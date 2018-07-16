package hxd.prefab;

class Unknown extends Prefab {

	var data : Dynamic;

	override function load(v:Dynamic) {
		this.data = v;
	}

	override function save() {
		return data;
	}

	#if editor
	override function edit(ctx:hide.prefab.EditContext) {
		ctx.properties.add(new hide.Element('<font color="red">Unknown prefab $type</font>'));
	}
	#end


}