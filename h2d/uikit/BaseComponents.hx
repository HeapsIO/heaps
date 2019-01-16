package h2d.uikit;

class Drawable<T:h2d.Drawable> extends Component<T> {

	override function handleProp(o:T, p:Property):Bool {
		switch( p ) {
		case PColor(r,g,b,a):
			o.color.set(r,g,b,a);
		case PSmooth(v):
			o.smooth = v;
		case PTileWrap(v):
			o.tileWrap = v;
		default:
			return super.handleProp(o, p);
		}
		return true;
	}

}

class Bitmap extends Drawable<h2d.Bitmap> {

	public function new() {
		super("bitmap",h2d.Bitmap,function(p) return new h2d.Bitmap(h2d.Tile.fromColor(0xFF00FF,16,16),p));
	}

	override function handleProp(o:h2d.Bitmap, p:Property):Bool {
		switch( p ) {
		case PSource(res):
			o.tile = res.toTile();
			return true;
		default:
		}
		return super.handleProp(o, p);
	}

	static var inst = new Bitmap();

}

class Flow extends Component<h2d.Flow> {

	public function new() {
		super("flow",h2d.Flow,function(p) return new h2d.Flow(p));
	}

	override function handleProp(o:h2d.Flow, p:Property):Bool {
		switch( p ) {
		case PWidth(c,v):
			switch( c ) {
			case Whole:
				o.minWidth = o.maxWidth = v;
			case Min:
				o.minWidth = v;
			case Max:
				o.maxWidth = v;
			}
		case PHeight(c,v):
			switch( c ) {
			case Whole:
				o.minHeight = o.maxHeight = v;
			case Min:
				o.minHeight = v;
			case Max:
				o.maxHeight = v;
			}
		case PPadding(top, right, bottom, left):
			o.paddingTop = top;
			o.paddingRight = right;
			o.paddingBottom = bottom;
			o.paddingLeft = left;
		case PPaddingDir(dir, value):
			switch( dir ) {
			case Left: o.paddingLeft = value;
			case Right: o.paddingRight = value;
			case Top: o.paddingTop = value;
			case Bottom: o.paddingBottom = value;
			}
		case PBackground(t, borderW, borderH):
			o.backgroundTile = t;
			if( borderW != null ) o.borderWidth = borderW;
			if( borderH != null ) o.borderHeight = borderH;
		case PDebug(b):
			o.debug = b;
		default:
			return super.handleProp(o,p);
		}
		return true;
	}

	static var inst = new Flow();

}
