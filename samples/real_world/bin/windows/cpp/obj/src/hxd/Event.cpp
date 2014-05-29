#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_hxd_Event
#include <hxd/Event.h>
#endif
#ifndef INCLUDED_hxd_EventKind
#include <hxd/EventKind.h>
#endif
namespace hxd{

Void Event_obj::__construct(::hxd::EventKind k,hx::Null< Float >  __o_x,hx::Null< Float >  __o_y)
{
HX_STACK_FRAME("hxd.Event","new",0x90f42c52,"hxd.Event.new","hxd/Event.hx",29,0x8fdcac5f)
HX_STACK_THIS(this)
HX_STACK_ARG(k,"k")
HX_STACK_ARG(__o_x,"x")
HX_STACK_ARG(__o_y,"y")
Float x = __o_x.Default(0.);
Float y = __o_y.Default(0.);
{
	HX_STACK_LINE(30)
	this->kind = k;
	HX_STACK_LINE(31)
	this->relX = x;
	HX_STACK_LINE(32)
	this->relY = y;
}
;
	return null();
}

//Event_obj::~Event_obj() { }

Dynamic Event_obj::__CreateEmpty() { return  new Event_obj; }
hx::ObjectPtr< Event_obj > Event_obj::__new(::hxd::EventKind k,hx::Null< Float >  __o_x,hx::Null< Float >  __o_y)
{  hx::ObjectPtr< Event_obj > result = new Event_obj();
	result->__construct(k,__o_x,__o_y);
	return result;}

Dynamic Event_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Event_obj > result = new Event_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

::String Event_obj::toString( ){
	HX_STACK_FRAME("hxd.Event","toString",0xa001e77a,"hxd.Event.toString","hxd/Event.hx",35,0x8fdcac5f)
	HX_STACK_THIS(this)
	HX_STACK_LINE(36)
	::String _g = ::Std_obj::string(this->kind);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(36)
	::String _g1 = (_g + HX_CSTRING("["));		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(36)
	int _g2 = ::Std_obj::_int(this->relX);		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(36)
	::String _g3 = (_g1 + _g2);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(36)
	::String _g4 = (_g3 + HX_CSTRING(","));		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(36)
	int _g5 = ::Std_obj::_int(this->relY);		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(36)
	::String _g6 = (_g4 + _g5);		HX_STACK_VAR(_g6,"_g6");
	HX_STACK_LINE(36)
	return (_g6 + HX_CSTRING("]"));
}


HX_DEFINE_DYNAMIC_FUNC0(Event_obj,toString,return )


Event_obj::Event_obj()
{
}

void Event_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Event);
	HX_MARK_MEMBER_NAME(kind,"kind");
	HX_MARK_MEMBER_NAME(relX,"relX");
	HX_MARK_MEMBER_NAME(relY,"relY");
	HX_MARK_MEMBER_NAME(propagate,"propagate");
	HX_MARK_MEMBER_NAME(cancel,"cancel");
	HX_MARK_MEMBER_NAME(button,"button");
	HX_MARK_MEMBER_NAME(touchId,"touchId");
	HX_MARK_MEMBER_NAME(keyCode,"keyCode");
	HX_MARK_MEMBER_NAME(charCode,"charCode");
	HX_MARK_MEMBER_NAME(wheelDelta,"wheelDelta");
	HX_MARK_END_CLASS();
}

void Event_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(kind,"kind");
	HX_VISIT_MEMBER_NAME(relX,"relX");
	HX_VISIT_MEMBER_NAME(relY,"relY");
	HX_VISIT_MEMBER_NAME(propagate,"propagate");
	HX_VISIT_MEMBER_NAME(cancel,"cancel");
	HX_VISIT_MEMBER_NAME(button,"button");
	HX_VISIT_MEMBER_NAME(touchId,"touchId");
	HX_VISIT_MEMBER_NAME(keyCode,"keyCode");
	HX_VISIT_MEMBER_NAME(charCode,"charCode");
	HX_VISIT_MEMBER_NAME(wheelDelta,"wheelDelta");
}

Dynamic Event_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"kind") ) { return kind; }
		if (HX_FIELD_EQ(inName,"relX") ) { return relX; }
		if (HX_FIELD_EQ(inName,"relY") ) { return relY; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"cancel") ) { return cancel; }
		if (HX_FIELD_EQ(inName,"button") ) { return button; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"touchId") ) { return touchId; }
		if (HX_FIELD_EQ(inName,"keyCode") ) { return keyCode; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"charCode") ) { return charCode; }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"propagate") ) { return propagate; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"wheelDelta") ) { return wheelDelta; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Event_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"kind") ) { kind=inValue.Cast< ::hxd::EventKind >(); return inValue; }
		if (HX_FIELD_EQ(inName,"relX") ) { relX=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"relY") ) { relY=inValue.Cast< Float >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"cancel") ) { cancel=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"button") ) { button=inValue.Cast< int >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"touchId") ) { touchId=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"keyCode") ) { keyCode=inValue.Cast< int >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"charCode") ) { charCode=inValue.Cast< int >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"propagate") ) { propagate=inValue.Cast< bool >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"wheelDelta") ) { wheelDelta=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Event_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("kind"));
	outFields->push(HX_CSTRING("relX"));
	outFields->push(HX_CSTRING("relY"));
	outFields->push(HX_CSTRING("propagate"));
	outFields->push(HX_CSTRING("cancel"));
	outFields->push(HX_CSTRING("button"));
	outFields->push(HX_CSTRING("touchId"));
	outFields->push(HX_CSTRING("keyCode"));
	outFields->push(HX_CSTRING("charCode"));
	outFields->push(HX_CSTRING("wheelDelta"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::hxd::EventKind*/ ,(int)offsetof(Event_obj,kind),HX_CSTRING("kind")},
	{hx::fsFloat,(int)offsetof(Event_obj,relX),HX_CSTRING("relX")},
	{hx::fsFloat,(int)offsetof(Event_obj,relY),HX_CSTRING("relY")},
	{hx::fsBool,(int)offsetof(Event_obj,propagate),HX_CSTRING("propagate")},
	{hx::fsBool,(int)offsetof(Event_obj,cancel),HX_CSTRING("cancel")},
	{hx::fsInt,(int)offsetof(Event_obj,button),HX_CSTRING("button")},
	{hx::fsInt,(int)offsetof(Event_obj,touchId),HX_CSTRING("touchId")},
	{hx::fsInt,(int)offsetof(Event_obj,keyCode),HX_CSTRING("keyCode")},
	{hx::fsInt,(int)offsetof(Event_obj,charCode),HX_CSTRING("charCode")},
	{hx::fsFloat,(int)offsetof(Event_obj,wheelDelta),HX_CSTRING("wheelDelta")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("kind"),
	HX_CSTRING("relX"),
	HX_CSTRING("relY"),
	HX_CSTRING("propagate"),
	HX_CSTRING("cancel"),
	HX_CSTRING("button"),
	HX_CSTRING("touchId"),
	HX_CSTRING("keyCode"),
	HX_CSTRING("charCode"),
	HX_CSTRING("wheelDelta"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Event_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Event_obj::__mClass,"__mClass");
};

#endif

Class Event_obj::__mClass;

void Event_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.Event"), hx::TCanCast< Event_obj> ,sStaticFields,sMemberFields,
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

void Event_obj::__boot()
{
}

} // end namespace hxd
