package hxd.res;

class AwdModel extends Resource {

	public function load() {
		return new hxd.res.fmt.AwdReader().read(entry.getBytes());		
	}
	
}