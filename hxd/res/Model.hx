package hxd.res;

class Model extends Resource {

	public function toHmd() : hxd.fmt.hmd.Library {
		var fs = entry.open();
		var hmd = new hxd.fmt.hmd.Reader(fs).readHeader(#if editor true #end);
		fs.close();
		return new hxd.fmt.hmd.Library(this, hmd);
	}

}