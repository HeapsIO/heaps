package hxd.inspect;
import cdb.jq.JQuery;
import hxd.inspect.Property;

private class DrawEvent implements h3d.IDrawable {
	var i : SceneInspector;
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

class SceneInspector {

	static var CSS = hxd.res.Embed.getFileContent("hxd/inspect/inspect.css");
	static var current : SceneInspector;

	public var scene(default, set) : h3d.scene.Scene;
	public var connected(get, never): Bool;

	var inspect : PropInspector;
	var jroot : JQuery;
	var event : DrawEvent;
	var oldLog : Dynamic -> haxe.PosInfos -> Void;
	var savedFile : String;
	var oldLoop : Void -> Void;
	var state : Map<String,{ original : Dynamic, current : Dynamic }>;

	var panels : Array<Panel>;
	var rootNodes : Array<Node>;

	public var scenePanel : ScenePanel;
	var propsPanel : Panel;
	var logPanel : Panel;
	var statsPanel : Panel;

	public function new( scene, ?host, ?port ) {

		current = this;

		event = new DrawEvent(this);
		savedFile = "sceneProps.js";
		state = new Map();
		oldLog = haxe.Log.trace;
		//haxe.Log.trace = onTrace;
		inspect = new PropInspector(host, port);
		inspect.resolveProps = resolveProps;
		inspect.onChange = onChange;
		inspect.handleKey = onKey;
		this.scene = scene;
		panels = [];
		rootNodes = [];

		init();

		scenePanel.addNode("Renderer", "object-group", scenePanel.getRendererProps);

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
		addTool("Statistics", "bar-chart", function() {
			if( statsPanel == null ) {
				statsPanel = new StatsPanel();
				statsPanel.dock(jroot, Right, 0.35);
			}
			statsPanel.show();
		}, "Open statistics");
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
			J("<pre>").addClass("line").text(pos.fileName+"(" + pos.lineNumber + ") : " + vstr).appendTo(J("#log"));
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

		scenePanel.dock(jroot, Left, 0.2);
		logPanel.dock(jroot, Down, 0.3);
		propsPanel.dock(scenePanel.j, Down, 0.5);
	}

	function load() {
		try {
		hxd.File.browse(function(b) {
			savedFile = b.fileName;
			b.load(function(bytes) {

				// reset to default
				for( s in state.keys() )
					inspect.setPathPropValue(s, state.get(s).original);
				state = new Map();

				var o : Dynamic = haxe.Json.parse(bytes.toString());
				function browseRec( path : Array<String>, v : Dynamic ) {
					switch( Type.typeof(v) ) {
					case TNull, TInt, TFloat, TBool, TClass(_):
						var path = path.join(".");
						state.set(path, { original : null, current : v });
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
			});

		},{ defaultPath : savedFile, fileTypes : [ { name:"Scene Props", extensions:["js"] } ] } );
		} catch( e : Dynamic ) {
			// already open
		}
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
		try {
			hxd.File.saveAs(haxe.io.Bytes.ofString(js), { defaultPath : savedFile, saveFileName : function(name) savedFile = name } );
		} catch( e : Dynamic ) {
			// already open
		}
	}

	public function sync() {
		if( scene == null || !inspect.connected ) return;
		for( p in panels )
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

	function fillProps( n : TreeNode ) {
		var t = inspect.makeProps(n.getFullPath(), n.props());
		propsPanel.j.text("");
		propsPanel.parent = n;
		t.appendTo(propsPanel.j);
		propsPanel.show();
	}

}