// shader setup:
	
if( globals.constModified || shader.constModified ) {
	shader.syncGlobalConsts(globals);
	// will get/build an instance based on globals + const bits
	// the instance is the eval'd version of the shader and has an unique ID
}
instances.push(shader.instance);

// get/build a linked shader based on the unique instance identifiers and outputs
// make sure that it's unique (use md5(toString) to prevent dups)
var linked = getLinkedVersion(instances, ["output.pos", "output.color"]);

shaders.sort(sortByLinkedId)
for( s in linked ) {
	if( s != prevId ) {
		selectShader(s);
		uploadParams(s.buildGlobals(globals));
	}
	// handle params and per-object globals (modelView, modelViewInv)
	uploadParams(s.buildParams(globals));
	render();g
}

// CHECK HOW RENDER PASS ARE DONE

var passes : Map< String, Array<ObjectPass> > = collecObjectPasses();
for( m in allPasses ) {
	var objs = passes.get(m.name);
	m.render(objs);
}

function renderPass() {
	for( op in objectPasses ) {
		op.pass.setup(...);
		op.pass.assemble();
	}
	objectPass.sort(sortByShaderID);
	beginPass();
	for( op in objectPasses ) {
		engine.selectPass(op.pass);
		op.primitive.render();
	}
	endPass();
}

// ----------------------------
// on mesh, passes are referenced by their name, not by a concrete object (decouple local setup from global one)

var m = new Mesh(prim).material;

(color white by default)
m.texture = mytexture; // add the TextureShader on pass[0] if not already added
m.addShader(new TextureMap(tex2)).additive = true; // second texture with additive
m.castShadows = true; // add/remove the "shadowMap" pass with DepthShader
m.receiveShadows = false; //add/remove the ShadowShader on pass[0]

m.blendMode = Normal | Alpha | Additive
	will set m.pass[0].name to "default" | "alpha" | "additive" and blendSrc/blendDst as well
	-> blend / depth / culling / color are now in Pass properties, not in Material
	
mesh.addPass("outline",true/*inherit*/).addShader(new OutlineShader({ params }));
mesh.removePass("outline");

// on Scene, global setup as Array of passes

var passes = scene.passes;
passes.push(new ShadowMapPass("shadowMap",2048,...));

Pass :
	name : String; // a quel pass il s'execute
	parentPass : inherit des modifiers (null si on ne veux pas garder les transforms par exemple)
	shaders : Array<Shader> // this pass modifier
	blendSrc/Dst
	depthTest/Write
	culling
	colorMask

ObjectPass:
	pass : Pass (params already set)
	prim : Primitive
	obj : Object (for absPos, invAbsPos and error reporting)

how are "globals" injected ?
	before a pass is rendered, each pass is setup() using the current pass globals + the object specific globals
	--> each pass can reinterpret the globals (eg : ShadowMap uses Light instead of Camera)
	it is then assembled at pass rendering time (not before)
	--> we need to know the pass output variable, global list and output selection to do so


	