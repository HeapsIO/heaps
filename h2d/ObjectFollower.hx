package h2d;

/**
	Follows the 3D object position in current 3D camera, synchronizing the follower position to projected 2D position of the followed object.
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

	/**
		Mask with current depth buffer
	**/
	public var depthMask : Bool = false;

	/**
		Calculate the depth for masking with the given bias in 3D position units, relative to current camera.
	**/
	public var depthBias : Float = 0.;

	/**
		Express the offset in terms of the current camera direction.
	**/
	public var cameraRelative : Bool = false;

	/**
		If enabled, the ObjectFollower will remove itself if the object followed is null or removed.
	**/
	public var autoRemove : Bool = false;

	var zValue : Float = 0.;
	var outputScale : Float = 1.;
	var tmpPos = new h3d.Vector();
	var tmpSize : h2d.col.Bounds;

	/**
		Create a new ObjectFollower instance.
		@param obj The 3D object to follow.
		@param parent An optional parent `h2d.Object` instance to which ObjectFollower adds itself if set.
	**/
	public function new( obj, ?parent ) {
		super(parent);
		this.follow = obj;
	}

	function followObject() {
		if( follow == null ) {
			if ( autoRemove )
				remove();
			return;
		}
		var scene = @:privateAccess follow.getScene();
		if( scene == null ) {
			if ( autoRemove )
				remove();
			return;
		}
		var camera = scene.getRenderCamera();
		var s2d = getScene();
		var width = s2d == null ? h3d.Engine.getCurrent().width : s2d.width;
		var height = s2d == null ? h3d.Engine.getCurrent().height : s2d.height;
		var absPos = follow.getAbsPos();
		var pos = new h3d.Vector();
		if( cameraRelative ) {
			var m = new h3d.Matrix();
			inline m.load(camera.mcam);
			inline m.transpose();
			var tmp = new h3d.Vector(offsetX, offsetZ, offsetY);
			tmp.transform3x3(m);
			pos.set(absPos._41 + tmp.x, absPos._42 + tmp.y, absPos._43 + tmp.z);
		} else {
			pos.set(absPos._41 + offsetX, absPos._42 + offsetY, absPos._43 + offsetZ);
		}
		var p = camera.project(pos.x, pos.y, pos.z, width * outputScale, height * outputScale, tmpPos);
		zValue = p.z;

		if( horizontalAlign != Left || verticalAlign != Top ) {
			if( tmpSize == null ) tmpSize = new h2d.col.Bounds();
			var prev = follow;
			follow = null;
			var b = getSize(tmpSize); // prevent recursive
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

		if( depthBias != 0 ) {
			var move = camera.pos.sub(pos).normalized();
			pos.x += move.x * depthBias;
			pos.y += move.y * depthBias;
			pos.z += move.z * depthBias;
			var p2 = camera.project(pos.x, pos.y, pos.z, width, height, tmpPos);
			zValue = p2.z;
		}
	}

	override function calcAbsPos() {
		super.calcAbsPos();
		absX = x;
		absY = y;
	}

	override function syncPos() {
		if( follow == null ) {
			if( posChanged ) {
				calcAbsPos();
				for( c in children )
					c.posChanged = true;
				posChanged = false;
			}
			return;
		}
		followObject();
		super.syncPos();
	}

	override function sync(ctx) {
		followObject();
		super.sync(ctx);
	}

	override function drawRec(ctx:RenderContext) {

		if( !visible || zValue < 0 || zValue > 1 )
			return;
		if( followVisibility ) {
			var parent = follow;
			while(parent != null) {
				if( !parent.visible )
					return;
				parent = parent.parent;
			}
		}

		if( !depthMask ) @:privateAccess {
			var prev = ctx.baseShader.zValue;
			ctx.baseShader.zValue = zValue;
			super.drawRec(ctx);
			ctx.baseShader.zValue = prev;
			return;
		}

		@:privateAccess {
			var scene = follow.getScene();
			var camera = scene.getRenderCamera();
			var wantedMode : h3d.mat.Data.Compare = camera.reverseDepth ? GreaterEqual : LessEqual;
			var prev = ctx.baseShader.zValue;
			var prevMode = ctx.pass.depthTest, prevWrite = ctx.pass.depthWrite, prevClamp = ctx.pass.depthClamp;
			if( prevMode != wantedMode ) {
				ctx.pass.depth(true, wantedMode, prevClamp);
				ctx.engine.selectMaterial(ctx.pass);
			}
			ctx.baseShader.zValue = zValue;
			super.drawRec(ctx);
			ctx.baseShader.zValue = prev;
			if( prevMode != wantedMode ) {
				ctx.pass.depth(prevWrite, prevMode, prevClamp);
				ctx.engine.selectMaterial(ctx.pass);
			}
		}
	}

}