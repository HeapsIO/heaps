package h3d.pass;

class CustomOutput extends Default {

	var outputs : Array<hxsl.Output>;

	public function new( outputs ) {
		this.outputs = outputs;
		super();
	}

	override function getOutputs() {
		return outputs;
	}

}