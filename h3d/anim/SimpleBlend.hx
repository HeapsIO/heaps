package h3d.anim;

class SimpleBlend extends Transition {

	public var objectsMap : Map<String,Bool>;

	public function new( anim1 : Animation, anim2 : Animation, objects : Map < String, Bool > ) {
		super("blend", anim1, anim2);
		this.objectsMap = objects;
		if( anim1.isInstance && anim2.isInstance )
			setupInstance();
	}

	function setupInstance() {
		for( o in anim1.objects.copy() )
			if( objectsMap.get(o.objectName) )
				anim1.unbind(o.objectName);
		for( o in anim2.objects.copy() )
			if( !objectsMap.get(o.objectName) )
				anim2.unbind(o.objectName);
		isInstance = true;
	}

	override function clone(?a : Animation) : Animation {
		var a : SimpleBlend = cast a;
		if( a == null )
			a = new SimpleBlend(anim1, anim2, objectsMap);
		super.clone(a);
		a.objectsMap = objectsMap;
		return a;
	}

	override function createInstance( base ) {
		return new SimpleBlend(anim1.createInstance(base), anim2.createInstance(base), objectsMap);
	}

}