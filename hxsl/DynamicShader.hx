package hxsl;

class DynamicShader extends Shader {

	var params = new Array<Dynamic>();
	var varIndexes = new Map<Int,Int>();
	var varIndex = 0;

	public function new( s : SharedShader ) {
		this.shader = s;
		super();
		for( v in s.data.vars )
			addVarIndex(v);
	}

	function addVarIndex(v:hxsl.Ast.TVar) {
		if( v.kind != Param )
			return;
		switch(v.type){
		case TStruct(vl):
			for( v in vl )
				addVarIndex(v);
			return;
		default:
		}
		switch( v.type ) {
		case TSampler2D:
			params[varIndex] = h3d.mat.Texture.fromColor(0xFF00FF);
		case TSamplerCube:
			params[varIndex] = h3d.mat.Texture.defaultCubeTexture();
		default:
		}
		varIndexes.set(v.id, varIndex++);
	}

	override function getParamValue(index:Int) : Dynamic {
		return params[index];
	}

	override public function getParamFloatValue(index:Int):Float {
		return params[index];
	}

	public function setParamValue( p : hxsl.Ast.TVar, value : Dynamic ) {
		params[varIndexes.get(p.id)] = value;
	}

	override function updateConstants( globals : Globals ) {
		constBits = 0;
		var c = shader.consts;
		while( c != null ) {
			if( c.globalId != 0 ) {
				c = c.next;
				continue;
			}
			var v : Dynamic = params[varIndexes.get(c.v.id)];
			switch( c.v.type ) {
			case TInt:
				var v : Int = v;
				if( v >>> c.bits != 0 ) throw "Constant outside range";
				constBits |= v << c.pos;
			case TBool:
				if( v ) constBits |= 1 << c.pos;
			case TChannel(n):
				throw "TODO:"+c.v.type;
			default:
				throw "assert";
			}
			c = c.next;
		}
		updateConstantsFinal(globals);
	}

}