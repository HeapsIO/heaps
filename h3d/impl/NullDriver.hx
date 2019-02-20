package h3d.impl;
import h3d.impl.Driver;

class NullDriver extends Driver {

	var cur : hxsl.RuntimeShader;

	public function new() {
	}

	override function hasFeature( f : Feature ) {
		return true;
	}

	override function isSupportedFormat( fmt : h3d.mat.Data.TextureFormat ) {
		return true;
	}

	override function logImpl(str:String) {
		#if sys
		Sys.println(str);
		#else
		trace(str);
		#end
	}

	override function isDisposed() {
		return false;
	}

	override function getDriverName( details : Bool ) {
		return "NullDriver";
	}

	override function init( onCreate : Bool -> Void, forceSoftware = false ) {
		onCreate(false);
	}

	override function selectShader( shader : hxsl.RuntimeShader ) {
		if( cur == shader ) return false;
		cur = shader;
		return true;
	}

	override function getShaderInputNames() : InputNames {
		var names = [];
		for( v in cur.vertex.data.vars )
			if( v.kind == Input )
				names.push(v.name);
		return InputNames.get(names);
	}

	override function allocTexture( t : h3d.mat.Texture ) : Texture {
		return cast {};
	}

	override function allocIndexes( count : Int, is32 : Bool ) : IndexBuffer {
		return cast {};
	}

	override function allocVertexes( m : ManagedBuffer ) : VertexBuffer {
		return cast {};
	}

}