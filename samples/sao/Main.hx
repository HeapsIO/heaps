import hxd.Math;

class CustomRenderer extends h3d.scene.Renderer {

	var sao : h3d.pass.ScalableAO;
	var saoBlur : h3d.pass.Blur;
	var out : h3d.mat.Texture;

	public function new() {
		super();
		sao = new h3d.pass.ScalableAO();
		// TODO : use a special Blur that prevents bluring across depths
		saoBlur = new h3d.pass.Blur(3,5);
		saoBlur.passes = 3;
	}

	override function process( ctx, passes ) {
		super.process(ctx, passes);

		var saoTarget = allocTarget("sao",0,false);
		setTarget(saoTarget);
		sao.apply(depth.getTexture(), normal.getTexture(), ctx.camera);
		saoBlur.apply(saoTarget, allocTarget("saoBlurTmp", 0, false));

		h3d.pass.Copy.run(saoTarget, null, Multiply);
	}

}

class Main extends hxd.App {

	var time : Float = 0.;

	function initMaterial( m : h3d.mat.MeshMaterial ) {
		m.mainPass.enableLights = true;
		m.addPass(new h3d.mat.Pass("depth", m.mainPass));
		m.addPass(new h3d.mat.Pass("normal", m.mainPass));
	}

	override function init() {

		var floor = new h3d.prim.Grid(40,40,0.25,0.25);
		floor.addNormals();
		floor.translate( -5, -5, 0);
		var m = new h3d.scene.Mesh(floor, s3d);
		initMaterial(m.material);
		m.material.color.makeColor(0.35, 0.5, 0.5);

		for( i in 0...100 ) {
			var box : h3d.prim.Polygon = new h3d.prim.Cube(Math.random(),Math.random(), 0.7 + Math.random() * 0.8);
			box.unindex();
			box.addNormals();
			var p = new h3d.scene.Mesh(box, s3d);
			p.x = Math.srand(3);
			p.y = Math.srand(3);
			initMaterial(p.material);
			p.material.color.makeColor(Math.random() * 0.3, 0.5, 0.5);
		}
		s3d.camera.zNear = 0.5;
		s3d.camera.zFar = 15;

		s3d.lightSystem.ambientLight.set(0.5, 0.5, 0.5);
		var dir = new h3d.scene.DirLight(new h3d.Vector( -0.3, -0.2, -1), s3d);
		dir.color.set(0.5, 0.5, 0.5);

		s3d.renderer = new CustomRenderer();
	}

	override function update( dt : Float ) {
		time += dt * 0.001;
		s3d.camera.pos.set(6 * Math.cos(time), 6 * Math.sin(time), 3);
	}

	public static var inst : Main;
	static function main() {
		inst = new Main();
	}

}
