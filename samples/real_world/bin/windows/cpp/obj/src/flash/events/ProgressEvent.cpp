#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_flash_events_Event
#include <flash/events/Event.h>
#endif
#ifndef INCLUDED_flash_events_ProgressEvent
#include <flash/events/ProgressEvent.h>
#endif
namespace flash{
namespace events{

Void ProgressEvent_obj::__construct(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,hx::Null< int >  __o_bytesLoaded,hx::Null< int >  __o_bytesTotal)
{
HX_STACK_FRAME("flash.events.ProgressEvent","new",0xae1d0c68,"flash.events.ProgressEvent.new","flash/events/ProgressEvent.hx",14,0xc7812a28)
HX_STACK_THIS(this)
HX_STACK_ARG(type,"type")
HX_STACK_ARG(__o_bubbles,"bubbles")
HX_STACK_ARG(__o_cancelable,"cancelable")
HX_STACK_ARG(__o_bytesLoaded,"bytesLoaded")
HX_STACK_ARG(__o_bytesTotal,"bytesTotal")
bool bubbles = __o_bubbles.Default(false);
bool cancelable = __o_cancelable.Default(false);
int bytesLoaded = __o_bytesLoaded.Default(0);
int bytesTotal = __o_bytesTotal.Default(0);
{
	HX_STACK_LINE(16)
	super::__construct(type,bubbles,cancelable);
	HX_STACK_LINE(18)
	this->bytesLoaded = bytesLoaded;
	HX_STACK_LINE(19)
	this->bytesTotal = bytesTotal;
}
;
	return null();
}

//ProgressEvent_obj::~ProgressEvent_obj() { }

Dynamic ProgressEvent_obj::__CreateEmpty() { return  new ProgressEvent_obj; }
hx::ObjectPtr< ProgressEvent_obj > ProgressEvent_obj::__new(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,hx::Null< int >  __o_bytesLoaded,hx::Null< int >  __o_bytesTotal)
{  hx::ObjectPtr< ProgressEvent_obj > result = new ProgressEvent_obj();
	result->__construct(type,__o_bubbles,__o_cancelable,__o_bytesLoaded,__o_bytesTotal);
	return result;}

Dynamic ProgressEvent_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< ProgressEvent_obj > result = new ProgressEvent_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4]);
	return result;}

::flash::events::Event ProgressEvent_obj::clone( ){
	HX_STACK_FRAME("flash.events.ProgressEvent","clone",0xe7f96165,"flash.events.ProgressEvent.clone","flash/events/ProgressEvent.hx",24,0xc7812a28)
	HX_STACK_THIS(this)
	HX_STACK_LINE(26)
	::String _g = this->get_type();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(26)
	bool _g1 = this->get_bubbles();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(26)
	bool _g2 = this->get_cancelable();		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(26)
	return ::flash::events::ProgressEvent_obj::__new(_g,_g1,_g2,this->bytesLoaded,this->bytesTotal);
}


::String ProgressEvent_obj::toString( ){
	HX_STACK_FRAME("flash.events.ProgressEvent","toString",0x8e86f7a4,"flash.events.ProgressEvent.toString","flash/events/ProgressEvent.hx",31,0xc7812a28)
	HX_STACK_THIS(this)
	HX_STACK_LINE(33)
	::String _g = this->get_type();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(33)
	::String _g1 = (HX_CSTRING("[ProgressEvent type=") + _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(33)
	::String _g2 = (_g1 + HX_CSTRING(" bubbles="));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(33)
	bool _g3 = this->get_bubbles();		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(33)
	::String _g4 = ::Std_obj::string(_g3);		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(33)
	::String _g5 = (_g2 + _g4);		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(33)
	::String _g6 = (_g5 + HX_CSTRING(" cancelable="));		HX_STACK_VAR(_g6,"_g6");
	HX_STACK_LINE(33)
	bool _g7 = this->get_cancelable();		HX_STACK_VAR(_g7,"_g7");
	HX_STACK_LINE(33)
	::String _g8 = ::Std_obj::string(_g7);		HX_STACK_VAR(_g8,"_g8");
	HX_STACK_LINE(33)
	::String _g9 = (_g6 + _g8);		HX_STACK_VAR(_g9,"_g9");
	HX_STACK_LINE(33)
	::String _g10 = (_g9 + HX_CSTRING(" bytesLoaded="));		HX_STACK_VAR(_g10,"_g10");
	HX_STACK_LINE(33)
	::String _g11 = (_g10 + this->bytesLoaded);		HX_STACK_VAR(_g11,"_g11");
	HX_STACK_LINE(33)
	::String _g12 = (_g11 + HX_CSTRING(" bytesTotal="));		HX_STACK_VAR(_g12,"_g12");
	HX_STACK_LINE(33)
	::String _g13 = (_g12 + this->bytesTotal);		HX_STACK_VAR(_g13,"_g13");
	HX_STACK_LINE(33)
	return (_g13 + HX_CSTRING("]"));
}


::String ProgressEvent_obj::PROGRESS;

::String ProgressEvent_obj::SOCKET_DATA;


ProgressEvent_obj::ProgressEvent_obj()
{
}

Dynamic ProgressEvent_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"bytesTotal") ) { return bytesTotal; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"bytesLoaded") ) { return bytesLoaded; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic ProgressEvent_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 10:
		if (HX_FIELD_EQ(inName,"bytesTotal") ) { bytesTotal=inValue.Cast< int >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"bytesLoaded") ) { bytesLoaded=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void ProgressEvent_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("bytesLoaded"));
	outFields->push(HX_CSTRING("bytesTotal"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("PROGRESS"),
	HX_CSTRING("SOCKET_DATA"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(ProgressEvent_obj,bytesLoaded),HX_CSTRING("bytesLoaded")},
	{hx::fsInt,(int)offsetof(ProgressEvent_obj,bytesTotal),HX_CSTRING("bytesTotal")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("bytesLoaded"),
	HX_CSTRING("bytesTotal"),
	HX_CSTRING("clone"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(ProgressEvent_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(ProgressEvent_obj::PROGRESS,"PROGRESS");
	HX_MARK_MEMBER_NAME(ProgressEvent_obj::SOCKET_DATA,"SOCKET_DATA");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(ProgressEvent_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(ProgressEvent_obj::PROGRESS,"PROGRESS");
	HX_VISIT_MEMBER_NAME(ProgressEvent_obj::SOCKET_DATA,"SOCKET_DATA");
};

#endif

Class ProgressEvent_obj::__mClass;

void ProgressEvent_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.events.ProgressEvent"), hx::TCanCast< ProgressEvent_obj> ,sStaticFields,sMemberFields,
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

void ProgressEvent_obj::__boot()
{
	PROGRESS= HX_CSTRING("progress");
	SOCKET_DATA= HX_CSTRING("socketData");
}

} // end namespace flash
} // end namespace events
