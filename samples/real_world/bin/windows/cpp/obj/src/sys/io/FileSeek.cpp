#include <hxcpp.h>

#ifndef INCLUDED_sys_io_FileSeek
#include <sys/io/FileSeek.h>
#endif
namespace sys{
namespace io{

::sys::io::FileSeek FileSeek_obj::SeekBegin;

::sys::io::FileSeek FileSeek_obj::SeekCur;

::sys::io::FileSeek FileSeek_obj::SeekEnd;

HX_DEFINE_CREATE_ENUM(FileSeek_obj)

int FileSeek_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("SeekBegin")) return 0;
	if (inName==HX_CSTRING("SeekCur")) return 1;
	if (inName==HX_CSTRING("SeekEnd")) return 2;
	return super::__FindIndex(inName);
}

int FileSeek_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("SeekBegin")) return 0;
	if (inName==HX_CSTRING("SeekCur")) return 0;
	if (inName==HX_CSTRING("SeekEnd")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic FileSeek_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("SeekBegin")) return SeekBegin;
	if (inName==HX_CSTRING("SeekCur")) return SeekCur;
	if (inName==HX_CSTRING("SeekEnd")) return SeekEnd;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("SeekBegin"),
	HX_CSTRING("SeekCur"),
	HX_CSTRING("SeekEnd"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FileSeek_obj::SeekBegin,"SeekBegin");
	HX_MARK_MEMBER_NAME(FileSeek_obj::SeekCur,"SeekCur");
	HX_MARK_MEMBER_NAME(FileSeek_obj::SeekEnd,"SeekEnd");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FileSeek_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(FileSeek_obj::SeekBegin,"SeekBegin");
	HX_VISIT_MEMBER_NAME(FileSeek_obj::SeekCur,"SeekCur");
	HX_VISIT_MEMBER_NAME(FileSeek_obj::SeekEnd,"SeekEnd");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class FileSeek_obj::__mClass;

Dynamic __Create_FileSeek_obj() { return new FileSeek_obj; }

void FileSeek_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("sys.io.FileSeek"), hx::TCanCast< FileSeek_obj >,sStaticFields,sMemberFields,
	&__Create_FileSeek_obj, &__Create,
	&super::__SGetClass(), &CreateFileSeek_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void FileSeek_obj::__boot()
{
hx::Static(SeekBegin) = hx::CreateEnum< FileSeek_obj >(HX_CSTRING("SeekBegin"),0);
hx::Static(SeekCur) = hx::CreateEnum< FileSeek_obj >(HX_CSTRING("SeekCur"),1);
hx::Static(SeekEnd) = hx::CreateEnum< FileSeek_obj >(HX_CSTRING("SeekEnd"),2);
}


} // end namespace sys
} // end namespace io
