package hxd.prefab;

@:keepSub
class Prefab {

	public var type(default, null) : String;
	public var name(default, set) : String;
	public var parent(default, set) : Prefab;
	public var source(default, set) : String;
	public var children(default, null) : Array<Prefab>;
	public var enabled : Bool = true;
	public var props : Any;

	public function new(?parent) {
		this.parent = parent;
		children = [];
	}

	function set_name(n) {
		return name = n;
	}

	function set_source(f) {
		return source = f;
	}

	function set_parent(p) {
		if( parent != null )
			parent.children.remove(this);
		parent = p;
		if( parent != null )
			parent.children.push(this);
		return p;
	}

	#if editor
	public function edit( ctx : hide.prefab.EditContext ) {
	}

	public function getHideProps() : hide.prefab.HideProps {
		return { icon : "question-circle", name : "Unknown" };
	}

	public function setSelected( ctx : hide.prefab.Context, b : Bool ) {
		var materials = ctx.shared.getMaterials(this);

		if( !b ) {
			for( m in materials ) {
				m.mainPass.stencil = null;
				m.removePass(m.getPass("highlight"));
			}
			return;
		}

		var shader = new h3d.shader.FixedColor(0xffffff);
		for( m in materials ) {
			var p = m.allocPass("highlight");
			p.culling = None;
			p.depthWrite = false;
			p.addShader(shader);
		}
	}
	#end

	public inline function iterator() : Iterator<Prefab> {
		return children.iterator();
	}

	public function load( v : Dynamic ) {
		throw "Not implemented";
	}

	public function save() : {} {
		throw "Not implemented";
		return null;
	}

	public function makeInstance( ctx : Context ) : Context {
		return ctx;
	}

	public function updateInstance( ctx : Context, ?propName : String ) {
	}

	public function removeInstance( ctx : Context ) : Bool {
		return false;
	}

	public function saveRec() : {} {
		var obj : Dynamic = save();
		obj.type = type;
		if( !enabled )
			obj.enabled = false;
		if( name != null )
			obj.name = name;
		if( source != null )
			obj.source = source;
		if( children.length > 0 )
			obj.children = [for( s in children ) s.saveRec()];
		if( props != null && obj.props == null )
			obj.props = props;
		return obj;
	}

	public function reload( p : Dynamic ) {
		load(p);
		var childData : Array<Dynamic> = p.children;
		if( childData == null ) {
			if( this.children.length > 0 ) this.children = [];
			return;
		}
		var curChild = new Map();
		for( c in children )
			curChild.set(c.name, c);
		var newchild = [];
		for( v in childData ) {
			var name : String = v.name;
			var prev = curChild.get(name);
			if( prev != null && prev.type == v.type ) {
				curChild.remove(name);
				prev.reload(v);
				newchild.push(prev);
			} else {
				newchild.push(loadRec(v,this));
			}
		}
		children = newchild;
	}

	public static function loadRec( v : Dynamic, ?parent : Prefab ) {
		var pcl = @:privateAccess Library.registeredElements.get(v.type);
		var pcl = pcl == null ? null : pcl.cl;
		if( pcl == null ) pcl = hxd.prefab.Unknown;
		var p = Type.createInstance(pcl, [parent]);
		p.type = v.type;
		p.name = v.name;
		if(v.enabled != null)
			p.enabled = v.enabled;
		p.props = v.props;
		if( v.source != null )
			p.source = v.source;
		p.load(v);
		var children : Array<Dynamic> = v.children;
		if( children != null )
			for( v in children )
				loadRec(v, p);
		return p;
	}

	public function makeInstanceRec( ctx : Context ) : Context {
		if(!enabled)
			return ctx;
		if( ctx == null ) {
			ctx = new Context();
			ctx.init();
		}
		ctx = makeInstance(ctx);
		for( c in children )
			c.makeInstanceRec(ctx);
		return ctx;
	}

	#if castle
	public function getCdbModel( ?p : Prefab ) : cdb.Sheet {
		if( p == null )
			p = this;
		if( parent != null )
			return parent.getCdbModel(p);
		return null;
	}
	#end

	public function getPrefabByName( name : String ) {
		if( this.name == name )
			return this;
		for( c in children ) {
			var p = c.getPrefabByName(name);
			if( p != null )
				return p;
		}
		return null;
	}

	public function getOpt<T:Prefab>( cl : Class<T>, ?name : String ) : T {
		var parts = name == null ? null : name.split(".");
		for( c in children ) {
			if( (name == null || c.name == name) ) {
				var cval = c.to(cl);
				if( cval != null ) return cval;
			}
			if( parts != null && parts.length > 1 && c.name == parts[0] ) {
				parts.shift();
				return c.getOpt(cl, parts.join("."));
			}
			var p = c.getOpt(cl, name);
			if( p != null )
				return p;
		}
		return null;
	}

	public function get<T:Prefab>( cl : Class<T>, ?name : String ) : T {
		var v = getOpt(cl, name);
		if( v == null )
			throw "Missing prefab " + (name == null ? Type.getClassName(cl) : (cl == null ? name : name+"(" + Type.getClassName(cl) + ")"));
		return v;
	}

	public function getAll<T:Prefab>( cl : Class<T>, ?arr: Array<T> ) : Array<T> {
		return findAll(function(p) return p.to(cl));
	}

	public function findAll<T>( f : Prefab -> Null<T>, ?arr : Array<T> ) : Array<T> {
		if(arr == null)
			arr = [];
		for( c in children ) {
			var v = f(c);
			if( v != null )
				arr.push(v);
			c.findAll(f, arr);
		}
		return arr;
	}

	public function flatten<T:Prefab>( ?cl : Class<T>, ?arr: Array<T> ) : Array<T> {
		if(arr == null)
			arr = [];
		if( cl == null )
			arr.push(cast this);
		else {
			var i = to(cl);
			if(i != null)
				arr.push(i);
		}
		for(c in children)
			c.flatten(cl, arr);
		return arr;
	}

	public function visitChildren(func: Prefab->Bool) {
		for(c in children) {
			if(func(c))
				c.visitChildren(func);
		}
	}

	public function getParent<T:Prefab>( c : Class<T> ) : Null<T> {
		var p = parent;
		while(p != null) {
			var inst = p.to(c);
			if(inst != null) return inst;
			p = p.parent;
		}
		return null;
	}

	public function to<T:Prefab>( c : Class<T> ) : Null<T> {
		return Std.instance(this, c);
	}

	public function getAbsPath() {
		var p = this;
		var path = [];
		while(p.parent != null) {
			path.unshift(p.name);
			p = p.parent;
		}
		return path.join('.');
	}

	public function getDefaultName() : String {
		if(source != null) {
			var f = new haxe.io.Path(source).file;
			f = f.split(" ")[0].split("-")[0];
			return f;
		}
		return type.split(".").pop();
	}

	public function clone() : Prefab {
		var obj = saveRec();
		return loadRec(haxe.Json.parse(haxe.Json.stringify(obj)));
	}
}
