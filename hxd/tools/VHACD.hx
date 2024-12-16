package hxd.tools;

#if (hl && hl_ver >= version("1.15.0"))
enum abstract FillMode(Int) {
	var FLOOD_FILL	= 0;
	var SURFACE_ONLY = 1;
	var RAYCAST_FILL = 2;
}

@:hlNative("heaps", "vhacd_")
abstract Instance(hl.Abstract<"vhacd">) {
	public function clean() {}

	public function release() {}

	public function compute(points:hl.Bytes, countPoints:Int, triangles:hl.Bytes, countTriangle:Int, params:Parameters) : Bool {
		return false;
	}

	public function get_n_convex_hulls() : Int {
		return 0;
	}

	public function get_convex_hull(index:Int, convexHullOut:ConvexHull) : Bool {
		return false;
	}
}

abstract Pointer(haxe.Int64) from haxe.Int64 to haxe.Int64 {}

@:struct class Parameters {
	var _unused0 : Pointer = 0;
	var _unused1 : Pointer = 0;
	var _unused2 : Pointer = 0;
	public var maxConvexHulls : Int = 64;                       // The maximum number of convex hulls to produce
	public var maxResolution : Int = 400000;                    // The voxel resolution to use
	public var minimumVolumePercentErrorAllowed : Float = 1;    // if the voxels are within 1% of the volume of the hull, we consider this a close enough approximation
	public var maxRecursionDepth : Int = 10;                    // The maximum recursion depth
	public var shrinkWrap : Bool = true;                        // Whether or not to shrinkwrap the voxel positions to the source mesh on output
	public var fillMode : FillMode = FLOOD_FILL;                // How to fill the interior of the voxelized mesh
	public var maxNumVerticesPerCH : Int = 64;                  // The maximum number of vertices allowed in any output convex hull
	public var asyncACD : Bool = false;                         // Whether or not to run asynchronously, taking advantage of additional cores
	public var minEdgeLength : Int = 2;                         // Once a voxel patch has an edge length of less than 4 on all 3 sides, we don't keep recursing
	public var findBestPlane : Bool = false;                    // Whether or not to attempt to split planes along the best location. Experimental feature. False by default.
	public function new() {
	}
}

@:struct class ConvexHull {
	public var points : hl.Bytes;
	public var triangles : hl.Bytes;
	public var pointCount : Int;
	public var triangleCount : Int;
	public var volume : Float;
	public var centerX : Float;
	public var centerY : Float;
	public var centerZ : Float;
	public var meshId : Int;
	public var boundsMinX : Float;
	public var boundsMinY : Float;
	public var boundsMinZ : Float;
	public var boundsMaxX : Float;
	public var boundsMaxY : Float;
	public var boundsMaxZ : Float;
	public function new(){
	}
}

class VHACD {

	var instance : Instance;

	public function new() {
		instance = createVhacd();
	}

	public function compute(points : hl.Bytes, countPoints : Int, triangles : hl.Bytes, countTriangle : Int, params : Parameters) {
		return instance.compute(points, countPoints, triangles, countTriangle, params);
	}

	public function getConvexHullCount() : Int {
		return instance.get_n_convex_hulls();
	}

	public function getConvexHull(index : Int, convexHull: ConvexHull) : Bool {
		return instance.get_convex_hull(index, convexHull);
	}

	public function clean() {
		instance.clean();
	}

	public function release() {
		instance.release();
		instance = null;
	}

	@:hlNative("heaps", "create_vhacd")
	static function createVhacd() : Instance {
		return null;
	}
}
#end
