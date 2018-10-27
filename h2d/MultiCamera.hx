package h2d;

class MultiCamera extends Camera {

	var cameras : Array<Camera>;

	public function new( ?scene : h2d.Scene ) {
		super(scene);
		cameras = new Array();
	}

}