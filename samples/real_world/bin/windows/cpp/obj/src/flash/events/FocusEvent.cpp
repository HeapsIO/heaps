#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_flash_display_DisplayObject
#include <flash/display/DisplayObject.h>
#endif
#ifndef INCLUDED_flash_display_IBitmapDrawable
#include <flash/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_flash_display_InteractiveObject
#include <flash/display/InteractiveObject.h>
#endif
#ifndef INCLUDED_flash_events_Event
#include <flash/events/Event.h>
#endif
#ifndef INCLUDED_flash_events_EventDispatcher
#include <flash/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_flash_events_FocusEvent
#include <flash/events/FocusEvent.h>
#endif
#ifndef INCLUDED_flash_events_IEventDispatcher
#include <flash/events/IEventDispatcher.h>
#endif
namespace flash{
namespace events{

Void FocusEvent_obj::__construct(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,::flash::display::InteractiveObject relatedObject,hx::Null< bool >  __o_shiftKey,hx::Null< int >  __o_keyCode,::String __o_direction)
{
HX_STACK_FRAME("flash.events.FocusEvent","new",0x314877ab,"flash.events.FocusEvent.new","flash/events/FocusEvent.hx",20,0x89ce2005)
HX_STACK_THIS(this)
HX_STACK_ARG(type,"type")
HX_STACK_ARG(__o_bubbles,"bubbles")
HX_STACK_ARG(__o_cancelable,"cancelable")
HX_STACK_ARG(relatedObject,"relatedObject")
HX_STACK_ARG(__o_shiftKey,"shiftKey")
HX_STACK_ARG(__o_keyCode,"keyCode")
HX_STACK_ARG(__o_direction,"direction")
bool bubbles = __o_bubbles.Default(true);
bool cancelable = __o_cancelable.Default(false);
bool shiftKey = __o_shiftKey.Default(false);
int keyCode = __o_keyCode.Default(0);
::String direction = __o_direction.Default(HX_CSTRING("none"));
{
	HX_STACK_LINE(22)
	super::__construct(type,bubbles,cancelable);
	HX_STACK_LINE(24)
	this->relatedObject = relatedObject;
	HX_STACK_LINE(25)
	this->keyCode = keyCode;
	HX_STACK_LINE(26)
	this->shiftKey = shiftKey;
}
;
	return null();
}

//FocusEvent_obj::~FocusEvent_obj() { }

Dynamic FocusEvent_obj::__CreateEmpty() { return  new FocusEvent_obj; }
hx::ObjectPtr< FocusEvent_obj > FocusEvent_obj::__new(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,::flash::display::InteractiveObject relatedObject,hx::Null< bool >  __o_shiftKey,hx::Null< int >  __o_keyCode,::String __o_direction)
{  hx::ObjectPtr< FocusEvent_obj > result = new FocusEvent_obj();
	result->__construct(type,__o_bubbles,__o_cancelable,relatedObject,__o_shiftKey,__o_keyCode,__o_direction);
	return result;}

Dynamic FocusEvent_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< FocusEvent_obj > result = new FocusEvent_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4],inArgs[5],inArgs[6]);
	return result;}

::flash::events::Event FocusEvent_obj::clone( ){
	HX_STACK_FRAME("flash.events.FocusEvent","clone",0x1d486368,"flash.events.FocusEvent.clone","flash/events/FocusEvent.hx",31,0x89ce2005)
	HX_STACK_THIS(this)
	HX_STACK_LINE(33)
	::String _g = this->get_type();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(33)
	bool _g1 = this->get_bubbles();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(33)
	bool _g2 = this->get_cancelable();		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(33)
	return ::flash::events::FocusEvent_obj::__new(_g,_g1,_g2,this->relatedObject,this->shiftKey,this->keyCode,null());
}


::String FocusEvent_obj::toString( ){
	HX_STACK_FRAME("flash.events.FocusEvent","toString",0xa900d981,"flash.events.FocusEvent.toString","flash/events/FocusEvent.hx",38,0x89ce2005)
	HX_STACK_THIS(this)
	HX_STACK_LINE(40)
	::String _g = this->get_type();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(40)
	::String _g1 = (HX_CSTRING("[FocusEvent type=") + _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(40)
	::String _g2 = (_g1 + HX_CSTRING(" bubbles="));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(40)
	bool _g3 = this->get_bubbles();		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(40)
	::String _g4 = ::Std_obj::string(_g3);		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(40)
	::String _g5 = (_g2 + _g4);		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(40)
	::String _g6 = (_g5 + HX_CSTRING(" cancelable="));		HX_STACK_VAR(_g6,"_g6");
	HX_STACK_LINE(40)
	bool _g7 = this->get_cancelable();		HX_STACK_VAR(_g7,"_g7");
	HX_STACK_LINE(40)
	::String _g8 = ::Std_obj::string(_g7);		HX_STACK_VAR(_g8,"_g8");
	HX_STACK_LINE(40)
	::String _g9 = (_g6 + _g8);		HX_STACK_VAR(_g9,"_g9");
	HX_STACK_LINE(40)
	::String _g10 = (_g9 + HX_CSTRING(" relatedObject="));		HX_STACK_VAR(_g10,"_g10");
	HX_STACK_LINE(40)
	::String _g11 = ::Std_obj::string(this->relatedObject);		HX_STACK_VAR(_g11,"_g11");
	HX_STACK_LINE(40)
	::String _g12 = (_g10 + _g11);		HX_STACK_VAR(_g12,"_g12");
	HX_STACK_LINE(40)
	::String _g13 = (_g12 + HX_CSTRING(" shiftKey="));		HX_STACK_VAR(_g13,"_g13");
	HX_STACK_LINE(40)
	::String _g14 = ::Std_obj::string(this->shiftKey);		HX_STACK_VAR(_g14,"_g14");
	HX_STACK_LINE(40)
	::String _g15 = (_g13 + _g14);		HX_STACK_VAR(_g15,"_g15");
	HX_STACK_LINE(40)
	::String _g16 = (_g15 + HX_CSTRING(" keyCode="));		HX_STACK_VAR(_g16,"_g16");
	HX_STACK_LINE(40)
	::String _g17 = (_g16 + this->keyCode);		HX_STACK_VAR(_g17,"_g17");
	HX_STACK_LINE(40)
	return (_g17 + HX_CSTRING("]"));
}


::String FocusEvent_obj::FOCUS_IN;

::String FocusEvent_obj::FOCUS_OUT;

::String FocusEvent_obj::KEY_FOCUS_CHANGE;

::String FocusEvent_obj::MOUSE_FOCUS_CHANGE;


FocusEvent_obj::FocusEvent_obj()
{
}

void FocusEvent_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(FocusEvent);
	HX_MARK_MEMBER_NAME(keyCode,"keyCode");
	HX_MARK_MEMBER_NAME(relatedObject,"relatedObject");
	HX_MARK_MEMBER_NAME(shiftKey,"shiftKey");
	::flash::events::Event_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void FocusEvent_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(keyCode,"keyCode");
	HX_VISIT_MEMBER_NAME(relatedObject,"relatedObject");
	HX_VISIT_MEMBER_NAME(shiftKey,"shiftKey");
	::flash::events::Event_obj::__Visit(HX_VISIT_ARG);
}

Dynamic FocusEvent_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"keyCode") ) { return keyCode; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"FOCUS_IN") ) { return FOCUS_IN; }
		if (HX_FIELD_EQ(inName,"shiftKey") ) { return shiftKey; }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"FOCUS_OUT") ) { return FOCUS_OUT; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"relatedObject") ) { return relatedObject; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"KEY_FOCUS_CHANGE") ) { return KEY_FOCUS_CHANGE; }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"MOUSE_FOCUS_CHANGE") ) { return MOUSE_FOCUS_CHANGE; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic FocusEvent_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 7:
		if (HX_FIELD_EQ(inName,"keyCode") ) { keyCode=inValue.Cast< int >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"FOCUS_IN") ) { FOCUS_IN=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"shiftKey") ) { shiftKey=inValue.Cast< bool >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"FOCUS_OUT") ) { FOCUS_OUT=inValue.Cast< ::String >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"relatedObject") ) { relatedObject=inValue.Cast< ::flash::display::InteractiveObject >(); return inValue; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"KEY_FOCUS_CHANGE") ) { KEY_FOCUS_CHANGE=inValue.Cast< ::String >(); return inValue; }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"MOUSE_FOCUS_CHANGE") ) { MOUSE_FOCUS_CHANGE=inValue.Cast< ::String >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void FocusEvent_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("keyCode"));
	outFields->push(HX_CSTRING("relatedObject"));
	outFields->push(HX_CSTRING("shiftKey"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("FOCUS_IN"),
	HX_CSTRING("FOCUS_OUT"),
	HX_CSTRING("KEY_FOCUS_CHANGE"),
	HX_CSTRING("MOUSE_FOCUS_CHANGE"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(FocusEvent_obj,keyCode),HX_CSTRING("keyCode")},
	{hx::fsObject /*::flash::display::InteractiveObject*/ ,(int)offsetof(FocusEvent_obj,relatedObject),HX_CSTRING("relatedObject")},
	{hx::fsBool,(int)offsetof(FocusEvent_obj,shiftKey),HX_CSTRING("shiftKey")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("keyCode"),
	HX_CSTRING("relatedObject"),
	HX_CSTRING("shiftKey"),
	HX_CSTRING("clone"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FocusEvent_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(FocusEvent_obj::FOCUS_IN,"FOCUS_IN");
	HX_MARK_MEMBER_NAME(FocusEvent_obj::FOCUS_OUT,"FOCUS_OUT");
	HX_MARK_MEMBER_NAME(FocusEvent_obj::KEY_FOCUS_CHANGE,"KEY_FOCUS_CHANGE");
	HX_MARK_MEMBER_NAME(FocusEvent_obj::MOUSE_FOCUS_CHANGE,"MOUSE_FOCUS_CHANGE");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FocusEvent_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(FocusEvent_obj::FOCUS_IN,"FOCUS_IN");
	HX_VISIT_MEMBER_NAME(FocusEvent_obj::FOCUS_OUT,"FOCUS_OUT");
	HX_VISIT_MEMBER_NAME(FocusEvent_obj::KEY_FOCUS_CHANGE,"KEY_FOCUS_CHANGE");
	HX_VISIT_MEMBER_NAME(FocusEvent_obj::MOUSE_FOCUS_CHANGE,"MOUSE_FOCUS_CHANGE");
};

#endif

Class FocusEvent_obj::__mClass;

void FocusEvent_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.events.FocusEvent"), hx::TCanCast< FocusEvent_obj> ,sStaticFields,sMemberFields,
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

void FocusEvent_obj::__boot()
{
	FOCUS_IN= HX_CSTRING("focusIn");
	FOCUS_OUT= HX_CSTRING("focusOut");
	KEY_FOCUS_CHANGE= HX_CSTRING("keyFocusChange");
	MOUSE_FOCUS_CHANGE= HX_CSTRING("mouseFocusChange");
}

} // end namespace flash
} // end namespace events
