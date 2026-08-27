package hxd.fmt.gltf;
import hxd.fmt.hmd.Data;
import hxd.BufferFormat;

class HMDOut extends hxd.fmt.hmd.HMDOut<hxd.fmt.gltf.Data> {

	public function new() {
		super();
	}

	override function load(data : hxd.fmt.gltf.Data) {
		trace("Load data");
	}

	override function toHMD() : Data {
		// if we have only animation data, make sure to export all joints positions
		// because they might be applied to a different model at runtime
		// if( !includeGeometry )
		// 	optimizeSkin = false;

		// leftHandConvert();
		// autoMerge();

		// if( filePath != null ) {
		// 	filePath = filePath.split("\\").join("/").toLowerCase();
		// 	if( !StringTools.endsWith(filePath, "/") )
		// 		filePath += "/";
		// }
		// this.filePath = filePath;

		var d = new Data();
		#if hmd_version
		d.version = Std.parseInt(#if macro haxe.macro.Context.definedValue("hmd_version") #else haxe.macro.Compiler.getDefine("hmd_version") #end);
		#else
		d.version = Data.CURRENT_VERSION;
		#end
		d.geometries = [];
		d.materials = [];
		d.models = [];
		d.animations = [];
		d.shapes = [];

		var dataOut = new haxe.io.BytesOutput();

		// addModels(includeGeometry);

		// var names = getAnimationNames();
		// for ( animName in names ) {
		// 	var anim = loadAnimation(animName);
		// 	if(anim != null)
		// 		d.animations.push(makeAnimation(anim));
		// }

		d.data = dataOut.getBytes();
		return d;
	}
}
