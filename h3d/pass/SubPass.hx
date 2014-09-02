package h3d.pass;

class SubPass extends Base {

	var sub : Base;

	public function new( sub : Base, priority, forceProcessing = false ) {
		super();
		this.sub = sub;
		this.priority = priority;
		this.forceProcessing = forceProcessing;
	}

	override function setContext( ctx ) {
		sub.setContext(ctx);
	}

	override function compileShader(pass) {
		return sub.compileShader(pass);
	}

	override function draw(name, passes) {
		return sub.draw(name, passes);
	}

	override function getLightSystem() {
		return sub.getLightSystem();
	}

	override function dispose() {
		sub.dispose();
	}

}