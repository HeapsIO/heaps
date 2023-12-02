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

	public static function browse( onSelect : BrowseSelect -> Void, ?options : BrowseOptions ) {
		if( options == null ) options = {};
		#if (hl && (haxe_ver >= 4))
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

	public static function saveAs( dataContent : haxe.io.Bytes, ?options : BrowseOptions ) {
		if( options == null ) options = { };
		#if (hl && (haxe_ver >= 4))
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
		#if (sys || nodejs)
		return sys.FileSystem.exists(path);
		#else
		throw "Not supported";
		return false;
		#end
	}

	public static function delete( path : String ) {
		#if (sys || nodejs)
		try sys.FileSystem.deleteFile(path) catch( e : Dynamic ) { };
		#else
		throw "Not supported";
		#end
	}

	public static function listDirectory( path : String ) {
		#if (sys || nodejs)
		return sys.FileSystem.readDirectory(path);
		#else
		throw "Not supported";
		#end
	}

	public static function getBytes( path : String ) : haxe.io.Bytes {
		#if (sys || nodejs)
		return sys.io.File.getBytes(path);
		#else
		throw "Not supported";
		return null;
		#end
	}

	public static function saveBytes( path : String, data : haxe.io.Bytes ) {
		#if (sys || nodejs)
		sys.io.File.saveBytes(path, data);
		#else
		throw "Not supported";
		#end
	}

	public static function load( path : String, onLoad : haxe.io.Bytes -> Void, ?onError : String -> Void ) {
		if( onError == null ) onError = function(_) { };
		#if sys
		var content = try sys.io.File.getBytes(path) catch( e : Dynamic ) { if( onError != null ) onError("" + e); return; };
		onLoad(content);
		#else
		throw "Not supported";
		#end
	}

	public static function createDirectory( path : String ) {
		#if (sys || nodejs)
		sys.FileSystem.createDirectory(path);
		#else
		throw "Not supported";
		#end
	}

}