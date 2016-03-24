package hxd.inspect;
import hxd.inspect.Property;

private class SceneObject extends TreeNode {

	public var o : h3d.scene.Object;
	public var visible = true;
	public var culled = false;

	public function new(o, p) {
		this.o = o;
		super(o.name != null ? o.name : o.toString(), p);
	}

	function objectName( o : h3d.scene.Object ) {
		var name = o.name != null ? o.name : o.toString();
		return name.split(".").join("_");
	}

	override function getPathName() {
		var name = objectName(o);
		if( o.parent == null )
			return name;
		var idx = Lambda.indexOf(@:privateAccess o.parent.childs, o);
		var count = 0;
		for( i in 0...idx )
			if( objectName(o.parent.getChildAt(i)) == name )
				count++;
		if( count > 0 )
			name += "@" + count;
		return name;
	}
}

class ScenePanel extends Panel {

	var scene : h3d.scene.Scene;
	var sceneObjects : Array<SceneObject>;
	var scenePosition = 0;

	public function new(name, scene) {
		super(name, "Scene 3D");
		sceneObjects = [];
		this.scene = scene;
	}

	override function initContent() {
		super.initContent();
		j.addClass("scene");
		j.html('
			<ul class="buttons">
				<li class="bt_hide" title="Show/Hide invisible objects">
					<i class="fa fa-eye" />
				</li>
				<li class="bt_highlight" title="[TODO] Auto highlight in scene selected object">
					<i class="fa fa-cube" />
				</li>
			</ul>
			<div class="scrollable">
				<ul class="elt root">
				</ul>
			</div>
		');
		content = j.find(".root");

		var bt = j.find(".bt_hide");
		bt.addClass("active");
		bt.click(function(_) {
			bt.toggleClass("active");
			content.toggleClass("masked");
		});

		var bt = j.find(".bt_highlight");
		bt.click(function(_) {
			bt.toggleClass("active");
			// TODO
		});
	}

	public function addNode( name : String, icon : String, ?getProps : Void -> Array<Property>, ?parent : TreeNode ) {
		var n = new TreeNode(name, parent == null ? this : parent);
		n.icon = icon;
		n.props = getProps;
		if( getProps != null )
			n.onSelect = function() inspect.editProps(n);
		return n;
	}

	function getObjectIcon( o : h3d.scene.Object) {
		if( Std.is(o, h3d.scene.Skin) )
			return "child";
		if( Std.is(o, h3d.scene.Mesh) )
			return "cube";
		if( Std.is(o, h3d.scene.CustomObject) )
			return "globe";
		if( Std.is(o, h3d.scene.Scene) )
			return "picture-o";
		if( Std.is(o, h3d.scene.Light) )
			return "lightbulb-o";
		return null;
	}

	override function sync() {
		scenePosition = 0;
		syncRec(scene, this);
		while( sceneObjects.length > scenePosition )
			sceneObjects.pop().dispose();
	}

	@:access(hxd.inspect.TreeNode)
	function syncRec( o : h3d.scene.Object, p : Node ) {
		var so = sceneObjects[scenePosition];
		if( so != null && so.o != o ) {
			for( i in scenePosition + 1...sceneObjects.length )
				if( sceneObjects[i].o == o ) {
					var tmp = sceneObjects[i];
					sceneObjects[i] = so;
					sceneObjects[scenePosition] = tmp;
					so = tmp;
					break;
				}
		}
		if( so == null || so.o != o ) {
			so = new SceneObject(o, p);
			sceneObjects.insert(scenePosition, so);
			var icon = getObjectIcon(o);
			so.icon = icon == null ? "circle-o" : getObjectIcon(o);
			so.props = function() return getObjectProps(o);
			so.onSelect = function() inspect.editProps(so);
		}

		if( so.parent != p ) so.parent = p;

		if( o.visible != so.visible ) {
			so.visible = o.visible;
			so.j.toggleClass("hidden");
		}
		@:privateAccess if( o.culled != so.culled ) {
			so.culled = o.culled;
			so.j.toggleClass("culled");
		}

		scenePosition++;
		if( o.numChildren > 0 ) {
			if( so.openIcon == null && so.icon == "circle-o" ) {
				so.openIcon = "circle-o";
				so.icon = "dot-circle-o";
			}
			for( c in o )
				syncRec(c, so);
		} else if( so.jchild != null ) {
			for( o in so.childs )
				o.dispose();
			so.jchild.remove();
			so.jchild = null;
			if( so.openIcon == "circle-o" ) {
				so.openIcon = null;
				so.icon = "circle-o";
			}
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

	function colorize( code : String ) {
		code = code.split("\t").join("    ");
		code = StringTools.htmlEscape(code);
		code = ~/\b((var)|(function)|(if)|(else)|(for)|(while))\b/g.replace(code, "<span class='kwd'>$1</span>");
		code = ~/(@[A-Za-z]+)/g.replace(code, "<span class='meta'>$1</span>");
		return code;
	}

	function getMaterialProps( mat : h3d.mat.Material ) {
		var props = [];
		props.push(PString("name", function() return mat.name == null ? "" : mat.name, function(n) mat.name = n == "" ? null : n));
		for( pass in mat.getPasses() ) {
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
				var p = getShaderProps(s);
				p = PPopup(p, ["Toggle", "View Source"], function(j, i) {
					switch( i ) {
					case 0:
						if( index == 0 ) return; // Don't allow toggle base shader
						if( !pass.removeShader(s) )
							pass.addShaderAt(s, shaders.length - (index + 1));
						j.toggleClass("disable");
					case 1:
						var shader = @:privateAccess s.shader;
						var p = new Panel(null, shader.data.name+" shader");
						var toString = hxsl.Printer.shaderToString;
						var code = toString(shader.data);
						p.j.html("<pre class='code'>"+colorize(code)+"</pre>");
					}

				});
				pl.push(p);
			}

			var p = PGroup("pass " + pass.name, pl);
			p = PPopup(p, ["Toggle", "View Shader"], function(j, i) {
				switch( i ) {
				case 0:
					if( !mat.removePass(pass) )
						mat.addPass(pass);
					j.toggleClass("disable");
				case 1:
					var p = new Panel(null,pass.name+" shader");
					var shader = scene.renderer.compileShader(pass);
					var toString = hxsl.Printer.shaderToString;
					var code = toString(shader.vertex.data) + "\n\n" + toString(shader.fragment.data);
					p.j.html("<pre class='code'>" + colorize(code) + "</pre>");
				}
			});
			props.push(p);
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
			props.push(PFloats("direction", function() return [dl.direction.x, dl.direction.y, dl.direction.z], function(fl) dl.direction.set(fl[0], fl[1], fl[2])));
		var pl = Std.instance(l, h3d.scene.PointLight);
		if( pl != null )
			props.push(PFloats("params", function() return [pl.params.x, pl.params.y, pl.params.z], function(fl) pl.params.set(fl[0], fl[1], fl[2], fl[3])));
		return PGroup("Light", props);
	}

	function getObjectProps( o : h3d.scene.Object ) {
		var props = [];
		props.push(PString("name", function() return o.name == null ? "" : o.name, function(v) o.name = v == "" ? null : v));
		props.push(PFloat("x", function() return o.x, function(v) o.x = v));
		props.push(PFloat("y", function() return o.y, function(v) o.y = v));
		props.push(PFloat("z", function() return o.z, function(v) o.z = v));
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
		var fx = Std.instance(v,h3d.pass.ScreenFx);
		if( fx != null ) {
			var props = [];
			addDynamicProps(props, v);
			return props;
		}
		var s = Std.instance(v, hxsl.Shader);
		if( s != null )
			return [getShaderProps(s)];
		return null;
	}

	function addDynamicProps( props : Array<Property>, o : Dynamic ) {
		var cl = Type.getClass(o);
		var ignoreList = null;
		var ccur = cl;
		while( ccur != null ) {
			var cmeta : Dynamic = haxe.rtti.Meta.getType(ccur);
			var ignore : Array<String> = cmeta.ignore;
			if( ignore != null ) {
				if( ignoreList == null ) ignoreList = [];
				for( i in ignore )
					ignoreList.push(i);
			}
			ccur = Type.getSuperClass(ccur);
		}

		var meta = haxe.rtti.Meta.getFields(cl);
		var fields = Type.getInstanceFields(cl);
		fields.sort(Reflect.compare);
		for( f in fields ) {

			if( ignoreList != null && ignoreList.indexOf(f) >= 0 ) continue;

			var v = Reflect.field(o, f);

			// @inspect metadata
			var m : Dynamic = Reflect.field(meta, f);

			if( m != null && Reflect.hasField(m, "ignore") )
				continue;

			if( m != null && Reflect.hasField(m, "inspect") ) {
				if( Std.is(v, Bool) )
					props.unshift(PBool(f, function() return Reflect.getProperty(o, f), function(v) Reflect.setProperty(o, f, v)));
				else if( Std.is(v, Float) ) {
					var range : Array<Null<Float>> = m.range;
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

		for( t in getTextures(@:privateAccess def.tcache) )
			props.push(t);

		return props;
	}

	public function getRendererProps() {
		var props = [];
		var ls = scene.lightSystem;
		props.push(PGroup("LightSystem", [
			PRange("maxLightsPerObject", 0, 10, function() return ls.maxLightsPerObject, function(s) ls.maxLightsPerObject = Std.int(s), 1),
			PColor("ambientLight", false, function() return ls.ambientLight, function(v) ls.ambientLight = v),
			PBool("perPixelLighting", function() return ls.perPixelLighting, function(b) ls.perPixelLighting = b),
		]));

		var s = Std.instance(scene.renderer.getPass("shadow", false),h3d.pass.ShadowMap);
		if( s != null ) {
			props.push(PGroup("Shadows", [
				PRange("size", 64, 2048, function() return s.size, function(sz) s.size = Std.int(sz), 64),
				PColor("color", false, function() return s.color, function(v) s.color = v),
				PRange("power", 0, 100, function() return s.power, function(v) s.power = v),
				PRange("bias", 0, 0.1, function() return s.bias, function(v) s.bias = v),
			]));
		}

		var r = scene.renderer;

		var tex = getTextures(@:privateAccess r.tcache);
		if( tex.length > 0 )
			props.push( PGroup("Textures", tex) );

		var pmap = new Map();
		for( p in @:privateAccess r.allPasses ) {
			if( pmap.exists(p.p) ) continue;
			pmap.set(p.p, true);
			props.push(PGroup("Pass " + p.name, getPassProps(p.p)));
		}

		addDynamicProps(props, r);
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

}