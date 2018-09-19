package h3d.scene.pbr;

class Tile extends h3d.scene.Mesh {

	public var tileX (default, null) : Int;
	public var tileY (default, null) : Int;
	public var heightMap(default, set) : h3d.mat.Texture;
	public var surfaceIndexMap : h3d.mat.Texture;
	public var surfaceCount = 0;
	public var surfaceWeights : Array<h3d.mat.Texture> = [];
	var shader : h3d.shader.pbr.Terrain;
	public var surfaceWeightArray (default, null) : h3d.mat.TextureArray;

	public function new(x : Int, y : Int , ?parent){
		super(Std.instance(parent, Terrain).grid, null, parent);
		this.tileX = x;
		this.tileY = y;
		shader = new h3d.shader.pbr.Terrain();
		material.mainPass.addShader(shader);
		material.mainPass.culling = None;
		this.x = x * getTerrain().tileSize;
		this.y = y * getTerrain().tileSize;
		this.surfaceCount = getTerrain().surfaces.length;
	}

	function set_heightMap(v){
		shader.heightMap = v;
		return heightMap = v;
	}

	public function uploadWeightMap(tex : h3d.mat.Texture, i : Int){
		if(i < surfaceWeights.length && surfaceWeights[i] != null){
			getTerrain().copyPass.apply(tex, surfaceWeights[i]);
			generateWeightArray();
		}
	}

	public function refresh(){

		if(heightMap == null || heightMap.width != getTerrain().heightMapResolution + 2){
			var oldHeightMap = heightMap;
			heightMap = new h3d.mat.Texture(getTerrain().heightMapResolution + 2, getTerrain().heightMapResolution + 2, [Target], RGBA32F );
			heightMap.wrap = Clamp;
			heightMap.filter = Nearest;
			if(oldHeightMap != null){
				getTerrain().copyPass.apply(oldHeightMap, heightMap);
				oldHeightMap.dispose();
			}
		}

		if(surfaceIndexMap == null || surfaceIndexMap.width != getTerrain().weightMapResolution){
			var oldSurfaceIndexMap = surfaceIndexMap;
			surfaceIndexMap = new h3d.mat.Texture(getTerrain().weightMapResolution, getTerrain().weightMapResolution, [Target], RGBA);
			surfaceIndexMap.filter = Nearest;
			if(oldSurfaceIndexMap != null){
				getTerrain().copyPass.apply(oldSurfaceIndexMap, surfaceIndexMap);
				oldSurfaceIndexMap.dispose();
			}
		}

		if(surfaceWeights.length != surfaceCount || surfaceWeights[0].width != getTerrain().weightMapResolution){
			var oldArray = surfaceWeights;
			surfaceWeights = new Array<h3d.mat.Texture>();
			surfaceWeights.resize(surfaceCount);
			for(i in 0 ... surfaceWeights.length){
				surfaceWeights[i] = new h3d.mat.Texture(getTerrain().weightMapResolution, getTerrain().weightMapResolution, [Target], RGBA);
				surfaceWeights[i].wrap = Clamp;
				if(i < oldArray.length && oldArray[i] != null)
					getTerrain().copyPass.apply(oldArray[i], surfaceWeights[i]);
			}
			for(i in 0 ... oldArray.length)
				if( oldArray[i] != null) oldArray[i].dispose();

			generateWeightArray();
		}
	}

	public function generateWeightArray(){
		if(surfaceWeightArray == null || surfaceWeightArray.width != getTerrain().weightMapResolution || surfaceWeightArray.get_layerCount() != surfaceWeights.length){
			if(surfaceWeightArray != null) surfaceWeightArray.dispose();
			surfaceWeightArray = new h3d.mat.TextureArray(getTerrain().weightMapResolution, getTerrain().weightMapResolution, surfaceWeights.length, [Target]);
			surfaceWeightArray.wrap = Clamp;
		}
		for(i in 0 ... surfaceWeights.length)
			if(surfaceWeights[i] != null) getTerrain().copyPass.apply(surfaceWeights[i], surfaceWeightArray, None, null, i);
	}

	public override function dispose() {
		if(heightMap != null) heightMap.dispose();
		if(surfaceIndexMap != null) surfaceIndexMap.dispose();
		for(i in 0 ... surfaceWeights.length)
			if( surfaceWeights[i] != null) surfaceWeights[i].dispose();
	}

	override function emit(ctx:RenderContext){
		if( getTerrain().surfaceArray == null) return;
		var bounds = getBounds();
		if(bounds != null){
			if(ctx.camera.getFrustum().hasBounds(bounds))
				super.emit(ctx);
		}else
			super.emit(ctx);
	}

	override function sync(ctx:RenderContext) {
		if( getTerrain().surfaceArray == null) return;
		shader.heightMap = heightMap;
		shader.heightMapSize = getTerrain().heightMapResolution;
		shader.primSize = getTerrain().tileSize;
		shader.cellSize = getTerrain().cellSize;
		shader.showGrid = getTerrain().showGrid;
		shader.surfaceIndexMap = surfaceIndexMap;
		shader.albedoTextures = getTerrain().surfaceArray.albedo;
		shader.normalTextures = getTerrain().surfaceArray.normal;
		shader.pbrTextures = getTerrain().surfaceArray.pbr;
		shader.weightTextures = surfaceWeightArray;
		shader.weightCount = surfaceCount;
		shader.surfaceParams = getTerrain().surfaceArray.params;
		shader.secondSurfaceParams = getTerrain().surfaceArray.secondParams;
		shader.tileIndex = new h3d.Vector(tileX, tileY);
		shader.useHeightBlend = getTerrain().useHeightBlend;
		shader.parallaxAmount = getTerrain().parallaxAmount / 10.0;
	}

	inline function getTerrain(){
		return Std.instance(parent, Terrain);
	}
}

class Surface {
	public var albedo (default, set) : h3d.mat.Texture;
	public var normal (default, set) : h3d.mat.Texture;
	public var pbr (default, set) : h3d.mat.Texture;
	public var tilling = 1.0;
	public var offset : h3d.Vector;
	public var angle = 0.0;

	public function new(?albedo : h3d.mat.Texture, ?normal : h3d.mat.Texture, ?pbr : h3d.mat.Texture){
		this.albedo = albedo;
		this.normal = normal;
		this.pbr = pbr;
		this.offset = new h3d.Vector(0);
	}

	public function dispose() {
		if(albedo != null) albedo.dispose();
		if(normal != null) normal.dispose();
		if(pbr != null) pbr.dispose();
	}

	function set_albedo(t : h3d.mat.Texture){
		return albedo = swap(albedo, t);
	}

	function set_normal(t : h3d.mat.Texture){
		return normal = swap(normal, t);
	}

	function set_pbr(t : h3d.mat.Texture){
		return pbr = swap(pbr, t);
	}

	function swap(a : h3d.mat.Texture, b : h3d.mat.Texture) : h3d.mat.Texture {
		if(a != null) a.dispose();
		if(b != null){
			var r = b.clone();
			r.wrap = Repeat;
			return r;
		}
		return null;
	}
}

class SurfaceArray {
	public var albedo : h3d.mat.TextureArray;
	public var normal : h3d.mat.TextureArray;
	public var pbr : h3d.mat.TextureArray;
	public var params : Array<h3d.Vector> = [];
	public var secondParams : Array<h3d.Vector> = [];

	public function new(count, res){
		albedo = new h3d.mat.TextureArray(res, res, count, [Target]);
		normal = new h3d.mat.TextureArray(res, res, count, [Target]);
		pbr = new h3d.mat.TextureArray(res, res, count, [Target]);
		albedo.wrap = Repeat;
		normal.wrap = Repeat;
		pbr.wrap = Repeat;
	}

	public function dispose() {
		if(albedo != null) albedo.dispose();
		if(normal != null) normal.dispose();
		if(pbr != null) pbr.dispose();
	}
}

class Terrain extends Object {

	public var tileSize = 1.0;
	public var cellSize = 1.0;
	public var cellCount = 1;
	public var heightMapResolution = 1;
	public var weightMapResolution = 1;
	public var showGrid : Bool;
	public var useHeightBlend : Bool;
	public var parallaxAmount : Float = 0;
	public var grid (default, null) : h3d.prim.Grid;
	public var copyPass (default, null): h3d.pass.Copy;
	public var tiles (default, null) : Array<Tile> = [];
	public var surfaces (default, null) : Array<Surface> = [];
	public var surfaceArray (default, null) : SurfaceArray;

	public function new(?parent){
		super(parent);
		grid = new h3d.prim.Grid( cellCount, cellCount, cellSize, cellSize);
		grid.addUVs();
		grid.addNormals();
		copyPass = new h3d.pass.Copy();
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
		var surfaceSize = 1;
		for(i in 0 ... surfaces.length)
			if(surfaces[i].albedo != null) surfaceSize = hxd.Math.ceil(hxd.Math.max(surfaces[i].albedo.width, surfaceSize));

		if(surfaceArray != null) surfaceArray.dispose();
		surfaceArray = new SurfaceArray(surfaces.length, surfaceSize);
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

	public function refreshMesh(){
		if(grid != null) grid.dispose();
		grid = new h3d.prim.Grid( cellCount, cellCount, cellSize, cellSize);
		grid.addUVs();
		grid.addNormals();

		for(tile in tiles){
			tile.primitive = grid;
			tile.x = tile.tileX * tileSize;
			tile.y = tile.tileY * tileSize;
		}
	}

	public function refreshTex(){
		for(tile in tiles){
			tile.surfaceCount = surfaces.length;
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

	public function getTile(x : Int, y : Int) : Tile {
		var result : Tile = null;
		for(tile in tiles)
			if(tile.tileX == x && tile.tileY == y) result = tile;
		return result;
	}

	public function getTileAtWorldPos(pos : h3d.Vector) : Tile {
		var result : Tile = null;
		var tileX = Math.floor(pos.x / tileSize);
		var tileY = Math.floor(pos.y / tileSize);
		for(tile in tiles)
			if(tile.tileX == tileX && tile.tileY == tileY) result = tile;
		return result;
	}

	public function createTileAtWorldPos(pos : h3d.Vector) : Tile {
		var tileX = Math.floor(pos.x / tileSize);
		var tileY = Math.floor(pos.y / tileSize);
		var result = getTile(tileX, tileY);
		return result == null ? createTile(tileX, tileY) : result;
	}

	public function getTiles(pos : h3d.Vector, range : Float, ?create = false) : Array<Tile> {
		if(create){
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
}


