#include <hxcpp.h>

#ifndef INCLUDED_Sys
#include <Sys.h>
#endif
#ifndef INCLUDED_cpp_vm_Thread
#include <cpp/vm/Thread.h>
#endif
#ifndef INCLUDED_flash_Lib
#include <flash/Lib.h>
#endif
#ifndef INCLUDED_flash_events_Event
#include <flash/events/Event.h>
#endif
#ifndef INCLUDED_flash_events_EventDispatcher
#include <flash/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_flash_events_IEventDispatcher
#include <flash/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_flash_events_SampleDataEvent
#include <flash/events/SampleDataEvent.h>
#endif
#ifndef INCLUDED_flash_media_AudioThreadState
#include <flash/media/AudioThreadState.h>
#endif
#ifndef INCLUDED_flash_media_InternalAudioType
#include <flash/media/InternalAudioType.h>
#endif
#ifndef INCLUDED_flash_media_Sound
#include <flash/media/Sound.h>
#endif
#ifndef INCLUDED_flash_media_SoundChannel
#include <flash/media/SoundChannel.h>
#endif
#ifndef INCLUDED_flash_media_SoundTransform
#include <flash/media/SoundTransform.h>
#endif
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
namespace flash{
namespace media{

Void SoundChannel_obj::__construct(Dynamic handle,Float startTime,int loops,::flash::media::SoundTransform soundTransform)
{
HX_STACK_FRAME("flash.media.SoundChannel","new",0xd1f3548e,"flash.media.SoundChannel.new","flash/media/SoundChannel.hx",21,0xe5676a20)
HX_STACK_THIS(this)
HX_STACK_ARG(handle,"handle")
HX_STACK_ARG(startTime,"startTime")
HX_STACK_ARG(loops,"loops")
HX_STACK_ARG(soundTransform,"soundTransform")
{
	HX_STACK_LINE(46)
	this->__addedToThread = false;
	HX_STACK_LINE(45)
	this->__thread_completed = false;
	HX_STACK_LINE(53)
	super::__construct(null());
	HX_STACK_LINE(55)
	if (((soundTransform != null()))){
		HX_STACK_LINE(57)
		::flash::media::SoundTransform _g = soundTransform->clone();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(57)
		this->__transform = _g;
	}
	HX_STACK_LINE(61)
	if (((handle != null()))){
		HX_STACK_LINE(63)
		Dynamic _g1 = ::flash::media::SoundChannel_obj::lime_sound_channel_create(handle,startTime,loops,this->__transform);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(63)
		this->__handle = _g1;
	}
	HX_STACK_LINE(67)
	if (((this->__handle != null()))){
		HX_STACK_LINE(69)
		::flash::media::SoundChannel_obj::__incompleteList->push(hx::ObjectPtr<OBJ_>(this));
	}
}
;
	return null();
}

//SoundChannel_obj::~SoundChannel_obj() { }

Dynamic SoundChannel_obj::__CreateEmpty() { return  new SoundChannel_obj; }
hx::ObjectPtr< SoundChannel_obj > SoundChannel_obj::__new(Dynamic handle,Float startTime,int loops,::flash::media::SoundTransform soundTransform)
{  hx::ObjectPtr< SoundChannel_obj > result = new SoundChannel_obj();
	result->__construct(handle,startTime,loops,soundTransform);
	return result;}

Dynamic SoundChannel_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< SoundChannel_obj > result = new SoundChannel_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3]);
	return result;}

Void SoundChannel_obj::stop( ){
{
		HX_STACK_FRAME("flash.media.SoundChannel","stop",0xe6501414,"flash.media.SoundChannel.stop","flash/media/SoundChannel.hx",91,0xe5676a20)
		HX_STACK_THIS(this)
		HX_STACK_LINE(95)
		if (((bool((this->__soundInstance != null())) && bool((this->__soundInstance->__audioType == ::flash::media::InternalAudioType_obj::MUSIC))))){
			HX_STACK_LINE(97)
			if (((::flash::media::SoundChannel_obj::__audioState != null()))){
				HX_STACK_LINE(98)
				::flash::media::SoundChannel_obj::__audioState->remove(hx::ObjectPtr<OBJ_>(this));
			}
		}
		HX_STACK_LINE(105)
		::flash::media::SoundChannel_obj::lime_sound_channel_stop(this->__handle);
		HX_STACK_LINE(106)
		this->__handle = null();
		HX_STACK_LINE(107)
		this->__soundInstance = null();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(SoundChannel_obj,stop,(void))

bool SoundChannel_obj::__checkComplete( ){
	HX_STACK_FRAME("flash.media.SoundChannel","__checkComplete",0xfd40a7af,"flash.media.SoundChannel.__checkComplete","flash/media/SoundChannel.hx",113,0xe5676a20)
	HX_STACK_THIS(this)
	HX_STACK_LINE(113)
	if (((this->__handle != null()))){
		HX_STACK_LINE(115)
		if (((  (((this->__dataProvider != null()))) ? bool(::flash::media::SoundChannel_obj::lime_sound_channel_needs_data(this->__handle)) : bool(false) ))){
			HX_STACK_LINE(117)
			::flash::events::SampleDataEvent request = ::flash::events::SampleDataEvent_obj::__new(::flash::events::SampleDataEvent_obj::SAMPLE_DATA,null(),null());		HX_STACK_VAR(request,"request");
			HX_STACK_LINE(118)
			Float _g = ::flash::media::SoundChannel_obj::lime_sound_channel_get_data_position(this->__handle);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(118)
			request->position = _g;
			HX_STACK_LINE(119)
			this->__dataProvider->dispatchEvent(request);
			HX_STACK_LINE(121)
			if (((request->data->length > (int)0))){
				HX_STACK_LINE(123)
				::flash::media::SoundChannel_obj::lime_sound_channel_add_data(this->__handle,request->data);
			}
		}
		HX_STACK_LINE(131)
		if (((bool(this->__addedToThread) || bool((bool((this->__soundInstance != null())) && bool((this->__soundInstance->__audioType == ::flash::media::InternalAudioType_obj::MUSIC))))))){
			HX_STACK_LINE(133)
			if (((::flash::media::SoundChannel_obj::__audioState == null()))){
				HX_STACK_LINE(135)
				::flash::media::AudioThreadState _g1 = ::flash::media::AudioThreadState_obj::__new();		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(135)
				::flash::media::SoundChannel_obj::__audioState = _g1;
				HX_STACK_LINE(137)
				::flash::media::SoundChannel_obj::__audioThreadRunning = true;
				HX_STACK_LINE(138)
				::flash::media::SoundChannel_obj::__audioThreadIsIdle = false;
				HX_STACK_LINE(140)
				::cpp::vm::Thread _g2 = ::cpp::vm::Thread_obj::current();		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(140)
				::flash::media::SoundChannel_obj::__audioState->mainThread = _g2;
				HX_STACK_LINE(141)
				::cpp::vm::Thread _g3 = ::cpp::vm::Thread_obj::create(::flash::media::SoundChannel_obj::__checkCompleteBackgroundThread_dyn());		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(141)
				::flash::media::SoundChannel_obj::__audioState->audioThread = _g3;
			}
			HX_STACK_LINE(145)
			if ((!(this->__addedToThread))){
				HX_STACK_LINE(147)
				::flash::media::SoundChannel_obj::__audioState->add(hx::ObjectPtr<OBJ_>(this));
				HX_STACK_LINE(148)
				this->__addedToThread = true;
			}
			HX_STACK_LINE(152)
			return this->__thread_completed;
		}
		else{
			HX_STACK_LINE(158)
			if ((this->__runCheckComplete())){
				HX_STACK_LINE(160)
				return true;
			}
		}
		HX_STACK_LINE(164)
		return false;
	}
	else{
		HX_STACK_LINE(168)
		return true;
	}
	HX_STACK_LINE(113)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC0(SoundChannel_obj,__checkComplete,return )

bool SoundChannel_obj::__runCheckComplete( ){
	HX_STACK_FRAME("flash.media.SoundChannel","__runCheckComplete",0x05abc608,"flash.media.SoundChannel.__runCheckComplete","flash/media/SoundChannel.hx",227,0xe5676a20)
	HX_STACK_THIS(this)
	HX_STACK_LINE(229)
	if ((::flash::media::SoundChannel_obj::lime_sound_channel_is_complete(this->__handle))){
		HX_STACK_LINE(231)
		this->__soundInstance = null();
		HX_STACK_LINE(232)
		this->__handle = null();
		HX_STACK_LINE(234)
		if (((this->__dataProvider != null()))){
			HX_STACK_LINE(236)
			(::flash::media::SoundChannel_obj::__dynamicSoundCount)--;
		}
		HX_STACK_LINE(240)
		::flash::events::Event completeEvent = ::flash::events::Event_obj::__new(::flash::events::Event_obj::SOUND_COMPLETE,null(),null());		HX_STACK_VAR(completeEvent,"completeEvent");
		HX_STACK_LINE(241)
		this->dispatchEvent(completeEvent);
		HX_STACK_LINE(243)
		return true;
	}
	HX_STACK_LINE(247)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC0(SoundChannel_obj,__runCheckComplete,return )

Float SoundChannel_obj::get_leftPeak( ){
	HX_STACK_FRAME("flash.media.SoundChannel","get_leftPeak",0x7c1b5be1,"flash.media.SoundChannel.get_leftPeak","flash/media/SoundChannel.hx",259,0xe5676a20)
	HX_STACK_THIS(this)
	HX_STACK_LINE(259)
	return ::flash::media::SoundChannel_obj::lime_sound_channel_get_left(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(SoundChannel_obj,get_leftPeak,return )

Float SoundChannel_obj::get_rightPeak( ){
	HX_STACK_FRAME("flash.media.SoundChannel","get_rightPeak",0xfc22d1a0,"flash.media.SoundChannel.get_rightPeak","flash/media/SoundChannel.hx",260,0xe5676a20)
	HX_STACK_THIS(this)
	HX_STACK_LINE(260)
	return ::flash::media::SoundChannel_obj::lime_sound_channel_get_right(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(SoundChannel_obj,get_rightPeak,return )

Float SoundChannel_obj::get_position( ){
	HX_STACK_FRAME("flash.media.SoundChannel","get_position",0xf5c5dac4,"flash.media.SoundChannel.get_position","flash/media/SoundChannel.hx",261,0xe5676a20)
	HX_STACK_THIS(this)
	HX_STACK_LINE(261)
	return ::flash::media::SoundChannel_obj::lime_sound_channel_get_position(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(SoundChannel_obj,get_position,return )

Float SoundChannel_obj::set_position( Float value){
	HX_STACK_FRAME("flash.media.SoundChannel","set_position",0x0abefe38,"flash.media.SoundChannel.set_position","flash/media/SoundChannel.hx",262,0xe5676a20)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(262)
	Float _g = this->get_position();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(262)
	return ::flash::media::SoundChannel_obj::lime_sound_channel_set_position(this->__handle,_g);
}


HX_DEFINE_DYNAMIC_FUNC1(SoundChannel_obj,set_position,return )

::flash::media::SoundTransform SoundChannel_obj::get_soundTransform( ){
	HX_STACK_FRAME("flash.media.SoundChannel","get_soundTransform",0x37952ef8,"flash.media.SoundChannel.get_soundTransform","flash/media/SoundChannel.hx",265,0xe5676a20)
	HX_STACK_THIS(this)
	HX_STACK_LINE(267)
	if (((this->__transform == null()))){
		HX_STACK_LINE(269)
		::flash::media::SoundTransform _g = ::flash::media::SoundTransform_obj::__new(null(),null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(269)
		this->__transform = _g;
	}
	HX_STACK_LINE(273)
	return this->__transform->clone();
}


HX_DEFINE_DYNAMIC_FUNC0(SoundChannel_obj,get_soundTransform,return )

::flash::media::SoundTransform SoundChannel_obj::set_soundTransform( ::flash::media::SoundTransform value){
	HX_STACK_FRAME("flash.media.SoundChannel","set_soundTransform",0x1444616c,"flash.media.SoundChannel.set_soundTransform","flash/media/SoundChannel.hx",278,0xe5676a20)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(280)
	::flash::media::SoundTransform _g = value->clone();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(280)
	this->__transform = _g;
	HX_STACK_LINE(281)
	::flash::media::SoundChannel_obj::lime_sound_channel_set_transform(this->__handle,this->__transform);
	HX_STACK_LINE(283)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(SoundChannel_obj,set_soundTransform,return )

int SoundChannel_obj::__dynamicSoundCount;

Array< ::Dynamic > SoundChannel_obj::__incompleteList;

::flash::media::AudioThreadState SoundChannel_obj::__audioState;

bool SoundChannel_obj::__audioThreadIsIdle;

bool SoundChannel_obj::__audioThreadRunning;

::flash::media::SoundChannel SoundChannel_obj::createDynamic( Dynamic handle,::flash::media::SoundTransform soundTransform,::flash::events::EventDispatcher dataProvider){
	HX_STACK_FRAME("flash.media.SoundChannel","createDynamic",0xa3fc4191,"flash.media.SoundChannel.createDynamic","flash/media/SoundChannel.hx",76,0xe5676a20)
	HX_STACK_ARG(handle,"handle")
	HX_STACK_ARG(soundTransform,"soundTransform")
	HX_STACK_ARG(dataProvider,"dataProvider")
	HX_STACK_LINE(78)
	::flash::media::SoundChannel result = ::flash::media::SoundChannel_obj::__new(null(),(int)0,(int)0,soundTransform);		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(80)
	result->__dataProvider = dataProvider;
	HX_STACK_LINE(81)
	result->__handle = handle;
	HX_STACK_LINE(82)
	::flash::media::SoundChannel_obj::__incompleteList->push(result);
	HX_STACK_LINE(84)
	(::flash::media::SoundChannel_obj::__dynamicSoundCount)++;
	HX_STACK_LINE(86)
	return result;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(SoundChannel_obj,createDynamic,return )

Void SoundChannel_obj::__checkCompleteBackgroundThread( ){
{
		HX_STACK_FRAME("flash.media.SoundChannel","__checkCompleteBackgroundThread",0x83363b27,"flash.media.SoundChannel.__checkCompleteBackgroundThread","flash/media/SoundChannel.hx",177,0xe5676a20)
		HX_STACK_LINE(179)
		while((true)){
			HX_STACK_LINE(179)
			if ((!(::flash::media::SoundChannel_obj::__audioThreadRunning))){
				HX_STACK_LINE(179)
				break;
			}
			HX_STACK_LINE(181)
			if ((!(::flash::media::SoundChannel_obj::__audioThreadIsIdle))){
				HX_STACK_LINE(183)
				::flash::media::SoundChannel_obj::__audioState->updateComplete();
				HX_STACK_LINE(185)
				::Sys_obj::sleep(0.01);
			}
			else{
				HX_STACK_LINE(189)
				::Sys_obj::sleep(0.2);
			}
		}
		HX_STACK_LINE(195)
		::flash::media::SoundChannel_obj::__audioThreadRunning = false;
		HX_STACK_LINE(196)
		::flash::media::SoundChannel_obj::__audioThreadIsIdle = true;
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(SoundChannel_obj,__checkCompleteBackgroundThread,(void))

bool SoundChannel_obj::__completePending( ){
	HX_STACK_FRAME("flash.media.SoundChannel","__completePending",0xa8b9a22c,"flash.media.SoundChannel.__completePending","flash/media/SoundChannel.hx",205,0xe5676a20)
	HX_STACK_LINE(205)
	return (::flash::media::SoundChannel_obj::__incompleteList->length > (int)0);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(SoundChannel_obj,__completePending,return )

Void SoundChannel_obj::__pollComplete( ){
{
		HX_STACK_FRAME("flash.media.SoundChannel","__pollComplete",0xa55a43ca,"flash.media.SoundChannel.__pollComplete","flash/media/SoundChannel.hx",210,0xe5676a20)
		HX_STACK_LINE(212)
		int i = ::flash::media::SoundChannel_obj::__incompleteList->length;		HX_STACK_VAR(i,"i");
		HX_STACK_LINE(214)
		while((true)){
			HX_STACK_LINE(214)
			int _g = --(i);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(214)
			if ((!(((_g >= (int)0))))){
				HX_STACK_LINE(214)
				break;
			}
			HX_STACK_LINE(216)
			if ((::flash::media::SoundChannel_obj::__incompleteList->__get(i).StaticCast< ::flash::media::SoundChannel >()->__checkComplete())){
				HX_STACK_LINE(218)
				::flash::media::SoundChannel_obj::__incompleteList->splice(i,(int)1);
			}
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(SoundChannel_obj,__pollComplete,(void))

Dynamic SoundChannel_obj::lime_sound_channel_is_complete;

Dynamic SoundChannel_obj::lime_sound_channel_get_left;

Dynamic SoundChannel_obj::lime_sound_channel_get_right;

Dynamic SoundChannel_obj::lime_sound_channel_get_position;

Dynamic SoundChannel_obj::lime_sound_channel_set_position;

Dynamic SoundChannel_obj::lime_sound_channel_get_data_position;

Dynamic SoundChannel_obj::lime_sound_channel_stop;

Dynamic SoundChannel_obj::lime_sound_channel_create;

Dynamic SoundChannel_obj::lime_sound_channel_set_transform;

Dynamic SoundChannel_obj::lime_sound_channel_needs_data;

Dynamic SoundChannel_obj::lime_sound_channel_add_data;


SoundChannel_obj::SoundChannel_obj()
{
}

void SoundChannel_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(SoundChannel);
	HX_MARK_MEMBER_NAME(leftPeak,"leftPeak");
	HX_MARK_MEMBER_NAME(rightPeak,"rightPeak");
	HX_MARK_MEMBER_NAME(__dataProvider,"__dataProvider");
	HX_MARK_MEMBER_NAME(__handle,"__handle");
	HX_MARK_MEMBER_NAME(__soundInstance,"__soundInstance");
	HX_MARK_MEMBER_NAME(__transform,"__transform");
	HX_MARK_MEMBER_NAME(__thread_completed,"__thread_completed");
	HX_MARK_MEMBER_NAME(__addedToThread,"__addedToThread");
	::flash::events::EventDispatcher_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void SoundChannel_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(leftPeak,"leftPeak");
	HX_VISIT_MEMBER_NAME(rightPeak,"rightPeak");
	HX_VISIT_MEMBER_NAME(__dataProvider,"__dataProvider");
	HX_VISIT_MEMBER_NAME(__handle,"__handle");
	HX_VISIT_MEMBER_NAME(__soundInstance,"__soundInstance");
	HX_VISIT_MEMBER_NAME(__transform,"__transform");
	HX_VISIT_MEMBER_NAME(__thread_completed,"__thread_completed");
	HX_VISIT_MEMBER_NAME(__addedToThread,"__addedToThread");
	::flash::events::EventDispatcher_obj::__Visit(HX_VISIT_ARG);
}

Dynamic SoundChannel_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"stop") ) { return stop_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"leftPeak") ) { return inCallProp ? get_leftPeak() : leftPeak; }
		if (HX_FIELD_EQ(inName,"position") ) { return get_position(); }
		if (HX_FIELD_EQ(inName,"__handle") ) { return __handle; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"rightPeak") ) { return inCallProp ? get_rightPeak() : rightPeak; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"__transform") ) { return __transform; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"__audioState") ) { return __audioState; }
		if (HX_FIELD_EQ(inName,"get_leftPeak") ) { return get_leftPeak_dyn(); }
		if (HX_FIELD_EQ(inName,"get_position") ) { return get_position_dyn(); }
		if (HX_FIELD_EQ(inName,"set_position") ) { return set_position_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"createDynamic") ) { return createDynamic_dyn(); }
		if (HX_FIELD_EQ(inName,"get_rightPeak") ) { return get_rightPeak_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"__pollComplete") ) { return __pollComplete_dyn(); }
		if (HX_FIELD_EQ(inName,"soundTransform") ) { return get_soundTransform(); }
		if (HX_FIELD_EQ(inName,"__dataProvider") ) { return __dataProvider; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"__soundInstance") ) { return __soundInstance; }
		if (HX_FIELD_EQ(inName,"__addedToThread") ) { return __addedToThread; }
		if (HX_FIELD_EQ(inName,"__checkComplete") ) { return __checkComplete_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"__incompleteList") ) { return __incompleteList; }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"__completePending") ) { return __completePending_dyn(); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"__thread_completed") ) { return __thread_completed; }
		if (HX_FIELD_EQ(inName,"__runCheckComplete") ) { return __runCheckComplete_dyn(); }
		if (HX_FIELD_EQ(inName,"get_soundTransform") ) { return get_soundTransform_dyn(); }
		if (HX_FIELD_EQ(inName,"set_soundTransform") ) { return set_soundTransform_dyn(); }
		break;
	case 19:
		if (HX_FIELD_EQ(inName,"__dynamicSoundCount") ) { return __dynamicSoundCount; }
		if (HX_FIELD_EQ(inName,"__audioThreadIsIdle") ) { return __audioThreadIsIdle; }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"__audioThreadRunning") ) { return __audioThreadRunning; }
		break;
	case 23:
		if (HX_FIELD_EQ(inName,"lime_sound_channel_stop") ) { return lime_sound_channel_stop; }
		break;
	case 25:
		if (HX_FIELD_EQ(inName,"lime_sound_channel_create") ) { return lime_sound_channel_create; }
		break;
	case 27:
		if (HX_FIELD_EQ(inName,"lime_sound_channel_get_left") ) { return lime_sound_channel_get_left; }
		if (HX_FIELD_EQ(inName,"lime_sound_channel_add_data") ) { return lime_sound_channel_add_data; }
		break;
	case 28:
		if (HX_FIELD_EQ(inName,"lime_sound_channel_get_right") ) { return lime_sound_channel_get_right; }
		break;
	case 29:
		if (HX_FIELD_EQ(inName,"lime_sound_channel_needs_data") ) { return lime_sound_channel_needs_data; }
		break;
	case 30:
		if (HX_FIELD_EQ(inName,"lime_sound_channel_is_complete") ) { return lime_sound_channel_is_complete; }
		break;
	case 31:
		if (HX_FIELD_EQ(inName,"__checkCompleteBackgroundThread") ) { return __checkCompleteBackgroundThread_dyn(); }
		if (HX_FIELD_EQ(inName,"lime_sound_channel_get_position") ) { return lime_sound_channel_get_position; }
		if (HX_FIELD_EQ(inName,"lime_sound_channel_set_position") ) { return lime_sound_channel_set_position; }
		break;
	case 32:
		if (HX_FIELD_EQ(inName,"lime_sound_channel_set_transform") ) { return lime_sound_channel_set_transform; }
		break;
	case 36:
		if (HX_FIELD_EQ(inName,"lime_sound_channel_get_data_position") ) { return lime_sound_channel_get_data_position; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic SoundChannel_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 8:
		if (HX_FIELD_EQ(inName,"leftPeak") ) { leftPeak=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"position") ) { return set_position(inValue); }
		if (HX_FIELD_EQ(inName,"__handle") ) { __handle=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"rightPeak") ) { rightPeak=inValue.Cast< Float >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"__transform") ) { __transform=inValue.Cast< ::flash::media::SoundTransform >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"__audioState") ) { __audioState=inValue.Cast< ::flash::media::AudioThreadState >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"soundTransform") ) { return set_soundTransform(inValue); }
		if (HX_FIELD_EQ(inName,"__dataProvider") ) { __dataProvider=inValue.Cast< ::flash::events::EventDispatcher >(); return inValue; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"__soundInstance") ) { __soundInstance=inValue.Cast< ::flash::media::Sound >(); return inValue; }
		if (HX_FIELD_EQ(inName,"__addedToThread") ) { __addedToThread=inValue.Cast< bool >(); return inValue; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"__incompleteList") ) { __incompleteList=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"__thread_completed") ) { __thread_completed=inValue.Cast< bool >(); return inValue; }
		break;
	case 19:
		if (HX_FIELD_EQ(inName,"__dynamicSoundCount") ) { __dynamicSoundCount=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"__audioThreadIsIdle") ) { __audioThreadIsIdle=inValue.Cast< bool >(); return inValue; }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"__audioThreadRunning") ) { __audioThreadRunning=inValue.Cast< bool >(); return inValue; }
		break;
	case 23:
		if (HX_FIELD_EQ(inName,"lime_sound_channel_stop") ) { lime_sound_channel_stop=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 25:
		if (HX_FIELD_EQ(inName,"lime_sound_channel_create") ) { lime_sound_channel_create=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 27:
		if (HX_FIELD_EQ(inName,"lime_sound_channel_get_left") ) { lime_sound_channel_get_left=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_sound_channel_add_data") ) { lime_sound_channel_add_data=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 28:
		if (HX_FIELD_EQ(inName,"lime_sound_channel_get_right") ) { lime_sound_channel_get_right=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 29:
		if (HX_FIELD_EQ(inName,"lime_sound_channel_needs_data") ) { lime_sound_channel_needs_data=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 30:
		if (HX_FIELD_EQ(inName,"lime_sound_channel_is_complete") ) { lime_sound_channel_is_complete=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 31:
		if (HX_FIELD_EQ(inName,"lime_sound_channel_get_position") ) { lime_sound_channel_get_position=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_sound_channel_set_position") ) { lime_sound_channel_set_position=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 32:
		if (HX_FIELD_EQ(inName,"lime_sound_channel_set_transform") ) { lime_sound_channel_set_transform=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 36:
		if (HX_FIELD_EQ(inName,"lime_sound_channel_get_data_position") ) { lime_sound_channel_get_data_position=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void SoundChannel_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("leftPeak"));
	outFields->push(HX_CSTRING("rightPeak"));
	outFields->push(HX_CSTRING("position"));
	outFields->push(HX_CSTRING("soundTransform"));
	outFields->push(HX_CSTRING("__dataProvider"));
	outFields->push(HX_CSTRING("__handle"));
	outFields->push(HX_CSTRING("__soundInstance"));
	outFields->push(HX_CSTRING("__transform"));
	outFields->push(HX_CSTRING("__thread_completed"));
	outFields->push(HX_CSTRING("__addedToThread"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("__dynamicSoundCount"),
	HX_CSTRING("__incompleteList"),
	HX_CSTRING("__audioState"),
	HX_CSTRING("__audioThreadIsIdle"),
	HX_CSTRING("__audioThreadRunning"),
	HX_CSTRING("createDynamic"),
	HX_CSTRING("__checkCompleteBackgroundThread"),
	HX_CSTRING("__completePending"),
	HX_CSTRING("__pollComplete"),
	HX_CSTRING("lime_sound_channel_is_complete"),
	HX_CSTRING("lime_sound_channel_get_left"),
	HX_CSTRING("lime_sound_channel_get_right"),
	HX_CSTRING("lime_sound_channel_get_position"),
	HX_CSTRING("lime_sound_channel_set_position"),
	HX_CSTRING("lime_sound_channel_get_data_position"),
	HX_CSTRING("lime_sound_channel_stop"),
	HX_CSTRING("lime_sound_channel_create"),
	HX_CSTRING("lime_sound_channel_set_transform"),
	HX_CSTRING("lime_sound_channel_needs_data"),
	HX_CSTRING("lime_sound_channel_add_data"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(SoundChannel_obj,leftPeak),HX_CSTRING("leftPeak")},
	{hx::fsFloat,(int)offsetof(SoundChannel_obj,rightPeak),HX_CSTRING("rightPeak")},
	{hx::fsObject /*::flash::events::EventDispatcher*/ ,(int)offsetof(SoundChannel_obj,__dataProvider),HX_CSTRING("__dataProvider")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(SoundChannel_obj,__handle),HX_CSTRING("__handle")},
	{hx::fsObject /*::flash::media::Sound*/ ,(int)offsetof(SoundChannel_obj,__soundInstance),HX_CSTRING("__soundInstance")},
	{hx::fsObject /*::flash::media::SoundTransform*/ ,(int)offsetof(SoundChannel_obj,__transform),HX_CSTRING("__transform")},
	{hx::fsBool,(int)offsetof(SoundChannel_obj,__thread_completed),HX_CSTRING("__thread_completed")},
	{hx::fsBool,(int)offsetof(SoundChannel_obj,__addedToThread),HX_CSTRING("__addedToThread")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("leftPeak"),
	HX_CSTRING("rightPeak"),
	HX_CSTRING("__dataProvider"),
	HX_CSTRING("__handle"),
	HX_CSTRING("__soundInstance"),
	HX_CSTRING("__transform"),
	HX_CSTRING("__thread_completed"),
	HX_CSTRING("__addedToThread"),
	HX_CSTRING("stop"),
	HX_CSTRING("__checkComplete"),
	HX_CSTRING("__runCheckComplete"),
	HX_CSTRING("get_leftPeak"),
	HX_CSTRING("get_rightPeak"),
	HX_CSTRING("get_position"),
	HX_CSTRING("set_position"),
	HX_CSTRING("get_soundTransform"),
	HX_CSTRING("set_soundTransform"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(SoundChannel_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(SoundChannel_obj::__dynamicSoundCount,"__dynamicSoundCount");
	HX_MARK_MEMBER_NAME(SoundChannel_obj::__incompleteList,"__incompleteList");
	HX_MARK_MEMBER_NAME(SoundChannel_obj::__audioState,"__audioState");
	HX_MARK_MEMBER_NAME(SoundChannel_obj::__audioThreadIsIdle,"__audioThreadIsIdle");
	HX_MARK_MEMBER_NAME(SoundChannel_obj::__audioThreadRunning,"__audioThreadRunning");
	HX_MARK_MEMBER_NAME(SoundChannel_obj::lime_sound_channel_is_complete,"lime_sound_channel_is_complete");
	HX_MARK_MEMBER_NAME(SoundChannel_obj::lime_sound_channel_get_left,"lime_sound_channel_get_left");
	HX_MARK_MEMBER_NAME(SoundChannel_obj::lime_sound_channel_get_right,"lime_sound_channel_get_right");
	HX_MARK_MEMBER_NAME(SoundChannel_obj::lime_sound_channel_get_position,"lime_sound_channel_get_position");
	HX_MARK_MEMBER_NAME(SoundChannel_obj::lime_sound_channel_set_position,"lime_sound_channel_set_position");
	HX_MARK_MEMBER_NAME(SoundChannel_obj::lime_sound_channel_get_data_position,"lime_sound_channel_get_data_position");
	HX_MARK_MEMBER_NAME(SoundChannel_obj::lime_sound_channel_stop,"lime_sound_channel_stop");
	HX_MARK_MEMBER_NAME(SoundChannel_obj::lime_sound_channel_create,"lime_sound_channel_create");
	HX_MARK_MEMBER_NAME(SoundChannel_obj::lime_sound_channel_set_transform,"lime_sound_channel_set_transform");
	HX_MARK_MEMBER_NAME(SoundChannel_obj::lime_sound_channel_needs_data,"lime_sound_channel_needs_data");
	HX_MARK_MEMBER_NAME(SoundChannel_obj::lime_sound_channel_add_data,"lime_sound_channel_add_data");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(SoundChannel_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(SoundChannel_obj::__dynamicSoundCount,"__dynamicSoundCount");
	HX_VISIT_MEMBER_NAME(SoundChannel_obj::__incompleteList,"__incompleteList");
	HX_VISIT_MEMBER_NAME(SoundChannel_obj::__audioState,"__audioState");
	HX_VISIT_MEMBER_NAME(SoundChannel_obj::__audioThreadIsIdle,"__audioThreadIsIdle");
	HX_VISIT_MEMBER_NAME(SoundChannel_obj::__audioThreadRunning,"__audioThreadRunning");
	HX_VISIT_MEMBER_NAME(SoundChannel_obj::lime_sound_channel_is_complete,"lime_sound_channel_is_complete");
	HX_VISIT_MEMBER_NAME(SoundChannel_obj::lime_sound_channel_get_left,"lime_sound_channel_get_left");
	HX_VISIT_MEMBER_NAME(SoundChannel_obj::lime_sound_channel_get_right,"lime_sound_channel_get_right");
	HX_VISIT_MEMBER_NAME(SoundChannel_obj::lime_sound_channel_get_position,"lime_sound_channel_get_position");
	HX_VISIT_MEMBER_NAME(SoundChannel_obj::lime_sound_channel_set_position,"lime_sound_channel_set_position");
	HX_VISIT_MEMBER_NAME(SoundChannel_obj::lime_sound_channel_get_data_position,"lime_sound_channel_get_data_position");
	HX_VISIT_MEMBER_NAME(SoundChannel_obj::lime_sound_channel_stop,"lime_sound_channel_stop");
	HX_VISIT_MEMBER_NAME(SoundChannel_obj::lime_sound_channel_create,"lime_sound_channel_create");
	HX_VISIT_MEMBER_NAME(SoundChannel_obj::lime_sound_channel_set_transform,"lime_sound_channel_set_transform");
	HX_VISIT_MEMBER_NAME(SoundChannel_obj::lime_sound_channel_needs_data,"lime_sound_channel_needs_data");
	HX_VISIT_MEMBER_NAME(SoundChannel_obj::lime_sound_channel_add_data,"lime_sound_channel_add_data");
};

#endif

Class SoundChannel_obj::__mClass;

void SoundChannel_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.media.SoundChannel"), hx::TCanCast< SoundChannel_obj> ,sStaticFields,sMemberFields,
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

void SoundChannel_obj::__boot()
{
	__dynamicSoundCount= (int)0;
	__incompleteList= Array_obj< ::Dynamic >::__new();
	__audioThreadIsIdle= true;
	__audioThreadRunning= false;
	lime_sound_channel_is_complete= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_sound_channel_is_complete"),(int)1);
	lime_sound_channel_get_left= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_sound_channel_get_left"),(int)1);
	lime_sound_channel_get_right= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_sound_channel_get_right"),(int)1);
	lime_sound_channel_get_position= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_sound_channel_get_position"),(int)1);
	lime_sound_channel_set_position= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_sound_channel_set_position"),(int)2);
	lime_sound_channel_get_data_position= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_sound_channel_get_data_position"),(int)1);
	lime_sound_channel_stop= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_sound_channel_stop"),(int)1);
	lime_sound_channel_create= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_sound_channel_create"),(int)4);
	lime_sound_channel_set_transform= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_sound_channel_set_transform"),(int)2);
	lime_sound_channel_needs_data= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_sound_channel_needs_data"),(int)1);
	lime_sound_channel_add_data= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_sound_channel_add_data"),(int)2);
}

} // end namespace flash
} // end namespace media
