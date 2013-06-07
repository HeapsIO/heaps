
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
		window.addClass("panel").addClass("window");
		engine.onResized = function() window.refresh();
		var box = new h2d.comp.Box(window);
		box.addClass("main");
		window.addCss("
			.window {
				layout : absolute;
				padding : 15;
			}
			button.big {
				width : 500px;
			}
			slider.incr {
				increment : 0.1;
			}
		");
		new h2d.comp.Button("H/V Box", box).onClick = function() box.toggleClass(":vertical");
		new h2d.comp.Button("Absolute", box).onClick = function() box.toggleClass(":absolute");
		var b2 = new h2d.comp.Button("A slightly long one (styled with CSS)");
		b2.x = 50;
		b2.y = 100;
		b2.addClass("big");
		box.addChild(b2);
		b2.onClick = function() b2.text = "Clicked!";
		
		var b2 = new h2d.comp.Box(box);
		var bord = new h2d.comp.Button("Show Borders", b2);
		var borders = false;
		bord.onClick = function() {
			borders = !borders;
			if( borders ) {
				window.addCss("
					box {
						border : 1px solid red;
					}
					label {
						border : 1px solid #0FF;
					}
				");
			} else {
				window.addCss("
					box {
						border : none;
					}
					label {
						border : none;
					}
				");
			}
		};
		
		var slider = new h2d.comp.Slider(box);
		var label = new h2d.comp.Label("", box);
		slider.onChange = function(v) {
			label.text = ""+h3d.FMath.fmt(v);
		};
		
		var slider = new h2d.comp.Slider(box);
		var label = new h2d.comp.Label("", box);
		slider.addClass("incr");
		slider.onChange = function(v) {
			label.text = ""+h3d.FMath.fmt(v);
		};

		var cb = new h2d.comp.Box(box);
		var lab = new h2d.comp.Label("OFF");
		new h2d.comp.Checkbox(cb).onChange = function(b) {
			lab.text = b ? "ON" : "OFF";
		};
		cb.addChild(lab);
		
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