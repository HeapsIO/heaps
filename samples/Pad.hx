class Pad extends hxd.App {

	var flow : h2d.Flow;
	var l : Array<PadUI>;
	var tf : h2d.Text;

	override function init() {
		l = [];
		flow = new h2d.Flow(s2d);
		flow.padding = 20;
		flow.layout = Vertical;

		tf = new h2d.Text(hxd.res.DefaultFont.get(), flow);
		tf.text = "Waiting for pad...";

		hxd.Pad.wait(onPad);
	}

	function onPad( p : hxd.Pad ){
		tf.remove();
		var ui = new PadUI(p, flow);
		l.push( ui );
		if( !p.connected )
			throw "Pad not connected ?";
		p.onDisconnect = function(){
			if( p.connected )
				throw "OnDisconnect called while still connected ?";
			ui.remove();
			l.remove( ui );
		}
		flow.reflow();
	}

	// if we the window has been resized
	override function onResize() {

	}

	override function update(dt:Float) {
		for( ui in l )
			ui.update();
	}

	static function main() {
		hxd.Res.initEmbed();
		new Pad();
	}

}

class PadUI extends h2d.Object {

	var tfName : h2d.Text;

	var bg : h2d.Graphics;
	var main : h2d.Graphics;
	var left : h2d.Graphics;
	var right : h2d.Graphics;

	var lt : h2d.Graphics;
	var rt : h2d.Graphics;

	var buttons : Map<String,{ tf : h2d.Text, bg : h2d.Bitmap }>;

	var pad : hxd.Pad;

	public function new( p : hxd.Pad, parent : h2d.Object ){
		super( parent );

		pad = p;

		bg = new h2d.Graphics(this);
		bg.lineStyle(1,0xFFFFFF,0.5);
		bg.drawRect(0,0,660,160);
		bg.lineStyle(1,0xFFFFFF,1);
		bg.drawRect(20,20,100,100);
		bg.drawRect(140,20,100,100);
		bg.drawRect(260,20,20,100);
		bg.drawRect(300,20,20,100);
		bg.endFill();

		var fnt = hxd.Res.customFont.toFont();

		tfName = new h2d.Text(fnt,this);
		tfName.text = pad.name;

		main = new h2d.Graphics(this);
		main.lineStyle(1,0x00FF00,1);
		main.drawCircle(0,0,4);
		main.endFill();

		left = new h2d.Graphics(this);
		right = new h2d.Graphics(this);

		for( g in [left,right] ){
			g.beginFill(0xFF0000);
			g.drawCircle(0,0,2);
			g.endFill();
		}

		lt = new h2d.Graphics(this);
		lt.x = 260;
		rt = new h2d.Graphics(this);
		rt.x = 300;
		for( g in [lt,rt] ){
			g.beginFill(0x00FF00);
			g.drawRect(0,0,20,100);
			g.endFill();
			g.scaleY = 0;
			g.y = 120;
		}

		buttons = new Map();

		var x = 0.;
		for( n in ["A","B","X","Y","LB","RB","LT","RT","back","start","dpadUp","dpadDown","dpadLeft","dpadRight"] ){
			var t = new h2d.Text(fnt,this);
			x += 20;
			t.x = x;
			t.y = 140;
			t.text = n;
			t.alpha = 0.1;
			var bg = new h2d.Bitmap(h2d.Tile.fromColor(0xFFFFFF, hxd.Math.ceil(t.textWidth), 8), t);
			bg.y = 10;
			bg.alpha = 0;
			buttons.set(n, { tf : t, bg : bg });

			x += t.textWidth;
		}
	}

	var wasPressed = false;
	public function update(){
		var conf = pad.config;
		main.x = 20 + 50 + pad.xAxis * 50;
		main.y = 20 + 50 + pad.yAxis * 50;

		left.x = 20 + 50 + pad.values[ conf.analogX ] * 50;
		left.y = 20 + 50 - pad.values[ conf.analogY ] * 50;
		left.setScale( 1 + 3 * pad.values[conf.analogClick] );

		right.x = 140 + 50 + pad.values[ conf.ranalogX ] * 50;
		right.y = 20 + 50 - pad.values[ conf.ranalogY ] * 50;
		right.setScale( 1 + 3 * pad.values[conf.ranalogClick] );

		lt.scaleY = -pad.values[ conf.LT ];
		rt.scaleY = -pad.values[ conf.RT ];

		for( k in buttons.keys() ) {
			var bid = Reflect.field(conf, k);
			var but = buttons[k];
			but.tf.alpha = 0.3 + (pad.buttons[bid] ? 0.7 : 0);

			if( pad.buttons[bid] != pad.isDown(bid) )
				throw "Button " + bid + " = " + pad.buttons[bid] + " but isDown = " + pad.isDown(bid);

			var bg = but.bg;
			if( pad.isPressed(bid) ) {
				bg.alpha = 1;
				bg.color.setColor(0xFF00FF00);
			} else if( pad.isReleased(bid) ) {
				bg.alpha = 1;
				bg.color.setColor(0xFFFF0000);
			} else if( bg.alpha > 0 )
				bg.alpha -= 0.05;
		}

		if( !wasPressed && pad.isDown(conf.A) && pad.values[conf.LT] > 0 && pad.values[conf.RT] > 0 )
			pad.rumble( pad.values[conf.LT], pad.values[conf.RT]*0.5 );
		wasPressed = pad.isDown(conf.A);

		if(hxd.Key.isDown(hxd.Key.ESCAPE)) {
			hxd.System.exit();
		}
	}
}