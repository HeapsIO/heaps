package hxd.impl;
import haxe.macro.Context;
using haxe.macro.Tools;

class BitsBuilder {

	public static function build() {
		var fields = Context.getBuildFields();
		var pos = Context.currentPos();
		var bitsMap = new Map<String, { field : String, current : Int, fields : Array<haxe.macro.Expr> }>();
		for( f in fields.copy() ) {
			var bits = 0;
			var field : String = null;
			for( m2 in f.meta ) {
				if( m2.name == ":bits" ) {
					if( m2.params.length < 1 )
						Context.error("Please specify the bits field", f.pos);

					bits = -1; // auto
					field = switch( m2.params[0] ) {
						case { expr : EConst(CIdent(v)) } : v;
						default : null;
					}

					if( m2.params.length > 1 ) {
						bits = switch( m2.params[1] ) {
							case { expr : EConst(CInt(v)) } : Std.parseInt(v);
							default : -1;
						}
					}
					break;
				}
			}

			if( bits == 0 ) continue;

			var inf = bitsMap.get(field);
			if( inf == null ) {
				inf = { field : field, current : 0, fields : [] };
				bitsMap.set(field, inf);
			}

			var offset = inf.current;
			switch( f.kind ) {
			case FVar(vt = TPath( { pack : pack, name : name }), init):
				f.kind = FProp("default", "set", vt, init);

				var path = pack.copy();
				path.push(name);
				var t = try Context.getType(path.join(".")) catch( e : Dynamic ) continue;
				var fget = null;
				var expr = switch( t ) {
				case TAbstract(a, _):
					var t = Std.string(a);
					switch( t ) {
					case "Bool":
						if( bits < 0 ) bits = 1;
						fget = function(v) return macro ($v != 0);
						macro (v ? 1 : 0);
					case "Int":
						if( bits < 0 ) Context.error("Please specify bit count", f.pos);
						fget = function(v) return v;
						macro (v & $v{ (1<<bits) - 1 });
					default:
						null;
					}
				case TEnum(e, _):
					if( bits < 0 ) {
						var count = e.get().names.length;
						while( count > 1 << bits ) bits++;
					}
					fget = function(v) return macro Type.createEnumIndex($p{path},$v);
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
						expr : macro { this.$field = (this.$field & $v{erase}) | ($expr << $v{offset}); return this.$name = v; }
					}),
					pos : f.pos,
				});

				var v = fget(macro (this.$field >> $v{offset}) & $v{mask});
				inf.fields.push(macro this.$name = $v);

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
			default:
			}

			inf.current += bits;
			if( inf.current > 32 )
				Context.error(inf.current + " bits were used while maximum was 32", pos);
		}

		for( f in bitsMap ) {
			var field = f.field;
			fields.push({
				name : "load" + f.field.charAt(0).toUpperCase() + f.field.substr(1),
				access : [],
				pos : pos,
				kind : FFun({
					args : [{ name : "bits", type : macro : Int }],
					ret : null,
					expr : macro { this.$field = bits; {$a{f.fields}} },
				}),
			});
		}

		return fields;
	}

}