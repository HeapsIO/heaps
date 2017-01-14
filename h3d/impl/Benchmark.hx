package h3d.impl;

private class QueryObject {

	var driver : h3d.impl.Driver;

	public var q : h3d.impl.Driver.Query;
	public var value : Float;
	public var name : String;
	public var drawCalls : Int;
	public var next : QueryObject;

	public function new() {
		driver = h3d.Engine.getCurrent().driver;
		q = driver.allocQuery(TimeStamp);
	}

	public function sync() {
		value = driver.queryResult(q);
	}

	public function isAvailable() {
		return driver.queryResultAvailable(q);
	}

}

private class StatsObject {
	public var name : String;
	public var time : Float;
	public var drawCalls : Int;
	public var next : StatsObject;
	public var xPos : Int;
	public var xSize : Int;
	public function new() {
	}
}

class Benchmark extends h2d.Graphics {

	var cachedStats : StatsObject;
	var currentStats : StatsObject;
	var cachedQueries : QueryObject;
	var currentFrame : QueryObject;
	var waitFrames : Array<QueryObject>;
	var engine : h3d.Engine;
	var stats : StatsObject;
	var labels : Array<h2d.Text>;
	var interact : h2d.Interactive;

	public var enable : Bool;

	public var width : Null<Int>;
	public var height = 16;
	public var textColor = 0;
	public var colors = new Array<Int>();
	public var font : h2d.Font;

	var tip : h2d.Text;
	var tipCurrent : StatsObject;
	var tipCurName : String;
	var curWidth : Int;

	public function new(?parent) {
		super(parent);
		waitFrames = [];
		labels = [];
		engine = h3d.Engine.getCurrent();
		enable = engine.driver.hasFeature(Queries);
		interact = new h2d.Interactive(0,0,this);
		interact.onMove = onMove;
		interact.cursor = Default;
		interact.onOut = function(_) {
			if( tip == null ) return;
			tip.remove();
			tip = null;
			tipCurrent = null;
		}
	}

	function onMove(e:hxd.Event) {
		var s = currentStats;
		while( s != null ) {
			if( e.relX >= s.xPos && e.relX <= s.xPos + s.xSize )
				break;
			s = s.next;
		}
		if( tip != null ) {
			tip.remove();
			tip = null;
			tipCurrent = null;
		}
		if( s == null )
			return;
		tip = new h2d.Text(font, this);
		tip.y = -20;
		tipCurrent = s;
		tipCurName = s.name;
		syncTip(s);
	}

	function syncTip(s:StatsObject) {
		tip.text = s.name+"(" + Std.int(s.time / 1000) + " us " + s.drawCalls + " draws)";
		var tw = tip.textWidth;
		var tx = s.xPos + ((s.xSize - tw) >> 1);
		if( tx + tw > curWidth ) tx = curWidth - tw;
		if( tx < 0 ) tx = 0;
		if( hxd.Math.abs(tip.x - tx) > 5 ) tip.x = tx;
	}

	public function begin() {

		if( !enable ) return;

		// end was not called...
		if( currentFrame != null )
			end();

		// sync with available frame
		var changed = false;
		while( waitFrames.length > 0 ) {
			var q = waitFrames[0];
			if( !q.isAvailable() )
				break;
			waitFrames.shift();

			// recycle previous stats
			var st = currentStats;
			while( st != null ) {
				var n = st.next;
				st.next = cachedStats;
				cachedStats = st;
				st = n;
			}
			currentStats = null;

			var prev : QueryObject = null;
			while( q != null ) {
				q.sync();
				if( prev != null ) {
					var s = allocStat();
					var dt = prev.value - q.value;
					if( s.name == q.name ) {
						// smooth
						var et = hxd.Math.abs(dt - s.time);
						if( et > 4e6 )
							s.time = dt;
						else
							s.time = s.time * 0.9 + dt * 0.1;
					} else {
						s.name = q.name;
						s.time = dt;
					}
					s.drawCalls = prev.drawCalls - q.drawCalls;
					s.next = currentStats;
					currentStats = s;
				}
				// recycle
				var n = q.next;
				q.next = cachedQueries;
				cachedQueries = q;
				prev = q;
				q = n;
			}
			// stats updated
			changed = true;
		}

		if( allocated && visible )
			syncVisual();

		measure("begin");
	}

	function syncVisual() {
		var s2d = getScene();
		clear();
		var width = width == null ? s2d.width : width;
		curWidth = width;
		beginFill(0, 0.5);
		drawRect(0, 0, width, height);

		interact.width = width;
		interact.height = height;

		var totalTime = 0.;
		var s = currentStats;
		while( s != null ) {
			totalTime += s.time;
			s = s.next;
		}

		var space = 40;
		width -= space;

		var count = 0;
		var xPos = 0;
		var curTime = 0.;
		var s = currentStats;
		while( s != null ) {
			if( colors.length < count ) {
				var color = new h3d.Vector();
				var m = new h3d.Matrix();
				m.identity();
				m.colorHue(count);
				color.setColor(0x3399FF);
				color.transform(m);
				colors.push(color.toColor());
			}

			curTime += s.time;
			var xEnd = Math.ceil(width * (curTime / totalTime));
			var xSize = xEnd - xPos;
			beginFill(colors[count]);
			drawRect(xPos, 0, xSize, height);

			var l = allocLabel(count);
			if( xSize < s.name.length * 4 )
				l.visible = false;
			else {
				l.text = s.name;
				l.x = xPos + ((xSize - l.textWidth) >> 1);
			}

			s.xPos = xPos;
			s.xSize = xSize;

			if( tipCurrent == s && tipCurName == s.name )
				syncTip(s);

			xPos = xEnd;
			count++;
			s = s.next;
		}

		var time = allocLabel(count++);
		time.x = xPos + 10;
		time.textColor = 0xFFFFFF;
		var timeMs = totalTime / 1e6;
		time.text = Std.int(timeMs) + "." + Std.int((timeMs * 10) % 10);

		while( labels.length > count )
			labels.pop().remove();
	}

	function allocLabel(index) {
		var l = labels[index];
		if( l != null )
			return l;
		if( font == null ) font = hxd.res.DefaultFont.get();
		l = new h2d.Text(font, this);
		l.textColor = textColor;
		labels[index] = l;
		return l;
	}

	public function end() {
		if( !enable ) return;
		measure("end");
		waitFrames.push(currentFrame);
		currentFrame = null;
	}

	function allocStat() {
		var s = cachedStats;
		if( s != null )
			cachedStats = s.next;
		else
			s = new StatsObject();
		return s;
	}

	function allocQuery() {
		var q = cachedQueries;
		if( q != null )
			cachedQueries = q.next;
		else
			q = new QueryObject();
		return q;
	}

	public function measure( name : String ) {
		if( !enable ) return;
		var q = allocQuery();
		q.name = name;
		q.drawCalls = engine.drawCalls;
		q.next = currentFrame;
		currentFrame = q;
		engine.driver.endQuery(q.q);
	}

}