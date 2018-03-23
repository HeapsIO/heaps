package hxd.fmt.kframes;

// https://github.com/HeapsIO/Keyframes

abstract KFSize<T:Float>(Array<T>) {
	public var x(get, set) : T;
	public var y(get, set) : T;
	inline function get_x() return this[0];
	inline function get_y() return this[1];
	inline function set_x(v) return this[0] = v;
	inline function set_y(v) return this[1] = v;
}

@:enum abstract KFAnimProp(String) {
	var AnchorPoint = "ANCHOR_POINT";
	var XPosition = "X_POSITION";
	var YPosition = "Y_POSITION";
	var Scale = "SCALE";
	var Opacity = "OPACITY";
	var Rotation = "ROTATION";
}

typedef KFAnimValue = {
	var start_frame : Int;
	var data : Array<Float>;
}

typedef KFAnimation = {
	var property : KFAnimProp;
	var key_values : Array<KFAnimValue>;
	var timing_curves : Array<Array<KFSize<Float>>>;
}

typedef KFFeature = {
	var name : String;
	var feature_id : Int;
	var size : KFSize<Int>;
	var feature_animations : Array<KFAnimation>;
	@:optional var backed_image : String;
	@:optional var from_frame : Int;
	@:optional var to_frame : Int;
}

typedef KeyframesFile = {
	var formatVersion : String;
	var name : String; // COMP
	var key : Int;
	var frame_rate : Float;
	var animation_frame_count : Int;
	var canvas_size : KFSize<Int>;
	var features : Array<KFFeature>;
	var animation_groups : Array<{}>; // TODO
}

