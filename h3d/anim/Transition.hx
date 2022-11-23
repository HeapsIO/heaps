package h3d.anim;

class Transition extends Animation {

	public var anim1 : Animation;
	public var anim2 : Animation;

	public function new( transitionName : String, anim1 : Animation, anim2 : Animation ) {
		var r1 = 1, r2 = 1;
		while( true ) {
			var d = anim1.frameCount * r1 - anim2.frameCount * r2;
			if( d == 0 ) break;
			if( d < 0 ) r1++ else r2++;
		}
		super(transitionName+"("+anim1.name+","+anim2.name+")",anim1.frameCount * r1, anim1.sampling);
		this.anim1 = anim1;
		this.anim2 = anim2;
	}

	override function unbind( objectName : String ) {
		super.unbind(objectName);
		anim1.unbind(objectName);
		anim2.unbind(objectName);
	}

	override function setFrame( f : Float ) {
		super.setFrame(f);
		anim1.setFrame(frame % anim1.frameCount);
		anim2.setFrame(frame % anim2.frameCount);
	}

	override function clone(?a : Animation) : Animation {
		var a : Transition = cast a;
		if( a == null )
			a = new Transition(this.name.split("(")[0], anim1, anim2);
		super.clone(a);
		a.anim1 = anim1.clone();
		a.anim2 = anim2.clone();
		return a;
	}

	override function sync( decompose : Bool = false ) {
		if( decompose )
			throw "Decompose not supported on transition";
		anim1.isSync = anim2.isSync = false;
		anim1.sync();
		anim2.sync();
	}

	override function bind(base) {
		anim1.bind(base);
		anim2.bind(base);
	}

	override function update(dt:Float) {
		var rt = super.update(dt);
		var st = dt - rt;
		var tmp = st;
		while( tmp > 0 )
			tmp = anim1.update(tmp);
		var tmp = st;
		while( tmp > 0 )
			tmp = anim2.update(tmp);
		return rt;
	}

	#if !(dataOnly || macro)
	override function initAndBind( obj : h3d.scene.Object ) {
		super.initAndBind(obj);
		anim1.initAndBind(obj);
		anim2.initAndBind(obj);
	}
	#end

}
