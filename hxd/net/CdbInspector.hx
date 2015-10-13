package hxd.net;

enum Property {
	PBool( name : String, get : Void -> Bool, set : Bool -> Void );
	PEnum( name : String, e : Enum<Dynamic>, get : Void -> Dynamic, set : Dynamic -> Void );
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
		J("#material").dock(scene.get(), Down, 0.3);
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
		for( p in props ) {
			var j = J("<tr>");
			j.addClass("prop");
			j.addClass(p.getName().toLowerCase());
			j.appendTo(t);

			var jname = J("<th>");
			var jprop = J("<td>");
			jname.appendTo(j);
			jprop.appendTo(j);

			switch( p ) {
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
					input.trigger("focus");
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
			}
		}
		return t;
	}

	function selectObject( o : h3d.scene.Object ) {
		if( !o.isMesh() )
			return;
		var mat = o.toMesh().material;
		var j = J("#material");
		j.text("");
		j.attr("caption", "Material - " + (mat.name == null ? "@" + o.toString() : mat.name));
		for( pass in mat.getPasses() ) {
			var pgrp = J("<div>");
			pgrp.appendTo(j);

			var p = J("<div>");
			p.addClass("pass");
			p.text(pass.name);
			p.appendTo(pgrp);

			var t = makeProps([
				PBool("DepthWrite", function() return pass.depthWrite, function(b) pass.depthWrite = b),
				PEnum("DepthTest", h3d.mat.Data.Compare, function() return pass.depthTest, function(v) pass.depthTest = v),
			]);

			t.appendTo(pgrp);
			t.style("display", "none");
			p.click(function(_) t.toggle());
		}
	}

}