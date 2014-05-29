#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif

HX_DEFINE_DYNAMIC_FUNC1(IMap_obj,get,return )

HX_DEFINE_DYNAMIC_FUNC2(IMap_obj,set,)

HX_DEFINE_DYNAMIC_FUNC1(IMap_obj,exists,return )

HX_DEFINE_DYNAMIC_FUNC1(IMap_obj,remove,return )

HX_DEFINE_DYNAMIC_FUNC0(IMap_obj,keys,return )

HX_DEFINE_DYNAMIC_FUNC0(IMap_obj,iterator,return )

HX_DEFINE_DYNAMIC_FUNC0(IMap_obj,toString,return )


static ::String sMemberFields[] = {
	HX_CSTRING("get"),
	HX_CSTRING("set"),
	HX_CSTRING("exists"),
	HX_CSTRING("remove"),
	HX_CSTRING("keys"),
	HX_CSTRING("iterator"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(IMap_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(IMap_obj::__mClass,"__mClass");
};

#endif

Class IMap_obj::__mClass;

void IMap_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("IMap"), hx::TCanCast< IMap_obj> ,0,sMemberFields,
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

void IMap_obj::__boot()
{
}

