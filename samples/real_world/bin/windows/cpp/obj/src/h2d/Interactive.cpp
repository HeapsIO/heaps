#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
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
#ifndef INCLUDED_h2d_Drawable
#include <h2d/Drawable.h>
#endif
#ifndef INCLUDED_h2d_DrawableShader
#include <h2d/DrawableShader.h>
#endif
#ifndef INCLUDED_h2d_Interactive
#include <h2d/Interactive.h>
#endif
#ifndef INCLUDED_h2d_Layers
#include <h2d/Layers.h>
#endif
#ifndef INCLUDED_h2d_Scene
#include <h2d/Scene.h>
#endif
#ifndef INCLUDED_h2d_Sprite
#include <h2d/Sprite.h>
#endif
#ifndef INCLUDED_h2d_Tile
#include <h2d/Tile.h>
#endif
#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
#endif
#ifndef INCLUDED_h3d_IDrawable
#include <h3d/IDrawable.h>
#endif
#ifndef INCLUDED_h3d_impl_Shader
#include <h3d/impl/Shader.h>
#endif
#ifndef INCLUDED_h3d_scene_RenderContext
#include <h3d/scene/RenderContext.h>
#endif
#ifndef INCLUDED_hxd_Cursor
#include <hxd/Cursor.h>
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
namespace h2d{

Void Interactive_obj::__construct(Float width,Float height,::h2d::Sprite parent)
{
HX_STACK_FRAME("h2d.Interactive","new",0x84cccda0,"h2d.Interactive.new","h2d/Interactive.hx",3,0x08606591)
HX_STACK_THIS(this)
HX_STACK_ARG(width,"width")
HX_STACK_ARG(height,"height")
HX_STACK_ARG(parent,"parent")
{
	HX_STACK_LINE(9)
	this->propagateEvents = false;
	HX_STACK_LINE(8)
	this->blockEvents = true;
	HX_STACK_LINE(16)
	super::__construct(parent,null());
	HX_STACK_LINE(17)
	this->set_width(width);
	HX_STACK_LINE(18)
	this->set_height(height);
	HX_STACK_LINE(19)
	this->set_cursor(::hxd::Cursor_obj::Button);
}
;
	return null();
}

//Interactive_obj::~Interactive_obj() { }

Dynamic Interactive_obj::__CreateEmpty() { return  new Interactive_obj; }
hx::ObjectPtr< Interactive_obj > Interactive_obj::__new(Float width,Float height,::h2d::Sprite parent)
{  hx::ObjectPtr< Interactive_obj > result = new Interactive_obj();
	result->__construct(width,height,parent);
	return result;}

Dynamic Interactive_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Interactive_obj > result = new Interactive_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

Float Interactive_obj::set_width( Float w){
	HX_STACK_FRAME("h2d.Interactive","set_width",0x3b8f6ba9,"h2d.Interactive.set_width","h2d/Interactive.hx",22,0x08606591)
	HX_STACK_THIS(this)
	HX_STACK_ARG(w,"w")
	HX_STACK_LINE(22)
	return this->width = w;
}


Float Interactive_obj::set_height( Float h){
	HX_STACK_FRAME("h2d.Interactive","set_height",0x983e40e4,"h2d.Interactive.set_height","h2d/Interactive.hx",23,0x08606591)
	HX_STACK_THIS(this)
	HX_STACK_ARG(h,"h")
	HX_STACK_LINE(23)
	return this->height = h;
}


Float Interactive_obj::get_width( ){
	HX_STACK_FRAME("h2d.Interactive","get_width",0x583e7f9d,"h2d.Interactive.get_width","h2d/Interactive.hx",24,0x08606591)
	HX_STACK_THIS(this)
	HX_STACK_LINE(24)
	return this->width;
}


Float Interactive_obj::get_height( ){
	HX_STACK_FRAME("h2d.Interactive","get_height",0x94c0a270,"h2d.Interactive.get_height","h2d/Interactive.hx",25,0x08606591)
	HX_STACK_THIS(this)
	HX_STACK_LINE(25)
	return this->height;
}


Void Interactive_obj::onAlloc( ){
{
		HX_STACK_FRAME("h2d.Interactive","onAlloc",0x12b1e016,"h2d.Interactive.onAlloc","h2d/Interactive.hx",27,0x08606591)
		HX_STACK_THIS(this)
		HX_STACK_LINE(28)
		::h2d::Scene _g = this->getScene();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(28)
		this->scene = _g;
		HX_STACK_LINE(29)
		if (((this->scene != null()))){
			HX_STACK_LINE(29)
			this->scene->addEventTarget(hx::ObjectPtr<OBJ_>(this));
		}
		HX_STACK_LINE(30)
		this->super::onAlloc();
	}
return null();
}


Void Interactive_obj::draw( ::h3d::scene::RenderContext ctx){
{
		HX_STACK_FRAME("h2d.Interactive","draw",0xa7d4c6c4,"h2d.Interactive.draw","h2d/Interactive.hx",34,0x08606591)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ctx,"ctx")
		HX_STACK_LINE(34)
		if (((this->backgroundColor != null()))){
			HX_STACK_LINE(34)
			Float _g = this->get_width();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(34)
			int _g1 = ::Std_obj::_int(_g);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(34)
			Float _g2 = this->get_height();		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(34)
			int _g3 = ::Std_obj::_int(_g2);		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(34)
			::h2d::Tile _g4 = ::h2d::Tile_obj::fromColor(this->backgroundColor,_g1,_g3,hx::SourceInfo(HX_CSTRING("Interactive.hx"),34,HX_CSTRING("h2d.Interactive"),HX_CSTRING("draw")));		HX_STACK_VAR(_g4,"_g4");
			HX_STACK_LINE(34)
			this->drawTile(ctx->engine,_g4);
		}
	}
return null();
}


Void Interactive_obj::onParentChanged( ){
{
		HX_STACK_FRAME("h2d.Interactive","onParentChanged",0x6305718b,"h2d.Interactive.onParentChanged","h2d/Interactive.hx",38,0x08606591)
		HX_STACK_THIS(this)
		HX_STACK_LINE(38)
		if (((this->scene != null()))){
			HX_STACK_LINE(39)
			this->scene->removeEventTarget(hx::ObjectPtr<OBJ_>(this));
			HX_STACK_LINE(40)
			this->scene->addEventTarget(hx::ObjectPtr<OBJ_>(this));
		}
	}
return null();
}


Void Interactive_obj::calcAbsPos( ){
{
		HX_STACK_FRAME("h2d.Interactive","calcAbsPos",0xd8ff4d77,"h2d.Interactive.calcAbsPos","h2d/Interactive.hx",44,0x08606591)
		HX_STACK_THIS(this)
		HX_STACK_LINE(45)
		this->super::calcAbsPos();
		HX_STACK_LINE(47)
		if (((bool((this->scene != null())) && bool((this->scene->currentOver == hx::ObjectPtr<OBJ_>(this)))))){
			HX_STACK_LINE(48)
			::hxd::Stage stage = ::hxd::Stage_obj::getInstance();		HX_STACK_VAR(stage,"stage");
			HX_STACK_LINE(49)
			Float _g = stage->stage->get_mouseX();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(49)
			Float _g1 = stage->stage->get_mouseY();		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(49)
			::hxd::Event e = ::hxd::Event_obj::__new(::hxd::EventKind_obj::EMove,_g,_g1);		HX_STACK_VAR(e,"e");
			HX_STACK_LINE(50)
			this->scene->onEvent(e);
		}
	}
return null();
}


Void Interactive_obj::onDelete( ){
{
		HX_STACK_FRAME("h2d.Interactive","onDelete",0x742eb16a,"h2d.Interactive.onDelete","h2d/Interactive.hx",54,0x08606591)
		HX_STACK_THIS(this)
		HX_STACK_LINE(55)
		if (((this->scene != null()))){
			HX_STACK_LINE(56)
			this->scene->removeEventTarget(hx::ObjectPtr<OBJ_>(this));
			HX_STACK_LINE(57)
			if (((this->scene->currentOver == hx::ObjectPtr<OBJ_>(this)))){
				HX_STACK_LINE(58)
				this->scene->currentOver = null();
				HX_STACK_LINE(59)
				::hxd::System_obj::setCursor(::hxd::Cursor_obj::Default);
			}
			HX_STACK_LINE(61)
			if (((this->scene->currentFocus == hx::ObjectPtr<OBJ_>(this)))){
				HX_STACK_LINE(62)
				this->scene->currentFocus = null();
			}
		}
		HX_STACK_LINE(64)
		this->super::onDelete();
	}
return null();
}


bool Interactive_obj::checkBounds( ::hxd::Event e){
	HX_STACK_FRAME("h2d.Interactive","checkBounds",0x55c7969d,"h2d.Interactive.checkBounds","h2d/Interactive.hx",68,0x08606591)
	HX_STACK_THIS(this)
	HX_STACK_ARG(e,"e")
	HX_STACK_LINE(68)
	::hxd::EventKind _g = e->kind;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(68)
	switch( (int)(_g->__Index())){
		case (int)4: case (int)1: case (int)6: case (int)7: {
			HX_STACK_LINE(69)
			return false;
		}
		;break;
		default: {
			HX_STACK_LINE(70)
			return true;
		}
	}
	HX_STACK_LINE(68)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC1(Interactive_obj,checkBounds,return )

Void Interactive_obj::handleEvent( ::hxd::Event e){
{
		HX_STACK_FRAME("h2d.Interactive","handleEvent",0x35a6b092,"h2d.Interactive.handleEvent","h2d/Interactive.hx",75,0x08606591)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
		HX_STACK_LINE(76)
		if (((  ((this->isEllipse)) ? bool(this->checkBounds(e)) : bool(false) ))){
			HX_STACK_LINE(77)
			Float _g = this->get_width();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(77)
			Float cx = (_g * 0.5);		HX_STACK_VAR(cx,"cx");
			HX_STACK_LINE(77)
			Float _g1 = this->get_height();		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(77)
			Float cy = (_g1 * 0.5);		HX_STACK_VAR(cy,"cy");
			HX_STACK_LINE(78)
			Float dx = (Float(((e->relX - cx))) / Float(cx));		HX_STACK_VAR(dx,"dx");
			HX_STACK_LINE(79)
			Float dy = (Float(((e->relY - cy))) / Float(cy));		HX_STACK_VAR(dy,"dy");
			HX_STACK_LINE(80)
			if (((((dx * dx) + (dy * dy)) > (int)1))){
				HX_STACK_LINE(81)
				e->cancel = true;
				HX_STACK_LINE(82)
				return null();
			}
		}
		HX_STACK_LINE(85)
		if ((this->propagateEvents)){
			HX_STACK_LINE(85)
			e->propagate = true;
		}
		HX_STACK_LINE(86)
		if ((!(this->blockEvents))){
			HX_STACK_LINE(86)
			e->cancel = true;
		}
		HX_STACK_LINE(87)
		{
			HX_STACK_LINE(87)
			::hxd::EventKind _g = e->kind;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(87)
			switch( (int)(_g->__Index())){
				case (int)2: {
					HX_STACK_LINE(89)
					this->onMove(e);
				}
				;break;
				case (int)0: {
					HX_STACK_LINE(91)
					if (((bool(this->enableRightButton) || bool((e->button == (int)0))))){
						HX_STACK_LINE(92)
						this->isMouseDown = e->button;
						HX_STACK_LINE(93)
						this->onPush(e);
					}
				}
				;break;
				case (int)1: {
					HX_STACK_LINE(96)
					if (((bool(this->enableRightButton) || bool((e->button == (int)0))))){
						HX_STACK_LINE(97)
						this->onRelease(e);
						HX_STACK_LINE(98)
						if (((this->isMouseDown == e->button))){
							HX_STACK_LINE(99)
							this->onClick(e);
						}
					}
					HX_STACK_LINE(101)
					this->isMouseDown = (int)-1;
				}
				;break;
				case (int)3: {
					HX_STACK_LINE(103)
					::hxd::System_obj::setCursor(this->cursor);
					HX_STACK_LINE(104)
					this->onOver(e);
				}
				;break;
				case (int)4: {
					HX_STACK_LINE(106)
					this->isMouseDown = (int)-1;
					HX_STACK_LINE(107)
					::hxd::System_obj::setCursor(::hxd::Cursor_obj::Default);
					HX_STACK_LINE(108)
					this->onOut(e);
				}
				;break;
				case (int)5: {
					HX_STACK_LINE(110)
					this->onWheel(e);
				}
				;break;
				case (int)7: {
					HX_STACK_LINE(112)
					this->onFocusLost(e);
					HX_STACK_LINE(113)
					if (((bool((bool(!(e->cancel)) && bool((this->scene != null())))) && bool((this->scene->currentFocus == hx::ObjectPtr<OBJ_>(this)))))){
						HX_STACK_LINE(113)
						this->scene->currentFocus = null();
					}
				}
				;break;
				case (int)6: {
					HX_STACK_LINE(115)
					this->onFocus(e);
					HX_STACK_LINE(116)
					if (((bool(!(e->cancel)) && bool((this->scene != null()))))){
						HX_STACK_LINE(116)
						this->scene->currentFocus = hx::ObjectPtr<OBJ_>(this);
					}
				}
				;break;
				case (int)9: {
					HX_STACK_LINE(118)
					this->onKeyUp(e);
				}
				;break;
				case (int)8: {
					HX_STACK_LINE(120)
					this->onKeyDown(e);
				}
				;break;
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Interactive_obj,handleEvent,(void))

::hxd::Cursor Interactive_obj::set_cursor( ::hxd::Cursor c){
	HX_STACK_FRAME("h2d.Interactive","set_cursor",0xd4dac7d3,"h2d.Interactive.set_cursor","h2d/Interactive.hx",124,0x08606591)
	HX_STACK_THIS(this)
	HX_STACK_ARG(c,"c")
	HX_STACK_LINE(125)
	this->cursor = c;
	HX_STACK_LINE(126)
	if (((bool((this->scene != null())) && bool((this->scene->currentOver == hx::ObjectPtr<OBJ_>(this)))))){
		HX_STACK_LINE(127)
		::hxd::System_obj::setCursor(this->cursor);
	}
	HX_STACK_LINE(128)
	return c;
}


HX_DEFINE_DYNAMIC_FUNC1(Interactive_obj,set_cursor,return )

Void Interactive_obj::eventToLocal( ::hxd::Event e){
{
		HX_STACK_FRAME("h2d.Interactive","eventToLocal",0xad6767b6,"h2d.Interactive.eventToLocal","h2d/Interactive.hx",131,0x08606591)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
		HX_STACK_LINE(133)
		Float x = e->relX;		HX_STACK_VAR(x,"x");
		HX_STACK_LINE(133)
		Float y = e->relY;		HX_STACK_VAR(y,"y");
		HX_STACK_LINE(134)
		Float rx = (((x * this->scene->matA) + (y * this->scene->matB)) + this->scene->absX);		HX_STACK_VAR(rx,"rx");
		HX_STACK_LINE(135)
		Float ry = (((x * this->scene->matC) + (y * this->scene->matD)) + this->scene->absY);		HX_STACK_VAR(ry,"ry");
		HX_STACK_LINE(136)
		Float _g = this->scene->get_height();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(136)
		Float _g1 = this->scene->get_width();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(136)
		Float r = (Float(_g) / Float(_g1));		HX_STACK_VAR(r,"r");
		HX_STACK_LINE(138)
		::h2d::Interactive i = hx::ObjectPtr<OBJ_>(this);		HX_STACK_VAR(i,"i");
		HX_STACK_LINE(140)
		Float dx = (rx - i->absX);		HX_STACK_VAR(dx,"dx");
		HX_STACK_LINE(141)
		Float dy = (ry - i->absY);		HX_STACK_VAR(dy,"dy");
		HX_STACK_LINE(143)
		Float _g2 = i->get_width();		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(143)
		Float _g3 = (_g2 * i->matA);		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(143)
		Float w1 = (_g3 * r);		HX_STACK_VAR(w1,"w1");
		HX_STACK_LINE(144)
		Float _g4 = i->get_width();		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(144)
		Float h1 = (_g4 * i->matC);		HX_STACK_VAR(h1,"h1");
		HX_STACK_LINE(145)
		Float ky = ((h1 * dx) - (w1 * dy));		HX_STACK_VAR(ky,"ky");
		HX_STACK_LINE(147)
		Float _g5 = i->get_height();		HX_STACK_VAR(_g5,"_g5");
		HX_STACK_LINE(147)
		Float _g6 = (_g5 * i->matB);		HX_STACK_VAR(_g6,"_g6");
		HX_STACK_LINE(147)
		Float w2 = (_g6 * r);		HX_STACK_VAR(w2,"w2");
		HX_STACK_LINE(148)
		Float _g7 = i->get_height();		HX_STACK_VAR(_g7,"_g7");
		HX_STACK_LINE(148)
		Float h2 = (_g7 * i->matD);		HX_STACK_VAR(h2,"h2");
		HX_STACK_LINE(149)
		Float kx = ((w2 * dy) - (h2 * dx));		HX_STACK_VAR(kx,"kx");
		HX_STACK_LINE(151)
		Float max = ((h1 * w2) - (w1 * h2));		HX_STACK_VAR(max,"max");
		HX_STACK_LINE(153)
		Float _g8 = i->get_width();		HX_STACK_VAR(_g8,"_g8");
		HX_STACK_LINE(153)
		Float _g9 = ((Float((kx * r)) / Float(max)) * _g8);		HX_STACK_VAR(_g9,"_g9");
		HX_STACK_LINE(153)
		e->relX = _g9;
		HX_STACK_LINE(154)
		Float _g10 = i->get_height();		HX_STACK_VAR(_g10,"_g10");
		HX_STACK_LINE(154)
		Float _g11 = ((Float(ky) / Float(max)) * _g10);		HX_STACK_VAR(_g11,"_g11");
		HX_STACK_LINE(154)
		e->relY = _g11;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Interactive_obj,eventToLocal,(void))

Void Interactive_obj::startDrag( Dynamic callb,Dynamic onCancel){
{
		HX_STACK_FRAME("h2d.Interactive","startDrag",0x459612b6,"h2d.Interactive.startDrag","h2d/Interactive.hx",157,0x08606591)
		HX_STACK_THIS(this)
		HX_STACK_ARG(callb,"callb")
		HX_STACK_ARG(onCancel,"onCancel")
		HX_STACK_LINE(157)
		Dynamic callb1 = Dynamic( Array_obj<Dynamic>::__new().Add(callb));		HX_STACK_VAR(callb1,"callb1");
		HX_STACK_LINE(157)
		Array< ::Dynamic > _g = Array_obj< ::Dynamic >::__new().Add(hx::ObjectPtr<OBJ_>(this));		HX_STACK_VAR(_g,"_g");

		HX_BEGIN_LOCAL_FUNC_S2(hx::LocalFunc,_Function_1_1,Array< ::Dynamic >,_g,Dynamic,callb1)
		Void run(::hxd::Event event){
			HX_STACK_FRAME("*","_Function_1_1",0x5200ed37,"*._Function_1_1","h2d/Interactive.hx",158,0x08606591)
			HX_STACK_ARG(event,"event")
			{
				HX_STACK_LINE(159)
				Float x = event->relX;		HX_STACK_VAR(x,"x");
				HX_STACK_LINE(159)
				Float y = event->relY;		HX_STACK_VAR(y,"y");
				HX_STACK_LINE(160)
				_g->__get((int)0).StaticCast< ::h2d::Interactive >()->eventToLocal(event);
				HX_STACK_LINE(161)
				callb1->__GetItem((int)0)(event);
				HX_STACK_LINE(162)
				event->relX = x;
				HX_STACK_LINE(163)
				event->relY = y;
			}
			return null();
		}
		HX_END_LOCAL_FUNC1((void))

		HX_STACK_LINE(158)
		this->scene->startDrag( Dynamic(new _Function_1_1(_g,callb1)),onCancel,null());
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Interactive_obj,startDrag,(void))

Void Interactive_obj::stopDrag( ){
{
		HX_STACK_FRAME("h2d.Interactive","stopDrag",0xbed36bd6,"h2d.Interactive.stopDrag","h2d/Interactive.hx",168,0x08606591)
		HX_STACK_THIS(this)
		HX_STACK_LINE(168)
		this->scene->stopDrag();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Interactive_obj,stopDrag,(void))

Void Interactive_obj::focus( ){
{
		HX_STACK_FRAME("h2d.Interactive","focus",0x572c2d18,"h2d.Interactive.focus","h2d/Interactive.hx",171,0x08606591)
		HX_STACK_THIS(this)
		HX_STACK_LINE(172)
		if (((this->scene == null()))){
			HX_STACK_LINE(173)
			return null();
		}
		HX_STACK_LINE(174)
		::hxd::Event ev = ::hxd::Event_obj::__new(null(),null(),null());		HX_STACK_VAR(ev,"ev");
		HX_STACK_LINE(175)
		if (((this->scene->currentFocus != null()))){
			HX_STACK_LINE(176)
			if (((this->scene->currentFocus == hx::ObjectPtr<OBJ_>(this)))){
				HX_STACK_LINE(177)
				return null();
			}
			HX_STACK_LINE(178)
			ev->kind = ::hxd::EventKind_obj::EFocusLost;
			HX_STACK_LINE(179)
			this->scene->currentFocus->handleEvent(ev);
			HX_STACK_LINE(180)
			if ((ev->cancel)){
				HX_STACK_LINE(180)
				return null();
			}
		}
		HX_STACK_LINE(182)
		ev->kind = ::hxd::EventKind_obj::EFocus;
		HX_STACK_LINE(183)
		this->handleEvent(ev);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Interactive_obj,focus,(void))

Void Interactive_obj::blur( ){
{
		HX_STACK_FRAME("h2d.Interactive","blur",0xa67ddd67,"h2d.Interactive.blur","h2d/Interactive.hx",186,0x08606591)
		HX_STACK_THIS(this)
		HX_STACK_LINE(187)
		if (((this->scene == null()))){
			HX_STACK_LINE(188)
			return null();
		}
		HX_STACK_LINE(189)
		if (((this->scene->currentFocus == hx::ObjectPtr<OBJ_>(this)))){
			HX_STACK_LINE(190)
			::hxd::Event ev = ::hxd::Event_obj::__new(null(),null(),null());		HX_STACK_VAR(ev,"ev");
			HX_STACK_LINE(191)
			ev->kind = ::hxd::EventKind_obj::EFocusLost;
			HX_STACK_LINE(192)
			this->scene->currentFocus->handleEvent(ev);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Interactive_obj,blur,(void))

bool Interactive_obj::hasFocus( ){
	HX_STACK_FRAME("h2d.Interactive","hasFocus",0xba8aa4de,"h2d.Interactive.hasFocus","h2d/Interactive.hx",197,0x08606591)
	HX_STACK_THIS(this)
	HX_STACK_LINE(197)
	return (bool((this->scene != null())) && bool((this->scene->currentFocus == hx::ObjectPtr<OBJ_>(this))));
}


HX_DEFINE_DYNAMIC_FUNC0(Interactive_obj,hasFocus,return )

HX_BEGIN_DEFAULT_FUNC(__default_onOver,Interactive_obj)
Void run(::hxd::Event e){
{
		HX_STACK_FRAME("h2d.Interactive","onOver",0xe81364d3,"h2d.Interactive.onOver","h2d/Interactive.hx",200,0x08606591)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
	}
return null();
}
HX_END_LOCAL_FUNC1((void))
HX_END_DEFAULT_FUNC

HX_BEGIN_DEFAULT_FUNC(__default_onOut,Interactive_obj)
Void run(::hxd::Event e){
{
		HX_STACK_FRAME("h2d.Interactive","onOut",0x850f01ef,"h2d.Interactive.onOut","h2d/Interactive.hx",203,0x08606591)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
	}
return null();
}
HX_END_LOCAL_FUNC1((void))
HX_END_DEFAULT_FUNC

HX_BEGIN_DEFAULT_FUNC(__default_onPush,Interactive_obj)
Void run(::hxd::Event e){
{
		HX_STACK_FRAME("h2d.Interactive","onPush",0xe8bbe559,"h2d.Interactive.onPush","h2d/Interactive.hx",206,0x08606591)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
	}
return null();
}
HX_END_LOCAL_FUNC1((void))
HX_END_DEFAULT_FUNC

HX_BEGIN_DEFAULT_FUNC(__default_onRelease,Interactive_obj)
Void run(::hxd::Event e){
{
		HX_STACK_FRAME("h2d.Interactive","onRelease",0x7acaaba8,"h2d.Interactive.onRelease","h2d/Interactive.hx",209,0x08606591)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
	}
return null();
}
HX_END_LOCAL_FUNC1((void))
HX_END_DEFAULT_FUNC

HX_BEGIN_DEFAULT_FUNC(__default_onClick,Interactive_obj)
Void run(::hxd::Event e){
{
		HX_STACK_FRAME("h2d.Interactive","onClick",0x397cb7e9,"h2d.Interactive.onClick","h2d/Interactive.hx",212,0x08606591)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
	}
return null();
}
HX_END_LOCAL_FUNC1((void))
HX_END_DEFAULT_FUNC

HX_BEGIN_DEFAULT_FUNC(__default_onMove,Interactive_obj)
Void run(::hxd::Event e){
{
		HX_STACK_FRAME("h2d.Interactive","onMove",0xe6bbb690,"h2d.Interactive.onMove","h2d/Interactive.hx",215,0x08606591)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
	}
return null();
}
HX_END_LOCAL_FUNC1((void))
HX_END_DEFAULT_FUNC

HX_BEGIN_DEFAULT_FUNC(__default_onWheel,Interactive_obj)
Void run(::hxd::Event e){
{
		HX_STACK_FRAME("h2d.Interactive","onWheel",0xbad8703c,"h2d.Interactive.onWheel","h2d/Interactive.hx",218,0x08606591)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
	}
return null();
}
HX_END_LOCAL_FUNC1((void))
HX_END_DEFAULT_FUNC

HX_BEGIN_DEFAULT_FUNC(__default_onFocus,Interactive_obj)
Void run(::hxd::Event e){
{
		HX_STACK_FRAME("h2d.Interactive","onFocus",0xf5a79b79,"h2d.Interactive.onFocus","h2d/Interactive.hx",221,0x08606591)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
	}
return null();
}
HX_END_LOCAL_FUNC1((void))
HX_END_DEFAULT_FUNC

HX_BEGIN_DEFAULT_FUNC(__default_onFocusLost,Interactive_obj)
Void run(::hxd::Event e){
{
		HX_STACK_FRAME("h2d.Interactive","onFocusLost",0x4f1e21fd,"h2d.Interactive.onFocusLost","h2d/Interactive.hx",224,0x08606591)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
	}
return null();
}
HX_END_LOCAL_FUNC1((void))
HX_END_DEFAULT_FUNC

HX_BEGIN_DEFAULT_FUNC(__default_onKeyUp,Interactive_obj)
Void run(::hxd::Event e){
{
		HX_STACK_FRAME("h2d.Interactive","onKeyUp",0xd01cf57b,"h2d.Interactive.onKeyUp","h2d/Interactive.hx",227,0x08606591)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
	}
return null();
}
HX_END_LOCAL_FUNC1((void))
HX_END_DEFAULT_FUNC

HX_BEGIN_DEFAULT_FUNC(__default_onKeyDown,Interactive_obj)
Void run(::hxd::Event e){
{
		HX_STACK_FRAME("h2d.Interactive","onKeyDown",0xbe248f82,"h2d.Interactive.onKeyDown","h2d/Interactive.hx",230,0x08606591)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
	}
return null();
}
HX_END_LOCAL_FUNC1((void))
HX_END_DEFAULT_FUNC


Interactive_obj::Interactive_obj()
{
	onOver = new __default_onOver(this);
	onOut = new __default_onOut(this);
	onPush = new __default_onPush(this);
	onRelease = new __default_onRelease(this);
	onClick = new __default_onClick(this);
	onMove = new __default_onMove(this);
	onWheel = new __default_onWheel(this);
	onFocus = new __default_onFocus(this);
	onFocusLost = new __default_onFocusLost(this);
	onKeyUp = new __default_onKeyUp(this);
	onKeyDown = new __default_onKeyDown(this);
}

void Interactive_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Interactive);
	HX_MARK_MEMBER_NAME(cursor,"cursor");
	HX_MARK_MEMBER_NAME(isEllipse,"isEllipse");
	HX_MARK_MEMBER_NAME(blockEvents,"blockEvents");
	HX_MARK_MEMBER_NAME(propagateEvents,"propagateEvents");
	HX_MARK_MEMBER_NAME(backgroundColor,"backgroundColor");
	HX_MARK_MEMBER_NAME(enableRightButton,"enableRightButton");
	HX_MARK_MEMBER_NAME(scene,"scene");
	HX_MARK_MEMBER_NAME(isMouseDown,"isMouseDown");
	HX_MARK_MEMBER_NAME(onOver,"onOver");
	HX_MARK_MEMBER_NAME(onOut,"onOut");
	HX_MARK_MEMBER_NAME(onPush,"onPush");
	HX_MARK_MEMBER_NAME(onRelease,"onRelease");
	HX_MARK_MEMBER_NAME(onClick,"onClick");
	HX_MARK_MEMBER_NAME(onMove,"onMove");
	HX_MARK_MEMBER_NAME(onWheel,"onWheel");
	HX_MARK_MEMBER_NAME(onFocus,"onFocus");
	HX_MARK_MEMBER_NAME(onFocusLost,"onFocusLost");
	HX_MARK_MEMBER_NAME(onKeyUp,"onKeyUp");
	HX_MARK_MEMBER_NAME(onKeyDown,"onKeyDown");
	::h2d::Drawable_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void Interactive_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(cursor,"cursor");
	HX_VISIT_MEMBER_NAME(isEllipse,"isEllipse");
	HX_VISIT_MEMBER_NAME(blockEvents,"blockEvents");
	HX_VISIT_MEMBER_NAME(propagateEvents,"propagateEvents");
	HX_VISIT_MEMBER_NAME(backgroundColor,"backgroundColor");
	HX_VISIT_MEMBER_NAME(enableRightButton,"enableRightButton");
	HX_VISIT_MEMBER_NAME(scene,"scene");
	HX_VISIT_MEMBER_NAME(isMouseDown,"isMouseDown");
	HX_VISIT_MEMBER_NAME(onOver,"onOver");
	HX_VISIT_MEMBER_NAME(onOut,"onOut");
	HX_VISIT_MEMBER_NAME(onPush,"onPush");
	HX_VISIT_MEMBER_NAME(onRelease,"onRelease");
	HX_VISIT_MEMBER_NAME(onClick,"onClick");
	HX_VISIT_MEMBER_NAME(onMove,"onMove");
	HX_VISIT_MEMBER_NAME(onWheel,"onWheel");
	HX_VISIT_MEMBER_NAME(onFocus,"onFocus");
	HX_VISIT_MEMBER_NAME(onFocusLost,"onFocusLost");
	HX_VISIT_MEMBER_NAME(onKeyUp,"onKeyUp");
	HX_VISIT_MEMBER_NAME(onKeyDown,"onKeyDown");
	::h2d::Drawable_obj::__Visit(HX_VISIT_ARG);
}

Dynamic Interactive_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"draw") ) { return draw_dyn(); }
		if (HX_FIELD_EQ(inName,"blur") ) { return blur_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"scene") ) { return scene; }
		if (HX_FIELD_EQ(inName,"focus") ) { return focus_dyn(); }
		if (HX_FIELD_EQ(inName,"onOut") ) { return onOut; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"cursor") ) { return cursor; }
		if (HX_FIELD_EQ(inName,"onOver") ) { return onOver; }
		if (HX_FIELD_EQ(inName,"onPush") ) { return onPush; }
		if (HX_FIELD_EQ(inName,"onMove") ) { return onMove; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"onAlloc") ) { return onAlloc_dyn(); }
		if (HX_FIELD_EQ(inName,"onClick") ) { return onClick; }
		if (HX_FIELD_EQ(inName,"onWheel") ) { return onWheel; }
		if (HX_FIELD_EQ(inName,"onFocus") ) { return onFocus; }
		if (HX_FIELD_EQ(inName,"onKeyUp") ) { return onKeyUp; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"onDelete") ) { return onDelete_dyn(); }
		if (HX_FIELD_EQ(inName,"stopDrag") ) { return stopDrag_dyn(); }
		if (HX_FIELD_EQ(inName,"hasFocus") ) { return hasFocus_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"isEllipse") ) { return isEllipse; }
		if (HX_FIELD_EQ(inName,"set_width") ) { return set_width_dyn(); }
		if (HX_FIELD_EQ(inName,"get_width") ) { return get_width_dyn(); }
		if (HX_FIELD_EQ(inName,"startDrag") ) { return startDrag_dyn(); }
		if (HX_FIELD_EQ(inName,"onRelease") ) { return onRelease; }
		if (HX_FIELD_EQ(inName,"onKeyDown") ) { return onKeyDown; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"set_height") ) { return set_height_dyn(); }
		if (HX_FIELD_EQ(inName,"get_height") ) { return get_height_dyn(); }
		if (HX_FIELD_EQ(inName,"calcAbsPos") ) { return calcAbsPos_dyn(); }
		if (HX_FIELD_EQ(inName,"set_cursor") ) { return set_cursor_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"blockEvents") ) { return blockEvents; }
		if (HX_FIELD_EQ(inName,"isMouseDown") ) { return isMouseDown; }
		if (HX_FIELD_EQ(inName,"checkBounds") ) { return checkBounds_dyn(); }
		if (HX_FIELD_EQ(inName,"handleEvent") ) { return handleEvent_dyn(); }
		if (HX_FIELD_EQ(inName,"onFocusLost") ) { return onFocusLost; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"eventToLocal") ) { return eventToLocal_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"propagateEvents") ) { return propagateEvents; }
		if (HX_FIELD_EQ(inName,"backgroundColor") ) { return backgroundColor; }
		if (HX_FIELD_EQ(inName,"onParentChanged") ) { return onParentChanged_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"enableRightButton") ) { return enableRightButton; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Interactive_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"scene") ) { scene=inValue.Cast< ::h2d::Scene >(); return inValue; }
		if (HX_FIELD_EQ(inName,"onOut") ) { onOut=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"cursor") ) { if (inCallProp) return set_cursor(inValue);cursor=inValue.Cast< ::hxd::Cursor >(); return inValue; }
		if (HX_FIELD_EQ(inName,"onOver") ) { onOver=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"onPush") ) { onPush=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"onMove") ) { onMove=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"onClick") ) { onClick=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"onWheel") ) { onWheel=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"onFocus") ) { onFocus=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"onKeyUp") ) { onKeyUp=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"isEllipse") ) { isEllipse=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"onRelease") ) { onRelease=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"onKeyDown") ) { onKeyDown=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"blockEvents") ) { blockEvents=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"isMouseDown") ) { isMouseDown=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"onFocusLost") ) { onFocusLost=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"propagateEvents") ) { propagateEvents=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"backgroundColor") ) { backgroundColor=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"enableRightButton") ) { enableRightButton=inValue.Cast< bool >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Interactive_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("cursor"));
	outFields->push(HX_CSTRING("isEllipse"));
	outFields->push(HX_CSTRING("blockEvents"));
	outFields->push(HX_CSTRING("propagateEvents"));
	outFields->push(HX_CSTRING("backgroundColor"));
	outFields->push(HX_CSTRING("enableRightButton"));
	outFields->push(HX_CSTRING("scene"));
	outFields->push(HX_CSTRING("isMouseDown"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::hxd::Cursor*/ ,(int)offsetof(Interactive_obj,cursor),HX_CSTRING("cursor")},
	{hx::fsBool,(int)offsetof(Interactive_obj,isEllipse),HX_CSTRING("isEllipse")},
	{hx::fsBool,(int)offsetof(Interactive_obj,blockEvents),HX_CSTRING("blockEvents")},
	{hx::fsBool,(int)offsetof(Interactive_obj,propagateEvents),HX_CSTRING("propagateEvents")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Interactive_obj,backgroundColor),HX_CSTRING("backgroundColor")},
	{hx::fsBool,(int)offsetof(Interactive_obj,enableRightButton),HX_CSTRING("enableRightButton")},
	{hx::fsObject /*::h2d::Scene*/ ,(int)offsetof(Interactive_obj,scene),HX_CSTRING("scene")},
	{hx::fsInt,(int)offsetof(Interactive_obj,isMouseDown),HX_CSTRING("isMouseDown")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Interactive_obj,onOver),HX_CSTRING("onOver")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Interactive_obj,onOut),HX_CSTRING("onOut")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Interactive_obj,onPush),HX_CSTRING("onPush")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Interactive_obj,onRelease),HX_CSTRING("onRelease")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Interactive_obj,onClick),HX_CSTRING("onClick")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Interactive_obj,onMove),HX_CSTRING("onMove")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Interactive_obj,onWheel),HX_CSTRING("onWheel")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Interactive_obj,onFocus),HX_CSTRING("onFocus")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Interactive_obj,onFocusLost),HX_CSTRING("onFocusLost")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Interactive_obj,onKeyUp),HX_CSTRING("onKeyUp")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Interactive_obj,onKeyDown),HX_CSTRING("onKeyDown")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("cursor"),
	HX_CSTRING("isEllipse"),
	HX_CSTRING("blockEvents"),
	HX_CSTRING("propagateEvents"),
	HX_CSTRING("backgroundColor"),
	HX_CSTRING("enableRightButton"),
	HX_CSTRING("scene"),
	HX_CSTRING("isMouseDown"),
	HX_CSTRING("set_width"),
	HX_CSTRING("set_height"),
	HX_CSTRING("get_width"),
	HX_CSTRING("get_height"),
	HX_CSTRING("onAlloc"),
	HX_CSTRING("draw"),
	HX_CSTRING("onParentChanged"),
	HX_CSTRING("calcAbsPos"),
	HX_CSTRING("onDelete"),
	HX_CSTRING("checkBounds"),
	HX_CSTRING("handleEvent"),
	HX_CSTRING("set_cursor"),
	HX_CSTRING("eventToLocal"),
	HX_CSTRING("startDrag"),
	HX_CSTRING("stopDrag"),
	HX_CSTRING("focus"),
	HX_CSTRING("blur"),
	HX_CSTRING("hasFocus"),
	HX_CSTRING("onOver"),
	HX_CSTRING("onOut"),
	HX_CSTRING("onPush"),
	HX_CSTRING("onRelease"),
	HX_CSTRING("onClick"),
	HX_CSTRING("onMove"),
	HX_CSTRING("onWheel"),
	HX_CSTRING("onFocus"),
	HX_CSTRING("onFocusLost"),
	HX_CSTRING("onKeyUp"),
	HX_CSTRING("onKeyDown"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Interactive_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Interactive_obj::__mClass,"__mClass");
};

#endif

Class Interactive_obj::__mClass;

void Interactive_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.Interactive"), hx::TCanCast< Interactive_obj> ,sStaticFields,sMemberFields,
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

void Interactive_obj::__boot()
{
}

} // end namespace h2d
