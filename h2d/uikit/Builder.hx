package h2d.uikit;
import h2d.uikit.BaseComponents;

class Builder {

	static var IS_EMPTY = ~/^[ \r\n\t]*$/;

	public var errors : Array<String> = [];
	var path : Array<String> = [];
	var props : Property.PropertyParser;

	public function new() {
		props = new Property.PropertyParser();
	}

	function error( msg : String ) {
		errors.push(path.join(".")+": "+msg);
	}

	function loadTile( path : String ) {
		return hxd.res.Loader.currentInstance.load(path).toTile();
	}

	public function build( x : Xml, ?root : Element ) {
		if( root == null )
			root = new Element(new h2d.Flow(), Component.get("flow"));
		switch( x.nodeType ) {
		case Document:
			for( e in x )
				build(e, root);
		case Comment, DocType, ProcessingInstruction:
			// nothing
		case CData, PCData:
			if( !IS_EMPTY.match(x.nodeValue) ) {
				// add text
			}
		case Element:
			path.push(x.nodeName);
			var comp = @:privateAccess Component.COMPONENTS.get(x.nodeName);
			if( comp == null ) {
				error("Uknown node");
			} else {
				var inst = new Element(comp.make(root.obj), comp, root);
				var css = new CssParser();
				for( a in x.attributes() ) {
					var v = x.get(a);
					var pval = try css.parseValue(v) catch( e : Dynamic ) {
						path.push(a);
						error("Invalid attribute value '"+v+"' ("+e+")");
						path.pop();
						continue;
					}
					var p = props.parse(a, pval);
					if( p == null ) {
						path.push(a);
						error("Invalid attribute value '"+v+"'");
						path.pop();
						continue;
					}
					if( p == PUnknown ) {
						path.push(a);
						error("Unknown attribute");
						path.pop();
						continue;
					}
					if( !inst.setProp(p) )
						error("Unsupported attribute "+a);
				}
				root = inst;
			}
			for( e in x )
				build(e, root);
			path.pop();
		}
		return root;
	}

}
