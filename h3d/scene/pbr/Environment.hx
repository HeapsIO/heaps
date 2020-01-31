package h3d.scene.pbr;

class IrradBase extends h3d.shader.ScreenShader {

	static var SRC = {

		@const var samplesBits : Int;

		function _reversebits( i : Int ) : Int {
			var r = (i << 16) | (i >>> 16);
			r = ((r & 0x00ff00ff) << 8) | ((r & 0xff00ff00) >>> 8);
			r = ((r & 0x0f0f0f0f) << 4) | ((r & 0xf0f0f0f0) >>> 4);
			r = ((r & 0x33333333) << 2) | ((r & 0xcccccccc) >>> 2);
			r = ((r & 0x55555555) << 1) | ((r & 0xaaaaaaaa) >>> 1);
			return r;
		}

		function hammersley( i : Int, max : Int ) : Vec2 {
			var ri = _reversebits(i) * 2.3283064365386963e-10;
			return vec2(float(i) / float(max), ri);
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
			return (tanX * ltan.x + tanY * ltan.y + n * ltan.z).normalize();
		}


	};

}


class IrradShader extends IrradBase {

	static var SRC = {

		@param var faceMatrix : Mat3;
		@param var envMap : SamplerCube;

		@const var isSpecular : Bool;
		@const var isSRGB : Bool;
		@param var roughness : Float;

		@param var cubeSize : Float;
		@param var cubeScaleFactor : Float;

		@param var threshold : Float;
		@param var scale : Float;

		function cosineWeightedSampling( p : Vec2, n : Vec3 ) : Vec3 {
			var sq = sqrt(1 - p.x);
			var alpha = 2 * PI * p.y;
			var ltan = vec3( sq * cos(alpha),  sq * sin(alpha), sqrt(p.x));

			var up = abs(n.z) < 0.999 ? vec3(0, 0, 1) : vec3(1, 0, 0);
			var tanX = normalize(cross(up, n));
			var tanY = normalize(cross(n, tanX));
			return (tanX * ltan.x + tanY * ltan.y + n * ltan.z).normalize();
		}

		function getNormal() : Vec3 {
			var d = input.uv * 2. - 1.;
			if( isSpecular ) {
				// WRAP edge fixup
				// https://seblagarde.wordpress.com/2012/06/10/amd-cubemapgen-for-physically-based-rendering/
				d += cubeScaleFactor * (d * d * d);
			}
			return (vec3(d,1.) * faceMatrix).normalize();
		}

		function gammaCorrect( color : Vec3 ) : Vec3 {
			return isSRGB ? color : color.pow(vec3(2.2));
		}

		function fragment() {
			var color = vec3(0.);
			var n = getNormal();
			var totalWeight = 1e-10;
			var numSamples = 1 << samplesBits;
			for( i in 0...numSamples ) {
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
					var envMapColor = envMap.get(l).rgb;
					envMapColor *= mix(1.0, scale, (max( max(envMapColor.r, max(envMapColor.g, envMapColor.b)) - threshold, 0) / max(0.001, (1.0 - threshold))));
					color += gammaCorrect(envMapColor) * amount;
					totalWeight += amount;
				}
			}
			// store the envMap in linear space (don't revert gamma correction)
			output.color = vec4(color / totalWeight, 1.);
		}

	}

}

class IrradLut extends IrradBase {

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
			for( i in 0...numSamples ) {
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
}

class IrradEquiProj extends h3d.shader.ScreenShader {

	static var SRC = {

		@param var texture : Sampler2D;
		@param var faceMatrix : Mat3;

		function getNormal() : Vec3 {
			var d = input.uv * 2. - 1.;
			return (vec3(d,1.) * faceMatrix).normalize();
		}

		function fragment() {
			var n = getNormal();
			var uv = vec2(atan(n.y, n.x), asin(-n.z));
    		uv *= vec2(0.1591, 0.3183);
    		uv += 0.5;
			pixelColor = texture.get(uv);
		}

	};

}

class Environment  {

	public var sampleBits : Int;
	public var diffSize : Int;
	public var specSize : Int;
	public var specLevels : Int;

	public var ignoredSpecLevels : Int = 1;

	public var source : h3d.mat.Texture;
	public var env : h3d.mat.Texture;
	public var lut : h3d.mat.Texture;
	public var diffuse : h3d.mat.Texture;
	public var specular : h3d.mat.Texture;

	public var power : Float = 1.;
	public var rot : Float = 0.;
	public var threshold : Float = 0.;
	public var scale : Float = 1.;

	/*
		Source can be cube map already prepared or a 2D equirectangular map that
		will be turned into a cube map.
	*/
	public function new( src : h3d.mat.Texture, ?diffSize = 64, ?specSize = 512, ?sampleBits = 12 ) {
		this.source = src;
		equiToCube();
		this.diffSize = diffSize;
		this.specSize = specSize;
		this.sampleBits = sampleBits;
	}


	function equiToCube() {
		if( source.flags.has(Loading) )
			throw "Source is not ready";
		if( source.flags.has(Cube) ) {
			this.env = source;
		} else {
			if( source.width != source.height * 2 )
				throw "Unrecognized environment map format";
			env = new h3d.mat.Texture(source.height, source.height, [Cube, Target]);
			var pass = new h3d.pass.ScreenFx(new IrradEquiProj());
			var engine = h3d.Engine.getCurrent();
			pass.shader.texture = source;
			for( i in 0...6 ) {
				engine.pushTarget(env,i);
				pass.shader.faceMatrix = getCubeMatrix(i);
				pass.render();
				engine.popTarget();
			}

			env.realloc = function() {
				equiToCube();
				compute();
			}
		}
	}

	public function dispose() {
		if( env != null ) env.dispose();
		if( lut != null ) lut.dispose();
		if( diffuse != null ) diffuse.dispose();
		if( specular != null ) specular.dispose();
	}

	function createTextures() {
		if( lut == null ) {
			lut = new h3d.mat.Texture(128, 128, [Target], RGBA32F);
			lut.setName("irradLut");
			lut.preventAutoDispose();
		}
		if( diffuse == null ) {
			diffuse = new h3d.mat.Texture(diffSize, diffSize, [Cube, Target], RGBA32F);
			diffuse.setName("irradDiffuse");
			diffuse.preventAutoDispose();
		}
		if( specular == null ) {
			specular = new h3d.mat.Texture(specSize, specSize, [Cube, Target, MipMapped, ManualMipMapGen], RGBA32F);
			specular.setName("irradSpecular");
			specular.mipMap = Linear;
			specular.preventAutoDispose();
		}
	}

	public function compute() {
		createTextures();
		computeIrradLut();
		computeIrradiance();
	}

	function getCubeMatrix( face : Int ) {
		return h3d.Matrix.L(switch( face ) {
			case 0: [0,0,-1,0,
					 0,-1,0,0,
					 1,0,0,0];
			case 1: [0,0,1,0,
					 0,-1,0,0,
					-1,0,0,0];
			case 2: [1,0,0,0,
					 0,0,1,0,
					 0,1,0,0];
			case 3: [1,0,0,0,
					 0,0,-1,0,
					 0,-1,0,0];
			case 4: [1,0,0,0,
					 0,-1,0,0,
					 0,0,1,0];
			default: [-1,0,0,0,
					   0,-1,0,0,
					   0,0,-1,0];
		});
	}

	function computeIrradLut() {
		var screen = new h3d.pass.ScreenFx(new IrradLut());
		screen.shader.samplesBits = sampleBits;

		var engine = h3d.Engine.getCurrent();
		engine.pushTarget(lut);
		screen.render();
		engine.popTarget();
		screen.dispose();
	}

	function getMipLevels() : Int {
		var mipLevels = 1;
		while( specular.width > 1 << (mipLevels - 1) )
			mipLevels++;
		return mipLevels;
	}

	function computeIrradiance() {

		var screen = new h3d.pass.ScreenFx(new IrradShader());
		screen.shader.samplesBits = sampleBits;
		screen.shader.envMap = env;
		screen.shader.isSRGB = env.isSRGB();
		screen.shader.threshold = threshold;
		screen.shader.scale = scale;

		var engine = h3d.Engine.getCurrent();

		for( i in 0...6 ) {
			screen.shader.faceMatrix = getCubeMatrix(i);
			engine.pushTarget(diffuse, i);
			screen.render();
			engine.popTarget();
		}

		screen.shader.isSpecular = true;

		var mipLevels = getMipLevels();
		specLevels = mipLevels - ignoredSpecLevels;

		for( i in 0...6 ) {
			screen.shader.faceMatrix = getCubeMatrix(i);
			for( j in 0... mipLevels ) {
				var size = specular.width >> j;
				screen.shader.cubeSize = size;
				screen.shader.cubeScaleFactor = size == 1 ? 0 : (size * size) / Math.pow(size - 1, 3);
				screen.shader.roughness = j / specLevels;
				engine.pushTarget(specular, i, j);
				screen.render();
				engine.popTarget();
			}
		}
	}

}