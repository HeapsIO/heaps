package h3d.impl;
#if sceneprof

private class Frame {
	public var samples : Array<{ time : Float, sect: String, stack : Array<String> }> = [];
	public var startTime : Float;
	public function new() {
	}
}

private class StackLink {
	static var UID = 1;
	public var id : Int;
	public var elt : String;
	public var parent : StackLink;
	public var children : Map<String,StackLink> = new Map();
	public var written : Bool;
	public function new(elt) {
		id = UID++;
		this.elt = elt;
	}
	public function getChildren(elt:String) {
		var c = children.get(elt);
		if( c == null ) {
			c = new StackLink(elt);
			c.parent = this;
			children.set(elt,c);
		}
		return c;
	}
}

class SceneProf {
	static var frames : Array<Frame>;
	static var curFrame : Frame;
	static var lastFrameId = -1;
	static var enable = false;
    static var curSection : String;

	static var stackCache : Map<h3d.scene.Object, Array<String>>;
	static var stackCache2d : Map<h2d.Object, Array<String>>;

	public static function start() {
		enable = true;
		stackCache = new Map();
		stackCache2d = new Map();
		frames = [];
		lastFrameId = -1;
	}

	public static function stop() {
		enable = false;
	}

	public static function begin(section: String, frame : Int) {
		if(!enable) return;
		if(frame != lastFrameId) {
			var f = new Frame();
			f.startTime = Sys.time();
			frames.push(f);
			curFrame = f;
			lastFrameId = frame;
		}
        curSection = section;
	}

	static function getStack(o: h3d.scene.Object) : Array<String> {
		var r = stackCache.get(o);
		if(r != null)
			return r;
		var s = null;
		if(o.parent != null)
			s = getStack(o.parent).copy();
		else s = [];

		var name = o.name != null ? o.name : Type.getClassName(Type.getClass(o));
		s.unshift(name);
		stackCache.set(o, s);
		return s;
	}

	static function getStack2d(o: h2d.Object) : Array<String> {
		var r = stackCache2d.get(o);
		if(r != null)
			return r;
		var s = null;
		if(o.parent != null)
			s = getStack2d(o.parent).copy();
		else s = [];

		var name = o.name != null ? o.name : Type.getClassName(Type.getClass(o));
		s.unshift(name);
		stackCache2d.set(o, s);
		return s;
	}

	public static function mark(?o3d: h3d.scene.Object, ?o2d: h2d.Object) {
		if(!enable) return;
		var t = Sys.time();
		curFrame.samples.push({
			time: t,
			sect: curSection,
			stack: o3d != null ? getStack(o3d) : getStack2d(o2d)
		});
	}

	public static function end() {
		if(!enable) return;
		curFrame.samples.push({
			time: Sys.time(),
			sect: curSection,
			stack: []
		});
	}

	public static function save(outFile: String) {
		function makeStacks( st : Array<StackLink> ) {
			var write = [];
			for( s in st ) {
				var s = s;
				while( s != null ) {
					if( s.written ) break;
					s.written = true;
					write.push(s);
					s = s.parent;
				}
			}
			write.sort(function(s1,s2) return s1.id - s2.id);
			return [for( s in write ) {
				callFrame : {
					functionName : s.elt,
					scriptId : 0,
				},
				id : s.id,
				parent : s.parent == null ? null : s.parent.id,
			}];
		}

		var json : Array<Dynamic> = [
			{
    			pid : 0,
    			tid : 0,
 	 			ts : 0,
				ph : "M",
				cat : "__metadata",
				name : "thread_name",
				args : { name : "CrBrowserMain" }
			}
		];

		var count = 1;
		var f0 = frames[0];
		var t0 = f0.samples.length == 0 ? f0.startTime : f0.samples[0].time;

		var tid = 0;

		function timeStamp(t:Float) {
			return Std.int((t - t0) * 1000000) + 1;
		}

		var lastT = 0.;
		var rootStack = new StackLink("(root)");
		var profileId = count++;

		json.push({
			pid : 0,
			tid : tid,
			ts : 0,
			ph : "P",
			cat : "disabled-by-default-v8.cpu_profiler",
			name : "Profile",
			id : "0x"+profileId,
			args: { data : { startTime : 0 } },
		});

		for( f in frames ) {
			if( f.samples.length == 0 ) continue;
			json.push({
				pid : 0,
				tid : tid,
				ts : timeStamp(f.startTime),
				ph : "B",
				cat : "devtools.timeline",
				name : "FunctionCall",
			});
			json.push({
				pid : 0,
				tid : tid,
				ts : timeStamp(f.samples[f.samples.length-1].time),
				ph : "E",
				cat : "devtools.timeline",
				name : "FunctionCall"
			});
		}
		for( f in frames ) {
			if( f.samples.length == 0 ) continue;

			var timeDeltas = [];
			var allStacks = [];
			var lines = [];

			for( s in f.samples) {
				var st = rootStack;
				st = st.getChildren(s.sect);
				var line = 0;
				for( i in 0...s.stack.length ) {
					var s = s.stack[s.stack.length - 1 - i];
					st = st.getChildren(s);
				}
				allStacks.push(st);
				var t = Math.ffloor((s.time - t0) * 1000000);
				timeDeltas.push(t - lastT);
				lastT = t;
			}
			json.push({
				pid : 0,
				tid : tid,
				ts : 0,
				ph : "P",
				cat : "disabled-by-default-v8.cpu_profiler",
				name : "ProfileChunk",
				id : "0x"+profileId,
				args : {
					data : {
						cpuProfile : {
							nodes : makeStacks(allStacks),
							samples : [for( s in allStacks ) s.id]
						},
						timeDeltas : timeDeltas,
					}
				}
			});
		}
		sys.io.File.saveContent(outFile, haxe.Json.stringify(json));
	}
}
#end