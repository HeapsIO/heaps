package h2d;

class Scene3D extends Sprite {

	public var scene : h3d.scene.Scene;

	public function new( scene, ?parent ) {
		super(parent);
		this.scene = scene;
	}

	override function draw( ctx : RenderContext ) {
		scene.render(ctx.engine);
	}

}

class ObjectFollower extends Sprite {

	public var follow : h3d.scene.Object;
	public var pixelSnap = true;
	public var offsetX = 0.;
	public var offsetY = 0.;
	public var offsetZ = 0.;

	public function new( obj, ?parent ) {
		super(parent);
		this.follow = obj;
	}

	function followObject() {
		if( follow == null )
			return;
		var scene = @:privateAccess follow.getScene();
		if( scene == null )
			return;
		var s2d = getScene();
		var width = s2d == null ? h3d.Engine.getCurrent().width : s2d.width;
		var height = s2d == null ? h3d.Engine.getCurrent().height : s2d.height;
		var absPos = follow.getAbsPos();
		var p = scene.camera.project(absPos._41 + offsetX, absPos._42 + offsetY, absPos._43 + offsetZ, width, height, pixelSnap);
		x = p.x;
		y = p.y;
		visible = p.z > 0;
	}

	override function calcAbsPos() {
		super.calcAbsPos();
		absX = x;
		absY = y;
	}

	override function syncPos() {
		followObject();
		super.syncPos();
	}

	override function sync(ctx) {
		followObject();
		super.sync(ctx);
	}

}