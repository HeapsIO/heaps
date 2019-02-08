package hxd.prefab.rfx;

enum Step {
	BeforeHdr;
	AfterHdr;
	Final;
}

class RendererFX extends Prefab {

	public function apply( r : h3d.scene.Renderer, step : Step ) {
	}

	override function save() {
		return {};
	}

	override function load(v:Dynamic) {
	}

	public function dispose() {
	}

	#if editor
	override function getHideProps() : hide.prefab.HideProps {
		return { name : Type.getClassName(Type.getClass(this)).split(".").pop(), icon : "plus-circle" };
	}
	#end

}