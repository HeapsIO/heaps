#include <hxcpp.h>

#ifndef INCLUDED_h3d_anim_LinearFrame
#include <h3d/anim/LinearFrame.h>
#endif
namespace h3d{
namespace anim{

Void LinearFrame_obj::__construct()
{
HX_STACK_FRAME("h3d.anim.LinearFrame","new",0x631d43d2,"h3d.anim.LinearFrame.new","h3d/anim/LinearAnimation.hx",15,0x1f025447)
HX_STACK_THIS(this)
{
}
;
	return null();
}

//LinearFrame_obj::~LinearFrame_obj() { }

Dynamic LinearFrame_obj::__CreateEmpty() { return  new LinearFrame_obj; }
hx::ObjectPtr< LinearFrame_obj > LinearFrame_obj::__new()
{  hx::ObjectPtr< LinearFrame_obj > result = new LinearFrame_obj();
	result->__construct();
	return result;}

Dynamic LinearFrame_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< LinearFrame_obj > result = new LinearFrame_obj();
	result->__construct();
	return result;}


LinearFrame_obj::LinearFrame_obj()
{
}

Dynamic LinearFrame_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"tx") ) { return tx; }
		if (HX_FIELD_EQ(inName,"ty") ) { return ty; }
		if (HX_FIELD_EQ(inName,"tz") ) { return tz; }
		if (HX_FIELD_EQ(inName,"qx") ) { return qx; }
		if (HX_FIELD_EQ(inName,"qy") ) { return qy; }
		if (HX_FIELD_EQ(inName,"qz") ) { return qz; }
		if (HX_FIELD_EQ(inName,"qw") ) { return qw; }
		if (HX_FIELD_EQ(inName,"sx") ) { return sx; }
		if (HX_FIELD_EQ(inName,"sy") ) { return sy; }
		if (HX_FIELD_EQ(inName,"sz") ) { return sz; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic LinearFrame_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"tx") ) { tx=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"ty") ) { ty=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"tz") ) { tz=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"qx") ) { qx=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"qy") ) { qy=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"qz") ) { qz=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"qw") ) { qw=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"sx") ) { sx=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"sy") ) { sy=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"sz") ) { sz=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void LinearFrame_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("tx"));
	outFields->push(HX_CSTRING("ty"));
	outFields->push(HX_CSTRING("tz"));
	outFields->push(HX_CSTRING("qx"));
	outFields->push(HX_CSTRING("qy"));
	outFields->push(HX_CSTRING("qz"));
	outFields->push(HX_CSTRING("qw"));
	outFields->push(HX_CSTRING("sx"));
	outFields->push(HX_CSTRING("sy"));
	outFields->push(HX_CSTRING("sz"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(LinearFrame_obj,tx),HX_CSTRING("tx")},
	{hx::fsFloat,(int)offsetof(LinearFrame_obj,ty),HX_CSTRING("ty")},
	{hx::fsFloat,(int)offsetof(LinearFrame_obj,tz),HX_CSTRING("tz")},
	{hx::fsFloat,(int)offsetof(LinearFrame_obj,qx),HX_CSTRING("qx")},
	{hx::fsFloat,(int)offsetof(LinearFrame_obj,qy),HX_CSTRING("qy")},
	{hx::fsFloat,(int)offsetof(LinearFrame_obj,qz),HX_CSTRING("qz")},
	{hx::fsFloat,(int)offsetof(LinearFrame_obj,qw),HX_CSTRING("qw")},
	{hx::fsFloat,(int)offsetof(LinearFrame_obj,sx),HX_CSTRING("sx")},
	{hx::fsFloat,(int)offsetof(LinearFrame_obj,sy),HX_CSTRING("sy")},
	{hx::fsFloat,(int)offsetof(LinearFrame_obj,sz),HX_CSTRING("sz")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("tx"),
	HX_CSTRING("ty"),
	HX_CSTRING("tz"),
	HX_CSTRING("qx"),
	HX_CSTRING("qy"),
	HX_CSTRING("qz"),
	HX_CSTRING("qw"),
	HX_CSTRING("sx"),
	HX_CSTRING("sy"),
	HX_CSTRING("sz"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(LinearFrame_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(LinearFrame_obj::__mClass,"__mClass");
};

#endif

Class LinearFrame_obj::__mClass;

void LinearFrame_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.anim.LinearFrame"), hx::TCanCast< LinearFrame_obj> ,sStaticFields,sMemberFields,
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

void LinearFrame_obj::__boot()
{
}

} // end namespace h3d
} // end namespace anim
