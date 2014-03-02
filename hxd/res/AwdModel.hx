package hxd.res;

class AwdModel extends Resource {

	public function load() {
		return new hxd.fmt.awd.Reader().read(entry.getBytes());
	}
	
}