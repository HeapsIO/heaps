import h2d.Tile;
import hxd.Key;
import h2d.Flow;
import h2d.Object;
import h2d.Text.Align;

class Flows extends hxd.App {

	// for animation
	var hAligns = [FlowAlign.Left, FlowAlign.Middle, FlowAlign.Right];
	var vAligns = [FlowAlign.Top, FlowAlign.Middle, FlowAlign.Bottom];

	var movingFlow : Flow;
	var reversedFlow : Array<Flow> = [];
	var vAlignChildFlow : Array<Flow> = [];
	var hAlignChildFlow : Array<Flow> = [];

	// for screens
	var idxFctDisplayed = 7; // also the first screen displayed
	var fctGenerationScreen : Array<Void -> Void> = []; // list of functions generating screen
	var currentFlows : Array<Flow> = []; // removed when switching screen

	override function init() {

		var font = hxd.res.DefaultFont.get();

		var colors = [0xff0000, 0x00ffff, 0xffffff, 0x00ff00, 0x0080ff, 0xff8000, 0x7000ff, 0xff00ff, 0x0000ff, 0xff007f, 0x808080, 0xe0e0e0];

		var spaceX = 10.0;
		var spaceY = 10.0;

		// Flows
		function createText(parent:Object, color : Int, text : String) {
			var flow = new Flow(parent);
			flow.backgroundTile = Tile.fromColor(colors[color]);
			flow.padding = 5;
			flow.horizontalSpacing = 15;
			flow.verticalSpacing = 15;

			var tf = new h2d.Text(font, flow);
			tf.textColor = 0x000000;
			tf.textAlign = Align.Left;
			tf.text = text;

			currentFlows.push(flow);
			return flow;
		}

		function createTitle(text : String) {
			return createText(s2d, 11, text + " - Use LEFT and RIGHT ARROWS to switch screen");
		}

		function createFlowSimple(parent:Object, x : Float, y : Float, size = 75) {
			var flow = new Flow(parent);
			flow.debug = true;
			flow.horizontalSpacing = 15;
			flow.verticalSpacing = 15;
			flow.padding = 10;
			flow.minHeight = Math.ceil(.5 * size);
			flow.minWidth = size;
			flow.backgroundTile = Tile.fromColor(0xaaaaaa);

			flow.x = x;
			flow.y = y;

			return flow;
		}

		function createFlow(parent:Object, color : Int, text : String, vAlign:FlowAlign, hAlign:FlowAlign, size = 100) {
			var flow = new Flow(parent);
			flow.debug = true;
			flow.horizontalAlign = hAlign;
			flow.verticalAlign = vAlign;
			flow.horizontalSpacing = 15;
			flow.verticalSpacing = 15;
			flow.padding = 5;
			flow.minHeight = Math.ceil(.5 * size);
			flow.minWidth = size;

			flow.backgroundTile = Tile.fromColor(0x888888);
		
			createText(flow, color, text);

			return flow;
		}
		
		function createFlowWithText(parent:Object, size : Int, vAlign: FlowAlign, hAlign : FlowAlign, text : String) {
			var flow = new Flow(parent);
			flow.debug = true;
			flow.verticalAlign = vAlign;
			flow.horizontalAlign = hAlign;
			flow.horizontalSpacing = 15;
			flow.verticalSpacing = 15;
			flow.padding = 10;
			flow.minHeight = Math.ceil(.5 * size);
			flow.minWidth = size;

			flow.backgroundTile = Tile.fromColor(0x888888);
		
			var tf = new h2d.Text(font, flow);
			tf.textColor = 0x000000;
			tf.textAlign = Align.Left;
			tf.text = text;

			return flow;
		}

		function screen0() : Void {
			var title = createTitle("0°) 9 flows with text inline");
			var yoffset = title.getBounds().height + spaceY;
			var xoffset = spaceX;

			var flow;

			flow = createFlowSimple(s2d, xoffset, yoffset);

			createFlow(flow, 1, "TopLeft", FlowAlign.Top, FlowAlign.Left);
			createFlow(flow, 2, "TopMiddle", FlowAlign.Top, FlowAlign.Middle);
			createFlow(flow, 3, "TopRight", FlowAlign.Top, FlowAlign.Right);

			createFlow(flow, 4, "CentLeft", FlowAlign.Middle, FlowAlign.Left);
			createFlow(flow, 5, "CentMiddle", FlowAlign.Middle, FlowAlign.Middle);
			createFlow(flow, 6, "CentRight", FlowAlign.Middle, FlowAlign.Right);

			createFlow(flow, 7, "BotLeft", FlowAlign.Bottom, FlowAlign.Left);
			createFlow(flow, 8, "BotMiddle", FlowAlign.Bottom, FlowAlign.Middle);
			createFlow(flow, 9, "BotRight", FlowAlign.Bottom, FlowAlign.Right);
			
			currentFlows.push(flow);
		}
		
		function screen1() : Void {
			var title = createTitle("1°) 3 flows with text inline in 3 flows inline");
			var yoffset = title.getBounds().height + spaceY;
			var xoffset = spaceX;

			var flow;
			var subFlow;

			flow = createFlowSimple(s2d, xoffset, yoffset);

			subFlow = createFlowSimple(flow, 0, 0);
			createFlow(subFlow, 1, "TopLeft", FlowAlign.Top, FlowAlign.Left);
			createFlow(subFlow, 2, "TopMiddle", FlowAlign.Top, FlowAlign.Middle);
			createFlow(subFlow, 3, "TopRight", FlowAlign.Top, FlowAlign.Right);

			subFlow = createFlowSimple(flow, 0, 0);
			createFlow(subFlow, 1, "CentLeft", FlowAlign.Middle, FlowAlign.Left);
			createFlow(subFlow, 2, "CentMiddle", FlowAlign.Middle, FlowAlign.Middle);
			createFlow(subFlow, 3, "CentRight", FlowAlign.Middle, FlowAlign.Right);

			subFlow = createFlowSimple(flow, 0, 0);
			createFlow(subFlow, 1, "BotLeft", FlowAlign.Bottom, FlowAlign.Left);
			createFlow(subFlow, 2, "BotMiddle", FlowAlign.Bottom, FlowAlign.Middle);
			createFlow(subFlow, 3, "BotRight", FlowAlign.Bottom, FlowAlign.Right);
			
			currentFlows.push(flow);
		}

		function screen2() : Void {
			var title = createTitle("2°) 1 flow with text in 1 flow in 1 flow : all alignments");
			var yoffset = title.getBounds().height + spaceY;
			var xoffset = spaceX;

			var flow = createFlowSimple(s2d, xoffset, yoffset);
			flow.minHeight = 200;
			flow.minWidth = 400;
			flow.verticalAlign = FlowAlign.Top;
			flow.horizontalAlign = FlowAlign.Left;
			flow.isVertical = true;

			var subFlow = createFlowSimple(flow, 0, 0);
			subFlow.minHeight = 100;
			subFlow.minWidth = 200;
			subFlow.verticalAlign = FlowAlign.Top;
			subFlow.horizontalAlign = FlowAlign.Left;
			movingFlow = createFlow(subFlow, 1, "Text", FlowAlign.Top, FlowAlign.Left);
			
			currentFlows.push(flow);
		}

		function screen3() : Void {
			var title = createTitle("3°) 3 flows with text inline inside 3 flows in column");
			var yoffset = title.getBounds().height + spaceY;
			var xoffset = spaceX;

			var flow;
			var subFlow;

			flow = createFlowSimple(s2d, xoffset, yoffset);
			flow.isVertical = true;

			subFlow = createFlowSimple(flow, 0, 0);
			createFlow(subFlow, 1, "TopLeft", FlowAlign.Top, FlowAlign.Left);
			createFlow(subFlow, 2, "TopMiddle", FlowAlign.Top, FlowAlign.Middle);
			createFlow(subFlow, 3, "TopRight", FlowAlign.Top, FlowAlign.Right);

			subFlow = createFlowSimple(flow, 0, 0);
			createFlow(subFlow, 4, "CentLeft", FlowAlign.Middle, FlowAlign.Left);
			createFlow(subFlow, 5, "CentMiddle", FlowAlign.Middle, FlowAlign.Middle);
			createFlow(subFlow, 6, "CentRight", FlowAlign.Middle, FlowAlign.Right);

			subFlow = createFlowSimple(flow, 0, 0);
			createFlow(subFlow, 7, "BotLeft", FlowAlign.Bottom, FlowAlign.Left);
			createFlow(subFlow, 8, "BotMiddle", FlowAlign.Bottom, FlowAlign.Middle);
			createFlow(subFlow, 9, "BotRight", FlowAlign.Bottom, FlowAlign.Right);
			
			currentFlows.push(flow);
		}

		function screen4() : Void {
			var title = createTitle("4°) Reversing");
			var yoffset = title.getBounds().height + spaceY;
			var xoffset = spaceX;
			
			var flow;
			
			function generateFlowsWithThreeFlowsWithThreeChilds(xoffset : Float, yoffset : Float, vAlign : FlowAlign, isVertical : Bool) {

				function generateFlowThreeChilds(xoffset : Float , yoffset : Float, vAlign : FlowAlign, hAlign: FlowAlign, isVertical : Bool) : Flow {
					var flow = createFlowSimple(s2d, xoffset, yoffset);
					flow.verticalAlign = vAlign;
					flow.horizontalAlign = hAlign;
					flow.isVertical = isVertical;
					createFlow(flow, 0, "A", FlowAlign.Middle, FlowAlign.Middle, 50);
					createFlow(flow, 3, "B", FlowAlign.Middle, FlowAlign.Middle, 50);
					createFlow(flow, 8, "C", FlowAlign.Middle, FlowAlign.Middle, 50);

					flow.minHeight = Math.ceil(flow.innerHeight + spaceY*5);
					flow.minWidth = Math.ceil(flow.innerWidth + spaceX*5);
					return flow;
				}
				while (reversedFlow.pop() != null) {};
				
				var flow = generateFlowThreeChilds(xoffset, yoffset, vAlign, FlowAlign.Left, isVertical);
				reversedFlow.push(flow);
				currentFlows.push(flow);

				xoffset += flow.getBounds().width + spaceX;
				flow = generateFlowThreeChilds(xoffset, yoffset, vAlign, FlowAlign.Middle, isVertical);
				reversedFlow.push(flow);
				currentFlows.push(flow);

				xoffset += flow.getBounds().width + spaceX;
				flow = generateFlowThreeChilds(xoffset, yoffset, vAlign, FlowAlign.Right, isVertical);
				reversedFlow.push(flow);
				currentFlows.push(flow);
				
				return flow;
			}

			// Are Not Vertical
			flow = generateFlowsWithThreeFlowsWithThreeChilds(xoffset, yoffset, FlowAlign.Top, false);
			
			yoffset += flow.getBounds().height + spaceY;
			flow = generateFlowsWithThreeFlowsWithThreeChilds(xoffset, yoffset, FlowAlign.Middle, false);
			
			yoffset += flow.getBounds().height + spaceY;
			flow = generateFlowsWithThreeFlowsWithThreeChilds(xoffset, yoffset, FlowAlign.Bottom, false);

			// Are Vertical
			yoffset += flow.getBounds().height + spaceY;
			xoffset = spaceX;
			flow = generateFlowsWithThreeFlowsWithThreeChilds(xoffset, yoffset, FlowAlign.Top, true);
			
			yoffset += flow.getBounds().height + spaceY;
			flow = generateFlowsWithThreeFlowsWithThreeChilds(xoffset, yoffset, FlowAlign.Middle, true);
			
			yoffset += flow.getBounds().height + spaceY;
			flow = generateFlowsWithThreeFlowsWithThreeChilds(xoffset, yoffset, FlowAlign.Bottom, true);
		}

		function screen5() : Void {
			var title = createTitle("5°) Multiline + MaxWidth reached | Multiline + MaxHeight reached");
			var yoffset = title.getBounds().height + spaceY;
			var xoffset = spaceX;

			var flow = createFlowSimple(s2d, xoffset, yoffset);
			flow.maxWidth = 400;
			flow.multiline = true;

			createFlow(flow, 1, "A", FlowAlign.Middle, FlowAlign.Middle);
			createFlow(flow, 2, "B", FlowAlign.Middle, FlowAlign.Middle);
			createFlow(flow, 3, "C", FlowAlign.Middle, FlowAlign.Middle);
			createFlow(flow, 4, "D", FlowAlign.Middle, FlowAlign.Middle);
			createFlow(flow, 5, "E", FlowAlign.Middle, FlowAlign.Middle);
			createFlow(flow, 6, "F", FlowAlign.Middle, FlowAlign.Middle);
			createFlow(flow, 7, "G", FlowAlign.Middle, FlowAlign.Middle);
			createFlow(flow, 8, "H", FlowAlign.Middle, FlowAlign.Middle);
			
			currentFlows.push(flow);

			xoffset += flow.getSize().width + spaceX;

			flow = createFlowSimple(s2d, xoffset, yoffset);
			flow.maxHeight = 200;
			flow.isVertical = true;
			flow.multiline = true;

			createFlow(flow, 1, "A", FlowAlign.Middle, FlowAlign.Middle);
			createFlow(flow, 2, "B", FlowAlign.Middle, FlowAlign.Middle);
			createFlow(flow, 3, "C", FlowAlign.Middle, FlowAlign.Middle);
			createFlow(flow, 4, "D", FlowAlign.Middle, FlowAlign.Middle);
			createFlow(flow, 5, "E", FlowAlign.Middle, FlowAlign.Middle);
			createFlow(flow, 6, "F", FlowAlign.Middle, FlowAlign.Middle);
			createFlow(flow, 7, "G", FlowAlign.Middle, FlowAlign.Middle);
			createFlow(flow, 8, "H", FlowAlign.Middle, FlowAlign.Middle);
			
			currentFlows.push(flow);
		}

		function screen6() : Void {
			var title = createTitle("6°) Child Properties");
			var yoffset = title.getBounds().height + spaceY;
			var xoffset = spaceX;

			var flow = createFlowSimple(s2d, xoffset, yoffset);
			flow.minHeight = 150;
			currentFlows.push(flow);

			while (vAlignChildFlow.pop() != null) {};

			vAlignChildFlow.push(createFlowWithText(flow, 1, FlowAlign.Middle, null, "v"));
			vAlignChildFlow.push(createFlowWithText(flow, 1, FlowAlign.Middle, null, "v"));
			vAlignChildFlow.push(createFlowWithText(flow, 1, FlowAlign.Middle, null, "v"));

			flow.getProperties(vAlignChildFlow[0]).verticalAlign = Top;
			flow.getProperties(vAlignChildFlow[1]).verticalAlign = Middle;
			flow.getProperties(vAlignChildFlow[2]).verticalAlign = Bottom;

			xoffset += flow.getSize().width + 15*spaceX;

			flow = createFlowSimple(s2d, xoffset, yoffset);
			flow.minWidth = 150;
			flow.isVertical = true;
			currentFlows.push(flow);

			while (hAlignChildFlow.pop() != null) {};

			hAlignChildFlow.push(createFlowWithText(flow, 1, FlowAlign.Middle, null, ">"));
			hAlignChildFlow.push(createFlowWithText(flow, 1, FlowAlign.Middle, null, ">"));
			hAlignChildFlow.push(createFlowWithText(flow, 1, FlowAlign.Middle, null, ">"));

			flow.getProperties(hAlignChildFlow[0]).horizontalAlign = Left;
			flow.getProperties(hAlignChildFlow[1]).horizontalAlign = Middle;
			flow.getProperties(hAlignChildFlow[2]).horizontalAlign = Right;
		}

		function screen7() : Void {
			var title = createTitle("7°) Points of the compass (Doesn't work !)");
			var yoffset = title.getBounds().height + spaceY;
			var xoffset = spaceX;

			var flow = createFlowSimple(s2d, xoffset, yoffset);
			flow.minHeight = 350;
			flow.minWidth = 350;
			currentFlows.push(flow);

			var subFlow;
			
			subFlow = createFlowWithText(flow, 1, FlowAlign.Middle, null, "S");
			flow.getProperties(subFlow).verticalAlign = FlowAlign.Bottom;
			flow.getProperties(subFlow).horizontalAlign = FlowAlign.Middle;

			subFlow = createFlowWithText(flow, 1, FlowAlign.Middle, null, "SE");
			flow.getProperties(subFlow).verticalAlign = FlowAlign.Bottom;
			flow.getProperties(subFlow).horizontalAlign = FlowAlign.Middle;

			subFlow = createFlowWithText(flow, 1, FlowAlign.Middle, null, "NO");
			flow.getProperties(subFlow).verticalAlign = FlowAlign.Top;
			flow.getProperties(subFlow).horizontalAlign = FlowAlign.Left;

			subFlow = createFlowWithText(flow, 1, FlowAlign.Middle, null, "N");
			flow.getProperties(subFlow).verticalAlign = FlowAlign.Top;
			flow.getProperties(subFlow).horizontalAlign = FlowAlign.Middle;
			
			subFlow = createFlowWithText(flow, 1, FlowAlign.Middle, null, "NE");
			flow.getProperties(subFlow).verticalAlign = FlowAlign.Top;
			flow.getProperties(subFlow).horizontalAlign = FlowAlign.Right;
			
			subFlow = createFlowWithText(flow, 1, FlowAlign.Middle, null, "O");
			flow.getProperties(subFlow).verticalAlign = FlowAlign.Middle;
			flow.getProperties(subFlow).horizontalAlign = FlowAlign.Left;
			
			subFlow = createFlowWithText(flow, 1, FlowAlign.Middle, null, "x");
			flow.getProperties(subFlow).verticalAlign = FlowAlign.Middle;
			flow.getProperties(subFlow).horizontalAlign = FlowAlign.Middle;
			
			subFlow = createFlowWithText(flow, 1, FlowAlign.Middle, null, "E");
			flow.getProperties(subFlow).verticalAlign = FlowAlign.Middle;
			flow.getProperties(subFlow).horizontalAlign = FlowAlign.Right;
			
			subFlow = createFlowWithText(flow, 1, FlowAlign.Middle, null, "SO");
			flow.getProperties(subFlow).verticalAlign = FlowAlign.Bottom;
			flow.getProperties(subFlow).horizontalAlign = FlowAlign.Left;

		}

		fctGenerationScreen.push(screen0);
		fctGenerationScreen.push(screen1);
		fctGenerationScreen.push(screen2);
		fctGenerationScreen.push(screen3);
		fctGenerationScreen.push(screen4);
		fctGenerationScreen.push(screen5);
		fctGenerationScreen.push(screen6);
		fctGenerationScreen.push(screen7);

		fctGenerationScreen[idxFctDisplayed]();

		onResize();
	}

	var lastUpdate = 0.5;
	override function update(dt:Float) {

		var screenSwitched = false;
		if (Key.isPressed(Key.LEFT)) {
			idxFctDisplayed -= 1;
			screenSwitched = true;
		}
		if (Key.isPressed(Key.RIGHT)) {
			idxFctDisplayed += 1;
			screenSwitched = true;
		}
		if (screenSwitched) {
			if (idxFctDisplayed < 0) {
				idxFctDisplayed = fctGenerationScreen.length-1;
			} else {
				idxFctDisplayed = idxFctDisplayed%(fctGenerationScreen.length);
			}
			for (f in currentFlows) {
				f.remove();
			}
			while (currentFlows.pop() != null) {};
			fctGenerationScreen[idxFctDisplayed]();
		}

		lastUpdate -= dt;
		switch (idxFctDisplayed) {
			case 2:
				if (lastUpdate < 0) {
					lastUpdate = .2;
					movingFlow.horizontalAlign = hAligns[(hAligns.indexOf(movingFlow.horizontalAlign)+1)%3];
					if (movingFlow.horizontalAlign == hAligns[0]) {
						movingFlow.verticalAlign = vAligns[(vAligns.indexOf(movingFlow.verticalAlign)+1)%3];
						
						if (movingFlow.verticalAlign == vAligns[0]) {
							var parent = Std.instance(movingFlow.parent, Flow);

							parent.horizontalAlign = hAligns[(hAligns.indexOf(parent.horizontalAlign)+1)%3];
							if (parent.horizontalAlign == hAligns[0]) {
								parent.verticalAlign = vAligns[(vAligns.indexOf(parent.verticalAlign)+1)%3];
								
								if (parent.verticalAlign == vAligns[0]) {
									
									var parent = Std.instance(parent.parent, Flow);

									parent.horizontalAlign = hAligns[(hAligns.indexOf(parent.horizontalAlign)+1)%3];
									if (parent.horizontalAlign == hAligns[0]) {
										parent.verticalAlign = vAligns[(vAligns.indexOf(parent.verticalAlign)+1)%3];
									}
								}
							}
						}
					}
				}

			case 4:
				if (lastUpdate < 0) {
					lastUpdate = 0.5;
					for (f in reversedFlow) {
						f.reverse = !f.reverse;
					}
				}
			case 6 : 
				if (lastUpdate < 0) {
					lastUpdate = 0.5;
					for (f in vAlignChildFlow) {
						var prop = currentFlows[1].getProperties(f);
						prop.verticalAlign = vAligns[(vAligns.indexOf(prop.verticalAlign)+1)%3];
					}
					for (f in hAlignChildFlow) {
						var prop = currentFlows[2].getProperties(f);
						prop.horizontalAlign = hAligns[(hAligns.indexOf(prop.horizontalAlign)+1)%3];
					}
				}
			default: 
		}
	}

	static function main() {
		hxd.Res.initEmbed();
		new Flows();
	}

}