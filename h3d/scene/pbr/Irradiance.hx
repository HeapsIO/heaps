package h3d.scene.pbr;

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


class IrradShader extends IrradBase {

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
			#if hldx
			d.y *= -1;
			#end
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

class Irradiance  {

	public var sampleBits : Int;
	public var diffSize : Int;
	public var specSize : Int;
	public var specLevels : Int;

	public var ignoredSpecLevels : Int = 5;

	public var envMap : h3d.mat.Texture;
	public var lut : h3d.mat.Texture;
	public var diffuse : h3d.mat.Texture;
	public var specular : h3d.mat.Texture;

	public var power : Float = 1.;

	public function new(envMap) {
		this.envMap = envMap;
		#if (js || flash)
		sampleBits = 5;
		diffSize = 16;
		specSize = 16;
		#else
		diffSize = 64;
		specSize = 256;
		sampleBits = 10;
		#end
	}


	public function compute() {

		lut = new h3d.mat.Texture(128, 128, [Target], #if js RGBA32F #else RGBA16F #end);
		lut.setName("irradLut");
		diffuse = new h3d.mat.Texture(diffSize, diffSize, [Cube, Target]);
		diffuse.setName("irradDiffuse");
		specular = new h3d.mat.Texture(specSize, specSize, [Cube, Target, MipMapped, ManualMipMapGen]);
		specular.setName("irradSpecular");
		specular.mipMap = Linear;

		computeIrradLut();
		computeIrradiance();
	}

	function computeIrradLut() {
		var screen = new h3d.pass.ScreenFx(new IrradLut());
		screen.shader.samplesBits = sampleBits;
		#if (js || flash)
		var nsamples = 1 << sampleBits;
		screen.shader.SamplesCount = nsamples;
		screen.shader.hammerTbl = [for( i in 0...nsamples ) hammersley(i, nsamples)];
		#end

		var engine = h3d.Engine.getCurrent();
		engine.driver.setRenderTarget(lut);
		screen.render();
		engine.driver.setRenderTarget(null);
		screen.dispose();
	}

	function computeIrradiance() {

		var screen = new h3d.pass.ScreenFx(new IrradShader());
		screen.shader.samplesBits = sampleBits;
		screen.shader.envMap = envMap;

		#if (js || flash)
		var nsamples = 1 << sampleBits;
		screen.shader.SamplesCount = nsamples;
		screen.shader.hammerTbl = [for( i in 0...nsamples ) hammersley(i, nsamples)];
		#end

		var engine = h3d.Engine.getCurrent();

		for( i in 0...6 ) {
			screen.shader.face = i;
			engine.driver.setRenderTarget(diffuse, i);
			screen.render();
		}

		screen.shader.isSpecular = true;

		var mipLevels = 1;
		while( specular.width > 1 << (mipLevels - 1) )
			mipLevels++;

		specLevels = mipLevels - ignoredSpecLevels;

		for( i in 0...6 ) {
			screen.shader.face = i;
			for( j in 0...mipLevels ) {
				var size = specular.width >> j;
				screen.shader.cubeSize = size;
				screen.shader.cubeScaleFactor = size == 1 ? 0 : (size * size) / Math.pow(size - 1, 3);
				screen.shader.roughness = j / specLevels;
				engine.driver.setRenderTarget(specular, i, j);
				screen.render();
			}
		}
		engine.driver.setRenderTarget(null);
	}

}