package hxd.fmt.hmd;

@:generic
class HMDOut<T> {
	public function new() {

	}

	public function load<T>(data : T) {
		throw "Not implemented";
	}

	public function toHMD() : hxd.fmt.hmd.Data {
		throw "Not implemented";
	}
}