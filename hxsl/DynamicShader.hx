package hxsl;

class DynamicShader extends Shader {

	public function new( s : SharedShader ) {
		this.shader = s;
		super();
	}

	override function updateConstants( globals : Globals ) {
		constBits = 0;
		var c = shader.consts;
		while( c != null ) {
			if( c.globalId != 0 ) {
				c = c.next;
				continue;
			}
			var v : Dynamic;
			if( c.v.parent == null )
				v = Reflect.field(this, c.v.name+"__");
			else
				throw "TODO";
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