package h3d.prim;

import h3d.col.Point;

class Disc extends Polygon {

	public var radius(default,null) : Float;
	public var segments(default,null) : Int;

	public function new( radius = 0.5, segments = 8, thetaStart = 0.0, ?thetaLength : Float ) {
		if( segments < 3 ) segments = 3;
		if( thetaLength == null ) thetaLength = Math.PI * 2;
		this.radius = radius;
		this.segments = segments;
		var pts = [], idx = new hxd.IndexBuffer();
		for( i in 0...segments ) {
			var a = thetaStart + i / segments * thetaLength;
			pts.push(new Point( radius * Math.cos(a), radius * Math.sin(a), 0 ));
			idx.push(i);
			idx.push((i == segments - 1) ? 0 : i + 1);
			idx.push(segments);
		}
		pts.push( new Point() );
		super( pts, idx );
	}

	override function addUVs() {
		uvs = [];
		for( i in 0...segments ) {
			uvs.push( new UV( (points[i].x / radius + 1) / 2, (points[i].y / radius + 1) / 2) );
		}
		uvs.push( new UV( 0.5, 0.5 ) );
	}

	/**
	 * Get a default unit Disc with 
	 * radius = 0.5, segments = 8, thetaStart = 0.0, thetaLength = Math.PI * 2
	 * and add UVs to it. If it has not be cached, it is cached and subsequent
	 * calls to this method will return Disc from cache.
	 */
	public static function defaultUnitDisc() {
		var engine = h3d.Engine.getCurrent();
		var d : Disc = @:privateAccess engine.resCache.get(Disc);
		if( d != null )
			return d;
		d = new h3d.prim.Disc();
		d.addUVs();
		@:privateAccess engine.resCache.set(Disc, d);
		return d;
	}

}
