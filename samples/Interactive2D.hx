class Interactive2D extends SampleApp {

	var log:h2d.HtmlText;
	var simple : h2d.Interactive;

	public function new() {
		super();
	}


	override private function init()
	{
		super.init();

		log = new h2d.HtmlText(hxd.res.DefaultFont.get(), s2d);
		log.maxWidth = 600;
		log.x = 10;
		log.y = 10;

		simple = new h2d.Interactive(100, 30, s2d);
		simple.cursor = hxd.Cursor.Hide;

		new h2d.Bitmap(h2d.Tile.fromColor(0xffffff, 100, 30), simple);
		var simplePoint = new h2d.Bitmap(h2d.Tile.fromColor(0xff0000), simple);
		simple.onMove = function ( e : hxd.Event ) {
			simplePoint.x = e.relX;
			simplePoint.y = e.relY;
		}

	}

	override private function update(dt:Float)
	{
		super.update(dt);
		simple.rotation += dt * .1;
		var cos = Math.cos(simple.rotation);
		var sin = Math.sin(simple.rotation);
		var hw = -simple.width * .5;
		var hh = -simple.height * .5;
		simple.x = s2d.width  * .5 + (cos * hw - sin * hh);
		simple.y = s2d.height * .5 + (sin * hw + cos * hh);
	}

	static function main() {
		hxd.Res.initEmbed();
		new Interactive2D();
	}

}