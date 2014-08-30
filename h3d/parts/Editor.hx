package h3d.parts;
import h3d.parts.Data;

private typedef History = {
	var state : String;
	var frames : Array<h2d.Tile>;
}

private typedef Curve = {
	var value : Value;
	var shape : Bool;
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
	var converge : Converge;
	var pointSelected : h2d.col.Point;
}

class Editor extends h2d.Sprite implements Randomized {

	var emit : Emitter;
	var state : State;
	var curState : String;
	var stateChanged : Null<Float>;
	var curTile : h2d.Tile;
	var width : Int;
	var height : Int;
	var ui : h2d.comp.Component;
	var stats : h2d.comp.Label;
	var cachedMode : BlendMode;
	var lastPartSeen : Null<Float>;
	var props : {
		startTime : Float,
		pause : Bool,
		slow : Bool,
	};
	var curve : Curve;
	var curveBG : h2d.Tile;
	var curveTexture : h2d.Tile;
	var grad : h2d.comp.GradientEditor;
	var cedit : h2d.Interactive;
	var undo : Array<History>;
	var redo : Array<History>;
	var randomValue : Float;
	public var currentFilePath : String;
	public var autoLoop : Bool = true;
	public var moveEmitter(default,set) : Bool = false;

	static var CURVES : Array<{ name : String, f : Curve -> Data.Value }> = [
		{ name : "Const", f : function(c) return VConst(c.min) },
		{ name : "Linear", f : function(c) return VLinear(c.min, c.max - c.min) },
		{ name : "Pow", f : function(c) return VPow(c.min, c.max - c.min, c.pow) },
		{ name : "Sin", f : function(c) return VSin(c.freq * Math.PI, (c.max - c.min) * 0.5, (c.min + c.max) * 0.5) },
		{ name : "Cos", f : function(c) return VCos(c.freq * Math.PI, (c.max - c.min) * 0.5, (c.min + c.max) * 0.5) },
		{ name : "Curve", f : function(c) return solvePoly(c) },
		{ name : "Random", f : function(c) return VRandom(c.min, c.max - c.min, c.converge) },
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
		init();
		setState(emit.state);
	}

	public dynamic function onTextureSelect() {
		hxd.File.browse(function(sel) {
			sel.load(function(bytes) {
				changeTexture(sel.fileName, hxd.res.Any.fromBytes(sel.fileName, bytes).toTile());
			});
		},{
			defaultPath : currentFilePath,
			title : "Please select the texture",
			fileTypes : [{ name : "Images", extensions : ["png","jpg","jpeg","gif"] }],
		});
	}

	public function changeTexture( name : String, t : h2d.Tile ) {
		state.textureName = name;
		curState = null; // force reload (if texture was changed)
		setTexture(t);
		buildUI();
	}

	function set_moveEmitter(v) {
		this.moveEmitter = v;
		buildUI();
		return v;
	}

	public dynamic function loadTexture( textureName : String ) : h2d.Tile {
		var bytes = null;
		try {
			var path = currentFilePath.split("\\").join("/").split("/");
			path.pop();
			bytes = hxd.File.getBytes(path.join("/") + "/" + textureName);
		} catch( e : Dynamic ) try {
			bytes = hxd.File.getBytes(textureName);
		} catch( e : Dynamic ) {
		}
		return bytes == null ? null : hxd.res.Any.fromBytes(textureName,bytes).toTile();
	}

	public dynamic function onLoad() {
		hxd.File.browse(function(sel) {
			currentFilePath = sel.fileName;
			sel.load(function(data) {
				var s = State.load(data, function(name) {
					var t = loadTexture(name);
					if( t == null ) {
						t = h2d.Tile.fromColor(0x800000);
						// try dynamic loading. Will most likely fail since the path is relative
						hxd.File.load(name, function(bytes) {
							setTexture(hxd.res.Any.fromBytes(name, bytes).toTile());
						});
					}
					return t;
				});
				setState(s);
			});
		},{
			defaultPath : currentFilePath,
			fileTypes : [{ name : "Particle Effect", extensions : ["p"] }],
		});
	}

	public dynamic function onSave( saveData ) {
		if( currentFilePath != null )
			try {
				hxd.File.saveBytes(currentFilePath, saveData);
				return;
			} catch( e : Dynamic ) {
			}
		if( currentFilePath == null ) currentFilePath = "default.p";
		hxd.File.saveAs(saveData, {
			defaultPath : currentFilePath,
			fileTypes : [{ name : "Particle Effect", extensions : ["p"] }],
			saveFileName : function(path) currentFilePath = path,
		});
	}

	public function setState(s) {
		undo = [];
		redo = [];
		state = s;
		curState = null;
		cachedMode = null;
		lastPartSeen = null;
		stateChanged = null;
		curve = initCurve(VLinear(0, 1));
		props = {
			startTime : 0.,
			pause : false,
			slow : false,
		};
		buildUI();
		emit.reset();
	}

	override function onAlloc() {
		super.onAlloc();
		getScene().addEventListener(onEvent);
	}

	override function onDelete() {
		super.onDelete();
		getScene().addEventListener(onEvent);
	}

	var time : Float = 0.;
	public dynamic function onMoveEmitter(dt:Float) {
		time += dt * 0.03 * 60;
		var r = 1;
		emit.x = Math.cos(time) * r;
		emit.y = Math.sin(time * 0.5) * r;
		emit.z = (Math.cos(time * 1.3) * Math.sin(time * 1.5) + 1) * r;
	}

	function onEvent( e : hxd.Event ) {
		function loadHistory( h : History ) {
			curState = h.state;
			stateChanged = null;
			state = haxe.Unserializer.run(curState);
			state.frames = h.frames;
			undo.push(h);
			var n = curve.name;
			if( n != null ) {
				curve.name = null;
				editCurve(n);
			} else
				buildUI();
		}
		switch( e.kind ) {
		case EKeyDown:
			switch( e.keyCode ) {
			case "Z".code if( hxd.Key.isDown(hxd.Key.CTRL) && undo.length > (stateChanged != null?0:1) ):
				if( stateChanged != null ) {
					stateChanged = null;
					undo.push({ state : curState, frames : state.frames });
					redo = [];
				}
				redo.push(undo.pop());
				loadHistory(undo.pop());
			case "Y".code if( hxd.Key.isDown(hxd.Key.CTRL) && redo.length > 0 ):
				loadHistory(redo.pop());
			case "S".code if( hxd.Key.isDown(hxd.Key.CTRL) ):
				onSave(haxe.io.Bytes.ofString(curState));
			default:
			}
		default:
		}
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

					span.label {
						width : 97px;
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

					.box {
						width : 95px;
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

					.tname {
						width : 102px;
					}

					#curve {
						width : 300px;
						height : 110px;
						border : 1px solid #333;
					}

					button.file {
						width : 15px;
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

					.m_random .v_rnd {
						display : block;
					}

					.v_rnd button {
						width : auto;
					}

					.v_rnd select {
						width : 40px;
					}

				</style>
				<div class="main panel">

					<h1>Global</h1>
					<div class="sep"></div>
					<div class="col">
						<div class="line">
							<span class="label">Life</span> <value value="${state.globalLife}" onchange="api.s.globalLife = this.value"/>
							<checkbox checked="${state.loop}" onchange="api.s.loop = this.checked"/> <span>Loop</span>
						</div>
						<div class="line">
							<span class="label">Start Delay</span> <value value="${state.delay}" onchange="api.s.delay = this.value"/>
							<checkbox checked="${state.is3D}" onchange="api.s.is3D = this.checked"/> <span>3D</span>
						</div>
						<div class="line">
							<select onchange="api.s.blendMode = api.blendModes[api.parseInt(this.value)]; $(\'.ic.alpha\').toggleClass(\':disabled\', api.s.blendMode.index == 2)">
								<option value="0" selected="${state.blendMode == Add}">Additive</option>
								<option value="1" selected="${state.blendMode == Alpha}">Alpha</option>
								<option value="2" selected="${state.blendMode == SoftAdd}">Soft Add</option>
							</select>
							<select onchange="api.s.sortMode = api.sortModes[api.parseInt(this.value)]">
								<option value="0" selected="${state.sortMode == Front}">Front</option>
								<option value="1" selected="${state.sortMode == Back}">Back</option>
								<option value="2" selected="${state.sortMode == Sort}">Sort</option>
								<option value="2" selected="${state.sortMode == InvSort}">InvSort</option>
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
							<span class="label">Emitter Type</span> <select onchange="api.setCurShape(api.parseInt(this.value))">
								<option value="0" selected="${state.shape.match(SLine(_))}">Line</option>
								<option value="1" selected="${state.shape.match(SSphere(_))}">Sphere</option>
								<option value="2" selected="${state.shape.match(SCone(_))}">Cone</option>
								<option value="3" selected="${state.shape.match(SDisc(_))}">Disc</option>
							</select>
						</div>
						<div id="shape">
							<div class="val">
								<button class="ic" value="Size" onclick="api.editCurve(\'size\',true)"/>
							</div>
							<div class="val">
								<button class="ic" value="Angle" onclick="api.editCurve(\'angle\',true)"/>
							</div>
						</div>
						<div class="line">
							<div class="box">
								<checkbox checked="${state.emitTrail}" onchange="api.s.emitTrail = this.checked"/> <span>Trail</span>
							</div>
							<div class="box">
								<checkbox checked="${state.randomDir}" onchange="api.s.randomDir = this.checked"/> <span>Rand. Dir</span>
							</div>
						</div>
						<div class="line">
							<div class="box">
								<checkbox checked="${state.emitLocal}" onchange="api.s.emitLocal = this.checked"/> <span>Local</span>
							</div>
							<div class="box">
								<checkbox checked="${state.emitFromShell}" onchange="api.s.emitFromShell = this.checked"/> <span>From Shell</span>
							</div>
						</div>
						<div class="line">
							<checkbox checked="${this.moveEmitter}" onchange="api.setMove(this.checked)"/> <span>Move Emitter</span>
						</div>
					</div>

					<h1>Particle</h1>
					<div class="sep"></div>
					<div class="col">
						<div class="buttons">
							<button class="ic" value="Life" onclick="api.editCurve(\'life\')"/>
							<span></span>
							<button class="ic" value="Speed" onclick="api.editCurve(\'speed\')"/>
							<button class="ic" value="Gravity" onclick="api.editCurve(\'gravity\')"/>
							<button class="ic" value="Size" onclick="api.editCurve(\'size\')"/>
							<button class="ic" value="Ratio" onclick="api.editCurve(\'ratio\')"/>
							<button class="ic" value="Rotation" onclick="api.editCurve(\'rotation\')"/>
							<button class="icol" value="Color" onclick="api.editColors()"/>
							<button class="ic alpha" value="Alpha" disabled="${state.blendMode == SoftAdd}" onclick="api.editCurve(\'alpha\')"/>
							<button class="ic" value="Light" onclick="api.editCurve(\'light\')"/>
						</div>
					</div>

					<h1>Animation</h1>
					<div class="sep"></div>
					<div class="col">
						<div class="line">
							<span>Texture</span> <input disabled="1" class="tname" value="${state.textureName == null ? 'default' : state.textureName}"/> <button class="file" value="..." onclick="api.selectTexture()"/>
						</div>
						<div class="line">
							<div class="box"><checkbox checked="${state.frames != null && state.frames.length > 1}" onchange="api.toggleSplit()"/> <span>Animate</span></div>
							<button disabled="${state.frames == null || state.frames.length <= 1}" class="ic" value="Frame" onclick="api.editCurve(\'frame\')"/>
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
								<checkbox checked="${props.slow}" onchange="api.props.slow = this.checked"/> <span>Slow</span>
							</div>
							<div class="line">
								<button value="Restart" onclick="api.reset()"/>
							</div>
							<div class="line">
								<button value="Load" onclick="api.load()"/> <button value="Save" onclick="api.save()"/>
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
									str += '<option value="$i" selected="${i == curve.mode}">${CURVES[i].name}</option>';
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
						<div class="val v_rnd">
							<button value="S" onclick="var tmp = api.curve.max; api.curve.max = api.curve.min; api.curve.min = tmp; api.buildUI()"/>
							<select onchange="api.curve.converge = api.converge[api.parseInt(this.value)]; api.updateCurve()">
								<option value="0" selected="${curve.converge == No}">No</option>
								<option value="1" selected="${curve.converge == Start}">Start</option>
								<option value="2" selected="${curve.converge == End}">End</option>
							</select>
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
			converge : Type.allEnums(Converge),
			reset : emit.reset,
			props : props,
			curve : curve,
			setCurveMode : setCurveMode,
			updateCurve : updateCurve,
			editCurve : editCurve,
			setCurShape : setCurShape,
			editColors : editColors,
			clearCurve : clearCurve,
			toggleSplit : toggleSplit,
			buildUI : buildUI,
			selectTexture : function() onTextureSelect(),
			load : function() onLoad(),
			save : function() onSave(haxe.io.Bytes.ofString(curState)),
			setMove : function(b) moveEmitter = b,
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

	function toggleSplit() {
		if( state.frames.length == 1 ) {
			state.frame = VLinear(0,1);
			state.initFrames();
			if( state.frames.length == 1 )
				state.frame = null;
		} else {
			state.frames = [curTile];
			state.frame = null;
		}
		buildUI();
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

	function editCurve( name : String, isShape : Bool = false ) {
		if( curve.name == name && curve.shape == isShape ) {
			curve.name = null;
			ui.getElementById("curvePanel").addStyleString("display:none");
			return;
		}
		if( grad != null ) {
			grad.remove();
			grad = null;
		}
		var v : Value = isShape ? getShapeValue(name) : Reflect.field(state, name);
		if( v == null ) v = VLinear(0,1);
		curve = initCurve(v);
		curve.name = name;
		curve.shape = isShape;
		switch( name ) {
		case "emitRate":
			curve.incr = 1;
		default:
			curve.incr = 0.01;
		}
		rebuildCurve();
		buildUI();
	}

	public function rand() {
		return randomValue;
	}

	function init() {
		var bg = new hxd.BitmapData(300, 110);
		bg.clear(0x202020);
		for( h in [0, bg.height >> 1, bg.height - 1] )
			bg.line(0, h, bg.width - 1, h, 0xFF101010);
		for( h in [bg.height * 0.25, bg.height * 0.75] ) {
			var h = Math.round(h);
			bg.line(0, h, bg.width - 1, h, 0xFF191919);
		}
		curveBG = h2d.Tile.fromBitmap(bg);
		bg.dispose();
		curveTexture = h2d.Tile.fromTexture(new h3d.mat.Texture(512, 512)).sub(0, 0, curveBG.width, curveBG.height);
	}

	function rebuildCurve() {
		var bmp = new hxd.BitmapData(512, 512);
		var width = curveTexture.width, height = curveTexture.height;
		var yMax;

		switch( curve.value ) {
		case VConst(v): yMax = Math.abs(v);
		case VRandom(min, len,_), VLinear(min, len), VPow(min,len,_): yMax = Math.max(Math.abs(min), Math.abs(min + len));
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
		for( x in 0...width ) {
			var px = x / (width - 1);
			randomValue = 0;
			var py0 = State.eval(curve.value, px, this, null);
			randomValue = 1;
			var py1 = State.eval(curve.value, px, this, null);
			var iy0 = posY(py0);
			if( py0 != py1 ) {
				var iy1 = posY(py1);
				if( iy1 != iy0 ) {
					bmp.line(x, iy0, x, iy1, 0x40FF0000);
					bmp.setPixel(x, iy1, 0xFFFF0000);
				}
			}
			bmp.setPixel(x, iy0, 0xFFFF0000);
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
			shape : false,
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
			converge : No,
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
		case VRandom(a, b, conv):
			c.min = a;
			c.max = a + b;
			c.converge = conv;
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

	function getShapeValue( value : String ) {
		return switch( [state.shape, value] ) {
		case [(SLine(v) | SSphere(v) | SCone(v, _) | SDisc(v)), "size"]: v;
		case [SCone(_, a), "angle"]: a;
		default: VConst(0);
		}
	}

	function rebuildShape( mode : Int, getValue ) {
		var size = getValue("size");
		state.shape = switch( mode ) {
		case 0: SLine(size);
		case 1: SSphere(size);
		case 2: SCone(size, getValue("angle"));
		case 3: SDisc(size);
		default: throw "Unknown shape #" + mode;
		}
	}

	function setCurShape( mode : Int ) {
		rebuildShape(mode, getShapeValue);
		buildUI();
	}

	function setCurveMode( mode : Int ) {
		var cm = ui.getElementById("curve").getParent();
		cm.removeClass("m_" + CURVES[curve.mode].name.toLowerCase());
		curve.mode = mode;
		var cn = CURVES[curve.mode].name.toLowerCase();
		cm.addClass("m_" + cn);
		if( cn == "curve" && curve.max == 0 ) {
			curve.max = 1;
			buildUI();
		} else
			updateCurve();
	}

	function updateCurve() {
		curve.value = CURVES[curve.mode].f(curve);
		if( curve.name != null ) {
			if( curve.shape )
				rebuildShape(Type.enumIndex(state.shape),function(n) return n == curve.name ? curve.value : getShapeValue(n));
			else
				Reflect.setField(state, curve.name, curve.value);
		}
		rebuildCurve();
	}

	function setTexture( t : h2d.Tile ) {
		state.frames = [t];
		curTile = t;
		state.initFrames();
	}

	override function sync( ctx : h2d.RenderContext ) {
		// if resized, let's reflow our ui
		if( ctx.engine.width != width || ctx.engine.height != height ) {
			ui.refresh();
			width = ctx.engine.width;
			height = ctx.engine.height;
		}
		if( cachedMode != state.blendMode && state.textureName == null ) {
			cachedMode = state.blendMode;
			setTexture(null);
		}
		var old = state.frames;
		state.frames = null;
		var s = haxe.Serializer.run(state);
		state.frames = old;
		if( s != curState ) {
			stateChanged = haxe.Timer.stamp();
			curState = s;
			emit.setState(state);
		} else if( stateChanged != null && haxe.Timer.stamp() - stateChanged > 1 ) {
			stateChanged = null;
			undo.push({ state : curState, frames : old });
			redo = [];
		}
		emit.speed = props.pause ? 0 : (props.slow ? 0.1 : 1);
		if( moveEmitter ) onMoveEmitter(ctx.elapsedTime);
		var pcount = emit.count;
		if( stats != null )
			stats.text = [
				hxd.Math.fmt(emit.time * state.globalLife) + " s",
				pcount + " parts",
				hxd.Math.fmt(ctx.engine.fps) + " fps",
			].join("\n");
		if( autoLoop && !emit.isActive() ) {
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