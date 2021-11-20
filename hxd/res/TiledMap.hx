package hxd.res;
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
		var data = entry.getText();
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