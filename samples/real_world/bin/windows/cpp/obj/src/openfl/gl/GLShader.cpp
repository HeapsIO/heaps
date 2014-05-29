#include <hxcpp.h>

#ifndef INCLUDED_openfl_gl_GLObject
#include <openfl/gl/GLObject.h>
#endif
#ifndef INCLUDED_openfl_gl_GLShader
#include <openfl/gl/GLShader.h>
#endif
namespace openfl{
namespace gl{

Void GLShader_obj::__construct(int version,Dynamic id)
{
HX_STACK_FRAME("openfl.gl.GLShader","new",0x79d68027,"openfl.gl.GLShader.new","openfl/gl/GLShader.hx",9,0x420a0e89)
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

//GLShader_obj::~GLShader_obj() { }

Dynamic GLShader_obj::__CreateEmpty() { return  new GLShader_obj; }
hx::ObjectPtr< GLShader_obj > GLShader_obj::__new(int version,Dynamic id)
{  hx::ObjectPtr< GLShader_obj > result = new GLShader_obj();
	result->__construct(version,id);
	return result;}

Dynamic GLShader_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< GLShader_obj > result = new GLShader_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

::String GLShader_obj::getType( ){
	HX_STACK_FRAME("openfl.gl.GLShader","getType",0x364f41b7,"openfl.gl.GLShader.getType","openfl/gl/GLShader.hx",16,0x420a0e89)
	HX_STACK_THIS(this)
	HX_STACK_LINE(16)
	return HX_CSTRING("Shader");
}



GLShader_obj::GLShader_obj()
{
}

Dynamic GLShader_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 7:
		if (HX_FIELD_EQ(inName,"getType") ) { return getType_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic GLShader_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void GLShader_obj::__GetFields(Array< ::String> &outFields)
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
	HX_MARK_MEMBER_NAME(GLShader_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(GLShader_obj::__mClass,"__mClass");
};

#endif

Class GLShader_obj::__mClass;

void GLShader_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("openfl.gl.GLShader"), hx::TCanCast< GLShader_obj> ,sStaticFields,sMemberFields,
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

void GLShader_obj::__boot()
{
}

} // end namespace openfl
} // end namespace gl
