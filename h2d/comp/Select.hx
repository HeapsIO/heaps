package h2d.comp;

class Select extends Interactive {

	var tf : h2d.Text;
	var options : Array<{ label : String, value : Null<String> }>;
	var list : ItemList;
	public var selectedIndex : Int;
	
	public function new(?parent) {
		super("select", parent);
		tf = new h2d.Text(null, this);
		selectedIndex = 0;
		options = [];
	}

	override function onClick() {
		popup();
	}
	
	public function popup() {
		if( list != null )
			return;
		var p : h2d.Sprite = this;
		while( p.parent != null )
			p = p.parent;
		list = new ItemList();
		p.addChild(list);
		list.addClass("popup");
		list.evalStyle();
		for( o in options )
			new Label(o.label, list);
		updateListPos();
		list.selected = this.selectedIndex;
		list.onChange = function(i) {
			this.selectedIndex = i;
			list.remove();
			list = null;
			tf.text = options[i].label;
		};
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