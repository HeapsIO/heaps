package hxd.res;

class Atlas extends Resource {

	public function toAtlas() : Map<String,h2d.Tile> {
		var tiles = new Map();
		var lines = entry.getBytes().toString().split("\n");
		var basePath = entry.path.split("/");
		basePath.pop();
		var basePath = basePath.join("/");
		if( basePath.length > 0 ) basePath += "/";
		while( lines.length > 0 ) {
			var line = StringTools.trim(lines.shift());
			if( line == "" ) continue;
			var file = hxd.res.Loader.currentInstance.load(basePath + line).toTile();
			while( lines.length > 0 ) {
				var line = StringTools.trim(lines.shift());
				if( line == "" ) break;
				var prop = line.split(": ");
				if( prop.length > 1 ) continue;
				var key = line;
				var tileX = 0, tileY = 0, tileW = 0, tileH = 0;
				while( lines.length > 0 ) {
					var line = StringTools.trim(lines.shift());
					var prop = line.split(": ");
					if( prop.length == 1 ) {
						lines.unshift(line);
						break;
					}
					var v = prop[1];
					switch( prop[0] ) {
					case "rotate":
						if( v == "true" ) throw "Rotation not supported in atlas";
					case "xy":
						var vals = v.split(", ");
						tileX = Std.parseInt(vals[0]);
						tileY = Std.parseInt(vals[1]);
					case "size":
						var vals = v.split(", ");
						tileW = Std.parseInt(vals[0]);
						tileH = Std.parseInt(vals[1]);
					case "index", "orig", "offset":
						// ?
					default:
						trace("Unknown prop " + prop[0]);
					}
				}
				var t = file.sub(tileX, tileY, tileW, tileH);
				tiles.set(key, t);
			}
		}
		return tiles;
	}

}