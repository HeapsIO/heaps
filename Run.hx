import haxe.io.Bytes;
import sys.io.File;
import haxe.Json;
import sys.io.Process;
import sys.FileSystem;
import haxe.io.Path;
using StringTools;

class Run {

	public static inline var CMD_PAD:Int = 10;

	static inline var ESC = String.fromCharCode(27) + "[";
	public static inline var COL_YELLOW = ESC + "33m";
	public static inline var COL_YELLOW2 = ESC + "93m";
	public static inline var COL_DEF = COL_RESET;//ESC + "39m";
	public static inline var COL_GRAY = ESC + "37m";
	public static inline var COL_RED = ESC + "91m";
	public static inline var COL_RESET = ESC + "0m";
	inline static function setColor(col:Int) {
		Sys.print(ESC + col + "m");
	}

	public static var verboseMode:Bool;
	public static var dryRun:Bool;
	public static var autoAnswer:Int = 0;
	static var commands:Array<Command> = [
		{ name: "help", shorthand: null, descr: "Show this text", callback: showHelp, man: null },
		{ name: "setup", shorthand: null, descr: "Provide guided setup for extra tooling that may be requried for Heaps", callback: setupTools, man: null },
		{ name: "init", shorthand: null, descr: "Initialize Heaps project at provided directory path", callback: initProject, man: "
 &YUsage: &0heaps init <directory> [options]

  New project directory should be empty.

 &YApplicable flags: &0
 
&{--dry-run}
&{--verbose}
" },
	];
	static var switches:Array<Command> = [
			{ name: "--verbose", shorthand: "-v", descr: "Enable verbose mode", callback: enableVerbose, man: null },
			{ name: "--dry-run", shorthand: null, descr: "Perform a dry run of the command", callback: enableDryRun, man: null },
			{ name: "--yes", shorthand: "-y", descr: "Auto-answer yes to binary questions", callback: autoYes, man: null },
			{ name: "--no", shorthand: "-n", descr: "Auto-answer no to binary questions", callback: autoNo, man: null },
	];
	static var allCommands:Array<Command> = commands.concat(switches);

	static var heapsDir:String;
	static var cwd:String;

	static function main() {
		var args = Sys.args();
		cwd = args.pop();
		heapsDir = Path.directory(Sys.programPath());
		if (args.length == 0) {
			showHelp(args, 0);
			return;
		}
		if (args[0] != "help") {
			for (cmd in switches) {
				tryToRun(cmd, args);
			}
		}
		var command = args.shift().toLowerCase();
		for (cmd in commands) {
			if (cmd.name == command || cmd.shorthand == command) {
				cmd.callback(args, 0);
			}
		}
		
	}

	static function setupTools(args:Array<String>, pos:Int):Bool {
		var binDir = Path.join([heapsDir, "tools/bin"]);
		// Hashlink
		var path = Sys.getEnv("PATH").split(";");
		var windows = Sys.systemName() == "Windows";
		var exe = windows ? ".exe" : "";

		var foundHL:String = null;
		for (dir in path) {
			if (FileSystem.exists(Path.join([dir, "hl" + exe]))) {
				foundHL = dir;
				break;
			}
		}

		if (foundHL == null) {
			if (ask("Could not locate Hashlink in PATH: Would you like to install it?", true)) {
				Sys.println("Due to reasons described below - automation of installation is not possible.");
				Sys.println("Install latest release at https://github.com/HaxeFoundation/hashlink/releases");
			} else {
				Sys.println("Hashlink is a primary Heaps target, consider installing it, or adding it to PATH");
			}
		} else {
			verbose("Found hashlink at " + foundHL);
		}

		// Tools
		if (!FileSystem.exists(binDir)) {
			verbose("Creating tools/bin directory");
			if (!dryRun) FileSystem.createDirectory(binDir);
		}
		var foundTools = false;
		var osBin = windows ? binDir.toLowerCase() : binDir;
		for (dir in path) {
			dir = Path.removeTrailingSlashes(Path.normalize(dir));
			if ((windows ? dir.toLowerCase() : dir) == osBin) {
				foundTools = true;
				break;
			}
		}
		if (!foundTools) {
			if (ask("&YWarning: &0Could not find tools/bin in PATH! Would you like to add it? ", true)) {
				verbose("Adding tools/bin to PATH");
				if (!dryRun) {
					// TODO
					Sys.println("TODO: Actually add it to path");
				}
			} else {
				verbose("Note that tools won't be available to Heaps unless tools/bin folder are in the PATH.");
			}
		}
		var haxeVer = runProcess("haxe.exe", ["--version"]).split(".");
		if (Std.parseInt(haxeVer[0] + haxeVer[1]) < 41 ) fatal("Heaps Tools require Haxe 4.1.0 or higher!");

		var versions:Map<String, String> = [];
		var versionPath = Path.join([binDir, ".versions"]);
		if (FileSystem.exists(versionPath)) versions = haxe.Unserializer.run(File.getContent(versionPath));

		inline function outdatedMessage(name:String, dispname:String, json:GithubJson) {
			if (!versions.exists(name)) return dispname + " is not installed. Would you like to install it?";
			else return dispname + " is outdated. Would you like to upgrade from " + versions[name] + " to " + json.name + "?";
		}
		for (tool in [
				{ name: "Heaps tools pack", github: "HeapsIO/heaps-tools", windowsOnly: true, windowsName: "heaps_tools_windows.zip", unixName: "" },
				{ name: "Fontgen tool", github: "Yanrishatum/fontgen", windowsOnly: true, windowsName: "fontgen.zip", unixName: "" }]) {
			if (tool.windowsOnly && !windows) {
				verbose("Skipping " + tool.name + ": Windows only tool");
				continue;
			}
			verbose("Fetching latest release info from &U" + tool.github + "&0");
			var json:GithubJson = Json.parse(httpGetS("https://api.github.com/repos/" + tool.github + "/releases/latest"));
			// versions.exists(name) && versions[name] == json.name
			if (!versions.exists(tool.github) || versions[tool.github] != json.name) {
				if (ask(outdatedMessage("Yanrishatum/fontgen", "Fontgen tool", json), true)) {
					if (dryRun) {
						Sys.println("Dry run: New version would not be loaded");
					} else {
						var name = windows ? tool.windowsName : tool.unixName;
						for (asset in json.assets) {
							if (asset.name == name) {
								Sys.println("Loading file: " + name);
								var zipBytes = httpGet(asset.browser_download_url);
								var zip = new haxe.zip.Reader(new haxe.io.BytesInput(zipBytes)).read();
								for (file in zip) {
									verbose("Saving file: " + file.fileName);
									if (!dryRun) File.saveBytes(file.fileName, file.data);
								}
							}
						}
					}
					versions[tool.github] = json.name;
					Sys.println("Updated " + tool.name + " to " + json.name);
				}
			} else {
				verbose(tool.name + " is up-to-date");
			}
		}
		
		if (!dryRun) File.saveContent(versionPath, haxe.Serializer.run(versions));
		return true;
	}

	static function initProject(args:Array<String>, pos:Int):Bool {
		if (args.length == 0) {
			Sys.println(format("&RError: &0Project path was not provided"));
			return false;
		}
		// TODO: Build name
		var name = "game";// args.shift().toLowerCase();
		var ctx = { 
			name: name
		};
		var projectTemplate = Path.join([heapsDir, "tools/project"]);
		var projectPath = Path.join([cwd, args.shift()]);
		if (!dryRun && !FileSystem.exists(projectPath)) FileSystem.createDirectory(projectPath);
		if (FileSystem.exists(projectPath) && FileSystem.readDirectory(projectPath).length != 0) {
			Sys.println(format("&RError: &0Project directory is not empty!"));
			return false;
		}
		if (!dryRun) Sys.setCwd(projectPath);
		function copyRec(src:String, dist:String) {
			for (f in FileSystem.readDirectory(src)) {
				var path = Path.join([src, f]);
				var dstPath = Path.join([dist, f]);
				if (FileSystem.isDirectory(path)) {
					copyRec(path, dstPath);
				} else {
					if (f == ".keep") continue;
					if (verboseMode) Sys.println("Creating file " + dstPath);
					if (!dryRun) File.saveContent(dstPath, new haxe.Template(File.getContent(path)).execute(ctx));
				}
			}
		}
		
		copyRec(projectTemplate, ".");
		return true;
	}

	static function showHelp(args:Array<String>, pos:Int):Bool {
		/*
		 * /\\\   /\\\                      /\\\
		 * \/\\\  \/\\\                     \/\\\\
		 *  \/\\\  \/\\\     /\\\\\\\\      /\\\\\\\      /\\\\\\\\\\     /\\\\\\\
		 *   \/\\\\\\\\\\   /\\\/////\\\    \/\\\\\\\\    \/\\\/////\\\  /\\\/////
		 *    \/\\\////\\\  /\\\\\\\\\\\    /\\\\///\\\\   \/\\\   \/\\\ /\\\\\\\\
		 *     \/\\\  \/\\\ \//\\///////    \/\\\\ \/\\\\\  \/\\\\\\\\\/ \///////\\\
		 *      \/\\\  \/\\\  \//\\\\\\\\\\ /\\\\\\\\\\\\\\\ \/\\\/////   /\\\\\\\\/
		 *       \///   \///    \////////// \///////////////  \/\\\       \////////
		 *                                                     \///
		*/
		if (args.length == 0) {
			Sys.println(COL_YELLOW + " /\\\\\\   /\\\\\\                      /\\\\\\
 \\/\\\\\\  \\/\\\\\\                     \\/\\\\\\\\
  \\/\\\\\\  \\/\\\\\\     /\\\\\\\\\\\\\\\\      /\\\\\\\\\\\\\\      /\\\\\\\\\\\\\\\\\\\\     /\\\\\\\\\\\\\\
   \\/\\\\\\\\\\\\\\\\\\\\   /\\\\\\/////\\\\\\    \\/\\\\\\\\\\\\\\\\    \\/\\\\\\/////\\\\\\  /\\\\\\/////
    \\/\\\\\\////\\\\\\  /\\\\\\\\\\\\\\\\\\\\\\    /\\\\\\\\///\\\\\\\\   \\/\\\\\\   \\/\\\\\\ /\\\\\\\\\\\\\\\\
     \\/\\\\\\  \\/\\\\\\ \\//\\\\///////    \\/\\\\\\\\ \\/\\\\\\\\\\  \\/\\\\\\\\\\\\\\\\\\/ \\///////\\\\\\
      \\/\\\\\\  \\/\\\\\\  \\//\\\\\\\\\\\\\\\\\\\\ /\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ \\/\\\\\\/////   /\\\\\\\\\\\\\\\\/
       \\///   \\///    \\////////// \\///////////////  \\/\\\\\\       \\////////
                                                     \\///\n");
			var version : String;
			Sys.print(COL_DEF + "Heaps Command-Line Utility");
			if (FileSystem.exists(Path.join([heapsDir, ".git"]))) {
				var proc = new Process("git", ["rev-parse", "--abbrev-ref", "HEAD"]);
				proc.exitCode();
				version = proc.stdout.readUntil("\n".code).toString();
				proc = new Process("git", ["rev-parse", "HEAD"]);
				proc.exitCode();
				version += "-" + proc.stdout.readString(7);
			} else {
				version = Json.parse(File.getContent(Path.join([heapsDir, "haxelib.jcon"]))).version;
			}
			Sys.println(" (" + version + ")\n");
			Sys.println(COL_YELLOW + " Usage: " + COL_DEF + "heaps <command>" + COL_GRAY + " [arguments]\n");
			Sys.println(COL_YELLOW + " Commands:\n" + COL_RESET);
			for (cmd in commands) {
				Sys.println(cmd.toHelp());
			}
			Sys.println(COL_YELLOW + "\n Common switches:\n" + COL_RESET);
			for (cmd in switches) {
				Sys.println(cmd.toHelp());
			}
			Sys.println(COL_DEF + "\nFor additional help, run " + COL_YELLOW2 + "heaps help <command>" + COL_RESET);
		} else {
			var name = args.shift().toLowerCase();
			for (cmd in allCommands) {
				if (cmd.name == name || cmd.shorthand == name) {
					Sys.println(cmd.toMan());
				}
			}
		}

		return true;
	}

	static function enableVerbose(args:Array<String>, pos:Int):Bool {
		verboseMode = true;
		return true;
	}

	static function enableDryRun(args:Array<String>, pos:Int):Bool {
		dryRun = true;
		verbose("Dry run mode on");
		return true;
	}

	static function autoYes(args:Array<String>, pos:Int):Bool {
		autoAnswer = 1;
		return true;
	}
	static function autoNo(args:Array<String>, pos:Int):Bool {
		autoAnswer = -1;
		return true;
	}

	public static inline function warn(str:String) {
		Sys.println(format("&YWarning: &0" + str));
	}
	public static inline function fatal(str:String) {
		Sys.println(format("&RFatal: &0" + str));
		Sys.exit(1);
	}
	public static inline function verbose(str:String) {
		if (verboseMode) Sys.println(format(str));
	}
	public static inline function format(str:String) {
		var idx = str.indexOf("&{");
		while (idx != -1) {
			var next = str.indexOf("}", idx + 2);
			var name = str.substring(idx+2, next);
			for (cmd in allCommands) {
				if (cmd.name == name) {
					str = str.replace("&{" + name + "}", cmd.toHelp());
					break;
				}
			}
			idx = str.indexOf("&{", idx + name.length + 3);
		}
		return str.replace("&0", COL_RESET).replace("&G", COL_GRAY).replace("&Y", COL_YELLOW).replace("&U", COL_YELLOW2).replace("&R", COL_RED);
	}
	public static inline function ask(str:String, defYes:Bool):Bool {
		Sys.print(format(str + (defYes ? "[&YY&0n] " : "[y&YN&0] ")));
		var isYes = defYes;
		switch (autoAnswer) {
			case 1: isYes = true;
			case 2: isYes = false;
			default:
				var char = Sys.getChar(false);
				if (char == 'y'.code || char == 'Y'.code) isYes = true;
				else if (char == 'n'.code || char == 'N'.code) isYes = false;
		}
		Sys.println(isYes ? "Y" : "N");
		return isYes;
	}


	static function httpGet(url:String) {
		var req = new sys.Http(url);
		var data:Bytes = null;
		req.onBytes = (b) -> data = b;
		req.onError = (err) -> fatal("Http error: " + err + "\nURL: " + url);
		req.setHeader("User-Agent", "curl/7.27.0"); // workaround for haxe 4.1.1
		req.request(false);
		return data;
	}
	static function httpGetS(url:String) {
		var req = new sys.Http(url);
		var data:String = null;
		req.onData = (b) -> data = b;
		req.onError = (err) -> fatal("Http error: " + err + "\nURL: " + url);
		req.setHeader("User-Agent", ""); // workaround for haxe 4.1.1
		req.request(false);
		return data;
	}
	static function runProcess( cmd:String, args:Array<String> ) : String {
		var proc = new Process(cmd, args);
		proc.exitCode();
		return proc.stdout.readAll().toString();
	}

	static function tryToRun( cmd : Command, args : Array<String> ) {
		var i = 0;
		while (i < args.length) {
			var arg = args[i].toLowerCase();
			if (arg == cmd.name || arg == cmd.shorthand) {
				if (cmd.callback(args, i+1)) {
					args.splice(i, 1);
					return true;
				}
			}
			i++;
		}
		return false;
	}

}

typedef GithubJson = {

	var name:String;
	var assets:Array<{ name:String, browser_download_url:String }>;

}

@:structInit
class Command {
	public var name:String;
	public var shorthand:String;
	public var descr:String;
	public var man:String;
	public var callback:(args:Array<String>, pos:Int)->Bool;

	public function toHelp():String {
		var res = name;
		if (shorthand == null) {
			res = name.rpad(" ", Run.CMD_PAD);
		} else if (res.length + shorthand.length + 3 > Run.CMD_PAD) {
			res += "\n  " + shorthand.lpad(" ", Run.CMD_PAD);
		} else {
			res += " / " + shorthand.rpad(" ", Run.CMD_PAD - 3 - res.length);
		}
		return "  " + Run.COL_RESET + res + Run.COL_YELLOW2 + " -- " + descr;
	}

	public function toMan():String {
		if ( man == null ) {
			return Run.COL_DEF + descr + "\n\nNo extended documentation for this command available" + Run.COL_RESET;
		}
		return Run.COL_GRAY + descr + "\n\n" + Run.COL_RESET + Run.format(man) + Run.COL_RESET;
	}

}