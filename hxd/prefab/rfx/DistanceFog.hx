package hxd.prefab.rfx;

typedef DistanceFogProps = {
 	var startDistance : Float;
	var endDistance : Float;
	var startOpacity : Float;
	var endOpacity : Float;

	var startColor : Int;
	var endColor : Int;
	var startColorDistance : Float;
	var endColorDistance : Float;
}

class DistanceFog extends RendererFX {

	var fogPass = new h3d.pass.ScreenFx(new h3d.shader.DistanceFog());

	public function new(?parent) {
		super(parent);
		props = ({
			startDistance : 0,
			endDistance : 100,
			startOpacity : 0,
			endOpacity : 1,
		 	startColor : 0xffffff,
	    	endColor : 0xffffff,
			startColorDistance : 0,
			endColorDistance : 100,
		} : DistanceFogProps);

		fogPass.pass.setBlendMode(Alpha);
	}

	override function apply(r:h3d.scene.Renderer, step:hxd.prefab.rfx.RendererFX.Step) {
		if( step == BeforeTonemapping ) {
			var p : DistanceFogProps = props;
			var ctx = r.ctx;
			var depth : hxsl.ChannelTexture = ctx.getGlobal("depthMap");

			fogPass.shader.startDistance = p.startDistance;
			fogPass.shader.endDistance = p.endDistance;
			fogPass.shader.startOpacity = p.startOpacity;
			fogPass.shader.endOpacity = p.endOpacity;
			fogPass.shader.startColorDistance = p.startColorDistance;
			fogPass.shader.endColorDistance = p.endColorDistance;
			fogPass.shader.startColor = h3d.Vector.fromColor(p.startColor);
			fogPass.shader.endColor = h3d.Vector.fromColor(p.endColor);
			fogPass.shader.depthTextureChannel = depth.channel;
			fogPass.shader.depthTexture = depth.texture;

			fogPass.shader.cameraPos = ctx.camera.pos;
			fogPass.shader.cameraInverseViewProj.load(ctx.camera.getInverseViewProj());

			fogPass.render();
		}
	}

	#if editor
	override function edit( ctx : hide.prefab.EditContext ) {
		ctx.properties.add(new hide.Element('
			<dl>
				<div class="group" name="Opacity">
					<dt>Start Distance</dt><dd><input type="range" min="0" max="100" field="startDistance"/></dd>
					<dt>End Distance</dt><dd><input type="range" min="0" max="100" field="endDistance"/></dd>
					<dt>Start Opacity</dt><dd><input type="range" min="0" max="1" field="startOpacity"/></dd>
					<dt>End Opacity</dt><dd><input type="range" min="0" max="1" field="endOpacity"/></dd>
				</div>
				<div class="group" name="Color">
					<dt>Start Distance</dt><dd><input type="range" min="0" max="100" field="startColorDistance"/></dd>
					<dt>End Distance</dt><dd><input type="range" min="0" max="100" field="endColorDistance"/></dd>
					<dt>Start Color</dt><dd><input type="color" field="startColor"/></dd>
					<dt>End Color</dt><dd><input type="color" field="endColor"/></dd>
				</div>
			</dl>
		'),props);
	}
	#end

	static var _ = Library.register("rfx.distanceFog", DistanceFog);

}