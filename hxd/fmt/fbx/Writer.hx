package hxd.fmt.fbx;

import hxd.fmt.fbx.Data;
import hxd.fmt.hmd.Data;

class Writer {
	var out: haxe.io.Output;

	public function new(out) {
		this.out = out;
	}

	function resolvePathImpl( modelPath : String, filePath : String ) {
		#if editor
		inline function exists(path) return File.exists(path);
		var fullPath = hide.Ide.inst.getPath(filePath);
		if( exists(fullPath) )
			return fullPath;

		// swap drive letter
		if( fullPath.charAt(1) == ":" && fullPath.charAt(0) != hide.Ide.inst.projectDir.charAt(0) ) {
			fullPath = hide.Ide.inst.projectDir.charAt(0) + fullPath.substr(1);
			if( exists(fullPath) )
				return fullPath;
		}

		if( modelPath == null )
			return null;

		filePath = filePath.split("\\").join("/");
		modelPath = hide.Ide.inst.getPath(modelPath);

		var path = modelPath.split("/");
		path.pop();
		var relToModel = path.join("/") + "/" + filePath.split("/").pop();
		if( exists(relToModel) )
			return relToModel;

		return null;
		#end
		return filePath;
	}

	function getTabFormat(depth:Int) {
		return '${StringTools.rpad("", '\t', depth)}';
	}

	function writeNode(n:FbxNode, depth:Int = 0) {
		out.writeString('${getTabFormat(depth)}${n.name}:');

		if (n.props != null && n.props.length > 0) {
			for (idx => p in n.props) {
				out.writeString('${idx != 0 ? ',' : ''}${(p.match(PInt(_)) || p.match(PFloat(_))) && idx != 0 ? '' : ' '}${writeProperty(p, depth)}');
			}
		}

		if (n.childs == null || n.childs.length <= 0)
			out.writeString('\n');
		else {
			out.writeString(' {\n');
			for (c in n.childs) {
				writeNode(c, depth + 1);
			}
			out.writeString('${getTabFormat(depth)}}\n');
		}
	}

	function writeProperty(p:FbxProp, depth:Int) {
		switch (p) {
			case PInt(v):
				return Std.string(v);

			case PFloat(v):
				return Std.string(v);

			case PString(v):
				return '"${v}"';

			case PIdent(i):
				return i;

			case PInts(v):
				{
					var res = '*${v.length} {\n';
					res += '${getTabFormat(depth + 1)}a: ';

					for (idx => i in v) {
						res += '${idx != 0 ? ',' : ''}${i}';
					}

					res += '\n${getTabFormat(depth)}}';
					return res;
				}

			case PFloats(v):
				{
					var res = '*${v.length} {\n';
					res += '${getTabFormat(depth + 1)}a: ';

					for (idx => i in v) {
						res += '${idx != 0 ? ',' : ''}${i}';
					}

					res += '\n${getTabFormat(depth)}}';
					return res;
				}

			default:
				return "Unsupported data";
		}
	}

	function writeHeader() {
		// This header is mandatory for most importers to define the fbx version
		// of the file
		var fbxVersion = "7.3.0";
		out.writeString('; FBX ${fbxVersion} project file\n');
		out.writeString('; Copyright (C) 1997-2010 Autodesk Inc. and/or its licensors.\n');
		out.writeString('; All rights reserved.\n');
		out.writeString('; ----------------------------------------------------\n');
		out.writeString('\n');
	}

	function buildHeaderExtension() : FbxNode {
		var date = Date.now();
		var header : FbxNode = { name: "FBXHeaderExtension", props: null, childs: [
			{ name: "FBXHeaderVersion", props: [PInt(1003)], childs: null },
			{ name: "FBXVersion", props: [PInt(7003)], childs: null },
			{ name: "CreationTimeStamp", props: null, childs:[
				{ name: "Version", props:[PInt(1000)], childs:null },
				{ name: "Year", props:[PInt(date.getFullYear())], childs:null },
				{ name: "Month", props:[PInt(date.getMonth())], childs:null },
				{ name: "Day", props:[PInt(date.getDay())], childs:null },
				{ name: "Hour", props:[PInt(date.getHours())], childs:null },
				{ name: "Minute", props:[PInt(date.getMinutes())], childs:null },
				{ name: "Second", props:[PInt(date.getSeconds())], childs:null },
				{ name: "Millisecond", props:[PInt(0)], childs:null}
			] },
			{ name: "Creator", props: [PString("")], childs: null },
			{ name: "SceneInfo", props: [PString("SceneInfo::GlobalInfo"), PString("UserData")], childs: [
				{ name : "Type", props: [PString("UserData")], childs: null },
				{ name : "Version", props: [PInt(100)], childs: null },
				{ name:"MetaData", props:null, childs: [
					{ name:"Version", props:[PInt(100)], childs: [] },
					{ name:"Title", props:[PString("")], childs: [] },
					{ name:"Subject", props:[PString("")], childs: [] },
					{ name:"Author", props:[PString("")], childs: [] },
					{ name:"Keywords", props:[PString("")], childs: [] },
					{ name:"Revision", props:[PString("")], childs: [] },
					{ name:"Comment", props:[PString("")], childs: [] }
				] },
				{ name:"Properties70", props: null, childs:[
					{ name:"P", props:[PString("DocumentUrl"), PString("KString"), PString("Url"), PString(""), PString("C:\\")], childs:null },
					{ name:"P", props:[PString("SrcDocumentUrl"), PString("KString"), PString("Url"), PString(""), PString("C:\\")], childs:null },
					{ name:"P", props:[PString("Original"), PString("Compound"), PString(""), PString("")], childs:null },
					{ name:"P", props:[PString("Original|ApplicationVendor"), PString("KString"), PString(""), PString(""), PString("")], childs:null },
					{ name:"P", props:[PString("Original|ApplicationName"), PString("KString"), PString(""), PString(""), PString("")], childs:null },
					{ name:"P", props:[PString("Original|ApplicationVersion"), PString("KString"), PString(""), PString(""), PString("")], childs:null },
					{ name:"P", props:[PString("Original|DateTime_GMT"), PString("DateTime"), PString(""), PString(""), PString("01/01/1970 00:00:00.000")], childs:null },
					{ name:"P", props:[PString("Original|FileName"), PString("KString"), PString(""), PString(""), PString("/foobar.fbx")], childs:null },
					{ name:"P", props:[PString("LastSaved"), PString("Compound"), PString(""), PString("")], childs:null },
					{ name:"P", props:[PString("LastSaved|ApplicationVendor"), PString("KString"), PString(""), PString(""), PString("")], childs:null },
					{ name:"P", props:[PString("LastSaved|ApplicationVersion"), PString("KString"), PString(""), PString(""), PString("")], childs:null },
					{ name:"P", props:[PString("LastSaved|DateTime_GMT"), PString("DateTime"), PString(""), PString(""), PString("01/01/1970 00:00:00.000")], childs:null },
					{ name:"P", props:[PString("Original|ApplicationNativeFile"), PString("KString"), PString(""), PString(""), PString("")], childs:null },
				] }
			] } ]
		};

		return header;
	}

	function buildGlobalSettings() {
		var globalSettings : FbxNode = { name:"GlobalSettings", props: null, childs: [
			{ name:"Version", props: [PInt(1000)], childs: null },
			{ name:"Properties70", props: null, childs: [
				{ name: "P", props: [PString("UpAxis"), PString("int"), PString("Integer"), PString(""), PInt(2) ], childs:null },
				{ name: "P", props: [PString("UpAxisSign"), PString("int"), PString("Integer"), PString(""), PInt(1) ], childs:null },
				{ name: "P", props: [PString("FrontAxis"), PString("int"), PString("Integer"), PString(""), PInt(0) ], childs:null },
				{ name: "P", props: [PString("FrontAxisSign"), PString("int"), PString("Integer"), PString(""), PInt(-1) ], childs:null },
				{ name: "P", props: [PString("CoordAxis"), PString("int"), PString("Integer"), PString(""), PInt(1) ], childs:null },
				{ name: "P", props: [PString("CoordAxisSign"), PString("int"), PString("Integer"), PString(""), PInt(-1) ], childs:null },
				{ name: "P", props: [PString("OriginalUpAxis"), PString("int"), PString("Integer"), PString(""), PInt(-1) ], childs:null },
				{ name: "P", props: [PString("OriginalUpAxisSign"), PString("int"), PString("Integer"), PString(""), PInt(1) ], childs:null },
				{ name: "P", props: [PString("UnitScaleFactor"), PString("double"), PString("Number"), PString(""), PInt(100) ], childs:null },
				{ name: "P", props: [PString("OriginalUnitScaleFactor"), PString("double"), PString("Number"), PString(""), PInt(1) ], childs:null },
				{ name: "P", props: [PString("AmbientColor"), PString("ColorRGB"), PString("Color"), PString(""), PInt(0), PInt(0), PInt(0) ], childs:null },
				{ name: "P", props: [PString("DefaultCamera"), PString("KString"), PString(""), PString(""), PString("Producer Perspective") ], childs:null },
				{ name: "P", props: [PString("TimeMode"), PString("enum"), PString(""), PString(""), PInt(11) ], childs:null },
				{ name: "P", props: [PString("TimeSpanStart"), PString("Ktime"), PString("Time"), PString(""), PInt(0) ], childs:null },
				{ name: "P", props: [PString("TimeSpanStop"), PString("Ktime"), PString("Time"), PString(""), PInt(0) ], childs:null },
				{ name: "P", props: [PString("CustomFrameRate"), PString("double"), PString("Number"), PString(""), PInt(24) ], childs:null },
			] }
		] };

		return globalSettings;
	}

	function buildDefinitions(objects: Array<h3d.scene.Object>) {
		var materialsIds = new Array<String>();
		var defCount = 1;
		var meshCount = 0;
		var materialCount = 0;
		var textureCount = 0;

		var meshes = [];
		for (o in objects) {
			var meshes = o.getMeshes();
			meshCount += meshes.length;

			for (m in meshes) {
				if (materialsIds.contains(m.name))
					continue;

				materialsIds.push(m.name);
				materialCount += m.getMaterials().length;

				if (m.material.texture != null)
					textureCount++;

				if (m.material.normalMap != null)
					textureCount++;

				if (m.material.specularTexture != null)
					textureCount++;
			}
		}

		var defGlobalSettings : FbxNode = { name:"ObjectType", props:[PString("GlobalSettings")], childs: [
			{ name: "Count", props: [PInt(1)], childs: null }
		] };
		defCount += 1;

		var modelCount = meshCount;
		var defModel : FbxNode = { name:"ObjectType", props:[PString("Model")], childs: [
			{ name: "Count", props: [PInt(modelCount)], childs: null },
			{ name: "PropertyTemplate", props: [PString("FbxNode")], childs: [
				{ name:"Properties70", props: null, childs: [
					{ name: "P", props: [PString("QuaternionInterpolate"), PString("enum"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("RotationOffset"), PString("Vector3D"), PString("Vector"), PString(""), PInt(0), PInt(0), PInt(0)], childs:null },
					{ name: "P", props: [PString("RotationPivot"), PString("Vector3D"), PString("Vector"), PString(""), PInt(0), PInt(0), PInt(0)], childs:null },
					{ name: "P", props: [PString("ScalingOffset"), PString("Vector3D"), PString("Vector"), PString(""), PInt(0), PInt(0), PInt(0)], childs:null },
					{ name: "P", props: [PString("ScalingPivot"), PString("Vector3D"), PString("Vector"), PString(""), PInt(0), PInt(0), PInt(0)], childs:null },
					{ name: "P", props: [PString("TranslationActive"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("TranslationMin"), PString("Vector3D"), PString("Vector"), PString(""), PInt(0), PInt(0), PInt(0)], childs:null },
					{ name: "P", props: [PString("TranslationMax"), PString("Vector3D"), PString("Vector"), PString(""), PInt(0), PInt(0), PInt(0)], childs:null },
					{ name: "P", props: [PString("TranslationMinX"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("TranslationMinY"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("TranslationMinZ"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("TranslationMaxX"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("TranslationMaxY"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("TranslationMaxZ"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("RotationOrder"), PString("enum"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("RotationSpaceForLimitOnly"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("RotationStiffnessX"), PString("double"), PString("Number"), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("RotationStiffnessY"), PString("double"), PString("Number"), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("RotationStiffnessZ"), PString("double"), PString("Number"), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("AxisLen"), PString("double"), PString("Number"), PString(""), PInt(10)], childs:null },
					{ name: "P", props: [PString("PreRotation"), PString("Vector3D"), PString("Vector"), PString(""), PInt(0), PInt(0), PInt(0)], childs:null },
					{ name: "P", props: [PString("PostRotation"), PString("Vector3D"), PString("Vector"), PString(""), PInt(0), PInt(0), PInt(0)], childs:null },
					{ name: "P", props: [PString("RotationActive"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("RotationMin"), PString("Vector3D"), PString("Vector"), PString(""), PInt(0), PInt(0), PInt(0)], childs:null },
					{ name: "P", props: [PString("RotationMax"), PString("Vector3D"), PString("Vector"), PString(""), PInt(0), PInt(0), PInt(0)], childs:null },
					{ name: "P", props: [PString("RotationMinX"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("RotationMinY"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("RotationMinZ"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("RotationMaxX"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("RotationMaxY"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("RotationMaxZ"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("InheritType"), PString("enum"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("ScalingActive"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("ScalingMin"), PString("Vector3D"), PString("Vector"), PString(""), PInt(0), PInt(0), PInt(0)], childs:null },
					{ name: "P", props: [PString("ScalingMax"), PString("Vector3D"), PString("Vector"), PString(""), PInt(1), PInt(1), PInt(1)], childs:null },
					{ name: "P", props: [PString("ScalingMinX"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("ScalingMinY"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("ScalingMinZ"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("ScalingMaxX"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("ScalingMaxY"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("ScalingMaxZ"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("GeometricTranslation"), PString("Vector3D"), PString("Vector"), PString(""), PInt(0), PInt(0), PInt(0)], childs:null },
					{ name: "P", props: [PString("GeometricRotation"), PString("Vector3D"), PString("Vector"), PString(""), PInt(0), PInt(0), PInt(0)], childs:null },
					{ name: "P", props: [PString("GeometricScaling"), PString("Vector3D"), PString("Vector"), PString(""), PInt(1), PInt(1), PInt(1)], childs:null },
					{ name: "P", props: [PString("MinDampRangeX"), PString("double"), PString("Number"), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("MinDampRangeY"), PString("double"), PString("Number"), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("MinDampRangeZ"), PString("double"), PString("Number"), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("MaxDampRangeX"), PString("double"), PString("Number"), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("MaxDampRangeY"), PString("double"), PString("Number"), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("MaxDampRangeZ"), PString("double"), PString("Number"), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("MinDampStrengthX"), PString("double"), PString("Number"), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("MinDampStrengthY"), PString("double"), PString("Number"), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("MinDampStrengthZ"), PString("double"), PString("Number"), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("MaxDampStrengthX"), PString("double"), PString("Number"), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("MaxDampStrengthY"), PString("double"), PString("Number"), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("MaxDampStrengthZ"), PString("double"), PString("Number"), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("PreferedAngleX"), PString("double"), PString("Number"), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("PreferedAngleY"), PString("double"), PString("Number"), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("PreferedAngleZ"), PString("double"), PString("Number"), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("LookAtProperty"), PString("object"), PString(""), PString("")], childs:null },
					{ name: "P", props: [PString("UpVectorProperty"), PString("object"), PString(""), PString("")], childs:null },
					{ name: "P", props: [PString("Show"), PString("bool"), PString(""), PString(""), PInt(1)], childs:null },
					{ name: "P", props: [PString("NegativePercentShapeSupport"), PString("bool"), PString(""), PString(""), PInt(1)], childs:null },
					{ name: "P", props: [PString("DefaultAttributeIndex"), PString("int"), PString("Integer"), PString(""), PInt(-1)], childs:null },
					{ name: "P", props: [PString("Freeze"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("LODBox"), PString("bool"), PString(""), PString(""), PInt(0)], childs:null },
					{ name: "P", props: [PString("Lcl Translation"), PString("Lcl Translation"), PString(""), PString("A"), PInt(0), PInt(0), PInt(0)], childs:null },
					{ name: "P", props: [PString("Lcl Rotation"), PString("Lcl Rotation"), PString(""), PString("A"), PInt(0), PInt(0), PInt(0)], childs:null },
					{ name: "P", props: [PString("Lcl Scaling"), PString("Lcl Scaling"), PString(""), PString("A"), PInt(1), PInt(1), PInt(1)], childs:null },
					{ name: "P", props: [PString("Visibility"), PString("Visibility"), PString(""), PString("A"), PInt(1)], childs:null },
					{ name: "P", props: [PString("Visibility Inheritance"), PString("Visibility Inheritance"), PString(""), PString(""), PInt(1)], childs:null },
				] }
			] }
		] };
		defCount += modelCount;

		var geometryCount = meshCount;
		var defGeometry : FbxNode = { name:"ObjectType", props:[PString("Geometry")], childs: [
			{ name: "Count", props: [PInt(geometryCount)], childs: null },
			{ name: "PropertyTemplate", props: [PString("FbxMesh")], childs: [
					{ name:"Properties70", props: null, childs: [
					{ name: "P", props: [PString("Color"), PString("ColorRGB"), PString("Color"), PString(""), PFloat(0.8), PFloat(0.8), PFloat(0.8)], childs: null },
					{ name: "P", props: [PString("BBoxMin"), PString("Vector3D"), PString("Vector"), PString(""), PInt(0), PInt(0), PInt(0)], childs: null },
					{ name: "P", props: [PString("BBoxMax"), PString("Vector3D"), PString("Vector"), PString(""), PInt(0), PInt(0), PInt(0)], childs: null },
					{ name: "P", props: [PString("Primary Visibility"), PString("bool"), PString(""), PString(""), PInt(1)], childs: null },
					{ name: "P", props: [PString("Casts Shadows"), PString("bool"), PString(""), PString(""), PInt(1)], childs: null },
					{ name: "P", props: [PString("Receive Shadows"), PString("bool"), PString(""), PString(""), PInt(1)], childs: null },
				] }
			] }
		] };
		defCount += geometryCount;

		var defMaterial : FbxNode = { name:"ObjectType", props:[PString("Material")], childs: [
			{ name: "Count", props: [PInt(materialCount)], childs: null },
			{ name: "PropertyTemplate", props: [PString("FbxSurfacePhong")], childs: [
					{ name:"Properties70", props: null, childs: [
					{ name: "P", props: [PString("ShadingModel"), PString("KString"), PString(""), PString(""), PString("Phong")], childs: null },
					{ name: "P", props: [PString("MultiLayer"), PString("bool"), PString(""), PString(""), PInt(0)], childs: null },
					{ name: "P", props: [PString("EmissiveColor"), PString("Color"), PString(""), PString("A"), PInt(0), PInt(0), PInt(0)], childs: null },
					{ name: "P", props: [PString("EmissiveFactor"), PString("Number"), PString(""), PString("A"), PInt(1)], childs: null },
					{ name: "P", props: [PString("AmbientColor"), PString("Color"), PString(""), PString("A"), PFloat(0.2), PFloat(0.2), PFloat(0.2)], childs: null },
					{ name: "P", props: [PString("AmbientFactor"), PString("Number"), PString(""), PString("A"), PInt(1)], childs: null },
					{ name: "P", props: [PString("DiffuseColor"), PString("Color"), PString(""), PString("A"), PFloat(0.8), PFloat(0.8), PFloat(0.8)], childs: null },
					{ name: "P", props: [PString("DiffuseFactor"), PString("Number"), PString(""), PString("A"), PInt(1)], childs: null },
					{ name: "P", props: [PString("Bump"), PString("Vector3D"), PString("Vector"), PString(""), PInt(0), PInt(0), PInt(0)], childs: null },
					{ name: "P", props: [PString("NormalMap"), PString("Vector3D"), PString("Vector"), PString(""), PInt(0), PInt(0), PInt(0)], childs: null },
					{ name: "P", props: [PString("BumpFactor"), PString("double"), PString("Number"), PString(""), PInt(1)], childs: null },
					{ name: "P", props: [PString("TransparentColor"), PString("Color"), PString(""), PString("A"), PInt(0), PInt(0), PInt(0)], childs: null },
					{ name: "P", props: [PString("TransparencyFactor"), PString("Number"), PString(""), PString("A"), PInt(0)], childs: null },
					{ name: "P", props: [PString("DisplacementColor"), PString("ColorRGB"), PString("Color"), PString(""), PInt(0), PInt(0), PInt(0)], childs: null },
					{ name: "P", props: [PString("DisplacementFactor"), PString("double"), PString("Number"), PString(""), PInt(1)], childs: null },
					{ name: "P", props: [PString("VectorDisplacementColor"), PString("ColorRGB"), PString("Color"), PString(""), PInt(0), PInt(0), PInt(0)], childs: null },
					{ name: "P", props: [PString("VectorDisplacementFactor"), PString("double"), PString("Number"), PString(""), PInt(1)], childs: null },
					{ name: "P", props: [PString("SpecularColor"), PString("Color"), PString(""), PString("A"), PFloat(0.2), PFloat(0.2), PFloat(0.2)], childs: null },
					{ name: "P", props: [PString("SpecularFactor"), PString("Number"), PString(""), PString("A"), PInt(1)], childs: null },
					{ name: "P", props: [PString("ShininessExponent"), PString("Number"), PString(""), PString("A"), PInt(20)], childs: null },
					{ name: "P", props: [PString("ReflectionColor"), PString("Color"), PString(""), PString("A"), PInt(0), PInt(0), PInt(0)], childs: null },
					{ name: "P", props: [PString("ReflectionFactor"), PString("Number"), PString(""), PString("A"), PInt(1)], childs: null },
				]}
			] },
		] };
		defCount += materialCount;

		var definitions : FbxNode = { name:"Definitions", props: null, childs: [
			{ name: "Version", props: [PInt(100)], childs: null },
			{ name: "Count", props: [PInt(defCount)], childs: null },
			defGlobalSettings,
			defModel,
			defGeometry,
			defMaterial
		]};

		if ( textureCount != 0 ) {
			var defTexture : FbxNode = { name:"ObjectType", props:[PString("Texture")], childs: [
				{ name: "Count", props: [PInt(textureCount)], childs: null },
				{ name: "PropertyTemplate", props: [PString("FbxFileTexture")], childs: [
						{ name:"Properties70", props: null, childs: [
						{ name: "P", props: [PString("TextureTypeUse"), PString("enum"), PString(""), PString(""), PInt(0)], childs: null },
						{ name: "P", props: [PString("Texture alpha"), PString("Number"), PString(""), PString("A"), PFloat(1)], childs: null },
						{ name: "P", props: [PString("CurrentMappingType"), PString("enum"), PString(""), PString(""), PInt(0)], childs: null },
						{ name: "P", props: [PString("WrapModeU"), PString("enum"), PString(""), PString(""), PInt(0)], childs: null },
						{ name: "P", props: [PString("WrapModeV"), PString("enum"), PString(""), PString(""), PInt(0)], childs: null },
						{ name: "P", props: [PString("UVSwap"), PString("bool"), PString(""), PString(""), PInt(0)], childs: null },
						{ name: "P", props: [PString("PremultiplyAlpha"), PString("bool"), PString(""), PString(""), PInt(1)], childs: null },
						{ name: "P", props: [PString("Translation"), PString("Vector"), PString(""), PString("A"), PFloat(0), PFloat(0), PFloat(0)], childs: null },
						{ name: "P", props: [PString("Rotation"), PString("Vector"), PString(""), PString("A"), PFloat(0), PFloat(0), PFloat(0)], childs: null },
						{ name: "P", props: [PString("Scaling"), PString("Vector"), PString(""), PString("A"), PFloat(1), PFloat(1), PFloat(1)], childs: null },
						{ name: "P", props: [PString("TextureRotationPivot"), PString("Vector3D"), PString("Vector"), PString(""), PFloat(0), PFloat(0), PFloat(0)], childs: null },
						{ name: "P", props: [PString("TextureScalingPivot"), PString("Vector3D"), PString("Vector"), PString(""), PFloat(0), PFloat(0), PFloat(0)], childs: null },
						{ name: "P", props: [PString("CurrentTextureBlendMode"), PString("enum"), PString(""), PString(""), PInt(1)], childs: null },
						{ name: "P", props: [PString("UVSet"), PString("KString"), PString(""), PString(""), PString("default")], childs: null },
						{ name: "P", props: [PString("UseMaterial"), PString("bool"), PString(""), PString(""), PInt(0)], childs: null },
						{ name: "P", props: [PString("UseMipMap"), PString("bool"), PString(""), PString(""), PInt(0)], childs: null },
					]}
				] },
			] };
			defCount += textureCount;

			var videoCount = textureCount;
			var defVideo : FbxNode = { name:"ObjectType", props:[PString("FbxVideo")], childs: [
				{ name: "Count", props: [PInt(videoCount)], childs: null },
				{ name: "PropertyTemplate", props: [PString("FbxFileTexture")], childs: [
						{ name:"Properties70", props: null, childs: [
						{ name: "P", props: [PString("ImageSequence"), PString("bool"), PString(""), PString(""), PInt(0)], childs: null },
						{ name: "P", props: [PString("ImageSequenceOffset"), PString("int"), PString("Integer"), PString(""), PInt(0)], childs: null },
						{ name: "P", props: [PString("FrameRate"), PString("double"), PString("Number"), PString(""), PInt(0)], childs: null },
						{ name: "P", props: [PString("LastFrame"), PString("int"), PString("Integer"), PString(""), PInt(0)], childs: null },
						{ name: "P", props: [PString("Width"), PString("int"), PString("Integer"), PString(""), PInt(0)], childs: null },
						{ name: "P", props: [PString("Height"), PString("int"), PString("Integer"), PString(""), PInt(0)], childs: null },
						{ name: "P", props: [PString("Path"), PString("KString"), PString("XRefUrl"), PString(""), PString("")], childs: null },
						{ name: "P", props: [PString("StartFrame"), PString("int"), PString("Integer"), PString(""), PInt(0)], childs: null },
						{ name: "P", props: [PString("StopFrame"), PString("int"), PString("Integer"), PString(""), PInt(0)], childs: null },
						{ name: "P", props: [PString("PlaySpeed"), PString("double"), PString("Number"), PString(""), PInt(0)], childs: null },
						{ name: "P", props: [PString("Offset"), PString("Ktime"), PString("Time"), PString(""), PInt(0)], childs: null },
						{ name: "P", props: [PString("InterlaceMode"), PString("enum"), PString(""), PString(""), PInt(0)], childs: null },
						{ name: "P", props: [PString("FreeRunning"), PString("bool"), PString(""), PString(""), PInt(0)], childs: null },
						{ name: "P", props: [PString("Loop"), PString("bool"), PString(""), PString(""), PInt(0)], childs: null },
						{ name: "P", props: [PString("AccessMode"), PString("bool"), PString(""), PString(""), PInt(0)], childs: null },
					]}
				] },
			] };

			defCount += videoCount;

			definitions.childs.push(defTexture);
			definitions.childs.push(defVideo);
		}

		return definitions;
	}

	function buildObjects(objects: Array<h3d.scene.Object>, params : Dynamic, objectRegistry : Array<Dynamic>) {
		var objectsNode : FbxNode = { name: "Objects", props: null, childs: [] };
		var nextFreeId = 1;

		function getUniqueId() {
			nextFreeId++;
			return nextFreeId - 1;
		}

		function buildObject(object : h3d.scene.Object, params : Dynamic, isRoot : Bool) {
			var modelId = getUniqueId();
			var modelTransform = object.getTransform();

			// We add some extra rotations to the default transform to handle
			// the export on different axis
			if (isRoot) {
				var q = new h3d.Quat();

				if (params.forward == "0" && params.forwardSign== "1" && params.up == "2" && params.upSign == "1")
					q.initRotation(0,0,0);
				else if (params.forward == "0" && params.forwardSign== "-1" && params.up == "2" && params.upSign == "1")
					q.initRotation(0,0,Math.degToRad(90));
				else
					throw "Export params not yet implemented";

				modelTransform = modelTransform.multiplied(q.toMatrix());
			}

			// Apply the default transform of the mode on the current transform to
			// get the real transform
			if (object.defaultTransform != null)
				modelTransform = object.defaultTransform.multiplied(modelTransform);

			// Convert left hand matrix to right hand matrix
			modelTransform._12 = -modelTransform._12;
			modelTransform._13 = -modelTransform._13;
			modelTransform._21 = -modelTransform._21;
			modelTransform._31 = -modelTransform._31;
			modelTransform._41 = -modelTransform._41;

			// The model node is used for every object, not only those we have mesh
			var model : FbxNode = { name:"Model", props: [PInt(modelId), PString('Model::${object.name}'), PString("Mesh")], childs:[
				{ name:"Version", props:[ PInt(232)], childs:null },
				{ name:"Properties70", props: null, childs: [
					{ name:"P", props:[PString("InheritType"), PString("enum"), PString(""), PString(""), PInt(1)], childs: null },
					{ name:"P", props:[PString("DefaultAttributeIndex"), PString("int"), PString("Integer"), PString(""), PInt(0)], childs: null },
					{ name:"P", props:[PString("Lcl Translation"), PString("Lcl Translation"), PString(""), PString("A"), PFloat(modelTransform.getPosition().x), PFloat(modelTransform.getPosition().y), PFloat(modelTransform.getPosition().z)], childs: null },
					{ name:"P", props:[PString("Lcl Rotation"), PString("Lcl Rotation"), PString(""), PString("A"), PFloat(Math.radToDeg(modelTransform.getEulerAngles().x)), PFloat(Math.radToDeg(modelTransform.getEulerAngles().y)), PFloat(Math.radToDeg(modelTransform.getEulerAngles().z))], childs: null },
					{ name:"P", props:[PString("Lcl Scaling"), PString("Lcl Scaling"), PString(""), PString("A"), PFloat(modelTransform.getScale().x), PFloat(modelTransform.getScale().y), PFloat(modelTransform.getScale().z)], childs: null },
				]}
			] };

			objectsNode.childs.push(model);

			var mesh = Std.downcast(object, h3d.scene.Mesh);
			if (mesh == null)
				return;

			var vertices = new Array<Float>();
			var normals = new Array<Float>();
			var uvs = new Array<Array<Float>>();
			var indexes = new Array<Int>();

			var hmdModel = Std.downcast(mesh.primitive, h3d.prim.HMDModel);
			var vertexFormat = @:privateAccess hmdModel.data.vertexFormat;
			var bufs = hmdModel.getDataBuffers(vertexFormat);
			var idxVertex = 0;

			// Fill mesh informations that will be required in the fbx file
			while (idxVertex < bufs.vertexes.length) {
				var curIndex = idxVertex;
				vertices.push(-bufs.vertexes[curIndex]); // Convert left hand X coordinate to right hand X coordinate
				vertices.push(bufs.vertexes[curIndex + 1]);
				vertices.push(bufs.vertexes[curIndex + 2]);
				curIndex += 3;

				if (vertexFormat.hasInput("normal")) {
					normals.push(-bufs.vertexes[curIndex]); // Convert left hand X coordinate to right hand X coordinate
					normals.push(bufs.vertexes[curIndex + 1]);
					normals.push(bufs.vertexes[curIndex + 2]);
					curIndex += 3;
				}

				// Tangent export isn't supported at the moment
				if (vertexFormat.hasInput("tangent"))
					curIndex += 3;

				var uvIdx = 0;
				var uvInput = 'uv${ uvIdx == 0 ? "" : '${uvIdx + 1}'}';
				while(vertexFormat.hasInput(uvInput)) {
					if (uvs.length < uvIdx + 1)
						uvs.push(new Array<Float>());

					uvs[uvIdx].push(bufs.vertexes[curIndex]);
					uvs[uvIdx].push(1 - bufs.vertexes[curIndex + 1]);
					curIndex += 2;
					uvIdx++;
					uvInput = 'uv${ uvIdx == 0 ? "" : '${uvIdx + 1}'}';
				}

				idxVertex += vertexFormat.stride;
			}

			var idxIndex = 0;
			while (idxIndex < bufs.indexes.length) {
				// We have to flip the order of vertex to change the facing direction of the triangle (because we changed X axis
				// sign earlier to change from left hand to right hand)

				// /!\ Last vertex index This is because the last index that close the polygon (in our case, we work with triangles, so the third)
				// need to be increased by one and then set to negative.
				// (This is because original index is XOR'ed with -1.)
				indexes.push(bufs.indexes[idxIndex + 1]);
				indexes.push(bufs.indexes[idxIndex]);
				indexes.push( -1 * (bufs.indexes[idxIndex + 2] + 1));

				idxIndex += 3;
			}

			var meshMaterials = mesh.getMaterials();
			var mats = new Array<Int>();
			for (idx => mat in meshMaterials ) {
				var hmdModel = Std.downcast(mesh.primitive, h3d.prim.HMDModel);
				var materialId = -1;

				// Only write material once in the fbx file
				for (i in 0...objectRegistry.length) {
					if (objectRegistry[i].name == "__mat"+mat.name) {
						materialId = objectRegistry[i].id;
						break;
					}
				}

				if (materialId == -1) {
					materialId = getUniqueId();

					var material : FbxNode = { name:"Material", props: [PInt(materialId), PString('Material::${mat.name}'), PString("")], childs:[
						{ name: "Version", props: [PInt(102)], childs: null },
						{ name: "ShadingModel", props: [PString("phong")], childs: null },
						{ name: "MultiLayer", props: [PInt(0)], childs: null },
						{ name: "Properties70", props: null, childs: [
							{ name:"P", props: [PString("EmissiveColor"), PString("Color"), PString(""), PString("A"), PFloat(1), PFloat(1), PFloat(1)], childs: null },
							{ name:"P", props: [PString("EmissiveFactor"), PString("Number"), PString(""), PString("A"), PInt(0)], childs: null },
							{ name:"P", props: [PString("AmbientColor"), PString("Color"), PString(""), PString("A"), PFloat(0.05), PFloat(0.05), PFloat(0.05)], childs: null },
							{ name:"P", props: [PString("AmbientFactor"), PString("Number"), PString(""), PString("A"), PInt(0)], childs: null },
							{ name:"P", props: [PString("DiffuseColor"), PString("Color"), PString(""), PString("A"), PFloat(0.8), PFloat(0.8), PFloat(0.8)], childs: null },
							{ name:"P", props: [PString("BumpFactor"), PString("double"), PString("Number"), PString(""), PInt(0)], childs: null },
							{ name:"P", props: [PString("SpecularColor"), PString("Color"), PString(""), PString("A"), PFloat(0.8), PFloat(0.8), PFloat(0.8)], childs: null },
							{ name:"P", props: [PString("SpecularFactor"), PString("Number"), PString(""), PString("A"), PFloat(0.25)], childs: null },
							{ name:"P", props: [PString("ShininessExponent"), PString("Number"), PString(""), PString("A"), PInt(0)], childs: null },
							{ name:"P", props: [PString("ReflectionColor"), PString("Color"), PString(""), PString("A"), PFloat(0.8), PFloat(0.8), PFloat(0.8)], childs: null },
							{ name:"P", props: [PString("ReflectionFactor"), PString("Number"), PString(""), PString("A"), PInt(0)], childs: null },
							{ name:"P", props: [PString("Shininess"), PString("Number"), PString(""), PString("A"), PInt(25)], childs: null },
							{ name:"P", props: [PString("Emissive"), PString("Vector3D"), PString("Vector"), PString(""), PInt(0), PInt(0), PInt(0)], childs: null },
							{ name:"P", props: [PString("Ambient"), PString("Vector3D"), PString("Vector"), PString(""), PInt(0), PInt(0), PInt(0)], childs: null },
							{ name:"P", props: [PString("Diffuse"), PString("Vector3D"), PString("Vector"), PString(""), PFloat(0.8), PFloat(0.8), PFloat(0.8)], childs: null },
							{ name:"P", props: [PString("Specular"), PString("Vector3D"), PString("Vector"), PString(""), PFloat(0.2), PFloat(0.2), PFloat(0.2)], childs: null },
							{ name:"P", props: [PString("Opacity"), PString("double"), PString("Number"), PString(""), PInt(1)], childs: null },
							{ name:"P", props: [PString("Reflectivity"), PString("double"), PString("Number"), PString(""), PInt(0)], childs: null }
						] },
					] };

					objectsNode.childs.push(material);
				}

				objectRegistry.push({ name: "__mat"+mat.name, type: "O", id: materialId, parentId: modelId, property: null });

				var matIndexes = hmdModel.getMaterialIndexes(idx);
				for (i in 0...Std.int(matIndexes.count / 3))
					mats.push(idx);

				// Building mat textures
				var textures = new Array<Dynamic>();
				for (matData in @:privateAccess hmdModel.lib.header.materials) {
					if (matData.name == mat.name) {
						if (matData.diffuseTexture != null)
							@:privateAccess textures.push({ name: matData.diffuseTexture.substr(matData.diffuseTexture.lastIndexOf("/") + 1), path: resolvePathImpl(hmdModel.lib.resource.entry.path ,matData.diffuseTexture), property: "DiffuseColor" });
						if (matData.normalMap != null)
							@:privateAccess textures.push({ name: matData.normalMap.substr(matData.normalMap.lastIndexOf("/") + 1), path: resolvePathImpl(hmdModel.lib.resource.entry.path ,matData.normalMap), property: "NormalMap" });
						if (matData.specularTexture != null)
							@:privateAccess textures.push({ name : matData.specularTexture.substr(matData.specularTexture.lastIndexOf("/") + 1), path: resolvePathImpl(hmdModel.lib.resource.entry.path ,matData.specularTexture), property: "SpecularFactor" });
					}
				}

				for (t in textures) {
					var textureId = getUniqueId();
					var textureProperty = '${ t.property == "DiffuseColor" ? "base_color_texture" : (t.property == "NormalMap" ? "normalmap_texture" : "specular_texture") }';
					var texture : FbxNode = { name:"Texture", props: [PInt(textureId), PString('Texture::${textureProperty}'), PString("Clip")], childs:[
						{ name: "Type", props: [PString("TextureVideoClip")], childs: null },
						{ name: "Version", props: [PInt(202)], childs: null },
						{ name: "TextureName", props: [PString('Texture::${textureProperty}')], childs: null },
						{ name: "Properties70", props: null, childs: [
							{ name:"P", props: [PString("UseMaterial"), PString("bool"), PString(""), PString(""), PInt(1)], childs: null },
							{ name:"P", props: [PString("AlphaSource"), PString("enum"), PString(""), PString(""), PInt(2)], childs: null },
						] },
						{ name: "Media", props: [PString('Video::${t.name}')], childs: null },
						{ name: "Filename", props: [PString(t.path)], childs: null },
						{ name: "RelativeFilename", props: [PString("")], childs: null },
						{ name: "ModelUVTranslation", props: [PFloat(0), PFloat(0)], childs: null },
						{ name: "ModelUVScaling", props: [PFloat(1), PFloat(1)], childs: null },
						{ name: "Texture_Alpha_Source", props: [PString("None")], childs: null },
						{ name: "Cropping", props: [PInt(0), PInt(0), PInt(0), PInt(0)], childs: null },
					] };


					objectsNode.childs.push(texture);
					objectRegistry.push({ name: "texture_"+t.name, type: "P", id: textureId, parentId: materialId, property: t.property });

					// If texture isn't registered in fbx file, we should add it (it is registered as "Video" object)
					var videoId = -1;
					for (idx in 0...objectRegistry.length) {
						if (objectRegistry[idx].name == "__video"+t.name) {
							videoId = objectRegistry[idx].id;
							break;
						}
					}

					if (videoId == -1) {
						videoId = getUniqueId();
						var video : FbxNode = { name:"Video", props: [PInt(videoId), PString('Video::${t.name}'), PString("Clip")], childs:[
							{ name: "Type", props: [PString("Clip")], childs: null },
							{ name: "Properties70", props: null, childs: [
								{ name:"P", props: [PString("KString"), PString("XRefUrl"), PString(""), PString(t.path)], childs: null },
							] },
							{ name: "UseMipMap", props: [PInt(0)], childs: null },
							{ name: "Filename", props: [PString(t.path)], childs: null },
							{ name: "RelativeFilename", props: [PString("")], childs: null },
						] };

						objectsNode.childs.push(video);
					}

					objectRegistry.push({ name: "__video"+t.name, type: "O", id: videoId, parentId: textureId, property: null });
				}
			}

			var geometryId = getUniqueId();
			var geometry : FbxNode = { name:"Geometry", props: [PInt(geometryId), PString('Geometry::${mesh.name}'), PString("Mesh")], childs:[
				{ name:"Vertices", props: [PFloats(vertices)], childs: null},
				{ name:"PolygonVertexIndex", props: [PInts(indexes)], childs: null},
				{ name:"GeometryVersion", props: [PInt(124)], childs: null},
				{ name:"LayerElementNormal", props: [PInt(0)], childs: [
					{ name: "Version", props: [ PInt(101) ], childs: null },
					{ name: "Name", props: [ PString("") ], childs: null },
					{ name: "MappingInformationType", props: [ PString("ByVertice") ], childs: null },
					{ name: "ReferenceInformationType", props: [ PString("Direct") ], childs: null },
					{ name: "Normals", props: [ PFloats(normals) ], childs: null },
				]},
				{ name:"LayerElementMaterial", props: [PInt(0)], childs: [
					{ name: "Version", props: [ PInt(101) ], childs: null },
					{ name: "Name", props: [ PString("") ], childs: null },
					{ name: "MappingInformationType", props: [ PString("ByPolygon") ], childs: null },
					{ name: "ReferenceInformationType", props: [ PString("IndexToDirect") ], childs: null },
					{ name: "Materials", props: [ PInts(mats) ], childs: null },
				]}
			] };

			// Add all uv maps in layer elements
			for (idx => uv in uvs) {
				geometry.childs.push(
					{ name:"LayerElementUV", props: [PInt(idx)], childs: [
						{ name: "Version", props: [ PInt(101) ], childs: null },
						{ name: "Name", props: [ PString("UVMap"+idx) ], childs: null },
						{ name: "MappingInformationType", props: [ PString("ByVertice") ], childs: null },
						{ name: "ReferenceInformationType", props: [ PString("Direct") ], childs: null },
						{ name: "UV", props: [ PFloats(uv) ], childs: null },
					]}
				);
			}

			// Build all layers (we're currently building several layers only to support several uvs maps)
			geometry.childs.push(
				{ name:"Layer", props: [PInt(0)], childs: [
					{ name: "Version", props: [ PInt(100) ], childs: null },
					{ name: "LayerElement", props: null, childs: [
						{ name: "Type", props: [ PString("LayerElementNormal") ], childs: null },
						{ name: "TypedIndex", props: [ PInt(0) ], childs: null },
					] },
					{ name: "LayerElement", props: null, childs: [
						{ name: "Type", props: [ PString("LayerElementMaterial") ], childs: null },
						{ name: "TypedIndex", props: [ PInt(0) ], childs: null },
					] },
					{ name: "LayerElement", props: null, childs: [
						{ name: "Type", props: [ PString("LayerElementUV") ], childs: null },
						{ name: "TypedIndex", props: [ PInt(0) ], childs: null },
					] },
				]}
			);

			for (idx => uv in uvs) {
				if (idx == 0)
					continue;

				geometry.childs.push(
					{ name:"Layer", props: [PInt(idx)], childs: [
						{ name: "Version", props: [ PInt(100) ], childs: null },
						{ name: "LayerElement", props: null, childs: [
							{ name: "Type", props: [ PString("LayerElementUV") ], childs: null },
							{ name: "TypedIndex", props: [ PInt(idx) ], childs: null },
						] },
					]}
				);
			}

			objectsNode.childs.push(geometry);
			objectRegistry.push({ name: "geometry" ,type: "O", id: geometryId, parentId: modelId, property: null });
		}

		function build(objects: Array<h3d.scene.Object>, parentId : Int) {
			for (o in objects) {
				var objectId = nextFreeId;

				// Register object in object registry for future usage (add connections for example)
				objectRegistry.push({ name: o.name, type : "O", id: nextFreeId, parentId: parentId, property: null });

				// Build current object and his children recusively
				buildObject(o, params, parentId == 0);
				build(@:privateAccess o.children, objectId);
			}
		}

		build(objects, 0);
		return objectsNode;
	}

	function buildConnections(objectRegistry : Array<Dynamic>) {
		var connections : FbxNode = { name:"Connections", props: null, childs: [] };

		for (o in objectRegistry) {
			var connection = { name:"C", props: [ PString("O"+o.type), PInt(o.id), PInt(o.parentId) ], childs: null };

			if (o.property != null)
				connection.props.push(PString(o.property));

			connections.childs.push(connection);
		}

		return connections;
	}

	public function write(objects: Array<h3d.scene.Object>, ?params : Dynamic) {
		var old = out;
		var header = new haxe.io.BytesOutput();
		out = header;

		var objectRegistry = new Array<Dynamic>();

		writeHeader();
		writeNode(buildHeaderExtension());
		writeNode(buildGlobalSettings());
		writeNode(buildDefinitions(objects));
		writeNode(buildObjects(objects, params, objectRegistry));
		writeNode(buildConnections(objectRegistry));

		var bytes = header.getBytes();
		out = old;

		out.write(bytes);
	}
}
