package hxd.inspect;
import hxd.inspect.Property;

enum RendererSection {
	Core;
	Textures;
	Lights;
}

class SceneProps {

	var scene : h3d.scene.Scene;
	public var root : Node;

	public function new( scene ) {
		this.scene = scene;
		root = new Node("s3d");
		initRenderer();
	}

	function refresh() {
	}

	function addNode( name : String, icon : String, props : Void -> Array<Property>, ?parent : Node ) : Node {
		if( parent == null ) parent = root;
		var n = new Node(name, parent);
		n.props = props;
		return n;
	}

	function initRenderer() {
		var r = addNode("Renderer", "sliders", getRendererProps.bind(Core));
		addNode("Lights", "adjust", getRendererProps.bind(Lights), r);
		var s = addNode("Shaders", "code-fork", function() return [], r);
		addNode("Passes", "gears", getRendererProps.bind(Textures), r);

		var r = scene.renderer;
		var cl = Type.getClass(r);
		var ignoreList = getIgnoreList(cl);
		var fields = Type.getInstanceFields(cl);
		var meta = haxe.rtti.Meta.getFields(cl);
		fields.sort(Reflect.compare);
		var prev : { name : String, group : Array<{ name : String, v : Dynamic }> } = null;
		for( f in fields ) {
			if( ignoreList != null && ignoreList.indexOf(f) >= 0 ) continue;
			var m = Reflect.field(meta, f);
			if( m != null && Reflect.hasField(m, "ignore") ) continue;
			var v = Reflect.field(r, f);
			if( !Std.is(v, hxsl.Shader) && !Std.is(v, h3d.pass.ScreenFx) && !Std.is(v,Group) ) continue;

			if( prev != null && StringTools.startsWith(f, prev.name) ) {
				prev.group.push({ name : f.substr(prev.name.length), v : v });
				continue;
			}

			var subs = { name : f, group : [] };
			prev = subs;
			addNode(f, "circle", function() {
				var props = getDynamicProps(v);
				for( g in subs.group ) {
					var gp = getDynamicProps(g.v);
					if( gp.length == 1 )
						switch( gp[0] ) {
						case PGroup(_, props): gp = props;
						default:
						}
					props.push(PGroup(g.name, gp));
				}
				return props;
			}, s);
		}
	}

	public function getRendererProps( section : RendererSection ) {
		var props = [];

		var r = scene.renderer;

		switch( section ) {
		case Lights:

			var ls = scene.lightSystem;
			var props = [];
			props.push(PGroup("LightSystem",[
				PRange("maxLightsPerObject", 0, 10, function() return ls.maxLightsPerObject, function(s) ls.maxLightsPerObject = Std.int(s), 1),
				PColor("ambientLight", false, function() return ls.ambientLight, function(v) ls.ambientLight = v),
				PBool("perPixelLighting", function() return ls.perPixelLighting, function(b) ls.perPixelLighting = b),
			]));

			if( ls.shadowLight != null )
				props.push(PGroup("DirLight", getObjectProps(ls.shadowLight)));

			var s = r.getPass(h3d.pass.DefaultShadowMap);
			if( s != null ) {
				props.push(PGroup("Shadows",[
					PRange("size", 64, 2048, function() return s.size, function(sz) s.size = Std.int(sz), 64),
					PColor("color", false, function() return s.color, function(v) s.color = v),
					PRange("power", 0, 100, function() return s.power, function(v) s.power = v),
					PRange("bias", 0, 0.1, function() return s.bias, function(v) s.bias = v),
					PGroup("blur", getDynamicProps(s.blur)),
				]));
			}

			return props;

		case Textures:

			var props = [];
			/*
			var tp = getTextures(@:privateAccess r.tcache);
			if( tp.length > 0 )
				props.push(PGroup("Textures",tp));*/

			for( p in @:privateAccess r.allPasses )
				props.push(PGroup("Pass " + p.name, getPassProps(p)));
			return props;

		case Core:

			var props = [];
			addDynamicProps(props, r, function(v) return !Std.is(v,hxsl.Shader) && !Std.is(v,h3d.pass.ScreenFx) && !Std.is(v,Group));
			return props;

		}
	}

	function getShaderProps( s : hxsl.Shader ) {
		var props = [];
		var data = @:privateAccess s.shader;
		var vars = data.data.vars.copy();
		vars.sort(function(v1, v2) return Reflect.compare(v1.name, v2.name));
		for( v in vars ) {
			switch( v.kind ) {
			case Param:

				if( v.qualifiers != null && v.qualifiers.indexOf(Ignore) >= 0 ) continue;

				var name = v.name+"__";
				function set(val:Dynamic) {
					Reflect.setField(s, name, val);
					if( hxsl.Ast.Tools.isConst(v) )
						@:privateAccess s.constModified = true;
				}
				switch( v.type ) {
				case TBool:
					props.push(PBool(v.name, function() return Reflect.field(s,name), set ));
				case TInt:
					var done = false;
					if( v.qualifiers != null )
						for( q in v.qualifiers )
							switch( q ) {
							case Range(min, max):
								done = true;
								props.push(PRange(v.name, min, max, function() return Reflect.field(s, name), set,1));
								break;
							default:
							}
					if( !done )
						props.push(PInt(v.name, function() return Reflect.field(s,name), set ));
				case TFloat:
					var done = false;
					if( v.qualifiers != null )
						for( q in v.qualifiers )
							switch( q ) {
							case Range(min, max):
								done = true;
								props.push(PRange(v.name, min, max, function() return Reflect.field(s, name), set));
								break;
							default:
							}
					if( !done )
						props.push(PFloat(v.name, function() return Reflect.field(s, name), set));
				case TVec(size = (3 | 4), VFloat) if( v.name.toLowerCase().indexOf("color") >= 0 ):
					props.push(PColor(v.name, size == 4, function() return Reflect.field(s, name), set));
				case TSampler2D, TSamplerCube:
					props.push(PTexture(v.name, function() return Reflect.field(s, name), set));
				case TVec(size, VFloat):
					props.push(PFloats(v.name, function() {
						var v : h3d.Vector = Reflect.field(s, name);
						var vl = [v.x, v.y];
						if( size > 2 ) vl.push(v.z);
						if( size > 3 ) vl.push(v.w);
						return vl;
					}, function(vl) {
						set(new h3d.Vector(vl[0], vl[1], vl[2], vl[3]));
					}));
				case TArray(_):
					props.push(PString(v.name, function() {
						var a : Array<Dynamic> = Reflect.field(s, name);
						return a == null ? "NULL" : "(" + a.length + " elements)";
					}, function(val) {}));
				default:
					props.push(PString(v.name, function() return ""+Reflect.field(s,name), function(val) { } ));
				}
			default:
			}
		}

		var name = data.data.name;
		if( StringTools.startsWith(name, "h3d.shader.") )
			name = name.substr(11);
		name = name.split(".").join(" "); // no dot in prop name !

		return PGroup("shader "+name, props);
	}

	function getMaterialShaderProps( mat : h3d.mat.Material, pass : h3d.mat.Pass, shader : hxsl.Shader ) {
		return getShaderProps(shader);
	}

	function getMaterialPassProps( mat : h3d.mat.Material, pass : h3d.mat.Pass ) {
		var pl = [
			PBool("Lights", function() return pass.enableLights, function(v) pass.enableLights = v),
			PEnum("Cull", h3d.mat.Data.Face, function() return pass.culling, function(v) pass.culling = v),
			PEnum("BlendSrc", h3d.mat.Data.Blend, function() return pass.blendSrc, function(v) pass.blendSrc = pass.blendAlphaSrc = v),
			PEnum("BlendDst", h3d.mat.Data.Blend, function() return pass.blendDst, function(v) pass.blendDst = pass.blendAlphaDst = v),
			PBool("DepthWrite", function() return pass.depthWrite, function(b) pass.depthWrite = b),
			PEnum("DepthTest", h3d.mat.Data.Compare, function() return pass.depthTest, function(v) pass.depthTest = v)
		];

		var shaders = [for( s in pass.getShaders() ) s];
		shaders.reverse();
		for( index in 0...shaders.length ) {
			var s = shaders[index];
			var p = getMaterialShaderProps(mat,pass,s);
			pl.push(p);
		}
		return PGroup("pass " + pass.name, pl);
	}

	function getMaterialProps( mat : h3d.mat.Material ) {
		var props = [];
		props.push(PString("name", function() return mat.name == null ? "" : mat.name, function(n) mat.name = n == "" ? null : n));
		if( mat.props == null ) {
			for( pass in mat.getPasses() ) {
				var p = getMaterialPassProps(mat, pass);
				props.push(p);
			}
		} else {
			//props = props.concat(mat.props.inspect(function() mat.props.apply(mat)));
		}
		return PGroup("Material",props);
	}

	function getLightProps( l : h3d.scene.Light ) {
		var props = [];
		props.push(PColor("color", false, function() return l.color, function(c) l.color.load(c)));
		props.push(PRange("priority", 0, 10, function() return l.priority, function(p) l.priority = Std.int(p),1));
		props.push(PBool("enableSpecular", function() return l.enableSpecular, function(b) l.enableSpecular = b));
		var dl = Std.instance(l, h3d.scene.DirLight);
		if( dl != null )
			props.push(PFloats("direction", function() {
				var dir = dl.getDirection();
				return [dl.x, dl.y, dl.z];
			}, function(fl) dl.setDirection(new h3d.Vector(fl[0], fl[1], fl[2]))));
		var pl = Std.instance(l, h3d.scene.PointLight);
		if( pl != null )
			props.push(PFloats("params", function() return [pl.params.x, pl.params.y, pl.params.z], function(fl) pl.params.set(fl[0], fl[1], fl[2], fl[3])));
		return PGroup("Light", props);
	}

	public function getObjectProps( o : h3d.scene.Object ) {
		var props = [];
		props.push(PString("name", function() return o.name == null ? "" : o.name, function(v) o.name = v == "" ? null : v));
		props.push(PFloats("pos", function() return [o.x, o.y, o.z], function(v) { o.x = v[0]; o.y = v[1]; o.z = v[2]; }));
		props.push(PFloats("scale", function() return [o.scaleX, o.scaleY, o.scaleZ], function(v) { o.scaleX = v[0]; o.scaleY = v[1]; o.scaleZ = v[2]; }));
		props.push(PBool("visible", function() return o.visible, function(v) o.visible = v));

		if( o.isMesh() ) {
			var multi = Std.instance(o, h3d.scene.MultiMaterial);
			if( multi != null && multi.materials.length > 1 ) {
				for( m in multi.materials )
					props.push(getMaterialProps(m));
			} else
				props.push(getMaterialProps(o.toMesh().material));
		} else {
			var c = Std.instance(o, h3d.scene.CustomObject);
			if( c != null )
				props.push(getMaterialProps(c.material));
			var l = Std.instance(o, h3d.scene.Light);
			if( l != null )
				props.push(getLightProps(l));
		}
		return props;
	}

	function getDynamicProps( v : Dynamic ) : Array<Property> {
		if( Std.is(v,h3d.pass.ScreenFx) || Std.is(v,Group) ) {
			var props = [];
			addDynamicProps(props, v);
			return props;
		}
		var s = Std.instance(v, hxsl.Shader);
		if( s != null )
			return [getShaderProps(s)];
		var o = Std.instance(v, h3d.scene.Object);
		if( o != null )
			return getObjectProps(o);
		var s = Std.instance(v, hxsl.Shader);
		if( s != null )
			return [getShaderProps(s)];
		return null;
	}

	function getIgnoreList( c : Class<Dynamic> ) {
		var ignoreList = null;
		while( c != null ) {
			var cmeta : Dynamic = haxe.rtti.Meta.getType(c);
			if( cmeta != null ) {
				var ignore : Array<String> = cmeta.ignore;
				if( ignore != null ) {
					if( ignoreList == null ) ignoreList = [];
					for( i in ignore )
						ignoreList.push(i);
				}
			}
			c = Type.getSuperClass(c);
		}
		return ignoreList;
	}

	function addDynamicProps( props : Array<Property>, o : Dynamic, ?filter : Dynamic -> Bool ) {
		var cl = Type.getClass(o);
		var ignoreList = getIgnoreList(cl);
		var meta = haxe.rtti.Meta.getFields(cl);
		var fields = Type.getInstanceFields(cl);
		fields.sort(Reflect.compare);
		for( f in fields ) {

			if( ignoreList != null && ignoreList.indexOf(f) >= 0 ) continue;

			var v = Reflect.field(o, f);

			if( filter != null && !filter(v) ) continue;

			// @inspect metadata
			var m : Dynamic = Reflect.field(meta, f);

			if( m != null && Reflect.hasField(m, "ignore") )
				continue;

			if( m != null && Reflect.hasField(m, "inspect") ) {
				if( Std.is(v, Bool) )
					props.unshift(PBool(f, function() return Reflect.getProperty(o, f), function(v) Reflect.setProperty(o, f, v)));
				else if( Std.is(v, Float) ) {
					var range : Array<Dynamic> = m.range;
					if( range != null )
						props.unshift(PRange(f, range[0], range[1], function() return Reflect.getProperty(o, f), function(v) Reflect.setProperty(o, f, v), range[2]));
					else
						props.unshift(PFloat(f, function() return Reflect.getProperty(o, f), function(v) Reflect.setProperty(o, f, v)));
				}
			} else {

				var pl = getDynamicProps(v);
				if( pl != null ) {
					if( pl.length == 1 && pl[0].match(PGroup(_)) )
						props.push(pl[0]);
					else
						props.push(PGroup(f, pl));
				}
			}
		}
	}

	function getPassProps( p : h3d.pass.Base ) {
		var props = [];
		var def = Std.instance(p, h3d.pass.Default);
		if( def == null ) return props;

		addDynamicProps(props, p);

		//for( t in getTextures(@:privateAccess def.tcache) )
		//	props.push(t);

		return props;
	}

	function getTextures( t : h3d.impl.TextureCache ) {
		var cache = @:privateAccess t.cache;
		var props = [];
		for( i in 0...cache.length ) {
			var t = cache[i];
			props.push(PTexture(t.name, function() return t, null));
		}
		return props;
	}

	public function applyProps( propsValues : Dynamic, ?node : Node, ?onError : String -> Void, lerp = 1. ) {
		if( propsValues == null )
			return;
		if( node == null )
			node = root;
		if( lerp < 0 )
			lerp = 0;
		else if( lerp > 1 )
			lerp = 1;
		else if( Math.isNaN(lerp) )
			throw "lerp is NaN";
		var props = null;
		for( f in Reflect.fields(propsValues) ) {
			var v : Dynamic = Reflect.field(propsValues, f);
			var isObj = Reflect.isObject(v) && !Std.is(v, String) && !Std.is(v, Array);
			if( isObj ) {
				var n = node.getChildByName(f);
				if( n != null ) {
					applyProps(v, n, onError, lerp);
					continue;
				}
			}
			if( props == null ) {
				if( node.props == null ) {
					if( onError != null ) onError(node.getFullPath() + " has no properties");
					continue;
				}
				var pl = node.props();
				props = new Map();
				for( p in pl )
					props.set(PropTools.getPropName(p), p);
			}
			var p = props.get(f);
			if( p == null ) {
				if( onError != null ) onError(node.getFullPath() + " has no property "+f);
				continue;
			}
			switch( p ) {
			case PGroup(_, props) if( isObj ):
				applyPropsGroup(node.getFullPath()+"."+f, v, props, onError, lerp);
			default:
				PropTools.setPropValue(p, v, lerp);
			}
		}
	}

	function applyPropsGroup( path : String, propsValues : Dynamic, props : Array<Property>, onError : String -> Void, lerp : Float ) {
		var pmap = new Map();
		for( p in props )
			pmap.set(PropTools.getPropName(p), p);
		for( f in Reflect.fields(propsValues) ) {
			var p = pmap.get(f);
			if( p == null ) {
				if( onError != null ) onError(path+" has no property "+f);
				continue;
			}
			var v : Dynamic = Reflect.field(propsValues, f);
			switch( p ) {
			case PGroup(_, props):
				applyPropsGroup(path + "." + f, v, props, onError, lerp);
			default:
				PropTools.setPropValue(p, v, lerp);
			}
		}
	}


}