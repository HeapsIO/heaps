#include <hxcpp.h>

#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
#endif
#ifndef INCLUDED_h3d_Vector
#include <h3d/Vector.h>
#endif
#ifndef INCLUDED_h3d_impl_LineShader
#include <h3d/impl/LineShader.h>
#endif
#ifndef INCLUDED_h3d_impl_Shader
#include <h3d/impl/Shader.h>
#endif
namespace h3d{
namespace impl{

Void LineShader_obj::__construct()
{
HX_STACK_FRAME("h3d.impl.LineShader","new",0x14f7efe4,"h3d.impl.LineShader.new","h3d/impl/Shaders.hx",54,0x9fb5c9e9)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(54)
	super::__construct();
}
;
	return null();
}

//LineShader_obj::~LineShader_obj() { }

Dynamic LineShader_obj::__CreateEmpty() { return  new LineShader_obj; }
hx::ObjectPtr< LineShader_obj > LineShader_obj::__new()
{  hx::ObjectPtr< LineShader_obj > result = new LineShader_obj();
	result->__construct();
	return result;}

Dynamic LineShader_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< LineShader_obj > result = new LineShader_obj();
	result->__construct();
	return result;}

::String LineShader_obj::VERTEX;

::String LineShader_obj::FRAGMENT;


LineShader_obj::LineShader_obj()
{
}

void LineShader_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(LineShader);
	HX_MARK_MEMBER_NAME(mproj,"mproj");
	HX_MARK_MEMBER_NAME(start,"start");
	HX_MARK_MEMBER_NAME(end,"end");
	HX_MARK_MEMBER_NAME(color,"color");
	::h3d::impl::Shader_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void LineShader_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(mproj,"mproj");
	HX_VISIT_MEMBER_NAME(start,"start");
	HX_VISIT_MEMBER_NAME(end,"end");
	HX_VISIT_MEMBER_NAME(color,"color");
	::h3d::impl::Shader_obj::__Visit(HX_VISIT_ARG);
}

Dynamic LineShader_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"end") ) { return end; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"mproj") ) { return mproj; }
		if (HX_FIELD_EQ(inName,"start") ) { return start; }
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

Dynamic LineShader_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"end") ) { end=inValue.Cast< ::h3d::Vector >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"mproj") ) { mproj=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		if (HX_FIELD_EQ(inName,"start") ) { start=inValue.Cast< ::h3d::Vector >(); return inValue; }
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

void LineShader_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("mproj"));
	outFields->push(HX_CSTRING("start"));
	outFields->push(HX_CSTRING("end"));
	outFields->push(HX_CSTRING("color"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("VERTEX"),
	HX_CSTRING("FRAGMENT"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(LineShader_obj,mproj),HX_CSTRING("mproj")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(LineShader_obj,start),HX_CSTRING("start")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(LineShader_obj,end),HX_CSTRING("end")},
	{hx::fsInt,(int)offsetof(LineShader_obj,color),HX_CSTRING("color")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("mproj"),
	HX_CSTRING("start"),
	HX_CSTRING("end"),
	HX_CSTRING("color"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(LineShader_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(LineShader_obj::VERTEX,"VERTEX");
	HX_MARK_MEMBER_NAME(LineShader_obj::FRAGMENT,"FRAGMENT");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(LineShader_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(LineShader_obj::VERTEX,"VERTEX");
	HX_VISIT_MEMBER_NAME(LineShader_obj::FRAGMENT,"FRAGMENT");
};

#endif

Class LineShader_obj::__mClass;

void LineShader_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.impl.LineShader"), hx::TCanCast< LineShader_obj> ,sStaticFields,sMemberFields,
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

void LineShader_obj::__boot()
{
	VERTEX= HX_CSTRING("\r\n\t\tattribute vec2 pos; \r\n\t\t\r\n\t\tuniform mat4 mproj;\r\n\t\tuniform vec4 start;\r\n\t\tuniform vec4 end;\r\n\t\t\r\n\t\tvoid main(void) {\r\n\t\t\t\r\n\t\t\tvec4 spos = start*mproj;\r\n\t\t\tvec4 epos = end*mproj;\r\n\t\t\tvec2 delta = epos.xy  - spos.xy;\r\n\t\t\tnormalize(delta);\r\n\t\t\t\r\n\t\t\tvec4 p = (epos - spos) * (pos.x + 1.0) * 0.5 + spos;\r\n\t\t\tp.xy += delta.yx * pos.y * p.z / 400.0;\r\n\t\t\tgl_Position = p;\r\n\t\t}\r\n\t");
	FRAGMENT= HX_CSTRING("\r\n\t\tuniform vec4 color /*byte4*/;\r\n\t\tvoid main(void) {\r\n\t\t\tgl_FragColor = color;\r\n\t\t}\r\n\t");
}

} // end namespace h3d
} // end namespace impl
