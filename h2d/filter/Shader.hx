package h2d.filter;

/**
	The base class for simple filters that don't need specialized render passes and rely completely on the shaders.

	Provides an easy interface to implement custom filters without going too deep into filter rendering process with render passes.

	Compatible shaders should extend from `h3d.shader.ScreenShader` and contain an input texture uniform, as well as assign `pixelColor` in fragment shader.

	Sample of a simple custom filter:
	```haxe
	class InvertColorShader extends h3d.shader.ScreenShader {
		static var SRC = {
			@param var texture : Sampler2D;

			function fragment() {
				var pixel : Vec4 = texture.get(calculatedUV);
				// Premultiply alpha to ensure correct transparency.
				pixelColor = vec4((1. - pixel.rgb) * pixel.a, pixel.a);
				// Some other filters directly assign `output.color` and fetch from `input.uv`.
				// While it will work, it does not work well when multiple shaders in one filter are involved.
				// In this case use `calculatedUV` and `pixelColor`.
			}
		}
	}

	// When initializing
	// Second argument should point at Sampler2D that will take in the texture with contents filter should modify.
	myObj.filter = new h2d.filter.Shader<InvertColorShader>(new InvertColorShader(), "texture");
	```
**/
class Shader< T:h3d.shader.ScreenShader > extends Filter {

	/**
		The assigned shader instance.
		Can be accessed to modify shader uniforms.
	**/
	public var shader(get, never) : T;
	/**
		ScreenFX pass that will render the filter.
	**/
	public var pass : h3d.pass.ScreenFx<T>;
	/**
		When enabled, sampling on the input texture will use nearest neighbor algorithm.
	**/
	public var nearest : Bool;
	var textureParam : String;

	/**
		Create new shader filter.
		@param shader The shader instance that will be used for rendering.
		@param textureParam The name of `Sampler2D` in the shader to which input texture will be assigned. Should be present in the shader.
	**/
	public function new( shader : T, textureParam = "texture" ) {
		super();
		var found = false;
		for( v in @:privateAccess shader.shader.data.vars ) {
			if( v.name == textureParam ) {
				found = true;
				break;
			}
		}
		if( !found ) throw "Shader does not have '" + textureParam + "' variable";
		this.textureParam = textureParam;
		this.pass = new h3d.pass.ScreenFx(shader);
	}

	function get_shader() return pass.shader;

	override function draw( ctx : RenderContext, t : h2d.Tile ) {
		var out = ctx.textures.allocTileTarget("shaderTmp", t);
		ctx.engine.pushTarget(out);
		Reflect.setField(shader, textureParam + "__", t.getTexture());
		if( nearest ) t.getTexture().filter = Nearest;
		pass.render();
		ctx.engine.popTarget();
		return h2d.Tile.fromTexture(out);
	}

}