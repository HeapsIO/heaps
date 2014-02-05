package h3d.mat;

typedef LightSystem = {
	var ambient : h3d.Vector;
	var dirs : Array<{ dir : h3d.Vector, color : h3d.Vector }>;
	var points : Array<{ pos : h3d.Vector, color : h3d.Vector, att : h3d.Vector }>;
}

typedef ShadowMap = {
	var lightProj : h3d.Matrix;
	var lightCenter : h3d.Matrix;
	var color : h3d.Vector;
	var texture : Texture;
}

typedef DecalInfos = {
	var depthTexture : Texture;
	var uvScaleRatio : h3d.Vector;
	var screenToLocal : h3d.Matrix;
}

private class MeshShader extends h3d.impl.Shader {
	
#if flash
	static var SRC = {

		var input : {
			pos : Float3,
			uv : Float2,
			normal : Float3,
			color : Float3,
			colorAdd : Float3,
			blending : Float,
			weights : Float3,
			indexes : Int,
		};
		
		var tuv : Float2;
		
		var uvScale : Float2;
		var uvDelta : Float2;
		var hasSkin : Bool;
		var hasVertexColor : Bool;
		var hasVertexColorAdd : Bool;
		var skinMatrixes : M34<34>;

		var tcolor : Float3;
		var acolor : Float3;
		var talpha : Float;
		
		var zBias : Float;
		var hasZBias : Bool;
		
		var alphaMap : Texture;
		var alphaMapScroll : Float2;
		var hasAlphaMap : Bool;
		
		var lightSystem : Param < {
			var ambient : Float3;
			var dirs : Array<{ dir : Float3, color : Float3 }>;
			var points : Array<{ pos : Float3, color : Float3, att : Float3 }>;
		}>;
		
		var fog : Float4;
		
		var glowTexture : Texture;
		var glowAmount : Float3;
		var hasGlow : Bool;
		
		var blendTexture : Texture;
		var hasBlend : Bool;
		var tblend : Float;

		var hasShadowMap : Bool;
		var shadowLightProj : Matrix;
		var shadowLightCenter : Matrix;
		var shadowColor : Float4;
		var shadowTexture : Texture;
		var tshadowPos : Float4;

		var isOutline : Bool;
		var outlineColor : Int;
		var outlineSize : Float;
		var outlinePower : Float;
		var outlineProj : Float3;
		
		var cameraPos : Float3;
		var worldNormal : Float3;
		var worldView : Float3;

		// the decal volume should have its pivot at the center of the box
		// uvScaleRatio is the size of the box primitive
		var isDecal : Bool;
		var depthTexture : Texture;
		var uvScaleRatio : Float2;
		var screenToLocal : Matrix;
		var outProjPos : Float4; // varying
		
		var smoothEdges : Bool;
		var smoothFactor : Float;
		
		var writeDistance : Bool;
		var projCenter : Float3;
		var distance : Float3;
		
		
		var colorMap : Texture;
		var colorMapMatrix : Matrix;
		var hasColorMap : Bool;

		function vertex( mpos : Matrix, mproj : Matrix ) {
			var tpos = input.pos.xyzw;
			var tnorm : Float3 = [0, 0, 0];
			
			if( lightSystem != null || isOutline ) {
				var n = input.normal;
				if( hasSkin )
					n = n * input.weights.x * skinMatrixes[input.indexes.x * (255 * 3)].m33 + n * input.weights.y * skinMatrixes[input.indexes.y * (255 * 3)].m33 + n * input.weights.z * skinMatrixes[input.indexes.z * (255 * 3)].m33;
				else if( mpos != null )
					n *= mpos.m33;
				tnorm = n.normalize();
			}
			
			if( hasSkin )
				tpos.xyz = tpos * input.weights.x * skinMatrixes[input.indexes.x * (255 * 3)] + tpos * input.weights.y * skinMatrixes[input.indexes.y * (255 * 3)] + tpos * input.weights.z * skinMatrixes[input.indexes.z * (255 * 3)];
			else if( mpos != null )
				tpos *= mpos;
				
			if( isOutline ) {
				tpos.xy += tnorm.xy * outlineProj.xy * outlineSize;
				worldNormal = tnorm;
				worldView = (cameraPos - tpos.xyz).normalize();
			}
			
			var ppos = tpos * mproj;
			if( hasZBias ) ppos.z += zBias;
			
			if( writeDistance ) {
				var tmp = projCenter - (ppos.xyz / ppos.w);
				tmp.y *= -1;
				distance = tmp;
			}
			
			out = ppos;
			var t = input.uv;
			if( uvScale != null ) t *= uvScale;
			if( uvDelta != null ) t += uvDelta;
			if( isDecal || smoothEdges ) outProjPos = ppos;
			tuv = t;
			if( lightSystem != null ) {
				// calculate normal
				var col = lightSystem.ambient;
				for( d in lightSystem.dirs )
					col += d.color * tnorm.dot(-d.dir).max(0);
				for( p in lightSystem.points ) {
					var d = tpos.xyz - p.pos;
					var dist2 = d.dot(d);
					var dist = dist2.sqt();
					col += p.color * (tnorm.dot(d).max(0) / (p.att.x * dist + p.att.y * dist2 + p.att.z * dist2 * dist));
				}
				if( hasVertexColor )
					tcolor = col * input.color;
				else
					tcolor = col;
			} else if( hasVertexColor )
				tcolor = input.color;
			if( hasVertexColorAdd )
				acolor = input.colorAdd;
			if( fog != null ) {
				var dist = tpos.xyz - fog.xyz;
				talpha = (fog.w * dist.dot(dist).rsqrt()).min(1);
			}
			if( hasBlend ) tblend = input.blending;
			if( hasShadowMap )
				tshadowPos = tpos * shadowLightProj * shadowLightCenter;
		}
		
		var killAlpha : Bool;
		var killAlphaThreshold : Float;
		var isDXT1 : Bool;
		var isDXT5 : Bool;
		
		function fragment( tex : Texture, colorAdd : Float4, colorMul : Float4, colorMatrix : M44 ) {
			if( isOutline ) {
				var c = outlineColor;
				var e = 1 - worldNormal.normalize().dot(worldView.normalize());
				out = c * e.pow(outlinePower);
			} else if( isDecal ) {
				var screenPos = outProjPos.xy / outProjPos.w;
				var tuv = screenPos * [0.5,-0.5] + [0.5,0.5];
				var ruv : Float4 = [0,0,0,0];
				ruv.xy = screenPos;
				ruv.z = depthTexture.get(tuv).rgb.dot([1,1/255,1/(255*255)]);
				ruv.w = 1;
				var wpos = ruv * screenToLocal;
				var coord = uvScaleRatio * (wpos.xy / wpos.w) + 0.5;
				kill( min(min(coord.x, coord.y), min(1 - coord.x, 1 - coord.y)) );
				var c = tex.get(coord.xy);
				if( killAlpha ) kill(c.a - killAlphaThreshold);
				if( colorAdd != null ) c += colorAdd;
				if( colorMul != null ) c = c * colorMul;
				if( colorMatrix != null ) c = c * colorMatrix;
				out = c;
			} else {
				var c = tex.get(tuv.xy, type = isDXT1 ? 1 : isDXT5 ? 2 : 0);
				if( hasColorMap )
					c.rgb += (colorMap.get(tuv.xy) * colorMapMatrix).rgb;
				if( fog != null ) c.a *= talpha;
				if( hasAlphaMap ) c.a *= alphaMap.get(alphaMapScroll != null ? tuv + alphaMapScroll : tuv.xy,type=isDXT1 ? 1 : isDXT5 ? 2 : 0).b;
				if( smoothEdges ) {
					var screenPos = outProjPos.xyz / outProjPos.w;
					var tuv = screenPos.xy * [0.5,-0.5] + [0.5,0.5];
					c.a *= ((depthTexture.get(tuv).rgb.dot([1, 1 / 255, 1 / (255*255)]) - screenPos.z) * smoothFactor).sat();
				}
				if( killAlpha ) kill(c.a - killAlphaThreshold);
				if( hasBlend ) c.rgb = c.rgb * (1 - tblend) + tblend * blendTexture.get(tuv.xy,type=isDXT1 ? 1 : isDXT5 ? 2 : 0).rgb;
				if( colorAdd != null ) c += colorAdd;
				if( colorMul != null ) c = c * colorMul;
				if( colorMatrix != null ) c = c * colorMatrix;
				if( hasVertexColorAdd )
					c.rgb += acolor;
				if( lightSystem != null || hasVertexColor )
					c.rgb *= tcolor;
				if( hasShadowMap ) {
					// ESM filtering
					var shadow = exp( shadowColor.w * (tshadowPos.z - shadowTexture.get(tshadowPos.xy).dot([1, 1 / 255, 1 / (255 * 255), 1 / (255 * 255 * 255)]))).sat();
					c.rgb *= (1 - shadow) * shadowColor.rgb + shadow.xxx;
				}
				if( hasGlow ) c.rgb += glowTexture.get(tuv.xy).rgb * glowAmount;
				if( writeDistance ) c.rgb *= distance + [0.5,0.5,0];
				out = c;
			}
		}
		
	}
#else

	public var maxSkinMatrixes : Int = 34;
	public var hasVertexColor : Bool;
	public var hasVertexColorAdd : Bool;
	public var lightSystem(default, set) : LightSystem;
	public var hasSkin : Bool;
	public var hasZBias : Bool;
	public var hasShadowMap : Bool;
	public var killAlpha : Bool;
	public var hasAlphaMap : Bool;
	public var hasBlend : Bool;
	public var hasGlow : Bool;
	
	var lights : {
		ambient : h3d.Vector,
		dirsDir : Array<h3d.Vector>,
		dirsColor : Array<h3d.Vector>,
		pointsPos : Array<h3d.Vector>,
		pointsColor : Array<h3d.Vector>,
		pointsAtt : Array<h3d.Vector>,
	};
	
	function set_lightSystem(l) {
		this.lightSystem = l;
		lights = {
			ambient : l.ambient,
			dirsDir : [for( l in l.dirs ) l.dir],
			dirsColor : [for( l in l.dirs ) l.color],
			pointsPos : [for( p in l.points ) p.pos],
			pointsColor : [for( p in l.points ) p.color],
			pointsAtt : [for( p in l.points ) p.att],
		};
		return l;
	}
	
	override function getConstants(vertex) {
		var cst = [];
		if( hasVertexColor ) cst.push("#define hasVertexColor");
		if( hasVertexColorAdd ) cst.push("#define hasVertexColorAdd");
		if( fog != null ) cst.push("#define hasFog");
		if( hasBlend ) cst.push("#define hasBlend");
		if( hasShadowMap ) cst.push("#define hasShadowMap");
		if( lightSystem != null ) {
			cst.push("#define hasLightSystem");
			cst.push("const int numDirLights = " + lightSystem.dirs.length+";");
			cst.push("const int numPointLights = " + lightSystem.points.length+";");
		}
		if( vertex ) {
			if( mpos != null ) cst.push("#define hasPos");
			if( hasSkin ) {
				cst.push("#define hasSkin");
				cst.push("const int maxSkinMatrixes = " + maxSkinMatrixes+";");
			}
			if( uvScale != null ) cst.push("#define hasUVScale");
			if( uvDelta != null ) cst.push("#define hasUVDelta");
			if( hasZBias ) cst.push("#define hasZBias");
		} else {
			if( killAlpha ) cst.push("#define killAlpha");
			if( colorAdd != null ) cst.push("#define hasColorAdd");
			if( colorMul != null ) cst.push("#define hasColorMul");
			if( colorMatrix != null ) cst.push("#define hasColorMatrix");
			if( hasAlphaMap ) cst.push("#define hasAlphaMap");
			if( hasGlow ) cst.push("#define hasGlow");
			if( hasVertexColorAdd || lightSystem != null ) cst.push("#define hasFragColor");
		}
		return cst.join("\n");
	}

	static var VERTEX = "
	
		attribute vec3 pos;
		attribute vec2 uv;
		#if hasLightSystem
		attribute vec3 normal;
		#end
		#if hasVertexColor
		attribute vec3 color;
		#end
		#if hasVertexColorAdd
		attribute vec3 colorAdd;
		#end
		#if hasBlend
		attribute float blending;
		#end
		#if hasSkin
		uniform mat4 skinMatrixes[maxSkinMatrixes];
		#end

		uniform mat4 mpos;
		uniform mat4 mproj;
		uniform float zBias;
		uniform vec2 uvScale;
		uniform vec2 uvDelta;
		
		// we can't use Array of structures in GLSL
		struct LightSystem {
			vec3 ambient;
			vec3 dirsDir[numDirLights];
			vec3 dirsColor[numDirLights];
			vec3 pointsPos[numPointLights];
			vec3 pointsColor[numPointLights];
			vec3 pointsAtt[numPointLights];
		};
		uniform LightSystem lights;
			
		uniform mat4 shadowLightProj;
		uniform mat4 shadowLightCenter;

		uniform vec4 fog;
		
		varying lowp vec2 tuv;
		varying lowp vec3 tcolor;
		varying lowp vec3 acolor;
		varying mediump float talpha;
		varying mediump float tblend;
		varying mediump vec4 tshadowPos;
		
		uniform mat3 mposInv;

		void main(void) {
			vec4 tpos = vec4(pos, 1.0);
			#if hasSkin
//				tpos.xyz = tpos * input.weights.x * skinMatrixes[input.indexes.x * (255 * 3)] + tpos * input.weights.y * skinMatrixes[input.indexes.y * (255 * 3)] + tpos * input.weights.z * skinMatrixes[input.indexes.z * (255 * 3)];
			#elseif hasPos
				tpos = mpos * tpos;
			#end
			vec4 ppos = mproj * tpos;
			#if hasZBias
				ppos.z += zBias;
			#end
			gl_Position = ppos;
			vec2 t = uv;
			#if hasUVScale
				t *= uvScale;
			#end
			#if hasUVDelta
				t += uvDelta;
			#end
			tuv = t;
			#if hasLightSystem
				vec3 n = normal;
				#if hasPos
					n = mat3(mpos) * n;
				#elseif hasSkin
					//n = n * input.weights.x * skinMatrixes[input.indexes.x * (255 * 3)] + n * input.weights.y * skinMatrixes[input.indexes.y * (255 * 3)] + n * input.weights.z * skinMatrixes[input.indexes.z * (255 * 3)];
					#if hasPos
						n = mposInv * n;
					#end
				#end
				n = normalize(n);
				vec3 col = lights.ambient;
				for(int i = 0; i < numDirLights; i++ )
					col += lights.dirsColor[i] * max(dot(n,-lights.dirsDir[i]),0.);
				for(int i = 0; i < numPointLights; i++ ) {
					vec3 d = tpos.xyz - lights.pointsPos[i];
					float dist2 = dot(d,d);
					float dist = sqrt(dist2);
					col += lights.pointsColor[i] * (max(dot(n,d),0.) / dot(lights.pointsAtt[i],vec3(dist,dist2,dist2*dist)));
				}
				#if hasVertexColor
					tcolor = col * color;
				#else
					tcolor = col;
				#end
			#elseif hasVertexColor
				tcolor = color;
			#end
			#if hasVertexColorAdd
				acolor = colorAdd;
			#end
			#if hasFog
				vec3 dist = tpos.xyz - fog.xyz;
				talpha = (fog.w * dist.dot(dist).rsqrt()).min(1);
			#end
			#if hasBlend
				tblend = blending;
			#end
			#if hasShadowMap
				tshadowPos = shadowLightCenter * shadowLightProj * tpos;
			#end
		}

	";
	
	static var FRAGMENT = "
	
		varying lowp vec2 tuv;
		varying lowp vec3 tcolor;
		varying lowp vec3 acolor;
		varying mediump float talpha;
		varying mediump float tblend;
		varying mediump vec4 tshadowPos;

		uniform sampler2D tex;
		uniform lowp vec4 colorAdd;
		uniform lowp vec4 colorMul;
		uniform mediump mat4 colorMatrix;
		
		uniform lowp float killAlphaThreshold;

		#if hasAlphaMap
		uniform sampler2D alphaMap;
		#end
		
		#if hasBlend
		uniform sampler2D blendTexture;
		#end

		#if hasGlow
		uniform sampler2D glowTexture;
		uniform float glowAmount;
		#end

		#if hasShadowMap
		uniform sampler2D shadowTexture;
		uniform vec4 shadowColor;
		#end

		void main(void) {
			lowp vec4 c = texture2D(tex, tuv);
			#if hasFog
				c.a *= talpha;
			#end
			#if hasAlphaMap
				c.a *= texture2D(alphaMap, tuv).b;
			#end
			#if killAlpha
				if( c.a - killAlphaThreshold ) discard;
			#end
			#if hasBlend
				c.rgb = c.rgb * (1 - tblend) + tblend * texture2D(blendTexture, tuv).rgb;
			#end
			#if hasColorAdd
				c += colorAdd;
			#end
			#if hasColorMul
				c *= colorMul;
			#end
			#if hasColorMatrix
				c = colorMatrix * c;
			#end
			#if hasVertexColorAdd
				c.rgb += acolor;
			#end
			#if hasFragColor
				c.rgb *= tcolor;
			#end
			#if hasShadowMap
				// ESM filtering
				mediump float shadow = exp( shadowColor.w * (tshadowPos.z - shadowTexture.get(tshadowPos.xy).dot([1, 1 / 255, 1 / (255 * 255), 1 / (255 * 255 * 255)]))).sat();
				c.rgb *= (1 - shadow) * shadowColor.rgb + shadow.xxx;
			#end
			#if hasGlow
				c.rgb += texture2D(glowTexture,tuv).rgb * glowAmount;
			#end
			gl_FragColor = c;
		}

	";


#end
	
}

class MeshMaterial extends Material {

	var mshader : MeshShader;
	
	public var texture : Texture;
	public var glowTexture(get,set) : Texture;
	public var glowAmount(get, set) : Float;
	public var glowColor(get, set) : h3d.Vector;

	public var useMatrixPos : Bool;
	public var uvScale(get,set) : Null<h3d.Vector>;
	public var uvDelta(get,set) : Null<h3d.Vector>;

	public var killAlpha(get,set) : Bool;

	public var hasVertexColor(get, set) : Bool;
	public var hasVertexColorAdd(get,set) : Bool;
	
	public var colorAdd(get,set) : Null<h3d.Vector>;
	public var colorMul(get,set) : Null<h3d.Vector>;
	public var colorMatrix(get,set) : Null<h3d.Matrix>;
	
	public var hasSkin(get,set) : Bool;
	public var skinMatrixes(get,set) : Array<h3d.Matrix>;
	
	public var lightSystem(get, set) : LightSystem;
	
	public var alphaMap(get, set): Texture;
	
	public var fog(get, set) : h3d.Vector;
	public var zBias(get, set) : Null<Float>;
	
	public var blendTexture(get, set) : Texture;
	
	public var killAlphaThreshold(get, set) : Float;
	
	
	public var shadowMap(null, set) : ShadowMap;
	
	public var volumeDecal(default, set) : DecalInfos;
	
	public function new(texture) {
		mshader = new MeshShader();
		super(mshader);
		this.texture = texture;
		useMatrixPos = true;
		killAlphaThreshold = 0.001;
	}
	
	override function clone( ?m : Material ) {
		var m = m == null ? new MeshMaterial(texture) : cast m;
		super.clone(m);
		m.useMatrixPos = useMatrixPos;
		m.uvScale = uvScale;
		m.uvDelta = uvDelta;
		m.killAlpha = killAlpha;
		m.hasVertexColor = hasVertexColor;
		m.hasVertexColorAdd = hasVertexColorAdd;
		m.colorAdd = colorAdd;
		m.colorMul = colorMul;
		m.colorMatrix = colorMatrix;
		m.hasSkin = hasSkin;
		m.skinMatrixes = skinMatrixes;
		m.lightSystem = lightSystem;
		m.alphaMap = alphaMap;
		m.fog = fog;
		m.zBias = zBias;
		m.blendTexture = blendTexture;
		m.killAlphaThreshold = killAlphaThreshold;
		return m;
	}
	
	override function setup( ctx : h3d.scene.RenderContext ) {
		mshader.mpos = useMatrixPos ? ctx.localPos : null;
		mshader.mproj = ctx.camera.m;
		mshader.tex = texture;
		#if flash
		if( mshader.isOutline ) {
			mshader.outlineProj = new h3d.Vector(ctx.camera.mproj._11, ctx.camera.mproj._22);
			mshader.cameraPos = ctx.camera.pos;
		}
		#end
	}
	
	/**
		Set the DXT compression access mode for all textures of this material.
	**/
	public function setDXTSupport( enable : Bool, alpha = false ) {
		#if flash
		if( !enable ) {
			mshader.isDXT1 = false;
			mshader.isDXT5 = false;
		} else {
			mshader.isDXT1 = !alpha;
			mshader.isDXT5 = alpha;
		}
		#else
		throw "Not implemented";
		#end
	}
	
	inline function get_uvScale() {
		return mshader.uvScale;
	}

	inline function set_uvScale(v) {
		return mshader.uvScale = v;
	}

	inline function get_uvDelta() {
		return mshader.uvDelta;
	}

	inline function set_uvDelta(v) {
		return mshader.uvDelta = v;
	}

	inline function get_killAlpha() {
		return mshader.killAlpha;
	}

	inline function set_killAlpha(v) {
		return mshader.killAlpha = v;
	}

	inline function get_colorAdd() {
		return mshader.colorAdd;
	}

	inline function set_colorAdd(v) {
		return mshader.colorAdd = v;
	}

	inline function get_colorMul() {
		return mshader.colorMul;
	}

	inline function set_colorMul(v) {
		return mshader.colorMul = v;
	}

	inline function get_colorMatrix() {
		return mshader.colorMatrix;
	}

	inline function set_colorMatrix(v) {
		return mshader.colorMatrix = v;
	}
	
	inline function get_hasSkin() {
		return mshader.hasSkin;
	}
	
	inline function set_hasSkin(v) {
		return mshader.hasSkin = v;
	}

	inline function get_hasVertexColor() {
		return mshader.hasVertexColor;
	}
	
	inline function set_hasVertexColor(v) {
		return mshader.hasVertexColor = v;
	}
	
	inline function get_hasVertexColorAdd() {
		return mshader.hasVertexColorAdd;
	}
	
	inline function set_hasVertexColorAdd(v) {
		return mshader.hasVertexColorAdd = v;
	}
	
	inline function get_skinMatrixes() {
		return mshader.skinMatrixes;
	}
	
	inline function set_skinMatrixes( v : Array<h3d.Matrix> ) {
		if( v != null && v.length > 35 )
			throw "Maximum 35 bones are allowed for skinning (has "+v.length+")";
		return mshader.skinMatrixes = v;
	}
	
	inline function get_lightSystem() : LightSystem {
		return mshader.lightSystem;
	}

	inline function set_lightSystem(v:LightSystem) {
		if( v != null && hasSkin && v.dirs.length + v.points.length > 6 )
			throw "Maximum 6 lights are allowed with skinning ("+(v.dirs.length+v.points.length)+" set)";
		return mshader.lightSystem = v;
	}
	
	inline function get_alphaMap() {
		return mshader.alphaMap;
	}
	
	inline function set_alphaMap(m) {
		mshader.hasAlphaMap = m != null;
		return mshader.alphaMap = m;
	}
	
	inline function get_zBias() {
		return mshader.hasZBias ? mshader.zBias : null;
	}

	inline function set_zBias(v : Null<Float>) {
		mshader.hasZBias = v != null;
		mshader.zBias = v;
		return v;
	}
	
	inline function get_glowTexture() {
		return mshader.glowTexture;
	}

	inline function set_glowTexture(t) {
		mshader.hasGlow = t != null;
		if( t != null && mshader.glowAmount == null ) mshader.glowAmount = new h3d.Vector(1, 1, 1);
		return mshader.glowTexture = t;
	}
	
	inline function get_glowAmount() {
		if( mshader.glowAmount == null ) mshader.glowAmount = new h3d.Vector(1, 1, 1);
		return mshader.glowAmount.x;
	}

	inline function set_glowAmount(v) {
		if( mshader.glowAmount == null ) mshader.glowAmount = new h3d.Vector(1, 1, 1);
		mshader.glowAmount.set(v, v, v);
		return v;
	}
	
	inline function get_glowColor() {
		if( mshader.glowAmount == null ) mshader.glowAmount = new h3d.Vector(1, 1, 1);
		return mshader.glowAmount;
	}

	inline function set_glowColor(v) {
		return mshader.glowAmount = v;
	}

	inline function get_fog() {
		return mshader.fog;
	}

	inline function set_fog(v) {
		return mshader.fog = v;
	}
	
	inline function get_blendTexture() {
		return mshader.blendTexture;
	}
	
	inline function set_blendTexture(v) {
		mshader.hasBlend = v != null;
		return mshader.blendTexture = v;
	}
	
	inline function get_killAlphaThreshold() {
		return mshader.killAlphaThreshold;
	}
	
	inline function set_killAlphaThreshold(v) {
		return mshader.killAlphaThreshold = v;
	}
	
	inline function set_shadowMap(v:ShadowMap) {
		if( v != null ) {
			mshader.hasShadowMap = true;
			mshader.shadowColor = v.color;
			mshader.shadowTexture = v.texture;
			mshader.shadowLightProj = v.lightProj;
			mshader.shadowLightCenter = v.lightCenter;
		} else
			mshader.hasShadowMap = false;
		return v;
	}
	
	inline function set_volumeDecal( d : DecalInfos ) {
		if( d != null ) {
			mshader.isDecal = true;
			mshader.depthTexture = d.depthTexture;
			mshader.uvScaleRatio = d.uvScaleRatio;
			mshader.screenToLocal = d.screenToLocal;
		} else
			mshader.isDecal = false;
		return volumeDecal = d;
	}
	
	#if flash

	public var isOutline(get, set) : Bool;
	public var outlineColor(get, set) : Int;
	public var outlineSize(get, set) : Float;
	public var outlinePower(get, set) : Float;
	
	inline function get_isOutline() {
		return mshader.isOutline;
	}
	
	inline function set_isOutline(v) {
		return mshader.isOutline = v;
	}

	inline function get_outlineColor() {
		return mshader.outlineColor;
	}
	
	inline function set_outlineColor(v) {
		return mshader.outlineColor = v;
	}

	inline function get_outlineSize() {
		return mshader.outlineSize;
	}
	
	inline function set_outlineSize(v) {
		return mshader.outlineSize = v;
	}

	inline function get_outlinePower() {
		return mshader.outlinePower;
	}
	
	inline function set_outlinePower(v) {
		return mshader.outlinePower = v;
	}
	
	public function setColorMap( texture, ?matrix ) {
		mshader.hasColorMap = texture != null;
		mshader.colorMap = texture;
		mshader.colorMapMatrix = matrix;
	}
	
	public function enableSmoothEdges( factor : Float, depthTexture ) {
		mshader.smoothEdges = true;
		mshader.smoothFactor = factor;
		mshader.depthTexture = depthTexture;
	}
	
	#end
}
