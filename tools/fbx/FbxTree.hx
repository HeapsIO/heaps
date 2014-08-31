using hxd.fmt.fbx.Data;

class FbxTree {

	#if neko
	public static function main() {
		var path = Sys.args()[0];
		if( path == null ) {
			Sys.println("Please enter file path");
			return;
		}
		var file = sys.io.File.getContent(path);
		var root : FbxNode =  h3d.fbx.Parser.parse(file);
		var str = toString(root);
	}
	#end

	public static function toXml( root : FbxNode ) {
		var buf = new StringBuf();

		var parents = new Map();
		var childs = new Map();

		var rootObjects = [];
		var objects = new Map();

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

		function highestDepth( id : Int, stack : Map<Int,Bool> ) {
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

		var marked = new Map();
		function genRec( o : FbxNode, tabs : String ) {
			var id = o.props[0].toInt();
			var m = marked.get(id);
			var type = o.name;
			if( type == "" ) type = "A";
			buf.add(tabs + '<$type id="$id" name="${o.props[1].toString()}" type="${o.props[2].toString()}"');
			if( m ) {
				buf.add('>REF</$type>\n');
				return;
			}
			tabs += "\t";
			marked.set(id, true);
			var childs = childs.get(id);
			if( childs == null ) {
				buf.add("/>\n");
				return;
			}
			buf.add(">\n");
			var oc = [];
			for( cid in childs ) {
				var o = objects.get(cid);
				oc.push( { o : o, d : highestDepth(cid,new Map()) } );
			}
			//oc.sort(function(o1, o2) return o1.d - o2.d);
			for( o in oc )
				genRec(o.o, tabs);
			buf.add(tabs.substr(1)+'</$type>\n');
		}
		buf.add("<FBX>\n");
		for( r in rootObjects )
			genRec(r, "");
		buf.add("</FBX>\n");

		return buf.toString();
	}

	public static function toString( root : FbxNode ) {
		var buf = new StringBuf();

		var parents = new Map();
		var childs = new Map();

		var rootObjects = [];
		var objects = new Map();

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

		function highestDepth( id : Int, stack : Map<Int,Bool> ) {
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

		var marked = new Map();
		function genRec( o : FbxNode, tabs : String ) {
			var id = o.props[0].toInt();
			var m = marked.get(id);
			buf.add(tabs + id + " " + o.props[1].toString() + "(" + o.props[2].toString() + ")" + (m?" [REF]":"")+"\n");
			if( m ) return;
			tabs += "\t";
			marked.set(id, true);
			var childs = childs.get(id);
			if( childs == null )
				return;
			var oc = [];
			for( cid in childs ) {
				var o = objects.get(cid);
				oc.push( { o : o, d : highestDepth(cid,new Map()) } );
			}
			//oc.sort(function(o1, o2) return o1.d - o2.d);
			for( o in oc )
				genRec(o.o, tabs);
		}
		for( r in rootObjects )
			genRec(r, "");

		return buf.toString();
	}

}