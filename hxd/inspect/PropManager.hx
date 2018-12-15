package hxd.inspect;
import vdom.JQuery;
import hxd.inspect.Property;

private typedef History = { path : String, oldV : Dynamic, newV : Dynamic };

class PropManager extends vdom.Client {

	public var host : String = "127.0.0.1";
	public var port = 6669;
	public var connected(default,null) = false;

	var sock : hxd.net.Socket;
	var pendingMessages : Array<vdom.Message>;

	var refreshProps : Void -> Void;
	var history : Array<History>;
	var redoHistory : Array<History>;
	var groupsStatus : Map<String,Bool>;

	public function new( ?host, ?port ) {
		super();
		groupsStatus = new Map();
		history = [];
		redoHistory = [];
		if( host != null )
			this.host = host;
		if( port != null )
			this.port = port;
		sock = new hxd.net.Socket();
		sock.onError = function(e) {
			if( connected ) onConnected(false);
			connected = false;
			haxe.Timer.delay(connect,500);
		};
		sock.onData = function() {
			while( true ) {
				var len = try sock.input.readUInt16() catch( e : haxe.io.Eof ) -1;
				if( len < 0 ) break;
				var data = sock.input.read(len);
				handle(decodeAnswer(data));
			}
		}
		connect();
	}

	public function dispose() {
		if( sock != null ) {
			sock.close();
			sock = null;
		}
	}

	override function onKey(e:vdom.Event) {
		switch( e.keyCode ) {
		case 'Z'.code if( e.ctrlKey ):
			undo();
		case 'Y'.code if( e.ctrlKey ):
			redo();
		default:
			handleKey(e);
		}
	}

	public dynamic function handleKey( e : vdom.Event ) {
	}

	function connect() {
		if( sock == null ) return; // was closed
		sock.close();
		sock.connect(host, port, function() {
			connected = true;
			syncDom();
			onConnected(true);
		});
	}

	function flushMessages() {
		if( pendingMessages == null ) return;
		var msg = pendingMessages.length == 1 ? pendingMessages[0] : vdom.Message.Group(pendingMessages);
		pendingMessages = null;
		if( sock == null ) return;
		var data = encodeMessage(msg);
		sock.out.wait();
		sock.out.writeInt32(data.length);
		sock.out.write(data);
		sock.out.flush();
	}

	override function send( msg : vdom.Message ) {
		if( pendingMessages == null ) {
			pendingMessages = [];
			haxe.Timer.delay(flushMessages,0);
		}
		pendingMessages.push(msg);
	}

	public dynamic function onConnected(b:Bool) {
	}

	public function undo() {
		var h = history.pop();
		if( h == null ) return;
		redoHistory.push(h);
		setPathPropValue(h.path, h.oldV);
		refreshProps();
	}

	public function redo() {
		var h = redoHistory.pop();
		if( h == null ) return;
		history.push(h);
		setPathPropValue(h.path, h.newV);
		refreshProps();
	}

	public dynamic function resolveProps( path : Array<String> ) : Array<Property> {
		return null;
	}

	function resolvePropPath( path : String ) : Property {
		var fullPath = path;
		var path = path.split(".");
		var props = resolveProps(path);
		if( props == null ) {
			trace("Prop not found " + path);
			return null;
		}
		var ppath = path.join(".");
		var p = getPropPath(path, props);
		if( p == null )
			trace("Prop not found " + ppath + " in "+fullPath.substr(0, fullPath.length - (ppath.length + 1)));
		return p;
	}

	public function getPathPropValue( path : String ) : Dynamic {
		var p = resolvePropPath(path);
		if( p == null ) return null;
		return getPropValue(p);
	}

	public function setPathPropValue( path : String, v : Dynamic ) {
		var p = resolvePropPath(path);
		if( p != null )
			PropTools.setPropValue(p, v);
	}

	function getPropPath( path : Array<String>, props : Array<Property> ) {
		for( p in props ) {
			var p = propFollow(p);
			var name = PropTools.getPropName(p);
			if( name == path[0] ) {
				path.shift();
				switch( p ) {
				case PGroup(_, props):
					return getPropPath(path, props);
				default:
					return path.length == 0 ? p : null;
				}
			}
		}
		return null;
	}

	function getPropValue( p : Property ) : Dynamic {
		switch( p ) {
		case PInt(_, get, _): return get();
		case PFloat(_, get, _): return get();
		case PRange(_, _, _, get, _): return get();
		case PString(_, get, _): return get();
		case PBool(_, get, _): return get();
		case PEnum(_, _, get, _): return get();
		case PColor(_, alpha, get, _): return "#" + StringTools.hex(get().toColor(),alpha?8:6);
		case PFloats(_, get, _): return get().copy();
		case PTexture(_, get, _):
			var t = get();
			return getTexturePath(t, false);
		case PGroup(_), PPopup(_), PCustom(_):
			throw "Cannot get property " + p.getName();
		}
	}

	public function makeProps( basePath : String, props : Array<Property>, expandLevel = 1 ) {
		var t = J("<table>");
		t.addClass("iprops");
		refreshProps = function() {
			t.text("");
			for( p in props )
				addProp(basePath, t, p, [], expandLevel);
		};
		refreshProps();
		return t;
	}

	public function sameValue( v1 : Dynamic, v2 : Dynamic ) {
		if( v1 == v2 ) return true;
		if( Std.is(v1, Array) && Std.is(v2, Array) ) {
			var a1 : Array<Dynamic> = v1;
			var a2 : Array<Dynamic> = v2;
			if( a1.length != a2.length )
				return false;
			for( i in 0...a1.length )
				if( !sameValue(a1[i], a2[i]) )
					return false;
			return true;
		}
		return false;
	}

	function addHistory( path : String, oldV : Dynamic, newV : Dynamic ) {
		if( sameValue(oldV, newV) )
			return;
		history.push( { path : path, oldV : oldV, newV : newV } );
		redoHistory = [];
		onChange(path, oldV, newV);
	}

	public dynamic function onChange( path : String, oldV : Dynamic, newV : Dynamic ) {
	}

	function propFollow( p : Property ) {
		return switch( p ) {
		case PPopup(p, _, _): propFollow(p);
		default: p;
		}
	}

	var cachedResPath = null;

	public function getResPath() {
		if( cachedResPath != null )
			return cachedResPath;
		var lfs = Std.instance(hxd.res.Loader.currentInstance.fs, hxd.fs.LocalFileSystem);
		if( lfs != null )
			cachedResPath = lfs.baseDir;
		else {
			var resPath = haxe.macro.Compiler.getDefine("resPath");
			if( resPath == null ) resPath = "res";
			cachedResPath = hxd.File.applicationPath() + resPath + "/";
		}
		return cachedResPath;
	}

	function getTexturePath( t : h3d.mat.Texture, absolute : Bool ) {
		var res = null;
		try {
			if( t != null && t.name != null )
				res = hxd.res.Loader.currentInstance.load(t.name).toImage();
		} catch( e : Dynamic ) {
		}
		if( res != null ) {
			if( !absolute )
				return res.entry.path;
			return getResPath() + res.entry.path;
		}
		if( t != null && t.name != null && (t.name.charCodeAt(0) == '/'.code || t.name.charCodeAt(1) == ':'.code) )
			return t.name;
		return null;
	}

	public dynamic function onShowTexture( t : h3d.mat.Texture ) {
	}

	function addProp( basePath : String, t : JQuery, p : Property, gids : Array<Int>, expandLevel ) {
		var j = J("<tr>");
		j.addClass("prop");
		for( g in gids )
			j.addClass("g_" + g);
		j.addClass(p.getName().toLowerCase());

		var visible = gids.length <= expandLevel;

		if( groupsStatus.exists(basePath) )
			visible = groupsStatus.get(basePath);
		if( !visible )
			j.style("display", "none");

		if( gids.length > 0 ) {
			var gid = gids[gids.length - 1];
			j.addClass("gs_" + gid);
		}

		j.appendTo(t);

		var jname = J("<th>");
		var jprop = J("<td>");
		jname.appendTo(j);
		jprop.appendTo(j);

		var name = PropTools.getPropName(p);
		var path = basePath + "." +name;
		if( name != null )
			jname.text(name);

		switch( p ) {
		case PGroup(name, props):

			var expand = gids.length + 1 <= expandLevel;
			if( groupsStatus.exists(path) )
				expand = groupsStatus.get(path);

			jname.attr("colspan", "2");
			jname.style("padding-left", (gids.length * 16) + "px");
			jname.html('<i class="fa ' + (expand ? 'fa-arrow-down' : 'fa-arrow-right') +'" attr="$path"/> ' + StringTools.htmlEscape(name));
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
					for( a in all.find("i.fa-arrow-right").elements() )
						groupsStatus.set(a.getAttr("path"), false);
				}

				groupsStatus.set(path, show);

			});
			jprop.dispose();
			gids.push(gid);
			for( p in props )
				addProp(path, t, p, gids, expandLevel);
			gids.pop();

		case PBool(_, get, set):
			var v = get();
			jprop.text(v ? "Yes" : "No");
			jprop.click(function(_) {
				addHistory(path,v,!v);
				v = !v;
				set(v);
				jprop.text(v ? "Yes" : "No");
			});
		case PEnum(_, tenum, get, set):
			jprop.text(get());
			var delay = false;
			jprop.click(function(_) {

				if( delay ) return;

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
					input.dispose();
					jprop.text(get());
				});
				input.change(function(_) {
					var v = Std.parseInt(input.getValue());
					if( v != null ) {
						addHistory(path, cur, v);
						cur = v;
						set(all[v]);
					}
					input.dispose();
					jprop.text(get());
					delay = true;
					haxe.Timer.delay(function() delay = false, 200);
				});
			});
		case PInt(_, get, set):
			jprop.text("" + get());
			jprop.click(function(_) editValue(jprop,function() return "" + get(),
				function(s) {
					var i = Std.parseInt(s);
					if( i != null ) {
						addHistory(path, get(), i);
						set(i);
					}
				}
			));
			jprop.mousedown(function(e) {
				if( e.which == 3 ) {
					if( jprop.find("input").length > 0 ) return;
					var old = get();
					var cur : Float = old;
					j.addClass("active");
					jprop.special("startDrag", [], function(v: { done:Bool, dx:Float, dy:Float } ) {
						var delta = ( Math.max(Math.abs(old == 0 ? 1 : old),1e-3) / 200 ) * v.dx;
						cur += delta;
						cur = hxd.Math.fmt(cur);
						var icur = Math.round(cur);
						set(icur);
						jprop.text("" + icur);
						if( v.done ) {
							j.removeClass("active");
							addHistory(path, old, icur);
						}
						return v.done;
					});
				}
			});
		case PFloat(_, get, set):
			jprop.text("" + get());
			jprop.click(function(_) editValue(jprop,function() return "" + get(),
				function(s) {
					var f = Std.parseFloat(s);
					if( !Math.isNaN(f) ) {
						addHistory(path, get(), f);
						set(f);
					}
				}
			));
			jprop.mousedown(function(e) {
				if( e.which == 3 ) {
					if( jprop.find("input").length > 0 ) return;
					var old = get();
					var cur = old;
					j.addClass("active");
					jprop.special("startDrag", [], function(v: { done:Bool, dx:Float, dy:Float } ) {
						var delta = ( Math.max(Math.abs(old == 0 ? 1 : old),1e-3) / 100 ) * v.dx;
						cur += delta;
						cur = hxd.Math.fmt(cur);
						set(cur);
						jprop.text("" + cur);
						if( v.done ) {
							j.removeClass("active");
							addHistory(path, old, cur);
						}
						return v.done;
					});
				}
			});
		case PRange(_, min, max, get, set, incr):
			var v = get();
			if( incr == null ) incr = (max - min) / 400;
			jprop.html('<input class="range" type="range" min="$min" max="$max" value="$v" step="$incr"/> <span class="range_text">$v</span>');
			var ji = jprop.find("input.range");
			var jt = jprop.find("span");
			ji.bind("input",function(_) {
				var nv = Std.parseFloat(ji.getValue());
				set(nv);
				jt.text("" + nv);
			});
			ji.bind("change", function(_) {
				var nv = Std.parseFloat(ji.getValue());
				if( v != nv ) {
					addHistory(path, v, nv);
					v = nv;
				}
				set(nv);
				jt.text("" + nv);
			});
			jt.click(function(_) editValue(jt, function() return "" + get(), function(s) {
				var nv = Std.parseFloat(s);
				if( !Math.isNaN(nv) && v != nv ) {
					addHistory(path, v, nv);
					v = nv;
					set(nv);
					ji.val(nv);
				}
			}));
		case PFloats(_, get, set):
			var values = get();
			jprop.html("<table><tr></tr></table>");
			var jt = jprop.find("tr");
			for( i in 0...values.length ) {
				var jv = J("<td>").appendTo(jt);
				jv.text("" + values[i]);
				jv.click(function(_) editValue(jv,function() return "" + values[i],
					function(s) {
						var f = Std.parseFloat(s);
						if( !Math.isNaN(f) ) {
							var old = values.copy();
							values[i] = f;
							addHistory(path, old, values.copy());
							set(values);
						}
					}
				));
				jv.mousedown(function(e) {
					if( e.which == 3 ) {
						if( jv.find("input").length > 0 ) return;
						var old = values.copy();
						var cur = old[i];
						jv.addClass("active");
						jv.special("startDrag", [], function(v: { done:Bool, dx:Float, dy:Float } ) {
							var delta = ( Math.max(Math.abs(old[i] == 0 ? 1 : old[i]), 1e-3) / 100 ) * v.dx;
							cur += delta;
							values[i] = hxd.Math.fmt(cur);
							set(values);
							jv.text("" + values[i]);
							if( v.done ) {
								jv.removeClass("active");
								addHistory(path, old, values.copy());
							}
							return v.done;
						});
					}
			});
			}
		case PString(_, get, set):
			var cur = get();
			jprop.text("" + cur);
			jprop.click(function(_) editValue(jprop, get, function(s) {
				addHistory(path, cur, s);
				cur = s;
				set(cur);
			}));
		case PColor(_, alpha, get, set):
			var cur = 0;
			function init() {
				cur = get().toColor();
				if( !alpha ) cur &= 0xFFFFFF;
				jprop.html('<div class="color" style="background:#${StringTools.hex(cur&0xFFFFFF,6)}"></div>');
			}
			var delay = false;
			jprop.click(function(_) {
				if( delay ) return;
				jprop.special("colorPick", [get().toColor(), alpha], function(c) {
					if( jprop.get() == null || jprop.get().id < 0 )
						return true;
					delay = true;
					haxe.Timer.delay(function() delay = false, 200);
					var color = h3d.Vector.fromColor(c.color);
					if( c.done ) {
						if( !alpha ) c.color &= 0xFFFFFF;
						addHistory(path, "#"+StringTools.hex(cur,alpha?8:6), "#"+StringTools.hex(c.color,alpha?8:6));
						cur = c.color;
					}
					set(color);
					if( c.done ) init();
					return c.done;
				});
			});
			init();
		case PTexture(_, get, set):
			var filePath = null;
			var isLoaded = false;
			function init() {
				var t = get();
				filePath = getTexturePath(t, true);
				if( filePath == null ) {
					if( t == null )
						jprop.text("");
					else {
						jprop.html(StringTools.htmlEscape("" + t) + " <button>View</button>");
						jprop.find("button").click(function(_) onShowTexture(get()));
					}
				} else
					jprop.html('<img src="file://$filePath"/>');
			}
			init();

			function onTextureSelect(_) {
				jprop.special("fileSelect", [filePath, "png,jpg,jpeg,gif"], function(newPath) {
					if( newPath == null ) return true;

					hxd.File.load(newPath, function(data) {
						if( isLoaded ) get().dispose();
						isLoaded = true;
						if( StringTools.startsWith(newPath.toLowerCase(), getResPath().toLowerCase()) )
							newPath = newPath.substr(getResPath().length);
						set( hxd.res.Any.fromBytes(newPath, data).toTexture() );
						addHistory(path, filePath, newPath);
						init();
						filePath = newPath;
					});

					return true;
				});
			}

			if( filePath == null )
				jprop.dblclick(onTextureSelect);
			else
				jprop.click(onTextureSelect);


		case PPopup(p, menu, click):
			j.dispose();
			j = addProp(basePath, t, p, gids, expandLevel);
			j.mousedown(function(e) {
				if( e.which == 3 )
					j.special("popupMenu", menu, function(i) { click(j, i); return true; });
			});
		case PCustom(name, content, _):
			if( name == "" ) {
				jname.dispose();
				jprop.attr("colspan", "2");
			}
			var c = content();
			if( c != null ) c.appendTo(jprop);
		}
		return j;
	}

	function editValue( j : JQuery, get : Void -> String, set : String -> Void ) {

		if( j.find("input").length > 0 ) return;

		var input = J("<input>");
		input.attr("value", get());
		j.text("");
		input.appendTo(j);
		input.focus();
		input.select();
		input.blur(function(_) {
			set(input.getValue());
			input.dispose();
			j.text(get());
		});
		input.keydown(function(e) {
			if( e.keyCode == 13 )
				input.blur();
		});
	}

}