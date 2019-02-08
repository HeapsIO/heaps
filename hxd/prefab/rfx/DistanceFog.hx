package hxd.prefab.rfx;

typedef DistanceFogProps = {
 	var startDistance : Float;
	var endDistance : Float;
	var density : Float;
	var startColor : Int;
	var endColor : Int;
}

class DistanceFog extends RendererFX {

	var fogPass = new h3d.pass.ScreenFx(new h3d.shader.DistanceFog());

	public function new(?parent) {
		super(parent);
		props = ({
			startDistance : 0,
			endDistance : 100,
			density : 1.0,
		 	startColor : 0xffffff,
	    	endColor : 0xffffff,
		} : DistanceFogProps);

		fogPass.pass.setBlendMode(Alpha);
	}

	override function apply(r:h3d.scene.Renderer, step:hxd.prefab.rfx.RendererFX.Step) {
		if( step == AfterHdr ) {
			var p : DistanceFogProps = props;
			var ctx = r.ctx;
			var depth : hxsl.ChannelTexture = ctx.getGlobal("depthMap");

			fogPass.shader.startDistance = p.startDistance;
			fogPass.shader.endDistance = p.endDistance;
			fogPass.shader.startColor = h3d.Vector.fromColor(p.startColor);
			fogPass.shader.endColor = h3d.Vector.fromColor(p.endColor);
			fogPass.shader.depthTextureChannel = depth.channel;
			fogPass.shader.depthTexture = depth.texture;
			fogPass.shader.density = p.density;

			fogPass.shader.cameraPos = ctx.camera.pos;
			fogPass.shader.cameraInverseViewProj.load(ctx.camera.getInverseViewProj());

			fogPass.render();
		}
	}

	#if editor
	override function edit( ctx : hide.prefab.EditContext ) {
		ctx.properties.add(new hide.Element('
			<dl>
			<dt>Density</dt><dd><input type="range" min="0" max="1" field="density"/></dd>
			<dt>Start Distance</dt><dd><input type="range" min="0" max="100" field="startDistance"/></dd>
			<dt>End Distance</dt><dd><input type="range" min="0" max="100" field="endDistance"/></dd>
			<dt>Start Color</dt><dd><input type="color" field="startColor"/></dd>
			<dt>End Color</dt><dd><input type="color" field="endColor"/></dd>
			</dl>
		'),props);
	}
	#end

	static var _ = Library.register("rfx.distanceFog", DistanceFog);

}