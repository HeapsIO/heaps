
class Comps {
	
	var engine : h3d.Engine;
	var scene : h2d.Scene;
	
	function new() {
		engine = new h3d.Engine();
		engine.onReady = init;
		engine.init();
		// make sure that arial.ttf is inside the current class path (remove "true" to get errors)
		// emebedding the font will greatly improve visibility on flash (might be required on some targets)
		h2d.Font.embed("Arial", "arial.ttf", true);
	}
	
	function init() {
		flash.Lib.current.stage.addEventListener(flash.events.Event.ENTER_FRAME, function(_) update());
		scene = new h2d.Scene();
		var document = h2d.comp.Parser.fromHtml(h2d.comp.Context.getFile("components.html"),{ fmt : h3d.FMath.fmt });
		scene.addChild(document);
	}
	
	function update() {
		engine.render(scene);
		scene.checkEvents();
	}
	
	static function main() {
		new Comps();
	}
	
}