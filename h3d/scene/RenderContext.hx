package h3d.scene;

class RenderContext {
	public var engine : h3d.Engine;
	public var camera : h3d.Camera;
	public var time : Float;
	public var elapsedTime : Float;
	public var currentPass : Int;
	public var frame : Int;
	var passes : Array<RenderContext -> Void>;
	
	public function new() {
		time = 0.;
		elapsedTime = 1. / flash.Lib.current.stage.frameRate;
	}
	
	public function addPass(p) {
		if( passes == null ) passes = [];
		passes.push(p);
	}
	
	public function finalize() {
		var old = passes;
		while( old != null ) {
			passes = null;
			currentPass++;
			for( p in old )
				p(this);
			old = passes;
		}
	}
	
}