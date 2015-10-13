package hxd;

typedef BrowseOptions = {
	/** The default path in which we browse the file, if supported **/
	?defaultPath : String,
	/** The dialog title, if supported **/
	?title : String,
	/** If supported, will return a relative full path instead of an absolute one **/
	?relativePath : Bool,
	/** the file types that we are allowed to select **/
	?fileTypes : Array<{ name : String, extensions : Array<String> }>,
	/** this will be called when saving a file with the target path, if supported **/
	?saveFileName : String -> Void,
};

typedef BrowseSelect = {
	/** might contain only the file name without the full path depending on sandbox restrictions **/
	var fileName : String;
	/** allow to load the selected file content **/
	function load( onReady : haxe.io.Bytes -> Void ) : Void;
}

class File {

	#if flash
	static function isAir() {
		return flash.system.Capabilities.playerType == "Desktop";
	}
	#end

	#if air3

	static function getRelPath( path : String ) {
		return try new flash.filesystem.File(path) catch( e : Dynamic ) new flash.filesystem.File(flash.filesystem.File.applicationDirectory.nativePath + "/" + path);
	}

	static var lastBrowseDir : Dynamic;
	static function browseAir( onSelect : BrowseSelect -> Void, options : BrowseOptions, filters ) {
		var f : flash.filesystem.File = lastBrowseDir;
		if( f == null )
			f = flash.filesystem.File.applicationDirectory;
		if( options.defaultPath != null )
			try f = flash.filesystem.File.applicationDirectory.resolvePath(options.defaultPath) catch( e : Dynamic ) {}
		lastBrowseDir = f;
		var basePath = f.clone();
		f.addEventListener(flash.events.Event.SELECT, function(_) {
			var path = f.nativePath;
			if( options.relativePath ) {
				if( !basePath.isDirectory ) basePath = basePath.parent;
				var relPath = basePath.getRelativePath(f, true);
				if( relPath != null )
					path = relPath;
			}
			var sel : BrowseSelect = {
				fileName : path,
				load : function(onReady) {
					haxe.Timer.delay(function() {
						var fs = new flash.filesystem.FileStream();
						fs.open(f, flash.filesystem.FileMode.READ);
						var bytes = haxe.io.Bytes.alloc(fs.bytesAvailable);
						fs.readBytes(bytes.getData());
						fs.close();
						onReady(bytes);
					},1);
				},
			};
			onSelect(sel);
		});
		f.browseForOpen(options.title == null ? "" : options.title, filters);
	}
	#end

	public static function browse( onSelect : BrowseSelect -> Void, ?options : BrowseOptions ) {
		if( options == null ) options = {};
		#if flash
			var filters = options.fileTypes == null ? null : [for( o in options.fileTypes ) new flash.net.FileFilter(o.name,[for( e in o.extensions ) "*."+e].join(";"))];
			#if air3
			if( isAir() ) {
				browseAir(onSelect, options,filters);
				return;
			}
			#end
			var f = new flash.net.FileReference();
			f.addEventListener(flash.events.Event.SELECT, function(_) {
				var sel : BrowseSelect = {
					fileName : f.name,
					load : function(onReady) {
						f.addEventListener(flash.events.Event.COMPLETE, function(_) {
							onReady(haxe.io.Bytes.ofData(f.data));
						});
						f.load();
					},
				};
				onSelect(sel);
			});
			f.browse(filters);
		#else
			throw "Not supported";
		#end
	}

	#if air3
	static function saveAsAir( dataContent : haxe.io.Bytes, options : BrowseOptions ) {
		var f = flash.filesystem.File.applicationDirectory;
		if( options.defaultPath != null )
			try f = f.resolvePath(options.defaultPath) catch( e : Dynamic ) {}
		var basePath = f.clone();
		f.addEventListener(flash.events.Event.SELECT, function(_) {
			// save data
			var o = new flash.filesystem.FileStream();
			o.open(f, flash.filesystem.FileMode.WRITE);
			o.writeBytes(dataContent.getData());
			o.close();
			if( options.saveFileName != null ) {
				var path = f.nativePath;
				if( options.relativePath ) {
					if( !basePath.isDirectory ) basePath = basePath.parent;
					var relPath = basePath.getRelativePath(f, true);
					if( relPath != null )
						path = relPath;
				}
				options.saveFileName(path);
			}
		});
		f.browseForSave(options.title == null ? "" : options.title);
	}
	#end

	public static function saveAs( dataContent : haxe.io.Bytes, ?options : BrowseOptions ) {
		if( options == null ) options = { };
		#if flash
			#if air3
			if( isAir() ) {
				saveAsAir(dataContent, options);
				return;
			}
			#end
			var f = new flash.net.FileReference();
			f.addEventListener(flash.events.Event.SELECT, function(_) {
			});
			var defaultFile = options.defaultPath;
			f.save(dataContent.getData(), defaultFile);
		#else
			throw "Not supported";
		#end
	}

	public static function exists( path : String ) : Bool {
		#if air3
		return getRelPath(path).exists;
		#elseif sys
		return sys.FileSystem.exists(path);
		#else
		throw "Not supported";
		return false;
		#end
	}

	public static function delete( path : String ) {
		#if air3
		try {
			getRelPath(path).deleteFile();
		} catch( e : Dynamic ) {
		}
		#elseif sys
		try sys.FileSystem.deleteFile(path) catch( e : Dynamic ) { };
		#else
		throw "Not supported";
		#end
	}

	public static function getBytes( path : String ) : haxe.io.Bytes {
		#if air3
		var file = getRelPath(path);
		if( !file.exists ) throw "File not found " + path;
		var fs = new flash.filesystem.FileStream();
		fs.open(file, flash.filesystem.FileMode.READ);
		var bytes = haxe.io.Bytes.alloc(fs.bytesAvailable);
		fs.readBytes(bytes.getData());
		fs.close();
		return bytes;
		#elseif sys
		return sys.io.File.getBytes(path);
		#else
		throw "Not supported";
		return null;
		#end
	}

	#if air3
	static function saveBytesAir( path : String, data : haxe.io.Bytes ) {
		if( path == null ) throw "NULL path";
		var f = getRelPath(path);
		var o = new flash.filesystem.FileStream();
		o.open(f, flash.filesystem.FileMode.WRITE);
		o.writeBytes(data.getData());
		o.close();
	}
	#end

	public static function saveBytes( path : String, data : haxe.io.Bytes ) {
		#if flash
			#if air3
			if( isAir() ) {
				saveBytesAir(path, data);
				return;
			}
			#end
			saveAs(data, { defaultPath:path } );
		#elseif sys
		sys.io.File.saveBytes(path, data);
		#else
		throw "Not supported";
		#end
	}

	public static function saveBytesAt( path : String, data : haxe.io.Bytes, dataPos : Int, dataSize : Int, filePos : Int ) {
		#if air3
		if( path == null ) throw "NULL path";
		var f = new flash.filesystem.File(path);
		var o = new flash.filesystem.FileStream();
		o.open(f, flash.filesystem.FileMode.UPDATE);
		if( filePos != o.position ) o.position = filePos;
		if( dataSize > 0 ) o.writeBytes(data.getData(),dataPos,dataSize);
		o.close();
		#else
		throw "Not supported"; // requires "update" mode
		#end
	}

	public static function load( path : String, onLoad : haxe.io.Bytes -> Void, ?onError : String -> Void ) {
		if( onError == null ) onError = function(_) { };
		#if flash
		var f = new flash.net.URLLoader();
		f.dataFormat = flash.net.URLLoaderDataFormat.BINARY;
		f.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(e:flash.events.IOErrorEvent) {
			onError(Std.string(e));
		});
		f.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, function(e:flash.events.SecurityErrorEvent) {
			onError(Std.string(e));
		});
		f.addEventListener(flash.events.Event.COMPLETE, function(_) {
			onLoad(haxe.io.Bytes.ofData(f.data));
		});
		f.load(new flash.net.URLRequest(path));
		#else
		throw "Not supported";
		#end
	}

	public static function createDirectory( path : String ) {
		#if air3
		getRelPath(path).createDirectory();
		#elseif sys
		sys.FileSystem.createDirectory(path);
		#else
		throw "Not supported";
		#end
	}

	public static function applicationPath() : String {
		#if flash
		var path = flash.Lib.current.loaderInfo.loaderURL.substr(7); // file://
		if( path.charCodeAt(2) == "|".code ) // driver letter on windows
			path = path.charAt(1) + ":" + path.substr(3);
		var path = path.split("/");
		path[path.length - 1] = "";
		return path.join("/");
		#else
		throw "Not supported";
		return null;
		#end
	}

}