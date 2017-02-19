class Pad extends hxd.App {

	var flow : h2d.Flow;
	var l : Array<PadUI>;
	var tf : h2d.Text;

	override function init() {
		l = [];
		flow = new h2d.Flow(s2d);
		flow.padding = 20;
		flow.isVertical = true;

		tf = new h2d.Text(hxd.res.DefaultFont.get(), flow);
		tf.text = "Waiting for pad...";

		hxd.Pad.wait(onPad);
	}

	function onPad( p : hxd.Pad ){
		tf.remove();
		var ui = new PadUI(p, flow);
		l.push( ui );
		p.onDisconnect = function(){
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

class PadUI extends h2d.Sprite {

	var tfName : h2d.Text;

	var bg : h2d.Graphics;
	var main : h2d.Graphics;
	var left : h2d.Graphics;
	var right : h2d.Graphics;

	var lt : h2d.Graphics;
	var rt : h2d.Graphics;

	var buttons : Map<String,h2d.Text>;

	var pad : hxd.Pad;

	public function new( p : hxd.Pad, parent : h2d.Sprite ){
		super( parent );

		pad = p;

		bg = new h2d.Graphics(this);
		bg.lineStyle(1,0xFFFFFF,0.5);
		bg.drawRect(0,0,600,160);
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

		var x = 0;
		for( n in ["A","B","X","Y","LB","RB","back","start","dpadUp","dpadDown","dpadLeft","dpadRight"] ){
			var t = new h2d.Text(fnt,this);
			x += 20;
			t.x = x;
			t.y = 140;
			t.text = n;
			t.alpha = 0.1;
			buttons.set(n,t);
			x += t.textWidth;
		}
	}

	public function update(){
		var conf = #if flash hxd.Pad.CONFIG_XBOX #else hxd.Pad.CONFIG_SDL #end;
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

		for( k in buttons.keys() )
			buttons[k].alpha = 0.3 + (pad.buttons[ Reflect.field(conf,k) ] ? 0.7 : 0);
	}
}