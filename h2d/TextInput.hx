package h2d;
import hxd.Key in K;


class TextInput extends Text {

	public var interactive : h2d.Interactive;
	public var cursorIndex : Int = -1;
	public var cursorTile : h2d.Tile;
	public var selectionTile : h2d.Tile;
	public var cursorBlinkTime = 0.5;
	public var inputWidth : Null<Int>;
	public var selectionRange : { start : Int, length : Int };

	var cursorText : String;
	var cursorX : Int;
	var cursorXIndex : Int;
	var cursorBlink = 0.;
	var cursorScroll = 0;
	var scrollX = 0;
	var selectionPos : Int;
	var selectionSize : Int;

	public function new(font, ?parent) {
		super(font, parent);
		interactive = new h2d.Interactive(0, 0);
		interactive.cursor = TextInput;
		interactive.onClick = function(e:hxd.Event) {
			interactive.focus();
			cursorBlink = 0;
			cursorIndex = textPos(e.relX, e.relY);
		};
		interactive.onKeyDown = function(e:hxd.Event) {
			if( cursorIndex < 0 )
				return;

			var oldIndex = cursorIndex;
			var oldText = text;

			switch( e.keyCode ) {
			case K.LEFT:
				if( cursorIndex > 0 )
					cursorIndex--;
			case K.RIGHT:
				if( cursorIndex < text.length )
					cursorIndex++;
			case K.HOME:
				cursorIndex = 0;
			case K.END:
				cursorIndex = text.length;
			case K.DELETE:
				text = text.substr(0, cursorIndex) + text.substr(cursorIndex + 1 , text.length - (cursorIndex + 1));
				onChange();
			case K.BACKSPACE:
				if( cursorIndex > 0 ) {
					if( selectionRange == null ) {
						text = text.substr(0, cursorIndex - 1) + text.substr(cursorIndex, text.length - cursorIndex);
						cursorIndex--;
					} else {
						cursorIndex = selectionRange.start;
						var end = cursorIndex + selectionRange.length;
						text = text.substr(0, cursorIndex) + text.substr(end, text.length - end);
						selectionRange = null;
					}
					onChange();
				}
			default:
				if( e.charCode != 0 ) {
					text = text.substr(0, cursorIndex) + String.fromCharCode(e.charCode) + text.substr(cursorIndex, text.length - cursorIndex);
					cursorIndex++;
					onChange();
				}
			}

			cursorBlink = 0.;

			if( K.isDown(K.SHIFT) && text == oldText ) {

				if( selectionRange == null )
					selectionRange = oldIndex < cursorIndex ? { start : oldIndex, length : cursorIndex - oldIndex } : { start : cursorIndex, length : oldIndex - cursorIndex };
				else {
					// TODO
				}
			} else
				selectionRange = null;

		};
		interactive.onFocusLost = function(_) cursorIndex = -1;
		addChildAt(interactive, 0);
	}

	override function set_font(f) {
		super.set_font(f);
		cursorTile = h2d.Tile.fromColor(0xFFFFFF, 1, font.size);
		cursorTile.dy = 2;
		selectionTile = h2d.Tile.fromColor(0x3399FF, 0, font.lineHeight);
		return f;
	}

	function textPos( x : Float, y : Float ) {
		x += scrollX;
		var pos = 0;
		while( pos < text.length ) {
			if( calcTextWidth(text.substr(0,pos+1)) > x )
				break;
			pos++;
		}
		return pos;
	}

	override function sync(ctx) {
		interactive.width = (inputWidth != null ? inputWidth : maxWidth != null ? Math.ceil(maxWidth) : textWidth);
		interactive.height = font.lineHeight;
		super.sync(ctx);
	}

	override function draw(ctx:RenderContext) {
		if( inputWidth != null ) {
			var h = localToGlobal(new h2d.col.Point(inputWidth, font.lineHeight));
			ctx.setRenderZone(absX, absY, h.x - absX, h.y - absY);
		}

		if( cursorIndex >=0 && (text != cursorText || cursorIndex != cursorXIndex) ) {
			cursorText = text;
			cursorXIndex = cursorIndex;
			cursorX = calcTextWidth(text.substr(0, cursorIndex));
			if( inputWidth != null && cursorX - scrollX >= inputWidth )
				scrollX = cursorX - inputWidth + 1;
			else if( cursorX < scrollX )
				scrollX = cursorX;
		}

		absX -= scrollX * matA;
		absY -= scrollX * matC;

		if( selectionRange != null ) {
			if( selectionSize == 0 ) {
				selectionPos = calcTextWidth(text.substr(0, selectionRange.start));
				selectionSize = calcTextWidth(text.substr(selectionRange.start, selectionRange.length));
			}
			selectionTile.dx += selectionPos - scrollX;
			selectionTile.width += selectionSize;
			emitTile(ctx, selectionTile);
			selectionTile.dx -= selectionPos - scrollX;
			selectionTile.width -= selectionSize;
		}

		super.draw(ctx);
		absX += scrollX * matA;
		absY += scrollX * matC;

		if( cursorIndex >= 0 ) {
			cursorBlink += ctx.elapsedTime;
			if( cursorBlink % (cursorBlinkTime * 2) < cursorBlinkTime ) {
				cursorTile.dx += cursorX - scrollX;
				emitTile(ctx, cursorTile);
				cursorTile.dx -= cursorX - scrollX;
			}
		}

		if( inputWidth != null )
			ctx.clearRenderZone();
	}

	public dynamic function onChange() {
	}

	override function drawRec(ctx:RenderContext) {
		var old = interactive.visible;
		interactive.visible = false;
		interactive.draw(ctx);
		super.drawRec(ctx);
		interactive.visible = true;
	}

}