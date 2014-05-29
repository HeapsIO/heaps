#include <hxcpp.h>

#ifndef INCLUDED_flash_Lib
#include <flash/Lib.h>
#endif
#ifndef INCLUDED_flash_display_DisplayObject
#include <flash/display/DisplayObject.h>
#endif
#ifndef INCLUDED_flash_display_DisplayObjectContainer
#include <flash/display/DisplayObjectContainer.h>
#endif
#ifndef INCLUDED_flash_display_IBitmapDrawable
#include <flash/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_flash_display_InteractiveObject
#include <flash/display/InteractiveObject.h>
#endif
#ifndef INCLUDED_flash_display_Stage
#include <flash/display/Stage.h>
#endif
#ifndef INCLUDED_flash_events_EventDispatcher
#include <flash/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_flash_events_IEventDispatcher
#include <flash/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_openfl_display_ManagedStage
#include <openfl/display/ManagedStage.h>
#endif
namespace openfl{
namespace display{

Void ManagedStage_obj::__construct(int width,int height,hx::Null< int >  __o_flags)
{
HX_STACK_FRAME("openfl.display.ManagedStage","new",0x45a3b4bb,"openfl.display.ManagedStage.new","openfl/display/ManagedStage.hx",42,0xd0b98453)
HX_STACK_THIS(this)
HX_STACK_ARG(width,"width")
HX_STACK_ARG(height,"height")
HX_STACK_ARG(__o_flags,"flags")
int flags = __o_flags.Default(0);
{
	HX_STACK_LINE(44)
	Dynamic _g = ::openfl::display::ManagedStage_obj::lime_managed_stage_create(width,height,flags);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(44)
	super::__construct(_g,width,height);
}
;
	return null();
}

//ManagedStage_obj::~ManagedStage_obj() { }

Dynamic ManagedStage_obj::__CreateEmpty() { return  new ManagedStage_obj; }
hx::ObjectPtr< ManagedStage_obj > ManagedStage_obj::__new(int width,int height,hx::Null< int >  __o_flags)
{  hx::ObjectPtr< ManagedStage_obj > result = new ManagedStage_obj();
	result->__construct(width,height,__o_flags);
	return result;}

Dynamic ManagedStage_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< ManagedStage_obj > result = new ManagedStage_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

HX_BEGIN_DEFAULT_FUNC(__default_beginRender,ManagedStage_obj)
Void run(){
{
		HX_STACK_FRAME("openfl.display.ManagedStage","beginRender",0x48f385ba,"openfl.display.ManagedStage.beginRender","openfl/display/ManagedStage.hx",49,0xd0b98453)
		HX_STACK_THIS(this)
	}
return null();
}
HX_END_LOCAL_FUNC0((void))
HX_END_DEFAULT_FUNC

HX_BEGIN_DEFAULT_FUNC(__default_endRender,ManagedStage_obj)
Void run(){
{
		HX_STACK_FRAME("openfl.display.ManagedStage","endRender",0xd57fd42c,"openfl.display.ManagedStage.endRender","openfl/display/ManagedStage.hx",56,0xd0b98453)
		HX_STACK_THIS(this)
	}
return null();
}
HX_END_LOCAL_FUNC0((void))
HX_END_DEFAULT_FUNC

Void ManagedStage_obj::pumpEvent( Dynamic event){
{
		HX_STACK_FRAME("openfl.display.ManagedStage","pumpEvent",0x83ae64ed,"openfl.display.ManagedStage.pumpEvent","openfl/display/ManagedStage.hx",65,0xd0b98453)
		HX_STACK_THIS(this)
		HX_STACK_ARG(event,"event")
		HX_STACK_LINE(65)
		::openfl::display::ManagedStage_obj::lime_managed_stage_pump_event(this->__handle,event);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(ManagedStage_obj,pumpEvent,(void))

Void ManagedStage_obj::resize( int width,int height){
{
		HX_STACK_FRAME("openfl.display.ManagedStage","resize",0xaf586079,"openfl.display.ManagedStage.resize","openfl/display/ManagedStage.hx",72,0xd0b98453)
		HX_STACK_THIS(this)
		HX_STACK_ARG(width,"width")
		HX_STACK_ARG(height,"height")
		struct _Function_1_1{
			inline static Dynamic Block( int &width,int &height){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","openfl/display/ManagedStage.hx",72,0xd0b98453)
				{
					hx::Anon __result = hx::Anon_obj::Create();
					__result->Add(HX_CSTRING("type") , (int)8,false);
					__result->Add(HX_CSTRING("x") , width,false);
					__result->Add(HX_CSTRING("y") , height,false);
					return __result;
				}
				return null();
			}
		};
		HX_STACK_LINE(72)
		this->pumpEvent(_Function_1_1::Block(width,height));
	}
return null();
}


Void ManagedStage_obj::sendQuit( ){
{
		HX_STACK_FRAME("openfl.display.ManagedStage","sendQuit",0xbbe7aefc,"openfl.display.ManagedStage.sendQuit","openfl/display/ManagedStage.hx",79,0xd0b98453)
		HX_STACK_THIS(this)
		struct _Function_1_1{
			inline static Dynamic Block( ){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","openfl/display/ManagedStage.hx",79,0xd0b98453)
				{
					hx::Anon __result = hx::Anon_obj::Create();
					__result->Add(HX_CSTRING("type") , (int)10,false);
					return __result;
				}
				return null();
			}
		};
		HX_STACK_LINE(79)
		this->pumpEvent(_Function_1_1::Block());
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(ManagedStage_obj,sendQuit,(void))

HX_BEGIN_DEFAULT_FUNC(__default_setNextWake,ManagedStage_obj)
Void run(Float delay){
{
		HX_STACK_FRAME("openfl.display.ManagedStage","setNextWake",0xd4c403d4,"openfl.display.ManagedStage.setNextWake","openfl/display/ManagedStage.hx",84,0xd0b98453)
		HX_STACK_THIS(this)
		HX_STACK_ARG(delay,"delay")
	}
return null();
}
HX_END_LOCAL_FUNC1((void))
HX_END_DEFAULT_FUNC

Float ManagedStage_obj::__doProcessStageEvent( Dynamic event){
	HX_STACK_FRAME("openfl.display.ManagedStage","__doProcessStageEvent",0xca8937bb,"openfl.display.ManagedStage.__doProcessStageEvent","openfl/display/ManagedStage.hx",91,0xd0b98453)
	HX_STACK_THIS(this)
	HX_STACK_ARG(event,"event")
	HX_STACK_LINE(93)
	this->__pollTimers();
	HX_STACK_LINE(95)
	Float wake = this->super::__doProcessStageEvent(event);		HX_STACK_VAR(wake,"wake");
	HX_STACK_LINE(96)
	this->setNextWake(wake);
	HX_STACK_LINE(98)
	return wake;
}


Void ManagedStage_obj::__render( bool sendEnterFrame){
{
		HX_STACK_FRAME("openfl.display.ManagedStage","__render",0x8a68483b,"openfl.display.ManagedStage.__render","openfl/display/ManagedStage.hx",103,0xd0b98453)
		HX_STACK_THIS(this)
		HX_STACK_ARG(sendEnterFrame,"sendEnterFrame")
		HX_STACK_LINE(105)
		this->beginRender();
		HX_STACK_LINE(106)
		this->super::__render(sendEnterFrame);
		HX_STACK_LINE(107)
		this->endRender();
	}
return null();
}


int ManagedStage_obj::etUnknown;

int ManagedStage_obj::etKeyDown;

int ManagedStage_obj::etChar;

int ManagedStage_obj::etKeyUp;

int ManagedStage_obj::etMouseMove;

int ManagedStage_obj::etMouseDown;

int ManagedStage_obj::etMouseClick;

int ManagedStage_obj::etMouseUp;

int ManagedStage_obj::etResize;

int ManagedStage_obj::etPoll;

int ManagedStage_obj::etQuit;

int ManagedStage_obj::etFocus;

int ManagedStage_obj::etShouldRotate;

int ManagedStage_obj::etDestroyHandler;

int ManagedStage_obj::etRedraw;

int ManagedStage_obj::etTouchBegin;

int ManagedStage_obj::etTouchMove;

int ManagedStage_obj::etTouchEnd;

int ManagedStage_obj::etTouchTap;

int ManagedStage_obj::etChange;

int ManagedStage_obj::efLeftDown;

int ManagedStage_obj::efShiftDown;

int ManagedStage_obj::efCtrlDown;

int ManagedStage_obj::efAltDown;

int ManagedStage_obj::efCommandDown;

int ManagedStage_obj::efMiddleDown;

int ManagedStage_obj::efRightDown;

int ManagedStage_obj::efLocationRight;

int ManagedStage_obj::efPrimaryTouch;

Dynamic ManagedStage_obj::lime_managed_stage_create;

Dynamic ManagedStage_obj::lime_managed_stage_pump_event;


ManagedStage_obj::ManagedStage_obj()
{
	beginRender = new __default_beginRender(this);
	endRender = new __default_endRender(this);
	setNextWake = new __default_setNextWake(this);
}

void ManagedStage_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(ManagedStage);
	HX_MARK_MEMBER_NAME(beginRender,"beginRender");
	HX_MARK_MEMBER_NAME(endRender,"endRender");
	HX_MARK_MEMBER_NAME(setNextWake,"setNextWake");
	::flash::display::Stage_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void ManagedStage_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(beginRender,"beginRender");
	HX_VISIT_MEMBER_NAME(endRender,"endRender");
	HX_VISIT_MEMBER_NAME(setNextWake,"setNextWake");
	::flash::display::Stage_obj::__Visit(HX_VISIT_ARG);
}

Dynamic ManagedStage_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"resize") ) { return resize_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"sendQuit") ) { return sendQuit_dyn(); }
		if (HX_FIELD_EQ(inName,"__render") ) { return __render_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"endRender") ) { return endRender; }
		if (HX_FIELD_EQ(inName,"pumpEvent") ) { return pumpEvent_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"beginRender") ) { return beginRender; }
		if (HX_FIELD_EQ(inName,"setNextWake") ) { return setNextWake; }
		break;
	case 21:
		if (HX_FIELD_EQ(inName,"__doProcessStageEvent") ) { return __doProcessStageEvent_dyn(); }
		break;
	case 25:
		if (HX_FIELD_EQ(inName,"lime_managed_stage_create") ) { return lime_managed_stage_create; }
		break;
	case 29:
		if (HX_FIELD_EQ(inName,"lime_managed_stage_pump_event") ) { return lime_managed_stage_pump_event; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic ManagedStage_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 9:
		if (HX_FIELD_EQ(inName,"endRender") ) { endRender=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"beginRender") ) { beginRender=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"setNextWake") ) { setNextWake=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 25:
		if (HX_FIELD_EQ(inName,"lime_managed_stage_create") ) { lime_managed_stage_create=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 29:
		if (HX_FIELD_EQ(inName,"lime_managed_stage_pump_event") ) { lime_managed_stage_pump_event=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void ManagedStage_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("etUnknown"),
	HX_CSTRING("etKeyDown"),
	HX_CSTRING("etChar"),
	HX_CSTRING("etKeyUp"),
	HX_CSTRING("etMouseMove"),
	HX_CSTRING("etMouseDown"),
	HX_CSTRING("etMouseClick"),
	HX_CSTRING("etMouseUp"),
	HX_CSTRING("etResize"),
	HX_CSTRING("etPoll"),
	HX_CSTRING("etQuit"),
	HX_CSTRING("etFocus"),
	HX_CSTRING("etShouldRotate"),
	HX_CSTRING("etDestroyHandler"),
	HX_CSTRING("etRedraw"),
	HX_CSTRING("etTouchBegin"),
	HX_CSTRING("etTouchMove"),
	HX_CSTRING("etTouchEnd"),
	HX_CSTRING("etTouchTap"),
	HX_CSTRING("etChange"),
	HX_CSTRING("efLeftDown"),
	HX_CSTRING("efShiftDown"),
	HX_CSTRING("efCtrlDown"),
	HX_CSTRING("efAltDown"),
	HX_CSTRING("efCommandDown"),
	HX_CSTRING("efMiddleDown"),
	HX_CSTRING("efRightDown"),
	HX_CSTRING("efLocationRight"),
	HX_CSTRING("efPrimaryTouch"),
	HX_CSTRING("lime_managed_stage_create"),
	HX_CSTRING("lime_managed_stage_pump_event"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(ManagedStage_obj,beginRender),HX_CSTRING("beginRender")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(ManagedStage_obj,endRender),HX_CSTRING("endRender")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(ManagedStage_obj,setNextWake),HX_CSTRING("setNextWake")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("beginRender"),
	HX_CSTRING("endRender"),
	HX_CSTRING("pumpEvent"),
	HX_CSTRING("resize"),
	HX_CSTRING("sendQuit"),
	HX_CSTRING("setNextWake"),
	HX_CSTRING("__doProcessStageEvent"),
	HX_CSTRING("__render"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(ManagedStage_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::etUnknown,"etUnknown");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::etKeyDown,"etKeyDown");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::etChar,"etChar");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::etKeyUp,"etKeyUp");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::etMouseMove,"etMouseMove");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::etMouseDown,"etMouseDown");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::etMouseClick,"etMouseClick");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::etMouseUp,"etMouseUp");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::etResize,"etResize");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::etPoll,"etPoll");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::etQuit,"etQuit");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::etFocus,"etFocus");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::etShouldRotate,"etShouldRotate");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::etDestroyHandler,"etDestroyHandler");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::etRedraw,"etRedraw");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::etTouchBegin,"etTouchBegin");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::etTouchMove,"etTouchMove");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::etTouchEnd,"etTouchEnd");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::etTouchTap,"etTouchTap");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::etChange,"etChange");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::efLeftDown,"efLeftDown");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::efShiftDown,"efShiftDown");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::efCtrlDown,"efCtrlDown");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::efAltDown,"efAltDown");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::efCommandDown,"efCommandDown");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::efMiddleDown,"efMiddleDown");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::efRightDown,"efRightDown");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::efLocationRight,"efLocationRight");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::efPrimaryTouch,"efPrimaryTouch");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::lime_managed_stage_create,"lime_managed_stage_create");
	HX_MARK_MEMBER_NAME(ManagedStage_obj::lime_managed_stage_pump_event,"lime_managed_stage_pump_event");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::etUnknown,"etUnknown");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::etKeyDown,"etKeyDown");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::etChar,"etChar");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::etKeyUp,"etKeyUp");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::etMouseMove,"etMouseMove");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::etMouseDown,"etMouseDown");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::etMouseClick,"etMouseClick");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::etMouseUp,"etMouseUp");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::etResize,"etResize");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::etPoll,"etPoll");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::etQuit,"etQuit");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::etFocus,"etFocus");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::etShouldRotate,"etShouldRotate");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::etDestroyHandler,"etDestroyHandler");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::etRedraw,"etRedraw");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::etTouchBegin,"etTouchBegin");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::etTouchMove,"etTouchMove");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::etTouchEnd,"etTouchEnd");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::etTouchTap,"etTouchTap");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::etChange,"etChange");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::efLeftDown,"efLeftDown");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::efShiftDown,"efShiftDown");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::efCtrlDown,"efCtrlDown");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::efAltDown,"efAltDown");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::efCommandDown,"efCommandDown");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::efMiddleDown,"efMiddleDown");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::efRightDown,"efRightDown");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::efLocationRight,"efLocationRight");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::efPrimaryTouch,"efPrimaryTouch");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::lime_managed_stage_create,"lime_managed_stage_create");
	HX_VISIT_MEMBER_NAME(ManagedStage_obj::lime_managed_stage_pump_event,"lime_managed_stage_pump_event");
};

#endif

Class ManagedStage_obj::__mClass;

void ManagedStage_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("openfl.display.ManagedStage"), hx::TCanCast< ManagedStage_obj> ,sStaticFields,sMemberFields,
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

void ManagedStage_obj::__boot()
{
	etUnknown= (int)0;
	etKeyDown= (int)1;
	etChar= (int)2;
	etKeyUp= (int)3;
	etMouseMove= (int)4;
	etMouseDown= (int)5;
	etMouseClick= (int)6;
	etMouseUp= (int)7;
	etResize= (int)8;
	etPoll= (int)9;
	etQuit= (int)10;
	etFocus= (int)11;
	etShouldRotate= (int)12;
	etDestroyHandler= (int)13;
	etRedraw= (int)14;
	etTouchBegin= (int)15;
	etTouchMove= (int)16;
	etTouchEnd= (int)17;
	etTouchTap= (int)18;
	etChange= (int)19;
	efLeftDown= (int)1;
	efShiftDown= (int)2;
	efCtrlDown= (int)4;
	efAltDown= (int)8;
	efCommandDown= (int)16;
	efMiddleDown= (int)32;
	efRightDown= (int)64;
	efLocationRight= (int)16384;
	efPrimaryTouch= (int)32768;
	lime_managed_stage_create= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_managed_stage_create"),(int)3);
	lime_managed_stage_pump_event= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_managed_stage_pump_event"),(int)2);
}

} // end namespace openfl
} // end namespace display
