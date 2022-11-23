package h3d.impl;

enum Step {
	MainDraw;
	Decals;
	Shadows;
	Lighting;
	Forward;
	BeforeTonemapping;
	AfterTonemapping;
	Overlay;
	Custom( name : String );
}

interface RendererFX {
	public var enabled : Bool;
	public function begin( r : h3d.scene.Renderer, step : Step ) : Void;
	public function end( r : h3d.scene.Renderer, step : Step ) : Void;
	public function dispose() : Void;
}
