package hxd.net;

enum Property {
	PBool( name : String, get : Void -> Bool, set : Bool -> Void );
	PInt( name : String, get : Void -> Int, set : Int -> Void );
	PFloat( name : String, get : Void -> Float, set : Float -> Void );
	PString( name : String, get : Void -> String, set : String -> Void );
	PEnum( name : String, e : Enum<Dynamic>, get : Void -> Dynamic, set : Dynamic -> Void );
	PColor( name : String, hasAlpha : Bool, get : Void -> h3d.Vector, set : h3d.Vector -> Void );
	PGroup( name : String, props : Array<Property> );
	PTexture( name : String, get : Void -> h3d.mat.Texture, set : h3d.mat.Texture -> Void );
	PFloats( name : String, get : Void -> Array<Float>, set : Array<Float> -> Void );
	PPopup( p : Property, menu : Array<String>, click : cdb.jq.JQuery -> Int -> Void );
	PCustom( name : String, content : Void -> cdb.jq.JQuery, ?set : Dynamic -> Void );
}