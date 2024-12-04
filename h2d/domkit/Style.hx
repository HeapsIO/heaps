package h2d.domkit;

typedef SourceFile = {
	name: String,
	txt: String,
	#if (format >= version("3.8.0")) sourceMap: format.map.Data, #end
}

class Style extends domkit.CssStyle {

	var currentObjects : Array<h2d.Object> = [];
	var resources : Array<hxd.res.Resource> = [];
	var errors : Array<String>;
	var errorsText : h2d.Text;

	public var allowInspect(default, set) = false;
	public var inspectKeyCode : Int = 0;
	public var inspectDetailsKeyCode : Int = hxd.Key.CTRL;
	public var s3d : h3d.scene.Scene;
	public var cssParser : domkit.CssParser;
	public var onInspectHyperlink : (String) -> Void = null;

	public function new() {
		super();
		cssParser = new domkit.CssParser();
	}

	public function load( r : hxd.res.Resource, watchChanges = true ) {
		if( watchChanges ) r.watch(function() {
			#if (sys || nodejs)
			var fs = Std.downcast(hxd.res.Loader.currentInstance.fs, hxd.fs.LocalFileSystem);
			if( fs != null ) fs.clearCache();
			#end
			onChange();
		});
		resources.push(r);
		var variables = cssParser.variables.copy();
		add(cssParser.parseSheet(r.entry.getText(), r.name));
		cssParser.variables = variables;
		for( o in currentObjects )
			o.dom.applyStyle(this);
	}

	public function unload( r : hxd.res.Resource ) {
		r.watch(null);
		resources.remove(r);
		onChange();
	}

	override function clear() {
		super.clear();
		resources.resize(0);
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
	public function sync( ?dt : Float ) {
		if( dt == null )
			dt = hxd.Timer.elapsedTime;
		var T0 = domkit.CssStyle.TAG;
		for( o in currentObjects )
			o.dom.applyStyle(this, true);
		updateTime(dt);
		return domkit.CssStyle.TAG - T0;
	}

	override function onInvalidProperty(e:domkit.Properties<Dynamic>, s:domkit.CssStyle.RuleStyle, msg:String) {
		if( errors != null ) {
			var path = s.p.name;
			var ee = e;
			while(ee != null) {
				path = (ee.id.isDefined() ? "#" + ee.id.toString() : ee.component.name) + "." + path;
				ee = ee.parent;
			}
			if( msg == null ) msg = "Invalid property value '"+(domkit.CssParser.valueStr(s.value))+"'";
			var posStr = "";
			var f = find(sourceFiles, f -> f.name == s.pos.file);
			if (s.pos != null && f != null) {
				var pos = getPos(f, s.pos.pmin);
				posStr = pos.file+":"+pos.line+": ";
			}
			errors.push(posStr+msg+" for " + path);
		}
	}

	inline function find<T>( it : Array<T>, f : T -> Bool ) : Null<T> {
		var ret = null;
		for( v in it ) {
			if(f(v)) {
				ret = v;
				break;
			}
		}
		return ret;
	}
	inline function countLines(str: String, until = -1, code = "\n".code) {
		var ret = {
			line: 1,
			col: 0,
		}
		if (until < 0)
			until = str.length;
		var lastFound = 0;
		for( i in 0...until ) {
			if( StringTools.fastCodeAt(str, i) == code ) {
				ret.line++;
				lastFound = i;
			}
		}
		ret.col = until - lastFound;
		return ret;
	}
	inline function getPos(f: SourceFile, pmin) {
		var count = countLines(f.txt, pmin);
		var line = count.line;
		var col = count.col;
		var file = f.name;
		#if (format >= version("3.8.0"))
		if (f.sourceMap != null) {
			var pos = f.sourceMap.originalPositionFor(count.line, count.col);
			if (pos != null) {
				file = pos.source;
				line = pos.originalLine;
				if (pos.originalColumn == null)
					col = -1;
				else
					col = pos.originalColumn;
			}
		}
		#end
		return {
			line: line,
			count: count,
			file: file,
			col: col,
		};
	}

	#if (format >= version("3.8.0"))
	function getSourceMapFor(r: hxd.res.Resource) {
		var mapFile = r.entry.path + ".map";
		if( hxd.res.Loader.currentInstance.exists(mapFile) ) {
			var mapContent = hxd.res.Loader.currentInstance.load(mapFile).toText();
			try {
				return new format.map.Reader().parse(mapContent);
			} catch(e) {}
		}
		return null;
	}
	#end
	var sourceFiles: Array<SourceFile> = [];

	function onChange( ntry : Int = 0 ) {
		if( ntry >= 10 ) return;
		ntry++;
		var oldRules = data.rules;
		errors = [];
		data.rules = [];
		sourceFiles = [];
		for( r in resources ) {
			var txt = try r.entry.getText() catch( e : Dynamic ) { haxe.Timer.delay(onChange.bind(ntry),100); data.rules = oldRules; return; }
			var curFile = {
				name: r.entry.name,
				txt: txt,
				#if (format >= version("3.8.0"))
				sourceMap: getSourceMapFor(r),
				#end
			};
			sourceFiles.push(curFile);
			try {
				data.add(cssParser.parseSheet(txt, r.name));
			} catch( e : domkit.Error ) {
				cssParser.warnings.push({ msg : e.message, pmin : e.pmin, pmax : e.pmax });
			}
			for( w in cssParser.warnings ) {
				var pos = getPos(curFile, w.pmin);
				errors.push(pos.file+":"+pos.line+": " + w.msg);
		 	}
		}
		onReload();
		for( o in currentObjects )
			o.dom.applyStyle(this);
		refreshErrors();
		sourceFiles = [];
	}

	public dynamic function onReload() {
	}

	function refreshErrors( ?scene ) {
		if( errors.length == 0 ) {
			if( errorsText != null ) {
				errorsText.parent.remove();
				errorsText = null;
			}
		} else {
			if( errorsText == null ) {
				if( scene == null && currentObjects.length > 0 ) {
					scene = currentObjects[0].getScene();
					if( scene == null ) {
						for( o in currentObjects ) {
							scene = o.getScene();
							if( scene != null ) break;
						}
					}
				}
				if( scene == null ) return;
				var fl = new h2d.Flow();
				scene.add(fl,100);
				fl.backgroundTile = h2d.Tile.fromColor(0x400000,0.9);
				fl.padding = 10;
				errorsText = new h2d.Text(hxd.res.DefaultFont.get(), fl);
			}
			var fl = Std.downcast(errorsText.parent, h2d.Flow);
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
					if( o.dom != null ) {
						@:privateAccess o.dom.currentValues = null;
						@:privateAccess o.dom.currentRuleStyles = null;
					}
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

	var lastFrame = -1;
	function onWindowEvent( e : hxd.Event ) {
		switch( e.kind ) {
		case EPush if( inspectKeyCode == 0 || hxd.Key.isDown(inspectKeyCode) ):
			lastFrame = -1;
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

				if( inspectModeActive && s3d != null && @:privateAccess s3d.renderer.debugging )
					inspectModeActive = false;

				if( inspectModeActive )
					updatePreview(e);
				else {
					clearPreview();
					hxd.System.setNativeCursor(Default);
				}
			}
		case EMove:
			if( inspectModeActive && !inspectModeDetails ) {
				var anyScene = null;
				for( o in currentObjects ) {
					anyScene = o.getScene();
					if( anyScene != null ) break;
				}
				if( anyScene == null || lastFrame < anyScene.renderer.frame ) {
					if( anyScene != null )
						lastFrame = anyScene.renderer.frame;
					updatePreview(e);
				}
			}
		case EWheel if( inspectKeyCode == 0 || hxd.Key.isDown(inspectKeyCode) ):
			lastFrame = -1;
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
			if( dom.id.isDefined() )
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
		prevFlow.layout = Vertical;
		prevFlow.verticalSpacing = 16;

		var previewTitle = new h2d.HtmlText(hxd.res.DefaultFont.get(), prevFlow);

		var propsFlow = new h2d.Flow(prevFlow);
		var propsLineText = new h2d.HtmlText(hxd.res.DefaultFont.get(), propsFlow);
		var propsValueText = new h2d.HtmlText(hxd.res.DefaultFont.get(), propsFlow);

		if (onInspectHyperlink != null)
			propsLineText.onHyperlink = onInspectHyperlink;

		previewTitle.text = getDisplayInfo(obj);
		var dom = obj.dom;

		if(dom != null) {
			var posLines = [];
			var valueLines = [];
			var files: Array<SourceFile> = [];
			var lineDigits = 0;
			var resourcePath = "";
			if (onInspectHyperlink != null && resources.length > 0 && resources[0].entry is hxd.fs.LocalFileSystem.LocalEntry) {
				var entry = Std.downcast(resources[0].entry, hxd.fs.LocalFileSystem.LocalEntry);
				var idx = @:privateAccess entry.file.lastIndexOf("/");
				if (idx >= 0) resourcePath = @:privateAccess entry.file.substr(0, idx);
			}

			for( i in 0...dom.currentSet.length ) {
				if( dom.currentRuleStyles == null || dom.currentRuleStyles[i] == null )
					continue;
				var vs = dom.currentRuleStyles[i];
				if (find(files, f -> f.name == vs.pos.file) != null)
					continue;
				var r = find(resources, r -> r.name == vs.pos.file);
				if (r != null) {
					var txt = r.entry.getText();
					files.push({
						name: vs.pos.file,
						txt: txt,
						#if (format >= version("3.8.0"))
						sourceMap: getSourceMapFor(r),
						#end
					});
					lineDigits = hxd.Math.imax(lineDigits, Std.int(Math.log(countLines(txt).line) / Math.log(10)));
				}
			}

			for( s in dom.style ) {
				if( s.p.name == "text" || Std.isOfType(s.value,h2d.Tile) ) continue;
				valueLines.push(' <font color="#D0D0D0"> ${s.p.name}</font> <font color="#808080">${s.value}</font><font color="#606060"> (style)</font>');
			}
			var emptyDigits = "";
			for (i in 0...lineDigits)
				emptyDigits += " ";
			for( i in 0...dom.currentSet.length ) {
				var p = dom.currentSet[i];
				if( p.name == "text" ) continue;
				var v = dom.currentValues == null ? null : dom.currentValues[i];
				var vs = dom.currentRuleStyles == null ? null : dom.currentRuleStyles[i];
				var lStr = emptyDigits;
				if (vs != null) {
					v = vs.value;
					var f = find(files, f -> f.name == vs.pos.file);
					if (f != null) {
						var pos = getPos(f, vs.pos.pmin);
						var s = "" + pos.line;
						if (pos.file == null)
							lStr = '<font color="#707070">$s</font>';
						else {
							var posStr = '${pos.file}:$s';
							if (onInspectHyperlink != null && resourcePath != null) {
								var colStr = pos.col >= 0 ? (":" + pos.col) : "";
								posStr = '<a href="$resourcePath/$posStr$colStr">$posStr</a>';
							}
							lStr = '<font color="#707070">$posStr</font>';
						}
					}
				}
				var vstr = v == null ? "???" : StringTools.htmlEscape(domkit.CssParser.valueStr(v));
				posLines.push(lStr);
				valueLines.push('<font color="#D0D0D0"> ${p.name}</font> <font color="#808080">$vstr</font>');
			}
			var txt = Std.downcast(obj, h2d.HtmlText);
			if( txt != null ) {
				// if the text has custom nodes, display them in CSS
				var x = try @:privateAccess txt.parseText(txt.text) catch( e : Dynamic ) null;
				var nodes = new Map();
				function gatherRec(x:Xml) {
					switch( x.nodeType ) {
					case Element:
						nodes.set(x.nodeName.toLowerCase(), true);
						for( c in x )
							gatherRec(c);
					case Document:
						for( c in x )
							gatherRec(c);
					default:
					}
				}
				gatherRec(x);
				nodes.remove("font");
				nodes.remove("br");
				nodes.remove("img");
				var nodes = [for( k in nodes.keys() ) k];
				nodes.sort(Reflect.compare);
				if( nodes.length > 0 ) {
					posLines.push("");
					valueLines.push('<font color="#D0D0D0"> text-tags</font> <font color="#808080">${nodes.join(',')}</font>');
				}
			}
			propsLineText.text = posLines.join("<br/>");
			propsValueText.text = valueLines.join("<br/>");
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
