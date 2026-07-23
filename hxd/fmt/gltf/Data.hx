package hxd.fmt.gltf;

typedef GltfDocument = {
    asset: GltfAsset,
    ?scene: Int,
    ?scenes: Array<GltfScene>,
    // ?nodes: Array<GltfNode>,
    // ?meshes: Array<GltfMesh>,
    // ?accessors: Array<GltfAccessor>,
    // ?bufferViews: Array<GltfBufferView>,
    // ?buffers: Array<GltfBuffer>,
    // ?materials: Array<GltfMaterial>,
    // ?textures: Array<GltfTexture>,
    // ?images: Array<GltfImage>,
    // ?samplers: Array<GltfSampler>,
    // ?animations: Array<GltfAnimation>,
    // ?skins: Array<GltfSkin>,
    // ?cameras: Array<GltfCamera>,
    // ?extensionsUsed: Array<String>,
    // ?extensionsRequired: Array<String>
}

typedef GltfAsset = {
    version: String,
    ?generator: String,
    ?copyright: String,
    ?minVersion: String
}

typedef GltfScene = {
    ?name: String,
    ?nodes: Array<Int>  // indices de nodes racine
}

typedef GltfNode = {
    ?name: String,
    ?children: Array<Int>,     // indices d'autres nodes
    ?mesh: Int,                 // index dans "meshes"
    ?skin: Int,
    ?camera: Int,
    // soit matrix, soit TRS séparé :
    ?matrix: Array<Float>,      // 16 floats
    ?translation: Array<Float>, // [x,y,z]
    ?rotation: Array<Float>,    // quaternion [x,y,z,w]
    ?scale: Array<Float>        // [x,y,z]
}

typedef GltfMesh = {
    ?name: String,
    primitives: Array<GltfPrimitive>
}

typedef GltfPrimitive = {
    attributes: {
        ?POSITION: Int,
        ?NORMAL: Int,
        ?TEXCOORD_0: Int,
        ?TANGENT: Int,
        ?COLOR_0: Int
        // etc, ce sont tous des indices vers "accessors"
    },
    ?indices: Int,      // index accessor pour les indices de triangles
    ?material: Int,      // index vers "materials"
    ?mode: Int            // 4 = TRIANGLES par défaut
}

typedef GltfAccessor = {
    ?bufferView: Int,
    ?byteOffset: Int,     // défaut 0
    componentType: Int,   // 5126=FLOAT, 5123=UNSIGNED_SHORT, 5125=UNSIGNED_INT...
    count: Int,
    type: String,          // "SCALAR", "VEC2", "VEC3", "VEC4", "MAT4"
    ?normalized: Bool,
    ?min: Array<Float>,
    ?max: Array<Float>
}

typedef GltfBufferView = {
    buffer: Int,
    ?byteOffset: Int,
    byteLength: Int,
    ?byteStride: Int,
    ?target: Int   // 34962=ARRAY_BUFFER, 34963=ELEMENT_ARRAY_BUFFER
}

typedef GltfBuffer = {
    ?uri: String,      // absent si c'est le chunk BIN du glb
    byteLength: Int
}

class GltfTools {

}