class Comps {

	var engine : h3d.Engine;
	var scene : h2d.Scene;

	function new() {
		engine = new h3d.Engine();
		engine.onReady = init;
		engine.init();
		// make sure that arial.ttf is inside the current class path (remove "true" to get errors)
		// embedding the font will greatly improve visibility on flash (might be required on some targets)
		hxd.res.Embed.embedFont("Arial.ttf", true);
	}

	function init() {
		hxd.System.setLoop(update);
		scene = new h2d.Scene();
		var document = h2d.comp.Parser.fromHtml(hxd.res.Embed.getFileContent("components.html"),{ fmt : hxd.Math.fmt });
		scene.addChild(document);
		engine.onResized = function() document.setStyle(null);
		var rounded1: h2d.comp.Box = cast document.getElementById('rounded1');
		rounded1.onClick = function() {
			new h2d.comp.JQuery(document, '.window').toggleClass('showBorders');
		}
	}

	function update() {
		engine.render(scene);
	}

	static function main() {
		new Comps();
	}

}