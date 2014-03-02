package h2d.comp;

class Select extends Interactive {

	var tf : h2d.Text;
	var options : Array<{ label : String, value : Null<String> }>;
	var list : ItemList;
	public var value(default, null) : String;
	public var selectedIndex(default,set) : Int;
	
	public function new(?parent) {
		super("select", parent);
		tf = new h2d.Text(null, this);
		options = [];
		selectedIndex = 0;
	}

	override function onClick() {
		popup();
	}
	
	public function getOptions() {
		return options.copy();
	}
	
	public function popup() {
		if( list != null || options.length == 0 )
			return;
		var p : Component = this;
		while( p.parentComponent != null )
			p = p.parentComponent;
		list = new ItemList();
		list.onItemOver = function(i) onItemOver(i < 0 ? null : options[i].value);
		p.addChild(list);
		list.addClass("popup");
		list.evalStyle();
		for( o in options )
			new Label(o.label, list);
		updateListPos();
		list.selected = this.selectedIndex;
		list.onChange = function(i) {
			this.selectedIndex = i;
			needRebuild = true;
			close();
			this.onChange(value);
		};
		var scene = getScene();
		scene.startDrag(function(e) {
			if( e.kind == ERelease ) {
				scene.stopDrag();
				close();
			}
		},close);
	}
	
	public function close() {
		list.remove();
		list = null;
		getScene().stopDrag();
	}
	
	public dynamic function onChange( value : String ) {
	}

	function set_selectedIndex(i) {
		var o = options[i];
		value = o == null ? "" : (o.value == null ? o.label : o.value);
		if( i != selectedIndex ) needRebuild = true;
		return selectedIndex = i;
	}
	
	public function setValue(v) {
		var k = -1;
		for( i in 0...options.length )
			if( options[i].value == v ) {
				k = i;
				break;
			}
		if( k < 0 ) {
			for( i in 0...options.length )
				if( options[i].label == v ) {
					k = i;
					break;
				}
		}
		selectedIndex = k;
		return value;
	}
	
	
	function updateListPos() {
		var scene = getScene();
		var s = new h2d.css.Style();
		var pos = localToGlobal();
		s.offsetX = pos.x - extLeft();
		s.offsetY = pos.y - extTop();
		s.width = contentWidth + style.paddingLeft + style.paddingRight - (list.style.paddingLeft + list.style.paddingRight);
		var yMargin = (list.style.paddingBottom + list.style.paddingTop) * 0.5;
		var xMargin = (list.style.paddingLeft + list.style.paddingRight) * 0.5;
		var maxY = (scene != null ? scene.height : h3d.Engine.getCurrent().height) - (list.height + yMargin);
		var maxX = (scene != null ? scene.width : h3d.Engine.getCurrent().width) - (list.width + xMargin);
		if( s.offsetX > maxX )
			s.offsetX = maxX;
		if( s.offsetX < xMargin )
			s.offsetX = xMargin;
		if( s.offsetY > maxY )
			s.offsetY = maxY;
		if( s.offsetY < yMargin )
			s.offsetY = yMargin;
		if( list.customStyle == null || s.offsetX != list.customStyle.offsetX || s.offsetY != list.customStyle.offsetY || s.width != list.customStyle.width )
			list.setStyle(s);
	}
	
	public function clear() {
		options = [];
		needRebuild = true;
		selectedIndex = 0;
	}
	
	public function addOption(label, ?value) {
		options.push( { label : label, value : value } );
		needRebuild = true;
		if( selectedIndex == options.length - 1 )
			selectedIndex = selectedIndex; // update value
	}
	
	public dynamic function onItemOver( value : String ) {
	}

	override function resize( ctx : Context ) {
		if( ctx.measure ) {
			tf.font = getFont();
			tf.textColor = style.color;
			tf.text = options[selectedIndex] == null ? "" : options[selectedIndex].label;
			tf.filter = true;
			contentWidth = tf.textWidth;
			contentHeight = tf.textHeight;
		}
		super.resize(ctx);
		if( !ctx.measure && list != null )
			updateListPos();
	}
	
}