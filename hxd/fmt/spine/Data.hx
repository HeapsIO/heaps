package hxd.fmt.spine;

class Bone {

	public var name : String;
	public var parent : Bone;
	public var childs : Array<Bone>;

	public var x : Float;
	public var y : Float;
	public var rotation : Float;
	public var scaleX : Float;
	public var scaleY : Float;
	public var length : Float;

	public var flipX : Bool;
	public var flipY : Bool;
	public var inheritScale : Bool;
	public var inheritRotation : Bool;

	public function new() {
		childs = [];
	}

}

class Slot {

	public var name : String;
	public var bone : Bone;
	public var attachment : String;
	public var color : h3d.Vector;
	public var blendMode : h2d.BlendMode;

	public function new() {
		color = new h3d.Vector(1, 1, 1, 1);
	}
}

class Attachment {
	public var skin : Skin;
	public var slot : Slot;
	public var color : h3d.Vector;
	public function new() {
		color = new h3d.Vector(1, 1, 1, 1);
	}
}

class RegionAttachment extends Attachment {
	public var width : Float;
	public var height : Float;
}

class SkinnedVertice {
	public var u : Float;
	public var v : Float;
	public var vx0 : Float;
	public var vy0 : Float;
	public var vw0 : Float;
	public var vx1 : Float;
	public var vy1 : Float;
	public var vw1 : Float;
	public var vx2 : Float;
	public var vy2 : Float;
	public var vw2 : Float;
	public var bone0 : Bone;
	public var bone1 : Bone;
	public var bone2 : Bone;
	public function new() {
	}
}

class SkinnedMeshAttachment extends Attachment {
	public var vertices : Array<SkinnedVertice> = [];
	public var triangles : Array<Int>;
}

class Skin {
	public var name : String;
	public var attachments : Array<Attachment>;
	public function new() {
		attachments = [];
	}
}

class AnimationCurve {
	public function new() {
	}
}

class BoneCurve extends AnimationCurve {
	public var bone : Bone;
	public var translate : haxe.ds.Vector<Float>;
	public var scale : haxe.ds.Vector<Float>;
	public var rotate : haxe.ds.Vector<Float>;
	public function new(bone) {
		super();
		this.bone = bone;
	}
}

class Animation {
	public var name : String;
	public var curves : Array<AnimationCurve>;
	public function new() {
		curves = [];
	}
}
