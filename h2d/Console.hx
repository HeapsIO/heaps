package h2d;

import hxd.Key;

enum ConsoleArg {
	AInt;
	AFloat;
	AString;
	ABool;
	AEnum( values : Array<String> );
}

class Console extends h2d.Sprite {

	public static var HIDE_LOG_TIMEOUT = 3.;

	var width : Int;
	var height : Int;
	var bg : h2d.Bitmap;
	var tf : h2d.Text;
	var logTxt : h2d.HtmlText;
	var cursor : h2d.Bitmap;
	var cursorPos(default, set) : Int;
	var lastLogTime : Float;
	var commands : Map < String, { help : String, args : Array<{ name : String, t : ConsoleArg, ?opt : Bool }>, callb : Dynamic } > ;
	var aliases : Map<String,String>;
	var logDY : Float = 0;
	var logs : Array<String>;
	var logIndex:Int;
	var curCmd:String;

	public var shortKeyChar : Int = "/".code;

	public function new(font:h2d.Font,?parent) {
		super(parent);
		height = font.lineHeight + 2;
		logTxt = new h2d.HtmlText(font, this);
		logTxt.x = 2;
		logTxt.visible = false;
		logs = [];
		logIndex = -1;
		bg = new h2d.Bitmap(h2d.Tile.fromColor(0,1,1,0.5), this);
		bg.visible = false;
		tf = new h2d.Text(font, bg);
		tf.x = 2;
		tf.y = 1;
		tf.textColor = 0xFFFFFFFF;
		cursor = new h2d.Bitmap(h2d.Tile.fromColor(tf.textColor, 1, font.lineHeight), tf);
		commands = new Map();
		aliases = new Map();
		addCommand("help", "Show help", [ { name : "command", t : AString, opt : true } ], showHelp);
		addAlias("?", "help");
	}

	public function addCommand( name, help, args, callb : Dynamic ) {
		commands.set(name, { help : help, args:args, callb:callb } );
	}

	public function addAlias( name, command ) {
		aliases.set(name, command);
	}

	public function runCommand( commandLine : String ) {
		handleCommand(commandLine);
	}

	override function onAlloc() {
		super.onAlloc();
		getScene().addEventListener(onEvent);
	}

	override function onDelete() {
		getScene().removeEventListener(onEvent);
		super.onDelete();
	}

	function onEvent( e : hxd.Event ) {
		switch( e.kind ) {
		case EWheel:
			if( logTxt.visible ) {
				logDY -= tf.font.lineHeight * e.wheelDelta * 3;
				if( logDY < 0 ) logDY = 0;
				if( logDY > logTxt.textHeight ) logDY = logTxt.textHeight;
				e.propagate = false;
			}
		case EKeyDown:
			handleKey(e);
			if( bg.visible ) e.propagate = false;
		default:
		}
	}

	function showHelp( ?command : String ) {
		var all;
		if( command == null ) {
			all = Lambda.array( { iterator : function() return commands.keys() } );
			all.sort(Reflect.compare);
			all.remove("help");
			all.push("help");
		} else {
			if( aliases.exists(command) ) command = aliases.get(command);
			if( !commands.exists(command) )
				throw 'Command not found "$command"';
			all = [command];
		}
		for( cmdName in all ) {
			var c = commands.get(cmdName);
			var str = "/" + cmdName;
			for( a in aliases.keys() )
				if( aliases.get(a) == cmdName )
					str += "|" + a;
			for( a in c.args ) {
				var astr = a.name;
				switch( a.t ) {
				case AInt, AFloat:
					astr += ":"+a.t.getName().substr(1);
				case AString:
					// nothing
				case AEnum(values):
					astr += "=" + values.join("|");
				case ABool:
					astr += "=0|1";
				}
				str += " " + (a.opt?"["+astr+"]":astr);
			}
			if( c.help != "" )
				str += " : " + c.help;
			log(str);
		}
	}

	public function isActive() {
		return bg.visible;
	}

	function set_cursorPos(v:Int) {
		if( v > tf.text.length ) v = tf.text.length;
		cursor.x = tf.calcTextWidth(tf.text.substr(0, v));
		return cursorPos = v;
	}

	function handleKey( e : hxd.Event ) {
		if( e.charCode == shortKeyChar && !bg.visible ) {
			bg.visible = true;
			logIndex = -1;
		}
		if( !bg.visible )
			return;
		switch( e.keyCode ) {
		case Key.LEFT:
			if( cursorPos > 0 )
				cursorPos--;
		case Key.RIGHT:
			if( cursorPos < tf.text.length )
				cursorPos++;
		case Key.HOME:
			cursorPos = 0;
		case Key.END:
			cursorPos = tf.text.length;
		case Key.DELETE:
			tf.text = tf.text.substr(0, cursorPos) + tf.text.substr(cursorPos + 1);
			return;
		case Key.BACKSPACE:
			if( cursorPos > 0 ) {
				tf.text = tf.text.substr(0, cursorPos - 1) + tf.text.substr(cursorPos);
				cursorPos--;
			}
			return;
		case Key.ENTER:
			var cmd = tf.text;
			tf.text = "";
			cursorPos = 0;
			handleCommand(cmd);
			if( !logTxt.visible ) bg.visible = false;
			return;
		case Key.ESCAPE:
			hide();
			return;
		case Key.UP:
			if(logs.length == 0 || logIndex == 0) return;
			if(logIndex == -1) {
				curCmd = tf.text;
				logIndex = logs.length - 1;
			}
			else logIndex--;
			tf.text = logs[logIndex];
			cursorPos = tf.text.length;
		case Key.DOWN:
			if(tf.text == curCmd) return;
			if(logIndex == logs.length - 1) {
				tf.text = curCmd;
				cursorPos = tf.text.length;
				logIndex = -1;
				return;
			}
			logIndex++;
			tf.text = logs[logIndex];
			cursorPos = tf.text.length;
		}
		if( e.charCode != 0 ) {
			tf.text = curCmd = tf.text.substr(0, cursorPos) + String.fromCharCode(e.charCode) + tf.text.substr(cursorPos);
			cursorPos++;
		}
	}

	function hide() {
		bg.visible = false;
		tf.text = "";
		cursorPos = 0;
	}

	function handleCommand( command : String ) {
		command = StringTools.trim(command);
		if( command.charCodeAt(0) == "/".code ) command = command.substr(1);
		if( command == "" ) {
			hide();
			return;
		}
		logs.push(command);
		logIndex = -1;

		var args = ~/[ \t]+/g.split(command);
		var cmdName = args[0];
		if( aliases.exists(cmdName) ) cmdName = aliases.get(cmdName);
		var cmd = commands.get(cmdName);
		var errorColor = 0xC00000;
		if( cmd == null ) {
			log('Unknown command "${cmdName}"',errorColor);
			return;
		}
		var vargs = new Array<Dynamic>();
		for( i in 0...cmd.args.length ) {
			var a = cmd.args[i];
			var v = args[i + 1];
			if( v == null ) {
				if( a.opt ) {
					vargs.push(null);
					continue;
				}
				log('Missing argument ${a.name}',errorColor);
				return;
			}
			switch( a.t ) {
			case AInt:
				var i = Std.parseInt(v);
				if( i == null ) {
					log('$v should be Int for argument ${a.name}',errorColor);
					return;
				}
				vargs.push(i);
			case AFloat:
				var f = Std.parseFloat(v);
				if( Math.isNaN(f) ) {
					log('$v should be Float for argument ${a.name}',errorColor);
					return;
				}
				vargs.push(f);
			case ABool:
				switch( v ) {
				case "true", "1": vargs.push(true);
				case "false", "0": vargs.push(false);
				default:
					log('$v should be Bool for argument ${a.name}',errorColor);
					return;
				}
			case AString:
				// if we take a single string, let's pass the whole args (allows spaces)
				vargs.push(cmd.args.length == 1 ? StringTools.trim(command.substr(args[0].length)) : v);
			case AEnum(values):
				var found = false;
				for( v2 in values )
					if( v == v2 ) {
						found = true;
						vargs.push(v2);
					}
				if( !found ) {
					log('$v should be [${values.join("|")}] for argument ${a.name}', errorColor);
					return;
				}
			}
		}
		try {
			Reflect.callMethod(null, cmd.callb, vargs);
		} catch( e : String ) {
			log('ERROR $e', errorColor);
		}
	}

	public function log( text : String, ?color ) {
		if( color == null ) color = tf.textColor;
		var oldH = logTxt.textHeight;
		logTxt.text += '<font color="#${StringTools.hex(color&0xFFFFFF,6)}">${StringTools.htmlEscape(text)}</font><br/>';
		if( logDY != 0 ) logDY += logTxt.textHeight - oldH;
		logTxt.alpha = 1;
		logTxt.visible = true;
		lastLogTime = haxe.Timer.stamp();
	}

	override function sync(ctx:h2d.RenderContext) {
		var scene = ctx.scene;
		if( scene != null ) {
			x = 0;
			y = scene.height - height;
			width = scene.width;
			bg.tile.scaleToSize(width, height);
		}
		var log = logTxt;
		if( log.visible ) {
			log.y = bg.y - log.textHeight + logDY;
			var dt = haxe.Timer.stamp() - lastLogTime;
			if( dt > HIDE_LOG_TIMEOUT && !bg.visible ) {
				log.alpha -= ctx.elapsedTime * 4;
				if( log.alpha <= 0 )
					log.visible = false;
			}
		}
		super.sync(ctx);
	}

}