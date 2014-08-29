package hxd.impl;
import haxe.macro.Context;
using haxe.macro.Tools;

class BitsBuilder {

	public static function build() {
		var fields = Context.getBuildFields();
		var pos = Context.currentPos();
		var offset = 0;
		for( f in fields.copy() ) {
			var bits = 0;
			for( m2 in f.meta ) {
				if( m2.name == ":bits" ) {
					switch( m2.params ) {
					case [ { expr : EConst(CInt(v)) } ]: bits = Std.parseInt(v);
					default: bits = -1;
					}
					break;
				}
			}
			if( bits == 0 ) continue;
			switch( f.kind ) {
			case FVar(vt = TPath( { pack : pack, name : name }), init):
				f.kind = FProp("default", "set", vt, init);

				var path = pack.copy();
				path.push(name);
				var t = try Context.getType(path.join(".")) catch( e : Dynamic ) continue;
				var expr = switch( t ) {
				case TAbstract(a, _):
					var t = Std.string(a);
					switch( t ) {
					case "Bool":
						if( bits < 0 ) bits = 1;
						macro (v ? 1 : 0);
					case "Int":
						if( bits < 0 ) Context.error("Please specify bit count", f.pos);
						macro (v & $v{ (1<<bits) - 1 });
					default:
						null;
					}
				case TEnum(e, _):
					if( bits < 0 ) {
						var count = e.get().names.length;
						while( count > 1 << bits ) bits++;
					}
					macro Type.enumIndex(v);
				default:
					null;
				}
				if( expr == null )
					throw "Type " + t + " is not supported for bits";
				var mask = (1 << bits) - 1;
				var erase = ~(mask << offset);
				var name = f.name;
				fields.push({
					name : "set_" + f.name,
					kind : FFun({
						args : [ { name : "v", type : vt } ],
						ret : vt,
						expr : macro { bits = (bits & $v{erase}) | ($expr << $v{offset}); return this.$name = v; }
					}),
					pos : f.pos,
				});
				fields.push({
					name : "get" + f.name.charAt(0).toUpperCase() + f.name.substr(1),
					access : [AStatic,APublic,AInline],
					kind : FFun( {
						args : [ { name : "v", type : macro:Int } ],
						ret : macro:Int,
						expr : macro return (v >> $v{offset}) & $v{mask},
					}),
					pos : f.pos,
				});
				fields.push( {
					name : f.name + "_bits",
					access : [AStatic, APublic, AInline],
					kind : FVar(null, macro $v{ bits } ),
					pos : pos,
				});
				fields.push( {
					name : f.name + "_offset",
					access : [AStatic, APublic, AInline],
					kind : FVar(null, macro $v{ offset } ),
					pos : pos,
				});
				fields.push( {
					name : f.name + "_mask",
					access : [AStatic, APublic, AInline],
					kind : FVar(null, macro $v{ mask << offset } ),
					pos : pos,
				});
				offset += bits;
			default:
			}
		}
		if( offset > 32 )
			Context.error(offset + " bits were used while maximum was 32", pos);
		return fields;
	}

}