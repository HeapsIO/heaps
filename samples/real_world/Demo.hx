
import flash.Lib;
import h2d.Anim;
import h2d.Bitmap;
import h2d.Text;
import h3d.Engine;
import haxe.Resource;
import haxe.Timer;
import haxe.Utf8;
import hxd.BitmapData;
import h2d.SpriteBatch;
import hxd.Profiler;
import hxd.System;
class Demo 
{
	var engine : h3d.Engine;
	var scene : h2d.Scene;
	var actions : List < Void->Void > ;
	
	function new() 
	{
		engine = new h3d.Engine();
		engine.onReady = init;
		engine.backgroundColor = 0xFFCCCCCC;
		//engine.autoResize = true;
		engine.init();
		
		#if flash
		flash.Lib.current.addChild(new openfl.display.FPS());
		#end
		//flash.Lib.current.addEventListener(flash.events.Event.RESIZE, onResize );
	}
	
	function onResize(_)
	{
		trace("resize");
		trace(flash.Lib.current.stage.stageWidth + " " + flash.Lib.current.stage.stageHeight);
	}
	
	function init() 
	{
		
		scene = new h2d.Scene();
		var root = new h2d.Sprite(scene);
		
		var font = hxd.res.FontBuilder.getFont("arial", 32, { antiAliasing : false , chars : hxd.Charset.DEFAULT_CHARS } );
		var fontRoboto = hxd.res.FontBuilder.getFont("Roboto-Black", 32, { antiAliasing : false , chars : hxd.Charset.DEFAULT_CHARS } );
		
		var tileHaxe = hxd.Res.haxe.toTile();
		var tileNME = hxd.Res.nme.toTile();
		var tileOFL = hxd.Res.openfl.toTile();
		
		var oTileHaxe = tileHaxe;
		
		tileHaxe = tileHaxe.center( Std.int(tileHaxe.width / 2), Std.int(tileHaxe.height / 2) );
		tileNME = tileNME.center( Std.int(tileNME.width / 2), Std.int(tileNME.height / 2) );
		tileOFL = tileOFL.center( Std.int(tileOFL.width / 2), Std.int(tileOFL.height / 2) );
		
		var stw = flash.Lib.current.stage.stageWidth;
		var sth = flash.Lib.current.stage.stageHeight;
		
		var fill = new Bitmap(tileHaxe.center(0,0), scene);
		fill.scaleX =  stw / tileHaxe.width;
		fill.scaleY =  sth / tileHaxe.height * 0.7;
		fill.toBack();
		fill.name = "fill";
		
		var subHaxe = oTileHaxe.sub(0, 0, 16, 16).center(8, 8);
		batch = new SpriteBatch( tileHaxe, scene );
		batch.hasVertexColor = true;
		batch.hasVertexAlpha = true;
		batch.hasRotationScale = true;
		
		for ( i in 0...16*16) {
			var e = batch.alloc(tileHaxe);
			e.x = (i % 16) * 16; 
			e.y = Std.int(i / 16) * 16;
			e.t = subHaxe;
			e.color.x = Math.random();
			e.color.y = Math.random();
			e.color.z = Math.random();
			e.width = 16;
			e.height = 16;
			e.skewY = Math.PI / 4;
			var p = -5 + Std.random(10);
			e.changePriority(p);
		}
		batch.name = "batch";
		
		fps=new h2d.Text(font, root);
		fps.textColor = 0xFFFFFF;
		fps.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
		fps.text = "";
		fps.x = 0;
		fps.y = 450;
		fps.name = "tf";
		
		tf = new h2d.Text(font, root);
		tf.textColor = 0xFFFFFF;
		tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
		tf.text = "This is a large batch of text\n that is representative about\n real world pavé.";
		tf.y = 300;
		tf.x = System.height * 0.5;
		tf.name = "tf";
		
		var char = hxd.Res.char.toTile();
		
		var idle_anim : Array<h2d.Tile> = [];
		
		var x = 0;
		var y = 0;
		var w = 48; var h = 32;
		var idle_anim = [];
		for ( i in 0...6) {
			idle_anim.push( char.sub(x, y, w, h).center(w >> 1, h) );
			x += 48;
		}
		
		anim = new Anim(idle_anim,scene);
		anim.x = 16;
		anim.y = 200; 
		anim.name = "anim";
		
		
		bmp = new Bitmap(idle_anim[1], scene);
		bmp.name = "bitmap";
		bmp.x = 16;
		bmp.y = 250; 
		anims = [];
		
		bmp = new Bitmap(idle_anim[1], scene);
		bmp.name = "bitmap";
		bmp.x = 100;
		bmp.y = 250; 
		//bmp.skewX = Math.PI / 4;
		
		
		var shCircle = new flash.display.Shape();
		shCircle.graphics.beginFill(0xFF0000);
		shCircle.graphics.drawCircle(60, 400, 50);
		shCircle.graphics.endFill();
		
		var shSquare = new flash.display.Shape();
		shSquare.graphics.beginFill(0x004080);
		shSquare.graphics.drawRect(100, 400, 50, 50);
		shSquare.graphics.endFill();
		
		h2d.Sprite.fromSprite(shCircle, scene);
		h2d.Sprite.fromSprite(shSquare, scene);
				
		var local = new h2d.Sprite(scene);
		local.name = "local";
		var a = null;
		for ( i in 0...16 * 16) {
			
			anims.push( a = new Anim(idle_anim, anim.shader, local));
			a.name = "anim"+i;
			a.x = 300 + i%16 * 16;
			a.y = 16 + Std.int(i / 16) * 16;
		}
		
		var s = new h2d.Graphics(scene);
		s.beginFill(0xFF00FF);
		s.drawRect(0, 0, 50, 50);
		s.endFill();
		
		s.x = 300;
		s.y = 300;
		square = s;
		
		var s = new h2d.Graphics(s);
		s.beginFill(0xFF00FF);
		s.drawCircle(0, 0, 30, 30);
		s.endFill();
		
		s.x = 50;
		s.y = 50;
		sphere = s;
		
		hxd.System.setLoop(update);
		
		bds = new h2d.Graphics(scene);
		
		square = new Bitmap(idle_anim[1], scene);
		square.name = "bitmap";
		square.x = 200;
		square.y = 250; 
		
		sphere = new Bitmap(idle_anim[1], square);
		sphere.name = "bitmap";
		sphere.x = 50;
		sphere.y = 50; 
		
	}
	
	static var square: h2d.Sprite;
	static var sphere : h2d.Sprite;
	static var bds : h2d.Graphics;
	
	
	static var fps : Text;
	static var tf : Text;
	static var batch : SpriteBatch;
	static var bmp : Bitmap;
	static var anim : h2d.Anim;
	static var anims : Array<h2d.Anim>;
	
	var spin = 0;
	var count = 0;
	function update() 
	{
		sphere.rotation += 0.02;
		square.rotation += 0.001;
		square.scaleX = square.scaleY = 0.5 + 0.5 * Math.abs(Math.sin(count* 0.01 ));
		sphere.scaleX = sphere.scaleY = 0.5 + 0.5 * Math.abs(Math.sin(count * 0.1 ));
		
		//bmp.rotation += 0.003;
		bmp.skewX = Math.PI / 8;
		bmp.skewY = Math.PI / 8;
		bmp.scaleX = 1.0 + 0.1 * Math.abs(Math.sin(count * 0.1 ));
		
		bds.clear();
		bds.beginFill(0xFF00FF, 0.2); 
		var b = bmp.getBounds();
		bds.drawRect(b.x, b.y, b.width, b.height);
		bds.endFill();
		
		for ( e in batch.getElements()) 
			e.rotation += 0.1;
		
		Profiler.end("myUpdate");
		Profiler.begin("engine.render");
		engine.render(scene);
		Profiler.end("engine.render");
		Profiler.begin("engine.vbl");
		if (count > 100) {
			trace(Profiler.dump());
			Profiler.clean();
			count = 0;
		}
		
		count++;
		
		#if cpp
		var driver : h3d.impl.GlDriver = cast Engine.getCurrent().driver;
		
		Profiler.end("engine.vbl");
		Profiler.begin("myUpdate");
		if(spin++>=10){
			fps.text = Std.string(Engine.getCurrent().fps) + " ssw:"+driver.shaderSwitch+" tsw:"+driver.textureSwitch+" rsw"+driver.resetSwitch;
			spin = 0;
		}
		#end
		
		
	}
	
	static function main() 
	{
		hxd.Res.loader = new hxd.res.Loader(hxd.res.EmbedFileSystem.create());
		new Demo();
	}
}
