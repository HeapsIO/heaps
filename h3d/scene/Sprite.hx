package h3d.scene;

class DummyScene extends h2d.Sprite {
	
	override function calcAbsPos() {
	}
	
}

class Sprite extends Object {
	
	var dummy : DummyScene;
	public var depthTest : Bool;
	public var element(default, set) : h2d.Drawable;
	public var renderPass : Int;
	
	public function new(element, ?parent) {
		super(parent);
		dummy = new DummyScene();
		depthTest = true;
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
		if( renderPass > ctx.currentPass ) {
			ctx.addPass(draw);
			return;
		}
		var p = new h3d.Vector(absPos._41, absPos._42, absPos._43);
		p.transform(ctx.camera.m);
		if( p.z < 0 ) return;
		p.x /= p.w;
		p.y /= p.w;
		p.z /= p.w;
		element.shader.zValue = depthTest ? p.z : 0;
		if( !dummy.allocated )
			dummy.onAlloc();
		// base transformation
		dummy.matA = 2 * scaleX / 1024;
		dummy.matB = 0;
		dummy.matC = 0;
		dummy.matD = -2 * scaleY / 1024 * (ctx.engine.width / ctx.engine.height);
		dummy.absX = p.x;
		dummy.absY = p.y;
		dummy.posChanged = true;
		// temporary enable z-compare
		var c = h2d.Tools.getCoreObjects();
		c.tmpMaterial.depthTest = LessEqual;
		dummy.sync(ctx);
		dummy.drawRec(ctx);
		c.tmpMaterial.depthTest = Always;
	}
	
}