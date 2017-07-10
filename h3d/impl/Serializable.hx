package h3d.impl;

#if !hxbit
private interface EmptyInterface {}
#end

typedef Serializable = #if hxbit hxbit.Serializable #else EmptyInterface #end;

#if hxbit
class SceneSerializer extends hxbit.Serializer {

	public var materialRef = new Map<String,h3d.mat.Material>();

	var version = 0;

	var resPath : String = MacroHelper.getResourcesPath();
	var shaderVarIndex : Int;
	var shaderUID = 0;
	var shaderIndexes = new Map<hxsl.Shader,Int>();
	var cachedShaders = new Array<hxsl.Shader>();

	function addTexture( t : h3d.mat.Texture ) {
		if( t == null ) {
			addInt(0);
			return true;
		}
		if( t.name != null ) {
			addInt(1);
			addString(t.name);
			return true;
		}
		return false;
	}

	function getTexture() {
		switch( getInt() ) {
		case 0:
			return null;
		case 1:
			return resolveTexture(getString());
		default:
			throw "assert";
		}
	}

	function resolveTexture( path : String ) {
		return hxd.res.Loader.currentInstance.load(path).toTexture();
	}

	public function loadHMD( path : String ) {
		return hxd.res.Loader.currentInstance.load(path).toHmd();
	}

	public function addShader( s : hxsl.Shader ) {
		if( s == null ) {
			addInt(0);
			return;
		}
		var id = shaderIndexes.get(s);
		if( id != null ) {
			addInt(id);
			return;
		}
		id = ++shaderUID;
		shaderIndexes.set(s, id);
		addInt(id);
		addString(Type.getClassName(Type.getClass(s)));
		shaderVarIndex = 0;
		for( v in @:privateAccess s.shader.data.vars )
			addShaderVar(v, s);
	}

	public function getShader() {
		var id = getInt();
		if( id == 0 )
			return null;
		var s = cachedShaders[id];
		if( s != null )
			return s;
		var sname = getString();
		var cl : Class<hxsl.Shader> = cast Type.resolveClass(sname);
		if( cl == null ) throw "Missing shader " + sname;
		s = Type.createEmptyInstance(cl);
		@:privateAccess s.initialize();
		for( v in @:privateAccess s.shader.data.vars ) {
			if( !canSerializeVar(v) ) continue;
			var val : Dynamic = getShaderVar(v, s);
			Reflect.setField(s, v.name+"__", val);
		}
		cachedShaders[id] = s;
		return s;
	}

	function canSerializeVar( v : hxsl.Ast.TVar ) {
		return v.kind == Param && (v.qualifiers == null || v.qualifiers.indexOf(Ignore) < 0);
	}

	function addShaderVar( v : hxsl.Ast.TVar, s : hxsl.Shader ) {
		if( !canSerializeVar(v) )
			return;
		switch( v.type ) {
		case TStruct(vl):
			for( v in vl )
				addShaderVar(v, s);
			return;
		default:
		}
		var val : Dynamic = s.getParamValue(shaderVarIndex++);
		switch( v.type ) {
		case TBool:
			addBool(val);
		case TInt:
			addInt(val);
		case TFloat:
			addFloat(val);
		case TVec(n, VFloat):
			var v : h3d.Vector = val;
			addFloat(v.x);
			addFloat(v.y);
			if( n >= 3 ) addFloat(v.z);
			if( n >= 4 ) addFloat(v.w);
		case TSampler2D:
			if( !addTexture(val) )
				throw "Cannot serialize unnamed texture " + s+"."+v.name+" = "+val;
		default:
			throw "Cannot serialize macro var " + v.name+":"+hxsl.Ast.Tools.toString(v.type);
		}
	}

	function getShaderVar( v : hxsl.Ast.TVar, s : hxsl.Shader ) : Dynamic {
		switch( v.type ) {
		case TStruct(vl):
			var obj = {};
			for( v in vl ) {
				if( !canSerializeVar(v) ) continue;
				Reflect.setField(obj, v.name, getShaderVar(v, s));
			}
			return obj;
		default:
		}
		switch( v.type ) {
		case TBool:
			return getBool();
		case TFloat:
			return getFloat();
		case TInt:
			return getInt();
		case TVec(n, VFloat):
			var v = new h3d.Vector(getFloat(), getFloat());
			if( n >= 3 ) v.z = getFloat();
			if( n >= 4 ) v.w = getFloat();
			return v;
		case TSampler2D:
			return getTexture();
		default:
			throw "Cannot unserialize macro var " + v.name+":"+hxsl.Ast.Tools.toString(v.type);
		}
	}

	function initSCNPaths( resPath : String, projectPath : String ) {
		this.resPath = resPath;
	}

	public function loadSCN( bytes ) {
		setInput(bytes, 0);
		if( getString() != "SCN" )
			throw "Invalid SCN file";
		version = getInt();
		beginLoad(bytes, inPos);
		initSCNPaths(getString(), getString());
		var objs = [];
		for( i in 0...getInt() ) {
			var obj : h3d.scene.Object = cast getAnyRef();
			objs.push(obj);
		}
		endLoad();
		return { content : objs };
	}

	public function saveSCN( obj : h3d.scene.Object, includeRoot : Bool ) {
		begin();
		addString("SCN");
		addInt(version); // version

		var pos = out.length;
		usedClasses = [];
		addString(resPath);
		#if sys
		addString(Sys.getCwd());
		#else
		addString(null);
		#end

		var objs = includeRoot ? [obj] : [for( o in obj ) o];
		objs = [for( o in obj ) if( @:privateAccess !o.flags.has(FNoSerialize) ) o];
		addInt(objs.length);
		for( o in objs )
			addAnyRef(o);

		return endSave(pos);
	}

}
#end
