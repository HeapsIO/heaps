package hxd.impl;

class Properties {

	public function getField(obj : Dynamic, f : String) : Dynamic {
		return Reflect.field(obj, f);
	}

	public function setField(obj : Dynamic, f : String, value : Dynamic) {
		Reflect.setField(obj, f, value);
	}

	function valueStr( v : Dynamic ) {
		var c = Type.getClass(v);
		return c == null ? Std.string(v) : Type.getClassName(c);
	}

	function typeStr(t:Type.ValueType) {
		return switch(t) { case TClass(c): Type.getClassName(c); default: t.getName(); };
	}

	public function apply( props : Dynamic, obj : Dynamic ) {
		for( f in Reflect.fields(props) ) {
			var v : Dynamic = getField(props, f);
			var vprev : Dynamic = getField(obj, f);
			var t = Type.typeof(v);
			switch(t) {
			case TObject:
				if( vprev == null || !Reflect.isObject(vprev) )
					throw valueStr(obj) + " is missing object field " + f;
				apply(v, vprev);
				continue;
			case TInt, TFloat:
				setField(obj, f, v);
				continue;
			case TClass(Array):
				switch( Type.typeof(vprev) ) {
				case TClass(h3d.Vector):
					var v : Array<Float> = v;
					var vprev : h3d.Vector = vprev;
					vprev.set();
					if( v.length >= 1 ) vprev.x = v[0];
					if( v.length >= 2 ) vprev.y = v[1];
					if( v.length >= 3 ) vprev.z = v[2];
					if( v.length >= 4 ) vprev.w = v[3];
					continue;
				default:
				}
			case TClass(String):
				switch( Type.typeof(vprev) ) {
				case TClass(h3d.Vector):
					var v : String = v;
					var vprev : h3d.Vector = vprev;
					if( v.charCodeAt(0) == '#'.code )  {
						var color = Std.parseInt("0x" + v.substr(1));
						vprev.set(
							((color >> 16) & 0xFF) / 255,
							((color >> 8) & 0xFF) / 255,
							(color & 0xFF) / 255,
							(color >>> 24) / 255
						);
						continue;
					}
				default:
				}
			default:
			}
			throw "Don't know how to set " + valueStr(obj) + "." + f + " with " + typeStr(t)+" (was "+typeStr(Type.typeof(vprev))+")";
		}
	}

}