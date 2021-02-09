package h2d.col;

/**
	A common interface for 2D Shapes to hit-test again the mouse or a specific point in space.
**/
interface Collider /* extends hxd.impl.Serializable.StructSerializable */ {

	/**
		Tests if Point `p` is inside the Collider.
	**/
	public function contains( p : Point ) : Bool;

}