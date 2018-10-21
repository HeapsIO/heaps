package h3d.scene.pbr;

import h3d.scene.pbr.Renderer;

class LightProbeBaker {

	public var useGPU = false;
	public var environment : h3d.scene.pbr.Environment;

	var envMap : h3d.mat.Texture;
	var customCamera : h3d.Camera;
	var cubeDir = [ h3d.Matrix.L([0,0,-1,0, 0,1,0,0, -1,-1,1,0]),
					h3d.Matrix.L([0,0,1,0, 0,1,0,0, 1,-1,-1,0]),
	 				h3d.Matrix.L([-1,0,0,0, 0,0,1,0, 1,-1,-1,0]),
	 				h3d.Matrix.L([-1,0,0,0, 0,0,-1,0, 1,1,1,0]),
				 	h3d.Matrix.L([-1,0,0,0, 0,1,0,0, 1,-1,1,0]),
				 	h3d.Matrix.L([1,0,0,0, 0,1,0,0, -1,-1,-1,0]) ];

	function getSwiz(name,comp) : hxsl.Output { return Swiz(Value(name,3),[comp]); }

	var computeSH : h3d.pass.ScreenFx<h3d.shader.pbr.ComputeSH>;
	var output0 = new h3d.mat.Texture(1, 1, [Target], RGBA32F);
	var output1 = new h3d.mat.Texture(1, 1, [Target], RGBA32F);
	var output2 = new h3d.mat.Texture(1, 1, [Target], RGBA32F);
	var output3 = new h3d.mat.Texture(1, 1, [Target], RGBA32F);
	var output4 = new h3d.mat.Texture(1, 1, [Target], RGBA32F);
	var output5 = new h3d.mat.Texture(1, 1, [Target], RGBA32F);
	var output6 = new h3d.mat.Texture(1, 1, [Target], RGBA32F);
	var output7 = new h3d.mat.Texture(1, 1, [Target], RGBA32F);
	var textureArray: Array<h3d.mat.Texture>;

	public function new(){
		customCamera = new h3d.Camera();
		customCamera.screenRatio = 1.0;
		customCamera.fovY = 90;
	}

	public function bake(renderer : h3d.scene.Renderer, s3d : Scene, volumetricLightMap : VolumetricLightmap, resolution : Int, ?time :Float) {

		var timer = haxe.Timer.stamp();
		var timeElapsed = 0.0;

		var index = volumetricLightMap.lastBakedProbeIndex + 1;
		if(index > volumetricLightMap.getProbeCount() - 1) return time;

		setupEnvMap(resolution);
		setupShaderOutput(volumetricLightMap.shOrder);

		// Save Scene Config
		var oldRenderer = s3d.renderer;
		var oldCamera = s3d.camera;
		var oldRenderMode = renderer.renderMode;
		s3d.renderer = renderer;
		s3d.renderer.renderMode = LightProbe;
		s3d.camera = customCamera;
		var engine = h3d.Engine.getCurrent();

		var coefCount = volumetricLightMap.getCoefCount();
		var sizeX = volumetricLightMap.probeCount.x * coefCount;
		var sizeY = volumetricLightMap.probeCount.y * volumetricLightMap.probeCount.z;
		if(volumetricLightMap.lightProbeTexture == null || volumetricLightMap.lightProbeTexture.width != sizeX || volumetricLightMap.lightProbeTexture.height != sizeY){
			if( volumetricLightMap.lightProbeTexture != null ) volumetricLightMap.lightProbeTexture.dispose();
			volumetricLightMap.lightProbeTexture = new h3d.mat.Texture(sizeX, sizeY, [Dynamic], RGBA32F);
			volumetricLightMap.lightProbeTexture.filter = Nearest;
		}

		var pixels : hxd.Pixels.PixelsFloat = volumetricLightMap.lightProbeTexture.capturePixels();

		while( (time != null && timeElapsed < time) || time == null){
			var coords = volumetricLightMap.getProbeCoords(index);

			// Bake a Probe
			for( f in 0...6 ) {
				engine.begin();
				customCamera.setCubeMap(f, volumetricLightMap.getProbePosition(coords));
				customCamera.update();
				engine.pushTarget(envMap, f);
				engine.clear(0,1,0);
				s3d.render(engine);
				engine.popTarget();
			}
			volumetricLightMap.lastBakedProbeIndex = index;

			var sh : SphericalHarmonic = useGPU ? convertEnvIntoSH_GPU(renderer, envMap, volumetricLightMap.shOrder) : convertEnvIntoSH_CPU(envMap, volumetricLightMap.shOrder);
			for(coef in 0... coefCount){
				var u = coords.x + volumetricLightMap.probeCount.x * coef;
				var v = coords.y + coords.z * volumetricLightMap.probeCount.y;
				pixels.setPixelF(u, v, new h3d.Vector(sh.coefR[coef], sh.coefG[coef], sh.coefB[coef], 0));
			}

			index = volumetricLightMap.lastBakedProbeIndex + 1;
			if(index > volumetricLightMap.getProbeCount() - 1) break;

			timeElapsed = haxe.Timer.stamp() - timer;
		}

		volumetricLightMap.lightProbeTexture.uploadPixels(pixels, 0, 0);

		// Restore Scene Config
		s3d.camera = oldCamera;
		s3d.renderer = oldRenderer;
		s3d.renderer.renderMode = oldRenderMode;

		return time - timeElapsed;
	}

	function setupEnvMap(resolution : Int){
		if(envMap == null || resolution != envMap.width ) {
			if( envMap != null ) envMap.dispose();
			envMap = new h3d.mat.Texture(resolution, resolution, [Cube, Target], RGBA32F);
		}
	}

	public function dispose() {
		if( envMap != null ) {
			envMap.dispose();
			envMap = null;
		}
		output0.dispose();
		output1.dispose();
		output2.dispose();
		output3.dispose();
		output4.dispose();
		output5.dispose();
		output6.dispose();
		output7.dispose();
	}

	function setupShaderOutput(order : Int){

		if(order > 3 || order <= 0){ throw "Not Supported"; return; }

		switch(order){
			case 1:
				textureArray = [output0];
				computeSH = new h3d.pass.ScreenFx(new h3d.shader.pbr.ComputeSH(),[
								Vec4([Value("out.coefL00", 3), Const(0)])]);
			case 2:
				textureArray = [output0, output1, output2, output3];
				computeSH = new h3d.pass.ScreenFx(new h3d.shader.pbr.ComputeSH(),[
							Vec4([Value("out.coefL00", 3), Const(0)]),
							Vec4([Value("out.coefL1n1", 3), Const(0)]),
							Vec4([Value("out.coefL10", 3), Const(0)]),
							Vec4([Value("out.coefL11", 3), Const(0)])]);

			case 3:
				textureArray = [output0, output1, output2, output3, output4, output5, output6, output7];
				computeSH = new h3d.pass.ScreenFx(new h3d.shader.pbr.ComputeSH(),[
							Vec4([Value("out.coefL00", 3), getSwiz("out.coefL22",X) ]),
							Vec4([Value("out.coefL1n1", 3), getSwiz("out.coefL22",Y) ]),
							Vec4([Value("out.coefL10", 3), getSwiz("out.coefL22",Z) ]),
							Vec4([Value("out.coefL11", 3), Const(0)]),
							Vec4([Value("out.coefL2n2", 3), Const(0)]),
							Vec4([Value("out.coefL2n1", 3), Const(0)]),
							Vec4([Value("out.coefL20", 3), Const(0)]),
							Vec4([Value("out.coefL21", 3), Const(0)])]);
		}
	}

	function convertEnvIntoSH_GPU(renderer : h3d.scene.Renderer, env : h3d.mat.Texture, order : Int) : SphericalHarmonic {
		var t0 = haxe.Timer.stamp();

		@:privateAccess renderer.ctx.engine = h3d.Engine.getCurrent();
		@:privateAccess renderer.setTargets(textureArray);
		computeSH.shader.ORDER = order;
		computeSH.shader.width = env.width;
		computeSH.shader.environment = env;
		computeSH.shader.cubeDir = cubeDir;
		computeSH.render();
		@:privateAccess renderer.resetTarget();
		@:privateAccess renderer.ctx.engine.flushTarget();

		var sphericalHarmonic = new SphericalHarmonic(order);
		var coefCount = order * order;
		var maxCoef : Int = Std.int(Math.min(8, coefCount));

		for(i in 0...maxCoef){
			var pixel : hxd.Pixels.PixelsFloat = textureArray[i].capturePixels();
			var coefs : h3d.Vector = pixel.getPixelF(0, 0);
			sphericalHarmonic.coefR[i] = coefs.r;
			sphericalHarmonic.coefG[i] = coefs.g;
			sphericalHarmonic.coefB[i] = coefs.b;
			// Last coefs is inside the alpha channel
			if( order == 3 ){
				if( i == 0 ){ sphericalHarmonic.coefR[8] = coefs.a; }
				if( i == 1 ){ sphericalHarmonic.coefG[8] = coefs.a; }
				if( i == 2 ){ sphericalHarmonic.coefB[8] = coefs.a; }
			}
		}
		//trace("SH compute time GPU", haxe.Timer.stamp() - t0);
		return sphericalHarmonic;
	}

	function convertEnvIntoSH_CPU(env : h3d.mat.Texture, order : Int) : SphericalHarmonic {
		var coefCount = order * order;
		var sphericalHarmonic = new SphericalHarmonic(order);
		var face : hxd.Pixels.PixelsFloat;
		var weightSum = 0.0;
		var invWidth = 1.0 / env.width;
		var shData : Array<Float> = [for (value in 0...coefCount) 0];

		for(f in 0...6){
			face = env.capturePixels(f, 0);
			for (u in 0...face.width) {
				var fU : Float = (u / face.width ) * 2 - 1;// Texture coordinate U in range [-1 to 1]
				fU *= fU;
				var uCoord = 2.0 * u * invWidth + invWidth;
				for (v in 0...face.width) {
        			var fV : Float = (v / face.height ) * 2 - 1;// Texture coordinate V in range [-1 to 1]
					fV *= fV;
					var vCoord = 2.0 * v * invWidth + invWidth;
					var dir = getDir(uCoord, vCoord, f);// Get direction from center of cube texture to current texel
           			var diffSolid = 4.0 / ((1.0 + fU + fV) * Math.sqrt(1.0 + fU + fV));	// Scale factor depending on distance from center of the face
					weightSum += diffSolid;
					var color = face.getPixelF(u,v);// Get color from the current face
					evalSH(order, dir, shData);// Calculate coefficients of spherical harmonics for current direction
					for(i in 0...coefCount){
						sphericalHarmonic.coefR[i] += shData[i] * color.r * diffSolid;
						sphericalHarmonic.coefG[i] += shData[i] * color.g * diffSolid;
						sphericalHarmonic.coefB[i] += shData[i] * color.b * diffSolid;
					}
				}
			}
		}
		// Final scale for coefficients
		var normProj = (4.0 * Math.PI) / weightSum;
		for(i in 0...coefCount){
			sphericalHarmonic.coefR[i] *= normProj;
			sphericalHarmonic.coefG[i] *= normProj;
			sphericalHarmonic.coefB[i] *= normProj;
		}
		return sphericalHarmonic;
	}

	inline function evalSH(order:Int, dir:h3d.Vector, shData : Array<Float>) {
		for (l in 0...order) {
       		for (m in -l...l+1) {
				shData[getIndex(l, m)] = evalCoef(l, m, dir);
			}
		}
	}

	inline function getIndex(l : Int, m :Int) : Int {
		return l * (l + 1) + m;
	}

	inline function getDir(u: Float, v:Float, face:Int) : h3d.Vector {
		var dir = new h3d.Vector();
		switch(face) {
			case 0: dir.x = -1.0; dir.y = -1.0 + v; dir.z = 1.0 - u;
			case 1: dir.x = 1.0; dir.y = -1.0 + v; dir.z = -1.0 + u;
			case 2: dir.x = 1.0 - u; dir.y = -1.0; dir.z = -1.0 + v;
			case 3: dir.x = 1.0 - u; dir.y = 1.0; dir.z = 1.0 - v;
			case 4: dir.x = 1.0 - u;  dir.y = -1.0 + v; dir.z = 1.0;
			case 5: dir.x = -1.0 + u; dir.y = -1.0 + v;  dir.z = -1.0;
			default:
		}
		dir.normalizeFast();
		return dir;
	}

	inline function evalCoef(l : Int, m : Int, dir: h3d.Vector) : Float{
		// Coef from Stupid Spherical Harmonics (SH) Peter-Pike Sloan Microsoft Corporation
		return switch [l,m] {
			case[0,0]:	0.282095; // 0.5 * sqrt(1/pi)
			case[1,-1]:	-0.488603 * dir.y;  // -sqrt(3/(4pi)) * y
			case[1,0]:	0.488603 * dir.z; // sqrt(3/(4pi)) * z
			case[1,1]:	-0.488603 * dir.x; // -sqrt(3/(4pi)) * x
			case[2,-2]:	1.092548 * dir.y * dir.x;// 0.5 * sqrt(15/pi) * y * x
			case[2,-1]:	-1.092548 * dir.y * dir.z; // -0.5 * sqrt(15/pi) * y * z
			case[2,0]:	0.315392 * (-dir.x * dir.x - dir.y * dir.y + 2.0 * dir.z * dir.z);// 0.25 * sqrt(5/pi) * (-x^2-y^2+2z^2)
			case[2,1]:  -1.092548 * dir.x * dir.z; // -0.5 * sqrt(15/pi) * x * z
			case[2,2]:	0.546274 * (dir.x * dir.x - dir.y * dir.y); // 0.25 * sqrt(15/pi) * (x^2 - y^2)
			case[3,-3]:	-0.590044 * dir.y * (3.0 * dir.x * dir.x - dir.y * dir.y);// -0.25 * sqrt(35/(2pi)) * y * (3x^2 - y^2)
			case[3,-2]: 2.890611 * dir.x * dir.y * dir.z; // 0.5 * sqrt(105/pi) * x * y * z
			case[3,-1]: -0.457046 * dir.y * (4.0 * dir.z * dir.z - dir.x * dir.x - dir.y * dir.y); // -0.25 * sqrt(21/(2pi)) * y * (4z^2-x^2-y^2)
			case[3,0]:  0.373176 * dir.z * (2.0 * dir.z * dir.z - 3.0 * dir.x * dir.x - 3.0 * dir.y * dir.y);  // 0.25 * sqrt(7/pi) * z * (2z^2 - 3x^2 - 3y^2)
			case[3,1]:	-0.457046 * dir.x * (4.0 * dir.z * dir.z - dir.x * dir.x - dir.y * dir.y); // -0.25 * sqrt(21/(2pi)) * x * (4z^2-x^2-y^2)
			case[3,2]:  1.445306 * dir.z * (dir.x * dir.x - dir.y * dir.y); // 0.25 * sqrt(105/pi) * z * (x^2 - y^2)
			case[3,3]:	-0.590044 * dir.x * (dir.x * dir.x - 3.0 * dir.y * dir.y); // -0.25 * sqrt(35/(2pi)) * x * (x^2-3y^2)
			case[4,-4]: 2.503343 * dir.x * dir.y * (dir.x * dir.x - dir.y * dir.y);// 0.75 * sqrt(35/pi) * x * y * (x^2-y^2)
			case[4,-3]: -1.770131 * dir.y * dir.z * (3.0 * dir.x * dir.x - dir.y * dir.y); // -0.75 * sqrt(35/(2pi)) * y * z * (3x^2-y^2)
			case[4,-2]: 0.946175 * dir.x * dir.y * (7.0 * dir.z * dir.z - 1.0);// 0.75 * sqrt(5/pi) * x * y * (7z^2-1)
			case[4,-1]: -0.669047 * dir.y * dir.z * (7.0 * dir.z * dir.z - 3.0);// -0.75 * sqrt(5/(2pi)) * y * z * (7z^2-3)
			case[4,0]:  0.105786 * (35.0 * dir.z * dir.z * dir.z * dir.z - 30.0 * dir.z * dir.z + 3.0);// 3/16 * sqrt(1/pi) * (35z^4-30z^2+3)
			case[4,1]:  -0.669047 * dir.x * dir.z * (7.0 * dir.z * dir.z - 3.0);// -0.75 * sqrt(5/(2pi)) * x * z * (7z^2-3)
			case[4,2]:  0.473087 * (dir.x * dir.x - dir.y * dir.y) * (7.0 * dir.z * dir.z - 1.0);// 3/8 * sqrt(5/pi) * (x^2 - y^2) * (7z^2 - 1)
			case[4,3]:  -1.770131 * dir.x * dir.z * (dir.x * dir.x - 3.0 * dir.y * dir.y);// -0.75 * sqrt(35/(2pi)) * x * z * (x^2 - 3y^2)
			case[4,4]:  0.625836 * (dir.x * dir.x * (dir.x * dir.x - 3.0 * dir.y * dir.y) - dir.y * dir.y * (3.0 * dir.x * dir.x - dir.y * dir.y)); // 3/16*sqrt(35/pi) * (x^2 * (x^2 - 3y^2) - y^2 * (3x^2 - y^2))
			default: 0;
		}
	}
}