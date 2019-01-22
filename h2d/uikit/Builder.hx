package h2d.uikit;
import h2d.uikit.BaseComponents;

class Builder {

	static var IS_EMPTY = ~/^[ \r\n\t]*$/;

	public var errors : Array<String> = [];
	var path : Array<String> = [];

	public function new() {
	}

	function error( msg : String ) {
		errors.push(msg+" "+path.join("."));
	}

	function loadTile( path : String ) {
		return hxd.res.Loader.currentInstance.load(path).toTile();
	}

	public function build( x : Xml ) : Document {
		var doc = new Document();
		switch( x.nodeType ) {
		case Document:
			for( e in x ) {
				var e = buildRec(e, null);
				if( e != null ) doc.elements.push(e);
			}
		default:
			var e = buildRec(x, null);
			if( e != null ) doc.elements.push(e);
		}
		return doc;
	}

	function buildRec( x : Xml, root : Element ) : Element {
		var inst = null;
		switch( x.nodeType ) {
		case Comment, DocType, ProcessingInstruction, Document:
			// nothing
		case CData, PCData:
			if( !IS_EMPTY.match(x.nodeValue) ) {
				// add text
				var txml = Xml.createElement("text");
				inst = buildRec(txml, root);
				if( inst != null )
					inst.setAttribute("text", VString(StringTools.trim(x.nodeValue)));
			}
		case Element:
			path.push(x.nodeName);
			var comp = @:privateAccess Component.COMPONENTS.get(x.nodeName);
			if( comp == null ) {
				error("Unknown node");
			} else {
				inst = new Element(comp.make(root == null ? null : root.obj), comp, root);
				var css = new CssParser();
				for( a in x.attributes() ) {
					var v = x.get(a);
					var pval = try css.parseValue(v) catch( e : Dynamic ) {
						path.push(a);
						error("Invalid attribute value '"+v+"' ("+e+")");
						path.pop();
						continue;
					}
					switch( inst.setAttribute(a.toLowerCase(),pval) ) {
					case Ok:
					case Unknown:
						path.push(a);
						error("Unknown attribute");
						path.pop();
					case Unsupported:
						error("Unsupported attribute "+a+" in");
					case InvalidValue(msg):
						path.push(a);
						error("Invalid attribute value"+(msg == null ? "" : " ("+msg+") for"));
						path.pop();
					}
				}
			}
			for( e in x )
				buildRec(e, inst == null ? root : inst);
			path.pop();
		}
		return inst;
	}

}
