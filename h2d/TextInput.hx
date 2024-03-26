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
	var prevCursorYIndex : Int;
	var cursorYIndex : Int;
	var cursorBlink = 0.;
	var cursorScroll = 0;
	var scrollX = 0.;
	var selectionPos : Float;
	var selectionSize : Float;
	var undo : Array<TextHistoryElement> = [];
	var redo : Array<TextHistoryElement> = [];
	var lastChange = 0.;
	var lastClick = 0.;
	var maxHistorySize = 100;

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
				var startPos = textPos(e.relX, e.relY);
				cursorIndex = startPos.cursorIndex;
				cursorYIndex = startPos.lineIndex;
				selectionRange = null;

				var pt = new h2d.col.Point();
				var scene = getScene();
				if( scene == null ) return; // was removed
				scene.startCapture(function(e) {
					pt.x = e.relX;
					pt.y = e.relY;
					globalToLocal(pt);
					var pos = textPos(pt.x, pt.y);
					if( pos.cursorIndex == startPos.cursorIndex )
						selectionRange = null;
					else if( pos.cursorIndex < startPos.cursorIndex )
						selectionRange = { start : pos.cursorIndex, length : startPos.cursorIndex - pos.cursorIndex };
					else
						selectionRange = { start : startPos.cursorIndex, length : pos.cursorIndex - startPos.cursorIndex };
					selectionSize = 0;
					cursorIndex = pos.cursorIndex;
					cursorYIndex = pos.lineIndex;
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
			cursorIndex = -1;
			selectionRange = null;
			hideSoftwareKeyboard(this);
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
				cursorYIndex = getAllLines().length - 1;
			}
			lastClick = t;
		};

		interactive.onKeyUp = function(e) onKeyUp(e);
		interactive.onRelease = function(e) onRelease(e);
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
		case K.UP if( multiline ):
			moveCursorVertically(-1);
		case K.DOWN if( multiline ):
			moveCursorVertically(1);
		case K.LEFT if (K.isDown(K.CTRL)):
			var ncIdx = getWordStart();
			var nYIdx = resolveYIndex(ncIdx);
			if (cursorYIndex > nYIdx){
				var cL = getCurrentLine();
				// Only go to the end of the upper line if we're not going to the start of the current one
				if (ncIdx != cL.startIndex)
					cursorYIndex = nYIdx;
			}
			cursorIndex = ncIdx;
		case K.LEFT:
			if( cursorIndex > 0 ){
				var ncIdx = cursorIndex - 1;
				var cL = getCurrentLine();
				if (cursorIndex == cL.startIndex && cursorYIndex > 0){
					// We go to the end of the upper line
					cursorYIndex--;
					if (text.charCodeAt(cursorIndex - 1) == '\n'.code)
						cursorIndex--;
				}
				else {
					cursorIndex = ncIdx;	
					if (text.charCodeAt(cursorIndex) == '\n'.code)
						cursorIndex--;
				}					
			}
		case K.RIGHT if (K.isDown(K.CTRL)):
			cursorIndex = getWordEnd();
			cursorYIndex = resolveYIndex(cursorIndex);
		case K.RIGHT:
			if( cursorIndex < text.length ){
				var ncIdx = cursorIndex + 1;
				var yIdx = resolveYIndex(cursorIndex);
				var cL = getCurrentLine();
				if (cursorIndex == cL.startIndex + cL.value.length && cursorYIndex == yIdx){
					// We go to the start of the next line
					var lines = getAllLines();
					if (cursorYIndex < lines.length - 1)
						cursorYIndex++;					
				}
				else {
					if (text.charCodeAt(cursorIndex) == '\n'.code)
						cursorYIndex++;		
					cursorIndex = ncIdx;																
				}
			}
		case K.HOME:
			if( multiline ) {
				var currentLine = getCurrentLine();
				cursorIndex = currentLine.startIndex;
			} else cursorIndex = 0;
		case K.END:
			if( multiline ) {
				var currentLine = getCurrentLine();
				cursorIndex = currentLine.startIndex + currentLine.value.length;
			} else cursorIndex = text.length;
		case K.BACKSPACE, K.DELETE if( selectionRange != null ):
			if( !canEdit ) return;
			beforeChange();
			cutSelection();
			onChange();
		case K.DELETE:
			if( cursorIndex < text.length && canEdit ) {
				beforeChange();
				var end = K.isDown(K.CTRL) ? getWordEnd() : cursorIndex + 1;
				text = text.substr(0, cursorIndex) + text.substr(end);
				onChange();
			}
		case K.BACKSPACE:
			if( cursorIndex > 0 && canEdit ) {
				beforeChange();
				var end = cursorIndex;
				cursorIndex = K.isDown(K.CTRL) ? getWordStart() : cursorIndex - 1;
				if (text.charCodeAt(cursorIndex) == '\n'.code)
					cursorIndex--;
				text = text.substr(0, cursorIndex) + text.substr(end);
				cursorYIndex = resolveYIndex(cursorIndex);
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
			} else {
				beforeChange();
				if( selectionRange != null )
					cutSelection();
				text = text.substr(0, cursorIndex) + '\n' + text.substr(cursorIndex);
				cursorIndex++;
				cursorYIndex++;
				onChange();
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
				cursorIndex = text.length;
				cursorYIndex = getAllLines().length - 1;
				selectionRange = {start: 0, length: text.length};
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
			if( t != null && t.length > 0 ) {
				beforeChange();
				if( selectionRange != null )
					cutSelection();
				text = text.substr(0, cursorIndex) + t + text.substr(cursorIndex);
				cursorIndex += t.length;
				onChange();
			}
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
				cursorYIndex = resolveYIndex(cursorIndex);
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
		cursorYIndex = resolveYIndex(cursorIndex);
		var end = cursorIndex + selectionRange.length;
		text = text.substr(0, cursorIndex) + text.substr(end);
		selectionRange = null;
		return true;
	}

	function getWordEnd() {
		var len = text.length;
		if (cursorIndex >= len) {
			return cursorIndex;
		}
		var charset = hxd.Charset.getDefault();
		var ret = cursorIndex;
		while (ret < len && charset.isSpace(StringTools.fastCodeAt(text, ret))) ret++;
		while (ret < len && !charset.isSpace(StringTools.fastCodeAt(text, ret))) ret++;
		return ret;
	}

	function getWordStart() {
		if (cursorIndex <= 0) {
			return cursorIndex;
		}
		var charset = hxd.Charset.getDefault();
		var ret = cursorIndex;
		while (ret > 0 && charset.isSpace(StringTools.fastCodeAt(text, ret - 1))) ret--;
		while (ret > 0 && !charset.isSpace(StringTools.fastCodeAt(text, ret - 1))) ret--;
		return ret;
	}

	function moveCursorVertically(yDiff: Int){
		if( !multiline || yDiff == 0)
			return;
		var lines = [];
		var currIndex = 0;
		for( line in getAllLines() ) {
			lines.push( { line: line, startIndex: currIndex } );
			currIndex += line.length;
		}
		var destinationIndex = hxd.Math.iclamp(cursorYIndex + yDiff, 0, lines.length - 1);
		if (destinationIndex == cursorYIndex)
			return;
		var current = lines[cursorYIndex];
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
		function setCursorAt(index: Int){
			cursorIndex = index;
			if (cursorIndex > 0 && text.charCodeAt(cursorIndex - 1) == '\n'.code)
				cursorIndex--;
			cursorYIndex = destinationIndex;
		}
		for( cI in 0...destination.line.length ) {
			var cc = destination.line.charCodeAt(cI);
			var c = font.getChar(cc);
			var newCurrOffset = currOffset + c.width + c.getKerningOffset(prevCC) + letterSpacing;
			if( newCurrOffset > xOffset ) {
				setCursorAt(destination.startIndex + cI + 1);
				if( xOffset - currOffset < newCurrOffset - xOffset )
					cursorIndex--;
				return;
			}
			currOffset = newCurrOffset;
			prevCC = cc;
		}
		setCursorAt(destination.startIndex + destination.line.length);
	}

	function setState(h:TextHistoryElement) {
		text = h.t;
		cursorIndex = h.c;
		selectionRange = h.sel;
		if( selectionRange != null )
			cursorIndex = selectionRange.start + selectionRange.length;
		cursorYIndex = resolveYIndex(cursorIndex);
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

	function getAllLines() {
		var lines = this.text.split('\n');
		var finalLines : Array<String> = [];

		for (i in 0...lines.length - 1){
			var splitText = splitText(lines[i]).split('\n');
			splitText[splitText.length - 1] += '\n';
			finalLines = finalLines.concat(splitText);
		}
		var splitText = splitText(lines[lines.length - 1]).split('\n');
		finalLines = finalLines.concat(splitText);

		return finalLines;
	}

	function getCurrentLine() : {value: String, startIndex: Int} {
		var lines = getAllLines();
		var currIndex = 0;
		for( i in 0...lines.length ) {
			if (i == cursorYIndex)
				return { value: lines[i], startIndex: currIndex };	
			currIndex += lines[i].length;
		}
		return { value: '', startIndex: -1 };
	}

	/**
		Returns the line index on which the given character index is on.
		When the index matches both the end of one line & the start of the next one, the first option is returned. 
	**/
	function resolveYIndex(index: Int) : Int {
		var lines = getAllLines();
		var currIndex = 0;
		for( i in 0...lines.length ) {
			var newCurrIndex = currIndex + lines[i].length;
			if( index <= newCurrIndex ) 
				return i;	
			currIndex = newCurrIndex;
		}
		return -1;
	}

	function getCursorXOffset() {
		var currLineIndex = resolveYIndex(cursorIndex);
		if (cursorYIndex > currLineIndex)
			return 0.;
		else {
			var currLine = getCurrentLine();
			return calcTextWidth(currLine.value.substr(0, cursorIndex - currLine.startIndex));
		}
	}

	function getCursorYOffset() {
		return cursorYIndex * font.lineHeight;
	}

	/**
		Returns a String representing currently selected text area or `null` if no text is selected.
	**/
	public function getSelectedText() : String {
		return selectionRange == null ? null : text.substr(selectionRange.start, selectionRange.length);
	}

	override function set_text(t:String) {
		super.set_text(t);
		if( cursorIndex > t.length ) {
			cursorIndex = t.length;
			cursorYIndex = getAllLines().length - 1;
		}
		return t;
	}

	override function set_font(f) {
		super.set_font(f);
		cursorTile = h2d.Tile.fromColor(0xFFFFFF, 1, font.size);
		cursorTile.dy = 2;
		selectionTile = h2d.Tile.fromColor(0x3399FF, 0, hxd.Math.ceil(font.lineHeight));
		return f;
	}

	override function initGlyphs(text:String, rebuild = true):Void {
		super.initGlyphs(text, rebuild);
		if( rebuild ) {
			this.calcWidth += cursorTile.width; // cursor end pos
			if( inputWidth != null && this.calcWidth > inputWidth ) this.calcWidth = inputWidth;
		}
	}

	function textPos( x : Float, y : Float ) : {lineIndex: Int, cursorIndex: Int} {
		x += scrollX;
		var lineIndex = Math.floor(y / font.lineHeight);
		var lines = getAllLines();
		lineIndex = hxd.Math.iclamp(lineIndex, 0, lines.length - 1);
		var selectedLine = lines[lineIndex];
		var pos = 0;
		for(i in 0...lineIndex) {
			pos += lines[i].length;
		}

		var linePos = 0;
		while( linePos < selectedLine.length ) {
			if( calcTextWidth(selectedLine.substr(0,linePos+1)) > x ) 
				break;		
			if ( selectedLine.charCodeAt(linePos) == '\n'.code)
				break;
			pos++;
			linePos++;
		}
		return {lineIndex: lineIndex, cursorIndex: pos};
	}

	override function sync(ctx) {
		var lines = getAllLines();
		interactive.width = (inputWidth != null ? inputWidth : maxWidth != null ? Math.ceil(maxWidth) : textWidth);
		interactive.height = font.lineHeight * lines.length;
		super.sync(ctx);
	}

	override function draw(ctx:RenderContext) {
		if( inputWidth != null ) {
			var h = localToGlobal(new h2d.col.Point(inputWidth, font.lineHeight));
			ctx.clipRenderZone(absX, absY, h.x - absX, h.y - absY);
		}

		if( cursorIndex >= 0 && (text != cursorText || cursorIndex != cursorXIndex || prevCursorYIndex != cursorYIndex) ) {
			if( cursorIndex > text.length ) {
				cursorIndex = text.length;
				cursorYIndex = getAllLines().length - 1;
			}
			cursorText = text;
			cursorXIndex = cursorIndex;
			prevCursorYIndex = cursorYIndex;
			cursorX = getCursorXOffset();
			cursorY = getCursorYOffset();
			if( inputWidth != null && cursorX - scrollX >= inputWidth )
				scrollX = cursorX - inputWidth + 1;
			else if( cursorX < scrollX && cursorIndex > 0 )
				scrollX = cursorX - hxd.Math.imin(inputWidth, Std.int(cursorX));
			else if( cursorX < scrollX )
				scrollX = cursorX;
		}

		absX -= scrollX * matA;
		absY -= scrollX * matC;

		if( selectionRange != null ) {
			var lines = getAllLines();
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
				if( selectionRange.start + selectionRange.length == text.length ) selectionSize += cursorTile.width; // last pixel

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

		if( inputWidth != null )
			ctx.popRenderZone();
	}

	/**
		Sets focus on this `TextInput`.
	**/
	public function focus() {
		interactive.focus();
		if( cursorIndex < 0 ) {
			cursorIndex = 0;
			cursorYIndex = 0;
			if( text != "" ) selectionRange = { start : 0, length : text.length };
		}
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