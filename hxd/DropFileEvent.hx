package hxd;

import haxe.io.Bytes;

/**
	The Drag&Drop event type.

	@see `hxd.DropFileEvent.kind`
**/
enum DropFileEventKind {
	/**
		User initiated the drag&drop operation by dragging content over the window.
	**/
	DropStart;
	/**
		User cancelled the drag&drop operation by moving cursor outside the window area.
	**/
	DropEnd;
	/**
		User continued the drag&drop operation by moving the cursor within the window area.
	**/
	DropMove;
	/**
		User confirmed the drag&drop operation.
	**/
	Drop;
}

/**
	The type of the content that was drag&dropped by user.

	@see `DroppedFile.kind`
**/
enum DropFileContentKind {
	/**
		The dropped file contents is a string.
	**/
	KString;
	/**
		The dropped file contents is a binary file.
	**/
	KFile;
	/**
		The dropped file contents are an unsupported type.
	**/
	KUnknown(type: String);
}

/**
	The information about the dropped file.
**/
interface DroppedFile {
	/**
		The content type of the dropped file.
	**/
	var kind : DropFileContentKind;
	/**
		The dropped file name if available.
	**/
	var name : String;
	/**
		The dropped file MIME type if available.
	**/
	var type : String;

	/**
		Retrieve the dropped file contents as Bytes and pass it to `callback`.
	**/
	function getBytes( callback : (data : Bytes) -> Void ) : Void;
	/**
		Retrieve the dropped file contents as a String and pass to to `callback`.
	**/
	function getString( callback : (data : String) -> Void ) : Void;

	/**
		Return the native file information data.
	**/
	// function getNative()

	#if !js
	/**
		[non-`js` target only] Returns the contents of the dropped file as Bytes.
	**/
	function getBytesSync() : Bytes;
	/**
		[non-`js` target only] Returns the contents of the dropped file as a String.
	**/
	function getStringSync() : String;
	#end

}

/**
	The drag&drop operation event.

	@see `hxd.Window.addDragAndDropTarget`
	@see `hxd.Window.removeDragAndDropTarget`
**/
class DropFileEvent {
	/**
		The event type of the drag&drop operation.
	**/
	public var kind: DropFileEventKind;

	/**
		The list of the files that were dropped.

		Only guaranteed to be populated when `kind == Drop`.
	**/
	public var files: Array<DroppedFile>;
	/**
		The first dropped file. Alias to `files[0]`.
	**/
	public var file(get, never): Null<DroppedFile>;
	
	public function new(kind: DropFileEventKind, files: Array<DroppedFile>) {
		this.kind = kind;
		this.files = files;
	}

	inline function get_file() return files[0];

}

