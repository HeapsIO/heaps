package h3d.shader;

class Parallax extends hxsl.Shader {

	public static final MIN_LAYERS = 6;
	public static final MAX_LAYERS = 24;
	static var SRC = {

		@param var amount : Float;
		@param var heightMap : Channel;
		@:import BaseMesh;

		@const var minLayers : Int;
		@const var maxLayers : Int;

		var vertexTransformedNormal : Vec3;
		var transformedTangent : Vec4;
		var calculatedUV : Vec2;

		function vertex() {
			vertexTransformedNormal = transformedNormal;
		}

		function fragment() {
			var viewWS = (camera.position - transformedPosition).normalize();
			var viewNS : Vec3;
			{
				var n = vertexTransformedNormal.normalize();
				var tanX = transformedTangent.xyz.normalize();
				var tanY = n.cross(tanX);
				viewNS = vec3(viewWS.dot(tanX), viewWS.dot(tanY), viewWS.dot(n)).normalize();
			}
			if( maxLayers == 0 )
				calculatedUV += viewNS.xy * heightMap.get(calculatedUV) * amount;
			else {
				var numLayers = mix(float(maxLayers), float(minLayers), abs(viewNS.z));
				var layerDepth = 1 / numLayers;
				var curLayerDepth = 0.;
				var delta = (viewNS.xy / viewNS.z) * amount / numLayers;
				var curUV = calculatedUV;
				var curDepth = heightMap.getLod(curUV,0.);
			    while( curLayerDepth < curDepth ) {
			        curUV += delta;
			        curDepth = heightMap.getLod(curUV,0.);
			        curLayerDepth += layerDepth;
				}
				var prevUV = curUV - delta;
				var after = curDepth - curLayerDepth;
				var before = heightMap.get(prevUV) - curLayerDepth + layerDepth;
				calculatedUV = mix(curUV, prevUV, after / (after - before));
			}
		}
	}

	public function new() {
		super();
		maxLayers = MAX_LAYERS;
		minLayers = MIN_LAYERS;
	}
}