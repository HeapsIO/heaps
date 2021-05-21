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

	public function dispose() {
		driver.deleteQuery(q);
		q = null;
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

	public var estimateWait = false;
	public var enable(default,set) : Bool;

	public var width : Null<Int>;
	public var height = 16;
	public var textColor = 0;
	public var colors = new Array<Int>();
	public var font : h2d.Font;

	public var recalTime = 1e9;
	public var smoothTime = 0.95;

	public var measureCpu = false;

	var tip : h2d.Text;
	var tipCurrent : StatsObject;
	var tipCurName : String;
	var curWidth : Int;
	var prevFrame : Float;
	var frameTime : Float;

	public function new(?parent) {
		super(parent);
		waitFrames = [];
		labels = [];
		engine = h3d.Engine.getCurrent();
		interact = new h2d.Interactive(0,0,this);
		interact.onMove = onMove;
		interact.cursor = Default;
		interact.onOut = function(_) {
			if( tip == null ) return;
			tip.parent.remove();
			tip = null;
			tipCurrent = null;
		}
		enable = engine.driver.hasFeature(Queries);
	}

	function set_enable(e) {
		if( !e )
			cleanup();
		return enable = e;
	}

	function cleanup() {
		while( waitFrames.length > 0 ) {
			var w = waitFrames.pop();
			while( w != null ) {
				w.dispose();
				w = w.next;
			}
		}
		while( cachedQueries != null ) {
			cachedQueries.dispose();
			cachedQueries = cachedQueries.next;
		}
		while( currentFrame != null ) {
			currentFrame.dispose();
			currentFrame = currentFrame.next;
		}
	}

	override function clear() {
		super.clear();
		if( labels != null ) {
			for( t in labels ) t.remove();
			labels = [];
		}
		if( interact != null ) interact.width = interact.height = 0;
	}

	override function onRemove() {
		super.onRemove();
		cleanup();
	}

	function onMove(e:hxd.Event) {
		var s = currentStats;
		while( s != null ) {
			if( e.relX >= s.xPos && e.relX <= s.xPos + s.xSize )
				break;
			s = s.next;
		}
		if( tip == null ) {
			var fl = new h2d.Flow(this);
			fl.y = -23;
			fl.backgroundTile = h2d.Tile.fromColor(0,1,1,0.8);
			fl.padding = 5;
			tip = new h2d.Text(font, fl);
			tip.dropShadow = { dx : 0, dy : 1, color : 0, alpha : 1 };
		}
		tipCurrent = s;
		tipCurName = s == null ? null : s.name;
		syncTip(s);
	}

	function syncTip(s:StatsObject) {
		if( s == null )
			tip.text = "total "+engine.drawCalls+" draws "+hxd.Math.fmt(engine.drawTriangles/1000000)+" Mtri";
		else
			tip.text = s.name+"( " + Std.int(s.time / 1e6) + "." + StringTools.lpad(""+(Std.int(s.time/1e4)%100),"0",2) + " ms " + s.drawCalls + " draws )";
		var tw = tip.textWidth + 10;
		var tx = s == null ? curWidth : s.xPos + ((s.xSize - tw) * .5);
		if( tx + tw > curWidth ) tx = curWidth - tw;
		if( tx < 0 ) tx = 0;
		if( hxd.Math.abs(tip.parent.x - tx) > 5 ) tip.parent.x = Std.int(tx);
	}

	public function begin() {

		if( !enable ) return;

		var t0 = haxe.Timer.stamp();
		var ft = (t0 - prevFrame) * 1e9;
		if( hxd.Math.abs(ft - frameTime) > recalTime )
			frameTime = ft;
		else
			frameTime = frameTime * smoothTime + ft * (1 - smoothTime);
		prevFrame = t0;

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
			var totalTime = 0.;
			while( q != null ) {
				if( !measureCpu ) q.sync();
				if( prev != null ) {
					var dt = prev.value - q.value;
					var s = allocStat(q.name, dt);
					totalTime += dt;
					s.drawCalls = prev.drawCalls - q.drawCalls;
					if( s.drawCalls < 0 ) s.drawCalls = 0;
				}
				// recycle
				var n = q.next;
				q.next = cachedQueries;
				cachedQueries = q;
				prev = q;
				q = n;
			}

			if( estimateWait ) {
				var waitT = frameTime - totalTime;
				if( waitT > 0 ) {
					if( hxd.Window.getInstance().vsync ) {
						var vst = 1e9 / hxd.System.getDefaultFrameRate() - totalTime;
						if( vst > waitT ) vst = waitT;
						if( vst > 0 ) {
							var s = allocStat("vsync", vst);
							s.drawCalls = 0;
							waitT -= vst;
						}
					}
					if( waitT > 0.5e6 /* 0.5 ms */ ) {
						var s = allocStat(measureCpu ? "gpuwait" : "cpuwait", waitT);
						s.drawCalls = 0;
					}
				}
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
		var old = labels;
		labels = null;
		clear();
		labels = old;

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

		var space = 52;
		width -= space;

		var count = 0;
		var xPos = 0;
		var curTime = 0.;
		var s = currentStats;
		while( s != null ) {
			if( colors.length <= count ) {
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
			if( xSize < s.name.length * 6 )
				l.visible = false;
			else {
				l.visible = true;
				l.textColor = textColor;
				l.text = s.name;
				l.x = xPos + Std.int((xSize - l.textWidth) * .5);
			}

			s.xPos = xPos;
			s.xSize = xSize;

			if( tipCurrent == s && tipCurName == s.name )
				syncTip(s);

			xPos = xEnd;
			count++;
			s = s.next;
		}

		if( tip != null && tipCurrent == null )
			syncTip(null);

		var time = allocLabel(count++);
		time.x = xPos + 3;
		time.y = -1;
		time.visible = true;
		time.textColor = 0xFFFFFF;
		var timeMs = totalTime / 1e6;
		time.text = Std.int(timeMs) + "." + Std.int((timeMs * 10) % 10) + (measureCpu?" cpu" : " gpu");

		while( labels.length > count )
			labels.pop().remove();
	}

	function allocLabel(index) {
		var l = labels[index];
		if( l != null )
			return l;
		if( font == null ) font = hxd.res.DefaultFont.get();
		l = new h2d.Text(font, this);
		labels[index] = l;
		return l;
	}

	public function end() {
		if( !enable ) return;
		measure("end");
		waitFrames.push(currentFrame);
		currentFrame = null;
	}

	function allocStat( name, time : Float ) {
		var s = cachedStats;
		if( s != null )
			cachedStats = s.next;
		else
			s = new StatsObject();
		if( name == s.name ) {
			// smooth
			var et = hxd.Math.abs(time - s.time);
			if( et > recalTime )
				s.time = time;
			else
				s.time = s.time * smoothTime + time * (1 - smoothTime);
		} else {
			s.name = name;
			s.time = time;
		}
		s.next = currentStats;
		currentStats = s;
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
		if( currentFrame != null && currentFrame.name == name )
			return;
		var q = allocQuery();
		q.name = name;
		q.drawCalls = engine.drawCalls;
		q.next = currentFrame;
		currentFrame = q;
		engine.driver.endQuery(q.q);
		if( measureCpu ) q.value = haxe.Timer.stamp() * 1e9;
	}

}