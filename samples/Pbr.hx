
class PbrShader extends hxsl.Shader {

	static var SRC = {

		@:import h3d.shader.BaseMesh;

		@param var exposure : Float;

		@param var lightPos : Vec3;
		@param var lightColor : Vec3;

		@const var specularMode : Bool;
		var metalness : Float;
		var roughness : Float;
		var occlusion : Float;
		var albedoColor : Vec3;
		var specularColor : Vec3;

		@param var defMetalness : Float;
		@param var defRoughness : Float;

		@param var envMap : SamplerCube;
		@param var irrDiffuse : SamplerCube;
		@param var irrSpecular : SamplerCube;
		@param var irrSpecularLevels : Float;
		@param var irrLut : Sampler2D;

		@const var directLighting : Bool;
		@const var indirectLighting : Bool;
		@const var specularLighting : Bool;

		var l : Vec3;
		var n : Vec3;
		var v : Vec3;
		var h : Vec3;

		function vertex() {
			albedoColor = pixelColor.rgb;
		}

		function __init__fragment() {
			metalness = defMetalness;
			roughness = defRoughness;
			occlusion = 1.;
			specularColor = vec3(metalness);
		}

		function calcG(v:Vec3) : Float {
			var k = (roughness + 1).pow(2) / 8;// (roughness * roughness) / 2;
			var NdV = n.dot(v);
			return NdV / (NdV * (1 - k) + k);
		}

		function calcLight( lightPos : Vec3 ) : Vec3 {

			var color = vec3(0.);
			var normal = transformedNormal.normalize();
			var view = (camera.position - transformedPosition).normalize();
			var lightDir = (lightPos - transformedPosition).normalize();

			if( specularMode ) {

				var diffuse = lightDir.dot(normal).max(0.);

				var specularPower = metalness * 40.;
				var r = reflect(-lightDir, normal).normalize();
				var specular = r.dot(view).max(0.).pow(specularPower);
				color = albedoColor * (diffuse + specular) * lightColor;

			} else {

				//if( metalness > 0.5 )
				//	specularColor = diffuseColor;

				l = lightDir;
				n = normal;
				v = view;
				h = (l + v).normalize();



				// diffuse BRDF
				var direct : Vec3;


				// ------------- DIRECT LIGHT -------------------------

				var F0 = metalness;
				var diffuse = albedoColor * n.dot(l).saturate() / PI;

				// General Cook-Torrance formula for microfacet BRDF
				// 		f(l,v) = D(h).F(v,h).G(l,v,h) / 4(n.l)(n.v)

				// formulas below from 2013 Siggraph "Real Shading in UE4"
				var alpha = roughness.pow(2);

				// D = normal distribution fonction
				// GGX (Trowbridge-Reitz) "Disney"
				var D = alpha.pow(2) / (PI * ( n.dot(h).pow(2) * (alpha.pow(2) - 1.) + 1).pow(2));

				// F = fresnel term
				// Schlick approx
				// pow 5 optimized with Spherical Gaussian
				// var F = F0 + (1 - F0) * pow(1 - v.dot(h).min(1.), 5.);
				var F = F0 + (1.01 - F0) * exp2( ( -5.55473 * v.dot(h) - 6.98316) * v.dot(h) );

				// G = geometric attenuation
				// Schlick (modified for UE4 with k=alpha/2)
				var G = calcG(l) * calcG(v);

				var specular = (D * F * G / (4 * n.dot(l) * n.dot(v))).max(0.);

				// custom falloff to prevent infinite when we have n.h ~= 0
				if( n.dot(l) < 0 ) specular *= (1 + n.dot(l) * 6).saturate();

				if( !specularLighting )
					specular = 0.;

				direct = (diffuse + specular) * lightColor;


				// ------------- INDIRECT LIGHT -------------------------

				var diffuse = irrDiffuse.get(normal).rgb.pow(vec3(2.2)) * albedoColor;

				var envSpec = textureCubeLod(irrSpecular, reflect(-v,n), roughness * irrSpecularLevels).rgb.pow(vec3(2.2));

				var envBRDF = irrLut.get(vec2(roughness, n.dot(v)));
				var specular = envSpec * (specularColor * envBRDF.x + envBRDF.y);

				if( !specularLighting )
					specular = vec3(0.);

				var indirect = diffuse * occlusion + specular;

				if( directLighting )
					color += direct;
				if( indirectLighting )
					color += indirect;
			}

			return color;
		}


		function fragment() {
			var color = calcLight(lightPos);

			if( !specularMode ) {
				// reinhard tonemapping
				color *= exp(exposure);
				color = color / (color + vec3(1.));

				// gamma correct
				color = color.pow(vec3(1 / 2.2));
			}

			pixelColor.rgb = color;
		}

	}

	public function new() {
		super();
		exposure = 0;
		specularMode = false;
		directLighting = true;
		indirectLighting = true;
		specularLighting = true;
		lightPos.set(30, 10, 40);
		lightColor.set(0.1, 0.1, 0.1);
	}

}

class AdjustShader extends hxsl.Shader {

	static var SRC = {
		@param var roughnessValue : Float;
		@param var metalnessValue : Float;
		var roughness : Float;
		var metalness : Float;
		function fragment() {
			roughness = roughnessValue;
			metalness = metalnessValue;
		}
	}

	public function new(rough, metal) {
		super();
		roughnessValue = rough;
		metalnessValue = metal;
	}

}

class PbrMaterialShader extends hxsl.Shader {

	static var SRC = {

		@input var input : { uv : Vec2 };
		@global var camera : { position : Vec3 };
		@global var global : { modelViewInverse : Mat4 };

		var output : { color : Vec4 };

		@param var albedoMap : Sampler2D;
		@param var roughnessMap : Sampler2D;
		@param var metalnessMap : Sampler2D;
		@param var normalMap : Sampler2D;
		@param var heightMap : Sampler2D;
		@param var occlusionMap : Sampler2D;

		@param var normalPower : Float;
		@param var parallaxScale : Float;
		@param var occlusionScale : Float;

		var roughness : Float;
		var metalness : Float;
		var occlusion : Float;
		var calculatedUV : Vec2;
		var albedoColor : Vec3;

		var transformedPosition : Vec3;
		var transformedNormal : Vec3;

		function vertex() {
			calculatedUV = input.uv;
		}

		function fragment() {


			var n = transformedNormal;
			var up = abs(n.z) < 0.999 ? vec3(0, 0, 1) : vec3(0, 1, 0);
			var tanX = normalize(cross(up, n));
			var tanY = normalize(cross(n, tanX));

			var uv = calculatedUV;
			var height = heightMap.get(calculatedUV).r;

			var viewWS = (camera.position - transformedPosition).normalize();
			var viewNS = vec3(viewWS.dot(tanX), viewWS.dot(tanY), viewWS.dot(n)).normalize();

			uv -= viewNS.xy * height * parallaxScale;

			occlusion = mix(1., occlusionScale * occlusionMap.get(uv).r, occlusionScale);
			albedoColor = albedoMap.get(uv).rgb.pow(vec3(2.2));
			roughness = roughnessMap.get(uv).r;
			metalness = metalnessMap.get(uv).r;

			var nf = unpackNormal(normalMap.get(uv));

			nf.xy *= normalPower;
			nf = nf.normalize();

			transformedNormal = (-nf.x * tanX - nf.y * tanY + nf.z * n).normalize();
		}
	}

}

class IrradBase extends h3d.shader.ScreenShader {

	static var SRC = {

		@const var samplesBits : Int;
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

		function importanceSampleGGX( roughness : Float, p : Vec2, n : Vec3 ) : Vec3 {
			var a = roughness * roughness;
			var phi = 2 * PI * p.x;
			var cosT = sqrt((1 - p.y) / (1 + (a * a - 1) * p.y)).min(1.);
			var sinT = sqrt(1 - cosT * cosT);
			var ltan = vec3(sinT * cos(phi), sinT * sin(phi), cosT);

			var up = abs(n.z) < 0.999 ? vec3(0, 0, 1) : vec3(1, 0, 0);
			var tanX = normalize(cross(up, n));
			var tanY = normalize(cross(n, tanX));
			return tanX * ltan.x + tanY * ltan.y + n * ltan.z;
		}


	};

}


class Irradiance extends IrradBase {

	static var SRC = {

		@const var face : Int;
		@param var envMap : SamplerCube;

		@const var isSpecular : Bool;
		@param var roughness : Float;

		@param var cubeSize : Float;
		@param var cubeScaleFactor : Float;

		function cosineWeightedSampling( p : Vec2, n : Vec3 ) : Vec3 {
			var sq = sqrt(1 - p.x);
			var alpha = 2 * PI * p.y;
			var ltan = vec3( sq * cos(alpha),  sq * sin(alpha), sqrt(p.x));

			var up = abs(n.z) < 0.999 ? vec3(0, 0, 1) : vec3(1, 0, 0);
			var tanX = normalize(cross(up, n));
			var tanY = normalize(cross(n, tanX));
			return tanX * ltan.x + tanY * ltan.y + n * ltan.z;
		}

		function getNormal() : Vec3 {
			var d = input.uv * 2. - 1.;
			if( isSpecular ) {
				// WRAP edge fixup
				// https://seblagarde.wordpress.com/2012/06/10/amd-cubemapgen-for-physically-based-rendering/
				d += cubeScaleFactor * (d * d * d);
			}
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
			var totalWeight = 1e-10;
			var numSamples = 1 << samplesBits;
			#if (js || flash) @:unroll #end
			for( i in 0...1 << samplesBits ) {
				var p = hammersley(i, numSamples);
				var l : Vec3;
				if( isSpecular ) {
					var h = importanceSampleGGX(roughness, p, n);
					var v = n; // approx
					l = reflect(-v, h).normalize();
				} else {
					l = cosineWeightedSampling(p, n);
				}
				var amount = n.dot(l).saturate();
				if( amount > 0 ) {
					color += envMap.get(l).rgb.pow(vec3(2.2)) * amount;
					totalWeight += amount;
				}
			}
			output.color = vec4((color / totalWeight).pow(vec3(1/2.2)), 1.);
		}

	}

}

class IrradianceLut extends IrradBase {

	static var SRC = {

		function GGX( NdotV : Float, roughness : Float ) : Float {
			var k = (roughness * roughness) * 0.5; // only in IBL, use (r + 1)² / 8 for lighting
			return NdotV / (NdotV * (1.0 - k) + k);
		}

		function G_Smith(roughness : Float, nDotV : Float, nDotL : Float) : Float {
			return GGX(nDotL, roughness) * GGX(nDotV, roughness);
		}

		function fragment() {
			var roughness = input.uv.x;
			var NoV = input.uv.y;
			var v = vec3( sqrt( 1.0 - NoV * NoV ), 0., NoV );
			var n = vec3(0, 0, 1.);
			var numSamples = 1 << samplesBits;
			var a = 0., b = 0.;
			#if (js || flash) @:unroll #end
			for( i in 0...1 << samplesBits ) {
				var xi = hammersley(i, numSamples);
				var h = importanceSampleGGX( roughness, xi, n );
				var l = reflect(-v, h);
				var NoL = saturate( dot(n, l) );
				var NoH = saturate( dot(n, h) );
				var VoH = saturate( dot(v, h) );
				if( NoL > 0 ) {
					var g = G_Smith( roughness, NoV, NoL );
					var gvis = g * VoH / (NoH * NoV);
					var fresnel = pow( 1 - VoH, 5. );
					a += (1 - fresnel) * gvis;
					b += fresnel * gvis;
				}
			}
			output.color = vec4(a / numSamples, b / numSamples, 0, 1);
		}
	}

	public function new() {
		super();
		samplesBits = 10;
	}

}

class Pbr extends hxd.App {

	var fui : h2d.Flow;
	var font : h2d.Font;
	var hue : Float;
	var saturation : Float;
	var brightness : Float;
	var color : h2d.Bitmap;
	var sphere : h3d.scene.Mesh;
	var grid : h3d.scene.Object;

	var sampleBits : Int;

	var shader : PbrShader;
	var material : PbrMaterialShader;

	var envMap : h3d.mat.Texture;
	var irradDiffuse : h3d.mat.Texture;
	var irradSpecular : h3d.mat.Texture;

	override function init() {

		new h3d.scene.CameraController(5.5, s3d);


		font = hxd.res.DefaultFont.get();

		#if (js || flash)
		new h2d.Text(font, s2d).text = "Not supported on this platform (requires render to mipmap target and fragment textureCubeLod support)";
		return;
		#end

		shader = new PbrShader();

		var sp = new h3d.prim.Sphere(1, 128, 128);
		sp.addNormals();
		sp.addUVs();

		var bg = new h3d.scene.Mesh(sp, s3d);
		bg.scale(10);
		bg.material.mainPass.culling = Front;

		fui = new h2d.Flow(s2d);
		fui.y = 5;
		fui.verticalSpacing = 5;
		fui.isVertical = true;

		envMap = new h3d.mat.Texture(512, 512, [Cube]);
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

		var axis = new h3d.scene.Graphics(s3d);
		axis.lineStyle(2, 0xFF0000);
		axis.lineTo(2, 0, 0);
		axis.lineStyle(2, 0x00FF00);
		axis.moveTo(0, 0, 0);
		axis.lineTo(0, 2, 0);
		axis.lineStyle(2, 0x0000FF);
		axis.moveTo(0, 0, 0);
		axis.lineTo(0, 0, 2);

		axis.lineStyle(2, 0xFFFFFF, 0.5);
		axis.moveTo(shader.lightPos.x, shader.lightPos.y, shader.lightPos.z);
		axis.lineTo(shader.lightPos.x * 0.1, shader.lightPos.y * 0.1, shader.lightPos.z * 0.1);
		axis.material.blendMode = Alpha;
		axis.visible = false;

		var size, ssize;
		#if (js || flash)
		sampleBits = 5;
		size = 16;
		ssize = 16;
		#else
		size = 64;
		ssize = 256;
		sampleBits = 10;
		#end

		computeIrradLut();

		irradDiffuse = new h3d.mat.Texture(size, size, [Cube]);
		irradSpecular = new h3d.mat.Texture(ssize, ssize, [Cube, MipMapped]);
		irradSpecular.mipMap = Linear;
		computeIrradiance();

		shader.envMap = envMap;
		shader.irrDiffuse = irradDiffuse;
		shader.irrSpecular = irradSpecular;

		var cubeShader = bg.material.mainPass.addShader(new h3d.shader.CubeMap(envMap));

		shader.defMetalness = 0.2;
		shader.defRoughness = 0.5;
		shader.exposure = 2.;
		hue = 0.2;
		saturation = 0.2;
		brightness = -1;

		function addSphere(x,y) {
			var sphere = new h3d.scene.Mesh(sp, s3d);
			sphere.x = x;
			sphere.y = y;
			sphere.material.mainPass.addShader(shader);
			return sphere;
		}

		sphere = addSphere(0, 0);
		material = new PbrMaterialShader();
		material.normalPower = 1;
		material.parallaxScale = 1 / 64;
		material.occlusionScale = 1;

		//loadMaterial("mat/harshbricks-");

		grid = new h3d.scene.Object(s3d);
		var max = 5;
		for( x in 0...max )
			for( y in 0...max ) {
				var s = addSphere(x - (max - 1) * 0.5, y - (max - 1) * 0.5);
				grid.addChild(s);
				s.scale(0.4);
				s.material.mainPass.addShader(new AdjustShader( Math.pow(x / (max - 1), 1), Math.pow(y / (max - 1), 2)));
			}
		grid.visible = false;

		addCheck("PBR", function() return !shader.specularMode, function(b) shader.specularMode = !b);

		// camera
		addSeparator();
		addSlider("Exposure", -3, 3, function() return shader.exposure, function(v) shader.exposure = v);
		addSlider("Light", 0, 10, function() return shader.lightColor.x, function(v) shader.lightColor.set(v, v, v));

		// material color
		color = new h2d.Bitmap(h2d.Tile.fromColor(0xFFFFFF, 30, 30), fui);
		fui.getProperties(color).paddingLeft = 150;
		addSlider("Hue", 0, Math.PI*2, function() return hue, function(v) hue = v);
		addSlider("Saturation", 0, 1, function() return saturation, function(v) saturation = v);
		addSlider("Brightness", -1, 1, function() return brightness, function(v) brightness = v);

		addSlider("Metalness", 0.02, 0.99, function() return shader.defMetalness, function(v) shader.defMetalness = v);
		addSlider("Roughness", 0, 1, function() return shader.defRoughness, function(v) shader.defRoughness = v);

		// material properties
		addSeparator();
		addSlider("NormalPower", 0, 2, function() return material.normalPower, function(v) material.normalPower = v);
		addSlider("Parallax", 0, 1, function() return material.parallaxScale * 64, function(v) material.parallaxScale = v / 64);
		addSlider("Occlusion", 0, 1, function() return material.occlusionScale, function(v) material.occlusionScale = v);

		// debug
		addSeparator();
		addCheck("Direct", function() return shader.directLighting, function(b) shader.directLighting = b);
		addCheck("Indirect", function() return shader.indirectLighting, function(b) shader.indirectLighting = b);
		addCheck("Specular", function() return shader.specularLighting, function(b) shader.specularLighting = b);
		addCheck("Axis", function() return axis.visible, function(b) axis.visible = b);
		addCheck("Grid", function() return grid.visible, function(b) {
			grid.visible = !grid.visible;
			sphere.visible = !sphere.visible;
		});

		addChoice("EnvMap", ["Default", "IDiff", "ISpec"], function(i) cubeShader.texture = [envMap, irradDiffuse, irradSpecular][i]);
		var r = Math.sqrt(2);
		var cube = new h3d.prim.Cube(r,r,r);
		cube.unindex();
		cube.addNormals();
		cube.addUVs();
		cube.translate( -r * 0.5, -r * 0.5, -r * 0.5);
		var prims : Array<h3d.prim.Primitive> = [sp, cube];
		addChoice("Prim", ["Sphere","Cube"], function(i) sphere.primitive = prims[i], prims.indexOf(sphere.primitive));
	}

	function addSeparator() {
		fui.getProperties(fui.getChildAt(fui.numChildren - 1)).paddingBottom += 20;
	}

	function loadMaterial( filePath : String ) {
		var mat = material;
		function load(name) {
			var t = hxd.Res.load(filePath + name+".png").toTexture();
			t.wrap = Repeat;
			return t;
		}
		sphere.material.mainPass.removeShader(mat);
		mat.albedoMap = load("albedo");
		mat.normalMap = load("normal");
		mat.roughnessMap = load("roughness");
		mat.metalnessMap = load("metalness");
		mat.heightMap = load("height");
		mat.occlusionMap = load("ao");
		sphere.material.mainPass.addShader(mat);
	}

	function computeIrradLut() {
		var irradLut = new h3d.mat.Texture(128, 128, #if js RGBA32F #else RGBA16F #end);
		var screen = new h3d.pass.ScreenFx(new IrradianceLut());
		screen.shader.samplesBits = sampleBits;
		#if (js || flash)
		var nsamples = 1 << sampleBits;
		screen.shader.SamplesCount = nsamples;
		screen.shader.hammerTbl = [for( i in 0...nsamples ) hammersley(i, nsamples)];
		#end

		engine.driver.setRenderTarget(irradLut);
		screen.render();
		engine.driver.setRenderTarget(null);
		shader.irrLut = irradLut;
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

		shader.irrSpecularLevels = mipLevels - 4;

		for( i in 0...6 ) {
			screen.shader.face = i;
			for( j in 0...mipLevels ) {
				var size = irradSpecular.width >> j;
				screen.shader.cubeSize = size;
				screen.shader.cubeScaleFactor = size == 1 ? 0 : (size * size) / Math.pow(size - 1, 3);
				screen.shader.roughness = j / shader.irrSpecularLevels;
				engine.driver.setRenderTarget(irradSpecular, i, j);
				screen.render();
			}
		}
		engine.driver.setRenderTarget(null);
	}

	function addCheck( text, get : Void -> Bool, set : Bool -> Void ) {
		var i = new h2d.Interactive(110, font.lineHeight, fui);
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
		var i = new h2d.Interactive(110, font.lineHeight, fui);
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

		if( grid == null ) return;

		var color = new h3d.Vector(1, 0, 0);
		var m = new h3d.Matrix();
		m.identity();
		m.colorSaturation(saturation - 1);
		m.colorHue(hue);
		m.colorLightness(brightness);
		color.transform3x4(m);
		color.setColor(color.toColor()); // saturate

		this.color.color.load(color);
		this.sphere.material.color.load(color);
		for( s in grid )
			s.toMesh().material.color.load(color);

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
				var cosT = Math.min(Math.sqrt((1 - h.y) / (1 + (a * a - 1) * h.y)), 1.);
				var sinT = Math.sqrt(1 - cosT * cosT);
				var ltan = new h3d.Vector(sinT * Math.cos(phi), sinT * Math.sin(phi), cosT);

				var h = new h3d.Vector(
					tanX.x * ltan.x + tanY.x * ltan.y + n.x * ltan.z,
					tanX.y * ltan.x + tanY.y * ltan.y + n.y * ltan.z,
					tanX.z * ltan.x + tanY.z * ltan.y + n.z * ltan.z
				);

				var v = n; // approx

				var hDotV = v.dot3(h);
				// reflect(-v,h)

				l.x = 2 * hDotV * h.x - v.x;
				l.y = 2 * hDotV * h.y - v.y;
				l.z = 2 * hDotV * h.z - v.z;

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
		#if hl
		hxd.Res.initLocal();
		@:privateAccess {
			hxd.System.windowWidth = 1280;
			hxd.System.windowHeight = 800;
		}
		#else
		hxd.Res.initEmbed();
		#end
		new Pbr();
	}

}
