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
	PFloats( name : String, get : Void -> Array<Float>, set : Array<Float> -> Void );
	PPopup( p : Property, menu : Array<String>, click : JQuery -> Int -> Void );
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
	public var visible = true;
	public var culled = false;
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
	var oldLoop : Void -> Void;

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
		oldLog = haxe.Log.trace;
		haxe.Log.trace = onTrace;
	}

	function onTrace( v : Dynamic, ?pos : haxe.PosInfos ) {
		if( !connected )
			oldLog(v, pos);
		else {
			J("<pre>").addClass("line").text(pos.fileName+"(" + pos.lineNumber + ") : " + Std.string(v)).appendTo(J("#log"));
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

	function pauseLoop() {
		scene.setElapsedTime(0);
		h3d.Engine.getCurrent().render(scene);
	}

	function refresh() {
		sceneObjects = [];
		j.html('
			<ul id="toolbar" class="toolbar">
				<li id="scene-pause"><i class="fa fa-pause" alt="Pause Game"></i></li>
			</ul>
			<div id="scene" class="panel" caption="Scene">
				<ul id="scontent" class="elt">
				</ul>
			</div>
			<div id="props" class="panel" caption="Properties">
			</div>
			<div id="log" class="panel" caption="Log">
			</div>
		');
		send(SetCSS(CSS));
		var scene = J("#scene");
		scene.dock(root, Left, 0.2);

		var pause = j.find("#scene-pause");
		pause.click(function(_) {

			if( oldLoop != null ) {
				hxd.System.setLoop(oldLoop);
				oldLoop = null;
			} else {
				oldLoop = hxd.System.getCurrentLoop();
				hxd.System.setLoop(pauseLoop);
			}

			pause.toggleClass("active", oldLoop != null);
		});

		J("#log").dock(root, Down, 0.3);
		J("#props").dock(scene.get(), Down, 0.5);
	}

	public function sync() {
		if( scene == null || !connected ) return;
		scenePosition = 0;
		if( sceneObjects.length == 0 ) {
			var lj = J("<li>");
			lj.html('<i class="fa fa-object-group"></i><div class="content">Renderer</div>');
			lj.appendTo(J("#scontent"));
			lj.find(".content").click(function(_) {
				J("#scene").find(".selected").removeClass("selected");
				lj.addClass("selected");
				selectRenderer();
			});
			sceneObjects.push(null);
		}
		syncRec(scene, null);
	}

	function syncRec( o : h3d.scene.Object, p : SceneObject ) {
		var so = sceneObjects[scenePosition];
		if( so == null || so.o != o || so.parent != p ) {
			so = new SceneObject(o, p);
			sceneObjects.insert(scenePosition, so);
			so.j = J("<li>");
			var icon = null;
			if( Std.is(o, h3d.scene.Skin) )
				icon = "child"
			else if( Std.is(o, h3d.scene.Mesh) )
				icon = "cube";
			else if( Std.is(o, h3d.scene.CustomObject) )
				icon = "globe";
			else if( Std.is(o, h3d.scene.Scene) )
				icon = "picture-o";
			else if( Std.is(o, h3d.scene.Light) )
				icon = "lightbulb-o";
			else
				icon = "circle-o";
			so.j.html('<i class="fa fa-$icon"></i><div class="content">${o.name == null ? o.toString() : o.name}</div>');
			so.j.find("i").click(function(_) {
				if( o.numChildren > 0 ) {
					so.j.toggleClass("expand");
					so.jchild.slideToggle(50);
				}
			});
			so.j.find(".content").click(function(_) {
				J("#scene").find(".selected").removeClass("selected");
				so.j.addClass("selected");
				selectObject(o);
			});
			so.j.appendTo( p != null ? p.jchild : J("#scontent") );
			if( p != null ) p.childs.push(so);
		}
		if( o.visible != so.visible ) {
			so.visible = o.visible;
			so.j.toggleClass("hidden");
		}
		@:privateAccess if( o.culled != so.culled ) {
			so.culled = o.culled;
			so.j.toggleClass("culled");
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

	function makeProps( props : Array<Property>, expandLevel = 1 ) {
		var t = J("<table>");
		t.addClass("props");
		for( p in props )
			addProp(t, p, [], expandLevel);
		return t;
	}

	public function createPanel( name : String ) {
		var panel = J('<div>');
		panel.addClass("panel");
		panel.attr("caption", ""+name);
		panel.appendTo(j);
		panel.dock(root, Fill);
		return panel;
	}

	function addProp( t : JQuery, p : Property, gids : Array<Int>, expandLevel ) {
		var j = J("<tr>");
		j.addClass("prop");
		for( g in gids )
			j.addClass("g_" + g);
		j.addClass(p.getName().toLowerCase());
		if( gids.length > expandLevel )
			j.style("display", "none");
		if( gids.length > 0 )
			j.addClass("gs_" + gids[gids.length - 1]);
		j.appendTo(t);

		var jname = J("<th>");
		var jprop = J("<td>");
		jname.appendTo(j);
		jprop.appendTo(j);

		switch( p ) {
		case PGroup(name, props):

			jname.attr("colspan", "2");
			jname.style("padding-left", (gids.length * 16) + "px");
			jname.html('<i class="fa ' + (gids.length + 1 > expandLevel ? 'fa-arrow-right' : 'fa-arrow-down') +'"/> ' + StringTools.htmlEscape(name));
			var gid = t.get().childs.length;
			j.click(function(_) {
				var i = jname.find("i");
				var show = i.hasClass("fa-arrow-right");
				i.attr("class", "fa "+(show ? "fa-arrow-down" : "fa-arrow-right"));
				if( show )
					t.find(".gs_" + gid).style("display", "");
				else {
					var all = t.find(".g_" + gid);
					all.style("display", "none");
					all.find("i.fa-arrow-down").attr("class", "fa fa-arrow-right");
				}
			});
			jprop.remove();
			gids.push(gid);
			for( p in props )
				addProp(t, p, gids, expandLevel);
			gids.pop();

		case PBool(name, get, set):
			jname.text(name);
			var v = get();
			jprop.text(v ? "Yes" : "No");
			jprop.click(function(_) {
				v = !v;
				set(v);
				jprop.text(v ? "Yes" : "No");
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

		case PFloats(name, get, set):
			jname.text(name);
			var values = get();
			jprop.html("<table><tr></tr></table>");
			var jt = jprop.find("tr");
			for( i in 0...values.length ) {
				var jv = J("<td>").appendTo(jt);
				jv.text(""+values[i]);
				jv.dblclick(function(_) editValue(jv, function() return "" + values[i], function(s) { var f = Std.parseFloat(s); if( !Math.isNaN(f) ) { values[i] = f; set(values); } }));
			}
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
				} else if( t != null && t.name != null && (t.name.charCodeAt(0) == '/'.code || t.name.charCodeAt(1) == ':'.code) )
					path = t.name;

				if( path == null ) {
					if( t == null )
						jprop.text("");
					else {
						jprop.html(StringTools.htmlEscape("" + t) + " <button>View</button>");
						jprop.find("button").click(function(_) {
							var p = createPanel("" + t);
							p.html("Loading...");
							haxe.Timer.delay(function() {
								var bmp = t.captureBitmap();
								var png = bmp.toPNG();
								bmp.dispose();
								var pngBase64 = new haxe.crypto.BaseCode(haxe.io.Bytes.ofString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/")).encodeBytes(png).toString();
								p.html('<img src="data:image/png;base64,$pngBase64" style="background:#696969"/>');
							},0);
						});
					}
				} else
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
		case PPopup(p, menu, click):
			j.remove();
			j = addProp(t, p, gids, expandLevel);
			j.mousedown(function(e) {
				if( e.which == 3 )
					j.special("popupMenu", menu, function(i) click(j,i));
			});
		}
		return j;
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

	function getShaderProps( s : hxsl.Shader ) {
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
				case TVec(size, VFloat):
					props.push(PFloats(v.name, function() {
						var v : h3d.Vector = Reflect.field(s, name);
						var vl = [v.x, v.y];
						if( size > 2 ) vl.push(v.z);
						if( size > 3 ) vl.push(v.w);
						return vl;
					}, function(vl) {
						set(new h3d.Vector(vl[0], vl[1], vl[2], vl[3]));
					}));
				case TArray(_):
					props.push(PString(v.name, function() {
						var a : Array<Dynamic> = Reflect.field(s, name);
						return a == null ? "NULL" : "(" + a.length + " elements)";
					}, function(val) {}));
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

	function colorize( code : String ) {
		code = code.split("\t").join("    ");
		code = StringTools.htmlEscape(code);
		code = ~/\b((var)|(function)|(if)|(else)|(for)|(while))\b/g.replace(code, "<span class='kwd'>$1</span>");
		code = ~/(@[A-Za-z]+)/g.replace(code, "<span class='meta'>$1</span>");
		return code;
	}

	function getMaterialProps( mat : h3d.mat.Material ) {
		var props = [];
		props.push(PString("name", function() return mat.name == null ? "" : mat.name, function(n) mat.name = n == "" ? null : n));
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
			for( index in 0...shaders.length ) {
				var s = shaders[index];
				var p = getShaderProps(s);
				p = PPopup(p, ["Toggle", "View Source"], function(j, i) {
					switch( i ) {
					case 0:
						if( index == 0 ) return; // Don't allow toggle base shader
						if( !pass.removeShader(s) )
							pass.addShaderAt(s, shaders.length - (index + 1));
						j.toggleClass("disable");
					case 1:
						var shader = @:privateAccess s.shader;
						var p = createPanel(shader.data.name+" shader");
						var toString = hxsl.Printer.shaderToString;
						var code = toString(shader.data);
						p.html("<pre class='code'>"+colorize(code)+"</pre>");
					}

				});
				pl.push(p);
			}

			var p = PGroup("pass " + pass.name, pl);
			p = PPopup(p, ["Toggle", "View Shader"], function(j, i) {
				switch( i ) {
				case 0:
					if( !mat.removePass(pass) )
						mat.addPass(pass);
					j.toggleClass("disable");
				case 1:
					var p = createPanel(pass.name+" shader");

					var shader = scene.renderer.compileShader(pass);
					var toString = hxsl.Printer.shaderToString;
					var code = toString(shader.vertex.data) + "\n\n" + toString(shader.fragment.data);
					p.html("<pre class='code'>"+colorize(code)+"</pre>");
				}
			});
			props.push(p);
		}
		return PGroup("Material",props);
	}

	function getLightProps( l : h3d.scene.Light ) {
		var props = [];
		props.push(PColor("color", false, function() return l.color, function(c) l.color.load(c)));
		props.push(PInt("priority", function() return l.priority, function(p) l.priority = p));
		props.push(PBool("enableSpecular", function() return l.enableSpecular, function(b) l.enableSpecular = b));
		var dl = Std.instance(l, h3d.scene.DirLight);
		if( dl != null )
			props.push(PFloats("direction", function() return [dl.direction.x, dl.direction.y, dl.direction.z], function(fl) dl.direction.set(fl[0], fl[1], fl[2])));
		var pl = Std.instance(l, h3d.scene.PointLight);
		if( pl != null )
			props.push(PFloats("params", function() return [pl.params.x, pl.params.y, pl.params.z], function(fl) pl.params.set(fl[0], fl[1], fl[2], fl[3])));
		return PGroup("Light", props);
	}


	function selectObject( o : h3d.scene.Object ) {

		var props = [];

		props.push(PString("name", function() return o.name == null ? "" : o.name, function(v) o.name = v == "" ? null : v));
		props.push(PFloat("x", function() return o.x, function(v) o.x = v));
		props.push(PFloat("y", function() return o.y, function(v) o.y = v));
		props.push(PFloat("z", function() return o.z, function(v) o.z = v));
		props.push(PBool("visible", function() return o.visible, function(v) o.visible = v));

		if( o.isMesh() ) {
			var multi = Std.instance(o, h3d.scene.MultiMaterial);
			if( multi != null && multi.materials.length > 1 ) {
				for( m in multi.materials )
					props.push(getMaterialProps(m));
			} else
				props.push(getMaterialProps(o.toMesh().material));
		} else {
			var c = Std.instance(o, h3d.scene.CustomObject);
			if( c != null )
				props.push(getMaterialProps(c.material));
			var l = Std.instance(o, h3d.scene.Light);
			if( l != null )
				props.push(getLightProps(l));
		}

		var j = J("#props");
		j.text("");

		var t = makeProps(props);
		t.appendTo(j);
	}

	function getTextures( t : h3d.impl.TextureCache ) {
		var cache = @:privateAccess t.cache;
		var props = [];
		for( i in 0...cache.length ) {
			var t = cache[i];
			props.push(PTexture(t.name, function() return t, null));
		}
		return props;
	}

	function getDynamicProps( v : Dynamic ) {
		var fx = Std.instance(v,h3d.pass.ScreenFx);
		if( fx != null )
			return [getShaderProps(fx.shader)];
		var s = Std.instance(v, hxsl.Shader);
		if( s != null )
			return [getShaderProps(s)];
		return null;
	}

	function getPassProps( p : h3d.pass.Base ) {
		var props = [];
		var def = Std.instance(p, h3d.pass.Default);
		if( def == null ) return props;

		for( f in Type.getInstanceFields(Type.getClass(p)) ) {
			var pl = getDynamicProps(Reflect.field(p, f));
			if( pl != null )
				props.push(PGroup(f,pl));
		}

		for( t in getTextures(@:privateAccess def.tcache) )
			props.push(t);

		return props;
	}

	function selectRenderer() {
		var props = [];

		var ls = scene.lightSystem;
		props.push(PGroup("LightSystem", [
			PInt("maxLightsPerObject", function() return ls.maxLightsPerObject, function(s) ls.maxLightsPerObject = s),
			PColor("ambientLight", false, function() return ls.ambientLight, function(v) ls.ambientLight = v),
			PBool("perPixelLighting", function() return ls.perPixelLighting, function(b) ls.perPixelLighting = b),
		]));

		var r = scene.renderer;

		var tex = getTextures(@:privateAccess r.tcache);
		if( tex.length > 0 )
			props.push( PGroup("Textures", tex) );

		var pmap = new Map();
		for( p in @:privateAccess r.allPasses ) {
			if( pmap.exists(p.p) ) continue;
			pmap.set(p.p, true);
			props.push(PGroup("Pass " + p.name, getPassProps(p.p)));
		}

		for( f in Type.getInstanceFields(Type.getClass(r)) ) {
			var pl = getDynamicProps(Reflect.field(r, f));
			if( pl != null )
				props.push(PGroup(f,pl));
		}

		var j = J("#props");
		j.text("");
		var t = makeProps(props);
		t.appendTo(j);
	}

}