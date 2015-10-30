package hxd.fmt.spine;
import hxd.fmt.spine.JsonData;
import hxd.fmt.spine.Data;

class Library {

	public var bonesMap : Map<String,Bone>;
	public var bones : Array<Bone>;
	public var slots : Array<Slot>;
	public var defaultSkin : Skin;
	public var skins : Map<String,Skin>;
	public var animations : Map<String, Animation>;

	public function new() {
		bones = [];
		slots = [];
		bonesMap = new Map();
		skins = new Map();
		animations = new Map();
	}

	public function loadText( j : String ) {
		load(haxe.Json.parse(j));
	}

	inline function def<T>( v : Null<T>, def : T ) {
		return v == null ? def : v;
	}

	public function load( j : JsonData ) {

		if( j.bones != null )
			for( bd in j.bones ) {
				var b = new Bone();
				b.name = bd.name;
				if( bd.parent != null ) {
					b.parent = bonesMap.get(bd.parent);
					if( b.parent == null ) throw "Missing bone " + bd.parent;
					b.parent.childs.push(b);
				}

				b.length = def(bd.length, 0);
				b.x = def(bd.x,0);
				b.y = def(bd.y,0);
				b.rotation = def(bd.rotation,0) * Math.PI / 180;
				b.scaleX = def(bd.scaleX, 1);
				b.scaleY = def(bd.scaleY, 1);
				b.flipX = bd.flipX;
				b.flipY = bd.flipY;
				b.inheritScale = def(bd.inheritScale, true);
				b.inheritRotation = def(bd.inheritRotation,true);

				bones.push(b);
				bonesMap.set(b.name, b);
			}

		if( j.ik != null )
			trace("TODO : ik");

		var slotByName = new Map();
		if( j.slots != null ) {
			var BLENDS = new Map<String, h2d.BlendMode>();
			for( sd in j.slots ) {
				var s = new Slot();
				s.name = sd.name;
				s.attachment = sd.attachment;
				s.blendMode = sd.blend == null ? Alpha : BLENDS.get(sd.blend);
				if( s.blendMode == null ) throw "Unknown blend mode " + sd.blend;
				if( sd.color != null )
					s.color.setColor(parseColor(sd.color));
				slotByName.set(s.name, s);
				slots.push(s);
			}
		}

		if( j.skins != null )
			for( skinName in j.skins.keys() ) {
				var sd = j.skins.get(skinName);
				var s = new Skin();
				s.name = skinName;
				for( slotName in sd.keys() ) {
					var ssd = sd.get(slotName);
					var slot = slotByName.get(slotName);
					if( slot == null ) throw "Unknown skin slot " + slotName;
					for( attachName in ssd.keys() ) {
						var a = loadAttachment(ssd.get(attachName));
						a.skin = s;
						a.slot = slot;
						s.attachments.push(a);
					}
				}
				skins.set(s.name, s);
				if( s.name == "default" )
					defaultSkin = s;
			}

		if( j.animations != null )
			for( animName in j.animations.keys() ) {
				var a = loadAnimation(j.animations.get(animName));
				a.name = animName;
				animations.set(animName, a);
			}
	}

	function parseColor( color : String ) {
		return Std.parseInt("0x" + color);
	}

	function loadAttachment( j : JAttachment ) {
		var type = j.type;
		if( type == null ) type = "region";
		var attach : Attachment;
		switch( type ) {
		case "region":

			var j : JRegionAttach = cast j;
			var r = new RegionAttachment();

			var x = def(j.x, 0);
			var y = def(j.y, 0);
			var scaleX = def(j.scaleX, 1);
			var scaleY = def(j.scaleY, 1);
			var rotation = def(j.rotation, 0) * Math.PI / 180;

			r.width = j.width;
			r.height = j.height;
			// TODO

			attach = r;

		case "skinnedmesh":
			var j : JSkinMeshAttach = cast j;
			var s = new SkinnedMeshAttachment();
			var vertices = j.vertices;
			var uvs = j.uvs;
			var pos = 0, uvPos = 0;
			while( pos < vertices.length ) {
				var nbones = Std.int(vertices[pos++]);
				var v = new SkinnedVertice();
				if( nbones == 0 ) throw "no bones?";

				v.u = uvs[uvPos++];
				v.v = uvs[uvPos++];

				v.bone0 = bones[Std.int(vertices[pos++])];
				v.vx0 = vertices[pos++];
				v.vy0 = vertices[pos++];
				v.vw0 = vertices[pos++];

				if( nbones > 1 ) {
					v.bone1 = bones[Std.int(vertices[pos++])];
					v.vx1 = vertices[pos++];
					v.vy1 = vertices[pos++];
					v.vw1 = vertices[pos++];
				}
				if( nbones > 2 ) {
					v.bone2 = bones[Std.int(vertices[pos++])];
					v.vx2 = vertices[pos++];
					v.vy2 = vertices[pos++];
					v.vw2 = vertices[pos++];
				}
				if( nbones > 3 ) {
					for( i in 0...nbones - 3 ) {
						var bone = bones[Std.int(vertices[pos++])];
						var vx = vertices[pos++];
						var vy = vertices[pos++];
						var w = vertices[pos++];
						if( v.vw0 < v.vw1 && v.vw0 < v.vw2 ) {
							if( w > v.vw0 ) {
								v.bone0 = bone;
								v.vx0 = vx;
								v.vy0 = vy;
								v.vw0 = w;
							}
						} else if( v.vw1 < v.vw0 && v.vw1 < v.vw2 ) {
							if( w > v.vw1 ) {
								v.bone1 = bone;
								v.vx1 = vx;
								v.vy1 = vy;
								v.vw1 = w;
							}
						} else {
							if( w > v.vw2 ) {
								v.bone2 = bone;
								v.vx2 = vx;
								v.vy2 = vy;
								v.vw2 = w;
							}
						}
					}
					// normalize weights
					var tot = v.vw0 + v.vw1 + v.vw2;
					v.vw0 /= tot;
					v.vw1 /= tot;
					v.vw2 /= tot;
				}

				s.vertices.push(v);
			}
			s.triangles = j.triangles;
			attach = s;

		default:
			throw "Unsupported attach type " + type;
		}
		if( j.color != null )
			attach.color.setColor(parseColor(j.color));
		return attach;
	}

	function loadAnimation( j : JAnimation ) {
		var a = new Animation();

		if( j.slots != null )
			trace("TODO : slots");

		if( j.bones != null ) {
			var boneCurves = new Map();
			for( boneName in j.bones.keys() ) {
				var bd = j.bones.get(boneName);
				var bone = bonesMap.get(boneName);
				if( bone == null ) throw "Missing bone " + boneName;

				var c = boneCurves.get(boneName);
				if( c == null ) {
					c = new BoneCurve(bone);
					boneCurves.set(bone.name, c);
				}

				if( bd.translate != null ) {
					var values = new haxe.ds.Vector(bd.translate.length * 3);
					var pos = 0;
					for( t in bd.translate )
						values[pos++] = t.time;
					for( t in bd.translate ) {
						values[pos++] = t.x;
						values[pos++] = t.y;
					}
					c.translate = values;
				}
				if( bd.scale != null ) {
					var values = new haxe.ds.Vector(bd.scale.length * 3);
					var pos = 0;
					for( t in bd.scale )
						values[pos++] = t.time;
					for( t in bd.scale ) {
						values[pos++] = t.x;
						values[pos++] = t.y;
					}
					c.scale = values;
				}
				if( bd.rotate != null ) {
					var values = new haxe.ds.Vector(bd.rotate.length * 2);
					var pos = 0;
					for( t in bd.rotate )
						values[pos++] = t.time;
					for( t in bd.rotate ) {
						var a = t.angle * Math.PI / 180;
						values[pos++] = a;
					}
					c.rotate = values;
				}
				if( bd.flipX != null || bd.flipY != null )
					trace("TODO : bone flip anim");
			}
		}

		if( j.ik != null )
			trace("TODO : ik");

		if( j.events != null )
			trace("TODO : events");

		if( j.ffd != null )
			trace("TODO : ffd");

		if( j.drawOrder != null )
			trace("TODO : drawOrder");

		return a;
	}

}