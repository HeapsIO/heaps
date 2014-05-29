#include <hxcpp.h>

#ifndef INCLUDED_openfl_gl_GLFramebuffer
#include <openfl/gl/GLFramebuffer.h>
#endif
#ifndef INCLUDED_openfl_gl_GLObject
#include <openfl/gl/GLObject.h>
#endif
namespace openfl{
namespace gl{

Void GLFramebuffer_obj::__construct(int version,Dynamic id)
{
HX_STACK_FRAME("openfl.gl.GLFramebuffer","new",0x2a895ccf,"openfl.gl.GLFramebuffer.new","openfl/gl/GLFramebuffer.hx",9,0xd976e821)
HX_STACK_THIS(this)
HX_STACK_ARG(version,"version")
HX_STACK_ARG(id,"id")
{
	HX_STACK_LINE(9)
	super::__construct(version,id);
}
;
	return null();
}

//GLFramebuffer_obj::~GLFramebuffer_obj() { }

Dynamic GLFramebuffer_obj::__CreateEmpty() { return  new GLFramebuffer_obj; }
hx::ObjectPtr< GLFramebuffer_obj > GLFramebuffer_obj::__new(int version,Dynamic id)
{  hx::ObjectPtr< GLFramebuffer_obj > result = new GLFramebuffer_obj();
	result->__construct(version,id);
	return result;}

Dynamic GLFramebuffer_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< GLFramebuffer_obj > result = new GLFramebuffer_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

::String GLFramebuffer_obj::getType( ){
	HX_STACK_FRAME("openfl.gl.GLFramebuffer","getType",0x0af1925f,"openfl.gl.GLFramebuffer.getType","openfl/gl/GLFramebuffer.hx",16,0xd976e821)
	HX_STACK_THIS(this)
	HX_STACK_LINE(16)
	return HX_CSTRING("Framebuffer");
}



GLFramebuffer_obj::GLFramebuffer_obj()
{
}

Dynamic GLFramebuffer_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 7:
		if (HX_FIELD_EQ(inName,"getType") ) { return getType_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic GLFramebuffer_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void GLFramebuffer_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("getType"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(GLFramebuffer_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(GLFramebuffer_obj::__mClass,"__mClass");
};

#endif

Class GLFramebuffer_obj::__mClass;

void GLFramebuffer_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("openfl.gl.GLFramebuffer"), hx::TCanCast< GLFramebuffer_obj> ,sStaticFields,sMemberFields,
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

void GLFramebuffer_obj::__boot()
{
}

} // end namespace openfl
} // end namespace gl
