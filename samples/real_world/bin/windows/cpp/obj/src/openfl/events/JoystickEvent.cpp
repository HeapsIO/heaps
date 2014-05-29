#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_flash_events_Event
#include <flash/events/Event.h>
#endif
#ifndef INCLUDED_openfl_events_JoystickEvent
#include <openfl/events/JoystickEvent.h>
#endif
namespace openfl{
namespace events{

Void JoystickEvent_obj::__construct(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,hx::Null< int >  __o_device,hx::Null< int >  __o_id,hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z)
{
HX_STACK_FRAME("openfl.events.JoystickEvent","new",0xfbc75f99,"openfl.events.JoystickEvent.new","openfl/events/JoystickEvent.hx",25,0x4ab90817)
HX_STACK_THIS(this)
HX_STACK_ARG(type,"type")
HX_STACK_ARG(__o_bubbles,"bubbles")
HX_STACK_ARG(__o_cancelable,"cancelable")
HX_STACK_ARG(__o_device,"device")
HX_STACK_ARG(__o_id,"id")
HX_STACK_ARG(__o_x,"x")
HX_STACK_ARG(__o_y,"y")
HX_STACK_ARG(__o_z,"z")
bool bubbles = __o_bubbles.Default(false);
bool cancelable = __o_cancelable.Default(false);
int device = __o_device.Default(0);
int id = __o_id.Default(0);
Float x = __o_x.Default(0);
Float y = __o_y.Default(0);
Float z = __o_z.Default(0);
{
	HX_STACK_LINE(27)
	super::__construct(type,bubbles,cancelable);
	HX_STACK_LINE(29)
	this->device = device;
	HX_STACK_LINE(30)
	this->id = id;
	HX_STACK_LINE(31)
	this->x = x;
	HX_STACK_LINE(32)
	this->y = y;
	HX_STACK_LINE(33)
	this->z = z;
	HX_STACK_LINE(35)
	this->axis = Array_obj< Float >::__new().Add(x).Add(y).Add(z).Add((int)0).Add((int)0).Add((int)0);
}
;
	return null();
}

//JoystickEvent_obj::~JoystickEvent_obj() { }

Dynamic JoystickEvent_obj::__CreateEmpty() { return  new JoystickEvent_obj; }
hx::ObjectPtr< JoystickEvent_obj > JoystickEvent_obj::__new(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,hx::Null< int >  __o_device,hx::Null< int >  __o_id,hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z)
{  hx::ObjectPtr< JoystickEvent_obj > result = new JoystickEvent_obj();
	result->__construct(type,__o_bubbles,__o_cancelable,__o_device,__o_id,__o_x,__o_y,__o_z);
	return result;}

Dynamic JoystickEvent_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< JoystickEvent_obj > result = new JoystickEvent_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4],inArgs[5],inArgs[6],inArgs[7]);
	return result;}

::flash::events::Event JoystickEvent_obj::clone( ){
	HX_STACK_FRAME("openfl.events.JoystickEvent","clone",0xb343a2d6,"openfl.events.JoystickEvent.clone","openfl/events/JoystickEvent.hx",40,0x4ab90817)
	HX_STACK_THIS(this)
	HX_STACK_LINE(42)
	::String _g = this->get_type();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(42)
	bool _g1 = this->get_bubbles();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(42)
	bool _g2 = this->get_cancelable();		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(42)
	return ::openfl::events::JoystickEvent_obj::__new(_g,_g1,_g2,this->device,this->id,this->x,this->y,this->z);
}


::String JoystickEvent_obj::toString( ){
	HX_STACK_FRAME("openfl.events.JoystickEvent","toString",0xaf0c72d3,"openfl.events.JoystickEvent.toString","openfl/events/JoystickEvent.hx",47,0x4ab90817)
	HX_STACK_THIS(this)
	HX_STACK_LINE(49)
	::String _g = this->get_type();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(49)
	::String _g1 = (HX_CSTRING("[JoystickEvent type=") + _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(49)
	::String _g2 = (_g1 + HX_CSTRING(" bubbles="));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(49)
	bool _g3 = this->get_bubbles();		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(49)
	::String _g4 = ::Std_obj::string(_g3);		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(49)
	::String _g5 = (_g2 + _g4);		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(49)
	::String _g6 = (_g5 + HX_CSTRING(" cancelable="));		HX_STACK_VAR(_g6,"_g6");
	HX_STACK_LINE(49)
	bool _g7 = this->get_cancelable();		HX_STACK_VAR(_g7,"_g7");
	HX_STACK_LINE(49)
	::String _g8 = ::Std_obj::string(_g7);		HX_STACK_VAR(_g8,"_g8");
	HX_STACK_LINE(49)
	::String _g9 = (_g6 + _g8);		HX_STACK_VAR(_g9,"_g9");
	HX_STACK_LINE(49)
	::String _g10 = (_g9 + HX_CSTRING(" device="));		HX_STACK_VAR(_g10,"_g10");
	HX_STACK_LINE(49)
	::String _g11 = (_g10 + this->device);		HX_STACK_VAR(_g11,"_g11");
	HX_STACK_LINE(49)
	::String _g12 = (_g11 + HX_CSTRING(" id="));		HX_STACK_VAR(_g12,"_g12");
	HX_STACK_LINE(49)
	::String _g13 = (_g12 + this->id);		HX_STACK_VAR(_g13,"_g13");
	HX_STACK_LINE(49)
	::String _g14 = (_g13 + HX_CSTRING(" x="));		HX_STACK_VAR(_g14,"_g14");
	HX_STACK_LINE(49)
	::String _g15 = (_g14 + this->x);		HX_STACK_VAR(_g15,"_g15");
	HX_STACK_LINE(49)
	::String _g16 = (_g15 + HX_CSTRING(" y="));		HX_STACK_VAR(_g16,"_g16");
	HX_STACK_LINE(49)
	::String _g17 = (_g16 + this->y);		HX_STACK_VAR(_g17,"_g17");
	HX_STACK_LINE(49)
	::String _g18 = (_g17 + HX_CSTRING(" z="));		HX_STACK_VAR(_g18,"_g18");
	HX_STACK_LINE(49)
	::String _g19 = (_g18 + this->z);		HX_STACK_VAR(_g19,"_g19");
	HX_STACK_LINE(49)
	return (_g19 + HX_CSTRING("]"));
}


::String JoystickEvent_obj::AXIS_MOVE;

::String JoystickEvent_obj::BALL_MOVE;

::String JoystickEvent_obj::BUTTON_DOWN;

::String JoystickEvent_obj::BUTTON_UP;

::String JoystickEvent_obj::HAT_MOVE;

::String JoystickEvent_obj::DEVICE_ADDED;

::String JoystickEvent_obj::DEVICE_REMOVED;


JoystickEvent_obj::JoystickEvent_obj()
{
}

void JoystickEvent_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(JoystickEvent);
	HX_MARK_MEMBER_NAME(axis,"axis");
	HX_MARK_MEMBER_NAME(device,"device");
	HX_MARK_MEMBER_NAME(id,"id");
	HX_MARK_MEMBER_NAME(x,"x");
	HX_MARK_MEMBER_NAME(y,"y");
	HX_MARK_MEMBER_NAME(z,"z");
	::flash::events::Event_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void JoystickEvent_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(axis,"axis");
	HX_VISIT_MEMBER_NAME(device,"device");
	HX_VISIT_MEMBER_NAME(id,"id");
	HX_VISIT_MEMBER_NAME(x,"x");
	HX_VISIT_MEMBER_NAME(y,"y");
	HX_VISIT_MEMBER_NAME(z,"z");
	::flash::events::Event_obj::__Visit(HX_VISIT_ARG);
}

Dynamic JoystickEvent_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { return x; }
		if (HX_FIELD_EQ(inName,"y") ) { return y; }
		if (HX_FIELD_EQ(inName,"z") ) { return z; }
		break;
	case 2:
		if (HX_FIELD_EQ(inName,"id") ) { return id; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"axis") ) { return axis; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"device") ) { return device; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic JoystickEvent_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { x=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"y") ) { y=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"z") ) { z=inValue.Cast< Float >(); return inValue; }
		break;
	case 2:
		if (HX_FIELD_EQ(inName,"id") ) { id=inValue.Cast< int >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"axis") ) { axis=inValue.Cast< Array< Float > >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"device") ) { device=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void JoystickEvent_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("axis"));
	outFields->push(HX_CSTRING("device"));
	outFields->push(HX_CSTRING("id"));
	outFields->push(HX_CSTRING("x"));
	outFields->push(HX_CSTRING("y"));
	outFields->push(HX_CSTRING("z"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("AXIS_MOVE"),
	HX_CSTRING("BALL_MOVE"),
	HX_CSTRING("BUTTON_DOWN"),
	HX_CSTRING("BUTTON_UP"),
	HX_CSTRING("HAT_MOVE"),
	HX_CSTRING("DEVICE_ADDED"),
	HX_CSTRING("DEVICE_REMOVED"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Array< Float >*/ ,(int)offsetof(JoystickEvent_obj,axis),HX_CSTRING("axis")},
	{hx::fsInt,(int)offsetof(JoystickEvent_obj,device),HX_CSTRING("device")},
	{hx::fsInt,(int)offsetof(JoystickEvent_obj,id),HX_CSTRING("id")},
	{hx::fsFloat,(int)offsetof(JoystickEvent_obj,x),HX_CSTRING("x")},
	{hx::fsFloat,(int)offsetof(JoystickEvent_obj,y),HX_CSTRING("y")},
	{hx::fsFloat,(int)offsetof(JoystickEvent_obj,z),HX_CSTRING("z")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("axis"),
	HX_CSTRING("device"),
	HX_CSTRING("id"),
	HX_CSTRING("x"),
	HX_CSTRING("y"),
	HX_CSTRING("z"),
	HX_CSTRING("clone"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(JoystickEvent_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(JoystickEvent_obj::AXIS_MOVE,"AXIS_MOVE");
	HX_MARK_MEMBER_NAME(JoystickEvent_obj::BALL_MOVE,"BALL_MOVE");
	HX_MARK_MEMBER_NAME(JoystickEvent_obj::BUTTON_DOWN,"BUTTON_DOWN");
	HX_MARK_MEMBER_NAME(JoystickEvent_obj::BUTTON_UP,"BUTTON_UP");
	HX_MARK_MEMBER_NAME(JoystickEvent_obj::HAT_MOVE,"HAT_MOVE");
	HX_MARK_MEMBER_NAME(JoystickEvent_obj::DEVICE_ADDED,"DEVICE_ADDED");
	HX_MARK_MEMBER_NAME(JoystickEvent_obj::DEVICE_REMOVED,"DEVICE_REMOVED");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(JoystickEvent_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(JoystickEvent_obj::AXIS_MOVE,"AXIS_MOVE");
	HX_VISIT_MEMBER_NAME(JoystickEvent_obj::BALL_MOVE,"BALL_MOVE");
	HX_VISIT_MEMBER_NAME(JoystickEvent_obj::BUTTON_DOWN,"BUTTON_DOWN");
	HX_VISIT_MEMBER_NAME(JoystickEvent_obj::BUTTON_UP,"BUTTON_UP");
	HX_VISIT_MEMBER_NAME(JoystickEvent_obj::HAT_MOVE,"HAT_MOVE");
	HX_VISIT_MEMBER_NAME(JoystickEvent_obj::DEVICE_ADDED,"DEVICE_ADDED");
	HX_VISIT_MEMBER_NAME(JoystickEvent_obj::DEVICE_REMOVED,"DEVICE_REMOVED");
};

#endif

Class JoystickEvent_obj::__mClass;

void JoystickEvent_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("openfl.events.JoystickEvent"), hx::TCanCast< JoystickEvent_obj> ,sStaticFields,sMemberFields,
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

void JoystickEvent_obj::__boot()
{
	AXIS_MOVE= HX_CSTRING("axisMove");
	BALL_MOVE= HX_CSTRING("ballMove");
	BUTTON_DOWN= HX_CSTRING("buttonDown");
	BUTTON_UP= HX_CSTRING("buttonUp");
	HAT_MOVE= HX_CSTRING("hatMove");
	DEVICE_ADDED= HX_CSTRING("deviceAdded");
	DEVICE_REMOVED= HX_CSTRING("deviceRemoved");
}

} // end namespace openfl
} // end namespace events
