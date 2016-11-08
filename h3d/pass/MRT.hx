package h3d.pass;

@:access(h3d.pass.MRT)
class MRTSubPass extends Default {

	var mrt : MRT;
	var output : Int;
	var varId : Int;

	public function new( m, output ) {
		this.mrt = m;
		this.output = output;
		super();
		this.varId = hxsl.Globals.allocID(mrt.fragmentOutputs[output] + "Map");
	}

	override function getOutputs() {
		return ["output.position", "output."+mrt.fragmentOutputs[output]];
	}

	override function getTexture( index = 0 ) {
		return index == 0 ? mrt.getTexture(output) : null;
	}

	override function draw( passes ) {
		if( ctx == null )
			ctx = mrt.ctx;
		var texture = mrt.getTexture(output);
		if( passes != null ) {
			ctx.engine.pushTarget(texture);
			passes = super.draw(passes);
			ctx.engine.popTarget();
		}
		ctx.setGlobalID(varId, texture);
		return passes;
	}

}

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

	public function getSubPass( output : Int ) {
		var s = new MRTSubPass(this, output);
		s.setContext(ctx);
		return s;
	}

	public function drawImmediate( passes : Object ) {
		return super.draw(passes);
	}

}