package h3d.impl;

enum Step {
	BeforeLighting;
	BeforeTonemapping;
	AfterTonemapping;
	AfterUI;
}

interface RendererFX {
	public var enabled : Bool;
	public function apply( r : h3d.scene.Renderer, step : Step ) : Void;
	public function dispose() : Void;
}
