
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
		var window = new h2d.comp.Box(scene);
		engine.onResized = function() window.setStyle(null);
		window.addCss("
			box {
				border : 1px solid red;
			}
			button.big {
				width : 500px;
			}
			slider.incr {
				increment : 0.1;
			}
		");
		new h2d.comp.Button("H/V Box", window).onClick = function() window.toggleClass(":vertical");
		new h2d.comp.Button("Absolute", window).onClick = function() window.toggleClass(":absolute");
		var b2 = new h2d.comp.Button("A slightly long one (styled with CSS)");
		b2.x = 50;
		b2.y = 100;
		b2.addClass("big");
		window.addChild(b2);
		b2.onClick = function() b2.text = "Clicked!";
		
		var b2 = new h2d.comp.Box(window);
		new h2d.comp.Button("Second", b2);
		
		var slider = new h2d.comp.Slider(window);
		var label = new h2d.comp.Label("", window);
		slider.onChange = function(v) {
			label.text = ""+h3d.FMath.fmt(v);
		};
		
		var slider = new h2d.comp.Slider(window);
		var label = new h2d.comp.Label("", window);
		slider.addClass("incr");
		slider.onChange = function(v) {
			label.text = ""+h3d.FMath.fmt(v);
		};

		
		// since it's not in a container, it does no get animated on rollover (margin don't apply on free position)
		var bs = new h2d.comp.Button("Standalone", scene);
		bs.x = scene.width - 100;
		bs.y = scene.height - 30;
	}
	
	function update() {
		engine.render(scene);
		scene.checkEvents();
	}
	
	static function main() {
		new Comps();
	}
	
}