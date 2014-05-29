#include <hxcpp.h>

#ifndef INCLUDED_h3d_col_Point
#include <h3d/col/Point.h>
#endif
#ifndef INCLUDED_h3d_fbx_FBxTools
#include <h3d/fbx/FBxTools.h>
#endif
#ifndef INCLUDED_h3d_fbx_FbxNode
#include <h3d/fbx/FbxNode.h>
#endif
#ifndef INCLUDED_h3d_fbx_FbxProp
#include <h3d/fbx/FbxProp.h>
#endif
#ifndef INCLUDED_h3d_fbx_Geometry
#include <h3d/fbx/Geometry.h>
#endif
#ifndef INCLUDED_h3d_fbx_Library
#include <h3d/fbx/Library.h>
#endif
namespace h3d{
namespace fbx{

Void Geometry_obj::__construct(::h3d::fbx::Library l,::h3d::fbx::FbxNode root)
{
HX_STACK_FRAME("h3d.fbx.Geometry","new",0x8d23518b,"h3d.fbx.Geometry.new","h3d/fbx/Geometry.hx",9,0x40abff03)
HX_STACK_THIS(this)
HX_STACK_ARG(l,"l")
HX_STACK_ARG(root,"root")
{
	HX_STACK_LINE(10)
	this->lib = l;
	HX_STACK_LINE(11)
	this->root = root;
}
;
	return null();
}

//Geometry_obj::~Geometry_obj() { }

Dynamic Geometry_obj::__CreateEmpty() { return  new Geometry_obj; }
hx::ObjectPtr< Geometry_obj > Geometry_obj::__new(::h3d::fbx::Library l,::h3d::fbx::FbxNode root)
{  hx::ObjectPtr< Geometry_obj > result = new Geometry_obj();
	result->__construct(l,root);
	return result;}

Dynamic Geometry_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Geometry_obj > result = new Geometry_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

Array< Float > Geometry_obj::getVertices( ){
	HX_STACK_FRAME("h3d.fbx.Geometry","getVertices",0x184ea6da,"h3d.fbx.Geometry.getVertices","h3d/fbx/Geometry.hx",15,0x40abff03)
	HX_STACK_THIS(this)
	HX_STACK_LINE(15)
	return this->root->get(HX_CSTRING("Vertices"),null())->getFloats();
}


HX_DEFINE_DYNAMIC_FUNC0(Geometry_obj,getVertices,return )

Array< int > Geometry_obj::getPolygons( ){
	HX_STACK_FRAME("h3d.fbx.Geometry","getPolygons",0xda8a0f9a,"h3d.fbx.Geometry.getPolygons","h3d/fbx/Geometry.hx",19,0x40abff03)
	HX_STACK_THIS(this)
	HX_STACK_LINE(19)
	return this->root->get(HX_CSTRING("PolygonVertexIndex"),null())->getInts();
}


HX_DEFINE_DYNAMIC_FUNC0(Geometry_obj,getPolygons,return )

Array< int > Geometry_obj::getMaterials( ){
	HX_STACK_FRAME("h3d.fbx.Geometry","getMaterials",0x639cd3eb,"h3d.fbx.Geometry.getMaterials","h3d/fbx/Geometry.hx",22,0x40abff03)
	HX_STACK_THIS(this)
	HX_STACK_LINE(23)
	::h3d::fbx::FbxNode mats = this->root->get(HX_CSTRING("LayerElementMaterial"),true);		HX_STACK_VAR(mats,"mats");
	HX_STACK_LINE(24)
	if (((mats == null()))){
		HX_STACK_LINE(24)
		return null();
	}
	else{
		HX_STACK_LINE(24)
		return mats->get(HX_CSTRING("Materials"),null())->getInts();
	}
	HX_STACK_LINE(24)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Geometry_obj,getMaterials,return )

Array< int > Geometry_obj::getShapeIndexes( ){
	HX_STACK_FRAME("h3d.fbx.Geometry","getShapeIndexes",0x28f32240,"h3d.fbx.Geometry.getShapeIndexes","h3d/fbx/Geometry.hx",32,0x40abff03)
	HX_STACK_THIS(this)
	HX_STACK_LINE(32)
	return this->root->get(HX_CSTRING("Indexes"),null())->getInts();
}


HX_DEFINE_DYNAMIC_FUNC0(Geometry_obj,getShapeIndexes,return )

Dynamic Geometry_obj::getIndexes( ){
	HX_STACK_FRAME("h3d.fbx.Geometry","getIndexes",0x722cac3f,"h3d.fbx.Geometry.getIndexes","h3d/fbx/Geometry.hx",39,0x40abff03)
	HX_STACK_THIS(this)
	HX_STACK_LINE(40)
	int count = (int)0;		HX_STACK_VAR(count,"count");
	HX_STACK_LINE(40)
	int pos = (int)0;		HX_STACK_VAR(pos,"pos");
	HX_STACK_LINE(41)
	Array< int > index = this->getPolygons();		HX_STACK_VAR(index,"index");
	HX_STACK_LINE(42)
	Array< int > vout = Array_obj< int >::__new();		HX_STACK_VAR(vout,"vout");
	HX_STACK_LINE(42)
	Array< int > iout = Array_obj< int >::__new();		HX_STACK_VAR(iout,"iout");
	HX_STACK_LINE(43)
	{
		HX_STACK_LINE(43)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(43)
		while((true)){
			HX_STACK_LINE(43)
			if ((!(((_g < index->length))))){
				HX_STACK_LINE(43)
				break;
			}
			HX_STACK_LINE(43)
			int i = index->__get(_g);		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(43)
			++(_g);
			HX_STACK_LINE(44)
			(count)++;
			HX_STACK_LINE(45)
			if (((i < (int)0))){
				HX_STACK_LINE(46)
				index[pos] = (-(i) - (int)1);
				HX_STACK_LINE(47)
				int start = ((pos - count) + (int)1);		HX_STACK_VAR(start,"start");
				HX_STACK_LINE(48)
				{
					HX_STACK_LINE(48)
					int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(48)
					while((true)){
						HX_STACK_LINE(48)
						if ((!(((_g1 < count))))){
							HX_STACK_LINE(48)
							break;
						}
						HX_STACK_LINE(48)
						int n = (_g1)++;		HX_STACK_VAR(n,"n");
						HX_STACK_LINE(49)
						vout->push(index->__get((n + start)));
					}
				}
				HX_STACK_LINE(50)
				{
					HX_STACK_LINE(50)
					int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(50)
					int _g1 = (count - (int)2);		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(50)
					while((true)){
						HX_STACK_LINE(50)
						if ((!(((_g2 < _g1))))){
							HX_STACK_LINE(50)
							break;
						}
						HX_STACK_LINE(50)
						int n = (_g2)++;		HX_STACK_VAR(n,"n");
						HX_STACK_LINE(51)
						iout->push((start + n));
						HX_STACK_LINE(52)
						iout->push(((start + count) - (int)1));
						HX_STACK_LINE(53)
						iout->push(((start + n) + (int)1));
					}
				}
				HX_STACK_LINE(55)
				index[pos] = i;
				HX_STACK_LINE(56)
				count = (int)0;
			}
			HX_STACK_LINE(58)
			(pos)++;
		}
	}
	struct _Function_1_1{
		inline static Dynamic Block( Array< int > &vout,Array< int > &iout){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/fbx/Geometry.hx",60,0x40abff03)
			{
				hx::Anon __result = hx::Anon_obj::Create();
				__result->Add(HX_CSTRING("vidx") , vout,false);
				__result->Add(HX_CSTRING("idx") , iout,false);
				return __result;
			}
			return null();
		}
	};
	HX_STACK_LINE(60)
	return _Function_1_1::Block(vout,iout);
}


HX_DEFINE_DYNAMIC_FUNC0(Geometry_obj,getIndexes,return )

Array< Float > Geometry_obj::getNormals( ){
	HX_STACK_FRAME("h3d.fbx.Geometry","getNormals",0xbd47c0ab,"h3d.fbx.Geometry.getNormals","h3d/fbx/Geometry.hx",63,0x40abff03)
	HX_STACK_THIS(this)
	HX_STACK_LINE(64)
	Array< Float > nrm = this->root->get(HX_CSTRING("LayerElementNormal.Normals"),null())->getFloats();		HX_STACK_VAR(nrm,"nrm");
	HX_STACK_LINE(67)
	::String _g = ::h3d::fbx::FBxTools_obj::toString(this->root->get(HX_CSTRING("LayerElementNormal.MappingInformationType"),null())->props->__get((int)0).StaticCast< ::h3d::fbx::FbxProp >());		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(67)
	if (((_g == HX_CSTRING("ByVertice")))){
		HX_STACK_LINE(68)
		Array< Float > nout = Array_obj< Float >::__new();		HX_STACK_VAR(nout,"nout");
		HX_STACK_LINE(69)
		{
			HX_STACK_LINE(69)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(69)
			Array< int > _g11 = this->getPolygons();		HX_STACK_VAR(_g11,"_g11");
			HX_STACK_LINE(69)
			while((true)){
				HX_STACK_LINE(69)
				if ((!(((_g1 < _g11->length))))){
					HX_STACK_LINE(69)
					break;
				}
				HX_STACK_LINE(69)
				int i = _g11->__get(_g1);		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(69)
				++(_g1);
				HX_STACK_LINE(70)
				int vid = i;		HX_STACK_VAR(vid,"vid");
				HX_STACK_LINE(71)
				if (((vid < (int)0))){
					HX_STACK_LINE(71)
					vid = (-(vid) - (int)1);
				}
				HX_STACK_LINE(72)
				nout->push(nrm->__get((vid * (int)3)));
				HX_STACK_LINE(73)
				nout->push(nrm->__get(((vid * (int)3) + (int)1)));
				HX_STACK_LINE(74)
				nout->push(nrm->__get(((vid * (int)3) + (int)2)));
			}
		}
		HX_STACK_LINE(76)
		nrm = nout;
	}
	HX_STACK_LINE(78)
	return nrm;
}


HX_DEFINE_DYNAMIC_FUNC0(Geometry_obj,getNormals,return )

Array< Float > Geometry_obj::getShapeNormals( ){
	HX_STACK_FRAME("h3d.fbx.Geometry","getShapeNormals",0x740e36ac,"h3d.fbx.Geometry.getShapeNormals","h3d/fbx/Geometry.hx",83,0x40abff03)
	HX_STACK_THIS(this)
	HX_STACK_LINE(83)
	return this->root->get(HX_CSTRING("Normals"),null())->getFloats();
}


HX_DEFINE_DYNAMIC_FUNC0(Geometry_obj,getShapeNormals,return )

Dynamic Geometry_obj::getColors( ){
	HX_STACK_FRAME("h3d.fbx.Geometry","getColors",0x21de8251,"h3d.fbx.Geometry.getColors","h3d/fbx/Geometry.hx",86,0x40abff03)
	HX_STACK_THIS(this)
	HX_STACK_LINE(87)
	::h3d::fbx::FbxNode color = this->root->get(HX_CSTRING("LayerElementColor"),true);		HX_STACK_VAR(color,"color");
	HX_STACK_LINE(88)
	if (((color == null()))){
		HX_STACK_LINE(88)
		return null();
	}
	else{
		HX_STACK_LINE(88)
		Array< Float > _g = color->get(HX_CSTRING("Colors"),null())->getFloats();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(88)
		Array< int > _g1 = color->get(HX_CSTRING("ColorIndex"),null())->getInts();		HX_STACK_VAR(_g1,"_g1");
		struct _Function_2_1{
			inline static Dynamic Block( Array< int > &_g1,Array< Float > &_g){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/fbx/Geometry.hx",88,0x40abff03)
				{
					hx::Anon __result = hx::Anon_obj::Create();
					__result->Add(HX_CSTRING("values") , _g,false);
					__result->Add(HX_CSTRING("index") , _g1,false);
					return __result;
				}
				return null();
			}
		};
		HX_STACK_LINE(88)
		return _Function_2_1::Block(_g1,_g);
	}
	HX_STACK_LINE(88)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Geometry_obj,getColors,return )

Dynamic Geometry_obj::getUVs( ){
	HX_STACK_FRAME("h3d.fbx.Geometry","getUVs",0x22ab97d1,"h3d.fbx.Geometry.getUVs","h3d/fbx/Geometry.hx",91,0x40abff03)
	HX_STACK_THIS(this)
	HX_STACK_LINE(92)
	Dynamic uvs = Dynamic( Array_obj<Dynamic>::__new());		HX_STACK_VAR(uvs,"uvs");
	HX_STACK_LINE(93)
	{
		HX_STACK_LINE(93)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(93)
		Array< ::Dynamic > _g1 = this->root->getAll(HX_CSTRING("LayerElementUV"));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(93)
		while((true)){
			HX_STACK_LINE(93)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(93)
				break;
			}
			HX_STACK_LINE(93)
			::h3d::fbx::FbxNode v = _g1->__get(_g).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(v,"v");
			HX_STACK_LINE(93)
			++(_g);
			HX_STACK_LINE(94)
			::h3d::fbx::FbxNode index = v->get(HX_CSTRING("UVIndex"),true);		HX_STACK_VAR(index,"index");
			HX_STACK_LINE(95)
			Array< Float > values = v->get(HX_CSTRING("UV"),null())->getFloats();		HX_STACK_VAR(values,"values");
			HX_STACK_LINE(96)
			Array< int > index1;		HX_STACK_VAR(index1,"index1");
			HX_STACK_LINE(96)
			if (((index == null()))){
				HX_STACK_LINE(98)
				Array< int > _g2 = Array_obj< int >::__new();		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(98)
				{
					HX_STACK_LINE(98)
					int _g3 = (int)0;		HX_STACK_VAR(_g3,"_g3");
					HX_STACK_LINE(98)
					Array< int > _g4 = this->getPolygons();		HX_STACK_VAR(_g4,"_g4");
					HX_STACK_LINE(98)
					while((true)){
						HX_STACK_LINE(98)
						if ((!(((_g3 < _g4->length))))){
							HX_STACK_LINE(98)
							break;
						}
						HX_STACK_LINE(98)
						int i = _g4->__get(_g3);		HX_STACK_VAR(i,"i");
						HX_STACK_LINE(98)
						++(_g3);
						HX_STACK_LINE(98)
						_g2->push((  (((i < (int)0))) ? int((-(i) - (int)1)) : int(i) ));
					}
				}
				HX_STACK_LINE(98)
				index1 = _g2;
			}
			else{
				HX_STACK_LINE(99)
				index1 = index->getInts();
			}
			struct _Function_3_1{
				inline static Dynamic Block( Array< int > &index1,Array< Float > &values){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/fbx/Geometry.hx",100,0x40abff03)
					{
						hx::Anon __result = hx::Anon_obj::Create();
						__result->Add(HX_CSTRING("values") , values,false);
						__result->Add(HX_CSTRING("index") , index1,false);
						return __result;
					}
					return null();
				}
			};
			HX_STACK_LINE(100)
			uvs->__Field(HX_CSTRING("push"),true)(_Function_3_1::Block(index1,values));
		}
	}
	HX_STACK_LINE(102)
	return uvs;
}


HX_DEFINE_DYNAMIC_FUNC0(Geometry_obj,getUVs,return )

::h3d::col::Point Geometry_obj::getGeomTranslate( ){
	HX_STACK_FRAME("h3d.fbx.Geometry","getGeomTranslate",0x7e828a71,"h3d.fbx.Geometry.getGeomTranslate","h3d/fbx/Geometry.hx",106,0x40abff03)
	HX_STACK_THIS(this)
	HX_STACK_LINE(107)
	{
		HX_STACK_LINE(107)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(107)
		Array< ::Dynamic > _g1 = this->lib->getParent(this->root,HX_CSTRING("Model"),null())->getAll(HX_CSTRING("Properties70.P"));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(107)
		while((true)){
			HX_STACK_LINE(107)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(107)
				break;
			}
			HX_STACK_LINE(107)
			::h3d::fbx::FbxNode p = _g1->__get(_g).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(107)
			++(_g);
			HX_STACK_LINE(108)
			::String _g2 = ::h3d::fbx::FBxTools_obj::toString(p->props->__get((int)0).StaticCast< ::h3d::fbx::FbxProp >());		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(108)
			if (((_g2 == HX_CSTRING("GeometricTranslation")))){
				HX_STACK_LINE(109)
				Float _g11 = ::h3d::fbx::FBxTools_obj::toFloat(p->props->__get((int)4).StaticCast< ::h3d::fbx::FbxProp >());		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(109)
				Float _g21;		HX_STACK_VAR(_g21,"_g21");
				HX_STACK_LINE(109)
				_g21 = (_g11 * ((  ((this->lib->leftHand)) ? int((int)-1) : int((int)1) )));
				HX_STACK_LINE(109)
				Float _g3 = ::h3d::fbx::FBxTools_obj::toFloat(p->props->__get((int)5).StaticCast< ::h3d::fbx::FbxProp >());		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(109)
				Float _g4 = ::h3d::fbx::FBxTools_obj::toFloat(p->props->__get((int)6).StaticCast< ::h3d::fbx::FbxProp >());		HX_STACK_VAR(_g4,"_g4");
				HX_STACK_LINE(109)
				return ::h3d::col::Point_obj::__new(_g21,_g3,_g4);
			}
		}
	}
	HX_STACK_LINE(110)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Geometry_obj,getGeomTranslate,return )


Geometry_obj::Geometry_obj()
{
}

void Geometry_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Geometry);
	HX_MARK_MEMBER_NAME(lib,"lib");
	HX_MARK_MEMBER_NAME(root,"root");
	HX_MARK_END_CLASS();
}

void Geometry_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(lib,"lib");
	HX_VISIT_MEMBER_NAME(root,"root");
}

Dynamic Geometry_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"lib") ) { return lib; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"root") ) { return root; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"getUVs") ) { return getUVs_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"getColors") ) { return getColors_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"getIndexes") ) { return getIndexes_dyn(); }
		if (HX_FIELD_EQ(inName,"getNormals") ) { return getNormals_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"getVertices") ) { return getVertices_dyn(); }
		if (HX_FIELD_EQ(inName,"getPolygons") ) { return getPolygons_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"getMaterials") ) { return getMaterials_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"getShapeIndexes") ) { return getShapeIndexes_dyn(); }
		if (HX_FIELD_EQ(inName,"getShapeNormals") ) { return getShapeNormals_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"getGeomTranslate") ) { return getGeomTranslate_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Geometry_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"lib") ) { lib=inValue.Cast< ::h3d::fbx::Library >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"root") ) { root=inValue.Cast< ::h3d::fbx::FbxNode >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Geometry_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("lib"));
	outFields->push(HX_CSTRING("root"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h3d::fbx::Library*/ ,(int)offsetof(Geometry_obj,lib),HX_CSTRING("lib")},
	{hx::fsObject /*::h3d::fbx::FbxNode*/ ,(int)offsetof(Geometry_obj,root),HX_CSTRING("root")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("lib"),
	HX_CSTRING("root"),
	HX_CSTRING("getVertices"),
	HX_CSTRING("getPolygons"),
	HX_CSTRING("getMaterials"),
	HX_CSTRING("getShapeIndexes"),
	HX_CSTRING("getIndexes"),
	HX_CSTRING("getNormals"),
	HX_CSTRING("getShapeNormals"),
	HX_CSTRING("getColors"),
	HX_CSTRING("getUVs"),
	HX_CSTRING("getGeomTranslate"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Geometry_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Geometry_obj::__mClass,"__mClass");
};

#endif

Class Geometry_obj::__mClass;

void Geometry_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.fbx.Geometry"), hx::TCanCast< Geometry_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatics
#endif
#ifdef HXCPP_SCRIPTABLE
    , sMemberStorageInfo
#endif
);
}

void Geometry_obj::__boot()
{
}

} // end namespace h3d
} // end namespace fbx
