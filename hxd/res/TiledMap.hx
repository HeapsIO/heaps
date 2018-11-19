package hxd.res;

#if (format_tiled >= "2.0.0")

import format.tmx.Data;
import format.tmx.Reader;
using format.tmx.Tools;

typedef TiledMapData = {
	var tmx : TmxMap;
	/** Optional list of loaded tilesets when loading map with `loadTilesets = true`. **/
	var tilesets : Array<TiledMapTileset>;
}

typedef TiledMapTileset = {
	var tileset : TmxTileset;
	/**
		List of all tiles in the tileset.
		Note that they are not guaranteed to share the same texture, if tileset is an image set.
	**/
	var tiles : Array<h2d.Tile>;
}

class TiledMap extends Resource {

	var reader : Reader;

	/**
		Parses TMX file and optionally resolves TSX references and loads tileset images. objectTypes can be provided to add their properties to objects.
	**/
	public function toMap(resolveTsx = true, loadTilesets = true, ?objectTypes:Map<String, TmxObjectTypeTemplate>) : TiledMapData {
		
		reader = new Reader();
		if ( resolveTsx ) reader.resolveTSX = loadTsx;
		if ( objectTypes != null ) reader.resolveTypeTemplate = objectTypes.get;

		var tmx = reader.read(Xml.parse(entry.getText()));
		var data : TiledMapData = {
			tmx: tmx,
			tilesets: null
		};
		if ( loadTilesets ) {
			var tilesets = data.tilesets = new Array();
			for ( tset in tmx.tilesets ) {
				var tileset : TiledMapTileset = {
					tileset: tset,
					tiles: new Array()
				};
				if (tset.image != null && tset.image.source != null) {
					if (haxe.io.Path.isAbsolute(tset.image.source)) throw "Cannot load tileset image with absolute path!";
					var texture = hxd.res.Loader.currentInstance.load(haxe.io.Path.join([entry.directory, tset.image.source])).toTexture();
					var x : Int = tset.margin;
					var xmax = texture.width - tset.margin;
					var y : Int = tset.margin;
					var ox = 0;
					var oy = 0;
					if (tset.tileOffset != null) {
						ox = tset.tileOffset.x;
						oy = tset.tileOffset.y;
					}
					for ( i in 0...tset.tileCount ) {
						tileset.tiles.push(@:privateAccess new h2d.Tile(texture, x, y, tset.tileWidth, tset.tileHeight, ox, oy));
						x += tset.tileWidth + tset.spacing;
						if (x >= xmax) {
							x = tset.margin;
							y += tset.tileHeight + tset.spacing;
						}
					}
				} else {
					// Image collection
					for (tile in tset.tiles) {
						if (haxe.io.Path.isAbsolute(tile.image.source)) throw "Cannot load tileset image with absolute path!";
						tileset.tiles.push(hxd.res.Loader.currentInstance.load(haxe.io.Path.join([entry.directory, tset.image.source])).toTile());
					}
				}
				tilesets.push(tileset);
			}
		}
		reader = null;
		return data;
	}

	function loadTsx( path : String ) : TmxTileset {
		if (haxe.io.Path.isAbsolute(path)) throw "Cannot load TSX with absolute path!";
		var res = hxd.res.Loader.currentInstance.load( haxe.io.Path.join([entry.directory, path]));
		if ( res != null ) {
			return reader.readTSX(Xml.parse(res.entry.getText()));
		}
		throw "Could not find Tsx at path '" + path + "' relative to '" + entry.directory + "'!";
	}

}

#else

#if (haxe_ver < 4)
import haxe.xml.Fast in Access;
#else
import haxe.xml.Access;
#end

typedef TiledMapLayer = {
	var data : Array<Int>;
	var name : String;
	var opacity : Float;
	var objects : Array<{ x: Int, y : Int, name : String, type : String }>;
}

typedef TiledMapData = {
	var width : Int;
	var height : Int;
	var layers : Array<TiledMapLayer>;
}

class TiledMap extends Resource {

	public function toMap() : TiledMapData {
		var data = entry.getBytes().toString();
		var base = new haxe.crypto.BaseCode(haxe.io.Bytes.ofString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"));
		var x = new Access(Xml.parse(data).firstElement());
		var layers = [];
		for( l in x.nodes.layer ) {
			var data = StringTools.trim(l.node.data.innerData);
			while( data.charCodeAt(data.length-1) == "=".code )
				data = data.substr(0, data.length - 1);
			var bytes = haxe.io.Bytes.ofString(data);
			var bytes = base.decodeBytes(bytes);
			bytes = format.tools.Inflate.run(bytes);
			var input = new haxe.io.BytesInput(bytes);
			var data = [];
			for( i in 0...bytes.length >> 2 )
				data.push(input.readInt32());
			layers.push( {
				name : l.att.name,
				opacity : l.has.opacity ? Std.parseFloat(l.att.opacity) : 1.,
				objects : [],
				data : data,
			});
		}
		for( l in x.nodes.objectgroup ) {
			var objs = [];
			for( o in l.nodes.object )
				if( o.has.name )
					objs.push( { name : o.att.name, type : o.has.type ? o.att.type : null, x : Std.parseInt(o.att.x), y : Std.parseInt(o.att.y) } );
			layers.push( {
				name : l.att.name,
				opacity : 1.,
				objects : objs,
				data : null,
			});
		}
		return {
			width : Std.parseInt(x.att.width),
			height : Std.parseInt(x.att.height),
			layers : layers,
		};
	}

}

#end