#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_flash_events_Event
#include <flash/events/Event.h>
#endif
#ifndef INCLUDED_flash_events_SampleDataEvent
#include <flash/events/SampleDataEvent.h>
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
namespace events{

Void SampleDataEvent_obj::__construct(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable)
{
HX_STACK_FRAME("flash.events.SampleDataEvent","new",0xe39e5801,"flash.events.SampleDataEvent.new","flash/events/SampleDataEvent.hx",16,0x1395dcaf)
HX_STACK_THIS(this)
HX_STACK_ARG(type,"type")
HX_STACK_ARG(__o_bubbles,"bubbles")
HX_STACK_ARG(__o_cancelable,"cancelable")
bool bubbles = __o_bubbles.Default(false);
bool cancelable = __o_cancelable.Default(false);
{
	HX_STACK_LINE(18)
	super::__construct(type,bubbles,cancelable);
	HX_STACK_LINE(20)
	::flash::utils::ByteArray _g = ::flash::utils::ByteArray_obj::__new(null());		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(20)
	this->data = _g;
	HX_STACK_LINE(21)
	this->data->bigEndian = false;
	HX_STACK_LINE(22)
	this->position = 0.0;
}
;
	return null();
}

//SampleDataEvent_obj::~SampleDataEvent_obj() { }

Dynamic SampleDataEvent_obj::__CreateEmpty() { return  new SampleDataEvent_obj; }
hx::ObjectPtr< SampleDataEvent_obj > SampleDataEvent_obj::__new(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable)
{  hx::ObjectPtr< SampleDataEvent_obj > result = new SampleDataEvent_obj();
	result->__construct(type,__o_bubbles,__o_cancelable);
	return result;}

Dynamic SampleDataEvent_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< SampleDataEvent_obj > result = new SampleDataEvent_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

::flash::events::Event SampleDataEvent_obj::clone( ){
	HX_STACK_FRAME("flash.events.SampleDataEvent","clone",0x7917853e,"flash.events.SampleDataEvent.clone","flash/events/SampleDataEvent.hx",27,0x1395dcaf)
	HX_STACK_THIS(this)
	HX_STACK_LINE(29)
	::String _g = this->get_type();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(29)
	bool _g1 = this->get_bubbles();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(29)
	bool _g2 = this->get_cancelable();		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(29)
	return ::flash::events::SampleDataEvent_obj::__new(_g,_g1,_g2);
}


::String SampleDataEvent_obj::toString( ){
	HX_STACK_FRAME("flash.events.SampleDataEvent","toString",0xb610016b,"flash.events.SampleDataEvent.toString","flash/events/SampleDataEvent.hx",34,0x1395dcaf)
	HX_STACK_THIS(this)
	HX_STACK_LINE(36)
	::String _g = this->get_type();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(36)
	::String _g1 = (HX_CSTRING("[SampleDataEvent type=") + _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(36)
	::String _g2 = (_g1 + HX_CSTRING(" bubbles="));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(36)
	bool _g3 = this->get_bubbles();		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(36)
	::String _g4 = ::Std_obj::string(_g3);		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(36)
	::String _g5 = (_g2 + _g4);		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(36)
	::String _g6 = (_g5 + HX_CSTRING(" cancelable="));		HX_STACK_VAR(_g6,"_g6");
	HX_STACK_LINE(36)
	bool _g7 = this->get_cancelable();		HX_STACK_VAR(_g7,"_g7");
	HX_STACK_LINE(36)
	::String _g8 = ::Std_obj::string(_g7);		HX_STACK_VAR(_g8,"_g8");
	HX_STACK_LINE(36)
	::String _g9 = (_g6 + _g8);		HX_STACK_VAR(_g9,"_g9");
	HX_STACK_LINE(36)
	return (_g9 + HX_CSTRING("]"));
}


::String SampleDataEvent_obj::SAMPLE_DATA;


SampleDataEvent_obj::SampleDataEvent_obj()
{
}

void SampleDataEvent_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(SampleDataEvent);
	HX_MARK_MEMBER_NAME(data,"data");
	HX_MARK_MEMBER_NAME(position,"position");
	::flash::events::Event_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void SampleDataEvent_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(data,"data");
	HX_VISIT_MEMBER_NAME(position,"position");
	::flash::events::Event_obj::__Visit(HX_VISIT_ARG);
}

Dynamic SampleDataEvent_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"data") ) { return data; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"position") ) { return position; }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"SAMPLE_DATA") ) { return SAMPLE_DATA; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic SampleDataEvent_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"data") ) { data=inValue.Cast< ::flash::utils::ByteArray >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"position") ) { position=inValue.Cast< Float >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"SAMPLE_DATA") ) { SAMPLE_DATA=inValue.Cast< ::String >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void SampleDataEvent_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("data"));
	outFields->push(HX_CSTRING("position"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("SAMPLE_DATA"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::flash::utils::ByteArray*/ ,(int)offsetof(SampleDataEvent_obj,data),HX_CSTRING("data")},
	{hx::fsFloat,(int)offsetof(SampleDataEvent_obj,position),HX_CSTRING("position")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("data"),
	HX_CSTRING("position"),
	HX_CSTRING("clone"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(SampleDataEvent_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(SampleDataEvent_obj::SAMPLE_DATA,"SAMPLE_DATA");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(SampleDataEvent_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(SampleDataEvent_obj::SAMPLE_DATA,"SAMPLE_DATA");
};

#endif

Class SampleDataEvent_obj::__mClass;

void SampleDataEvent_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.events.SampleDataEvent"), hx::TCanCast< SampleDataEvent_obj> ,sStaticFields,sMemberFields,
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

void SampleDataEvent_obj::__boot()
{
	SAMPLE_DATA= HX_CSTRING("sampleData");
}

} // end namespace flash
} // end namespace events
