package hxsl;

class DynamicShader extends Shader {

	var values = new Array<Dynamic>();
	var accesses = new Array<{ index : Int, fields : Array<String> }>();
	var varIndexes = new Map<Int,Int>();
	var varNames = new Map<String,Int>();
	var varIndex = 0;

	public function new( s : SharedShader ) {
		this.shader = s;
		super();
		for( v in s.data.vars )
			addVarIndex(v);
	}

	function addVarIndex(v:hxsl.Ast.TVar, ?access : { index : Int, fields : Array<String> }, ?defObj : Dynamic ) {
		if( v.kind != Param )
			return;
		var vid = values.length;
		if( access != null )
			access = { index : access.index, fields : access.fields.copy() };
		switch(v.type){
		case TStruct(vl):
			var vobj = {};
			if( access == null ) {
				values.push(vobj);
				access = { index : vid, fields : [] };
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
			varNames.set(v.name, vid);
			values.push(value);
		} else
			Reflect.setField(defObj, v.name, value);

		var vidx = accesses.length;
		varIndexes.set(v.id, vidx);
		accesses.push(access == null ? { index : vid, fields : null } : access);
	}

	override function getParamValue(index:Int) : Dynamic {
		var a = accesses[index];
		var v = values[a.index];
		if( a.fields != null )
			for( f in a.fields )
				v = Reflect.field(v, f);
		return v;
	}

	override function getParamFloatValue(index:Int):Float {
		return getParamValue(index);
	}

	public function setParamValue( p : hxsl.Ast.TVar, value : Dynamic ) {
		var vidx = varIndexes.get(p.id);
		var a = accesses[vidx];
		if( a.fields == null )
			values[a.index] = value;
		else {
			var obj = values[a.index];
			for( i in 0...a.fields.length - 1 )
				obj = Reflect.field(obj, a.fields[i]);
			Reflect.setField(obj, a.fields[a.fields.length - 1], value);
		}
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


	#if hscript
	@:keep public function hscriptGet( field : String ) {
		var vid = varNames.get(field);
		if( vid == null )
			return Reflect.getProperty(this, field);
		return values[vid];
	}

	@:keep public function hscriptSet( field : String, value : Dynamic ) : Dynamic {
		var vid = varNames.get(field);
		if( vid == null ) {
			Reflect.setProperty(this, field, value);
			return value;
		}
		return values[vid] = value;
	}
	#end

	override function toString() {
		return "DynamicShader<" + shader.data.name+">";
	}


}