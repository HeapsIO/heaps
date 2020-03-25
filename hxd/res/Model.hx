package hxd.res;

class Model extends Resource {

	public function toHmd() : hxd.fmt.hmd.Library {
		var fs = new hxd.fs.FileInput(entry);
		var hmd = new hxd.fmt.hmd.Reader(fs).readHeader();
		fs.close();
		return new hxd.fmt.hmd.Library(this, hmd);
	}

}