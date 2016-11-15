
class PbrShader extends hxsl.Shader {

	static var SRC = {

		@:import h3d.shader.BaseMesh;

		@param var exposure : Float;

		@param var lightPos : Vec3;
		@param var lightColor : Vec3;

		@const var specularMode : Bool;
		@param var metalness : Float;

		@param var roughness : Float;

		@param var envMap : SamplerCube;
		@param var irrDiffuse : SamplerCube;
		@param var irrSpecular : SamplerCube;

		var l : Vec3;
		var n : Vec3;
		var v : Vec3;
		var h : Vec3;

		function calcG(v:Vec3) : Float {

			// UE4 uses   k = (R + 1)² / 8  "disney hotness" for analytic light sources

			var k = (roughness * roughness) / 2;
			return n.dot(v) / (n.dot(v) * (1 - k) + k);
		}

		function fragment() {

			var color : Vec3;

			var diffuseColor = pixelColor.rgb;
			var lightDir = (lightPos - transformedPosition).normalize();
			var normal = transformedNormal.normalize();
			var view = (camera.position - transformedPosition).normalize();


			var lambert = lightDir.dot(normal).max(0.);

			if( specularMode ) {

				var specularPower = metalness * 40.;
				var r = reflect(-lightDir, normal).normalize();
				var specValue = r.dot(view).max(0.).pow(specularPower);
				color = diffuseColor * (lambert + specValue) * lightColor;

			} else {

				l = lightDir;
				n = normal;
				v = (camera.position - transformedPosition).normalize();
				h = (l + v).normalize();



				// diffuse BRDF
				var direct : Vec3;
				var F = 0.;

				#if !flash
				if( n.dot(l) < 0 ) {
					direct = vec3(0.);
				} else
				#end
				{

					// ------------- DIRECT LIGHT -------------------------

					var F0 = metalness;
					var diffuse = diffuseColor * n.dot(l) / PI;

					// General Cook-Torrance formula for microfacet BRDF
					// 		f(l,v) = D(h).F(v,h).G(l,v,h) / 4(n.l)(n.v)

					// formulas below from 2013 Siggraph "Real Shading in UE4"
					var alpha = roughness.pow(2);

					// D = normal distribution fonction
					// GGX (Trowbridge-Reitz) "Disney"
					var D = alpha.pow(2) / (PI * ( n.dot(h).pow(2) * (alpha.pow(2) - 1.) + 1).pow(2));

					// F = fresnel term

					// Schlick approx
					// var F = F0 + (1 - F0) * pow(1 - v.dot(h), 5.);
					// pow 5 optimized with Spherical Gaussian
					F = F0 + (1 - F0) * (2.).pow( ( -5.55473 * v.dot(h) - 6.98316) * v.dot(h) );

					// G = geometric attenuation
					// Schlick (modified for UE4 with k=alpha/2)
					var G = calcG(l) * calcG(v);

					var specular = D * F * G / (4 * n.dot(l) * n.dot(v));

					direct = (diffuse + specular) * lightColor;


				}


				// ------------- INDIRECT LIGHT -------------------------

				var diffuse = irrDiffuse.get(normal).rgb.pow(vec3(2.2)) * diffuseColor;
				var specular = vec3(0, 0, 0); // TODO - generate PMREM from CubeMap
				var indirect = diffuse + specular;

				color = direct + indirect;

				// reinhard tonemapping
				color *= exp(exposure);
				color = color / (color + vec3(1.));

				// gamma correct
				color = color.pow(vec3(1 / 2.2));

			}

			#if flash
			color *= float(n.dot(l) > 0.);
			#end

			pixelColor.rgb = color;
		}

	}

	public function new() {
		super();
		exposure = 0;
		specularMode = false;
		lightPos.set(5, 15, 20);
		lightColor.set(1, 1, 1);
	}

}

class Irradiance extends h3d.shader.ScreenShader {

	static var SRC = {

		@const var face : Int;
		@const var samplesBits : Int;
		@param var envMap : SamplerCube;

		@const var isSpecular : Bool;
		@param var roughness : Float;

		#if (js || flash)
		@const var SamplesCount : Int;
		@param var hammerTbl : Array<Vec4,SamplesCount>;
		#end

		function _reversebits( i : Int ) : Int {
			var r = (i << 16) | (i >>> 16);
			r = ((r & 0x00ff00ff) << 8) | ((r & 0xff00ff00) >>> 8);
			r = ((r & 0x0f0f0f0f) << 4) | ((r & 0xf0f0f0f0) >>> 4);
			r = ((r & 0x33333333) << 2) | ((r & 0xcccccccc) >>> 2);
			r = ((r & 0x55555555) << 1) | ((r & 0xaaaaaaaa) >>> 1);
			return r;
		}

		function hammersley( i : Int, max : Int ) : Vec2 {
			#if (js || flash)
			return hammerTbl[i].xy;
			#else
			var ri = _reversebits(i) * 2.3283064365386963e-10;
			return vec2(float(i) / float(max), ri);
			#end
		}

		function cosineWeightedSampling( p : Vec2 ) : Vec3 {
			var sq = sqrt(1 - p.x);
			var alpha = 2 * PI * p.y;
			return vec3( sq * cos(alpha),  sq * sin(alpha), sqrt(p.x));
		}

		function getNormal() : Vec3 {
			var d = input.uv * 2. - 1.;
			var n : Vec3;
			switch( face ) {
			case 0: n = vec3(1, d.y, -d.x);
			case 1: n = vec3(-1, d.y, d.x);
			case 2: n = vec3(d.x, 1, -d.y);
			case 3: n = vec3(d.x, -1, d.y);
			case 4: n = vec3(d.x, d.y, 1);
			default: n = vec3(-d.x, d.y,-1);
			}
			return n.normalize();
		}

		function fragment() {
			var color = vec3(0.);
			var n = getNormal();
			var up = abs(n.z) < 0.999 ? vec3(0, 0, 1) : vec3(1, 0, 0);
			var tanX = normalize(cross(up, n));
			var tanY = normalize(cross(n, tanX));
			var totalWeight = 1e-10;
			var numSamples = 1 << samplesBits;
			for( i in 0...1 << samplesBits ) {
				var p = hammersley(i, numSamples);
				var l : Vec3;
				if( isSpecular ) {
					// importance sampling GGX BRDF
					var a = roughness * roughness;
					var phi = 2 * PI * p.x;
					var cosT = sqrt((1 - p.y) / (1 + (a * a - 1) * p.y));
					var sinT = sqrt(1 - cosT * cosT);
					var ltan = vec3(sinT * cos(phi), sinT * sin(phi), cosT);
					var h = tanX * ltan.x + tanY * ltan.y + n * ltan.z;
					var v = n; // approx
					l = -reflect(v, h);
				} else {
					var ltan = cosineWeightedSampling(p);
					l = tanX * ltan.x + tanY * ltan.y + n * ltan.z;
				}
				var amount = n.dot(l);
				if( amount > 0 ) {
					color += envMap.get(l).rgb.pow(vec3(2.2)) * amount;
					totalWeight += amount;
				}
			}
			output.color = vec4((color / totalWeight).pow(vec3(1/2.2)), 1.);
		}

	}

}


class Pbr extends hxd.App {

	var fui : h2d.Flow;
	var cameraRot = Math.PI / 4;
	var cameraDist = 5.5;
	var font : h2d.Font;
	var hue : Float;
	var saturation : Float;
	var brightness : Float;
	var color : h2d.Bitmap;
	var sphere : h3d.scene.Mesh;

	var sampleBits : Int;

	var envMap : h3d.mat.Texture;
	var irradDiffuse : h3d.mat.Texture;
	var irradSpecular : h3d.mat.Texture;

	override function init() {

		#if flash
		engine.debug = true;
		#end

		//displaySampling(256, new h3d.Vector(1, 0., 0.), 0.5);

		font = hxd.res.DefaultFont.get();

		var sp = new h3d.prim.Sphere(1, 128, 128);
		sp.addNormals();
		sp.addUVs();
		sphere = new h3d.scene.Mesh(sp, s3d);
		var shader = sphere.material.mainPass.addShader(new PbrShader());

		var bg = new h3d.scene.Mesh(sp, s3d);
		bg.scale(10);
		bg.material.mainPass.culling = Front;

		fui = new h2d.Flow(s2d);
		fui.y = 5;
		fui.verticalSpacing = 5;
		fui.isVertical = true;

		var g = new h3d.scene.Graphics(s3d);
		g.lineStyle(1, 0xFF0000);
		g.moveTo(0, 0, 0);
		g.lineTo(2, 0, 0);
		g.lineStyle(1, 0x00FF00);
		g.moveTo(0, 0, 0);
		g.lineTo(0, 2, 0);
		g.lineStyle(1, 0x0000FF);
		g.moveTo(0, 0, 0);
		g.lineTo(0, 0, 2);
		g.lineStyle();

		envMap = new h3d.mat.Texture(512, 512, [Cubic]);
		inline function set(face:Int, res:hxd.res.Image) {
			#if flash
			// all mipmap levels required
			var bmp = res.toBitmap();
			var level = 0;
			while( true ) {
				envMap.uploadBitmap(bmp, level++, face);
				if( bmp.width == 1 ) break;
				var sub = new hxd.BitmapData(bmp.width >> 1, bmp.height >> 1);
				sub.drawScaled(0, 0, sub.width, sub.height, bmp, 0, 0, bmp.width, bmp.height);
				bmp.dispose();
				bmp = sub;
			}
			bmp.dispose();
			#else
			var pix = res.getPixels();
			envMap.uploadPixels(pix, 0, face);
			#end
		}
		set(0, hxd.Res.front);
		set(1, hxd.Res.back);
		set(2, hxd.Res.right);
		set(3, hxd.Res.left);
		set(4, hxd.Res.top);
		set(5, hxd.Res.bottom);


		var size = 64;
		#if (js || flash)
		sampleBits = 5;
		size = 16;
		#else
		sampleBits = 10;
		#end

		irradDiffuse = new h3d.mat.Texture(size, size, [Cubic]);
		irradSpecular = new h3d.mat.Texture(size, size, [Cubic, MipMapped]);
		computeIrradiance();

		shader.envMap = envMap;
		shader.irrDiffuse = irradDiffuse;
		shader.irrSpecular = irradSpecular;

		var cubeShader = bg.material.mainPass.addShader(new h3d.shader.CubeMap(envMap));

		shader.metalness = 0.2;
		shader.roughness = 0.3;
		hue = 0.2;
		saturation = 0.2;
		brightness = 0.2;

		addCheck("PBR", function() return !shader.specularMode, function(b) shader.specularMode = !b);
		addSlider("Exposure", -3, 3, function() return shader.exposure, function(v) shader.exposure = v);
		addSlider("Metalness", 0, 1, function() return shader.metalness, function(v) shader.metalness = v);
		addSlider("Roughness", 0, 1, function() return shader.roughness, function(v) shader.roughness = v);

		color = new h2d.Bitmap(h2d.Tile.fromColor(0xFFFFFF, 30, 30), fui);
		fui.getProperties(color).paddingLeft = 50;

		addSlider("Hue", 0, Math.PI, function() return hue, function(v) hue = v);
		addSlider("Saturation", 0, 1, function() return saturation, function(v) saturation = v);
		addSlider("Brightness", 0, 1, function() return brightness, function(v) brightness = v);
		addChoice("Env", ["Default", "IDiff", "ISpec"], function(i) cubeShader.texture = [envMap, irradDiffuse, irradSpecular][i]);

		s2d.addEventListener(onEvent);
	}

	function computeIrradiance() {
		var screen = new h3d.pass.ScreenFx(new Irradiance());
		screen.shader.samplesBits = sampleBits;
		screen.shader.envMap = envMap;

		#if (js || flash)
		var nsamples = 1 << sampleBits;
		screen.shader.SamplesCount = nsamples;
		screen.shader.hammerTbl = [for( i in 0...nsamples ) hammersley(i, nsamples)];
		#end

		for( i in 0...6 ) {
			screen.shader.face = i;
			engine.driver.setRenderTarget(irradDiffuse, i);
			screen.render();
		}

		screen.shader.isSpecular = true;

		var mipLevels = 1;
		while( irradSpecular.width > 1 << (mipLevels - 1) )
			mipLevels++;

		for( i in 0...6 ) {
			screen.shader.face = i;
			for( j in 0...mipLevels ) {
				screen.shader.roughness = j / mipLevels;
				engine.driver.setRenderTarget(irradSpecular, i, j);
				screen.render();
			}
		}
		engine.driver.setRenderTarget(null);
	}

	function onEvent(e:hxd.Event) {
		switch( e.kind ) {
		case EPush:
			var px = e.relX;
			s2d.startDrag(function(e2) {
				switch( e2.kind ) {
				case EMove:
					var dx = e2.relX - px;
					px += dx;
					cameraRot += dx * 0.01;
				case ERelease:
					s2d.stopDrag();
				default:
				}
			});
		case EWheel:
			cameraDist *= Math.pow(1.1, e.wheelDelta);
		default:
		}
	}

	function addCheck( text, get : Void -> Bool, set : Bool -> Void ) {


		var i = new h2d.Interactive(80, font.lineHeight, fui);
		i.backgroundColor = 0xFF808080;

		fui.getProperties(i).paddingLeft = 20;

		var t = new h2d.Text(font, i);
		t.maxWidth = i.width;
		t.text = text+":"+(get()?"ON":"OFF");
		t.textAlign = Center;

		i.onClick = function(_) {
			var v = !get();
			set(v);
			t.text = text + ":" + (v?"ON":"OFF");
		};
		i.onOver = function(_) {
			t.textColor = 0xFFFFFF;
		};
		i.onOut = function(_) {
			t.textColor = 0xEEEEEE;
		};
		i.onOut(null);
	}

	function addChoice( text, choices, callb, value = 0 ) {
		var i = new h2d.Interactive(80, font.lineHeight, fui);
		i.backgroundColor = 0xFF808080;
		fui.getProperties(i).paddingLeft = 20;

		var t = new h2d.Text(font, i);
		t.maxWidth = i.width;
		t.text = text+":"+choices[value];
		t.textAlign = Center;

		i.onClick = function(_) {
			value++;
			value %= choices.length;
			callb(value);
			t.text = text + ":" + choices[value];
		};
		i.onOver = function(_) {
			t.textColor = 0xFFFFFF;
		};
		i.onOut = function(_) {
			t.textColor = 0xEEEEEE;
		};
		i.onOut(null);
	}

	function addSlider( text, min : Float, max : Float, get : Void -> Float, set : Float -> Void ) {
		var f = new h2d.Flow(fui);

		f.horizontalSpacing = 5;

		var tf = new h2d.Text(font, f);
		tf.text = text;
		tf.maxWidth = 100;
		tf.textAlign = Right;

		var sli = new h2d.Slider(100, 10, f);
		sli.minValue = min;
		sli.maxValue = max;
		sli.value = get();

		var tf = new h2d.TextInput(font, f);
		tf.text = "" + hxd.Math.fmt(sli.value);
		sli.onChange = function() {
			set(sli.value);
			tf.text = "" + hxd.Math.fmt(sli.value);
			f.needReflow = true;
		};
		tf.onChange = function() {
			var v = Std.parseFloat(tf.text);
			if( Math.isNaN(v) ) return;
			sli.value = v;
			set(v);
		};
	}

	override function update(dt:Float) {
		s3d.camera.pos.set(Math.cos(cameraRot) * cameraDist, Math.sin(cameraRot) * cameraDist, cameraDist * 2 / 3);

		var color = new h3d.Vector(1, 0, 0);
		var m = new h3d.Matrix();
		m.identity();
		m.colorHue(hue);
		m.colorSaturation(saturation);
		m.colorBrightness(brightness);
		color.transform3x4(m);

		this.color.color.load(color);
		this.sphere.material.color.load(color);

	}


	// ----- DEBUG


	function _reversebits( i : Int ) : Int {
		var r = (i << 16) | (i >>> 16);
		r = ((r & 0x00ff00ff) << 8) | ((r & 0xff00ff00) >>> 8);
		r = ((r & 0x0f0f0f0f) << 4) | ((r & 0xf0f0f0f0) >>> 4);
		r = ((r & 0x33333333) << 2) | ((r & 0xcccccccc) >>> 2);
		r = ((r & 0x55555555) << 1) | ((r & 0xaaaaaaaa) >>> 1);
		return r;
	}

	function hammersley( i : Int, max : Int ) : h3d.Vector {
		var ri = _reversebits(i) * 2.3283064365386963e-10;
		return new h3d.Vector(i / max, ri);
	}

	function cosineWeightedSampling( p : h3d.Vector ) : h3d.Vector {
		var sq = Math.sqrt(1 - p.x);
		var alpha = 2 * Math.PI * p.y;
		return new h3d.Vector( sq * Math.cos(alpha),  sq * Math.sin(alpha), Math.sqrt(p.x));
	}

	function displaySampling( max : Int, n : h3d.Vector, ?roughness : Float ) {
		n.normalize();
		var up = n.z < 0.999 ? new h3d.Vector(0, 0, 1) : new h3d.Vector(1, 0, 0);
		var tanX = up.cross(n);
		tanX.normalize();
		var tanY = n.cross(tanX);
		tanY.normalize();

		var sp = new h3d.prim.Sphere(0.01, 4, 4);
		for( i in 0...max ) {
			var h = hammersley(i, max);

			var l = new h3d.Vector();
			if( roughness != null ) {

				var a = roughness * roughness;
				var phi = 2 * Math.PI * h.x;
				var cosT = Math.sqrt((1 - h.y) / (1 + (a * a - 1) * h.y));
				var sinT = Math.sqrt(1 - cosT * cosT);
				var ltan = new h3d.Vector(sinT * Math.cos(phi), sinT * Math.sin(phi), cosT);

				var hx = tanX.x * ltan.x + tanY.x * ltan.y + n.x * ltan.z;
				var hy = tanX.y * ltan.x + tanY.y * ltan.y + n.y * ltan.z;
				var hz = tanX.z * ltan.x + tanY.z * ltan.y + n.z * ltan.z;

				var v = n; // approx

				var hDotV = v.dot3(new h3d.Vector(hx, hy, hz));
				// -reflect(v,h)
				l.x = v.x - 2 * hDotV * h.x;
				l.y = v.y - 2 * hDotV * h.y;
				l.z = v.z - 2 * hDotV * h.z;

			} else {

				var c = cosineWeightedSampling(h);
				l.x = tanX.x * c.x + tanY.x * c.y + n.x * c.z;
				l.y = tanX.y * c.x + tanY.y * c.y + n.y * c.z;
				l.z = tanX.z * c.x + tanY.z * c.y + n.z * c.z;

			}

			l.normalize();

			var s = new h3d.scene.Mesh(sp, s3d);
			s.x = l.x;
			s.y = l.y;
			s.z = l.z;
		}
	}

	// ---------------------


	static function main() {
		hxd.Res.initEmbed();
		#if hl
		@:privateAccess {
			hxd.System.windowWidth = 1280;
			hxd.System.windowHeight = 800;
		}
		#end
		new Pbr();
	}

}
