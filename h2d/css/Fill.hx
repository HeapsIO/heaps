package h2d.css;
import h2d.css.Defs;

class Fill extends h2d.TileGroup {

	public function new(?parent) {
		super(h2d.Tile.fromColor(0xFFFFFF), parent);
	}

	public inline function fillRectColor(x, y, w, h, c) {
		content.rectColor(x, y, w, h, c);
	}

	public inline function fillRectGradient(x, y, w, h, ctl, ctr, cbl, cbr) {
		content.rectGradient(x, y, w, h, ctl, ctr, cbl, cbr);
	}

	public inline function addPoint(x, y, color) {
		content.addPoint(x, y, color);
	}

	public function fillRect(fill:FillStyle,x,y,w,h) {
		switch( fill ) {
		case Transparent:
		case Color(c):
			fillRectColor(x,y,w,h,c);
		case Gradient(a,b,c,d):
			fillRectGradient(x,y,w,h,a,b,c,d);
		}
	}

	inline function clerp(c1:Int,c2:Int,v:Float) {
		var a = Std.int( (c1>>>24) * (1-v) + (c2>>>24) * v );
		var r = Std.int( ((c1>>16)&0xFF) * (1-v) + ((c2>>16)&0xFF) * v );
		var g = Std.int( ((c1>>8)&0xFF) * (1-v) + ((c2>>8)&0xFF) * v );
		var b = Std.int( (c1&0xFF) * (1-v) + (c2&0xFF) * v );
		return (a << 24) | (r << 16) | (g << 8) | b;
	}

	public function lineRect(fill:FillStyle, x:Float, y:Float, w:Float, h:Float, size:Float) {
		if( size <= 0 ) return;
		switch( fill ) {
		case Transparent:
		case Color(c):
			fillRectColor(x,y,w,size,c);
			fillRectColor(x,y+h-size,w,size,c);
			fillRectColor(x,y+size,size,h-size*2,c);
			fillRectColor(x+w-size,y+size,size,h-size*2,c);
		case Gradient(a,b,c,d):
			var px = size / w;
			var py = size / h;
			var a2 = clerp(a,c,py);
			var b2 = clerp(b,d,py);
			var c2 = clerp(a,c,1-py);
			var d2 = clerp(b,d,1-py);
			fillRectGradient(x,y,w,size,a,b,a2,b2);
			fillRectGradient(x,y+h-size,w,size,c2,d2,c,d);
			fillRectGradient(x,y+size,size,h-size*2,a2,clerp(a2,b2,px),c2,clerp(c2,d2,px));
			fillRectGradient(x+w-size,y+size,size,h-size*2,clerp(a2,b2,1-px),b2,clerp(c2,d2,1-px),d2);
		}
	}

}
