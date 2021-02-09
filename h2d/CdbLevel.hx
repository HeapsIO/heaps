package h2d;

#if !castle
"Please compile with -lib castle"
#end

/**
	[CastleDB](http://castledb.org) integration; A part of `CdbLevel` decoder.
**/
typedef TileSpec = {
	var file(default, never) : String;
	var stride(default, never) : Int;
	var size(default, never) : Int;
}

/**
	[CastleDB](http://castledb.org) integration; A part of `CdbLevel` decoder.
**/
typedef LayerSpec = {
	var name : String;
	var data : cdb.Types.TileLayer;
}

/**
	[CastleDB](http://castledb.org) integration; A part of `CdbLevel` decoder.
**/
typedef LevelSpec = {
	var width : Int;
	var height : Int;
	var props : cdb.Data.LevelProps;
	var tileProps(default, null) : Array<Dynamic>;
	var layers : Array<LayerSpec>;
}

/**
	[CastleDB](http://castledb.org) integration; A part of `CdbLevel` decoder.
**/
class LevelTileset {
	public var stride : Int;
	public var size : Int;
	public var res : hxd.res.Image;
	public var tile : h2d.Tile;
	public var tiles : Array<h2d.Tile>;
	public var objects : Array<LevelObject>;
	public var groups : Map<String, LevelGroup>;
	public var groupsById : Array<LevelGroup>;
	public var tilesProps(get, never) : Array<Dynamic>;
	var props :	cdb.Data.TilesetProps;
	var tileBuilder : cdb.TileBuilder;
	public function new() {
	}
	inline function get_tilesProps() return props.props;
	public function getTileBuilder() {
		if( tileBuilder == null )
			tileBuilder = new cdb.TileBuilder(props, stride, tiles.length);
		return tileBuilder;
	}
}

/**
	[CastleDB](http://castledb.org) integration; A part of `CdbLevel` decoder.
**/
class LevelObject {
	public var tileset : LevelTileset;
	public var id : Int;
	public var x : Int;
	public var y : Int;
	public var width : Int;
	public var height : Int;
	public var props : Dynamic;
	public var tile : h2d.Tile;

	public function new(tset, x, y, w, h) {
		this.tileset = tset;
		this.x = x;
		this.y = y;
		id = x + y * tileset.stride;
		width = w;
		height = h;
		var sz = tileset.size;
		tile = tileset.tile.sub(x * sz, y * sz, width * sz, height * sz);
	}
}

/**
	[CastleDB](http://castledb.org) integration; A part of `CdbLevel` decoder.
**/
class LevelGroup {
	public var tileset : LevelTileset;
	public var name : String;
	public var id : Int;
	public var x : Int;
	public var y : Int;
	public var width : Int;
	public var height : Int;
	public var tile : h2d.Tile;
	public var value : Dynamic;

	public function new(name, tset, x, y, w, h, val) {
		this.tileset = tset;
		this.x = x;
		this.y = y;
		id = x + y * tileset.stride;
		this.name = name;
		width = w;
		height = h;
		var sz = tileset.size;
		tile = tileset.tile.sub(x * sz, y * sz, w * sz, h * sz);
		value = val;
	}
}

/**
	[CastleDB](http://castledb.org) integration; A part of `CdbLevel` decoder.
**/
class LevelObjectInstance {
	public var x : Int;
	public var y : Int;
	public var rot : Int;
	public var flip : Bool;
	public var obj : LevelObject;
	public function new() {
	}
}

/**
	[CastleDB](http://castledb.org) integration; A part of `CdbLevel` decoder.
**/
enum LevelLayerData {
	LTiles( data : Array<Int> );
	LGround( data : Array<Int> );
	LObjects( objects : Array<LevelObjectInstance> );
}

/**
	[CastleDB](http://castledb.org) integration; A part of `CdbLevel` decoder.
**/
class LevelLayer {

	/**
		Which level this layer belongs to
	**/
	public var level : CdbLevel;

	/**
		The name of the layer, as it was created in CDB
	**/
	public var name : String;

	/**
		CdbLevel extends Layers: this index will tell in which object layer this LevelLayer content is added to.
	**/
	public var layerIndex(default,null) : Int;

	/**
		The raw data of the layer. You can read it or modify it then set needRedraw=true to update it on screen.
	**/
	public var data : LevelLayerData;

	/**
		The tileset this layer is using to display its graphics
	**/
	public var tileset : LevelTileset;

	/**
		If the layer needs to be redrawn, it's set to true.
	**/
	public var needRedraw = true;

	/**
		Allows to add objects on the same layerIndex that can behind or in front of the
	**/
	public var objectsBehind(default, set) : Bool;

	/**
		One or several tile groups that will be used to display the layer
	**/
	public var contents : Array<h2d.TileGroup>;

	/**
		Alias to the first element of contents
	**/
	public var content(get, never) : h2d.TileGroup;

	public function new(level) {
		this.level = level;
	}

	inline function get_content() {
		return contents[0];
	}

	/**
		Entirely removes this layer from the level.
	**/
	public function remove() {
		for( c in contents )
			c.remove();
		contents = [];
		level.layers.remove(this);
		@:privateAccess level.layersMap.remove(name);
	}

	/**
		Returns the data for the given CDB per-tile property based on the data of the current layer.
		For instance if you have a "collide" per-tile property set for several of your objects or tiles,
		then calling buildIntProperty("collide") will return you with the collide data for the given layer.
		In case of objects, if several objects overlaps, the greatest property value overwrites the lowest.
	**/
	public function buildIntProperty( name : String ) {
		var tprops = [for( p in tileset.tilesProps ) p == null ? 0 : Reflect.field(p, name)];
		var out = [for( i in 0...level.width * level.height ) 0];
		switch( data ) {
		case LTiles(data), LGround(data):
			for( i in 0...level.width * level.height ) {
				var t = data[i];
				if( t == 0 ) continue;
				out[i] = tprops[t - 1];
			}
		case LObjects(objects):
			for( o in objects ) {
				var ox = Std.int(o.x / tileset.size);
				var oy = Std.int(o.y / tileset.size);
				for( dy in 0...o.obj.height )
					for( dx in 0...o.obj.width ) {
						var idx = ox + dx + (oy + dy) * level.width;
						var cur = tprops[o.obj.id + dx + dy * tileset.stride];
						if( cur > out[idx] )
							out[idx] = cur;
					}
			}
		}
		return out;
	}

	public function buildStringProperty( name : String ) {
		var tprops = [for( p in tileset.tilesProps ) p == null ? null : Reflect.field(p, name)];
		var out : Array<String> = [for( i in 0...level.width * level.height ) null];
		switch( data ) {
		case LTiles(data), LGround(data):
			for( i in 0...level.width * level.height ) {
				var t = data[i];
				if( t == 0 ) continue;
				out[i] = tprops[t - 1];
			}
		case LObjects(objects):
			for( o in objects ) {
				var ox = Std.int(o.x / tileset.size);
				var oy = Std.int(o.y / tileset.size);
				for( dy in 0...o.obj.height )
					for( dx in 0...o.obj.width ) {
						var idx = ox + dx + (oy + dy) * level.width;
						var cur = tprops[o.obj.id + dx + dy * tileset.stride];
						if( cur != null )
							out[idx] = cur;
					}
			}
		}
		return out;
	}

	function set_objectsBehind(v) {
		if( v == objectsBehind )
			return v;
		if( v && !data.match(LObjects(_)) )
			throw "Can only set objectsBehind for 'Objects' Layer Mode";
		needRedraw = true;
		return objectsBehind = v;
	}
}

/**
	A decoder and renderer for levels created with the CastleDB 2D level editor.
	See http://castledb.org for more details.
**/
class CdbLevel extends Layers {

	public var width(default, null) : Int;
	public var height(default, null) : Int;
	public var level(default, null) : LevelSpec;
	public var layers : Array<LevelLayer>;
	var tilesets : Map<String, LevelTileset>;
	var layersMap : Map<String, LevelLayer>;
	var levelsProps : cdb.Data.LevelsProps;

	public function new(allLevels:cdb.Types.Index<Dynamic>,index:Int,?parent) {
		super(parent);
		levelsProps = @:privateAccess allLevels.sheet.props.level;
		level = allLevels.all[index];
		width = level.width;
		height = level.height;
		tilesets = new Map();
		layersMap = new Map();
		layers = [];
		for( ldat in level.layers ) {
			var l = loadLayer(ldat);
			if( l != null ) {
				@:privateAccess l.layerIndex = layers.length;
				layers.push(l);
				layersMap.set(l.name, l);

				var content = new h2d.TileGroup(l.tileset.tile);
				add(content, l.layerIndex);
				l.contents = [content];
			}
		}
	}

	public function getLevelLayer( name : String ) : LevelLayer {
		return layersMap.get(name);
	}

	public function buildIntProperty( name : String ) {
		var collide = null;
		for( l in layers ) {
			var layer = l.buildIntProperty(name);
			if( collide == null )
				collide = layer;
			else
				for( i in 0...width	* height ) {
					var v = layer[i];
					if( v != 0 && v > collide[i] ) collide[i] = v;
				}
		}
		if( collide == null ) collide = [for( i in 0...width * height ) 0];
		return collide;
	}

	override function getBoundsRec(relativeTo:Object, out:h2d.col.Bounds, forSize:Bool) {
		redraw();
		super.getBoundsRec(relativeTo, out, forSize);
	}

	public function buildStringProperty( name : String ) {
		var collide = null;
		for( l in layers ) {
			var layer = l.buildStringProperty(name);
			if( collide == null )
				collide = layer;
			else
				for( i in 0...width	* height ) {
					var v = layer[i];
					if( v != null ) collide[i] = v;
				}
		}
		if( collide == null ) collide = [for( i in 0...width * height ) null];
		return collide;
	}

	public function getTileset( file : String ) : LevelTileset {
		return tilesets.get(file);
	}

	function redrawLayer( l : LevelLayer ) {
		for( c in l.contents )
			c.clear();
		l.needRedraw = false;
		var pos = 0;
		switch( l.data ) {
		case LTiles(data), LGround(data):
			var size = l.tileset.size;
			var tiles = l.tileset.tiles;
			var i = 0;
			var content = l.contents[pos++];
			for( y in 0...height )
				for( x in 0...width ) {
					var t = data[i++];
					if( t == 0 ) continue;
					content.add(x * size, y * size, tiles[t - 1]);
				}
			if( l.data.match(LGround(_)) ) {
				var b = l.tileset.getTileBuilder();
				var grounds = b.buildGrounds(data, width);
				var glen = grounds.length;
				var i = 0;
				while( i < glen ) {
					var x = grounds[i++];
					var y = grounds[i++];
					var t = grounds[i++];
					content.add(x * size, y * size, tiles[t]);
				}
			}
		case LObjects(objects):
			if( l.objectsBehind ) {
				var pos = 0;
				var byY = [];
				var curY = -1;
				var content = null;
				for( o in objects ) {
					var baseY = o.y + Std.int(o.obj.tile.height);
					if( baseY != curY ) {
						curY = baseY;
						content = byY[baseY];
						if( content == null ) {
							content = l.contents[pos++];
							if( content == null ) {
								content = new h2d.TileGroup(l.tileset.tile);
								add(content, l.layerIndex);
								l.contents.push(content);
							}
							content.y = baseY;
							byY[baseY] = content;
						}
					}
					content.add(o.x, o.y - baseY, o.obj.tile);
				}
			} else {
				var content = l.contents[pos++];
				for( o in objects )
					content.add(o.x, o.y, o.obj.tile);
			}
		}
		// clean extra lines
		while( pos > 0 && l.contents[pos] != null )
			l.contents.pop().remove();
	}

	function loadTileset( ldat : TileSpec ) : LevelTileset {
		var t = new LevelTileset();
		t.size = ldat.size;
		t.stride = ldat.stride;
		t.res = hxd.res.Loader.currentInstance.load(ldat.file).toImage();
		t.tile = t.res.toTile();
		t.tiles = t.tile.gridFlatten(t.size);
		t.objects = [];
		t.groupsById = [];
		t.groups = new Map<String, LevelGroup>();
		var tprops = Reflect.field(levelsProps.tileSets, ldat.file);
		@:privateAccess t.props = tprops;
		if( tprops != null ) {
			var hasBorder = false;
			for( s in tprops.sets )
				switch( s.t ) {
				case Object:
					var o = new LevelObject(t, s.x, s.y, s.w, s.h);
					t.objects[o.id] = o;
				case Group:
					var name = s.opts.name;
					var g = new LevelGroup(name, t, s.x, s.y, s.w, s.h, s.opts.value);
					if (name != null) t.groups.set(name, g);
					t.groupsById[g.id] = g;
				case Ground, Border, Tile:
					// nothing
				}
		}
		return t;
	}

	function resolveTileset( tdat : TileSpec ) {
		var t = tilesets.get(tdat.file);
		if( t == null ) {
			t = loadTileset(tdat);
			if( t == null )
				return null;
			tilesets.set(tdat.file, t);
		}
		if( t.stride != tdat.stride || t.size != tdat.size )
			throw "Tileset " + tdat.file+" is used with different stride/size";
		return t;
	}

	function loadLayer( ldat : LayerSpec ) : LevelLayer {
		if( ldat.data == null )
			return null;
		var t = resolveTileset(ldat.data);
		if( t == null )
			return null;
		var l = new LevelLayer(this);
		l.name = ldat.name;
		l.tileset = t;
		var data = ldat.data.data.decode();
		var lprops = null;
		for( lp in level.props.layers )
			if( lp.l == l.name ) {
				lprops = lp.p;
				break;
			}
		var mode : cdb.Data.LayerMode = lprops != null && lprops.mode != null ? lprops.mode : Tiles;
		switch( mode ) {
		case Tiles:
			l.data = LTiles(data);
		case Ground:
			l.data = LGround(data);
		case Objects:
			var objs = [];
			var i = 1;
			var len = data.length;
			while( i < len ) {
				var x = data[i++];
				var y = data[i++];
				var t = data[i++];
				var e = new LevelObjectInstance();
				e.x = x & 0x7FFF;
				e.y = y & 0x7FFF;
				e.rot = (x >> 15) | ((y >> 15) << 1);
				e.flip = (t >> 15) != 0;
				t &= 0x7FFF;
				e.obj = l.tileset.objects[t];
				if( e.obj == null ) {
					// create new 1x1 object
					var o = new LevelObject(l.tileset, t%l.tileset.stride, Std.int(t/l.tileset.stride), 1, 1);
					e.obj = l.tileset.objects[t] = o;
				}
				objs.push(e);
			}
			l.data = LObjects(objs);
			l.objectsBehind = true;
		}
		return l;
	}

	public function redraw() {
		for( l in layers )
			if( l.needRedraw )
				redrawLayer(l);
	}

	override function sync(ctx:RenderContext) {
		super.sync(ctx);
		for( l in layers ) {
			if( l.needRedraw )
				redrawLayer(l);
			if( l.objectsBehind )
				ysort(l.layerIndex);
		}
	}

}
