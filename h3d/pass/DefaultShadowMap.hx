package h3d.pass;

class DefaultShadowMap extends DirShadowMap {

	var shadowMapId : Int;
	var shadowProjId : Int;
	var shadowColorId : Int;
	var shadowPowerId : Int;
	var shadowBiasId : Int;

	public var color : h3d.Vector;

	public function new(size=1024,?format:hxd.PixelFormat) {
		if( format != null )
			this.format = format;
		super(null);
		this.size = size;
		color = new h3d.Vector();
		mode = Dynamic;
		shadowMapId = hxsl.Globals.allocID("shadow.map");
		shadowProjId = hxsl.Globals.allocID("shadow.proj");
		shadowColorId = hxsl.Globals.allocID("shadow.color");
		shadowPowerId = hxsl.Globals.allocID("shadow.power");
		shadowBiasId = hxsl.Globals.allocID("shadow.bias");
	}

	override function draw( passes, ?sort ) {
		super.draw(passes, sort);
		ctx.setGlobalID(shadowMapId, { texture : dshader.shadowMap, channel : format == h3d.mat.Texture.nativeFormat ? hxsl.Channel.PackedFloat : hxsl.Channel.R });
		ctx.setGlobalID(shadowProjId, getShadowProj());
		ctx.setGlobalID(shadowColorId, color);
		ctx.setGlobalID(shadowPowerId, power);
		ctx.setGlobalID(shadowBiasId, bias);
	}

}