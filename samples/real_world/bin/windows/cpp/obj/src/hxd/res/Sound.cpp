#include <hxcpp.h>

#ifndef INCLUDED_hxd_res_FileEntry
#include <hxd/res/FileEntry.h>
#endif
#ifndef INCLUDED_hxd_res_Resource
#include <hxd/res/Resource.h>
#endif
#ifndef INCLUDED_hxd_res_Sound
#include <hxd/res/Sound.h>
#endif
namespace hxd{
namespace res{

Void Sound_obj::__construct(::hxd::res::FileEntry entry)
{
HX_STACK_FRAME("hxd.res.Sound","new",0x111cf5f9,"hxd.res.Sound.new","hxd/res/Sound.hx",3,0xc98f9219)
HX_STACK_THIS(this)
HX_STACK_ARG(entry,"entry")
{
	HX_STACK_LINE(11)
	this->volume = 1.0;
	HX_STACK_LINE(3)
	super::__construct(entry);
}
;
	return null();
}

//Sound_obj::~Sound_obj() { }

Dynamic Sound_obj::__CreateEmpty() { return  new Sound_obj; }
hx::ObjectPtr< Sound_obj > Sound_obj::__new(::hxd::res::FileEntry entry)
{  hx::ObjectPtr< Sound_obj > result = new Sound_obj();
	result->__construct(entry);
	return result;}

Dynamic Sound_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Sound_obj > result = new Sound_obj();
	result->__construct(inArgs[0]);
	return result;}

Float Sound_obj::getPosition( ){
	HX_STACK_FRAME("hxd.res.Sound","getPosition",0x692c49f8,"hxd.res.Sound.getPosition","hxd/res/Sound.hx",29,0xc98f9219)
	HX_STACK_THIS(this)
	HX_STACK_LINE(29)
	return 0.;
}


HX_DEFINE_DYNAMIC_FUNC0(Sound_obj,getPosition,return )

Void Sound_obj::play( ){
{
		HX_STACK_FRAME("hxd.res.Sound","play",0xe991ee3b,"hxd.res.Sound.play","hxd/res/Sound.hx",34,0xc98f9219)
		HX_STACK_THIS(this)
		HX_STACK_LINE(34)
		this->playAt((int)0);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Sound_obj,play,(void))

Void Sound_obj::playAt( Float startPosition){
{
		HX_STACK_FRAME("hxd.res.Sound","playAt",0xe4966c0e,"hxd.res.Sound.playAt","hxd/res/Sound.hx",112,0xc98f9219)
		HX_STACK_THIS(this)
		HX_STACK_ARG(startPosition,"startPosition")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Sound_obj,playAt,(void))

Void Sound_obj::stop( ){
{
		HX_STACK_FRAME("hxd.res.Sound","stop",0xeb93b049,"hxd.res.Sound.stop","hxd/res/Sound.hx",168,0xc98f9219)
		HX_STACK_THIS(this)
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Sound_obj,stop,(void))

Float Sound_obj::set_volume( Float v){
	HX_STACK_FRAME("hxd.res.Sound","set_volume",0x5753e79e,"hxd.res.Sound.set_volume","hxd/res/Sound.hx",177,0xc98f9219)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(178)
	this->volume = v;
	HX_STACK_LINE(183)
	return v;
}


HX_DEFINE_DYNAMIC_FUNC1(Sound_obj,set_volume,return )

int Sound_obj::BUFFER_SIZE;

HX_BEGIN_DEFAULT_FUNC(__default_getGlobalVolume,Sound_obj)
Float run(::hxd::res::Sound s){
	HX_STACK_FRAME("hxd.res.Sound","getGlobalVolume",0xfd03786c,"hxd.res.Sound.getGlobalVolume","hxd/res/Sound.hx",8,0xc98f9219)
	HX_STACK_ARG(s,"s")
	HX_STACK_LINE(8)
	return 1.0;
}
HX_END_LOCAL_FUNC1(return )
HX_END_DEFAULT_FUNC

Dynamic Sound_obj::getGlobalVolume;


Sound_obj::Sound_obj()
{
}

Dynamic Sound_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"loop") ) { return loop; }
		if (HX_FIELD_EQ(inName,"play") ) { return play_dyn(); }
		if (HX_FIELD_EQ(inName,"stop") ) { return stop_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"volume") ) { return volume; }
		if (HX_FIELD_EQ(inName,"playAt") ) { return playAt_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"set_volume") ) { return set_volume_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"BUFFER_SIZE") ) { return BUFFER_SIZE; }
		if (HX_FIELD_EQ(inName,"getPosition") ) { return getPosition_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"getGlobalVolume") ) { return getGlobalVolume; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Sound_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"loop") ) { loop=inValue.Cast< bool >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"volume") ) { if (inCallProp) return set_volume(inValue);volume=inValue.Cast< Float >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"BUFFER_SIZE") ) { BUFFER_SIZE=inValue.Cast< int >(); return inValue; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"getGlobalVolume") ) { getGlobalVolume=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Sound_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("volume"));
	outFields->push(HX_CSTRING("loop"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("BUFFER_SIZE"),
	HX_CSTRING("getGlobalVolume"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(Sound_obj,volume),HX_CSTRING("volume")},
	{hx::fsBool,(int)offsetof(Sound_obj,loop),HX_CSTRING("loop")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("volume"),
	HX_CSTRING("loop"),
	HX_CSTRING("getPosition"),
	HX_CSTRING("play"),
	HX_CSTRING("playAt"),
	HX_CSTRING("stop"),
	HX_CSTRING("set_volume"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Sound_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Sound_obj::BUFFER_SIZE,"BUFFER_SIZE");
	HX_MARK_MEMBER_NAME(Sound_obj::getGlobalVolume,"getGlobalVolume");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Sound_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Sound_obj::BUFFER_SIZE,"BUFFER_SIZE");
	HX_VISIT_MEMBER_NAME(Sound_obj::getGlobalVolume,"getGlobalVolume");
};

#endif

Class Sound_obj::__mClass;

void Sound_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.res.Sound"), hx::TCanCast< Sound_obj> ,sStaticFields,sMemberFields,
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

void Sound_obj::__boot()
{
	BUFFER_SIZE= (int)4096;
	getGlobalVolume = new __default_getGlobalVolume;

}

} // end namespace hxd
} // end namespace res
