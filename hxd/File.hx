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

	#if (flash && air3)

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
		function onSelectCallb(_) {
			f.removeEventListener(flash.events.Event.SELECT, onSelectCallb);
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
		}
		f.addEventListener(flash.events.Event.SELECT, onSelectCallb);
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
		#elseif (hl && (haxe_ver >= 4))
			var old = hxd.System.allowTimeout;
			hxd.System.allowTimeout = false;
			var path = hl.UI.loadFile({
				fileName : options.defaultPath,
				filters : options.fileTypes == null ? null : [for( e in options.fileTypes ) { name : e.name, exts : e.extensions }],
				title : options.title,
			});
			hxd.System.allowTimeout = old;
			if( path == null ) return;
			if( options.relativePath ) {
				var cwd = Sys.getCwd();
				if( StringTools.startsWith(path, cwd) )
					path = path.substr(cwd.length);
			}
			var b : BrowseSelect = {
				fileName : path,
				load : function(onReady) {
					var data = sys.io.File.getBytes(path);
					haxe.Timer.delay(function() onReady(data),0);
				},
			};
			onSelect(b);
		#elseif js
			var input : js.html.InputElement = cast js.Browser.document.getElementById("heapsBrowserInput");
			if( input==null ) {
				input = cast js.Browser.document.createElement("input");
				input.setAttribute("id","heapsBrowserInput");
				js.Browser.document.body.appendChild(input);
			}
			input.setAttribute("type","file");
			input.style.display = "none";
			if( options.fileTypes!=null ) {
				var extensions = [];
				for(ft in options.fileTypes)
					for(e in ft.extensions)
						extensions.push("."+e);
				input.setAttribute("accept",extensions.join(","));
			}
			input.onclick = function(e) {
				input.value = null;
			}
			input.onchange = function(e) {
				var file : js.html.File = e.target.files[0];
				var b : BrowseSelect = {
					fileName: file.name,
					load : function(onReady) {
						var reader = new js.html.FileReader();
						reader.readAsDataURL(file);
						reader.onload = function(re) {
							var raw : String = re.target.result;
							var header = raw.substr(0, raw.indexOf(","));
							var data = raw.substr(raw.indexOf(",")+1);

							if( raw.indexOf(";")>=0 ) {
								// Encoding is specified
								onReady( switch( header.split(";")[1] ) {
									case "base64" : haxe.crypto.Base64.decode(data);
									case _ : throw "Unsupported encoding: "+header.split(";")[1];
								});
							}
							else {
								// Plain text
								onReady( haxe.io.Bytes.ofString(data) );
							}
						}
					}
				}
				onSelect(b);
				input.remove();
			}
			input.click();
		#else
			throw "Not supported";
		#end
	}

	#if (flash && air3)
	static function saveAsAir( dataContent : haxe.io.Bytes, options : BrowseOptions ) {
		var f = flash.filesystem.File.applicationDirectory;
		if( options.defaultPath != null )
			try f = f.resolvePath(options.defaultPath) catch( e : Dynamic ) {}
		var basePath = f.clone();
		function onSelect(_) {
			f.removeEventListener(flash.events.Event.SELECT, onSelect);
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
		};
		f.addEventListener(flash.events.Event.SELECT, onSelect);
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
		#elseif (hl && (haxe_ver >= 4))
			var old = hxd.System.allowTimeout;
			hxd.System.allowTimeout = false;
			var path = hl.UI.saveFile({
				fileName : options.defaultPath,
				title : options.title,
				filters : options.fileTypes == null ? null : [for( e in options.fileTypes ) { name : e.name, exts : e.extensions }],
			});
			hxd.System.allowTimeout = old;
			if( path == null )
				return;
			if( options.relativePath ) {
				var cwd = Sys.getCwd();
				if( StringTools.startsWith(path, cwd) )
					path = path.substr(cwd.length);
			}
			if( options.saveFileName != null )
				options.saveFileName(path);
			sys.io.File.saveBytes(path, dataContent);
		#else
			throw "Not supported";
		#end
	}

	public static function exists( path : String ) : Bool {
		#if (flash && air3)
		return getRelPath(path).exists;
		#elseif (sys || nodejs)
		return sys.FileSystem.exists(path);
		#else
		throw "Not supported";
		return false;
		#end
	}

	public static function delete( path : String ) {
		#if (flash && air3)
		try {
			getRelPath(path).deleteFile();
		} catch( e : Dynamic ) {
		}
		#elseif (sys || nodejs)
		try sys.FileSystem.deleteFile(path) catch( e : Dynamic ) { };
		#else
		throw "Not supported";
		#end
	}

	public static function listDirectory( path : String ) {
		#if (flash && air3)
		try {
			return [for( f in getRelPath(path).getDirectoryListing() ) f.name];
		} catch( e : Dynamic ) {
			return [];
		}
		#elseif (sys || nodejs)
		return sys.FileSystem.readDirectory(path);
		#else
		throw "Not supported";
		#end
	}

	public static function getBytes( path : String ) : haxe.io.Bytes {
		#if (flash && air3)
		var file = getRelPath(path);
		if( !file.exists ) throw "File not found " + path;
		var fs = new flash.filesystem.FileStream();
		fs.open(file, flash.filesystem.FileMode.READ);
		var bytes = haxe.io.Bytes.alloc(fs.bytesAvailable);
		fs.readBytes(bytes.getData());
		fs.close();
		return bytes;
		#elseif (sys || nodejs)
		return sys.io.File.getBytes(path);
		#else
		throw "Not supported";
		return null;
		#end
	}

	#if (flash && air3)
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
		#elseif (sys || nodejs)
		sys.io.File.saveBytes(path, data);
		#else
		throw "Not supported";
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
		#elseif sys
		var content = try sys.io.File.getBytes(path) catch( e : Dynamic ) { if( onError != null ) onError("" + e); return; };
		onLoad(content);
		#else
		throw "Not supported";
		#end
	}

	public static function createDirectory( path : String ) {
		#if (flash && air3)
		getRelPath(path).createDirectory();
		#elseif (sys || nodejs)
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