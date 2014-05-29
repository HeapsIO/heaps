#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_flash_events_ErrorEvent
#include <flash/events/ErrorEvent.h>
#endif
#ifndef INCLUDED_flash_events_Event
#include <flash/events/Event.h>
#endif
#ifndef INCLUDED_flash_events_IOErrorEvent
#include <flash/events/IOErrorEvent.h>
#endif
#ifndef INCLUDED_flash_events_TextEvent
#include <flash/events/TextEvent.h>
#endif
namespace flash{
namespace events{

Void IOErrorEvent_obj::__construct(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,::String __o_text,hx::Null< int >  __o_id)
{
HX_STACK_FRAME("flash.events.IOErrorEvent","new",0x46b75fe1,"flash.events.IOErrorEvent.new","flash/events/IOErrorEvent.hx",12,0x7107e88f)
HX_STACK_THIS(this)
HX_STACK_ARG(type,"type")
HX_STACK_ARG(__o_bubbles,"bubbles")
HX_STACK_ARG(__o_cancelable,"cancelable")
HX_STACK_ARG(__o_text,"text")
HX_STACK_ARG(__o_id,"id")
bool bubbles = __o_bubbles.Default(true);
bool cancelable = __o_cancelable.Default(false);
::String text = __o_text.Default(HX_CSTRING(""));
int id = __o_id.Default(0);
{
	HX_STACK_LINE(12)
	super::__construct(type,bubbles,cancelable,text,id);
}
;
	return null();
}

//IOErrorEvent_obj::~IOErrorEvent_obj() { }

Dynamic IOErrorEvent_obj::__CreateEmpty() { return  new IOErrorEvent_obj; }
hx::ObjectPtr< IOErrorEvent_obj > IOErrorEvent_obj::__new(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,::String __o_text,hx::Null< int >  __o_id)
{  hx::ObjectPtr< IOErrorEvent_obj > result = new IOErrorEvent_obj();
	result->__construct(type,__o_bubbles,__o_cancelable,__o_text,__o_id);
	return result;}

Dynamic IOErrorEvent_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< IOErrorEvent_obj > result = new IOErrorEvent_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4]);
	return result;}

::flash::events::Event IOErrorEvent_obj::clone( ){
	HX_STACK_FRAME("flash.events.IOErrorEvent","clone",0x9a6a451e,"flash.events.IOErrorEvent.clone","flash/events/IOErrorEvent.hx",17,0x7107e88f)
	HX_STACK_THIS(this)
	HX_STACK_LINE(19)
	::String _g = this->get_type();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(19)
	bool _g1 = this->get_bubbles();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(19)
	bool _g2 = this->get_cancelable();		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(19)
	return ::flash::events::IOErrorEvent_obj::__new(_g,_g1,_g2,this->text,this->errorID);
}


::String IOErrorEvent_obj::toString( ){
	HX_STACK_FRAME("flash.events.IOErrorEvent","toString",0x87ce6d8b,"flash.events.IOErrorEvent.toString","flash/events/IOErrorEvent.hx",24,0x7107e88f)
	HX_STACK_THIS(this)
	HX_STACK_LINE(26)
	::String _g = this->get_type();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(26)
	::String _g1 = (HX_CSTRING("[IOErrorEvent type=") + _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(26)
	::String _g2 = (_g1 + HX_CSTRING(" bubbles="));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(26)
	bool _g3 = this->get_bubbles();		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(26)
	::String _g4 = ::Std_obj::string(_g3);		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(26)
	::String _g5 = (_g2 + _g4);		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(26)
	::String _g6 = (_g5 + HX_CSTRING(" cancelable="));		HX_STACK_VAR(_g6,"_g6");
	HX_STACK_LINE(26)
	bool _g7 = this->get_cancelable();		HX_STACK_VAR(_g7,"_g7");
	HX_STACK_LINE(26)
	::String _g8 = ::Std_obj::string(_g7);		HX_STACK_VAR(_g8,"_g8");
	HX_STACK_LINE(26)
	::String _g9 = (_g6 + _g8);		HX_STACK_VAR(_g9,"_g9");
	HX_STACK_LINE(26)
	::String _g10 = (_g9 + HX_CSTRING(" text="));		HX_STACK_VAR(_g10,"_g10");
	HX_STACK_LINE(26)
	::String _g11 = (_g10 + this->text);		HX_STACK_VAR(_g11,"_g11");
	HX_STACK_LINE(26)
	::String _g12 = (_g11 + HX_CSTRING(" errorID="));		HX_STACK_VAR(_g12,"_g12");
	HX_STACK_LINE(26)
	::String _g13 = (_g12 + this->errorID);		HX_STACK_VAR(_g13,"_g13");
	HX_STACK_LINE(26)
	return (_g13 + HX_CSTRING("]"));
}


::String IOErrorEvent_obj::IO_ERROR;


IOErrorEvent_obj::IOErrorEvent_obj()
{
}

Dynamic IOErrorEvent_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"IO_ERROR") ) { return IO_ERROR; }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic IOErrorEvent_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 8:
		if (HX_FIELD_EQ(inName,"IO_ERROR") ) { IO_ERROR=inValue.Cast< ::String >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void IOErrorEvent_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("IO_ERROR"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("clone"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(IOErrorEvent_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(IOErrorEvent_obj::IO_ERROR,"IO_ERROR");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(IOErrorEvent_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(IOErrorEvent_obj::IO_ERROR,"IO_ERROR");
};

#endif

Class IOErrorEvent_obj::__mClass;

void IOErrorEvent_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.events.IOErrorEvent"), hx::TCanCast< IOErrorEvent_obj> ,sStaticFields,sMemberFields,
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

void IOErrorEvent_obj::__boot()
{
	IO_ERROR= HX_CSTRING("ioError");
}

} // end namespace flash
} // end namespace events
