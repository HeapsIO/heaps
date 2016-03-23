package hxd.inspect;

private class ResObject extends TreeNode {

	public var f : hxd.fs.FileEntry;

	public function new(f, p) {
		this.f = f;
		super(f.name, p);
	}

}


class ResPanel extends Panel {

	var loader : hxd.res.Loader;
	var needSync = true;
	var files : Array<ResObject> = [];
	var filePos : Int;

	public function new(id, loader) {
		super(id, "Resources");
		this.loader = loader;
		sync();
	}

	override function sync() {
		if( !needSync ) return;
		needSync = false;
		filePos = 0;
		var subs = Lambda.array(loader.fs.getRoot());
		haxe.ds.ArraySort.sort(subs,function(s1, s2) return (s1.isDirectory?0:1) - (s2.isDirectory?0:1));
		for( e in subs )
			syncRec(e, this);
		while( files.length > filePos )
			files.pop().remove();
	}

	override function initContent() {
		super.initContent();
		j.addClass("resources");
		j.html('
			<div class="scrollable">
				<ul class="elt root">
				</ul>
			</div>
		');
		content = j.find(".root");
	}

	function getFileIcon( f : hxd.fs.FileEntry ) {
		if( f.isDirectory )
			return "folder-o";
		switch( f.extension ) {
		case "png", "gif", "jpg", "jpeg":
			return "file-image-o";
		case "xml":
			return "file-code-o";
		case "wav", "mp3", "ogg":
			return "file-sound-o";
		case "fbx":
			return "cube";
		default:
			return "file-text-o";
		}
	}

	function syncRec( f : hxd.fs.FileEntry, parent : Node ) {
		var fo = files[filePos];
		if( fo == null || fo.name != f.name ) {
			fo = new ResObject(f, parent);
			fo.icon = getFileIcon(f);
			files.insert(filePos, fo);
		}
		filePos++;
		if( f.isDirectory ) {
			f.watch(function() needSync = true);
			fo.openIcon = "folder-open-o";
			var subs = Lambda.array(f);
			haxe.ds.ArraySort.sort(subs,function(s1, s2) return (s1.isDirectory?0:1) - (s2.isDirectory?0:1));
			for( c in subs )
				syncRec(c, fo);
		}
	}

}