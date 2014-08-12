package h3d.pass;

class Clear extends ScreenFx<h3d.shader.Clear> {

	public function new() {
		super( new h3d.shader.Clear() );
	}

	public function apply( ?color : h3d.Vector, ?depth : Float ) {
		pass.depth(depth != null, Always);
		shader.depth = depth != null ? depth : 0;
		if( color != null ) {
			shader.color.load(color);
			pass.colorMask = 15;
		} else
			pass.colorMask = 0;
		render();
	}

}