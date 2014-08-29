package hxd.fmt.fbx;
using hxd.fmt.fbx.Data;

class Filter {

	var ignoreList : Array<Array<String>>;
	var removedObjects : Map<Int,Bool>;

	public function new() {
		ignoreList = [];
	}

	public function ignore( path : String ) {
		ignoreList.push(path.split("."));
	}

	public function filter( f : FbxNode ) : FbxNode {
		removedObjects = new Map();
		var f2 = filterRec(f, ignoreList, 0);
		for( i in 0...f2.childs.length ) {
			var c = f2.childs[i];
			if( c.name == "Connections" ) {
				var cnx = [];
				for( c in c.childs )
					if( !removedObjects.exists(c.props[1].toInt()) && !removedObjects.exists(c.props[2].toInt()) )
						cnx.push(c);
				f2.childs[i] = {
					name : c.name,
					props : c.props,
					childs : cnx,
				};
			}
		}
		return f2;
	}

	function filterRec( f : FbxNode, match : Array<Array<String>>, index : Int ) {
		var sub = [];
		for( m in match )
			if( m[index] == f.name ) {
				if( m.length == index + 1 )
					return null;
				sub.push(m);
			}
		if( sub.length == 0 )
			return f;
		var f2 = {
			name : f.name,
			props : f.props.copy(),
			childs : [],
		};
		var isObjects = index == 1 && f.name == "Objects";
		index++;
		for( c in f.childs ) {
			var fs = filterRec(c, sub, index);
			if( fs != null )
				f2.childs.push(fs);
			else if( isObjects )
				removedObjects.set(c.getId(),true);
		}
		return f2;
	}

}
