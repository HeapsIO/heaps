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
			throw "Prefab "+unk.type+" was not compiled";

		var ctx = new hrt.prefab.ContextShared(s2d, s3d);

		function play() {
			var i = prefab.make(ctx);
			var obj = i.to(hrt.prefab.Object3D);
			if( obj != null ) {
				var fx = cast(obj.local3d, hrt.prefab.fx.FX.FXAnimation);
				fx.onEnd = function() {
					fx.remove();
					play();
				};
			}
		}
		play();

		new h3d.scene.CameraController(20,s3d);
		var text = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
		text.text = "Drag and move with your mouse!";

	}

	static function main() {
		h3d.mat.PbrMaterialSetup.set();
		hxd.Res.initEmbed();
		new FxView();
	}

}