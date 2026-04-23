package hxd.fmt.gltf;

enum GltfProp {
	PInt( v : Int );
	PFloat( v : Float );
	PString( v : String );
	PIdent( i : String );
	PInts( v : Array<Int> );
	PFloats( v : Array<Float> );
	PBinary( v : haxe.io.Bytes );
}

typedef GltfNode = {
	var name : String;
	var props : Array<GltfProp>;
	var childs : Array<GltfProp>;
}

class GltfTools {

}