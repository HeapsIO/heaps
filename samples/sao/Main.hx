import hxd.Math;
import h3d.pass.ScalableAO;
import hxd.Key in K;

class CustomRenderer extends h3d.scene.Renderer {

	public var sao : h3d.pass.ScalableAO;
	public var saoBlur : h3d.pass.Blur;
	public var mode = 0;
	public var hasMRT : Bool;
	var out : h3d.mat.Texture;

	public function new() {
		super();
		sao = new h3d.pass.ScalableAO();
		// TODO : use a special Blur that prevents bluring across depths
		saoBlur = new h3d.pass.Blur(2, 3, 2);
		sao.shader.sampleRadius	= 0.2;
		hasMRT = h3d.Engine.getCurrent().driver.hasFeature(MultipleRenderTargets);
		if( hasMRT )
			def = new h3d.pass.MRT(["color","depth","normal"],0,true);
	}

	override function render() {
		super.render();
		if(mode != 1) {
			var saoTarget = allocTarget("sao",0,false);
			pushTarget(saoTarget);
			if( hasMRT )
				sao.apply(def.getTexture(1), def.getTexture(2), ctx.camera);
			else
				sao.apply(depth.getTexture(), normal.getTexture(), ctx.camera);
			popTarget();
			saoBlur.apply(saoTarget, allocTarget("saoBlurTmp", 1, false));
			if( hasMRT ) h3d.pass.Copy.run(def.getTexture(0), null);
			h3d.pass.Copy.run(saoTarget, null, mode == 0 ? Multiply : null);
		}
	}

}

class Main extends hxd.App {

	var time : Float = 0.;
	var wscale = 1.;
	var camdist = 6.;
	var paused = false;

	function initMaterial( m : h3d.mat.MeshMaterial ) {
		m.mainPass.enableLights = true;
		if( !Std.instance(s3d.renderer,CustomRenderer).hasMRT ) {
			m.addPass(new h3d.mat.Pass("depth", m.mainPass));
			m.addPass(new h3d.mat.Pass("normal", m.mainPass));
		}
	}

	override function init() {
		var r = new hxd.Rand(Std.random(0xFFFFFF));

		s3d.renderer = new CustomRenderer();

		var floor = new h3d.prim.Grid(40,40,0.25,0.25);
		floor.addNormals();
		floor.translate( -5, -5, 0);
		var m = new h3d.scene.Mesh(floor, s3d);
		initMaterial(m.material);
		m.material.color.makeColor(0.35, 0.5, 0.5);
		m.setScale(wscale);

		for( i in 0...100 ) {
			var box : h3d.prim.Polygon = new h3d.prim.Cube(0.3 + r.rand() * 0.5, 0.3 + r.rand() * 0.5, 0.2 + r.rand());
			box.unindex();
			box.addNormals();
			var p = new h3d.scene.Mesh(box, s3d);
			p.setScale(wscale);
			p.x = r.srand(3) * wscale;
			p.y = r.srand(3) * wscale;
			initMaterial(p.material);
			p.material.color.makeColor(r.rand() * 0.3, 0.5, 0.5);
		}
		s3d.camera.zNear = 0.1 * wscale;
		s3d.camera.zFar = 150 * wscale;

		s3d.lightSystem.ambientLight.set(0.5, 0.5, 0.5);
		var dir = new h3d.scene.DirLight(new h3d.Vector( -0.3, -0.2, -1), s3d);
		dir.color.set(0.5, 0.5, 0.5);

		time = Math.PI * 0.25;
		camdist = 6 * wscale;
	}

	function reset() {
		s3d = new h3d.scene.Scene();
		init();
	}

	override function update( dt : Float ) {

		if(K.isPressed(K.BACKSPACE))
			reset();

		if(K.isDown(K.SHIFT))
			dt *= 10;
		if(K.isPressed("P".code) || K.isPressed(K.SPACE))
			paused = !paused;

		var r = Std.instance(s3d.renderer, CustomRenderer);
		if(K.isPressed(K.NUMBER_1))
			r.mode = 0;
		if(K.isPressed(K.NUMBER_2))
			r.mode = 1;
		if(K.isPressed(K.NUMBER_3))
			r.mode = 2;
		if(K.isPressed("B".code))
			r.saoBlur.passes = r.saoBlur.passes == 0 ? 3 : 0;

		if( K.isDown(K.CTRL) && K.isDown(K.SHIFT) ) {
			if(K.isDown(K.NUMPAD_ADD))
				r.sao.shader.bias *= 1.02;
			if(K.isDown(K.NUMPAD_SUB))
				r.sao.shader.bias /= 1.02;
		} else if( K.isDown(K.SHIFT) ) {
			if(K.isDown(K.NUMPAD_ADD))
				s3d.camera.fovY *= 1.02;
			if(K.isDown(K.NUMPAD_SUB))
				s3d.camera.fovY /= 1.02;
		} else if( K.isDown(K.CTRL) ) {
			if(K.isDown(K.NUMPAD_ADD))
				r.sao.shader.intensity *= 1.02;
			if(K.isDown(K.NUMPAD_SUB))
				r.sao.shader.intensity /= 1.02;
		} else {
			if(K.isDown(K.NUMPAD_ADD))
				r.sao.shader.sampleRadius *= 1.02;
			if(K.isDown(K.NUMPAD_SUB))
				r.sao.shader.sampleRadius /= 1.02;
		}

		if(!paused)
			time += dt * 0.001;
		s3d.camera.pos.set(camdist * Math.cos(time), camdist * Math.sin(time), camdist * 0.5);
	}

	public static var inst : Main;
	static function main() {
		inst = new Main();
	}

}
