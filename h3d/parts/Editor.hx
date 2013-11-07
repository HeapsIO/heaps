package h3d.parts;
import h3d.parts.Data;

@:bitmap("h3d/parts/default.png") private class DefaultPart extends flash.display.BitmapData {
}

@:bitmap("h3d/parts/defaultAlpha.png") private class DefaultPartAlpha extends flash.display.BitmapData {
}

private typedef Curve = {
	var value : Value;
	var mode : Int;
	var min : Float;
	var max : Float;
	var pow : Float;
	var freq : Float;
	var ampl : Float;
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
	};
	var curve : Curve;
	var curveBG : h2d.Tile;
	var curveTexture : h2d.Tile;
	
	static var CURVES : Array<{ name : String, f : Curve -> Data.Value }> = [
		{ name : "Const", f : function(c) return VConst(c.min) },
		{ name : "Linear", f : function(c) return VLinear(c.min, c.max - c.min) },
		{ name : "Pow", f : function(c) return VPow(c.min, c.max - c.min, c.pow) },
		{ name : "Random", f : function(c) return VRandom(c.min, c.max - c.min) },
	];
	
	public function new(emiter, ?parent) {
		super(parent);
		this.emit = emiter;
		this.state = emit.state;
		props = {
			startTime : 0.,
		};
		curve = makeCurve(VLinear(0, 1));
		init();
		buildUI();
		setCurveMode(curve.mode);
	}

	function buildUI() {
		if( ui != null ) ui.remove();
		ui = h2d.comp.Parser.fromHtml('
			<body class="body">
				<style>
					* {
						font-size : 12px;
					}

					.body {
						layout : dock;
					}

					.main {
						padding : 15px;
						height : 150px;
						dock : bottom;
						layout : horizontal;
						horizontal-spacing : 10px;
					}

					.col {
						layout : vertical;
					}

					.line {
						layout : horizontal;
					}
					
					#curve {
						padding-top : 10px;
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
					
					.curve .val {
						display : none;
					}
					
					.m_const .v_min, .m_linear .v_min, .m_pow .v_min, .m_random .v_min {
						display : block;
					}

					.m_linear .v_max, .m_pow .v_max, .m_random .v_max {
						display : block;
					}
					
					.m_pow .v_pow {
						display : block;
					}
					
				</style>
				<div class="main panel">
					<div class="col large">
						<select onchange="api.s.blendMode = api.blendModes[api.parseInt(this.value)]">
							<option value="0" checked="${state.blendMode == Add}">Additive</option>
							<option value="1" checked="${state.blendMode == Alpha}">Alpha</option>
							<option value="2" checked="${state.blendMode == SoftAdd}">Soft Add</option>
						</select>
						<div class="line">
							<checkbox checked="${state.loop}" onchange="api.s.loop = this.checked"/> <span>Loop</span>
						</div>
						<div class="line">
							<span>Start Time</span> <input value="${props.startTime}" onchange="api.props.startTime = api.parseFloat(this.value)"/> <button value="Start" onclick="api.reset()"/>
						</div>
						<div class="line" style="layout:dock;width:200px">
							<label id="stats" style="dock:bottom"/>
						</div>
					</div>
					<div class="col curve">
						<div class="line">
							<select onchange="api.setCurveMode(api.parseInt(this.value))">
								${{
									var str = "";
									for( i in 0...CURVES.length )
										str += '<option value="$i" checked="${i == curve.mode}">${CURVES[i].name}</option>';
									str;
								}}
							</select>
							<div class="val v_min">
								<span>Min</span> <value value="${curve.min}" increment="0.01" onchange="api.curve.min = this.value; api.updateCurve()"/>
							</div>
							<div class="val v_max">
								<span>Max</span> <value value="${curve.max}" increment="0.01" onchange="api.curve.max = this.value; api.updateCurve()"/>
							</div>
							<div class="val v_pow">
								<span>Pow</span> <value value="${curve.pow}" increment="0.01" onchange="api.curve.pow = this.value; api.updateCurve()"/>
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
			reset : emit.reset,
			props : props,
			curve : curve,
			setCurveMode : setCurveMode,
			updateCurve : updateCurve,
		});
		addChild(ui);
		stats = cast ui.getElementById("stats");
		var c = ui.getElementById("curve");
		c.addChild(new h2d.Bitmap(curveBG));
		c.addChild(new h2d.Bitmap(curveTexture));
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
		inline function posY(y:Float) {
			return Std.int((1 - y) * 0.5 * height);
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
		curveTexture.getTexture().uploadBitmap(bmp);
		bmp.dispose();
	}
	
	function makeCurve( v : Value ) : Curve {
		var c : Curve = {
			value : v,
			mode : v.getIndex(),
			min : 0.,
			max : 1.,
			freq : 1.,
			ampl : 1.,
			pow : 1.,
		};
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
		case VCustom(_):
			throw "assert";
		}
		return c;
	}
	
	function setCurveMode( mode : Int ) {
		var cm = ui.getElementById("curve").getParent();
		cm.removeClass("m_" + CURVES[curve.mode].name.toLowerCase());
		curve.mode = mode;
		cm.addClass("m_" + CURVES[curve.mode].name.toLowerCase());
		updateCurve();
	}
	
	function updateCurve() {
		curve.value = CURVES[curve.mode].f(curve);
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
		var pcount = emit.count;
		if( stats != null ) stats.text = hxd.Math.fmt(emit.time) + " s\n" + pcount + " p\n" + hxd.Math.fmt(ctx.engine.fps) + " fps";
		if( getScene().getSpritesCount() > 500 ) {
			var map = new Map();
			function loop(c:h2d.Sprite) {
				var t = Type.getClassName(Type.getClass(c));
				map.set(t, map.get(t) + 1);
				for( c in c ) loop(c);
			}
			loop(getScene());
			throw map.toString();
		}
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
		super.sync(ctx);
	}
	
}