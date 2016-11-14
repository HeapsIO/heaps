
class PbrShader extends hxsl.Shader {

	static var SRC = {

		@:import h3d.shader.BaseMesh;

		@param var exposure : Float;

		@param var lightPos : Vec3;
		@param var lightColor : Vec3;

		@const var specularMode : Bool;
		@param var metalness : Float;

		@param var roughness : Float;

		@param var cubeMap : SamplerCube;

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

				var diffuse = vec3(0, 0, 0); // TODO - generate Irradiance EnvMap from CubeMap
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

	override function init() {

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

		engine.debug = true;


		var cube = new h3d.mat.Texture(512, 512, [Cubic]);
		inline function set(face:Int, res:hxd.res.Image) {
			#if flash
			// all mipmap levels required
			var bmp = res.toBitmap();
			var level = 0;
			while( true ) {
				cube.uploadBitmap(bmp, level++, face);
				if( bmp.width == 1 ) break;
				var sub = new hxd.BitmapData(bmp.width >> 1, bmp.height >> 1);
				sub.drawScaled(0, 0, sub.width, sub.height, bmp, 0, 0, bmp.width, bmp.height);
				bmp.dispose();
				bmp = sub;
			}
			bmp.dispose();
			#else
			var pix = res.getPixels();
			cube.uploadPixels(pix, 0, face);
			#end
		}
		set(0, hxd.Res.front);
		set(1, hxd.Res.back);
		set(2, hxd.Res.right);
		set(3, hxd.Res.left);
		set(4, hxd.Res.top);
		set(5, hxd.Res.bottom);

		shader.cubeMap = cube;
		bg.material.mainPass.addShader(new h3d.shader.CubeMap(cube));

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


		s2d.addEventListener(onEvent);
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
