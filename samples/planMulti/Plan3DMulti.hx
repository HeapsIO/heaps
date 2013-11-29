import format.png.Data.Color;
import haxe.io.Bytes;
import hxd.BytesBuffer;
import hxd.IndexBuffer;

class PlanMultiShader extends h3d.impl.Shader {
#if flash
	static var SRC = {
		var input : {
			pos : Float3,
			color : Color, 
		};

		var vertexColor : Color;
		function vertex( mproj : Matrix , matColor : Color) {
			out = input.pos.xyzw * mproj;
			vertexColor = input.color * matColor;
		}
		
		function fragment() {
			out = vertexColor;
		}
	};
	
#elseif (js || cpp)

//
//attribute vec4 color/*byte4*/;
//attribute vec4 color;
	static var VERTEX = "
		attribute vec3 pos;
		attribute vec4 color;
		
		uniform mat4 mproj;
		uniform vec4 matColor /*byte4*/;
		
		varying vec4 vertexColor;
		
		void main(void) {
			gl_Position = mproj * vec4(pos.xyz, 1);
			//gl_Position.w = 0;
			//gl_Position = vec4(pos.xyz,1) * mproj;
			//vertexColor = matColor;
			//vertexColor = color;
			
			vertexColor.x = color.x * matColor.x;
			vertexColor.y = color.y * matColor.y;
			vertexColor.z = color.z * matColor.z;
			vertexColor.w = color.w * matColor.w;
			
		}
	";
	
	static var FRAGMENT = "
		varying vec4 vertexColor;
		void main(void) {
			gl_FragColor = vertexColor;
		}
	";
#end
}

class PlanMultiMaterial extends h3d.mat.Material{
	var sh : PlanMultiShader;

	public var matColor(get,set) : Int;
	
	public function new() {
		super(sh=new PlanMultiShader());
		depthTest = h3d.mat.Data.Compare.Always;
		matColor = 0xFFFFFFFF;
	}
	
	override function setup( ctx : h3d.scene.RenderContext ) {
		super.setup(ctx);
		sh.mproj = ctx.camera.m;
	}
	
	public inline function get_matColor() return sh.matColor;
	public inline function set_matColor(v) return sh.matColor = v;
}

//this plan should be unit
class Plan3DMulti extends h3d.prim.MeshPrimitive {
	
	public function new() {
		super();
	}

	function getPos() : Array<Float>
	{
		var a : Array<Float> = [];
		var i = 0;
		
		a[i++] = 0;
		a[i++] = 0;
		a[i++] = 0;
		
		a[i++] = 0;
		a[i++] = 1;
		a[i++] = 0;
		
		a[i++] = 1;
		a[i++] = 0;
		a[i++] = 0;
		
		a[i++] = 1;
		a[i++] = 1;
		a[i++] = 0;
		
		return a;
	}
	
	function getColorByte() : Array<Int>{
		var a :Array<Int>= [];
		var i = 0;
		
		a[i++] = 0x0;
		a[i++] = 0xFF;
		a[i++] = 0xFF;
		a[i++] = 0xFF;
		
		a[i++] = 0xFF;
		a[i++] = 0x0;
		a[i++] = 0xFF;
		a[i++] = 0xFF;
		
		a[i++] = 0xFF;
		a[i++] = 0xFF;
		a[i++] = 0x0;
		a[i++] = 0xFF;
		
		a[i++] = 0xFF;
		a[i++] = 0xFF;
		a[i++] = 0xFF;
		a[i++] = 0x0;
		
		return a;
	}
	
	function getColorFloat() : Array<Float>{
		var a :Array<Float>= [];
		var i = 0;
		
		a[i++] = 0;
		a[i++] = 1;
		a[i++] = 1;
		a[i++] = 1;
		
		a[i++] = 1;
		a[i++] = 0;
		a[i++] = 1;
		a[i++] = 1;
		
		a[i++] = 1;
		a[i++] = 1;
		a[i++] = 0;
		a[i++] = 1;
		
		a[i++] = 1;
		a[i++] = 1;
		a[i++] = 1;
		a[i++] = 0;
		
		return a;
	}
	
	override function getBounds() {
		var b = new h3d.col.Bounds();
		b.xMin = 0;
		b.xMax = 1;
		b.yMin = 0;
		b.yMax = 1;
		b.zMin = b.zMax = 0;
		return b;
	}
	
	public function getIndex()
	{
		return [ 0, 1, 2, 1, 2, 3];
	}

	override function alloc( engine : h3d.Engine ) {
		
		var pbuf = hxd.FloatBuffer.fromArray( getPos() );
		var cbufB = hxd.BytesBuffer.fromU8Array( getColorByte()); 
		var cbufF = hxd.FloatBuffer.fromArray( getColorFloat()); 
		
		//engine.mem.allocVector(pbuf, 3, 0);
		addBuffer("pos", engine.mem.allocVector(pbuf, 3, 0));
		#if flash
		addBuffer("color", engine.mem.allocBytes(cbufB.getBytes(), 1, 0 ));
		#end
		//addBuffer("pos", engine.mem.allocVector(pbuf, 4, 0));
		addBuffer("color", engine.mem.allocVector(cbufF, 4, 0 ));
		
		indexes = engine.mem.allocIndex(getIndex());
	}
	
}
