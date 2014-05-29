#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_openfl_gl_GL
#include <openfl/gl/GL.h>
#endif
#ifndef INCLUDED_openfl_gl_GLObject
#include <openfl/gl/GLObject.h>
#endif
namespace openfl{
namespace gl{

Void GLObject_obj::__construct(int version,Dynamic id)
{
HX_STACK_FRAME("openfl.gl.GLObject","new",0x0d7614c1,"openfl.gl.GLObject.new","openfl/gl/GLObject.hx",14,0x56378b2f)
HX_STACK_THIS(this)
HX_STACK_ARG(version,"version")
HX_STACK_ARG(id,"id")
{
	HX_STACK_LINE(16)
	this->version = version;
	HX_STACK_LINE(17)
	this->id = id;
}
;
	return null();
}

//GLObject_obj::~GLObject_obj() { }

Dynamic GLObject_obj::__CreateEmpty() { return  new GLObject_obj; }
hx::ObjectPtr< GLObject_obj > GLObject_obj::__new(int version,Dynamic id)
{  hx::ObjectPtr< GLObject_obj > result = new GLObject_obj();
	result->__construct(version,id);
	return result;}

Dynamic GLObject_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< GLObject_obj > result = new GLObject_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

::String GLObject_obj::getType( ){
	HX_STACK_FRAME("openfl.gl.GLObject","getType",0x7efe2b51,"openfl.gl.GLObject.getType","openfl/gl/GLObject.hx",24,0x56378b2f)
	HX_STACK_THIS(this)
	HX_STACK_LINE(24)
	return HX_CSTRING("GLObject");
}


HX_DEFINE_DYNAMIC_FUNC0(GLObject_obj,getType,return )

Void GLObject_obj::invalidate( ){
{
		HX_STACK_FRAME("openfl.gl.GLObject","invalidate",0x54b5933a,"openfl.gl.GLObject.invalidate","openfl/gl/GLObject.hx",31,0x56378b2f)
		HX_STACK_THIS(this)
		HX_STACK_LINE(31)
		this->id = null();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(GLObject_obj,invalidate,(void))

bool GLObject_obj::isValid( ){
	HX_STACK_FRAME("openfl.gl.GLObject","isValid",0x2db0a193,"openfl.gl.GLObject.isValid","openfl/gl/GLObject.hx",38,0x56378b2f)
	HX_STACK_THIS(this)
	HX_STACK_LINE(38)
	if (((this->id != null()))){
		HX_STACK_LINE(38)
		int _g = ::openfl::gl::GL_obj::get_version();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(38)
		return (this->version == _g);
	}
	else{
		HX_STACK_LINE(38)
		return false;
	}
	HX_STACK_LINE(38)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC0(GLObject_obj,isValid,return )

bool GLObject_obj::isInvalid( ){
	HX_STACK_FRAME("openfl.gl.GLObject","isInvalid",0x47159b4e,"openfl.gl.GLObject.isInvalid","openfl/gl/GLObject.hx",45,0x56378b2f)
	HX_STACK_THIS(this)
	HX_STACK_LINE(45)
	return !(this->isValid());
}


HX_DEFINE_DYNAMIC_FUNC0(GLObject_obj,isInvalid,return )

::String GLObject_obj::toString( ){
	HX_STACK_FRAME("openfl.gl.GLObject","toString",0x5d340cab,"openfl.gl.GLObject.toString","openfl/gl/GLObject.hx",50,0x56378b2f)
	HX_STACK_THIS(this)
	HX_STACK_LINE(52)
	::String _g = this->getType();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(52)
	::String _g1 = (_g + HX_CSTRING("("));		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(52)
	::String _g2 = ::Std_obj::string(this->id);		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(52)
	::String _g3 = (_g1 + _g2);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(52)
	return (_g3 + HX_CSTRING(")"));
}


HX_DEFINE_DYNAMIC_FUNC0(GLObject_obj,toString,return )

bool GLObject_obj::get_invalidated( ){
	HX_STACK_FRAME("openfl.gl.GLObject","get_invalidated",0x45f5bc01,"openfl.gl.GLObject.get_invalidated","openfl/gl/GLObject.hx",66,0x56378b2f)
	HX_STACK_THIS(this)
	HX_STACK_LINE(66)
	return this->isInvalid();
}


HX_DEFINE_DYNAMIC_FUNC0(GLObject_obj,get_invalidated,return )

bool GLObject_obj::get_valid( ){
	HX_STACK_FRAME("openfl.gl.GLObject","get_valid",0x7d311474,"openfl.gl.GLObject.get_valid","openfl/gl/GLObject.hx",73,0x56378b2f)
	HX_STACK_THIS(this)
	HX_STACK_LINE(73)
	return this->isValid();
}


HX_DEFINE_DYNAMIC_FUNC0(GLObject_obj,get_valid,return )


GLObject_obj::GLObject_obj()
{
}

void GLObject_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(GLObject);
	HX_MARK_MEMBER_NAME(id,"id");
	HX_MARK_MEMBER_NAME(invalidated,"invalidated");
	HX_MARK_MEMBER_NAME(valid,"valid");
	HX_MARK_MEMBER_NAME(version,"version");
	HX_MARK_END_CLASS();
}

void GLObject_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(id,"id");
	HX_VISIT_MEMBER_NAME(invalidated,"invalidated");
	HX_VISIT_MEMBER_NAME(valid,"valid");
	HX_VISIT_MEMBER_NAME(version,"version");
}

Dynamic GLObject_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"id") ) { return id; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"valid") ) { return inCallProp ? get_valid() : valid; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"version") ) { return version; }
		if (HX_FIELD_EQ(inName,"getType") ) { return getType_dyn(); }
		if (HX_FIELD_EQ(inName,"isValid") ) { return isValid_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"isInvalid") ) { return isInvalid_dyn(); }
		if (HX_FIELD_EQ(inName,"get_valid") ) { return get_valid_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"invalidate") ) { return invalidate_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"invalidated") ) { return inCallProp ? get_invalidated() : invalidated; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"get_invalidated") ) { return get_invalidated_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic GLObject_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"id") ) { id=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"valid") ) { valid=inValue.Cast< bool >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"version") ) { version=inValue.Cast< int >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"invalidated") ) { invalidated=inValue.Cast< bool >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void GLObject_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("id"));
	outFields->push(HX_CSTRING("invalidated"));
	outFields->push(HX_CSTRING("valid"));
	outFields->push(HX_CSTRING("version"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(GLObject_obj,id),HX_CSTRING("id")},
	{hx::fsBool,(int)offsetof(GLObject_obj,invalidated),HX_CSTRING("invalidated")},
	{hx::fsBool,(int)offsetof(GLObject_obj,valid),HX_CSTRING("valid")},
	{hx::fsInt,(int)offsetof(GLObject_obj,version),HX_CSTRING("version")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("id"),
	HX_CSTRING("invalidated"),
	HX_CSTRING("valid"),
	HX_CSTRING("version"),
	HX_CSTRING("getType"),
	HX_CSTRING("invalidate"),
	HX_CSTRING("isValid"),
	HX_CSTRING("isInvalid"),
	HX_CSTRING("toString"),
	HX_CSTRING("get_invalidated"),
	HX_CSTRING("get_valid"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(GLObject_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(GLObject_obj::__mClass,"__mClass");
};

#endif

Class GLObject_obj::__mClass;

void GLObject_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("openfl.gl.GLObject"), hx::TCanCast< GLObject_obj> ,sStaticFields,sMemberFields,
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

void GLObject_obj::__boot()
{
}

} // end namespace openfl
} // end namespace gl
