package h3d.impl;

#if js
private typedef GL = js.html.webgl.GL;
#elseif cpp
import openfl.gl.GL;
#end

#if (!macro && (js || cpp))
@:build(h3d.impl.DebugGL.buildProxy())
#end
class DebugGL {
	
	
	#if macro
	static function buildProxy() {
		var gl = haxe.macro.Context.getType("GL");
		var fields = [];
		var pos = haxe.macro.Context.currentPos();
		switch( gl ) {
		case TInst(cl, _):
			for( f in cl.get().statics.get() ) {
				var fname = f.name;
				if( !f.isPublic ) continue;
				switch( f.kind ) {
				case FVar(_):
					if( fname.toUpperCase() == fname )
						fields.push((macro class { public static var $fname = GL.$fname; } ).fields[0] );
				case FMethod(_):
					switch( haxe.macro.Context.follow(f.type) ) {
					case TFun(args, ret):
						var eargs = [for( a in args ) macro $i { a.name } ];
						var expr = if( haxe.macro.TypeTools.toString(haxe.macro.Context.follow(ret)) == "Void" )
							macro {
								GL.$fname($a{eargs});
								haxe.Log.trace($v { fname } + ([$a { eargs } ] : Array<Dynamic>), _pos);
							};
						else
							macro {
								var r = GL.$fname($a { eargs } );
								haxe.Log.trace($v{fname} + ([$a{eargs}] : Array<Dynamic>) + "=" + r, _pos);
								return r;
							};
						var fargs = [for( a in args ) { name : a.name, opt : false, type : null, value : null } ];
						fargs.push( { name : "_pos", opt : true, type : macro : haxe.PosInfos, value : null } );
						fields.push({
							name : fname,
							access : [APublic, AStatic],
							meta : [],
							pos : pos,
							kind : FFun( {
								ret : null,
								args : fargs,
								params : [],
								expr : expr,
							}),
						});
					default:
					}
				}
			}
		default:
		}
		return fields;
	}
	#end
	
}