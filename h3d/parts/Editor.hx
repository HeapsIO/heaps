package h3d.parts;
import h3d.parts.Data;

@:bitmap("h3d/parts/default.png") private class DefaultPart extends flash.display.BitmapData {
}

@:bitmap("h3d/parts/defaultAlpha.png") private class DefaultPartAlpha extends flash.display.BitmapData {
}

private typedef Curve = {
	var value : Value;
	var name : String;
	var incr : Float;
	var mode : Int;
	var min : Float;
	var max : Float;
	var pow : Float;
	var freq : Float;
	var prec : Float;
	var scaleY : Float;
	var points : Array<h2d.col.Point>;
	var active : Bool;
	var pointSelected : h2d.col.Point;
}

class Editor extends h2d.Sprite {
	
	var emit : Emiter;
	var state : State;
	var curState : String;
	var width : Int;
	var height : Int;
	var ui : h2d.comp.Component;
	var stats : h2d.comp.Label;
	var cachedMode : BlendMode;
	var lastPartSeen : Null<Float>;
	var props : {
		startTime : Float,
		pause : Bool,
	};
	var curve : Curve;
	var curveBG : h2d.Tile;
	var curveTexture : h2d.Tile;
	var grad : h2d.comp.GradientEditor;
	var cedit : h2d.Interactive;
	
	static var CURVES : Array<{ name : String, f : Curve -> Data.Value }> = [
		{ name : "Const", f : function(c) return VConst(c.min) },
		{ name : "Linear", f : function(c) return VLinear(c.min, c.max - c.min) },
		{ name : "Pow", f : function(c) return VPow(c.min, c.max - c.min, c.pow) },
		{ name : "Sin", f : function(c) return VSin(c.freq * Math.PI, (c.max - c.min) * 0.5, (c.min + c.max) * 0.5) },
		{ name : "Cos", f : function(c) return VCos(c.freq * Math.PI, (c.max - c.min) * 0.5, (c.min + c.max) * 0.5) },
		{ name : "Curve", f : function(c) return solvePoly(c) },
		{ name : "Random", f : function(c) return VRandom(c.min, c.max - c.min) },
	];

	
	static function solvePoly( c : Curve ) {

		if( c.points == null )
			c.points = [new h2d.col.Point(0, c.min/c.max), new h2d.col.Point(1, 1)];
		
		var xvals = [for( p in c.points ) p.x];
		var yvals = [for( p in c.points ) p.y * c.max];
		var pts = [];
		for( i in 0...c.points.length ) {
			pts.push(xvals[i]);
			pts.push(yvals[i]);
		}
		var p = Std.int(c.prec);
		var beta = h2d.col.Polynomial.regress(xvals, yvals, p <= 0 ? 0 : (p >= c.points.length ? c.points.length-1 : p));
		while( Math.abs(beta[beta.length - 1]) < 1e-3 )
			beta.pop();
		return VPoly(beta,pts);
	}
	
	public function new(emiter, ?parent) {
		super(parent);
		this.emit = emiter;
		this.state = emit.state;
		props = {
			startTime : 0.,
			pause : false,
		};
		curve = initCurve(VLinear(0, 1));
		init();
		buildUI();
	}

	function buildUI() {
		if( ui != null ) ui.remove();
		ui = h2d.comp.Parser.fromHtml('
			<body class="body">
				<style>
					* {
						font-size : 12px;
					}
					
					h1 {
						font-size : 10px;
						color : #BBB;
					}

					.body {
						layout : dock;
					}
					
					span {
						padding-top : 2px;
					}

					.main {
						padding : 15px;
						width : 202px;
						dock : right;
						layout : vertical;
						vertical-spacing : 10px;
					}

					.col {
						layout : vertical;
						margin-bottom : 10px;
					}
					
					.sep {
						margin-top : -10px;
						margin-bottom : -2px;
						height : 1px;
						width : 200px;
						background-color : #555;
					}
					
					.buttons {
						layout : inline;
					}

					.line {
						layout : horizontal;
					}
					
					.ic, .icol {
						icon : url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAIAAACQkWg2AAAAB3RJTUUH3QsHEDot9CONhQAAABd0RVh0U29mdHdhcmUAR0xEUE5HIHZlciAzLjRxhaThAAAACHRwTkdHTEQzAAAAAEqAKR8AAAAEZ0FNQQAAsY8L/GEFAAAABmJLR0QA/wD/AP+gvaeTAAAARklEQVR4nGP4z/CfJMRAmQYIIFbDfwwGJvpPHQ249PxHdtJ/LHKkaMBtBAN+80jRgCMY8GrAFjMMBGMKI+Jor4EU1eRoAADB1BsCKErgdwAAAABJRU5ErkJggg=");
						icon-top : 1px;
						icon-left : 2px;
						icon-color : #888;
						padding-left : 20px;
					}
					
					.ic:hover, .icol:hover {
						icon-top : 0px;
					}
					
					.icol {
						icon-color : #AAA;
						icon : url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAIAAACQkWg2AAAAB3RJTUUH3QsICwAiCSUSqgAAABd0RVh0U29mdHdhcmUAR0xEUE5HIHZlciAzLjRxhaThAAAACHRwTkdHTEQzAAAAAEqAKR8AAAAEZ0FNQQAAsY8L/GEFAAAABmJLR0QA/wD/AP+gvaeTAAAAMklEQVR4nGMwIBEwAPFJWQVMlLHvLSYayRqcdmNBD8tFMNFI1kBa4vMnETD8Z/hPEgIAvqs9dJhBcSIAAAAASUVORK5CYII==");
					}
					
					select, button, input {
						icon-top : 2px;
						width : 70px;
						height : 11px;
						padding-top : 2px;
					}
					
					input {
						height : 13px;
						padding-top : 2px;
					}

					.curve_cont {
						dock : right;
						width : 310px;
						layout : dock;
					}
					
					.curve {
						dock : bottom;
						layout : vertical;
						padding : 5px;
						height : 165px;
					}
					
					.curve .title {
						width : 180px;
						text-align : right;
						padding: 2px 10px;
						background-color : #202020;
					}
					
					#curve {
						width : 300px;
						height : 110px;
						border : 1px solid #333;
					}
					
					.curve .val {
						display : none;
					}
					
					.m_const .v_min, .m_linear .v_min, .m_pow .v_min, .m_random .v_min, .m_cos .v_min, .m_sin .v_min {
						display : block;
					}

					.m_linear .v_max, .m_pow .v_max, .m_random .v_max, .m_cos .v_max, .m_sin .v_max, .m_curve .v_max {
						display : block;
					}
					
					.m_pow .v_pow {
						display : block;
					}
					
					.m_cos .v_freq, .m_sin .v_freq {
						display : block;
					}
					
					.m_curve .v_prec, .m_curve .v_clear {
						display : block;
					}
					
				</style>
				<div class="main panel">
				
					<h1>Global</h1>
					<div class="sep"></div>
					<div class="col">
						<div class="line">
							<span>Life</span> <value value="${state.globalLife}" onchange="api.s.globalLife = this.value"/>
							<checkbox checked="${state.loop}" onchange="api.s.loop = this.checked"/> <span>Loop</span>
						</div>
						<div class="line">
							<select onchange="api.s.blendMode = api.blendModes[api.parseInt(this.value)]">
								<option value="0" checked="${state.blendMode == Add}">Additive</option>
								<option value="1" checked="${state.blendMode == Alpha}">Alpha</option>
								<option value="2" checked="${state.blendMode == SoftAdd}">Soft Add</option>
							</select>
							<select onchange="api.s.sortMode = api.sortModes[api.parseInt(this.value)]">
								<option value="0" checked="${state.sortMode == Front}">Front</option>
								<option value="1" checked="${state.sortMode == Back}">Back</option>
								<option value="2" checked="${state.sortMode == Sort}">Sort</option>
								<option value="2" checked="${state.sortMode == InvSort}">InvSort</option>
							</select>
						</div>
						<div class="line">
							<button class="ic" value="Speed" onclick="api.editCurve(\'globalSpeed\')"/>
							<button class="ic" value="Size" onclick="api.editCurve(\'globalSize\')"/>
						</div>
					</div>
					
					<h1>Emit</h1>
					<div class="sep"></div>
					<div class="col">
						<div class="line">
							<button class="ic" value="Emit Rate" onclick="api.editCurve(\'emitRate\')"/>
							<span>Max</span> <value value="${state.maxParts}" increment="1" onchange="api.s.maxParts = this.value"/>
						</div>
						<div class="line">
							<span>Emiter Type</span> <select onchange="api.setCurShape(api.parseInt(this.value))">
								<option value="0" checked="${state.shape.match(SDir(_))}">Direction</option>
								<option value="1" checked="${state.shape.match(SSphere(_))}">Sphere</option>
								<option value="2" checked="${state.shape.match(SSector(_))}">Sector</option>
							</select>
						</div>
						<div id="shape">
							<div class="val">
								<span>Size</span> <value value="${
									switch( state.shape ) {
									case SSphere(r), SSector(r,_): r;
									case SDir(x, y, z): Math.sqrt(x * x + y * y + z * z);
									case SCustom(_): 0.;
									}} " onchange="api.setShapeProp(\'size\', this.value)"/>
							</div>
							<div class="val">
								<span>Angle</span> <value value="${
									(switch( state.shape ) {
									case SSector(_,a): a;
									default: 0.;
								}) * 180 / Math.PI} " onchange="api.setShapeProp(\'angle\', this.value)"/>
							</div>
						</div>
						<div class="line">
							<checkbox checked="${state.emitFromShell}" onchange="api.s.emitFromShell = this.checked"/> <span>Emit from Shell</span>
						</div>
						<div class="line">
							<checkbox checked="${state.randomDir}" onchange="api.s.randomDir = this.checked"/> <span>Random Dir</span>
						</div>
						<!-- TODO : Bursts edition -->
					</div>
					
					<h1>Particle</h1>
					<div class="sep"></div>
					<div class="col">
						<div class="buttons">
							<button class="ic" value="Life" onclick="api.editCurve(\'life\')"/>
							<button class="ic" value="Size" onclick="api.editCurve(\'size\')"/>
							<button class="ic" value="Rotation" onclick="api.editCurve(\'rotation\')"/>
							<button class="ic" value="Speed" onclick="api.editCurve(\'speed\')"/>
							<button class="ic" value="Gravity" onclick="api.editCurve(\'gravity\')"/>
							<button class="icol" value="Color" onclick="api.editColors()"/>
							<button class="ic" value="Alpha" onclick="api.editCurve(\'alpha\')"/>
							<button class="ic" value="Light" onclick="api.editCurve(\'light\')"/>
						</div>
					</div>
					
					<h1>Collide</h1>
					<div class="sep"></div>
					<div class="col">
						<div class="line">
							<checkbox checked="${state.collide}" onchange="api.s.collide = this.checked"/> <span>Collide</span>
							<value value="${state.bounce}" onchange="api.s.bounce = this.value"/> <span>Bounce</span>
						</div>
						<div class="line">
							<checkbox checked="${state.collideKill}" onchange="api.s.collideKill = this.checked"/> <span>Kill</span>
						</div>
					</div>
					
					<h1>Play</h1>
					<div class="sep"></div>
					<div style="layout:dock;width:200px">
						<div class="col" style="dock:bottom">
							<div class="line">
								<span>Loop Time</span> <value value="${props.startTime}" onchange="api.props.startTime = this.value"/>
							</div>
							<div class="line">
								<checkbox checked="${props.pause}" onchange="api.props.pause = this.checked"/> <span>Pause</span>
							</div>
							<div class="line">
								<button value="Restart" onclick="api.reset()"/>
							</div>
							<label id="stats"/>
						</div>
					</div>
				</div>
				<div class="curve_cont" style="display:${if( curve.name == null ) "none" else "block" }" id="curvePanel">
				<div class="curve panel">
					<div class="line">
						<select onchange="api.setCurveMode(api.parseInt(this.value))">
							${{
								var str = "";
								for( i in 0...CURVES.length )
									str += '<option value="$i" checked="${i == curve.mode}">${CURVES[i].name}</option>';
								str;
							}}
						</select>
						<span class="title">${curve.name == null ? "" : curve.name.charAt(0).toUpperCase() + curve.name.substr(1)}</span>
					</div>
					<div class="line">
						<div class="val v_min">
							<span>Min</span> <value value="${curve.min}" increment="${curve.incr}" onchange="api.curve.min = this.value; api.updateCurve()"/>
						</div>
						<div class="val v_max">
							<span>Max</span> <value value="${curve.max}" increment="${curve.incr}" onchange="api.curve.max = this.value; api.updateCurve()"/>
						</div>
						<div class="val v_pow">
							<span>Pow</span> <value value="${curve.pow}" increment="0.01" onchange="api.curve.pow = this.value; api.updateCurve()"/>
						</div>
						<div class="val v_freq">
							<span>Freq</span> <value value="${curve.freq}" increment="0.01" onchange="api.curve.freq = this.value; api.updateCurve()"/>
						</div>
						<div class="val v_prec">
							<span>Prec</span> <value value="${curve.prec}" increment="0.1" onchange="api.curve.prec = this.value; api.updateCurve()"/>
						</div>
						<div class="val v_clear">
							<button value="Clear" onclick="api.clearCurve()"/>
						</div>
					</div>
					<div id="curve">
					</div>
				</div>
				</div>
			</body>
		',{
			s : state,
			parseInt : Std.parseInt,
			parseFloat : Std.parseFloat,
			blendModes : Type.allEnums(BlendMode),
			sortModes : Type.allEnums(SortMode),
			reset : emit.reset,
			props : props,
			curve : curve,
			setCurveMode : setCurveMode,
			updateCurve : updateCurve,
			editCurve : editCurve,
			setCurShape : setCurShape,
			setShapeProp : setShapeProp,
			editColors : editColors,
			clearCurve : clearCurve,
		});
		addChildAt(ui,0);
		stats = cast ui.getElementById("stats");
		var c = ui.getElementById("curve");
		c.addChild(new h2d.Bitmap(curveBG));
		c.addChild(new h2d.Bitmap(curveTexture));
		cedit = new h2d.Interactive(curveBG.width, curveBG.height, c);
		cedit.onPush = onCurveEvent;
		cedit.onMove = onCurveEvent;
		cedit.onRelease = onCurveEvent;
		cedit.onOut = onCurveEvent;
		cedit.onKeyDown = onCurveEvent;
		setCurveMode(curve.mode);
	}
	
	function clearCurve() {
		curve.points = [new h2d.col.Point(0, curve.min/curve.max), new h2d.col.Point(1, 1)];
		curve.freq = 2;
		buildUI();
	}
	
	function onCurveEvent( e : hxd.Event ) {
		if( !curve.value.match(VPoly(_)) )
			return;
		var px = e.relX / curveBG.width;
		var py = ((1 - (e.relY / (0.5 * curveBG.height))) / curve.scaleY) / curve.max;
		switch( e.kind ) {
		case ERelease:
			if( curve.active && curve.pointSelected == null ) {
				curve.points.push(new h2d.col.Point(px,py));
				updateCurve();
			}
			curve.active = false;
		case EPush:
			curve.active = true;
			var dMax = 0.002;
			var old = curve.pointSelected;
			curve.pointSelected = null;
			for( p in curve.points ) {
				var d = hxd.Math.distanceSq(p.x - px, (p.y - py) * curve.max * curve.scaleY * curveBG.height / curveBG.width);
				if( d < dMax ) {
					dMax = d;
					curve.pointSelected = p;
				}
			}
			if( old != curve.pointSelected ) {
				rebuildCurve();
				if( curve.pointSelected != null ) cedit.focus();
			}
		case EMove:
			if( curve.active && curve.pointSelected != null ) {
				curve.pointSelected.x = px;
				curve.pointSelected.y = py;
				updateCurve();
			}
		case EOut:
			if( curve.pointSelected == null ) curve.active = false;
		case EKeyDown:
			if( curve.pointSelected != null )
				switch( e.keyCode ) {
				case hxd.Key.DELETE:
					curve.points.remove(curve.pointSelected);
					curve.pointSelected = null;
					updateCurve();
				default:
				}
		default:
		}
	}
	
	function editColors() {
		if( grad != null ) {
			grad.remove();
			grad = null;
			return;
		}
		ui.getElementById("curvePanel").addStyleString("display:none");
		curve.name = null;
		grad = new h2d.comp.GradientEditor(false, this);
		grad.setKeys(state.colors == null ? [ { x : 0., value : 0xFFFFFF }, { x : 1., value : 0xFFFFFF } ] : [for( c in state.colors ) { x : c.time, value : c.color } ]);
		grad.onChange = function(keys) {
			state.colors = [for( k in keys ) { time : k.x, color : k.value & 0xFFFFFF } ];
			var found = false;
			for( s in state.colors )
				if( s.color != 0xFFFFFF ) {
					found = true;
					break;
				}
			if( !found ) state.colors = null;
		};
	}
	
	function editCurve( name : String ) {
		if( curve.name == name ) {
			curve.name = null;
			ui.getElementById("curvePanel").addStyleString("display:none");
			return;
		}
		if( grad != null ) {
			grad.remove();
			grad = null;
		}
		var old : Value = Reflect.field(state, name);
		var v = old;
		if( v == null )
			switch( name ) {
			default:
				v = VLinear(0,1);
			}
		curve = initCurve(v);
		curve.name = name;
		switch( name ) {
		case "emitRate":
			curve.incr = 1;
		default:
			curve.incr = 0.01;
		}
		rebuildCurve();
		buildUI();
	}
	
	function init() {
		var bg = new hxd.BitmapData(300, 110);
		bg.clear(0xFF202020);
		for( h in [0, bg.height >> 1, bg.height - 1] )
			bg.line(0, h, bg.width - 1, h, 0xFF101010);
		for( h in [bg.height * 0.25, bg.height * 0.75] ) {
			var h = Math.round(h);
			bg.line(0, h, bg.width - 1, h, 0xFF191919);
		}
		curveBG = h2d.Tile.fromBitmap(bg);
		bg.dispose();
		curveTexture = 	h2d.Tile.fromTexture(h3d.Engine.getCurrent().mem.allocTexture(512, 512)).sub(0, 0, curveBG.width, curveBG.height);
	}
	
	function rebuildCurve() {
		var bmp = new hxd.BitmapData(512, 512);
		var width = curveTexture.width, height = curveTexture.height;
		var yMax;
		
		switch( curve.value ) {
		case VConst(v): yMax = Math.abs(v);
		case VRandom(min, len), VLinear(min, len), VPow(min,len,_): yMax = Math.max(Math.abs(min), Math.abs(min + len));
		case VPoly(_):
			yMax = 0;
			for( p in curve.points ) {
				var py = Math.abs(p.y * curve.max);
				if( py > yMax )
					yMax = py;
			}
		case VSin(_, a, o), VCos(_, a, o):
			yMax = Math.max(Math.abs(a - o), Math.abs(a + o));
		case VCustom(_):
			throw "assert";
		}
		
		
		var sy = 1.;
		var k = 0;
		while( yMax > 100 * curve.incr ) {
			var f = (k&1 == 0 ? 0.2 : 0.5); // x5 and x2 scale
			sy *= f;
			yMax *= f;
			k++;
		}
		sy /= (100 * curve.incr);
		curve.scaleY = sy;
		
		inline function posX(x:Float) {
			return Std.int(x * (width - 1));
		}
		inline function posY(y:Float) {
			return Std.int((1 - y * curve.scaleY) * 0.5 * height);
		}
		switch( curve.value ) {
		case VRandom(start, len):
			var y0 = posY(start), y1 = posY(start + len);
			bmp.fill(h2d.col.Bounds.fromValues(0, Math.min(y0,y1), width, Math.abs(y1 - y0)),0x40FF0000);
			bmp.line(0, y0, width - 1, y0, 0xFFFF0000);
			bmp.line(0, y1, width - 1, y1, 0xFFFF0000);
		default:
			for( x in 0...width ) {
				var px = x / (width - 1);
				var py = state.eval(curve.value, px, Math.random());
				bmp.setPixel(x, posY(py), 0xFFFF0000);
			}
		}
		
		switch( curve.value ) {
		case VPoly(_):
			for( p in curve.points ) {
				var px = posX(p.x), py = posY(p.y * curve.max);
				var color = p == curve.pointSelected ? 0xFFFFFFFF : 0xFF808080;
				bmp.line(px - 1, py - 1, px + 1, py - 1, color);
				bmp.line(px - 1, py, px - 1, py + 1, color);
				bmp.line(px + 1, py, px + 1, py + 1, color);
				bmp.line(px, py + 1, px, py + 1, color);
			}
		default:
		}
		
		curveTexture.getTexture().uploadBitmap(bmp);
		bmp.dispose();
	}
	
	function initCurve( v : Value ) {
		var c : Curve = {
			value : null,
			name : null,
			mode : -1,
			incr : 0.01,
			min : 0.,
			max : 1.,
			freq : 1.,
			pow : 1.,
			prec : 3,
			scaleY : 1.,
			points : null,
			active : false,
			pointSelected : null,
		};
		c.value = v;
		c.mode = v.getIndex();
		switch( v ) {
		case VConst(v):
			c.min = c.max = v;
		case VLinear(min, len):
			c.min = min;
			c.max = min + len;
		case VPow(min, len, pow):
			c.min = min;
			c.max = min + len;
			c.pow = pow;
		case VRandom(a, b):
			c.min = a;
			c.max = b;
		case VSin(f, a, off), VCos(f, a, off):
			c.min = off - a;
			c.max = off + a;
			c.freq = f / Math.PI;
		case VPoly(values,pts):
			c.points = [];
			for( i in 0...pts.length >> 1 )
				c.points.push(new h2d.col.Point(pts[i << 1], pts[(i << 1) + 1]));
			c.max = 1;
			c.prec = values.length - 1;
			c.active = false;
			c.pointSelected = null;
		case VCustom(_):
			throw "assert";
		}
		return c;
	}
	
	function setCurShape( mode : Int ) {
		state.shape = switch( mode ) {
		case 0: SDir(0, 0, 1);
		case 1: SSphere(1);
		case 2: SSector(1,Math.PI/4);
		default: throw "Unknown shape #" + mode;
		}
		buildUI();
	}
	
	function setShapeProp( prop : String, v : Float ) {
		if( prop == "angle" )
			v = v * Math.PI / 180;
		switch( [state.shape, prop] ) {
		case [SSphere(_), "size"]:
			state.shape = SSphere(v);
		case [SSector(_,a), "size"]:
			state.shape = SSector(v,a);
		case [SSector(s,_), "angle"]:
			state.shape = SSector(s,v);
		case [SDir(_, _, _), "size"]:
			state.shape = SDir(0,0,v);
		default:
		}
	}
	
	function setCurveMode( mode : Int ) {
		var cm = ui.getElementById("curve").getParent();
		cm.removeClass("m_" + CURVES[curve.mode].name.toLowerCase());
		curve.mode = mode;
		var cn = CURVES[curve.mode].name.toLowerCase();
		cm.addClass("m_" + cn);
		updateCurve();
	}
	
	function updateCurve() {
		curve.value = CURVES[curve.mode].f(curve);
		if( curve.name != null ) Reflect.setField(state, curve.name, curve.value);
		rebuildCurve();
	}

	function setTexture( t : hxd.BitmapData ) {
		if( state.texture != null )
			state.texture.dispose();
		state.texture = h3d.mat.Texture.fromBitmap(t);
	}
	
	override function sync( ctx : h3d.scene.RenderContext ) {
		// if resized, let's reflow our ui
		if( ctx.engine.width != width || ctx.engine.height != height ) {
			ui.refresh();
			width = ctx.engine.width;
			height = ctx.engine.height;
		}
		if( cachedMode != state.blendMode && state.textureName == null ) {
			cachedMode = state.blendMode;
			var t = switch( state.blendMode ) {
			case Add, SoftAdd: new DefaultPart(0, 0);
			case Alpha: new DefaultPartAlpha(0, 0);
			};
			setTexture(hxd.BitmapData.fromNative(t));
			t.dispose();
		}
		var old = state.texture;
		state.texture = null;
		var s = haxe.Serializer.run(state);
		state.texture = old;
		if( s != curState ) {
			curState = s;
			emit.setState(state);
		}
		emit.pause = props.pause;
		var pcount = emit.count;
		if( stats != null ) stats.text = hxd.Math.fmt(emit.time) + " s\n" + pcount + " p\n" + hxd.Math.fmt(ctx.engine.fps) + " fps" + ("\n"+getScene().getSpritesCount());
		if( !state.loop && pcount == 0 && emit.time > 1 ) {
			if( lastPartSeen == null )
				lastPartSeen = emit.time;
			else if( emit.time - lastPartSeen > 0.5 ) {
				emit.reset();
				if( Math.isNaN(props.startTime) ) props.startTime = 0;
				var dt = 1 / 60;
				var t = props.startTime;
				while( t > dt ) {
					emit.update(dt);
					t -= dt;
				}
				if( t > 0 )
					emit.update(t);
			}
		} else
			lastPartSeen = null;
			
		if( grad != null ) {
			grad.x = width - 680;
			grad.y = height - 190;
			grad.colorPicker.x = grad.boxWidth - 180;
			grad.colorPicker.y = -321;
		}
			
		super.sync(ctx);
	}
	
}