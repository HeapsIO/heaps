package hxd.net;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
using haxe.macro.TypeTools;

enum RpcMode {
	/*
		When called on the client: will forward the call on the server, but not execute locally.
		When called on the server: will forward the call to the clients (and force its execution), then execute.
		This is the default behavior.
	*/
	All;
	/*
		When called on the server: will forward the call to the clients, but not execute locally.
		When called on the client: will execute locally.
	*/
	Client;
	/*
		When called on the client: will forward the call the server, but not execute locally.
		When called on the server: will execute locally.
	*/
	Server;
}

enum PropType {
	PInt;
	PFloat;
	PBool;
	PString;
	PSerializable( t : ComplexType );
	PEnum( t : ComplexType );
	PMap( k : PropType, v : PropType );
	PArray( k : PropType );
	PObj( fields : Array<{ name : String, type : PropType, opt : Bool }> );
	PNull( v : PropType );
	PProxy( v : PropType );
	PAlias( t : ComplexType, v : PropType );
}

class Macros {

	public static macro function serializeValue( ctx : Expr, v : Expr ) : Expr {
		var t = Context.typeof(v);
		var pt = getPropType(t);
		if( pt == null ) {
			Context.error("Unsupported type " + t.toString(), v.pos);
			return macro { };
		}
		return serializeExpr(ctx, v, pt);
	}

	public static macro function unserializeValue( ctx : Expr, v : Expr ) : Expr {
		var t = Context.typeof(v);
		var pt = getPropType(t);
		if( pt == null ) {
			Context.error("Unsupported type " + t.toString(), v.pos);
			return macro { };
		}
		return unserializeExpr(ctx, v, pt);
	}

	#if macro

	static function isSerializable( c : Ref<ClassType> ) {
		while( true ) {
			var cg = c.get();
			for( i in cg.interfaces )
				switch( i.t.toString() ) {
				case "hxd.net.Serializable", "hxd.net.NetworkSerializable":
					return true;
				default:
				}
			var sup = cg.superClass;
			if( sup == null )
				break;
			c = sup.t;
		}
		return false;
	}

	static function getPropType( t : haxe.macro.Type, isNull = false ) {
		switch( t ) {
		case TAbstract(a, pl):
			switch( a.toString() ) {
			case "Float":
				return isNull ? PNull(PFloat) : PFloat;
			case "Int":
				return isNull ? PNull(PInt) : PInt;
			case "Bool":
				return isNull ? PNull(PBool) : PBool;
			case "Map":
				var tk = getPropType(pl[0]);
				var tv = getPropType(pl[1]);
				if( tk == null || tv == null ) return null;
				return PMap(tk, tv);
			case "hxd.net.ArrayProxy", "hxd.net.ArrayProxy2":
				var t = getPropType(pl[0]);
				if( t == null ) return null;
				return PProxy(PArray(t));
			case "hxd.net.MapProxy", "hxd.net.MapProxy2":
				var k = getPropType(pl[0]);
				var v = getPropType(pl[1]);
				if( k == null || v == null ) return null;
				return PProxy(PMap(k,v));
			default:
				var pt = getPropType(Context.followWithAbstracts(t, true), isNull);
				if( pt == null ) return null;
				return PAlias(t.toComplexType(),pt);
			}
		case TEnum(e, []):
			var et = t.toComplexType();
			return PEnum(et);
		case TAnonymous(a):
			var a = a.get();
			var fields = [];
			for( f in a.fields ) {
				var ft = getPropType(f.type);
				if( ft == null ) return null;
				fields.push( { name : f.name, type : ft, opt : f.meta.has(":optional") } );
			}
			return PObj(fields);
		case TInst(c, pl):
			switch( c.toString() ) {
			case "String":
				return PString;
			case "Array":
				var at = getPropType(pl[0]);
				if( at == null ) return null;
				return PArray(at);
			case name if( StringTools.startsWith(name, "hxd.net.ObjProxy_") ):
				var fields = c.get().fields.get();
				for( f in fields )
					if( f.name == "__value" ) {
						var t = getPropType(f.type);
						if( t == null ) return null;
						return PProxy(t);
					}
			default:
				if( isSerializable(c) )
					return PSerializable(t.toComplexType());
			}
		case TType(td, pl):
			switch( td.toString() ) {
			case "Null":
				return getPropType(pl[0], true);
			default:
				return getPropType(Context.follow(t, true), isNull);
			}
		default:
		}
		return null;
	}

	static function isNullable( t : PropType ) {
		switch( t ) {
		case PInt, PFloat, PBool:
			return false;
		default:
			return true;
		}
	}

	static function toType( t : ComplexType ) : Type {
		return Context.typeof(macro (null:$t));
	}

	static function toComplex( t : PropType ) : ComplexType {
		var name, params = null;
		switch( t ) {
		case PFloat:
			name = "Float";
		case PInt:
			name = "Int";
		case PBool:
			name = "Bool";
		case PString:
			name = "String";
		case PNull(t):
			name = "Null";
			params = [toComplex(t)];
		case PMap(k, v):
			name = "Map";
			params = [toComplex(k), toComplex(v)];
		case PArray(t):
			name = "Array";
			params = [toComplex(t)];
		case PObj(fl):
			var pos = Context.currentPos();
			return TAnonymous([for( f in fl ) { name : f.name, kind : FVar(toComplex(f.type)), pos : pos } ]);
		case PSerializable(t), PEnum(t):
			return t;
		case PProxy(t):
			return TPath( { pack : ["hxd", "net"], name : "NetworkSerializable", sub : "Proxy", params : [TPType(toComplex(t))] } );
		case PAlias(t, _):
			return t;
		}
		return TPath( { pack : [], name : name, params : params == null ? null : [for( p in params ) TPType(p)] } );
	}

	static function serializeExpr( ctx : Expr, v : Expr, t : PropType ) {
		switch( t ) {
		case PFloat:
			return macro $ctx.addFloat($v);
		case PInt:
			return macro $ctx.addInt($v);
		case PBool:
			return macro $ctx.addBool($v);
		case PNull(t):
			return macro if( $v == null ) $ctx.addByte(0) else { $ctx.addByte(1); ${serializeExpr(ctx,v,t)}; };
		case PMap(kt, vt):
			var kt = toComplex(kt);
			var vt = toComplex(vt);
			var vk = { expr : EConst(CIdent("k")), pos : v.pos };
			var vv = { expr : EConst(CIdent("v")), pos : v.pos };
			return macro $ctx.addMap($v, function(k:$kt) return hxd.net.Macros.serializeValue($ctx, $vk), function(v:$vt) return hxd.net.Macros.serializeValue($ctx, $vv));
		case PEnum(et):
			return macro (null : hxd.net.Serializable.SerializableEnum<$et>).serialize($ctx,$v);
		case PObj(fields):
			var nullables = [for( f in fields ) if( isNullable(f.type) ) f];
			var ct = toComplex(t);
			if( nullables.length >= 32 )
				Context.error("Too many nullable fields", v.pos);
			return macro {
				var v : $ct = $v;
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
						for( f in fields ) {
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
		case PString:
			return macro $ctx.addString($v);
		case PArray(t):
			var at = toComplex(t);
			var ve = { expr : EConst(CIdent("e")), pos : v.pos };
			return macro $ctx.addArray($v, function(e:$at) return hxd.net.Macros.serializeValue($ctx, $ve));
		case PSerializable(_):
			return macro $ctx.addKnownRef($v);
		case PProxy(t):
			return serializeExpr(ctx, { expr : EField(v, "__value"), pos : v.pos }, t);
		case PAlias(_, t):
			return serializeExpr(ctx, { expr : ECast(v, null), pos : v.pos }, t);
		}
	}

	static function unserializeExpr( ctx : Expr, v : Expr, t : PropType, isProxy = false ) {
		switch( t ) {
		case PFloat:
			return macro $v = $ctx.getFloat();
		case PInt:
			return macro $v = $ctx.getInt();
		case PBool:
			return macro $v = $ctx.getBool();
		case PNull(t):
			return macro if( $ctx.getByte() == 0 ) $v = null else { ${ unserializeExpr(ctx, v, t) }; };
		case PMap(k,t):
			var kt = toComplex(k);
			var vt = toComplex(t);
			var vk = { expr : EConst(CIdent("k")), pos : v.pos };
			var vv = { expr : EConst(CIdent("v")), pos : v.pos };
			return macro {
				var k : $kt;
				var v : $vt;
				$v = $ctx.getMap(function() { hxd.net.Macros.unserializeValue($ctx, $vk); return $vk; }, function() { hxd.net.Macros.unserializeValue($ctx, $vv); return $vv; });
			};
		case PEnum(et):
			return macro { var e : $et; e = (null : hxd.net.Serializable.SerializableEnum<$et>).unserialize($ctx); $v = e; }
		case PObj(fields):
			var nullables = [for( f in fields ) if( isNullable(f.type) ) f];
			if( nullables.length >= 32 )
				Context.error("Too many nullable fields", v.pos);
			var ct = toComplex(t);
			return macro {
				var fbits = $ctx.getByte();
				if( fbits == 0 )
					$v = null;
				else {
					fbits--;
					$b{{
						var exprs = [];
						var vars = [];
						for( f in fields ) {
							var nidx = nullables.indexOf(f);
							var name = f.name;
							var ct = toComplex(f.type);
							vars.push( { field : name, expr : { expr : EConst(CIdent(name)), pos:v.pos } } );
							if( nidx < 0 ) {
								exprs.unshift(macro var $name : $ct);
								exprs.push(macro hxd.net.Macros.unserializeValue($ctx, $i { name } ));
							} else {
								exprs.unshift(macro var $name : $ct = null);
								exprs.push(macro if( fbits & $v { 1 << nidx } != 0 ) hxd.net.Macros.unserializeValue($ctx, $i { name } ));
							}
						}
						exprs.push( { expr : EBinop(OpAssign,v, { expr : EObjectDecl(vars), pos:v.pos } ), pos:v.pos } );
						exprs;
					}};
				}
			};
		case PString:
			return macro $v = $ctx.getString();
		case PArray(at):
			var at = toComplex(at);
			var ve = { expr : EConst(CIdent("e")), pos : v.pos };
			return macro {
				var e : $at;
				$v = $ctx.getArray(function() { hxd.net.Macros.unserializeValue($ctx, e); return e; });
			};
		case PSerializable(ct):
			var path = haxe.macro.ComplexTypeTools.toString(ct);
			var cexpr = Context.parseInlineString(path, v.pos);
			return macro $v = $ctx.getRef($cexpr,$cexpr.__clid);
		case PProxy(t):
			return unserializeExpr(ctx, v, t, true);
		case PAlias(ct, vt):
			var cvt = toComplex(vt);
			return macro {
				var v : $cvt;
				${unserializeExpr(ctx,macro v,vt)};
				$v = cast v;
			};
		}
	}

	static function withPos( e : Expr, p : Position ) {
		e.pos = p;
		haxe.macro.ExprTools.iter(e, function(e) withPos(e, p));
		return e;
	}

	public static function buildSerializable() {
		var cl = Context.getLocalClass().get();
		if( cl.isInterface )
			return null;
		var fields = Context.getBuildFields();
		var toSerialize = [];

		if( !Context.defined("display") )
		for( f in fields ) {
			if( f.meta == null ) continue;
			for( meta in f.meta )
				if( meta.name == ":s" ) {
					toSerialize.push({ f : f, m : meta });
					break;
				}
		}

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

	static function maybeNeedProxy( e : Expr ) {
		if( e == null )
			return true;
		switch( e.expr ) {
		case EConst(CInt(_)), EConst(CFloat(_)), EConst(CString(_)), EConst(CIdent("true"|"false")):
			return false;
		default:
		}
		return true;
	}

	static function needProxy( t : PropType ) {
		if( t == null )
			return false;
		switch( t ) {
		case PMap(_), PArray(_), PObj(_), PProxy(_):
			return true;
		case PAlias(_, v):
			return needProxy(v);
		default:
			return false;
		}
	}

	static function toProxyRec( t : ComplexType ) {
		var tt = Context.resolveType(t, Context.currentPos());
		var p = getPropType(tt);
		if( !needProxy(p) )
			return t;
		return toProxy(t);
	}

	static function toProxy( t : ComplexType ) {
		switch( t ) {
		case TPath(t):
			t.params = [for( p in t.params ) switch( p ) { case TPType(t): TPType(toProxyRec(t)); default: p; }];
		case TAnonymous(a):
			for( f in a )
				switch( f.kind ) {
				case FVar(t, e):
					f.kind = FVar(toProxyRec(t), e);
				default:
				}
		default:
		}
		return macro : hxd.net.NetworkSerializable.Proxy<$t>;
	}


	static var hasRetVal : Bool;
	static function hasReturnVal( e : Expr ) {
		hasRetVal = false;
		checkRetVal(e);
		return hasRetVal;
	}

	static function checkRetVal( e : Expr ) {
		if( hasRetVal )
			return;
		switch( e.expr ) {
		case EReturn(e):
			if( e != null )
				hasRetVal = true;
		default:
			haxe.macro.ExprTools.iter(e, checkRetVal);
		}
	}

	public static function buildNetworkSerializable() {
		var cl = Context.getLocalClass().get();
		if( cl.isInterface )
			return null;
		var fields = Context.getBuildFields();
		var toSerialize = [];
		var rpc = [];

		if( !Context.defined("display") )
		for( f in fields ) {
			if( f.meta == null ) continue;
			for( meta in f.meta ) {
				if( meta.name == ":s" ) {
					toSerialize.push({ f : f, m : meta });
					break;
				}
				if( meta.name == ":rpc" ) {
					var mode : RpcMode = All;
					if( meta.params.length != 0 )
						switch( meta.params[0].expr ) {
						case EConst(CIdent("all")):
						case EConst(CIdent("client")): mode = Client;
						case EConst(CIdent("server")): mode = Server;
						default:
							Context.error("Unexpected Rpc mode : should be all|client|server", meta.params[0].pos);
						}
					rpc.push({ f : f, mode:mode });
					break;
				}
			}
		}

		var sup = cl.superClass;
		var isSubSer = sup != null && isSerializable(sup.t);
		var startFID = 0, rpcID = 0;
		if( isSubSer ) {
			startFID = switch( sup.t.get().meta.extract(":fieldID")[0].params[0].expr ) {
			case EConst(CInt(i)): Std.parseInt(i);
			default: throw "assert";
			}
			rpcID = switch( sup.t.get().meta.extract(":rpcID")[0].params[0].expr ) {
			case EConst(CInt(i)): Std.parseInt(i);
			default: throw "assert";
			}
		}

		var pos = Context.currentPos();
		if( !isSubSer ) {
			fields = fields.concat((macro class {
				@:noCompletion public var __host : hxd.net.NetworkHost;
				@:noCompletion public var __bits : Int = 0;
				@:noCompletion public var __next : hxd.net.NetworkSerializable;
				@:noCompletion public function setNetworkBit( b : Int ) {
					if( __host != null ) {
						if( __bits == 0 ) @:privateAccess __host.mark(this);
						__bits |= 1 << b;
					}
				}
				public var enableReplication(get, set) : Bool;
				inline function get_enableReplication() return __host != null;
				function set_enableReplication(b) {
					hxd.net.NetworkHost.enableReplication(this, b);
					return b;
				}
				public inline function networkCancelProperty( props : hxd.net.NetworkSerializable.Property ) {
					__bits &= ~props.toInt();
				}
			}).fields);
		}

		var flushExpr = [];
		var syncExpr = [];
		var noComplete : Metadata = [ { name : ":noCompletion", pos : pos } ];

		for( f in toSerialize ) {
			var pos = f.f.pos;
			var fname = f.f.name;
			var bitID = startFID++;
			var ftype : ComplexType;
			var proxy = false;
			switch( f.f.kind ) {
			case FVar(t, e):
				ftype = t;
				if( ftype == null ) {
					if( maybeNeedProxy(e) ) Context.error("Type required", pos);
				} else {
					var tt = Context.resolveType(t, pos);
					if( needProxy(getPropType(tt)) ) {
						proxy = true;
						ftype = toProxy(ftype);
					}
				}
				f.f.kind = FProp("default", "set", ftype, e);
			case FProp(get, set, t, e):
				ftype = t;
				if( ftype == null ) {
					if( maybeNeedProxy(e) ) Context.error("Type required", pos);
				} else {
					var tt = Context.resolveType(t, pos);
					if( needProxy(getPropType(tt)) ) {
						proxy = true;
						ftype = toProxy(ftype);
					}
				}
				if( set == "null" )
					Context.warning("Null setter is not respected when using NetworkSerializable", pos);
				else if( set != "default" && set != "set" )
					Context.error("Invalid setter", pos);
				f.f.kind = FProp(get,"set", ftype, e);
			default:
				throw "assert";
			}

			var setExpr = macro
				if( this.$fname != v ) {
					if( __host != null ) {
						if( this.__bits == 0 ) @:privateAccess __host.mark(this);
						this.__bits |= 1 << $v{ bitID };
					}
					this.$fname = v;
					${if( proxy ) macro this.$fname.bindHost(this,$v{bitID}) else macro {}};
				};

			var found = false;
			for( set in fields )
				if( set.name == "set_" + f.f.name )
					switch( set.kind ) {
					case FFun(f):
						function replaceRec(e:Expr) {
							switch( e.expr ) {
							case EBinop(OpAssign, e1 = { expr : (EConst(CIdent(name)) | EField( { expr : EConst(CIdent("this")) }, name)) }, e2) if( name == fname ):
								return macro {
									var v = $e2;
									$setExpr;
									v;
								};
								return e;
							case EBinop(OpAssignOp(_), { expr : (EConst(CIdent(name)) | EField( { expr : EConst(CIdent("this")) }, name)) }, _) if( name == fname ):
								throw "TODO";
							default:
								return haxe.macro.ExprTools.map(e, replaceRec);
							}
						}
						f.expr = replaceRec(f.expr);
						found = true;
						break;
					default:
					}
			if( !found )
				fields.push({
					name : "set_" + fname,
					pos : pos,
					kind : FFun({
						args : [ { name : "v", type : ftype } ],
						expr : macro { $setExpr; return v; },
						ret : ftype,
					}),
				});
			flushExpr.push(macro if( b & (1 << $v{ bitID } ) != 0 ) hxd.net.Macros.serializeValue(ctx, this.$fname));
			syncExpr.push(macro if( __bits & (1 << $v { bitID } ) != 0 ) hxd.net.Macros.unserializeValue(ctx, this.$fname));

			var prop = "networkProp" + fname.charAt(0).toUpperCase() + fname.substr(1);
			fields.push({
				name : prop,
				pos : pos,
				kind : FProp("get", "never", macro : hxd.net.NetworkSerializable.Property),
				access : [APublic],
			});
			fields.push({
				name : "get_"+prop,
				pos : pos,
				kind : FFun( {
					args : [],
					expr : macro return new hxd.net.NetworkSerializable.Property(1 << $v{bitID}),
					ret : null,
				}),
				access : [AInline],
			});
		}

		// BUILD RPC
		var firstRPCID = rpcID;
		var rpcCases = [];
		for( r in rpc ) {
			switch( r.f.kind ) {
			case FFun(f):
				var id = rpcID++;
				var ret = f.ret;
				f.ret = macro : Void;
				for( a in f.args )
					if( a.type == null )
						Context.error("Type required for rpc function argument " + r.f.name+"(" + a.name+")", r.f.pos);

				var hasReturnVal = hasReturnVal(f.expr);

				var expr = f.expr;
				var resultCall = macro null;

				if( hasReturnVal ) {
					expr = macro {
						inline function __execute() ${f.expr};
						onResult(__execute());
					}
					resultCall = macro function(__ctx) {
						var v = cast null;
						if( false ) onResult(v); // type
						hxd.net.Macros.unserializeValue(__ctx, v);
						onResult(v);
					};
				}

				var forwardRPC = macro {
					var __ctx = __host.beginRPC(this,$v{id},$resultCall);
					$b{[
						for( a in f.args )
							macro hxd.net.Macros.serializeValue(__ctx,$i{a.name})
					]};
				};

				f.expr = switch( r.mode ) {
				case All:
					macro {
						if( __host != null ) {
							$forwardRPC;
							if( !__host.isAuth ) return;
						}
						$expr;
					}
				case Client:
					macro {
						if( __host != null && __host.isAuth ) {
							$forwardRPC;
							return;
						}
						$expr;
					}
				case Server:
					macro {
						if( __host != null && !__host.isAuth ) {
							$forwardRPC;
							return;
						}
						$expr;
					}
				};
				var p = r.f.pos;
				var exprs = [{ expr : EVars([for( a in f.args ) { name : a.name, type : a.type, expr : null }]), pos : p }];
				for( a in f.args )
					exprs.push(macro hxd.net.Macros.unserializeValue(__ctx, $i { a.name } ));

				var cargs = [for( a in f.args ) { expr : EConst(CIdent(a.name)), pos : p } ];
				if( hasReturnVal ) {
					f.args.push( { name : "onResult", type : ret == null ? null : TFunction([ret], macro:Void) } );
					cargs.push(macro function(result) {
						@:privateAccess __clientResult.beginRPCResult();
						hxd.net.Macros.serializeValue(__ctx, result);
					});
				}

				exprs.push( { expr : ECall( { expr : EField({ expr : EConst(CIdent("this")), pos:p }, r.f.name), pos : p }, cargs), pos : p } );
				rpcCases.push({ values : [{ expr : EConst(CInt(""+id)), pos : p }], guard : null, expr : { expr : EBlock(exprs), pos : p } });
			default:
				Context.error("Cannot use @:rpc on non function", r.f.pos);
			}
		}

		// Add network methods
		var access = [APublic];
		if( isSubSer ) access.push(AOverride);

		if( fields.length != 0 || !isSubSer ) {
			if( isSubSer ) {
				flushExpr.unshift(macro super.networkFlush(ctx));
				syncExpr.unshift(macro super.networkSync(ctx));
			} else {
				flushExpr.unshift(macro ctx.addInt(__bits));
				flushExpr.push(macro __bits = 0);
				syncExpr.unshift(macro __bits = ctx.getInt());
			}
			flushExpr.unshift(macro var b = __bits);
			fields.push({
				name : "networkFlush",
				pos : pos,
				access : access,
				meta : noComplete,
				kind : FFun({
					args : [ { name : "ctx", type : macro : hxd.net.Serializer } ],
					ret : null,
					expr : { expr : EBlock(flushExpr), pos : pos },
				}),
			});

			fields.push({
				name : "networkSync",
				pos : pos,
				access : access,
				meta : noComplete,
				kind : FFun({
					args : [ { name : "ctx", type : macro : hxd.net.Serializer } ],
					ret : null,
					expr : macro @:privateAccess $b{syncExpr},
				}),
			});
		}

		if( rpc.length != 0 || !isSubSer ) {
			var swExpr = { expr : ESwitch( { expr : EConst(CIdent("__id")), pos : pos }, rpcCases, macro throw "Unknown RPC identifier " + __id), pos : pos };
			fields.push({
				name : "networkRPC",
				pos : pos,
				access : access,
				meta : noComplete,
				kind : FFun({
					args : [ { name : "__ctx", type : macro : hxd.net.Serializer }, { name : "__id", type : macro : Int }, { name : "__clientResult", type : macro : hxd.net.NetworkHost.NetworkClient } ],
					ret : null,
					expr : if( isSubSer && firstRPCID > 0 ) macro { if( __id < $v { firstRPCID } ) { super.networkRPC(__ctx, __id, __clientResult); return; } $swExpr; } else swExpr,
				}),
			});
		}


		// add metadata

		if( startFID > 32 ) Context.error("Too many serializable fields", pos);
		if( rpcID > 255 ) Context.error("Too many rpc calls", pos);
		cl.meta.add(":fieldID", [macro $v { startFID } ], pos);
		cl.meta.add(":rpcID", [macro $v { rpcID } ], pos);

		return fields;
	}

	static function buildProxyType( p : PropType ) {
		switch( p ) {
		case PArray(k):
			var name = switch( k ) {
			case PProxy(_): "ArrayProxy2";
			default: "ArrayProxy";
			}
			return toType(TPath( { pack : ["hxd", "net"], name : "ArrayProxy", sub : name, params : [TPType(toComplex(k))] } ));
		case PMap(k, v):
			var name = switch( v ) {
			case PProxy(_): "MapProxy2";
			default: "MapProxy";
			}
			return toType(TPath( { pack : ["hxd", "net"], name : "MapProxy", sub : name, params : [TPType(toComplex(k)),TPType(toComplex(v))] } ));
		case PObj(fields):
			// define type
			var name = "ObjProxy_";
			fields.sort(function(f1, f2) return Reflect.compare(f1.name, f2.name));
			name += [for( f in fields ) f.name+"_" + haxe.macro.ComplexTypeTools.toString(toComplex(f.type)).split(".").join("_")].join("_");
			try {
				return Context.getType("hxd.net." + name);
			} catch( e : Dynamic ) {
				var pos = Context.currentPos();
				var pt = toComplex(p);
				var myT = TPath( { pack : ["hxd", "net"], name : name } );
				var tfields = (macro class {
					var obj : hxd.net.NetworkSerializable.ProxyHost;
					var bit : Int;
					@:noCompletion public var __value(get, never) : $pt;
					inline function get___value() : $pt return cast this;
					inline function mark() if( obj != null ) obj.setNetworkBit(bit);
					@:noCompletion public function setNetworkBit(_) mark();
					@:noCompletion public function bindHost(obj, bit) { this.obj = obj; this.bit = bit; }
					@:noCompletion public function unbindHost() this.obj = null;
				}).fields;
				for( f in fields ) {
					var ft = toComplex(f.type);
					var fname = f.name;
					tfields.push({
						name : f.name,
						pos : pos,
						access : [APublic],
						kind : FProp("default","set",ft),
					});
					tfields.push( {
						name : "set_" + f.name,
						pos : pos,
						access : [AInline],
						kind : FFun({
							ret : ft,
							args : [ { name : "v", type : ft } ],
							expr : macro { this.$fname = v; mark(); return v; }
						}),
					});
				}
				tfields.push({
					name : "new",
					pos : pos,
					access : [APublic],
					kind : FFun({
						ret : null,
						args : [for( f in fields ) { name : f.name, type : toComplex(f.type), opt : f.opt } ],
						expr : { expr : EBlock([for( f in fields ) { var fname = f.name; macro this.$fname = $i{fname}; }]), pos : pos },
					})
				});
				var t : TypeDefinition = {
					pos : pos,
					pack : ["hxd", "net"],
					meta : [{ name : ":structInit", pos : pos }],
					name : name,
					kind : TDClass([
						{ pack : ["hxd", "net"], name : "NetworkSerializable", sub : "ProxyHost" },
						{ pack : ["hxd", "net"], name : "NetworkSerializable", sub : "ProxyChild" },
					]),
					fields : tfields,
				};
				Context.defineType(t);
				return Context.getType("hxd.net." + name);
			}
		case PAlias(_, p):
			return buildProxyType(p);
		case PProxy(_):
			return toType(toComplex(p));
		default:
		}
		return null;
	}

	public static function buildSerializableProxy() {
		var t = Context.getLocalType();
		switch( t ) {
		case TInst(_, [pt]):
			var p = getPropType(pt);
			if( p != null ) {
				var t = buildProxyType(p);
				if( t != null ) return t;
			}
			throw "TODO "+pt+" ("+p+")";
		default:
			throw "assert";
		}
	}

	#end

}