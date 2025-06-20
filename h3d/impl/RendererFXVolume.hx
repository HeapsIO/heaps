package h3d.impl;

enum Shape {
	Sphere(radius : Float);
	Box(width : Float, height: Float);
}

class RendererFXVolume extends h3d.scene.Object {
	public var priority : Int;
	public var innerShape : Shape;
	public var outerShape : Shape;
	public var effects : Array<h3d.impl.RendererFX> = [];

	var factor : Float = 0.;
	var cam : h3d.Camera;

	public function new(?parent : h3d.scene.Object) {
		super(parent);
		this.innerShape = Sphere(1);
		this.outerShape = Sphere(1);
	}

	override function sync(ctx : h3d.scene.RenderContext) {
		super.sync(ctx);

		#if !editor
		if (effects == null) return;
		factor = getFactor(ctx.camera.pos);
		var renderer = ctx.scene.renderer;
		if (factor > 0 && !renderer.volumeEffects.contains(this))
			renderer.volumeEffects.push(this);

		if (factor <= 0 && !renderer.volumeEffects.contains(this))
			renderer.volumeEffects.remove(this);
		#end
	}

	override function onRemove() {
		super.onRemove();
		var renderer = getScene().renderer;
		if (renderer == null) return;
		renderer.volumeEffects.remove(this);
	}

	public function getFactor(pos : h3d.col.Point) : Float {
		var distance = (getAbsPos().getPosition() - pos).length();

		switch ([innerShape, outerShape]) {
			case [Sphere(r1), Sphere(r2)]:
				if (distance < r1) return 1;
				if (distance > r2) return 0;
				return 1 - hxd.Math.clamp((distance - r1) / (r2 - r1), 0, 1);
			default:
				return 0.;
		}
	}
}
