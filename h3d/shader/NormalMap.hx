package h3d.shader;

class NormalMap extends hxsl.Shader {

    static var SRC = {

		@global var camera : {
			var position : Vec3;
			@var var dir : Vec3;
		};

        @global var global : {
            @perObject var modelView : Mat4;
        };

        @input var input : {
            var normal : Vec3;
			var tangent : Vec3;
        };

        @param var texture : Sampler2D;

        var calculatedUV : Vec2;
		var transformedPosition : Vec3;
        var transformedNormal : Vec3;

		@var var transformedTangent : Vec3;

		function vertex() {
			transformedTangent = input.tangent * global.modelView.mat3();
		}

		function fragment() {
			var n = transformedNormal;
			var nf = unpackNormal(texture.get(calculatedUV));
			var tanX = transformedTangent.normalize();
			tanX.x *= -1;
			var tanY = n.cross(tanX);
			transformedNormal = (nf.x * tanX - nf.y * tanY + nf.z * n).normalize();
        }
    };

    public function new(?texture) {
        super();
        this.texture = texture;
		h3d.Engine.getCurrent().driver.hasFeature(StandardDerivatives);
    }

}