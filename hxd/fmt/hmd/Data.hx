package hxd.fmt.hmd;

import hxd.fmt.fbx.HMDOut.CollideParams;

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
	var Empty = 255; // Stored as byte
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


enum ResolveResult {
	Empty;
	Mesh(model : Model);
	ConvexHulls(model : Model);
	Shapes;
}

class Collider {
	public var type : ColliderType;

	public static function resolveColliderType(d : Data, model : Model, params : CollideParams, ?collisionThresholdHeight : Float, ?collisionUseLowLod : Bool) : ResolveResult {
		var generateCollides : Dynamic = null; // Default config (props.json)

		var type : ResolveResult = null;
		if (params == null)
			type = ResolveResult.Empty;
		var collidersParams = params;
		if (type == null && params.useDefault) {
			collidersParams = generateCollides;
			var colliderModel = findMeshModel(d, model.getObjectName() + "_Collider");
			if (colliderModel != null) {
				type = ResolveResult.Mesh(colliderModel);
			}

			if (type == null && collisionThresholdHeight != null) {
				var dimension = d.geometries[model.geometry].bounds.dimension();
				if (dimension < collisionThresholdHeight)
					type = ResolveResult.Empty;
			}

			if (type == null && collisionUseLowLod != null) {
				if (model.lods != null && model.lods.length > 0)
					type = ResolveResult.Mesh(d.models[model.lods[model.lods.length - 1]]);
			}
		}
		if (type == null && collidersParams != null) {
			var colliderModel = findMeshModel(d, collidersParams.mesh) ?? model;
			if( collidersParams.precision != null ) {
				type = ResolveResult.ConvexHulls(colliderModel);
			} else if( collidersParams.mesh != null ) {
				type = ResolveResult.Mesh(colliderModel);
			} else if( collidersParams.shapes != null ) {
				type = ResolveResult.Shapes;
			}
		}

		return type;
	}

	static function findMeshModel(d : Data, name : String) {
		if (name == null)
			return null;
		for (model in d.models) {
			if (model.geometry >= 0 && model.name == name)
				return model;
		}
		return null;
	}
}


typedef ConvexHullParams = {
	var maxConvexHulls : Int;
	var maxResolution : Int;
};

class ConvexHullsCollider extends Collider {
	public var vertexCounts : Array<Int>;
	public var vertexPosition : DataPosition;
	public var indexCounts : Array<Int>;
	public var indexPosition : DataPosition;
	public function new() {
		type = ConvexHulls;
	}

	public static function buildConvexHulls(vertices : Array<Float>, indexes : Array<Int>, params : ConvexHullParams) {
		var vCount = Std.int(vertices.length / 3);
		var triCount = Std.int(indexes.length / 3);
		var out : Array<{vertices: Array<Float>, indexes : Array<Int>}> = [];

		#if (sys || nodejs)
		// Format data for meshtools
		var outputData = new haxe.io.BytesBuffer();
		outputData.addInt32(vCount);
		for (idx in 0...vCount) {
			var x = vertices[idx * 3];
			var y = vertices[idx * 3 + 1];
			var z = vertices[idx * 3 + 2];
			outputData.addFloat(x);
			outputData.addFloat(y);
			outputData.addFloat(z);
		}

		outputData.addInt32(triCount);
		for (idx in indexes)
			outputData.addInt32(idx);

		// Exec meshtools
		var fileName = tmpFile("vhacd_data");
		var outFile = fileName + ".out";
		sys.io.File.saveBytes(fileName, outputData.getBytes());

		var ret = try Sys.command("meshTools",["vhacd", fileName, outFile, '${params.maxConvexHulls}', '${params.maxResolution}']) catch( e : Dynamic ) -1;
		if( ret != 0 ) {
			sys.FileSystem.deleteFile(fileName);
			throw "Failed to call 'vhacd' executable required to generate collision data. Please ensure it's in your PATH";
		}

		// Get result data and format it for output
		var bytes = sys.io.File.getBytes(outFile);
		var i = 0;
		var convexHullCount = bytes.getInt32(i++<<2);
		for ( idx in 0...convexHullCount ) {
			var pointCount = bytes.getInt32(i++<<2);
			var vertices = [];
			for ( _ in 0...pointCount ) {
				var x = bytes.getDouble(i<<2);
				vertices.push(x);
				i += 2;
				var y = bytes.getDouble(i<<2);
				vertices.push(y);
				i += 2;
				var z = bytes.getDouble(i<<2);
				vertices.push(z);
				i += 2;
			}

			var triangleCount = bytes.getInt32(i++<<2);
			var indexes = [];
			for ( _ in 0...triangleCount ) {
				indexes.push(bytes.getInt32(i++<<2));
				indexes.push(bytes.getInt32(i++<<2));
				indexes.push(bytes.getInt32(i++<<2));
			}

			out.push({ vertices: vertices, indexes: indexes });
		}

		sys.FileSystem.deleteFile(fileName);
		sys.FileSystem.deleteFile(outFile);

		return out;
		#end

		#if (hl && hl_ver >= version("1.15.0"))
		var verticesBytes = new hl.Bytes(vCount * 3 * 4);
		for (idx in 0...vCount) {
			var x = vertices[idx * 3];
			var y = vertices[idx * 3 + 1];
			var z = vertices[idx * 3 + 2];
			verticesBytes.setF32(4 * idx * 3, x);
			verticesBytes.setF32(4 * (idx * 3 + 1), y);
			verticesBytes.setF32(4 * (idx * 3 + 2), z);
		}

		var indexesBytes = new hl.Bytes(indexes.length * 4);
		for (idx in 0...indexes.length)
			indexesBytes.setI32(4 * idx, indexes[idx]);

		var startStamp = haxe.Timer.stamp();
		var vhacdInstance = new hxd.tools.VHACD();
		var p = new hxd.tools.VHACD.Parameters();
		p.maxConvexHulls = params.maxConvexHulls;
		p.maxResolution = params.maxResolution;
		vhacdInstance.compute(verticesBytes, vCount, indexesBytes, triCount, p);
		var convexHullCount = vhacdInstance.getConvexHullCount();
		if ( convexHullCount == 0 )
			return null;

		var convexHull = new hxd.tools.VHACD.ConvexHull();
		for ( i in 0...convexHullCount) {
			vhacdInstance.getConvexHull(i, convexHull);
			var pointCount = convexHull.pointCount;
			var pos = 0;
			var pointsBytes = convexHull.points;
			var vertices = [];
			for ( _ in 0...pointCount ) {
				var x = pointsBytes.getF64(8*pos++);
				var y = pointsBytes.getF64(8*pos++);
				var z = pointsBytes.getF64(8*pos++);
				vertices.push(x);
				vertices.push(y);
				vertices.push(z);
			}

			var triangleCount = convexHull.triangleCount;
			var triangles = convexHull.triangles;
			var pos = 0;
			var indexes = [];
			for ( _ in 0...triangleCount ) {
				indexes.push(triangles.getI32(4*pos++));
				indexes.push(triangles.getI32(4*pos++));
				indexes.push(triangles.getI32(4*pos++));
			}
			out.push({ vertices : vertices, indexes : indexes });
		}
		vhacdInstance.release();

		return out;
		#end

		return out;
	}

	static function tmpFile(name : String): String {
		#if (sys || nodejs)
		var tmp = Sys.getEnv("TMPDIR");
		if( tmp == null ) tmp = Sys.getEnv("TMP");
		if( tmp == null ) tmp = Sys.getEnv("TEMP");
		if( tmp == null ) tmp = ".";
		return tmp+"/"+name+Date.now().getTime()+"_"+Std.random(0x1000000)+".bin";
		#else
		return null;
		#end
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

class EmptyCollider extends Collider {
	public function new() {
		type = Empty;
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
