package h2d.comp;

class Box extends Component {
	
	public function new(vertical=false,?parent) {
		super("box", parent);
		if( vertical ) addClass("vertical");
	}
	
	override function resizeRec( r : CssDefs.Resize ) {
		var extX = style.paddingLeft + style.borderSize;
		var extY = style.paddingTop + style.borderSize;
		var r2 = new CssDefs.Resize(0, 0);
		r2.measure = r.measure;
		if( r.measure ) {
			width = r.maxWidth;
			height = r.maxHeight;
			if( style.width != null ) width = style.width;
			if( style.height != null ) height = style.height;
			contentWidth = width - (extX + style.paddingRight + style.borderSize);
			contentHeight = height - (extY + style.paddingBottom + style.borderSize);
		} else {
			r2.maxWidth = r.maxWidth;
			r2.maxHeight = r.maxHeight;
			r2.xPos = r.xPos;
			r2.yPos = r.yPos;
			if( r2.xPos == null ) r2.xPos = 0;
			if( r2.yPos == null ) r2.yPos = 0;
			resize(r2);
		}
		switch( style.layout ) {
		case Horizontal:
			var lineHeight = 0.;
			var xPos = 0., yPos = 0., maxPos = 0.;
			var prev = null;
			for( c in childs ) {
				var c = flash.Lib.as(c, Component);
				if( c != null ) {
					if( r.measure ) {
						r2.xPos = xPos;
						r2.yPos = yPos;
						r2.maxWidth = contentWidth - xPos;
						r2.maxHeight = contentHeight - yPos;
						c.resizeRec(r2);
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
						r2.xPos = xPos;
						r2.yPos = yPos;
						c.resizeRec(r2);
						xPos += c.width + style.horizontalSpacing;
					}
					prev = c;
				}
			}
			if( r.measure ) {
				contentWidth = maxPos;
				contentHeight = yPos + lineHeight;
			}
		case Vertical:
			var colWidth = 0.;
			var xPos = 0., yPos = 0., maxPos = 0.;
			var prev = null;
			for( c in childs ) {
				var c = flash.Lib.as(c, Component);
				if( c != null ) {
					if( r.measure ) {
						r2.xPos = xPos;
						r2.yPos = yPos;
						r2.maxWidth = r.maxWidth - xPos;
						r2.maxHeight = contentHeight - yPos;
						c.resizeRec(r2);
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
						r2.xPos = xPos;
						r2.yPos = yPos;
						c.resizeRec(r2);
						yPos += c.height + style.verticalSpacing;
					}
					prev = c;
				}
			}
			if( r.measure ) {
				contentWidth = xPos + colWidth;
				contentHeight = maxPos;
			}
		}
		if( r.measure ) {
			width = contentWidth + extX + style.paddingRight + style.borderSize;
			height = contentHeight + extY + style.paddingBottom + style.borderSize;
		}
	}
	
	
}