package h2d.uikit;

enum CssValue {
	VIdent( i : String );
	VString( s : String );
	VUnit( v : Float, unit : String );
	VFloat( v : Float );
	VInt( v : Int );
	VHex( h : String, v : Int );
	VList( l : Array<CssValue> );
	VGroup( l : Array<CssValue> );
	VCall( f : String, vl : Array<CssValue> );
	VLabel( v : String, val : CssValue );
	VSlash;
}