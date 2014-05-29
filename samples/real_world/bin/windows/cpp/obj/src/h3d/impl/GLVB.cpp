#include <hxcpp.h>

#ifndef INCLUDED_h3d_impl_GLVB
#include <h3d/impl/GLVB.h>
#endif
#ifndef INCLUDED_openfl_gl_GLBuffer
#include <openfl/gl/GLBuffer.h>
#endif
#ifndef INCLUDED_openfl_gl_GLObject
#include <openfl/gl/GLObject.h>
#endif
namespace h3d{
namespace impl{

Void GLVB_obj::__construct(::openfl::gl::GLBuffer b,hx::Null< int >  __o_s)
{
HX_STACK_FRAME("h3d.impl.GLVB","new",0xc8e0415c,"h3d.impl.GLVB.new","h3d/impl/Driver.hx",25,0xe373499d)
HX_STACK_THIS(this)
HX_STACK_ARG(b,"b")
HX_STACK_ARG(__o_s,"s")
int s = __o_s.Default(0);
{
	HX_STACK_LINE(25)
	this->b = b;
	HX_STACK_LINE(25)
	this->stride = s;
}
;
	return null();
}

//GLVB_obj::~GLVB_obj() { }

Dynamic GLVB_obj::__CreateEmpty() { return  new GLVB_obj; }
hx::ObjectPtr< GLVB_obj > GLVB_obj::__new(::openfl::gl::GLBuffer b,hx::Null< int >  __o_s)
{  hx::ObjectPtr< GLVB_obj > result = new GLVB_obj();
	result->__construct(b,__o_s);
	return result;}

Dynamic GLVB_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< GLVB_obj > result = new GLVB_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}


GLVB_obj::GLVB_obj()
{
}

void GLVB_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(GLVB);
	HX_MARK_MEMBER_NAME(b,"b");
	HX_MARK_MEMBER_NAME(stride,"stride");
	HX_MARK_END_CLASS();
}

void GLVB_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(b,"b");
	HX_VISIT_MEMBER_NAME(stride,"stride");
}

Dynamic GLVB_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"b") ) { return b; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"stride") ) { return stride; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic GLVB_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"b") ) { b=inValue.Cast< ::openfl::gl::GLBuffer >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"stride") ) { stride=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void GLVB_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("b"));
	outFields->push(HX_CSTRING("stride"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::openfl::gl::GLBuffer*/ ,(int)offsetof(GLVB_obj,b),HX_CSTRING("b")},
	{hx::fsInt,(int)offsetof(GLVB_obj,stride),HX_CSTRING("stride")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("b"),
	HX_CSTRING("stride"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(GLVB_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(GLVB_obj::__mClass,"__mClass");
};

#endif

Class GLVB_obj::__mClass;

void GLVB_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.impl.GLVB"), hx::TCanCast< GLVB_obj> ,sStaticFields,sMemberFields,
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

void GLVB_obj::__boot()
{
}

} // end namespace h3d
} // end namespace impl
