
import h2d.Graphics;
import h2d.Sprite;
import h2d.Text;
import h2d.TileGroup;
import h3d.Engine;
import haxe.Resource;
import haxe.Utf8;
import hxd.BitmapData;
import h2d.SpriteBatch;
class Demo 
{
	var engine : h3d.Engine;
	var scene : h2d.Scene;
	
	function new() 
	{
		engine = new h3d.Engine();
		engine.onReady = init;
		engine.backgroundColor = 0xFFCCCCCC;
		engine.init();
		
		#if flash
		flash.Lib.current.addChild(new openfl.display.FPS());
		#end
	}
	
	function onResize(_)
	{
		trace("resize");
		trace(flash.Lib.current.stage.stageWidth + " " + flash.Lib.current.stage.stageHeight);
	}
	
	function init() 
	{
		scene = new h2d.Scene();
		
		var tileHaxe = hxd.Res.haxe.toTile();
		var tileNME = hxd.Res.nme.toTile();
		var oTileHaxe = tileHaxe;
		
		tileHaxe = tileHaxe.center( Std.int(tileHaxe.width / 2), Std.int(tileHaxe.height / 2) );
		tileNME = tileNME.center( Std.int(tileNME.width / 2), Std.int(tileNME.height / 2) );
		
		var font = hxd.res.FontBuilder.getFont("arial", 32, { antiAliasing : false , chars : hxd.Charset.DEFAULT_CHARS } );
		var tf = fps=new h2d.Text(font, scene);
		tf.textColor = 0xFFFFFF;
		tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
		tf.text = "turlututu";
		tf.scale(2);
		tf.y = 100;
		tf.x = 200;
           
		
		var shape = new h2d.Graphics(scene); 
		shape.lineStyle(2, 0, 0.5); 
		for (h in 0...6) { 
		   var angle = 2 * Math.PI / 6 * h; 
		   var pointX = (30) * Math.cos(angle); 
		   var pointY = (30) * Math.sin(angle); 
		   if (h == 0) shape.addPoint(pointX + 60 / 2 + 1, pointY + 52 / 2 - 1); 
		   else shape.addPoint(pointX + 60 / 2 + 1, pointY + 52 / 2 - 1); 
		} 
		shape.endFill(); 
		 
		shape.x = 300; 
		shape.y = 300; 
		 
		var sh = new h2d.Graphics(scene); 
		sh.lineStyle(2, 0, 0.5); 
		sh.addPoint(0, 0); 
		sh.addPoint(50, 0); 
		sh.addPoint(50, 50); 
		sh.addPoint(0, 50); 
		sh.x = 100; 
		sh.y = 300; 
		sh.endFill();
		
		
		var q = new h2d.Graphics(scene);
		var b = sh.getBounds();
		q.beginFill(0xFF0000, 0.5);
		q.drawRect(b.x, b.y, b.width, b.height );
		q.endFill();
		
		
		var q = new h2d.Graphics(scene);
		var b = shape.getBounds();
		q.beginFill(0xFF0000, 0.5);
		q.drawRect(b.x, b.y, b.width, b.height );
		q.endFill();
		
		
		var q = new h2d.Graphics(scene);
		var b = tf.getBounds();
		q.beginFill(0xFF0000, 0.5);
		q.drawRect(b.x, b.y, b.width, b.height );
		q.endFill();
		
		hxd.System.setLoop(update);
	}
	
	static var fps : Text;
	static var bmp : h2d.Bitmap;
	public var batch : SpriteBatch;
	
	var spin = 0;
	var count = 0;
	
	function update() 
	{
		count++; // Utilité du count ?
		if (spin++ >=5){
			fps.text = Std.string(Engine.getCurrent().fps);
			spin = 0;
		}
		
		engine.render(scene);
	}
	
	static function main() 
	{
		hxd.Res.loader = new hxd.res.Loader(hxd.res.EmbedFileSystem.create());
		new Demo();
	}
}
