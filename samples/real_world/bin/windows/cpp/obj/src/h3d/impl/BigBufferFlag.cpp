#include <hxcpp.h>

#ifndef INCLUDED_h3d_impl_BigBufferFlag
#include <h3d/impl/BigBufferFlag.h>
#endif
namespace h3d{
namespace impl{

::h3d::impl::BigBufferFlag BigBufferFlag_obj::BBF_DYNAMIC;

HX_DEFINE_CREATE_ENUM(BigBufferFlag_obj)

int BigBufferFlag_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("BBF_DYNAMIC")) return 0;
	return super::__FindIndex(inName);
}

int BigBufferFlag_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("BBF_DYNAMIC")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic BigBufferFlag_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("BBF_DYNAMIC")) return BBF_DYNAMIC;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("BBF_DYNAMIC"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(BigBufferFlag_obj::BBF_DYNAMIC,"BBF_DYNAMIC");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(BigBufferFlag_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(BigBufferFlag_obj::BBF_DYNAMIC,"BBF_DYNAMIC");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class BigBufferFlag_obj::__mClass;

Dynamic __Create_BigBufferFlag_obj() { return new BigBufferFlag_obj; }

void BigBufferFlag_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.impl.BigBufferFlag"), hx::TCanCast< BigBufferFlag_obj >,sStaticFields,sMemberFields,
	&__Create_BigBufferFlag_obj, &__Create,
	&super::__SGetClass(), &CreateBigBufferFlag_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void BigBufferFlag_obj::__boot()
{
hx::Static(BBF_DYNAMIC) = hx::CreateEnum< BigBufferFlag_obj >(HX_CSTRING("BBF_DYNAMIC"),0);
}


} // end namespace h3d
} // end namespace impl
