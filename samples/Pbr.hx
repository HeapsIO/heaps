
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

class CubeMap extends hxsl.Shader {

	static var SRC = {

		var pixelColor : Vec4;
		var transformedNormal : Vec3;
		@param var texture : SamplerCube;
		@param var lod : Float;
		function fragment() {
			pixelColor.rgb *= textureCubeLod(texture,transformedNormal,lod).rgb;
		}

	}

	public function new(texture) {
		super();
		this.texture = texture;
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

	var shader : PbrShader;
	var material : PbrMaterialShader;

	var envMap : h3d.mat.Texture;
	var irrad : h3d.scene.pbr.Irradiance;

	override function init() {

		new h3d.scene.CameraController(5.5, s3d);


		font = hxd.res.DefaultFont.get();

		#if flash
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
		envMap.name = "envMap";
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

		irrad = new h3d.scene.pbr.Irradiance(envMap);
		irrad.compute();

		shader.envMap = envMap;
		shader.irrDiffuse = irrad.diffuse;
		shader.irrSpecular = irrad.specular;
		shader.irrLut = irrad.lut;
		shader.irrSpecularLevels = irrad.specLevels;

		var cubeShader = bg.material.mainPass.addShader(new CubeMap(envMap));

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

		var r = Math.sqrt(2);
		var cube = new h3d.prim.Cube(r,r,r);
		cube.unindex();
		cube.addNormals();
		cube.addUVs();
		cube.translate( -r * 0.5, -r * 0.5, -r * 0.5);
		var prims : Array<h3d.prim.Primitive> = [sp, cube];
		addChoice("Prim", ["Sphere","Cube"], function(i) sphere.primitive = prims[i], prims.indexOf(sphere.primitive));

		addChoice("EnvMap", ["Default", "IDiff", "ISpec"], function(i) cubeShader.texture = [envMap, irrad.diffuse, irrad.specular][i]);
		addSlider("EnvLod", 0, irrad.specLevels, function() return cubeShader.lod, function(v) cubeShader.lod = v);

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

	// ---------------------


	static function main() {
		#if hl
		hxd.Res.initLocal();
		#else
		hxd.Res.initEmbed();
		#end
		new Pbr();
	}

}
