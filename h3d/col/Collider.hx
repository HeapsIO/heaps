package h3d.col;

interface Collider extends h3d.impl.Serializable.StructSerializable {

	/**
		Returns the distance of intersection between the ray and the collider, or negative if no collision.
	**/
	public function rayIntersection( r : Ray, bestMatch : Bool ) : Float;
	public function contains( p : Point ) : Bool;
	public function inFrustum( mvp : h3d.Matrix ) : Bool;

}


class OptimizedCollider implements h3d.impl.Serializable implements Collider {

	@:s public var a : Collider;
	@:s public var b : Collider;

	public function new(a, b) {
		this.a = a;
		this.b = b;
	}

	public function rayIntersection( r : Ray, bestMatch : Bool ) : Float {
		if( a.rayIntersection(r, bestMatch) < 0 )
			return -1;
		return b.rayIntersection(r, bestMatch);
	}

	public function contains( p : Point ) {
		return a.contains(p) && b.contains(p);
	}

	public function inFrustum( mvp : h3d.Matrix ) {
		return a.inFrustum(mvp) && b.inFrustum(mvp);
	}


	#if (hxbit && !macro)
	function customSerialize(ctx:hxbit.Serializer) {
	}
	function customUnserialize(ctx:hxbit.Serializer) {
	}
	#end

}

class GroupCollider implements Collider {

	public var colliders : Array<Collider>;

	public function new(colliders) {
		this.colliders = colliders;
	}

	public function rayIntersection( r : Ray, bestMatch : Bool ) : Float {
		var best = -1.;
		for( c in colliders ) {
			var d = c.rayIntersection(r, bestMatch);
			if( d >= 0 ) {
				if( !bestMatch ) return d;
				if( best < 0 || d < best ) best = d;
			}
		}
		return best;
	}

	public function contains( p : Point ) {
		for( c in colliders )
			if( c.contains(p) )
				return true;
		return false;
	}

	public function inFrustum( mvp : h3d.Matrix ) {
		for( c in colliders )
			if( c.inFrustum(mvp) )
				return true;
		return false;
	}


	#if (hxbit && !macro)

	function customSerialize(ctx:hxbit.Serializer) {
		ctx.addInt(colliders.length);
		for( c in colliders )
			ctx.addStruct(c);
	}

	function customUnserialize(ctx:hxbit.Serializer) {
		colliders = [for( i in 0...ctx.getInt() ) ctx.getStruct()];
	}

	#end


}