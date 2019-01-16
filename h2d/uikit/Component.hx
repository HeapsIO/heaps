package h2d.uikit;

class Component<T:h2d.Object> {

	public var name : String;
	public var cl : Class<T>;
	public var make : h2d.Object -> T;

	public function new(name, cl,make) {
		this.name = name;
		this.cl = cl;
		this.make = make;
		COMPONENTS.set(name, this);
	}

	function getFlowParent( o : T ) {
		return Std.instance(o.parent, h2d.Flow);
	}

	public function handleProp( o : T, p : Property ) : Bool {
		switch( p ) {
		case PName(name):
			o.name = name;
		case PPosition(x, y):
			if( x != null ) o.x = x;
			if( y != null ) o.y = y;
		case PScale(sx, sy):
			if( sx != null ) o.scaleX = sx;
			if( sy != null ) o.scaleY = sy;
		case PRotation(v):
			o.rotation = v;
		case PAlpha(v):
			o.alpha = v;
		case PBlend(mode):
			o.blendMode = mode;
		case PVisible(b):
			o.visible = b;
		case PMargin(left,right,top,bottom):
			var parent = getFlowParent(o);
			if( parent != null ) {
				var props = parent.getProperties(o);
				props.paddingLeft = left;
				props.paddingRight = right;
				props.paddingTop = top;
				props.paddingBottom = bottom;
			}
		case PMarginDir(dir, v):
			var parent = getFlowParent(o);
			if( parent != null ) {
				var props = parent.getProperties(o);
				switch( dir ) {
				case Left: props.paddingLeft = v;
				case Right: props.paddingRight = v;
				case Top: props.paddingTop = v;
				case Bottom: props.paddingBottom = v;
				}
			}
		default:
			return false;
		}
		return true;
	}

	public static function get( name : String ) {
		return COMPONENTS.get(name);
	}

	static var COMPONENTS = new Map<String,Component<Dynamic>>();
	static var inst = new Component("object",h2d.Object,h2d.Object.new);

}
