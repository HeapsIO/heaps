package hxd.res;

enum Platform {
	Flash;
	HL;
	Cpp;
	JS;
	Unknown;
}

/**
	Resources configuration file.
	Should be modified with --macro to be sure it's correctly setup before any code is compiled.
**/
class Config {

	/**
		Maps the extension to a given resource class. Example ["wav,mp3,ogg" => "hxd.res.Sound"]
	**/
	public static var extensions = [
		"jpg,png,jpeg,gif,tga" => "hxd.res.Image",
		"fbx,hmd" => "hxd.res.Model",
		"ttf" => "hxd.res.Font",
		"fnt" => "hxd.res.BitmapFont",
		"wav,mp3,ogg" => "hxd.res.Sound",
		"tmx" => "hxd.res.TiledMap",
		"atlas" => "hxd.res.Atlas",
		"grd" => "hxd.res.Gradients",
		"prefab,fx,l3d" => "hxd.res.Prefab"
	];

	/**
		File extensions ignored by the resource scan
	**/
	public static var ignoredExtensions = [
		"gal" => true, // graphics gale source
		"lch" => true, // labchirp source
		"fla" => true, // Adobe flash
	];


	/**
		Paired extensions are files that can have the same name but different extensions.
		Only the "main" one will be accessible through hxd.Res.
		Example : ["fbx" => "png,jpg,jpeg,gif"]
	**/
	public static var pairedExtensions = [
		"fnt" => "png",
		"fbx" => "png,jpg,jpeg,gif,tga",
		"cdb" => "img",
		"atlas" => "png",
		"ogg" => "wav",
		"mp3" => "wav",
		"l3d" => "bake",
	];

	static function defined( name : String ) {
		return haxe.macro.Context.defined(name);
	}

	static function init() {
		var pf =
			if( defined("flash") ) Flash else
			if( defined("js") ) JS else
			if( defined("cpp") ) Cpp else
			if( defined("hl") ) HL else
			Unknown;
		if ( pf != HL )
			ignoredExtensions.set("ogg", true);
		return pf;
	}

	public static var platform : Platform = init();

}