using h3d.fbx.Data;

class FbxTree {

	public static function main() {
		var path = Sys.args()[0];
		if( path == null ) {
			Sys.println("Please enter file path");
			return;
		}
		var file = sys.io.File.getContent(path);
		var root : FbxNode =  h3d.fbx.Parser.parse(file);
		
		var parents = new IntHash();
		var childs = new IntHash();

		var rootObjects = [];
		var objects = new IntHash();
		
		objects.set(0, root);
		rootObjects.push(root);
		
		for( o in root.get("Objects").childs ) {
			objects.set(o.props[0].toInt(), o);
			rootObjects.push(o);
		}
		
		for( c in root.getAll("Connections.C") ) {
			var cid = c.props[1].toInt();
			var pid = c.props[2].toInt();
			
			rootObjects.remove(objects.get(cid));
			
			var pl = parents.get(cid);
			if( pl == null ) {
				pl = [];
				parents.set(cid, pl);
			}
			pl.push(pid);

			var cl = childs.get(pid);
			if( cl == null ) {
				cl = [];
				childs.set(pid, cl);
			}
			cl.push(cid);
		}
		
		function highestDepth( id : Int, stack : IntHash<Bool> ) {
			if( stack.get(id) )
				return 0;
			var pl = parents.get(id);
			if( pl == null )
				return 0;
			stack.set(id, true);
			var max = 0;
			for( p in pl ) {
				var d = highestDepth(p, stack);
				if( d > max )
					max = d;
			}
			return 1 + max;
		}
		
		var marked = new IntHash();
		function genRec( o : FbxNode, tabs : String ) {
			var id = o.props[0].toInt();
			var m = marked.get(id);
			Sys.println(tabs + id + " " + o.props[1].toString() + "(" + o.props[2].toString() + ")" + (m?" [REF]":""));
			if( m ) return;
			tabs += "\t";
			marked.set(id, true);
			var childs = childs.get(id);
			if( childs == null )
				return;
			var oc = [];
			for( cid in childs ) {
				var o = objects.get(cid);
				oc.push( { o : o, d : highestDepth(cid,new IntHash()) } );
			}
			//oc.sort(function(o1, o2) return o1.d - o2.d);
			for( o in oc )
				genRec(o.o, tabs);
		}
		for( r in rootObjects )
			genRec(r, "");
	}
	
}