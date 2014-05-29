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
#ifndef INCLUDED_flash_events_TextEvent
#include <flash/events/TextEvent.h>
#endif
namespace flash{
namespace events{

Void ErrorEvent_obj::__construct(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,::String __o_text,hx::Null< int >  __o_id)
{
HX_STACK_FRAME("flash.events.ErrorEvent","new",0x54930dbb,"flash.events.ErrorEvent.new","flash/events/ErrorEvent.hx",12,0x41a3fbf5)
HX_STACK_THIS(this)
HX_STACK_ARG(type,"type")
HX_STACK_ARG(__o_bubbles,"bubbles")
HX_STACK_ARG(__o_cancelable,"cancelable")
HX_STACK_ARG(__o_text,"text")
HX_STACK_ARG(__o_id,"id")
bool bubbles = __o_bubbles.Default(false);
bool cancelable = __o_cancelable.Default(false);
::String text = __o_text.Default(HX_CSTRING(""));
int id = __o_id.Default(0);
{
	HX_STACK_LINE(14)
	super::__construct(type,bubbles,cancelable,text);
	HX_STACK_LINE(15)
	this->errorID = id;
}
;
	return null();
}

//ErrorEvent_obj::~ErrorEvent_obj() { }

Dynamic ErrorEvent_obj::__CreateEmpty() { return  new ErrorEvent_obj; }
hx::ObjectPtr< ErrorEvent_obj > ErrorEvent_obj::__new(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,::String __o_text,hx::Null< int >  __o_id)
{  hx::ObjectPtr< ErrorEvent_obj > result = new ErrorEvent_obj();
	result->__construct(type,__o_bubbles,__o_cancelable,__o_text,__o_id);
	return result;}

Dynamic ErrorEvent_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< ErrorEvent_obj > result = new ErrorEvent_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4]);
	return result;}

::flash::events::Event ErrorEvent_obj::clone( ){
	HX_STACK_FRAME("flash.events.ErrorEvent","clone",0x98f09d78,"flash.events.ErrorEvent.clone","flash/events/ErrorEvent.hx",20,0x41a3fbf5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(22)
	::String _g = this->get_type();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(22)
	bool _g1 = this->get_bubbles();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(22)
	bool _g2 = this->get_cancelable();		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(22)
	return ::flash::events::ErrorEvent_obj::__new(_g,_g1,_g2,this->text,this->errorID);
}


::String ErrorEvent_obj::toString( ){
	HX_STACK_FRAME("flash.events.ErrorEvent","toString",0x474c4971,"flash.events.ErrorEvent.toString","flash/events/ErrorEvent.hx",27,0x41a3fbf5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(29)
	::String _g = this->get_type();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(29)
	::String _g1 = (HX_CSTRING("[ErrorEvent type=") + _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(29)
	::String _g2 = (_g1 + HX_CSTRING(" bubbles="));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(29)
	bool _g3 = this->get_bubbles();		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(29)
	::String _g4 = ::Std_obj::string(_g3);		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(29)
	::String _g5 = (_g2 + _g4);		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(29)
	::String _g6 = (_g5 + HX_CSTRING(" cancelable="));		HX_STACK_VAR(_g6,"_g6");
	HX_STACK_LINE(29)
	bool _g7 = this->get_cancelable();		HX_STACK_VAR(_g7,"_g7");
	HX_STACK_LINE(29)
	::String _g8 = ::Std_obj::string(_g7);		HX_STACK_VAR(_g8,"_g8");
	HX_STACK_LINE(29)
	::String _g9 = (_g6 + _g8);		HX_STACK_VAR(_g9,"_g9");
	HX_STACK_LINE(29)
	::String _g10 = (_g9 + HX_CSTRING(" text="));		HX_STACK_VAR(_g10,"_g10");
	HX_STACK_LINE(29)
	::String _g11 = (_g10 + this->text);		HX_STACK_VAR(_g11,"_g11");
	HX_STACK_LINE(29)
	::String _g12 = (_g11 + HX_CSTRING(" errorID="));		HX_STACK_VAR(_g12,"_g12");
	HX_STACK_LINE(29)
	::String _g13 = (_g12 + this->errorID);		HX_STACK_VAR(_g13,"_g13");
	HX_STACK_LINE(29)
	return (_g13 + HX_CSTRING("]"));
}


::String ErrorEvent_obj::ERROR;


ErrorEvent_obj::ErrorEvent_obj()
{
}

Dynamic ErrorEvent_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"ERROR") ) { return ERROR; }
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"errorID") ) { return errorID; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic ErrorEvent_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"ERROR") ) { ERROR=inValue.Cast< ::String >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"errorID") ) { errorID=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void ErrorEvent_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("errorID"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("ERROR"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(ErrorEvent_obj,errorID),HX_CSTRING("errorID")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("errorID"),
	HX_CSTRING("clone"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(ErrorEvent_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(ErrorEvent_obj::ERROR,"ERROR");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(ErrorEvent_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(ErrorEvent_obj::ERROR,"ERROR");
};

#endif

Class ErrorEvent_obj::__mClass;

void ErrorEvent_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.events.ErrorEvent"), hx::TCanCast< ErrorEvent_obj> ,sStaticFields,sMemberFields,
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

void ErrorEvent_obj::__boot()
{
	ERROR= HX_CSTRING("error");
}

} // end namespace flash
} // end namespace events
