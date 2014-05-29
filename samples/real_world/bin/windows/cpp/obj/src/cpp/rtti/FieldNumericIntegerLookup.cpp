#include <hxcpp.h>

#ifndef INCLUDED_cpp_rtti_FieldNumericIntegerLookup
#include <cpp/rtti/FieldNumericIntegerLookup.h>
#endif
namespace cpp{
namespace rtti{


static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FieldNumericIntegerLookup_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FieldNumericIntegerLookup_obj::__mClass,"__mClass");
};

#endif

Class FieldNumericIntegerLookup_obj::__mClass;

void FieldNumericIntegerLookup_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("cpp.rtti.FieldNumericIntegerLookup"), hx::TCanCast< FieldNumericIntegerLookup_obj> ,0,sMemberFields,
	0, 0,
	&super::__SGetClass(), 0, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatics
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void FieldNumericIntegerLookup_obj::__boot()
{
}

} // end namespace cpp
} // end namespace rtti
