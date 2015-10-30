package hxd.fmt.spine;
import haxe.DynamicAccess;

typedef JCurve = haxe.ds.Either<String,Array<Float>>; // "stepped" | "linear" | [b1,b2,b3,b4] (bezier factors)

typedef JBoneAnimation = {
	@:optional var rotate : Array<{ time : Float, angle : Float, ?curve : JCurve }>;
	@:optional var scale : Array<{ time : Float, x : Float, y : Float, ?curve : JCurve }>;
	@:optional var translate : Array<{ time : Float, x : Float, y : Float, ?curve : JCurve }>;
	@:optional var flipX : Array<{ time : Float, x : Bool }>;
	@:optional var flipY : Array<{ time : Float, y : Bool }>;
}

typedef JAnimation = {
	@:optional var bones : DynamicAccess<JBoneAnimation>;
	@:optional var slots : Dynamic;
	@:optional var ik : Dynamic;
	@:optional var ffd : Dynamic;
	@:optional var drawOrder : Dynamic;
	@:optional var events : Dynamic;
}

typedef JBone = {
	var color : String;
	var name : String;
	@:optional var x : Float;
	@:optional var y : Float;
	@:optional var scaleX : Float;
	@:optional var scaleY : Float;
	@:optional var rotation : Float;
	@:optional var length : Float;
	@:optional var parent : String;
	@:optional var flipX : Bool;
	@:optional var flipY : Bool;
	@:optional var inheritScale : Bool;
	@:optional var inheritRotation : Bool;
}

typedef JSkeleton = {
	var hash : String;
	var width : Float;
	var height : Float;
	var images : String;
	var spine : String; // version
}

typedef JAttachment = {
	?type : String,
	?color : String,
};

typedef JRegionAttach = { > JAttachment,
	var width : Float;
	var height : Float;
	@:optional var x : Float;
	@:optional var y : Float;
	@:optional var rotation : Float;
	@:optional var scaleX : Float;
	@:optional var scaleY : Float;
};

typedef JSkinMeshAttach = { >JAttachment,
	var width : Int;
	var height : Int;
	var hull : Int;
	var edges : Array<Int>;
	var triangles : Array<Int>;
	var uvs : Array<Float>;
	var vertices : Array<Float>;
}

typedef JSkin = DynamicAccess<DynamicAccess<JAttachment>>;

typedef JSlot = {
	var name : String;
	var attachment : String;
	var body : String;
	@:optional var blend : String;
	@:optional var color : String;
}

typedef JsonData = {
	var animations : DynamicAccess<JAnimation>;
	var bones : Array<JBone>;
	var ik : Dynamic;
	var skeleton : JSkeleton;
	var skins : DynamicAccess<JSkin>;
	var slots : Array<JSlot>;
}
