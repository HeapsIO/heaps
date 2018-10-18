package h3d.scene.pbr.terrain;

class Terrain extends Object {

	public var tileSize : Float;
	public var cellSize : Float;
	public var cellCount : Int;
	public var heightMapResolution : Int;
	public var weightMapResolution : Int;
	public var showGrid : Bool;
	public var showChecker : Bool;
	public var showComplexity : Bool;
	public var parallaxAmount : Float;
	public var parallaxMinStep : Int;
	public var parallaxMaxStep : Int;
	public var heightBlendStrength : Float;
	public var heightBlendSharpness : Float;
	public var copyPass (default, null): h3d.pass.Copy;
	public var tiles (default, null) : Array<Tile> = [];
	public var surfaces (default, null) : Array<Surface> = [];
	public var surfaceArray (default, null) : h3d.scene.pbr.terrain.Surface.SurfaceArray;

	public function new(?parent){
		super(parent);
		copyPass = new h3d.pass.Copy();
	}

	public function getHeight(pos : h3d.Vector) : Float {
		var z = 0.0;
		var t = getTileAtWorldPos(pos);
		if(t != null){
			var pos = t.globalToLocal(pos.clone());
			z = t.getHeight(pos.x / tileSize, pos.y / tileSize);
		}
		return z;
	}

	public function getSurface(i : Int) : Surface{
		if(i < surfaces.length)
				return surfaces[i];
		return null;
	}

	public function getSurfaceFromTex(albedo, ?normal, ?pbr) : Surface{
		for(s in surfaces){
			var valid = false;
			valid = s.albedo.name == albedo;
			valid = valid && !(normal != null && s.normal.name != normal);
			valid = valid && !(pbr != null && s.pbr.name != pbr);
			if(valid) return s;
		}
		return null;
	}

	public function addSurface(albedo, normal, pbr) : Surface {
		surfaces.push(new Surface(albedo, normal, pbr));
		return surfaces[surfaces.length - 1];
	}

	public function addEmptySurface() : Surface {
		surfaces.push(new Surface());
		return surfaces[surfaces.length - 1];
	}

	public function generateSurfaceArray(){
		if(surfaces.length == 0) return;
		var surfaceSize = 1;
		for(i in 0 ... surfaces.length)
			if(surfaces[i].albedo != null) surfaceSize = hxd.Math.ceil(hxd.Math.max(surfaces[i].albedo.width, surfaceSize));

		if(surfaceArray != null) surfaceArray.dispose();
		surfaceArray = new h3d.scene.pbr.terrain.Surface.SurfaceArray(surfaces.length, surfaceSize);
		for(i in 0 ... surfaces.length){
			if(surfaces[i].albedo != null) copyPass.apply(surfaces[i].albedo, surfaceArray.albedo, null, null, i);
			if(surfaces[i].normal != null) copyPass.apply(surfaces[i].normal, surfaceArray.normal, null, null, i);
			if(surfaces[i].pbr != null) copyPass.apply(surfaces[i].pbr, surfaceArray.pbr, null, null, i);
		}
		updateSurfaceParams();
		refreshTex();
	}

	public function updateSurfaceParams(){
		for(i in 0 ... surfaces.length){
			surfaceArray.params[i] = new h3d.Vector(surfaces[i].tilling, surfaces[i].offset.x, surfaces[i].offset.y, hxd.Math.degToRad(surfaces[i].angle));
			surfaceArray.secondParams[i] = new h3d.Vector(0, 0, 0, 0);
		}
	}

	public function refreshTiles(){
		for(tile in tiles)
			if(tile.needAlloc){
				tile.grid.alloc(h3d.Engine.getCurrent());
				tile.needAlloc = false;
			}
	}

	public function refreshMesh(){
		for(tile in tiles){
			tile.x = tile.tileX * tileSize;
			tile.y = tile.tileY * tileSize;
			tile.refreshMesh();
		}
		for(tile in tiles)
			tile.blendEdges();
	}

	public function refreshTex(){
		for(tile in tiles){
			tile.refresh();
		}
	}

	public function refresh(){
		refreshMesh();
		refreshTex();
	}

	public function createTile(x : Int, y : Int) : Tile {
		var tile = getTile(x,y);
		if(tile == null){
			tile = new Tile(x, y, this);
			tile.refresh();
			tiles.push(tile);
		}
		return tile;
	}

	public function addTile(tile : Tile, ?replace = false){
		for(t in tiles){
			if(tile == t) return;
			if(tile.tileX == t.tileX && tile.tileY == t.tileY){
				if(replace){
					removeTile(t);
					break;
				}else
					return;
			}
		}
		tile.parent = this;
		tiles.push(tile);
		addChild(tile);
	}

	public function removeTileAt(x : Int, y : Int) : Bool {
		var t = getTile(x,y);
		if(t == null){
			removeTile(t);
			return true;
		}
		return false;
	}

	public function removeTile(t : Tile) : Bool {
		if(t == null) return false;
		var r = tiles.remove(t);
		if(r) t.remove();
		return r;
	}

	public function getTileIndex(t : Tile) : Int {
		for(i in 0 ... tiles.length)
			if(t == tiles[i]) return i;
		return -1;
	}

	public function getTile(x : Int, y : Int) : Tile {
		var result : Tile = null;
		for(tile in tiles)
			if(tile.tileX == x && tile.tileY == y) result = tile;
		return result;
	}

	public function getTileAtWorldPos(pos : h3d.Vector) : Tile {
		var pos = globalToLocal(pos.clone());
		var result : Tile = null;
		var tileX = Math.floor(pos.x / tileSize);
		var tileY = Math.floor(pos.y / tileSize);
		for(tile in tiles)
			if(tile.tileX == tileX && tile.tileY == tileY) result = tile;
		return result;
	}

	public function createTileAtWorldPos(pos : h3d.Vector) : Tile {
		var pos = globalToLocal(pos.clone());
		var tileX = Math.floor(pos.x / tileSize);
		var tileY = Math.floor(pos.y / tileSize);
		var result = getTile(tileX, tileY);
		return result == null ? createTile(tileX, tileY) : result;
	}

	public function getTiles(pos : h3d.Vector, range : Float, ?create = false) : Array<Tile> {
		var pos = globalToLocal(pos.clone());
		if(create != null && create){
			var maxTileX = Math.floor((pos.x + range)/ tileSize);
			var minTileX = Math.floor((pos.x - range)/ tileSize);
			var maxTileY = Math.floor((pos.y + range)/ tileSize);
			var minTileY = Math.floor((pos.y - range)/ tileSize);
			for( x in minTileX ... maxTileX + 1)
				for( y in minTileY...maxTileY + 1)
					createTile(x, y);
		}
		var result : Array<Tile> = [];
		for(tile in tiles)
			if( Math.abs(pos.x - (tile.tileX * tileSize + tileSize * 0.5)) <= range + (tileSize * 0.5)
			&& Math.abs(pos.y - (tile.tileY * tileSize + tileSize * 0.5)) <= range + (tileSize * 0.5))
				result.push(tile);
		return result;
	}

	public function getVisibleTiles(c : Camera) : Array<Tile> {
		var res = [];
		var bounds : h3d.col.Bounds = null;
		for(tile in tiles){
			if(bounds == null){
				bounds = tile.getBounds();
				bounds.zMax = 10000;
				bounds.zMin = -10000;
			}
			if(c.getFrustum().hasBounds(bounds))
				res.push(tile);
		}
		return res;
	}
}


