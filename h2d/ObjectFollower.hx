package h2d;

/**
	Allows a 2D object position to follow a 3D object using the current camera.
**/
@:uiNoComponent
class ObjectFollower extends Object {

	/**
		Reference to target 3D object to follow.
	**/
	public var follow : h3d.scene.Object;
	/**
		Rounds the resulting 2d position of follower aligning it to s2d pixel grid.
	**/
	public var pixelSnap = true;
	/**
		If enabled, follower will mirror visibility of target object.
	**/
	public var followVisibility = false;
	/**
		Extra camera projection offset along X-axis to which follower will attach to.
	**/
	public var offsetX = 0.;
	/**
		Extra camera projection offset along Y-axis to which follower will attach to.
	**/
	public var offsetY = 0.;
	/**
		Extra camera projection offset along Z-axis to which follower will attach to.
	**/
	public var offsetZ = 0.;

	/**
		Horizontal object alignment relative to anchoring point.
	**/
	public var horizontalAlign : h2d.Flow.FlowAlign = Left;
	/**
		Vertical object alignment relative to anchoring point.
	**/
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
		x = p.x;
		y = p.y;
		visible = p.z > 0;

		if( horizontalAlign != Left || verticalAlign != Top ) {
			var prev = follow;
			follow = null;
			var b = getBounds(this); // prevent recursive
			follow = prev;

			var w = b.width, h = b.height;
			switch( horizontalAlign ) {
			case Middle: x -= w * 0.5;
			case Right: x -= w;
			default:
			}
			switch( verticalAlign ) {
			case Middle: y -= h * 0.5;
			case Bottom: y -= h;
			default:
			}
		}

		if( pixelSnap ) {
			x = Math.round(x);
			y = Math.round(y);
		}

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