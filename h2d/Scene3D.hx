package h2d;

class Scene3D extends h2d.Flow {

	public var s2d : h2d.Scene;
	public var s3d : h3d.scene.Scene;
	public var deleteOnRemove = true;
	public var backgroundColor : Null<Int> = null;
	var events : hxd.SceneEvents;
	var renderTexture : h3d.mat.Texture;
	var prevScale : h2d.Scene.ScaleMode;
	var prevWidth = -1;
	var prevHeight = -1;
	var bgModel : h3d.scene.Mesh;

	public function new(events:hxd.SceneEvents,?parent) {
		this.events = events;
		s2d = new h2d.Scene();
		s3d = new h3d.scene.Scene();
		super(parent);
	}

	override function onAdd() {
		super.onAdd();
		events.addScene(s3d, 0);
		events.addScene(s2d, 0);
	}

	override function onAfterReflow() {
		var tw = Std.int(calculatedWidth);
		var th = Std.int(calculatedHeight);

		// bad fill
		if( tw < 1 ) tw = 1;
		if( th < 1 ) th = 1;
		if( tw >= 100000 || th >= 100000 )
			tw = th = 10;
		if( renderTexture == null || renderTexture.width != tw || renderTexture.height != th ) {
			if( renderTexture != null ) {
				renderTexture.dispose();
				renderTexture.depthBuffer.dispose();
			}
			renderTexture = new h3d.mat.Texture(tw, th, [Target]);
			renderTexture.depthBuffer = new h3d.mat.Texture(tw, th, Depth24Stencil8);
			backgroundTile = h2d.Tile.fromTexture(renderTexture);
		}

		var rootScene = getScene();
		var pos = this.getAbsPos().getPosition();
		var sx = rootScene.viewportScaleX;
		var sy = rootScene.viewportScaleY;
		s2d.scaleMode = Custom(renderTexture.width, renderTexture.height, sx, sy);
		@:privateAccess s2d.offsetX = pos.x * sx;
		@:privateAccess s2d.offsetY = pos.y * sy;

		var scenePosition = {
			offsetX : pos.x * sx,
			offsetY : pos.y * sy,
			width : Std.int(renderTexture.width * sx),
			height : Std.int(renderTexture.height * sy)
		};
		s3d.scenePosition = scenePosition;
		prevScale = rootScene.scaleMode;
		prevWidth = rootScene.width;
		prevHeight = rootScene.height;
	}

	override function onRemove() {
		super.onRemove();
		if( !deleteOnRemove )
			return;
		events.removeScene(s3d);
		events.removeScene(s2d);
		s3d.dispose();
		s2d.dispose();
		if( renderTexture != null ) {
			renderTexture.depthBuffer.dispose();
			renderTexture.dispose();
			renderTexture = null;
		}
	}

	override function sync(ctx:RenderContext) {
		var scene = getScene();
		if( scene.width != prevWidth || scene.height != prevHeight || !scene.scaleMode.equals(prevScale) )
			needReflow = true;
		super.sync(ctx);
	}

	override function draw(ctx:h2d.RenderContext) {
		var prevRZ = ctx.getCurrentRenderZone();
		@:privateAccess ctx.clearRZ();
		s3d.setOutputTarget(ctx.engine, renderTexture);
		var pbr = Std.downcast(s3d.renderer, h3d.scene.pbr.Renderer);
		if( pbr != null ) {
			if( backgroundColor == null ) {
				pbr.skyMode = Hide;
				pbr.enableTransparency = false;
			} else {
				pbr.skyMode = CustomColor;
				pbr.enableTransparency = true;
				(pbr.props : h3d.scene.pbr.Renderer.RenderProps).skyColor = backgroundColor;
			}
		} else
			ctx.engine.clear(backgroundColor ?? 0, 1, 0);
		s3d.setElapsedTime(hxd.Timer.dt);
		s3d.render(ctx.engine);
		s2d.render(ctx.engine);
		s3d.setOutputTarget();
		if( prevRZ != null )
			@:privateAccess ctx.setRZ(prevRZ.x, prevRZ.y, prevRZ.width, prevRZ.height);
		@:privateAccess ctx.initShaders(ctx.baseShaderList);
		ctx.setCurrent();
	}

}