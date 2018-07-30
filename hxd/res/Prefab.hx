package hxd.res;

class Prefab extends hxd.res.Resource {

	var lib : hxd.prefab.Prefab;

	public function load() : hxd.prefab.Prefab {
		if( lib != null )
			return lib;
		var data = haxe.Json.parse(entry.getText());
		var type = @:privateAccess hxd.prefab.Library.registeredExtensions.get(entry.extension);
		if( type == null )
			lib = new hxd.prefab.Library();
		else
			lib = Type.createInstance(hxd.prefab.Library.getRegistered().get(type).cl,[]);
		lib.load(data);
		watch(function() lib.reload(haxe.Json.parse(entry.getText())));
		return lib;
	}

}