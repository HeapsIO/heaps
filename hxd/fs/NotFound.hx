package hxd.fs;

/**
	An exception thrown when the requested path was not found in the file system.
**/
class NotFound {
	/**
		The request path of the missing file.
	**/
	public var path : String;
	/**
		Create a new NotFound exception for the given `path`.
	**/
	public function new(path) {
		this.path = path;
	}
	@:dox(hide) @:keep function toString() {
		return "Resource file not found '" + path + "'";
	}
}