package h2d.col;

/**
	`h2d.col.Collider` provides a common interface for Shapes to hit-test.
**/
interface Collider /* extends hxd.impl.Serializable.StructSerializable */ {

	/**
		Tests if Point `p` is inside Collider.
	**/
	public function contains( p : Point ) : Bool;

}