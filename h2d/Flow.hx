package h2d;

enum FlowAlign {
	Top;
	Left;
	Right;
	Middle;
	Bottom;
}

@:allow(h2d.Flow)
class FlowProperties {

	var elt : Object;

	public var paddingLeft = 0;
	public var paddingTop = 0;
	public var paddingRight = 0;
	public var paddingBottom = 0;

	public var isAbsolute(default,set) = false;
	public var horizontalAlign : Null<FlowAlign>;
	public var verticalAlign : Null<FlowAlign>;

	public var offsetX = 0;
	public var offsetY = 0;

	public var minWidth : Null<Int>;
	public var minHeight : Null<Int>;

	public var calculatedWidth(default,null) : Int = 0;
	public var calculatedHeight(default,null) : Int = 0;

	public var isBreak(default,null) : Bool;

	/**
		If our flow have a maximum size, it will constraint the children by using .constraintSize()
	**/
	public var constraint = true;

	public function new(elt) {
		this.elt = elt;
	}

	public inline function align(vertical, horizontal) {
		this.verticalAlign = vertical;
		this.horizontalAlign = horizontal;
	}

	function set_isAbsolute(a) {
		if( a ) @:privateAccess elt.constraintSize( -1, -1); // remove constraint
		return isAbsolute = a;
	}

}

class Flow extends Object {

	var tmpBounds = new h2d.col.Bounds();

	/**
		If some sub element gets resized, you need to set reflow to true in order to force
		the reflow of elements. You can also directly call reflow() which will immediately
		update all elements positions.

		If a reflow is needed, reflow() will be called before rendering the flow.
		Each change in one of the flow properties or addition/removal of elements will set needReflow to true.
	**/
	public var needReflow(default, set) : Bool = true;

	/**
		Horizontal alignment of elements inside the flow.
	**/
	public var horizontalAlign(default, set) : Null<FlowAlign>;

	/**
		Vertical alignment of elements inside the flow.
	**/
	public var verticalAlign(default,set) : Null<FlowAlign>;

	public var minWidth(default, set) : Null<Int>;
	public var minHeight(default, set) : Null<Int>;
	public var maxWidth(default, set) : Null<Int>;
	public var maxHeight(default, set) : Null<Int>;

	public var lineHeight(default, set) : Null<Int>;
	public var colWidth(default, set) : Null<Int>;

	/**
		Enabling overflow will treat maxWidth/maxHeight and lineHeight/colWidth constraints as absolute : bigger elements will overflow instead of expanding the limit.
	**/
	public var overflow(default, set) : Bool = false;

	/**
		Will set all padding values at the same time.
	**/
	public var padding(never, set) : Int;
	public var paddingHorizontal(never, set) : Int;
	public var paddingVertical(never, set) : Int;
	public var paddingLeft(default, set) : Int = 0;
	public var paddingRight(default, set) : Int = 0;
	public var paddingTop(default, set) : Int = 0;
	public var paddingBottom(default, set) : Int = 0;

	/**
		The horizontal space between two flowed elements.
	**/
	public var horizontalSpacing(default, set) : Int = 0;

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
		Calculate the client width, which is the innner size of the flow without the borders and padding.
	**/
	public var innerWidth(get, never) : Int;
	/**
		Calculate the client height, which is the innner size of the flow without the borders and padding.
	**/
	public var innerHeight(get, never) : Int;

	/**
		Flow total width (inlcudes borders and paddings)
	**/
	public var outerWidth(get, never) : Int;
	/**
		Flow total height (inlcudes borders and paddings)
	**/
	public var outerHeight(get, never) : Int;

	/**
		By default, elements will be flowed horizontaly, then in several lines if maxWidth is reached.
		You can instead flow them vertically, then to next column is maxHeight is reached by setting the isVertical flag to true.
	**/
	public var isVertical(default, set) : Bool;

	/**
		When isInline is set to false, the flow size will be reported based on its bounds instead of its calculated size.
		See getSize() documentation.
	**/
	public var isInline = true;

	/**
		When set to true, the debug will display red box around the flow, green box for the client space and blue boxes for each element.
	**/
	public var debug(default, set) : Bool;

	/**
		When set to true, uses specified lineHeight/colWidth instead of maxWidth/maxHeight for alignment.
	**/
	public var multiline(default,set) : Bool = false;

	/**
		When set to true, children are aligned in reverse order
	**/
	public var reverse(default,set) : Bool = true;

	var background : h2d.ScaleGrid;
	var debugGraphics : h2d.Graphics;
	var properties : Array<FlowProperties> = [];

	var calculatedWidth : Float = 0.;
	var calculatedHeight : Float = 0.;
	var constraintWidth : Float = -1;
	var constraintHeight : Float = -1;
	var realMaxWidth : Float = -1;
	var realMaxHeight : Float = -1;

	public function new(?parent) {
		super(parent);
	}

	/**
		Get the per-element properties. Returns null if the element is not currently part of the flow.
	**/
	public function getProperties( e : h2d.Object ) {
		needReflow = true; // properties might be changed
		return properties[getChildIndex(e)];
	}

	function set_isVertical(v) {
		if( isVertical == v )
			return v;
		needReflow = true;
		return isVertical = v;
	}

	function set_horizontalAlign(v) {
		if( horizontalAlign == v )
			return v;
		needReflow = true;
		return horizontalAlign = v;
	}

	function set_debug(v) {
		if( debug == v )
			return v;
		needReflow = true;
		if( v ) {
			debugGraphics = new h2d.Graphics(this);
			getProperties(debugGraphics).isAbsolute = true;
		} else {
			debugGraphics.remove();
			debugGraphics = null;
		}
		return debug = v;
	}

	function set_verticalAlign(v) {
		if( verticalAlign == v )
			return v;
		needReflow = true;
		return verticalAlign = v;
	}

	function set_overflow(v) {
		if( overflow == v )
			return v;
		needReflow = true;
		return overflow = v;
	}

	function set_multiline(v) {
		if( multiline == v )
			return v;
		needReflow = true;
		return multiline = v;
	}

	function set_reverse(v) {
		if( reverse == v )
			return v;
		needReflow = true;
		return reverse = v;
	}

	function set_needReflow(v) {
		if( needReflow == v )
			return v;
		if( v )
			onContentChanged();
		return needReflow = v;
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

	inline function set_paddingHorizontal(v) {
		paddingLeft = v;
		paddingRight = v;
		return v;
	}

	inline function set_paddingVertical(v) {
		paddingTop = v;
		paddingBottom = v;
		return v;
	}

	function get_outerWidth() {
		if( needReflow ) reflow();
		return Math.ceil(calculatedWidth);
	}

	function get_outerHeight() {
		if( needReflow ) reflow();
		return Math.ceil(calculatedHeight);
	}

	function get_innerWidth() {
		if( needReflow ) reflow();
		return Math.ceil(calculatedWidth) - (paddingLeft + paddingRight + borderWidth * 2);
	}

	function get_innerHeight() {
		if( needReflow ) reflow();
		return Math.ceil(calculatedHeight) - (paddingTop + paddingBottom + borderHeight * 2);
	}

	function set_paddingLeft(v) {
		if( paddingLeft == v ) return v;
		needReflow = true;
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
		return paddingTop = v;
	}

	function set_paddingBottom(v) {
		if( paddingBottom == v ) return v;
		needReflow = true;
		return paddingBottom = v;
	}

	override function constraintSize( width, height ) {
		constraintWidth = width;
		constraintHeight = height;
		updateConstraint();
	}

	override function contentChanged( s : Object ) {
		while( s.parent != this )
			s = s.parent;
		if( getProperties(s).isAbsolute )
			return;
		needReflow = true;
		onContentChanged();
	}

	/**
		Adds some spacing by either increasing the padding of the latest
		non absolute element or the padding of the flow if no element was found.
		The padding affected depends on the isVertical property.
	**/
	public function addSpacing( v : Int ) {
		var last = properties.length - 1;
		while( last >= 0 && properties[last].isAbsolute )
			last--;
		if( isVertical ) {
			if( last >= 0 )
				properties[last].paddingBottom += v;
			else
				paddingTop += v;
		} else {
			if( last >= 0 )
				properties[last].paddingRight += v;
			else
				paddingLeft += v;
		}
	}

	override function getBoundsRec( relativeTo, out, forSize ) {
		if( needReflow ) reflow();
		if( forSize ) {
			if( !isInline )
				super.getBoundsRec(relativeTo, out, true);
			if( calculatedWidth != 0 ) {
				if( posChanged ) {
					calcAbsPos();
					for( c in children )
						c.posChanged = true;
					posChanged = false;
				}
				addBounds(relativeTo, out, 0, 0, calculatedWidth, calculatedHeight);
			}
		} else
			super.getBoundsRec(relativeTo, out, forSize);
	}

	override function setParentContainer(c) {
		parentContainer = c;
		// break propogation
	}

	override function addChildAt( s, pos ) {
		if( background != null ) pos++;
		var fp = getProperties(s);
		super.addChildAt(s, pos);
		if( fp == null ) fp = new FlowProperties(s) else properties.remove(fp);
		properties.insert(pos, fp);
		needReflow = true;
		s.setParentContainer(this);
	}

	override public function removeChild(s:Object) {
		var index = getChildIndex(s);
		super.removeChild(s);
		if( index >= 0 ) {
			needReflow = true;
			properties.splice(index, 1);
			s.constraintSize( -1, -1); // remove constraint
		}
		if( s != null ) {
			if( s == background )
				backgroundTile = null;
			if( s == interactive )
				enableInteractive = false;
		}
	}

	override function removeChildren() {
		var k = 0;
		while( numChildren>k ) {
			var c = getChildAt(k);
			if( c == background || c == interactive || c == debugGraphics ) k++; else removeChild(c);
		}
	}

	override function sync(ctx:RenderContext) {
		if( needReflow ) reflow();
		super.sync(ctx);
	}

	function set_maxWidth(w) {
		if( maxWidth == w )
			return w;
		maxWidth = w;
		updateConstraint();
		return w;
	}

	function set_maxHeight(h) {
		if( maxHeight == h )
			return h;
		maxHeight = h;
		updateConstraint();
		return h;
	}

	function updateConstraint() {
		var oldW = realMaxWidth, oldH = realMaxHeight;
		realMaxWidth = if( maxWidth == null ) constraintWidth else if( constraintWidth < 0 ) maxWidth else hxd.Math.min(maxWidth, constraintWidth);
		realMaxHeight = if( maxHeight == null ) constraintHeight else if( constraintHeight < 0 ) maxHeight else hxd.Math.min(maxHeight, constraintHeight);
		if( minWidth != null && realMaxWidth < minWidth && realMaxWidth >= 0 )
			realMaxWidth = minWidth;
		if( minHeight != null && realMaxHeight < minHeight && realMaxWidth >= 0 )
			realMaxHeight = minHeight;
		if( realMaxWidth != oldW || realMaxHeight != oldH )
			needReflow = true;
	}

	function set_minWidth(w) {
		if( minWidth == w )
			return w;
		needReflow = true;
		minWidth = w;
		updateConstraint();
		return w;
	}

	function set_minHeight(h) {
		if( minHeight == h )
			return h;
		needReflow = true;
		minHeight = h;
		updateConstraint();
		return h;
	}

	function set_horizontalSpacing(s) {
		if( horizontalSpacing == s )
			return s;
		needReflow = true;
		return horizontalSpacing = s;
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
				interactive.cursor = Default;
				properties[properties.length - 1].isAbsolute = true;
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
				properties[0].isAbsolute = true;
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
		return backgroundTile = t;
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

		onBeforeReflow();

		var isConstraintWidth = realMaxWidth >= 0;
		var isConstraintHeight = realMaxHeight >= 0;
		// outter size
		var maxTotWidth = realMaxWidth < 0 ? 100000000 : Math.floor(realMaxWidth);
		var maxTotHeight = realMaxHeight < 0 ? 100000000 : Math.floor(realMaxHeight);
		// inner size
		var maxInWidth = maxTotWidth - (paddingLeft + paddingRight + borderWidth * 2);
		var maxInHeight = maxTotHeight - (paddingTop + paddingBottom + borderHeight * 2);

		if( debug )
			debugGraphics.clear();

		inline function childAt(i: Int) {
			return children[ reverse ? children.length - i - 1 : i ];
		}
		inline function propAt(i: Int) {
			return properties[ reverse ? children.length - i - 1 : i ];
		}

		var cw, ch;
		if( !isVertical ) {
			var halign = horizontalAlign == null ? Left : horizontalAlign;
			var valign = verticalAlign == null ? Bottom : verticalAlign;

			var startX = paddingLeft + borderWidth;
			var x = startX;
			var y = paddingTop + borderHeight;
			cw = x;
			var maxLineHeight = 0;
			var minLineHeight = this.lineHeight != null ? lineHeight : (this.minHeight != null && !multiline) ? (this.minHeight - (paddingTop + paddingBottom + borderHeight * 2)) : 0;
			var lastIndex = 0;

			inline function alignLine( maxIndex ) {
				if( maxLineHeight < minLineHeight )
					maxLineHeight = minLineHeight;
				else if( overflow && minLineHeight != 0 )
					maxLineHeight = minLineHeight;
				for( i in lastIndex...maxIndex ) {
					var p = propAt(i);
					if( p.isAbsolute ) continue;
					var c = childAt(i);
					if( !c.visible ) continue;
					var a = p.verticalAlign != null ? p.verticalAlign : valign;
					c.y = y + p.offsetY + p.paddingTop;
					switch( a ) {
					case Bottom:
						c.y += maxLineHeight - Std.int(p.calculatedHeight);
					case Middle:
						c.y += Std.int((maxLineHeight - p.calculatedHeight) * 0.5);
					default:
					}
				}
				lastIndex = maxIndex;
			}

			inline function remSize(from: Int) {
				var size = 0;
				for( j in from...children.length ) {
					var p = propAt(j);
					if( p.isAbsolute || !childAt(j).visible ) continue;
					if( p.isBreak ) break;
					size += horizontalSpacing + p.calculatedWidth;
				}
				return size;
			}

			for( i in 0...children.length ) {
				var p = propAt(i);
				if( p.isAbsolute ) continue;
				var c = childAt(i);
				if( !c.visible ) continue;

				c.constraintSize(
					isConstraintWidth && p.constraint ? maxInWidth / Math.abs(c.scaleX) : -1,
					isConstraintHeight && p.constraint ? maxInHeight / Math.abs(c.scaleX) : -1
				);

				var b = c.getSize(tmpBounds);
				var br = false;
				p.calculatedWidth = Math.ceil(b.xMax) + p.paddingLeft + p.paddingRight;
				p.calculatedHeight = Math.ceil(b.yMax) + p.paddingTop + p.paddingBottom;
				if( p.minWidth != null && p.calculatedWidth < p.minWidth ) p.calculatedWidth = p.minWidth;
				if( p.minHeight != null && p.calculatedHeight < p.minHeight ) p.calculatedHeight = p.minHeight;
				if( multiline && x - startX + p.calculatedWidth > maxInWidth && x - startX > 0 ) {
					br = true;
					alignLine(i);
					y += maxLineHeight + verticalSpacing;
					maxLineHeight = 0;
					x = startX;
				}
				p.isBreak = br;
				x += p.calculatedWidth;
				if( x > cw ) cw = x;
				x += horizontalSpacing;
				if( p.calculatedHeight > maxLineHeight ) maxLineHeight = p.calculatedHeight;
			}
			alignLine(children.length);
			cw += paddingRight + borderWidth;
			ch = y + maxLineHeight + paddingBottom + borderHeight;

			// horizontal align
			if( minWidth != null && cw < minWidth ) cw = minWidth;
			var endX = cw - (paddingRight + borderWidth);
			var xmin = startX, xmax = endX;
			var midSpace = 0;
			for( i in 0...children.length ) {
				var p = propAt(i);
				if( p.isAbsolute || !childAt(i).visible ) continue;
				if( p.isBreak ) {
					xmin = startX;
					xmax = endX;
					midSpace = 0;
				}
				var px;
				var align = p.horizontalAlign == null ? halign : p.horizontalAlign;
				switch( align ) {
				case Right:
					if( midSpace == 0 ) {
						var remSize = p.calculatedWidth + remSize(i + 1);
						midSpace = xmax - remSize;
						xmin += midSpace;
					}
					px = xmin;
					xmin += p.calculatedWidth + horizontalSpacing;
				case Middle:
					if( midSpace == 0 ) {
						var remSize = p.calculatedWidth + remSize(i + 1);
						midSpace = Std.int(((xmax - xmin) - remSize) * 0.5);
						xmin += midSpace;
					}
					px = xmin;
					xmin += p.calculatedWidth + horizontalSpacing;
				default:
					if( midSpace != 0 ) {
						xmin += midSpace;
						midSpace = 0;
					}
					px = xmin;
					xmin += p.calculatedWidth + horizontalSpacing;
				}
				childAt(i).x = px + p.offsetX + p.paddingLeft;
			}

		} else {

			var halign = horizontalAlign == null ? Left : horizontalAlign;
			var valign = verticalAlign == null ? Top : verticalAlign;

			var startY = paddingTop + borderHeight;
			var y = startY;
			var x = paddingLeft + borderWidth;
			ch = y;
			var maxColWidth = 0;
			var minColWidth = this.colWidth != null ? colWidth : (this.minWidth != null && !multiline) ? (this.minWidth - (paddingLeft + paddingRight + borderWidth * 2)) : 0;
			var lastIndex = 0;

			inline function alignLine( maxIndex ) {
				if( maxColWidth < minColWidth )
					maxColWidth = minColWidth;
				else if( overflow && minColWidth != 0 )
					maxColWidth = minColWidth;
				for( i in lastIndex...maxIndex ) {
					var p = propAt(i);
					if( p.isAbsolute ) continue;
					var c = childAt(i);
					if( !c.visible ) continue;
					var a = p.horizontalAlign != null ? p.horizontalAlign : halign;
					c.x = x + p.offsetX + p.paddingLeft;
					switch( a ) {
					case Right:
						c.x += maxColWidth - p.calculatedWidth;
					case Middle:
						c.x += Std.int((maxColWidth - p.calculatedWidth) * 0.5);
					default:
					}
				}
				lastIndex = maxIndex;
			}

			inline function remSize(from: Int) {
				var size = 0;
				for( j in from...children.length ) {
					var p = propAt(j);
					if( p.isAbsolute || !childAt(j).visible ) continue;
					if( p.isBreak ) break;
					size += verticalSpacing + p.calculatedHeight;
				}
				return size;
			}

			for( i in 0...children.length ) {
				var p = propAt(i);
				if( p.isAbsolute ) continue;

				var c = childAt(i);
				if( !c.visible ) continue;

				c.constraintSize(
					isConstraintWidth && p.constraint ? maxInWidth / Math.abs(c.scaleX) : -1,
					isConstraintHeight && p.constraint ? maxInHeight / Math.abs(c.scaleY) : -1
				);

				var b = c.getSize(tmpBounds);
				var br = false;

				p.calculatedWidth = Math.ceil(b.xMax) + p.paddingLeft + p.paddingRight;
				p.calculatedHeight = Math.ceil(b.yMax) + p.paddingTop + p.paddingBottom;
				if( p.minWidth != null && p.calculatedWidth < p.minWidth ) p.calculatedWidth = p.minWidth;
				if( p.minHeight != null && p.calculatedHeight < p.minHeight ) p.calculatedHeight = p.minHeight;

				if( multiline && y - startY + p.calculatedHeight > maxInHeight && y - startY > 0 ) {
					br = true;
					alignLine(i);
					x += maxColWidth + horizontalSpacing;
					maxColWidth = 0;
					y = startY;
				}
				p.isBreak = br;
				c.y = y + p.offsetY + p.paddingTop;
				y += p.calculatedHeight;
				if( y > ch ) ch = y;
				y += verticalSpacing;
				if( p.calculatedWidth > maxColWidth ) maxColWidth = p.calculatedWidth;
			}
			alignLine(children.length);
			ch += paddingBottom + borderHeight;
			cw = x + maxColWidth + paddingRight + borderWidth;


			// vertical align
			if( minHeight != null && ch < minHeight ) ch = minHeight;
			var endY : Int = ch - (paddingBottom + borderHeight);
			var ymin = startY, ymax = endY;
			var midSpace = 0;
			for( i in 0...children.length ) {
				var p = propAt(i);
				if( p.isAbsolute || !childAt(i).visible ) continue;
				if( p.isBreak ) {
					ymin = startY;
					ymax = endY;
					midSpace = 0;
				}
				var py;
				var align = p.verticalAlign == null ? valign : p.verticalAlign;
				switch( align ) {
				case Bottom:
					if( midSpace == 0 ) {
						var remSize = p.calculatedHeight + remSize(i + 1);
						midSpace = ymax - remSize;
						ymin += midSpace;
					}
					py = ymin;
					ymin += p.calculatedHeight + verticalSpacing;
				case Middle:
					if( midSpace == 0 ) {
						var remSize = p.calculatedHeight + remSize(i + 1);
						midSpace = Std.int(((ymax - ymin) - remSize) * 0.5);
						ymin += midSpace;
					}
					py = ymin;
					ymin += p.calculatedHeight + verticalSpacing;
				default:
					if( midSpace != 0 ) {
						ymin += midSpace;
						midSpace = 0;
					}
					py = ymin;
					ymin += p.calculatedHeight + verticalSpacing;
				}
				childAt(i).y = py + p.offsetY + p.paddingTop;
			}
		}

		if( minWidth != null && cw < minWidth ) cw = minWidth;
		if( minHeight != null && ch < minHeight ) ch = minHeight;
		if( overflow ) {
			if( isConstraintWidth && cw > maxTotWidth ) cw = maxTotWidth;
			if( isConstraintHeight && ch > maxTotHeight ) ch = maxTotHeight;
		}

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

		if( debug ) {
			if( debugGraphics != children[children.length - 1] ) {
				addChild(debugGraphics); // always on-top
				needReflow = false;
			}
			if( paddingLeft != 0 || paddingRight != 0 || paddingTop != 0 || paddingBottom != 0 || borderWidth != 0 || borderHeight != 0 ) {
				debugGraphics.lineStyle(1, 0x00FF00);
				debugGraphics.drawRect(paddingLeft + borderWidth, paddingTop + borderHeight, innerWidth, innerHeight);
			}
			debugGraphics.lineStyle(1, 0x0080FF);
			for( i in 0...children.length ) {
				var p = propAt(i);
				var c = childAt(i);
				if( p.isAbsolute || !c.visible ) continue;
				debugGraphics.drawRect(c.x, c.y, p.calculatedWidth, p.calculatedHeight);
			}
			debugGraphics.lineStyle(1, 0xFF0000);
			debugGraphics.drawRect(0, 0, cw, ch);
		}

		onAfterReflow();
	}

	/**
		Called before each reflow() is done.
	**/
	public dynamic function onBeforeReflow() {
	}

	/**
		Called after each time a reflow() was done.
	**/
	public dynamic function onAfterReflow() {
	}

}