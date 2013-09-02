@:bitmap("default.png") class DefaultPart extends flash.display.BitmapData {
}

@:bitmap("defaultAlpha.png") class DefaultPartAlpha extends flash.display.BitmapData {
}

class MovingPart extends h3d.scene.Particles.Particle {
	public var time : Float;
	public var decay : Float;
	public var vx : Float;
	public var vy : Float;
	public var vz : Float;
	public var acc : Float;
	public var speed : Float;
	public var life : Float;
	public var alphaDecay : Float;
	public var rotSpeed : Float;
	public var sizeAcc : Float;
	public function new() {
		super(null);
	}
}

class RangeSlider extends h2d.comp.Slider {
	public var range(default,set) : Float;
	public function new(?parent) {
		super(parent);
		range = 0.;
		this.cursor.customStyle = new h2d.css.Style();
		input.onWheel = function(e:hxd.Event) {
			range += e.wheelDelta * 0.01;
			if( range < 0 ) range = 0;
			onChange(value);
		};
	}
	function set_range(v) {
		needRebuild = true;
		return this.range = v;
	}
	override function resize(ctx:h2d.comp.Context) {
		super.resize(ctx);
		if( ctx.measure )
			this.cursor.customStyle.paddingLeft = this.cursor.customStyle.paddingRight = Std.int(range * width * 0.5);
	}
}

class Prop {
	public var value : Float;
	public var range : Float;
	public function new(v=0.) {
		value = v;
		range = 0.;
	}
	public function set(v, r) {
		this.value = v;
		this.range = r;
	}
	public function get() {
		return value + (Math.random() * 2 - 1) * range;
	}
	public function getClamp() {
		var v = get();
		if( v < 0 ) v = 0;
		if( v > 1 ) v = 1;
		return v;
	}
}

class Main {
	
	var s3d : h3d.scene.Scene;
	var s2d : h2d.Scene;
	var engine : h3d.Engine;
	var ui : h2d.comp.Component;
	var emit : h3d.scene.Particles;
	var stats : h2d.comp.Label;
	var props : {
		add : Bool,
		tex : String,
		gspeed : Float,
		count : Prop,
		life : Prop,
		speed : Prop,
		acc : Prop,
		alpha : Prop,
		alphaDecay : Prop,
		rot : Prop,
		rotSpeed : Prop,
		size : Prop,
		sizeAcc : Prop,
	};
	var gen : Float = 0.;
	var parts : Array<MovingPart>;
	var addMode : Null<Bool>;
	
	public function new() {
		engine = new h3d.Engine();
		engine.onReady = init;
		engine.init();
		h2d.Font.embed("Arial", "arial.ttf");
	}
	
	function init() {
		hxd.System.setLoop(update);
		s3d = new h3d.scene.Scene();
		s2d = new h2d.Scene();
		parts = [];
		props = {
			tex : null,
			add : true,
			count : new Prop(),
			life : new Prop(),
			speed : new Prop(),
			acc : new Prop(0.5),
			alpha : new Prop(1),
			alphaDecay : new Prop(),
			rot : new Prop(),
			rotSpeed : new Prop(0.5),
			size : new Prop(0.5),
			sizeAcc : new Prop(0.5),
			gspeed : 0.5,
		};
		var p = new h2d.comp.Parser( { props : props } );
		p.register("range", function(x:haxe.xml.Fast, parent) return new RangeSlider(parent));
		ui = p.build(new haxe.xml.Fast(Xml.parse(hxd.System.getFileContent("ui.html")).firstElement()));
		engine.onResized = function() ui.setStyle(null);
		s2d.addChild(ui);
		s3d.addPass(s2d);
		engine.render(s2d);
		stats = cast ui.getElementById("stats");
		emit = new h3d.scene.Particles(s3d);
		emit.hasRotation = true;
		emit.hasSize = true;
		setTexture(hxd.BitmapData.fromNative(new DefaultPart(0, 0)));
	}
	
	function setTexture( t : hxd.BitmapData ) {
		if( emit.material.texture != null )
			emit.material.texture.dispose();
		emit.material.texture = h3d.mat.Texture.fromBitmap(t);
	}
	
	function update() {
		
		var dt = 120 * props.gspeed / engine.fps;
		gen += props.count.getClamp() * 10;
		while( gen >= 0 ) {
			var p = new MovingPart();
			p.vx = (Math.random() * 2 - 1);
			p.vy = (Math.random() * 2 - 1);
			p.vz = (Math.random() * 2 - 1);
			p.life = (props.life.getClamp() * 3 + 0.1) * 60;
			p.speed = props.speed.getClamp() * 0.3;
			p.acc = (props.acc.get() - 0.5) * 0.2 + 1;
			p.alpha = props.alpha.get();
			p.alphaDecay = props.alphaDecay.get() * 0.5;
			p.rotation = props.rot.getClamp() * Math.PI * 2;
			p.rotSpeed = (props.rotSpeed.get() - 0.5) * 0.5;
			p.size = props.size.get() * 2;
			p.sizeAcc = (props.sizeAcc.get() - 0.5) * 0.2 + 1;
			emit.add(p);
			parts.push(p);
			gen -= 1.0;
		}
		for( p in parts ) {
			var a = Math.pow(p.acc, dt);
			p.vx *= a;
			p.vy *= a;
			p.vz *= a;
			p.size *= Math.pow(p.sizeAcc, dt);
			var s = p.speed * dt;
			p.x += p.vx * s;
			p.y += p.vy * s;
			p.z += p.vz * s;
			p.life -= dt;
			p.alpha -= p.alphaDecay * dt;
			p.rotation += p.rotSpeed * dt;
			if( p.life < 0 ) {
				p.remove();
				parts.remove(p);
			}
		}
		stats.text = parts.length + " p\n" + h3d.FMath.fmt(engine.fps) + " fps";
		if( props.add )
			emit.material.blend(SrcAlpha, One);
		else
			emit.material.blend(SrcAlpha, OneMinusSrcAlpha);
		if( addMode != props.add && props.tex == null ) {
			addMode = props.add;
			setTexture(hxd.BitmapData.fromNative(addMode ? new DefaultPart(0, 0) : new DefaultPartAlpha(0, 0)));
		}
		engine.render(s3d);
		s2d.checkEvents();
	}
	
	static function main() {
		new Main();
	}
	
}