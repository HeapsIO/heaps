package h2d;

class Camera extends h2d.Object {

	/** X position of the camera anchor point. **/
	public var viewX(get, set) : Float;
	/** Y position of the camera anchor point. **/
	public var viewY(get, set) : Float;

	/** Current camera width. Cannot be set directly, please use `horizontalRatio`. **/
	public var width(default, null) : Int;
	/** Current camera height. Cannot be set directly, please use `verticalRatio`. **/
	public var height(default, null) : Int;
	/** Percent value of horizontal camera size relative to s2d size. (default : 1) **/
	public var horizontalRatio(default, set) : Float;
	/** Percent value of vertical camera size relative to s2d size. (default : 1) **/
	public var verticalRatio(default, set) : Float;
	/** Horizontal anchor position inside ratio boundaries used for anchoring and resize compensation. ( default : 0.5 ) **/
	public var anchorX(default, set) : Float;
	/** Vertical anchor position inside ratio boundaries used for anchoring and resize compensation. ( default : 0.5 ) **/
	public var anchorY(default, set) : Float;

	public var zoom(get, set) : Float;

	var ratioChanged : Bool;
	var sceneWidth : Int;
	var sceneHeight : Int;
	var anchorWidth : Float;
	var anchorHeight : Float;
	var scene : Scene;

	public function new( ?parent : h2d.Object, horizontalRatio : Float = 1, verticalRatio : Float = 1, anchorX : Float = 0.5, anchorY : Float = 0.5 ) {
		super(parent);
		this.horizontalRatio = horizontalRatio;
		this.verticalRatio = verticalRatio;
		this.anchorX = anchorX;
		this.anchorY = anchorY;
		this.width = 0; this.height = 0;
		this.anchorWidth = 0; this.anchorHeight = 0;
		this.sceneWidth = 0; this.sceneHeight = 0;
		ratioChanged = true;
		if ( parent != null ) {
			initScene();
		}
	}

	inline function get_viewX() { return -this.x + anchorWidth; }
	inline function get_viewY() { return -this.y + anchorHeight; }

	inline function set_viewX( v : Float ) {
		this.x = anchorWidth - v;
		return v;
	}
	inline function set_viewY( v : Float ) {
		this.y = anchorHeight - v;
		return v;
	}

	inline function set_horizontalRatio( v ) {
		ratioChanged = true;
		return horizontalRatio = hxd.Math.clamp(v, 0, 1);
	}
	
	inline function set_verticalRatio( v ) {
		ratioChanged = true;
		return verticalRatio = hxd.Math.clamp(v, 0, 1);
	}

	inline function set_anchorX( v ) {
		anchorX = hxd.Math.clamp(v, 0, 1);
		anchorWidth = sceneWidth * anchorX;
		return anchorX;
	}

	inline function set_anchorY( v ) {
		anchorY = hxd.Math.clamp(v, 0, 1);
		anchorHeight = sceneHeight * anchorY;
		return anchorY;
	}

	inline function get_zoom() { return scaleX; }

	inline function set_zoom( v : Float ) {
		var d = v / zoom;
		setScale(v);
		viewX *= d;
		viewY *= d;
		return v;
	}

	override private function onAdd()
	{
		initScene();
		super.onAdd();
	}

	override private function onRemove()
	{
		this.scene = null;
		super.onRemove();
	}

	override private function sync( ctx : RenderContext )
	{
		if ( scene != null && (ratioChanged || scene.width != sceneWidth || scene.height != sceneHeight) ) {
			var oldX = viewX;
			var oldY = viewY;
			this.sceneWidth = scene.width;
			this.sceneHeight = scene.height;
			this.width = Math.round(scene.width * horizontalRatio);
			this.height = Math.round(scene.height * verticalRatio);
			this.anchorWidth = width * anchorX;
			this.anchorHeight = height * anchorY;
			this.viewX = oldX;
			this.viewY = oldY;
			this.ratioChanged = false;
		}
		super.sync(ctx);
	}

	inline function initScene() {
		this.scene = parent.getScene();
		if ( scene != parent ) throw "Camera can be added only to Scene or MultiCamera!";
		if ( sceneWidth == 0 )
		{
			sceneWidth = scene.width;
			sceneHeight = scene.height;
			anchorWidth = sceneWidth * anchorX;
			anchorHeight = sceneHeight * anchorY;
		}
	}

}