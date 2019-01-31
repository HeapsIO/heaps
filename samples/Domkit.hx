
class View extends h2d.Flow implements h2d.domkit.Object {

	static var SRC =
	<flow background="#024" padding="20" min-width="200" content-halign={align}>
		Hello World
	</flow>;

	public function new(align,?parent) {
		super(parent);
		initComponent();
	}

}

//PARAM=-lib domkit
class Domkit extends hxd.App {

	var center : h2d.Flow;

	override function init() {
		var view = new View(Right);
		center = new h2d.Flow(s2d);
		center.horizontalAlign = center.verticalAlign = Middle;

		center.addChild(view.document.root.obj);
		onResize();
	}

	override function onResize() {
		center.minWidth = center.maxWidth = s2d.width;
		center.minHeight = center.maxHeight = s2d.height;
	}

	static function main() {
		new Domkit();
	}

}
