package hxd.impl;

typedef AllocPos = #if track_alloc AllocPosImpl #else {} #end

#if track_alloc
class AllocPosImpl {

	public var position : String;
	public var stack : Array<String> = [];
	public static var ENGINE_PACKAGES = ["h3d","hxd","h2d","haxe","sys","hrt" /* HIDE */];

	public function new() {
		var curStack = haxe.CallStack.callStack();
		curStack.shift();
		for( s in curStack ) {
			switch( s ) {
			case FilePos(_,file,line,_):
				var idx = file.indexOf("\\std/");
				if( idx > 0 )
					file = file.substr(idx + 5);
				var pos = file+":"+line;
				stack.push(pos);
				if( position == null ){
					var p = file.indexOf("/");
					var pack = p < 0 ? "" : file.substr(0,p);
					if( ENGINE_PACKAGES.indexOf(pack) < 0 ) position = pos;
				}
			case Method(cl,meth):
				// TODO
			case CFunction, Module(_), LocalFunction(_):
				// skip
			}
		}
		if( position == null ) position = stack[0];
	}

}
#end
