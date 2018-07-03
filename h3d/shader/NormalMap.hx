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

		@var var transformedTangent : Vec4;

		function __init__vertex() {
			transformedTangent = vec4(input.tangent * global.modelView.mat3(),input.tangent.dot(input.tangent) > 0.5 ? 1. : -1.);
		}

		function fragment() {
			var n = transformedNormal;
			var nf = unpackNormal(texture.get(calculatedUV));
			var tanX = transformedTangent.xyz.normalize();
			var tanY = n.cross(tanX) * -transformedTangent.w;
			transformedNormal = (nf.x * tanX + nf.y * tanY + nf.z * n).normalize();
		}

     };

    public function new(?texture) {
        super();
        this.texture = texture;
    }

}