package h2d.domkit;

class Style extends domkit.CssStyle {

	var currentObjects : Array<h2d.Object> = [];
	var resources : Array<hxd.res.Resource> = [];
	var errors : Array<String>;
	var errorsText : h2d.Text;

	public var allowInspect(default, set) = false;
	public var inspectKeyCode : Int = 0;
	public var inspectDetailsKeyCode : Int = hxd.Key.CTRL;

	public function new() {
		super();
	}

	public function load( r : hxd.res.Resource, watchChanges = true ) {
		if( watchChanges ) r.watch(function() {
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

	// ------ inspector -----

	var inspectModeActive = false;
	var inspectModeDetails = false;
	var inspectModeDetailsRight = -1;
	var inspectPreview : h2d.Object;
	var inspectPreviewObjects : Array<h2d.Object>;

	function set_allowInspect(b) {
		if( allowInspect == b )
			return b;
		@:privateAccess domkit.Properties.KEEP_VALUES = b;
		if( b ) {
			hxd.Window.getInstance().addEventTarget(onWindowEvent);
			onChange();
		} else {
			hxd.Window.getInstance().removeEventTarget(onWindowEvent);
			var scenes = [];
			for( o in currentObjects ) {
				var s = o.getScene();
				if( s == null || scenes.indexOf(s) >= 0 ) continue;
				scenes.push(s);
				function scanRec(o:h2d.Object) {
					if( o.dom != null ) @:privateAccess o.dom.currentValues = null;
					for( o in o ) scanRec(o);
				}
				scanRec(s);
			}
			if( inspectModeActive ) {
				inspectModeActive = false;
				hxd.System.setNativeCursor(Default);
			}
		}
		return allowInspect = b;
	}

	function onWindowEvent( e : hxd.Event ) {
		switch( e.kind ) {
		case EPush if( inspectKeyCode == 0 || hxd.Key.isDown(inspectKeyCode) ):
			if( e.button == hxd.Key.MOUSE_MIDDLE ) {
				if(hxd.Key.isDown(inspectDetailsKeyCode)) {
					inspectModeActive = true;
					inspectModeDetails = true;
					inspectModeDetailsRight = -1;
				}
				else {
					inspectModeActive = !inspectModeActive;
					inspectModeDetails = false;
					inspectModeDetailsRight = -1;
				}

				if( inspectModeActive )
					updatePreview(e);
				else {
					clearPreview();
					hxd.System.setNativeCursor(Default);
				}
			}
		case EMove:
			if( inspectModeActive && !inspectModeDetails) updatePreview(e);
		case EWheel if( inspectKeyCode == 0 || hxd.Key.isDown(inspectKeyCode) ):
			if( inspectPreviewObjects != null ) {
				if( e.wheelDelta > 0 ) {
					var p = inspectPreviewObjects[0].parent;
					while( p != null && p.dom == null ) p = p.parent;
					if( p != null ) {
						var prev = inspectPreviewObjects;
						clearPreview();
						setPreview(p);
						inspectPreviewObjects = prev;
						inspectPreviewObjects.unshift(p);
					}
				} else if( inspectPreviewObjects.length > 1 ) {
					var prev = inspectPreviewObjects;
					clearPreview();
					prev.shift();
					setPreview(prev[0]);
					inspectPreviewObjects = prev;
				}
			}
		default:
		}
		if( inspectModeActive ) hxd.System.setNativeCursor(Move);
	}

	function clearPreview() {
		if( inspectPreview == null ) return;
		var obj = inspectPreviewObjects[0];
		var flow = Std.downcast(obj, h2d.Flow);
		if( flow != null ) flow.debug = false;
		inspectPreview.remove();
		inspectPreview = null;
		inspectPreviewObjects = null;
	}

	function updatePreview( e : hxd.Event ) {
		clearPreview();
		var checkedScenes = [];
		var ox = e.relX, oy = e.relY;
		for( o in currentObjects ) {
			var scene = o.getScene();
			if( scene == null || checkedScenes.indexOf(scene) >= 0 ) continue;
			checkedScenes.push(scene);
			e.relX = scene.mouseX;
			e.relY = scene.mouseY;
			if( lookupRec(scene, e) )
				break;
		}
		e.relX = ox;
		e.relY = oy;
	}

	function lookupRec( obj : h2d.Object, e : hxd.Event ) {
		if( !obj.visible || obj.alpha <= 0 )
			return false;
		var ch = @:privateAccess obj.children;
		for( i in 0...ch.length ) {
			if( lookupRec(ch[ch.length-1-i], e) )
				return true;
		}
		if( obj.dom == null )
			return false;
		var b = obj.getBounds();
		if( !b.contains(new h2d.col.Point(e.relX,e.relY)) )
			return false;
		if( Type.getClass(obj) == h2d.Object ) // objects containing transparent flow?
			return false;
		var fl = Std.downcast(obj, h2d.Flow);
		if( fl != null && fl.backgroundTile == null && fl.interactive == null )
			return false;
		setPreview(obj);
		return true;
	}

	@:access(domkit.Properties)
	static function getDisplayInfo(obj: h2d.Object) : String {
		var dom = obj.dom;
		var nameParts = [];
		if(dom != null) {
			nameParts.push(dom.component.name);
			if( dom.classes != null ) {
				for( c in dom.classes )
					nameParts.push("."+c);
			}
			if( dom.id != null )
				nameParts.push("#"+dom.id);
		}
		else
			nameParts.push('<font color="#aaaaaa">' + Type.getClassName(Type.getClass(obj)).split(".").pop() + '</font>');
		var sz = obj.getSize();
		nameParts.push(' <font color="#808080">${Math.ceil(sz.width)}x${Math.ceil(sz.height)}</font>');
		return nameParts.join("");
	}

	@:access(domkit.Properties)
	function setPreview( obj : h2d.Object, ?details=false) {
		var b = obj.getBounds();
		if( b.xMin < 0 ) b.xMin = 0;
		if( b.yMin < 0 ) b.yMin = 0;
		var scene = obj.getScene();
		if( scene == null ) return;

		inspectPreview = new h2d.Object();
		scene.add(inspectPreview, @:privateAccess scene.layerCount - 1);
		inspectPreviewObjects = [obj];

		if(inspectModeDetails) {
			var treeRoot = new h2d.Flow(inspectPreview);
			treeRoot.layout = Vertical;
			treeRoot.backgroundTile = h2d.Tile.fromColor(0x101010,1.0);
			treeRoot.padding = 6;
			var parents : Array<h2d.Object> = [];
			{
				var o = obj;
				for(i in 0...20) {
					o = o.parent;
					if(o == null) break;
					parents.push(o);
				}
			}
			function addBtn(o : h2d.Object, indent: Int, open: Bool) {
				var btn = new Flow(treeRoot);
				var txt = new HtmlText(hxd.res.DefaultFont.get(), btn);
				var text = getDisplayInfo(o);
				if(o.numChildren > 0 && !open)
					text = '<font color="#808080">[+] </font>' + text;
				txt.text = text;
				btn.paddingLeft = 10 * indent;
				btn.paddingTop = btn.paddingBottom = 2;
				btn.paddingRight = 10;
				btn.enableInteractive = true;
				if(o == obj)
					btn.backgroundTile = Tile.fromColor(0x50aaff, 1, 1, 0.5);
				else {
					btn.interactive.onOver = function(_) btn.backgroundTile = Tile.fromColor(0x202020, 1, 1, 1.0);
					btn.interactive.onOut = function(_) btn.backgroundTile = null;
				}
				btn.interactive.onPush = function(e) {
					clearPreview();
					setPreview(o, true);
				}
			}

			for(i in 0...parents.length)
				addBtn(parents[parents.length-1 - i], i, true);

			var thisIndent = parents.length;
			var childCount = 0;
			final maxDepth = 3;
			function addChildRec(o : h2d.Object, depth : Int) {
				if(childCount > 50) return;
				addBtn(o, thisIndent + depth, depth < maxDepth);
				++childCount;
				if(depth < maxDepth) {
					for(i in 0...o.numChildren)
						addChildRec(o.getChildAt(i), depth+1);
				}
			}
			addChildRec(obj, 0);

			if(inspectModeDetailsRight < 0)
				inspectModeDetailsRight = (scene.mouseX > scene.width / 2) ? 0 : 1;

			if(inspectModeDetailsRight > 0)
				treeRoot.x = scene.width - treeRoot.getBounds().width;
		}


		var p = new h2d.Bitmap(h2d.Tile.fromColor(0xFF0000, Math.round(b.width), Math.round(b.height), 0.1), inspectPreview);
		p.x = Math.round(b.xMin);
		p.y = Math.round(b.yMin);
		var flow = Std.downcast(obj, h2d.Flow);
		if( flow != null )
			flow.debug = true;
		else {
			var w = p.tile.iwidth;
			var h = p.tile.iheight;
			var horiz = h2d.Tile.fromColor(0xFF0000, w, 1);
			var vert = h2d.Tile.fromColor(0xFF0000, 1, h);
			new h2d.Bitmap(horiz, p);
			new h2d.Bitmap(vert, p);
			new h2d.Bitmap(horiz, p).y = h - 1;
			new h2d.Bitmap(vert, p).x = w - 1;
		}

		var prevFlow = new h2d.Flow(p);
		prevFlow.backgroundTile = h2d.Tile.fromColor(0,0.8);
		prevFlow.padding = 7;
		prevFlow.paddingTop = 4;

		var previewText = new h2d.HtmlText(hxd.res.DefaultFont.get(), prevFlow);
		var lines = [];
		lines.push(getDisplayInfo(obj));
		lines.push("");
		var dom = obj.dom;
		if(dom != null) {
			for( s in dom.style ) {
				if( s.p.name == "text" || hxd.impl.Api.isOfType(s.value,h2d.Tile) ) continue;
				lines.push(' <font color="#D0D0D0"> ${s.p.name}</font> <font color="#808080">${s.value}</font><font color="#606060"> (style)</font>');
			}
			for( i in 0...dom.currentSet.length ) {
				var p = dom.currentSet[i];
				if( p.name == "text" ) continue;
				var v = dom.currentValues == null ? null : dom.currentValues[i];
				var vstr = v == null ? "???" : StringTools.htmlEscape(domkit.CssParser.valueStr(v));
				lines.push(' <font color="#D0D0D0"> ${p.name}</font> <font color="#808080">$vstr</font>');
			}
			previewText.text = lines.join("<br/>");
		}

		var size = prevFlow.getBounds();
		if( b.xMax + size.width < scene.width )
			prevFlow.x = Std.int(b.width+2);
		else if( b.xMin - size.width > 0 )
			prevFlow.x = -Std.int(size.width+2);
		if( b.yMin + size.height + 10 > scene.height )
			prevFlow.y = Std.int(scene.height - (b.yMin + size.height + 10));
	}

}
