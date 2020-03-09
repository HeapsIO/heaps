import hrt.prefab.fx.FX;
import hrt.prefab.l3d.Polygon;

class ColorMult extends hxsl.Shader {
	static var SRC = {
		@param var color : Vec3;
		@param var amount : Float = 1.0;
		var pixelColor : Vec4;

		function fragment() {
			pixelColor.rgb = mix(pixelColor.rgb, pixelColor.rgb * color, amount);
		}
	}
}

//PARAM=-lib hide
class FxView extends hxd.App {


	override function init() {
		var prefab = hxd.Res.hideEffect.load();
		var unk = prefab.getOpt(hrt.prefab.Unknown);
		if( unk != null )
			throw "Prefab "+unk.getPrefabType()+" was not compiled";

		var ctx = new hrt.prefab.Context();
		var shared = new hrt.prefab.ContextShared();
		ctx.shared = shared;
		shared.root2d = s2d;
		shared.root3d = s3d;
		ctx.init();

		function play() {
			var i = prefab.make(ctx);
			var fx = cast(i.local3d, hrt.prefab.fx.FX.FXAnimation);
			fx.onEnd = function() {
				fx.remove();
				play();
			};
		}
		play();

		new h3d.scene.CameraController(20,s3d);

	}

	static function main() {
		h3d.mat.PbrMaterialSetup.set();
		hxd.Res.initEmbed();
		new FxView();
	}

}