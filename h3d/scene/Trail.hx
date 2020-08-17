package h3d.scene;

private class TrailElement {
	public var q : h3d.Quat;
	public var x : Float;
	public var y : Float;
	public var z : Float;
	public var t : Float;
	public var size : Float;
	public function new() {
	}
}

class Trail extends Mesh {

	// to optimize : use a proper buffer with slide window
	var points : Array<TrailElement> = [];
	var dprim : h3d.prim.DynamicPrimitive;

	public var duration : Float = 0.5;
	public var angle : Float = 0.;
	public var sizeStart : Float = 4.;
	public var sizeEnd : Float = 0.;
	public var movementMin : Float = 0.1;
	public var movementMax : Float = 0.5;
	public var smoothness : Float = 0.5;
	public var materialData = {};

	public var texture(get, set) : h3d.mat.Texture;
	var pending = new TrailElement(); // tmp

	public function new(?parent) {
		dprim = new h3d.prim.DynamicPrimitive(8);
		super(dprim, null, parent);
		material.props = getMaterialProps();
		material.mainPass.dynamicParameters = true;
	}

	function get_texture() return material.texture;
	function set_texture(t) return material.texture = t;

	public function getMaterialProps() {
		var name = h3d.mat.MaterialSetup.current.name;
		var p = Reflect.field(materialData, name);
		if( p == null ) {
			p = h3d.mat.MaterialSetup.current.getDefaults("trail3D");
			Reflect.setField(materialData, name, p);
		}
		return p;
	}

	public function clear() {
		if( points.length > 0 ) points = [];
	}

	public function save() : Dynamic {
		return {
			duration : duration,
			angle : angle,
			sizeStart : sizeStart,
			sizeEnd : sizeEnd,
			texture : texture == null ? null : texture.name,
			movementMin : movementMin,
			movementMax : movementMax,
			smoothness : smoothness,
			material : materialData,
		};
	}

	public function load( obj : Dynamic ) {
		for( f in Reflect.fields(obj) ) {
			var v : Dynamic = Reflect.field(obj, f);
			switch( f ) {
			case "texture":
				texture = v == null ? null : loadTexture(v);
			case "material":
				materialData = v;
				material.props = getMaterialProps();
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
		if( ctx.elapsedTime == 0 || (!ctx.visibleFlag && !alwaysSync) )
			return;

		var curX = absPos._41;
		var curY = absPos._42;
		var curZ = absPos._43;
		var curTime = ctx.time;

		if( pending.size != 0 && points.length == 0 )
			pending.size = 0;

		if( pending.size != 0 ) {

			// http://scaledinnovation.com/analytics/splines/aboutSplines.html

			var prev = points[points.length - 1];

			var x0 = prev.x;
			var y0 = prev.y;
			var z0 = prev.z;

			var x1 = pending.x;
			var y1 = pending.y;
			var z1 = pending.z;

			var x2 = curX;
			var y2 = curY;
			var z2 = curZ;

			var d01 = hxd.Math.distance(x1 - x0, y1 - y0, z1 - z0);
			var d12 = hxd.Math.distance(x2 - x1, y2 - y1, z2 - z1);

			var fa = smoothness * d01 / (d01 + d12);
			var cx = x1 - fa * (x2 - x0);
			var cy = y1 - fa * (y2 - y0);
			var cz = z1 - fa * (z2 - z0);

			var dist = d01;
			var k = Math.ceil(dist / movementMax);
			if( k > 20 ) k = 20; // max splitting

			for( i in 0...k ) {
				var v = (i + 1) / k;
				var q2 = new h3d.Quat();
				q2.slerp(prev.q, pending.q, v);
				q2.normalize();

				// bezier
				var b0 = (1 - v) * (1 - v);
				var b1 = 2 * v * (1 - v);
				var b2 = v * v;

				var e = new TrailElement();
				e.x = x0 * b0 + cx * b1 + x1 * b2;
				e.y = y0 * b0 + cy * b1 + y1 * b2;
				e.z = z0 * b0 + cz * b1 + z1 * b2;
				e.t = hxd.Math.lerp(prev.t, pending.t, v);
				e.size = 1;
				e.q = q2;
				points.push(e);
			}
			pending.size = 0;
		}


		var prev = points[points.length - 1];
		var q = new h3d.Quat();
		q.initRotateMatrix(absPos);
		var dist = prev == null ? 0 : hxd.Math.distanceSq(prev.x - curX, prev.y - curY, prev.z - curZ);
		var e = null;
		if( dist < movementMax * movementMax ) {
			/*
                if we have [0,0,X] sizes points, we don't need to keep pushing 0 sized points, simply replace the latest
            */
            if( prev != null && prev.size == 0 && points.length > 2 && points[points.length - 2].size == 0 && dist < movementMin * movementMin )
                e = prev;
            else {
                e = new TrailElement();
                e.size = prev == null || dist > movementMin * movementMin ? 1 : 0;
                points.push(e);
            }
		} else {
			e = pending;
			e.size = 1;
		}

		e.x = curX;
		e.y = curY;
		e.z = curZ;
		e.t = curTime;
		e.q = q;

		var lastTime = curTime - duration;
		while( points.length > 0 && points[0].t < lastTime && (points.length > 1 || pending.size != 0) )
			points.shift();

		if( points.length <= 2 ) {
			dprim.dispose();
			return;
		}

		var buffer = dprim.getBuffer((points.length - 1) * 2);
		var up = new h3d.col.Point(0, Math.sin(angle), Math.cos(angle));

		var out = 0;
		var p0 = points[0];
		var delta = new h3d.col.Point(1, 0, 0);
		var leftSave = up.cross(delta);
		var left = new h3d.col.Point();
		dprim.bounds.empty();
		for( i in 1...points.length ) {
			var p1 = points[i];
			var dist2 = hxd.Math.distanceSq(p1.x - p0.x, p1.y - p0.y, p1.z - p0.z);
			left.load(leftSave);
			p0.q.toMatrix(absPos);
			left.transform3x3(absPos);

			var n = left.cross(delta);
			var u = (curTime - p0.t) / duration;

			var size = hxd.Math.lerp(sizeStart, sizeEnd, u) * 0.5 * p1.size;
			left.scale(size);

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

		var reservePoints = Math.ceil(duration * hxd.Timer.wantedFPS);
		dprim.minVSize = hxd.Math.nextPOT(reservePoints * 2);
		dprim.minISize = hxd.Math.nextPOT(reservePoints * 6);

		dprim.flush();
	}

	override function draw(ctx:RenderContext) {
		if( points.length >= 2 ) {
			absPos.identity();
			posChanged = true;
			ctx.uploadParams();
			super.draw(ctx);
		}
	}

}