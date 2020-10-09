package h2d;

/**
	Allows a 2D object position to follow a 3D object using the current camera.
**/
@:uiNoComponent
class ObjectFollower extends Object {

	public var follow : h3d.scene.Object;
	public var pixelSnap = true;
	public var followVisibility = false;
	public var offsetX = 0.;
	public var offsetY = 0.;
	public var offsetZ = 0.;

	public var horizontalAlign : h2d.Flow.FlowAlign = Left;
	public var verticalAlign : h2d.Flow.FlowAlign = Top;

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
		var p = scene.camera.project(absPos._41 + offsetX, absPos._42 + offsetY, absPos._43 + offsetZ, width, height);
		visible = p.z > 0;

		if( horizontalAlign != Left || verticalAlign != Top ) {
			var prev = follow;
			follow = null;
			var b = getSize(); // prevent recursive
			follow = prev;

			var w = b.width, h = b.height;
			switch( horizontalAlign ) {
			case Middle: p.x -= w * 0.5;
			case Right: p.x -= w;
			default:
			}
			switch( verticalAlign ) {
			case Middle: p.y -= h * 0.5;
			case Bottom: p.y -= h;
			default:
			}
		}

		if( pixelSnap ) {
			p.x = Math.round(p.x);
			p.y = Math.round(p.y);
		}

		x = p.x;
		y = p.y;

		if(followVisibility) {
			var parent = follow;
			while(parent != null) {
				visible = visible && parent.visible;
				parent = parent.parent;
			}
		}
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