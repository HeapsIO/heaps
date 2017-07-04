package hxsl;

enum Output {
	Const( v : Float);
	Value( v : String );
	PackNormal( v : Output );
	PackFloat( v : Output );
	Vec2( a : Array<Output> );
	Vec3( a : Array<Output> );
	Vec4( a : Array<Output> );
}
