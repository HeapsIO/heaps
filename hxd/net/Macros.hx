package hxd.net;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
using haxe.macro.TypeTools;

class Macros {

	public static macro function serializeValue( ctx : Expr, v : Expr ) : Expr {
		var t = Context.typeof(v);
		var e = exprFromType(ctx, v, t, false);
		if( e == null ) {
			Context.error("Unsupported type " + t.toString(), v.pos);
			return macro { };
		}
		return e;
	}

	public static macro function unserializeValue( ctx : Expr, v : Expr ) : Expr {
		var t = Context.typeof(v);
		var e = unexprFromType(ctx, v, t, false);
		if( e == null ) {
			Context.error("Unsupported type " + t.toString(), v.pos);
			return macro { };
		}
		return e;
	}

	#if macro

	static function isSerializable( c : Ref<ClassType> ) {
		while( true ) {
			var cg = c.get();
			for( i in cg.interfaces )
				if( i.t.toString() == "hxd.net.Serializable" )
					return true;
			var sup = cg.superClass;
			if( sup == null )
				break;
			c = sup.t;
		}
		return false;
	}

	static function isNullable( t : haxe.macro.Type ) {
		switch( t ) {
		case TAbstract(a,_):
			switch( a.toString() ) {
			case "Float", "Int", "Bool":
				return false;
			default:
				return isNullable(Context.followWithAbstracts(t, true));
			}
		case TType(td, _):
			if( td.toString() == "Null" )
				return true;
			return isNullable(Context.follow(t, true));
		case TLazy(_):
			return isNullable(Context.follow(t, true));
		case TInst(_), TAnonymous(_), TEnum(_), TFun(_), TMono(_), TDynamic(_):
			return true;
		}
	}

	static function exprFromType( ctx : Expr, v : Expr, t : haxe.macro.Type, isNull ) {
		switch( t ) {
		case TAbstract(a, pl):
			switch( a.toString() ) {
			case "Float":
				return macro $ctx.addDouble(cast $v);
			case "Int":
				return macro $ctx.addInt(cast $v);
			case "Bool":
				return macro $ctx.addBool(cast $v);
			case "Map":
				var kt = pl[0].toComplexType();
				var vt = pl[1].toComplexType();
				var vk = { expr : EConst(CIdent("k")), pos : v.pos };
				var vv = { expr : EConst(CIdent("v")), pos : v.pos };
				return macro $ctx.addMap(cast $v, function(k:$kt) return hxd.net.Macros.serializeValue($ctx, $vk), function(v:$vt) return hxd.net.Macros.serializeValue($ctx, $vv));
			default:
				return exprFromType(ctx, v, Context.followWithAbstracts(t, true), isNull);
			}
		case TEnum(e, []):
			var ct = t.toComplexType();
			return macro (null : hxd.net.Serializable.SerializableEnum<$ct>).serialize($ctx,cast $v);
		case TAnonymous(a):
			var a = a.get();
			var nullables = [for( f in a.fields ) if( isNullable(f.type) ) f];
			var ct = t.toComplexType();
			if( nullables.length >= 32 )
				Context.error("Too many nullable fields", v.pos);
			return macro {
				var v : $ct = cast $v;
				if( v == null )
					$ctx.addByte(0);
				else {
					var fbits = 0;
					$b{[
						for( i in 0...nullables.length ) {
							var name = nullables[i].name;
							macro if( v.$name != null ) fbits |= $v{ 1 << i };
						}
					]};
					$ctx.addInt(fbits + 1);
					$b{[
						for( f in a.fields ) {
							var nidx = nullables.indexOf(f);
							var name = f.name;
							if( nidx < 0 )
								macro hxd.net.Macros.serializeValue($ctx, v.$name);
							else
								macro if( fbits & $v{1<<nidx} != 0 ) hxd.net.Macros.serializeValue($ctx, v.$name);
						}
					]};
				}
			};
		case TInst(c, pl):
			switch( c.toString() ) {
			case "String":
				return macro $ctx.addString(cast $v);
			case "Array":
				var at = pl[0].toComplexType();
				var ve = { expr : EConst(CIdent("e")), pos : v.pos };
				return macro $ctx.addArray(cast $v, function(e:$at) return hxd.net.Macros.serializeValue($ctx, $ve));
			default:
				if( isSerializable(c) )
					return macro $ctx.addRef(cast $v);
			}
		case TType(td, pl):
			switch( td.toString() ) {
			case "Null":
				return exprFromType(ctx, v, pl[0], true);
			default:
				return exprFromType(ctx, v, Context.follow(t, true), isNull);
			}
		default:
		}
		return null;
	}

	static function unexprFromType( ctx : Expr, v : Expr, t : haxe.macro.Type, isNull ) {
		switch( t ) {
		case TAbstract(a, pl):
			switch( a.toString() ) {
			case "Float":
				return macro $v = cast $ctx.getDouble();
			case "Int":
				return macro $v = cast $ctx.getInt();
			case "Bool":
				return macro $v = cast $ctx.getBool();
			case "Map":
				var kt = pl[0].toComplexType();
				var vt = pl[1].toComplexType();
				var vk = { expr : EConst(CIdent("k")), pos : v.pos };
				var vv = { expr : EConst(CIdent("v")), pos : v.pos };
				return macro {
					var k : $kt;
					var v : $vt;
					$v = cast $ctx.getMap(function() { hxd.net.Macros.unserializeValue($ctx, $vk); return $vk; }, function() { hxd.net.Macros.unserializeValue($ctx, $vv); return $vv; });
				};
			default:
				return unexprFromType(ctx, v, Context.followWithAbstracts(t, true), isNull);
			}
		case TEnum(e, []):
			var ct = t.toComplexType();
			return macro { var e : $ct; e = (null : hxd.net.Serializable.SerializableEnum<$ct>).unserialize($ctx); $v = cast e; }
		case TAnonymous(a):
			var a = a.get();
			var nullables = [for( f in a.fields ) if( isNullable(f.type) ) f];
			var ct = t.toComplexType();
			if( nullables.length >= 32 )
				Context.error("Too many nullable fields", v.pos);
			return macro {
				var fbits = $ctx.getByte();
				if( fbits == 0 )
					$v = cast null;
				else {
					var obj : $ct = cast { };
					fbits--;
					$b{[
						for( f in a.fields ) {
							var nidx = nullables.indexOf(f);
							var name = f.name;
							if( nidx < 0 )
								macro hxd.net.Macros.unserializeValue($ctx, obj.$name);
							else
								macro if( fbits & $v{1<<nidx} != 0 ) hxd.net.Macros.unserializeValue($ctx, obj.$name);
						}
					]};
					$v = cast obj;
				}
			};
		case TInst(c, pl):
			switch( c.toString() ) {
			case "String":
				return macro $v = cast $ctx.getString();
			case "Array":
				var at = pl[0].toComplexType();
				var ve = { expr : EConst(CIdent("e")), pos : v.pos };
				return macro {
					var e : $at;
					$v = cast $ctx.getArray(function() { hxd.net.Macros.unserializeValue($ctx, e); return e; });
				};
			case path:
				if( isSerializable(c) ) {
					var cexpr = Context.parseInlineString(path, v.pos);
					return macro $v = cast $ctx.getRef($cexpr,$cexpr.__clid);
				}
			}
		case TType(td, pl):
			switch( td.toString() ) {
			case "Null":
				return unexprFromType(ctx, v, pl[0], true);
			default:
				return unexprFromType(ctx, v, Context.follow(t, true), isNull);
			}
		default:
		}
		return null;
	}

	static function withPos( e : Expr, p : Position ) {
		e.pos = p;
		haxe.macro.ExprTools.iter(e, function(e) withPos(e, p));
		return e;
	}

	public static function buildSerializable() {
		var fields = Context.getBuildFields();
		var toSerialize = [];
		for( f in fields ) {
			if( f.meta == null ) continue;
			var m = null;
			for( meta in f.meta )
				if( meta.name == ":s" ) {
					toSerialize.push({ f : f, m : m });
					break;
				}
		}

		var cl = Context.getLocalClass().get();
		var sup = cl.superClass;
		var isSubSer = sup != null && isSerializable(sup.t);

		var pos = Context.currentPos();
		var el = [], ul = [];
		for( f in toSerialize ) {
			var fname = f.f.name;
			el.push(withPos(macro hxd.net.Macros.serializeValue(ctx, this.$fname),f.f.pos));
			ul.push(withPos(macro hxd.net.Macros.unserializeValue(ctx, this.$fname),f.f.pos));
		}
		var access = [APublic];
		if( isSubSer )
			access.push(AOverride);
		else
			fields.push({
				name : "__uid",
				pos : pos,
				access : [APublic],
				meta : [{ name : ":noCompletion", pos : pos }],
				kind : FVar(macro : Int, macro @:privateAccess ++hxd.net.Serializer.UID),
			});
		fields.push({
			name : "__clid",
			pos : pos,
			access : [AStatic],
			meta : [{ name : ":noCompletion", pos : pos }, { name : ":keep", pos : pos }],
			kind : FVar(macro : Int, macro @:privateAccess hxd.net.Serializer.registerClass($i{cl.name})),
		});
		fields.push({
			name : "getCLID",
			pos : pos,
			access : access,
			meta : [{ name : ":noCompletion", pos : pos }],
			kind : FFun({ args : [], ret : macro : Int, expr : macro return __clid }),
		});

		if( toSerialize.length == 0 && isSubSer )
			return fields;

		fields.push({
			name : "serialize",
			pos : pos,
			meta : [ { name:":keep", pos:pos } ],
			access : access,
			kind : FFun({
				args : [ { name : "ctx", type : macro : hxd.net.Serializer } ],
				ret : null,
				expr : macro @:privateAccess { ${ if( isSubSer ) macro super.serialize(ctx) else macro { } }; $b{el} }
			}),
		});

		var unserExpr = macro @:privateAccess { ${ if( isSubSer ) macro super.unserialize(ctx) else macro { } }; $b{ul} };

		for( f in fields )
			if( f.name == "unserialize" ) {
				var found = false;
				function repl(e:Expr) {
					switch( e.expr ) {
					case ECall( { expr : EField( { expr : EConst(CIdent("super")) }, "unserialize") }, [ctx]):
						found = true;
						return macro { var ctx : hxd.net.Serializer = $ctx; $unserExpr; }
					default:
						return haxe.macro.ExprTools.map(e, repl);
					}
				}
				switch( f.kind ) {
				case FFun(f):
					f.expr = repl(f.expr);
				default:
				}
				f.meta.push( { name:":keep", pos:pos } );
				if( !found ) Context.error("Override of unserialize() with no super.unserialize(ctx) found", f.pos);
				return fields;
			}

		fields.push({
			name : "unserialize",
			pos : pos,
			meta : [ { name:":keep", pos:pos } ],
			access : access,
			kind : FFun({
				args : [ { name : "ctx", type : macro : hxd.net.Serializer } ],
				ret : null,
				expr : unserExpr,
			}),
		});

		return fields;
	}

	public static function buildSerializableEnum() {
		switch( Context.getLocalType() ) {
		case TInst(_, [tenum = TEnum(e, [])]):
			var e = e.get();
			var name = e.pack.length == 0 ? e.name : e.pack.join("_") + "_" + e.name;
			try {
				return Context.getType("hxd.net.enumSer." + name);
			} catch( _ : Dynamic ) {
				var pos = Context.currentPos();
				var cases = [], ucases = [];
				if( e.names.length >= 256 )
					Context.error("Too many constructors", pos);
				for( f in e.names ) {
					var c = e.constructs.get(f);
					switch( Context.follow(c.type) ) {
					case TFun(args, _):
						var eargs = [for( a in args ) macro hxd.net.Macros.serializeValue(ctx,$i{a.name})];
						cases.push({
							values : [{ expr : ECall({ expr : EConst(CIdent(c.name)), pos : pos },[for( a in args ) { expr : EConst(CIdent(a.name)), pos : pos }]), pos : pos }],
							expr : macro {
								ctx.addByte($v{c.index+1});
								$b{eargs};
							}
						});

						var evals = [];
						for( a in args ) {
							var aname = "_"+a.name;
							var at = a.t.toComplexType();
							evals.push(macro var $aname : $at);
							evals.push(macro hxd.net.Macros.unserializeValue(ctx,$i{aname}));
						}
						evals.push({ expr : ECall({ expr : EConst(CIdent(c.name)), pos : pos },[for( a in args ) { expr : EConst(CIdent("_"+a.name)), pos : pos }]), pos : pos });
						ucases.push({
							values : [macro $v{c.index+1}],
							expr : { expr : EBlock(evals), pos : pos },
						});

					default:
						cases.push({
							values : [ { expr : EConst(CIdent(c.name)), pos : pos } ],
							expr : macro ctx.addByte($v{c.index+1}),
						});
						ucases.push({
							values : [macro $v{c.index+1}],
							expr : { expr : EConst(CIdent(c.name)), pos : pos },
						});
					}
				}
				var t : TypeDefinition = {
					name : name,
					pack : ["hxd","net","enumSer"],
					kind : TDClass(),
					fields : [{
						name : "serialize",
						meta : [{name:":extern",pos:pos}],
						access : [APublic, AInline],
						pos : pos,
						kind : FFun( {
							args : [{ name : "ctx", type : macro : hxd.net.Serializer },{ name : "v", type : tenum.toComplexType() }],
							expr : macro @:privateAccess if( v == null ) ctx.addByte(0) else ${{ expr : ESwitch(macro v,cases,null), pos : pos }},
							ret : null,
						}),
					},{
						name : "unserialize",
						access : [APublic, AInline],
						meta : [{name:":extern",pos:pos}],
						pos : pos,
						kind : FFun( {
							args : [{ name : "ctx", type : macro : hxd.net.Serializer }],
							expr : macro @:privateAccess {
								var b = ctx.getByte();
								if( b == 0 )
									return null;
								return ${{ expr : ESwitch(macro b,ucases,macro throw "Invalid enum index "+b), pos : pos }}
							},
							ret : tenum.toComplexType(),
						}),

					}],
					pos : pos,
				};
				Context.defineType(t);
				return Context.getType("hxd.net.enumSer." + name);
			}
		default:
		}
		Context.error("Enum expected", Context.currentPos());
		return null;
	}

	#end


}