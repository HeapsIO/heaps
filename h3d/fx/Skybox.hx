package h3d.fx;
import h3d.mat.Data;

class Skybox extends hxsl.Shader {
	
	static var SRC = {
		var input : {
			pos : Float3
		};
		var tuv : Float3;
		function vertex( mproj : M44 ) {
			out = pos.xyzw * mproj;
			tuv = pos;
		}
		function fragment( texture : CubeTexture ) {
			out = texture.get(tuv, nearest);
		}
	};

	var obj : h3d.Drawable<Skybox>;
	
	public function new(tex) {
		super();
		this.texture = tex;
		var prim = new h3d.prim.Cube(2, 2, 2);
        prim.translate( -1, -1, -1);
		obj = new h3d.Drawable(prim, this);
		obj.material.depth(false, Compare.Always);
		obj.material.culling = Face.Front;
	}
	
	public function render( engine : h3d.Engine, camera : h3d.Camera, ?pos : h3d.Matrix ) {
        var size = camera.zFar / Math.sqrt(3);
        var m;
        if( pos == null ) {
        	m = new h3d.Matrix();
        	m.identity();
        } else
        	m = pos.copy();
        m.scale(size, size, size);
        m.translate(camera.pos.x, camera.pos.y, camera.pos.z);
        m.add(camera.m);
		mproj = m;
		obj.render(engine);
	}
	
}
