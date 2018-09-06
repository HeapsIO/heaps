package h3d.scene.pbr;

class Tile extends h3d.scene.Mesh {

	public var tileX (default, null) : Int;
	public var tileY (default, null) : Int;
	public var heightMap(default, set) : h3d.mat.Texture;
	public var surfaceIndex : h3d.mat.Texture;
	public var surfaceCount = 0;
	public var surfaceWeights : Array<h3d.mat.Texture> = [];
	var shader : h3d.shader.pbr.Terrain;

	public function new(x : Int, y : Int , surfaceCount, prim, ?parent){
		super(prim, null, parent);
		this.tileX = x;
		this.tileY = y;
		shader = new h3d.shader.pbr.Terrain();
		material.mainPass.addShader(shader);
		material.mainPass.culling = None;
		shader.usePreview = false;
		this.x = x * getTerrain().tileSize;
		this.y = y * getTerrain().tileSize;
		this.surfaceCount = surfaceCount;
	}

	function set_heightMap(v){
		shader.heightMap = v;
		return heightMap = v;
	}

	public function initTex(){
		if(heightMap != null) heightMap.dispose();
		heightMap = new h3d.mat.Texture(getTerrain().heightMapResolution + 2, getTerrain().heightMapResolution + 2, [Target], R16F);
		heightMap.wrap = Clamp;
		if(surfaceIndex != null) surfaceIndex.dispose();
		surfaceIndex = new h3d.mat.Texture(getTerrain().weightMapResolution, getTerrain().weightMapResolution, [Target], RGBA);
		surfaceIndex.filter = Nearest;
		for(i in 0 ... surfaceWeights.length) surfaceWeights[i].dispose();
		surfaceWeights = [for (value in 0...surfaceCount) new h3d.mat.Texture(getTerrain().weightMapResolution, getTerrain().weightMapResolution, [Target], RGBA)];
	}

	public override function dispose() {
		if(heightMap != null) heightMap.dispose();
		if(surfaceIndex != null) surfaceIndex.dispose();
		for(i in 0 ... surfaceWeights.length) surfaceWeights[i].dispose();
	}

	override function emit(ctx:RenderContext){
		var bounds = getBounds();
		if(bounds != null){
			if(ctx.camera.getFrustum().hasBounds(bounds))
				super.emit(ctx);
		}else
			super.emit(ctx);
	}

	override function sync(ctx:RenderContext) {
		shader.heightMap = heightMap;
		shader.heightMapSize = getTerrain().heightMapResolution ;
		shader.primSize = getTerrain().tileSize;
		shader.cellSize = getTerrain().cellSize;
		shader.showGrid = getTerrain().showGrid;
	}

	inline function getTerrain(){
		return Std.instance(parent, Terrain);
	}
}

class Surface {
	public var index : Int;
	public var albedo : h3d.mat.Texture;
	public var normal : h3d.mat.Texture;
	public var pbrTex : h3d.mat.Texture;
}

class Terrain extends Object {

	public var tileSize = 1.0;
	public var cellSize = 1.0;
	public var heightMapResolution = 1;
	public var weightMapResolution = 1;
	public var showGrid = false;
	var grid : h3d.prim.Grid;

	var tiles : Array<Tile> = [];
	var surfaces : Array<Surface> = [];

	public function new(?parent){
		super(parent);
		grid = new h3d.prim.Grid( Math.floor(tileSize/cellSize), Math.floor(tileSize/cellSize), cellSize, cellSize);
		grid.addUVs();
		grid.addNormals();
	}

	public function refreshMesh(){
		if(grid != null) grid.dispose();
		grid = new h3d.prim.Grid( Math.floor(tileSize/cellSize), Math.floor(tileSize/cellSize), cellSize, cellSize);
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
			tile.initTex();
		}
	}

	public function refresh(){
		refreshMesh();
		refreshTex();
	}

	public function createTile(x : Int, y : Int){
		var tile = getTile(x,y);
		if(tile == null){
			tile = new Tile(x, y, surfaces.length, grid, this);
			tile.initTex();
			tiles.push(tile);
		}
		return tile;
	}

	public function getTile(x : Int, y : Int){
		var result : Tile = null;
		for(tile in tiles)
			if(tile.tileX == x && tile.tileY == y) result = tile;
		return result;
	}

	public function getTileAtWorldPos(pos : h3d.Vector){
		var result : Tile = null;
		var tileX = Math.floor(pos.x / tileSize);
		var tileY = Math.floor(pos.y / tileSize);
		for(tile in tiles)
			if(tile.tileX == tileX && tile.tileY == tileY) result = tile;
		return result;
	}

	public function createTileAtWorldPos(pos : h3d.Vector){
		var tileX = Math.floor(pos.x / tileSize);
		var tileY = Math.floor(pos.y / tileSize);
		var result = getTile(tileX, tileY);
		return result == null ? createTile(tileX, tileY) : result;
	}

	public function getTiles(pos : h3d.Vector, range : Float, ?create = false){
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


