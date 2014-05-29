#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_flash_display_BitmapData
#include <flash/display/BitmapData.h>
#endif
#ifndef INCLUDED_flash_display_BlendMode
#include <flash/display/BlendMode.h>
#endif
#ifndef INCLUDED_flash_display_DisplayObject
#include <flash/display/DisplayObject.h>
#endif
#ifndef INCLUDED_flash_display_IBitmapDrawable
#include <flash/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_flash_events_EventDispatcher
#include <flash/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_flash_events_IEventDispatcher
#include <flash/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_flash_geom_ColorTransform
#include <flash/geom/ColorTransform.h>
#endif
#ifndef INCLUDED_flash_geom_Matrix
#include <flash/geom/Matrix.h>
#endif
#ifndef INCLUDED_flash_geom_Point
#include <flash/geom/Point.h>
#endif
#ifndef INCLUDED_flash_geom_Rectangle
#include <flash/geom/Rectangle.h>
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
#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
#endif
#ifndef INCLUDED_h3d_impl_MemoryManager
#include <h3d/impl/MemoryManager.h>
#endif
#ifndef INCLUDED_h3d_mat_Texture
#include <h3d/mat/Texture.h>
#endif
#ifndef INCLUDED_haxe_Log
#include <haxe/Log.h>
#endif
#ifndef INCLUDED_haxe_Timer
#include <haxe/Timer.h>
#endif
#ifndef INCLUDED_haxe_ds_IntMap
#include <haxe/ds/IntMap.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_hxd_Pixels
#include <hxd/Pixels.h>
#endif
#ifndef INCLUDED_hxd_Profiler
#include <hxd/Profiler.h>
#endif
#ifndef INCLUDED_hxd_System
#include <hxd/System.h>
#endif
namespace h2d{

Void Tile_obj::__construct(::h3d::mat::Texture tex,int x,int y,int w,int h,hx::Null< int >  __o_dx,hx::Null< int >  __o_dy)
{
HX_STACK_FRAME("h2d.Tile","new",0x2d4783d4,"h2d.Tile.new","h2d/Tile.hx",43,0xe227443b)
HX_STACK_THIS(this)
HX_STACK_ARG(tex,"tex")
HX_STACK_ARG(x,"x")
HX_STACK_ARG(y,"y")
HX_STACK_ARG(w,"w")
HX_STACK_ARG(h,"h")
HX_STACK_ARG(__o_dx,"dx")
HX_STACK_ARG(__o_dy,"dy")
int dx = __o_dx.Default(0);
int dy = __o_dy.Default(0);
{
	HX_STACK_LINE(44)
	this->innerTex = tex;
	HX_STACK_LINE(45)
	this->x = x;
	HX_STACK_LINE(46)
	this->y = y;
	HX_STACK_LINE(47)
	this->width = w;
	HX_STACK_LINE(48)
	this->height = h;
	HX_STACK_LINE(49)
	this->dx = dx;
	HX_STACK_LINE(50)
	this->dy = dy;
	HX_STACK_LINE(51)
	if (((tex != null()))){
		HX_STACK_LINE(51)
		this->setTexture(tex);
	}
}
;
	return null();
}

//Tile_obj::~Tile_obj() { }

Dynamic Tile_obj::__CreateEmpty() { return  new Tile_obj; }
hx::ObjectPtr< Tile_obj > Tile_obj::__new(::h3d::mat::Texture tex,int x,int y,int w,int h,hx::Null< int >  __o_dx,hx::Null< int >  __o_dy)
{  hx::ObjectPtr< Tile_obj > result = new Tile_obj();
	result->__construct(tex,x,y,w,h,__o_dx,__o_dy);
	return result;}

Dynamic Tile_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Tile_obj > result = new Tile_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4],inArgs[5],inArgs[6]);
	return result;}

::h3d::mat::Texture Tile_obj::getTexture( ){
	HX_STACK_FRAME("h2d.Tile","getTexture",0xc656b1f1,"h2d.Tile.getTexture","h2d/Tile.hx",148,0xe227443b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(149)
	if (((  ((!(((this->innerTex == null()))))) ? bool(this->innerTex->isDisposed()) : bool(true) ))){
		HX_STACK_LINE(150)
		return ::h2d::Tools_obj::getCoreObjects()->getEmptyTexture();
	}
	HX_STACK_LINE(151)
	return this->innerTex;
}


HX_DEFINE_DYNAMIC_FUNC0(Tile_obj,getTexture,return )

bool Tile_obj::isDisposed( ){
	HX_STACK_FRAME("h2d.Tile","isDisposed",0x7a677ffb,"h2d.Tile.isDisposed","h2d/Tile.hx",155,0xe227443b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(155)
	if ((!(((this->innerTex == null()))))){
		HX_STACK_LINE(155)
		return this->innerTex->isDisposed();
	}
	else{
		HX_STACK_LINE(155)
		return true;
	}
	HX_STACK_LINE(155)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC0(Tile_obj,isDisposed,return )

Void Tile_obj::setTexture( ::h3d::mat::Texture tex){
{
		HX_STACK_FRAME("h2d.Tile","setTexture",0xc9d45065,"h2d.Tile.setTexture","h2d/Tile.hx",158,0xe227443b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(tex,"tex")
		HX_STACK_LINE(159)
		this->innerTex = tex;
		HX_STACK_LINE(160)
		if (((tex != null()))){
			HX_STACK_LINE(161)
			this->u = (Float(((this->x + 0.001))) / Float(tex->width));
			HX_STACK_LINE(162)
			this->v = (Float(((this->y + 0.001))) / Float(tex->height));
			HX_STACK_LINE(163)
			this->u2 = (Float((((this->x + this->width) - 0.001))) / Float(tex->width));
			HX_STACK_LINE(164)
			this->v2 = (Float((((this->y + this->height) - 0.001))) / Float(tex->height));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Tile_obj,setTexture,(void))

Void Tile_obj::switchTexture( ::h2d::Tile t){
{
		HX_STACK_FRAME("h2d.Tile","switchTexture",0x02f299bb,"h2d.Tile.switchTexture","h2d/Tile.hx",169,0xe227443b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(t,"t")
		HX_STACK_LINE(169)
		this->setTexture(t->innerTex);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Tile_obj,switchTexture,(void))

::h2d::Tile Tile_obj::sub( int x,int y,int w,int h,hx::Null< int >  __o_dx,hx::Null< int >  __o_dy){
int dx = __o_dx.Default(0);
int dy = __o_dy.Default(0);
	HX_STACK_FRAME("h2d.Tile","sub",0x2d4b5cf4,"h2d.Tile.sub","h2d/Tile.hx",177,0xe227443b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(x,"x")
	HX_STACK_ARG(y,"y")
	HX_STACK_ARG(w,"w")
	HX_STACK_ARG(h,"h")
	HX_STACK_ARG(dx,"dx")
	HX_STACK_ARG(dy,"dy")
{
		HX_STACK_LINE(177)
		return ::h2d::Tile_obj::__new(this->innerTex,(this->x + x),(this->y + y),w,h,dx,dy);
	}
}


HX_DEFINE_DYNAMIC_FUNC6(Tile_obj,sub,return )

::h2d::Tile Tile_obj::center( Dynamic dx,Dynamic dy){
	HX_STACK_FRAME("h2d.Tile","center",0xd0a612e1,"h2d.Tile.center","h2d/Tile.hx",186,0xe227443b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(dx,"dx")
	HX_STACK_ARG(dy,"dy")
	HX_STACK_LINE(187)
	if (((dx == null()))){
		HX_STACK_LINE(187)
		dx = (int(this->width) >> int((int)1));
	}
	HX_STACK_LINE(188)
	if (((dy == null()))){
		HX_STACK_LINE(188)
		dy = (int(this->height) >> int((int)1));
	}
	HX_STACK_LINE(189)
	return this->sub((int)0,(int)0,this->width,this->height,-(dx),-(dy));
}


HX_DEFINE_DYNAMIC_FUNC2(Tile_obj,center,return )

::h2d::Tile Tile_obj::centerRatio( Dynamic __o_px,Dynamic __o_py){
Dynamic px = __o_px.Default(0.5);
Dynamic py = __o_py.Default(0.5);
	HX_STACK_FRAME("h2d.Tile","centerRatio",0xefb6826a,"h2d.Tile.centerRatio","h2d/Tile.hx",192,0xe227443b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(px,"px")
	HX_STACK_ARG(py,"py")
{
		HX_STACK_LINE(193)
		int _g = -(::Std_obj::_int((px * this->width)));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(193)
		int _g1 = -(::Std_obj::_int((py * this->height)));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(193)
		return this->sub((int)0,(int)0,this->width,this->height,_g,_g1);
	}
}


HX_DEFINE_DYNAMIC_FUNC2(Tile_obj,centerRatio,return )

Void Tile_obj::setCenter( Dynamic dx,Dynamic dy){
{
		HX_STACK_FRAME("h2d.Tile","setCenter",0xa4785d8b,"h2d.Tile.setCenter","h2d/Tile.hx",197,0xe227443b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(dx,"dx")
		HX_STACK_ARG(dy,"dy")
		HX_STACK_LINE(197)
		::h2d::Tile _g;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(197)
		{
			HX_STACK_LINE(197)
			Dynamic dx1 = dx;		HX_STACK_VAR(dx1,"dx1");
			HX_STACK_LINE(197)
			Dynamic dy1 = dy;		HX_STACK_VAR(dy1,"dy1");
			HX_STACK_LINE(197)
			if (((dx1 == null()))){
				HX_STACK_LINE(197)
				dx1 = (int(this->width) >> int((int)1));
			}
			HX_STACK_LINE(197)
			if (((dy1 == null()))){
				HX_STACK_LINE(197)
				dy1 = (int(this->height) >> int((int)1));
			}
			HX_STACK_LINE(197)
			_g = this->sub((int)0,(int)0,this->width,this->height,-(dx1),-(dy1));
		}
		HX_STACK_LINE(197)
		this->copy(_g);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Tile_obj,setCenter,(void))

Void Tile_obj::setCenterRatio( Dynamic __o_px,Dynamic __o_py){
Dynamic px = __o_px.Default(0.5);
Dynamic py = __o_py.Default(0.5);
	HX_STACK_FRAME("h2d.Tile","setCenterRatio",0x64034f80,"h2d.Tile.setCenterRatio","h2d/Tile.hx",200,0xe227443b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(px,"px")
	HX_STACK_ARG(py,"py")
{
		HX_STACK_LINE(200)
		int _g = -(::Std_obj::_int((px * this->width)));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(200)
		int _g1 = -(::Std_obj::_int((py * this->height)));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(200)
		::h2d::Tile _g2 = this->sub((int)0,(int)0,this->width,this->height,_g,_g1);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(200)
		this->copy(_g2);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Tile_obj,setCenterRatio,(void))

Void Tile_obj::setPos( int x,int y){
{
		HX_STACK_FRAME("h2d.Tile","setPos",0x3a37d81e,"h2d.Tile.setPos","h2d/Tile.hx",202,0xe227443b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_LINE(203)
		this->x = x;
		HX_STACK_LINE(204)
		this->y = y;
		HX_STACK_LINE(205)
		::h3d::mat::Texture tex = this->innerTex;		HX_STACK_VAR(tex,"tex");
		HX_STACK_LINE(206)
		if (((tex != null()))){
			HX_STACK_LINE(207)
			this->u = (Float(((x + 0.001))) / Float(tex->width));
			HX_STACK_LINE(208)
			this->v = (Float(((y + 0.001))) / Float(tex->height));
			HX_STACK_LINE(209)
			this->u2 = (Float((((this->width + x) - 0.001))) / Float(tex->width));
			HX_STACK_LINE(210)
			this->v2 = (Float((((this->height + y) - 0.001))) / Float(tex->height));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Tile_obj,setPos,(void))

Void Tile_obj::setSize( int w,int h){
{
		HX_STACK_FRAME("h2d.Tile","setSize",0xb89c5ef7,"h2d.Tile.setSize","h2d/Tile.hx",214,0xe227443b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(w,"w")
		HX_STACK_ARG(h,"h")
		HX_STACK_LINE(215)
		this->width = w;
		HX_STACK_LINE(216)
		this->height = h;
		HX_STACK_LINE(217)
		::h3d::mat::Texture tex = this->innerTex;		HX_STACK_VAR(tex,"tex");
		HX_STACK_LINE(218)
		if (((tex != null()))){
			HX_STACK_LINE(219)
			this->u2 = (Float((((w + this->x) - 0.001))) / Float(tex->width));
			HX_STACK_LINE(220)
			this->v2 = (Float((((h + this->y) - 0.001))) / Float(tex->height));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Tile_obj,setSize,(void))

Void Tile_obj::scaleToSize( int w,int h){
{
		HX_STACK_FRAME("h2d.Tile","scaleToSize",0xa7d3197a,"h2d.Tile.scaleToSize","h2d/Tile.hx",224,0xe227443b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(w,"w")
		HX_STACK_ARG(h,"h")
		HX_STACK_LINE(225)
		this->width = w;
		HX_STACK_LINE(226)
		this->height = h;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Tile_obj,scaleToSize,(void))

Void Tile_obj::scrollDiscrete( Float dx,Float dy){
{
		HX_STACK_FRAME("h2d.Tile","scrollDiscrete",0x3fa153f2,"h2d.Tile.scrollDiscrete","h2d/Tile.hx",229,0xe227443b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(dx,"dx")
		HX_STACK_ARG(dy,"dy")
		HX_STACK_LINE(230)
		::h3d::mat::Texture tex = this->innerTex;		HX_STACK_VAR(tex,"tex");
		HX_STACK_LINE(231)
		hx::AddEq(this->u,(Float(dx) / Float(tex->width)));
		HX_STACK_LINE(232)
		hx::SubEq(this->v,(Float(dy) / Float(tex->height)));
		HX_STACK_LINE(233)
		hx::AddEq(this->u2,(Float(dx) / Float(tex->width)));
		HX_STACK_LINE(234)
		hx::SubEq(this->v2,(Float(dy) / Float(tex->height)));
		HX_STACK_LINE(235)
		int _g = ::Std_obj::_int((this->u * tex->width));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(235)
		this->x = _g;
		HX_STACK_LINE(236)
		int _g1 = ::Std_obj::_int((this->v * tex->height));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(236)
		this->y = _g1;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Tile_obj,scrollDiscrete,(void))

Void Tile_obj::flipX( ){
{
		HX_STACK_FRAME("h2d.Tile","flipX",0x1a70bd7f,"h2d.Tile.flipX","h2d/Tile.hx",239,0xe227443b)
		HX_STACK_THIS(this)
		HX_STACK_LINE(240)
		Float tu = this->u2;		HX_STACK_VAR(tu,"tu");
		HX_STACK_LINE(241)
		this->u2 = this->u;
		HX_STACK_LINE(242)
		this->u = tu;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Tile_obj,flipX,(void))

Void Tile_obj::flipY( ){
{
		HX_STACK_FRAME("h2d.Tile","flipY",0x1a70bd80,"h2d.Tile.flipY","h2d/Tile.hx",245,0xe227443b)
		HX_STACK_THIS(this)
		HX_STACK_LINE(246)
		Float tv = this->v2;		HX_STACK_VAR(tv,"tv");
		HX_STACK_LINE(247)
		this->v2 = this->v;
		HX_STACK_LINE(248)
		this->v = tv;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Tile_obj,flipY,(void))

Void Tile_obj::dispose( ){
{
		HX_STACK_FRAME("h2d.Tile","dispose",0x6210fe13,"h2d.Tile.dispose","h2d/Tile.hx",251,0xe227443b)
		HX_STACK_THIS(this)
		HX_STACK_LINE(252)
		if (((this->innerTex != null()))){
			HX_STACK_LINE(252)
			this->innerTex->dispose();
		}
		HX_STACK_LINE(253)
		this->innerTex = null();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Tile_obj,dispose,(void))

::h2d::Tile Tile_obj::clone( ){
	HX_STACK_FRAME("h2d.Tile","clone",0x60418bd1,"h2d.Tile.clone","h2d/Tile.hx",256,0xe227443b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(257)
	::h2d::Tile t = ::h2d::Tile_obj::__new(null(),this->x,this->y,this->width,this->height,this->dx,this->dy);		HX_STACK_VAR(t,"t");
	HX_STACK_LINE(258)
	t->innerTex = this->innerTex;
	HX_STACK_LINE(259)
	t->u = this->u;
	HX_STACK_LINE(260)
	t->u2 = this->u2;
	HX_STACK_LINE(261)
	t->v = this->v;
	HX_STACK_LINE(262)
	t->v2 = this->v2;
	HX_STACK_LINE(263)
	return t;
}


HX_DEFINE_DYNAMIC_FUNC0(Tile_obj,clone,return )

::h2d::Tile Tile_obj::copy( ::h2d::Tile t){
	HX_STACK_FRAME("h2d.Tile","copy",0x6a0e0dc1,"h2d.Tile.copy","h2d/Tile.hx",266,0xe227443b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(t,"t")
	HX_STACK_LINE(267)
	this->innerTex = t->innerTex;
	HX_STACK_LINE(268)
	this->u = t->u;
	HX_STACK_LINE(269)
	this->u2 = t->u2;
	HX_STACK_LINE(270)
	this->v = t->v;
	HX_STACK_LINE(271)
	this->v2 = t->v2;
	HX_STACK_LINE(272)
	this->dx = t->dx;
	HX_STACK_LINE(273)
	this->dy = t->dy;
	HX_STACK_LINE(274)
	return t;
}


HX_DEFINE_DYNAMIC_FUNC1(Tile_obj,copy,return )

Array< ::Dynamic > Tile_obj::split( int frames,hx::Null< bool >  __o_vertical){
bool vertical = __o_vertical.Default(false);
	HX_STACK_FRAME("h2d.Tile","split",0x994d634e,"h2d.Tile.split","h2d/Tile.hx",278,0xe227443b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(frames,"frames")
	HX_STACK_ARG(vertical,"vertical")
{
		HX_STACK_LINE(279)
		Array< ::Dynamic > tl = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(tl,"tl");
		HX_STACK_LINE(280)
		if ((vertical)){
			HX_STACK_LINE(281)
			int stride = ::Std_obj::_int((Float(this->height) / Float(frames)));		HX_STACK_VAR(stride,"stride");
			HX_STACK_LINE(282)
			{
				HX_STACK_LINE(282)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(282)
				while((true)){
					HX_STACK_LINE(282)
					if ((!(((_g < frames))))){
						HX_STACK_LINE(282)
						break;
					}
					HX_STACK_LINE(282)
					int i = (_g)++;		HX_STACK_VAR(i,"i");
					HX_STACK_LINE(283)
					::h2d::Tile _g1 = this->sub((int)0,(i * stride),this->width,stride,null(),null());		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(283)
					tl->push(_g1);
				}
			}
		}
		else{
			HX_STACK_LINE(285)
			int stride = ::Std_obj::_int((Float(this->width) / Float(frames)));		HX_STACK_VAR(stride,"stride");
			HX_STACK_LINE(286)
			{
				HX_STACK_LINE(286)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(286)
				while((true)){
					HX_STACK_LINE(286)
					if ((!(((_g < frames))))){
						HX_STACK_LINE(286)
						break;
					}
					HX_STACK_LINE(286)
					int i = (_g)++;		HX_STACK_VAR(i,"i");
					HX_STACK_LINE(287)
					::h2d::Tile _g1 = this->sub((i * stride),(int)0,stride,this->height,null(),null());		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(287)
					tl->push(_g1);
				}
			}
		}
		HX_STACK_LINE(289)
		return tl;
	}
}


HX_DEFINE_DYNAMIC_FUNC2(Tile_obj,split,return )

::String Tile_obj::toString( ){
	HX_STACK_FRAME("h2d.Tile","toString",0x7d9818b8,"h2d.Tile.toString","h2d/Tile.hx",293,0xe227443b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(293)
	return (((((((((HX_CSTRING("Tile(") + this->x) + HX_CSTRING(",")) + this->y) + HX_CSTRING(",")) + this->width) + HX_CSTRING("x")) + this->height) + ((  (((bool((this->dx != (int)0)) || bool((this->dy != (int)0))))) ? ::String((((HX_CSTRING(",") + this->dx) + HX_CSTRING(":")) + this->dy)) : ::String(HX_CSTRING("")) ))) + HX_CSTRING(")"));
}


HX_DEFINE_DYNAMIC_FUNC0(Tile_obj,toString,return )

Void Tile_obj::upload( ::flash::display::BitmapData bmp){
{
		HX_STACK_FRAME("h2d.Tile","upload",0x5724b70d,"h2d.Tile.upload","h2d/Tile.hx",296,0xe227443b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(bmp,"bmp")
		HX_STACK_LINE(297)
		{
			HX_STACK_LINE(297)
			::String pos_fileName = HX_CSTRING("Tile.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
			HX_STACK_LINE(297)
			int pos_lineNumber = (int)297;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
			HX_STACK_LINE(297)
			::String pos_className = HX_CSTRING("h2d.Tile");		HX_STACK_VAR(pos_className,"pos_className");
			HX_STACK_LINE(297)
			::String pos_methodName = HX_CSTRING("upload");		HX_STACK_VAR(pos_methodName,"pos_methodName");
			HX_STACK_LINE(297)
			if (((::hxd::System_obj::debugLevel >= (int)3))){
				HX_STACK_LINE(297)
				::String _g = HX_CSTRING("uploading from tile ");		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(297)
				::String _g1 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g);		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(297)
				::haxe::Log_obj::trace(_g1,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
			}
			HX_STACK_LINE(297)
			HX_CSTRING("uploading from tile ");
		}
		HX_STACK_LINE(299)
		int w = this->innerTex->width;		HX_STACK_VAR(w,"w");
		HX_STACK_LINE(300)
		int h = this->innerTex->height;		HX_STACK_VAR(h,"h");
		HX_STACK_LINE(303)
		int _g2 = bmp->get_width();		HX_STACK_VAR(_g2,"_g2");
		struct _Function_1_1{
			inline static bool Block( ::flash::display::BitmapData &bmp,int &h){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h2d/Tile.hx",303,0xe227443b)
				{
					HX_STACK_LINE(303)
					int _g3 = bmp->get_height();		HX_STACK_VAR(_g3,"_g3");
					HX_STACK_LINE(303)
					return (h != _g3);
				}
				return null();
			}
		};
		HX_STACK_LINE(303)
		if (((  ((!(((w != _g2))))) ? bool(_Function_1_1::Block(bmp,h)) : bool(true) ))){
			HX_STACK_LINE(304)
			{
				HX_STACK_LINE(304)
				int _g4 = bmp->get_width();		HX_STACK_VAR(_g4,"_g4");
				HX_STACK_LINE(304)
				::String _g5 = (((((HX_CSTRING("Resizing to final tex size ") + w) + HX_CSTRING(" ")) + h) + HX_CSTRING(" <> ")) + _g4);		HX_STACK_VAR(_g5,"_g5");
				HX_STACK_LINE(304)
				::String _g6 = (_g5 + HX_CSTRING(" "));		HX_STACK_VAR(_g6,"_g6");
				HX_STACK_LINE(304)
				int _g7 = bmp->get_height();		HX_STACK_VAR(_g7,"_g7");
				HX_STACK_LINE(304)
				Dynamic msg = (_g6 + _g7);		HX_STACK_VAR(msg,"msg");
				HX_STACK_LINE(304)
				::String pos_fileName = HX_CSTRING("Tile.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
				HX_STACK_LINE(304)
				int pos_lineNumber = (int)304;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
				HX_STACK_LINE(304)
				::String pos_className = HX_CSTRING("h2d.Tile");		HX_STACK_VAR(pos_className,"pos_className");
				HX_STACK_LINE(304)
				::String pos_methodName = HX_CSTRING("upload");		HX_STACK_VAR(pos_methodName,"pos_methodName");
				HX_STACK_LINE(304)
				if (((::hxd::System_obj::debugLevel >= (int)1))){
					HX_STACK_LINE(304)
					::String _g8 = ::Std_obj::string(msg);		HX_STACK_VAR(_g8,"_g8");
					HX_STACK_LINE(304)
					::String _g9 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g8);		HX_STACK_VAR(_g9,"_g9");
					HX_STACK_LINE(304)
					::haxe::Log_obj::trace(_g9,hx::SourceInfo(HX_CSTRING("System.hx"),305,HX_CSTRING("hxd.System"),HX_CSTRING("trace1")));
				}
				HX_STACK_LINE(304)
				msg;
			}
			HX_STACK_LINE(305)
			::flash::display::BitmapData bmp2 = ::flash::display::BitmapData_obj::__new(w,h,true,(int)0,null());		HX_STACK_VAR(bmp2,"bmp2");
			HX_STACK_LINE(306)
			::flash::geom::Point p0 = ::flash::geom::Point_obj::__new((int)0,(int)0);		HX_STACK_VAR(p0,"p0");
			HX_STACK_LINE(307)
			::flash::display::BitmapData bmp1 = bmp;		HX_STACK_VAR(bmp1,"bmp1");
			HX_STACK_LINE(308)
			{
				HX_STACK_LINE(308)
				::String pos_fileName = HX_CSTRING("Tile.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
				HX_STACK_LINE(308)
				int pos_lineNumber = (int)308;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
				HX_STACK_LINE(308)
				::String pos_className = HX_CSTRING("h2d.Tile");		HX_STACK_VAR(pos_className,"pos_className");
				HX_STACK_LINE(308)
				::String pos_methodName = HX_CSTRING("upload");		HX_STACK_VAR(pos_methodName,"pos_methodName");
				HX_STACK_LINE(308)
				if (((::hxd::System_obj::debugLevel >= (int)3))){
					HX_STACK_LINE(308)
					::String _g10 = HX_CSTRING("copying pixels");		HX_STACK_VAR(_g10,"_g10");
					HX_STACK_LINE(308)
					::String _g11 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g10);		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(308)
					::haxe::Log_obj::trace(_g11,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
				}
				HX_STACK_LINE(308)
				HX_CSTRING("copying pixels");
			}
			HX_STACK_LINE(309)
			::flash::geom::Rectangle _g12 = bmp1->get_rect();		HX_STACK_VAR(_g12,"_g12");
			HX_STACK_LINE(309)
			bmp2->copyPixels(bmp1,_g12,p0,bmp1,p0,true);
			HX_STACK_LINE(310)
			{
				HX_STACK_LINE(310)
				::String pos_fileName = HX_CSTRING("Tile.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
				HX_STACK_LINE(310)
				int pos_lineNumber = (int)310;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
				HX_STACK_LINE(310)
				::String pos_className = HX_CSTRING("h2d.Tile");		HX_STACK_VAR(pos_className,"pos_className");
				HX_STACK_LINE(310)
				::String pos_methodName = HX_CSTRING("upload");		HX_STACK_VAR(pos_methodName,"pos_methodName");
				HX_STACK_LINE(310)
				if (((::hxd::System_obj::debugLevel >= (int)3))){
					HX_STACK_LINE(310)
					::String _g13 = HX_CSTRING("uploading dual bitmap");		HX_STACK_VAR(_g13,"_g13");
					HX_STACK_LINE(310)
					::String _g14 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g13);		HX_STACK_VAR(_g14,"_g14");
					HX_STACK_LINE(310)
					::haxe::Log_obj::trace(_g14,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
				}
				HX_STACK_LINE(310)
				HX_CSTRING("uploading dual bitmap");
			}
			HX_STACK_LINE(311)
			this->innerTex->uploadBitmap(bmp2,null(),null());
			HX_STACK_LINE(312)
			{
				HX_STACK_LINE(312)
				::String pos_fileName = HX_CSTRING("Tile.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
				HX_STACK_LINE(312)
				int pos_lineNumber = (int)312;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
				HX_STACK_LINE(312)
				::String pos_className = HX_CSTRING("h2d.Tile");		HX_STACK_VAR(pos_className,"pos_className");
				HX_STACK_LINE(312)
				::String pos_methodName = HX_CSTRING("upload");		HX_STACK_VAR(pos_methodName,"pos_methodName");
				HX_STACK_LINE(312)
				if (((::hxd::System_obj::debugLevel >= (int)3))){
					HX_STACK_LINE(312)
					::String _g15 = HX_CSTRING("uploaded bitmap");		HX_STACK_VAR(_g15,"_g15");
					HX_STACK_LINE(312)
					::String _g16 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g15);		HX_STACK_VAR(_g16,"_g16");
					HX_STACK_LINE(312)
					::haxe::Log_obj::trace(_g16,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
				}
				HX_STACK_LINE(312)
				HX_CSTRING("uploaded bitmap");
			}
			HX_STACK_LINE(313)
			bmp2->dispose();
			HX_STACK_LINE(314)
			bmp2 = null();
		}
		else{
			HX_STACK_LINE(319)
			{
				HX_STACK_LINE(319)
				::String pos_fileName = HX_CSTRING("Tile.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
				HX_STACK_LINE(319)
				int pos_lineNumber = (int)319;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
				HX_STACK_LINE(319)
				::String pos_className = HX_CSTRING("h2d.Tile");		HX_STACK_VAR(pos_className,"pos_className");
				HX_STACK_LINE(319)
				::String pos_methodName = HX_CSTRING("upload");		HX_STACK_VAR(pos_methodName,"pos_methodName");
				HX_STACK_LINE(319)
				if (((::hxd::System_obj::debugLevel >= (int)3))){
					HX_STACK_LINE(319)
					::String _g17 = HX_CSTRING("uploading bitmap");		HX_STACK_VAR(_g17,"_g17");
					HX_STACK_LINE(319)
					::String _g18 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g17);		HX_STACK_VAR(_g18,"_g18");
					HX_STACK_LINE(319)
					::haxe::Log_obj::trace(_g18,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
				}
				HX_STACK_LINE(319)
				HX_CSTRING("uploading bitmap");
			}
			HX_STACK_LINE(320)
			this->innerTex->uploadBitmap(bmp,null(),null());
			HX_STACK_LINE(321)
			{
				HX_STACK_LINE(321)
				::String pos_fileName = HX_CSTRING("Tile.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
				HX_STACK_LINE(321)
				int pos_lineNumber = (int)321;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
				HX_STACK_LINE(321)
				::String pos_className = HX_CSTRING("h2d.Tile");		HX_STACK_VAR(pos_className,"pos_className");
				HX_STACK_LINE(321)
				::String pos_methodName = HX_CSTRING("upload");		HX_STACK_VAR(pos_methodName,"pos_methodName");
				HX_STACK_LINE(321)
				if (((::hxd::System_obj::debugLevel >= (int)3))){
					HX_STACK_LINE(321)
					::String _g19 = HX_CSTRING("uploaded bitmap");		HX_STACK_VAR(_g19,"_g19");
					HX_STACK_LINE(321)
					::String _g20 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g19);		HX_STACK_VAR(_g20,"_g20");
					HX_STACK_LINE(321)
					::haxe::Log_obj::trace(_g20,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
				}
				HX_STACK_LINE(321)
				HX_CSTRING("uploaded bitmap");
			}
		}
		HX_STACK_LINE(323)
		{
			HX_STACK_LINE(323)
			::String pos_fileName = HX_CSTRING("Tile.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
			HX_STACK_LINE(323)
			int pos_lineNumber = (int)323;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
			HX_STACK_LINE(323)
			::String pos_className = HX_CSTRING("h2d.Tile");		HX_STACK_VAR(pos_className,"pos_className");
			HX_STACK_LINE(323)
			::String pos_methodName = HX_CSTRING("upload");		HX_STACK_VAR(pos_methodName,"pos_methodName");
			HX_STACK_LINE(323)
			if (((::hxd::System_obj::debugLevel >= (int)2))){
				HX_STACK_LINE(323)
				::String _g21 = HX_CSTRING("tile upload done");		HX_STACK_VAR(_g21,"_g21");
				HX_STACK_LINE(323)
				::String _g22 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g21);		HX_STACK_VAR(_g22,"_g22");
				HX_STACK_LINE(323)
				::haxe::Log_obj::trace(_g22,hx::SourceInfo(HX_CSTRING("System.hx"),315,HX_CSTRING("hxd.System"),HX_CSTRING("trace2")));
			}
			HX_STACK_LINE(323)
			HX_CSTRING("tile upload done");
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Tile_obj,upload,(void))

Float Tile_obj::EPSILON_PIXEL;

::h2d::Tile Tile_obj::fromFlashBitmap( ::flash::display::BitmapData bmp,Dynamic allocPos){
	HX_STACK_FRAME("h2d.Tile","fromFlashBitmap",0xd08ca5e9,"h2d.Tile.fromFlashBitmap","h2d/Tile.hx",56,0xe227443b)
	HX_STACK_ARG(bmp,"bmp")
	HX_STACK_ARG(allocPos,"allocPos")
	HX_STACK_LINE(56)
	return ::h2d::Tile_obj::fromBitmap(bmp,allocPos);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Tile_obj,fromFlashBitmap,return )

::h2d::Tile Tile_obj::fromBitmap( ::flash::display::BitmapData bmp,Dynamic allocPos){
	HX_STACK_FRAME("h2d.Tile","fromBitmap",0x0c647805,"h2d.Tile.fromBitmap","h2d/Tile.hx",60,0xe227443b)
	HX_STACK_ARG(bmp,"bmp")
	HX_STACK_ARG(allocPos,"allocPos")
	HX_STACK_LINE(61)
	{
		HX_STACK_LINE(61)
		::String pos_fileName = HX_CSTRING("Tile.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
		HX_STACK_LINE(61)
		int pos_lineNumber = (int)61;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
		HX_STACK_LINE(61)
		::String pos_className = HX_CSTRING("h2d.Tile");		HX_STACK_VAR(pos_className,"pos_className");
		HX_STACK_LINE(61)
		::String pos_methodName = HX_CSTRING("fromBitmap");		HX_STACK_VAR(pos_methodName,"pos_methodName");
		HX_STACK_LINE(61)
		if (((::hxd::System_obj::debugLevel >= (int)3))){
			HX_STACK_LINE(61)
			::String _g = HX_CSTRING("Tile.fromBitmap");		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(61)
			::String _g1 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(61)
			::haxe::Log_obj::trace(_g1,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
		}
		HX_STACK_LINE(61)
		HX_CSTRING("Tile.fromBitmap");
	}
	HX_STACK_LINE(63)
	int w = (int)1;		HX_STACK_VAR(w,"w");
	HX_STACK_LINE(63)
	int h = (int)1;		HX_STACK_VAR(h,"h");
	HX_STACK_LINE(64)
	while((true)){
		HX_STACK_LINE(64)
		int _g2 = bmp->get_width();		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(64)
		if ((!(((w < _g2))))){
			HX_STACK_LINE(64)
			break;
		}
		HX_STACK_LINE(65)
		hx::ShlEq(w,(int)1);
	}
	HX_STACK_LINE(66)
	while((true)){
		HX_STACK_LINE(66)
		int _g3 = bmp->get_height();		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(66)
		if ((!(((h < _g3))))){
			HX_STACK_LINE(66)
			break;
		}
		HX_STACK_LINE(67)
		hx::ShlEq(h,(int)1);
	}
	HX_STACK_LINE(69)
	::h3d::Engine _g4;		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(69)
	{
		HX_STACK_LINE(69)
		if (((::hxd::System_obj::debugLevel >= (int)1))){
			HX_STACK_LINE(69)
			if (((::h3d::Engine_obj::CURRENT == null()))){
				HX_STACK_LINE(69)
				HX_STACK_DO_THROW(HX_CSTRING("no current context, please do this operation after engine init/creation"));
			}
		}
		HX_STACK_LINE(69)
		_g4 = ::h3d::Engine_obj::CURRENT;
	}
	HX_STACK_LINE(69)
	if (((_g4 == null()))){
		struct _Function_2_1{
			inline static Dynamic Block( ){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h2d/Tile.hx",70,0xe227443b)
				{
					HX_STACK_LINE(70)
					::String pos_fileName = HX_CSTRING("Tile.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
					HX_STACK_LINE(70)
					int pos_lineNumber = (int)70;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
					HX_STACK_LINE(70)
					::String pos_className = HX_CSTRING("h2d.Tile");		HX_STACK_VAR(pos_className,"pos_className");
					HX_STACK_LINE(70)
					::String pos_methodName = HX_CSTRING("fromBitmap");		HX_STACK_VAR(pos_methodName,"pos_methodName");
					HX_STACK_LINE(70)
					if (((::hxd::System_obj::debugLevel >= (int)1))){
						HX_STACK_LINE(70)
						::String _g5 = HX_CSTRING("The h3d render context is not ready yet");		HX_STACK_VAR(_g5,"_g5");
						HX_STACK_LINE(70)
						::String _g6 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g5);		HX_STACK_VAR(_g6,"_g6");
						HX_STACK_LINE(70)
						::haxe::Log_obj::trace(_g6,hx::SourceInfo(HX_CSTRING("System.hx"),305,HX_CSTRING("hxd.System"),HX_CSTRING("trace1")));
					}
					HX_STACK_LINE(70)
					return HX_CSTRING("The h3d render context is not ready yet");
				}
				return null();
			}
		};
		HX_STACK_LINE(70)
		HX_STACK_DO_THROW(_Function_2_1::Block());
		HX_STACK_LINE(71)
		return null();
	}
	HX_STACK_LINE(73)
	if ((::hxd::Profiler_obj::enable)){
		HX_STACK_LINE(73)
		Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
		HX_STACK_LINE(73)
		Dynamic ent = ::hxd::Profiler_obj::h->get(HX_CSTRING("alloc tex"));		HX_STACK_VAR(ent,"ent");
		HX_STACK_LINE(73)
		if (((null() == ent))){
			struct _Function_3_1{
				inline static Dynamic Block( ){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h2d/Tile.hx",73,0xe227443b)
					{
						hx::Anon __result = hx::Anon_obj::Create();
						__result->Add(HX_CSTRING("start") , null(),false);
						__result->Add(HX_CSTRING("total") , 0.0,false);
						__result->Add(HX_CSTRING("hit") , (int)0,false);
						return __result;
					}
					return null();
				}
			};
			HX_STACK_LINE(73)
			ent = _Function_3_1::Block();
			HX_STACK_LINE(73)
			::hxd::Profiler_obj::h->set(HX_CSTRING("alloc tex"),ent);
		}
		HX_STACK_LINE(73)
		ent->__FieldRef(HX_CSTRING("start")) = t;
		HX_STACK_LINE(73)
		(ent->__FieldRef(HX_CSTRING("hit")))++;
	}
	struct _Function_1_1{
		inline static ::h3d::Engine Block( ){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h2d/Tile.hx",74,0xe227443b)
			{
				HX_STACK_LINE(74)
				if (((::hxd::System_obj::debugLevel >= (int)1))){
					HX_STACK_LINE(74)
					if (((::h3d::Engine_obj::CURRENT == null()))){
						HX_STACK_LINE(74)
						HX_STACK_DO_THROW(HX_CSTRING("no current context, please do this operation after engine init/creation"));
					}
				}
				HX_STACK_LINE(74)
				return ::h3d::Engine_obj::CURRENT;
			}
			return null();
		}
	};
	HX_STACK_LINE(74)
	::h3d::mat::Texture tex = (_Function_1_1::Block())->mem->allocTexture(w,h,false,allocPos);		HX_STACK_VAR(tex,"tex");
	HX_STACK_LINE(75)
	if ((::hxd::Profiler_obj::enable)){
		HX_STACK_LINE(75)
		Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
		HX_STACK_LINE(75)
		Dynamic ent = ::hxd::Profiler_obj::h->get(HX_CSTRING("alloc tex"));		HX_STACK_VAR(ent,"ent");
		HX_STACK_LINE(75)
		if (((null() != ent))){
			HX_STACK_LINE(75)
			if (((ent->__Field(HX_CSTRING("start"),true) != null()))){
				HX_STACK_LINE(75)
				hx::AddEq(ent->__FieldRef(HX_CSTRING("total")),(t - ent->__Field(HX_CSTRING("start"),true)));
			}
		}
	}
	HX_STACK_LINE(76)
	int _g7 = bmp->get_width();		HX_STACK_VAR(_g7,"_g7");
	HX_STACK_LINE(76)
	int _g8 = bmp->get_height();		HX_STACK_VAR(_g8,"_g8");
	HX_STACK_LINE(76)
	::h2d::Tile t = ::h2d::Tile_obj::__new(tex,(int)0,(int)0,_g7,_g8,null(),null());		HX_STACK_VAR(t,"t");
	HX_STACK_LINE(77)
	if ((::hxd::Profiler_obj::enable)){
		HX_STACK_LINE(77)
		Float t1 = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t1,"t1");
		HX_STACK_LINE(77)
		Dynamic ent = ::hxd::Profiler_obj::h->get(HX_CSTRING("upload tex"));		HX_STACK_VAR(ent,"ent");
		HX_STACK_LINE(77)
		if (((null() == ent))){
			struct _Function_3_1{
				inline static Dynamic Block( ){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h2d/Tile.hx",77,0xe227443b)
					{
						hx::Anon __result = hx::Anon_obj::Create();
						__result->Add(HX_CSTRING("start") , null(),false);
						__result->Add(HX_CSTRING("total") , 0.0,false);
						__result->Add(HX_CSTRING("hit") , (int)0,false);
						return __result;
					}
					return null();
				}
			};
			HX_STACK_LINE(77)
			ent = _Function_3_1::Block();
			HX_STACK_LINE(77)
			::hxd::Profiler_obj::h->set(HX_CSTRING("upload tex"),ent);
		}
		HX_STACK_LINE(77)
		ent->__FieldRef(HX_CSTRING("start")) = t1;
		HX_STACK_LINE(77)
		(ent->__FieldRef(HX_CSTRING("hit")))++;
	}
	HX_STACK_LINE(78)
	t->upload(bmp);
	HX_STACK_LINE(79)
	if ((::hxd::Profiler_obj::enable)){
		HX_STACK_LINE(79)
		Float t1 = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t1,"t1");
		HX_STACK_LINE(79)
		Dynamic ent = ::hxd::Profiler_obj::h->get(HX_CSTRING("upload tex"));		HX_STACK_VAR(ent,"ent");
		HX_STACK_LINE(79)
		if (((null() != ent))){
			HX_STACK_LINE(79)
			if (((ent->__Field(HX_CSTRING("start"),true) != null()))){
				HX_STACK_LINE(79)
				hx::AddEq(ent->__FieldRef(HX_CSTRING("total")),(t1 - ent->__Field(HX_CSTRING("start"),true)));
			}
		}
	}
	HX_STACK_LINE(80)
	return t;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Tile_obj,fromBitmap,return )

::h2d::Tile Tile_obj::fromTexture( ::h3d::mat::Texture t){
	HX_STACK_FRAME("h2d.Tile","fromTexture",0x70e37405,"h2d.Tile.fromTexture","h2d/Tile.hx",84,0xe227443b)
	HX_STACK_ARG(t,"t")
	HX_STACK_LINE(84)
	return ::h2d::Tile_obj::__new(t,(int)0,(int)0,t->width,t->height,null(),null());
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Tile_obj,fromTexture,return )

::h2d::Tile Tile_obj::fromPixels( ::hxd::Pixels pixels,Dynamic allocPos){
	HX_STACK_FRAME("h2d.Tile","fromPixels",0xa8025743,"h2d.Tile.fromPixels","h2d/Tile.hx",87,0xe227443b)
	HX_STACK_ARG(pixels,"pixels")
	HX_STACK_ARG(allocPos,"allocPos")
	HX_STACK_LINE(88)
	::hxd::Pixels pix2 = pixels->makeSquare(true);		HX_STACK_VAR(pix2,"pix2");
	HX_STACK_LINE(89)
	::h3d::mat::Texture t = ::h3d::mat::Texture_obj::fromPixels(pix2,hx::SourceInfo(HX_CSTRING("Tile.hx"),89,HX_CSTRING("h2d.Tile"),HX_CSTRING("fromPixels")));		HX_STACK_VAR(t,"t");
	HX_STACK_LINE(90)
	if (((pix2 != pixels))){
		HX_STACK_LINE(90)
		pix2->dispose();
	}
	HX_STACK_LINE(91)
	return ::h2d::Tile_obj::__new(t,(int)0,(int)0,pixels->width,pixels->height,null(),null());
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Tile_obj,fromPixels,return )

::h2d::Tile Tile_obj::fromSprite( ::flash::display::DisplayObject sprite,Dynamic allocPos){
	HX_STACK_FRAME("h2d.Tile","fromSprite",0xdeee441b,"h2d.Tile.fromSprite","h2d/Tile.hx",98,0xe227443b)
	HX_STACK_ARG(sprite,"sprite")
	HX_STACK_ARG(allocPos,"allocPos")
	HX_STACK_LINE(99)
	Array< ::Dynamic > _g = ::h2d::Tile_obj::fromSprites(Array_obj< ::Dynamic >::__new().Add(sprite),hx::SourceInfo(HX_CSTRING("Tile.hx"),99,HX_CSTRING("h2d.Tile"),HX_CSTRING("fromSprite")));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(99)
	return _g->__get((int)0).StaticCast< ::h2d::Tile >();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Tile_obj,fromSprite,return )

Array< ::Dynamic > Tile_obj::fromSprites( Array< ::Dynamic > sprites,Dynamic allocPos){
	HX_STACK_FRAME("h2d.Tile","fromSprites",0x318d53f8,"h2d.Tile.fromSprites","h2d/Tile.hx",105,0xe227443b)
	HX_STACK_ARG(sprites,"sprites")
	HX_STACK_ARG(allocPos,"allocPos")
	HX_STACK_LINE(106)
	Dynamic tmp = Dynamic( Array_obj<Dynamic>::__new());		HX_STACK_VAR(tmp,"tmp");
	HX_STACK_LINE(107)
	int width = (int)0;		HX_STACK_VAR(width,"width");
	HX_STACK_LINE(108)
	int height = (int)0;		HX_STACK_VAR(height,"height");
	HX_STACK_LINE(109)
	{
		HX_STACK_LINE(109)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(109)
		while((true)){
			HX_STACK_LINE(109)
			if ((!(((_g < sprites->length))))){
				HX_STACK_LINE(109)
				break;
			}
			HX_STACK_LINE(109)
			::flash::display::DisplayObject s = sprites->__get(_g).StaticCast< ::flash::display::DisplayObject >();		HX_STACK_VAR(s,"s");
			HX_STACK_LINE(109)
			++(_g);
			HX_STACK_LINE(110)
			::flash::geom::Rectangle g = s->getBounds(s);		HX_STACK_VAR(g,"g");
			HX_STACK_LINE(111)
			int dx;		HX_STACK_VAR(dx,"dx");
			HX_STACK_LINE(111)
			{
				HX_STACK_LINE(111)
				Float f = g->get_left();		HX_STACK_VAR(f,"f");
				HX_STACK_LINE(111)
				dx = ::Math_obj::floor(f);
			}
			HX_STACK_LINE(112)
			int dy;		HX_STACK_VAR(dy,"dy");
			HX_STACK_LINE(112)
			{
				HX_STACK_LINE(112)
				Float f = g->get_top();		HX_STACK_VAR(f,"f");
				HX_STACK_LINE(112)
				dy = ::Math_obj::floor(f);
			}
			HX_STACK_LINE(113)
			int _g1;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(113)
			{
				HX_STACK_LINE(113)
				Float f = g->get_right();		HX_STACK_VAR(f,"f");
				HX_STACK_LINE(113)
				_g1 = ::Math_obj::ceil(f);
			}
			HX_STACK_LINE(113)
			int w = (_g1 - dx);		HX_STACK_VAR(w,"w");
			HX_STACK_LINE(114)
			int _g11;		HX_STACK_VAR(_g11,"_g11");
			HX_STACK_LINE(114)
			{
				HX_STACK_LINE(114)
				Float f = g->get_bottom();		HX_STACK_VAR(f,"f");
				HX_STACK_LINE(114)
				_g11 = ::Math_obj::ceil(f);
			}
			HX_STACK_LINE(114)
			int h = (_g11 - dy);		HX_STACK_VAR(h,"h");
			struct _Function_3_1{
				inline static Dynamic Block( int &width,int &dy,int &dx,::flash::display::DisplayObject &s,int &w,int &h){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h2d/Tile.hx",115,0xe227443b)
					{
						hx::Anon __result = hx::Anon_obj::Create();
						__result->Add(HX_CSTRING("s") , s,false);
						__result->Add(HX_CSTRING("x") , width,false);
						__result->Add(HX_CSTRING("dx") , dx,false);
						__result->Add(HX_CSTRING("dy") , dy,false);
						__result->Add(HX_CSTRING("w") , w,false);
						__result->Add(HX_CSTRING("h") , h,false);
						return __result;
					}
					return null();
				}
			};
			HX_STACK_LINE(115)
			tmp->__Field(HX_CSTRING("push"),true)(_Function_3_1::Block(width,dy,dx,s,w,h));
			HX_STACK_LINE(116)
			hx::AddEq(width,w);
			HX_STACK_LINE(117)
			if (((height < h))){
				HX_STACK_LINE(117)
				height = h;
			}
		}
	}
	HX_STACK_LINE(119)
	int rw = (int)1;		HX_STACK_VAR(rw,"rw");
	HX_STACK_LINE(119)
	int rh = (int)1;		HX_STACK_VAR(rh,"rh");
	HX_STACK_LINE(120)
	while((true)){
		HX_STACK_LINE(120)
		if ((!(((rw < width))))){
			HX_STACK_LINE(120)
			break;
		}
		HX_STACK_LINE(121)
		hx::ShlEq(rw,(int)1);
	}
	HX_STACK_LINE(122)
	while((true)){
		HX_STACK_LINE(122)
		if ((!(((rh < height))))){
			HX_STACK_LINE(122)
			break;
		}
		HX_STACK_LINE(123)
		hx::ShlEq(rh,(int)1);
	}
	HX_STACK_LINE(131)
	::flash::display::BitmapData bmp = ::flash::display::BitmapData_obj::__new(rw,rh,true,(int)0,null());		HX_STACK_VAR(bmp,"bmp");
	HX_STACK_LINE(132)
	::flash::geom::Matrix m = ::flash::geom::Matrix_obj::__new(null(),null(),null(),null(),null(),null());		HX_STACK_VAR(m,"m");
	HX_STACK_LINE(133)
	{
		HX_STACK_LINE(133)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(133)
		while((true)){
			HX_STACK_LINE(133)
			if ((!(((_g < tmp->__Field(HX_CSTRING("length"),true)))))){
				HX_STACK_LINE(133)
				break;
			}
			HX_STACK_LINE(133)
			Dynamic t = tmp->__GetItem(_g);		HX_STACK_VAR(t,"t");
			HX_STACK_LINE(133)
			++(_g);
			HX_STACK_LINE(134)
			m->tx = (t->__Field(HX_CSTRING("x"),true) - t->__Field(HX_CSTRING("dx"),true));
			HX_STACK_LINE(135)
			m->ty = -(t->__Field(HX_CSTRING("dy"),true));
			HX_STACK_LINE(136)
			bmp->draw(t->__Field(HX_CSTRING("s"),true),m,null(),null(),null(),null());
		}
	}
	HX_STACK_LINE(138)
	::h2d::Tile main = ::h2d::Tile_obj::fromBitmap(bmp,allocPos);		HX_STACK_VAR(main,"main");
	HX_STACK_LINE(139)
	bmp->dispose();
	HX_STACK_LINE(140)
	Array< ::Dynamic > tiles = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(tiles,"tiles");
	HX_STACK_LINE(141)
	{
		HX_STACK_LINE(141)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(141)
		while((true)){
			HX_STACK_LINE(141)
			if ((!(((_g < tmp->__Field(HX_CSTRING("length"),true)))))){
				HX_STACK_LINE(141)
				break;
			}
			HX_STACK_LINE(141)
			Dynamic t = tmp->__GetItem(_g);		HX_STACK_VAR(t,"t");
			HX_STACK_LINE(141)
			++(_g);
			HX_STACK_LINE(142)
			::h2d::Tile _g2 = main->sub(t->__Field(HX_CSTRING("x"),true),(int)0,t->__Field(HX_CSTRING("w"),true),t->__Field(HX_CSTRING("h"),true),t->__Field(HX_CSTRING("dx"),true),t->__Field(HX_CSTRING("dy"),true));		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(142)
			tiles->push(_g2);
		}
	}
	HX_STACK_LINE(143)
	return tiles;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Tile_obj,fromSprites,return )

::haxe::ds::IntMap Tile_obj::COLOR_CACHE;

::h2d::Tile Tile_obj::fromColor( int color,hx::Null< int >  __o_width,Dynamic __o_height,Dynamic allocPos){
int width = __o_width.Default(1);
Dynamic height = __o_height.Default(1);
	HX_STACK_FRAME("h2d.Tile","fromColor",0x3ddb1e0d,"h2d.Tile.fromColor","h2d/Tile.hx",328,0xe227443b)
	HX_STACK_ARG(color,"color")
	HX_STACK_ARG(width,"width")
	HX_STACK_ARG(height,"height")
	HX_STACK_ARG(allocPos,"allocPos")
{
		HX_STACK_LINE(330)
		::h3d::mat::Texture t = ::h2d::Tile_obj::COLOR_CACHE->get(color);		HX_STACK_VAR(t,"t");
		HX_STACK_LINE(331)
		if (((  ((!(((t == null()))))) ? bool(t->isDisposed()) : bool(true) ))){
			HX_STACK_LINE(332)
			::h3d::mat::Texture _g = ::h3d::mat::Texture_obj::fromColor(color,allocPos);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(332)
			t = _g;
			HX_STACK_LINE(333)
			::h2d::Tile_obj::COLOR_CACHE->set(color,t);
		}
		HX_STACK_LINE(335)
		::h2d::Tile t1 = ::h2d::Tile_obj::__new(t,(int)0,(int)0,(int)1,(int)1,null(),null());		HX_STACK_VAR(t1,"t1");
		HX_STACK_LINE(337)
		t1->width = width;
		HX_STACK_LINE(338)
		t1->height = height;
		HX_STACK_LINE(339)
		return t1;
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(Tile_obj,fromColor,return )

Dynamic Tile_obj::autoCut( ::flash::display::BitmapData bmp,int width,Dynamic height,Dynamic allocPos){
	HX_STACK_FRAME("h2d.Tile","autoCut",0x4434eac7,"h2d.Tile.autoCut","h2d/Tile.hx",344,0xe227443b)
	HX_STACK_ARG(bmp,"bmp")
	HX_STACK_ARG(width,"width")
	HX_STACK_ARG(height,"height")
	HX_STACK_ARG(allocPos,"allocPos")
	HX_STACK_LINE(345)
	if (((height == null()))){
		HX_STACK_LINE(345)
		height = width;
	}
	HX_STACK_LINE(346)
	int colorBG;		HX_STACK_VAR(colorBG,"colorBG");
	HX_STACK_LINE(346)
	{
		HX_STACK_LINE(346)
		int _g = bmp->get_width();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(346)
		int x = (_g - (int)1);		HX_STACK_VAR(x,"x");
		HX_STACK_LINE(346)
		int _g1 = bmp->get_height();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(346)
		int y = (_g1 - (int)1);		HX_STACK_VAR(y,"y");
		HX_STACK_LINE(346)
		colorBG = bmp->getPixel32(x,y);
	}
	HX_STACK_LINE(347)
	Array< ::Dynamic > tl = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(tl,"tl");
	HX_STACK_LINE(348)
	int w = (int)1;		HX_STACK_VAR(w,"w");
	HX_STACK_LINE(348)
	int h = (int)1;		HX_STACK_VAR(h,"h");
	HX_STACK_LINE(349)
	while((true)){
		HX_STACK_LINE(349)
		int _g2 = bmp->get_width();		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(349)
		if ((!(((w < _g2))))){
			HX_STACK_LINE(349)
			break;
		}
		HX_STACK_LINE(350)
		hx::ShlEq(w,(int)1);
	}
	HX_STACK_LINE(351)
	while((true)){
		HX_STACK_LINE(351)
		int _g3 = bmp->get_height();		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(351)
		if ((!(((h < _g3))))){
			HX_STACK_LINE(351)
			break;
		}
		HX_STACK_LINE(352)
		hx::ShlEq(h,(int)1);
	}
	struct _Function_1_1{
		inline static ::h3d::Engine Block( ){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h2d/Tile.hx",353,0xe227443b)
			{
				HX_STACK_LINE(353)
				if (((::hxd::System_obj::debugLevel >= (int)1))){
					HX_STACK_LINE(353)
					if (((::h3d::Engine_obj::CURRENT == null()))){
						HX_STACK_LINE(353)
						HX_STACK_DO_THROW(HX_CSTRING("no current context, please do this operation after engine init/creation"));
					}
				}
				HX_STACK_LINE(353)
				return ::h3d::Engine_obj::CURRENT;
			}
			return null();
		}
	};
	HX_STACK_LINE(353)
	::h3d::mat::Texture tex = (_Function_1_1::Block())->mem->allocTexture(w,h,false,allocPos);		HX_STACK_VAR(tex,"tex");
	HX_STACK_LINE(354)
	{
		HX_STACK_LINE(354)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(354)
		int _g4 = bmp->get_height();		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(354)
		Float _g5 = (Float(_g4) / Float(height));		HX_STACK_VAR(_g5,"_g5");
		HX_STACK_LINE(354)
		int _g = ::Std_obj::_int(_g5);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(354)
		while((true)){
			HX_STACK_LINE(354)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(354)
				break;
			}
			HX_STACK_LINE(354)
			int y = (_g1)++;		HX_STACK_VAR(y,"y");
			HX_STACK_LINE(355)
			Array< ::Dynamic > a = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(a,"a");
			HX_STACK_LINE(356)
			tl[y] = a;
			HX_STACK_LINE(357)
			{
				HX_STACK_LINE(357)
				int _g3 = (int)0;		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(357)
				int _g6 = bmp->get_width();		HX_STACK_VAR(_g6,"_g6");
				HX_STACK_LINE(357)
				Float _g7 = (Float(_g6) / Float(width));		HX_STACK_VAR(_g7,"_g7");
				HX_STACK_LINE(357)
				int _g2 = ::Std_obj::_int(_g7);		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(357)
				while((true)){
					HX_STACK_LINE(357)
					if ((!(((_g3 < _g2))))){
						HX_STACK_LINE(357)
						break;
					}
					HX_STACK_LINE(357)
					int x = (_g3)++;		HX_STACK_VAR(x,"x");
					HX_STACK_LINE(358)
					Dynamic sz = ::h2d::Tile_obj::isEmpty(bmp,(x * width),(y * height),width,height,colorBG);		HX_STACK_VAR(sz,"sz");
					HX_STACK_LINE(359)
					if (((sz == null()))){
						HX_STACK_LINE(360)
						break;
					}
					HX_STACK_LINE(361)
					::h2d::Tile _g8 = ::h2d::Tile_obj::__new(tex,((x * width) + sz->__Field(HX_CSTRING("dx"),true)),((y * height) + sz->__Field(HX_CSTRING("dy"),true)),sz->__Field(HX_CSTRING("w"),true),sz->__Field(HX_CSTRING("h"),true),sz->__Field(HX_CSTRING("dx"),true),sz->__Field(HX_CSTRING("dy"),true));		HX_STACK_VAR(_g8,"_g8");
					HX_STACK_LINE(361)
					a->push(_g8);
				}
			}
		}
	}
	HX_STACK_LINE(364)
	int _g9 = bmp->get_width();		HX_STACK_VAR(_g9,"_g9");
	HX_STACK_LINE(364)
	int _g10 = bmp->get_height();		HX_STACK_VAR(_g10,"_g10");
	HX_STACK_LINE(364)
	::h2d::Tile main = ::h2d::Tile_obj::__new(tex,(int)0,(int)0,_g9,_g10,null(),null());		HX_STACK_VAR(main,"main");
	HX_STACK_LINE(365)
	main->upload(bmp);
	struct _Function_1_2{
		inline static Dynamic Block( Array< ::Dynamic > &tl,::h2d::Tile &main){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h2d/Tile.hx",366,0xe227443b)
			{
				hx::Anon __result = hx::Anon_obj::Create();
				__result->Add(HX_CSTRING("main") , main,false);
				__result->Add(HX_CSTRING("tiles") , tl,false);
				return __result;
			}
			return null();
		}
	};
	HX_STACK_LINE(366)
	return _Function_1_2::Block(tl,main);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(Tile_obj,autoCut,return )

Dynamic Tile_obj::isEmpty( ::flash::display::BitmapData b,int px,int py,int width,int height,int bg){
	HX_STACK_FRAME("h2d.Tile","isEmpty",0xb3245bb7,"h2d.Tile.isEmpty","h2d/Tile.hx",371,0xe227443b)
	HX_STACK_ARG(b,"b")
	HX_STACK_ARG(px,"px")
	HX_STACK_ARG(py,"py")
	HX_STACK_ARG(width,"width")
	HX_STACK_ARG(height,"height")
	HX_STACK_ARG(bg,"bg")
	HX_STACK_LINE(372)
	bool empty = true;		HX_STACK_VAR(empty,"empty");
	HX_STACK_LINE(373)
	int xmin = width;		HX_STACK_VAR(xmin,"xmin");
	HX_STACK_LINE(373)
	int ymin = height;		HX_STACK_VAR(ymin,"ymin");
	HX_STACK_LINE(373)
	int xmax = (int)0;		HX_STACK_VAR(xmax,"xmax");
	HX_STACK_LINE(373)
	int ymax = (int)0;		HX_STACK_VAR(ymax,"ymax");
	HX_STACK_LINE(374)
	{
		HX_STACK_LINE(374)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(374)
		while((true)){
			HX_STACK_LINE(374)
			if ((!(((_g < width))))){
				HX_STACK_LINE(374)
				break;
			}
			HX_STACK_LINE(374)
			int x = (_g)++;		HX_STACK_VAR(x,"x");
			HX_STACK_LINE(375)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(375)
			while((true)){
				HX_STACK_LINE(375)
				if ((!(((_g1 < height))))){
					HX_STACK_LINE(375)
					break;
				}
				HX_STACK_LINE(375)
				int y = (_g1)++;		HX_STACK_VAR(y,"y");
				HX_STACK_LINE(376)
				int color = b->getPixel32((x + px),(y + py));		HX_STACK_VAR(color,"color");
				HX_STACK_LINE(377)
				if (((color != bg))){
					HX_STACK_LINE(378)
					empty = false;
					HX_STACK_LINE(379)
					if (((x < xmin))){
						HX_STACK_LINE(379)
						xmin = x;
					}
					HX_STACK_LINE(380)
					if (((y < ymin))){
						HX_STACK_LINE(380)
						ymin = y;
					}
					HX_STACK_LINE(381)
					if (((x > xmax))){
						HX_STACK_LINE(381)
						xmax = x;
					}
					HX_STACK_LINE(382)
					if (((y > ymax))){
						HX_STACK_LINE(382)
						ymax = y;
					}
				}
				HX_STACK_LINE(384)
				if (((color == bg))){
					HX_STACK_LINE(385)
					b->setPixel32((x + px),(y + py),(int)0);
				}
			}
		}
	}
	HX_STACK_LINE(387)
	if ((empty)){
		HX_STACK_LINE(387)
		return null();
	}
	else{
		struct _Function_2_1{
			inline static Dynamic Block( int &xmin,int &ymin,int &xmax,int &ymax){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h2d/Tile.hx",387,0xe227443b)
				{
					hx::Anon __result = hx::Anon_obj::Create();
					__result->Add(HX_CSTRING("dx") , xmin,false);
					__result->Add(HX_CSTRING("dy") , ymin,false);
					__result->Add(HX_CSTRING("w") , ((xmax - xmin) + (int)1),false);
					__result->Add(HX_CSTRING("h") , ((ymax - ymin) + (int)1),false);
					return __result;
				}
				return null();
			}
		};
		HX_STACK_LINE(387)
		return _Function_2_1::Block(xmin,ymin,xmax,ymax);
	}
	HX_STACK_LINE(387)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC6(Tile_obj,isEmpty,return )


Tile_obj::Tile_obj()
{
}

void Tile_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Tile);
	HX_MARK_MEMBER_NAME(innerTex,"innerTex");
	HX_MARK_MEMBER_NAME(u,"u");
	HX_MARK_MEMBER_NAME(v,"v");
	HX_MARK_MEMBER_NAME(u2,"u2");
	HX_MARK_MEMBER_NAME(v2,"v2");
	HX_MARK_MEMBER_NAME(dx,"dx");
	HX_MARK_MEMBER_NAME(dy,"dy");
	HX_MARK_MEMBER_NAME(x,"x");
	HX_MARK_MEMBER_NAME(y,"y");
	HX_MARK_MEMBER_NAME(width,"width");
	HX_MARK_MEMBER_NAME(height,"height");
	HX_MARK_END_CLASS();
}

void Tile_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(innerTex,"innerTex");
	HX_VISIT_MEMBER_NAME(u,"u");
	HX_VISIT_MEMBER_NAME(v,"v");
	HX_VISIT_MEMBER_NAME(u2,"u2");
	HX_VISIT_MEMBER_NAME(v2,"v2");
	HX_VISIT_MEMBER_NAME(dx,"dx");
	HX_VISIT_MEMBER_NAME(dy,"dy");
	HX_VISIT_MEMBER_NAME(x,"x");
	HX_VISIT_MEMBER_NAME(y,"y");
	HX_VISIT_MEMBER_NAME(width,"width");
	HX_VISIT_MEMBER_NAME(height,"height");
}

Dynamic Tile_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"u") ) { return u; }
		if (HX_FIELD_EQ(inName,"v") ) { return v; }
		if (HX_FIELD_EQ(inName,"x") ) { return x; }
		if (HX_FIELD_EQ(inName,"y") ) { return y; }
		break;
	case 2:
		if (HX_FIELD_EQ(inName,"u2") ) { return u2; }
		if (HX_FIELD_EQ(inName,"v2") ) { return v2; }
		if (HX_FIELD_EQ(inName,"dx") ) { return dx; }
		if (HX_FIELD_EQ(inName,"dy") ) { return dy; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"sub") ) { return sub_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"copy") ) { return copy_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"width") ) { return width; }
		if (HX_FIELD_EQ(inName,"flipX") ) { return flipX_dyn(); }
		if (HX_FIELD_EQ(inName,"flipY") ) { return flipY_dyn(); }
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		if (HX_FIELD_EQ(inName,"split") ) { return split_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"height") ) { return height; }
		if (HX_FIELD_EQ(inName,"center") ) { return center_dyn(); }
		if (HX_FIELD_EQ(inName,"setPos") ) { return setPos_dyn(); }
		if (HX_FIELD_EQ(inName,"upload") ) { return upload_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"autoCut") ) { return autoCut_dyn(); }
		if (HX_FIELD_EQ(inName,"isEmpty") ) { return isEmpty_dyn(); }
		if (HX_FIELD_EQ(inName,"setSize") ) { return setSize_dyn(); }
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"innerTex") ) { return innerTex; }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"fromColor") ) { return fromColor_dyn(); }
		if (HX_FIELD_EQ(inName,"setCenter") ) { return setCenter_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"fromBitmap") ) { return fromBitmap_dyn(); }
		if (HX_FIELD_EQ(inName,"fromPixels") ) { return fromPixels_dyn(); }
		if (HX_FIELD_EQ(inName,"fromSprite") ) { return fromSprite_dyn(); }
		if (HX_FIELD_EQ(inName,"getTexture") ) { return getTexture_dyn(); }
		if (HX_FIELD_EQ(inName,"isDisposed") ) { return isDisposed_dyn(); }
		if (HX_FIELD_EQ(inName,"setTexture") ) { return setTexture_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"fromTexture") ) { return fromTexture_dyn(); }
		if (HX_FIELD_EQ(inName,"fromSprites") ) { return fromSprites_dyn(); }
		if (HX_FIELD_EQ(inName,"COLOR_CACHE") ) { return COLOR_CACHE; }
		if (HX_FIELD_EQ(inName,"centerRatio") ) { return centerRatio_dyn(); }
		if (HX_FIELD_EQ(inName,"scaleToSize") ) { return scaleToSize_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"switchTexture") ) { return switchTexture_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"setCenterRatio") ) { return setCenterRatio_dyn(); }
		if (HX_FIELD_EQ(inName,"scrollDiscrete") ) { return scrollDiscrete_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"fromFlashBitmap") ) { return fromFlashBitmap_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Tile_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"u") ) { u=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"v") ) { v=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"x") ) { x=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"y") ) { y=inValue.Cast< int >(); return inValue; }
		break;
	case 2:
		if (HX_FIELD_EQ(inName,"u2") ) { u2=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"v2") ) { v2=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"dx") ) { dx=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"dy") ) { dy=inValue.Cast< int >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"width") ) { width=inValue.Cast< int >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"height") ) { height=inValue.Cast< int >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"innerTex") ) { innerTex=inValue.Cast< ::h3d::mat::Texture >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"COLOR_CACHE") ) { COLOR_CACHE=inValue.Cast< ::haxe::ds::IntMap >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Tile_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("innerTex"));
	outFields->push(HX_CSTRING("u"));
	outFields->push(HX_CSTRING("v"));
	outFields->push(HX_CSTRING("u2"));
	outFields->push(HX_CSTRING("v2"));
	outFields->push(HX_CSTRING("dx"));
	outFields->push(HX_CSTRING("dy"));
	outFields->push(HX_CSTRING("x"));
	outFields->push(HX_CSTRING("y"));
	outFields->push(HX_CSTRING("width"));
	outFields->push(HX_CSTRING("height"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("EPSILON_PIXEL"),
	HX_CSTRING("fromFlashBitmap"),
	HX_CSTRING("fromBitmap"),
	HX_CSTRING("fromTexture"),
	HX_CSTRING("fromPixels"),
	HX_CSTRING("fromSprite"),
	HX_CSTRING("fromSprites"),
	HX_CSTRING("COLOR_CACHE"),
	HX_CSTRING("fromColor"),
	HX_CSTRING("autoCut"),
	HX_CSTRING("isEmpty"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h3d::mat::Texture*/ ,(int)offsetof(Tile_obj,innerTex),HX_CSTRING("innerTex")},
	{hx::fsFloat,(int)offsetof(Tile_obj,u),HX_CSTRING("u")},
	{hx::fsFloat,(int)offsetof(Tile_obj,v),HX_CSTRING("v")},
	{hx::fsFloat,(int)offsetof(Tile_obj,u2),HX_CSTRING("u2")},
	{hx::fsFloat,(int)offsetof(Tile_obj,v2),HX_CSTRING("v2")},
	{hx::fsInt,(int)offsetof(Tile_obj,dx),HX_CSTRING("dx")},
	{hx::fsInt,(int)offsetof(Tile_obj,dy),HX_CSTRING("dy")},
	{hx::fsInt,(int)offsetof(Tile_obj,x),HX_CSTRING("x")},
	{hx::fsInt,(int)offsetof(Tile_obj,y),HX_CSTRING("y")},
	{hx::fsInt,(int)offsetof(Tile_obj,width),HX_CSTRING("width")},
	{hx::fsInt,(int)offsetof(Tile_obj,height),HX_CSTRING("height")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("innerTex"),
	HX_CSTRING("u"),
	HX_CSTRING("v"),
	HX_CSTRING("u2"),
	HX_CSTRING("v2"),
	HX_CSTRING("dx"),
	HX_CSTRING("dy"),
	HX_CSTRING("x"),
	HX_CSTRING("y"),
	HX_CSTRING("width"),
	HX_CSTRING("height"),
	HX_CSTRING("getTexture"),
	HX_CSTRING("isDisposed"),
	HX_CSTRING("setTexture"),
	HX_CSTRING("switchTexture"),
	HX_CSTRING("sub"),
	HX_CSTRING("center"),
	HX_CSTRING("centerRatio"),
	HX_CSTRING("setCenter"),
	HX_CSTRING("setCenterRatio"),
	HX_CSTRING("setPos"),
	HX_CSTRING("setSize"),
	HX_CSTRING("scaleToSize"),
	HX_CSTRING("scrollDiscrete"),
	HX_CSTRING("flipX"),
	HX_CSTRING("flipY"),
	HX_CSTRING("dispose"),
	HX_CSTRING("clone"),
	HX_CSTRING("copy"),
	HX_CSTRING("split"),
	HX_CSTRING("toString"),
	HX_CSTRING("upload"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Tile_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Tile_obj::EPSILON_PIXEL,"EPSILON_PIXEL");
	HX_MARK_MEMBER_NAME(Tile_obj::COLOR_CACHE,"COLOR_CACHE");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Tile_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Tile_obj::EPSILON_PIXEL,"EPSILON_PIXEL");
	HX_VISIT_MEMBER_NAME(Tile_obj::COLOR_CACHE,"COLOR_CACHE");
};

#endif

Class Tile_obj::__mClass;

void Tile_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.Tile"), hx::TCanCast< Tile_obj> ,sStaticFields,sMemberFields,
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

void Tile_obj::__boot()
{
	EPSILON_PIXEL= 0.001;
	COLOR_CACHE= ::haxe::ds::IntMap_obj::__new();
}

} // end namespace h2d
