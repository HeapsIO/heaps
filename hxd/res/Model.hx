package hxd.res;

class Model extends Resource {

	public function toHmd() : hxd.fmt.hmd.Library {
		var hmd = new hxd.fmt.hmd.Reader(new hxd.fs.FileInput(entry)).readHeader();
		return new hxd.fmt.hmd.Library(entry, hmd);
	}

}