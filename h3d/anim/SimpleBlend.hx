package h3d.anim;

class SimpleBlend extends Transition {

	public var objectsMap : Map<String,Bool>;

	public function new( anim1 : Animation, anim2 : Animation, objects : Map < String, Bool > ) {
		super("blend", anim1, anim2);
		this.objectsMap = objects;
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
		var a = new SimpleBlend(anim1, anim2, objectsMap);
		a.anim1 = anim1.createInstance(base);
		a.anim2 = anim2.createInstance(base);
		for( o in a.anim1.objects.copy() )
			if( objectsMap.get(o.objectName) )
				a.anim1.objects.remove(o);
		for( o in a.anim2.objects.copy() )
			if( !objectsMap.get(o.objectName) )
				a.anim2.objects.remove(o);
		a.isInstance = true;
		return a;
	}

}