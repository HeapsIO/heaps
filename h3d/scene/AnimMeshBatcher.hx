package h3d.scene;

class AnimMeshBatchShader extends hxsl.Shader {
	static var SRC = {
		@param var animationMatrix : Mat4;

		@global var global : {
			@perObject var modelView : Mat4;
		};

		@input var input : {
			var normal : Vec3;
		};

		var relativePosition : Vec3;
		var transformedNormal : Vec3;
		function vertex() {
			relativePosition = relativePosition * animationMatrix.mat3x4();
			transformedNormal = (input.normal * animationMatrix.mat3() * global.modelView.mat3()).normalize();
		}
	};
}

class AnimMeshBatch extends MeshBatch {
	var copyObject : Object;
	var shader : AnimMeshBatchShader;

	public function new(primitive, material, copyObject, ?parent) {
		super(primitive, material, parent);
		shader = new AnimMeshBatchShader();
		material.mainPass.addShader(shader);
		this.copyObject = copyObject;
	}
	override function sync(ctx : RenderContext) {
		super.sync(ctx);
		shader.animationMatrix = copyObject.defaultTransform;
	}
}

class AnimMeshBatcher extends Object {
	var originalObject : Object;

	var batches : Array<MeshBatch> = [];
	public function new(object : h3d.scene.Object, resetSpawn : Void -> Void, spawn : h3d.Matrix -> Bool, ?parent) {
		super(parent);
		originalObject = object;
		addChild(originalObject);
		originalObject.alwaysSyncAnimation = true;
		originalObject.visible = false;
		for ( m in originalObject.getMeshes() ) {
			var mat : h3d.mat.Material = cast m.material.clone();
			var batch = new AnimMeshBatch(cast(m.primitive,h3d.prim.MeshPrimitive), mat, m, this);
			batch.begin();
			batches.push(batch);
		}

		var tmp = new h3d.Matrix();
		for ( b in batches ) {
			tmp.zero();
			resetSpawn();
			while ( spawn(tmp) ) {
				b.worldPosition = tmp;
				b.emitInstance();
			}
		}
	}

	override function playAnimation(anim : h3d.anim.Animation) {
		return originalObject.playAnimation(anim);
	}
}