package h3d.mat;

class MaterialDatabase {

	var db : Map<String,{ v : Dynamic }> = new Map();

	public function new() {
	}

	function getFilePath( model : hxd.res.Resource ) {
		return model.entry.directory+"/materials.props";
	}

	public function getModelData( model : hxd.res.Resource ) {
		if( model == null )
			return null;
		var cached = db.get(model.entry.directory);
		if( cached != null )
			return cached.v;
		var file = getFilePath(model);
		var value = try haxe.Json.parse(hxd.res.Loader.currentInstance.load(file).toText()) catch( e : hxd.res.NotFound ) {};
		db.set(model.entry.directory, { v : value });
		return value;
	}

	function saveData( model : hxd.res.Resource, data : Dynamic ) {
		var file = getFilePath(model);
		#if (sys || nodejs)
		var fs = hxd.impl.Api.downcast(hxd.res.Loader.currentInstance.fs, hxd.fs.LocalFileSystem);
		if( fs != null && !haxe.io.Path.isAbsolute(file) )
			file = fs.baseDir + file;
		if( data == null )
			(try sys.FileSystem.deleteFile(file) catch( e : Dynamic ) {});
		else
			sys.io.File.saveContent(file, haxe.Json.stringify(data, "\t"));
		#else
		throw "Can't save material props database " + file;
		#end
	}

	public function loadMatProps( material : Material, setup : MaterialSetup ) {
		var p : Dynamic = getModelData(material.model);
		if( p == null ) return p;
		p = p.materials;
		if( p == null ) return p;
		p = Reflect.field(p, setup.name);
		if( p == null ) return p;
		return Reflect.field(p, material.name);
	}

	public function saveMatProps( material : Material, setup : MaterialSetup ) {
		var path = ["materials", setup.name, material.name];
		var root : Dynamic = getModelData(material.model);
		if( root == null )
			return;
		var realRoot = root;
		var prevs = [];
		for( i in 0...path.length - 1 ) {
			var next = Reflect.field(root, path[i]);
			if( next == null ) {
				next = {};
				Reflect.setField(root, path[i], next);
			}
			prevs.push(root);
			root = next;
		}
		var name = path.pop();
		Reflect.deleteField(root, name);

		var currentProps = material.props;
		var defaultProps = material.getDefaultProps();
		if( currentProps == null || Std.string(defaultProps) == Std.string(currentProps) ) {
			// cleanup
			while( path.length > 0 ) {
				var name = path.pop();
				var root = prevs.pop();
				if( Reflect.fields(Reflect.field(root, name)).length != 0 )
					break;
				Reflect.deleteField(root, name);
			}
		} else {
			Reflect.setField(root, name, currentProps);
		}

		var file = getFilePath(material.model);
		if( Reflect.fields(realRoot).length == 0 )
			realRoot = null;
		saveData(material.model, realRoot);
	}

}