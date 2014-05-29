#include <hxcpp.h>

#ifndef INCLUDED_openfl_gl_GLObject
#include <openfl/gl/GLObject.h>
#endif
#ifndef INCLUDED_openfl_gl_GLTexture
#include <openfl/gl/GLTexture.h>
#endif
namespace openfl{
namespace gl{

Void GLTexture_obj::__construct(int version,Dynamic id)
{
HX_STACK_FRAME("openfl.gl.GLTexture","new",0x02caa7bd,"openfl.gl.GLTexture.new","openfl/gl/GLTexture.hx",9,0x14fd04f3)
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

//GLTexture_obj::~GLTexture_obj() { }

Dynamic GLTexture_obj::__CreateEmpty() { return  new GLTexture_obj; }
hx::ObjectPtr< GLTexture_obj > GLTexture_obj::__new(int version,Dynamic id)
{  hx::ObjectPtr< GLTexture_obj > result = new GLTexture_obj();
	result->__construct(version,id);
	return result;}

Dynamic GLTexture_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< GLTexture_obj > result = new GLTexture_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

::String GLTexture_obj::getType( ){
	HX_STACK_FRAME("openfl.gl.GLTexture","getType",0x47fdec4d,"openfl.gl.GLTexture.getType","openfl/gl/GLTexture.hx",16,0x14fd04f3)
	HX_STACK_THIS(this)
	HX_STACK_LINE(16)
	return HX_CSTRING("Texture");
}



GLTexture_obj::GLTexture_obj()
{
}

Dynamic GLTexture_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 7:
		if (HX_FIELD_EQ(inName,"getType") ) { return getType_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic GLTexture_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void GLTexture_obj::__GetFields(Array< ::String> &outFields)
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
	HX_MARK_MEMBER_NAME(GLTexture_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(GLTexture_obj::__mClass,"__mClass");
};

#endif

Class GLTexture_obj::__mClass;

void GLTexture_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("openfl.gl.GLTexture"), hx::TCanCast< GLTexture_obj> ,sStaticFields,sMemberFields,
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

void GLTexture_obj::__boot()
{
}

} // end namespace openfl
} // end namespace gl
