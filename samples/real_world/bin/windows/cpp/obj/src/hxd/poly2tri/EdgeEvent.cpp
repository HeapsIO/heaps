#include <hxcpp.h>

#ifndef INCLUDED_hxd_poly2tri_Edge
#include <hxd/poly2tri/Edge.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_EdgeEvent
#include <hxd/poly2tri/EdgeEvent.h>
#endif
namespace hxd{
namespace poly2tri{

Void EdgeEvent_obj::__construct()
{
HX_STACK_FRAME("hxd.poly2tri.EdgeEvent","new",0xe39fc220,"hxd.poly2tri.EdgeEvent.new","hxd/poly2tri/EdgeEvent.hx",9,0x0f18a930)
HX_STACK_THIS(this)
{
}
;
	return null();
}

//EdgeEvent_obj::~EdgeEvent_obj() { }

Dynamic EdgeEvent_obj::__CreateEmpty() { return  new EdgeEvent_obj; }
hx::ObjectPtr< EdgeEvent_obj > EdgeEvent_obj::__new()
{  hx::ObjectPtr< EdgeEvent_obj > result = new EdgeEvent_obj();
	result->__construct();
	return result;}

Dynamic EdgeEvent_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< EdgeEvent_obj > result = new EdgeEvent_obj();
	result->__construct();
	return result;}


EdgeEvent_obj::EdgeEvent_obj()
{
}

void EdgeEvent_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(EdgeEvent);
	HX_MARK_MEMBER_NAME(constrained_edge,"constrained_edge");
	HX_MARK_MEMBER_NAME(right,"right");
	HX_MARK_END_CLASS();
}

void EdgeEvent_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(constrained_edge,"constrained_edge");
	HX_VISIT_MEMBER_NAME(right,"right");
}

Dynamic EdgeEvent_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"right") ) { return right; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"constrained_edge") ) { return constrained_edge; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic EdgeEvent_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"right") ) { right=inValue.Cast< bool >(); return inValue; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"constrained_edge") ) { constrained_edge=inValue.Cast< ::hxd::poly2tri::Edge >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void EdgeEvent_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("constrained_edge"));
	outFields->push(HX_CSTRING("right"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::hxd::poly2tri::Edge*/ ,(int)offsetof(EdgeEvent_obj,constrained_edge),HX_CSTRING("constrained_edge")},
	{hx::fsBool,(int)offsetof(EdgeEvent_obj,right),HX_CSTRING("right")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("constrained_edge"),
	HX_CSTRING("right"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(EdgeEvent_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(EdgeEvent_obj::__mClass,"__mClass");
};

#endif

Class EdgeEvent_obj::__mClass;

void EdgeEvent_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.poly2tri.EdgeEvent"), hx::TCanCast< EdgeEvent_obj> ,sStaticFields,sMemberFields,
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

void EdgeEvent_obj::__boot()
{
}

} // end namespace hxd
} // end namespace poly2tri
