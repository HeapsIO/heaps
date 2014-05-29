#include <hxcpp.h>

#ifndef INCLUDED_flash_utils_IDataOutput
#include <flash/utils/IDataOutput.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
namespace flash{
namespace utils{

HX_DEFINE_DYNAMIC_FUNC1(IDataOutput_obj,writeBoolean,)

HX_DEFINE_DYNAMIC_FUNC1(IDataOutput_obj,writeByte,)

HX_DEFINE_DYNAMIC_FUNC3(IDataOutput_obj,writeBytes,)

HX_DEFINE_DYNAMIC_FUNC1(IDataOutput_obj,writeDouble,)

HX_DEFINE_DYNAMIC_FUNC1(IDataOutput_obj,writeFloat,)

HX_DEFINE_DYNAMIC_FUNC1(IDataOutput_obj,writeInt,)

HX_DEFINE_DYNAMIC_FUNC1(IDataOutput_obj,writeShort,)

HX_DEFINE_DYNAMIC_FUNC1(IDataOutput_obj,writeUnsignedInt,)

HX_DEFINE_DYNAMIC_FUNC1(IDataOutput_obj,writeUTF,)

HX_DEFINE_DYNAMIC_FUNC1(IDataOutput_obj,writeUTFBytes,)


static ::String sMemberFields[] = {
	HX_CSTRING("writeBoolean"),
	HX_CSTRING("writeByte"),
	HX_CSTRING("writeBytes"),
	HX_CSTRING("writeDouble"),
	HX_CSTRING("writeFloat"),
	HX_CSTRING("writeInt"),
	HX_CSTRING("writeShort"),
	HX_CSTRING("writeUnsignedInt"),
	HX_CSTRING("writeUTF"),
	HX_CSTRING("writeUTFBytes"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(IDataOutput_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(IDataOutput_obj::__mClass,"__mClass");
};

#endif

Class IDataOutput_obj::__mClass;

void IDataOutput_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.utils.IDataOutput"), hx::TCanCast< IDataOutput_obj> ,0,sMemberFields,
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

void IDataOutput_obj::__boot()
{
}

} // end namespace flash
} // end namespace utils
