package h3d.mat;

class MaterialSetup {

	public var name(default,null) : String;
	public var displayName(default,null) : String;
	var database : MaterialDatabase;
	var emptyMat : h3d.mat.Material;

	public function new(name) {
		if( database == null )
			database = new MaterialDatabase();
		this.name = name;
	}

	public function createRenderer() : h3d.scene.Renderer {
		return new h3d.scene.fwd.Renderer();
	}

	public function createLightSystem() : h3d.scene.LightSystem {
		return new h3d.scene.fwd.LightSystem();
	}

	public function createMaterial() {
		return @:privateAccess new h3d.mat.Material();
	}

	public function getDefaults( ?kind : String ) {
		if( emptyMat == null ) emptyMat = createMaterial();
		return emptyMat.getDefaultProps(kind);
	}

	public function loadMaterialProps( material : h3d.mat.Material ) {
		return database.loadMatProps(material, this);
	}

	public function saveMaterialProps( material : Material ) {
		database.saveMatProps(material, this);
	}

	/*
		Can be used to perform custom mesh initialization such as computing extra buffers
		when loading it from HSD or displaying it in tools.
	*/
	public function customMeshInit( mesh : h3d.scene.Mesh ) {
	}

	public static var current = new MaterialSetup("Default");

}