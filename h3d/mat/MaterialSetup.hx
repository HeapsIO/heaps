package h3d.mat;

class MaterialSetup {

	public var name(default,null) : String;
	var database : MaterialDatabase;
	var emptyMat : h3d.mat.Material;

	public function new(name) {
		if( database == null )
			database = new MaterialDatabase("materials.json");
		this.name = name;
	}

	public function createRenderer() : h3d.scene.Renderer {
		return new h3d.scene.DefaultRenderer();
	}

	public function createLightSystem() {
		return new h3d.scene.LightSystem();
	}

	public function createMaterial() {
		return @:privateAccess new h3d.mat.Material();
	}

	public function loadProps( mat : h3d.mat.Material ) {
		return database.loadProps(mat, this);
	}

	public function getDefaults( ?kind : String ) {
		if( emptyMat == null ) emptyMat = createMaterial();
		return emptyMat.getDefaultProps(kind);
	}

	public function saveModelMaterial( material : Material ) {
		database.saveProps(material, this);
	}

	/*
		Can be used to perform custom mesh initialization such as computing extra buffers
		when loading it from HSD or displaying it in tools.
	*/
	public function customMeshInit( mesh : h3d.scene.Mesh ) {
	}

	public static var current = new MaterialSetup("Default");

}