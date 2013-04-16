package h3d.anim;

class SimpleBlend extends Animation {
	
	public var anim1 : Animation;
	public var anim2 : Animation;
	public var objectsMap : Map<String,Bool>;
	var anim1FrameDelta : Float = 0.;
	var anim2FrameDelta : Float = 0.;
	
	public function new( anim1 : Animation, anim2 : Animation, objects : Map < String, Bool > ) {
		var r1 = 1, r2 = 1;
		while( true ) {
			var d = anim1.frameCount * r1 - anim2.frameCount * r2;
			if( d == 0 ) break;
			if( d < 0 ) r1++ else r2++;
		}
		super("blend("+anim1.name+","+anim2.name+")",anim1.frameCount * r1, anim1.sampling);
		this.anim1 = anim1;
		this.anim2 = anim2;
		this.objectsMap = objects;
	}
	
	override function setFrame( f : Float ) {
		super.setFrame(f);
		anim1.setFrame((frame + anim1FrameDelta) % anim1.frameCount);
		anim2.setFrame((frame + anim2FrameDelta) % anim2.frameCount);
	}
	
	public function setFrameDeltas( anim1 : Float, anim2 : Float ) {
		anim1FrameDelta = anim1;
		anim2FrameDelta = anim2;
		setFrame(frame);
	}
	
	override function clone(?a : Animation) : Animation {
		if( a == null )
			a = new SimpleBlend(anim1, anim2, objectsMap);
		var a : SimpleBlend = cast a;
		a.anim1FrameDelta = anim1FrameDelta;
		a.anim2FrameDelta = anim2FrameDelta;
		super.clone(a);
		return a;
	}
	
	override function createInstance( base ) {
		var a = new SimpleBlend(anim1, anim2, objectsMap);
		a.anim1 = anim1.createInstance(base);
		a.anim2 = anim2.createInstance(base);
		a.anim1FrameDelta = anim1FrameDelta;
		a.anim2FrameDelta = anim2FrameDelta;
		a.anim1.setFrame(anim1FrameDelta % anim1.frameCount);
		a.anim2.setFrame(anim2FrameDelta % anim2.frameCount);
		for( o in a.anim1.objects.copy() )
			if( objectsMap.get(o.objectName) )
				a.anim1.objects.remove(o);
		for( o in a.anim2.objects.copy() )
			if( !objectsMap.get(o.objectName) )
				a.anim2.objects.remove(o);
		a.isInstance = true;
		return a;
	}

	override function sync() {
		anim1.sync();
		anim2.sync();
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
	
}