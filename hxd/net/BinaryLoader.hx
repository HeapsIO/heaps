package hxd.net;

class BinaryLoader {

	public var url(default, null) : String;

	public function new( url : String ) {
		this.url = url;
	}

	public dynamic function onLoaded( bytes : haxe.io.Bytes ) {
	}

	public dynamic function onProgress( cur : Int, max : Int ) {
	}

	public dynamic function onError( msg : String ) {
		throw msg;
	}

	public function load(raw = false) {
		#if js

		var xhr = new js.html.XMLHttpRequest();
		xhr.open('GET', url, true);
		xhr.responseType = js.html.XMLHttpRequestResponseType.ARRAYBUFFER;
		xhr.onerror = function(e) onError(xhr.statusText);

		xhr.onload = function(e) {

			if (xhr.status != 200) {
				onError(xhr.statusText);
				return;
			}
			onLoaded(raw ? xhr.response : haxe.io.Bytes.ofData(xhr.response));
		}

		xhr.onprogress = function(e) {
			onProgress(Std.int(js.Syntax.code("{0}.loaded || {0}.position", e)), Std.int(js.Syntax.code("{0}.total || {0}.totalSize", e)));
		}
		xhr.send();

		#else

		throw "Not available on this platform";

		#end
	}

}
