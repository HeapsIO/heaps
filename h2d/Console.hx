package h2d;

import hxd.Key;

/**
	The console argument type.
**/
enum ConsoleArg {
	/**
		An integer parameter.
	**/
	AInt;
	/**
		A floating-point parameter.
	**/
	AFloat;
	/**
		A text string parameter.
	**/
	AString;
	/**
		A boolean parameter. Can be `true`, `false`, `1` or `0`.
	**/
	ABool;
	/**
		A text string parameter with limitation to only accept the specified list values.
	**/
	AEnum( values : Array<String> );
}

/**
	A descriptor for an argument of a console command.
**/
typedef ConsoleArgDesc = {
	/**
		A human-readable argument name.
	**/
	name : String,
	/**
		The type of the argument.
	**/
	t : ConsoleArg,
	/**
		When set, argument is considered optional and command callback will receive `null` if argument was omitted.
		Inserting optional arguments between non-optional arguments leads to an undefined behavior.
	**/
	?opt : Bool,
}

/**
	A simple debug console integration.

	Console can be focused manually through `Console.show` and `Console.hide` methods
	as well as by pressing the key defined by `Console.shortKeyChar`.

	It's possible to log messages to console via `Console.log` method.

	By default comes with 2 commands: `help` and `cls`, which print help message
	describing all commands and clears the console logs respectively.

	To add custom commands, use `Console.add` and `Console.addCommand` methods.
**/
class Console #if !macro extends h2d.Object #end {

	#if !macro
	/**
		The timeout in seconds before log will automatically hide after the last message.
	**/
	public static var HIDE_LOG_TIMEOUT = 3.;

	var width : Int;
	var height : Int;
	var bg : h2d.Bitmap;
	var tf : h2d.TextInput;
	var hintTxt: h2d.Text;
	var logTxt : h2d.HtmlText;
	var lastLogTime : Float;
	var commands : Map < String, { help : String, args : Array<ConsoleArgDesc>, callb : Dynamic } > ;
	var aliases : Map<String,String>;
	var logDY : Float = 0;
	var logs : Array<String>;
	var logIndex:Int;
	var curCmd:String;

	/**
		The text character which should be pressed in order to automatically show console input.
	**/
	public var shortKeyChar : Int = "/".code;
	/**
		Provide an auto-complete on Enter/Tab key and command completion hints.
	**/
	public var autoComplete : Bool = true;

	/**
		Create a new Console instance using the provided font and parent.
		@param font The font to use for console text input and log.
		@param parent An optional parent `h2d.Object` instance to which Console adds itself if set.
	**/
	public function new(font:h2d.Font,?parent) {
		super(parent);
		height = Math.ceil(font.lineHeight) + 2;
		logTxt = new h2d.HtmlText(font, this);
		logTxt.x = 2;
		logTxt.dropShadow = { dx : 0, dy : 1, color : 0, alpha : 0.5 };
		logTxt.visible = false;
		logs = [];
		logIndex = -1;
		bg = new h2d.Bitmap(h2d.Tile.fromColor(0,1,1,0.5), this);
		bg.visible = false;

		hintTxt = new h2d.Text(font, bg);
		hintTxt.x = 2;
		hintTxt.y = 1;
		hintTxt.textColor = 0xFFFFFFFF;
		hintTxt.alpha = 0.5;

		tf = new h2d.TextInput(font, bg);
		tf.onKeyDown = handleKey;
		tf.onChange = handleCmdChange;
		tf.onFocusLost = function(_) hide();
		tf.x = 2;
		tf.y = 1;
		tf.textColor = 0xFFFFFFFF;

		commands = new Map();
		aliases = new Map();
		addCommand("help", "Show help", [ { name : "command", t : AString, opt : true } ], showHelp);
		addCommand("cls", "Clear console", [], function() {
			logs = [];
			logTxt.text = "";
		});
		addAlias("?", "help");
	}

	/**
		Add a new command to console.
		@param name Command name.
		@param help Optional command description text.
		@param args An array of command arguments.
		@param callb The callback method taking the arguments listed in `args`.
	**/
	public function addCommand( name, ?help, args : Array<ConsoleArgDesc>, callb : Dynamic ) {
		commands.set(name, { help : help == null ? "" : help, args:args, callb:callb } );
	}

	#end

	/**
		Add a new command to console. <span class="label">Macro method</span>

		The `callb` method arguments are used to determine console argument type and names. Due to that,
		only the following callback argument types are supported: `Int`, `Float`, `String` and `Bool`.
		Another limitation is that commands added via macro do not contain description.

		For example:
		```haxe
		function addItem(id:Int, ?amount:Int) {
			var item = findItemById(id)
			if (amount == null) amount = 1;
			player.giveItem(item, amount);
			console.log('Added $amount x ${item.name} to player!');
		}
		// Macro call automatically takes addItem arguments.
		console.add("additem", addItem);
		// And is equivalent to using addCommand describing each argument manually:
		console.addCommand("additem", null, [{ name: "id", t: AInt }, { name: "amount", t: AInt, opt: true }], addItem);
		```

		@param name A String expression of the command name.
		@param callb An expression that points at the callback method.
	**/
	public macro function add( ethis, name, callb ) {
		var args = [];
		var et = haxe.macro.Context.typeExpr(callb);
		switch( haxe.macro.Context.follow(et.t) ) {
		case TFun(fargs, _):
			for( a in fargs ) {
				var t = haxe.macro.Context.followWithAbstracts(a.t);
				var tstr = haxe.macro.TypeTools.toString(t);
				var tval = switch( tstr ) {
				case "Int": AInt;
				case "Float": AFloat;
				case "String": AString;
				case "Bool": ABool;
				default: haxe.macro.Context.error("Unsupported parameter type "+tstr+" for argument "+a.name, callb.pos);
				}
				var tname = ""+tval;
				args.push(macro { name : $v{a.name}, t : h2d.Console.ConsoleArg.$tname, opt : $v{a.opt} });
			}
		default:
			haxe.macro.Context.error(haxe.macro.TypeTools.toString(et.t)+" should be a function", callb.pos);
		}
		return macro $ethis.addCommand($name,null,$a{args},$callb);
	}

	#if !macro

	/**
		Add an alias to an existing command.
		@param name Command alias.
		@param command Full command name to alias.
	**/
	public function addAlias( name, command ) {
		aliases.set(name, command);
	}

	/**
		Executes `commandLine` the same way the user would execute it.
	**/
	public function runCommand( commandLine : String ) {
		handleCommand(commandLine);
	}

	override function onAdd() {
		super.onAdd();
		@:privateAccess getScene().window.addEventTarget(onEvent);
	}

	override function onRemove() {
		@:privateAccess getScene().window.removeEventTarget(onEvent);
		super.onRemove();
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
		case ETextInput:
			if( e.charCode == shortKeyChar && !bg.visible )
				show();
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

	/**
		Checks if the Console is currently shown.
	**/
	public function isActive() {
		return bg.visible;
	}

	/**
		Hides the Console.
	**/
	public function hide() {
		bg.visible = false;
		tf.text = "";
		hintTxt.text = "";
		tf.cursorIndex = -1;
	}

	/**
		Shows and focuses the Console.
	**/
	public function show() {
		bg.visible = true;
		tf.focus();
		tf.cursorIndex = tf.text.length;
		logIndex = -1;
	}

	function getCommandSuggestion(cmd : String) : String {
		if (cmd == "") {
			return "";
		}

		var closestCommand = "";
		var commandNames = commands.keys();
		for (command in commandNames) {
			if (command.indexOf(cmd) == 0) {
				if (closestCommand == "" || closestCommand.length > command.length) {
					closestCommand = command;
				}
			}
		}

		return closestCommand;
	}

	function handleKey( e : hxd.Event ) {
		if( !bg.visible )
			return;
		switch( e.keyCode ) {
		case Key.ENTER, Key.NUMPAD_ENTER:
			var cmd = tf.text;
			tf.text = "";

			hintTxt.text = "";
			if (autoComplete) {
				var suggestion = getCommandSuggestion(cmd);
				if (suggestion != "") {
					cmd = suggestion;
				}
			}

			handleCommand(cmd);
			if( !logTxt.visible ) bg.visible = false;
			e.cancel = true;
			return;
		case Key.TAB:
			if (autoComplete) {
				if (hintTxt.text != "") {
					tf.text = hintTxt.text + " ";
					tf.cursorIndex = tf.text.length;
				}
			}
		case Key.ESCAPE:
			hide();
		case Key.UP:
			if(logs.length == 0 || logIndex == 0) return;
			if(logIndex == -1) {
				curCmd = tf.text;
				logIndex = logs.length - 1;
			}
			else logIndex--;
			tf.text = logs[logIndex];
			tf.cursorIndex = tf.text.length;
		case Key.DOWN:
			if(tf.text == curCmd) return;
			if(logIndex == logs.length - 1) {
				tf.text = curCmd == null ? "" : curCmd;
				tf.cursorIndex = tf.text.length;
				logIndex = -1;
				return;
			}
			logIndex++;
			tf.text = logs[logIndex];
			tf.cursorIndex = tf.text.length;
		}
	}

	function handleCmdChange() {
		hintTxt.visible = autoComplete;
		if (autoComplete) {
			hintTxt.text = getCommandSuggestion(tf.text);
		} else {
			hintTxt.text = "";
		}
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

		var errorColor = 0xC00000;

		var args = [];
		var c = '';
		var i = 0;

		function readString(endChar:String) {
			var string = '';

			while (i < command.length) {
				c = command.charAt(++i);
				if (c == endChar) {
					++i;
					return string;
				}
				string += c;
			}

			return null;
		}

		inline function skipSpace() {
			c = command.charAt(i);
			while (c == ' ' || c == '\t') {
				c = command.charAt(++i);
			}
			--i;
		}

		var last = '';
		while (i < command.length) {
			c = command.charAt(i);

			switch (c) {
			case ' ' | '\t':
				skipSpace();

				args.push(last);
				last = '';
			case "'" | '"':
				var string = readString(c);
				if (string == null) {
					log('Bad formated string', errorColor);
					return;
				}

				args.push(string);
				last = '';

				skipSpace();
			default:
				last += c;
			}

			++i;
		}
		args.push(last);

		var cmdName = args[0];
		if( aliases.exists(cmdName) ) cmdName = aliases.get(cmdName);
		var cmd = commands.get(cmdName);
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

	/**
		Print to the console log.
		@param text The text to show in the log message.
		@param color Optional custom text color.
	**/
	public function log( text : String, ?color ) {
		if( color == null ) color = tf.textColor;
		var oldH = logTxt.textHeight;
		logTxt.text = logTxt.text + '<font color="#${StringTools.hex(color&0xFFFFFF,6)}">${StringTools.htmlEscape(text)}</font><br/>';
		if( logDY != 0 ) logDY += logTxt.textHeight - oldH;
		logTxt.alpha = 1;
		logTxt.visible = true;
		lastLogTime = haxe.Timer.stamp();
	}

	override function sync(ctx:h2d.RenderContext) {
		var scene = ctx.scene;
		if( scene != null ) {
			x = 0;
			y = scene.height - height*scaleY;
			width = scene.width;
			tf.maxWidth = width;
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

	#end

}
