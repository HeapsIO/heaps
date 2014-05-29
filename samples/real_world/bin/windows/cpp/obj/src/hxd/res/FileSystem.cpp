#include <hxcpp.h>

#ifndef INCLUDED_hxd_res_FileEntry
#include <hxd/res/FileEntry.h>
#endif
#ifndef INCLUDED_hxd_res_FileSystem
#include <hxd/res/FileSystem.h>
#endif
namespace hxd{
namespace res{

HX_DEFINE_DYNAMIC_FUNC0(FileSystem_obj,getRoot,return )

HX_DEFINE_DYNAMIC_FUNC1(FileSystem_obj,get,return )

HX_DEFINE_DYNAMIC_FUNC1(FileSystem_obj,exists,return )


static ::String sMemberFields[] = {
	HX_CSTRING("getRoot"),
	HX_CSTRING("get"),
	HX_CSTRING("exists"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FileSystem_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FileSystem_obj::__mClass,"__mClass");
};

#endif

Class FileSystem_obj::__mClass;

void FileSystem_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.res.FileSystem"), hx::TCanCast< FileSystem_obj> ,0,sMemberFields,
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

void FileSystem_obj::__boot()
{
}

} // end namespace hxd
} // end namespace res
