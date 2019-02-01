package h2d.domkit;

class Style extends domkit.CssStyle {

	var currentObjects : Array<h2d.domkit.Object> = [];
	var resources : Array<hxd.res.Resource> = [];

	public function new() {
		super();
	}

	public function load( r : hxd.res.Resource ) {
		r.watch(function() onChange());
		resources.push(r);
		add(new domkit.CssParser().parseSheet(r.entry.getText()));
		for( o in currentObjects )
			o.document.setStyle(this);
	}

	public function applyTo( obj ) {
		currentObjects.remove(obj);
		currentObjects.push(obj);
		obj.document.setStyle(this);
	}

	function remove(obj) {
		currentObjects.remove(obj);
	}

	function onChange( ntry : Int = 0 ) {
		if( ntry >= 10 ) return;
		ntry++;
		var oldRules = rules;
		rules = [];
		for( r in resources ) {
			var txt = try r.entry.getText() catch( e : Dynamic ) { haxe.Timer.delay(onChange.bind(ntry),100); rules = oldRules; return; }
			add(new domkit.CssParser().parseSheet(txt));
		}
		for( o in currentObjects )
			o.document.setStyle(this);
	}

}