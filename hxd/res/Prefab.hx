package hxd.res;

class Prefab extends hxd.res.Resource {

	var lib : hxd.prefab.Prefab;

	public function load() : hxd.prefab.Prefab {
		if( lib != null )
			return lib;
		var data = haxe.Json.parse(entry.getText());
		lib = hxd.prefab.Library.create(entry.extension);
		lib.load(data);
		watch(function() lib.reload(haxe.Json.parse(entry.getText())));
		return lib;
	}

}