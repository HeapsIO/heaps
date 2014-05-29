import flash.display.Sprite;
import flash.events.Event;


class NMEPreloader extends Sprite
{
	private var outline:Sprite;
	private var progress:Sprite;
	
	
	public function new()
	{
		super();
		
		var backgroundColor = getBackgroundColor ();
		var r = backgroundColor >> 16 & 0xFF;
		var g = backgroundColor >> 8  & 0xFF;
		var b = backgroundColor & 0xFF;
		var perceivedLuminosity = (0.299 * r + 0.587 * g + 0.114 * b);
		var color = 0x000000;
		
		if (perceivedLuminosity < 70) {
			
			color = 0xFFFFFF;
			
		}
		
		var x = 30;
		var height = 9;
		var y = getHeight () / 2 - height / 2;
		var width = getWidth () - x * 2;
		
		var padding = 3;
		
		outline = new Sprite ();
		outline.graphics.lineStyle (1, color, 0.15, true);
		outline.graphics.drawRoundRect (0, 0, width, height, padding * 2, padding * 2);
		outline.x = x;
		outline.y = y;
		addChild (outline);
		
		progress = new Sprite ();
		progress.graphics.beginFill (color, 0.35);
		progress.graphics.drawRect (0, 0, width - padding * 2, height - padding * 2);
		progress.x = x + padding;
		progress.y = y + padding;
		progress.scaleX = 0;
		addChild (progress);
	}
	
	
	public function getBackgroundColor():Int
	{
		return 65535;
	}
	
	
	public function getHeight():Float
	{
		var height = 480;
		
		if (height > 0) {
			
			return height;
			
		} else {
			
			return flash.Lib.current.stage.stageHeight;
			
		}
	}
	
	
	public function getWidth():Float
	{
		var width = 800;
		
		if (width > 0) {
			
			return width;
			
		} else {
			
			return flash.Lib.current.stage.stageWidth;
			
		}
	}
	
	
	public function onInit()
	{
		
	}
	
	
	public function onLoaded()
	{
		dispatchEvent (new Event (Event.COMPLETE));
	}

	
	public function onUpdate(bytesLoaded:Int, bytesTotal:Int)
	{
		var percentLoaded = bytesLoaded / bytesTotal;
		
		if (percentLoaded > 1)
		{
			percentLoaded == 1;
		}
		
		progress.scaleX = percentLoaded;
	}

	
}