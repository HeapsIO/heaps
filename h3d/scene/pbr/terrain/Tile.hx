package h3d.scene.pbr.terrain;

enum Direction{
	Up; Down; Left; Right; UpLeft; UpRight; DownLeft; DownRight;
}

class Tile extends h3d.scene.Mesh {

	public var tileX (default, null) : Int;
	public var tileY (default, null) : Int;
	public var heightMap(default, set) : h3d.mat.Texture;
	public var surfaceIndexMap : h3d.mat.Texture;
	public var surfaceWeights : Array<h3d.mat.Texture> = [];
	public var surfaceWeightArray (default, null) : h3d.mat.TextureArray;
	public var grid (default, null) : h3d.prim.Grid;
	public var needAlloc = false;
	public var needNewPixelCapture = false;
	var heightmapPixels : hxd.Pixels.PixelsFloat;
	var shader : h3d.shader.pbr.Terrain;

	public function new( x : Int, y : Int , ?parent ){
		super(null, null, parent);
		this.tileX = x;
		this.tileY = y;
		shader = new h3d.shader.pbr.Terrain();
		material.mainPass.addShader(shader);
		material.mainPass.culling = None;
		this.x = x * getTerrain().tileSize;
		this.y = y * getTerrain().tileSize;
		name = "tile_" + x + "_" + y;
	}

	function set_heightMap(v){
		shader.heightMap = v;
		return heightMap = v;
	}

	inline function getTerrain(){
		return Std.instance(parent, Terrain);
	}

	public function getHeightPixels(){
		if(needNewPixelCapture || heightmapPixels == null)
			heightmapPixels = heightMap.capturePixels();
		needNewPixelCapture = false;
		return heightmapPixels;
	}

	public function refreshMesh(){
		if(grid == null || grid.width != getTerrain().cellCount || grid.height != getTerrain().cellCount || grid.cellWidth != getTerrain().cellSize || grid.cellHeight != getTerrain().cellSize){
			if(grid != null) grid.dispose();
		 	grid = new h3d.prim.Grid( getTerrain().cellCount, getTerrain().cellCount, getTerrain().cellSize, getTerrain().cellSize);
			primitive = grid;
			//grid.addUVs(); // Not currently used
		}
		computeNormals();
	}

	public function blendEdges(){
		var adjTileX = getTerrain().getTile(tileX - 1, tileY);
		if( adjTileX != null){
			var flags = new haxe.EnumFlags<Direction>();
        	flags.set(Left);
			adjTileX.computeEdgesHeight(flags);
		}
		var adjTileY = getTerrain().getTile(tileX, tileY - 1);
		if( adjTileY != null){
			var flags = new haxe.EnumFlags<Direction>();
        	flags.set(Up);
			adjTileY.computeEdgesHeight(flags);
		}
		var adjTileXY = getTerrain().getTile(tileX - 1, tileY - 1);
		if( adjTileXY != null){
			var flags = new haxe.EnumFlags<Direction>();
        	flags.set(UpLeft);
			adjTileXY.computeEdgesHeight(flags);
		}
		var flags = new haxe.EnumFlags<Direction>();
        flags.set(Left);
		flags.set(Up);
		flags.set(UpLeft);
		computeEdgesHeight(flags);
		computeNormals();

		computeEdgesNormals();
	}

	public function refresh(){
		if(heightMap == null || heightMap.width != getTerrain().heightMapResolution + 1){
			var oldHeightMap = heightMap;
			heightMap = new h3d.mat.Texture(getTerrain().heightMapResolution + 1, getTerrain().heightMapResolution + 1, [Target], RGBA32F );
			heightMap.wrap = Clamp;
			heightMap.filter = Linear;
			heightMap.preventAutoDispose();
			heightMap.realloc = null;
			if(oldHeightMap != null){
				getTerrain().copyPass.apply(oldHeightMap, heightMap);
				oldHeightMap.dispose();
			}
			needNewPixelCapture = true;
		}

		if(surfaceIndexMap == null || surfaceIndexMap.width != getTerrain().weightMapResolution){
			var oldSurfaceIndexMap = surfaceIndexMap;
			surfaceIndexMap = new h3d.mat.Texture(getTerrain().weightMapResolution, getTerrain().weightMapResolution, [Target], RGBA);
			surfaceIndexMap.filter = Nearest;
			surfaceIndexMap.preventAutoDispose();
			surfaceIndexMap.realloc = null;
			if(oldSurfaceIndexMap != null){
				getTerrain().copyPass.apply(oldSurfaceIndexMap, surfaceIndexMap);
				oldSurfaceIndexMap.dispose();
			}
		}

		if( getTerrain().surfaces.length > 0 && (surfaceWeights.length != getTerrain().surfaces.length || surfaceWeights[0].width != getTerrain().weightMapResolution)){
			var oldArray = surfaceWeights;
			surfaceWeights = new Array<h3d.mat.Texture>();
			surfaceWeights = [for (i in 0...getTerrain().surfaces.length) null];
			for(i in 0 ... surfaceWeights.length){
				surfaceWeights[i] = new h3d.mat.Texture(getTerrain().weightMapResolution, getTerrain().weightMapResolution, [Target], R8);
				surfaceWeights[i].wrap = Clamp;
				surfaceWeights[i].preventAutoDispose();
				surfaceWeights[i].realloc = null;
				if(i < oldArray.length && oldArray[i] != null)
					getTerrain().copyPass.apply(oldArray[i], surfaceWeights[i]);
			}
			generateWeightArray();

			for(i in 0 ... oldArray.length)
				if( oldArray[i] != null) oldArray[i].dispose();
		}
	}

	public function generateWeightArray(){
		if(surfaceWeightArray == null || surfaceWeightArray.width != getTerrain().weightMapResolution || surfaceWeightArray.get_layerCount() != surfaceWeights.length){
			if(surfaceWeightArray != null) surfaceWeightArray.dispose();
			surfaceWeightArray = new h3d.mat.TextureArray(getTerrain().weightMapResolution, getTerrain().weightMapResolution, surfaceWeights.length, [Target], R8);
			surfaceWeightArray.wrap = Clamp;
			surfaceWeightArray.preventAutoDispose();
			surfaceWeightArray.realloc = null;
		}
		for(i in 0 ... surfaceWeights.length)
			if(surfaceWeights[i] != null) getTerrain().copyPass.apply(surfaceWeights[i], surfaceWeightArray, None, null, i);
	}

	public function computeEdgesHeight(flag : haxe.EnumFlags<Direction>){

		if(heightMap == null) return;
		var pixels : hxd.Pixels.PixelsFloat = getHeightPixels();

		if(flag.has(Left)){
			var adjTileX = getTerrain().getTile(tileX + 1, tileY);
			var adjHeightMapX = adjTileX != null ? adjTileX.heightMap : null;
			if(adjHeightMapX != null){
				var adjpixels : hxd.Pixels.PixelsFloat = adjTileX.getHeightPixels();
				for( i in 0 ... heightMap.height - 1){
					pixels.setPixelF(heightMap.width - 1, i, adjpixels.getPixelF(0,i) );
				}
			}
		}
		if(flag.has(Up)){
			var adjTileY = getTerrain().getTile(tileX, tileY + 1);
			var adjHeightMapY = adjTileY != null ? adjTileY.heightMap : null;
			if(adjHeightMapY != null){
				var adjpixels : hxd.Pixels.PixelsFloat = adjTileY.getHeightPixels();
				for( i in 0 ... heightMap.width - 1){
					pixels.setPixelF(i, heightMap.height - 1, adjpixels.getPixelF(i,0) );
				}
			}
		}
		if(flag.has(UpLeft)){
			var adjTileXY = getTerrain().getTile(tileX + 1, tileY + 1);
			var adjHeightMapXY = adjTileXY != null ? adjTileXY.heightMap : null;
			if(adjHeightMapXY != null){
				var adjpixels : hxd.Pixels.PixelsFloat = adjTileXY.getHeightPixels();
				pixels.setPixelF(heightMap.width - 1, heightMap.height - 1, adjpixels.getPixelF(0,0));
			}
		}
		heightmapPixels = pixels;
		heightMap.uploadPixels(pixels);
		needNewPixelCapture = false;
	}

	public function computeEdgesNormals(){
		if(grid.normals == null) return;
		var t0 = new h3d.col.Point(); var t1 = new h3d.col.Point(); var t2 = new h3d.col.Point();
		var triCount = Std.int(grid.triCount() / grid.width);
		var vertexCount = grid.width + 1;
		var step = hxd.Math.floor(grid.normals.length / grid.width) - 1;
		var s = hxd.Math.floor(grid.normals.length - grid.normals.length / grid.width + 2);
		var istep = triCount * 3 - 6;
		var i0, i1, i2 : Int = 0;

		inline function computeVertexPos(tile : Tile){
			t0.load(tile.grid.points[i0]); t1.load(tile.grid.points[i1]); t2.load(tile.grid.points[i2]);
			t0.z += tile.getHeight(t0.x / getTerrain().tileSize, t0.y / getTerrain().tileSize);
			t1.z += tile.getHeight(t1.x / getTerrain().tileSize, t1.y / getTerrain().tileSize);
			t2.z += tile.getHeight(t2.x / getTerrain().tileSize, t2.y / getTerrain().tileSize);
		}

		inline function computeNormal() : h3d.col.Point {
			var n1 = t1.sub(t0);
			n1.normalize();
			var n2 = t2.sub(t0);
			n2.normalize();
			return n1.cross(n2);
		}

		var adjUpTile = getTerrain().getTile(tileX, tileY + 1);
		var adjUpGrid = adjUpTile != null ? adjUpTile.grid: null;
		var adjDownTile = getTerrain().getTile(tileX, tileY - 1);
		var adjDownGrid = adjDownTile != null ? adjDownTile.grid: null;
		var adjLeftTile = getTerrain().getTile(tileX + 1, tileY);
		var adjLeftGrid = adjLeftTile != null ? adjLeftTile.grid: null;
		var adjRightTile = getTerrain().getTile(tileX - 1, tileY);
		var adjRightGrid = adjRightTile != null ? adjRightTile.grid: null;
		var adjUpRightTile = getTerrain().getTile(tileX - 1, tileY + 1);
		var adjUpRightGrid = adjUpRightTile != null ? adjUpRightTile.grid: null;
		var adjUpLeftTile = getTerrain().getTile(tileX + 1, tileY + 1);
		var adjUpLeftGrid = adjUpLeftTile != null ? adjUpLeftTile.grid: null;
		var adjDownLeftTile = getTerrain().getTile(tileX + 1, tileY - 1);
		var adjDownLeftGrid = adjDownLeftTile != null ? adjDownLeftTile.grid: null;
		var adjDownRightTile = getTerrain().getTile(tileX - 1, tileY - 1);
		var adjDownRightGrid = adjDownRightTile != null ? adjDownRightTile.grid: null;

		if(adjUpGrid != null && adjUpGrid.normals != null){
			var pos = 0;
			for( i in 0 ... vertexCount)
				adjUpGrid.normals[i].set(0,0,0);
			for( i in 0 ... triCount ) {
				i0 = adjUpGrid.idx[pos++]; i1 = adjUpGrid.idx[pos++]; i2 = adjUpGrid.idx[pos++];
				computeVertexPos(adjUpTile);
				var n = computeNormal();
				if(i0 <= adjUpGrid.width){ adjUpGrid.normals[i0].x += n.x; adjUpGrid.normals[i0].y += n.y; adjUpGrid.normals[i0].z += n.z;}
				if(i1 <= adjUpGrid.width){ adjUpGrid.normals[i1].x += n.x; adjUpGrid.normals[i1].y += n.y; adjUpGrid.normals[i1].z += n.z;}
				if(i2 <= adjUpGrid.width){ adjUpGrid.normals[i2].x += n.x; adjUpGrid.normals[i2].y += n.y; adjUpGrid.normals[i2].z += n.z;}
			}
			for( i in 0 ... vertexCount)
				adjUpGrid.normals[i].normalize();
			for( i in 1 ... vertexCount - 1){
				var n = grid.normals[s + i].add(adjUpGrid.normals[i]);
				n.normalize();
				grid.normals[s + i].load(n);
				adjUpGrid.normals[i].load(n);
			}
		}

		if(adjDownGrid != null && adjDownGrid.normals != null){
			var pos = triCount * (adjDownGrid.width - 1) * 3;
			for( i in 0 ... vertexCount)
				adjDownGrid.normals[s + i].set(0,0,0);
			for( i in 0 ... triCount ) {
				i0 = adjDownGrid.idx[pos++]; i1 = adjDownGrid.idx[pos++]; i2 = adjDownGrid.idx[pos++];
				computeVertexPos(adjDownTile);
				var n = computeNormal();
				if(i0 >= (adjDownGrid.width * adjDownGrid.height + adjDownGrid.height)){ adjDownGrid.normals[i0].x += n.x; adjDownGrid.normals[i0].y += n.y; adjDownGrid.normals[i0].z += n.z;}
				if(i1 >= (adjDownGrid.width * adjDownGrid.height + adjDownGrid.height)){ adjDownGrid.normals[i1].x += n.x; adjDownGrid.normals[i1].y += n.y; adjDownGrid.normals[i1].z += n.z;}
				if(i2 >= (adjDownGrid.width * adjDownGrid.height + adjDownGrid.height)){ adjDownGrid.normals[i2].x += n.x; adjDownGrid.normals[i2].y += n.y; adjDownGrid.normals[i2].z += n.z;}
			}
			for( i in 1 ... vertexCount - 1)
				adjDownGrid.normals[s + i].normalize();
			for( i in 1 ... vertexCount - 1){
				var n = grid.normals[i].add(adjDownGrid.normals[s + i]);
				n.normalize();
				grid.normals[i].load(n);
				adjDownGrid.normals[s + i].load(n);
			}
		}

		if(adjLeftGrid != null && adjLeftGrid.normals != null){
			var pos = 0;
			var istep = triCount * 3 - 6;
			var needStep = false;
			for( i in 0 ... vertexCount)
				adjLeftGrid.normals[i * step].set(0,0,0);
			for( i in 0 ... triCount ) {
				i0 = adjLeftGrid.idx[pos++]; i1 = adjLeftGrid.idx[pos++]; i2 = adjLeftGrid.idx[pos++];
				computeVertexPos(adjLeftTile);
				var n = computeNormal();
				if(i0 % (adjLeftGrid.width + 1) == 0){ adjLeftGrid.normals[i0].x += n.x; adjLeftGrid.normals[i0].y += n.y; adjLeftGrid.normals[i0].z += n.z;}
				if(i1 % (adjLeftGrid.width + 1) == 0){ adjLeftGrid.normals[i1].x += n.x; adjLeftGrid.normals[i1].y += n.y; adjLeftGrid.normals[i1].z += n.z;}
				if(i2 % (adjLeftGrid.width + 1) == 0){ adjLeftGrid.normals[i2].x += n.x; adjLeftGrid.normals[i2].y += n.y; adjLeftGrid.normals[i2].z += n.z;}
				if(needStep) pos += istep;
				needStep = !needStep;
			}
			for( i in 0 ... vertexCount)
				adjLeftGrid.normals[i * step].normalize();
			for( i in 1 ... vertexCount - 1){
				var n = grid.normals[i * step + (step - 1)].add(adjLeftGrid.normals[i * step]);
				n.normalize();
				grid.normals[i * step + (step - 1)].load(n);
				adjLeftGrid.normals[i * step].load(n);
			}
		}

		if(adjRightGrid != null && adjRightGrid.normals != null){
			var pos = (triCount - 2) * 3;
			var istep = (triCount - 2) * 3;
			var needStep = false;
			for( i in 0 ... vertexCount)
				adjRightGrid.normals[i * step + (step - 1)].set(0,0,0);
			for( i in 0 ... triCount ) {
				i0 = adjRightGrid.idx[pos++]; i1 = adjRightGrid.idx[pos++]; i2 = adjRightGrid.idx[pos++];
				computeVertexPos(adjRightTile);
				var n = computeNormal();
				if((i0 + 1) % (adjRightGrid.width + 1) == 0){ adjRightGrid.normals[i0].x += n.x; adjRightGrid.normals[i0].y += n.y; adjRightGrid.normals[i0].z += n.z;}
				if((i1 + 1) % (adjRightGrid.width + 1) == 0){ adjRightGrid.normals[i1].x += n.x; adjRightGrid.normals[i1].y += n.y; adjRightGrid.normals[i1].z += n.z;}
				if((i2 + 1) % (adjRightGrid.width + 1) == 0){ adjRightGrid.normals[i2].x += n.x; adjRightGrid.normals[i2].y += n.y; adjRightGrid.normals[i2].z += n.z;}
				if(needStep) pos += istep;
				needStep = !needStep;
			}
			for( i in 0 ... vertexCount)
				adjRightGrid.normals[i * step + (step - 1)].normalize();
			for( i in 1 ... vertexCount - 1){
				var n = grid.normals[i * step].add(adjRightGrid.normals[i * step + (step - 1)]);
				n.normalize();
				grid.normals[i * step].load(n);
				adjRightGrid.normals[i * step + (step - 1)].load(n);
			}
		}

		var topLeft = grid.points.length - 1;
		var downLeft= step - 1;
		var downRight = 0;
		var upRight = step * grid.height;

		var n = new h3d.col.Point();
		if(adjUpRightGrid != null && adjUpRightGrid.normals != null){
			var pos = (triCount) * 3 - 6;
			i0 = adjUpRightGrid.idx[pos++]; i1 = adjUpRightGrid.idx[pos++]; i2 = adjUpRightGrid.idx[pos++];
			computeVertexPos(adjUpRightTile);
			n = computeNormal();
			i0 = adjUpRightGrid.idx[pos++]; i1 = adjUpRightGrid.idx[pos++]; i2 = adjUpRightGrid.idx[pos++];
			computeVertexPos(adjUpRightTile);
			n = n.add(computeNormal());
			n.normalize();
		}
		if(adjRightGrid != null && adjRightGrid.normals != null) n = n.add(adjRightGrid.normals[topLeft]);
		if(adjUpGrid != null && adjUpGrid.normals != null) n = n.add(adjUpGrid.normals[downRight]);
		n = n.add(grid.normals[upRight]);
		n.normalize();
		if(adjUpRightGrid != null && adjUpRightGrid.normals != null) adjUpRightGrid.normals[downLeft].load(n);
		if(adjRightGrid != null && adjRightGrid.normals != null) adjRightGrid.normals[topLeft].load(n);
		if(adjUpGrid != null && adjUpGrid.normals != null) adjUpGrid.normals[downRight].load(n);
		grid.normals[upRight].load(n);

		n.set(0,0,0);
		if(adjUpLeftGrid != null && adjUpLeftGrid.normals != null){
			var pos = 0;
			i0 = adjUpLeftGrid.idx[pos++]; i1 = adjUpLeftGrid.idx[pos++]; i2 = adjUpLeftGrid.idx[pos++];
			computeVertexPos(adjUpLeftTile);
			n = computeNormal();
			n.normalize();
		}
		if(adjLeftGrid != null && adjLeftGrid.normals != null) n = n.add(adjLeftGrid.normals[upRight]);
		if(adjUpGrid != null && adjUpGrid.normals != null) n = n.add(adjUpGrid.normals[downLeft]);
		n = n.add(grid.normals[topLeft]);
		n.normalize();
		if(adjUpLeftGrid != null && adjUpLeftGrid.normals != null) adjUpLeftGrid.normals[downRight].load(n);
		if(adjLeftGrid != null && adjLeftGrid.normals != null) adjLeftGrid.normals[upRight].load(n);
		if(adjUpGrid != null && adjUpGrid.normals != null) adjUpGrid.normals[downLeft].load(n);
		grid.normals[topLeft].load(n);

		n.set(0,0,0);
		if(adjDownLeftGrid != null && adjDownLeftGrid.normals != null){
			var pos = (triCount) * 3 * (adjDownLeftGrid.height - 1) ;
			i0 = adjDownLeftGrid.idx[pos++]; i1 = adjDownLeftGrid.idx[pos++]; i2 = adjDownLeftGrid.idx[pos++];
			computeVertexPos(adjDownLeftTile);
			n = computeNormal();
			i0 = adjDownLeftGrid.idx[pos++]; i1 = adjDownLeftGrid.idx[pos++]; i2 = adjDownLeftGrid.idx[pos++];
			computeVertexPos(adjDownLeftTile);
			n = n.add(computeNormal());
			n.normalize();
		}
		if(adjLeftGrid != null && adjLeftGrid.normals != null) n = n.add(adjLeftGrid.normals[downRight]);
		if(adjDownGrid != null && adjDownGrid.normals != null) n = n.add(adjDownGrid.normals[topLeft]);
		n = n.add(grid.normals[downLeft]);
		n.normalize();
		if(adjDownLeftGrid != null && adjDownLeftGrid.normals != null) adjDownLeftGrid.normals[upRight].load(n);
		if(adjLeftGrid != null && adjLeftGrid.normals != null) adjLeftGrid.normals[downRight].load(n);
		if(adjDownGrid != null && adjDownGrid.normals != null) adjDownGrid.normals[topLeft].load(n);
		grid.normals[downLeft].load(n);

		n.set(0,0,0);
		if(adjDownRightGrid != null && adjDownRightGrid.normals != null){
			var pos = triCount * 3 * adjDownRightGrid.width - 3;
			i0 = adjDownRightGrid.idx[pos++]; i1 = adjDownRightGrid.idx[pos++]; i2 = adjDownRightGrid.idx[pos++];
			computeVertexPos(adjDownRightTile);
			n = computeNormal();
			n.normalize();
		}
		if(adjRightGrid != null && adjRightGrid.normals != null) n = n.add(adjRightGrid.normals[downLeft]);
		if(adjDownGrid != null && adjDownGrid.normals != null) n = n.add(adjDownGrid.normals[upRight]);
		n = n.add(grid.normals[downRight]);
		n.normalize();
		if(adjDownRightGrid != null && adjDownRightGrid.normals != null) adjDownRightGrid.normals[topLeft].load(n);
		if(adjRightGrid != null && adjRightGrid.normals != null) adjRightGrid.normals[downLeft].load(n);
		if(adjDownGrid != null && adjDownGrid.normals != null) adjDownGrid.normals[upRight].load(n);
		grid.normals[downRight].load(n);

		if(adjUpTile != null) adjUpTile.needAlloc = true;
		if(adjDownTile != null) adjDownTile.needAlloc = true;
		if(adjLeftTile != null) adjLeftTile.needAlloc = true;
		if(adjRightTile != null) adjRightTile.needAlloc = true;
		if(adjUpLeftTile != null) adjUpLeftTile.needAlloc = true;
		if(adjDownLeftTile != null) adjDownLeftTile.needAlloc = true;
		if(adjUpRightTile != null) adjUpRightTile.needAlloc = true;
		if(adjDownRightTile != null) adjDownRightTile.needAlloc = true;
		this.needAlloc = true;
	}

	public function computeNormals(){
		if(grid.normals == null) grid.normals = new Array<h3d.col.Point>();
		grid.normals = [
		for (i in 0...grid.points.length){
			if(i < grid.normals.length){
				grid.normals[i].set(0,0,0);
				grid.normals[i];
			} else
				new h3d.col.Point();
		}];

		var t0 = new h3d.col.Point(); var t1 = new h3d.col.Point(); var t2 = new h3d.col.Point();
		var pos = 0;
		for( i in 0...grid.triCount() ) {
			var i0, i1, i2;
			if( grid.idx == null ) {
				i0 = pos++; i1 = pos++; i2 = pos++;
			} else {
				i0 = grid.idx[pos++]; i1 = grid.idx[pos++]; i2 = grid.idx[pos++];
			}
			t0.load(grid.points[i0]); t1.load(grid.points[i1]); t2.load(grid.points[i2]);
			if(heightMap != null){
				t0.z += getHeight(t0.x / getTerrain().tileSize, t0.y / getTerrain().tileSize);
				t1.z += getHeight(t1.x / getTerrain().tileSize, t1.y / getTerrain().tileSize);
				t2.z += getHeight(t2.x / getTerrain().tileSize, t2.y / getTerrain().tileSize);
			}
			var n1 = t1.sub(t0);
			n1.normalizeFast();
			var n2 = t2.sub(t0);
			n2.normalizeFast();
			var n = n1.cross(n2);
			grid.normals[i0].x += n.x; grid.normals[i0].y += n.y; grid.normals[i0].z += n.z;
			grid.normals[i1].x += n.x; grid.normals[i1].y += n.y; grid.normals[i1].z += n.z;
			grid.normals[i2].x += n.x; grid.normals[i2].y += n.y; grid.normals[i2].z += n.z;
		}
		for( n in grid.normals )
			n.normalize();

		needAlloc = true;
	}

	public function getHeight(u : Float, v : Float, ?fast = false) : Float {
		var pixels = getHeightPixels();
		if(pixels == null) return 0.0;
		if(heightMap.filter == Linear && !fast){
			inline function getPix(u, v){
				return pixels.getPixelF(Std.int(hxd.Math.clamp(u, 0, pixels.width - 1)), Std.int(hxd.Math.clamp(v, 0, pixels.height - 1))).r;
			}
			var px = u * (heightMap.width - 1) + 0.5;
            var py = v * (heightMap.width - 1) + 0.5;
			var pxi = hxd.Math.floor(px);
            var pyi = hxd.Math.floor(py);
			var c00 = getPix(pxi, pyi);
			var c10 = getPix(pxi + 1, pyi);
			var c01 = getPix(pxi, pyi + 1);
			var c11 = getPix(pxi + 1, pyi + 1);
			var wx = px - pxi;
			var wy = py - pyi;
			var a = c00 * (1 - wx) + c10 * wx;
			var b = c01 * (1 - wx) + c11 * wx;
			return a * (1 - wy) + b * wy;

		}
		else{
			var x = hxd.Math.floor(u * (heightMap.width - 1) + 0.5);
			var y = hxd.Math.floor(v * (heightMap.height - 1) + 0.5);
			return pixels.getPixelF(x, y).r;
		}
	}

	public override function dispose() {
		if(heightMap != null) heightMap.dispose();
		if(surfaceIndexMap != null) surfaceIndexMap.dispose();
		for(i in 0 ... surfaceWeights.length)
			if( surfaceWeights[i] != null) surfaceWeights[i].dispose();
	}

	var cachedBounds : h3d.col.Bounds;
	var cachedHeightBound : Bool = false;
	override function emit( ctx:RenderContext ){
		if(!isReady()) return;
		if(cachedBounds == null) {
			cachedBounds = getBounds();
			cachedBounds.zMax = 0;
			cachedBounds.zMin = 0;
		}
		if(cachedBounds != null && cachedHeightBound == false && heightMap != null){
			for( u in 0 ... heightMap.width ){
				for( v in 0 ... heightMap.height ){
					var h = getHeight(u / heightMap.width, v / heightMap.height, true);
					cachedBounds.zMin = cachedBounds.zMin > h ? h : cachedBounds.zMin;
					cachedBounds.zMax = cachedBounds.zMax < h ? h : cachedBounds.zMax;
				}
			}
			cachedHeightBound = true;
		}
		if(ctx.camera.frustum.hasBounds(cachedBounds))
			super.emit(ctx);
	}

	override function sync(ctx:RenderContext) {
		if(!isReady()) return;

		shader.SHOW_GRID = getTerrain().showGrid;
		shader.SURFACE_COUNT = getTerrain().surfaces.length;
		shader.CHECKER = getTerrain().showChecker;
		shader.COMPLEXITY = getTerrain().showComplexity;

		shader.heightMapSize = heightMap.width;
		shader.primSize = getTerrain().tileSize;
		shader.cellSize = getTerrain().cellSize;

		shader.albedoTextures = getTerrain().surfaceArray.albedo;
		shader.normalTextures = getTerrain().surfaceArray.normal;
		shader.pbrTextures = getTerrain().surfaceArray.pbr;
		shader.weightTextures = surfaceWeightArray;
		shader.heightMap = heightMap;
		shader.surfaceIndexMap = surfaceIndexMap;

		shader.surfaceParams = getTerrain().surfaceArray.params;
		shader.secondSurfaceParams = getTerrain().surfaceArray.secondParams;
		shader.tileIndex.set(tileX, tileY); // = new h3d.Vector(tileX, tileY);
		shader.parallaxAmount = getTerrain().parallaxAmount;
		shader.minStep = getTerrain().parallaxMinStep;
		shader.maxStep = getTerrain().parallaxMaxStep;
		shader.heightBlendStrength = getTerrain().heightBlendStrength;
		shader.heightBlendSharpness = getTerrain().heightBlendSharpness;
	}

	function isReady(){
		if( getTerrain().surfaceArray == null || getTerrain().surfaces.length == 0 || surfaceWeights.length != getTerrain().surfaces.length)
			return false;
		if( heightMap == null )
			return false;
		for( i in 0 ... surfaceWeights.length )
			if( surfaceWeights[i] == null )
				return false;
		return true;
	}

	override function getLocalCollider():h3d.col.Collider {
		return null;
	}
}
