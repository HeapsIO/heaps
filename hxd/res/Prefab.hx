package hxd.res;

class Prefab extends hxd.res.Resource {

	#if !hide

	public function load() : Dynamic {
		throw "Prefab requires -lib hide";
	}

	#else

	var lib : hrt.prefab.Prefab;

	public function load() : hrt.prefab.Prefab {
		if( lib != null )
			return lib;
		var data = haxe.Json.parse(entry.getText());
		lib = hrt.prefab.Library.create(entry.extension);
		lib.loadData(data);
		watch(function() lib.reload(haxe.Json.parse(entry.getText())));
		return lib;
	}

	#end

}