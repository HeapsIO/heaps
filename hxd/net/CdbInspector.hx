package hxd.net;
import cdb.jq.JQuery;

enum Property {
	PBool( name : String, get : Void -> Bool, set : Bool -> Void );
	PInt( name : String, get : Void -> Int, set : Int -> Void );
	PFloat( name : String, get : Void -> Float, set : Float -> Void );
	PString( name : String, get : Void -> String, set : String -> Void );
	PEnum( name : String, e : Enum<Dynamic>, get : Void -> Dynamic, set : Dynamic -> Void );
	PColor( name : String, hasAlpha : Bool, get : Void -> h3d.Vector, set : h3d.Vector -> Void );
	PGroup( name : String, props : Array<Property> );
	PTexture( name : String, get : Void -> h3d.mat.Texture, set : h3d.mat.Texture -> Void );
}

private class CdbEvent implements h3d.IDrawable {
	var i : CdbInspector;
	public function new(i) {
		this.i = i;
	}
	public function render( engine : h3d.Engine ) {
		i.sync();
	}
}

private class SceneObject {
	public var o : h3d.scene.Object;
	public var parent : SceneObject;
	public var j : cdb.jq.JQuery;
	public var jchild : cdb.jq.JQuery;
	public var childs : Array<SceneObject>;
	public function new(o, p) {
		this.o = o;
		this.parent = p;
		childs = [];
	}
	public function remove() {
		for( c in childs )
			c.remove();
		j.remove();
		if( parent != null )
			parent.childs.remove(this);
	}
}


class CdbInspector extends cdb.jq.Client {

	static var CSS = hxd.res.Embed.getFileContent("hxd/net/inspect.css");

	public var host : String = "127.0.0.1";
	public var port = 6669;

	public var scene(default,set) : h3d.scene.Scene;

	var event : CdbEvent;
	var sock : hxd.net.Socket;
	var connected = false;
	var oldLog : Dynamic -> haxe.PosInfos -> Void;

	var sceneObjects : Array<SceneObject> = [];
	var scenePosition = 0;
	var flushWait = false;

	public function new( ?host, ?port ) {
		super();
		event = new CdbEvent(this);
		if( host != null )
			this.host = host;
		if( port != null )
			this.port = port;
		sock = new hxd.net.Socket();
		sock.onError = function(e) {
			connected = false;
			haxe.Timer.delay(connect,500);
		};
		sock.onData = function() {
			while( true ) {
				var len = try sock.input.readUInt16() catch( e : haxe.io.Eof ) -1;
				if( len < 0 ) break;
				var data = sock.input.read(len);
				var msg : cdb.jq.Message.Answer = cdb.BinSerializer.unserialize(data);
				handle(msg);
			}
		}
		connect();
		/*oldLog = haxe.Log.trace;
		haxe.Log.trace = onTrace;*/
	}

	function onTrace( v : Dynamic, ?pos : haxe.PosInfos ) {
		if( !connected )
			oldLog(v, pos);
		else {
			J("<div>").addClass("line").text(pos.fileName+"(" + pos.lineNumber + ") : " + Std.string(v)).appendTo(J("#log"));
		}
	}

	function set_scene(s:h3d.scene.Scene) {
		if( scene != null )
			scene.removePass(event);
		if( s != null )
			s.addPass(event, true);
		return scene = s;
	}

	function connect() {
		sock.close();
		sock.connect(host, port, function() {
			connected = true;
			refresh();
		});
	}

	override function sendBytes( msg : haxe.io.Bytes ) {
		if( !flushWait ) {
			flushWait = true;
			sock.out.wait();
			haxe.Timer.delay(function() {
				flushWait = false;
				sock.out.flush();
			},0);
		}
		sock.out.writeInt32(msg.length);
		sock.out.write(msg);
	}

	function refresh() {
		j.html('
			<div id="scene" class="panel" caption="Scene">
				<ul id="scontent" class="elt">
				</ul>
			</div>
			<div id="material" class="panel" caption="Material">
			</div>
			<div id="log" class="panel" caption="Log">
			</div>
		');
		send(SetCSS(CSS));
		var scene = J("#scene");
		scene.dock(root, Left, 0.2);
		J("#log").dock(root, Down, 0.3);
		J("#material").dock(scene.get(), Down, 0.5);
	}

	public function sync() {
		if( scene == null || !connected ) return;
		scenePosition = 0;
		syncRec(scene, null);
	}

	function syncRec( o : h3d.scene.Object, p : SceneObject ) {
		var so = sceneObjects[scenePosition];
		if( so == null || so.o != o || so.parent != p ) {
			so = new SceneObject(o, p);
			sceneObjects.insert(scenePosition, so);
			so.j = J("<li>");
			so.j.html('<div class="content">${o.toString()}</div>');
			so.j.find(".content").click(function(_) {
				J("#scene").find(".selected").removeClass("selected");
				so.j.addClass("selected");
				selectObject(o);
			});
			so.j.appendTo( p != null ? p.jchild : J("#scontent") );
			if( p != null ) p.childs.push(so);
		}
		scenePosition++;
		if( o.numChildren > 0 ) {
			if( so.jchild == null ) {
				so.jchild = J("<ul>");
				so.jchild.addClass("elt");
				so.jchild.appendTo(so.j);
			}
			for( c in o )
				syncRec(c, so);
		} else if( so.jchild != null ) {
			so.jchild.remove();
			so.jchild = null;
			for( o in so.childs )
				o.remove();
		}
	}

	function makeProps( props : Array<Property> ) {
		var t = J("<table>");
		t.addClass("props");
		for( p in props )
			addProp(t, p, 0);
		return t;
	}

	function addProp( t : JQuery, p : Property, gid : Int ) {
		var j = J("<tr>");
		j.addClass("prop");
		j.addClass("g_" + gid);
		j.addClass(p.getName().toLowerCase());
		if( gid > 0 ) j.style("display", "none");
		j.appendTo(t);

		var jname = J("<th>");
		var jprop = J("<td>");
		jname.appendTo(j);
		jprop.appendTo(j);

		switch( p ) {
		case PGroup(name, props):

			jname.attr("colspan", "2");
			jname.html('<i class="icon-arrow-right"/> ' + StringTools.htmlEscape(name));
			var gid = t.get().childs.length;
			j.click(function(_) {
				var i = jname.find("i");
				var show = i.hasClass("icon-arrow-right");
				i.attr("class", show ? "icon-arrow-down" : "icon-arrow-right");
				t.find(".g_" + gid).style("display", show?"":"none");
			});
			jprop.remove();
			for( p in props )
				addProp(t, p, gid);

		case PBool(name, get, set):
			jname.text(name);
			jprop.text(get() ? "Yes" : "No");
			j.dblclick(function(_) {
				set(!get());
				jprop.text(get() ? "Yes" : "No");
			});
		case PEnum(name, tenum, get, set):
			jname.text(name);
			jprop.text(get());
			j.dblclick(function(_) {

				var input = J("<select>");
				var cur = (get() : EnumValue).getIndex();
				var all : Array<EnumValue> = tenum.createAll();
				for( p in all ) {
					var name = p.getName();
					var idx = p.getIndex();
					J("<option>").attr("value", "" + p.getIndex()).attr(idx == cur ? "selected" : "_sel", "selected").text(name).appendTo(input);
				}
				jprop.text("");
				input.appendTo(jprop);
				input.focus();
				input.blur(function(_) {
					input.remove();
					jprop.text(get());
				});
				input.change(function(_) {
					var v = Std.parseInt(input.getValue());
					if( v != null )
						set(all[v]);
					input.remove();
					jprop.text(get());
				});
			});
		case PInt(name, get, set):
			jname.text(name);
			jprop.text("" + get());
			j.dblclick(function(_) editValue(jprop, function() return "" + get(), function(s) { var i = Std.parseInt(s); if( i != null ) set(i); } ));
		case PFloat(name, get, set):
			jname.text(name);
			jprop.text("" + get());
			j.dblclick(function(_) editValue(jprop, function() return "" + get(), function(s) { var i = Std.parseFloat(s); if( !Math.isNaN(i) ) set(i); } ));
		case PString(name, get, set):
			jname.text(name);
			jprop.text("" + get());
			j.dblclick(function(_) editValue(jprop, get, set));
		case PColor(name, alpha, get, set):
			jname.text(name);
			function init() {
				var v = get().toColor() & 0xFFFFFF;
				jprop.html('<div class="color" style="background:#${StringTools.hex(v,6)}"></div>');
			}
			jprop.dblclick(function(_) {
				jprop.special("colorPick", [get().toColor(),alpha], function(c) {
					set(h3d.Vector.fromColor(c.color));
					if( c.done ) init();
				});
			});
			init();
		case PTexture(name, get, set):
			jname.text(name);
			var path = null;
			var isLoaded = false;
			function init() {
				var t = get();
				var res = null;
				try {
					if( t != null && t.name != null )
						res = hxd.res.Loader.currentInstance.load(t.name).toImage();
				} catch( e : Dynamic ) {
				}
				if( res != null ) {
					// resolve path
					var lfs = Std.instance(hxd.res.Loader.currentInstance.fs, hxd.fs.LocalFileSystem);
					if( lfs != null )
						path = lfs.baseDir + res.entry.path;
					else {
						var resPath = haxe.macro.Compiler.getDefine("resPath");
						if( resPath == null ) resPath = "res";
						path = hxd.File.applicationPath() + resPath + "/" + res.entry.path;
					}
				} else if( t.name != null && (t.name.charCodeAt(0) == '/'.code || t.name.charCodeAt(1) == ':'.code) )
					path = t.name;

				if( path == null )
					jprop.text(""+t);
				else
					jprop.html('<img src="file://$path"/>');
			}
			init();
			jprop.dblclick(function(_) {
				jprop.special("fileSelect", [path, "png,jpg,jpeg,gif"], function(path) {

					if( path == null ) return;

					hxd.File.load(path, function(data) {
						if( isLoaded ) get().dispose();
						isLoaded = true;
						set( hxd.res.Any.fromBytes(path, data).toTexture() );
						init();
					});

				});
			});
		}
	}

	function editValue( j : JQuery, get : Void -> String, set : String -> Void ) {
		var input = J("<input>");
		input.attr("value", get());
		j.text("");
		input.appendTo(j);
		input.focus();
		input.blur(function(_) {
			input.remove();
			set(input.getValue());
			j.text(get());
		});
		input.keydown(function(e) {
			if( e.keyCode == 13 )
				input.blur();
		});
	}

	function makeShaderProps( s : hxsl.Shader ) {
		var props = [];
		var data = @:privateAccess s.shader;
		for( v in data.data.vars ) {
			switch( v.kind ) {
			case Param:
				var name = v.name+"__";
				function set(val:Dynamic) {
					Reflect.setField(s, name, val);
					if( hxsl.Ast.Tools.isConst(v) )
						@:privateAccess s.constModified = true;
				}
				switch( v.type ) {
				case TBool:
					props.push(PBool(v.name, function() return Reflect.field(s,name), set ));
				case TInt:
					props.push(PInt(v.name, function() return Reflect.field(s,name), set ));
				case TFloat:
					props.push(PFloat(v.name, function() return Reflect.field(s, name), set));
				case TVec(size = (3 | 4), VFloat) if( v.name.toLowerCase().indexOf("color") >= 0 ):
					props.push(PColor(v.name, size == 4, function() return Reflect.field(s, name), set));
				case TSampler2D, TSamplerCube:
					props.push(PTexture(v.name, function() return Reflect.field(s, name), set));
				default:
					props.push(PString(v.name, function() return ""+Reflect.field(s,name), function(val) { } ));
				}
			default:
			}
		}

		var name = data.data.name;
		if( StringTools.startsWith(name, "h3d.shader.") )
			name = name.substr(11);

		return PGroup("shader "+name, props);
	}

	function selectObject( o : h3d.scene.Object ) {

		if( !o.isMesh() )
			return;

		var mat = o.toMesh().material;
		var j = J("#material");
		j.text("");
		j.attr("caption", "Material - " + (mat.name == null ? "@" + o.toString() : mat.name));

		var props = [];

		for( pass in mat.getPasses() ) {

			var pl = [
				PBool("Lights", function() return pass.enableLights, function(v) pass.enableLights = v),
				PEnum("Cull", h3d.mat.Data.Face, function() return pass.culling, function(v) pass.culling = v),
				PEnum("BlendSrc", h3d.mat.Data.Blend, function() return pass.blendSrc, function(v) pass.blendSrc = pass.blendAlphaSrc = v),
				PEnum("BlendDst", h3d.mat.Data.Blend, function() return pass.blendDst, function(v) pass.blendDst = pass.blendAlphaDst = v),
				PBool("DepthWrite", function() return pass.depthWrite, function(b) pass.depthWrite = b),
				PEnum("DepthTest", h3d.mat.Data.Compare, function() return pass.depthTest, function(v) pass.depthTest = v)
			];

			var shaders = [for( s in pass.getShaders() ) s];
			shaders.reverse();
			for( s in shaders )
				pl.push(makeShaderProps(s));

			props.push(PGroup("pass "+pass.name,pl));
		}

		var t = makeProps(props);
		t.appendTo(j);
	}

}