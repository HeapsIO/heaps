#include <hxcpp.h>

#ifndef INCLUDED_openfl_gl_GLObject
#include <openfl/gl/GLObject.h>
#endif
#ifndef INCLUDED_openfl_gl_GLProgram
#include <openfl/gl/GLProgram.h>
#endif
#ifndef INCLUDED_openfl_gl_GLShader
#include <openfl/gl/GLShader.h>
#endif
namespace openfl{
namespace gl{

Void GLProgram_obj::__construct(int version,Dynamic id)
{
HX_STACK_FRAME("openfl.gl.GLProgram","new",0xc36fb1e6,"openfl.gl.GLProgram.new","openfl/gl/GLProgram.hx",10,0xb32032ea)
HX_STACK_THIS(this)
HX_STACK_ARG(version,"version")
HX_STACK_ARG(id,"id")
{
	HX_STACK_LINE(12)
	super::__construct(version,id);
	HX_STACK_LINE(13)
	Array< ::Dynamic > _g = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(13)
	this->shaders = _g;
}
;
	return null();
}

//GLProgram_obj::~GLProgram_obj() { }

Dynamic GLProgram_obj::__CreateEmpty() { return  new GLProgram_obj; }
hx::ObjectPtr< GLProgram_obj > GLProgram_obj::__new(int version,Dynamic id)
{  hx::ObjectPtr< GLProgram_obj > result = new GLProgram_obj();
	result->__construct(version,id);
	return result;}

Dynamic GLProgram_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< GLProgram_obj > result = new GLProgram_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

Void GLProgram_obj::attach( ::openfl::gl::GLShader shader){
{
		HX_STACK_FRAME("openfl.gl.GLProgram","attach",0xd16951ff,"openfl.gl.GLProgram.attach","openfl/gl/GLProgram.hx",20,0xb32032ea)
		HX_STACK_THIS(this)
		HX_STACK_ARG(shader,"shader")
		HX_STACK_LINE(20)
		this->shaders->push(shader);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(GLProgram_obj,attach,(void))

Array< ::Dynamic > GLProgram_obj::getShaders( ){
	HX_STACK_FRAME("openfl.gl.GLProgram","getShaders",0x9be202f2,"openfl.gl.GLProgram.getShaders","openfl/gl/GLProgram.hx",27,0xb32032ea)
	HX_STACK_THIS(this)
	HX_STACK_LINE(27)
	return this->shaders->copy();
}


HX_DEFINE_DYNAMIC_FUNC0(GLProgram_obj,getShaders,return )

::String GLProgram_obj::getType( ){
	HX_STACK_FRAME("openfl.gl.GLProgram","getType",0x5c5dbef6,"openfl.gl.GLProgram.getType","openfl/gl/GLProgram.hx",34,0xb32032ea)
	HX_STACK_THIS(this)
	HX_STACK_LINE(34)
	return HX_CSTRING("Program");
}



GLProgram_obj::GLProgram_obj()
{
}

void GLProgram_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(GLProgram);
	HX_MARK_MEMBER_NAME(shaders,"shaders");
	::openfl::gl::GLObject_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void GLProgram_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(shaders,"shaders");
	::openfl::gl::GLObject_obj::__Visit(HX_VISIT_ARG);
}

Dynamic GLProgram_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"attach") ) { return attach_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"shaders") ) { return shaders; }
		if (HX_FIELD_EQ(inName,"getType") ) { return getType_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"getShaders") ) { return getShaders_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic GLProgram_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 7:
		if (HX_FIELD_EQ(inName,"shaders") ) { shaders=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void GLProgram_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("shaders"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(GLProgram_obj,shaders),HX_CSTRING("shaders")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("shaders"),
	HX_CSTRING("attach"),
	HX_CSTRING("getShaders"),
	HX_CSTRING("getType"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(GLProgram_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(GLProgram_obj::__mClass,"__mClass");
};

#endif

Class GLProgram_obj::__mClass;

void GLProgram_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("openfl.gl.GLProgram"), hx::TCanCast< GLProgram_obj> ,sStaticFields,sMemberFields,
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

void GLProgram_obj::__boot()
{
}

} // end namespace openfl
} // end namespace gl
