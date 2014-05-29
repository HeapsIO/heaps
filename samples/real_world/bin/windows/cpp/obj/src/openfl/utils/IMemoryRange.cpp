#include <hxcpp.h>

#ifndef INCLUDED_flash_utils_ByteArray
#include <flash/utils/ByteArray.h>
#endif
#ifndef INCLUDED_flash_utils_IDataInput
#include <flash/utils/IDataInput.h>
#endif
#ifndef INCLUDED_flash_utils_IDataOutput
#include <flash/utils/IDataOutput.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_openfl_utils_IMemoryRange
#include <openfl/utils/IMemoryRange.h>
#endif
namespace openfl{
namespace utils{

HX_DEFINE_DYNAMIC_FUNC0(IMemoryRange_obj,getByteBuffer,return )

HX_DEFINE_DYNAMIC_FUNC0(IMemoryRange_obj,getStart,return )

HX_DEFINE_DYNAMIC_FUNC0(IMemoryRange_obj,getLength,return )


static ::String sMemberFields[] = {
	HX_CSTRING("getByteBuffer"),
	HX_CSTRING("getStart"),
	HX_CSTRING("getLength"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(IMemoryRange_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(IMemoryRange_obj::__mClass,"__mClass");
};

#endif

Class IMemoryRange_obj::__mClass;

void IMemoryRange_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("openfl.utils.IMemoryRange"), hx::TCanCast< IMemoryRange_obj> ,0,sMemberFields,
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

void IMemoryRange_obj::__boot()
{
}

} // end namespace openfl
} // end namespace utils
