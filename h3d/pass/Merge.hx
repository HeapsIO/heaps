package h3d.pass;

#if macro

class Merge {

	public static function run( tex1 : h3d.mat.Texture, tex2 : h3d.mat.Texture, ?blend : h3d.mat.BlendMode, ?pass : h3d.mat.Pass ) {
		throw "assert";
	}

}

#else

class MergeShader extends h3d.shader.ScreenShader {
	static var SRC = {
		@const var isCube : Bool;
		@param var tex1 : Sampler2D;
		@param var tex2 : Sampler2D;
		@param var cube1 : SamplerCube;
		@param var cube2 : SamplerCube;
		@param var faceMatrix : Mat3;
		@param var mipLvl : Int = 0;
		@param var alpha : Float;

		function fragment() {
			if( isCube ) {
				var dir = normalize(vec3(calculatedUV * 2. - 1., 1.) * faceMatrix);
				pixelColor = mix(cube1.getLod(dir, mipLvl), cube2.getLod(dir, mipLvl), alpha);
			} else
				pixelColor = mix(tex1.getLod(calculatedUV, mipLvl), tex2.getLod(calculatedUV, mipLvl), alpha);
		}
	};
}

class Merge extends ScreenFx<MergeShader> {

	public function new() {
		super(new MergeShader());
	}

	public function apply(tex1 : h3d.mat.Texture, tex2 : h3d.mat.Texture, t : Float, output : h3d.mat.Texture) {
		var isCube = tex1.flags.has(Cube);
		shader.isCube = isCube;
		if( isCube ) {
			shader.cube1 = tex1;
			shader.cube2 = tex2;
		} else {
			shader.tex1 = tex1;
			shader.tex2 = tex2;
		}
		shader.alpha = t;

		var e = h3d.Engine.getCurrent();
		e.driver.beginEvent("ToDTexture merge " + tex1.id + " and " + tex2.id);

		for (i in 0...tex1.mipLevels) {
			shader.mipLvl = i;
			if( isCube ) {
				for (layer in 0...6) {
					shader.faceMatrix = h3d.mat.Texture.getCubeFaceMatrix(layer);
					e.pushTarget(output, layer, i);
					render();
					e.popTarget();
				}
			} else {
				e.pushTarget(output, 0, i);
				render();
				e.popTarget();
			}
		}
		e.driver.endEvent();
		shader.tex1 = shader.tex2 = null;
		shader.cube1 = shader.cube2 = null;
	}

	public static function run(tex1 : h3d.mat.Texture, tex2 : h3d.mat.Texture, t : Float, output : h3d.mat.Texture) {
		var engine = h3d.Engine.getCurrent();
		if (tex1 == null || tex2 == null || t < 0 || t > 1 || output == null)
			return;
		var inst : Merge = @:privateAccess engine.resCache.get(Merge);
		if( inst == null ) {
			inst = new Merge();
			@:privateAccess engine.resCache.set(Merge, inst);
		}

		return inst.apply(tex1, tex2, t, output);
	}
}

#end