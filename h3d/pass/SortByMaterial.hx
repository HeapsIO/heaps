package h3d.pass;

class SortByMaterial {

	var shaderCount : Int = 1;
	var textureCount : Int = 1;
	var shaderIdMap : Array<Int>;
	var textureIdMap : Array<Int>;

	public function new() {
		shaderIdMap = [];
		textureIdMap = [];
	}

	public function sort( passes : PassList ) {
		var shaderStart = shaderCount, textureStart = textureCount;
		for( p in passes ) {
			if( shaderIdMap[p.shader.id] < shaderStart #if js || shaderIdMap[p.shader.id] == null #end )
				shaderIdMap[p.shader.id] = shaderCount++;
			if( textureIdMap[p.texture] < textureStart #if js || textureIdMap[p.shader.id] == null #end )
				textureIdMap[p.texture] = textureCount++;
		}
		passes.sort(function(o1, o2) {
			var d = shaderIdMap[o1.shader.id] - shaderIdMap[o2.shader.id];
			if( d != 0 ) return d;
			return textureIdMap[o1.texture] - textureIdMap[o2.texture];
		});
	}

}