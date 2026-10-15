package hxd.fmt.gltf;

/**
	A parsed glTF 2.0 file : the JSON document and the binary chunk of a GLB file.
	See https://registry.khronos.org/glTF/specs/2.0/glTF-2.0.html
**/
class Data {
	public var doc : GltfDocument;
	public var bin : Null<haxe.io.Bytes>; // The BIN chunk of a GLB file, used by the buffer without uri

	public function new( doc, ?bin ) {
		this.doc = doc;
		this.bin = bin;
	}
}

typedef GltfDocument = {
	var asset : GltfAsset;
	var ?scene : Int;
	var ?scenes : Array<GltfScene>;
	var ?nodes : Array<GltfNode>;
	var ?meshes : Array<GltfMesh>;
	var ?accessors : Array<GltfAccessor>;
	var ?bufferViews : Array<GltfBufferView>;
	var ?buffers : Array<GltfBuffer>;
	var ?materials : Array<GltfMaterial>;
	var ?textures : Array<GltfTexture>;
	var ?images : Array<GltfImage>;
	var ?samplers : Array<GltfSampler>;
	var ?animations : Array<GltfAnimation>;
	var ?skins : Array<GltfSkin>;
	var ?cameras : Array<GltfCamera>;
	var ?extensionsUsed : Array<String>;
	var ?extensionsRequired : Array<String>;
}

typedef GltfAsset = {
	var version : String;
	var ?generator : String;
	var ?copyright : String;
	var ?minVersion : String;
}

typedef GltfScene = {
	var ?name : String;
	var ?nodes : Array<Int>;
}

typedef GltfNode = {
	var ?name : String;
	var ?children : Array<Int>;
	var ?mesh : Int;
	var ?skin : Int;
	var ?camera : Int;
	var ?matrix : Array<Float>;
	var ?translation : Array<Float>;
	var ?rotation : Array<Float>;
	var ?scale : Array<Float>;
	var ?weights : Array<Float>;
}

typedef GltfMesh = {
	var ?name : String;
	var primitives : Array<GltfPrimitive>;
	var ?weights : Array<Float>;
}

typedef GltfPrimitive = {
	var attributes : haxe.DynamicAccess<Int>;
	var ?indices : Int;
	var ?material : Int;
	var ?mode : GltfPrimitiveMode;
	var ?targets : Array<haxe.DynamicAccess<Int>>;
	var ?extensions : Dynamic;
}

enum abstract GltfPrimitiveMode(Int) from Int to Int {
	var Points = 0;
	var Lines = 1;
	var LineLoop = 2;
	var LineStrip = 3;
	var Triangles = 4;
	var TriangleStrip = 5;
	var TriangleFan = 6;
}

enum abstract GltfComponentType(Int) from Int to Int {
	var Byte = 5120;
	var UnsignedByte = 5121;
	var Short = 5122;
	var UnsignedShort = 5123;
	var UnsignedInt = 5125;
	var Float32 = 5126;

	public inline function getSize() {
		return switch( this ) {
		case Byte, UnsignedByte: 1;
		case Short, UnsignedShort: 2;
		default: 4;
		}
	}
}

typedef GltfAccessor = {
	var ?bufferView : Int;
	var ?byteOffset : Int;
	var componentType : GltfComponentType;
	var ?normalized : Bool;
	var count : Int;
	var type : String;
	var ?min : Array<Float>;
	var ?max : Array<Float>;
	var ?sparse : GltfSparse;
	var ?name : String;
}

typedef GltfSparse = {
	var count : Int;
	var indices : { bufferView : Int, ?byteOffset : Int, componentType : GltfComponentType };
	var values : { bufferView : Int, ?byteOffset : Int };
}

typedef GltfBufferView = {
	var buffer : Int;
	var ?byteOffset : Int;
	var byteLength : Int;
	var ?byteStride : Int;
	var ?target : Int;
	var ?name : String;
}

typedef GltfBuffer = {
	var ?uri : String;
	var byteLength : Int;
	var ?name : String;
}

typedef GltfTextureInfo = {
	var index : Int;
	var ?texCoord : Int;
	var ?scale : Float;
	var ?strength : Float;
}

typedef GltfMaterial = {
	var ?name : String;
	var ?pbrMetallicRoughness : {
		var ?baseColorFactor : Array<Float>;
		var ?baseColorTexture : GltfTextureInfo;
		var ?metallicFactor : Float;
		var ?roughnessFactor : Float;
		var ?metallicRoughnessTexture : GltfTextureInfo;
	};
	var ?normalTexture : GltfTextureInfo;
	var ?occlusionTexture : GltfTextureInfo;
	var ?emissiveTexture : GltfTextureInfo;
	var ?emissiveFactor : Array<Float>;
	var ?alphaMode : String;
	var ?alphaCutoff : Float;
	var ?doubleSided : Bool;
}

typedef GltfTexture = {
	var ?sampler : Int;
	var ?source : Int;
	var ?name : String;
}

typedef GltfImage = {
	var ?uri : String;
	var ?mimeType : String;
	var ?bufferView : Int;
	var ?name : String;
}

typedef GltfSampler = {
	var ?magFilter : Int;
	var ?minFilter : Int;
	var ?wrapS : Int;
	var ?wrapT : Int;
}

typedef GltfSkin = {
	var ?inverseBindMatrices : Int;
	var ?skeleton : Int;
	var joints : Array<Int>;
	var ?name : String;
}

typedef GltfAnimation = {
	var channels : Array<GltfChannel>;
	var samplers : Array<GltfAnimationSampler>;
	var ?name : String;
}

typedef GltfChannel = {
	var sampler : Int;
	var target : {
		var ?node : Int;
		var path : String;
	};
}

typedef GltfAnimationSampler = {
	var input : Int;
	var ?interpolation : String;
	var output : Int;
}

typedef GltfCamera = {
	var type : String;
	var ?perspective : {
		var ?aspectRatio : Float;
		var yfov : Float;
		var ?zfar : Float;
		var znear : Float;
	};
	var ?orthographic : {
		var xmag : Float;
		var ymag : Float;
		var zfar : Float;
		var znear : Float;
	};
	var ?name : String;
}
