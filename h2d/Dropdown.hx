package h2d;

private class Fake extends Sprite {
	var dd : Dropdown;
	public function new(dd : Dropdown) {
		super(dd);
		this.dd = dd;
	}
	
	override function getBoundsRec(relativeTo:Sprite, out:h2d.col.Bounds, forSize:Bool) {
		super.getBoundsRec(relativeTo, out, forSize);
		if (dd.selectedItem >= 0) {
			var item = @:privateAccess dd.items[dd.selectedItem];
			var size = item.getSize();
			addBounds(relativeTo, out, 0, 0, size.width, size.height);
		}
	}
	
	override function draw(ctx) {
		if (dd.selectedItem >= 0) {
			var item = @:privateAccess dd.items[dd.selectedItem];
			var oldX = item.absX;
			var oldY = item.absY;
			item.absX = absX;
			item.absY = absY;
			item.drawRec(ctx);
			item.absX = oldX;
			item.absY = oldY;
		}
	}
}

class Dropdown extends Flow {
	var items : Array<h2d.Sprite>;
	var fake : Fake;
	var cursor : h2d.Bitmap;
	
	public var dropdownCursor(get,set) : h2d.Tile;
	public var dropdownList : Flow;
	public var dropdownLayer : Int = -1;
	public var selectedItem(default, set) : Int = -1;
	public var highlightedItem(default, null) : Int = -1;
	
	public function new(?parent) {
		super(parent);
		
		isVertical = false;
		dropdownList = new Flow();
		
		cursor = new h2d.Bitmap(h2d.Tile.fromColor(0x3399FF, 0, 0), dropdownList);
		dropdownList.getProperties(cursor).isAbsolute = true;
		dropdownList.isVertical = true;
		
		fake = new Fake(this);
		
		items = [];
		enableInteractive = true;
		
		interactive.onPush = function(e:hxd.Event) {
			if( e.button == 0 )
				interactive.focus();
		}
		interactive.onClick = function(e) {
			if (dropdownList.allocated) {
				close();
			} else {
				var bds = this.getBounds();
				dropdownList.y = bds.yMax;
				dropdownList.x = bds.xMin;
				dropdownList.minWidth = this.minWidth;
				open();
			}
		}
		
		interactive.onFocusLost = function(e) {
			if (highlightedItem >= 0) {
				selectedItem = highlightedItem;
			}
			close();
		}
		
		dropdownList.enableInteractive = true;
		dropdownList.interactive.onClick = function(e) {
			selectedItem = highlightedItem;
			close();
		}
		dropdownList.interactive.onMove = function(e : hxd.Event) {
			var clickPos = dropdownList.localToGlobal(new h2d.col.Point(e.relX, e.relY));
			for (i in 0...items.length) {
				var item = items[i];
				var bds = item.getBounds();
				if (clickPos.y >= bds.yMin && clickPos.y < bds.yMax) {
					if (highlightedItem != i) {
						if (highlightedItem >= 0) {
							onOutItem(items[highlightedItem]);
						}
						highlightedItem = i;
						if (cursor.tile.width != 0 && cursor.tile.height != 0) {
							cursor.visible = true;
							cursor.x = 0;
							cursor.y = item.y;
							cursor.tile.width = minWidth;
							cursor.tile.height = Std.int(item.getSize().height);
						}
						onOverItem(item);
					}
					break;
				}
			}
		}
		dropdownList.interactive.onOut = function(e : hxd.Event) {
			onOutItem(items[highlightedItem]);
			highlightedItem = -1;
			cursor.visible = false;
		}
		needReflow = true;
	}
	
	public function addItem(s : Sprite) {
		items.push(s);
		dropdownList.addChild(s);
		var width = Std.int(dropdownList.getSize().width);
		if( maxWidth != null && width > maxWidth ) width = maxWidth;
		minWidth = width;
	}
	
	function set_selectedItem(s) {
		if (s < 0) {
			return selectedItem = -1;
		} else if (s >= items.length) {
			return selectedItem = items.length - 1;
		}
		var item = items[s];
		var itemSize = item.getSize();
		minHeight = Std.int(itemSize.height);
		needReflow = true;
		return selectedItem = s;
	}
	
	public function open() {
		getScene().add(dropdownList, dropdownLayer);
		onOpen();
	}
	
	public function close() {
		dropdownList.remove();
		onClose();
	}
	
	public function get_dropdownCursor() {
		return cursor.tile;
	}
	
	public function set_dropdownCursor(c : h2d.Tile) {
		return cursor.tile = c;
	}
	
	public dynamic function onOpen() {
	}
	
	public dynamic function onClose() {
	}
	
	public dynamic function onOverItem(item : Sprite) {
	}
	
	public dynamic function onOutItem(item : Sprite) {
	}
}