package h2d;

private class Fake extends Object {
	var dd : Dropdown;
	public function new(dd : Dropdown) {
		super(dd);
		this.dd = dd;
	}

	override function getBoundsRec(relativeTo:Object, out:h2d.col.Bounds, forSize:Bool) {
		super.getBoundsRec(relativeTo, out, forSize);
		if (dd.selectedItem >= 0) {
			var item = @:privateAccess dd.getItem(dd.selectedItem);
			var size = item.getSize();
			addBounds(relativeTo, out, 0, 0, size.width, size.height);
		}
	}

	override function draw(ctx) {
		if (dd.selectedItem >= 0) {
			var item = @:privateAccess dd.getItem(dd.selectedItem);
			var oldX = item.absX;
			var oldY = item.absY;
			item.absX = absX;
			item.absY = absY;
			for( c in item ) c.posChanged = true;
			item.drawRec(ctx);
			for( c in item ) c.posChanged = true;
			item.absX = oldX;
			item.absY = oldY;
		}
	}
}

/**
	A simple UI component that creates an interactive drop-down list.

	Dropdown will add an `h2d.Flow` to the `Scene` when opening in order to be visible above other objects. See `Dropdown.dropdownLayer` for more details.

	There is no handling of user input on items, and implementation of selection and other actions is up to the user.

	Note that when `dropdownList` opens and closes, item objects will receive the `onHierarchyChanged` callback.
**/
@:uiNoComponent
class Dropdown extends Flow {
	var fake : Fake;
	var cursor : h2d.Bitmap;
	var arrow : h2d.Bitmap;

	/**
		A background Tile that is shown when user hover over an item in the dropdown list.

		The tile will be stretched to cover full row width and item height during rendering.
	**/
	public var tileOverItem(default, set) : h2d.Tile;
	/**
		A Tile used to visualize an arrow of the dropdown when the list is closed.
	**/
	public var tileArrow(default, set) : h2d.Tile;
	/**
		A Tile used to visualize and arrow of the dropdown when the list is open.
	**/
	public var tileArrowOpen : h2d.Tile;

	/**
		When disabled, the user would not be able to change the selected item.
	**/
	public var canEdit(default,set) : Bool = true;
	/**
		A reference to the Flow that will contain the items.
	**/
	public var dropdownList : Flow;
	/**
		A Scene layer to which `dropdownList` will be added when opening dropdown.
	**/
	public var dropdownLayer : Int = 0;
	/**
		Currently selected item index. To deselect an item, set it to `-1`.
	**/
	public var selectedItem(default, set) : Int = -1;
	/**
		Currently highlighted item index.
	**/
	public var highlightedItem(default, null) : Int = -1;
	/**
		When enabled, the dropdown list will appear above the dropdown.
	**/
	public var rollUp : Bool = false;

	/**
		Create a new Dropdown with given parent.
		@param parent An optional parent `h2d.Object` instance to which Dropdown adds itself if set.
	**/
	public function new(?parent) {
		super(parent);

		canEdit = true;
		minHeight = maxHeight = 21;
		paddingLeft = 5;
		verticalAlign = Middle;
		reverse = true;

		tileOverItem = h2d.Tile.fromColor(0x303030, 1, 1);
		tileArrow = tileArrowOpen = h2d.Tile.fromColor(0x404040, maxHeight - 2, maxHeight - 2);

		backgroundTile = h2d.Tile.fromColor(0x101010);
		borderHeight = borderWidth = 1;

		dropdownList = new Flow(this);
		dropdownList.layout = Vertical;
		dropdownList.borderHeight = dropdownList.borderWidth = 1;
		dropdownList.paddingLeft = paddingLeft;
		dropdownList.visible = false;

		cursor = new h2d.Bitmap(tileOverItem, dropdownList);
		dropdownList.getProperties(cursor).isAbsolute = true;

		arrow = new h2d.Bitmap(tileArrow, this);
		var p = getProperties(arrow);
		p.horizontalAlign = Right;
		p.verticalAlign = Top;

		inline function setItem(i) {
			if( selectedItem != i ) {
				selectedItem = i;
				onChange(getItem(i));
			}
		}

		//
		fake = new Fake(this);
		enableInteractive = true;
		interactive.onPush = function(e:hxd.Event) {
			if( e.button == 0 && canEdit )
				interactive.focus();
		}
		interactive.onClick = function(e) {
			if (dropdownList.parent != this ) {
				close();
			} else if( canEdit ) {
				var bds = this.getBounds();
				dropdownList.x = bds.xMin;
				dropdownList.minWidth = this.minWidth;
				open();
				dropdownList.y = rollUp ? bds.yMin - dropdownList.getSize().height : bds.yMax;
			}
		}

		interactive.onFocusLost = function(e) {
			if (highlightedItem >= 0 && canEdit) {
				setItem(highlightedItem);
			}
			close();
		}

		dropdownList.enableInteractive = true;
		dropdownList.interactive.onClick = function(e) {
			if( canEdit ) setItem(highlightedItem);
			close();
		}
		dropdownList.interactive.onMove = function(e : hxd.Event) {
			var clickPos = dropdownList.localToGlobal(new h2d.col.Point(e.relX, e.relY));
			var items = getItems();
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
							cursor.x = 1;
							cursor.y = item.y;
							cursor.tile.width = minWidth - 2;
							cursor.tile.height = Std.int(item.getSize().height);
						}
						onOverItem(item);
					}
					break;
				}
			}
		}
		dropdownList.interactive.onOut = function(e : hxd.Event) {
			onOutItem(getItem(highlightedItem));
			highlightedItem = -1;
			cursor.visible = false;
		}
		needReflow = true;
	}

	function getItems() : Array<h2d.Object> {
		return [for( i => obj in dropdownList.children ) if( !dropdownList.properties[i].isAbsolute ) obj];
	}

	function getItem(index) {
		return getItems()[index];
	}

	override function set_backgroundTile(t) {
		super.set_backgroundTile(t);
		if(dropdownList != null) dropdownList.backgroundTile = t;
		return t;
	}

	function set_tileArrow(t) {
		if(arrow != null) arrow.tile = t;
		return tileArrow = t;
	}

	function set_tileOverItem(t) {
		if(cursor != null) cursor.tile = t;
		return tileOverItem = t;
	}

	/**
		Adds the Object `s` to the dropdown list. `s` is not restricted to be the same type across all items.
	**/
	public function addItem(s : Object) {
		dropdownList.addChild(s);
		var width = Std.int(dropdownList.getSize().width);
		if( maxWidth != null && width > maxWidth ) width = maxWidth;
		minWidth = hxd.Math.imax(minWidth, Std.int(width-arrow.getSize().width));
	}

	function set_canEdit(b) {
		if( !b ) close();
		alpha = b ? 1 : 0.7;
		return canEdit = b;
	}

	function set_selectedItem(s) {
		var items = getItems();
		if( s < 0 )
			s = -1;
		else if( s >= items.length )
			s = items.length - 1;
		var item = items[s];
		if( item != null )
			minHeight = Std.int(item.getSize().height);
		needReflow = true;
		return selectedItem = s;
	}

	/**
		Programmatically opens the dropdown, showing the dropdown list.
	**/
	public function open() {
		if( dropdownList.parent == this ) {
			getScene().add(dropdownList, dropdownLayer);
			dropdownList.visible = true;
			arrow.tile = tileArrowOpen;
			onOpen();
		}
	}

	/**
		Programmatically closes the dropdown, hiding the dropdown list.
	**/
	public function close() {
		if( dropdownList.parent != this ) {
			addChild(dropdownList);
			dropdownList.visible = false;
			arrow.tile = tileArrow;
			onClose();
		}
	}

	override function onRemove() {
		super.onRemove();
		if( dropdownList.parent != this )
			dropdownList.remove();
	}

	/**
		Sent when dropdown is being opened. Triggered both by user input and programmatic action via `Dropdown.open`.
	**/
	public dynamic function onOpen() {
	}

	/**
		Sent when dropdown is being closed. Triggered both by user input and programmatic action via `Dropdown.close`.
	**/
	public dynamic function onClose() {
	}

	/**
		Sent when user change the item in the list.
		@param item An object that was hovered.
	**/
	public dynamic function onChange(item : Object) {
	}

	/**
		Sent when user hovers over an item in the dropdown list.
		@param item An object that was hovered.
	**/
	public dynamic function onOverItem(item : Object) {
	}

	/**
		Sent when user moves mouse away from an item in the dropdown list.
		@param item An item that was hovered previously.
	**/
	public dynamic function onOutItem(item : Object) {
	}
}
