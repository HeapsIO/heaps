package hxd.inspect;

class PropTools {

	public static function setPropValue( p : Property, v : Dynamic, lerp = 1. ) {
		switch( p ) {
		case PInt(_, get, set):
			if( !Std.is(v, Int) ) throw "Invalid int value " + v;
			var v : Int = v;
			if( lerp == 1 )
				set(v);
			else {
				var prev = get();
				var u = hxd.Math.lerp(prev, v, lerp);
				set( prev < v ? Math.ceil(u) : Math.floor(u) );
			}
		case PFloat(_, get, set):
			if( !Std.is(v, Float) ) throw "Invalid float value " + v;
			if( lerp == 1 )
				set(v);
			else
				set(hxd.Math.lerp(get(), v, lerp));
		case PRange(_, _, _, get, set):
			if( !Std.is(v, Float) ) throw "Invalid float value " + v;
			if( lerp == 1 )
				set(v);
			else
				set(hxd.Math.lerp(get(), v, lerp));
		case PBool(_, _, set):
			if( !Std.is(v, Bool) ) throw "Invalid bool value " + v;
			set(v);
		case PString(_, _, set):
			if( v != null && !Std.is(v, String) ) throw "Invalid string value " + v;
			set(v);
		case PEnum(_, en, _, set):
			var e = en.createAll()[v];
			if( e == null || !Std.is(v, Int) ) throw "Invalid enum " + en.getName() + " value " + v;
			set(e);
		case PColor(_, _, get, set):
			if( !Std.is(v, String) ) throw "Invalid color value " + v;
			var v : String = v;
			var newV = h3d.Vector.fromColor(Std.parseInt("0x" + v.substr(1)));
			if( lerp == 1 )
				set(newV);
			else {
				var prev = get();
				newV.r = hxd.Math.lerp(prev.r, newV.r, lerp);
				newV.g = hxd.Math.lerp(prev.g, newV.g, lerp);
				newV.b = hxd.Math.lerp(prev.b, newV.b, lerp);
				newV.a = hxd.Math.lerp(prev.a, newV.a, lerp);
				set(newV);
			}
		case PFloats(_, get, set):
			if( !Std.is(v, Array) ) throw "Invalid floats value " + v;
			var a : Array<Float> = v;
			var prev = get();
			var need = prev.length;
			if( a.length != need ) throw "Require " + need + " floats in value " + v;
			if( lerp == 1 )
				set(a.copy());
			else {
				var newA = a.copy();
				for( i in 0...need )
					newA[i] = hxd.Math.lerp(prev[i], newA[i], lerp);
				set(newA);
			}
		case PTexture(_, _, set):
			if( !Std.is(v, String) ) throw "Invalid texture value " + v;
			var path : String = v;
			if( path.charCodeAt(0) != '/'.code && path.charCodeAt(1) != ':'.code ) {
				set(hxd.res.Loader.currentInstance.load(path).toTexture());
			} else
				hxd.File.load(path, function(data) set( hxd.res.Any.fromBytes(path, data).toTexture() ));
		case PCustom(_, _, set) if( set != null ):
			set(v);
		case PPopup(p, _):
			setPropValue(p, v);
		case PGroup(_), PCustom(_):
			throw "Cannot set property " + p.getName();
		}
	}

	public static function getPropName( p : Property ) {
		return switch( p ) {
		case PGroup(name, _), PBool(name, _), PInt(name, _), PFloat(name, _), PFloats(name, _), PString(name, _), PColor(name, _), PTexture(name, _), PEnum(name,_,_,_), PCustom(name,_), PRange(name,_): name;
		case PPopup(p, _): getPropName(p);
		}
	}

}