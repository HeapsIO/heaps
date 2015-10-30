
class Main extends hxd.App {

	override function init() {
		var group = new h2d.Sprite(s2d);
		group.scale(0.5);
		var atlas = hxd.Res.Gorilla.toAtlas();
		var r = new hxd.fmt.spine.Library();
		r.loadText(hxd.Res.GorillaAnim.entry.getText());
	}

	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}


}