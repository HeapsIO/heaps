package hxd.fmt.hmd;

typedef GeometryDataFormat = hxd.BufferFormat.InputFormat;
typedef GeometryFormat = hxd.BufferFormat.BufferInput;

typedef DataPosition = Int;
typedef Index<T> = Int;

enum Property<T> {
	CameraFOVY( v : Float ) : Property<Float>;
	Unused_HasMaterialFlags; // TODO: Removing this will offset property indices
	HasExtraTextures;
	FourBonesByVertex;
	HasLod;
	HasCollider;
	HasColliders;
	HasCustomCollider;
}

typedef Properties = Null<Array<Property<Dynamic>>>;

enum abstract ColliderType(Int) from Int to Int {
	var ConvexHulls = 0;
	var Mesh = 1;
	var Group = 2;
	var Sphere = 3;
	var Box = 4;
	var Capsule = 5;
	var Cylinder = 6;
}

class Position {
	public var x : Float;
	public var y : Float;
	public var z : Float;
	public var qx : Float;
	public var qy : Float;
	public var qz : Float;
	public var qw(get, never) : Float;
	public var sx : Float;
	public var sy : Float;
	public var sz : Float;
	public function new() {
	}

	public inline function loadQuaternion( q : h3d.Quat ) {
		q.x = qx;
		q.y = qy;
		q.z = qz;
		q.w = qw;
	}

	function get_qw() {
		var qw = 1 - (qx * qx + qy * qy + qz * qz);
		return qw < 0 ? -Math.sqrt( -qw) : Math.sqrt(qw);
	}

	public function toMatrix(postScale=false) {
		var m = new h3d.Matrix();
		var q = QTMP;
		loadQuaternion(q);
		q.toMatrix(m);
		if( postScale ) {
			m.translate(x, y, z);
			m.scale(sx, sy, sz);
		} else {
			m._11 *= sx; m._12 *= sx; m._13 *= sx;
			m._21 *= sy; m._22 *= sy; m._23 *= sy;
			m._31 *= sz; m._32 *= sz; m._33 *= sz;
			m.translate(x, y, z);
		}
		return m;
	}
	static var QTMP = new h3d.Quat();
}

class Geometry {
	public var props : Properties;
	public var vertexCount : Int;
	public var vertexFormat : hxd.BufferFormat;
	public var vertexPosition : DataPosition;
	public var indexCount(get, never) : Int;
	public var indexCounts : Array<Int>;
	public var indexPosition : DataPosition;
	public var bounds : h3d.col.Bounds;
	public function new() {
	}
	function get_indexCount() {
		var k = 0;
		for( i in indexCounts ) k += i;
		return k;
	}
}

class BlendShape {
	public var name : String;
	public var geom : Index<Geometry>;
	public var vertexCount : Int;
	public var vertexFormat : hxd.BufferFormat;
	public var vertexPosition : DataPosition;
	public var indexCount : DataPosition;
	public var remapPosition : DataPosition;
	public function new() {
	}
}

class Collider {
	public var type : ColliderType;
}

class ConvexHullsCollider extends Collider {
	public var vertexCounts : Array<Int>;
	public var vertexPosition : DataPosition;
	public var indexCounts : Array<Int>;
	public var indexPosition : DataPosition;
	public function new() {
		type = ConvexHulls;
	}
}

class MeshCollider extends Collider {
	public var vertexCount : Int;
	public var vertexPosition : DataPosition;
	public var indexCount : Int;
	public var indexPosition : DataPosition;
	public function new() {
		type = Mesh;
	}
}

class GroupCollider extends Collider {
	public var colliders : Array<Collider>;
	public function new() {
		type = Group;
	}
}

class SphereCollider extends Collider {
	public var position : h3d.Vector;
	public var radius : Float;
	public function new() {
		type = Sphere;
	}
}

class BoxCollider extends Collider {
	public var position : h3d.Vector;
	public var halfExtent : h3d.Vector;
	public var rotation : h3d.Vector;
	public function new() {
		type = Box;
	}
}

class CapsuleCollider extends Collider {
	public var position : h3d.Vector;
	public var halfExtent : h3d.Vector;
	public var radius : Float;
	public function new() {
		type = Capsule;
	}
}

class CylinderCollider extends Collider {
	public var position : h3d.Vector;
	public var halfExtent : h3d.Vector;
	public var radius : Float;
	public function new() {
		type = Cylinder;
	}
}

class Material {

	public var name : String;
	public var props : Properties;
	public var diffuseTexture : Null<String>;
	public var specularTexture : Null<String>;
	public var normalMap : Null<String>;
	public var blendMode : h3d.mat.BlendMode;

	public function new() {
	}
}

class SkinJoint {
	public var name : String;
	public var props : Properties;
	public var parent : Index<SkinJoint>;
	public var position : Position;
	public var bind : Int;
	public var transpos : Null<Position>;
	public function new() {
	}
}

class SkinSplit {
	public var materialIndex : Int;
	public var joints : Array<Index<SkinJoint>>;
	public function new() {
	}
}

class Skin {
	public var name : String;
	public var props : Properties;
	public var joints : Array<SkinJoint>;
	public var split : Null<Array<SkinSplit>>;
	public function new() {
	}
}

class Model {
	public var name : String;
	public var props : Properties;
	public var parent : Index<Model>;
	public var follow : Null<String>;
	public var position : Position;
	public var geometry : Index<Geometry>;
	public var materials : Null<Array<Index<Material>>>;
	public var skin : Null<Skin>;
	public var lods : Array<Index<Model>>;
	public var collider : Null<Index<Collider>>;
	public var colliders : Null<Array<Index<Collider>>>;
	public function new() {
	}

	public function getObjectName() {
		if ( name == null )
			return name;
		var reg = ~/_*-*LOD0/;
		return reg.replace(name, '');
	}

	public function isLOD() {
		return name != null && name.indexOf("LOD") >= 0 && name.indexOf("LOD0") < 0;
	}

	public function isLOD0(modelName : String) {
		return name != null && StringTools.contains(name, modelName) && StringTools.contains(name, "LOD0");
	}

	public function toLODName(i : Int) {
		return name + "LOD" + i;
	}

	public function getLODInfos() : { lodLevel : Int , modelName : String } {
		var keyword = "LOD";
		if ( name == null || name.length <= keyword.length )
			return { lodLevel : -1, modelName : null };

		// Test prefix
		if ( name.substr(0, keyword.length) == keyword) {
			var parsedInt = Std.parseInt(name.substr( keyword.length, 1 ));
			if (parsedInt != null) {
				if ( Std.parseInt( name.substr( keyword.length + 1, 1 ) ) != null )
					throw 'Did not expect a second number after LOD in ${name}';
				return { lodLevel : parsedInt, modelName : name.substr(keyword.length) };
			}
		}

		// Test suffix
		var maxCursor = name.length - keyword.length - 1;
		if ( name.substr( maxCursor, keyword.length ) == keyword ) {
			var parsedInt = Std.parseInt( name.charAt( name.length - 1) );
			if ( parsedInt != null ) {
				return { lodLevel : parsedInt, modelName : name.substr( 0, maxCursor ) };
			}
		}

		return { lodLevel : -1, modelName : null };
	}

	public function isCollider() {
		if( name == null )
			return false;
		var idx = name.lastIndexOf("_");
		if( idx < 0 )
			return false;
		return StringTools.startsWith(name.substr(idx), "_Collider");
	}
}

enum AnimationFlag {
	HasPosition;
	HasRotation;
	HasScale;
	HasUV;
	HasAlpha;
	SingleFrame;
	HasProps;
	Reserved;
}

class AnimationObject {
	public var name : String;
	public var flags : haxe.EnumFlags<AnimationFlag>;
	public var props : Array<String>;
	public function new() {
	}
	public function getStride() {
		var stride = 0;
		if( flags.has(HasPosition) ) stride += 3;
		if( flags.has(HasRotation) ) stride += 3;
		if( flags.has(HasScale) ) stride += 3;
		if( flags.has(HasUV) ) stride += 2;
		if( flags.has(HasAlpha) ) stride += 1;
		if( flags.has(HasProps) ) stride += props.length;
		return stride;
	}
}

class AnimationEvent {
	public var frame : Int;
	public var data : String;
	public function new() {
	}
}

class Animation {
	public var name : String;
	public var props : Properties;
	public var frames : Int;
	public var sampling : Float;
	public var speed : Float;
	public var loop : Bool;
	public var objects : Array<AnimationObject>;
	public var events : Null<Array<AnimationEvent>>;
	public var dataPosition : DataPosition;
	public function new() {
	}
}

class Data {

	public static inline var CURRENT_VERSION = 4;

	public var version : Int;
	public var props : Properties;
	public var geometries : Array<Geometry>;
	public var materials : Array<Material>;
	public var models : Array<Model>;
	public var animations : Array<Animation>;
	public var shapes : Array<BlendShape>;
	public var colliders : Array<Collider>;
	public var dataPosition : Int;
	public var data : haxe.io.Bytes;

	public function new() {
	}

}
