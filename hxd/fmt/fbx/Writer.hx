package hxd.fmt.fbx;

import hxd.fmt.fbx.Data;
import hxd.fmt.hmd.Data;

class Writer {
	var out:haxe.io.Output;
	var version:Int;

	public function new(out) {
		this.out = out;
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
		var fbxVersion = "7.3.0";
		out.writeString('; FBX ${fbxVersion} project file\n');
		out.writeString('; Copyright (C) 1997-2010 Autodesk Inc. and/or its licensors.\n');
		out.writeString('; All rights reserved.\n');
		out.writeString('; ----------------------------------------------------\n');
		out.writeString('\n');

		writeNode(buildHeaderNode());
	}

	function buildTimeStampNode() : FbxNode{
		var date = Date.now();
		var tsVersion : FbxNode = {name: "Version", props:[PInt(1000)], childs:null};
		var tsYear : FbxNode = {name: "Year", props:[PInt(date.getFullYear())], childs:null};
		var tsMonth : FbxNode = {name: "Month", props:[PInt(date.getMonth())], childs:null};
		var tsDay : FbxNode = {name: "Day", props:[PInt(date.getDay())], childs:null};
		var tsHour : FbxNode = {name: "Hour", props:[PInt(date.getHours())], childs:null};
		var tsMinutes : FbxNode = {name: "Minute", props:[PInt(date.getMinutes())], childs:null};
		var tsSeconds : FbxNode = {name: "Second", props:[PInt(date.getSeconds())], childs:null};
		var tsMilliseconds : FbxNode = {name: "Millisecond", props:[PInt(0)], childs:null};
		var ts : FbxNode = {name: "CreationTimeStamp", props:null, childs:[tsVersion, tsYear, tsMonth, tsDay, tsHour, tsMinutes, tsSeconds, tsMilliseconds]};
		return ts;
	}

	function buildSceneInfoMetaDataNode() : FbxNode {
		var version : FbxNode = {name:"Version", props:[PInt(100)], childs: []};
		var title : FbxNode = {name:"Title", props:[PString("")], childs: []};
		var subject : FbxNode = {name:"Subject", props:[PString("")], childs: []};
		var author : FbxNode = {name:"Author", props:[PString("")], childs: []};
		var keywords : FbxNode = {name:"Keywords", props:[PString("")], childs: []};
		var revision : FbxNode = {name:"Revision", props:[PString("")], childs: []};
		var comment : FbxNode = {name:"Comment", props:[PString("")], childs: []};

		var metadata : FbxNode = {name:"MetaData", props:null, childs: [version, title, subject, author, keywords, revision, comment]};
		return metadata;
	}

	function buildSceneInfoPropertiesNode() : FbxNode {
		var properties : FbxNode = {name:"Properties70", props: null, childs:[
			{name:"P", props:[PString("DocumentUrl"), PString("KString"), PString("Url"), PString(""), PString("C:\\")], childs:null},
			{name:"P", props:[PString("SrcDocumentUrl"), PString("KString"), PString("Url"), PString(""), PString("C:\\")], childs:null},
			{name:"P", props:[PString("Original"), PString("Compound"), PString(""), PString("")], childs:null},
			{name:"P", props:[PString("Original|ApplicationVendor"), PString("KString"), PString(""), PString(""), PString("")], childs:null},
			{name:"P", props:[PString("Original|ApplicationName"), PString("KString"), PString(""), PString(""), PString("")], childs:null},
			{name:"P", props:[PString("Original|ApplicationVersion"), PString("KString"), PString(""), PString(""), PString("")], childs:null},
			{name:"P", props:[PString("Original|DateTime_GMT"), PString("DateTime"), PString(""), PString(""), PString("01/01/1970 00:00:00.000")], childs:null},
			{name:"P", props:[PString("Original|FileName"), PString("KString"), PString(""), PString(""), PString("/foobar.fbx")], childs:null},
			{name:"P", props:[PString("LastSaved"), PString("Compound"), PString(""), PString("")], childs:null},
			{name:"P", props:[PString("LastSaved|ApplicationVendor"), PString("KString"), PString(""), PString(""), PString("")], childs:null},
			{name:"P", props:[PString("LastSaved|ApplicationVersion"), PString("KString"), PString(""), PString(""), PString("")], childs:null},
			{name:"P", props:[PString("LastSaved|DateTime_GMT"), PString("DateTime"), PString(""), PString(""), PString("01/01/1970 00:00:00.000")], childs:null},
			{name:"P", props:[PString("Original|ApplicationNativeFile"), PString("KString"), PString(""), PString(""), PString("")], childs:null},
		]};

		return properties;
	}

	function buildSceneInfoNode() : FbxNode {
		var type : FbxNode = {name : "Type", props: [PString("UserData")], childs: null};
		var version : FbxNode = {name : "Version", props: [PInt(100)], childs: null};

		var sceneInfo : FbxNode = {name: "SceneInfo", props:[PString("SceneInfo::GlobalInfo"), PString("UserData")], childs: [type, version, buildSceneInfoMetaDataNode(), buildSceneInfoPropertiesNode()]};
		return sceneInfo;
	}

	function buildHeaderNode() : FbxNode {
		var headerVersion : FbxNode = {name:"FBXHeaderVersion", props: [PInt(1003)], childs: null};
		var version : FbxNode = {name:"FBXVersion", props: [PInt(7003)], childs: null};
		var creator : FbxNode = {name:"Creator", props: [PString("")], childs: null};

		var header : FbxNode = {name:"FBXHeaderExtension", props: null, childs: [headerVersion, version, buildTimeStampNode(), creator, buildSceneInfoNode()]};
		return header;
	}

	function buildProperties() {
		var properties : FbxNode = { name:"Properties70", props: null, childs: [
			{ name: "P", props: [PString("UpAxis"), PString("int"), PString("Integer"), PString(""), PInt(2) ], childs:null }, // Z up
			{ name: "P", props: [PString("UpAxisSign"), PString("int"), PString("Integer"), PString(""), PInt(1) ], childs:null },
			{ name: "P", props: [PString("FrontAxis"), PString("int"), PString("Integer"), PString(""), PInt(0) ], childs:null }, // X front
			{ name: "P", props: [PString("FrontAxisSign"), PString("int"), PString("Integer"), PString(""), PInt(1) ], childs:null },
			{ name: "P", props: [PString("CoordAxis"), PString("int"), PString("Integer"), PString(""), PInt(1) ], childs:null }, // Y coord
			{ name: "P", props: [PString("CoordAxisSign"), PString("int"), PString("Integer"), PString(""), PInt(1) ], childs:null },
			{ name: "P", props: [PString("OriginalUpAxis"), PString("int"), PString("Integer"), PString(""), PInt(-1) ], childs:null },
			{ name: "P", props: [PString("OriginalUpAxisSign"), PString("int"), PString("Integer"), PString(""), PInt(1) ], childs:null },
			{ name: "P", props: [PString("UnitScaleFactor"), PString("double"), PString("Number"), PString(""), PInt(1) ], childs:null },
			{ name: "P", props: [PString("OriginalUnitScaleFactor"), PString("double"), PString("Number"), PString(""), PInt(1) ], childs:null },
			{ name: "P", props: [PString("AmbientColor"), PString("ColorRGB"), PString("Color"), PString(""), PInt(0), PInt(0), PInt(0) ], childs:null },
			{ name: "P", props: [PString("DefaultCamera"), PString("KString"), PString(""), PString(""), PString("Producer Perspective") ], childs:null },
			{ name: "P", props: [PString("TimeMode"), PString("enum"), PString(""), PString(""), PInt(11) ], childs:null },
			{ name: "P", props: [PString("TimeSpanStart"), PString("Ktime"), PString("Time"), PString(""), PInt(0) ], childs:null },
			{ name: "P", props: [PString("TimeSpanStop"), PString("Ktime"), PString("Time"), PString(""), PInt(0) ], childs:null },
			{ name: "P", props: [PString("CustomFrameRate"), PString("double"), PString("Number"), PString(""), PInt(24) ], childs:null },
		] };
		return properties;
	}

	function buildGlobalSettings() {
		var version : FbxNode = {name:"Version", props: [PInt(1000)], childs: null};
		var properties : FbxNode = buildProperties();

		var globalSettings : FbxNode = {name:"GlobalSettings", props: null, childs: [version, properties]};
		return globalSettings;
	}

	public function write(fbx:FbxNode) {
		var old = out;
		var header = new haxe.io.BytesOutput();
		out = header;
		// version = d.version;

		// if( version > Data.CURRENT_VERSION ) throw "Can't write HMD v" + version;

		writeHeader();
		writeNode(buildGlobalSettings());

		// // We dont't want the root node to be written here
		// for (c in fbx.childs) {
		// 	writeNode(c);
		// }

		// writeNode(node);


		var bytes = header.getBytes();
		out = old;

		out.write(bytes);
	}
}
