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
		var p = scene.camera.project(absPos._41, absPos._42, absPos._43, width, height, true);
		x = p.x;
		y = p.y;
		visible = p.z > 0;
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