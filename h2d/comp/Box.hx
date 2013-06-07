package h2d.comp;

class Box extends Component {
	
	public function new(?layout,?parent) {
		super("box", parent);
		if( layout == null ) layout = h2d.css.Defs.Layout.Horizontal;
		addClass(":"+layout.getName().toLowerCase());
	}
	
	override function resizeRec( ctx : Context ) {
		var extX = extLeft();
		var extY = extTop();
		var ctx2 = new Context(0, 0);
		ctx2.measure = ctx.measure;
		if( ctx.measure ) {
			width = ctx.maxWidth;
			height = ctx.maxHeight;
			if( style.width != null ) width = style.width;
			if( style.height != null ) height = style.height;
			contentWidth = width - (extX + extRight());
			contentHeight = height - (extY + extBottom());
		} else {
			ctx2.xPos = ctx.xPos;
			ctx2.yPos = ctx.yPos;
			if( ctx2.xPos == null ) ctx2.xPos = 0;
			if( ctx2.yPos == null ) ctx2.yPos = 0;
			resize(ctx2);
		}
		switch( style.layout ) {
		case Horizontal:
			var lineHeight = 0.;
			var xPos = 0., yPos = 0., maxPos = 0.;
			var prev = null;
			for( c in components ) {
				if( ctx.measure ) {
					ctx2.xPos = xPos;
					ctx2.yPos = yPos;
					ctx2.maxWidth = contentWidth;
					ctx2.maxHeight = contentHeight - yPos;
					c.resizeRec(ctx2);
					var next = xPos + c.width;
					if( prev != null ) next += style.horizontalSpacing;
					if( xPos > 0 && next > contentWidth ) {
						yPos += lineHeight + style.verticalSpacing;
						xPos = c.width;
						lineHeight = c.height;
					} else {
						xPos = next;
						if( c.height > lineHeight ) lineHeight = c.height;
					}
					if( xPos > maxPos ) maxPos = xPos;
				} else {
					var next = xPos + c.width;
					if( xPos > 0 && next > contentWidth ) {
						yPos += lineHeight + style.verticalSpacing;
						xPos = 0;
						lineHeight = c.height;
					} else {
						if( c.height > lineHeight ) lineHeight = c.height;
					}
					ctx2.xPos = xPos;
					ctx2.yPos = yPos;
					c.resizeRec(ctx2);
					xPos += c.width + style.horizontalSpacing;
				}
				prev = c;
			}
			if( ctx.measure ) {
				if( maxPos < contentWidth ) contentWidth = maxPos;
				if( yPos + lineHeight < contentHeight ) contentHeight = yPos + lineHeight;
			}
		case Vertical:
			var colWidth = 0.;
			var xPos = 0., yPos = 0., maxPos = 0.;
			var prev = null;
			for( c in components ) {
				if( ctx.measure ) {
					ctx2.xPos = xPos;
					ctx2.yPos = yPos;
					ctx2.maxWidth = ctx.maxWidth - xPos;
					ctx2.maxHeight = contentHeight;
					c.resizeRec(ctx2);
					var next = yPos + c.height;
					if( prev != null ) next += style.verticalSpacing;
					if( yPos > 0 && next > contentHeight ) {
						xPos += colWidth + style.horizontalSpacing;
						yPos = c.height;
						colWidth = c.width;
					} else {
						yPos = next;
						if( c.width > colWidth ) colWidth = c.width;
					}
					if( yPos > maxPos ) maxPos = yPos;
				} else {
					var next = yPos + c.height;
					if( yPos > 0 && next > contentHeight ) {
						xPos += colWidth + style.horizontalSpacing;
						yPos = 0;
						colWidth = c.width;
					} else {
						if( c.width > colWidth ) colWidth = c.width;
					}
					ctx2.xPos = xPos;
					ctx2.yPos = yPos;
					c.resizeRec(ctx2);
					yPos += c.height + style.verticalSpacing;
				}
				prev = c;
			}
			if( ctx.measure ) {
				if( xPos + colWidth < contentWidth ) contentWidth = xPos + colWidth;
				if( maxPos < contentHeight ) contentHeight = maxPos;
			}
		case Absolute:
			var oldx = ctx.xPos, oldy = ctx.yPos;
			ctx.xPos = null;
			ctx.yPos = null;
			for( c in components )
				c.resizeRec(ctx);
			ctx.xPos = oldx;
			ctx.yPos = oldy;
		}
		if( ctx.measure ) {
			width = contentWidth + extX + extRight();
			height = contentHeight + extY + extBottom();
		}
	}
	
	
}