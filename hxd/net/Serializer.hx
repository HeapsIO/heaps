package hxd.net;

class ConvertField {
	public var index : Int;
	public var same : Bool;
	public var defaultValue : Dynamic;
	public var from : Null<Schema.FieldType>;
	public var to : Null<Schema.FieldType>;
	public function new(from, to) {
		this.from = from;
		this.to = to;
	}
}

class Convert {

	public var read : Array<ConvertField>;
	public var write : Array<ConvertField>;

	public function new( ourSchema : Schema, schema : Schema ) {
		var ourMap = new Map();
		for( i in 0...ourSchema.fieldsNames.length )
			ourMap.set(ourSchema.fieldsNames[i], ourSchema.fieldsTypes[i]);
		read = [];

		var map = new Map();
		for( i in 0...schema.fieldsNames.length ) {
			var oldT = schema.fieldsTypes[i];
			var newT = ourMap.get(schema.fieldsNames[i]);
			var c = new ConvertField(oldT, newT);
			if( newT != null && sameType(oldT, newT) )
				c.same = true;
			c.index = read.length;
			read.push(c);
			map.set(schema.fieldsNames[i], c);
		}

		write = [];
		for( i in 0...ourSchema.fieldsNames.length ) {
			var newT = ourSchema.fieldsTypes[i];
			var c = map.get(ourSchema.fieldsNames[i]);
			if( c == null ) {
				c = new ConvertField(null, newT);
				// resolve default value using a specific method ?
				c.defaultValue = getDefault(newT);
			}
			write.push(c);
		}
	}

	static function sameType( a : Schema.FieldType, b : Schema.FieldType ) {
		switch( [a, b] ) {
		case [PMap(ak, av), PMap(bk, bv)]:
			return sameType(ak, bk) && sameType(av, bv);
		case [PArray(a), PArray(b)],[PVector(a),PVector(b)],[PNull(a),PNull(b)]:
			return sameType(a, b);
		case [PObj(fa), PObj(fb)]:
			if( fa.length != fb.length ) return false;
			for( i in 0...fa.length ) {
				var a = fa[i];
				var b = fb[i];
				if( a.name != b.name || a.opt != b.opt || !sameType(a.type, b.type) )
					return false;
			}
			return true;
		case [PAlias(a), PAlias(b)]:
			return sameType(a, b);
		case [PAlias(a), _]:
			return sameType(a, b);
		case [_, PAlias(b)]:
			return sameType(a, b);
		default:
			return Type.enumEq(a, b);
		}
	}

	function getDefault(t:Schema.FieldType) : Dynamic {
		return switch( t ) {
		case PInt: 0;
		case PFloat: 0.;
		case PArray(_): [];
		case PMap(k, _):
			switch( k ) {
			case PInt: new Map<Int,Dynamic>();
			case PString: new Map<String,Dynamic>();
			default: new Map<{},Dynamic>();
			}
		case PVector(_): new haxe.ds.Vector<Dynamic>(0);
		case PBool: false;
		case PAlias(t): getDefault(t);
		case PEnum(_), PNull(_), PObj(_), PSerializable(_), PString, PUnknown, PBytes: null;
		};
	}

}

class Serializer {

	static var UID = 0;
	static var SEQ = 0;
	static inline var SEQ_BITS = 8;
	static inline var SEQ_MASK = 0xFFFFFFFF >>> SEQ_BITS;

	public static function resetCounters() {
		UID = 0;
		SEQ = 0;
	}

	static inline function allocUID() {
		return (SEQ << (32 - SEQ_BITS)) | (++UID);
	}

	static var CLASSES : Array<Class<Dynamic>> = [];
	static var CL_BYID = null;
	static var CLIDS = null;
	static function registerClass( c : Class<Dynamic> ) {
		if( CLIDS != null ) throw "Too late to register class";
		var idx = CLASSES.length;
		CLASSES.push(c);
		return idx;
	}

	static function initClassIDS() {
		var cl = CLASSES;
		var subClasses = [for( c in cl ) []];
		var isSub = [];
		for( i in 0...cl.length ) {
			var c = cl[i];
			while( true ) {
				c = Type.getSuperClass(c);
				if( c == null ) break;
				var idx = cl.indexOf(c);
				if( idx < 0 ) break; // super class is not serializable
				subClasses[idx].push(i);
				isSub[i] = true;
			}
		}

		inline function hash(name:String) {
			var v = 1;
			for( i in 0...name.length )
				v = v * 223 + StringTools.fastCodeAt(name,i);
			v = 1 + ((v & 0x3FFFFFFF) % 65423);
			return v;
		}
		CLIDS = [for( i in 0...CLASSES.length ) if( subClasses[i].length == 0 && !isSub[i] ) 0 else hash(Type.getClassName(cl[i]))];
		CL_BYID = [];
		for( i in 0...CLIDS.length ) {
			var cid = CLIDS[i];
			if( cid == 0 ) continue;
			if( CL_BYID[cid] != null ) throw "Conflicting CLID between " + Type.getClassName(CL_BYID[cid]) + " and " + Type.getClassName(cl[i]);
			CL_BYID[cid] = cl[i];
		}
	}

	public var refs : Map<Int,Serializable>;
	var newObjects : Array<Serializable>;
	var out : haxe.io.BytesBuffer;
	var input : haxe.io.Bytes;
	var inPos : Int;
	var usedClasses : Array<Bool> = [];
	var convert : Array<Convert>;

	public function new() {
		if( CLIDS == null ) initClassIDS();
	}

	public function begin() {
		out = new haxe.io.BytesBuffer();
		refs = new Map();
	}

	public function end() {
		var bytes = out.getBytes();
		out = null;
		refs = null;
		return bytes;
	}

	public function setInput(data, pos) {
		input = data;
		inPos = pos;
	}

	public function serialize( s : Serializable ) {
		begin();
		addKnownRef(s);
		return out.getBytes();
	}

	public function unserialize<T:Serializable>( data : haxe.io.Bytes, c : Class<T> ) : T {
		refs = new Map();
		setInput(data, 0);
		return getRef(c, Reflect.field(c,"__clid"));
	}

	public inline function getByte() {
		return input.get(inPos++);
	}

	public inline function addByte(v:Int) {
		out.addByte(v);
	}

	public inline function addInt(v:Int) {
		if( v >= 0 && v < 0x80 )
			out.addByte(v);
		else {
			out.addByte(0x80);
			out.addInt32(v);
		}
	}

	public inline function addInt32(v:Int) {
		out.addInt32(v);
	}

	public inline function addFloat(v:Float) {
		out.addFloat(v);
	}

	public inline function addDouble(v:Float) {
		out.addDouble(v);
	}

	public inline function addBool(v:Bool) {
		addByte(v?1:0);
	}

	public inline function addArray<T>(a:Array<T>,f:T->Void) {
		if( a == null ) {
			addByte(0);
			return;
		}
		addInt(a.length + 1);
		for( v in a )
			f(v);
	}

	public inline function addVector<T>(a:haxe.ds.Vector<T>,f:T->Void) {
		if( a == null ) {
			addByte(0);
			return;
		}
		addInt(a.length + 1);
		for( v in a )
			f(v);
	}

	public inline function getArray<T>(f:Void->T) : Array<T> {
		var len = getInt();
		if( len == 0 )
			return null;
		len--;
		var a = [];
		for( i in 0...len )
			a[i] = f();
		return a;
	}

	public inline function getVector<T>(f:Void->T) : haxe.ds.Vector<T> {
		var len = getInt();
		if( len == 0 )
			return null;
		len--;
		var a = new haxe.ds.Vector<T>(len);
		for( i in 0...len )
			a[i] = f();
		return a;
	}

	public inline function addMap<K,T>(a:Map<K,T>,fk:K->Void,ft:T->Void) {
		if( a == null ) {
			addByte(0);
			return;
		}
		var keys = Lambda.array({ iterator : a.keys });
		addByte(keys.length + 1);
		for( k in keys ) {
			fk(k);
			ft(a.get(k));
		}
	}

	@:extern public inline function getMap<K,T>(fk:Void->K, ft:Void->T) : Map<K,T> {
		var len = getInt();
		if( len == 0 )
			return null;
		var m = new Map<K,T>();
		while( --len > 0 ) {
			var k = fk();
			var v = ft();
			m.set(k, v);
		}
		return m;
	}

	public inline function getBool() {
		return getByte() != 0;
	}

	public inline function getInt() {
		var v = getByte();
		if( v == 0x80 ) {
			v = input.getInt32(inPos);
			inPos += 4;
		}
		return v;
	}

	public inline function getInt32() {
		var v = input.getInt32(inPos);
		inPos += 4;
		return v;
	}

	public inline function getDouble() {
		var v = input.getDouble(inPos);
		inPos += 8;
		return v;
	}

	public inline function getFloat() {
		var v = input.getFloat(inPos);
		inPos += 4;
		return v;
	}

	public inline function addString( s : String ) {
		if( s == null )
			addByte(0);
		else {
			addInt(s.length + 1);
			out.addString(s);
		}
	}

	public inline function addBytes( b : haxe.io.Bytes ) {
		if( b == null )
			addByte(0);
		else {
			addInt(b.length + 1);
			out.add(b);
		}
	}

	public inline function getString() {
		var len = getInt();
		if( len == 0 )
			return null;
		len--;
		var s = input.getString(inPos, len);
		inPos += len;
		return s;
	}

	public inline function getBytes() {
		var len = getInt();
		if( len == 0 )
			return null;
		len--;
		var s = input.sub(inPos, len);
		inPos += len;
		return s;
	}

	public inline function addCLID( clid : Int ) {
		addByte(clid >> 8);
		addByte(clid & 0xFF);
	}

	public inline function getCLID() {
		return (getByte() << 8) | getByte();
	}

	public function addAnyRef( s : Serializable ) {
		if( s == null ) {
			addByte(0);
			return;
		}
		addInt(s.__uid);
		if( refs[s.__uid] != null )
			return;
		refs[s.__uid] = s;
		var index = s.getCLID();
		usedClasses[index] = true;
		addCLID(index);
		s.serialize(this);
	}

	public function addKnownRef( s : Serializable ) {
		if( s == null ) {
			addByte(0);
			return;
		}
		addInt(s.__uid);
		if( refs[s.__uid] != null )
			return;
		refs[s.__uid] = s;
		var index = s.getCLID();
		usedClasses[index] = true;
		var clid = CLIDS[index];
		if( clid != 0 )
			addCLID(clid);
		s.serialize(this);
	}

	public function getAnyRef() : Serializable {
		var id = getInt();
		if( id == 0 ) return null;
		if( refs[id] != null )
			return cast refs[id];
		var rid = id & SEQ_MASK;
		if( UID < rid ) UID = rid;
		var clidx = getCLID();
		var i : Serializable = Type.createEmptyInstance(CLASSES[clidx]);
		if( newObjects != null ) newObjects.push(i);
		i.__uid = id;
		refs[id] = i;
		if( convert != null && convert[clidx] != null )
			convertRef(i, convert[clidx]);
		else
			i.unserialize(this);
		return i;
	}

	public function getRef<T:Serializable>( c : Class<T>, clidx : Int ) : T {
		var id = getInt();
		if( id == 0 ) return null;
		if( refs[id] != null )
			return cast refs[id];
		var rid = id & SEQ_MASK;
		if( UID < rid ) UID = rid;
		var clid = CLIDS[clidx];
		var i : T = Type.createEmptyInstance(clid == 0 ? c : cast CL_BYID[getCLID()]);
		if( newObjects != null ) newObjects.push(i);
		i.__uid = id;
		refs[id] = i;
		if( convert != null && convert[clidx] != null )
			convertRef(i, convert[clidx]);
		else
			i.unserialize(this);
		return i;
	}

	public inline function getKnownRef<T:Serializable>( c : Class<T> ) : T {
		return getRef(c, untyped c.__clid);
	}


	public function beginSave() {
		begin();
		usedClasses = [];
	}

	public function endSave() {
		var content = end();
		begin();
		var classes = [];
		var schemas = [];
		var sidx = CLASSES.indexOf(Schema);
		for( i in 0...usedClasses.length ) {
			if( !usedClasses[i] || i == sidx ) continue;
			var c = CLASSES[i];
			var schema = (Type.createEmptyInstance(c) : Serializable).getSerializeSchema();
			schemas.push(schema);
			classes.push(i);
			addKnownRef(schema);
		}
		var schemaData = end();
		begin();
		addString("HXS");
		addByte(1);
		for( i in 0...classes.length ) {
			var index = classes[i];
			addString(Type.getClassName(CLASSES[index]));
			addCLID(index);
			addInt32(schemas[i].checkSum);
		}
		addString(null);
		addInt(schemaData.length);
		out.add(schemaData);
		out.add(content);
		return end();
	}

	public function beginLoadSave() {
		var classByName = new Map();
		var schemas = [];
		var mapClasses = [];
		var indexes = [];
		var needConvert = false;
		var needReindex = false;
		for( i in 0...CLASSES.length )
			classByName.set(Type.getClassName(CLASSES[i]), i);
		if( getString() != "HXS" )
			throw "Invalid HXS data";
		var version = getByte();
		if( version != 1 )
			throw "Unsupported HXS version " + version;
		while( true ) {
			var clname = getString();
			if( clname == null ) break;
			var index = getCLID();
			var crc = getInt32();

			var ourClassIndex = classByName.get(clname);
			if( ourClassIndex == null ) throw "Missing class " + clname+" found in HXS data";
			var ourSchema = (Type.createEmptyInstance(CLASSES[ourClassIndex]) : Serializable).getSerializeSchema();
			if( ourSchema.checkSum != crc ) {
				needConvert = true;
				schemas[index] = ourSchema;
			}
			if( index != ourClassIndex )
				needReindex = true;
			mapClasses[index] = ourClassIndex;
			indexes.push(index);
		}
		var schemaDataSize = getInt();
		if( needConvert ) {
			convert = [];
			for( index in indexes ) {
				var ourSchema = schemas[index];
				var schema = getKnownRef(Schema);
				if( ourSchema != null )
					convert[index] = new Convert(ourSchema, schema);
			}
		} else {
			// skip schema data
			inPos += schemaDataSize;
		}
		if( needReindex ) {
			throw "TODO : reindex (save file not compatible)";
		}
	}

	function convertRef( i : Serializable, c : Convert ) {
		var values = new haxe.ds.Vector<Dynamic>(c.read.length);
		var writePos = 0;
		for( r in c.read )
			values[r.index] = readValue(r.from);
		var oldOut = this.out;
		out = new haxe.io.BytesBuffer();
		for( w in c.write ) {
			var v : Dynamic;
			if( w.from == null )
				v = w.defaultValue;
			else {
				v = values[w.index];
				if( !w.same )
					v = convertValue(v, w.from, w.to);
			}
			writeValue(v, w.to);
		}
		var bytes = out.getBytes();
		out = oldOut;
		var oldIn = input;
		var oldPos = inPos;
		setInput(bytes, 0);
		i.unserialize(this);
		setInput(oldIn, oldPos);
	}

	function isNullable( t : Schema.FieldType ) {
		return switch( t ) {
		case PInt, PFloat, PBool: false;
		default: true;
		}
	}

	function convertValue( v : Dynamic, from : Schema.FieldType, to : Schema.FieldType ) : Dynamic {
		if( v == null && isNullable(to) )
			return null;
		throw "Cannot convert " + v + " from " + from + " to " + to;
	}

	function readValue( t : Schema.FieldType ) : Dynamic {
		return switch( t ) {
		case PInt: getInt();
		case PFloat: getFloat();
		case PAlias(t): readValue(t);
		case PBool: getBool();
		case PString: getString();
		case PArray(t): getArray(function() return readValue(t));
		case PVector(t): getVector(function() return readValue(t));
		case PBytes: getBytes();
		case PEnum(name):
			var ser = "hxd.net.enumSer." + name.split(".").join("_");
			if( ser == null ) throw "No enum unserializer found for " + name;
			return (Type.resolveClass(ser) : Dynamic).doUnserialize(this);
		case PSerializable(name): getKnownRef(Type.resolveClass(name));
		case PNull(t): getByte() == 0 ? null : readValue(t);
		case PObj(fields):
			var bits = getByte();
			if( bits == 0 )
				return null;
			var o = {};
			bits--;
			var nullables = [for( f in fields ) if( isNullable(f.type) ) f];
			for( f in fields ) {
				var nidx = nullables.indexOf(f);
				if( nidx >= 0 && bits & (1 << nidx) == 0 ) continue;
				Reflect.setField(o, f.name, readValue(f.type));
			}
			return o;
		case PMap(k, v):
			switch( k ) {
			case PInt:
				(getMap(function() return readValue(k), function() return readValue(v)) : Map<Int,Dynamic>);
			case PString:
				(getMap(function() return readValue(k), function() return readValue(v)) : Map<String,Dynamic>);
			default:
				(getMap(function() return readValue(k), function() return readValue(v)) : Map<{},Dynamic>);
			}
		case PUnknown:
			throw "assert";
		}
	}

	function writeValue( v : Dynamic, t : Schema.FieldType )  {
		switch( t ) {
		case PInt:
			addInt(v);
		case PFloat:
			addFloat(v);
		case PAlias(t):
			writeValue(v,t);
		case PBool:
			addBool(v);
		case PString:
			addString(v);
		case PArray(t):
			addArray(v, function(v) return writeValue(v,t));
		case PVector(t):
			addVector(v, function(v) return writeValue(v,t));
		case PBytes:
			addBytes(v);
		case PEnum(name):
			var ser = "hxd.net.enumSer." + name.split(".").join("_");
			if( ser == null ) throw "No enum unserializer found for " + name;
			(Type.resolveClass(ser) : Dynamic).doSerialize(this,v);
		case PSerializable(_):
			addKnownRef(v);
		case PNull(t):
			if( v == null ) {
				addByte(0);
			} else {
				addByte(1);
				writeValue(v, t);
			}
		case PObj(fields):
			if( v == null )
				addByte(0);
			else {
				var fbits = 0;
				var nullables = [for( f in fields ) if( isNullable(f.type) ) f];
				for( i in 0...nullables.length )
					if( Reflect.field(v, nullables[i].name) != null )
						fbits |= 1 << i;
				addByte(fbits + 1);
				for( f in fields ) {
					var nidx = nullables.indexOf(f);
					var name = f.name;
					if( nidx >= 0 && fbits & (1 << nidx) == 0 ) continue;
					writeValue(Reflect.field(v, f.name), f.type);
				}
			}
		case PMap(k, t):
			addMap(v,function(v) writeValue(v,k), function(v) writeValue(v,t));
		case PUnknown:
			throw "assert";
		}
	}

}
