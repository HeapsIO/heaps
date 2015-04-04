package h2d.filter;

class Shader< T:h3d.shader.ScreenShader > extends Filter {

	public var shader(get, never) : T;
	public var pass : h3d.pass.ScreenFx<T>;
	public var nearest : Bool;
	var textureParam : String;

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
		var out = ctx.textures.allocTarget("shaderTmp", ctx, t.width, t.height, false);
		ctx.engine.setTarget(out);
		Reflect.setField(shader, textureParam + "__", t.getTexture());
		if( nearest ) t.getTexture().filter = Nearest;
		pass.render();
		return h2d.Tile.fromTexture(out);
	}

}