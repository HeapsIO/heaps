package hxd.net;

class Serializer {

	static var UID = 0;
	static var CLASSES = [];
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
			return 1 + ((v & 0x3FFFFFFF) % 255);
		}
		CLIDS = [for( i in 0...CLASSES.length ) if( subClasses[i].length == 0 && !isSub[i] ) 0 else hash(Type.getClassName(cl[i]))];
		CLASSES = [];
		for( i in 0...CLIDS.length ) {
			var cid = CLIDS[i];
			if( CLASSES[cid] != null ) throw "Conflicting CLID between " + Type.getClassName(CLASSES[cid]) + " and " + Type.getClassName(cl[i]);
			CLASSES[cid] = cl[i];
		}
	}

	var refs : Array<Serializable>;
	var out : haxe.io.BytesBuffer;
	var input : haxe.io.Bytes;
	var inPos : Int;

	public function new() {
		if( CLIDS == null ) initClassIDS();
	}

	public function serialize( s : Serializable ) {
		out = new haxe.io.BytesBuffer();
		refs = [];
		addRef(s);
		return out.getBytes();
	}

	public function unserialize<T:Serializable>( data : haxe.io.Bytes, c : Class<T> ) : T {
		refs = [];
		input = data;
		inPos = 0;
		return getRef(c, Reflect.field(c,"__clid"));
	}

	inline function getByte() {
		return input.get(inPos++);
	}

	inline function addByte(v:Int) {
		out.addByte(v);
	}

	inline function addInt(v:Int) {
		if( v >= 0 && v < 0x80 )
			out.addByte(v);
		else {
			out.addByte(0x80);
			out.addInt32(v);
		}
	}

	inline function addDouble(v:Float) {
		out.addDouble(v);
	}

	inline function addBool(v:Bool) {
		addByte(v?1:0);
	}

	inline function addArray<T>(a:Array<T>,f:T->Void) {
		if( a == null ) {
			addByte(0);
			return;
		}
		addInt(a.length + 1);
		for( v in a )
			f(v);
	}

	inline function getArray<T>(f:Void->T) : Array<T> {
		var len = getInt();
		if( len == 0 )
			return null;
		len--;
		var a = [];
		for( i in 0...len )
			a[i] = f();
		return a;
	}

	inline function addMap<K,T>(a:Map<K,T>,fk:K->Void,ft:T->Void) {
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

	@:extern inline function getMap<K,T>(fk:Void->K, ft:Void->T) : Map<K,T> {
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

	inline function getInt() {
		var v = getByte();
		if( v == 0x80 ) {
			v = input.getInt32(inPos);
			inPos += 4;
		}
		return v;
	}

	inline function getDouble() {
		var v = input.getDouble(inPos);
		inPos += 4;
		return v;
	}

	inline function addString( s : String ) {
		if( s == null )
			addByte(0);
		else {
			addInt(s.length + 1);
			out.addString(s);
		}
	}

	inline function getString() {
		var len = getInt();
		if( len == 0 )
			return null;
		len--;
		var s = input.getString(inPos, len);
		inPos += len;
		return s;
	}

	inline function addRef( s : Serializable ) {
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

	inline function getRef<T:Serializable>( c : Class<T>, clid : Int ) : T {
		var id = getInt();
		if( id == 0 ) return null;
		if( refs[id] != null )
			return cast refs[id];
		var clid = CLIDS[clid];
		var i = Type.createEmptyInstance(clid == 0 ? c : cast CLASSES[getByte()]);
		i.__uid = id;
		refs[id] = i;
		i.unserialize(this);
		return i;
	}

}