package hxd.fs;

class NotFound {
	public var path : String;
	public function new(path) {
		this.path = path;
	}
	@:keep function toString() {
		return "Resource file not found '" + path + "'";
	}
}