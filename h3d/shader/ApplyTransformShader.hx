package h3d.shader;

class ApplyTransformShader extends hxsl.Shader {
	static var SRC = {
		@const var IS_LOCAL : Bool = false;

		@param var invTransform : Mat4;
		@param var transform : Mat4;
		@param var prevTransform : Mat4;

		var modelView : Mat4;
		var modelViewInverse : Mat4;
		var prevModelView : Mat4;

		function __init__() {
			if(IS_LOCAL) {
				modelView = transform * modelView;
				modelViewInverse = modelViewInverse * invTransform;
				prevModelView = prevTransform * prevModelView;
			} else {
				modelView = modelView * transform;
				modelViewInverse = invTransform * modelViewInverse;
				prevModelView = prevModelView * prevTransform;
			}
		}
	};
}
