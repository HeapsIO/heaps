package h2d.comp;

class ItemList extends Box {
	
	public var selected(default,set) = -1;
	var inputs : Array<h2d.Interactive>;
	
	public function new(?parent) {
		super(Vertical, parent);
		this.name = "itemlist";
		inputs = [];
	}
	
	function set_selected(v:Int) {
		needRebuild = true;
		return selected = v;
	}
	
	override function resizeRec( ctx : Context ) {
		super.resizeRec(ctx);
		if( !ctx.measure ) {
			while( inputs.length < components.length )
				inputs.push(new h2d.Interactive(0, 0, this));
			while( inputs.length > components.length )
				inputs.pop().remove();
			for( i in 0...components.length ) {
				var c = components[i];
				var int = inputs[i];
				var selected = selected == i;
				var cursor = null;
				int.x = -style.paddingLeft;
				int.y = c.y - style.verticalSpacing * 0.5;
				int.width = contentWidth + style.paddingLeft + style.paddingRight;
				int.height = c.height + style.verticalSpacing;
				var oldCursor = int.getChildAt(0);
				if( oldCursor != null ) oldCursor.remove();
				if( selected ) {
					cursor = new h2d.Bitmap(h2d.Tile.fromColor(style.selectionColor, Std.int(int.width), Std.int(int.height)), int);
					int.onOver = function(_) {
					};
					int.onOut = function(_) {
					}
					int.onPush = function(_) {
					}
				} else {
					int.onOver = function(_) {
						if( cursor != null ) cursor.remove();
						cursor = new h2d.Bitmap(h2d.Tile.fromColor(style.cursorColor, Std.int(int.width), Std.int(int.height)), int);
					};
					int.onOut = function(_) {
						if( cursor != null ) cursor.remove();
						cursor = null;
					}
					int.onPush = function(_) {
						if( this.selected != i ) {
							this.selected = i;
							onChange(i);
						}
					}
				}
				//childs.remove(int);
				//childs.insert(1, int); // insert over bg
				addChildAt(int, 1);
				addChild(c);
			}
		}
	}
	
	public dynamic function onChange( selected : Int ) {
	}
	
}