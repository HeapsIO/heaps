package h3d.scene;

class RenderContext {
	public var engine : h3d.Engine;
	public var camera : h3d.Camera;
	var passes : Array<RenderContext -> Void>;
	
	public function new(e, c) {
		this.engine = e;
		this.camera = c;
	}
	
	public function addPass(p) {
		if( passes == null ) passes = [];
		passes.push(p);
	}
	
	public function finalize() {
		var old = passes;
		while( old != null ) {
			passes = null;
			for( p in old )
				p(this);
			old = passes;
		}
	}
	
}