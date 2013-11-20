package hxd.res;

interface FileSystem {
	public function getRoot() : FileEntry;
	public function get( path : String ) : FileEntry;
	public function exists( path : String ) : Bool;
	
}