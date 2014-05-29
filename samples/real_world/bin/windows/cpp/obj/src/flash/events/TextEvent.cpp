#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_flash_events_Event
#include <flash/events/Event.h>
#endif
#ifndef INCLUDED_flash_events_TextEvent
#include <flash/events/TextEvent.h>
#endif
namespace flash{
namespace events{

Void TextEvent_obj::__construct(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,::String __o_text)
{
HX_STACK_FRAME("flash.events.TextEvent","new",0xce59bee8,"flash.events.TextEvent.new","flash/events/TextEvent.hx",13,0xb9b2b7a8)
HX_STACK_THIS(this)
HX_STACK_ARG(type,"type")
HX_STACK_ARG(__o_bubbles,"bubbles")
HX_STACK_ARG(__o_cancelable,"cancelable")
HX_STACK_ARG(__o_text,"text")
bool bubbles = __o_bubbles.Default(false);
bool cancelable = __o_cancelable.Default(false);
::String text = __o_text.Default(HX_CSTRING(""));
{
	HX_STACK_LINE(15)
	super::__construct(type,bubbles,cancelable);
	HX_STACK_LINE(17)
	this->text = text;
}
;
	return null();
}

//TextEvent_obj::~TextEvent_obj() { }

Dynamic TextEvent_obj::__CreateEmpty() { return  new TextEvent_obj; }
hx::ObjectPtr< TextEvent_obj > TextEvent_obj::__new(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,::String __o_text)
{  hx::ObjectPtr< TextEvent_obj > result = new TextEvent_obj();
	result->__construct(type,__o_bubbles,__o_cancelable,__o_text);
	return result;}

Dynamic TextEvent_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< TextEvent_obj > result = new TextEvent_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3]);
	return result;}

::flash::events::Event TextEvent_obj::clone( ){
	HX_STACK_FRAME("flash.events.TextEvent","clone",0x16a7b3e5,"flash.events.TextEvent.clone","flash/events/TextEvent.hx",22,0xb9b2b7a8)
	HX_STACK_THIS(this)
	HX_STACK_LINE(24)
	::String _g = this->get_type();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(24)
	bool _g1 = this->get_bubbles();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(24)
	bool _g2 = this->get_cancelable();		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(24)
	return ::flash::events::TextEvent_obj::__new(_g,_g1,_g2,this->text);
}


::String TextEvent_obj::toString( ){
	HX_STACK_FRAME("flash.events.TextEvent","toString",0xc8b33524,"flash.events.TextEvent.toString","flash/events/TextEvent.hx",29,0xb9b2b7a8)
	HX_STACK_THIS(this)
	HX_STACK_LINE(31)
	::String _g = this->get_type();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(31)
	::String _g1 = (HX_CSTRING("[TextEvent type=") + _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(31)
	::String _g2 = (_g1 + HX_CSTRING(" bubbles="));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(31)
	bool _g3 = this->get_bubbles();		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(31)
	::String _g4 = ::Std_obj::string(_g3);		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(31)
	::String _g5 = (_g2 + _g4);		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(31)
	::String _g6 = (_g5 + HX_CSTRING(" cancelable="));		HX_STACK_VAR(_g6,"_g6");
	HX_STACK_LINE(31)
	bool _g7 = this->get_cancelable();		HX_STACK_VAR(_g7,"_g7");
	HX_STACK_LINE(31)
	::String _g8 = ::Std_obj::string(_g7);		HX_STACK_VAR(_g8,"_g8");
	HX_STACK_LINE(31)
	::String _g9 = (_g6 + _g8);		HX_STACK_VAR(_g9,"_g9");
	HX_STACK_LINE(31)
	::String _g10 = (_g9 + HX_CSTRING(" text="));		HX_STACK_VAR(_g10,"_g10");
	HX_STACK_LINE(31)
	::String _g11 = (_g10 + this->text);		HX_STACK_VAR(_g11,"_g11");
	HX_STACK_LINE(31)
	return (_g11 + HX_CSTRING("]"));
}


::String TextEvent_obj::LINK;

::String TextEvent_obj::TEXT_INPUT;


TextEvent_obj::TextEvent_obj()
{
}

void TextEvent_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(TextEvent);
	HX_MARK_MEMBER_NAME(text,"text");
	::flash::events::Event_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void TextEvent_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(text,"text");
	::flash::events::Event_obj::__Visit(HX_VISIT_ARG);
}

Dynamic TextEvent_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"LINK") ) { return LINK; }
		if (HX_FIELD_EQ(inName,"text") ) { return text; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"TEXT_INPUT") ) { return TEXT_INPUT; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic TextEvent_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"LINK") ) { LINK=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"text") ) { text=inValue.Cast< ::String >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"TEXT_INPUT") ) { TEXT_INPUT=inValue.Cast< ::String >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void TextEvent_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("text"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("LINK"),
	HX_CSTRING("TEXT_INPUT"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsString,(int)offsetof(TextEvent_obj,text),HX_CSTRING("text")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("text"),
	HX_CSTRING("clone"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(TextEvent_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(TextEvent_obj::LINK,"LINK");
	HX_MARK_MEMBER_NAME(TextEvent_obj::TEXT_INPUT,"TEXT_INPUT");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(TextEvent_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(TextEvent_obj::LINK,"LINK");
	HX_VISIT_MEMBER_NAME(TextEvent_obj::TEXT_INPUT,"TEXT_INPUT");
};

#endif

Class TextEvent_obj::__mClass;

void TextEvent_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.events.TextEvent"), hx::TCanCast< TextEvent_obj> ,sStaticFields,sMemberFields,
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

void TextEvent_obj::__boot()
{
	LINK= HX_CSTRING("link");
	TEXT_INPUT= HX_CSTRING("textInput");
}

} // end namespace flash
} // end namespace events
