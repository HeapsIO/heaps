package hxsl;
import hxsl.Ast;
using hxsl.Ast;

enum BlockType {
	Default;
	Globals;
	Params;
}

class NXGlslOut extends hxsl.GlslOut {

	var block : BlockType;
	var hasGlobals = false;
	var hasParams = false;
	var ubo : Array<TVar> = [];

	public function new(){
		super();
		version = 140;
	}

	override function initVar( v : TVar ){
		switch( block ){
		case Default:
			if ( v.type.match(TBuffer(_)) ) {
				ubo.push(v);
				super.initVar(v);
				return;
			}
			switch( v.kind ){
			case Global:
				hasGlobals = true;
			case Param:
				switch( v.type ) {
				case TArray(t, _) if( t.isSampler() ):
					super.initVar(v);
				default:
					hasParams = true;
				}
			case Output: 
				if( !isVertex ) add('layout(location=${outIndex++}) ');
				super.initVar(v);
			default:
				super.initVar(v);
			}
		case Globals:
			if( v.kind == Global && !v.type.match(TBuffer(_)) ){
				add("\t");
				super.initVar(v);
			} else if ( v.kind == Input ){
				throw "unsupported";
			}
		case Params:
			if( v.kind == Param ){
				switch( v.type ) {
				case TBuffer(_):
				case TArray(t, _) if( t.isSampler() ):
				default:
					add("\t");
					super.initVar(v);
				}
			} else if ( v.kind == Input ){
				throw "unsupported";
			}
		}
		if( v.qualifiers != null )
			for( q in v.qualifiers )
				switch( q ) {
				case PerInstance(n):
				default:
				}
	}

	override function initVars( s : ShaderData ){
		block = Default;
		hasGlobals = false;
		hasParams = false;
		ubo = [];

		super.initVars(s);

		var prefix = isVertex ? "Vertex" : "Fragment";

		if( hasGlobals ){
			block = Globals;
			var inputs = [];
			add("uniform "+prefix+"Globals {\n");
			for( v in s.vars ) {
				if ( v.kind.match(Input) )
					inputs.push(v);
				else
					initVar(v);
			}
			add("};\n");
		}

		if( hasParams ){
			block = Params;
			var inputs = [];
			add("uniform "+prefix+"Params {\n");
			for( v in s.vars ) {
				if ( v.kind.match(Input) )
					inputs.push(v);
				else
					initVar(v);
			}
			add("};\n");
		}

		for ( v in ubo )
			initVar(v);

		if( !isVertex && outIndex > 0 )
			decl("#extension GL_ARB_explicit_attrib_location : enable");
	}

}