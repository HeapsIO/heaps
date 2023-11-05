package hxd;

import haxe.ds.ReadOnlyArray;
import haxe.io.Bytes;

/**
	The information about the dropped file.
**/
abstract class DroppedFile {
	/**
		The dropped file name/path.
	**/
	public var file(default, null) : String;
	#if js
	/**
		The native JS data transfer file.
	**/
	public var native(default, null) : js.html.File;

	public function new( native : js.html.File ) {
		this.file = native.name;
		this.native = native;
	}
	#else
	public function new( file : String ) {
		this.file = file;
	}
	#end


	/**
		Retrieve the dropped file contents asynchronously and pass it to `callback`.
	**/
	abstract public function getBytes( callback : (data : Bytes) -> Void ) : Void;
}

/**
	The drag&drop operation event.

	@see `hxd.Window.addDragAndDropTarget`
	@see `hxd.Window.removeDragAndDropTarget`
**/
class DropFileEvent {
	/**
		The list of the files that were dropped.

		Only guaranteed to be populated when `kind == Drop`.
	**/
	public var files(default, null): ReadOnlyArray<DroppedFile>;
	/**
		The first dropped file. Alias to `files[0]`.
	**/
	public var file(get, never): Null<DroppedFile>;
	/**
		The X position inside the window at which the file was dropped.
	**/
	public var dropX(default, null): Int;
	/**
		The Y position inside the window at which the file was dropped.
	**/
	public var dropY(default, null): Int;
	
	public function new( files : Array<DroppedFile>, dx : Int, dy : Int ) {
		this.files = files;
		this.dropX = dx;
		this.dropY = dy;
	}

	inline function get_file() return files[0];

}

