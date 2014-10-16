package hxd.fmt.h3d;

class Library {

	var entry : hxd.res.FileEntry;
	var header : Data;
	var cachedPrimitives : Array<h3d.prim.Primitive>;
	var cachedAnimations : Map<String, h3d.anim.Animation>;

	public function new(entry, header) {
		this.entry = entry;
		this.header = header;
		cachedPrimitives = [];
		cachedAnimations = new Map();
	}

	function makePrimitive( id : Int ) {
		var p = cachedPrimitives[id];
		if( p != null ) return p;
		p = new h3d.prim.H3DModel(header.geometries[id], header.dataPosition, entry);
		cachedPrimitives[id] = p;
		return p;
	}

	function makeMaterial( mid : Int, loadTexture : String -> h3d.mat.Texture ) {
		var m = header.materials[mid];
		var mat = new h3d.mat.MeshMaterial();
		mat.name = m.name;
		if( m.diffuseTexture != null ) {
			mat.texture = loadTexture(m.diffuseTexture);
			if( mat.texture == null ) mat.texture = h3d.mat.Texture.fromColor(0xFF00FF);
		}
		mat.blendMode = m.blendMode;
		mat.mainPass.culling = m.culling;
		if( m.killAlpha != null ) {
			var t = mat.mainPass.getShader(h3d.shader.Texture);
			t.killAlpha = true;
			t.killAlphaThreshold = m.killAlpha;
		}
		return mat;
	}

	public function makeObject( ?loadTexture : String -> h3d.mat.Texture ) : h3d.scene.Object {
		if( loadTexture == null )
			loadTexture = function(_) return h3d.mat.Texture.fromColor(0xFF00FF);
		if( header.models.length == 0 )
			throw "This file does not contain any model";
		var objs = [];
		for( m in header.models ) {
			var obj : h3d.scene.Object;
			if( m.geometries == null ) {
				obj = new h3d.scene.Object();
			} else {
				var prim = m.geometries.length == 1 ? makePrimitive(m.geometries[0]) : new h3d.prim.MultiPrimitive([for( g in m.geometries ) makePrimitive(g)]);
				if( m.materials.length == 1 )
					obj = new h3d.scene.Mesh(prim, makeMaterial(m.materials[0],loadTexture));
				else
					obj = new h3d.scene.MultiMaterial(prim, [for( m in m.materials ) makeMaterial(m,loadTexture)]);
			}
			obj.name = m.name;
			obj.defaultTransform = m.position.toMatrix();
			objs.push(obj);
			if( objs.length > 1 )
				objs[m.parent].addChild(obj);
		}
		return objs[0];
	}

	public function loadAnimation( ?mode : h3d.anim.Mode, ?name : String ) : h3d.anim.Animation {

		if( mode != null && mode != LinearAnim )
			throw "Mode should be LinearAnim";

		var a = cachedAnimations.get(name == null ? "" : name);
		if( a != null )
			return a;

		var a = null;
		if( name == null ) {
			if( header.animations.length == 0 )
				return null;
			a = header.animations[0];
		} else {
			for( a2 in header.animations )
				if( a2.name == name ) {
					a = a2;
					break;
				}
			if( a == null )
				throw 'Animation $name not found !';
		}
		var l = new h3d.anim.LinearAnimation(a.name, a.frames, a.sampling);
		l.speed = a.speed;
		l.loop = a.loop;

		entry.open();
		entry.skip(header.dataPosition + a.dataPosition);

		for( o in a.objects ) {
			var pos = o.flags.has(HasPosition), rot = o.flags.has(HasRotation), scale = o.flags.has(HasScale);
			if( pos || rot || scale ) {
				var fl = new haxe.ds.Vector<h3d.anim.LinearAnimation.LinearFrame>(a.frames);
				var size = ((pos ? 3 : 0) + (rot ? 3 : 0) + (scale?3:0)) * 4 * a.frames;
				var data = hxd.impl.Tmp.getBytes(size);
				entry.read(data, 0, size);
				var p = 0;
				for( i in 0...fl.length ) {
					var f = new h3d.anim.LinearAnimation.LinearFrame();
					if( pos ) {
						f.tx = data.getFloat(p); p += 4;
						f.ty = data.getFloat(p); p += 4;
						f.tz = data.getFloat(p); p += 4;
					} else {
						f.tx = 0;
						f.ty = 0;
						f.tz = 0;
					}
					if( rot ) {
						f.qx = data.getFloat(p); p += 4;
						f.qy = data.getFloat(p); p += 4;
						f.qz = data.getFloat(p); p += 4;
						var qw = 1 - f.qx * f.qx + f.qy * f.qy + f.qz * f.qz;
						f.qw = qw < 0 ? -Math.sqrt( -qw) : Math.sqrt(qw);
					} else {
						f.qx = 0;
						f.qy = 0;
						f.qz = 0;
						f.qw = 1;
					}
					if( scale ) {
						f.sx = data.getFloat(p); p += 4;
						f.sy = data.getFloat(p); p += 4;
						f.sz = data.getFloat(p); p += 4;
					} else {
						f.sx = 1;
						f.sy = 1;
						f.sz = 1;
					}
					fl[i] = f;
				}
				l.addCurve(o.name, fl, rot, scale);
				hxd.impl.Tmp.saveBytes(data);
			}
			if( o.flags.has(HasUV) ) {
				var fl = new haxe.ds.Vector(a.frames*2);
				var size = 2 * 4 * a.frames;
				var data = hxd.impl.Tmp.getBytes(size);
				entry.read(data, 0, size);
				for( i in 0...fl.length )
					fl[i] = data.getFloat(i * 4);
				l.addUVCurve(o.name, fl);
				hxd.impl.Tmp.saveBytes(data);
			}
			if( o.flags.has(HasAlpha) ) {
				var fl = new haxe.ds.Vector(a.frames);
				var size = 4 * a.frames;
				var data = hxd.impl.Tmp.getBytes(size);
				entry.read(data, 0, size);
				for( i in 0...fl.length )
					fl[i] = data.getFloat(i * 4);
				l.addAlphaCurve(o.name, fl);
				hxd.impl.Tmp.saveBytes(data);
			}
		}

		entry.close();

		cachedAnimations.set(a.name, l);
		if( name == null ) cachedAnimations.set("", l);

		return l;
	}

}