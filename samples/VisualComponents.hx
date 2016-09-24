/*
	Package h2d.comp contains some visual components to create IDE in Heaps.
	** This is no longer much maintained.
*/
class VisualComponents extends hxd.App {

	var document : h2d.comp.Component;
	
	override function init() {
		document = h2d.comp.Parser.fromHtml(hxd.res.Embed.getFileContent("components.html"),{ fmt : hxd.Math.fmt });
		s2d.addChild(document);
	}
	
	override function onResize() {
		document.setStyle(null);
	}

	static function main() {
		// make sure that arial.ttf is inside the current class path (remove "true" to get errors)
		// embedding the font will greatly improve visibility on flash (might be required on some targets)
		hxd.res.Embed.embedFont("Arial.ttf", true);
		new VisualComponents();
	}

}