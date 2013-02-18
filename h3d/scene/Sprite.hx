package h3d.scene;

class DummyScene extends h2d.Sprite {
	
	override function updatePos() {
	}
	
}

class Sprite extends Object {
	
	var dummy : DummyScene;
	public var element(default,set) : h2d.Drawable;
	
	public function new(element, ?parent) {
		super(parent);
		dummy = new DummyScene();
		this.element = element;
	}
	
	function set_element(e) {
		if( element == e ) return e;
		if( element != null && element.parent == dummy ) element.remove();
		element = e;
		if( element != null ) dummy.addChild(element);
		return e;
	}
	
	@:access(h2d)
	override function draw( ctx : RenderContext ) {
		if( element == null )
			return;
		var p = new h3d.Vector(absPos._41, absPos._42, absPos._43);
		p.project(ctx.camera.m);
		element.shader.zValue = p.z;
		if( !dummy.allocated )
			dummy.onAlloc();
		// base transformation
		dummy.matA = 2 * scaleX / ctx.engine.width;
		dummy.matB = 0;
		dummy.matC = 0;
		dummy.matD = -2 * scaleY / ctx.engine.height;
		dummy.absX = p.x;
		dummy.absY = p.y;
		dummy.posChanged = true;
		// temporary enable z-compare
		var c = h2d.Tools.getCoreObjects();
		c.tmpMaterial.depthTest = LessEqual;
		dummy.render(ctx.engine);
		c.tmpMaterial.depthTest = Always;
	}
	
}