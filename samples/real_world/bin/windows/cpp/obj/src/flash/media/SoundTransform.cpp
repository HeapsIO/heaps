#include <hxcpp.h>

#ifndef INCLUDED_flash_media_SoundTransform
#include <flash/media/SoundTransform.h>
#endif
namespace flash{
namespace media{

Void SoundTransform_obj::__construct(hx::Null< Float >  __o_volume,hx::Null< Float >  __o_pan)
{
HX_STACK_FRAME("flash.media.SoundTransform","new",0x354551f7,"flash.media.SoundTransform.new","flash/media/SoundTransform.hx",11,0xa90e2857)
HX_STACK_THIS(this)
HX_STACK_ARG(__o_volume,"volume")
HX_STACK_ARG(__o_pan,"pan")
Float volume = __o_volume.Default(1.0);
Float pan = __o_pan.Default(0.0);
{
	HX_STACK_LINE(13)
	this->volume = volume;
	HX_STACK_LINE(14)
	this->pan = pan;
}
;
	return null();
}

//SoundTransform_obj::~SoundTransform_obj() { }

Dynamic SoundTransform_obj::__CreateEmpty() { return  new SoundTransform_obj; }
hx::ObjectPtr< SoundTransform_obj > SoundTransform_obj::__new(hx::Null< Float >  __o_volume,hx::Null< Float >  __o_pan)
{  hx::ObjectPtr< SoundTransform_obj > result = new SoundTransform_obj();
	result->__construct(__o_volume,__o_pan);
	return result;}

Dynamic SoundTransform_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< SoundTransform_obj > result = new SoundTransform_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

::flash::media::SoundTransform SoundTransform_obj::clone( ){
	HX_STACK_FRAME("flash.media.SoundTransform","clone",0xbde968b4,"flash.media.SoundTransform.clone","flash/media/SoundTransform.hx",21,0xa90e2857)
	HX_STACK_THIS(this)
	HX_STACK_LINE(21)
	return ::flash::media::SoundTransform_obj::__new(this->volume,this->pan);
}


HX_DEFINE_DYNAMIC_FUNC0(SoundTransform_obj,clone,return )


SoundTransform_obj::SoundTransform_obj()
{
}

Dynamic SoundTransform_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"pan") ) { return pan; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"volume") ) { return volume; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic SoundTransform_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"pan") ) { pan=inValue.Cast< Float >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"volume") ) { volume=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void SoundTransform_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("pan"));
	outFields->push(HX_CSTRING("volume"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(SoundTransform_obj,pan),HX_CSTRING("pan")},
	{hx::fsFloat,(int)offsetof(SoundTransform_obj,volume),HX_CSTRING("volume")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("pan"),
	HX_CSTRING("volume"),
	HX_CSTRING("clone"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(SoundTransform_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(SoundTransform_obj::__mClass,"__mClass");
};

#endif

Class SoundTransform_obj::__mClass;

void SoundTransform_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.media.SoundTransform"), hx::TCanCast< SoundTransform_obj> ,sStaticFields,sMemberFields,
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

void SoundTransform_obj::__boot()
{
}

} // end namespace flash
} // end namespace media
