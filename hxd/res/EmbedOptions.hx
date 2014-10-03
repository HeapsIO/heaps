package hxd.res;

typedef EmbedOptions = {
	?compressSounds : Bool,
	?createXBX : Bool,
	?xbxFilter : String -> hxd.fmt.fbx.Data.FbxNode -> hxd.fmt.fbx.Data.FbxNode,
	?createH3D : Bool,
	?tmpDir : String,
	?fontsChars : String,
}