package hxd.inspect;
import vdom.JQuery;
import hxd.inspect.Property;

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
	static var current(default,set) : Inspector;

	public static function getCurrent() return current;

	public var scene(default, set) : h3d.scene.Scene;
	public var connected(get, never): Bool;

	var props : PropManager;
	var jroot : JQuery;
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
	var currentNode : Node;
	var event : haxe.MainLoop.MainEvent;

	public function new( scene, ?host, ?port ) {

		current = this;

		savedFile = "sceneProps.js";
		state = new Map();
		oldLog = haxe.Log.trace;
		haxe.Log.trace = onTrace;
		props = new PropManager(host, port);
		props.resolveProps = resolveProps;
		props.onShowTexture = onShowTexture;
		props.onChange = onChange;
		props.handleKey = onKey;
		this.scene = scene;
		panels = [];
		panelList = [];
		rootNodes = [];

		init();
	}

	static function set_current(i:Inspector) {
		@:privateAccess Node.currentJRoot = i == null ? null : i.jroot;
		return current = i;
	}

	function init() {
		jroot = J(props.getRoot());
		jroot.html('
			<style>$CSS</style>
			<ul id="toolbar" class="toolbar">
			</ul>
		');
		jroot.attr("title", "Inspect");
		current = this;

		scenePanel = new ScenePanel("s3d", scene);
		logPanel = new Panel("log", "Log");
		//resPanel = new ResPanel("res", hxd.res.Loader.currentInstance);
		//resPanel.dock(Left, 0.2);
		//scenePanel.dock(Fill, null, resPanel);
		scenePanel.dock(Left, 0.2);
		logPanel.dock(Down, 0.3);
		getPropsPanel();

		addPanel("Scene", function() return scenePanel);
		addPanel("Properties", function() return getPropsPanel());
		//addPanel("Resources", function() return resPanel);
		addPanel("Log", function() return logPanel);

		addTool("Load...", "download", load, "Load settings");
		addTool("Save...", "save", save, "Save settings");
		addTool("Undo", "undo", props.undo, "Undo");
		addTool("Repeat", "repeat", props.redo, "Redo");
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

	function getPropsPanel() {
		if( propsPanel == null || propsPanel.isDisposed() ) {
			propsPanel = new Panel("props","Properties");
			propsPanel.dock(Down, 0.5, scenePanel);
		}
		return propsPanel;
	}

	function onShowTexture( t : h3d.mat.Texture ) {
		var p = new Panel(null, "" + t);
		p.onClose = p.dispose;
		function load( mode = "rgba" ) {
			p.j.html("Loading...");
			haxe.Timer.delay(function() {
				var bmp = t.capturePixels();
				function setChannel(v) {
					var bits = v * 8;
					for( x in 0...bmp.width )
						for( y in 0...bmp.height ) {
							var a = (bmp.getPixel(x, y) >>> bits) & 0xFF;
							bmp.setPixel(x, y, 0xFF000000 | a | (a<<8) | (a<<16));
						}
				}
				switch( mode ) {
				case "rgb":
					for( x in 0...bmp.width )
						for( y in 0...bmp.height )
							bmp.setPixel(x, y, bmp.getPixel(x, y) | 0xFF000000);
				case "alpha":
					setChannel(3);
				case "red":
					setChannel(2);
				case "green":
					setChannel(1);
				case "blue":
					setChannel(0);
				default:
				}

				var png = bmp.toPNG();
				bmp.dispose();
				var pngBase64 = new haxe.crypto.BaseCode(haxe.io.Bytes.ofString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/")).encodeBytes(png).toString();
				p.j.html('
					<select class="imageprops"><option value="rgba">RGBA</option><option value="rgb">RGB</option><option value="alpha">Alpha</option><option value="red">Red</option><option value="green">Green</option><option value="blue">Blue</option></select>
					<img src="data:image/png;base64,$pngBase64" style="background:#696969;max-width:100%"/>
				');
				var props = p.j.find(".imageprops");
				props.val(mode);
				props.change(function(_) load(props.getValue()));
			}, 0);
		}
		load();
		p.show();
	}

	public function dispose() {
		if( current == this ) current = null;
		props.dispose();
		scene = null;
		if( oldLoop != null ) {
			hxd.System.setLoop(oldLoop);
			oldLoop = null;
		}
	}

	inline function get_connected() {
		return props.connected;
	}

	public inline function J( ?elt : vdom.Dom, ?query : String ) {
		return props.J(elt,query);
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

	function onKey( e : vdom.Event ) {
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
		if( props.connected ) {
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
		if( s == null && event != null ) {
			event.stop();
			event = null;
		}
		if( s != null && event == null )
			event = haxe.MainLoop.add(sync);
		return scene = s;
	}

	function pauseLoop() {
		scene.setElapsedTime(0);
		h3d.Engine.getCurrent().render(scene);
	}

	public function saveFile( defaultName : String, ext : String, bytes : haxe.io.Bytes, onSelect : String -> Void ) {
		if( defaultName.charCodeAt(0) != "/".code && defaultName.charCodeAt(1) != ":".code )
			defaultName = props.getResPath() + defaultName;
		jroot.special("fileSave", [defaultName, ext, bytes], function(path) {
			if( path != null ) onSelect(path);
			return true;
		});
	}

	public function loadFile( ext : String, onLoad : String -> haxe.io.Bytes -> Void, ?defaultPath : String ) {
		if( defaultPath != null && defaultPath.charCodeAt(0) != "/".code && defaultPath.charCodeAt(1) != ":".code )
			defaultPath = props.getResPath() + defaultPath;
		jroot.special("fileSelect", [defaultPath, ext], function(newPath) {
			if( newPath == null ) return true;
			hxd.File.load(newPath, function(bytes) onLoad(newPath, bytes));
			return true;
		});
	}

	function load() {
		loadFile("js", function(newPath, data) {
			savedFile = newPath;
			resetDefaults();
			loadProps(data.toString());
		}, savedFile);
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
		saveFile(savedFile, "js", haxe.io.Bytes.ofString(js), function(name) savedFile = name);
	}

	public function resetDefaults() {
		for( s in state.keys() ) {
			var v = state.get(s);
			if( v.original != null )
				props.setPathPropValue(s, v.original);
		}
		state = new Map();
	}

	public function loadProps( props : String ) {
		var o : Dynamic = haxe.Json.parse(props);
		function browseRec( path : Array<String>, v : Dynamic ) {
			switch( Type.typeof(v) ) {
			case TNull, TInt, TFloat, TBool, TClass(_):
				var path = path.join(".");
				state.set(path, { original : this.props.getPathPropValue(path), current : v });
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
			this.props.setPathPropValue(s, state.get(s).current);
		refreshProps();
	}

	public function sync() {
		if( scene == null || !props.connected ) return;
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
			if( props.sameValue(s.original,newV) )
				state.remove(path);
			else
				s.current = newV;
		}
	}

	public function refreshProps() {
		if( currentNode != null ) editProps(currentNode);
	}

	public function editProps( n : Node ) {
		currentNode = n;
		var t = props.makeProps(n.getFullPath(), n.props());
		getPropsPanel();
		propsPanel.j.text("");
		propsPanel.parent = n;
		t.appendTo(propsPanel.j);
		propsPanel.show();
	}

}