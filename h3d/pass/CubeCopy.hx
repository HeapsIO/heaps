package h3d.pass;

private class CubeCopyShader extends h3d.shader.ScreenShader {

	static var SRC = {
		@param var texture : SamplerCube;
		@param var mat : Mat3;
		function fragment() {
			var uv = calculatedUV * 2.0 - 1.0;
			pixelColor = texture.get(normalize(vec3(uv, 1) * mat));
		}
	}
}

class CubeCopy extends ScreenFx<CubeCopyShader> {

	var cubeDir = [ h3d.Matrix.L([0,0,-1,0, 0,-1,0,0, 1,0,0,0]),
					h3d.Matrix.L([0,0,1,0, 0,-1,0,0, -1,0,0,0]),
	 				h3d.Matrix.L([1,0,0,0, 0,0,1,0, 0,1,0,0]),
	 				h3d.Matrix.L([1,0,0,0, 0,0,-1,0, 0,-1,0,0]),
				 	h3d.Matrix.L([1,0,0,0, 0,-1,0,0, 0,0,1,0]),
				 	h3d.Matrix.L([-1,0,0,0, 0,-1,0,0, 0,0,-1,0]) ];

	public function new() {
		super(new CubeCopyShader());
	}

	public function apply( from, to, ?blend : h3d.mat.BlendMode, mip : Int = 0 ) {
		shader.texture = from;
		for(i in 0 ... 6){
			if( to != null )
				engine.pushTarget(to, i, mip);
			shader.mat = cubeDir[i];
			pass.setBlendMode(blend == null ? None : blend);
			render();
			if( to != null )
				engine.popTarget();
		}
		shader.texture = null;
	}

	public static function run( from : h3d.mat.Texture, to : h3d.mat.Texture, ?blend : h3d.mat.BlendMode, mip : Int = 0 ) {
		var engine = h3d.Engine.getCurrent();
		if( to != null && from != null && (blend == null || blend == None) && mip == 0 && engine.driver.copyTexture(from, to) )
			return;
		var inst : CubeCopy = @:privateAccess engine.resCache.get(CubeCopy);
		if( inst == null ) {
			inst = new CubeCopy();
			@:privateAccess engine.resCache.set(CubeCopy, inst);
		}
		return inst.apply(from, to, blend, mip);
	}
}