package h2d;
import hxd.Key in K;

private typedef TextHistoryElement = { t : String, c : Int, sel : { start : Int, length : Int } };

/**
	A skinnable text input handler.

	Supports text selection, keyboard cursor navigation, as well as basic hotkeys: `Ctrl + Z`, `Ctrl + Y` for undo and redo and `Ctrl + A` to select all text.
**/
class TextInput extends Text {

	/**
		Current position of the input cursor.
		When TextInput is not focused value is -1.
	**/
	public var cursorIndex : Int = -1;
	/**
		The Tile used to render the input cursor.
	**/
	public var cursorTile : h2d.Tile;
	/**
		The Tile used to render the background for selected text.
		When rendering, this Tile is stretched horizontally to fill entire selection area.
	**/
	public var selectionTile : h2d.Tile;
	/**
		The blinking interval of the cursor in seconds.
	**/
	public var cursorBlinkTime = 0.5;
	/**
		Maximum input width.
		Contrary to `Text.maxWidth` does not cause a word-wrap, but also masks out contents that are outside the max width.
	**/
	public var inputWidth : Null<Int>;
	/**
		Whether the text input allows multiple lines.
	**/
	public var multiline: Bool = false;
	/**
		If not null, represents current text selection range.
	**/
	public var selectionRange : { start : Int, length : Int };
	/**
		When disabled, user would not be able to edit the input text (selection is still available).
	**/
	public var canEdit = true;

	/**
		If set, TextInput will render provided color as a background to text interactive area.
	**/
	public var backgroundColor(get, set) : Null<Int>;

	/**
		If set, insert these characters when pressing Tab
	**/
	public var insertTabs : Null<String>;

	/**
		When disabled, showSoftwareKeyboard will not be called.
	**/
	public var useSoftwareKeyboard : Bool = true;
	public static dynamic function showSoftwareKeyboard(target:TextInput) {}
	public static dynamic function hideSoftwareKeyboard(target:TextInput) {}

	var interactive : h2d.Interactive;
	var cursorText : String;
	var cursorX : Float;
	var cursorXIndex : Int;
	var cursorY : Float;
	var cursorBlink = 0.;
	var constraintHeight = -1.;
	var scrollX = 0.;
	var selectionPos : Float;
	var selectionSize : Float;
	var undo : Array<TextHistoryElement> = [];
	var redo : Array<TextHistoryElement> = [];
	var lastChange = 0.;
	var lastClick = 0.;
	var maxHistorySize = 100;
	var splitLines : Array<String>;
	var splitTextSize : Int;

	/**
		Create a new TextInput instance.
		@param font The font used to render the text.
		@param parent An optional parent `h2d.Object` instance to which TextInput adds itself if set.
	**/
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
				if( scene == null ) return; // was removed
				scene.startCapture(function(e) {
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
						scene.stopCapture();
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
		interactive.onFocus = function(e) {
			onFocus(e);
			if ( useSoftwareKeyboard && canEdit )
				showSoftwareKeyboard(this);
		}
		interactive.onFocusLost = function(e) {
			onFocusLost(e);
			if( !e.cancel ) onBlur();
		};

		interactive.onClick = function(e) {
			onClick(e);
			if( e.cancel ) return;
			var t = haxe.Timer.stamp();
			// double click to select all
			if( t - lastClick < 0.3 && getTextLength() != 0 ) {
				selectionRange = { start : 0, length : getTextLength() };
				selectionSize = 0;
				cursorIndex = getTextLength();
			}
			lastClick = t;
		};

		interactive.onKeyUp = function(e) onKeyUp(e);
		interactive.onRelease = function(e) onRelease(e);
		interactive.onKeyUp = function(e) onKeyUp(e);
		interactive.onMove = function(e) onMove(e);
		interactive.onOver = function(e) onOver(e);
		interactive.onOut = function(e) onOut(e);
		interactive.onWheel = function(e) e.propagate = true;

		interactive.cursor = TextInput;

		addChildAt(interactive, 0);
	}

	override function constraintSize(width:Float, height:Float) {
		super.constraintSize(width, height);
		constraintHeight = height;
	}

	function getVisibleLines() {
		var v = Math.ceil(constraintHeight / font.lineHeight);
		if( v <= 0 ) v = 10;
		return v;
	}

	function handleKey( e : hxd.Event ) {
		if( e.cancel || cursorIndex < 0 )
			return;

		var oldIndex = cursorIndex;
		var oldText = text;

		switch( e.keyCode ) {
		case K.UP if( multiline ):
			moveCursorVertically(-1);
		case K.DOWN if( multiline ):
			moveCursorVertically(1);
		case K.PGUP if( multiline ):
			moveCursorVertically(-getVisibleLines());
		case K.PGDOWN if( multiline ):
			moveCursorVertically(getVisibleLines());
		case K.LEFT if (K.isDown(K.CTRL)):
			cursorIndex = getWordStart();
		case K.LEFT:
			if( cursorIndex > 0 )
				cursorIndex--;
		case K.RIGHT if (K.isDown(K.CTRL)):
			cursorIndex = getWordEnd();
		case K.RIGHT:
			if( cursorIndex < getTextLength() )
				cursorIndex++;
		case K.HOME:
			if( multiline ) {
				var currentLine = getCurrentLine();
				cursorIndex = currentLine.startIndex;
			} else cursorIndex = 0;
		case K.END:
			if( multiline ) {
				var currentLine = getCurrentLine();
				cursorIndex = currentLine.startIndex + currentLine.value.length - 1;
			} else cursorIndex = getTextLength();
		case K.BACKSPACE, K.DELETE if( selectionRange != null ):
			if( !canEdit ) return;
			beforeChange();
			cutSelection();
			onChange();
		case K.DELETE:
			if( cursorIndex < getTextLength() && canEdit ) {
				beforeChange();
				if( selectionRange == null )
					selectionRange = { start : cursorIndex, length : K.isDown(K.CTRL) ? getWordEnd() - cursorIndex : 1 };
				cutSelection();
				onChange();
			}
		case K.BACKSPACE:
			if( cursorIndex > 0 && canEdit ) {
				beforeChange();
				if( selectionRange == null )
					selectionRange = { start : K.isDown(K.CTRL) ? getWordStart() : cursorIndex - 1, length : 1 };
				cutSelection();
				onChange();
			}
		case K.ESCAPE:
			cursorIndex = -1;
			interactive.blur();
			return;
		case K.ENTER, K.NUMPAD_ENTER:
			if(!multiline) {
				cursorIndex = -1;
				interactive.blur();
				return;
			} else if( canEdit ) {
				inputText("\n");
			}
		case K.Z if( K.isDown(K.CTRL) ):
			if( undo.length > 0 && canEdit ) {
				redo.push(curHistoryState());
				setState(undo.pop());
				onChange();
			}
			return;
		case K.Y if( K.isDown(K.CTRL) ):
			if( redo.length > 0 && canEdit ) {
				undo.push(curHistoryState());
				setState(redo.pop());
				onChange();
			}
			return;
		case K.A if (K.isDown(K.CTRL)):
			if (text != "") {
				cursorIndex = getTextLength();
				selectionRange = {start: 0, length: cursorIndex};
				selectionSize = 0;
			}
			return;
		case K.C if (K.isDown(K.CTRL)):
			if( text != "" && selectionRange != null ) {
				hxd.System.setClipboardText(text.substr(selectionRange.start, selectionRange.length));
			}
		case K.X if (K.isDown(K.CTRL)):
			if( text != "" && selectionRange != null ) {
				if(hxd.System.setClipboardText(text.substr(selectionRange.start, selectionRange.length))) {
					if( !canEdit ) return;
					beforeChange();
					cutSelection();
					onChange();
				}
			}
		case K.V if (K.isDown(K.CTRL)):
			if( !canEdit ) return;
			var t = hxd.System.getClipboardText();
			if( t != null && t.length > 0 )
				inputText(t.split("\r\n").join("\n").split("\r").join("\n"));
		case K.TAB if( insertTabs != null && canEdit ):
			inputText(insertTabs);
		default:
			if( e.kind == EKeyDown )
				return;
			if( e.charCode != 0 && canEdit ) {
				if( !font.hasChar(e.charCode) ) return; // don't allow chars not supported by font
				inputText(String.fromCharCode(e.charCode));
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

	/**
		When lineBreak is enabled and some word wrapping operation applies, the cursorIndex no
		longer represent the position in the exact text but in the wrapped text, including
		inserted newlines. This function allows to translate the cursor position into the position
		into the text. Use getCursorPos to convert the text position into a cursor position.
	**/
	public function getTextPos( cursor : Int ) {
		var lines = text.split("\n"); // real newlines
		var pos = 0;
		for( line in lines ) {
			for( p in splitRawText(line).split("\n") ) {
				if( cursor < p.length )
					return pos + cursor;
				pos += p.length;
				if( font.charset.isSpace(StringTools.fastCodeAt(text,pos)) ) pos++;
				cursor -= p.length + 1;
			}
			pos++;
		}
		return pos;
	}

	/**
		See getTextPos()
	**/
	public function getCursorPos( pos : Int ) {
		var lines = text.split("\n"); // real newlines
		var cursor = 0;
		var spos = 0;
		for( line in lines ) {
			for( p in splitRawText(line).split("\n") ) {
				if( (pos - spos) < p.length )
					return (pos - spos) + cursor;
				spos += p.length;
				if( font.charset.isSpace(StringTools.fastCodeAt(text,spos)) ) spos++;
				cursor += p.length + 1;
			}
			spos++;
		}
		return cursor;
	}

	function inputText( t : String ) {
		beforeChange();
		if( selectionRange != null )
			cutSelection();
		var pos = getTextPos(cursorIndex);
		text = text.substr(0, pos) + t + text.substr(pos);
		cursorIndex += t.length;
		onChange();
	}

	function cutSelection() {
		if(selectionRange == null) return false;
		cursorIndex = selectionRange.start;
		var end = cursorIndex + selectionRange.length;
		text = text.substr(0, getTextPos(cursorIndex)) + text.substr(getTextPos(end));
		selectionRange = null;
		return true;
	}

	/**
		This function is used to code the behavior of Ctrl-Left/Right word skipping.
		By default it uses charset.isSpace but can be customized.
	**/
	public dynamic function isWordLimit( pos : Int ) {
		return font.charset.isSpace(StringTools.fastCodeAt(text, pos));
	}

	function getWordEnd() {
		var len = getTextLength();
		if (cursorIndex >= len) {
			return len;
		}
		var ret = getTextPos(cursorIndex);
		while (ret < len && isWordLimit(ret)) ret++;
		while (ret < len && !isWordLimit(ret)) ret++;
		return getCursorPos(ret);
	}

	function getWordStart() {
		if (cursorIndex <= 0) {
			return 0;
		}
		var ret = getTextPos(cursorIndex);
		while (ret > 0 && isWordLimit(ret-1)) ret--;
		while (ret > 0 && !isWordLimit(ret-1)) ret--;
		return getCursorPos(ret);
	}

	function moveCursorVertically(yDiff: Int){
		if( !multiline || yDiff == 0 )
			return;
		var lines = [];
		var cursorLineIndex = -1, currLineIndex = 0, currIndex = 0;
		for( line in getSplitLines() ) {
			lines.push( { line: line, startIndex: currIndex } );
			var prevIndex = currIndex;
			currIndex += line.length;
			if( cursorIndex >= prevIndex && cursorIndex < currIndex )
				cursorLineIndex = currLineIndex;
			currLineIndex++;
		}
		if( cursorLineIndex == -1 )
			return;
		var inSelect = hxd.Key.isDown(hxd.Key.SHIFT);
		var destinationIndex = hxd.Math.iclamp(cursorLineIndex + yDiff, inSelect ? -1 : 0, inSelect ? lines.length : lines.length - 1);
		if (destinationIndex == cursorLineIndex)
			return;
		// We're moving down from the last line, move to the end of the line
		if( destinationIndex == lines.length) {
			cursorIndex = getTextLength();
			return;
		}
		// We're moving up from the first line, snap to beginning
		if( destinationIndex == -1 ) {
			cursorIndex = 0;
			return;
		}
		var current = lines[cursorLineIndex];
		var xOffset = 0.;
		var prevCC: Null<Int> = null;
		var cI = 0;
		while( current.startIndex + cI < cursorIndex) {
			var cc = current.line.charCodeAt(cI);
			var c = font.getChar(cc);
			xOffset += c.width + c.getKerningOffset(prevCC) + letterSpacing;
			prevCC = cc;
			cI++;
		}
		var destination = lines[destinationIndex];
		var currOffset = 0.;
		prevCC = null;
		for( cI in 0...destination.line.length ) {
			var cc = StringTools.fastCodeAt(destination.line, cI);
			var c = font.getChar(cc);
			var newCurrOffset = currOffset + c.width + c.getKerningOffset(prevCC) + letterSpacing;
			if( newCurrOffset > xOffset ) {
				cursorIndex = destination.startIndex + cI + 1;
				if( xOffset - currOffset < newCurrOffset - xOffset )
					cursorIndex--;
				return;
			}
			currOffset = newCurrOffset;
			prevCC = cc;
		}
		cursorIndex = destination.startIndex + destination.line.length;
		// The last character in this line may be the \n, check for this and move back by one.
		// we can't just assume this because the last line typically won't end with a newline.
		if( destination.line.charAt(destination.line.length-1) == "\n")
			cursorIndex--;
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

	/**
		Load the state from a previous input, copy the current text, cursor position, selection etc.
		This allows to continue uninterrupted input experience while the input component has been reset/rebuild
	**/
	public function loadState( from : TextInput, focus=false ) {
		if( from == null )
			return;
		this.undo = from.undo;
		this.redo = from.redo;
		this.text = from.text;
		this.cursorIndex = from.cursorIndex;
		this.scrollX = from.scrollX;
		this.selectionRange = from.selectionRange;
		this.cursorBlinkTime = from.cursorBlinkTime;
		if( focus ) this.focus();
	}

	public function clearUndo() {
		undo = [];
		redo = [];
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

	function getTextLength() {
		getSplitLines();
		return splitTextSize;
	}

	function getSplitLines() {
		if( splitLines != null && !(needsRebuild || textChanged) )
			return splitLines;
		var lines = this.text.split('\n');
		splitLines = [];
		splitTextSize = 0;
		for(l in lines) {
			for( l in splitText(l).split('\n') ) {
				splitLines.push(l+'\n');
				splitTextSize += l.length + 1;
			}
		}
		if( splitTextSize > 0 ) splitTextSize--;
		return splitLines;
	}

	function getCurrentLine() : {value: String, startIndex: Int} {
		var lines = getSplitLines();
		var currIndex = 0;
		for( i in 0...lines.length ) {
			var newCurrIndex = currIndex + lines[i].length;
			if( cursorIndex < newCurrIndex )
				return { value: lines[i], startIndex: currIndex };
			currIndex = newCurrIndex;
		}
		return { value: '', startIndex: -1 };
	}

	function getCursorXOffset() {
		var lines = getSplitLines();
		var offset = cursorIndex;
		var currLine = getCurrentLine().value;
		var currIndex = 0;

		for(i in 0...lines.length) {
			currIndex += lines[i].length;
			if(cursorIndex < currIndex) {
				break;
			} else {
				offset -= lines[i].length;
			}
		}

		return calcTextWidth(currLine.substr(0, offset));
	}

	function getCursorYOffset() {
		// return 0.0;
		var lines = getSplitLines();
		var currIndex = 0;
		var lineNum = 0;

		for(i in 0...lines.length) {
			currIndex += lines[i].length;
			if(cursorIndex < currIndex) {
				lineNum = i;
				break;
			}
		}

		return lineNum * font.lineHeight;
	}

	/**
		Returns a String representing currently selected text area or `null` if no text is selected.
	**/
	public function getSelectedText() : String {
		return selectionRange == null ? null : text.substr(selectionRange.start, selectionRange.length);
	}

	override function set_text(t:String) {
		super.set_text(t);
		if( cursorIndex > t.length ) cursorIndex = t.length;
		return t;
	}

	override function set_font(f) {
		super.set_font(f);
		cursorTile = h2d.Tile.fromColor(0xFFFFFF, 1, font.size);
		cursorTile.dy = 2;
		selectionTile = h2d.Tile.fromColor(0x3399FF, 0, hxd.Math.ceil(font.lineHeight));
		return f;
	}

	override function splitRawText(text:String, leftMargin:Float = 0., afterData:Float = 0., ?font:Font, ?sizes:Array<Float>, ?prevChar:Int = -1):String {
		if( !multiline )
			return text;
		return super.splitRawText(text, leftMargin, afterData, font, sizes, prevChar);
	}

	function getInputWidth() : Int {
		if( inputWidth != null )
			return inputWidth;
		if( realMaxWidth >= 0 )
			return Math.ceil(realMaxWidth);
		return -1;
	}

	override function initGlyphs(text:String, rebuild = true):Void {
		super.initGlyphs(text, rebuild);
		if( rebuild ) {
			splitLines = null;
			this.calcWidth += cursorTile.width; // cursor end pos
			var iw = getInputWidth();
			if( iw >= 0 && this.calcWidth > iw ) this.calcWidth = iw;
		}
	}

	function textPos( x : Float, y : Float ) {
		x += scrollX;
		var lineIndex = Math.floor(y / font.lineHeight);
		var lines = getSplitLines();
		lineIndex = hxd.Math.iclamp(lineIndex, 0, lines.length - 1);
		var selectedLine = lines[lineIndex];
		var pos = 0;
		for(i in 0...lineIndex) {
			pos += lines[i].length;
		}

		var linePos = 0;
		while( linePos < selectedLine.length ) {
			if( calcTextWidth(selectedLine.substr(0,linePos+1)) > x ) {
				pos++;
				break;
			}
			pos++;
			linePos++;
		}
		return pos - 1;
	}

	function syncInteract() {
		var lines = getSplitLines();
		var iw = getInputWidth();
		interactive.width = iw >= 0 ? iw : textWidth;
		var ih = font.lineHeight * (lines.length == 0 ? 1 : lines.length);
		if( multiline && constraintHeight >= 0 && ih < constraintHeight ) ih = constraintHeight;
		interactive.height = ih;
	}

	override function getBoundsRec(relativeTo:Object, out:h2d.col.Bounds, forSize:Bool) {
		syncInteract();
		super.getBoundsRec(relativeTo, out, forSize);
	}

	override function sync(ctx) {
		syncInteract();
		super.sync(ctx);
	}

	override function draw(ctx:RenderContext) {
		var iw = getInputWidth();
		if( multiline ) {
			iw = -1;
			scrollX = 0;
		}
		if( iw >= 0 ) {
			var h = localToGlobal(new h2d.col.Point(iw, font.lineHeight * (getSplitLines().length)));
			ctx.clipRenderZone(absX, absY, h.x - absX, h.y - absY);
		}

		var lastCursorY = cursorY;
		if( cursorIndex >= 0 && (text != cursorText || cursorIndex != cursorXIndex) ) {
			if( cursorIndex > getTextLength() ) cursorIndex = getTextLength();
			cursorText = text;
			cursorXIndex = cursorIndex;
			cursorX = getCursorXOffset();
			cursorY = getCursorYOffset();
			if( iw >= 0 && cursorX - scrollX >= iw )
				scrollX = cursorX - iw + 1;
			else if( cursorX < scrollX && cursorIndex > 0 )
				scrollX = cursorX - hxd.Math.imin(iw, Std.int(cursorX));
			else if( cursorX < scrollX )
				scrollX = cursorX;
		}

		if( multiline && cursorY != lastCursorY ) {
			// ensure cursor in scroll
			var p = parentContainer;
			var pt = localToGlobal(new h2d.col.Point(cursorX, cursorY));
			while( p != null ) {
				if( p.scrollToPos(pt) )
					break;
				p = p.parentContainer;
			}
			var pt = localToGlobal(new h2d.col.Point(cursorX, cursorY + font.lineHeight));
			while( p != null ) {
				if( p.scrollToPos(pt) )
					break;
				p = p.parentContainer;
			}
		}

		absX -= scrollX * matA;
		absY -= scrollX * matC;

		if( selectionRange != null ) {
			var lines = getSplitLines();
			var lineOffset = 0;

			for(i in 0...lines.length) {
				var line = lines[i];

				var selEnd = line.length;

				if(selectionRange.start > lineOffset + line.length || selectionRange.start + selectionRange.length < lineOffset) {
					lineOffset += line.length;
					continue;
				}

				var selStart = Math.floor(Math.max(0, selectionRange.start - lineOffset));
				var selEnd = Math.floor(Math.min(line.length - selStart, selectionRange.length + selectionRange.start - lineOffset - selStart));

				selectionPos = calcTextWidth(line.substr(0, selStart));
				selectionSize = calcTextWidth(line.substr(selStart, selEnd));
				if( selectionRange.start + selectionRange.length == cursorIndex ) selectionSize += cursorTile.width; // last pixel

				selectionTile.dx += selectionPos;
				selectionTile.dy += i * font.lineHeight;
				selectionTile.width += selectionSize;
				emitTile(ctx, selectionTile);
				selectionTile.dx -= selectionPos;
				selectionTile.dy -= i * font.lineHeight;
				selectionTile.width -= selectionSize;
				lineOffset += line.length;
			}
		}

		super.draw(ctx);
		absX += scrollX * matA;
		absY += scrollX * matC;

		if( cursorIndex >= 0 ) {
			cursorBlink += ctx.elapsedTime;
			if( cursorBlink % (cursorBlinkTime * 2) < cursorBlinkTime ) {
				cursorTile.dx += cursorX - scrollX;
				cursorTile.dy += cursorY;
				emitTile(ctx, cursorTile);
				cursorTile.dx -= cursorX - scrollX;
				cursorTile.dy -= cursorY;
			}
		}

		if( iw >= 0 )
			ctx.popRenderZone();
	}

	/**
		Sets focus on this `TextInput`.
	**/
	public function focus() {
		interactive.focus();
		if( cursorIndex < 0 ) {
			cursorIndex = 0;
			if( text != "" ) selectionRange = { start : 0, length : getTextLength() };
		}
	}

	function onBlur() {
		cursorIndex = -1;
		selectionRange = null;
		hideSoftwareKeyboard(this);
	}

	public function blur() {
		onBlur();
		interactive.blur();
	}

	/**
		Checks if TextInput is currently focused.
	**/
	public function hasFocus() {
		return interactive.hasFocus();
	}

	/**
		Delegate of underlying `Interactive.onOut`.
	**/
	public dynamic function onOut(e:hxd.Event) {
	}

	/**
		Delegate of underlying `Interactive.onOver`.
	**/
	public dynamic function onOver(e:hxd.Event) {
	}

	/**
		Delegate of underlying `Interactive.onMove`.
	**/
	public dynamic function onMove(e:hxd.Event) {
	}

	/**
		Delegate of underlying `Interactive.onClick`.
	**/
	public dynamic function onClick(e:hxd.Event) {
	}

	/**
		Delegate of underlying `Interactive.onPush`.
	**/
	public dynamic function onPush(e:hxd.Event) {
	}

	/**
		Delegate of underlying `Interactive.onRelease`.
	**/
	public dynamic function onRelease(e:hxd.Event) {
	}

	/**
		Delegate of underlying `Interactive.onKeyDown`.
	**/
	public dynamic function onKeyDown(e:hxd.Event) {
	}

	/**
		Delegate of underlying `Interactive.onKeyUp`.
	**/
	public dynamic function onKeyUp(e:hxd.Event) {
	}

	/**
		Delegate of underlying `Interactive.onTextInput`.
	**/
	public dynamic function onTextInput(e:hxd.Event) {
	}

	/**
		Delegate of underlying `Interactive.onFocus`.
	**/
	public dynamic function onFocus(e:hxd.Event) {
	}

	/**
		Delegate of underlying `Interactive.onFocusLost`.
	**/
	public dynamic function onFocusLost(e:hxd.Event) {
	}

	/**
		Sent when user modifies TextInput contents.
	**/
	public dynamic function onChange() {
	}

	override function drawRec(ctx:RenderContext) {
		var old = interactive.visible;
		var oldC = interactive.parentContainer;
		// workaround @:bypassAccessor not working by setting parentContainer=null
		// prevent domkit style to be updated
		interactive.parentContainer = null;
		interactive.visible = false;
		interactive.parentContainer = oldC;
		interactive.draw(ctx);
		super.drawRec(ctx);
		interactive.parentContainer = null;
		interactive.visible = old;
		interactive.parentContainer = oldC;
	}

	function get_backgroundColor() return interactive.backgroundColor;
	function set_backgroundColor(v) return interactive.backgroundColor = v;

}