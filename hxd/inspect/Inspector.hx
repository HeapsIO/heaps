package hxd.inspect;
import cdb.jq.JQuery;
import hxd.inspect.Property;

private class DrawEvent implements h3d.IDrawable {
	var i : Inspector;
	public function new(i) {
		this.i = i;
	}
	public function render( engine : h3d.Engine ) {
		i.sync();
	}
}

class Tool {
	public var name(default,set) : String;
	public var icon(default,set) : String;
	public var title(default,set) : String;
	public var click : Void -> Void;
	public var j : JQuery;
	public var jicon : JQuery;
	public var active(get, set) : Bool;
	public function new() {
	}
	function get_active() {
		return j.hasClass("active");
	}
	function set_active(v) {
		j.toggleClass("active", v);
		return v;
	}
	function set_name(v) {
		jicon.attr("alt", v);
		return name = v;
	}
	function set_icon(v) {
		jicon.attr("class", "fa fa-"+v);
		return icon = v;
	}
	function set_title(v) {
		j.attr("title", v);
		return title = v;
	}
}

class Inspector {

	static var CSS = hxd.res.Embed.getFileContent("hxd/inspect/inspect.css");
	static var current : Inspector;

	public var scene(default, set) : h3d.scene.Scene;
	public var connected(get, never): Bool;

	var inspect : PropManager;
	var jroot : JQuery;
	var event : DrawEvent;
	var oldLog : Dynamic -> haxe.PosInfos -> Void;
	var savedFile : String;
	var oldLoop : Void -> Void;
	var state : Map<String,{ original : Dynamic, current : Dynamic }>;

	var panels : Array<Panel>;
	var rootNodes : Array<Node>;

	public var scenePanel : ScenePanel;
	public var resPanel : ResPanel;
	var propsPanel : Panel;
	var logPanel : Panel;
	var panelList : Array<{ name : String, create : Void -> Panel, p : Panel } >;

	public function new( scene, ?host, ?port ) {

		current = this;

		event = new DrawEvent(this);
		savedFile = "sceneProps.js";
		state = new Map();
		oldLog = haxe.Log.trace;
		haxe.Log.trace = onTrace;
		inspect = new PropManager(host, port);
		inspect.resolveProps = resolveProps;
		inspect.onChange = onChange;
		inspect.handleKey = onKey;
		this.scene = scene;
		panels = [];
		panelList = [];
		rootNodes = [];

		init();
	}



	function init() {
		jroot = J(inspect.getRoot());
		jroot.html('
			<style>$CSS</style>
			<ul id="toolbar" class="toolbar">
			</ul>
		');
		jroot.attr("title", "Inspect");

		scenePanel = new ScenePanel("s3d",scene);
		propsPanel = new Panel("props","Properties");
		logPanel = new Panel("log", "Log");
		resPanel = new ResPanel("res", hxd.res.Loader.currentInstance);


		resPanel.dock(Left, 0.2);
		scenePanel.dock(Fill, null, resPanel);
		logPanel.dock(Down, 0.3);
		propsPanel.dock(Down, 0.5, scenePanel);

		addPanel("Scene", function() return scenePanel);
		addPanel("Properties", function() return propsPanel);
		addPanel("Resources", function() return resPanel);
		addPanel("Log", function() return logPanel);

		addTool("Load...", "download", load, "Load settings");
		addTool("Save...", "save", save, "Save settings");
		addTool("Undo", "undo", inspect.undo, "Undo");
		addTool("Repeat", "repeat", inspect.redo, "Redo");
		var pause : Tool = null;
		pause = addTool("Pause", "pause", function() {
			if( oldLoop != null ) {
				hxd.System.setLoop(oldLoop);
				oldLoop = null;
			} else {
				oldLoop = hxd.System.getCurrentLoop();
				hxd.System.setLoop(pauseLoop);
			}
			pause.active = oldLoop != null;
		}, "Pause scene");

		var sp : Tool = null;
		sp = addTool("Show Panel", "bars", function() {
			var panels = [for( p in panelList ) p.name];
			panels.push("New...");
			sp.j.special("popupMenu", panels, function(i) {
				var p = panelList[i];
				if( p == null ) {
					newPanel();
					return true;
				}
				if( p.p == null ) p.p = p.create();
				if( !p.p.visible ) p.p.show();
				return true;
			});
		}, "Show/Hide panel");

		addPanel("Stats", function() {
			var s = new StatsPanel();
			s.dock(Right, 0.35);
			return s;
		});
	}

	public function dispose() {
		if( current == this ) current = null;
		inspect.dispose();
		scene = null;
		if( oldLoop != null ) {
			hxd.System.setLoop(oldLoop);
			oldLoop = null;
		}
	}

	inline function get_connected() {
		return inspect.connected;
	}

	public inline function J( ?elt : cdb.jq.Dom, ?query : String ) {
		return inspect.J(elt,query);
	}

	public function addTool( name : String, icon : String, click : Void -> Void, ?title : String = "" ) {
		var t = new Tool();
		t.j = J("<li>");
		t.jicon = J("<i>").appendTo(t.j);
		t.j.click(function(_) t.click());
		t.name = name;
		t.icon = icon;
		t.title = title;
		t.click = click;
		t.j.appendTo(jroot.find("#toolbar"));
		return t;
	}

	function newPanel() {
	}

	public function addPanel( name : String, create : Void -> Panel ) {
		panelList.push({ name : name, create : create, p : null });
	}

	function onKey( e : cdb.jq.Event ) {
		switch( e.keyCode ) {
		case 'S'.code if( e.ctrlKey ):
			save();
		case hxd.Key.F1:
			load();
		default:
		}
	}

	function onTrace( v : Dynamic, ?pos : haxe.PosInfos ) {
		oldLog(v, pos);
		if( inspect.connected ) {
			var vstr = null;
			if( pos.customParams != null ) {
				pos.customParams.unshift(v);
				vstr = [for( v in pos.customParams ) Std.string(v)].join(",");
			} else
				vstr = Std.string(v);
			J("<pre>").addClass("line").text(pos.fileName+"(" + pos.lineNumber + ") : " + vstr).appendTo(logPanel.content);
		}
	}

	function set_scene(s:h3d.scene.Scene) {
		if( scene != null )
			scene.removePass(event);
		if( s != null )
			s.addPass(event);
		return scene = s;
	}

	function pauseLoop() {
		scene.setElapsedTime(0);
		h3d.Engine.getCurrent().render(scene);
	}

	function load() {
		jroot.special("fileSelect", [savedFile, "js"], function(newPath) {
			if( newPath == null ) return true;
			hxd.File.load(newPath,function(bytes) {
				savedFile = newPath;
				resetDefaults();
				loadProps(bytes.toString());
			});
			return true;
		});
	}

	public function resetDefaults() {
		for( s in state.keys() ) {
			var v = state.get(s);
			if( v.original != null )
				inspect.setPathPropValue(s, v.original);
		}
		state = new Map();
	}

	public function loadProps( props : String ) {
		var o : Dynamic = haxe.Json.parse(props);
		function browseRec( path : Array<String>, v : Dynamic ) {
			switch( Type.typeof(v) ) {
			case TNull, TInt, TFloat, TBool, TClass(_):
				var path = path.join(".");
				state.set(path, { original : inspect.getPathPropValue(path), current : v });
			case TUnknown, TFunction, TEnum(_):
				throw "Invalid value " + v;
			case TObject:
				for( f in Reflect.fields(v) ) {
					var fv = Reflect.field(v, f);
					path.push(f);
					browseRec(path, fv);
					path.pop();
				}
			}
		}
		browseRec([], o);
		for( s in state.keys() )
			inspect.setPathPropValue(s, state.get(s).current);
	}

	function save() {
		var o : Dynamic = { };
		for( s in state.keys() ) {
			var path = s.split(".");
			var o = o;
			while( path.length > 1 ) {
				var name = path.shift();
				var s = Reflect.field(o, name);
				if( s == null ) {
					s = { };
					Reflect.setField(o, name, s);
				}
				o = s;
			}
			Reflect.setField(o, path[0], state.get(s).current);
		}
		var js = haxe.Json.stringify(o, null, "\t");
		jroot.special("fileSave", [savedFile, "js", haxe.io.Bytes.ofString(js)], function(path) {
			if( path != null ) savedFile = path;
			return true;
		});
	}

	public function sync() {
		if( scene == null || !inspect.connected ) return;
		for( p in panels )
			if( p.visible )
				p.sync();
	}

	function resolveProps( path : Array<String> ) {
		var cur = null;
		var nodes = rootNodes;
		while( true ) {
			var k = path.shift();
			if( k == null ) break;
			var found = false;
			for( n in nodes ) {
				if( n.getPathName() == k ) {
					found = true;
					cur = n;
					nodes = @:privateAccess n.childs;
					break;
				}
			}
			if( !found ) {
				path.unshift(k);
				break;
			}
		}
		return cur == null || cur.props == null ? null : cur.props();
	}

	function onChange( path : String, oldV : Dynamic, newV : Dynamic ) {
		var s = state.get(path);
		if( s == null )
			state.set(path, { original : oldV, current : newV } );
		else {
			if( inspect.sameValue(s.original,newV) )
				state.remove(path);
			else
				s.current = newV;
		}
	}

	public function editProps( n : Node ) {
		var t = inspect.makeProps(n.getFullPath(), n.props());
		propsPanel.j.text("");
		propsPanel.parent = n;
		t.appendTo(propsPanel.j);
		propsPanel.show();
	}

}