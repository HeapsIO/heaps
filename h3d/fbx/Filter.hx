package h3d.fbx;
import h3d.fbx.Data;

class Filter {
	
	var ignoreList : Array<Array<String>>;
	
	public function new() {
		ignoreList = [];
	}
	
	public function ignore( path : String ) {
		ignoreList.push(path.split("."));
	}
	
	public function filter( f : FbxNode ) : FbxNode {
		var f2 = filterRec(f, ignoreList, 0);
		// TODO : rebuild connections !
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
		index++;
		for( c in f.childs ) {
			var fs = filterRec(c, sub, index);
			if( fs != null )
				f2.childs.push(fs);
		}
		return f2;
	}

}
