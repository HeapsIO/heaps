package h3d.shader;

class Parallax extends hxsl.Shader {

	static var SRC = {

		@param var amount : Float;
		@param var heightMap : Channel;
		@:import BaseMesh;

		@const var minLayers : Int = 6;
		@const var maxLayers : Int = 24;

		var vertexTransformedNormal : Vec3;
		var transformedTangent : Vec4;
		var calculatedUV : Vec2;

		function vertex() {
			vertexTransformedNormal = transformedNormal;
		}

		function fragment() {
			var viewWS = (camera.position - transformedPosition).normalize();
			var n = vertexTransformedNormal;
			var tanX = transformedTangent.xyz.normalize();
			var tanY = n.cross(tanX);
			var viewNS = (vec3(viewWS.dot(tanX), viewWS.dot(tanY), viewWS.dot(n)) * global.modelViewInverse.mat3()).normalize();
			if( maxLayers == 0 )
				calculatedUV += viewNS.xy * heightMap.get(calculatedUV) * amount;
			else {
				var numLayers = mix(float(maxLayers), float(minLayers), abs(viewNS.z));
				var layerDepth = 1 / numLayers;
				var curLayerDepth = 0.;
				var delta = (viewNS.xy / viewNS.z) * amount / numLayers;
				var curUV = calculatedUV;
				var curDepth = heightMap.get(curUV);
			    while( curLayerDepth < curDepth ) {
			        curUV += delta;
			        curDepth = heightMap.get(curUV);
			        curLayerDepth += layerDepth;
				}
				var prevUV = curUV - delta;
				var after = curDepth - curLayerDepth;
				var before = heightMap.get(prevUV) - curLayerDepth + layerDepth;
				calculatedUV = mix(curUV, prevUV, after / (after - before));
			}
		}
	}


}