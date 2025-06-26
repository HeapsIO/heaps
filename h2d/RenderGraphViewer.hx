package h2d;

import h2d.Graphics;
import h2d.Text;
import h2d.Font;
import h2d.Scene;
import hxd.res.DefaultFont;
import hxd.Math;

#if render_graph
import h3d.impl.RenderGraph;
import h3d.impl.RenderGraph.Frame;
import h3d.impl.RenderGraph.TexData;
import h3d.impl.RenderGraph.TargetSection;
import h3d.impl.RenderGraph.TargetsSection;
import h3d.impl.RenderGraph.TargetSectionBase;
import h3d.impl.RenderGraph.SampleTextureEvent;

class RenderGraphViewer extends h2d.Object {
	var cameraContainer : h2d.Object;
	var font : Font;
	var arrows : Array<Arrow>;
	var nodeGrid : Array<Array<GraphNode>>; // [col][row]
	var lastWrittenNode : Map<Int, GraphNode>;

	var backgroundLayer : h2d.Object;
	var sectionLayer : h2d.Object;

	public function new(scene:Scene) {
		super(scene);
		font = DefaultFont.get();
		arrows = [];
		nodeGrid = [];
		lastWrittenNode = new Map();

		cameraContainer = new h2d.Object(this);
		backgroundLayer = new h2d.Object(cameraContainer);
		sectionLayer = new h2d.Object(cameraContainer);

		if (RenderGraph.frame != null)
			buildGraph(RenderGraph.frame);

		var dragging = false;
		var lastMouse = new h2d.col.Point();
		var zoom = 1.0;
		hxd.Window.getInstance().addEventTarget(function(e) {
			switch e.kind {
			case EPush:
				dragging = true;
				lastMouse.set(e.relX, e.relY);

			case ERelease:
				dragging = false;

			case EMove:
				if (dragging) {
					var dx = e.relX - lastMouse.x;
					var dy = e.relY - lastMouse.y;
					cameraContainer.x += dx;
					cameraContainer.y += dy;
					lastMouse.set(e.relX, e.relY);
				}

			case EWheel:
				var zoomDelta = e.wheelDelta > 0 ? 1.1 : 0.9;
				var newZoom = Math.clamp(zoom * zoomDelta, 0.2, 3.0);

				var mouseX = e.relX;
				var mouseY = e.relY;

				var worldMouseX = (mouseX - cameraContainer.x) / zoom;
				var worldMouseY = (mouseY - cameraContainer.y) / zoom;

				zoom = newZoom;
				cameraContainer.scaleX = cameraContainer.scaleY = zoom;

				// Recaler pour que le point sous la souris reste fixe
				cameraContainer.x = mouseX - worldMouseX * zoom;
				cameraContainer.y = mouseY - worldMouseY * zoom;

			default:
			}
		});
	}

	public static inline var COL_WIDTH = 180;
	public static inline var ROW_HEIGHT = 80;
	public static inline var NODE_WIDTH = 60;
	public static inline var NODE_HEIGHT = 30;

	function buildGraph(frame:Frame) {
		var col = 0;

		var curSectionHash = "";
		for (section in frame.sections) {
			var sectionStartCol = col;

			for (target in section.targetSections) {
				var written = target.getTextureIds();
				if ( written.length == 0 )
					continue;
				var sectionHash = "";
				for ( t in written ) {
					var texData = frame.getTextureDataById(t);
					sectionHash += texData != null ? texData.name : "null";
				}
				var isSame = sectionHash == curSectionHash;
				if ( isSame )
					continue;
				curSectionHash = sectionHash;

				var colNodes = [];
				var colMaxRow = 0;

				for (row in 0...written.length) {
					var texId = written[row];
					var texData = frame.getTextureDataById(texId);
					if (texData == null) continue;

					var node = new GraphNode(texData, font);
					cameraContainer.addChild(node);
					colNodes.push(node);

					node.setPosition(col * COL_WIDTH, row * ROW_HEIGHT);
					colMaxRow = Std.int(Math.max(colMaxRow, row + 1));

					// Créer les flèches depuis les textures lues
					var sampled = getReadTextures(target);
					for (sampleId in sampled) {
						var from = lastWrittenNode.get(sampleId);
						if (from != null) {
							var arrow = new Arrow(from, node);
							arrows.push(arrow);
							cameraContainer.addChild(arrow);
							arrow.build();
						}
					}

					// Enregistrer le dernier writer
					lastWrittenNode.set(texId, node);
				}

				// Rectangle de fond pour TargetSection
				drawTargetBackground(col, colMaxRow);
				nodeGrid.push(colNodes);
				col++;
			}

			// Rectangle de fond + label pour RenderSection
			drawRenderSectionBackground(section.step, sectionStartCol, col - 1);
		}
	}

	function drawTargetBackground(col:Int, heightInRows:Int) {
		var g = new Graphics(sectionLayer);
		g.beginFill(0xffffff, 0.05);
		g.drawRect(col * COL_WIDTH - COL_WIDTH / 2, -20, COL_WIDTH, heightInRows * ROW_HEIGHT + 40);
		g.endFill();
	}

	function drawRenderSectionBackground(name:String, startCol:Int, endCol:Int) {
		var width = (endCol - startCol + 1) * COL_WIDTH;
		var height = 800; // Large valeur pour couvrir toutes les lignes
		var x = startCol * COL_WIDTH - COL_WIDTH / 2;
		var y = -40;

		var g = new Graphics(backgroundLayer);
		g.beginFill(0xffffff, 0.03);
		g.drawRect(x, y, width, height);
		g.endFill();

		var label = new Text(font, backgroundLayer);
		label.text = name;
		label.textColor = 0xffffff;
		label.x = x + 10;
		label.y = y + 5;
	}

	function getReadTextures(ts:TargetSectionBase):Array<Int> {
		var out = [];
		for (e in ts.events) {
			if (Std.isOfType(e, SampleTextureEvent)) {
				var ste = cast(e, SampleTextureEvent);
				if (!out.contains(ste.textureId))
					out.push(ste.textureId);
			}
		}
		return out;
	}
}


class GraphNode extends h2d.Object {
	public function new(data:TexData, font:Font) {
		super();
		var g = new Graphics(this);
		g.beginFill(0x4a90e2);
		g.drawRect(-30, -15, 60, 30);
		g.endFill();

		var txt = new Text(font, this);
		txt.text = data.name;
		txt.x = -txt.textWidth / 2;
		txt.y = -txt.textHeight / 2;
	}
}

class Arrow extends h2d.Object {
	var from:GraphNode;
	var to:GraphNode;

	public function new(from:GraphNode, to:GraphNode) {
		super();
		this.from = from;
		this.to = to;
	}

	public function build() {
		var g = new Graphics(this);
		var dx = to.x - from.x;
		var dy = to.y - from.y;
		var dist = Math.sqrt(dx * dx + dy * dy);
		var dirX = dx / dist;
		var dirY = dy / dist;

		var startX = from.x;
		var startY = from.y;
		var endX = to.x;
		var endY = to.y;

		g.lineStyle(2, 0xffffff);
		g.moveTo(startX, startY);
		g.lineTo(endX, endY);

		// Flèche
		var arrowSize = 6;
		var angle = Math.atan2(dy, dx);
		var left = angle + Math.PI * 0.75;
		var right = angle - Math.PI * 0.75;
		g.moveTo(endX, endY);
		g.lineTo(endX + Math.cos(left) * arrowSize, endY + Math.sin(left) * arrowSize);
		g.moveTo(endX, endY);
		g.lineTo(endX + Math.cos(right) * arrowSize, endY + Math.sin(right) * arrowSize);
	}
}
#end