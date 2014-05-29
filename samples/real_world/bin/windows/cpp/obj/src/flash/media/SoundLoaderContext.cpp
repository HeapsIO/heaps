#include <hxcpp.h>

#ifndef INCLUDED_flash_media_SoundLoaderContext
#include <flash/media/SoundLoaderContext.h>
#endif
namespace flash{
namespace media{

Void SoundLoaderContext_obj::__construct()
{
HX_STACK_FRAME("flash.media.SoundLoaderContext","new",0x3bea6b27,"flash.media.SoundLoaderContext.new","flash/media/SoundLoaderContext.hx",7,0x53489c27)
HX_STACK_THIS(this)
{
}
;
	return null();
}

//SoundLoaderContext_obj::~SoundLoaderContext_obj() { }

Dynamic SoundLoaderContext_obj::__CreateEmpty() { return  new SoundLoaderContext_obj; }
hx::ObjectPtr< SoundLoaderContext_obj > SoundLoaderContext_obj::__new()
{  hx::ObjectPtr< SoundLoaderContext_obj > result = new SoundLoaderContext_obj();
	result->__construct();
	return result;}

Dynamic SoundLoaderContext_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< SoundLoaderContext_obj > result = new SoundLoaderContext_obj();
	result->__construct();
	return result;}


SoundLoaderContext_obj::SoundLoaderContext_obj()
{
}

Dynamic SoundLoaderContext_obj::__Field(const ::String &inName,bool inCallProp)
{
	return super::__Field(inName,inCallProp);
}

Dynamic SoundLoaderContext_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void SoundLoaderContext_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(SoundLoaderContext_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(SoundLoaderContext_obj::__mClass,"__mClass");
};

#endif

Class SoundLoaderContext_obj::__mClass;

void SoundLoaderContext_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.media.SoundLoaderContext"), hx::TCanCast< SoundLoaderContext_obj> ,sStaticFields,sMemberFields,
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

void SoundLoaderContext_obj::__boot()
{
}

} // end namespace flash
} // end namespace media
