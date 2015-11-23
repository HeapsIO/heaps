package hxd.net;
import cdb.jq.JQuery;
import hxd.net.Property;

private typedef History = { path : String, oldV : Dynamic, newV : Dynamic };

class PropInspector extends cdb.jq.Client {

	public var host : String = "127.0.0.1";
	public var port = 6669;
	public var connected(default,null) = false;

	var sock : hxd.net.Socket;
	var flushWait = false;

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
				var msg : cdb.jq.Message.Answer = cdb.BinSerializer.unserialize(data);
				handle(msg);
			}
		}
		connect();
	}

	override function onKey(e:cdb.jq.Event) {
		switch( e.keyCode ) {
		case 'Z'.code if( e.ctrlKey ):
			undo();
		case 'Y'.code if( e.ctrlKey ):
			redo();
		default:
			handleKey(e);
		}
	}

	public dynamic function handleKey( e : cdb.jq.Event ) {
	}

	function connect() {
		sock.close();
		sock.connect(host, port, function() {
			connected = true;
			syncDom();
			onConnected(true);
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

	public function setPathPropValue( path : String, v : Dynamic ) {
		var fullPath = path;
		var path = path.split(".");
		var props = resolveProps(path);
		if( props == null ) return;
		var ppath = path.join(".");
		var p = getPropPath(path, props);
		if( p != null )
			setPropValue(p, v);
		else
			trace("Prop not found " + ppath + " in "+fullPath.substr(0, fullPath.length - (ppath.length + 1)));
	}

	function getPropPath( path : Array<String>, props : Array<Property> ) {
		for( p in props ) {
			var p = propFollow(p);
			var name = getPropName(p);
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

	function setPropValue( p : Property, v : Dynamic ) {
		switch( propFollow(p) ) {
		case PInt(_, _, set):
			if( !Std.is(v, Int) ) throw "Invalid int value " + v;
			set(v);
		case PFloat(_, _, set):
			if( !Std.is(v, Float) ) throw "Invalid float value " + v;
			set(v);
		case PBool(_, _, set):
			if( !Std.is(v, Bool) ) throw "Invalid bool value " + v;
			set(v);
		case PString(_, _, set):
			if( v != null && !Std.is(v, String) ) throw "Invalid string value " + v;
			set(v);
		case PEnum(_, en, _, set):
			var e = en.createAll()[v];
			if( e == null || !Std.is(v, Int) ) throw "Invalid enum " + en.getName() + " value " + v;
			set(e);
		case PColor(_, _, _, set):
			if( !Std.is(v, String) ) throw "Invalid color value " + v;
			set(h3d.Vector.fromColor(Std.parseInt("0x"+v.substr(1))));
		case PFloats(_, get, set):
			if( !Std.is(v, Array) ) throw "Invalid floats value " + v;
			var a : Array<Float> = v;
			var need = get().length;
			if( a.length != need ) throw "Require "+need+" floats in value " + v;
			set(a.copy());
		case PTexture(_, _, set):
			if( !Std.is(v, String) ) throw "Invalid texture value " + v;
			var path : String = v;
			if( path.charCodeAt(0) != '/'.code && path.charCodeAt(1) != ':'.code )
				path = hxd.File.applicationPath() + path;
			hxd.File.load(path, function(data) set( hxd.res.Any.fromBytes(path, data).toTexture() ));
		case PCustom(_, _, set) if( set != null ):
			set(v);
		case PGroup(_), PPopup(_), PCustom(_):
			throw "Cannot set property " + p.getName();
		}
	}

	public function makeProps( basePath : String, props : Array<Property>, expandLevel = 1 ) {
		var t = J("<table>");
		t.addClass("props");
		refreshProps = function() {
			t.text("");
			for( p in props )
				addProp(basePath, t, p, [], expandLevel);
		};
		refreshProps();
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

	function getPropName( p : Property ) {
		return switch( propFollow(p) ) {
		case PGroup(name, _), PBool(name, _), PInt(name, _), PFloat(name, _), PFloats(name, _), PString(name, _), PColor(name, _), PTexture(name, _), PEnum(name,_,_,_), PCustom(name,_): name;
		case PPopup(_): null;
		}
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

		var name = getPropName(p);
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
			jprop.remove();
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
					if( v != null ) {
						addHistory(path, cur, v);
						cur = v;
						set(all[v]);
					}
					input.remove();
					jprop.text(get());
				});
			});
		case PInt(_, get, set):
			jprop.text("" + get());
			j.dblclick(function(_) editValue(jprop,function() return "" + get(),
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
			j.dblclick(function(_) editValue(jprop,function() return "" + get(),
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
		case PFloats(_, get, set):
			var values = get();
			jprop.html("<table><tr></tr></table>");
			var jt = jprop.find("tr");
			for( i in 0...values.length ) {
				var jv = J("<td>").appendTo(jt);
				jv.text("" + values[i]);
				jv.dblclick(function(_) editValue(jv,function() return "" + values[i],
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
						var old = values[i];
						var cur = old;
						jv.addClass("active");
						jv.special("startDrag", [], function(v: { done:Bool, dx:Float, dy:Float } ) {
							var delta = ( Math.max(Math.abs(old == 0 ? 1 : old), 1e-3) / 100 ) * v.dx;
							cur += delta;
							values[i] = hxd.Math.fmt(cur);
							set(values);
							jv.text("" + values[i]);
							if( v.done ) {
								jv.removeClass("active");
								addHistory(path, old, values[i]);
							}
							return v.done;
						});
					}
			});
			}
		case PString(_, get, set):
			var cur = get();
			jprop.text("" + cur);
			j.dblclick(function(_) editValue(jprop, get, function(s) {
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
			jprop.dblclick(function(_) {
				jprop.special("colorPick", [get().toColor(), alpha], function(c) {
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
						filePath = lfs.baseDir + res.entry.path;
					else {
						var resPath = haxe.macro.Compiler.getDefine("resPath");
						if( resPath == null ) resPath = "res";
						filePath = hxd.File.applicationPath() + resPath + "/" + res.entry.path;
					}
				} else if( t != null && t.name != null && (t.name.charCodeAt(0) == '/'.code || t.name.charCodeAt(1) == ':'.code) )
					filePath = t.name;

				if( filePath == null ) {
					if( t == null )
						jprop.text("");
					else {
						jprop.html(StringTools.htmlEscape("" + t) + " <button>View</button>");
						jprop.find("button").click(function(_) {
							var p = createPanel("" + t);
							p.html("Loading...");
							haxe.Timer.delay(function() {
								var bmp = t.capturePixels();
								var png = bmp.toPNG();
								bmp.dispose();
								var pngBase64 = new haxe.crypto.BaseCode(haxe.io.Bytes.ofString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/")).encodeBytes(png).toString();
								p.html('<img src="data:image/png;base64,$pngBase64" style="background:#696969"/>');
							},0);
						});
					}
				} else
					jprop.html('<img src="file://$filePath"/>');
			}
			init();

			function relPath(path) {
				var base = hxd.File.applicationPath();
				if( StringTools.startsWith(path, base) )
					return path.substr(base.length);
				return path;
			}

			jprop.dblclick(function(_) {
				jprop.special("fileSelect", [filePath, "png,jpg,jpeg,gif"], function(newPath) {

					if( newPath == null ) return true;

					hxd.File.load(newPath, function(data) {
						if( isLoaded ) get().dispose();
						isLoaded = true;
						set( hxd.res.Any.fromBytes(newPath, data).toTexture() );
						addHistory(path, relPath(filePath), relPath(newPath));
						init();
						filePath = newPath;
					});

					return true;
				});
			});
		case PPopup(p, menu, click):
			j.remove();
			j = addProp(basePath, t, p, gids, expandLevel);
			j.mousedown(function(e) {
				if( e.which == 3 )
					j.special("popupMenu", menu, function(i) { click(j, i); return true; });
			});
		case PCustom(_, content, _):
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
			input.remove();
			set(input.getValue());
			j.text(get());
		});
		input.keydown(function(e) {
			if( e.keyCode == 13 )
				input.blur();
		});
	}

}