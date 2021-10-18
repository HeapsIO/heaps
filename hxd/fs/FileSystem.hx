package hxd.fs;

/**
	The base interface for the Resource system underlying file system.

	@see `hxd.Res`
**/
interface FileSystem {
	/**
		Returns the root FileEntry directory of the FileSystem.

		Not all file systems support `getRoot()`.
	**/
	public function getRoot() : FileEntry;
	/**
		Returns the FileEntry instance under the given `path`.

		Depending on file system used, entry is not guaranteed to be available for reading right away and should be first loaded via `FileEntry.load`.

		@throws `NotFound` if the file under given path does not exist.
	**/
	public function get( path : String ) : FileEntry;
	/**
		Checks whether the file under given `path` exists or not.
	**/
	public function exists( path : String ) : Bool;
	/**
		Disposes of the file system.

		File systems are expected to free the allocated file data that was stored in RAM.
	**/
	public function dispose() : Void;
	/**
		Returns the FileEntry directory under the given `path`.

		Not all file systems support `dir()`.
		
		@throws `NotFound` if the file under given path does not exist.
	**/
	public function dir( path : String ) : Array<FileEntry> ;
}