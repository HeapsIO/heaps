#include <hxcpp.h>

#ifndef INCLUDED_hxd_poly2tri_Constants
#include <hxd/poly2tri/Constants.h>
#endif
namespace hxd{
namespace poly2tri{

Void Constants_obj::__construct()
{
	return null();
}

//Constants_obj::~Constants_obj() { }

Dynamic Constants_obj::__CreateEmpty() { return  new Constants_obj; }
hx::ObjectPtr< Constants_obj > Constants_obj::__new()
{  hx::ObjectPtr< Constants_obj > result = new Constants_obj();
	result->__construct();
	return result;}

Dynamic Constants_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Constants_obj > result = new Constants_obj();
	result->__construct();
	return result;}

Float Constants_obj::kAlpha;

Float Constants_obj::EPSILON;

Float Constants_obj::PI_2;

Float Constants_obj::PI_3div4;


Constants_obj::Constants_obj()
{
}

Dynamic Constants_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"PI_2") ) { return PI_2; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"kAlpha") ) { return kAlpha; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"EPSILON") ) { return EPSILON; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"PI_3div4") ) { return PI_3div4; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Constants_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"PI_2") ) { PI_2=inValue.Cast< Float >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"kAlpha") ) { kAlpha=inValue.Cast< Float >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"EPSILON") ) { EPSILON=inValue.Cast< Float >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"PI_3div4") ) { PI_3div4=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Constants_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("kAlpha"),
	HX_CSTRING("EPSILON"),
	HX_CSTRING("PI_2"),
	HX_CSTRING("PI_3div4"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Constants_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Constants_obj::kAlpha,"kAlpha");
	HX_MARK_MEMBER_NAME(Constants_obj::EPSILON,"EPSILON");
	HX_MARK_MEMBER_NAME(Constants_obj::PI_2,"PI_2");
	HX_MARK_MEMBER_NAME(Constants_obj::PI_3div4,"PI_3div4");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Constants_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Constants_obj::kAlpha,"kAlpha");
	HX_VISIT_MEMBER_NAME(Constants_obj::EPSILON,"EPSILON");
	HX_VISIT_MEMBER_NAME(Constants_obj::PI_2,"PI_2");
	HX_VISIT_MEMBER_NAME(Constants_obj::PI_3div4,"PI_3div4");
};

#endif

Class Constants_obj::__mClass;

void Constants_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.poly2tri.Constants"), hx::TCanCast< Constants_obj> ,sStaticFields,sMemberFields,
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

void Constants_obj::__boot()
{
	kAlpha= 0.3;
	EPSILON= 1e-12;
	PI_2= 1.5707963267948966;
	PI_3div4= 2.3561944901923448;
}

} // end namespace hxd
} // end namespace poly2tri
