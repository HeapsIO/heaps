package hxd.net;

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
			v = 1 + ((v & 0x3FFFFFFF) % 255);
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

	public inline function addAnyRef( s : Serializable ) {
		if( s == null ) {
			addByte(0);
			return;
		}
		addInt(s.__uid);
		if( refs[s.__uid] != null )
			return;
		refs[s.__uid] = s;
		addInt(s.getCLID());
		s.serialize(this);
	}

	public inline function addKnownRef( s : Serializable ) {
		if( s == null ) {
			addByte(0);
			return;
		}
		addInt(s.__uid);
		if( refs[s.__uid] != null )
			return;
		refs[s.__uid] = s;
		var clid = CLIDS[s.getCLID()];
		if( clid != 0 )
			addByte(clid);
		s.serialize(this);
	}

	public inline function getAnyRef() : Serializable {
		var id = getInt();
		if( id == 0 ) return null;
		if( refs[id] != null )
			return cast refs[id];
		var rid = id & SEQ_MASK;
		if( UID < rid ) UID = rid;
		var clid = getInt();
		var i : Serializable = Type.createEmptyInstance(CLASSES[clid]);
		if( newObjects != null ) newObjects.push(i);
		i.__uid = id;
		refs[id] = i;
		i.unserialize(this);
		return i;
	}

	public inline function getRef<T:Serializable>( c : Class<T>, clid : Int ) : T {
		var id = getInt();
		if( id == 0 ) return null;
		if( refs[id] != null )
			return cast refs[id];
		var rid = id & SEQ_MASK;
		if( UID < rid ) UID = rid;
		var clid = CLIDS[clid];
		var i = Type.createEmptyInstance(clid == 0 ? c : cast CL_BYID[getByte()]);
		if( newObjects != null ) newObjects.push(i);
		i.__uid = id;
		refs[id] = i;
		i.unserialize(this);
		return i;
	}

	public inline function getKnownRef<T:Serializable>( c : Class<T> ) : T {
		return getRef(c, untyped c.__clid);
	}

}
