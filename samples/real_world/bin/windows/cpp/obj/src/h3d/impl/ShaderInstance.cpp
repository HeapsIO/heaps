#include <hxcpp.h>

#ifndef INCLUDED_h3d_impl_Attribute
#include <h3d/impl/Attribute.h>
#endif
#ifndef INCLUDED_h3d_impl_ShaderInstance
#include <h3d/impl/ShaderInstance.h>
#endif
#ifndef INCLUDED_h3d_impl_Uniform
#include <h3d/impl/Uniform.h>
#endif
#ifndef INCLUDED_openfl_gl_GLObject
#include <openfl/gl/GLObject.h>
#endif
#ifndef INCLUDED_openfl_gl_GLProgram
#include <openfl/gl/GLProgram.h>
#endif
namespace h3d{
namespace impl{

Void ShaderInstance_obj::__construct()
{
HX_STACK_FRAME("h3d.impl.ShaderInstance","new",0x8014f285,"h3d.impl.ShaderInstance.new","h3d/impl/Shader.hx",76,0x8487c6c0)
HX_STACK_THIS(this)
{
}
;
	return null();
}

//ShaderInstance_obj::~ShaderInstance_obj() { }

Dynamic ShaderInstance_obj::__CreateEmpty() { return  new ShaderInstance_obj; }
hx::ObjectPtr< ShaderInstance_obj > ShaderInstance_obj::__new()
{  hx::ObjectPtr< ShaderInstance_obj > result = new ShaderInstance_obj();
	result->__construct();
	return result;}

Dynamic ShaderInstance_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< ShaderInstance_obj > result = new ShaderInstance_obj();
	result->__construct();
	return result;}


ShaderInstance_obj::ShaderInstance_obj()
{
}

void ShaderInstance_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(ShaderInstance);
	HX_MARK_MEMBER_NAME(program,"program");
	HX_MARK_MEMBER_NAME(attribs,"attribs");
	HX_MARK_MEMBER_NAME(uniforms,"uniforms");
	HX_MARK_MEMBER_NAME(stride,"stride");
	HX_MARK_END_CLASS();
}

void ShaderInstance_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(program,"program");
	HX_VISIT_MEMBER_NAME(attribs,"attribs");
	HX_VISIT_MEMBER_NAME(uniforms,"uniforms");
	HX_VISIT_MEMBER_NAME(stride,"stride");
}

Dynamic ShaderInstance_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"stride") ) { return stride; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"program") ) { return program; }
		if (HX_FIELD_EQ(inName,"attribs") ) { return attribs; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"uniforms") ) { return uniforms; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic ShaderInstance_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"stride") ) { stride=inValue.Cast< int >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"program") ) { program=inValue.Cast< ::openfl::gl::GLProgram >(); return inValue; }
		if (HX_FIELD_EQ(inName,"attribs") ) { attribs=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"uniforms") ) { uniforms=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void ShaderInstance_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("program"));
	outFields->push(HX_CSTRING("attribs"));
	outFields->push(HX_CSTRING("uniforms"));
	outFields->push(HX_CSTRING("stride"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::openfl::gl::GLProgram*/ ,(int)offsetof(ShaderInstance_obj,program),HX_CSTRING("program")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(ShaderInstance_obj,attribs),HX_CSTRING("attribs")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(ShaderInstance_obj,uniforms),HX_CSTRING("uniforms")},
	{hx::fsInt,(int)offsetof(ShaderInstance_obj,stride),HX_CSTRING("stride")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("program"),
	HX_CSTRING("attribs"),
	HX_CSTRING("uniforms"),
	HX_CSTRING("stride"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(ShaderInstance_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(ShaderInstance_obj::__mClass,"__mClass");
};

#endif

Class ShaderInstance_obj::__mClass;

void ShaderInstance_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.impl.ShaderInstance"), hx::TCanCast< ShaderInstance_obj> ,sStaticFields,sMemberFields,
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

void ShaderInstance_obj::__boot()
{
}

} // end namespace h3d
} // end namespace impl
