package h2d;
import hxd.Key in K;

private typedef TextHistoryElement = { t : String, c : Int, sel : { start : Int, length : Int } };

class TextInput extends Text {

	public var cursorIndex : Int = -1;
	public var cursorTile : h2d.Tile;
	public var selectionTile : h2d.Tile;
	public var cursorBlinkTime = 0.5;
	public var inputWidth : Null<Int>;
	public var selectionRange : { start : Int, length : Int };
	public var canEdit = true;

	public var backgroundColor(get, set) : Null<Int>;

	var interactive : h2d.Interactive;
	var cursorText : String;
	var cursorX : Int;
	var cursorXIndex : Int;
	var cursorBlink = 0.;
	var cursorScroll = 0;
	var scrollX = 0;
	var selectionPos : Int;
	var selectionSize : Int;
	var undo : Array<TextHistoryElement> = [];
	var redo : Array<TextHistoryElement> = [];
	var lastChange = 0.;
	var lastClick = 0.;
	var maxHistorySize = 100;

	public function new(font, ?parent) {
		super(font, parent);
		interactive = new h2d.Interactive(0, 0);
		interactive.cursor = TextInput;
		interactive.onPush = function(e:hxd.Event) {
			onPush(e);
			if( !e.cancel && e.button == 0 ) {
				if( !interactive.hasFocus() ) {
					e.kind = EFocus;
					onFocus(e);
					e.kind = EPush;
					if( e.cancel ) return;
					interactive.focus();
				}
				cursorBlink = 0;
				var startIndex = textPos(e.relX, e.relY);
				cursorIndex = startIndex;
				selectionRange = null;

				var pt = new h2d.col.Point();
				var scene = getScene();
				scene.startDrag(function(e) {
					pt.x = e.relX;
					pt.y = e.relY;
					globalToLocal(pt);
					var index = textPos(pt.x, pt.y);
					if( index == startIndex )
						selectionRange = null;
					else if( index < startIndex )
						selectionRange = { start : index, length : startIndex - index };
					else
						selectionRange = { start : startIndex, length : index - startIndex };
					selectionSize = 0;
					cursorIndex = index;
					if( e.kind == ERelease || getScene() != scene )
						scene.stopDrag();
				});
			}
		};
		interactive.onKeyDown = function(e:hxd.Event) {
			onKeyDown(e);
			handleKey(e);
		};
		interactive.onTextInput = function(e:hxd.Event) {
			onTextInput(e);
			handleKey(e);
		};
		interactive.onFocusLost = function(e) {
			cursorIndex = -1;
			selectionRange = null;
			onFocusLost(e);
		};

		interactive.onClick = function(e) {
			onClick(e);
			if( e.cancel ) return;
			var t = haxe.Timer.stamp();
			// double click to select all
			if( t - lastClick < 0.3 && text.length != 0 ) {
				selectionRange = { start : 0, length : text.length };
				selectionSize = 0;
				cursorIndex = text.length;
			}
			lastClick = t;
		};

		interactive.onKeyUp = function(e) onKeyUp(e);
		interactive.onRelease = function(e) onRelease(e);
		interactive.onFocus = function(e) onFocus(e);
		interactive.onKeyUp = function(e) onKeyUp(e);
		interactive.onMove = function(e) onMove(e);
		interactive.onOver = function(e) onOver(e);
		interactive.onOut = function(e) onOut(e);

		interactive.cursor = TextInput;

		addChildAt(interactive, 0);
	}

	override function constraintSize(width:Float, height:Float) {
		// disable (don't allow multiline textinput for now)
	}

	function handleKey( e : hxd.Event ) {
		if( e.cancel || cursorIndex < 0 )
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
		case K.BACKSPACE, K.DELETE if( selectionRange != null ):
			if( !canEdit ) return;
			beforeChange();
			cutSelection();
			onChange();
		case K.DELETE:
			if( cursorIndex < text.length && canEdit ) {
				beforeChange();
				text = text.substr(0, cursorIndex) + text.substr(cursorIndex + 1);
				onChange();
			}
		case K.BACKSPACE:
			if( cursorIndex > 0 && canEdit ) {
				beforeChange();
				cursorIndex--;
				text = text.substr(0, cursorIndex) + text.substr(cursorIndex + 1);
				onChange();
			}
		case K.ENTER, K.NUMPAD_ENTER:
			cursorIndex = -1;
			interactive.blur();
			return;
		case K.Z if( K.isDown(K.CTRL) ):
			if( undo.length > 0 && canEdit ) {
				redo.push(curHistoryState());
				setState(undo.pop());
			}
			return;
		case K.Y if( K.isDown(K.CTRL) ):
			if( redo.length > 0 && canEdit ) {
				undo.push(curHistoryState());
				setState(redo.pop());
			}
			return;
		default:
			if( e.kind == EKeyDown )
				return;
			if( e.charCode != 0 && canEdit ) {

				if( !font.hasChar(e.charCode) ) return; // don't allow chars not supported by font

				beforeChange();
				if( selectionRange != null )
					cutSelection();
				text = text.substr(0, cursorIndex) + String.fromCharCode(e.charCode) + text.substr(cursorIndex);
				cursorIndex++;
				onChange();
			}
		}

		cursorBlink = 0.;

		if( K.isDown(K.SHIFT) && text == oldText ) {

			if( cursorIndex == oldIndex ) return;

			if( selectionRange == null )
				selectionRange = oldIndex < cursorIndex ? { start : oldIndex, length : cursorIndex - oldIndex } : { start : cursorIndex, length : oldIndex - cursorIndex };
			else if( oldIndex == selectionRange.start ) {
				selectionRange.length += oldIndex - cursorIndex;
				selectionRange.start = cursorIndex;
			} else
				selectionRange.length += cursorIndex - oldIndex;

			if( selectionRange.length == 0 )
				selectionRange = null;
			else if( selectionRange.length < 0 ) {
				selectionRange.start += selectionRange.length;
				selectionRange.length = -selectionRange.length;
			}
			selectionSize = 0;

		} else
			selectionRange = null;

	}

	function cutSelection() {
		if(selectionRange == null) return false;
		cursorIndex = selectionRange.start;
		var end = cursorIndex + selectionRange.length;
		text = text.substr(0, cursorIndex) + text.substr(end);
		selectionRange = null;
		return true;
	}

	function setState(h:TextHistoryElement) {
		text = h.t;
		cursorIndex = h.c;
		selectionRange = h.sel;
		if( selectionRange != null )
			cursorIndex = selectionRange.start + selectionRange.length;
	}

	function curHistoryState() : TextHistoryElement {
		return { t : text, c : cursorIndex, sel : selectionRange == null ? null : { start : selectionRange.start, length : selectionRange.length } };
	}

	function beforeChange() {
		var t = haxe.Timer.stamp();
		if( t - lastChange < 1 ) {
			lastChange = t;
			return;
		}
		lastChange = t;
		undo.push(curHistoryState());
		redo = [];
		while( undo.length > maxHistorySize ) undo.shift();
	}

	public function getSelectedText() {
		return selectionRange == null ? null : text.substr(selectionRange.start, selectionRange.length);
	}

	override function set_text(t:hxd.UString) {
		super.set_text(t);
		if( cursorIndex > t.length ) cursorIndex = t.length;
		return t;
	}

	override function set_font(f) {
		super.set_font(f);
		cursorTile = h2d.Tile.fromColor(0xFFFFFF, 1, font.size);
		cursorTile.dy = 2;
		selectionTile = h2d.Tile.fromColor(0x3399FF, 0, font.lineHeight);
		return f;
	}

	override function initGlyphs(text:hxd.UString, rebuild = true, handleAlign = true, lines:Array<Int> = null):Void {
		super.initGlyphs(text, rebuild, handleAlign, lines);
		if( rebuild ) {
			this.calcWidth += cursorTile.width; // cursor end pos
			if( inputWidth != null && this.calcWidth > inputWidth ) this.calcWidth = inputWidth;
		}
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

		if( cursorIndex >= 0 && (text != cursorText || cursorIndex != cursorXIndex) ) {
			if( cursorIndex > text.length ) cursorIndex = text.length;
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
				if( selectionRange.start + selectionRange.length == text.length ) selectionSize += cursorTile.width; // last pixel
			}
			selectionTile.dx += selectionPos;
			selectionTile.width += selectionSize;
			emitTile(ctx, selectionTile);
			selectionTile.dx -= selectionPos;
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

	public function focus() {
		interactive.focus();
	}

	public function hasFocus() {
		return interactive.hasFocus();
	}

	public dynamic function onOut(e:hxd.Event) {
	}

	public dynamic function onOver(e:hxd.Event) {
	}

	public dynamic function onMove(e:hxd.Event) {
	}

	public dynamic function onClick(e:hxd.Event) {
	}

	public dynamic function onPush(e:hxd.Event) {
	}

	public dynamic function onRelease(e:hxd.Event) {
	}

	public dynamic function onKeyDown(e:hxd.Event) {
	}

	public dynamic function onKeyUp(e:hxd.Event) {
	}

	public dynamic function onTextInput(e:hxd.Event) {
	}

	public dynamic function onFocus(e:hxd.Event) {
	}

	public dynamic function onFocusLost(e:hxd.Event) {
	}

	public dynamic function onChange() {
	}

	override function drawRec(ctx:RenderContext) {
		var old = interactive.visible;
		interactive.visible = false;
		interactive.draw(ctx);
		super.drawRec(ctx);
		interactive.visible = old;
	}

	function get_backgroundColor() return interactive.backgroundColor;
	function set_backgroundColor(v) return interactive.backgroundColor = v;

}