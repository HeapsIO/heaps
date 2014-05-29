#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
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
#ifndef INCLUDED_h2d_Layers
#include <h2d/Layers.h>
#endif
#ifndef INCLUDED_h2d_Matrix
#include <h2d/Matrix.h>
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
#ifndef INCLUDED_h2d__Tools_CoreObjects
#include <h2d/_Tools/CoreObjects.h>
#endif
#ifndef INCLUDED_h2d_col_Bounds
#include <h2d/col/Bounds.h>
#endif
#ifndef INCLUDED_h2d_col_Point
#include <h2d/col/Point.h>
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
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_hxd_Stage
#include <hxd/Stage.h>
#endif
#ifndef INCLUDED_hxd_System
#include <hxd/System.h>
#endif
#ifndef INCLUDED_hxd_impl_ArrayIterator
#include <hxd/impl/ArrayIterator.h>
#endif
namespace h2d{

Void Sprite_obj::__construct(::h2d::Sprite parent)
{
HX_STACK_FRAME("h2d.Sprite","new",0x5ce1e12b,"h2d.Sprite.new","h2d/Sprite.hx",14,0xc9e42484)
HX_STACK_THIS(this)
HX_STACK_ARG(parent,"parent")
{
	HX_STACK_LINE(28)
	this->skewY = 0.0;
	HX_STACK_LINE(27)
	this->skewX = 0.0;
	HX_STACK_LINE(25)
	this->scaleY = 1.0;
	HX_STACK_LINE(24)
	this->scaleX = 1.0;
	HX_STACK_LINE(75)
	this->matA = (int)1;
	HX_STACK_LINE(75)
	this->matB = (int)0;
	HX_STACK_LINE(75)
	this->matC = (int)0;
	HX_STACK_LINE(75)
	this->matD = (int)1;
	HX_STACK_LINE(75)
	this->absX = (int)0;
	HX_STACK_LINE(75)
	this->absY = (int)0;
	HX_STACK_LINE(76)
	{
		HX_STACK_LINE(76)
		this->x = (int)0;
		HX_STACK_LINE(76)
		{
			HX_STACK_LINE(76)
			this->posChanged = true;
			HX_STACK_LINE(76)
			if (((this->childs != null()))){
				HX_STACK_LINE(76)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(76)
				Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(76)
				while((true)){
					HX_STACK_LINE(76)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(76)
						break;
					}
					HX_STACK_LINE(76)
					::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(76)
					++(_g);
					HX_STACK_LINE(76)
					c->set_posChanged(true);
				}
			}
			HX_STACK_LINE(76)
			this->posChanged;
		}
		HX_STACK_LINE(76)
		(int)0;
	}
	HX_STACK_LINE(76)
	{
		HX_STACK_LINE(76)
		this->y = (int)0;
		HX_STACK_LINE(76)
		{
			HX_STACK_LINE(76)
			this->posChanged = true;
			HX_STACK_LINE(76)
			if (((this->childs != null()))){
				HX_STACK_LINE(76)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(76)
				Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(76)
				while((true)){
					HX_STACK_LINE(76)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(76)
						break;
					}
					HX_STACK_LINE(76)
					::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(76)
					++(_g);
					HX_STACK_LINE(76)
					c->set_posChanged(true);
				}
			}
			HX_STACK_LINE(76)
			this->posChanged;
		}
		HX_STACK_LINE(76)
		(int)0;
	}
	HX_STACK_LINE(76)
	{
		HX_STACK_LINE(76)
		this->scaleX = (int)1;
		HX_STACK_LINE(76)
		{
			HX_STACK_LINE(76)
			this->posChanged = true;
			HX_STACK_LINE(76)
			if (((this->childs != null()))){
				HX_STACK_LINE(76)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(76)
				Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(76)
				while((true)){
					HX_STACK_LINE(76)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(76)
						break;
					}
					HX_STACK_LINE(76)
					::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(76)
					++(_g);
					HX_STACK_LINE(76)
					c->set_posChanged(true);
				}
			}
			HX_STACK_LINE(76)
			this->posChanged;
		}
		HX_STACK_LINE(76)
		(int)1;
	}
	HX_STACK_LINE(76)
	{
		HX_STACK_LINE(76)
		this->scaleY = (int)1;
		HX_STACK_LINE(76)
		{
			HX_STACK_LINE(76)
			this->posChanged = true;
			HX_STACK_LINE(76)
			if (((this->childs != null()))){
				HX_STACK_LINE(76)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(76)
				Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(76)
				while((true)){
					HX_STACK_LINE(76)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(76)
						break;
					}
					HX_STACK_LINE(76)
					::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(76)
					++(_g);
					HX_STACK_LINE(76)
					c->set_posChanged(true);
				}
			}
			HX_STACK_LINE(76)
			this->posChanged;
		}
		HX_STACK_LINE(76)
		(int)1;
	}
	HX_STACK_LINE(76)
	{
		HX_STACK_LINE(76)
		this->rotation = (int)0;
		HX_STACK_LINE(76)
		{
			HX_STACK_LINE(76)
			this->posChanged = true;
			HX_STACK_LINE(76)
			if (((this->childs != null()))){
				HX_STACK_LINE(76)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(76)
				Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(76)
				while((true)){
					HX_STACK_LINE(76)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(76)
						break;
					}
					HX_STACK_LINE(76)
					::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(76)
					++(_g);
					HX_STACK_LINE(76)
					c->set_posChanged(true);
				}
			}
			HX_STACK_LINE(76)
			this->posChanged;
		}
		HX_STACK_LINE(76)
		(int)0;
	}
	HX_STACK_LINE(77)
	{
		HX_STACK_LINE(77)
		this->skewX = (int)0;
		HX_STACK_LINE(77)
		{
			HX_STACK_LINE(77)
			this->posChanged = true;
			HX_STACK_LINE(77)
			if (((this->childs != null()))){
				HX_STACK_LINE(77)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(77)
				Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(77)
				while((true)){
					HX_STACK_LINE(77)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(77)
						break;
					}
					HX_STACK_LINE(77)
					::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(77)
					++(_g);
					HX_STACK_LINE(77)
					c->set_posChanged(true);
				}
			}
			HX_STACK_LINE(77)
			this->posChanged;
		}
		HX_STACK_LINE(77)
		(int)0;
	}
	HX_STACK_LINE(77)
	{
		HX_STACK_LINE(77)
		this->skewY = (int)0;
		HX_STACK_LINE(77)
		{
			HX_STACK_LINE(77)
			this->posChanged = true;
			HX_STACK_LINE(77)
			if (((this->childs != null()))){
				HX_STACK_LINE(77)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(77)
				Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(77)
				while((true)){
					HX_STACK_LINE(77)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(77)
						break;
					}
					HX_STACK_LINE(77)
					::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(77)
					++(_g);
					HX_STACK_LINE(77)
					c->set_posChanged(true);
				}
			}
			HX_STACK_LINE(77)
			this->posChanged;
		}
		HX_STACK_LINE(77)
		(int)0;
	}
	HX_STACK_LINE(79)
	::h2d::Matrix _g = ::h2d::Matrix_obj::__new(null(),null(),null(),null(),null(),null());		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(79)
	this->pixSpaceMatrix = _g;
	HX_STACK_LINE(80)
	{
		HX_STACK_LINE(80)
		this->posChanged = true;
		HX_STACK_LINE(80)
		if (((this->childs != null()))){
			HX_STACK_LINE(80)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(80)
			Array< ::Dynamic > _g11 = this->childs;		HX_STACK_VAR(_g11,"_g11");
			HX_STACK_LINE(80)
			while((true)){
				HX_STACK_LINE(80)
				if ((!(((_g1 < _g11->length))))){
					HX_STACK_LINE(80)
					break;
				}
				HX_STACK_LINE(80)
				::h2d::Sprite c = _g11->__get(_g1).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
				HX_STACK_LINE(80)
				++(_g1);
				HX_STACK_LINE(80)
				c->set_posChanged(true);
			}
		}
		HX_STACK_LINE(80)
		this->posChanged;
	}
	HX_STACK_LINE(81)
	this->visible = true;
	HX_STACK_LINE(82)
	this->childs = Array_obj< ::Dynamic >::__new();
	HX_STACK_LINE(83)
	if (((parent != null()))){
		HX_STACK_LINE(84)
		parent->addChild(hx::ObjectPtr<OBJ_>(this));
	}
}
;
	return null();
}

//Sprite_obj::~Sprite_obj() { }

Dynamic Sprite_obj::__CreateEmpty() { return  new Sprite_obj; }
hx::ObjectPtr< Sprite_obj > Sprite_obj::__new(::h2d::Sprite parent)
{  hx::ObjectPtr< Sprite_obj > result = new Sprite_obj();
	result->__construct(parent);
	return result;}

Dynamic Sprite_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Sprite_obj > result = new Sprite_obj();
	result->__construct(inArgs[0]);
	return result;}

int Sprite_obj::getSpritesCount( ){
	HX_STACK_FRAME("h2d.Sprite","getSpritesCount",0xafdd4c22,"h2d.Sprite.getSpritesCount","h2d/Sprite.hx",102,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_LINE(103)
	int k = (int)0;		HX_STACK_VAR(k,"k");
	HX_STACK_LINE(104)
	{
		HX_STACK_LINE(104)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(104)
		Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(104)
		while((true)){
			HX_STACK_LINE(104)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(104)
				break;
			}
			HX_STACK_LINE(104)
			::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
			HX_STACK_LINE(104)
			++(_g);
			HX_STACK_LINE(105)
			int _g2 = c->getSpritesCount();		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(105)
			int _g11 = (_g2 + (int)1);		HX_STACK_VAR(_g11,"_g11");
			HX_STACK_LINE(105)
			hx::AddEq(k,_g11);
		}
	}
	HX_STACK_LINE(106)
	return k;
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,getSpritesCount,return )

bool Sprite_obj::set_posChanged( bool v){
	HX_STACK_FRAME("h2d.Sprite","set_posChanged",0x84f56392,"h2d.Sprite.set_posChanged","h2d/Sprite.hx",109,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(110)
	this->posChanged = v;
	HX_STACK_LINE(111)
	if (((bool(v) && bool((this->childs != null()))))){
		HX_STACK_LINE(112)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(112)
		Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(112)
		while((true)){
			HX_STACK_LINE(112)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(112)
				break;
			}
			HX_STACK_LINE(112)
			::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
			HX_STACK_LINE(112)
			++(_g);
			HX_STACK_LINE(113)
			c->set_posChanged(v);
		}
	}
	HX_STACK_LINE(114)
	return this->posChanged;
}


HX_DEFINE_DYNAMIC_FUNC1(Sprite_obj,set_posChanged,return )

::h2d::col::Point Sprite_obj::localToGlobal( ::h2d::col::Point pt){
	HX_STACK_FRAME("h2d.Sprite","localToGlobal",0x390c5e54,"h2d.Sprite.localToGlobal","h2d/Sprite.hx",120,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_ARG(pt,"pt")
	HX_STACK_LINE(121)
	this->syncPos();
	HX_STACK_LINE(122)
	if (((pt == null()))){
		HX_STACK_LINE(122)
		::h2d::col::Point _g = ::h2d::col::Point_obj::__new(null(),null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(122)
		pt = _g;
	}
	HX_STACK_LINE(123)
	Float px = (((pt->x * this->matA) + (pt->y * this->matC)) + this->absX);		HX_STACK_VAR(px,"px");
	HX_STACK_LINE(124)
	Float py = (((pt->x * this->matB) + (pt->y * this->matD)) + this->absY);		HX_STACK_VAR(py,"py");
	HX_STACK_LINE(125)
	pt->x = (((px + (int)1)) * 0.5);
	HX_STACK_LINE(126)
	pt->y = ((((int)1 - py)) * 0.5);
	HX_STACK_LINE(127)
	::h2d::Scene scene = this->getScene();		HX_STACK_VAR(scene,"scene");
	HX_STACK_LINE(128)
	if (((scene != null()))){
		HX_STACK_LINE(129)
		Float _g1 = scene->get_width();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(129)
		hx::MultEq(pt->x,_g1);
		HX_STACK_LINE(130)
		Float _g2 = scene->get_height();		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(130)
		hx::MultEq(pt->y,_g2);
	}
	else{
		HX_STACK_LINE(132)
		int _g3 = ::hxd::System_obj::get_width();		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(132)
		hx::MultEq(pt->x,_g3);
		HX_STACK_LINE(133)
		int _g4 = ::hxd::System_obj::get_height();		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(133)
		hx::MultEq(pt->y,_g4);
	}
	HX_STACK_LINE(135)
	return pt;
}


HX_DEFINE_DYNAMIC_FUNC1(Sprite_obj,localToGlobal,return )

::h2d::col::Point Sprite_obj::globalToLocal( ::h2d::col::Point pt){
	HX_STACK_FRAME("h2d.Sprite","globalToLocal",0x5ccf6b58,"h2d.Sprite.globalToLocal","h2d/Sprite.hx",138,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_ARG(pt,"pt")
	HX_STACK_LINE(139)
	this->syncPos();
	HX_STACK_LINE(140)
	::h2d::Scene scene = this->getScene();		HX_STACK_VAR(scene,"scene");
	HX_STACK_LINE(141)
	if (((scene != null()))){
		HX_STACK_LINE(142)
		Float _g = scene->get_width();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(142)
		hx::DivEq(pt->x,_g);
		HX_STACK_LINE(143)
		Float _g1 = scene->get_height();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(143)
		hx::DivEq(pt->y,_g1);
	}
	else{
		HX_STACK_LINE(145)
		int _g2 = ::hxd::System_obj::get_width();		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(145)
		hx::DivEq(pt->x,_g2);
		HX_STACK_LINE(146)
		int _g3 = ::hxd::System_obj::get_height();		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(146)
		hx::DivEq(pt->y,_g3);
	}
	HX_STACK_LINE(148)
	pt->x = ((pt->x * (int)2) - (int)1);
	HX_STACK_LINE(149)
	pt->y = ((int)1 - (pt->y * (int)2));
	HX_STACK_LINE(150)
	hx::SubEq(pt->x,this->absX);
	HX_STACK_LINE(151)
	hx::SubEq(pt->y,this->absY);
	HX_STACK_LINE(152)
	Float invDet = (Float((int)1) / Float((((this->matA * this->matD) - (this->matB * this->matC)))));		HX_STACK_VAR(invDet,"invDet");
	HX_STACK_LINE(153)
	Float px = ((((pt->x * this->matD) - (pt->y * this->matC))) * invDet);		HX_STACK_VAR(px,"px");
	HX_STACK_LINE(154)
	Float py = ((((-(pt->x) * this->matB) + (pt->y * this->matA))) * invDet);		HX_STACK_VAR(py,"py");
	HX_STACK_LINE(155)
	pt->x = px;
	HX_STACK_LINE(156)
	pt->y = py;
	HX_STACK_LINE(157)
	return pt;
}


HX_DEFINE_DYNAMIC_FUNC1(Sprite_obj,globalToLocal,return )

::h2d::Scene Sprite_obj::getScene( ){
	HX_STACK_FRAME("h2d.Sprite","getScene",0x1993182b,"h2d.Sprite.getScene","h2d/Sprite.hx",160,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_LINE(161)
	::h2d::Sprite p = hx::ObjectPtr<OBJ_>(this);		HX_STACK_VAR(p,"p");
	HX_STACK_LINE(162)
	while((true)){
		HX_STACK_LINE(162)
		if ((!(((p->parent != null()))))){
			HX_STACK_LINE(162)
			break;
		}
		HX_STACK_LINE(162)
		p = p->parent;
	}
	HX_STACK_LINE(163)
	return ::Std_obj::instance(p,hx::ClassOf< ::h2d::Scene >());
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,getScene,return )

Void Sprite_obj::addChild( ::h2d::Sprite s){
{
		HX_STACK_FRAME("h2d.Sprite","addChild",0x0000ff10,"h2d.Sprite.addChild","h2d/Sprite.hx",166,0xc9e42484)
		HX_STACK_THIS(this)
		HX_STACK_ARG(s,"s")
		HX_STACK_LINE(168)
		if (((s->parent != null()))){
			HX_STACK_LINE(168)
			HX_STACK_DO_THROW(HX_CSTRING("sprite already has a parent"));
		}
		HX_STACK_LINE(169)
		this->addChildAt(s,this->childs->length);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Sprite_obj,addChild,(void))

Void Sprite_obj::addChildAt( ::h2d::Sprite s,int pos){
{
		HX_STACK_FRAME("h2d.Sprite","addChildAt",0xc18b1c23,"h2d.Sprite.addChildAt","h2d/Sprite.hx",172,0xc9e42484)
		HX_STACK_THIS(this)
		HX_STACK_ARG(s,"s")
		HX_STACK_ARG(pos,"pos")
		HX_STACK_LINE(173)
		if (((pos < (int)0))){
			HX_STACK_LINE(173)
			pos = (int)0;
		}
		HX_STACK_LINE(174)
		if (((pos > this->childs->length))){
			HX_STACK_LINE(174)
			pos = this->childs->length;
		}
		HX_STACK_LINE(175)
		::h2d::Sprite p = hx::ObjectPtr<OBJ_>(this);		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(176)
		while((true)){
			HX_STACK_LINE(176)
			if ((!(((p != null()))))){
				HX_STACK_LINE(176)
				break;
			}
			HX_STACK_LINE(177)
			if (((p == s))){
				HX_STACK_LINE(177)
				HX_STACK_DO_THROW(HX_CSTRING("Recursive addChild"));
			}
			HX_STACK_LINE(178)
			p = p->parent;
		}
		HX_STACK_LINE(180)
		if (((s->parent != null()))){
			HX_STACK_LINE(182)
			bool old = s->allocated;		HX_STACK_VAR(old,"old");
			HX_STACK_LINE(183)
			s->allocated = false;
			HX_STACK_LINE(184)
			s->parent->removeChild(s);
			HX_STACK_LINE(185)
			s->allocated = old;
		}
		HX_STACK_LINE(187)
		this->childs->insert(pos,s);
		HX_STACK_LINE(188)
		if (((bool(!(this->allocated)) && bool(s->allocated)))){
			HX_STACK_LINE(189)
			s->onDelete();
		}
		HX_STACK_LINE(190)
		s->parent = hx::ObjectPtr<OBJ_>(this);
		HX_STACK_LINE(191)
		{
			HX_STACK_LINE(191)
			s->posChanged = true;
			HX_STACK_LINE(191)
			if (((s->childs != null()))){
				HX_STACK_LINE(191)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(191)
				Array< ::Dynamic > _g1 = s->childs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(191)
				while((true)){
					HX_STACK_LINE(191)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(191)
						break;
					}
					HX_STACK_LINE(191)
					::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(191)
					++(_g);
					HX_STACK_LINE(191)
					c->set_posChanged(true);
				}
			}
			HX_STACK_LINE(191)
			s->posChanged;
		}
		HX_STACK_LINE(193)
		if ((this->allocated)){
			HX_STACK_LINE(194)
			if ((!(s->allocated))){
				HX_STACK_LINE(195)
				s->onAlloc();
			}
			else{
				HX_STACK_LINE(197)
				s->onParentChanged();
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Sprite_obj,addChildAt,(void))

Void Sprite_obj::onParentChanged( ){
{
		HX_STACK_FRAME("h2d.Sprite","onParentChanged",0xaf6f2996,"h2d.Sprite.onParentChanged","h2d/Sprite.hx",202,0xc9e42484)
		HX_STACK_THIS(this)
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,onParentChanged,(void))

Void Sprite_obj::onAlloc( ){
{
		HX_STACK_FRAME("h2d.Sprite","onAlloc",0xbeff1521,"h2d.Sprite.onAlloc","h2d/Sprite.hx",206,0xc9e42484)
		HX_STACK_THIS(this)
		HX_STACK_LINE(207)
		this->allocated = true;
		HX_STACK_LINE(208)
		{
			HX_STACK_LINE(208)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(208)
			Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(208)
			while((true)){
				HX_STACK_LINE(208)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(208)
					break;
				}
				HX_STACK_LINE(208)
				::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
				HX_STACK_LINE(208)
				++(_g);
				HX_STACK_LINE(209)
				c->onAlloc();
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,onAlloc,(void))

Void Sprite_obj::onDelete( ){
{
		HX_STACK_FRAME("h2d.Sprite","onDelete",0x8b6fe5ff,"h2d.Sprite.onDelete","h2d/Sprite.hx",213,0xc9e42484)
		HX_STACK_THIS(this)
		HX_STACK_LINE(214)
		this->allocated = false;
		HX_STACK_LINE(215)
		{
			HX_STACK_LINE(215)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(215)
			Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(215)
			while((true)){
				HX_STACK_LINE(215)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(215)
					break;
				}
				HX_STACK_LINE(215)
				::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
				HX_STACK_LINE(215)
				++(_g);
				HX_STACK_LINE(216)
				c->onDelete();
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,onDelete,(void))

Void Sprite_obj::removeChild( ::h2d::Sprite s){
{
		HX_STACK_FRAME("h2d.Sprite","removeChild",0x3a79da83,"h2d.Sprite.removeChild","h2d/Sprite.hx",220,0xc9e42484)
		HX_STACK_THIS(this)
		HX_STACK_ARG(s,"s")
		HX_STACK_LINE(220)
		if ((this->childs->remove(s))){
			HX_STACK_LINE(221)
			if ((s->allocated)){
				HX_STACK_LINE(221)
				s->onDelete();
			}
			HX_STACK_LINE(222)
			s->parent = null();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Sprite_obj,removeChild,(void))

Void Sprite_obj::removeAllChildren( ){
{
		HX_STACK_FRAME("h2d.Sprite","removeAllChildren",0xcc87afa7,"h2d.Sprite.removeAllChildren","h2d/Sprite.hx",226,0xc9e42484)
		HX_STACK_THIS(this)
		HX_STACK_LINE(227)
		::h2d::Sprite s = null();		HX_STACK_VAR(s,"s");
		HX_STACK_LINE(228)
		while((true)){
			HX_STACK_LINE(228)
			::h2d::Sprite _g = s = this->childs->__get((int)0).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(228)
			if ((!(this->childs->remove(_g)))){
				HX_STACK_LINE(228)
				break;
			}
			HX_STACK_LINE(229)
			if ((s->allocated)){
				HX_STACK_LINE(229)
				s->onDelete();
			}
			HX_STACK_LINE(230)
			s->parent = null();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,removeAllChildren,(void))

Void Sprite_obj::remove( ){
{
		HX_STACK_FRAME("h2d.Sprite","remove",0x8e52dc59,"h2d.Sprite.remove","h2d/Sprite.hx",236,0xc9e42484)
		HX_STACK_THIS(this)
		HX_STACK_LINE(236)
		if (((this->parent != null()))){
			HX_STACK_LINE(236)
			this->parent->removeChild(hx::ObjectPtr<OBJ_>(this));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,remove,(void))

Void Sprite_obj::draw( ::h3d::scene::RenderContext ctx){
{
		HX_STACK_FRAME("h2d.Sprite","draw",0xe230ccd9,"h2d.Sprite.draw","h2d/Sprite.hx",239,0xc9e42484)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ctx,"ctx")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Sprite_obj,draw,(void))

Void Sprite_obj::cachePixSpaceMatrix( ){
{
		HX_STACK_FRAME("h2d.Sprite","cachePixSpaceMatrix",0xc0ec7235,"h2d.Sprite.cachePixSpaceMatrix","h2d/Sprite.hx",243,0xc9e42484)
		HX_STACK_THIS(this)
		HX_STACK_LINE(243)
		this->getPixSpaceMatrix(this->pixSpaceMatrix,null());
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,cachePixSpaceMatrix,(void))

Void Sprite_obj::sync( ::h3d::scene::RenderContext ctx){
{
		HX_STACK_FRAME("h2d.Sprite","sync",0xec205b30,"h2d.Sprite.sync","h2d/Sprite.hx",246,0xc9e42484)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ctx,"ctx")
		HX_STACK_LINE(247)
		bool changed = this->posChanged;		HX_STACK_VAR(changed,"changed");
		HX_STACK_LINE(248)
		if ((changed)){
			HX_STACK_LINE(249)
			this->calcAbsPos();
			HX_STACK_LINE(250)
			this->cachePixSpaceMatrix();
			HX_STACK_LINE(251)
			{
				HX_STACK_LINE(251)
				this->posChanged = false;
				HX_STACK_LINE(251)
				this->posChanged;
			}
		}
		HX_STACK_LINE(254)
		this->lastFrame = ctx->frame;
		HX_STACK_LINE(255)
		int p = (int)0;		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(255)
		int len = this->childs->length;		HX_STACK_VAR(len,"len");
		HX_STACK_LINE(256)
		while((true)){
			HX_STACK_LINE(256)
			if ((!(((p < len))))){
				HX_STACK_LINE(256)
				break;
			}
			HX_STACK_LINE(257)
			::h2d::Sprite c = this->childs->__get(p).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
			HX_STACK_LINE(258)
			if (((c == null()))){
				HX_STACK_LINE(259)
				break;
			}
			HX_STACK_LINE(260)
			if (((c->lastFrame != ctx->frame))){
				HX_STACK_LINE(261)
				if ((changed)){
					HX_STACK_LINE(261)
					c->posChanged = true;
					HX_STACK_LINE(261)
					if (((c->childs != null()))){
						HX_STACK_LINE(261)
						int _g = (int)0;		HX_STACK_VAR(_g,"_g");
						HX_STACK_LINE(261)
						Array< ::Dynamic > _g1 = c->childs;		HX_STACK_VAR(_g1,"_g1");
						HX_STACK_LINE(261)
						while((true)){
							HX_STACK_LINE(261)
							if ((!(((_g < _g1->length))))){
								HX_STACK_LINE(261)
								break;
							}
							HX_STACK_LINE(261)
							::h2d::Sprite c1 = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c1,"c1");
							HX_STACK_LINE(261)
							++(_g);
							HX_STACK_LINE(261)
							c1->set_posChanged(true);
						}
					}
					HX_STACK_LINE(261)
					c->posChanged;
				}
				HX_STACK_LINE(262)
				c->sync(ctx);
			}
			HX_STACK_LINE(266)
			if (((this->childs->__get(p).StaticCast< ::h2d::Sprite >() != c))){
				HX_STACK_LINE(267)
				p = (int)0;
				HX_STACK_LINE(268)
				len = this->childs->length;
			}
			else{
				HX_STACK_LINE(270)
				(p)++;
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Sprite_obj,sync,(void))

Void Sprite_obj::syncPos( ){
{
		HX_STACK_FRAME("h2d.Sprite","syncPos",0xae41d844,"h2d.Sprite.syncPos","h2d/Sprite.hx",274,0xc9e42484)
		HX_STACK_THIS(this)
		HX_STACK_LINE(275)
		if ((!(this->posChanged))){
			HX_STACK_LINE(275)
			return null();
		}
		HX_STACK_LINE(277)
		if (((this->parent != null()))){
			HX_STACK_LINE(277)
			this->parent->syncPos();
		}
		HX_STACK_LINE(278)
		if ((this->posChanged)){
			HX_STACK_LINE(279)
			this->calcAbsPos();
			HX_STACK_LINE(280)
			this->cachePixSpaceMatrix();
			HX_STACK_LINE(281)
			{
				HX_STACK_LINE(281)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(281)
				Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(281)
				while((true)){
					HX_STACK_LINE(281)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(281)
						break;
					}
					HX_STACK_LINE(281)
					::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(281)
					++(_g);
					HX_STACK_LINE(282)
					c->posChanged = true;
					HX_STACK_LINE(282)
					if (((c->childs != null()))){
						HX_STACK_LINE(282)
						int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
						HX_STACK_LINE(282)
						Array< ::Dynamic > _g11 = c->childs;		HX_STACK_VAR(_g11,"_g11");
						HX_STACK_LINE(282)
						while((true)){
							HX_STACK_LINE(282)
							if ((!(((_g2 < _g11->length))))){
								HX_STACK_LINE(282)
								break;
							}
							HX_STACK_LINE(282)
							::h2d::Sprite c1 = _g11->__get(_g2).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c1,"c1");
							HX_STACK_LINE(282)
							++(_g2);
							HX_STACK_LINE(282)
							c1->set_posChanged(true);
						}
					}
					HX_STACK_LINE(282)
					c->posChanged;
				}
			}
			HX_STACK_LINE(283)
			{
				HX_STACK_LINE(283)
				this->posChanged = false;
				HX_STACK_LINE(283)
				this->posChanged;
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,syncPos,(void))

::h2d::Matrix Sprite_obj::getPixSpaceMatrix( ::h2d::Matrix m,::h2d::Tile tile){
	if (((m == null()))){
		::h2d::Matrix _g = ::h2d::Matrix_obj::__new(null(),null(),null(),null(),null(),null());
		m = _g;
	}
	else{
		m->a = 1.;
		m->b = 0.;
		m->c = 0.;
		m->d = 1.;
		m->tx = 0.;
		m->ty = 0.;
	}
	Float ax = 0.0;
	Float ay = 0.0;
	struct _Function_1_1{
		inline static bool Block( hx::ObjectPtr< ::h2d::Sprite_obj > __this){
			{
				::h2d::Scene _g1 = __this->getScene();
				return (__this->parent == _g1);
			}
			return null();
		}
	};
	if (((  ((!(((this->parent == null()))))) ? bool(_Function_1_1::Block(this)) : bool(true) ))){
		if (((bool((this->skewX != (int)0)) || bool((this->skewY != (int)0))))){
			m->skew(this->skewX,this->skewY);
		}
		if (((bool((this->scaleX != (int)0)) || bool((this->scaleY != (int)0))))){
			Float x = this->scaleX;
			Float y = this->scaleY;
			hx::MultEq(m->a,x);
			hx::MultEq(m->b,y);
			hx::MultEq(m->c,x);
			hx::MultEq(m->d,y);
			hx::MultEq(m->tx,x);
			hx::MultEq(m->ty,y);
		}
		if (((this->rotation != (int)0))){
			Float angle = this->rotation;
			Float c = ::Math_obj::cos(angle);
			Float s = ::Math_obj::sin(angle);
			m->concat32(c,-(s),s,c,0.0,0.0);
		}
		ax = this->x;
		ay = this->y;
	}
	else{
		this->parent->syncPos();
		::h2d::Matrix pm = this->parent->pixSpaceMatrix;
		{
			m->a = 1.;
			m->b = 0.;
			m->c = 0.;
			m->d = 1.;
			m->tx = 0.;
			m->ty = 0.;
		}
		if (((bool((this->skewX != (int)0)) || bool((this->skewY != (int)0))))){
			m->skew(this->skewX,this->skewY);
		}
		if (((bool((this->scaleX != (int)0)) || bool((this->scaleY != (int)0))))){
			Float x = this->scaleX;
			Float y = this->scaleY;
			hx::MultEq(m->a,x);
			hx::MultEq(m->b,y);
			hx::MultEq(m->c,x);
			hx::MultEq(m->d,y);
			hx::MultEq(m->tx,x);
			hx::MultEq(m->ty,y);
		}
		if (((this->rotation != (int)0))){
			Float angle = this->rotation;
			Float c = ::Math_obj::cos(angle);
			Float s = ::Math_obj::sin(angle);
			m->concat32(c,-(s),s,c,0.0,0.0);
		}
		m->concat22(pm);
		ax = (((this->x * pm->a) + (this->y * pm->c)) + pm->tx);
		ay = (((this->x * pm->b) + (this->y * pm->d)) + pm->ty);
	}
	if (((tile != null()))){
		m->tx = ((ax + (tile->dx * m->a)) + (tile->dy * m->c));
		m->ty = ((ay + (tile->dx * m->b)) + (tile->dy * m->d));
	}
	else{
		m->tx = ax;
		m->ty = ay;
	}
	return m;
}


HX_DEFINE_DYNAMIC_FUNC2(Sprite_obj,getPixSpaceMatrix,return )

Void Sprite_obj::calcAbsPos( ){
{
		if (((this->parent == null()))){
			::h2d::Matrix t = ::h2d::Tools_obj::getCoreObjects()->tmpMatrix2D;
			{
				t->a = 1.;
				t->b = 0.;
				t->c = 0.;
				t->d = 1.;
				t->tx = 0.;
				t->ty = 0.;
			}
			if (((bool((this->skewX != (int)0)) || bool((this->skewY != (int)0))))){
				t->skew(this->skewX,this->skewY);
			}
			if (((bool((this->scaleX != (int)0)) || bool((this->scaleY != (int)0))))){
				Float x = this->scaleX;
				Float y = this->scaleY;
				hx::MultEq(t->a,x);
				hx::MultEq(t->b,y);
				hx::MultEq(t->c,x);
				hx::MultEq(t->d,y);
				hx::MultEq(t->tx,x);
				hx::MultEq(t->ty,y);
			}
			if (((this->rotation != (int)0))){
				Float angle = this->rotation;
				Float c = ::Math_obj::cos(angle);
				Float s = ::Math_obj::sin(angle);
				t->concat32(c,-(s),s,c,0.0,0.0);
			}
			{
				hx::AddEq(t->tx,this->x);
				hx::AddEq(t->ty,this->y);
			}
			this->matA = t->a;
			this->matB = t->b;
			this->matC = t->c;
			this->matD = t->d;
			this->absX = t->tx;
			this->absY = t->ty;
		}
		else{
			::h2d::Matrix t = ::h2d::Tools_obj::getCoreObjects()->tmpMatrix2D;
			{
				t->a = 1.;
				t->b = 0.;
				t->c = 0.;
				t->d = 1.;
				t->tx = 0.;
				t->ty = 0.;
			}
			if (((bool((this->skewX != (int)0)) || bool((this->skewY != (int)0))))){
				t->skew(this->skewX,this->skewY);
			}
			if (((bool((this->scaleX != (int)0)) || bool((this->scaleY != (int)0))))){
				Float x = this->scaleX;
				Float y = this->scaleY;
				hx::MultEq(t->a,x);
				hx::MultEq(t->b,y);
				hx::MultEq(t->c,x);
				hx::MultEq(t->d,y);
				hx::MultEq(t->tx,x);
				hx::MultEq(t->ty,y);
			}
			if (((this->rotation != (int)0))){
				Float angle = this->rotation;
				Float c = ::Math_obj::cos(angle);
				Float s = ::Math_obj::sin(angle);
				t->concat32(c,-(s),s,c,0.0,0.0);
			}
			::h2d::Matrix p = ::h2d::Tools_obj::getCoreObjects()->tmpMatrix2D_2;
			{
				p->a = 1.;
				p->b = 0.;
				p->c = 0.;
				p->d = 1.;
				p->tx = 0.;
				p->ty = 0.;
			}
			p->a = this->parent->matA;
			p->b = this->parent->matB;
			p->c = this->parent->matC;
			p->d = this->parent->matD;
			t->concat(p);
			p->tx = this->parent->absX;
			p->ty = this->parent->absY;
			this->matA = t->a;
			this->matB = t->b;
			this->matC = t->c;
			this->matD = t->d;
			this->absX = (((this->x * p->a) + (this->y * p->c)) + p->tx);
			this->absY = (((this->x * p->b) + (this->y * p->d)) + p->ty);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,calcAbsPos,(void))

Void Sprite_obj::drawRec( ::h3d::scene::RenderContext ctx){
{
		HX_STACK_FRAME("h2d.Sprite","drawRec",0x030491f7,"h2d.Sprite.drawRec","h2d/Sprite.hx",382,0xc9e42484)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ctx,"ctx")
		HX_STACK_LINE(383)
		if ((!(this->visible))){
			HX_STACK_LINE(383)
			return null();
		}
		HX_STACK_LINE(385)
		if ((this->posChanged)){
			HX_STACK_LINE(388)
			this->calcAbsPos();
			HX_STACK_LINE(389)
			{
				HX_STACK_LINE(389)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(389)
				Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(389)
				while((true)){
					HX_STACK_LINE(389)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(389)
						break;
					}
					HX_STACK_LINE(389)
					::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(389)
					++(_g);
					HX_STACK_LINE(390)
					c->posChanged = true;
					HX_STACK_LINE(390)
					if (((c->childs != null()))){
						HX_STACK_LINE(390)
						int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
						HX_STACK_LINE(390)
						Array< ::Dynamic > _g11 = c->childs;		HX_STACK_VAR(_g11,"_g11");
						HX_STACK_LINE(390)
						while((true)){
							HX_STACK_LINE(390)
							if ((!(((_g2 < _g11->length))))){
								HX_STACK_LINE(390)
								break;
							}
							HX_STACK_LINE(390)
							::h2d::Sprite c1 = _g11->__get(_g2).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c1,"c1");
							HX_STACK_LINE(390)
							++(_g2);
							HX_STACK_LINE(390)
							c1->set_posChanged(true);
						}
					}
					HX_STACK_LINE(390)
					c->posChanged;
				}
			}
			HX_STACK_LINE(391)
			{
				HX_STACK_LINE(391)
				this->posChanged = false;
				HX_STACK_LINE(391)
				this->posChanged;
			}
		}
		HX_STACK_LINE(393)
		this->draw(ctx);
		HX_STACK_LINE(394)
		{
			HX_STACK_LINE(394)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(394)
			Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(394)
			while((true)){
				HX_STACK_LINE(394)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(394)
					break;
				}
				HX_STACK_LINE(394)
				::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
				HX_STACK_LINE(394)
				++(_g);
				HX_STACK_LINE(395)
				c->drawRec(ctx);
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Sprite_obj,drawRec,(void))

Float Sprite_obj::set_x( Float v){
	HX_STACK_FRAME("h2d.Sprite","set_x",0xa2fbb4e6,"h2d.Sprite.set_x","h2d/Sprite.hx",398,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(399)
	this->x = v;
	HX_STACK_LINE(400)
	{
		HX_STACK_LINE(400)
		this->posChanged = true;
		HX_STACK_LINE(400)
		if (((this->childs != null()))){
			HX_STACK_LINE(400)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(400)
			Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(400)
			while((true)){
				HX_STACK_LINE(400)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(400)
					break;
				}
				HX_STACK_LINE(400)
				::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
				HX_STACK_LINE(400)
				++(_g);
				HX_STACK_LINE(400)
				c->set_posChanged(true);
			}
		}
		HX_STACK_LINE(400)
		this->posChanged;
	}
	HX_STACK_LINE(401)
	return v;
}


HX_DEFINE_DYNAMIC_FUNC1(Sprite_obj,set_x,return )

Float Sprite_obj::set_y( Float v){
	HX_STACK_FRAME("h2d.Sprite","set_y",0xa2fbb4e7,"h2d.Sprite.set_y","h2d/Sprite.hx",404,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(405)
	this->y = v;
	HX_STACK_LINE(406)
	{
		HX_STACK_LINE(406)
		this->posChanged = true;
		HX_STACK_LINE(406)
		if (((this->childs != null()))){
			HX_STACK_LINE(406)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(406)
			Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(406)
			while((true)){
				HX_STACK_LINE(406)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(406)
					break;
				}
				HX_STACK_LINE(406)
				::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
				HX_STACK_LINE(406)
				++(_g);
				HX_STACK_LINE(406)
				c->set_posChanged(true);
			}
		}
		HX_STACK_LINE(406)
		this->posChanged;
	}
	HX_STACK_LINE(407)
	return v;
}


HX_DEFINE_DYNAMIC_FUNC1(Sprite_obj,set_y,return )

Float Sprite_obj::set_scaleX( Float v){
	HX_STACK_FRAME("h2d.Sprite","set_scaleX",0x237f6760,"h2d.Sprite.set_scaleX","h2d/Sprite.hx",410,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(411)
	this->scaleX = v;
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
	HX_STACK_LINE(413)
	return v;
}


HX_DEFINE_DYNAMIC_FUNC1(Sprite_obj,set_scaleX,return )

Float Sprite_obj::set_scaleY( Float v){
	HX_STACK_FRAME("h2d.Sprite","set_scaleY",0x237f6761,"h2d.Sprite.set_scaleY","h2d/Sprite.hx",416,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(417)
	this->scaleY = v;
	HX_STACK_LINE(418)
	{
		HX_STACK_LINE(418)
		this->posChanged = true;
		HX_STACK_LINE(418)
		if (((this->childs != null()))){
			HX_STACK_LINE(418)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(418)
			Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(418)
			while((true)){
				HX_STACK_LINE(418)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(418)
					break;
				}
				HX_STACK_LINE(418)
				::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
				HX_STACK_LINE(418)
				++(_g);
				HX_STACK_LINE(418)
				c->set_posChanged(true);
			}
		}
		HX_STACK_LINE(418)
		this->posChanged;
	}
	HX_STACK_LINE(419)
	return v;
}


HX_DEFINE_DYNAMIC_FUNC1(Sprite_obj,set_scaleY,return )

Float Sprite_obj::set_skewX( Float v){
	HX_STACK_FRAME("h2d.Sprite","set_skewX",0x3115197c,"h2d.Sprite.set_skewX","h2d/Sprite.hx",422,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(423)
	this->skewX = v;
	HX_STACK_LINE(424)
	{
		HX_STACK_LINE(424)
		this->posChanged = true;
		HX_STACK_LINE(424)
		if (((this->childs != null()))){
			HX_STACK_LINE(424)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(424)
			Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(424)
			while((true)){
				HX_STACK_LINE(424)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(424)
					break;
				}
				HX_STACK_LINE(424)
				::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
				HX_STACK_LINE(424)
				++(_g);
				HX_STACK_LINE(424)
				c->set_posChanged(true);
			}
		}
		HX_STACK_LINE(424)
		this->posChanged;
	}
	HX_STACK_LINE(425)
	return v;
}


HX_DEFINE_DYNAMIC_FUNC1(Sprite_obj,set_skewX,return )

Float Sprite_obj::set_skewY( Float v){
	HX_STACK_FRAME("h2d.Sprite","set_skewY",0x3115197d,"h2d.Sprite.set_skewY","h2d/Sprite.hx",428,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(429)
	this->skewY = v;
	HX_STACK_LINE(430)
	{
		HX_STACK_LINE(430)
		this->posChanged = true;
		HX_STACK_LINE(430)
		if (((this->childs != null()))){
			HX_STACK_LINE(430)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(430)
			Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(430)
			while((true)){
				HX_STACK_LINE(430)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(430)
					break;
				}
				HX_STACK_LINE(430)
				::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
				HX_STACK_LINE(430)
				++(_g);
				HX_STACK_LINE(430)
				c->set_posChanged(true);
			}
		}
		HX_STACK_LINE(430)
		this->posChanged;
	}
	HX_STACK_LINE(431)
	return v;
}


HX_DEFINE_DYNAMIC_FUNC1(Sprite_obj,set_skewY,return )

Float Sprite_obj::set_rotation( Float v){
	HX_STACK_FRAME("h2d.Sprite","set_rotation",0x96d61290,"h2d.Sprite.set_rotation","h2d/Sprite.hx",434,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(435)
	this->rotation = v;
	HX_STACK_LINE(436)
	{
		HX_STACK_LINE(436)
		this->posChanged = true;
		HX_STACK_LINE(436)
		if (((this->childs != null()))){
			HX_STACK_LINE(436)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(436)
			Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(436)
			while((true)){
				HX_STACK_LINE(436)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(436)
					break;
				}
				HX_STACK_LINE(436)
				::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
				HX_STACK_LINE(436)
				++(_g);
				HX_STACK_LINE(436)
				c->set_posChanged(true);
			}
		}
		HX_STACK_LINE(436)
		this->posChanged;
	}
	HX_STACK_LINE(437)
	return v;
}


HX_DEFINE_DYNAMIC_FUNC1(Sprite_obj,set_rotation,return )

Void Sprite_obj::move( Float dx,Float dy){
{
		HX_STACK_FRAME("h2d.Sprite","move",0xe82183e6,"h2d.Sprite.move","h2d/Sprite.hx",443,0xc9e42484)
		HX_STACK_THIS(this)
		HX_STACK_ARG(dx,"dx")
		HX_STACK_ARG(dy,"dy")
		HX_STACK_LINE(444)
		{
			HX_STACK_LINE(444)
			::h2d::Sprite _g = hx::ObjectPtr<OBJ_>(this);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(444)
			{
				HX_STACK_LINE(444)
				Float _g1 = ::Math_obj::cos(this->rotation);		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(444)
				Float _g11 = (dx * _g1);		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(444)
				Float v = (_g->x + _g11);		HX_STACK_VAR(v,"v");
				HX_STACK_LINE(444)
				_g->x = v;
				HX_STACK_LINE(444)
				{
					HX_STACK_LINE(444)
					_g->posChanged = true;
					HX_STACK_LINE(444)
					if (((_g->childs != null()))){
						HX_STACK_LINE(444)
						int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
						HX_STACK_LINE(444)
						Array< ::Dynamic > _g12 = _g->childs;		HX_STACK_VAR(_g12,"_g12");
						HX_STACK_LINE(444)
						while((true)){
							HX_STACK_LINE(444)
							if ((!(((_g2 < _g12->length))))){
								HX_STACK_LINE(444)
								break;
							}
							HX_STACK_LINE(444)
							::h2d::Sprite c = _g12->__get(_g2).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
							HX_STACK_LINE(444)
							++(_g2);
							HX_STACK_LINE(444)
							c->set_posChanged(true);
						}
					}
					HX_STACK_LINE(444)
					_g->posChanged;
				}
				HX_STACK_LINE(444)
				v;
			}
		}
		HX_STACK_LINE(445)
		{
			HX_STACK_LINE(445)
			::h2d::Sprite _g = hx::ObjectPtr<OBJ_>(this);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(445)
			{
				HX_STACK_LINE(445)
				Float _g2 = ::Math_obj::sin(this->rotation);		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(445)
				Float _g3 = (dy * _g2);		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(445)
				Float v = (_g->y + _g3);		HX_STACK_VAR(v,"v");
				HX_STACK_LINE(445)
				_g->y = v;
				HX_STACK_LINE(445)
				{
					HX_STACK_LINE(445)
					_g->posChanged = true;
					HX_STACK_LINE(445)
					if (((_g->childs != null()))){
						HX_STACK_LINE(445)
						int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
						HX_STACK_LINE(445)
						Array< ::Dynamic > _g11 = _g->childs;		HX_STACK_VAR(_g11,"_g11");
						HX_STACK_LINE(445)
						while((true)){
							HX_STACK_LINE(445)
							if ((!(((_g1 < _g11->length))))){
								HX_STACK_LINE(445)
								break;
							}
							HX_STACK_LINE(445)
							::h2d::Sprite c = _g11->__get(_g1).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
							HX_STACK_LINE(445)
							++(_g1);
							HX_STACK_LINE(445)
							c->set_posChanged(true);
						}
					}
					HX_STACK_LINE(445)
					_g->posChanged;
				}
				HX_STACK_LINE(445)
				v;
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Sprite_obj,move,(void))

Void Sprite_obj::setPos( Float x,Float y){
{
		HX_STACK_FRAME("h2d.Sprite","setPos",0xf9372b27,"h2d.Sprite.setPos","h2d/Sprite.hx",448,0xc9e42484)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_LINE(449)
		{
			HX_STACK_LINE(449)
			this->x = x;
			HX_STACK_LINE(449)
			{
				HX_STACK_LINE(449)
				this->posChanged = true;
				HX_STACK_LINE(449)
				if (((this->childs != null()))){
					HX_STACK_LINE(449)
					int _g = (int)0;		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(449)
					Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(449)
					while((true)){
						HX_STACK_LINE(449)
						if ((!(((_g < _g1->length))))){
							HX_STACK_LINE(449)
							break;
						}
						HX_STACK_LINE(449)
						::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(449)
						++(_g);
						HX_STACK_LINE(449)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(449)
				this->posChanged;
			}
			HX_STACK_LINE(449)
			x;
		}
		HX_STACK_LINE(450)
		{
			HX_STACK_LINE(450)
			this->y = y;
			HX_STACK_LINE(450)
			{
				HX_STACK_LINE(450)
				this->posChanged = true;
				HX_STACK_LINE(450)
				if (((this->childs != null()))){
					HX_STACK_LINE(450)
					int _g = (int)0;		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(450)
					Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(450)
					while((true)){
						HX_STACK_LINE(450)
						if ((!(((_g < _g1->length))))){
							HX_STACK_LINE(450)
							break;
						}
						HX_STACK_LINE(450)
						::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(450)
						++(_g);
						HX_STACK_LINE(450)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(450)
				this->posChanged;
			}
			HX_STACK_LINE(450)
			y;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Sprite_obj,setPos,(void))

Void Sprite_obj::rotate( Float v){
{
		HX_STACK_FRAME("h2d.Sprite","rotate",0x54ea8670,"h2d.Sprite.rotate","h2d/Sprite.hx",454,0xc9e42484)
		HX_STACK_THIS(this)
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(454)
		::h2d::Sprite _g = hx::ObjectPtr<OBJ_>(this);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(454)
		{
			HX_STACK_LINE(454)
			Float v1 = (_g->rotation + v);		HX_STACK_VAR(v1,"v1");
			HX_STACK_LINE(454)
			_g->rotation = v1;
			HX_STACK_LINE(454)
			{
				HX_STACK_LINE(454)
				_g->posChanged = true;
				HX_STACK_LINE(454)
				if (((_g->childs != null()))){
					HX_STACK_LINE(454)
					int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(454)
					Array< ::Dynamic > _g11 = _g->childs;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(454)
					while((true)){
						HX_STACK_LINE(454)
						if ((!(((_g1 < _g11->length))))){
							HX_STACK_LINE(454)
							break;
						}
						HX_STACK_LINE(454)
						::h2d::Sprite c = _g11->__get(_g1).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(454)
						++(_g1);
						HX_STACK_LINE(454)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(454)
				_g->posChanged;
			}
			HX_STACK_LINE(454)
			v1;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Sprite_obj,rotate,(void))

Void Sprite_obj::scale( Float v){
{
		HX_STACK_FRAME("h2d.Sprite","scale",0xa19ae815,"h2d.Sprite.scale","h2d/Sprite.hx",457,0xc9e42484)
		HX_STACK_THIS(this)
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(458)
		{
			HX_STACK_LINE(458)
			::h2d::Sprite _g = hx::ObjectPtr<OBJ_>(this);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(458)
			{
				HX_STACK_LINE(458)
				Float v1 = (_g->scaleX * v);		HX_STACK_VAR(v1,"v1");
				HX_STACK_LINE(458)
				_g->scaleX = v1;
				HX_STACK_LINE(458)
				{
					HX_STACK_LINE(458)
					_g->posChanged = true;
					HX_STACK_LINE(458)
					if (((_g->childs != null()))){
						HX_STACK_LINE(458)
						int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
						HX_STACK_LINE(458)
						Array< ::Dynamic > _g11 = _g->childs;		HX_STACK_VAR(_g11,"_g11");
						HX_STACK_LINE(458)
						while((true)){
							HX_STACK_LINE(458)
							if ((!(((_g1 < _g11->length))))){
								HX_STACK_LINE(458)
								break;
							}
							HX_STACK_LINE(458)
							::h2d::Sprite c = _g11->__get(_g1).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
							HX_STACK_LINE(458)
							++(_g1);
							HX_STACK_LINE(458)
							c->set_posChanged(true);
						}
					}
					HX_STACK_LINE(458)
					_g->posChanged;
				}
				HX_STACK_LINE(458)
				v1;
			}
		}
		HX_STACK_LINE(459)
		{
			HX_STACK_LINE(459)
			::h2d::Sprite _g = hx::ObjectPtr<OBJ_>(this);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(459)
			{
				HX_STACK_LINE(459)
				Float v1 = (_g->scaleY * v);		HX_STACK_VAR(v1,"v1");
				HX_STACK_LINE(459)
				_g->scaleY = v1;
				HX_STACK_LINE(459)
				{
					HX_STACK_LINE(459)
					_g->posChanged = true;
					HX_STACK_LINE(459)
					if (((_g->childs != null()))){
						HX_STACK_LINE(459)
						int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
						HX_STACK_LINE(459)
						Array< ::Dynamic > _g11 = _g->childs;		HX_STACK_VAR(_g11,"_g11");
						HX_STACK_LINE(459)
						while((true)){
							HX_STACK_LINE(459)
							if ((!(((_g1 < _g11->length))))){
								HX_STACK_LINE(459)
								break;
							}
							HX_STACK_LINE(459)
							::h2d::Sprite c = _g11->__get(_g1).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
							HX_STACK_LINE(459)
							++(_g1);
							HX_STACK_LINE(459)
							c->set_posChanged(true);
						}
					}
					HX_STACK_LINE(459)
					_g->posChanged;
				}
				HX_STACK_LINE(459)
				v1;
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Sprite_obj,scale,(void))

Void Sprite_obj::setScale( Float v){
{
		HX_STACK_FRAME("h2d.Sprite","setScale",0xc7ed66dd,"h2d.Sprite.setScale","h2d/Sprite.hx",462,0xc9e42484)
		HX_STACK_THIS(this)
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(463)
		{
			HX_STACK_LINE(463)
			this->scaleX = v;
			HX_STACK_LINE(463)
			{
				HX_STACK_LINE(463)
				this->posChanged = true;
				HX_STACK_LINE(463)
				if (((this->childs != null()))){
					HX_STACK_LINE(463)
					int _g = (int)0;		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(463)
					Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(463)
					while((true)){
						HX_STACK_LINE(463)
						if ((!(((_g < _g1->length))))){
							HX_STACK_LINE(463)
							break;
						}
						HX_STACK_LINE(463)
						::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(463)
						++(_g);
						HX_STACK_LINE(463)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(463)
				this->posChanged;
			}
			HX_STACK_LINE(463)
			v;
		}
		HX_STACK_LINE(464)
		{
			HX_STACK_LINE(464)
			this->scaleY = v;
			HX_STACK_LINE(464)
			{
				HX_STACK_LINE(464)
				this->posChanged = true;
				HX_STACK_LINE(464)
				if (((this->childs != null()))){
					HX_STACK_LINE(464)
					int _g = (int)0;		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(464)
					Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(464)
					while((true)){
						HX_STACK_LINE(464)
						if ((!(((_g < _g1->length))))){
							HX_STACK_LINE(464)
							break;
						}
						HX_STACK_LINE(464)
						::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(464)
						++(_g);
						HX_STACK_LINE(464)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(464)
				this->posChanged;
			}
			HX_STACK_LINE(464)
			v;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Sprite_obj,setScale,(void))

::h2d::Sprite Sprite_obj::getChildAt( int n){
	HX_STACK_FRAME("h2d.Sprite","getChildAt",0xa962764e,"h2d.Sprite.getChildAt","h2d/Sprite.hx",468,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_ARG(n,"n")
	HX_STACK_LINE(468)
	return this->childs->__get(n).StaticCast< ::h2d::Sprite >();
}


HX_DEFINE_DYNAMIC_FUNC1(Sprite_obj,getChildAt,return )

int Sprite_obj::getChildIndex( ::h2d::Sprite s){
	HX_STACK_FRAME("h2d.Sprite","getChildIndex",0xaa238497,"h2d.Sprite.getChildIndex","h2d/Sprite.hx",471,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_ARG(s,"s")
	HX_STACK_LINE(472)
	{
		HX_STACK_LINE(472)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(472)
		int _g = this->childs->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(472)
		while((true)){
			HX_STACK_LINE(472)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(472)
				break;
			}
			HX_STACK_LINE(472)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(473)
			if (((this->childs->__get(i).StaticCast< ::h2d::Sprite >() == s))){
				HX_STACK_LINE(474)
				return i;
			}
		}
	}
	HX_STACK_LINE(475)
	return (int)-1;
}


HX_DEFINE_DYNAMIC_FUNC1(Sprite_obj,getChildIndex,return )

Void Sprite_obj::toBack( ){
{
		HX_STACK_FRAME("h2d.Sprite","toBack",0x00948557,"h2d.Sprite.toBack","h2d/Sprite.hx",478,0xc9e42484)
		HX_STACK_THIS(this)
		HX_STACK_LINE(478)
		if (((this->parent != null()))){
			HX_STACK_LINE(478)
			this->parent->setChildIndex(hx::ObjectPtr<OBJ_>(this),(int)0);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,toBack,(void))

Void Sprite_obj::toFront( ){
{
		HX_STACK_FRAME("h2d.Sprite","toFront",0xda403779,"h2d.Sprite.toFront","h2d/Sprite.hx",479,0xc9e42484)
		HX_STACK_THIS(this)
		HX_STACK_LINE(479)
		if (((this->parent != null()))){
			HX_STACK_LINE(479)
			this->parent->setChildIndex(hx::ObjectPtr<OBJ_>(this),(this->parent->childs->length - (int)1));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,toFront,(void))

Void Sprite_obj::setChildIndex( ::h2d::Sprite c,int idx){
{
		HX_STACK_FRAME("h2d.Sprite","setChildIndex",0xef2966a3,"h2d.Sprite.setChildIndex","h2d/Sprite.hx",481,0xc9e42484)
		HX_STACK_THIS(this)
		HX_STACK_ARG(c,"c")
		HX_STACK_ARG(idx,"idx")
		HX_STACK_LINE(482)
		this->childs->remove(c);
		HX_STACK_LINE(483)
		this->childs->insert(idx,c);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Sprite_obj,setChildIndex,(void))

int Sprite_obj::get_numChildren( ){
	HX_STACK_FRAME("h2d.Sprite","get_numChildren",0x6e6bb687,"h2d.Sprite.get_numChildren","h2d/Sprite.hx",487,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_LINE(487)
	return this->childs->length;
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,get_numChildren,return )

::hxd::impl::ArrayIterator Sprite_obj::iterator( ){
	HX_STACK_FRAME("h2d.Sprite","iterator",0xd4847943,"h2d.Sprite.iterator","h2d/Sprite.hx",491,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_LINE(491)
	return ::hxd::impl::ArrayIterator_obj::__new(this->childs);
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,iterator,return )

::h2d::col::Bounds Sprite_obj::getMyBounds( ){
	HX_STACK_FRAME("h2d.Sprite","getMyBounds",0xb951c982,"h2d.Sprite.getMyBounds","h2d/Sprite.hx",498,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_LINE(498)
	return ::h2d::col::Bounds_obj::__new();
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,getMyBounds,return )

Array< ::Dynamic > Sprite_obj::getChildrenBounds( ){
	HX_STACK_FRAME("h2d.Sprite","getChildrenBounds",0x54027a55,"h2d.Sprite.getChildrenBounds","h2d/Sprite.hx",502,0xc9e42484)
	HX_STACK_THIS(this)

	HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_1_1)
	::h2d::col::Bounds run(::h2d::Sprite c){
		HX_STACK_FRAME("*","_Function_1_1",0x5200ed37,"*._Function_1_1","h2d/Sprite.hx",502,0xc9e42484)
		HX_STACK_ARG(c,"c")
		{
			HX_STACK_LINE(502)
			return c->getBounds();
		}
		return null();
	}
	HX_END_LOCAL_FUNC1(return)

	HX_STACK_LINE(502)
	return this->childs->map( Dynamic(new _Function_1_1())).StaticCast< Array<Dynamic> >();
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,getChildrenBounds,return )

Float Sprite_obj::set_width( Float v){
	HX_STACK_FRAME("h2d.Sprite","set_width",0x7d5c3974,"h2d.Sprite.set_width","h2d/Sprite.hx",505,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(506)
	HX_STACK_DO_THROW(HX_CSTRING("cannot set width of this object"));
	HX_STACK_LINE(507)
	return v;
}


HX_DEFINE_DYNAMIC_FUNC1(Sprite_obj,set_width,return )

Float Sprite_obj::set_height( Float h){
	HX_STACK_FRAME("h2d.Sprite","set_height",0xe9a584b9,"h2d.Sprite.set_height","h2d/Sprite.hx",510,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_ARG(h,"h")
	HX_STACK_LINE(511)
	HX_STACK_DO_THROW(HX_CSTRING("cannot set height of this object"));
	HX_STACK_LINE(512)
	return h;
}


HX_DEFINE_DYNAMIC_FUNC1(Sprite_obj,set_height,return )

Float Sprite_obj::get_width( ){
	HX_STACK_FRAME("h2d.Sprite","get_width",0x9a0b4d68,"h2d.Sprite.get_width","h2d/Sprite.hx",516,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_LINE(516)
	::h2d::col::Bounds _this = this->getBounds();		HX_STACK_VAR(_this,"_this");
	HX_STACK_LINE(516)
	return (_this->xMax - _this->xMin);
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,get_width,return )

Float Sprite_obj::get_height( ){
	HX_STACK_FRAME("h2d.Sprite","get_height",0xe627e645,"h2d.Sprite.get_height","h2d/Sprite.hx",520,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_LINE(520)
	::h2d::col::Bounds _this = this->getBounds();		HX_STACK_VAR(_this,"_this");
	HX_STACK_LINE(520)
	return (_this->yMax - _this->yMin);
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,get_height,return )

::h2d::col::Bounds Sprite_obj::getBounds( ){
	HX_STACK_FRAME("h2d.Sprite","getBounds",0x6e734ab6,"h2d.Sprite.getBounds","h2d/Sprite.hx",526,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_LINE(527)
	::h2d::col::Bounds res = this->getMyBounds();		HX_STACK_VAR(res,"res");
	HX_STACK_LINE(529)
	Array< ::Dynamic > cs = null();		HX_STACK_VAR(cs,"cs");
	HX_STACK_LINE(530)
	if (((this->childs->length > (int)0))){
		HX_STACK_LINE(531)
		Array< ::Dynamic > _g = this->getChildrenBounds();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(531)
		cs = _g;
	}
	HX_STACK_LINE(532)
	if (((bool((res == null())) && bool((cs != null()))))){
		HX_STACK_LINE(532)
		res = cs->__get((int)0).StaticCast< ::h2d::col::Bounds >();
	}
	HX_STACK_LINE(534)
	if (((bool((res == null())) && bool((this->childs->length < (int)0))))){
		HX_STACK_LINE(535)
		::h2d::col::Point p = this->localToGlobal(null());		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(536)
		{
			HX_STACK_LINE(536)
			::h2d::col::Bounds b = ::h2d::col::Bounds_obj::__new();		HX_STACK_VAR(b,"b");
			HX_STACK_LINE(536)
			{
				HX_STACK_LINE(536)
				b->xMin = p->x;
				HX_STACK_LINE(536)
				b->yMin = p->y;
			}
			HX_STACK_LINE(536)
			{
				HX_STACK_LINE(536)
				b->xMax = p->x;
				HX_STACK_LINE(536)
				b->yMax = p->y;
			}
			HX_STACK_LINE(536)
			return b;
		}
	}
	HX_STACK_LINE(539)
	if (((bool((cs != null())) && bool((cs->length > (int)0))))){
		HX_STACK_LINE(540)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(540)
		while((true)){
			HX_STACK_LINE(540)
			if ((!(((_g < cs->length))))){
				HX_STACK_LINE(540)
				break;
			}
			HX_STACK_LINE(540)
			::h2d::col::Bounds nr = cs->__get(_g).StaticCast< ::h2d::col::Bounds >();		HX_STACK_VAR(nr,"nr");
			HX_STACK_LINE(540)
			++(_g);
			HX_STACK_LINE(541)
			if (((nr == null()))){
				HX_STACK_LINE(542)
				HX_STACK_DO_THROW(HX_CSTRING("assert"));
			}
			HX_STACK_LINE(543)
			{
				HX_STACK_LINE(543)
				if (((nr->xMin < res->xMin))){
					HX_STACK_LINE(543)
					res->xMin = nr->xMin;
				}
				HX_STACK_LINE(543)
				if (((nr->xMax > res->xMax))){
					HX_STACK_LINE(543)
					res->xMax = nr->xMax;
				}
				HX_STACK_LINE(543)
				if (((nr->yMin < res->yMin))){
					HX_STACK_LINE(543)
					res->yMin = nr->yMin;
				}
				HX_STACK_LINE(543)
				if (((nr->yMax > res->yMax))){
					HX_STACK_LINE(543)
					res->yMax = nr->yMax;
				}
			}
		}
	}
	HX_STACK_LINE(546)
	this->calcAbsPos();
	HX_STACK_LINE(547)
	return res;
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,getBounds,return )

::flash::display::Stage Sprite_obj::get_flashStage( ){
	HX_STACK_FRAME("h2d.Sprite","get_flashStage",0x23e96c4c,"h2d.Sprite.get_flashStage","h2d/Sprite.hx",559,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_LINE(559)
	return ::flash::Lib_obj::get_current()->get_stage();
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,get_flashStage,return )

::hxd::Stage Sprite_obj::get_stage( ){
	HX_STACK_FRAME("h2d.Sprite","get_stage",0x53b40220,"h2d.Sprite.get_stage","h2d/Sprite.hx",564,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_LINE(564)
	return ::hxd::Stage_obj::getInstance();
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,get_stage,return )

int Sprite_obj::detach( ){
	HX_STACK_FRAME("h2d.Sprite","detach",0xf9e99d68,"h2d.Sprite.detach","h2d/Sprite.hx",567,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_LINE(568)
	if (((this->parent == null()))){
		HX_STACK_LINE(568)
		return (int)-1;
	}
	HX_STACK_LINE(570)
	int idx = this->parent->getChildIndex(hx::ObjectPtr<OBJ_>(this));		HX_STACK_VAR(idx,"idx");
	HX_STACK_LINE(571)
	this->parent->removeChild(hx::ObjectPtr<OBJ_>(this));
	HX_STACK_LINE(572)
	return idx;
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,detach,return )

Void Sprite_obj::dispose( ){
{
		HX_STACK_FRAME("h2d.Sprite","dispose",0xc27a52ea,"h2d.Sprite.dispose","h2d/Sprite.hx",575,0xc9e42484)
		HX_STACK_THIS(this)
		HX_STACK_LINE(576)
		this->detach();
		HX_STACK_LINE(578)
		if ((this->allocated)){
			HX_STACK_LINE(578)
			this->onDelete();
		}
		HX_STACK_LINE(580)
		{
			HX_STACK_LINE(580)
			::h2d::Sprite s = null();		HX_STACK_VAR(s,"s");
			HX_STACK_LINE(580)
			while((true)){
				HX_STACK_LINE(580)
				::h2d::Sprite _g = s = this->childs->__get((int)0).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(580)
				if ((!(this->childs->remove(_g)))){
					HX_STACK_LINE(580)
					break;
				}
				HX_STACK_LINE(580)
				if ((s->allocated)){
					HX_STACK_LINE(580)
					s->onDelete();
				}
				HX_STACK_LINE(580)
				s->parent = null();
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,dispose,(void))

Float Sprite_obj::get_mouseX( ){
	HX_STACK_FRAME("h2d.Sprite","get_mouseX",0xafea28f1,"h2d.Sprite.get_mouseX","h2d/Sprite.hx",583,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_LINE(584)
	::h2d::col::Bounds b = this->getBounds();		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(585)
	Float _g;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(585)
	{
		HX_STACK_LINE(585)
		::hxd::Stage _this = ::hxd::Stage_obj::getInstance();		HX_STACK_VAR(_this,"_this");
		HX_STACK_LINE(585)
		_g = _this->stage->get_mouseX();
	}
	HX_STACK_LINE(585)
	return (_g - b->xMin);
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,get_mouseX,return )

Float Sprite_obj::get_mouseY( ){
	HX_STACK_FRAME("h2d.Sprite","get_mouseY",0xafea28f2,"h2d.Sprite.get_mouseY","h2d/Sprite.hx",588,0xc9e42484)
	HX_STACK_THIS(this)
	HX_STACK_LINE(589)
	::h2d::col::Bounds b = this->getBounds();		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(590)
	Float _g;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(590)
	{
		HX_STACK_LINE(590)
		::hxd::Stage _this = ::hxd::Stage_obj::getInstance();		HX_STACK_VAR(_this,"_this");
		HX_STACK_LINE(590)
		_g = _this->stage->get_mouseY();
	}
	HX_STACK_LINE(590)
	return (_g - b->yMin);
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,get_mouseY,return )

::h2d::Bitmap Sprite_obj::fromSprite( ::flash::display::DisplayObject v,::h2d::Sprite parent){
	HX_STACK_FRAME("h2d.Sprite","fromSprite",0xfa2e4fa4,"h2d.Sprite.fromSprite","h2d/Sprite.hx",554,0xc9e42484)
	HX_STACK_ARG(v,"v")
	HX_STACK_ARG(parent,"parent")
	HX_STACK_LINE(555)
	Array< ::Dynamic > _g = ::h2d::Tile_obj::fromSprites(Array_obj< ::Dynamic >::__new().Add(v),hx::SourceInfo(HX_CSTRING("Tile.hx"),99,HX_CSTRING("h2d.Tile"),HX_CSTRING("fromSprite")));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(555)
	::h2d::Tile _g1 = _g->__get((int)0).StaticCast< ::h2d::Tile >();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(555)
	return ::h2d::Bitmap_obj::__new(_g1,parent,null());
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Sprite_obj,fromSprite,return )


Sprite_obj::Sprite_obj()
{
}

void Sprite_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Sprite);
	HX_MARK_MEMBER_NAME(name,"name");
	HX_MARK_MEMBER_NAME(childs,"childs");
	HX_MARK_MEMBER_NAME(parent,"parent");
	HX_MARK_MEMBER_NAME(x,"x");
	HX_MARK_MEMBER_NAME(y,"y");
	HX_MARK_MEMBER_NAME(scaleX,"scaleX");
	HX_MARK_MEMBER_NAME(scaleY,"scaleY");
	HX_MARK_MEMBER_NAME(skewX,"skewX");
	HX_MARK_MEMBER_NAME(skewY,"skewY");
	HX_MARK_MEMBER_NAME(rotation,"rotation");
	HX_MARK_MEMBER_NAME(visible,"visible");
	HX_MARK_MEMBER_NAME(matA,"matA");
	HX_MARK_MEMBER_NAME(matB,"matB");
	HX_MARK_MEMBER_NAME(matC,"matC");
	HX_MARK_MEMBER_NAME(matD,"matD");
	HX_MARK_MEMBER_NAME(absX,"absX");
	HX_MARK_MEMBER_NAME(absY,"absY");
	HX_MARK_MEMBER_NAME(posChanged,"posChanged");
	HX_MARK_MEMBER_NAME(allocated,"allocated");
	HX_MARK_MEMBER_NAME(lastFrame,"lastFrame");
	HX_MARK_MEMBER_NAME(pixSpaceMatrix,"pixSpaceMatrix");
	HX_MARK_MEMBER_NAME(mouseX,"mouseX");
	HX_MARK_MEMBER_NAME(mouseY,"mouseY");
	HX_MARK_MEMBER_NAME(width,"width");
	HX_MARK_MEMBER_NAME(height,"height");
	HX_MARK_MEMBER_NAME(stage,"stage");
	HX_MARK_MEMBER_NAME(flashStage,"flashStage");
	HX_MARK_END_CLASS();
}

void Sprite_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(name,"name");
	HX_VISIT_MEMBER_NAME(childs,"childs");
	HX_VISIT_MEMBER_NAME(parent,"parent");
	HX_VISIT_MEMBER_NAME(x,"x");
	HX_VISIT_MEMBER_NAME(y,"y");
	HX_VISIT_MEMBER_NAME(scaleX,"scaleX");
	HX_VISIT_MEMBER_NAME(scaleY,"scaleY");
	HX_VISIT_MEMBER_NAME(skewX,"skewX");
	HX_VISIT_MEMBER_NAME(skewY,"skewY");
	HX_VISIT_MEMBER_NAME(rotation,"rotation");
	HX_VISIT_MEMBER_NAME(visible,"visible");
	HX_VISIT_MEMBER_NAME(matA,"matA");
	HX_VISIT_MEMBER_NAME(matB,"matB");
	HX_VISIT_MEMBER_NAME(matC,"matC");
	HX_VISIT_MEMBER_NAME(matD,"matD");
	HX_VISIT_MEMBER_NAME(absX,"absX");
	HX_VISIT_MEMBER_NAME(absY,"absY");
	HX_VISIT_MEMBER_NAME(posChanged,"posChanged");
	HX_VISIT_MEMBER_NAME(allocated,"allocated");
	HX_VISIT_MEMBER_NAME(lastFrame,"lastFrame");
	HX_VISIT_MEMBER_NAME(pixSpaceMatrix,"pixSpaceMatrix");
	HX_VISIT_MEMBER_NAME(mouseX,"mouseX");
	HX_VISIT_MEMBER_NAME(mouseY,"mouseY");
	HX_VISIT_MEMBER_NAME(width,"width");
	HX_VISIT_MEMBER_NAME(height,"height");
	HX_VISIT_MEMBER_NAME(stage,"stage");
	HX_VISIT_MEMBER_NAME(flashStage,"flashStage");
}

Dynamic Sprite_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { return x; }
		if (HX_FIELD_EQ(inName,"y") ) { return y; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { return name; }
		if (HX_FIELD_EQ(inName,"matA") ) { return matA; }
		if (HX_FIELD_EQ(inName,"matB") ) { return matB; }
		if (HX_FIELD_EQ(inName,"matC") ) { return matC; }
		if (HX_FIELD_EQ(inName,"matD") ) { return matD; }
		if (HX_FIELD_EQ(inName,"absX") ) { return absX; }
		if (HX_FIELD_EQ(inName,"absY") ) { return absY; }
		if (HX_FIELD_EQ(inName,"draw") ) { return draw_dyn(); }
		if (HX_FIELD_EQ(inName,"sync") ) { return sync_dyn(); }
		if (HX_FIELD_EQ(inName,"move") ) { return move_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"skewX") ) { return skewX; }
		if (HX_FIELD_EQ(inName,"skewY") ) { return skewY; }
		if (HX_FIELD_EQ(inName,"width") ) { return inCallProp ? get_width() : width; }
		if (HX_FIELD_EQ(inName,"stage") ) { return inCallProp ? get_stage() : stage; }
		if (HX_FIELD_EQ(inName,"set_x") ) { return set_x_dyn(); }
		if (HX_FIELD_EQ(inName,"set_y") ) { return set_y_dyn(); }
		if (HX_FIELD_EQ(inName,"scale") ) { return scale_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"childs") ) { return childs; }
		if (HX_FIELD_EQ(inName,"parent") ) { return parent; }
		if (HX_FIELD_EQ(inName,"scaleX") ) { return scaleX; }
		if (HX_FIELD_EQ(inName,"scaleY") ) { return scaleY; }
		if (HX_FIELD_EQ(inName,"mouseX") ) { return inCallProp ? get_mouseX() : mouseX; }
		if (HX_FIELD_EQ(inName,"mouseY") ) { return inCallProp ? get_mouseY() : mouseY; }
		if (HX_FIELD_EQ(inName,"height") ) { return inCallProp ? get_height() : height; }
		if (HX_FIELD_EQ(inName,"remove") ) { return remove_dyn(); }
		if (HX_FIELD_EQ(inName,"setPos") ) { return setPos_dyn(); }
		if (HX_FIELD_EQ(inName,"rotate") ) { return rotate_dyn(); }
		if (HX_FIELD_EQ(inName,"toBack") ) { return toBack_dyn(); }
		if (HX_FIELD_EQ(inName,"detach") ) { return detach_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"visible") ) { return visible; }
		if (HX_FIELD_EQ(inName,"onAlloc") ) { return onAlloc_dyn(); }
		if (HX_FIELD_EQ(inName,"syncPos") ) { return syncPos_dyn(); }
		if (HX_FIELD_EQ(inName,"drawRec") ) { return drawRec_dyn(); }
		if (HX_FIELD_EQ(inName,"toFront") ) { return toFront_dyn(); }
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"rotation") ) { return rotation; }
		if (HX_FIELD_EQ(inName,"getScene") ) { return getScene_dyn(); }
		if (HX_FIELD_EQ(inName,"addChild") ) { return addChild_dyn(); }
		if (HX_FIELD_EQ(inName,"onDelete") ) { return onDelete_dyn(); }
		if (HX_FIELD_EQ(inName,"setScale") ) { return setScale_dyn(); }
		if (HX_FIELD_EQ(inName,"iterator") ) { return iterator_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"allocated") ) { return allocated; }
		if (HX_FIELD_EQ(inName,"lastFrame") ) { return lastFrame; }
		if (HX_FIELD_EQ(inName,"set_skewX") ) { return set_skewX_dyn(); }
		if (HX_FIELD_EQ(inName,"set_skewY") ) { return set_skewY_dyn(); }
		if (HX_FIELD_EQ(inName,"set_width") ) { return set_width_dyn(); }
		if (HX_FIELD_EQ(inName,"get_width") ) { return get_width_dyn(); }
		if (HX_FIELD_EQ(inName,"getBounds") ) { return getBounds_dyn(); }
		if (HX_FIELD_EQ(inName,"get_stage") ) { return get_stage_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"fromSprite") ) { return fromSprite_dyn(); }
		if (HX_FIELD_EQ(inName,"posChanged") ) { return posChanged; }
		if (HX_FIELD_EQ(inName,"addChildAt") ) { return addChildAt_dyn(); }
		if (HX_FIELD_EQ(inName,"calcAbsPos") ) { return calcAbsPos_dyn(); }
		if (HX_FIELD_EQ(inName,"set_scaleX") ) { return set_scaleX_dyn(); }
		if (HX_FIELD_EQ(inName,"set_scaleY") ) { return set_scaleY_dyn(); }
		if (HX_FIELD_EQ(inName,"getChildAt") ) { return getChildAt_dyn(); }
		if (HX_FIELD_EQ(inName,"set_height") ) { return set_height_dyn(); }
		if (HX_FIELD_EQ(inName,"get_height") ) { return get_height_dyn(); }
		if (HX_FIELD_EQ(inName,"flashStage") ) { return inCallProp ? get_flashStage() : flashStage; }
		if (HX_FIELD_EQ(inName,"get_mouseX") ) { return get_mouseX_dyn(); }
		if (HX_FIELD_EQ(inName,"get_mouseY") ) { return get_mouseY_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"numChildren") ) { return get_numChildren(); }
		if (HX_FIELD_EQ(inName,"removeChild") ) { return removeChild_dyn(); }
		if (HX_FIELD_EQ(inName,"getMyBounds") ) { return getMyBounds_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"set_rotation") ) { return set_rotation_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"localToGlobal") ) { return localToGlobal_dyn(); }
		if (HX_FIELD_EQ(inName,"globalToLocal") ) { return globalToLocal_dyn(); }
		if (HX_FIELD_EQ(inName,"getChildIndex") ) { return getChildIndex_dyn(); }
		if (HX_FIELD_EQ(inName,"setChildIndex") ) { return setChildIndex_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"pixSpaceMatrix") ) { return pixSpaceMatrix; }
		if (HX_FIELD_EQ(inName,"set_posChanged") ) { return set_posChanged_dyn(); }
		if (HX_FIELD_EQ(inName,"get_flashStage") ) { return get_flashStage_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"getSpritesCount") ) { return getSpritesCount_dyn(); }
		if (HX_FIELD_EQ(inName,"onParentChanged") ) { return onParentChanged_dyn(); }
		if (HX_FIELD_EQ(inName,"get_numChildren") ) { return get_numChildren_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"removeAllChildren") ) { return removeAllChildren_dyn(); }
		if (HX_FIELD_EQ(inName,"getPixSpaceMatrix") ) { return getPixSpaceMatrix_dyn(); }
		if (HX_FIELD_EQ(inName,"getChildrenBounds") ) { return getChildrenBounds_dyn(); }
		break;
	case 19:
		if (HX_FIELD_EQ(inName,"cachePixSpaceMatrix") ) { return cachePixSpaceMatrix_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Sprite_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { if (inCallProp) return set_x(inValue);x=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"y") ) { if (inCallProp) return set_y(inValue);y=inValue.Cast< Float >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { name=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"matA") ) { matA=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"matB") ) { matB=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"matC") ) { matC=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"matD") ) { matD=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"absX") ) { absX=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"absY") ) { absY=inValue.Cast< Float >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"skewX") ) { if (inCallProp) return set_skewX(inValue);skewX=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"skewY") ) { if (inCallProp) return set_skewY(inValue);skewY=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"width") ) { if (inCallProp) return set_width(inValue);width=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"stage") ) { stage=inValue.Cast< ::hxd::Stage >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"childs") ) { childs=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"parent") ) { parent=inValue.Cast< ::h2d::Sprite >(); return inValue; }
		if (HX_FIELD_EQ(inName,"scaleX") ) { if (inCallProp) return set_scaleX(inValue);scaleX=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"scaleY") ) { if (inCallProp) return set_scaleY(inValue);scaleY=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"mouseX") ) { mouseX=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"mouseY") ) { mouseY=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"height") ) { if (inCallProp) return set_height(inValue);height=inValue.Cast< Float >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"visible") ) { visible=inValue.Cast< bool >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"rotation") ) { if (inCallProp) return set_rotation(inValue);rotation=inValue.Cast< Float >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"allocated") ) { allocated=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lastFrame") ) { lastFrame=inValue.Cast< int >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"posChanged") ) { if (inCallProp) return set_posChanged(inValue);posChanged=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"flashStage") ) { flashStage=inValue.Cast< ::flash::display::Stage >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"pixSpaceMatrix") ) { pixSpaceMatrix=inValue.Cast< ::h2d::Matrix >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Sprite_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("name"));
	outFields->push(HX_CSTRING("childs"));
	outFields->push(HX_CSTRING("parent"));
	outFields->push(HX_CSTRING("numChildren"));
	outFields->push(HX_CSTRING("x"));
	outFields->push(HX_CSTRING("y"));
	outFields->push(HX_CSTRING("scaleX"));
	outFields->push(HX_CSTRING("scaleY"));
	outFields->push(HX_CSTRING("skewX"));
	outFields->push(HX_CSTRING("skewY"));
	outFields->push(HX_CSTRING("rotation"));
	outFields->push(HX_CSTRING("visible"));
	outFields->push(HX_CSTRING("matA"));
	outFields->push(HX_CSTRING("matB"));
	outFields->push(HX_CSTRING("matC"));
	outFields->push(HX_CSTRING("matD"));
	outFields->push(HX_CSTRING("absX"));
	outFields->push(HX_CSTRING("absY"));
	outFields->push(HX_CSTRING("posChanged"));
	outFields->push(HX_CSTRING("allocated"));
	outFields->push(HX_CSTRING("lastFrame"));
	outFields->push(HX_CSTRING("pixSpaceMatrix"));
	outFields->push(HX_CSTRING("mouseX"));
	outFields->push(HX_CSTRING("mouseY"));
	outFields->push(HX_CSTRING("width"));
	outFields->push(HX_CSTRING("height"));
	outFields->push(HX_CSTRING("stage"));
	outFields->push(HX_CSTRING("flashStage"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("fromSprite"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsString,(int)offsetof(Sprite_obj,name),HX_CSTRING("name")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Sprite_obj,childs),HX_CSTRING("childs")},
	{hx::fsObject /*::h2d::Sprite*/ ,(int)offsetof(Sprite_obj,parent),HX_CSTRING("parent")},
	{hx::fsFloat,(int)offsetof(Sprite_obj,x),HX_CSTRING("x")},
	{hx::fsFloat,(int)offsetof(Sprite_obj,y),HX_CSTRING("y")},
	{hx::fsFloat,(int)offsetof(Sprite_obj,scaleX),HX_CSTRING("scaleX")},
	{hx::fsFloat,(int)offsetof(Sprite_obj,scaleY),HX_CSTRING("scaleY")},
	{hx::fsFloat,(int)offsetof(Sprite_obj,skewX),HX_CSTRING("skewX")},
	{hx::fsFloat,(int)offsetof(Sprite_obj,skewY),HX_CSTRING("skewY")},
	{hx::fsFloat,(int)offsetof(Sprite_obj,rotation),HX_CSTRING("rotation")},
	{hx::fsBool,(int)offsetof(Sprite_obj,visible),HX_CSTRING("visible")},
	{hx::fsFloat,(int)offsetof(Sprite_obj,matA),HX_CSTRING("matA")},
	{hx::fsFloat,(int)offsetof(Sprite_obj,matB),HX_CSTRING("matB")},
	{hx::fsFloat,(int)offsetof(Sprite_obj,matC),HX_CSTRING("matC")},
	{hx::fsFloat,(int)offsetof(Sprite_obj,matD),HX_CSTRING("matD")},
	{hx::fsFloat,(int)offsetof(Sprite_obj,absX),HX_CSTRING("absX")},
	{hx::fsFloat,(int)offsetof(Sprite_obj,absY),HX_CSTRING("absY")},
	{hx::fsBool,(int)offsetof(Sprite_obj,posChanged),HX_CSTRING("posChanged")},
	{hx::fsBool,(int)offsetof(Sprite_obj,allocated),HX_CSTRING("allocated")},
	{hx::fsInt,(int)offsetof(Sprite_obj,lastFrame),HX_CSTRING("lastFrame")},
	{hx::fsObject /*::h2d::Matrix*/ ,(int)offsetof(Sprite_obj,pixSpaceMatrix),HX_CSTRING("pixSpaceMatrix")},
	{hx::fsFloat,(int)offsetof(Sprite_obj,mouseX),HX_CSTRING("mouseX")},
	{hx::fsFloat,(int)offsetof(Sprite_obj,mouseY),HX_CSTRING("mouseY")},
	{hx::fsFloat,(int)offsetof(Sprite_obj,width),HX_CSTRING("width")},
	{hx::fsFloat,(int)offsetof(Sprite_obj,height),HX_CSTRING("height")},
	{hx::fsObject /*::hxd::Stage*/ ,(int)offsetof(Sprite_obj,stage),HX_CSTRING("stage")},
	{hx::fsObject /*::flash::display::Stage*/ ,(int)offsetof(Sprite_obj,flashStage),HX_CSTRING("flashStage")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("name"),
	HX_CSTRING("childs"),
	HX_CSTRING("parent"),
	HX_CSTRING("x"),
	HX_CSTRING("y"),
	HX_CSTRING("scaleX"),
	HX_CSTRING("scaleY"),
	HX_CSTRING("skewX"),
	HX_CSTRING("skewY"),
	HX_CSTRING("rotation"),
	HX_CSTRING("visible"),
	HX_CSTRING("matA"),
	HX_CSTRING("matB"),
	HX_CSTRING("matC"),
	HX_CSTRING("matD"),
	HX_CSTRING("absX"),
	HX_CSTRING("absY"),
	HX_CSTRING("posChanged"),
	HX_CSTRING("allocated"),
	HX_CSTRING("lastFrame"),
	HX_CSTRING("pixSpaceMatrix"),
	HX_CSTRING("mouseX"),
	HX_CSTRING("mouseY"),
	HX_CSTRING("width"),
	HX_CSTRING("height"),
	HX_CSTRING("stage"),
	HX_CSTRING("getSpritesCount"),
	HX_CSTRING("set_posChanged"),
	HX_CSTRING("localToGlobal"),
	HX_CSTRING("globalToLocal"),
	HX_CSTRING("getScene"),
	HX_CSTRING("addChild"),
	HX_CSTRING("addChildAt"),
	HX_CSTRING("onParentChanged"),
	HX_CSTRING("onAlloc"),
	HX_CSTRING("onDelete"),
	HX_CSTRING("removeChild"),
	HX_CSTRING("removeAllChildren"),
	HX_CSTRING("remove"),
	HX_CSTRING("draw"),
	HX_CSTRING("cachePixSpaceMatrix"),
	HX_CSTRING("sync"),
	HX_CSTRING("syncPos"),
	HX_CSTRING("getPixSpaceMatrix"),
	HX_CSTRING("calcAbsPos"),
	HX_CSTRING("drawRec"),
	HX_CSTRING("set_x"),
	HX_CSTRING("set_y"),
	HX_CSTRING("set_scaleX"),
	HX_CSTRING("set_scaleY"),
	HX_CSTRING("set_skewX"),
	HX_CSTRING("set_skewY"),
	HX_CSTRING("set_rotation"),
	HX_CSTRING("move"),
	HX_CSTRING("setPos"),
	HX_CSTRING("rotate"),
	HX_CSTRING("scale"),
	HX_CSTRING("setScale"),
	HX_CSTRING("getChildAt"),
	HX_CSTRING("getChildIndex"),
	HX_CSTRING("toBack"),
	HX_CSTRING("toFront"),
	HX_CSTRING("setChildIndex"),
	HX_CSTRING("get_numChildren"),
	HX_CSTRING("iterator"),
	HX_CSTRING("getMyBounds"),
	HX_CSTRING("getChildrenBounds"),
	HX_CSTRING("set_width"),
	HX_CSTRING("set_height"),
	HX_CSTRING("get_width"),
	HX_CSTRING("get_height"),
	HX_CSTRING("getBounds"),
	HX_CSTRING("flashStage"),
	HX_CSTRING("get_flashStage"),
	HX_CSTRING("get_stage"),
	HX_CSTRING("detach"),
	HX_CSTRING("dispose"),
	HX_CSTRING("get_mouseX"),
	HX_CSTRING("get_mouseY"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Sprite_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Sprite_obj::__mClass,"__mClass");
};

#endif

Class Sprite_obj::__mClass;

void Sprite_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.Sprite"), hx::TCanCast< Sprite_obj> ,sStaticFields,sMemberFields,
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

void Sprite_obj::__boot()
{
}

} // end namespace h2d
