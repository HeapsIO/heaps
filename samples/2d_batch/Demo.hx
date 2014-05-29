
import h2d.Graphics;
import h2d.BlurredBitmap;
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
	
	public static function blur( spr : h2d.Sprite, ?method : BlurMethod, ?freezed = false) : h2d.BlurredBitmap {
		var parent = spr.parent;
		var index = 0;
		if ( parent != null )
			index = spr.parent.getChildIndex(spr);
			
		var b = spr.getBounds();
		spr.detach();
		
		var bsize : Int = 4;//keep some pixel
		var hbsize : Int = (bsize >> 1);
		var blur = new BlurredBitmap(parent, Math.ceil(b.width + bsize), Math.ceil(b.height + bsize), method);
		
		blur.x = spr.x;
		blur.y = spr.y;
		blur.rotation =  spr.rotation;
		blur.scaleX = spr.scaleX; 
		blur.scaleY = spr.scaleY; 
		
		spr.scaleX = 1.0;
		spr.scaleY = 1.0;
		spr.x = 0;
		spr.y = 0;
		spr.rotation = 0;
		
		spr.x += (b.width + hbsize)*0.5;
		spr.y += b.height + hbsize;
		blur.freezed = freezed;
		blur.addChild( spr );
		blur.x += -(hbsize + b.width)*0.5;
		blur.y += -(hbsize + b.height);
		
		parent.addChildAt( blur, index );
		return blur;
	}
	
	public static function glow( spr : h2d.Sprite, col : Int, ?alpha = 1.0, ?freezed = false  ) : BlurredBitmap {
		col = col & 0xFFFFFF;
		var method = Gaussian3x3OnePass;
		var blur = blur(spr, method, freezed);
		blur.redrawChilds = true;
		var ca = hxd.Math.getColorVector(col);
		ca.w = alpha;
		blur.colorSet = ca;
		blur.killAlpha = true;
		
		return blur;
	}
	
	public static function dropShadow( 
		spr : h2d.Sprite, col : Int, 
		?alpha = 0.5, ofsX = 2.5, ofsY = 2.0, ?freezed = false  ) 	: BlurredBitmap {
		
		col = col & 0xFFFFFF;
		var method = Gaussian3x3OnePass;
		var blur = blur(spr, method, freezed);
		blur.width += ofsX;
		blur.height += ofsY;
		blur.redrawChilds = true;
		
		var m = new h3d.Matrix();
		var c = hxd.Math.getColorVector(col);
		
		m.identity();
		m._11 = 0.3; m._21 = 0.59; m._31 = 0.11;
		m._12 = 0.3; m._22 = 0.59; m._32 = 0.11;
		m._13 = 0.3; m._23 = 0.59; m._33 = 0.11;
		blur.colorMatrix = m;
		blur.color = c;
		
		var spr = blur.getChildAt(0);
		blur.ofsX = ofsX;
		blur.ofsY = ofsY;
		blur.blendMode = h2d.BlendMode.Multiply;
		
		return blur;
	}
	
	
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
		
		var tileHaxe = hxd.Res.haxe.toTile();
		var tileNME = hxd.Res.nme.toTile();
		var tileOFL = hxd.Res.openfl.toTile();
		var oTileHaxe = tileHaxe;
		
		tileHaxe = tileHaxe.center( Std.int(tileHaxe.width / 2), Std.int(tileHaxe.height / 2) );
		//tileHaxe = tileHaxe.center( 0,0 );
		tileNME = tileNME.center( Std.int(tileNME.width / 2), Std.int(tileNME.height / 2) );
		tileOFL = tileOFL.center( Std.int(tileOFL.width / 2), Std.int(tileOFL.height / 2) );
		
		var font = hxd.res.FontBuilder.getFont("arial", 32, { antiAliasing : false , chars : hxd.Charset.DEFAULT_CHARS } );
		var tf = fps=new h2d.Text(font, scene);
		tf.textColor = 0xFFFFFF;
		tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
		tf.text = "";
		tf.scale(1);
		tf.y = 300;
		tf.x = 300;
		
		var subHaxe = oTileHaxe.sub(0, 0, 16, 16).center(8, 8);
		
		batch = new SpriteBatch( tileHaxe, scene );
		//batch.hasVertexColor = true;
		batch.hasRotationScale = true;
		for ( i in 0...16*16) {
			var e = batch.alloc(tileHaxe); // Qu'est ce qu'un batch exactement ? Pourquoi alloc sur le Tile Haxe (alors qu'il y a le subHaxe) ?
			e.x = (i % 32) * 32; 
			e.y = Std.int(i / 32) * 32;
			//e.t = subHaxe;
			e.color.x = Math.random();
			e.color.y = Math.random();
			e.color.z = Math.random();
			//e.sx = 2.0;
			//e.sy = 2.0;
			e.width = 32; // Resize
			e.height = 32;
		}
		
		bmp = new h2d.Bitmap(tileHaxe, scene);
		bmp.x = 400;
		bmp.y = 400;
		bmp.color = new h3d.Vector(1, 1, 1, 1); // Couleur via un vector ? w ?
		//bmp.visible = false;
		
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
		
		for ( e in batch.getElements()) {
			e.rotation += 0.1;
		}
		
		bmp.rotation += 0.01;
		//batch.rotation += 0.01;
		
		engine.render(scene);
	}
	
	static function main() 
	{
		hxd.Res.loader = new hxd.res.Loader(hxd.res.EmbedFileSystem.create());
		new Demo();
	}
}
