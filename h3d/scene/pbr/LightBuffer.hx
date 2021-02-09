package h3d.scene.pbr;

class LightBuffer {

	public var defaultForwardShader = new h3d.shader.pbr.DefaultForward();

	var MAX_DIR_LIGHT = 2;
	var MAX_SPOT_LIGHT = 6;
	var MAX_POINT_LIGHT = 6;

	var lightInfos : hxd.FloatBuffer;
	final POINT_LIGHT_INFO_SIZE = 3;
	final SPOT_LIGHT_INFO_SIZE = 8;
	final DIR_LIGHT_INFO_SIZE = 5;

	public function new() {
		createBuffers();
	}

	function createBuffers() {
		var stride = 4;
		var size = 0;
		size += MAX_DIR_LIGHT * DIR_LIGHT_INFO_SIZE;
		size += MAX_POINT_LIGHT * POINT_LIGHT_INFO_SIZE;
		size += MAX_SPOT_LIGHT * SPOT_LIGHT_INFO_SIZE;
		size = hxd.Math.imax(1, size); // Avoid empty buffer
		lightInfos = new hxd.FloatBuffer(size * stride);
		defaultForwardShader.lightInfos = new h3d.Buffer(size, stride, [UniformBuffer, Dynamic]);
		defaultForwardShader.BUFFER_SIZE = size;
		defaultForwardShader.dirLightStride = DIR_LIGHT_INFO_SIZE * MAX_DIR_LIGHT;
		defaultForwardShader.pointLightStride = POINT_LIGHT_INFO_SIZE * MAX_POINT_LIGHT;
	}

	public function setBuffers( s : h3d.shader.pbr.DefaultForward ) {
		s.lightInfos = defaultForwardShader.lightInfos;
		s.dirLightStride = defaultForwardShader.dirLightStride;
		s.pointLightStride = defaultForwardShader.pointLightStride;
		s.cameraPosition = defaultForwardShader.cameraPosition;
		s.emissivePower = defaultForwardShader.emissivePower;
		s.BUFFER_SIZE = defaultForwardShader.BUFFER_SIZE;

		s.pointLightCount = defaultForwardShader.pointLightCount;
		s.spotLightCount = defaultForwardShader.spotLightCount;
		s.dirLightCount = defaultForwardShader.dirLightCount;

		/*for( i in 0 ... s.pointLightCount )
			s.pointShadowMaps[i] = defaultForwardShader.pointShadowMaps[i];
		for( i in 0 ... s.spotLightCount )
			s.spotShadowMaps[i] = defaultForwardShader.spotShadowMaps[i];
		for( i in 0 ... s.dirLightCount )
			s.dirShadowMaps[i] = defaultForwardShader.dirShadowMaps[i];*/

		s.USE_INDIRECT = defaultForwardShader.USE_INDIRECT;
		if( s.USE_INDIRECT ) {
			s.irrRotation = defaultForwardShader.irrRotation;
			s.irrPower = defaultForwardShader.irrPower;
			s.irrLut = defaultForwardShader.irrLut;
			s.irrDiffuse = defaultForwardShader.irrDiffuse;
			s.irrSpecular = defaultForwardShader.irrSpecular;
			s.irrSpecularLevels = defaultForwardShader.irrSpecularLevels;
		}
	}

	inline function fillFloats( b : hxd.FloatBuffer, f1 : Float, f2 : Float, f3 : Float, f4 : Float, i : Int ) {
		b[i+0] = f1;
		b[i+1] = f2;
		b[i+2] = f3;
		b[i+3] = f4;
	}

	inline function fillVector( b : hxd.FloatBuffer, v : h3d.Vector, i : Int ) {
		b[i+0] = v.r;
		b[i+1] = v.g;
		b[i+2] = v.b;
		b[i+3] = v.a;
	}

	public function sync( ctx : h3d.scene.RenderContext ) {

		var r = @:privateAccess ctx.scene.renderer;
		var pbrRenderer = Std.downcast(r, Renderer);
		var p : h3d.scene.pbr.Renderer.RenderProps = pbrRenderer.props;
		var s = defaultForwardShader;

		s.cameraPosition = ctx.camera.pos;
		s.emissivePower = p.emissive * p.emissive;

		s.pointLightCount = 0;
		s.spotLightCount = 0;
		s.dirLightCount = 0;

		// Safe Reset
		for( i in 0 ... lightInfos.length )
			lightInfos[i] = 0;

		var l = @:privateAccess ctx.lights;
		while( l != null ) {

			// Dir Light
			var dl = Std.downcast(l, DirLight);
			if( dl != null ) {
				var li = s.dirLightCount;
				var i = li * DIR_LIGHT_INFO_SIZE * 4;
				var pbr = @:privateAccess dl.pbr;
				fillVector(lightInfos, pbr.lightColor, i);
				lightInfos[i+3] = (dl.shadows != null && dl.shadows.mode != None) ? 1.0 : -1.0;
				fillVector(lightInfos, pbr.lightDir, i+4);
				/*if( lightInfos[i+3] > 0 ) {
					lightInfos[i+7] = dl.shadows.bias;
					s.dirShadowMaps[li] = dl.shadows.getShadowTex();
					var mat = dl.shadows.getShadowProj();
					fillFloats(lightInfos, mat._11, mat._21, mat._31, mat._41, i+8);
					fillFloats(lightInfos, mat._12, mat._22, mat._32, mat._42, i+12);
					fillFloats(lightInfos, mat._13, mat._23, mat._33, mat._43, i+16);
				}*/
				s.dirLightCount++;
			}

			// Point Light
			var pl = Std.downcast(l, PointLight);
			if( pl != null ) {
				var offset = MAX_DIR_LIGHT * DIR_LIGHT_INFO_SIZE * 4;
				var li = s.pointLightCount;
				var i = li * POINT_LIGHT_INFO_SIZE * 4 + offset;
				var pbr = @:privateAccess pl.pbr;
				fillVector(lightInfos, pbr.lightColor, i);
				lightInfos[i+3] = pbr.pointSize;
				fillVector(lightInfos, pbr.lightPos, i+4);
				lightInfos[i+7] = pbr.invLightRange4;
				lightInfos[i+8] = pl.range;
				lightInfos[i+9] = (pl.shadows != null && pl.shadows.mode != None) ? 1.0 : -1.0;
				/*if( lightInfos[i+9] > 0 ) {
					lightInfos[i+10] = pl.shadows.bias;
					s.pointShadowMaps[li] = pl.shadows.getShadowTex();
				}*/
				s.pointLightCount++;
			}

			// Spot Light
			var sl = Std.downcast(l, SpotLight);
			if( sl != null ) {
				var offset = (MAX_DIR_LIGHT * DIR_LIGHT_INFO_SIZE + MAX_POINT_LIGHT * POINT_LIGHT_INFO_SIZE) * 4 ;
				var li = s.spotLightCount;
				var i = s.spotLightCount * SPOT_LIGHT_INFO_SIZE * 4 + offset;
				var pbr = @:privateAccess sl.pbr;
				fillVector(lightInfos, pbr.lightColor, i);
				lightInfos[i+3] = pbr.range;
				fillVector(lightInfos, pbr.lightPos, i+4);
				lightInfos[i+7] = pbr.invLightRange4;
				fillVector(lightInfos, pbr.spotDir, i+8);
				lightInfos[i+12] = pbr.angle;
				lightInfos[i+13] = pbr.fallOff;
				lightInfos[i+14] = (sl.shadows != null && sl.shadows.mode != None) ? 1.0 : -1.0;
				/*if( lightInfos[i+14] > 0 ) {
					lightInfos[i+15] = sl.shadows.bias;
					var mat = sl.shadows.getShadowProj();
					fillFloats(lightInfos, mat._11, mat._21, mat._31, mat._41, i+16);
					fillFloats(lightInfos, mat._12, mat._22, mat._32, mat._42, i+20);
					fillFloats(lightInfos, mat._13, mat._23, mat._33, mat._43, i+24);
					fillFloats(lightInfos, mat._14, mat._24, mat._34, mat._44, i+28);
					s.spotShadowMaps[li] = sl.shadows.getShadowTex();
				}*/
				s.spotLightCount++;
			}

			l = l.next;
		}

		s.lightInfos.uploadVector(lightInfos, 0, s.lightInfos.vertices, 0);

		var pbrIndirect = @:privateAccess pbrRenderer.pbrIndirect;
		s.USE_INDIRECT = pbrRenderer.env != null && pbrIndirect.irrLut != null;
		if( s.USE_INDIRECT ) {
			s.irrRotation = pbrIndirect.irrRotation;
			s.irrPower = pbrIndirect.irrPower;
			s.irrLut = pbrIndirect.irrLut;
			s.irrDiffuse = pbrIndirect.irrDiffuse;
			s.irrSpecular = pbrIndirect.irrSpecular;
			s.irrSpecularLevels = pbrIndirect.irrSpecularLevels;
		}
	}
}
