package h3d.scene;

class Trail extends Mesh {

	// to optimize : use a proper buffer with slide window
	var points : Array<{ x : Float, y : Float, z : Float, q : h3d.Quat, t : Float }> = [];
	var dprim : h3d.prim.DynamicPrimitive;

	public var duration : Float = 0.5;
	public var angle : Float = 0.;
	public var sizeStart : Float = 4.;
	public var sizeEnd : Float = 0.;
	public var texture(get,set) : h3d.mat.Texture;

	public function new(?parent) {
		dprim = new h3d.prim.DynamicPrimitive(8);
		super(dprim, null, parent);
		material.blendMode = SoftAdd;
		material.mainPass.culling = None;
		material.mainPass.depthWrite = false;
	}

	function get_texture() return material.texture;
	function set_texture(t) return material.texture = t;

	public function save() : Dynamic {
		return {
			duration : duration,
			angle : angle,
			sizeStart : sizeStart,
			sizeEnd : sizeEnd,
			texture : texture == null ? null : texture.name,
		};
	}

	public function load( obj : Dynamic ) {
		for( f in Reflect.fields(obj) ) {
			var v : Dynamic = Reflect.field(obj, f);
			switch( f ) {
			case "texture":
				texture = v == null ? null : loadTexture(v);
			default:
				Reflect.setField(this, f, v);
			}
		}
	}

	function loadTexture( path : String ) {
		try	{
			return hxd.res.Loader.currentInstance.load(path).toTexture();
		} catch( e : hxd.res.NotFound ) {
			return h3d.mat.Texture.fromColor(0xFF00FF);
		}
	}

	override function sync(ctx) {
		super.sync(ctx);
		var curX = absPos._41;
		var curY = absPos._42;
		var curZ = absPos._43;
		var curTime = ctx.time;

		// todo : interpolate for softer curves if big step ?
		var q = new h3d.Quat();
		q.initRotateMatrix(absPos);
		points.push({ x : curX, y : curY, z : curZ, q : q, t : curTime });

		var lastTime = curTime - duration;
		while( points[0].t < lastTime )
			points.shift();

		if( points.length <= 2 ) {
			dprim.dispose();
			return;
		}

		var buffer = dprim.getBuffer((points.length - 1) * 2);
		var up = new h3d.col.Point(0, Math.sin(angle), Math.cos(angle));

		var out = 0;
		var p0 = points[0];
		dprim.bounds.empty();
		for( i in 1...points.length ) {
			var p1 = points[i];
			var delta = new h3d.col.Point(p1.x - p0.x, p1.y - p0.y, p1.z - p0.z);
			delta.normalizeFast();
			var left = up.cross(delta);
			p0.q.initRotateMatrix(absPos);
			left.transform3x3(absPos);

			var n = left.cross(delta);
			var u = (curTime - p0.t) / duration;

			left.scale( hxd.Math.lerp(sizeStart, sizeEnd, u) * 0.5 );

			buffer[out++] = p0.x - left.x;
			buffer[out++] = p0.y - left.y;
			buffer[out++] = p0.z - left.z;
			dprim.bounds.addPos(p0.x - left.x, p0.y - left.y, p0.z - left.z);

			buffer[out++] = n.x;
			buffer[out++] = n.y;
			buffer[out++] = n.z;

			buffer[out++] = u;
			buffer[out++] = 0;


			buffer[out++] = p0.x + left.x;
			buffer[out++] = p0.y + left.y;
			buffer[out++] = p0.z + left.z;
			dprim.bounds.addPos(p0.x + left.x, p0.y + left.y, p0.z + left.z);

			buffer[out++] = n.x;
			buffer[out++] = n.y;
			buffer[out++] = n.z;

			buffer[out++] = u;
			buffer[out++] = 1;
			p0 = p1;
		}


		var idx = dprim.getIndexes((points.length - 2) * 6);
		var out = 0;
		for( i in 0...points.length - 2 ) {
			var p = i * 2;
			idx[out++] = p;
			idx[out++] = p + 2;
			idx[out++] = p + 1;

			idx[out++] = p + 2;
			idx[out++] = p + 3;
			idx[out++] = p + 1;
		}

		absPos.identity();
		posChanged = true;

		dprim.flush();
	}

	override function draw(ctx:RenderContext) {
		if( points.length >= 2 ) super.draw(ctx);
	}

}