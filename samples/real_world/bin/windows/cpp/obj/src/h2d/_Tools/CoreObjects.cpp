#include <hxcpp.h>

#ifndef INCLUDED_h2d_Matrix
#include <h2d/Matrix.h>
#endif
#ifndef INCLUDED_h2d__Tools_CoreObjects
#include <h2d/_Tools/CoreObjects.h>
#endif
#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
#endif
#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
#endif
#ifndef INCLUDED_h3d_Vector
#include <h3d/Vector.h>
#endif
#ifndef INCLUDED_h3d_impl_Buffer
#include <h3d/impl/Buffer.h>
#endif
#ifndef INCLUDED_h3d_impl_MemoryManager
#include <h3d/impl/MemoryManager.h>
#endif
#ifndef INCLUDED_h3d_impl_Shader
#include <h3d/impl/Shader.h>
#endif
#ifndef INCLUDED_h3d_mat_Compare
#include <h3d/mat/Compare.h>
#endif
#ifndef INCLUDED_h3d_mat_Face
#include <h3d/mat/Face.h>
#endif
#ifndef INCLUDED_h3d_mat_Material
#include <h3d/mat/Material.h>
#endif
#ifndef INCLUDED_h3d_mat_Texture
#include <h3d/mat/Texture.h>
#endif
#ifndef INCLUDED_hxd_System
#include <hxd/System.h>
#endif
namespace h2d{
namespace _Tools{

Void CoreObjects_obj::__construct()
{
HX_STACK_FRAME("h2d._Tools.CoreObjects","new",0x149120e9,"h2d._Tools.CoreObjects.new","h2d/Tools.hx",19,0x62050538)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(20)
	::h3d::Vector _g = ::h3d::Vector_obj::__new(null(),null(),null(),null());		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(20)
	this->tmpMatA = _g;
	HX_STACK_LINE(21)
	::h3d::Vector _g1 = ::h3d::Vector_obj::__new(null(),null(),null(),null());		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(21)
	this->tmpMatB = _g1;
	HX_STACK_LINE(22)
	::h3d::Vector _g2 = ::h3d::Vector_obj::__new(null(),null(),null(),null());		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(22)
	this->tmpColor = _g2;
	HX_STACK_LINE(23)
	::h3d::Vector _g3 = ::h3d::Vector_obj::__new(null(),null(),null(),null());		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(23)
	this->tmpSize = _g3;
	HX_STACK_LINE(24)
	::h3d::Vector _g4 = ::h3d::Vector_obj::__new(null(),null(),null(),null());		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(24)
	this->tmpUVPos = _g4;
	HX_STACK_LINE(25)
	::h3d::Vector _g5 = ::h3d::Vector_obj::__new(null(),null(),null(),null());		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(25)
	this->tmpUVScale = _g5;
	HX_STACK_LINE(26)
	::h3d::Matrix _g6 = ::h3d::Matrix_obj::__new();		HX_STACK_VAR(_g6,"_g6");
	HX_STACK_LINE(26)
	this->tmpMatrix = _g6;
	HX_STACK_LINE(27)
	::h2d::Matrix _g7 = ::h2d::Matrix_obj::__new(null(),null(),null(),null(),null(),null());		HX_STACK_VAR(_g7,"_g7");
	HX_STACK_LINE(27)
	this->tmpMatrix2D = _g7;
	HX_STACK_LINE(28)
	::h2d::Matrix _g8 = ::h2d::Matrix_obj::__new(null(),null(),null(),null(),null(),null());		HX_STACK_VAR(_g8,"_g8");
	HX_STACK_LINE(28)
	this->tmpMatrix2D_2 = _g8;
	HX_STACK_LINE(29)
	::h3d::mat::Material _g9 = ::h3d::mat::Material_obj::__new(null());		HX_STACK_VAR(_g9,"_g9");
	HX_STACK_LINE(29)
	this->tmpMaterial = _g9;
	HX_STACK_LINE(30)
	this->tmpMaterial->set_culling(::h3d::mat::Face_obj::None);
	HX_STACK_LINE(31)
	this->tmpMaterial->depth(false,::h3d::mat::Compare_obj::Always);
	HX_STACK_LINE(33)
	Array< Float > vector;		HX_STACK_VAR(vector,"vector");
	HX_STACK_LINE(33)
	{
		HX_STACK_LINE(33)
		int length = (int)0;		HX_STACK_VAR(length,"length");
		HX_STACK_LINE(33)
		vector = Array_obj< Float >::__new();
	}
	HX_STACK_LINE(34)
	{
		HX_STACK_LINE(34)
		int _g10 = (int)0;		HX_STACK_VAR(_g10,"_g10");
		HX_STACK_LINE(34)
		Array< ::Dynamic > _g11 = Array_obj< ::Dynamic >::__new().Add(Array_obj< int >::__new().Add((int)0).Add((int)0)).Add(Array_obj< int >::__new().Add((int)1).Add((int)0)).Add(Array_obj< int >::__new().Add((int)0).Add((int)1)).Add(Array_obj< int >::__new().Add((int)1).Add((int)1));		HX_STACK_VAR(_g11,"_g11");
		HX_STACK_LINE(34)
		while((true)){
			HX_STACK_LINE(34)
			if ((!(((_g10 < _g11->length))))){
				HX_STACK_LINE(34)
				break;
			}
			HX_STACK_LINE(34)
			Array< int > pt = _g11->__get(_g10).StaticCast< Array< int > >();		HX_STACK_VAR(pt,"pt");
			HX_STACK_LINE(34)
			++(_g10);
			HX_STACK_LINE(35)
			vector->push(pt->__get((int)0));
			HX_STACK_LINE(36)
			vector->push(pt->__get((int)1));
			HX_STACK_LINE(37)
			vector->push(pt->__get((int)0));
			HX_STACK_LINE(38)
			vector->push(pt->__get((int)1));
		}
	}
	struct _Function_1_1{
		inline static ::h3d::Engine Block( ){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h2d/Tools.hx",41,0x62050538)
			{
				HX_STACK_LINE(41)
				if (((::hxd::System_obj::debugLevel >= (int)1))){
					HX_STACK_LINE(41)
					if (((::h3d::Engine_obj::CURRENT == null()))){
						HX_STACK_LINE(41)
						HX_STACK_DO_THROW(HX_CSTRING("no current context, please do this operation after engine init/creation"));
					}
				}
				HX_STACK_LINE(41)
				return ::h3d::Engine_obj::CURRENT;
			}
			return null();
		}
	};
	HX_STACK_LINE(41)
	::h3d::impl::Buffer _g10 = (_Function_1_1::Block())->mem->allocVector(vector,(int)4,(int)4,null(),hx::SourceInfo(HX_CSTRING("Tools.hx"),41,HX_CSTRING("h2d._Tools.CoreObjects"),HX_CSTRING("new")));		HX_STACK_VAR(_g10,"_g10");
	HX_STACK_LINE(41)
	this->planBuffer = _g10;
}
;
	return null();
}

//CoreObjects_obj::~CoreObjects_obj() { }

Dynamic CoreObjects_obj::__CreateEmpty() { return  new CoreObjects_obj; }
hx::ObjectPtr< CoreObjects_obj > CoreObjects_obj::__new()
{  hx::ObjectPtr< CoreObjects_obj > result = new CoreObjects_obj();
	result->__construct();
	return result;}

Dynamic CoreObjects_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< CoreObjects_obj > result = new CoreObjects_obj();
	result->__construct();
	return result;}

::h3d::mat::Texture CoreObjects_obj::getEmptyTexture( ){
	HX_STACK_FRAME("h2d._Tools.CoreObjects","getEmptyTexture",0x941ea18d,"h2d._Tools.CoreObjects.getEmptyTexture","h2d/Tools.hx",44,0x62050538)
	HX_STACK_THIS(this)
	HX_STACK_LINE(45)
	if (((  ((!(((this->emptyTexture == null()))))) ? bool(this->emptyTexture->isDisposed()) : bool(true) ))){
		HX_STACK_LINE(46)
		if (((this->emptyTexture != null()))){
			HX_STACK_LINE(46)
			this->emptyTexture->dispose();
		}
		HX_STACK_LINE(47)
		::h3d::mat::Texture _g = ::h3d::mat::Texture_obj::fromColor((int)-65281,hx::SourceInfo(HX_CSTRING("Tools.hx"),47,HX_CSTRING("h2d._Tools.CoreObjects"),HX_CSTRING("getEmptyTexture")));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(47)
		this->emptyTexture = _g;
	}
	HX_STACK_LINE(49)
	return this->emptyTexture;
}


HX_DEFINE_DYNAMIC_FUNC0(CoreObjects_obj,getEmptyTexture,return )


CoreObjects_obj::CoreObjects_obj()
{
}

void CoreObjects_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(CoreObjects);
	HX_MARK_MEMBER_NAME(tmpMatA,"tmpMatA");
	HX_MARK_MEMBER_NAME(tmpMatB,"tmpMatB");
	HX_MARK_MEMBER_NAME(tmpSize,"tmpSize");
	HX_MARK_MEMBER_NAME(tmpUVPos,"tmpUVPos");
	HX_MARK_MEMBER_NAME(tmpUVScale,"tmpUVScale");
	HX_MARK_MEMBER_NAME(tmpColor,"tmpColor");
	HX_MARK_MEMBER_NAME(tmpMatrix,"tmpMatrix");
	HX_MARK_MEMBER_NAME(tmpMatrix2D,"tmpMatrix2D");
	HX_MARK_MEMBER_NAME(tmpMatrix2D_2,"tmpMatrix2D_2");
	HX_MARK_MEMBER_NAME(tmpMaterial,"tmpMaterial");
	HX_MARK_MEMBER_NAME(planBuffer,"planBuffer");
	HX_MARK_MEMBER_NAME(emptyTexture,"emptyTexture");
	HX_MARK_END_CLASS();
}

void CoreObjects_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(tmpMatA,"tmpMatA");
	HX_VISIT_MEMBER_NAME(tmpMatB,"tmpMatB");
	HX_VISIT_MEMBER_NAME(tmpSize,"tmpSize");
	HX_VISIT_MEMBER_NAME(tmpUVPos,"tmpUVPos");
	HX_VISIT_MEMBER_NAME(tmpUVScale,"tmpUVScale");
	HX_VISIT_MEMBER_NAME(tmpColor,"tmpColor");
	HX_VISIT_MEMBER_NAME(tmpMatrix,"tmpMatrix");
	HX_VISIT_MEMBER_NAME(tmpMatrix2D,"tmpMatrix2D");
	HX_VISIT_MEMBER_NAME(tmpMatrix2D_2,"tmpMatrix2D_2");
	HX_VISIT_MEMBER_NAME(tmpMaterial,"tmpMaterial");
	HX_VISIT_MEMBER_NAME(planBuffer,"planBuffer");
	HX_VISIT_MEMBER_NAME(emptyTexture,"emptyTexture");
}

Dynamic CoreObjects_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 7:
		if (HX_FIELD_EQ(inName,"tmpMatA") ) { return tmpMatA; }
		if (HX_FIELD_EQ(inName,"tmpMatB") ) { return tmpMatB; }
		if (HX_FIELD_EQ(inName,"tmpSize") ) { return tmpSize; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"tmpUVPos") ) { return tmpUVPos; }
		if (HX_FIELD_EQ(inName,"tmpColor") ) { return tmpColor; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"tmpMatrix") ) { return tmpMatrix; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"tmpUVScale") ) { return tmpUVScale; }
		if (HX_FIELD_EQ(inName,"planBuffer") ) { return planBuffer; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"tmpMatrix2D") ) { return tmpMatrix2D; }
		if (HX_FIELD_EQ(inName,"tmpMaterial") ) { return tmpMaterial; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"emptyTexture") ) { return emptyTexture; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"tmpMatrix2D_2") ) { return tmpMatrix2D_2; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"getEmptyTexture") ) { return getEmptyTexture_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic CoreObjects_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 7:
		if (HX_FIELD_EQ(inName,"tmpMatA") ) { tmpMatA=inValue.Cast< ::h3d::Vector >(); return inValue; }
		if (HX_FIELD_EQ(inName,"tmpMatB") ) { tmpMatB=inValue.Cast< ::h3d::Vector >(); return inValue; }
		if (HX_FIELD_EQ(inName,"tmpSize") ) { tmpSize=inValue.Cast< ::h3d::Vector >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"tmpUVPos") ) { tmpUVPos=inValue.Cast< ::h3d::Vector >(); return inValue; }
		if (HX_FIELD_EQ(inName,"tmpColor") ) { tmpColor=inValue.Cast< ::h3d::Vector >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"tmpMatrix") ) { tmpMatrix=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"tmpUVScale") ) { tmpUVScale=inValue.Cast< ::h3d::Vector >(); return inValue; }
		if (HX_FIELD_EQ(inName,"planBuffer") ) { planBuffer=inValue.Cast< ::h3d::impl::Buffer >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"tmpMatrix2D") ) { tmpMatrix2D=inValue.Cast< ::h2d::Matrix >(); return inValue; }
		if (HX_FIELD_EQ(inName,"tmpMaterial") ) { tmpMaterial=inValue.Cast< ::h3d::mat::Material >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"emptyTexture") ) { emptyTexture=inValue.Cast< ::h3d::mat::Texture >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"tmpMatrix2D_2") ) { tmpMatrix2D_2=inValue.Cast< ::h2d::Matrix >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void CoreObjects_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("tmpMatA"));
	outFields->push(HX_CSTRING("tmpMatB"));
	outFields->push(HX_CSTRING("tmpSize"));
	outFields->push(HX_CSTRING("tmpUVPos"));
	outFields->push(HX_CSTRING("tmpUVScale"));
	outFields->push(HX_CSTRING("tmpColor"));
	outFields->push(HX_CSTRING("tmpMatrix"));
	outFields->push(HX_CSTRING("tmpMatrix2D"));
	outFields->push(HX_CSTRING("tmpMatrix2D_2"));
	outFields->push(HX_CSTRING("tmpMaterial"));
	outFields->push(HX_CSTRING("planBuffer"));
	outFields->push(HX_CSTRING("emptyTexture"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(CoreObjects_obj,tmpMatA),HX_CSTRING("tmpMatA")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(CoreObjects_obj,tmpMatB),HX_CSTRING("tmpMatB")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(CoreObjects_obj,tmpSize),HX_CSTRING("tmpSize")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(CoreObjects_obj,tmpUVPos),HX_CSTRING("tmpUVPos")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(CoreObjects_obj,tmpUVScale),HX_CSTRING("tmpUVScale")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(CoreObjects_obj,tmpColor),HX_CSTRING("tmpColor")},
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(CoreObjects_obj,tmpMatrix),HX_CSTRING("tmpMatrix")},
	{hx::fsObject /*::h2d::Matrix*/ ,(int)offsetof(CoreObjects_obj,tmpMatrix2D),HX_CSTRING("tmpMatrix2D")},
	{hx::fsObject /*::h2d::Matrix*/ ,(int)offsetof(CoreObjects_obj,tmpMatrix2D_2),HX_CSTRING("tmpMatrix2D_2")},
	{hx::fsObject /*::h3d::mat::Material*/ ,(int)offsetof(CoreObjects_obj,tmpMaterial),HX_CSTRING("tmpMaterial")},
	{hx::fsObject /*::h3d::impl::Buffer*/ ,(int)offsetof(CoreObjects_obj,planBuffer),HX_CSTRING("planBuffer")},
	{hx::fsObject /*::h3d::mat::Texture*/ ,(int)offsetof(CoreObjects_obj,emptyTexture),HX_CSTRING("emptyTexture")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("tmpMatA"),
	HX_CSTRING("tmpMatB"),
	HX_CSTRING("tmpSize"),
	HX_CSTRING("tmpUVPos"),
	HX_CSTRING("tmpUVScale"),
	HX_CSTRING("tmpColor"),
	HX_CSTRING("tmpMatrix"),
	HX_CSTRING("tmpMatrix2D"),
	HX_CSTRING("tmpMatrix2D_2"),
	HX_CSTRING("tmpMaterial"),
	HX_CSTRING("planBuffer"),
	HX_CSTRING("emptyTexture"),
	HX_CSTRING("getEmptyTexture"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(CoreObjects_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(CoreObjects_obj::__mClass,"__mClass");
};

#endif

Class CoreObjects_obj::__mClass;

void CoreObjects_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d._Tools.CoreObjects"), hx::TCanCast< CoreObjects_obj> ,sStaticFields,sMemberFields,
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

void CoreObjects_obj::__boot()
{
}

} // end namespace h2d
} // end namespace _Tools
