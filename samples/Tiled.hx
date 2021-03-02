import hxd.res.TiledMap.TiledMapData;

// Renders a Tiled tile map directly from a .tmx source file
// Tiled Options Required in your map:
//  Tile Layer Format: Base64 (zlib compressed)
//  Tile Render Order: Left Down

class Tiled extends hxd.App {

	inline static var TILE_SIZE:Int = 16;
	var tiles:h2d.TileGroup;
	var obj:h2d.Object;

	override function init() {
		var tiledMapData = hxd.Res.tileMap.toMap(); // .tmx file
		var tiles = hxd.Res.tiles.toTile();			// tile sheet used in .tmx file above

		// Specify the layers in the order they appear in the .tmx file
		// Currently the layer id and name attribute or not stored in the TiledMapData format
		drawLayer(tiledMapData, tiles, 0, TILE_SIZE);
		drawLayer(tiledMapData, tiles, 1, TILE_SIZE);
		drawLayer(tiledMapData, tiles, 2, TILE_SIZE);
		drawLayer(tiledMapData, tiles, 3, TILE_SIZE);
	}

	function drawLayer(map:TiledMapData, tiles:h2d.Tile, layer:Int, size:Int) {
		var tileGroup = new h2d.TileGroup(tiles);
		var tileSetArray = tiles.gridFlatten(TILE_SIZE, 0, 0);
		if( map.layers.length > 0 && layer < map.layers.length ) {
			var tileX = 0;
			var tileY = 0;
			for( tileId in map.layers[layer].data ) {
				// Tiled stores empty tiles as 0 and offsets the tileId by 1 so we must skip empty tiles and adjust the tileId back to the proper index 
				if( tileId > 0 && tileId < tileSetArray.length ) tileGroup.add(tileX, tileY, tileSetArray[tileId - 1]);
				tileX += size;
				if( tileX >= map.width * size ) {
					tileX = 0; 
					tileY += size;
				}
			}
		}

		s2d.addChild(tileGroup);
	}

	static function main() {
		hxd.Res.initEmbed();
		new Tiled();
	}
}