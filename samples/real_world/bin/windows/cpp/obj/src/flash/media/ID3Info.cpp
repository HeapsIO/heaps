#include <hxcpp.h>

#ifndef INCLUDED_flash_media_ID3Info
#include <flash/media/ID3Info.h>
#endif
namespace flash{
namespace media{

Void ID3Info_obj::__construct()
{
HX_STACK_FRAME("flash.media.ID3Info","new",0x8abc87b0,"flash.media.ID3Info.new","flash/media/ID3Info.hx",16,0xae583b02)
HX_STACK_THIS(this)
{
}
;
	return null();
}

//ID3Info_obj::~ID3Info_obj() { }

Dynamic ID3Info_obj::__CreateEmpty() { return  new ID3Info_obj; }
hx::ObjectPtr< ID3Info_obj > ID3Info_obj::__new()
{  hx::ObjectPtr< ID3Info_obj > result = new ID3Info_obj();
	result->__construct();
	return result;}

Dynamic ID3Info_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< ID3Info_obj > result = new ID3Info_obj();
	result->__construct();
	return result;}


ID3Info_obj::ID3Info_obj()
{
}

void ID3Info_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(ID3Info);
	HX_MARK_MEMBER_NAME(album,"album");
	HX_MARK_MEMBER_NAME(artist,"artist");
	HX_MARK_MEMBER_NAME(comment,"comment");
	HX_MARK_MEMBER_NAME(genre,"genre");
	HX_MARK_MEMBER_NAME(songName,"songName");
	HX_MARK_MEMBER_NAME(track,"track");
	HX_MARK_MEMBER_NAME(year,"year");
	HX_MARK_END_CLASS();
}

void ID3Info_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(album,"album");
	HX_VISIT_MEMBER_NAME(artist,"artist");
	HX_VISIT_MEMBER_NAME(comment,"comment");
	HX_VISIT_MEMBER_NAME(genre,"genre");
	HX_VISIT_MEMBER_NAME(songName,"songName");
	HX_VISIT_MEMBER_NAME(track,"track");
	HX_VISIT_MEMBER_NAME(year,"year");
}

Dynamic ID3Info_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"year") ) { return year; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"album") ) { return album; }
		if (HX_FIELD_EQ(inName,"genre") ) { return genre; }
		if (HX_FIELD_EQ(inName,"track") ) { return track; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"artist") ) { return artist; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"comment") ) { return comment; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"songName") ) { return songName; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic ID3Info_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"year") ) { year=inValue.Cast< ::String >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"album") ) { album=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"genre") ) { genre=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"track") ) { track=inValue.Cast< ::String >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"artist") ) { artist=inValue.Cast< ::String >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"comment") ) { comment=inValue.Cast< ::String >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"songName") ) { songName=inValue.Cast< ::String >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void ID3Info_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("album"));
	outFields->push(HX_CSTRING("artist"));
	outFields->push(HX_CSTRING("comment"));
	outFields->push(HX_CSTRING("genre"));
	outFields->push(HX_CSTRING("songName"));
	outFields->push(HX_CSTRING("track"));
	outFields->push(HX_CSTRING("year"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsString,(int)offsetof(ID3Info_obj,album),HX_CSTRING("album")},
	{hx::fsString,(int)offsetof(ID3Info_obj,artist),HX_CSTRING("artist")},
	{hx::fsString,(int)offsetof(ID3Info_obj,comment),HX_CSTRING("comment")},
	{hx::fsString,(int)offsetof(ID3Info_obj,genre),HX_CSTRING("genre")},
	{hx::fsString,(int)offsetof(ID3Info_obj,songName),HX_CSTRING("songName")},
	{hx::fsString,(int)offsetof(ID3Info_obj,track),HX_CSTRING("track")},
	{hx::fsString,(int)offsetof(ID3Info_obj,year),HX_CSTRING("year")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("album"),
	HX_CSTRING("artist"),
	HX_CSTRING("comment"),
	HX_CSTRING("genre"),
	HX_CSTRING("songName"),
	HX_CSTRING("track"),
	HX_CSTRING("year"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(ID3Info_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(ID3Info_obj::__mClass,"__mClass");
};

#endif

Class ID3Info_obj::__mClass;

void ID3Info_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.media.ID3Info"), hx::TCanCast< ID3Info_obj> ,sStaticFields,sMemberFields,
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

void ID3Info_obj::__boot()
{
}

} // end namespace flash
} // end namespace media
