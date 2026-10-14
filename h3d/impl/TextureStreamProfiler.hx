package h3d.impl;

import hxd.res.TextureStream;
import hxd.res.TextureStreamDebug;

class TextureStreamProfiler extends h2d.Object {

	static var current : TextureStreamProfiler;

	public static function toggle( parent : h2d.Object ) {
		if( current != null && current.parent != null ) {
			current.remove();
			current = null;
			return false;
		}
		current = new TextureStreamProfiler(parent);
		return true;
	}

	public var historyFrames(default, null) = 240;
	public var graphWidth = 480.;
	public var graphHeight = 64.;
	public var textRefreshFrames = 10;

	var font : h2d.Font;
	var root : h2d.Flow;
	var info : Table;
	var budgetText : h2d.Text;
	var budgetToggle : h2d.Flow;
	var budgetSlider : h2d.Slider;
	var budgetPercent = -1;
	var buttonColors = new Map<h2d.Flow, Int>();
	static inline var BUTTON = 0x3A4656;
	var timeGraph : h2d.Graphics;
	var countGraph : h2d.Graphics;
	var memoryGraph : h2d.Graphics;
	var timeScale : h2d.Text;
	var countScale : h2d.Text;
	var memoryScale : h2d.Text;
	var recent : Table;
	var notStreamedTotal : h2d.HtmlText;
	var notStreamedKinds : Table;
	var notStreamedLargest : Table;
	var textRefreshes = 0;
	static inline var MUTED = 0x9AA5B0;
	static inline var WARN = 0xFF7060;
	public var notStreamedTop = 8;

	var completionTime : Array<Float> = [];
	var completions : Array<Float> = [];
	var unloads : Array<Float> = [];
	var resident : Array<Float> = [];
	var budget : Array<Float> = [];
	var historyPos = 0;
	var stats : hxd.res.TextureStreamDebug.StreamStats;
	var frames = 0;

	public function new( ?parent : h2d.Object ) {
		super(parent);
		font = hxd.res.DefaultFont.get();
		x = y = 10;
		root = new h2d.Flow(this);
		root.layout = Vertical;
		root.verticalSpacing = 4;
		root.padding = 8;
		root.backgroundTile = h2d.Tile.fromColor(0x101418, 1, 1, 0.85);

		text("Texture streaming").textColor = 0xFFD080;
		info = new Table(font, root, null, [100, 0], [false, false]);
		info.verticalSpacing = 2;

		var row = new h2d.Flow(root);
		row.horizontalSpacing = 4;
		row.verticalAlign = Middle;
		row.paddingTop = 4;
		var label = new h2d.Text(font, row);
		label.text = "Virtual budget";
		label.textColor = MUTED;
		row.getProperties(label).minWidth = 104;
		budgetToggle = button(row, "Off", toggleBudget);
		budgetSlider = new h2d.Slider(200, 14, row);
		budgetSlider.maxValue = 100;
		budgetSlider.onChange = setBudgetPercent;
		row.getProperties(budgetSlider).paddingLeft = 6;
		budgetText = new h2d.Text(font, row);
		row.getProperties(budgetText).paddingLeft = 6;

		section("Mip loads time per frame", '${color(0xFF9040, "allocation and upload")}  ${color(0xFFD080, "budget")}');
		timeGraph = new h2d.Graphics(root);
		timeScale = scaleLabel(timeGraph);
		section("Mip changes per frame", '${color(0x60E070, "loads")}  ${color(0x60A0FF, "unloads")}');
		countGraph = new h2d.Graphics(root);
		countScale = scaleLabel(countGraph);
		section("Streamed memory", '${color(0x60E070, "resident")}  ${color(0x808890, "full resolution")}  ${color(0xFF6050, "budget")}');
		memoryGraph = new h2d.Graphics(root);
		memoryScale = scaleLabel(memoryGraph);
		section("Recent mips loads", "");
		recent = new Table(font, root, ["frame", "alloc", "upload", "queued", "mips", "MB", "texture"], [50, 60, 60, 70, 50, 50, 0], [true, true, true, true, false, true, false]);
		section("Not streamed", "");
		notStreamedTotal = new h2d.HtmlText(font, root);
		notStreamedKinds = new Table(font, root, ["MB", "kind", "count"], [50, 100, 0], [true, false, false]);
		notStreamedLargest = new Table(font, root, ["MB", "kind", "size", "format", "mips", "texture"], [50, 100, 90, 100, 50, 0], [true, false, false, false, false, false]);
	}

	function section( title : String, legend : String ) {
		var row = new h2d.Flow(root);
		row.horizontalSpacing = 12;
		row.paddingTop = 4;
		new h2d.Text(font, row).text = title;
		if( legend != "" ) {
			var l = new h2d.HtmlText(font, row);
			l.textColor = MUTED;
			l.text = legend;
		}
	}

	function scaleLabel( graph : h2d.Graphics ) {
		var t = new h2d.Text(font, graph);
		t.textColor = MUTED;
		t.setPosition(graphWidth + 6, 0);
		return t;
	}

	function text( s : String ) {
		var t = new h2d.Text(font, root);
		t.text = s;
		return t;
	}

	function button( parent : h2d.Object, label : String, onClick : Void -> Void ) {
		var f = new h2d.Flow(parent);
		f.paddingHorizontal = 6;
		f.paddingVertical = 2;
		f.minWidth = 36;
		f.horizontalAlign = Middle;
		new h2d.Text(font, f).text = label;
		setButtonColor(f, BUTTON);
		f.enableInteractive = true;
		f.interactive.cursor = Button;
		f.interactive.onOver = _ -> if( f.alpha == 1 ) f.backgroundTile = h2d.Tile.fromColor(0x56677D);
		f.interactive.onOut = _ -> f.backgroundTile = h2d.Tile.fromColor(buttonColors.get(f));
		f.interactive.onClick = _ -> {
			if( f.alpha < 1 ) return;
			onClick();
			refreshTexts();
		};
		return f;
	}

	function setButtonColor( f : h2d.Flow, color : Int ) {
		buttonColors.set(f, color);
		f.backgroundTile = h2d.Tile.fromColor(color);
	}

	function setButtonLabel( f : h2d.Flow, label : String ) {
		for( c in f ) {
			var t = Std.downcast(c, h2d.Text);
			if( t != null && t.text != label ) t.text = label;
		}
	}

	function toggleBudget() {
		if( TextureStream.debugBudget >= 0 ) {
			TextureStream.debugBudget = -1;
			return;
		}
		initBudgetPercent();
		if( budgetPercent >= 0 )
			TextureStream.debugBudget = stats.fullBytes * budgetPercent / 100;
	}

	function initBudgetPercent() {
		if( budgetPercent < 0 && stats != null && stats.fullBytes > 0 )
			budgetPercent = Math.floor(Math.min(TextureStream.residentBytes / stats.fullBytes, 1) * 100);
	}

	function setBudgetPercent() {
		var full = stats == null ? 0. : stats.fullBytes;
		if( full <= 0 ) return;
		budgetPercent = Math.round(budgetSlider.value);
		TextureStream.debugBudget = full * budgetPercent / 100;
		refreshBudgetControls();
	}

	function refreshBudgetControls() {
		var on = TextureStream.debugBudget >= 0;
		setButtonLabel(budgetToggle, on ? "On" : "Off");
		setButtonColor(budgetToggle, on ? 0x3C7A46 : BUTTON);
		if( on && stats != null && stats.fullBytes > 0 )
			budgetPercent = Math.round(TextureStream.debugBudget / stats.fullBytes * 100);
		else
			initBudgetPercent();
		if( budgetPercent >= 0 ) budgetSlider.value = budgetPercent;
		budgetSlider.alpha = on ? 1 : 0.4;
		budgetText.text = budgetPercent < 0 ? "" : on ? '$budgetPercent% of full resolution (${mb(TextureStream.debugBudget)} MB)' : '$budgetPercent% (off)';
	}

	override function onAdd() {
		super.onAdd();
		TextureStreamDebug.PROFILING = true;
	}

	override function onRemove() {
		super.onRemove();
		TextureStreamDebug.PROFILING = false;
		TextureStream.debugBudget = -1;
		if( current == this ) current = null;
	}

	override function sync( ctx : h2d.RenderContext ) {
		var fs = TextureStreamDebug.frameStats;
		var full = completionTime.length == historyFrames;
		push(completionTime, fs.completionTime);
		push(completions, fs.completions);
		push(unloads, fs.unloads);
		push(resident, TextureStream.residentBytes);
		push(budget, TextureStream.getBudget());
		// once full, the arrays are rings whose oldest entry is at historyPos
		if( full ) historyPos = (historyPos + 1) % historyFrames;
		if( stats == null || frames++ % textRefreshFrames == 0 )
			refreshTexts();
		drawTime();
		drawCounts();
		drawMemory();
		super.sync(ctx);
	}

	function push( a : Array<Float>, v : Float ) {
		if( a.length < historyFrames ) a.push(v) else a[historyPos] = v;
	}

	inline function at( a : Array<Float>, i : Int ) {
		return a[(historyPos + i) % a.length];
	}

	static inline function mb( v : Float ) {
		return fixed1(v / (1024 * 1024));
	}

	static inline function ms( v : Float ) {
		return fixed1(v * 1000);
	}

	static function fixed1( v : Float ) {
		var i = Math.round(v * 10);
		var sign = i < 0 ? "-" : "";
		if( i < 0 ) i = -i;
		return sign + Std.int(i / 10) + "." + (i % 10);
	}

	static function color( c : Int, s : String ) {
		return '<font color="#${StringTools.hex(c, 6)}">$s</font>';
	}

	function refreshTexts() {
		stats = TextureStreamDebug.getStats();
		var s = stats;
		var infoRows = [], infoColors = [];
		function row( label : String, value : String, warn = false ) {
			infoRows.push([label, value]);
			infoColors.push([MUTED, warn ? WARN : -1]);
		}
		row("Streamed", '${s.count} textures, ${mb(s.residentBytes)} MB resident of ${mb(s.fullBytes)} MB at full resolution');
		row("Visible", '${s.visible} textures, ${mb(s.visibleBytes)} MB');
		row("Hidden", '${s.hidden} textures, ${mb(s.hiddenBytes)} MB');
		row("Unloadable", '${mb(s.freeableBytes)} MB in ${s.freeable} hidden textures, ${s.freeable - s.freeableWaiting} ready');
		var budgets = [];
		budgets.push("MEMORY_BUDGET " + (TextureStream.MEMORY_BUDGET < 0 ? "off" : mb(TextureStream.MEMORY_BUDGET) + " MB"));
		budgets.push("MIN_GPU_FREE " + (TextureStream.MIN_GPU_FREE < 0 ? "off" : mb(TextureStream.MIN_GPU_FREE) + " MB"));
		budgets.push("virtual " + (TextureStream.debugBudget < 0 ? "off" : mb(TextureStream.debugBudget) + " MB"));
		row("Budgets", budgets.join(", "));
		if( s.excessBytes == Math.NEGATIVE_INFINITY )
			row("Excess", "no budget");
		else
			row("Excess", s.excessBytes > 0 ? mb(s.excessBytes) + " MB over budget" : mb(-s.excessBytes) + " MB under budget", s.excessBytes > 0);
		row("Max size", s.maxVisibleSize > 0 ? s.maxVisibleSize + " px" : "none", s.maxVisibleSize > 0);
		row("Status", s.status == "" ? "-" : s.status);
		row("Disk reads", '${s.readsQueued} queued, ${s.readsInFlight} reading, ${s.completedWaiting} read and waiting to be applied');
		if( s.gpuUsed >= 0 )
			row("VRAM", '${mb(s.gpuUsed)} MB used of ${mb(s.gpuBudget)} MB' + (s.gpuUsed > s.gpuBudget ? " (over budget)" : ""), s.gpuUsed > s.gpuBudget);
		if( s.heapsTextureBytes >= 0 )
			row("Allocated", 'textures ${mb(s.heapsTextureBytes)} MB, buffers ${mb(s.heapsBufferBytes)} MB');
		info.setRows(infoRows, infoColors);
		refreshBudgetControls();

		var rows = [], colors = [];
		var list = TextureStreamDebug.recentCompletions;
		var i = list.length - 1;
		while( i >= 0 ) {
			var c = list[i--];
			var upload = c.mainTime - c.allocTime;
			rows.push(["" + c.frame, ms(c.allocTime) + " ms", ms(upload) + " ms", ms(c.waitTime) + " ms", c.fromMip + " > " + c.toMip, "" + mb(c.bytes), shortName(c.name)]);
			// over the frame budget : the larger part is shown in red
			var over = c.mainTime > TextureStream.COMPLETION_TIME_BUDGET;
			colors.push(over ? [-1, c.allocTime >= upload ? WARN : -1, upload > c.allocTime ? WARN : -1, -1, -1, -1, -1] : null);
		}
		recent.setRows(rows, colors);

		if( textRefreshes++ % 6 == 0 ) {
			var tm = TextureStreamDebug.getNotStreamedMemory(notStreamedTop);
			notStreamedTotal.text = '${color(0xFFD080, mb(tm.bytes) + " MB")} in ${tm.count} textures';
			notStreamedKinds.setRows([for( c in tm.categories ) [mb(c.bytes), c.name, "" + c.count]]);
			notStreamedLargest.setRows([for( e in tm.largest ) ["" + mb(e.bytes), e.category, e.size, e.format, e.mips, shortName(e.name)]]);
		}
	}

	static function shortName( name : String ) {
		return name.length > 60 ? "..." + name.substr(name.length - 57) : name;
	}

	function drawTime() {
		var g = clearGraph(timeGraph);
		var max = TextureStream.COMPLETION_TIME_BUDGET * 4;
		for( v in completionTime ) if( v > max ) max = v;
		var w = graphWidth / historyFrames;
		g.beginFill(0xFF9040);
		for( i in 0...completionTime.length ) {
			var h = at(completionTime, i) / max * graphHeight;
			if( h > 0 ) g.drawRect(i * w, graphHeight - h, Math.max(w - 1, 1), h);
		}
		g.endFill();
		var y = graphHeight - TextureStream.COMPLETION_TIME_BUDGET / max * graphHeight;
		g.lineStyle(1, 0xFFD080, 0.8);
		g.moveTo(0, y);
		g.lineTo(graphWidth, y);
		g.lineStyle();
		setLabel(timeScale, 'top : ${ms(max)} ms');
	}

	function drawCounts() {
		var g = clearGraph(countGraph);
		var max = 4.;
		for( v in completions ) if( v > max ) max = v;
		for( v in unloads ) if( v > max ) max = v;
		line(g, completions, 0x60E070, v -> graphHeight - v / max * (graphHeight - 2));
		line(g, unloads, 0x60A0FF, v -> graphHeight - v / max * (graphHeight - 2));
		g.lineStyle();
		setLabel(countScale, 'top : ${Math.round(max)}');
	}

	function clearGraph( g : h2d.Graphics ) {
		g.clear();
		g.beginFill(0x000000, 0.5);
		g.drawRect(0, 0, graphWidth, graphHeight);
		g.endFill();
		return g;
	}

	function setLabel( t : h2d.Text, s : String ) {
		if( t.text != s ) t.text = s;
	}

	function drawMemory() {
		var g = clearGraph(memoryGraph);
		var full = stats == null ? 0. : stats.fullBytes;
		var max = full;
		for( v in resident ) if( v > max ) max = v;
		for( v in budget ) if( v > max ) max = v;
		if( max <= 0 ) return;
		inline function toY( v : Float ) return graphHeight - v / max * (graphHeight - 2);
		g.lineStyle(1, 0x808890, 0.8);
		g.moveTo(0, toY(full));
		g.lineTo(graphWidth, toY(full));
		line(g, budget, 0xFF6050, v -> v < 0 ? Math.NaN : toY(v));
		line(g, resident, 0x60E070, v -> toY(v));
		g.lineStyle();
		setLabel(memoryScale, 'top : ${mb(max)} MB');
	}

	function line( g : h2d.Graphics, values : Array<Float>, color : Int, toY : Float -> Float ) {
		var w = graphWidth / historyFrames;
		g.lineStyle(1, color);
		var drawing = false;
		for( i in 0...values.length ) {
			var y = toY(at(values, i));
			if( Math.isNaN(y) ) {
				drawing = false;
				continue;
			}
			if( drawing ) g.lineTo(i * w + w * 0.5, y) else g.moveTo(i * w + w * 0.5, y);
			drawing = true;
		}
	}

}

@:access(h3d.impl.TextureStreamProfiler)
private class Table extends h2d.Flow {

	var font : h2d.Font;
	var widths : Array<Int>;
	var rights : Array<Bool>;
	var rows : Array<{ flow : h2d.Flow, cells : Array<h2d.Text> }> = [];
	var first : Int;

	public function new( font : h2d.Font, parent : h2d.Object, header : Null<Array<String>>, widths : Array<Int>, rights : Array<Bool> ) {
		super(parent);
		this.font = font;
		this.widths = widths;
		this.rights = rights;
		layout = Vertical;
		first = header == null ? 0 : 1;
		if( header != null ) {
			var h = addRow();
			for( i in 0...header.length ) {
				h.cells[i].text = header[i];
				h.cells[i].textColor = TextureStreamProfiler.MUTED;
			}
		}
	}

	function addRow() {
		var flow = new h2d.Flow(this);
		flow.horizontalSpacing = 12;
		var cells = [];
		for( i in 0...widths.length ) {
			var cell = new h2d.Flow(flow);
			if( widths[i] > 0 ) cell.minWidth = widths[i];
			cell.horizontalAlign = rights[i] ? Right : Left;
			cells.push(new h2d.Text(font, cell));
		}
		var r = { flow : flow, cells : cells };
		rows.push(r);
		return r;
	}

	public function setRows( data : Array<Array<String>>, ?colors : Array<Array<Int>> ) {
		while( rows.length - first < data.length )
			addRow();
		for( r in first...rows.length ) {
			var row = rows[r];
			var values = data[r - first];
			row.flow.visible = values != null;
			if( values == null ) continue;
			var rowColors = colors == null ? null : colors[r - first];
			for( i in 0...row.cells.length ) {
				var c = row.cells[i];
				var v = values[i] == null ? "" : values[i];
				if( c.text != v ) c.text = v;
				c.textColor = rowColors == null || rowColors[i] < 0 ? 0xFFFFFF : rowColors[i];
			}
		}
	}
}
