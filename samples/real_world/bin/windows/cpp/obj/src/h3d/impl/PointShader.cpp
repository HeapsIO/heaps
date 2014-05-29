#include <hxcpp.h>

#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
#endif
#ifndef INCLUDED_h3d_Vector
#include <h3d/Vector.h>
#endif
#ifndef INCLUDED_h3d_impl_PointShader
#include <h3d/impl/PointShader.h>
#endif
#ifndef INCLUDED_h3d_impl_Shader
#include <h3d/impl/Shader.h>
#endif
namespace h3d{
namespace impl{

Void PointShader_obj::__construct()
{
HX_STACK_FRAME("h3d.impl.PointShader","new",0xab42c0ae,"h3d.impl.PointShader.new","h3d/impl/Shaders.hx",4,0x9fb5c9e9)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(4)
	super::__construct();
}
;
	return null();
}

//PointShader_obj::~PointShader_obj() { }

Dynamic PointShader_obj::__CreateEmpty() { return  new PointShader_obj; }
hx::ObjectPtr< PointShader_obj > PointShader_obj::__new()
{  hx::ObjectPtr< PointShader_obj > result = new PointShader_obj();
	result->__construct();
	return result;}

Dynamic PointShader_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< PointShader_obj > result = new PointShader_obj();
	result->__construct();
	return result;}

::String PointShader_obj::VERTEX;

::String PointShader_obj::FRAGMENT;


PointShader_obj::PointShader_obj()
{
}

void PointShader_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(PointShader);
	HX_MARK_MEMBER_NAME(mproj,"mproj");
	HX_MARK_MEMBER_NAME(delta,"delta");
	HX_MARK_MEMBER_NAME(size,"size");
	HX_MARK_MEMBER_NAME(color,"color");
	::h3d::impl::Shader_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void PointShader_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(mproj,"mproj");
	HX_VISIT_MEMBER_NAME(delta,"delta");
	HX_VISIT_MEMBER_NAME(size,"size");
	HX_VISIT_MEMBER_NAME(color,"color");
	::h3d::impl::Shader_obj::__Visit(HX_VISIT_ARG);
}

Dynamic PointShader_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"size") ) { return size; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"mproj") ) { return mproj; }
		if (HX_FIELD_EQ(inName,"delta") ) { return delta; }
		if (HX_FIELD_EQ(inName,"color") ) { return color; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"VERTEX") ) { return VERTEX; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"FRAGMENT") ) { return FRAGMENT; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic PointShader_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"size") ) { size=inValue.Cast< ::h3d::Vector >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"mproj") ) { mproj=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		if (HX_FIELD_EQ(inName,"delta") ) { delta=inValue.Cast< ::h3d::Vector >(); return inValue; }
		if (HX_FIELD_EQ(inName,"color") ) { color=inValue.Cast< int >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"VERTEX") ) { VERTEX=inValue.Cast< ::String >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"FRAGMENT") ) { FRAGMENT=inValue.Cast< ::String >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void PointShader_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("mproj"));
	outFields->push(HX_CSTRING("delta"));
	outFields->push(HX_CSTRING("size"));
	outFields->push(HX_CSTRING("color"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("VERTEX"),
	HX_CSTRING("FRAGMENT"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(PointShader_obj,mproj),HX_CSTRING("mproj")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(PointShader_obj,delta),HX_CSTRING("delta")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(PointShader_obj,size),HX_CSTRING("size")},
	{hx::fsInt,(int)offsetof(PointShader_obj,color),HX_CSTRING("color")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("mproj"),
	HX_CSTRING("delta"),
	HX_CSTRING("size"),
	HX_CSTRING("color"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(PointShader_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(PointShader_obj::VERTEX,"VERTEX");
	HX_MARK_MEMBER_NAME(PointShader_obj::FRAGMENT,"FRAGMENT");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(PointShader_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(PointShader_obj::VERTEX,"VERTEX");
	HX_VISIT_MEMBER_NAME(PointShader_obj::FRAGMENT,"FRAGMENT");
};

#endif

Class PointShader_obj::__mClass;

void PointShader_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.impl.PointShader"), hx::TCanCast< PointShader_obj> ,sStaticFields,sMemberFields,
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

void PointShader_obj::__boot()
{
	VERTEX= HX_CSTRING("\r\n\t\tattribute vec2 pos;\r\n\t\tvarying mediump vec2 tuv;\r\n\t\tuniform mat4 mproj;\r\n\t\tuniform vec4 delta;\r\n\t\tuniform vec2 size;\r\n\t\t\r\n\t\tvoid main(void) {\r\n\t\t\tvec4 p = delta * mproj;\r\n\t\t\tp.xy += pos.xy * size * p.z;\r\n\t\t\ttuv = pos;\r\n\t\t\tgl_Position = p;\r\n\t\t}\r\n\t");
	FRAGMENT= HX_CSTRING("\r\n\t\tvarying mediump vec2 tuv;\r\n\t\tuniform vec4 color /*byte4*/;\r\n\t\t\r\n\t\tvoid main(void) {\r\n\t\t\tif( 1.0 - dot(tuv, tuv) < 0.0 ) discard;\r\n\t\t\tgl_FragColor = color;\r\n\t\t}\r\n\t");
}

} // end namespace h3d
} // end namespace impl
