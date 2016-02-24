package;
import hxd.Res;


class Joint {
	var j : h3d.anim.Skin.Joint;
	var s : h3d.scene.Mesh;
	public var visible(default, set) : Bool;

	public function new (j : h3d.anim.Skin.Joint, parent: h3d.scene.Skin) {
		this.j = j;

		var p = new h3d.prim.Sphere(16, 16);
		p.addNormals();
		s = new h3d.scene.Mesh(p, parent);
		s.setScale(0.015);
		s.follow = parent.getObjectByName(j.name);
		s.name = "Joint("+j.name+")";
		s.material.color.setColor(0xFF0000);
		s.material.mainPass.depth(false, Always);
		s.material.mainPass.setPassName("add");
		s.material.mainPass.enableLights = false;
		visible = false;
	}

	function set_visible(b : Bool) {
		return s.visible = visible = b;
	}

	public function remove() {
		s.remove();
	}

	public function update(dt : Float) {

	}
}

class TreeView
{
	static var minWidth(default, set) = 0;
	static var minHeight(default, set) = 0;
	static var elts : Array<TreeView>;
	static var curr : Array<TreeView>;
	static var cont : h2d.Sprite;
	static var box : h2d.Bitmap;
	static var height = 22;
	static var bt : h2d.Interactive;
	static var fg : h2d.Bitmap;
	static var select : h2d.Bitmap;
	static var highlight : TreeView;
	static var s2d : h2d.Scene.Scene;
	static var dot : h2d.Bitmap;
	static var dummy : h3d.scene.Mesh;

	var obj : h3d.scene.Object;
	var childs : Array<TreeView>;
	var parent : TreeView;
	var unfold = true;
	var tf : h2d.Text;
	var arrow : h2d.Bitmap;
	var joints : Array<Joint>;
	var isdummy = false;

	public var showJoints(default, set): Bool;
	public var visible(default, set): Bool;
	public var x(default, set) : Float;
	public var y(default, set) : Float;
	public var selected : TreeView;

	public function new (o, parent = null) {
		if(cont == null)
			throw("TreeView must be initialized");

		this.obj = o;
		this.parent = parent;
		this.childs = [];
		elts.push(this);

		if(Std.is(o, h3d.scene.Skin)) {
			unfold = false;
			var s = cast(o, h3d.scene.Skin);
			joints = [];
			for( j in s.getSkinData().allJoints)
				joints.push(new Joint(j, s));
		}

		if(!o.isMesh() && o.numChildren == 0 )
			isdummy = true;

		if(parent == null) {
			bt.onOver = function(e:hxd.Event) {
				fg.visible = true;
			}
			bt.onOut = function(e:hxd.Event) {
				fg.visible = false;
				if(!select.visible)
					setHighligth(null);
			}
			bt.onMove = function(e:hxd.Event) {
				var id = Std.int(e.relY / height);
				fg.y = id * height;
				if(!select.visible){
					select.y = id * height;
					setHighligth(curr[id]);
				}
				else setHighligth(curr[Std.int(select.y / height)]);
			}
			bt.onClick = function(e:hxd.Event) {
				var id = Std.int(e.relY / height);
				var row = curr[id];

				selected = row;

				if(row.childs.length == 0) {
					if(fg.y == select.y)
						select.visible = !select.visible;
					else {
						select.y = fg.y;
						select.visible = true;
					}
				}
				else {
					row.unfold = !row.unfold;
					if(!row.unfold && select.visible) {
						//remove selected if parent is closed
						var e = curr[Std.int(select.y / height)];
						if(row.parent == null || e.parent == row)
							select.visible = false;
					}

					var old = select.visible ? curr[Std.int(select.y / height)] : null;
					draw();

					//update new select position
					if(old != null)
						for( i in 0...curr.length) {
							if(curr[i] == old) {
								select.y = i * height;
								break;
							}
						}
				}
				e.propagate = false;
			}
			bt.onWheel = function(e : hxd.Event) {
				cont.y -= e.wheelDelta * height * 3;
				e.propagate = false;
			};
			bt.onPush = function(e : hxd.Event) { e.propagate = false; }

			getObjectsLib(this);
			draw();
		}
	}

	public function onKey(e:hxd.Event) {
		if( selected == null ) return;
		if( e.keyCode == "V".code ) {
			selected.obj.visible = !selected.obj.visible;
			draw();
		}
	}

	function setHighligth(e : TreeView) {
		if(highlight != null) {
			for( m in highlight.obj.getMaterials() )
				m.mainPass.removeShader(m.mainPass.getShader(h3d.shader.ColorAdd));
			var skin = highlight.joints != null ? highlight : null;
			if(skin == null && highlight.parent != null)
				skin = highlight.parent.joints != null ? highlight.parent : null;
			if(skin != null && !Viewer.props.showBones) {
				cast(skin.obj, h3d.scene.Skin).showJoints = false;
				for(j in skin.joints)
					j.visible = false;
			}
			if(highlight.obj.name != null && highlight.obj.name.substr(0, 5) == "Joint") {
				highlight.obj.toMesh().material.color.setColor(0xFF0000);
				highlight.obj.setScale(0.015);
			}
			setDummy();
		}

		highlight = e;
		if(highlight != null) {
			var skin = highlight.joints != null ? highlight : null;
			if(skin == null && highlight.parent != null && highlight.obj.name.substr(0, 5) == "Joint")
				skin = highlight.parent.joints != null ? highlight.parent : null;
			if(skin != null) {
				cast(skin.obj, h3d.scene.Skin).showJoints = true;
				for(j in skin.joints)
					j.visible = true;
			}

			if(highlight.obj.name != null && highlight.obj.name.substr(0, 5) == "Joint") {
				highlight.obj.toMesh().material.color.setColor(0xFF00FF);
				highlight.obj.setScale(0.025);
			}
			if(e.isdummy)
				setDummy(e.obj);
		}
	}

	function getObjectsLib(parent : TreeView) {
		function getObjectsRec( e : TreeView) {
			for( o in e.obj ) {
				var child = new TreeView(o, e);
				e.childs.push(child);
				getObjectsRec(child);
			}
		}
		getObjectsRec(parent);
	}

	static function set_minWidth(v : Int) {
		box.tile = h2d.Tile.fromColor(0, v, minHeight, 0.3);
		fg.tile = h2d.Tile.fromColor(0, v, height, 0.3);
		select.tile = h2d.Tile.fromColor(0, v, height, 0.3);
		bt.width = v;
		return minWidth = v;
	}

	static function set_minHeight(v : Int) {
		box.tile = h2d.Tile.fromColor(0, minWidth, v, 0.3);
		bt.height = v;
		return minHeight = v;
	}

	function set_x(v : Float) {
		return cont.x = v;
	}

	function set_y(v : Float) {
		return cont.y = v;
	}

	public static function init(scene2d) {
		s2d = scene2d;

		if(cont == null) {
			cont = new h2d.Sprite(s2d);
			box = new h2d.Bitmap(h2d.Tile.fromColor(0), cont);
			fg = new h2d.Bitmap(h2d.Tile.fromColor(0), cont);
			fg.visible = false;
			select = new h2d.Bitmap(h2d.Tile.fromColor(0), cont);
			select.visible = false;
			bt = new h2d.Interactive(0, 0, cont);
			bt.propagateEvents = true;

			var t = Res.dot.toTile();
			t.dx -= t.width >> 1;
			t.dy -= t.height >> 1;
			dot = new h2d.Bitmap(t, cont);
			dot.visible = false;
		}

		clear();
		elts = [];
		if(dummy != null) {
			dummy.remove();
			dummy = null;
		}
	}

	static function clear() {
		minWidth = 0;
		minHeight = 0;
		curr = [];
		if(elts != null)
			for( e in elts)
				if(e.tf != null) {
					e.tf.remove();
					if(e.arrow != null)
						e.arrow.remove();
				}
	}

	public function draw(level = 0) {
		if(level == 0)
			clear();

		var dx = 14 + (parent != null ? parent.tf.x : 0);
		var font = hxd.res.FontBuilder.getFont("Verdana", 12);

		if(childs.length != 0) {
			var t = Res.arrow.toTile();
			t.dx -= t.width >> 1;
			t.dy -= t.height >> 1;
			arrow = new h2d.Bitmap(t, cont);
			arrow.x = dx + height * 0.5 - 16;
			arrow.y = minHeight + height * 0.5 + 1;
		}

		if(tf != null) tf.remove();
		tf = new h2d.Text(font, cont);
		var str = obj.toString();
		tf.text = str.indexOf("Joint") != -1 ? str.substr(5, str.length - 6) : str;

		tf.color.setColor(obj.visible ? 0xFFFFFFFF : 0xFF808080);
		tf.x = 5 + dx;
		tf.y = 5 + minHeight;

		minWidth = Std.int(Math.max(minWidth, tf.x + tf.textWidth + 10));
		minHeight += height;

		curr.push(this);
		if(unfold) {
			if(arrow != null) {
				arrow.rotation = Math.PI * 0.5;
				arrow.y += 1;
			}
			for(c in childs)
				c.draw(level + 1);
		}
	}

	function set_showJoints(b : Bool) {
		for ( e in elts) {
			if(e.joints != null)
				for(j in e.joints)
					j.visible = b;
		}

		return showJoints = b;
	}


	function setDummy(?o : h3d.scene.Object) {
		if(o == null) {
			if(dummy != null)
				dummy.visible = false;
			return;
		}

		if(dummy == null) {
			var p = new h3d.prim.Sphere(16, 16);
			p.addNormals();
			dummy = new h3d.scene.Mesh(p, o);
			dummy.material.color.setColor(0xFF00FF);
			dummy.material.mainPass.depth(false, Always);
			dummy.material.mainPass.setPassName("add");
			dummy.material.mainPass.enableLights = false;
		}
		o.addChild(dummy);
		dummy.visible = true;
	}

	var vect = new h3d.Vector(1, 0.5, 0.5);
	var cpt = 0.;
	public function update(dt:Float) {
		if(parent == null) {
			if(highlight != null) {
				var s = 0.8 + 0.2 * Math.sin(cpt);
				var color = new h3d.Vector(vect.x * s, vect.y * s, vect.z * s);
				for( m in highlight.obj.getMaterials() ) {
					m.mainPass.removeShader(m.mainPass.getShader(h3d.shader.ColorAdd));
					m.mainPass.addShader(new h3d.shader.ColorAdd(color.toColor()));
				}
			}
			cpt += 0.5 * dt;
		}

		for(c in childs)
			c.update(dt);

		if(joints != null)
			for (j in joints)
				j.update(dt);

		if(box.tile.height <= s2d.height)
			cont.y = 0;
		else cont.y = Math.max( -box.tile.height + s2d.height - height, Math.min(0, cont.y));

		dot.visible = select.visible;
		if(dot.visible) {
			var e = curr[Std.int(select.y / height)];
			dot.x = e.tf.x - 10;
			dot.y = select.y + 12;
		}

		if(dummy != null && dummy.visible) {
			var cam = @:privateAccess Viewer.inst.s3d.camera;
			var d = cam.pos.sub(cam.target).length();
			dummy.setScale(0.003 * d);
		}
	}

	function set_visible(b : Bool) {
		cont.visible = b;
		return visible = b;
	}

	public function trace(level = 0) {
		var offset = "";
		for (i in 0...level) offset += "    ";
		offset += "-> ";
		trace(offset + obj);
		for(c in childs)
			c.trace(level + 1);
	}
}