package h2d.domkit;

class Style extends domkit.CssStyle {

	var currentObjects : Array<h2d.Object> = [];
	var resources : Array<hxd.res.Resource> = [];
	var errors : Array<String>;
	var errorsText : h2d.Text;

	public function new() {
		super();
	}

	public function load( r : hxd.res.Resource ) {
		r.watch(function() {
			#if (sys || nodejs)
			var fs = hxd.impl.Api.downcast(hxd.res.Loader.currentInstance.fs, hxd.fs.LocalFileSystem);
			if( fs != null ) fs.clearCache();
			#end
			onChange();
		});
		resources.push(r);
		add(new domkit.CssParser().parseSheet(r.entry.getText()));
		for( o in currentObjects )
			o.dom.applyStyle(this);
	}

	public function addObject( obj ) {
		currentObjects.remove(obj);
		currentObjects.push(obj);
		obj.dom.applyStyle(this);
	}

	public function removeObject(obj) {
		currentObjects.remove(obj);
	}

	/**
		Returns number of dom elements that were updated
	**/
	public function sync() {
		var T0 = domkit.CssStyle.TAG;
		for( o in currentObjects )
			o.dom.applyStyle(this, true);
		return domkit.CssStyle.TAG - T0;
	}

	override function onInvalidProperty(e:domkit.Properties<Dynamic>, s:domkit.CssStyle.RuleStyle, msg:String) {
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
			o.dom.applyStyle(this);
		if( errors.length == 0 ) {
			if( errorsText != null ) {
				errorsText.parent.remove();
				errorsText = null;
			}
		} else {
			if( errorsText == null ) {
				if( currentObjects.length == 0 ) return;
				var scene = currentObjects[0].getScene();
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

}
