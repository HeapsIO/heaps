package h3d.pass;

class MRT extends Default {

	var fragmentOutputs : Array<String>;
	public var clearColors : Array<Null<Int>>;
	public var clearSameColor : Null<Int>;
	public var clearDepth : Null<Float>;

	public function new( fragmentOutputs, ?clearSameColor, ?clearDepth, ?clearColors ) {
		this.fragmentOutputs = fragmentOutputs;
		this.clearSameColor = clearSameColor;
		if( clearDepth ) this.clearDepth = 1.;
		this.clearColors = clearColors;
		super();
	}

	override function getOutputs() {
		var out = ["output.position"];
		for( o in fragmentOutputs )
			out.push("output." + o);
		return out;
	}

	override function draw(passes:Object) {
		var tex = [for( i in 0...fragmentOutputs.length ) tcache.allocTarget(fragmentOutputs[i], ctx, ctx.engine.width, ctx.engine.height, true)];
		if( clearColors != null )
			for( i in 0...fragmentOutputs.length ) {
				var color = clearColors[i];
				if( color != null ) {
					ctx.engine.pushTarget(tex[i]);
					ctx.engine.clear(color);
					ctx.engine.popTarget();
				}
			}
		ctx.engine.pushTargets(tex);
		if( clearDepth != null || clearSameColor != null )
			ctx.engine.clear(clearSameColor, clearDepth);
		passes = super.draw(passes);
		ctx.engine.popTarget();
		return passes;
	}

}