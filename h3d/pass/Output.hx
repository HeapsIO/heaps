package h3d.pass;

class Output extends Default {

	var outputs : Array<hxsl.Output>;

	public function new( name, outputs ) {
		this.outputs = outputs;
		super(name);
	}

	override function getOutputs() {
		return outputs;
	}

}