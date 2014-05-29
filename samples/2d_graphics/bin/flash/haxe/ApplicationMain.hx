#if (!macro || !haxe3)
#if (nme || openfl)


import flash.display.DisplayObject;
import flash.display.LoaderInfo;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.Lib;
import openfl.Assets;


class ApplicationMain {
	
	
	private static var complete:Bool;
	private static var loaderInfo:LoaderInfo;
	private static var preloader:NMEPreloader;
	
	
	public static function main () {
		
		
		
		//nme.Lib.setPackage("", "StressTest", "h2d.samples.h2d_2d_bounds", "1.0.0");
		
		loaderInfo = flash.Lib.current.loaderInfo;
		
		loaderInfo.addEventListener (Event.COMPLETE, loaderInfo_onComplete);
		loaderInfo.addEventListener (Event.INIT, loaderInfo_onInit);
		loaderInfo.addEventListener (ProgressEvent.PROGRESS, loaderInfo_onProgress);
		//loaderInfo.addEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
		//loaderInfo.addEventListener (HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
		
		
		
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		
		//if (loaderInfo.bytesLoaded < loaderInfo.bytesTotal || loaderInfo.bytesLoaded <= 0) {
			
			preloader = new NMEPreloader ();
			Lib.current.addChild (preloader);
			
			preloader.onInit ();
			preloader.onUpdate (loaderInfo.bytesLoaded, loaderInfo.bytesTotal);
			
			Lib.current.addEventListener (Event.ENTER_FRAME, current_onEnter);
			
		//} else {
			
			//start ();
			
		//}
		
		
		
	}
	
	
	private static function start ():Void {
		
		var hasMain = false;
		var mainClass = Type.resolveClass ("Demo");
		
		for (methodName in Type.getClassFields (mainClass)) {
			
			if (methodName == "main") {
				
				hasMain = true;
				break;
				
			}
			
		}
		
		if (hasMain) {
			
			Reflect.callMethod (mainClass, Reflect.field (mainClass, "main"), []);
			
		} else {
			
			var instance = Type.createInstance (DocumentClass, []);
			
			if (Std.is (instance, DisplayObject)) {
				
				Lib.current.addChild (cast instance);
				
			}
			
		}
		
	}
	
	
	private static function update ():Void {
		
		if (preloader != null) {
			
			preloader.onUpdate (loaderInfo.bytesLoaded, loaderInfo.bytesTotal);
			
		}
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private static function current_onEnter (event:Event):Void {
		
		if (complete) {
			
			Lib.current.removeEventListener (Event.ENTER_FRAME, current_onEnter);
			loaderInfo.removeEventListener (Event.COMPLETE, loaderInfo_onComplete);
			loaderInfo.removeEventListener (Event.INIT, loaderInfo_onInit);
			loaderInfo.removeEventListener (ProgressEvent.PROGRESS, loaderInfo_onProgress);
			
			if (preloader != null) {
				
				preloader.addEventListener (Event.COMPLETE, preloader_onComplete);
				preloader.onLoaded();
				
			} else {
				
				start ();
				
			}
			
		}
		
	}
	
	
	private static function loaderInfo_onComplete (event:Event):Void {
		
		complete = true;
		update ();
		
	}
	
	
	private static function loaderInfo_onInit (event:Event):Void {
		
		update ();
		
	}
	
	
	private static function loaderInfo_onProgress (event:ProgressEvent):Void {
		
		update ();
		
	}
	

	private static function preloader_onComplete (event:Event):Void {
		
		preloader.removeEventListener (Event.COMPLETE, preloader_onComplete);
		Lib.current.removeChild (preloader);
		Lib.current.stage.focus = null;
		preloader = null;
		
		start ();
		
	}
	
	
}


#else


import Demo;
import flash.display.DisplayObject;
import flash.Lib;


class ApplicationMain {
	
	
	public static function main () {
		
		var hasMain = false;
		
		for (methodName in Type.getClassFields (Demo)) {
			
			if (methodName == "main") {
				
				hasMain = true;
				break;
				
			}
			
		}
		
		if (hasMain) {
			
			Reflect.callMethod (Demo, Reflect.field (Demo, "main"), []);
			
		} else {
			
			var instance = Type.createInstance (DocumentClass, []);
			
			if (Std.is (instance, DisplayObject)) {
				
				Lib.current.addChild (cast instance);
				
			}
			
		}
		
	}
	
	
}


#end


#if haxe3 @:build(DocumentClass.build()) #end
@:keep class DocumentClass extends Demo { }


#else


import haxe.macro.Context;
import haxe.macro.Expr;


class DocumentClass {
	
	
	macro public static function build ():Array<Field> {
		
		var classType = Context.getLocalClass ().get ();
		var searchTypes = classType;
		
		while (searchTypes.superClass != null) {
			
			if (searchTypes.pack.length == 2 && searchTypes.pack[1] == "display" && searchTypes.name == "DisplayObject") {
				
				var fields = Context.getBuildFields ();
				var method = macro {
					return flash.Lib.current.stage;
				}
				
				fields.push ({ name: "get_stage", access: [ APrivate ], meta: [ { name: ":getter", params: [ macro stage ], pos: Context.currentPos() } ], kind: FFun({ args: [], expr: method, params: [], ret: macro :flash.display.Stage }), pos: Context.currentPos() });
				return fields;
				
			}
			
			searchTypes = searchTypes.superClass.t.get ();
			
		}
		
		return null;
		
	}
	
	
}


#end