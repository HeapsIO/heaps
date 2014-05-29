#include <hxcpp.h>

#ifndef INCLUDED_List
#include <List.h>
#endif
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
#ifndef INCLUDED_flash_display_MovieClip
#include <flash/display/MovieClip.h>
#endif
#ifndef INCLUDED_flash_display_Sprite
#include <flash/display/Sprite.h>
#endif
#ifndef INCLUDED_flash_display_Stage
#include <flash/display/Stage.h>
#endif
#ifndef INCLUDED_flash_display_StageScaleMode
#include <flash/display/StageScaleMode.h>
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
#ifndef INCLUDED_flash_events_KeyboardEvent
#include <flash/events/KeyboardEvent.h>
#endif
#ifndef INCLUDED_flash_events_MouseEvent
#include <flash/events/MouseEvent.h>
#endif
#ifndef INCLUDED_flash_events_TouchEvent
#include <flash/events/TouchEvent.h>
#endif
#ifndef INCLUDED_flash_ui_Multitouch
#include <flash/ui/Multitouch.h>
#endif
#ifndef INCLUDED_flash_ui_MultitouchInputMode
#include <flash/ui/MultitouchInputMode.h>
#endif
#ifndef INCLUDED_haxe_Log
#include <haxe/Log.h>
#endif
#ifndef INCLUDED_hxd_Event
#include <hxd/Event.h>
#endif
#ifndef INCLUDED_hxd_EventKind
#include <hxd/EventKind.h>
#endif
#ifndef INCLUDED_hxd_Stage
#include <hxd/Stage.h>
#endif
#ifndef INCLUDED_hxd_System
#include <hxd/System.h>
#endif
namespace hxd{

Void Stage_obj::__construct()
{
HX_STACK_FRAME("hxd.Stage","new",0x91eaf0f6,"hxd.Stage.new","hxd/Stage.hx",17,0xb24e483b)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(19)
	if (((::hxd::System_obj::debugLevel >= (int)2))){
		HX_STACK_LINE(19)
		::haxe::Log_obj::trace(HX_CSTRING("Stage:new()"),hx::SourceInfo(HX_CSTRING("Stage.hx"),19,HX_CSTRING("hxd.Stage"),HX_CSTRING("new")));
	}
	HX_STACK_LINE(21)
	::List _g = ::List_obj::__new();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(21)
	this->eventTargets = _g;
	HX_STACK_LINE(22)
	::List _g1 = ::List_obj::__new();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(22)
	this->resizeEvents = _g1;
	HX_STACK_LINE(25)
	::flash::display::Stage _g2 = ::flash::Lib_obj::get_current()->get_stage();		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(25)
	this->stage = _g2;
	HX_STACK_LINE(26)
	this->stage->set_scaleMode(::flash::display::StageScaleMode_obj::NO_SCALE);
	HX_STACK_LINE(27)
	this->stage->addEventListener(::flash::events::Event_obj::RESIZE,this->onResize_dyn(),null(),null(),null());
	HX_STACK_LINE(29)
	if ((::hxd::System_obj::get_isTouch())){
		HX_STACK_LINE(30)
		::flash::ui::Multitouch_obj::set_inputMode(::flash::ui::MultitouchInputMode_obj::TOUCH_POINT);
		HX_STACK_LINE(31)
		this->stage->addEventListener(::flash::events::TouchEvent_obj::TOUCH_BEGIN,this->onTouchDown_dyn(),null(),null(),null());
		HX_STACK_LINE(32)
		this->stage->addEventListener(::flash::events::TouchEvent_obj::TOUCH_MOVE,this->onTouchMove_dyn(),null(),null(),null());
		HX_STACK_LINE(33)
		this->stage->addEventListener(::flash::events::TouchEvent_obj::TOUCH_END,this->onTouchUp_dyn(),null(),null(),null());
	}
	else{
		HX_STACK_LINE(35)
		this->stage->addEventListener(::flash::events::MouseEvent_obj::MOUSE_DOWN,this->onMouseDown_dyn(),null(),null(),null());
		HX_STACK_LINE(36)
		this->stage->addEventListener(::flash::events::MouseEvent_obj::MOUSE_MOVE,this->onMouseMove_dyn(),null(),null(),null());
		HX_STACK_LINE(37)
		this->stage->addEventListener(::flash::events::MouseEvent_obj::MOUSE_UP,this->onMouseUp_dyn(),null(),null(),null());
		HX_STACK_LINE(38)
		this->stage->addEventListener(::flash::events::MouseEvent_obj::MOUSE_WHEEL,this->onMouseWheel_dyn(),null(),null(),null());
		HX_STACK_LINE(39)
		this->stage->addEventListener(::flash::events::KeyboardEvent_obj::KEY_DOWN,this->onKeyDown_dyn(),null(),null(),null());
		HX_STACK_LINE(40)
		this->stage->addEventListener(::flash::events::KeyboardEvent_obj::KEY_UP,this->onKeyUp_dyn(),null(),null(),null());
	}
}
;
	return null();
}

//Stage_obj::~Stage_obj() { }

Dynamic Stage_obj::__CreateEmpty() { return  new Stage_obj; }
hx::ObjectPtr< Stage_obj > Stage_obj::__new()
{  hx::ObjectPtr< Stage_obj > result = new Stage_obj();
	result->__construct();
	return result;}

Dynamic Stage_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Stage_obj > result = new Stage_obj();
	result->__construct();
	return result;}

Void Stage_obj::event( ::hxd::Event e){
{
		HX_STACK_FRAME("hxd.Stage","event",0xf3d5ba30,"hxd.Stage.event","hxd/Stage.hx",59,0xb24e483b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
		HX_STACK_LINE(59)
		for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(this->eventTargets->iterator());  __it->hasNext(); ){
			Dynamic et = __it->next();
			et(e).Cast< Void >();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Stage_obj,event,(void))

Void Stage_obj::addEventTarget( Dynamic et){
{
		HX_STACK_FRAME("hxd.Stage","addEventTarget",0x9bb86194,"hxd.Stage.addEventTarget","hxd/Stage.hx",64,0xb24e483b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(et,"et")
		HX_STACK_LINE(64)
		this->eventTargets->add(et);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Stage_obj,addEventTarget,(void))

Void Stage_obj::removeEventTarget( Dynamic et){
{
		HX_STACK_FRAME("hxd.Stage","removeEventTarget",0xdfc9943d,"hxd.Stage.removeEventTarget","hxd/Stage.hx",68,0xb24e483b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(et,"et")
		HX_STACK_LINE(68)
		this->eventTargets->remove(et);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Stage_obj,removeEventTarget,(void))

Void Stage_obj::addResizeEvent( Dynamic f){
{
		HX_STACK_FRAME("hxd.Stage","addResizeEvent",0x76466c0f,"hxd.Stage.addResizeEvent","hxd/Stage.hx",72,0xb24e483b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(f,"f")
		HX_STACK_LINE(72)
		this->resizeEvents->push(f);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Stage_obj,addResizeEvent,(void))

Void Stage_obj::removeResizeEvent( Dynamic f){
{
		HX_STACK_FRAME("hxd.Stage","removeResizeEvent",0xba579eb8,"hxd.Stage.removeResizeEvent","hxd/Stage.hx",76,0xb24e483b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(f,"f")
		HX_STACK_LINE(76)
		this->resizeEvents->remove(f);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Stage_obj,removeResizeEvent,(void))

Float Stage_obj::getFrameRate( ){
	HX_STACK_FRAME("hxd.Stage","getFrameRate",0x46a2cae1,"hxd.Stage.getFrameRate","hxd/Stage.hx",81,0xb24e483b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(81)
	return this->stage->frameRate;
}


HX_DEFINE_DYNAMIC_FUNC0(Stage_obj,getFrameRate,return )

Void Stage_obj::setFullScreen( bool v){
{
		HX_STACK_FRAME("hxd.Stage","setFullScreen",0x33d2e4b3,"hxd.Stage.setFullScreen","hxd/Stage.hx",87,0xb24e483b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(v,"v")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Stage_obj,setFullScreen,(void))

Float Stage_obj::get_mouseX( ){
	HX_STACK_FRAME("hxd.Stage","get_mouseX",0x6db17886,"hxd.Stage.get_mouseX","hxd/Stage.hx",114,0xb24e483b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(114)
	return this->stage->get_mouseX();
}


HX_DEFINE_DYNAMIC_FUNC0(Stage_obj,get_mouseX,return )

Float Stage_obj::get_mouseY( ){
	HX_STACK_FRAME("hxd.Stage","get_mouseY",0x6db17887,"hxd.Stage.get_mouseY","hxd/Stage.hx",118,0xb24e483b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(118)
	return this->stage->get_mouseY();
}


HX_DEFINE_DYNAMIC_FUNC0(Stage_obj,get_mouseY,return )

int Stage_obj::get_width( ){
	HX_STACK_FRAME("hxd.Stage","get_width",0x774ec773,"hxd.Stage.get_width","hxd/Stage.hx",122,0xb24e483b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(122)
	return this->stage->get_stageWidth();
}


HX_DEFINE_DYNAMIC_FUNC0(Stage_obj,get_width,return )

int Stage_obj::get_height( ){
	HX_STACK_FRAME("hxd.Stage","get_height",0xa3ef35da,"hxd.Stage.get_height","hxd/Stage.hx",126,0xb24e483b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(126)
	return this->stage->get_stageHeight();
}


HX_DEFINE_DYNAMIC_FUNC0(Stage_obj,get_height,return )

Void Stage_obj::onResize( Dynamic _){
{
		HX_STACK_FRAME("hxd.Stage","onResize",0x9845501d,"hxd.Stage.onResize","hxd/Stage.hx",130,0xb24e483b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(_,"_")
		HX_STACK_LINE(130)
		for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(this->resizeEvents->iterator());  __it->hasNext(); ){
			Dynamic e = __it->next();
			e().Cast< Void >();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Stage_obj,onResize,(void))

Void Stage_obj::onMouseDown( Dynamic e){
{
		HX_STACK_FRAME("hxd.Stage","onMouseDown",0x58303a9e,"hxd.Stage.onMouseDown","hxd/Stage.hx",134,0xb24e483b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
		HX_STACK_LINE(135)
		Float _g = this->stage->get_mouseX();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(135)
		Float _g1 = this->stage->get_mouseY();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(135)
		::hxd::Event _g2 = ::hxd::Event_obj::__new(::hxd::EventKind_obj::EPush,_g,_g1);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(135)
		this->event(_g2);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Stage_obj,onMouseDown,(void))

Void Stage_obj::onRMouseDown( Dynamic e){
{
		HX_STACK_FRAME("hxd.Stage","onRMouseDown",0x0829b0fe,"hxd.Stage.onRMouseDown","hxd/Stage.hx",138,0xb24e483b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
		HX_STACK_LINE(139)
		Float _g = this->stage->get_mouseX();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(139)
		Float _g1 = this->stage->get_mouseY();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(139)
		::hxd::Event e1 = ::hxd::Event_obj::__new(::hxd::EventKind_obj::EPush,_g,_g1);		HX_STACK_VAR(e1,"e1");
		HX_STACK_LINE(140)
		e1->button = (int)1;
		HX_STACK_LINE(141)
		this->event(e1);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Stage_obj,onRMouseDown,(void))

Void Stage_obj::onMouseUp( Dynamic e){
{
		HX_STACK_FRAME("hxd.Stage","onMouseUp",0x01606197,"hxd.Stage.onMouseUp","hxd/Stage.hx",144,0xb24e483b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
		HX_STACK_LINE(145)
		Float _g = this->stage->get_mouseX();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(145)
		Float _g1 = this->stage->get_mouseY();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(145)
		::hxd::Event _g2 = ::hxd::Event_obj::__new(::hxd::EventKind_obj::ERelease,_g,_g1);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(145)
		this->event(_g2);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Stage_obj,onMouseUp,(void))

Void Stage_obj::onRMouseUp( Dynamic e){
{
		HX_STACK_FRAME("hxd.Stage","onRMouseUp",0x950d7ff7,"hxd.Stage.onRMouseUp","hxd/Stage.hx",148,0xb24e483b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
		HX_STACK_LINE(149)
		Float _g = this->stage->get_mouseX();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(149)
		Float _g1 = this->stage->get_mouseY();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(149)
		::hxd::Event e1 = ::hxd::Event_obj::__new(::hxd::EventKind_obj::ERelease,_g,_g1);		HX_STACK_VAR(e1,"e1");
		HX_STACK_LINE(150)
		e1->button = (int)1;
		HX_STACK_LINE(151)
		this->event(e1);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Stage_obj,onRMouseUp,(void))

Void Stage_obj::onMouseMove( Dynamic e){
{
		HX_STACK_FRAME("hxd.Stage","onMouseMove",0x5e23254d,"hxd.Stage.onMouseMove","hxd/Stage.hx",154,0xb24e483b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
		HX_STACK_LINE(155)
		Float _g = this->stage->get_mouseX();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(155)
		Float _g1 = this->stage->get_mouseY();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(155)
		::hxd::Event _g2 = ::hxd::Event_obj::__new(::hxd::EventKind_obj::EMove,_g,_g1);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(155)
		this->event(_g2);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Stage_obj,onMouseMove,(void))

Void Stage_obj::onMouseWheel( ::flash::events::MouseEvent e){
{
		HX_STACK_FRAME("hxd.Stage","onMouseWheel",0xbdf1e6df,"hxd.Stage.onMouseWheel","hxd/Stage.hx",158,0xb24e483b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
		HX_STACK_LINE(159)
		Float _g = this->stage->get_mouseX();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(159)
		Float _g1 = this->stage->get_mouseY();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(159)
		::hxd::Event ev = ::hxd::Event_obj::__new(::hxd::EventKind_obj::EWheel,_g,_g1);		HX_STACK_VAR(ev,"ev");
		HX_STACK_LINE(160)
		ev->wheelDelta = (Float(-(e->delta)) / Float(3.0));
		HX_STACK_LINE(161)
		this->event(ev);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Stage_obj,onMouseWheel,(void))

Void Stage_obj::onKeyUp( ::flash::events::KeyboardEvent e){
{
		HX_STACK_FRAME("hxd.Stage","onKeyUp",0x4efe7bd1,"hxd.Stage.onKeyUp","hxd/Stage.hx",164,0xb24e483b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
		HX_STACK_LINE(165)
		::hxd::Event ev = ::hxd::Event_obj::__new(::hxd::EventKind_obj::EKeyUp,null(),null());		HX_STACK_VAR(ev,"ev");
		HX_STACK_LINE(166)
		ev->keyCode = e->keyCode;
		HX_STACK_LINE(167)
		int _g = this->getCharCode(e);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(167)
		ev->charCode = _g;
		HX_STACK_LINE(168)
		this->event(ev);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Stage_obj,onKeyUp,(void))

Void Stage_obj::onKeyDown( ::flash::events::KeyboardEvent e){
{
		HX_STACK_FRAME("hxd.Stage","onKeyDown",0xdd34d758,"hxd.Stage.onKeyDown","hxd/Stage.hx",171,0xb24e483b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
		HX_STACK_LINE(172)
		::hxd::Event ev = ::hxd::Event_obj::__new(::hxd::EventKind_obj::EKeyDown,null(),null());		HX_STACK_VAR(ev,"ev");
		HX_STACK_LINE(173)
		ev->keyCode = e->keyCode;
		HX_STACK_LINE(174)
		int _g = this->getCharCode(e);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(174)
		ev->charCode = _g;
		HX_STACK_LINE(175)
		this->event(ev);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Stage_obj,onKeyDown,(void))

int Stage_obj::getCharCode( ::flash::events::KeyboardEvent e){
	HX_STACK_FRAME("hxd.Stage","getCharCode",0x0942c86f,"hxd.Stage.getCharCode","hxd/Stage.hx",180,0xb24e483b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(e,"e")
	HX_STACK_LINE(180)
	return e->charCode;
}


HX_DEFINE_DYNAMIC_FUNC1(Stage_obj,getCharCode,return )

Void Stage_obj::onTouchDown( ::flash::events::TouchEvent e){
{
		HX_STACK_FRAME("hxd.Stage","onTouchDown",0x71481138,"hxd.Stage.onTouchDown","hxd/Stage.hx",217,0xb24e483b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
		HX_STACK_LINE(218)
		::hxd::Event ev = ::hxd::Event_obj::__new(::hxd::EventKind_obj::EPush,e->localX,e->localY);		HX_STACK_VAR(ev,"ev");
		HX_STACK_LINE(219)
		ev->touchId = e->touchPointID;
		HX_STACK_LINE(220)
		this->event(ev);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Stage_obj,onTouchDown,(void))

Void Stage_obj::onTouchUp( ::flash::events::TouchEvent e){
{
		HX_STACK_FRAME("hxd.Stage","onTouchUp",0x19e57db1,"hxd.Stage.onTouchUp","hxd/Stage.hx",223,0xb24e483b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
		HX_STACK_LINE(224)
		::hxd::Event ev = ::hxd::Event_obj::__new(::hxd::EventKind_obj::ERelease,e->localX,e->localY);		HX_STACK_VAR(ev,"ev");
		HX_STACK_LINE(225)
		ev->touchId = e->touchPointID;
		HX_STACK_LINE(226)
		this->event(ev);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Stage_obj,onTouchUp,(void))

Void Stage_obj::onTouchMove( ::flash::events::TouchEvent e){
{
		HX_STACK_FRAME("hxd.Stage","onTouchMove",0x773afbe7,"hxd.Stage.onTouchMove","hxd/Stage.hx",229,0xb24e483b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
		HX_STACK_LINE(230)
		::hxd::Event ev = ::hxd::Event_obj::__new(::hxd::EventKind_obj::EMove,e->localX,e->localY);		HX_STACK_VAR(ev,"ev");
		HX_STACK_LINE(231)
		ev->touchId = e->touchPointID;
		HX_STACK_LINE(232)
		this->event(ev);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Stage_obj,onTouchMove,(void))

::hxd::Stage Stage_obj::inst;

::hxd::Stage Stage_obj::getInstance( ){
	HX_STACK_FRAME("hxd.Stage","getInstance",0xc6ff88e1,"hxd.Stage.getInstance","hxd/Stage.hx",106,0xb24e483b)
	HX_STACK_LINE(107)
	if (((::hxd::Stage_obj::inst == null()))){
		HX_STACK_LINE(107)
		::hxd::Stage _g = ::hxd::Stage_obj::__new();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(107)
		::hxd::Stage_obj::inst = _g;
	}
	HX_STACK_LINE(108)
	return ::hxd::Stage_obj::inst;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Stage_obj,getInstance,return )

Void Stage_obj::openFLBoot( Dynamic callb){
{
		HX_STACK_FRAME("hxd.Stage","openFLBoot",0xb587be0c,"hxd.Stage.openFLBoot","hxd/Stage.hx",317,0xb24e483b)
		HX_STACK_ARG(callb,"callb")
		HX_STACK_LINE(319)
		::haxe::Log_obj::trace(HX_CSTRING("ofl boot !"),hx::SourceInfo(HX_CSTRING("Stage.hx"),319,HX_CSTRING("hxd.Stage"),HX_CSTRING("openFLBoot")));
		HX_STACK_LINE(321)
		::flash::display::Stage _g = ::flash::Lib_obj::get_current()->get_stage();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(321)
		if (((_g != null()))){
			HX_STACK_LINE(322)
			::haxe::Log_obj::trace(HX_CSTRING("stage created !"),hx::SourceInfo(HX_CSTRING("Stage.hx"),322,HX_CSTRING("hxd.Stage"),HX_CSTRING("openFLBoot")));
			HX_STACK_LINE(323)
			callb().Cast< Void >();
			HX_STACK_LINE(324)
			return null();
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Stage_obj,openFLBoot,(void))


Stage_obj::Stage_obj()
{
}

void Stage_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Stage);
	HX_MARK_MEMBER_NAME(stage,"stage");
	HX_MARK_MEMBER_NAME(fsDelayed,"fsDelayed");
	HX_MARK_MEMBER_NAME(resizeEvents,"resizeEvents");
	HX_MARK_MEMBER_NAME(eventTargets,"eventTargets");
	HX_MARK_MEMBER_NAME(width,"width");
	HX_MARK_MEMBER_NAME(height,"height");
	HX_MARK_MEMBER_NAME(mouseX,"mouseX");
	HX_MARK_MEMBER_NAME(mouseY,"mouseY");
	HX_MARK_END_CLASS();
}

void Stage_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(stage,"stage");
	HX_VISIT_MEMBER_NAME(fsDelayed,"fsDelayed");
	HX_VISIT_MEMBER_NAME(resizeEvents,"resizeEvents");
	HX_VISIT_MEMBER_NAME(eventTargets,"eventTargets");
	HX_VISIT_MEMBER_NAME(width,"width");
	HX_VISIT_MEMBER_NAME(height,"height");
	HX_VISIT_MEMBER_NAME(mouseX,"mouseX");
	HX_VISIT_MEMBER_NAME(mouseY,"mouseY");
}

Dynamic Stage_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"inst") ) { return inst; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"stage") ) { return stage; }
		if (HX_FIELD_EQ(inName,"width") ) { return inCallProp ? get_width() : width; }
		if (HX_FIELD_EQ(inName,"event") ) { return event_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"height") ) { return inCallProp ? get_height() : height; }
		if (HX_FIELD_EQ(inName,"mouseX") ) { return inCallProp ? get_mouseX() : mouseX; }
		if (HX_FIELD_EQ(inName,"mouseY") ) { return inCallProp ? get_mouseY() : mouseY; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"onKeyUp") ) { return onKeyUp_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"onResize") ) { return onResize_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"fsDelayed") ) { return fsDelayed; }
		if (HX_FIELD_EQ(inName,"get_width") ) { return get_width_dyn(); }
		if (HX_FIELD_EQ(inName,"onMouseUp") ) { return onMouseUp_dyn(); }
		if (HX_FIELD_EQ(inName,"onKeyDown") ) { return onKeyDown_dyn(); }
		if (HX_FIELD_EQ(inName,"onTouchUp") ) { return onTouchUp_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"openFLBoot") ) { return openFLBoot_dyn(); }
		if (HX_FIELD_EQ(inName,"get_mouseX") ) { return get_mouseX_dyn(); }
		if (HX_FIELD_EQ(inName,"get_mouseY") ) { return get_mouseY_dyn(); }
		if (HX_FIELD_EQ(inName,"get_height") ) { return get_height_dyn(); }
		if (HX_FIELD_EQ(inName,"onRMouseUp") ) { return onRMouseUp_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"getInstance") ) { return getInstance_dyn(); }
		if (HX_FIELD_EQ(inName,"onMouseDown") ) { return onMouseDown_dyn(); }
		if (HX_FIELD_EQ(inName,"onMouseMove") ) { return onMouseMove_dyn(); }
		if (HX_FIELD_EQ(inName,"getCharCode") ) { return getCharCode_dyn(); }
		if (HX_FIELD_EQ(inName,"onTouchDown") ) { return onTouchDown_dyn(); }
		if (HX_FIELD_EQ(inName,"onTouchMove") ) { return onTouchMove_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"resizeEvents") ) { return resizeEvents; }
		if (HX_FIELD_EQ(inName,"eventTargets") ) { return eventTargets; }
		if (HX_FIELD_EQ(inName,"getFrameRate") ) { return getFrameRate_dyn(); }
		if (HX_FIELD_EQ(inName,"onRMouseDown") ) { return onRMouseDown_dyn(); }
		if (HX_FIELD_EQ(inName,"onMouseWheel") ) { return onMouseWheel_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"setFullScreen") ) { return setFullScreen_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"addEventTarget") ) { return addEventTarget_dyn(); }
		if (HX_FIELD_EQ(inName,"addResizeEvent") ) { return addResizeEvent_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"removeEventTarget") ) { return removeEventTarget_dyn(); }
		if (HX_FIELD_EQ(inName,"removeResizeEvent") ) { return removeResizeEvent_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Stage_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"inst") ) { inst=inValue.Cast< ::hxd::Stage >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"stage") ) { stage=inValue.Cast< ::flash::display::Stage >(); return inValue; }
		if (HX_FIELD_EQ(inName,"width") ) { width=inValue.Cast< Float >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"height") ) { height=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"mouseX") ) { mouseX=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"mouseY") ) { mouseY=inValue.Cast< Float >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"fsDelayed") ) { fsDelayed=inValue.Cast< bool >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"resizeEvents") ) { resizeEvents=inValue.Cast< ::List >(); return inValue; }
		if (HX_FIELD_EQ(inName,"eventTargets") ) { eventTargets=inValue.Cast< ::List >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Stage_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("stage"));
	outFields->push(HX_CSTRING("fsDelayed"));
	outFields->push(HX_CSTRING("resizeEvents"));
	outFields->push(HX_CSTRING("eventTargets"));
	outFields->push(HX_CSTRING("width"));
	outFields->push(HX_CSTRING("height"));
	outFields->push(HX_CSTRING("mouseX"));
	outFields->push(HX_CSTRING("mouseY"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("inst"),
	HX_CSTRING("getInstance"),
	HX_CSTRING("openFLBoot"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::flash::display::Stage*/ ,(int)offsetof(Stage_obj,stage),HX_CSTRING("stage")},
	{hx::fsBool,(int)offsetof(Stage_obj,fsDelayed),HX_CSTRING("fsDelayed")},
	{hx::fsObject /*::List*/ ,(int)offsetof(Stage_obj,resizeEvents),HX_CSTRING("resizeEvents")},
	{hx::fsObject /*::List*/ ,(int)offsetof(Stage_obj,eventTargets),HX_CSTRING("eventTargets")},
	{hx::fsFloat,(int)offsetof(Stage_obj,width),HX_CSTRING("width")},
	{hx::fsFloat,(int)offsetof(Stage_obj,height),HX_CSTRING("height")},
	{hx::fsFloat,(int)offsetof(Stage_obj,mouseX),HX_CSTRING("mouseX")},
	{hx::fsFloat,(int)offsetof(Stage_obj,mouseY),HX_CSTRING("mouseY")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("stage"),
	HX_CSTRING("fsDelayed"),
	HX_CSTRING("resizeEvents"),
	HX_CSTRING("eventTargets"),
	HX_CSTRING("width"),
	HX_CSTRING("height"),
	HX_CSTRING("mouseX"),
	HX_CSTRING("mouseY"),
	HX_CSTRING("event"),
	HX_CSTRING("addEventTarget"),
	HX_CSTRING("removeEventTarget"),
	HX_CSTRING("addResizeEvent"),
	HX_CSTRING("removeResizeEvent"),
	HX_CSTRING("getFrameRate"),
	HX_CSTRING("setFullScreen"),
	HX_CSTRING("get_mouseX"),
	HX_CSTRING("get_mouseY"),
	HX_CSTRING("get_width"),
	HX_CSTRING("get_height"),
	HX_CSTRING("onResize"),
	HX_CSTRING("onMouseDown"),
	HX_CSTRING("onRMouseDown"),
	HX_CSTRING("onMouseUp"),
	HX_CSTRING("onRMouseUp"),
	HX_CSTRING("onMouseMove"),
	HX_CSTRING("onMouseWheel"),
	HX_CSTRING("onKeyUp"),
	HX_CSTRING("onKeyDown"),
	HX_CSTRING("getCharCode"),
	HX_CSTRING("onTouchDown"),
	HX_CSTRING("onTouchUp"),
	HX_CSTRING("onTouchMove"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Stage_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Stage_obj::inst,"inst");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Stage_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Stage_obj::inst,"inst");
};

#endif

Class Stage_obj::__mClass;

void Stage_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.Stage"), hx::TCanCast< Stage_obj> ,sStaticFields,sMemberFields,
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

void Stage_obj::__boot()
{
	inst= null();
}

} // end namespace hxd
