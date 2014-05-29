#include <hxcpp.h>

#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
#endif
#ifndef INCLUDED_h3d_Vector
#include <h3d/Vector.h>
#endif
#ifndef INCLUDED_h3d_impl_ColorShader
#include <h3d/impl/ColorShader.h>
#endif
#ifndef INCLUDED_h3d_impl_Shader
#include <h3d/impl/Shader.h>
#endif
namespace h3d{
namespace impl{

Void ColorShader_obj::__construct()
{
HX_STACK_FRAME("h3d.impl.ColorShader","new",0x2bbfb381,"h3d.impl.ColorShader.new","h3d/impl/Shaders.hx",110,0x9fb5c9e9)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(110)
	super::__construct();
}
;
	return null();
}

//ColorShader_obj::~ColorShader_obj() { }

Dynamic ColorShader_obj::__CreateEmpty() { return  new ColorShader_obj; }
hx::ObjectPtr< ColorShader_obj > ColorShader_obj::__new()
{  hx::ObjectPtr< ColorShader_obj > result = new ColorShader_obj();
	result->__construct();
	return result;}

Dynamic ColorShader_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< ColorShader_obj > result = new ColorShader_obj();
	result->__construct();
	return result;}

::String ColorShader_obj::VERTEX;

::String ColorShader_obj::FRAGMENT;


ColorShader_obj::ColorShader_obj()
{
}

void ColorShader_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(ColorShader);
	HX_MARK_MEMBER_NAME(mproj,"mproj");
	HX_MARK_MEMBER_NAME(mpos,"mpos");
	HX_MARK_MEMBER_NAME(col,"col");
	::h3d::impl::Shader_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void ColorShader_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(mproj,"mproj");
	HX_VISIT_MEMBER_NAME(mpos,"mpos");
	HX_VISIT_MEMBER_NAME(col,"col");
	::h3d::impl::Shader_obj::__Visit(HX_VISIT_ARG);
}

Dynamic ColorShader_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"col") ) { return col; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"mpos") ) { return mpos; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"mproj") ) { return mproj; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"VERTEX") ) { return VERTEX; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"FRAGMENT") ) { return FRAGMENT; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic ColorShader_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"col") ) { col=inValue.Cast< ::h3d::Vector >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"mpos") ) { mpos=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"mproj") ) { mproj=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"VERTEX") ) { VERTEX=inValue.Cast< ::String >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"FRAGMENT") ) { FRAGMENT=inValue.Cast< ::String >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void ColorShader_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("mproj"));
	outFields->push(HX_CSTRING("mpos"));
	outFields->push(HX_CSTRING("col"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("VERTEX"),
	HX_CSTRING("FRAGMENT"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(ColorShader_obj,mproj),HX_CSTRING("mproj")},
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(ColorShader_obj,mpos),HX_CSTRING("mpos")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(ColorShader_obj,col),HX_CSTRING("col")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("mproj"),
	HX_CSTRING("mpos"),
	HX_CSTRING("col"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(ColorShader_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(ColorShader_obj::VERTEX,"VERTEX");
	HX_MARK_MEMBER_NAME(ColorShader_obj::FRAGMENT,"FRAGMENT");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(ColorShader_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(ColorShader_obj::VERTEX,"VERTEX");
	HX_VISIT_MEMBER_NAME(ColorShader_obj::FRAGMENT,"FRAGMENT");
};

#endif

Class ColorShader_obj::__mClass;

void ColorShader_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.impl.ColorShader"), hx::TCanCast< ColorShader_obj> ,sStaticFields,sMemberFields,
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

void ColorShader_obj::__boot()
{
	VERTEX= HX_CSTRING("\r\n\t\tattribute vec3 pos;\r\n\t\tuniform mat4 mproj;\r\n\t\tuniform mat4 mpos;\r\n\t\tuniform vec4 col;\r\n\t\t\r\n\t\tvoid main(void) {\r\n\t\t\tvertexColor = col;\r\n\t\t\tgl_Position = vec4(pos.xyz,1)*mpos*mproj;\r\n\t\t}\r\n\t");
	FRAGMENT= HX_CSTRING("\r\n\t\tvarying vec4 vertexColor;\r\n\t\tvoid main(void) {\r\n\t\t\tgl_FragColor = vertexColor;\r\n\t\t}\r\n\t");
}

} // end namespace h3d
} // end namespace impl
