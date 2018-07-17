package hxd.prefab.rfx;

enum Step {
	BeforeHdr;
	AfterHdr;
}

class RendererFX extends Prefab {

	public function apply( ctx : h3d.scene.RenderContext, step : Step ) {
	}

	override function save() {
		return {};
	}

	override function load(v:Dynamic) {
	}

	#if editor
	override function getHideProps() : hide.prefab.HideProps {
		return { name : Type.getClassName(Type.getClass(this)).split(".").pop(), icon : "plus-circle" };
	}
	#end

}