package h3d.scene;

private class ImageShader extends h3d.impl.Shader {
	#if flash
	static var SRC = {
		var input : {
			pos : Float2,
			uv : Float2,
		};
		var tuv : Float2;
		function vertex() {
			out = input.pos.xyzw;
			tuv = input.uv;
		}
		function fragment( tex : Texture ) {
			out = tex.get(tuv);
		}
	}
	#elseif (js || cpp)
	static var VERTEX = "TODO";
	static var FRAGMENT = "TODO";
	public var tex : h3d.mat.Texture;
	#end
}

class Image extends Object {

	public var material : h3d.mat.Material;
	public var tile : h2d.Tile;
	
	public function new( ?tile, ?parent) {
		super(parent);
		material = new h3d.mat.Material(new ImageShader());
		material.depth(false, Always);
		material.culling = None;
		this.tile = tile;
	}
	
	@:access(h2d.Tile)
	override function draw( ctx : RenderContext ) {
		var tmp = new hxd.FloatBuffer();
		var dx = absPos._41 * 2 / ctx.engine.width;
		var dy = -absPos._42 * 2 / ctx.engine.height;
		if( tile == null )
			tile = new h2d.Tile(null, 0, 0, 0, 0);
		tmp.push(-1 * absPos._11 - 1 * absPos._21 + dx);
		tmp.push(1 * absPos._12 + 1 * absPos._22 + dy);
		tmp.push(tile.u);
		tmp.push(tile.v);

		tmp.push(1 * absPos._11 + 1 * absPos._21 + dx);
		tmp.push(1 * absPos._12 + 1 * absPos._22 + dy);
		tmp.push(tile.u2);
		tmp.push(tile.v);

		tmp.push(-1 * absPos._11 - 1 * absPos._21 + dx);
		tmp.push(-1 * absPos._12 - 1 * absPos._22 + dy);
		tmp.push(tile.u);
		tmp.push(tile.v2);

		tmp.push(1 * absPos._11 - 1 * absPos._21 + dx);
		tmp.push(1 * absPos._12 - 1 * absPos._22 + dy);
		tmp.push(tile.u2);
		tmp.push(tile.v2);
		
		cast(material.shader,ImageShader).tex = tile.getTexture();
		var b = h3d.Buffer.ofFloats(tmp,4,[Quads,Dynamic]);
		ctx.engine.selectMaterial(material);
		ctx.engine.renderQuadBuffer(b);
		b.dispose();
	}
	
}