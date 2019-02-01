class View extends h2d.Flow implements h2d.domkit.Object {

	static var SRC =
	<flow class="mybox" min-width="200" content-halign={align}>
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
		center = new h2d.Flow(s2d);
		center.horizontalAlign = center.verticalAlign = Middle;
		onResize();
		var view = new View(Right, center);

		var style = new h2d.domkit.Style();
		style.load(hxd.Res.style);
		style.applyTo(view);
	}

	override function onResize() {
		center.minWidth = center.maxWidth = s2d.width;
		center.minHeight = center.maxHeight = s2d.height;
	}

	static function main() {
		#if hl
		hxd.res.Resource.LIVE_UPDATE = true;
		hxd.Res.initLocal();
		#else
		hxd.Res.initEmbed();
		#end
		new Domkit();
	}

}
