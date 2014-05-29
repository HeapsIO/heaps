#include <hxcpp.h>

#ifndef INCLUDED_haxe_zip_FlushMode
#include <haxe/zip/FlushMode.h>
#endif
namespace haxe{
namespace zip{

::haxe::zip::FlushMode FlushMode_obj::BLOCK;

::haxe::zip::FlushMode FlushMode_obj::FINISH;

::haxe::zip::FlushMode FlushMode_obj::FULL;

::haxe::zip::FlushMode FlushMode_obj::NO;

::haxe::zip::FlushMode FlushMode_obj::SYNC;

HX_DEFINE_CREATE_ENUM(FlushMode_obj)

int FlushMode_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("BLOCK")) return 4;
	if (inName==HX_CSTRING("FINISH")) return 3;
	if (inName==HX_CSTRING("FULL")) return 2;
	if (inName==HX_CSTRING("NO")) return 0;
	if (inName==HX_CSTRING("SYNC")) return 1;
	return super::__FindIndex(inName);
}

int FlushMode_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("BLOCK")) return 0;
	if (inName==HX_CSTRING("FINISH")) return 0;
	if (inName==HX_CSTRING("FULL")) return 0;
	if (inName==HX_CSTRING("NO")) return 0;
	if (inName==HX_CSTRING("SYNC")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic FlushMode_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("BLOCK")) return BLOCK;
	if (inName==HX_CSTRING("FINISH")) return FINISH;
	if (inName==HX_CSTRING("FULL")) return FULL;
	if (inName==HX_CSTRING("NO")) return NO;
	if (inName==HX_CSTRING("SYNC")) return SYNC;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("NO"),
	HX_CSTRING("SYNC"),
	HX_CSTRING("FULL"),
	HX_CSTRING("FINISH"),
	HX_CSTRING("BLOCK"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FlushMode_obj::BLOCK,"BLOCK");
	HX_MARK_MEMBER_NAME(FlushMode_obj::FINISH,"FINISH");
	HX_MARK_MEMBER_NAME(FlushMode_obj::FULL,"FULL");
	HX_MARK_MEMBER_NAME(FlushMode_obj::NO,"NO");
	HX_MARK_MEMBER_NAME(FlushMode_obj::SYNC,"SYNC");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FlushMode_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(FlushMode_obj::BLOCK,"BLOCK");
	HX_VISIT_MEMBER_NAME(FlushMode_obj::FINISH,"FINISH");
	HX_VISIT_MEMBER_NAME(FlushMode_obj::FULL,"FULL");
	HX_VISIT_MEMBER_NAME(FlushMode_obj::NO,"NO");
	HX_VISIT_MEMBER_NAME(FlushMode_obj::SYNC,"SYNC");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class FlushMode_obj::__mClass;

Dynamic __Create_FlushMode_obj() { return new FlushMode_obj; }

void FlushMode_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.zip.FlushMode"), hx::TCanCast< FlushMode_obj >,sStaticFields,sMemberFields,
	&__Create_FlushMode_obj, &__Create,
	&super::__SGetClass(), &CreateFlushMode_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void FlushMode_obj::__boot()
{
hx::Static(BLOCK) = hx::CreateEnum< FlushMode_obj >(HX_CSTRING("BLOCK"),4);
hx::Static(FINISH) = hx::CreateEnum< FlushMode_obj >(HX_CSTRING("FINISH"),3);
hx::Static(FULL) = hx::CreateEnum< FlushMode_obj >(HX_CSTRING("FULL"),2);
hx::Static(NO) = hx::CreateEnum< FlushMode_obj >(HX_CSTRING("NO"),0);
hx::Static(SYNC) = hx::CreateEnum< FlushMode_obj >(HX_CSTRING("SYNC"),1);
}


} // end namespace haxe
} // end namespace zip
