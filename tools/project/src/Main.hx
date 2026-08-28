class Main extends hxd.App {

	static function main() {
		new Main();
	}

	override function loadAssets(onLoaded:() -> Void) {
		// Call hxd.Res.init here
		// hxd.Res.initEmbed();
		hxd.Res.initLocal();
		onLoaded();
	}

	override function init() {
		// Entry point
		
	}

}