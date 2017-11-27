package hxd.fmt.s3d;

// an enum would have been better but is less JSON-friendly

@:enum abstract ObjectType(String) {
	var Object = "object";
	var Particles = "particles";
	var Trail = "trail";
	var Constraint = "constraint";
}

typedef BaseObject = {
	var type : ObjectType;
	var name : String;
	@:optional var x : Float;
	@:optional var y : Float;
	@:optional var z : Float;
	@:optional var scaleX : Float;
	@:optional var scaleY : Float;
	@:optional var scaleZ : Float;
	@:optional var rotationX : Float;
	@:optional var rotationY : Float;
	@:optional var rotationZ : Float;
	@:optional var children : Array<BaseObject>;
}

typedef ObjectProperties = {> BaseObject,
	var modelPath : String;
	@:optional var animationPath : String;
	@:optional var lock : Bool;
}

typedef ConstraintProperties = {> BaseObject,
	var source : String;
	var attach : String;
}

typedef ExtraProperties = {> BaseObject,
	var data : Dynamic;
}

typedef Data = {
	var content : Array<BaseObject>;
}
