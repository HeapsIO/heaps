#include <hxcpp.h>

#ifndef INCLUDED_flash_media_InternalAudioType
#include <flash/media/InternalAudioType.h>
#endif
namespace flash{
namespace media{

::flash::media::InternalAudioType InternalAudioType_obj::MUSIC;

::flash::media::InternalAudioType InternalAudioType_obj::SOUND;

::flash::media::InternalAudioType InternalAudioType_obj::UNKNOWN;

HX_DEFINE_CREATE_ENUM(InternalAudioType_obj)

int InternalAudioType_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("MUSIC")) return 0;
	if (inName==HX_CSTRING("SOUND")) return 1;
	if (inName==HX_CSTRING("UNKNOWN")) return 2;
	return super::__FindIndex(inName);
}

int InternalAudioType_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("MUSIC")) return 0;
	if (inName==HX_CSTRING("SOUND")) return 0;
	if (inName==HX_CSTRING("UNKNOWN")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic InternalAudioType_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("MUSIC")) return MUSIC;
	if (inName==HX_CSTRING("SOUND")) return SOUND;
	if (inName==HX_CSTRING("UNKNOWN")) return UNKNOWN;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("MUSIC"),
	HX_CSTRING("SOUND"),
	HX_CSTRING("UNKNOWN"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(InternalAudioType_obj::MUSIC,"MUSIC");
	HX_MARK_MEMBER_NAME(InternalAudioType_obj::SOUND,"SOUND");
	HX_MARK_MEMBER_NAME(InternalAudioType_obj::UNKNOWN,"UNKNOWN");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(InternalAudioType_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(InternalAudioType_obj::MUSIC,"MUSIC");
	HX_VISIT_MEMBER_NAME(InternalAudioType_obj::SOUND,"SOUND");
	HX_VISIT_MEMBER_NAME(InternalAudioType_obj::UNKNOWN,"UNKNOWN");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class InternalAudioType_obj::__mClass;

Dynamic __Create_InternalAudioType_obj() { return new InternalAudioType_obj; }

void InternalAudioType_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.media.InternalAudioType"), hx::TCanCast< InternalAudioType_obj >,sStaticFields,sMemberFields,
	&__Create_InternalAudioType_obj, &__Create,
	&super::__SGetClass(), &CreateInternalAudioType_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void InternalAudioType_obj::__boot()
{
hx::Static(MUSIC) = hx::CreateEnum< InternalAudioType_obj >(HX_CSTRING("MUSIC"),0);
hx::Static(SOUND) = hx::CreateEnum< InternalAudioType_obj >(HX_CSTRING("SOUND"),1);
hx::Static(UNKNOWN) = hx::CreateEnum< InternalAudioType_obj >(HX_CSTRING("UNKNOWN"),2);
}


} // end namespace flash
} // end namespace media
