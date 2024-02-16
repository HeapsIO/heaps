package h3d.prim;

@:access(h3d.prim.HMDModel)
class Blendshape {

	var hmdModel : HMDModel;
	var weights : Array<Float> = [];
	var index : Int = 0;
	var amount : Float = 0;
	var inputMapping : Array<Map<String, Int>> = [];
	var shapesBytes = [];

	public function new(hmdModel) {
		this.hmdModel = hmdModel;

		if ( hmdModel.data.vertexFormat.hasLowPrecision )
			throw "Blend shape doesn't support low precision";

		// Cache data for blendshapes
		var is32 = hmdModel.data.vertexCount > 0x10000;
		var vertexFormat = hmdModel.data.vertexFormat;
		var size = hmdModel.data.vertexCount * vertexFormat.strideBytes;
		var shapes = hmdModel.lib.header.shapes;

		for ( s in 0...shapes.length ) {
			var s = shapes[s];

			var size = s.vertexCount * s.vertexFormat.strideBytes;
			var vertexBytes = haxe.io.Bytes.alloc(size);
			hmdModel.lib.resource.entry.readBytes(vertexBytes, 0, hmdModel.dataPosition + s.vertexPosition, size);

			size = hmdModel.data.vertexCount << 2;
			var remapBytes = haxe.io.Bytes.alloc(size);
			hmdModel.lib.resource.entry.readBytes(remapBytes, 0, hmdModel.dataPosition + s.remapPosition, size);

			shapesBytes.push({ vertexBytes : vertexBytes, remapBytes : remapBytes});
			inputMapping.push(new Map());
		}

		// We want to remap inputs since inputs can be not exactly in the same
		for ( input in vertexFormat.getInputs() ) {
			for ( s in 0...shapes.length ) {
				var offset = 0;
				for ( i in shapes[s].vertexFormat.getInputs() ) {
					if ( i.name == input.name )
						inputMapping[s].set(i.name, offset);
					offset += i.type.getSize();
				}
			}
		}
	}

	public function setBlendshapeAmount(blendshapeIdx: Int, amount: Float) {
		this.index = blendshapeIdx;
		this.amount = amount;

		uploadBlendshapeBytes();
	}

	function getBlendshapeCount() {
		if (hmdModel.lib.header.shapes == null)
			return 0;

		return hmdModel.lib.header.shapes.length;
	}

	function uploadBlendshapeBytes() {
		var is32 = hmdModel.data.vertexCount > 0x10000;
		var vertexFormat = hmdModel.data.vertexFormat;

		var size = hmdModel.data.vertexCount * vertexFormat.strideBytes;
		var originalBytes = haxe.io.Bytes.alloc(size);
		hmdModel.lib.resource.entry.readBytes(originalBytes, 0, hmdModel.dataPosition + hmdModel.data.vertexPosition, size);

		var shapes = hmdModel.lib.header.shapes;
		weights = [];

		for ( s in 0...shapes.length )
			weights[s] = s == index ? amount : 0.0;

		var flagOffset = 31;
		var bytes = haxe.io.Bytes.alloc(originalBytes.length);
		bytes.blit(0, originalBytes, 0, originalBytes.length);

		// Apply blendshapes offsets to original vertex
		for (sIdx in 0...shapes.length) {
			if (sIdx != index)
				continue;

			var sp = shapesBytes[sIdx];
			var offsetIdx = 0;
			var idx = 0;

			while (offsetIdx < shapes[sIdx].indexCount) {
				var affectedVId = sp.remapBytes.getInt32(idx << 2);

				var reachEnd = false;
				while (!reachEnd) {
					reachEnd = affectedVId >> flagOffset != 0;
					if (reachEnd)
						affectedVId = affectedVId ^ (1 << flagOffset);

					var inputIdx = 0;
					var offsetInput = 0;
					for (input in shapes[sIdx].vertexFormat.getInputs()) {
						for (sizeIdx in 0...input.type.getSize()) {
							// if (input.name == "normal")
							// 	continue;

							var original = originalBytes.getFloat(affectedVId * vertexFormat.stride + inputMapping[sIdx][input.name] + sizeIdx << 2);
							var offset = sp.vertexBytes.getFloat(offsetIdx * shapes[sIdx].vertexFormat.stride + offsetInput + sizeIdx << 2);

							var res = hxd.Math.lerp(original, original + offset, weights[sIdx]);
							bytes.setFloat(affectedVId * vertexFormat.stride + inputMapping[sIdx][input.name] + sizeIdx << 2, res);
						}

						offsetInput += input.type.getSize();
						inputIdx++;
					}

					idx++;

					if (idx < hmdModel.data.vertexCount)
						affectedVId = sp.remapBytes.getInt32(idx << 2);
				}

				offsetIdx++;
			}
		}

		// Send bytes to buffer for rendering
		hmdModel.buffer.uploadBytes(bytes, 0, hmdModel.data.vertexCount);
		hmdModel.indexCount = 0;
		hmdModel.indexesTriPos = [];
		for( n in hmdModel.data.indexCounts ) {
			hmdModel.indexesTriPos.push(Std.int(hmdModel.indexCount/3));
			hmdModel.indexCount += n;
		}


		var size = (is32 ? 4 : 2) * hmdModel.indexCount;
		var bytes = hmdModel.lib.resource.entry.fetchBytes(hmdModel.dataPosition + hmdModel.data.indexPosition, size);
		hmdModel.indexes.uploadBytes(bytes, 0, hmdModel.indexCount);
	}
}