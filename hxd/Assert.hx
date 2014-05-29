package hxd;

/**
 * Good old fashion assertions
 */
class Assert
{
	public static var ASSERT_HEADER = "[Assertion failed]";
	
	inline static function throwError( msg:String )
	{
		var msg = ASSERT_HEADER + "\n msg: " + msg + "\nstatck:\n" + haxe.CallStack.callStack().join(",\n");
		throw msg;
	}
	
	public static function fail( msg : String )
		throwError(msg);
	
	public inline static function isTrue( o : Bool, ?msg:String = "" )
		if ( false == o )
			throwError("value should be true\n"+msg);
	
	public static inline function isFalse( o : Bool, ?msg:String = "" ) 
		return isTrue( !o, msg );
	
	public static function equals( value : Dynamic, expected:Dynamic, ?msg:String="" )
		if ( value != expected )
			throwError(value + " should be "+expected+"\n  msg: " + msg);
	
	public static function isNull( o:Dynamic, ?msg:String="" )
		if ( o != null ) 
			throwError("Object is null\n msg: " + msg);
			
	public static function isZero( o : Float, ?msg:String="" )
		if ( o != 0.0 ) 
			throwError( '$o does not equal 0 \n msg: $msg' );
			
	public static function notZero( o : Float, ?msg:String="" )
		if ( o == 0.0 ) 
			throwError( '$o equals 0 \n msg: $msg' );
	
	public static function notNan( o : Float, ?msg:String="" )
		if ( Math.isNaN(o ) )  throwError( '$o is Nan \n msg: $msg' );
			
	public static function notNull( o:Dynamic, ?msg:String="" )
		if ( o == null )
			throwError("Object should be null\n  msg: " + msg);
	
	public static function arrayContains( a:Array<Dynamic>, o:Dynamic, ?msg:String = "" )
		if ( a.indexOf(o) == -1 )
			throwError("Array does not contain expected object\n  msg: " + msg);
			
	public static function contains( a:Iterable<Dynamic>, o:Dynamic, ?msg:String = "" )
		if ( !Lambda.has( a, o ) )
			throwError("Iterable does not contain expected object\n  msg: " + msg);
}