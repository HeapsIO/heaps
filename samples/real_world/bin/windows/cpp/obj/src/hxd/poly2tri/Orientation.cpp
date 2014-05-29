#include <hxcpp.h>

#ifndef INCLUDED_hxd_poly2tri_Constants
#include <hxd/poly2tri/Constants.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Orientation
#include <hxd/poly2tri/Orientation.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Point
#include <hxd/poly2tri/Point.h>
#endif
namespace hxd{
namespace poly2tri{

Void Orientation_obj::__construct()
{
	return null();
}

//Orientation_obj::~Orientation_obj() { }

Dynamic Orientation_obj::__CreateEmpty() { return  new Orientation_obj; }
hx::ObjectPtr< Orientation_obj > Orientation_obj::__new()
{  hx::ObjectPtr< Orientation_obj > result = new Orientation_obj();
	result->__construct();
	return result;}

Dynamic Orientation_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Orientation_obj > result = new Orientation_obj();
	result->__construct();
	return result;}

int Orientation_obj::CW;

int Orientation_obj::CCW;

int Orientation_obj::COLLINEAR;

int Orientation_obj::orient2d( ::hxd::poly2tri::Point pa,::hxd::poly2tri::Point pb,::hxd::poly2tri::Point pc){
	HX_STACK_FRAME("hxd.poly2tri.Orientation","orient2d",0x39618e64,"hxd.poly2tri.Orientation.orient2d","hxd/poly2tri/Orientation.hx",10,0xb9e3e89d)
	HX_STACK_ARG(pa,"pa")
	HX_STACK_ARG(pb,"pb")
	HX_STACK_ARG(pc,"pc")
	HX_STACK_LINE(11)
	Float detleft = (((pa->x - pc->x)) * ((pb->y - pc->y)));		HX_STACK_VAR(detleft,"detleft");
	HX_STACK_LINE(12)
	Float detright = (((pa->y - pc->y)) * ((pb->x - pc->x)));		HX_STACK_VAR(detright,"detright");
	HX_STACK_LINE(13)
	Float val = (detleft - detright);		HX_STACK_VAR(val,"val");
	HX_STACK_LINE(18)
	if (((bool((val > -(::hxd::poly2tri::Constants_obj::EPSILON))) && bool((val < ::hxd::poly2tri::Constants_obj::EPSILON))))){
		HX_STACK_LINE(18)
		return (int)0;
	}
	HX_STACK_LINE(20)
	if (((val > (int)0))){
		HX_STACK_LINE(20)
		return (int)-1;
	}
	HX_STACK_LINE(21)
	return (int)1;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Orientation_obj,orient2d,return )


Orientation_obj::Orientation_obj()
{
}

Dynamic Orientation_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 8:
		if (HX_FIELD_EQ(inName,"orient2d") ) { return orient2d_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Orientation_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void Orientation_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("CW"),
	HX_CSTRING("CCW"),
	HX_CSTRING("COLLINEAR"),
	HX_CSTRING("orient2d"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Orientation_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Orientation_obj::CW,"CW");
	HX_MARK_MEMBER_NAME(Orientation_obj::CCW,"CCW");
	HX_MARK_MEMBER_NAME(Orientation_obj::COLLINEAR,"COLLINEAR");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Orientation_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Orientation_obj::CW,"CW");
	HX_VISIT_MEMBER_NAME(Orientation_obj::CCW,"CCW");
	HX_VISIT_MEMBER_NAME(Orientation_obj::COLLINEAR,"COLLINEAR");
};

#endif

Class Orientation_obj::__mClass;

void Orientation_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.poly2tri.Orientation"), hx::TCanCast< Orientation_obj> ,sStaticFields,sMemberFields,
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

void Orientation_obj::__boot()
{
	CW= (int)1;
	CCW= (int)-1;
	COLLINEAR= (int)0;
}

} // end namespace hxd
} // end namespace poly2tri
