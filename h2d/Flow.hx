package h2d;

/**
	`Flow` content alignment rules.
**/
enum FlowAlign {
	/**
		Aligns children to the top edge of the `Flow`.

		Only applicable to the `Flow.verticalAlign`.
	**/
	Top;
	/**
		Aligns children to the left edge of the `Flow`.

		Only applicable to the `Flow.horizontalAlign`.
	**/
	Left;
	/**
		Aligns children to the right edge of the `Flow`.

		Only applicable to the `Flow.horizontalAlign`.
	**/
	Right;
	/**
		Aligns children to the center of the `Flow`.
	**/
	Middle;
	/**
		Aligns children to the bottom edge of the `Flow`.

		Only applicable to the `Flow.verticalAlign`.
	**/
	Bottom;
}

/**
	The `Flow.layout` type.
**/
enum FlowLayout {
	/**
		Children are aligned horizontally from left to right (or right to left when `Flow.reverse` is enabled).
		
		If `Flow.multiline` is enabled - children can overflow to the next row if there is not enough space available within the Flow size constraints.

		`Flow.lineHeight` can be used to set a fixed row height when `Flow.overflow` is set to `Limit` or `Hidden`.
		Objects with height that exceed the limitation will be aligned according to `Flow.verticalAlign` value vertically with `null` being treated as `Bottom`.
	**/
	Horizontal;
	/**
		Children are aligned vertically from top to bottom (or bottom to top when `Flow.reverse` is enabled).

		If `Flow.multiline` is enabled - children can overflow to the next column if there is not enough space available within the Flow size constraints.

		`Flow.colWidth` can be used to set a fixed column width when `Flow.overflow` is set to `Limit` or `Hidden`.
		Objects with height that exceed the limitation will be aligned according to `Flow.horizontalAlign` value horizontally with `null` being treated as `Left`.
	**/
	Vertical;
	/**
		Children are aligned independently (`Flow.reverse` has no effect).
	**/
	Stack;
}

/**
	The `Flow.overflow` rules.
**/
enum FlowOverflow {
	/**
		Children larger than `Flow.maxWidth` / `Flow.maxHeight` will expand the flow size.
	**/
	Expand;
	/**
		Limits the bounds reported by the flow using `Flow.maxWidth` or `Flow.maxHeight`, if set.

		Children larger than max size will draw outside of the Flow bounds or overflow if `Flow.multiline` is enabled.
	**/
	Limit;
	/**
		Limits the bounds reported by the flow using `maxWidth` or `maxHeight`, if set.

		Compared to `Limit` - Flow will mask out the content that is outside of Flow bounds.
	**/
	Hidden;
	// TODO: Scroll overflow, see #606
	//Scroll;
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
	public var lineBreak = false;

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
		if( a ) {
			@:privateAccess elt.constraintSize( -1, -1); // remove constraint
			isBreak = false;
		}
		return isAbsolute = a;
	}

}

/**
	An automatic layout system.
**/
class Flow extends Object {

	var tmpBounds = new h2d.col.Bounds();

	/**
		If some sub element gets resized, you need to set reflow to true in order to force
		the reflow of elements. You can also directly call `Flow.reflow` which will immediately
		update all elements positions.

		If a reflow is needed, `Flow.reflow` will be called before rendering the flow.
		Each change in one of the flow properties or addition/removal of elements will set needReflow to true.
	**/
	public var needReflow(default, set) : Bool = true;

	/**
		Horizontal alignment of elements inside the flow.
		See `FlowAlign` for more details.
	**/
	public var horizontalAlign(default, set) : Null<FlowAlign>;

	/**
		Vertical alignment of elements inside the flow.
		See `FlowAlign` for more details.
	**/
	public var verticalAlign(default,set) : Null<FlowAlign>;

	/**
		Ensures that Flow is at least the specified outer width at all times when not null.
	**/
	public var minWidth(default, set) : Null<Int>;
	/**
		Ensures that Flow is at least the specified outer height at all times when not null.
	**/
	public var minHeight(default, set) : Null<Int>;
	/**
		Attempts to limit the Flow outer width to the specified width.
		Used as a baseline for overflow when `Flow.multiline` is enabled and `Flow.layout` is `Horizontal`.
	**/
	public var maxWidth(default, set) : Null<Int>;
	/**
		Attempts to limit the Flow outer height to the specified height.
		Used as a baseline for overflow when `Flow.multiline` is enabled and `Flow.layout` is `Vertical`.
	**/
	public var maxHeight(default, set) : Null<Int>;

	/**
		Sets the minimum row height when `Flow.layout` is `Horizontal`.
	**/
	public var lineHeight(default, set) : Null<Int>;
	/**
		Sets the minimum colum width when `Flow.layout` is `Vertical`.
	**/
	public var colWidth(default, set) : Null<Int>;

	/**
		Enabling overflow will treat maxWidth/maxHeight and lineHeight/colWidth constraints as absolute : bigger elements will overflow instead of expanding the limit.
		See respective `FlowOverflow` values for more details.
	**/
	public var overflow(default, set) : FlowOverflow = Expand;

	/**
		Will set all padding values at the same time.
	**/
	public var padding(never, set) : Int;
	/**
		Will set `Flow.paddingLeft` and `Flow.paddingRight` to the given value.
	**/
	public var paddingHorizontal(never, set) : Int;
	/**
		Will set `Flow.paddingTop` and `Flow.paddingBottom` to the given value.
	**/
	public var paddingVertical(never, set) : Int;
	/**
		Sets the extra padding along the left edge of the Flow.

		Note that padding is applied inside the flow boundaries and included in the size constraint, shrinking available space for Flow children.
	**/
	public var paddingLeft(default, set) : Int = 0;
	/**
		Sets the extra padding along the right edge of the Flow.

		Note that padding is applied inside the flow boundaries and included in the size constraint, shrinking available space for Flow children.
	**/
	public var paddingRight(default, set) : Int = 0;
	/**
		Sets the extra padding along the top edge of the Flow.

		Note that padding is applied inside the flow boundaries and included in the size constraint, shrinking available space for Flow children.
	**/
	public var paddingTop(default, set) : Int = 0;
	/**
		Sets the extra padding along the bottom edge of the Flow.

		Note that padding is applied inside the flow boundaries and included in the size constraint, shrinking available space for Flow children.
	**/
	public var paddingBottom(default, set) : Int = 0;

	/**
		The horizontal separation spacing between two flowed elements.
	**/
	public var horizontalSpacing(default, set) : Int = 0;

	/**
		The vertical separation spacing between two flowed elements.
	**/
	public var verticalSpacing(default, set) : Int = 0;

	/**
		Adds an `h2d.Interactive` to the Flow that is accessible through `Flow.interactive` field.
		This Interactive is automatically resized to cover the whole Flow area.

		Flow is added as bottom most (after the `Flow.backgroundTile`) child as to not impede flow elements with Interactives.
	**/
	public var enableInteractive(default, set) : Bool;

	/**
		See `Flow.enableInteractive`.
	**/
	public var interactive(default, null) : h2d.Interactive;

	/**
		Setting a background tile will create an `h2d.ScaleGrid` background which uses the `Flow.borderWidth`/`Flow.borderHeigh` values for its borders.
		It will automatically resize when the reflow is done to cover the whole Flow area.
	**/
	public var backgroundTile(default, set) : h2d.Tile;
	/**
		Adds extra padding on left and right edge of the Flow.
		Uses same constraint limitations as padding. Used for ScaleGrid configuration, see `Flow.backgroundTile`.
	**/
	public var borderWidth(default, set) : Int = 0;
	/**
		Adds extra padding on top and bottom edge of the Flow.
		Uses same constraint limitations as padding. Used for ScaleGrid configuration, see `Flow.backgroundTile`.
	**/
	public var borderHeight(default, set) : Int = 0;

	/**
		Calculate the client width, which is the inner size of the flow without the borders and padding.
	**/
	public var innerWidth(get, never) : Int;
	/**
		Calculate the client height, which is the inner size of the flow without the borders and padding.
	**/
	public var innerHeight(get, never) : Int;

	/**
		Flow total width (includes borders and paddings)
	**/
	public var outerWidth(get, never) : Int;
	/**
		Flow total height (includes borders and paddings)
	**/
	public var outerHeight(get, never) : Int;

	/**
		The Flow item layout rules.
		See `FlowLayout` for specific details on each mode.
	**/
	public var layout(default, set) : FlowLayout = Horizontal;

	@:deprecated("isVertical is replaced by layout=Vertical")
	@:dox(hide)
	public var isVertical(get, set) : Bool;

	/**
		When isInline is set to false, the flow size will be reported based on its bounds instead of its calculated size.
		See `Object.getSize` documentation.
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
	public var reverse(default,set) : Bool = false;

	/**
		When set to true, if a width constraint is present and `minWidth` is null, will expand to fill all the available horizontal space
	**/

	public var fillWidth(default,set) : Bool = false;
	/**
		When set to true, if a height constraint is present and `minHeight` is null, will expand to fill all the available vertical space
	**/
	public var fillHeight(default,set) : Bool = false;

	var background : h2d.ScaleGrid;
	var debugGraphics : h2d.Graphics;
	var properties : Array<FlowProperties> = [];

	var calculatedWidth : Float = 0.;
	var calculatedHeight : Float = 0.;
	var constraintWidth : Float = -1;
	var constraintHeight : Float = -1;
	var realMaxWidth : Float = -1;
	var realMaxHeight : Float = -1;
	var realMinWidth : Int = -1;
	var realMinHeight : Int = -1;
	var isConstraint : Bool;

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

	function set_layout(v) {
		if(layout == v)
			return v;
		needReflow = true;
		return layout = v == null ? Horizontal : v;
	}

	function get_isVertical() {
		return layout == Vertical;
	}

	function set_isVertical(v) {
		layout = v ? Vertical : Horizontal;
		return v;
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

	function set_fillWidth(v) {
		if( fillWidth == v )
			return v;
		needReflow = true;
		return fillWidth = v;
	}

	function set_fillHeight(v) {
		if( fillHeight == v )
			return v;
		needReflow = true;
		return fillHeight = v;
	}

	override function constraintSize( width, height ) {
		constraintWidth = width;
		constraintHeight = height;
		isConstraint = true;
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
		switch (layout) {
			case Horizontal:
				if( last >= 0 )
					properties[last].paddingRight += v;
				else
					paddingLeft += v;

			case Vertical:
				if( last >= 0 )
					properties[last].paddingBottom += v;
				else
					paddingTop += v;
			case Stack:
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
		// break propagation
	}

	override function addChildAt( s, pos ) {
		if( background != null ) pos++;
		if( interactive != null ) pos++;
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
		if( !isConstraint && (fillWidth || fillHeight) ) {
			var scene = ctx.scene;
			if( scene.width != constraintWidth || scene.height != constraintHeight ) needReflow = true;
		}
		if( needReflow ) reflow();
		super.sync(ctx);
	}

	override function drawRec(ctx:RenderContext)
	{
		if ( overflow == Hidden ) {
			if ( posChanged ) {
				calcAbsPos();
				for ( c in children )
					c.posChanged = true;
				posChanged = false;
			}
			Mask.maskWith(ctx, this, hxd.Math.imax(outerWidth, maxWidth), hxd.Math.imax(outerHeight, maxHeight), 0, 0);
			super.drawRec(ctx);
			Mask.unmask(ctx);
		} else {
			super.drawRec(ctx);
		}
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

		var oldW = realMinWidth, oldH = realMinHeight;
		realMinWidth = if( minWidth == null && fillWidth ) Math.ceil(constraintWidth) else if( minWidth != null ) minWidth else -1;
		realMinHeight = if( minHeight == null && fillHeight ) Math.ceil(constraintHeight) else if( minHeight != null ) minHeight else -1;
		if(realMinWidth != oldW || realMinHeight != oldH)
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
				var interactive = new h2d.Interactive(0, 0);
				addChildAt(interactive,0);
				this.interactive = interactive;
				interactive.cursor = Default;
				getProperties(interactive).isAbsolute = true;
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
				getProperties(background).isAbsolute = true;
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
		See needReflow for more information.
	**/
	public function reflow() {

		onBeforeReflow();

		if( !isConstraint && (fillWidth || fillHeight) ) {
			var scene = getScene();
			if( scene.width != constraintWidth || scene.height != constraintHeight ) {
				constraintSize(fillWidth ? scene.width : -1, fillHeight ? scene.height : -1);
				isConstraint = false;
			}
		}

		var isConstraintWidth = realMaxWidth >= 0;
		var isConstraintHeight = realMaxHeight >= 0;
		// outer size
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
		switch(layout) {
		case Horizontal:
			var halign = horizontalAlign == null ? Left : horizontalAlign;
			var valign = verticalAlign == null ? Bottom : verticalAlign;

			var startX = paddingLeft + borderWidth;
			var x = startX;
			var y = paddingTop + borderHeight;
			cw = x;
			var maxLineHeight = 0;
			var minLineHeight = this.lineHeight != null ? lineHeight : (this.realMinHeight >= 0 && !multiline) ? (this.realMinHeight - (paddingTop + paddingBottom + borderHeight * 2)) : 0;
			var lastIndex = 0;

			inline function alignLine( maxIndex ) {
				if( maxLineHeight < minLineHeight )
					maxLineHeight = minLineHeight;
				else if( overflow != Expand && minLineHeight != 0 )
					maxLineHeight = minLineHeight;
				for( i in lastIndex...maxIndex ) {
					var p = propAt(i);
					if( p.isAbsolute && p.verticalAlign == null ) continue;
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
				var isAbs = p.isAbsolute;
				if( isAbs && p.horizontalAlign == null && p.verticalAlign == null ) continue;
				var c = childAt(i);
				if( !c.visible ) continue;

				var pw = p.paddingLeft + p.paddingRight;
				var ph = p.paddingTop + p.paddingBottom;
				if( !isAbs )
					c.constraintSize(
						isConstraintWidth && p.constraint ? (maxInWidth - pw) / Math.abs(c.scaleX) : -1,
						isConstraintHeight && p.constraint ? (maxInHeight - ph) / Math.abs(c.scaleX) : -1
					);

				var b = c.getSize(tmpBounds);
				var br = false;
				p.calculatedWidth = Math.ceil(b.xMax) + pw;
				p.calculatedHeight = Math.ceil(b.yMax) + ph;
				if( p.minWidth != null && p.calculatedWidth < p.minWidth ) p.calculatedWidth = p.minWidth;
				if( p.minHeight != null && p.calculatedHeight < p.minHeight ) p.calculatedHeight = p.minHeight;

				if( isAbs ) continue;

				if( ((multiline && x - startX + p.calculatedWidth > maxInWidth) || p.lineBreak) && x - startX > 0 ) {
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
			if( realMinWidth >= 0 && cw < realMinWidth ) cw = realMinWidth;
			var endX = cw - (paddingRight + borderWidth);
			var xmin = startX, xmax = endX;
			var midSpace = 0, curAlign = null;
			for( i in 0...children.length ) {
				var p = propAt(i);
				var c = childAt(i);
				if( !c.visible ) continue;
				if( p.isAbsolute ) {
					switch( p.horizontalAlign ) {
					case null:
					case Right:
						c.x = endX - p.calculatedWidth + p.offsetX;
					case Left:
						c.x = startX + p.offsetX;
					case Middle:
						c.x = startX + Std.int((endX - startX - p.calculatedWidth) * 0.5) + p.offsetX + startX;
					default:
					}
					continue;
				}
				if( p.isBreak ) {
					xmin = startX;
					xmax = endX;
					midSpace = 0;
				}
				var px;
				var align = p.horizontalAlign == null ? halign : p.horizontalAlign;
				if( curAlign != align ) {
					curAlign = align;
					midSpace = 0;
				}
				switch( align ) {
				case Right:
					if( midSpace == 0 ) {
						var remSize = p.calculatedWidth + remSize(i + 1);
						midSpace = (xmax - xmin) - remSize;
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
					px = xmin;
					xmin += p.calculatedWidth + horizontalSpacing;
				}
				c.x = px + p.offsetX + p.paddingLeft;
				if( p.isAbsolute ) xmin = px;
			}

		case Vertical:
			var halign = horizontalAlign == null ? Left : horizontalAlign;
			var valign = verticalAlign == null ? Top : verticalAlign;

			var startY = paddingTop + borderHeight;
			var y = startY;
			var x = paddingLeft + borderWidth;
			ch = y;
			var maxColWidth = 0;
			var minColWidth = this.colWidth != null ? colWidth : (this.realMinWidth >= 0 && !multiline) ? (this.realMinWidth - (paddingLeft + paddingRight + borderWidth * 2)) : 0;
			var lastIndex = 0;

			inline function alignLine( maxIndex ) {
				if( maxColWidth < minColWidth )
					maxColWidth = minColWidth;
				else if( overflow != Expand && minColWidth != 0 )
					maxColWidth = minColWidth;
				for( i in lastIndex...maxIndex ) {
					var p = propAt(i);
					if( p.isAbsolute && p.horizontalAlign == null ) continue;
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
				var isAbs = p.isAbsolute;
				if( isAbs && p.horizontalAlign == null && p.verticalAlign == null ) continue;

				var c = childAt(i);
				if( !c.visible ) continue;

				var pw = p.paddingLeft + p.paddingRight;
				var ph = p.paddingTop + p.paddingBottom;
				if( !isAbs )
					c.constraintSize(
						isConstraintWidth && p.constraint ? (maxInWidth - pw) / Math.abs(c.scaleX) : -1,
						isConstraintHeight && p.constraint ? (maxInHeight - ph) / Math.abs(c.scaleY) : -1
					);

				var b = c.getSize(tmpBounds);
				var br = false;

				p.calculatedWidth = Math.ceil(b.xMax) + pw;
				p.calculatedHeight = Math.ceil(b.yMax) + ph;
				if( p.minWidth != null && p.calculatedWidth < p.minWidth ) p.calculatedWidth = p.minWidth;
				if( p.minHeight != null && p.calculatedHeight < p.minHeight ) p.calculatedHeight = p.minHeight;

				if( isAbs ) continue;

				if( ((multiline && y - startY + p.calculatedHeight > maxInHeight) || p.lineBreak) && y - startY > 0 ) {
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
			if( realMinHeight >= 0 && ch < realMinHeight ) ch = realMinHeight;
			var endY : Int = ch - (paddingBottom + borderHeight);
			var ymin = startY, ymax = endY;
			var midSpace = 0, curAlign = null;
			for( i in 0...children.length ) {
				var p = propAt(i);
				var c = childAt(i);
				if( !c.visible )
					continue;
				if( p.isAbsolute ) {
					switch( p.verticalAlign ) {
					case null:
					case Bottom:
						c.y = endY - p.calculatedHeight + p.offsetY;
					case Top:
						c.y = startY + p.offsetY;
					case Middle:
						c.y = startY + Std.int((endY - startY - p.calculatedHeight) * 0.5) + p.offsetY + startY;
					default:
					}
					continue;
				}
				if( p.isBreak ) {
					ymin = startY;
					ymax = endY;
					midSpace = 0;
				}
				var py;
				var align = p.verticalAlign == null ? valign : p.verticalAlign;
				if( curAlign != align ) {
					curAlign = align;
					midSpace = 0;
				}
				switch( align ) {
				case Bottom:
					if( midSpace == 0 ) {
						var remSize = p.calculatedHeight + remSize(i + 1);
						midSpace = (ymax - ymin) - remSize;
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
					py = ymin;
					ymin += p.calculatedHeight + verticalSpacing;
				}
				c.y = py + p.offsetY + p.paddingTop;
			}
		case Stack:
			var halign = horizontalAlign == null ? Left : horizontalAlign;
			var valign = verticalAlign == null ? Top : verticalAlign;

			var maxChildW = 0;
			var maxChildH = 0;

			for( i in 0...children.length ) {
				var c = childAt(i);
				if( !c.visible ) continue;
				var p = propAt(i);
				var isAbs = p.isAbsolute;
				if( isAbs && p.verticalAlign == null && p.horizontalAlign == null ) continue;

				if( !isAbs )
					c.constraintSize(
						isConstraintWidth && p.constraint ? maxInWidth / Math.abs(c.scaleX) : -1,
						isConstraintHeight && p.constraint ? maxInHeight / Math.abs(c.scaleY) : -1
					);

				var b = c.getSize(tmpBounds);
				p.calculatedWidth = Math.ceil(b.xMax) + p.paddingLeft + p.paddingRight;
				p.calculatedHeight = Math.ceil(b.yMax) + p.paddingTop + p.paddingBottom;
				if( p.minWidth != null && p.calculatedWidth < p.minWidth ) p.calculatedWidth = p.minWidth;
				if( p.minHeight != null && p.calculatedHeight < p.minHeight ) p.calculatedHeight = p.minHeight;
				if( isAbs ) continue;
				if( p.calculatedWidth > maxChildW ) maxChildW = p.calculatedWidth;
				if( p.calculatedHeight > maxChildH ) maxChildH = p.calculatedHeight;
			}

			var xmin = paddingLeft + borderWidth;
			var ymin = paddingTop + borderHeight;
			var xmax = if(realMaxWidth > 0 && overflow != Expand) Math.floor(realMaxWidth - (paddingRight + borderWidth))
				else hxd.Math.imax(xmin + maxChildW, realMinWidth - (paddingRight + borderWidth));
			var ymax = if(realMaxWidth > 0 && overflow != Expand) Math.floor(realMaxHeight - (paddingBottom + borderHeight))
				else hxd.Math.imax(ymin + maxChildH, realMinHeight - (paddingBottom + borderHeight));
			cw = xmax + paddingRight + borderWidth;
			ch = ymax + paddingBottom + borderHeight;

			for( i in 0...children.length ) {
				var c = childAt(i);
				if( !c.visible ) continue;
				var p = propAt(i);
				var isAbs = p.isAbsolute;
				if( isAbs && p.verticalAlign == null && p.horizontalAlign == null ) continue;

				var valign = p.verticalAlign == null ? valign : p.verticalAlign;
				var halign = p.horizontalAlign == null ? halign : p.horizontalAlign;

				var px = switch( halign ) {
				case Right:
					xmax - p.calculatedWidth;
				case Middle:
					xmin + Std.int(((xmax - xmin) - p.calculatedWidth) * 0.5);
				default:
					xmin;
				}

				var py = switch( valign ) {
				case Bottom:
					ymax - p.calculatedHeight;
				case Middle:
					ymin + Std.int(((ymax - ymin) - p.calculatedHeight) * 0.5);
				default:
					ymin;
				}

				if( !isAbs || p.horizontalAlign != null )
					c.x = px + p.offsetX + p.paddingLeft;
				if( !isAbs || p.verticalAlign != null )
					c.y = py + p.offsetY + p.paddingTop;
			}
		}

		if( realMinWidth >= 0 && cw < realMinWidth ) cw = realMinWidth;
		if( realMinHeight >= 0 && ch < realMinHeight ) ch = realMinHeight;
		if( overflow != Expand ) {
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
		Sent at the start of the `reflow()`.
	**/
	public dynamic function onBeforeReflow() {
	}

	/**
		Sent after the `reflow()` was finished.
	**/
	public dynamic function onAfterReflow() {
	}

}