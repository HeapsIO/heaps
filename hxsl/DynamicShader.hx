package hxsl;

@:enum private abstract AccessKind(Int) {
	var Dynamic = 0;
	var Float = 1;
	var Structure = 2;
}

private class Access {
	public var kind : AccessKind;
	public var index : Int;
	public var fields : Array<String>;
	public function new(kind,index,fields) {
		this.kind = kind;
		this.index = index;
		this.fields = fields;
	}
}

class DynamicShader extends Shader {

	var values = new Array<Dynamic>();
	var floats = new Array<Float>();
	var accesses = new Array<Access>();
	var varIndexes = new Map<Int,Int>();
	var varNames = new Map<String,Int>();

	public function new( s : SharedShader ) {
		this.shader = s;
		super();
		for( v in s.data.vars )
			addVarIndex(v);
	}

	function addVarIndex(v:hxsl.Ast.TVar, ?access : Access, ?defObj : Dynamic ) {
		if( v.kind != Param )
			return;
		var isFloat = v.type == TFloat && access == null;
		var vid = isFloat ? floats.length : values.length;
		if( access != null )
			access = new Access(Structure, access.index, access.fields.copy());
		switch(v.type){
		case TStruct(vl):
			var vobj = {};
			if( access == null ) {
				values.push(vobj);
				access = new Access(Structure,vid,[]);
				varNames.set(v.name, vid);
			} else {
				Reflect.setField(defObj, v.name, vobj);
			}
			for( v in vl ) {
				access.fields.push(v.name);
				addVarIndex(v, access, vobj);
				access.fields.pop();
			}
			return;
		default:
		}
		var value : Dynamic = null;
		switch( v.type ) {
		case TVec(_):
			value = new h3d.Vector();
		case TMat3, TMat4, TMat3x4:
			var m = new h3d.Matrix();
			m.identity();
			value = m;
		case TInt, TFloat:
			value = 0;
		case TBool:
			value = false;
		default:
		}
		if( access == null ) {
			if( isFloat ) {
				varNames.set(v.name, -vid-1);
				floats.push(0);
			} else {
				varNames.set(v.name, vid);
				values.push(value);
			}
		} else
			Reflect.setField(defObj, v.name, value);

		var vidx = accesses.length;
		varIndexes.set(v.id, vidx);
		accesses.push(access == null ? new Access(isFloat?Float:Dynamic,vid,null) : access);
	}

	override function getParamValue(index:Int) : Dynamic {
		var a = accesses[index];
		switch( a.kind ) {
		case Dynamic:
			return values[a.index];
		case Float:
			return floats[a.index];
		case Structure:
			var v : Dynamic = values[a.index];
			for( f in a.fields )
				v = Reflect.field(v, f);
			return v;
		}
	}

	override function getParamFloatValue(index:Int):Float {
		var a = accesses[index];
		if( a.kind != Float )
			return getParamValue(index);
		return floats[a.index];
	}

	public function setParamValue( p : hxsl.Ast.TVar, value : Dynamic ) {
		var vidx = varIndexes.get(p.id);
		var a = accesses[vidx];
		switch( a.kind ) {
		case Dynamic:
			values[a.index] = value;
		case Float:
			floats[a.index] = value;
		case Structure:
			var obj = values[a.index];
			for( i in 0...a.fields.length - 1 )
				obj = Reflect.field(obj, a.fields[i]);
			Reflect.setField(obj, a.fields[a.fields.length - 1], value);
		}
	}

	public function setParamFloatValue( p : hxsl.Ast.TVar, value : Float ) {
		var vidx = varIndexes.get(p.id);
		var a = accesses[vidx];
		if( a.kind != Float ) {
			setParamValue(p, value);
			return;
		}
		floats[a.index] = value;
	}

	override function updateConstants( globals : Globals ) {
		constBits = 0;
		var c = shader.consts;
		while( c != null ) {
			if( c.globalId != 0 ) {
				c = c.next;
				continue;
			}
			var v : Dynamic = getParamValue(varIndexes.get(c.v.id));
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

	@:keep public function hscriptGet( field : String ) : Dynamic {
		var vid = varNames.get(field);
		if( vid == null )
			return Reflect.getProperty(this, field);
		if( vid < 0 )
			return floats[-vid-1];
		return values[vid];
	}

	@:keep public function hscriptSet( field : String, value : Dynamic ) : Dynamic {
		var vid = varNames.get(field);
		if( vid == null ) {
			Reflect.setProperty(this, field, value);
			return value;
		}
		if( vid < 0 )
			floats[-vid-1] = value;
		else
			values[vid] = value;
		return value;
	}

	override function toString() {
		return "DynamicShader<" + shader.data.name+">";
	}


}