#include <hxcpp.h>

#ifndef INCLUDED_h3d_impl_FBO
#include <h3d/impl/FBO.h>
#endif
#ifndef INCLUDED_h3d_mat_Texture
#include <h3d/mat/Texture.h>
#endif
#ifndef INCLUDED_openfl_gl_GLFramebuffer
#include <openfl/gl/GLFramebuffer.h>
#endif
#ifndef INCLUDED_openfl_gl_GLObject
#include <openfl/gl/GLObject.h>
#endif
#ifndef INCLUDED_openfl_gl_GLRenderbuffer
#include <openfl/gl/GLRenderbuffer.h>
#endif
namespace h3d{
namespace impl{

Void FBO_obj::__construct()
{
HX_STACK_FRAME("h3d.impl.FBO","new",0xc78144cc,"h3d.impl.FBO.new","h3d/impl/GlDriver.hx",65,0xae6eb278)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(71)
	this->height = (int)0;
	HX_STACK_LINE(70)
	this->width = (int)0;
}
;
	return null();
}

//FBO_obj::~FBO_obj() { }

Dynamic FBO_obj::__CreateEmpty() { return  new FBO_obj; }
hx::ObjectPtr< FBO_obj > FBO_obj::__new()
{  hx::ObjectPtr< FBO_obj > result = new FBO_obj();
	result->__construct();
	return result;}

Dynamic FBO_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< FBO_obj > result = new FBO_obj();
	result->__construct();
	return result;}


FBO_obj::FBO_obj()
{
}

void FBO_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(FBO);
	HX_MARK_MEMBER_NAME(fbo,"fbo");
	HX_MARK_MEMBER_NAME(color,"color");
	HX_MARK_MEMBER_NAME(rbo,"rbo");
	HX_MARK_MEMBER_NAME(width,"width");
	HX_MARK_MEMBER_NAME(height,"height");
	HX_MARK_END_CLASS();
}

void FBO_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(fbo,"fbo");
	HX_VISIT_MEMBER_NAME(color,"color");
	HX_VISIT_MEMBER_NAME(rbo,"rbo");
	HX_VISIT_MEMBER_NAME(width,"width");
	HX_VISIT_MEMBER_NAME(height,"height");
}

Dynamic FBO_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"fbo") ) { return fbo; }
		if (HX_FIELD_EQ(inName,"rbo") ) { return rbo; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"color") ) { return color; }
		if (HX_FIELD_EQ(inName,"width") ) { return width; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"height") ) { return height; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic FBO_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"fbo") ) { fbo=inValue.Cast< ::openfl::gl::GLFramebuffer >(); return inValue; }
		if (HX_FIELD_EQ(inName,"rbo") ) { rbo=inValue.Cast< ::openfl::gl::GLRenderbuffer >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"color") ) { color=inValue.Cast< ::h3d::mat::Texture >(); return inValue; }
		if (HX_FIELD_EQ(inName,"width") ) { width=inValue.Cast< int >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"height") ) { height=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void FBO_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("fbo"));
	outFields->push(HX_CSTRING("color"));
	outFields->push(HX_CSTRING("rbo"));
	outFields->push(HX_CSTRING("width"));
	outFields->push(HX_CSTRING("height"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::openfl::gl::GLFramebuffer*/ ,(int)offsetof(FBO_obj,fbo),HX_CSTRING("fbo")},
	{hx::fsObject /*::h3d::mat::Texture*/ ,(int)offsetof(FBO_obj,color),HX_CSTRING("color")},
	{hx::fsObject /*::openfl::gl::GLRenderbuffer*/ ,(int)offsetof(FBO_obj,rbo),HX_CSTRING("rbo")},
	{hx::fsInt,(int)offsetof(FBO_obj,width),HX_CSTRING("width")},
	{hx::fsInt,(int)offsetof(FBO_obj,height),HX_CSTRING("height")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("fbo"),
	HX_CSTRING("color"),
	HX_CSTRING("rbo"),
	HX_CSTRING("width"),
	HX_CSTRING("height"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FBO_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FBO_obj::__mClass,"__mClass");
};

#endif

Class FBO_obj::__mClass;

void FBO_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.impl.FBO"), hx::TCanCast< FBO_obj> ,sStaticFields,sMemberFields,
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

void FBO_obj::__boot()
{
}

} // end namespace h3d
} // end namespace impl
