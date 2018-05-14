package h3d.mat;

/**
	Depth buffer are used to store per pixel depth information when rendering a scene (also called Z-buffer)
**/
class DepthBuffer {

	@:allow(h3d.impl.MemoryManager)
	var b : h3d.impl.Driver.DepthBuffer;
	public var width(default, null) : Int;
	public var height(default, null) : Int;

	/**
		Creates a new depth buffer, it can be attached to one or several render target Texture by setting their `depthBuffer` property.
	**/
	public function new( width : Int, height : Int ) {
		this.width = width;
		this.height = height;
		if( width > 0 ) alloc();
	}

	function alloc() {
		h3d.Engine.getCurrent().mem.allocDepth(this);
	}

	public function dispose() {
		if( b != null ) {
			h3d.Engine.getCurrent().mem.deleteDepth(this);
			b = null;
		}
	}

	public function isDisposed() {
		return b == null;
	}

	/**
		This will return the default depth buffer, which is automatically resized to the screen size.
	**/
	public static function getDefault() {
		return h3d.Engine.getCurrent().driver.getDefaultDepthBuffer();
	}

}