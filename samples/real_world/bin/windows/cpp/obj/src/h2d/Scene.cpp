#include <hxcpp.h>

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
#ifndef INCLUDED_h2d_Bitmap
#include <h2d/Bitmap.h>
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
#ifndef INCLUDED_h2d_Tools
#include <h2d/Tools.h>
#endif
#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
#endif
#ifndef INCLUDED_h3d_IDrawable
#include <h3d/IDrawable.h>
#endif
#ifndef INCLUDED_h3d_impl_MemoryManager
#include <h3d/impl/MemoryManager.h>
#endif
#ifndef INCLUDED_h3d_impl_Shader
#include <h3d/impl/Shader.h>
#endif
#ifndef INCLUDED_h3d_mat_Texture
#include <h3d/mat/Texture.h>
#endif
#ifndef INCLUDED_h3d_scene_RenderContext
#include <h3d/scene/RenderContext.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
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

Void Scene_obj::__construct()
{
HX_STACK_FRAME("h2d.Scene","new",0x3e0ec50a,"h2d.Scene.new","h2d/Scene.hx",23,0x53cb92a7)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(24)
	super::__construct(null());
	HX_STACK_LINE(25)
	::h3d::Engine e;		HX_STACK_VAR(e,"e");
	HX_STACK_LINE(25)
	{
		HX_STACK_LINE(25)
		if (((::hxd::System_obj::debugLevel >= (int)1))){
			HX_STACK_LINE(25)
			if (((::h3d::Engine_obj::CURRENT == null()))){
				HX_STACK_LINE(25)
				HX_STACK_DO_THROW(HX_CSTRING("no current context, please do this operation after engine init/creation"));
			}
		}
		HX_STACK_LINE(25)
		e = ::h3d::Engine_obj::CURRENT;
	}
	HX_STACK_LINE(26)
	::h3d::scene::RenderContext _g = ::h3d::scene::RenderContext_obj::__new();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(26)
	this->ctx = _g;
	HX_STACK_LINE(27)
	this->set_width(e->width);
	HX_STACK_LINE(28)
	this->set_height(e->height);
	HX_STACK_LINE(29)
	Array< ::Dynamic > _g1 = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(29)
	this->interactive = _g1;
	HX_STACK_LINE(30)
	Array< ::Dynamic > _g2 = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(30)
	this->pushList = _g2;
	HX_STACK_LINE(31)
	Dynamic _g3 = Dynamic( Array_obj<Dynamic>::__new() );		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(31)
	this->eventListeners = _g3;
	HX_STACK_LINE(32)
	{
		HX_STACK_LINE(32)
		this->posChanged = true;
		HX_STACK_LINE(32)
		if (((this->childs != null()))){
			HX_STACK_LINE(32)
			int _g4 = (int)0;		HX_STACK_VAR(_g4,"_g4");
			HX_STACK_LINE(32)
			Array< ::Dynamic > _g11 = this->childs;		HX_STACK_VAR(_g11,"_g11");
			HX_STACK_LINE(32)
			while((true)){
				HX_STACK_LINE(32)
				if ((!(((_g4 < _g11->length))))){
					HX_STACK_LINE(32)
					break;
				}
				HX_STACK_LINE(32)
				::h2d::Sprite c = _g11->__get(_g4).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
				HX_STACK_LINE(32)
				++(_g4);
				HX_STACK_LINE(32)
				c->set_posChanged(true);
			}
		}
		HX_STACK_LINE(32)
		this->posChanged;
	}
}
;
	return null();
}

//Scene_obj::~Scene_obj() { }

Dynamic Scene_obj::__CreateEmpty() { return  new Scene_obj; }
hx::ObjectPtr< Scene_obj > Scene_obj::__new()
{  hx::ObjectPtr< Scene_obj > result = new Scene_obj();
	result->__construct();
	return result;}

Dynamic Scene_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Scene_obj > result = new Scene_obj();
	result->__construct();
	return result;}

hx::Object *Scene_obj::__ToInterface(const hx::type_info &inType) {
	if (inType==typeid( ::h3d::IDrawable_obj)) return operator ::h3d::IDrawable_obj *();
	return super::__ToInterface(inType);
}

Void Scene_obj::setFixedSize( Float w,Float h){
{
		HX_STACK_FRAME("h2d.Scene","setFixedSize",0x38447669,"h2d.Scene.setFixedSize","h2d/Scene.hx",35,0x53cb92a7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(w,"w")
		HX_STACK_ARG(h,"h")
		HX_STACK_LINE(36)
		this->set_width(w);
		HX_STACK_LINE(37)
		this->set_height(h);
		HX_STACK_LINE(38)
		this->fixedSize = true;
		HX_STACK_LINE(39)
		{
			HX_STACK_LINE(39)
			this->posChanged = true;
			HX_STACK_LINE(39)
			if (((this->childs != null()))){
				HX_STACK_LINE(39)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(39)
				Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(39)
				while((true)){
					HX_STACK_LINE(39)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(39)
						break;
					}
					HX_STACK_LINE(39)
					::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(39)
					++(_g);
					HX_STACK_LINE(39)
					c->set_posChanged(true);
				}
			}
			HX_STACK_LINE(39)
			this->posChanged;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Scene_obj,setFixedSize,(void))

Void Scene_obj::onAlloc( ){
{
		HX_STACK_FRAME("h2d.Scene","onAlloc",0x0234d480,"h2d.Scene.onAlloc","h2d/Scene.hx",42,0x53cb92a7)
		HX_STACK_THIS(this)
		HX_STACK_LINE(43)
		::hxd::Stage_obj::getInstance()->addEventTarget(this->onEvent_dyn());
		HX_STACK_LINE(44)
		this->super::onAlloc();
	}
return null();
}


Void Scene_obj::onDelete( ){
{
		HX_STACK_FRAME("h2d.Scene","onDelete",0x174199c0,"h2d.Scene.onDelete","h2d/Scene.hx",47,0x53cb92a7)
		HX_STACK_THIS(this)
		HX_STACK_LINE(48)
		::hxd::Stage_obj::getInstance()->removeEventTarget(this->onEvent_dyn());
		HX_STACK_LINE(49)
		this->super::onDelete();
	}
return null();
}


Void Scene_obj::onEvent( ::hxd::Event e){
{
		HX_STACK_FRAME("h2d.Scene","onEvent",0x5665f825,"h2d.Scene.onEvent","h2d/Scene.hx",53,0x53cb92a7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(e,"e")
		HX_STACK_LINE(53)
		if (((this->pendingEvents != null()))){
			HX_STACK_LINE(54)
			Float _g = this->screenXToLocal(e->relX);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(54)
			e->relX = _g;
			HX_STACK_LINE(55)
			Float _g1 = this->screenYToLocal(e->relY);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(55)
			e->relY = _g1;
			HX_STACK_LINE(56)
			this->pendingEvents->push(e);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Scene_obj,onEvent,(void))

Float Scene_obj::screenXToLocal( Float mx){
	HX_STACK_FRAME("h2d.Scene","screenXToLocal",0x6fa6577a,"h2d.Scene.screenXToLocal","h2d/Scene.hx",60,0x53cb92a7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(mx,"mx")
	HX_STACK_LINE(61)
	Float _g = this->get_width();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(61)
	Float _g1 = (((mx - this->x)) * _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(61)
	Float _g2;		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(61)
	{
		HX_STACK_LINE(61)
		::hxd::Stage _this = ::hxd::Stage_obj::getInstance();		HX_STACK_VAR(_this,"_this");
		HX_STACK_LINE(61)
		_g2 = _this->stage->get_stageWidth();
	}
	HX_STACK_LINE(61)
	Float _g3 = (_g2 * this->scaleX);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(61)
	return (Float(_g1) / Float(_g3));
}


HX_DEFINE_DYNAMIC_FUNC1(Scene_obj,screenXToLocal,return )

Float Scene_obj::screenYToLocal( Float my){
	HX_STACK_FRAME("h2d.Scene","screenYToLocal",0xa8d8c999,"h2d.Scene.screenYToLocal","h2d/Scene.hx",64,0x53cb92a7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(my,"my")
	HX_STACK_LINE(65)
	Float _g = this->get_height();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(65)
	Float _g1 = (((my - this->y)) * _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(65)
	Float _g2;		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(65)
	{
		HX_STACK_LINE(65)
		::hxd::Stage _this = ::hxd::Stage_obj::getInstance();		HX_STACK_VAR(_this,"_this");
		HX_STACK_LINE(65)
		_g2 = _this->stage->get_stageHeight();
	}
	HX_STACK_LINE(65)
	Float _g3 = (_g2 * this->scaleY);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(65)
	return (Float(_g1) / Float(_g3));
}


HX_DEFINE_DYNAMIC_FUNC1(Scene_obj,screenYToLocal,return )

Float Scene_obj::get_mouseX( ){
	HX_STACK_FRAME("h2d.Scene","get_mouseX",0x1a610ef2,"h2d.Scene.get_mouseX","h2d/Scene.hx",68,0x53cb92a7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(69)
	Float _g;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(69)
	{
		HX_STACK_LINE(69)
		::hxd::Stage _this = ::hxd::Stage_obj::getInstance();		HX_STACK_VAR(_this,"_this");
		HX_STACK_LINE(69)
		_g = _this->stage->get_mouseX();
	}
	HX_STACK_LINE(69)
	return this->screenXToLocal(_g);
}


Float Scene_obj::get_mouseY( ){
	HX_STACK_FRAME("h2d.Scene","get_mouseY",0x1a610ef3,"h2d.Scene.get_mouseY","h2d/Scene.hx",72,0x53cb92a7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(73)
	Float _g;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(73)
	{
		HX_STACK_LINE(73)
		::hxd::Stage _this = ::hxd::Stage_obj::getInstance();		HX_STACK_VAR(_this,"_this");
		HX_STACK_LINE(73)
		_g = _this->stage->get_mouseY();
	}
	HX_STACK_LINE(73)
	return this->screenYToLocal(_g);
}


Float Scene_obj::set_width( Float w){
	HX_STACK_FRAME("h2d.Scene","set_width",0x4907ce93,"h2d.Scene.set_width","h2d/Scene.hx",76,0x53cb92a7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(w,"w")
	HX_STACK_LINE(76)
	return this->width = w;
}


Float Scene_obj::set_height( Float h){
	HX_STACK_FRAME("h2d.Scene","set_height",0x541c6aba,"h2d.Scene.set_height","h2d/Scene.hx",77,0x53cb92a7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(h,"h")
	HX_STACK_LINE(77)
	return this->height = h;
}


Float Scene_obj::get_width( ){
	HX_STACK_FRAME("h2d.Scene","get_width",0x65b6e287,"h2d.Scene.get_width","h2d/Scene.hx",78,0x53cb92a7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(78)
	return this->width;
}


Float Scene_obj::get_height( ){
	HX_STACK_FRAME("h2d.Scene","get_height",0x509ecc46,"h2d.Scene.get_height","h2d/Scene.hx",79,0x53cb92a7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(79)
	return this->height;
}


Void Scene_obj::dispatchListeners( ::hxd::Event event){
{
		HX_STACK_FRAME("h2d.Scene","dispatchListeners",0x87c4d98f,"h2d.Scene.dispatchListeners","h2d/Scene.hx",81,0x53cb92a7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(event,"event")
		HX_STACK_LINE(82)
		event->propagate = true;
		HX_STACK_LINE(83)
		event->cancel = false;
		HX_STACK_LINE(84)
		{
			HX_STACK_LINE(84)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(84)
			Dynamic _g1 = this->eventListeners;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(84)
			while((true)){
				HX_STACK_LINE(84)
				if ((!(((_g < _g1->__Field(HX_CSTRING("length"),true)))))){
					HX_STACK_LINE(84)
					break;
				}
				HX_STACK_LINE(84)
				Dynamic l = _g1->__GetItem(_g);		HX_STACK_VAR(l,"l");
				HX_STACK_LINE(84)
				++(_g);
				HX_STACK_LINE(85)
				l(event).Cast< Void >();
				HX_STACK_LINE(86)
				if ((!(event->propagate))){
					HX_STACK_LINE(86)
					break;
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Scene_obj,dispatchListeners,(void))

Void Scene_obj::emitEvent( ::hxd::Event event){
{
		HX_STACK_FRAME("h2d.Scene","emitEvent",0x64099cf1,"h2d.Scene.emitEvent","h2d/Scene.hx",90,0x53cb92a7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(event,"event")
		HX_STACK_LINE(91)
		Float x = event->relX;		HX_STACK_VAR(x,"x");
		HX_STACK_LINE(91)
		Float y = event->relY;		HX_STACK_VAR(y,"y");
		HX_STACK_LINE(92)
		Float rx = (((x * this->matA) + (y * this->matB)) + this->absX);		HX_STACK_VAR(rx,"rx");
		HX_STACK_LINE(93)
		Float ry = (((x * this->matC) + (y * this->matD)) + this->absY);		HX_STACK_VAR(ry,"ry");
		HX_STACK_LINE(94)
		Float _g = this->get_height();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(94)
		Float _g1 = this->get_width();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(94)
		Float r = (Float(_g) / Float(_g1));		HX_STACK_VAR(r,"r");
		HX_STACK_LINE(95)
		bool handled = false;		HX_STACK_VAR(handled,"handled");
		HX_STACK_LINE(96)
		bool checkOver = false;		HX_STACK_VAR(checkOver,"checkOver");
		HX_STACK_LINE(96)
		bool checkPush = false;		HX_STACK_VAR(checkPush,"checkPush");
		HX_STACK_LINE(96)
		bool cancelFocus = false;		HX_STACK_VAR(cancelFocus,"cancelFocus");
		HX_STACK_LINE(97)
		{
			HX_STACK_LINE(97)
			::hxd::EventKind _g2 = event->kind;		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(97)
			switch( (int)(_g2->__Index())){
				case (int)2: {
					HX_STACK_LINE(98)
					checkOver = true;
				}
				;break;
				case (int)0: {
					HX_STACK_LINE(99)
					cancelFocus = true;
					HX_STACK_LINE(99)
					checkPush = true;
				}
				;break;
				case (int)1: {
					HX_STACK_LINE(100)
					checkPush = true;
				}
				;break;
				case (int)9: case (int)8: case (int)5: {
					HX_STACK_LINE(102)
					if (((this->currentFocus != null()))){
						HX_STACK_LINE(103)
						this->currentFocus->handleEvent(event);
					}
					else{
						HX_STACK_LINE(105)
						if (((this->currentOver != null()))){
							HX_STACK_LINE(106)
							event->propagate = true;
							HX_STACK_LINE(107)
							this->currentOver->handleEvent(event);
							HX_STACK_LINE(108)
							if ((!(event->propagate))){
								HX_STACK_LINE(108)
								return null();
							}
						}
						HX_STACK_LINE(110)
						this->dispatchListeners(event);
					}
					HX_STACK_LINE(112)
					return null();
				}
				;break;
				default: {
				}
			}
		}
		HX_STACK_LINE(115)
		{
			HX_STACK_LINE(115)
			int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(115)
			Array< ::Dynamic > _g11 = this->interactive;		HX_STACK_VAR(_g11,"_g11");
			HX_STACK_LINE(115)
			while((true)){
				HX_STACK_LINE(115)
				if ((!(((_g2 < _g11->length))))){
					HX_STACK_LINE(115)
					break;
				}
				HX_STACK_LINE(115)
				::h2d::Interactive i = _g11->__get(_g2).StaticCast< ::h2d::Interactive >();		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(115)
				++(_g2);
				HX_STACK_LINE(122)
				Float dx = (rx - i->absX);		HX_STACK_VAR(dx,"dx");
				HX_STACK_LINE(123)
				Float dy = (ry - i->absY);		HX_STACK_VAR(dy,"dy");
				HX_STACK_LINE(125)
				Float _g21 = i->get_width();		HX_STACK_VAR(_g21,"_g21");
				HX_STACK_LINE(125)
				Float _g3 = (_g21 * i->matA);		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(125)
				Float w1 = (_g3 * r);		HX_STACK_VAR(w1,"w1");
				HX_STACK_LINE(126)
				Float _g4 = i->get_width();		HX_STACK_VAR(_g4,"_g4");
				HX_STACK_LINE(126)
				Float h1 = (_g4 * i->matC);		HX_STACK_VAR(h1,"h1");
				HX_STACK_LINE(127)
				Float ky = ((h1 * dx) - (w1 * dy));		HX_STACK_VAR(ky,"ky");
				HX_STACK_LINE(129)
				if (((ky < (int)0))){
					HX_STACK_LINE(130)
					continue;
				}
				HX_STACK_LINE(132)
				Float _g5 = i->get_height();		HX_STACK_VAR(_g5,"_g5");
				HX_STACK_LINE(132)
				Float _g6 = (_g5 * i->matB);		HX_STACK_VAR(_g6,"_g6");
				HX_STACK_LINE(132)
				Float w2 = (_g6 * r);		HX_STACK_VAR(w2,"w2");
				HX_STACK_LINE(133)
				Float _g7 = i->get_height();		HX_STACK_VAR(_g7,"_g7");
				HX_STACK_LINE(133)
				Float h2 = (_g7 * i->matD);		HX_STACK_VAR(h2,"h2");
				HX_STACK_LINE(134)
				Float kx = ((w2 * dy) - (h2 * dx));		HX_STACK_VAR(kx,"kx");
				HX_STACK_LINE(137)
				if (((kx < (int)0))){
					HX_STACK_LINE(138)
					continue;
				}
				HX_STACK_LINE(140)
				Float max = ((h1 * w2) - (w1 * h2));		HX_STACK_VAR(max,"max");
				HX_STACK_LINE(142)
				if (((bool((ky >= max)) || bool(((kx * r) >= max))))){
					HX_STACK_LINE(143)
					continue;
				}
				HX_STACK_LINE(146)
				bool visible = true;		HX_STACK_VAR(visible,"visible");
				HX_STACK_LINE(147)
				::h2d::Sprite p = i;		HX_STACK_VAR(p,"p");
				HX_STACK_LINE(148)
				while((true)){
					HX_STACK_LINE(148)
					if ((!(((p != null()))))){
						HX_STACK_LINE(148)
						break;
					}
					HX_STACK_LINE(149)
					if ((!(p->visible))){
						HX_STACK_LINE(150)
						visible = false;
						HX_STACK_LINE(151)
						break;
					}
					HX_STACK_LINE(153)
					p = p->parent;
				}
				HX_STACK_LINE(155)
				if ((!(visible))){
					HX_STACK_LINE(155)
					continue;
				}
				HX_STACK_LINE(157)
				Float _g8 = i->get_width();		HX_STACK_VAR(_g8,"_g8");
				HX_STACK_LINE(157)
				Float _g9 = ((Float((kx * r)) / Float(max)) * _g8);		HX_STACK_VAR(_g9,"_g9");
				HX_STACK_LINE(157)
				event->relX = _g9;
				HX_STACK_LINE(158)
				Float _g10 = i->get_height();		HX_STACK_VAR(_g10,"_g10");
				HX_STACK_LINE(158)
				Float _g111 = ((Float(ky) / Float(max)) * _g10);		HX_STACK_VAR(_g111,"_g111");
				HX_STACK_LINE(158)
				event->relY = _g111;
				HX_STACK_LINE(160)
				i->handleEvent(event);
				HX_STACK_LINE(162)
				if ((event->cancel)){
					HX_STACK_LINE(163)
					event->cancel = false;
				}
				else{
					HX_STACK_LINE(164)
					if ((checkOver)){
						HX_STACK_LINE(165)
						if (((this->currentOver != i))){
							HX_STACK_LINE(166)
							bool old = event->propagate;		HX_STACK_VAR(old,"old");
							HX_STACK_LINE(167)
							if (((this->currentOver != null()))){
								HX_STACK_LINE(168)
								event->kind = ::hxd::EventKind_obj::EOut;
								HX_STACK_LINE(170)
								this->currentOver->handleEvent(event);
							}
							HX_STACK_LINE(172)
							event->kind = ::hxd::EventKind_obj::EOver;
							HX_STACK_LINE(173)
							event->cancel = false;
							HX_STACK_LINE(174)
							i->handleEvent(event);
							HX_STACK_LINE(175)
							if ((event->cancel)){
								HX_STACK_LINE(176)
								this->currentOver = null();
							}
							else{
								HX_STACK_LINE(178)
								this->currentOver = i;
								HX_STACK_LINE(179)
								checkOver = false;
							}
							HX_STACK_LINE(181)
							event->kind = ::hxd::EventKind_obj::EMove;
							HX_STACK_LINE(182)
							event->cancel = false;
							HX_STACK_LINE(183)
							event->propagate = old;
						}
						else{
							HX_STACK_LINE(185)
							checkOver = false;
						}
					}
					else{
						HX_STACK_LINE(187)
						if ((checkPush)){
							HX_STACK_LINE(188)
							if (((event->kind == ::hxd::EventKind_obj::EPush))){
								HX_STACK_LINE(189)
								this->pushList->push(i);
							}
							else{
								HX_STACK_LINE(191)
								this->pushList->remove(i);
							}
						}
						HX_STACK_LINE(193)
						if (((bool(cancelFocus) && bool((i == this->currentFocus))))){
							HX_STACK_LINE(194)
							cancelFocus = false;
						}
					}
				}
				HX_STACK_LINE(197)
				if ((event->propagate)){
					HX_STACK_LINE(198)
					event->propagate = false;
					HX_STACK_LINE(199)
					continue;
				}
				HX_STACK_LINE(202)
				handled = true;
				HX_STACK_LINE(203)
				break;
			}
		}
		HX_STACK_LINE(205)
		if (((bool(cancelFocus) && bool((this->currentFocus != null()))))){
			HX_STACK_LINE(206)
			event->kind = ::hxd::EventKind_obj::EFocusLost;
			HX_STACK_LINE(207)
			this->currentFocus->handleEvent(event);
			HX_STACK_LINE(208)
			event->kind = ::hxd::EventKind_obj::EPush;
		}
		HX_STACK_LINE(210)
		if (((bool(checkOver) && bool((this->currentOver != null()))))){
			HX_STACK_LINE(211)
			event->kind = ::hxd::EventKind_obj::EOut;
			HX_STACK_LINE(212)
			this->currentOver->handleEvent(event);
			HX_STACK_LINE(213)
			event->kind = ::hxd::EventKind_obj::EMove;
			HX_STACK_LINE(214)
			this->currentOver = null();
		}
		HX_STACK_LINE(216)
		if ((!(handled))){
			HX_STACK_LINE(217)
			if (((event->kind == ::hxd::EventKind_obj::EPush))){
				HX_STACK_LINE(218)
				this->pushList->push(null());
			}
			HX_STACK_LINE(219)
			this->dispatchListeners(event);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Scene_obj,emitEvent,(void))

bool Scene_obj::hasEvents( ){
	HX_STACK_FRAME("h2d.Scene","hasEvents",0x2efdd23d,"h2d.Scene.hasEvents","h2d/Scene.hx",224,0x53cb92a7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(224)
	return (bool((this->interactive->length > (int)0)) || bool((this->eventListeners->__Field(HX_CSTRING("length"),true) > (int)0)));
}


HX_DEFINE_DYNAMIC_FUNC0(Scene_obj,hasEvents,return )

Void Scene_obj::checkEvents( ){
{
		HX_STACK_FRAME("h2d.Scene","checkEvents",0x2c9ad0ab,"h2d.Scene.checkEvents","h2d/Scene.hx",227,0x53cb92a7)
		HX_STACK_THIS(this)
		HX_STACK_LINE(228)
		if (((this->pendingEvents == null()))){
			HX_STACK_LINE(229)
			if ((!(this->hasEvents()))){
				HX_STACK_LINE(230)
				return null();
			}
			HX_STACK_LINE(231)
			Array< ::Dynamic > _g = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(231)
			this->pendingEvents = _g;
		}
		HX_STACK_LINE(233)
		Array< ::Dynamic > old = this->pendingEvents;		HX_STACK_VAR(old,"old");
		HX_STACK_LINE(234)
		if (((old->length == (int)0))){
			HX_STACK_LINE(235)
			return null();
		}
		HX_STACK_LINE(236)
		this->pendingEvents = null();
		HX_STACK_LINE(237)
		Float ox = 0.;		HX_STACK_VAR(ox,"ox");
		HX_STACK_LINE(237)
		Float oy = 0.;		HX_STACK_VAR(oy,"oy");
		HX_STACK_LINE(238)
		{
			HX_STACK_LINE(238)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(238)
			while((true)){
				HX_STACK_LINE(238)
				if ((!(((_g < old->length))))){
					HX_STACK_LINE(238)
					break;
				}
				HX_STACK_LINE(238)
				::hxd::Event e = old->__get(_g).StaticCast< ::hxd::Event >();		HX_STACK_VAR(e,"e");
				HX_STACK_LINE(238)
				++(_g);
				HX_STACK_LINE(239)
				bool hasPos;		HX_STACK_VAR(hasPos,"hasPos");
				HX_STACK_LINE(239)
				{
					HX_STACK_LINE(239)
					::hxd::EventKind _g1 = e->kind;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(239)
					switch( (int)(_g1->__Index())){
						case (int)9: case (int)8: {
							HX_STACK_LINE(240)
							hasPos = false;
						}
						;break;
						default: {
							HX_STACK_LINE(241)
							hasPos = true;
						}
					}
				}
				HX_STACK_LINE(244)
				if ((hasPos)){
					HX_STACK_LINE(245)
					ox = e->relX;
					HX_STACK_LINE(246)
					oy = e->relY;
				}
				HX_STACK_LINE(249)
				if (((bool((this->currentDrag != null())) && bool(((bool((this->currentDrag->__Field(HX_CSTRING("ref"),true) == null())) || bool((this->currentDrag->__Field(HX_CSTRING("ref"),true) == e->touchId)))))))){
					HX_STACK_LINE(250)
					this->currentDrag->__Field(HX_CSTRING("f"),true)(e);
					HX_STACK_LINE(251)
					if ((e->cancel)){
						HX_STACK_LINE(252)
						continue;
					}
				}
				HX_STACK_LINE(254)
				this->emitEvent(e);
				HX_STACK_LINE(255)
				if (((bool((e->kind == ::hxd::EventKind_obj::ERelease)) && bool((this->pushList->length > (int)0))))){
					HX_STACK_LINE(256)
					{
						HX_STACK_LINE(256)
						int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
						HX_STACK_LINE(256)
						Array< ::Dynamic > _g2 = this->pushList;		HX_STACK_VAR(_g2,"_g2");
						HX_STACK_LINE(256)
						while((true)){
							HX_STACK_LINE(256)
							if ((!(((_g1 < _g2->length))))){
								HX_STACK_LINE(256)
								break;
							}
							HX_STACK_LINE(256)
							::h2d::Interactive i = _g2->__get(_g1).StaticCast< ::h2d::Interactive >();		HX_STACK_VAR(i,"i");
							HX_STACK_LINE(256)
							++(_g1);
							HX_STACK_LINE(258)
							if (((i != null()))){
								HX_STACK_LINE(259)
								i->handleEvent(e);
							}
						}
					}
					HX_STACK_LINE(261)
					Array< ::Dynamic > _g1 = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(261)
					this->pushList = _g1;
				}
			}
		}
		HX_STACK_LINE(264)
		if ((this->hasEvents())){
			HX_STACK_LINE(265)
			Array< ::Dynamic > _g2 = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(265)
			this->pendingEvents = _g2;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Scene_obj,checkEvents,(void))

Void Scene_obj::addEventListener( Dynamic f){
{
		HX_STACK_FRAME("h2d.Scene","addEventListener",0xa1f9f4e3,"h2d.Scene.addEventListener","h2d/Scene.hx",269,0x53cb92a7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(f,"f")
		HX_STACK_LINE(269)
		this->eventListeners->__Field(HX_CSTRING("push"),true)(f);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Scene_obj,addEventListener,(void))

bool Scene_obj::removeEventListener( Dynamic f){
	HX_STACK_FRAME("h2d.Scene","removeEventListener",0x8141f074,"h2d.Scene.removeEventListener","h2d/Scene.hx",273,0x53cb92a7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(273)
	return this->eventListeners->__Field(HX_CSTRING("remove"),true)(f);
}


HX_DEFINE_DYNAMIC_FUNC1(Scene_obj,removeEventListener,return )

Void Scene_obj::startDrag( Dynamic f,Dynamic onCancel,::hxd::Event refEvent){
{
		HX_STACK_FRAME("h2d.Scene","startDrag",0x530e75a0,"h2d.Scene.startDrag","h2d/Scene.hx",276,0x53cb92a7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(f,"f")
		HX_STACK_ARG(onCancel,"onCancel")
		HX_STACK_ARG(refEvent,"refEvent")
		HX_STACK_LINE(277)
		if (((bool((this->currentDrag != null())) && bool((this->currentDrag->__Field(HX_CSTRING("onCancel"),true) != null()))))){
			HX_STACK_LINE(278)
			this->currentDrag->__Field(HX_CSTRING("onCancel"),true)();
		}
		struct _Function_1_1{
			inline static Dynamic Block( ::hxd::Event &refEvent,Dynamic &f,Dynamic &onCancel){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h2d/Scene.hx",279,0x53cb92a7)
				{
					hx::Anon __result = hx::Anon_obj::Create();
					__result->Add(HX_CSTRING("f") , f,false);
					__result->Add(HX_CSTRING("ref") , (  (((refEvent == null()))) ? Dynamic(null()) : Dynamic(refEvent->touchId) ),false);
					__result->Add(HX_CSTRING("onCancel") , onCancel,false);
					return __result;
				}
				return null();
			}
		};
		HX_STACK_LINE(279)
		this->currentDrag = _Function_1_1::Block(refEvent,f,onCancel);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Scene_obj,startDrag,(void))

Void Scene_obj::stopDrag( ){
{
		HX_STACK_FRAME("h2d.Scene","stopDrag",0x61e6542c,"h2d.Scene.stopDrag","h2d/Scene.hx",283,0x53cb92a7)
		HX_STACK_THIS(this)
		HX_STACK_LINE(283)
		this->currentDrag = null();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Scene_obj,stopDrag,(void))

::h2d::Interactive Scene_obj::getFocus( ){
	HX_STACK_FRAME("h2d.Scene","getFocus",0x311c5278,"h2d.Scene.getFocus","h2d/Scene.hx",287,0x53cb92a7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(287)
	return this->currentFocus;
}


HX_DEFINE_DYNAMIC_FUNC0(Scene_obj,getFocus,return )

Void Scene_obj::addEventTarget( ::h2d::Interactive i){
{
		HX_STACK_FRAME("h2d.Scene","addEventTarget",0x16319e00,"h2d.Scene.addEventTarget","h2d/Scene.hx",291,0x53cb92a7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(i,"i")
		HX_STACK_LINE(310)
		int level;		HX_STACK_VAR(level,"level");
		HX_STACK_LINE(310)
		{
			HX_STACK_LINE(310)
			::h2d::Sprite i1 = i;		HX_STACK_VAR(i1,"i1");
			HX_STACK_LINE(310)
			int lv = (int)0;		HX_STACK_VAR(lv,"lv");
			HX_STACK_LINE(310)
			while((true)){
				HX_STACK_LINE(310)
				if ((!(((i1 != null()))))){
					HX_STACK_LINE(310)
					break;
				}
				HX_STACK_LINE(310)
				i1 = i1->parent;
				HX_STACK_LINE(310)
				(lv)++;
			}
			HX_STACK_LINE(310)
			level = lv;
		}
		HX_STACK_LINE(311)
		{
			HX_STACK_LINE(311)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(311)
			int _g = this->interactive->length;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(311)
			while((true)){
				HX_STACK_LINE(311)
				if ((!(((_g1 < _g))))){
					HX_STACK_LINE(311)
					break;
				}
				HX_STACK_LINE(311)
				int index = (_g1)++;		HX_STACK_VAR(index,"index");
				HX_STACK_LINE(312)
				::h2d::Sprite i1 = i;		HX_STACK_VAR(i1,"i1");
				HX_STACK_LINE(313)
				::h2d::Sprite i2 = this->interactive->__get(index).StaticCast< ::h2d::Interactive >();		HX_STACK_VAR(i2,"i2");
				HX_STACK_LINE(314)
				int lv1 = level;		HX_STACK_VAR(lv1,"lv1");
				HX_STACK_LINE(315)
				int lv2;		HX_STACK_VAR(lv2,"lv2");
				HX_STACK_LINE(315)
				{
					HX_STACK_LINE(315)
					::h2d::Sprite i3 = i2;		HX_STACK_VAR(i3,"i3");
					HX_STACK_LINE(315)
					int lv = (int)0;		HX_STACK_VAR(lv,"lv");
					HX_STACK_LINE(315)
					while((true)){
						HX_STACK_LINE(315)
						if ((!(((i3 != null()))))){
							HX_STACK_LINE(315)
							break;
						}
						HX_STACK_LINE(315)
						i3 = i3->parent;
						HX_STACK_LINE(315)
						(lv)++;
					}
					HX_STACK_LINE(315)
					lv2 = lv;
				}
				HX_STACK_LINE(316)
				::h2d::Sprite p1 = i1;		HX_STACK_VAR(p1,"p1");
				HX_STACK_LINE(317)
				::h2d::Sprite p2 = i2;		HX_STACK_VAR(p2,"p2");
				HX_STACK_LINE(318)
				while((true)){
					HX_STACK_LINE(318)
					if ((!(((lv1 > lv2))))){
						HX_STACK_LINE(318)
						break;
					}
					HX_STACK_LINE(319)
					i1 = p1;
					HX_STACK_LINE(320)
					p1 = p1->parent;
					HX_STACK_LINE(321)
					(lv1)--;
				}
				HX_STACK_LINE(323)
				while((true)){
					HX_STACK_LINE(323)
					if ((!(((lv2 > lv1))))){
						HX_STACK_LINE(323)
						break;
					}
					HX_STACK_LINE(324)
					i2 = p2;
					HX_STACK_LINE(325)
					p2 = p2->parent;
					HX_STACK_LINE(326)
					(lv2)--;
				}
				HX_STACK_LINE(328)
				while((true)){
					HX_STACK_LINE(328)
					if ((!(((p1 != p2))))){
						HX_STACK_LINE(328)
						break;
					}
					HX_STACK_LINE(329)
					i1 = p1;
					HX_STACK_LINE(330)
					p1 = p1->parent;
					HX_STACK_LINE(331)
					i2 = p2;
					HX_STACK_LINE(332)
					p2 = p2->parent;
				}
				HX_STACK_LINE(334)
				int _g2;		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(334)
				{
					HX_STACK_LINE(334)
					int id = (int)-1;		HX_STACK_VAR(id,"id");
					HX_STACK_LINE(334)
					{
						HX_STACK_LINE(334)
						int _g11 = (int)0;		HX_STACK_VAR(_g11,"_g11");
						HX_STACK_LINE(334)
						int _g3 = p1->childs->length;		HX_STACK_VAR(_g3,"_g3");
						HX_STACK_LINE(334)
						while((true)){
							HX_STACK_LINE(334)
							if ((!(((_g11 < _g3))))){
								HX_STACK_LINE(334)
								break;
							}
							HX_STACK_LINE(334)
							int k = (_g11)++;		HX_STACK_VAR(k,"k");
							HX_STACK_LINE(334)
							if (((p1->childs->__get(k).StaticCast< ::h2d::Sprite >() == i1))){
								HX_STACK_LINE(334)
								id = k;
								HX_STACK_LINE(334)
								break;
							}
						}
					}
					HX_STACK_LINE(334)
					_g2 = id;
				}
				HX_STACK_LINE(334)
				int _g11;		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(334)
				{
					HX_STACK_LINE(334)
					int id = (int)-1;		HX_STACK_VAR(id,"id");
					HX_STACK_LINE(334)
					{
						HX_STACK_LINE(334)
						int _g12 = (int)0;		HX_STACK_VAR(_g12,"_g12");
						HX_STACK_LINE(334)
						int _g3 = p2->childs->length;		HX_STACK_VAR(_g3,"_g3");
						HX_STACK_LINE(334)
						while((true)){
							HX_STACK_LINE(334)
							if ((!(((_g12 < _g3))))){
								HX_STACK_LINE(334)
								break;
							}
							HX_STACK_LINE(334)
							int k = (_g12)++;		HX_STACK_VAR(k,"k");
							HX_STACK_LINE(334)
							if (((p2->childs->__get(k).StaticCast< ::h2d::Sprite >() == i2))){
								HX_STACK_LINE(334)
								id = k;
								HX_STACK_LINE(334)
								break;
							}
						}
					}
					HX_STACK_LINE(334)
					_g11 = id;
				}
				HX_STACK_LINE(334)
				if (((_g2 > _g11))){
					HX_STACK_LINE(335)
					this->interactive->insert(index,i);
					HX_STACK_LINE(336)
					return null();
				}
			}
		}
		HX_STACK_LINE(339)
		this->interactive->push(i);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Scene_obj,addEventTarget,(void))

Void Scene_obj::removeEventTarget( ::h2d::Interactive i){
{
		HX_STACK_FRAME("h2d.Scene","removeEventTarget",0x6720e351,"h2d.Scene.removeEventTarget","h2d/Scene.hx",344,0x53cb92a7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(i,"i")
		HX_STACK_LINE(344)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(344)
		int _g = this->interactive->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(344)
		while((true)){
			HX_STACK_LINE(344)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(344)
				break;
			}
			HX_STACK_LINE(344)
			int k = (_g1)++;		HX_STACK_VAR(k,"k");
			HX_STACK_LINE(345)
			if (((this->interactive->__get(k).StaticCast< ::h2d::Interactive >() == i))){
				HX_STACK_LINE(346)
				this->interactive->splice(k,(int)1);
				HX_STACK_LINE(347)
				break;
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Scene_obj,removeEventTarget,(void))

Void Scene_obj::calcAbsPos( ){
{
		HX_STACK_FRAME("h2d.Scene","calcAbsPos",0x94dd774d,"h2d.Scene.calcAbsPos","h2d/Scene.hx",351,0x53cb92a7)
		HX_STACK_THIS(this)
		HX_STACK_LINE(353)
		this->matA = this->scaleX;
		HX_STACK_LINE(354)
		this->matB = (int)0;
		HX_STACK_LINE(355)
		this->matC = (int)0;
		HX_STACK_LINE(356)
		this->matD = this->scaleY;
		HX_STACK_LINE(357)
		this->absX = this->x;
		HX_STACK_LINE(358)
		this->absY = this->y;
		HX_STACK_LINE(361)
		Float _g = this->get_width();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(361)
		Float w = (Float((int)2) / Float(_g));		HX_STACK_VAR(w,"w");
		HX_STACK_LINE(362)
		Float _g1 = this->get_height();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(362)
		Float h = (Float((int)-2) / Float(_g1));		HX_STACK_VAR(h,"h");
		HX_STACK_LINE(363)
		this->absX = ((this->absX * w) - (int)1);
		HX_STACK_LINE(364)
		this->absY = ((this->absY * h) + (int)1);
		HX_STACK_LINE(365)
		hx::MultEq(this->matA,w);
		HX_STACK_LINE(366)
		hx::MultEq(this->matB,h);
		HX_STACK_LINE(367)
		hx::MultEq(this->matC,w);
		HX_STACK_LINE(368)
		hx::MultEq(this->matD,h);
		HX_STACK_LINE(371)
		if (((this->rotation != (int)0))){
			HX_STACK_LINE(372)
			Float cr = ::Math_obj::cos(this->rotation);		HX_STACK_VAR(cr,"cr");
			HX_STACK_LINE(373)
			Float sr = ::Math_obj::sin(this->rotation);		HX_STACK_VAR(sr,"sr");
			HX_STACK_LINE(374)
			Float tmpA = ((this->matA * cr) + (this->matB * sr));		HX_STACK_VAR(tmpA,"tmpA");
			HX_STACK_LINE(375)
			Float tmpB = ((this->matA * -(sr)) + (this->matB * cr));		HX_STACK_VAR(tmpB,"tmpB");
			HX_STACK_LINE(376)
			Float tmpC = ((this->matC * cr) + (this->matD * sr));		HX_STACK_VAR(tmpC,"tmpC");
			HX_STACK_LINE(377)
			Float tmpD = ((this->matC * -(sr)) + (this->matD * cr));		HX_STACK_VAR(tmpD,"tmpD");
			HX_STACK_LINE(378)
			Float tmpX = ((this->absX * cr) + (this->absY * sr));		HX_STACK_VAR(tmpX,"tmpX");
			HX_STACK_LINE(379)
			Float tmpY = ((this->absX * -(sr)) + (this->absY * cr));		HX_STACK_VAR(tmpY,"tmpY");
			HX_STACK_LINE(380)
			this->matA = tmpA;
			HX_STACK_LINE(381)
			this->matB = tmpB;
			HX_STACK_LINE(382)
			this->matC = tmpC;
			HX_STACK_LINE(383)
			this->matD = tmpD;
			HX_STACK_LINE(384)
			this->absX = tmpX;
			HX_STACK_LINE(385)
			this->absY = tmpY;
		}
	}
return null();
}


Void Scene_obj::dispose( ){
{
		HX_STACK_FRAME("h2d.Scene","dispose",0x05b01249,"h2d.Scene.dispose","h2d/Scene.hx",390,0x53cb92a7)
		HX_STACK_THIS(this)
		HX_STACK_LINE(390)
		this->super::dispose();
	}
return null();
}


Void Scene_obj::setElapsedTime( Float v){
{
		HX_STACK_FRAME("h2d.Scene","setElapsedTime",0x14abf17d,"h2d.Scene.setElapsedTime","h2d/Scene.hx",394,0x53cb92a7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(394)
		this->ctx->elapsedTime = v;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Scene_obj,setElapsedTime,(void))

Void Scene_obj::render( ::h3d::Engine engine){
{
		HX_STACK_FRAME("h2d.Scene","render",0x501d3cec,"h2d.Scene.render","h2d/Scene.hx",397,0x53cb92a7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(engine,"engine")
		HX_STACK_LINE(398)
		this->ctx->engine = engine;
		HX_STACK_LINE(399)
		(this->ctx->frame)++;
		HX_STACK_LINE(400)
		hx::AddEq(this->ctx->time,this->ctx->elapsedTime);
		HX_STACK_LINE(401)
		this->ctx->currentPass = (int)0;
		HX_STACK_LINE(402)
		this->sync(this->ctx);
		HX_STACK_LINE(403)
		this->drawRec(this->ctx);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Scene_obj,render,(void))

Void Scene_obj::sync( ::h3d::scene::RenderContext ctx){
{
		HX_STACK_FRAME("h2d.Scene","sync",0x123ada71,"h2d.Scene.sync","h2d/Scene.hx",406,0x53cb92a7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ctx,"ctx")
		HX_STACK_LINE(407)
		if ((!(this->allocated))){
			HX_STACK_LINE(408)
			this->onAlloc();
		}
		struct _Function_1_1{
			inline static bool Block( hx::ObjectPtr< ::h2d::Scene_obj > __this,::h3d::scene::RenderContext &ctx){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h2d/Scene.hx",409,0x53cb92a7)
				{
					HX_STACK_LINE(409)
					Float _g = __this->get_width();		HX_STACK_VAR(_g,"_g");
					struct _Function_2_1{
						inline static bool Block( hx::ObjectPtr< ::h2d::Scene_obj > __this,::h3d::scene::RenderContext &ctx){
							HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h2d/Scene.hx",409,0x53cb92a7)
							{
								HX_STACK_LINE(409)
								Float _g1 = __this->get_height();		HX_STACK_VAR(_g1,"_g1");
								HX_STACK_LINE(409)
								return (_g1 != ctx->engine->height);
							}
							return null();
						}
					};
					HX_STACK_LINE(409)
					return (  ((!(((_g != ctx->engine->width))))) ? bool(_Function_2_1::Block(__this,ctx)) : bool(true) );
				}
				return null();
			}
		};
		HX_STACK_LINE(409)
		if (((  ((!(this->fixedSize))) ? bool(_Function_1_1::Block(this,ctx)) : bool(false) ))){
			HX_STACK_LINE(410)
			this->set_width(ctx->engine->width);
			HX_STACK_LINE(411)
			this->set_height(ctx->engine->height);
			HX_STACK_LINE(412)
			{
				HX_STACK_LINE(412)
				this->posChanged = true;
				HX_STACK_LINE(412)
				if (((this->childs != null()))){
					HX_STACK_LINE(412)
					int _g = (int)0;		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(412)
					Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(412)
					while((true)){
						HX_STACK_LINE(412)
						if ((!(((_g < _g1->length))))){
							HX_STACK_LINE(412)
							break;
						}
						HX_STACK_LINE(412)
						::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(412)
						++(_g);
						HX_STACK_LINE(412)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(412)
				this->posChanged;
			}
		}
		HX_STACK_LINE(414)
		::h2d::Tools_obj::checkCoreObjects();
		HX_STACK_LINE(415)
		this->super::sync(ctx);
	}
return null();
}


::h2d::Bitmap Scene_obj::captureBitmap( ::h2d::Tile target,Dynamic __o_bindDepth){
Dynamic bindDepth = __o_bindDepth.Default(false);
	HX_STACK_FRAME("h2d.Scene","captureBitmap",0xd091aa3f,"h2d.Scene.captureBitmap","h2d/Scene.hx",424,0x53cb92a7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(target,"target")
	HX_STACK_ARG(bindDepth,"bindDepth")
{
		HX_STACK_LINE(425)
		::h3d::Engine engine;		HX_STACK_VAR(engine,"engine");
		HX_STACK_LINE(425)
		{
			HX_STACK_LINE(425)
			if (((::hxd::System_obj::debugLevel >= (int)1))){
				HX_STACK_LINE(425)
				if (((::h3d::Engine_obj::CURRENT == null()))){
					HX_STACK_LINE(425)
					HX_STACK_DO_THROW(HX_CSTRING("no current context, please do this operation after engine init/creation"));
				}
			}
			HX_STACK_LINE(425)
			engine = ::h3d::Engine_obj::CURRENT;
		}
		HX_STACK_LINE(426)
		if (((target == null()))){
			HX_STACK_LINE(427)
			int tw = (int)1;		HX_STACK_VAR(tw,"tw");
			HX_STACK_LINE(427)
			int th = (int)1;		HX_STACK_VAR(th,"th");
			HX_STACK_LINE(428)
			while((true)){
				HX_STACK_LINE(428)
				Float _g = this->get_width();		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(428)
				if ((!(((tw < _g))))){
					HX_STACK_LINE(428)
					break;
				}
				HX_STACK_LINE(428)
				hx::ShlEq(tw,(int)1);
			}
			HX_STACK_LINE(429)
			while((true)){
				HX_STACK_LINE(429)
				Float _g1 = this->get_height();		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(429)
				if ((!(((th < _g1))))){
					HX_STACK_LINE(429)
					break;
				}
				HX_STACK_LINE(429)
				hx::ShlEq(th,(int)1);
			}
			HX_STACK_LINE(430)
			::h3d::mat::Texture tex = engine->mem->allocTargetTexture(tw,th,hx::SourceInfo(HX_CSTRING("Scene.hx"),430,HX_CSTRING("h2d.Scene"),HX_CSTRING("captureBitmap")));		HX_STACK_VAR(tex,"tex");
			HX_STACK_LINE(431)
			int _g2;		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(431)
			{
				HX_STACK_LINE(431)
				Float f = this->get_width();		HX_STACK_VAR(f,"f");
				HX_STACK_LINE(431)
				_g2 = ::Math_obj::round(f);
			}
			HX_STACK_LINE(431)
			int _g3;		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(431)
			{
				HX_STACK_LINE(431)
				Float f = this->get_height();		HX_STACK_VAR(f,"f");
				HX_STACK_LINE(431)
				_g3 = ::Math_obj::round(f);
			}
			HX_STACK_LINE(431)
			::h2d::Tile _g4 = ::h2d::Tile_obj::__new(tex,(int)0,(int)0,_g2,_g3,null(),null());		HX_STACK_VAR(_g4,"_g4");
			HX_STACK_LINE(431)
			target = _g4;
		}
		HX_STACK_LINE(433)
		bool oc = engine->triggerClear;		HX_STACK_VAR(oc,"oc");
		HX_STACK_LINE(434)
		engine->triggerClear = true;
		HX_STACK_LINE(435)
		engine->begin();
		HX_STACK_LINE(436)
		engine->setRenderZone(target->x,target->y,target->width,target->height);
		HX_STACK_LINE(437)
		::h3d::mat::Texture tex = target->getTexture();		HX_STACK_VAR(tex,"tex");
		HX_STACK_LINE(438)
		engine->setTarget(tex,bindDepth,null());
		HX_STACK_LINE(439)
		Float ow = this->get_width();		HX_STACK_VAR(ow,"ow");
		HX_STACK_LINE(439)
		Float oh = this->get_height();		HX_STACK_VAR(oh,"oh");
		HX_STACK_LINE(439)
		bool of = this->fixedSize;		HX_STACK_VAR(of,"of");
		HX_STACK_LINE(440)
		this->setFixedSize(tex->width,tex->height);
		HX_STACK_LINE(441)
		this->render(engine);
		HX_STACK_LINE(442)
		this->set_width(ow);
		HX_STACK_LINE(443)
		this->set_height(oh);
		HX_STACK_LINE(444)
		this->fixedSize = of;
		HX_STACK_LINE(445)
		{
			HX_STACK_LINE(445)
			this->posChanged = true;
			HX_STACK_LINE(445)
			if (((this->childs != null()))){
				HX_STACK_LINE(445)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(445)
				Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(445)
				while((true)){
					HX_STACK_LINE(445)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(445)
						break;
					}
					HX_STACK_LINE(445)
					::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(445)
					++(_g);
					HX_STACK_LINE(445)
					c->set_posChanged(true);
				}
			}
			HX_STACK_LINE(445)
			this->posChanged;
		}
		HX_STACK_LINE(446)
		engine->setTarget(null(),null(),null());
		HX_STACK_LINE(447)
		engine->setRenderZone(null(),null(),null(),null());
		HX_STACK_LINE(448)
		engine->end();
		HX_STACK_LINE(449)
		engine->triggerClear = oc;
		HX_STACK_LINE(451)
		target->flipY();
		HX_STACK_LINE(453)
		return ::h2d::Bitmap_obj::__new(target,null(),null());
	}
}


HX_DEFINE_DYNAMIC_FUNC2(Scene_obj,captureBitmap,return )


Scene_obj::Scene_obj()
{
}

void Scene_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Scene);
	HX_MARK_MEMBER_NAME(fixedSize,"fixedSize");
	HX_MARK_MEMBER_NAME(interactive,"interactive");
	HX_MARK_MEMBER_NAME(pendingEvents,"pendingEvents");
	HX_MARK_MEMBER_NAME(ctx,"ctx");
	HX_MARK_MEMBER_NAME(currentOver,"currentOver");
	HX_MARK_MEMBER_NAME(currentFocus,"currentFocus");
	HX_MARK_MEMBER_NAME(pushList,"pushList");
	HX_MARK_MEMBER_NAME(currentDrag,"currentDrag");
	HX_MARK_MEMBER_NAME(eventListeners,"eventListeners");
	::h2d::Layers_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void Scene_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(fixedSize,"fixedSize");
	HX_VISIT_MEMBER_NAME(interactive,"interactive");
	HX_VISIT_MEMBER_NAME(pendingEvents,"pendingEvents");
	HX_VISIT_MEMBER_NAME(ctx,"ctx");
	HX_VISIT_MEMBER_NAME(currentOver,"currentOver");
	HX_VISIT_MEMBER_NAME(currentFocus,"currentFocus");
	HX_VISIT_MEMBER_NAME(pushList,"pushList");
	HX_VISIT_MEMBER_NAME(currentDrag,"currentDrag");
	HX_VISIT_MEMBER_NAME(eventListeners,"eventListeners");
	::h2d::Layers_obj::__Visit(HX_VISIT_ARG);
}

Dynamic Scene_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"ctx") ) { return ctx; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"sync") ) { return sync_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"render") ) { return render_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"onAlloc") ) { return onAlloc_dyn(); }
		if (HX_FIELD_EQ(inName,"onEvent") ) { return onEvent_dyn(); }
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"pushList") ) { return pushList; }
		if (HX_FIELD_EQ(inName,"onDelete") ) { return onDelete_dyn(); }
		if (HX_FIELD_EQ(inName,"stopDrag") ) { return stopDrag_dyn(); }
		if (HX_FIELD_EQ(inName,"getFocus") ) { return getFocus_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"fixedSize") ) { return fixedSize; }
		if (HX_FIELD_EQ(inName,"set_width") ) { return set_width_dyn(); }
		if (HX_FIELD_EQ(inName,"get_width") ) { return get_width_dyn(); }
		if (HX_FIELD_EQ(inName,"emitEvent") ) { return emitEvent_dyn(); }
		if (HX_FIELD_EQ(inName,"hasEvents") ) { return hasEvents_dyn(); }
		if (HX_FIELD_EQ(inName,"startDrag") ) { return startDrag_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"get_mouseX") ) { return get_mouseX_dyn(); }
		if (HX_FIELD_EQ(inName,"get_mouseY") ) { return get_mouseY_dyn(); }
		if (HX_FIELD_EQ(inName,"set_height") ) { return set_height_dyn(); }
		if (HX_FIELD_EQ(inName,"get_height") ) { return get_height_dyn(); }
		if (HX_FIELD_EQ(inName,"calcAbsPos") ) { return calcAbsPos_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"interactive") ) { return interactive; }
		if (HX_FIELD_EQ(inName,"currentOver") ) { return currentOver; }
		if (HX_FIELD_EQ(inName,"currentDrag") ) { return currentDrag; }
		if (HX_FIELD_EQ(inName,"checkEvents") ) { return checkEvents_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"currentFocus") ) { return currentFocus; }
		if (HX_FIELD_EQ(inName,"setFixedSize") ) { return setFixedSize_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"pendingEvents") ) { return pendingEvents; }
		if (HX_FIELD_EQ(inName,"captureBitmap") ) { return captureBitmap_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"eventListeners") ) { return eventListeners; }
		if (HX_FIELD_EQ(inName,"screenXToLocal") ) { return screenXToLocal_dyn(); }
		if (HX_FIELD_EQ(inName,"screenYToLocal") ) { return screenYToLocal_dyn(); }
		if (HX_FIELD_EQ(inName,"addEventTarget") ) { return addEventTarget_dyn(); }
		if (HX_FIELD_EQ(inName,"setElapsedTime") ) { return setElapsedTime_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"addEventListener") ) { return addEventListener_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"dispatchListeners") ) { return dispatchListeners_dyn(); }
		if (HX_FIELD_EQ(inName,"removeEventTarget") ) { return removeEventTarget_dyn(); }
		break;
	case 19:
		if (HX_FIELD_EQ(inName,"removeEventListener") ) { return removeEventListener_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Scene_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"ctx") ) { ctx=inValue.Cast< ::h3d::scene::RenderContext >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"pushList") ) { pushList=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"fixedSize") ) { fixedSize=inValue.Cast< bool >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"interactive") ) { interactive=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"currentOver") ) { currentOver=inValue.Cast< ::h2d::Interactive >(); return inValue; }
		if (HX_FIELD_EQ(inName,"currentDrag") ) { currentDrag=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"currentFocus") ) { currentFocus=inValue.Cast< ::h2d::Interactive >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"pendingEvents") ) { pendingEvents=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"eventListeners") ) { eventListeners=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Scene_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("fixedSize"));
	outFields->push(HX_CSTRING("interactive"));
	outFields->push(HX_CSTRING("pendingEvents"));
	outFields->push(HX_CSTRING("ctx"));
	outFields->push(HX_CSTRING("currentOver"));
	outFields->push(HX_CSTRING("currentFocus"));
	outFields->push(HX_CSTRING("pushList"));
	outFields->push(HX_CSTRING("currentDrag"));
	outFields->push(HX_CSTRING("eventListeners"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsBool,(int)offsetof(Scene_obj,fixedSize),HX_CSTRING("fixedSize")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Scene_obj,interactive),HX_CSTRING("interactive")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Scene_obj,pendingEvents),HX_CSTRING("pendingEvents")},
	{hx::fsObject /*::h3d::scene::RenderContext*/ ,(int)offsetof(Scene_obj,ctx),HX_CSTRING("ctx")},
	{hx::fsObject /*::h2d::Interactive*/ ,(int)offsetof(Scene_obj,currentOver),HX_CSTRING("currentOver")},
	{hx::fsObject /*::h2d::Interactive*/ ,(int)offsetof(Scene_obj,currentFocus),HX_CSTRING("currentFocus")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Scene_obj,pushList),HX_CSTRING("pushList")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Scene_obj,currentDrag),HX_CSTRING("currentDrag")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Scene_obj,eventListeners),HX_CSTRING("eventListeners")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("fixedSize"),
	HX_CSTRING("interactive"),
	HX_CSTRING("pendingEvents"),
	HX_CSTRING("ctx"),
	HX_CSTRING("currentOver"),
	HX_CSTRING("currentFocus"),
	HX_CSTRING("pushList"),
	HX_CSTRING("currentDrag"),
	HX_CSTRING("eventListeners"),
	HX_CSTRING("setFixedSize"),
	HX_CSTRING("onAlloc"),
	HX_CSTRING("onDelete"),
	HX_CSTRING("onEvent"),
	HX_CSTRING("screenXToLocal"),
	HX_CSTRING("screenYToLocal"),
	HX_CSTRING("get_mouseX"),
	HX_CSTRING("get_mouseY"),
	HX_CSTRING("set_width"),
	HX_CSTRING("set_height"),
	HX_CSTRING("get_width"),
	HX_CSTRING("get_height"),
	HX_CSTRING("dispatchListeners"),
	HX_CSTRING("emitEvent"),
	HX_CSTRING("hasEvents"),
	HX_CSTRING("checkEvents"),
	HX_CSTRING("addEventListener"),
	HX_CSTRING("removeEventListener"),
	HX_CSTRING("startDrag"),
	HX_CSTRING("stopDrag"),
	HX_CSTRING("getFocus"),
	HX_CSTRING("addEventTarget"),
	HX_CSTRING("removeEventTarget"),
	HX_CSTRING("calcAbsPos"),
	HX_CSTRING("dispose"),
	HX_CSTRING("setElapsedTime"),
	HX_CSTRING("render"),
	HX_CSTRING("sync"),
	HX_CSTRING("captureBitmap"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Scene_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Scene_obj::__mClass,"__mClass");
};

#endif

Class Scene_obj::__mClass;

void Scene_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.Scene"), hx::TCanCast< Scene_obj> ,sStaticFields,sMemberFields,
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

void Scene_obj::__boot()
{
}

} // end namespace h2d
