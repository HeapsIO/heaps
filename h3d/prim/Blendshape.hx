package h3d.prim;

@:access(h3d.prim.HMDModel)
class Blendshape {

	var hmdModel : HMDModel;
	var weights : Array<Float>;
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

		weights = [];

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

			weights.push(0.0);
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
		if (blendshapeIdx >= this.weights.length)
			throw 'Blendshape at index ${blendshapeIdx} doesn\'t exist (there is only ${this.weights.length} blendshapes).';

		this.weights[blendshapeIdx] = amount;
		uploadBlendshapeBytes();
	}

	function getBlendshapeCount() {
		if (hmdModel.lib.header.shapes == null)
			return 0;

		return hmdModel.lib.header.shapes.length;
	}

	function uploadBlendshapeBytes() {
		if (hmdModel.buffer == null || hmdModel.buffer.isDisposed())
			hmdModel.alloc(Engine.getCurrent());

		var is32 = hmdModel.data.vertexCount > 0x10000;
		var vertexFormat = hmdModel.data.vertexFormat;

		var size = hmdModel.data.vertexCount * vertexFormat.strideBytes;
		var originalBytes = haxe.io.Bytes.alloc(size);
		hmdModel.lib.resource.entry.readBytes(originalBytes, 0, hmdModel.dataPosition + hmdModel.data.vertexPosition, size);

		var flagOffset = 31;
		var shapes = hmdModel.lib.header.shapes;

		var bytesOffset = haxe.io.Bytes.alloc(originalBytes.length);
		bytesOffset.fill(0, originalBytes.length, 0);

		// Apply blendshapes offsets to original vertex
		for (sIdx in 0...shapes.length) {
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

							var res = hxd.Math.lerp(original, original + offset, weights[sIdx]) - original;

							var bytePos = affectedVId * vertexFormat.stride + inputMapping[sIdx][input.name] + sizeIdx << 2;
							bytesOffset.setFloat(bytePos, bytesOffset.getFloat(bytePos) + res);
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

		var bytes = haxe.io.Bytes.alloc(originalBytes.length);
		bytes.blit(0, originalBytes, 0, originalBytes.length);

		for (i in 0...(Std.int(bytesOffset.length / 4.0)))
			bytes.setFloat(i << 2, bytes.getFloat(i << 2) + bytesOffset.getFloat(i << 2));

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