package h2d;

enum FlowAlign {
	Top;
	Left;
	Right;
	Middle;
	Bottom;
	Absolute;
}

class FlowProperties {

	public var paddingLeft = 0;
	public var paddingTop = 0;
	public var paddingRight = 0;
	public var paddingBottom = 0;

	public var align : Null<FlowAlign>;

	public var offsetX = 0;
	public var offsetY = 0;

	public var minWidth : Null<Int>;
	public var minHeight : Null<Int>;

	public var calculatedWidth : Float = 0.;
	public var calculatedHeight : Float = 0.;

	public function new() {
	}

}

class Flow extends Sprite {

	static var tmpBounds = new h2d.col.Bounds();

	/**
		If some sub element gets resized, you need to set reflow to true in order to force
		the reflow of elements. You can also directly call reflow() which will immediately
		update all elements positions.

		If a reflow is needed, reflow() will be called before rendering the flow.
		Each change in one of the flow properties or addition/removal of elements will set needReflow to true.
	**/
	public var needReflow : Bool = true;
	public var align(default,set) : FlowAlign = Bottom;

	public var minWidth(default, set) : Null<Int>;
	public var minHeight(default, set) : Null<Int>;
	public var maxWidth(default, set) : Null<Int>;
	public var maxHeight(default, set) : Null<Int>;

	public var lineHeight(default, set) : Null<Int>;
	public var colWidth(default, set) : Null<Int>;

	/**
		Will set all padding values at the same time.
	**/
	public var padding(never, set) : Int;
	public var paddingLeft(default, set) : Int = 0;
	public var paddingRight(default, set) : Int = 0;
	public var paddingTop(default, set) : Int = 0;
	public var paddingBottom(default, set) : Int = 0;

	/**
		The horizontal space between two flowed elements.
	**/
	public var horitontalSpacing(default, set) : Int = 0;

	/**
		The vertical space between two flowed elements.
	**/
	public var verticalSpacing(default, set) : Int = 0;

	/**
		Set enableInteractive to true to create an h2d.Interactive accessible through
		the interactive field which will automatically cover the whole Flow area.
	**/
	public var enableInteractive(default, set) : Bool;

	/**
		See enableInteractive.
	**/
	public var interactive(default, null) : h2d.Interactive;

	/**
		Setting a background tile will create a ScaleGrid background which uses the borderWidth/Height values for its borders.
		It will automatically resize when the reflow is done to cover the whole Flow area.
	**/
	public var backgroundTile(default, set) : h2d.Tile;
	public var borderWidth(default, set) : Int = 0;
	public var borderHeight(default, set) : Int = 0;

	/**
		By default, elements will be flowed horizontaly, then in several lines if maxWidth is reached.
		You can instead flow them vertically, then to next column is maxHeight is reached by setting the isVertical flag to true.
	**/
	public var isVertical(default, set) : Bool;

	/**
		When isInline is set to true, the flow size will be reported based on the size of the elements instead of their bounds.
		This is useful if you want to include flows in other flows while keeping the text aligned.
	**/
	public var isInline = false;

	var background : h2d.ScaleGrid;
	var properties : Array<FlowProperties> = [];

	var calculatedWidth : Float = 0.;
	var calculatedHeight : Float = 0.;

	public function new(?parent) {
		super(parent);
	}

	/**
		Get the per-element properties. Returns null if the element is not currently part of the flow.
	**/
	public function getProperties( e : h2d.Sprite ) {
		needReflow = true; // properties might be changed
		return properties[getChildIndex(e)];
	}

	function set_isVertical(v) {
		if( isVertical == v )
			return v;
		needReflow = true;
		return isVertical = v;
	}

	function set_align(v) {
		if( align == v )
			return v;
		needReflow = true;
		return align = v;
	}

	function set_lineHeight(v) {
		if( lineHeight == v )
			return v;
		needReflow = true;
		return lineHeight = v;
	}

	function set_colWidth(v) {
		if( colWidth == v )
			return v;
		needReflow = true;
		return colWidth = v;
	}

	function set_padding(v) {
		paddingLeft = v;
		paddingTop = v;
		paddingRight = v;
		paddingBottom = v;
		return v;
	}

	function get_calculatedWidth() {
		if( needReflow ) reflow();
		return calculatedWidth;
	}

	function get_calculatedHeight() {
		if( needReflow ) reflow();
		return calculatedHeight;
	}

	function set_paddingLeft(v) {
		if( paddingLeft == v ) return v;
		needReflow = true;
		if( background != null ) background.borderWidth = paddingLeft;
		return paddingLeft = v;
	}

	function set_paddingRight(v) {
		if( paddingRight == v ) return v;
		needReflow = true;
		return paddingRight = v;
	}

	function set_paddingTop(v) {
		if( paddingTop == v ) return v;
		needReflow = true;
		if( background != null ) background.borderHeight = paddingTop;
		return paddingTop = v;
	}

	function set_paddingBottom(v) {
		if( paddingBottom == v ) return v;
		needReflow = true;
		return paddingBottom = v;
	}

	override function getBoundsRec( relativeTo, out, forSize ) {
		if( needReflow ) reflow();
		if( forSize ) {
			if( !isInline )
				super.getBoundsRec(relativeTo, out, false);
			else if( calculatedWidth != 0 )
				addBounds(relativeTo, out, 0, 0, calculatedWidth, calculatedHeight);
		} else
			super.getBoundsRec(relativeTo, out, forSize);
	}

	override function addChildAt( s, pos ) {
		if( background != null ) pos++;
		var fp = getProperties(s);
		super.addChildAt(s, pos);
		if( fp == null ) fp = new FlowProperties() else properties.remove(fp);
		properties.insert(pos, fp);
		needReflow = true;
	}

	override public function removeChild(s:Sprite) {
		var index = getChildIndex(s);
		super.removeChild(s);
		if( index >= 0 ) {
			needReflow = true;
			properties.splice(index, 1);
		}
	}

	override function sync(ctx:RenderContext) {
		if( needReflow ) reflow();
		super.sync(ctx);
	}

	function set_maxWidth(w) {
		if( maxWidth == w )
			return w;
		needReflow = true;
		return maxWidth = w;
	}

	function set_maxHeight(h) {
		if( maxHeight == h )
			return h;
		needReflow = true;
		return maxHeight = h;
	}

	function set_minWidth(w) {
		if( minWidth == w )
			return w;
		needReflow = true;
		return minWidth = w;
	}

	function set_minHeight(h) {
		if( minHeight == h )
			return h;
		needReflow = true;
		return minHeight = h;
	}

	function set_horitontalSpacing(s) {
		if( horitontalSpacing == s )
			return s;
		needReflow = true;
		return horitontalSpacing = s;
	}

	function set_verticalSpacing(s) {
		if( verticalSpacing == s )
			return s;
		needReflow = true;
		return verticalSpacing = s;
	}

	function set_enableInteractive(b) {
		if( enableInteractive == b )
			return b;
		if( b ) {
			if( interactive == null ) {
				interactive = new h2d.Interactive(0, 0, this);
				properties[properties.length - 1].align = Absolute;
				if( !needReflow ) {
					interactive.width = calculatedWidth;
					interactive.height = calculatedHeight;
				}
			}
		} else {
			if( interactive != null ) {
				interactive.remove();
				interactive = null;
			}
		}
		return enableInteractive = b;
	}

	function set_backgroundTile(t) {
		if( backgroundTile == t )
			return t;
		if( t != null ) {
			if( background == null ) {
				var background = new h2d.ScaleGrid(t, borderWidth, borderHeight);
				addChildAt(background, 0);
				properties[0].align = Absolute;
				this.background = background;
				if( !needReflow ) {
					background.width = Math.ceil(calculatedWidth);
					background.height = Math.ceil(calculatedHeight);
				}
			}
			background.tile = t;
		} else {
			if( background != null ) {
				background.remove();
				background = null;
			}
		}
		return t;
	}

	function set_borderWidth(v) {
		if( borderWidth == v )
			return v;
		if( background != null ) background.borderWidth = v;
		needReflow = true;
		return borderWidth = v;
	}

	function set_borderHeight(v) {
		if( borderHeight == v )
			return v;
		if( background != null ) background.borderHeight = v;
		needReflow = true;
		return borderHeight = v;
	}

	/**
		Call to force all flowed elements position to be updated.
		See needReflow for more informations.
	**/
	public function reflow() {

		var cw, ch;
		if( !isVertical ) {

			var startX = paddingLeft + borderWidth;
			var x : Float = startX;
			var y : Float = paddingTop + borderHeight;
			cw = x;
			var maxLineHeight = 0.;
			var tmpBounds = tmpBounds;
			var maxWidth = maxWidth == null ? 100000000 : maxWidth - (paddingLeft + paddingRight + borderWidth * 2);
			var lastIndex = 0;

			inline function alignLine( maxIndex ) {
				var lineHeight = this.lineHeight == null ? maxLineHeight : lineHeight;
				for( i in lastIndex...maxIndex ) {
					var c = childs[i];
					var p = properties[i];
					var a = p.align != null ? p.align : align;
					switch( a ) {
					case Bottom:
						c.y += lineHeight - p.calculatedHeight;
					case Middle:
						c.y += Std.int((lineHeight - p.calculatedHeight) * 0.5);
					default:
					}
				}
				lastIndex = maxIndex;
			}

			for( i in 0...childs.length ) {
				var c = childs[i];
				var p = properties[i];

				if( p.align == Absolute ) continue;

				var b = c.getSize(tmpBounds);
				p.calculatedWidth = b.xMax + p.paddingLeft + p.paddingRight;
				p.calculatedHeight = b.yMax + p.paddingTop + p.paddingBottom;
				if( p.minWidth != null && p.calculatedWidth < p.minWidth ) p.calculatedWidth = p.minWidth;
				if( p.minHeight != null && p.calculatedHeight < p.minHeight ) p.calculatedHeight = p.minHeight;

				if( x + p.calculatedWidth > maxWidth && x > startX ) {
					alignLine(i);
					y += maxLineHeight + verticalSpacing;
					maxLineHeight = 0;
					x = startX;
				}

				c.x = x + p.offsetX + p.paddingLeft;
				c.y = y + p.offsetY + p.paddingTop;

				x += p.calculatedWidth;
				if( x > cw ) cw = x;
				x += horitontalSpacing;
				if( p.calculatedHeight > maxLineHeight ) maxLineHeight = p.calculatedHeight;
			}
			alignLine(childs.length);
			cw += paddingRight + borderWidth;
			ch = y + maxLineHeight + paddingBottom + borderHeight;
		} else {

			var startY = paddingTop + borderHeight;
			var y : Float = startY;
			var x : Float = paddingLeft + borderWidth;
			ch = y;
			var maxColWidth = 0.;
			var tmpBounds = tmpBounds;
			var maxHeight = maxHeight == null ? 100000000 : maxHeight - (paddingTop + paddingBottom + borderHeight * 2);
			var lastIndex = 0;

			inline function alignLine( maxIndex ) {
				var colWidth = this.colWidth == null ? maxColWidth : colWidth;
				for( i in lastIndex...maxIndex ) {
					var c = childs[i];
					var p = properties[i];
					var a = p.align != null ? p.align : align;
					switch( a ) {
					case Right:
						c.x += colWidth - p.calculatedWidth;
					case Middle:
						c.x += Std.int((colWidth - p.calculatedWidth) * 0.5);
					default:
					}
				}
				lastIndex = maxIndex;
			}

			for( i in 0...childs.length ) {
				var c = childs[i];
				var p = properties[i];

				if( p.align == Absolute ) continue;

				// use getBounds instead of getSize for vertical align
				var b = c.getBounds(this, tmpBounds);

				p.calculatedWidth = b.xMax - c.x + p.paddingLeft + p.paddingRight;
				p.calculatedHeight = b.yMax - c.y + p.paddingTop + p.paddingBottom;
				if( p.minWidth != null && p.calculatedWidth < p.minWidth ) p.calculatedWidth = p.minWidth;
				if( p.minHeight != null && p.calculatedHeight < p.minHeight ) p.calculatedHeight = p.minHeight;

				if( y + p.calculatedHeight > maxHeight && y > startY ) {
					alignLine(i);
					x += maxColWidth + horitontalSpacing;
					maxColWidth = 0;
					y = startY;
				}

				c.x = x + p.offsetX + p.paddingLeft;
				c.y = y + p.offsetY + p.paddingTop;

				y += p.calculatedHeight;
				if( y > ch ) ch = y;
				y += verticalSpacing;
				if( p.calculatedWidth > maxColWidth ) maxColWidth = p.calculatedWidth;
			}
			alignLine(childs.length);
			ch += paddingTop + borderHeight;
			cw = x + maxColWidth + paddingRight + borderWidth;
		}

		if( minWidth != null && cw < minWidth ) cw = minWidth;
		if( minHeight != null && ch < minHeight ) ch = minHeight;

		if( interactive != null ) {
			interactive.width = cw;
			interactive.height = ch;
		}

		if( background != null ) {
			background.width = Math.ceil(cw);
			background.height = Math.ceil(ch);
		}

		calculatedWidth = cw;
		calculatedHeight = ch;
		needReflow = false;
		onReflow();
	}

	/**
		Called each time a reflow() was done.
	**/
	public dynamic function onReflow() {
	}

}