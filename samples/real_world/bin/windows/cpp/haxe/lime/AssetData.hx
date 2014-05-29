package lime;


import lime.utils.Assets;


class AssetData {

	private static var initialized:Bool = false;
	
	public static var library = new #if haxe3 Map <String, #else Hash <#end LibraryType> ();
	public static var path = new #if haxe3 Map <String, #else Hash <#end String> ();
	public static var type = new #if haxe3 Map <String, #else Hash <#end AssetType> ();	
	
	public static function initialize():Void {
		
		if (!initialized) {
			
			path.set ("assets/char.png", "assets/char.png");
			type.set ("assets/char.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/haxe.png", "assets/haxe.png");
			type.set ("assets/haxe.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/haxe.tga", "assets/haxe.tga");
			type.set ("assets/haxe.tga", Reflect.field (AssetType, "binary".toUpperCase ()));
			path.set ("assets/haxe2k.png", "assets/haxe2k.png");
			type.set ("assets/haxe2k.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/nme.png", "assets/nme.png");
			type.set ("assets/nme.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/openfl.png", "assets/openfl.png");
			type.set ("assets/openfl.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/openfl.svg", "assets/openfl.svg");
			type.set ("assets/openfl.svg", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/Roboto.ttf", "assets/Roboto.ttf");
			type.set ("assets/Roboto.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
			
			
			initialized = true;
			
		} //!initialized
		
	} //initialize
	
	
} //AssetData
