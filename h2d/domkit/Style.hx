package h2d.domkit;

class Style extends domkit.CssStyle {

	var currentObjects : Array<h2d.domkit.Object> = [];
	var resources : Array<hxd.res.Resource> = [];
	var errors : Array<String>;
	var errorsText : h2d.Text;

	public function new() {
		super();
	}

	public function load( r : hxd.res.Resource ) {
		r.watch(function() onChange());
		resources.push(r);
		add(new domkit.CssParser().parseSheet(r.entry.getText()));
		for( o in currentObjects )
			getDocument(o).setStyle(this);
	}

	public function applyTo( obj ) {
		currentObjects.remove(obj);
		currentObjects.push(obj);
		getDocument(obj).setStyle(this);
	}

	function remove(obj) {
		currentObjects.remove(obj);
	}

	override function onInvalidProperty(e:domkit.Element<Dynamic>, s:domkit.CssStyle.RuleStyle, msg:String) {
		if( errors != null ) {
			var path = s.p.name;
			var ee = e;
			while(ee != null) {
				path = (ee.id != null ? "#" + ee.id : ee.component.name) + "." + path;
				ee = ee.parent;
			}

			if( msg == null ) msg = "Invalid property value '"+(domkit.CssParser.valueStr(s.value))+"'";
			errors.push(msg+" for " + path);
		}
	}

	function onChange( ntry : Int = 0 ) {
		if( ntry >= 10 ) return;
		ntry++;
		var oldRules = rules;
		errors = [];
		rules = [];
		for( r in resources ) {
			var txt = try r.entry.getText() catch( e : Dynamic ) { haxe.Timer.delay(onChange.bind(ntry),100); rules = oldRules; return; }
			var parser = new domkit.CssParser();
			try {
				add(parser.parseSheet(txt));
			} catch( e : domkit.Error ) {
				parser.warnings.push({ msg : e.message, pmin : e.pmin, pmax : e.pmax });
			}
			for( w in parser.warnings ) {
				var line = txt.substr(0,w.pmin).split("\n").length;
				errors.push(r.entry.path+":"+line+": " + w.msg);
		 	}
		}
		for( o in currentObjects )
			getDocument(o).setStyle(this);
		if( errors.length == 0 ) {
			if( errorsText != null ) {
				errorsText.parent.remove();
				errorsText = null;
			}
		} else {
			if( errorsText == null ) {
				if( currentObjects.length == 0 ) return;
				var scene = getDocument(currentObjects[0]).root.obj.getScene();
				var fl = new h2d.Flow();
				scene.addChildAt(fl,100);
				fl.backgroundTile = h2d.Tile.fromColor(0x400000,0.9);
				fl.padding = 10;
				errorsText = new h2d.Text(hxd.res.DefaultFont.get(), fl);
			}
			var fl = hxd.impl.Api.downcast(errorsText.parent, h2d.Flow);
			var sc = fl.getScene();
			fl.maxWidth = sc.width;
			errorsText.text = errors.join("\n");
			var b = fl.getBounds();
			fl.y = sc.height - Std.int(b.height);
		}
	}

	function getDocument( o : h2d.domkit.Object ) : domkit.Document<h2d.Object> {
		return (o : Dynamic).document;
	}

}