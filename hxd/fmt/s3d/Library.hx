package hxd.fmt.s3d;
import hxd.fmt.s3d.Data;

class Library {

	public var data : Data;
	var cache : h3d.prim.ModelCache;

	public function new( ?cache ) {
		this.cache = cache;
		if( this.cache == null ) this.cache = new h3d.prim.ModelCache();
		data = { content : [] };
	}

	public function load( content : Dynamic ) {
		data = content;
	}

	public function save() {
		return data;
	}

	public function makeInstance() {
		var root = new h3d.scene.Object();
		for( c in data.content )
			makeObject(c, root);
		return root;
	}

	public function makeObject( o : BaseObject, ?parent : h3d.scene.Object ) {
		var obj = initObject(o, parent);
		if( obj == null )
			return null;
		obj.name = o.name;
		if( o.x != null ) obj.x = o.x;
		if( o.y != null ) obj.y = o.y;
		if( o.z != null ) obj.z = o.z;
		if( o.scaleX != null ) obj.scaleX = o.scaleX;
		if( o.scaleY != null ) obj.scaleY = o.scaleY;
		if( o.scaleZ != null ) obj.scaleZ = o.scaleZ;
		obj.setRotate(o.rotationX == null ? 0 : o.rotationX, o.rotationY == null ? 0 : o.rotationY, o.rotationZ == null ? 0 : o.rotationZ);
		if( parent != null )
			parent.addChild(obj);
		if( o.children != null ) {
			for( c in o.children )
				makeObject(c, obj);
		}
		return obj;
	}

	function initObject( o : BaseObject, ?parent : h3d.scene.Object ) : h3d.scene.Object {
		switch( o.type ) {
		case Object:
			var p : ObjectProperties = cast o;
			var obj = loadModel(p.modelPath);
			if( p.animationPath != null ) {
				var a = obj.playAnimation(loadAnimation(p.animationPath));
			}
			return obj;
		case Constraint:
			var root = parent;
			while( root != null && root.parent != null )
				root = root.parent;
			var p : ConstraintProperties = cast o;
			if( root != null ) {
				var obj = root.getObjectByName(p.source.split(".").pop());
				if( obj != null ) obj.follow = root.getObjectByName(p.attach.split(".").pop());
			}
			return null;
		case Particles:
			var p : ExtraProperties = cast o;
			var obj = new h3d.parts.GpuParticles();
			obj.load(p.data);
			return obj;
		case Trail:
			var p : ExtraProperties = cast o;
			var obj = new h3d.scene.Trail();
			obj.load(p.data);
			return obj;
		}
	}

	function loadModel( path : String ) : h3d.scene.Object {
		return cache.loadModel(hxd.res.Loader.currentInstance.load(path).toModel());
	}

	function loadAnimation( path : String ) : h3d.anim.Animation {
		return cache.loadAnimation(hxd.res.Loader.currentInstance.load(path).toModel());
	}

}