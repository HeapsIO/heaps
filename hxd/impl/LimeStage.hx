package hxd.impl;
import hxd.Event;

@:allow(hxd.Stage)
@:access(hxd.Stage)
class LimeStage implements lime.app.IModule {
	
	var stage : hxd.Stage;

	var width : Int;
	var height : Int;

	var mouseX : Int = 0;
	var mouseY : Int = 0;

	public function new( s : hxd.Stage ){
		stage = s;
		width = hxd.System.width;
		height = hxd.System.height;
	}

	public function render(renderer){
		if( hxd.System.loopFunc != null )
			hxd.System.loopFunc();
	}

	public function onWindowResize(win, w, h){
		width = w;
		height = h;
		stage.onResize(null);
	}

	public function onMouseMove(win, x, y){
		mouseX = Std.int(x);
		mouseY = Std.int(y);
		stage.event(new Event(EMove, mouseX, mouseY));
	}

	public function onMouseDown(win, x, y, button){
		var e = new Event(EPush, x, y);
		e.button = button;
		stage.event(e);
	}

	public function onMouseUp(win, x, y, button){
		var e = new Event(ERelease, x, y);
		e.button = button;
		stage.event(e);
	}
	
	public function onMouseWheel( win, dx : Float, dy : Float ){
		if( dy != 0 ){
			var ev = new Event(EWheel, mouseX, mouseY);
			ev.wheelDelta = dy;
			stage.event(ev);
		}
	}

	public function onGamepadAxisMove( gamepad, axis, value:Float ){ }
	
	public function onGamepadButtonDown( gamepad, button ){ }
	
	public function onGamepadButtonUp( gamepad, button ){ }
	
	public function onGamepadConnect( gamepad ){}

	public function onGamepadDisconnect( gamepad ){ }
	
	public function onJoystickAxisMove( joystick, axis:Int, value:Float ){ }

	public function onJoystickButtonDown( joystick, button:Int ){ }

	public function onJoystickButtonUp( joystick, button:Int ){ }

	public function onJoystickConnect( joystick ){ }

	public function onJoystickDisconnect( joystick ){ }

	public function onJoystickHatMove( joystick, hat:Int, position ){ }
	
	public function onJoystickTrackballMove( joystick, trackball:Int, value:Float ){ }

	public function onKeyDown( window, keyCode, modifier ){ }

	public function onKeyUp( window, keyCode, modifier ){ }

	public function onModuleExit( code:Int ){ }
	
	public function onMouseMoveRelative( window, x:Float, y:Float ){ }
	
	public function onPreloadComplete(  ){ }
	
	public function onPreloadProgress( loaded:Int, total:Int ){ }

	public function onRenderContextLost( renderer ){ }

	public function onRenderContextRestored( renderer, context ){ }

	public function onTextEdit( window, text:String, start:Int, length:Int ){ }

	public function onTextInput( window, text:String ){ }

	public function onTouchEnd( touch ){ }

	public function onTouchMove( touch ){ }

	public function onTouchStart( touch ){ }
	
	public function onWindowActivate( window ){ }

	public function onWindowClose( window ){ }
	
	public function onWindowCreate( window ){ }
	
	public function onWindowDeactivate( window ){ }

	public function onWindowEnter( window ){ }
	
	public function onWindowFocusIn( window ){ }

	public function onWindowFocusOut( window ){ }

	public function onWindowFullscreen( window ){ }
	
	public function onWindowLeave( window ){ }
	
	public function onWindowMove( window, x:Float, y:Float ){ }
	
	public function onWindowMinimize( window ){ }
	
	public function onWindowRestore( window ){ }

	public function update( dt ){ }
		
}
