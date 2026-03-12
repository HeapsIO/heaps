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
		@param var tex1 : Sampler2D;
		@param var tex2 : Sampler2D;
		@param var mipLvl : Int = 0;
		@param var alpha : Float;

		function fragment() {
			pixelColor = mix(tex1.getLod(calculatedUV, mipLvl), tex2.getLod(calculatedUV, mipLvl), alpha);
		}
	};
}

class Merge extends ScreenFx<MergeShader> {

	public function new() {
		super(new MergeShader());
	}

	public function apply(tex1 : h3d.mat.Texture, tex2 : h3d.mat.Texture, t : Float, output : h3d.mat.Texture) {
		shader.tex1 = tex1;
		shader.tex2 = tex2;
		shader.alpha = t;

		var e = h3d.Engine.getCurrent();
		e.driver.beginEvent("ToDTexture merge " + tex1.id + " and " + tex2.id);

		for (i in 0...tex1.mipLevels) {
			shader.mipLvl = i;
			if (tex1.flags.has(Cube)) {
				#if hldx
				for (layer in 0...6) {
					mergeShader.tex1.slice = layer + 1;
					mergeShader.tex2.slice = layer + 1;
					e.pushTarget(output, layer, i);
					render();
					e.popTarget();
				}
				#else
					output = t < 0.5 ? tex1 : tex2;
				#end
			} else {
				e.pushTarget(output, i);
				render();
				e.popTarget();
			}
		}
		e.driver.endEvent();
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