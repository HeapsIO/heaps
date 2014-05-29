#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_h2d_Anim
#include <h2d/Anim.h>
#endif
#ifndef INCLUDED_h2d_Drawable
#include <h2d/Drawable.h>
#endif
#ifndef INCLUDED_h2d_DrawableShader
#include <h2d/DrawableShader.h>
#endif
#ifndef INCLUDED_h2d_Matrix
#include <h2d/Matrix.h>
#endif
#ifndef INCLUDED_h2d_Sprite
#include <h2d/Sprite.h>
#endif
#ifndef INCLUDED_h2d_Tile
#include <h2d/Tile.h>
#endif
#ifndef INCLUDED_h2d_col_Bounds
#include <h2d/col/Bounds.h>
#endif
#ifndef INCLUDED_h2d_col_Point
#include <h2d/col/Point.h>
#endif
#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
#endif
#ifndef INCLUDED_h3d_impl_Shader
#include <h3d/impl/Shader.h>
#endif
#ifndef INCLUDED_h3d_scene_RenderContext
#include <h3d/scene/RenderContext.h>
#endif
namespace h2d{

Void Anim_obj::__construct(Array< ::Dynamic > frames,Dynamic speed,::h2d::DrawableShader sh,::h2d::Sprite parent)
{
HX_STACK_FRAME("h2d.Anim","new",0x2696ec37,"h2d.Anim.new","h2d/Anim.hx",3,0x16ee3938)
HX_STACK_THIS(this)
HX_STACK_ARG(frames,"frames")
HX_STACK_ARG(speed,"speed")
HX_STACK_ARG(sh,"sh")
HX_STACK_ARG(parent,"parent")
{
	HX_STACK_LINE(8)
	this->loop = true;
	HX_STACK_LINE(18)
	super::__construct(parent,sh);
	HX_STACK_LINE(19)
	if (((frames == null()))){
		HX_STACK_LINE(19)
		this->frames = Array_obj< ::Dynamic >::__new();
	}
	else{
		HX_STACK_LINE(19)
		this->frames = frames;
	}
	HX_STACK_LINE(20)
	this->currentFrame = (int)0;
	HX_STACK_LINE(21)
	if (((speed == null()))){
		HX_STACK_LINE(21)
		this->speed = (int)15;
	}
	else{
		HX_STACK_LINE(21)
		this->speed = speed;
	}
}
;
	return null();
}

//Anim_obj::~Anim_obj() { }

Dynamic Anim_obj::__CreateEmpty() { return  new Anim_obj; }
hx::ObjectPtr< Anim_obj > Anim_obj::__new(Array< ::Dynamic > frames,Dynamic speed,::h2d::DrawableShader sh,::h2d::Sprite parent)
{  hx::ObjectPtr< Anim_obj > result = new Anim_obj();
	result->__construct(frames,speed,sh,parent);
	return result;}

Dynamic Anim_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Anim_obj > result = new Anim_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3]);
	return result;}

Void Anim_obj::play( Array< ::Dynamic > frames){
{
		HX_STACK_FRAME("h2d.Anim","play",0x9ecf6e3d,"h2d.Anim.play","h2d/Anim.hx",26,0x16ee3938)
		HX_STACK_THIS(this)
		HX_STACK_ARG(frames,"frames")
		HX_STACK_LINE(27)
		this->frames = frames;
		HX_STACK_LINE(28)
		this->currentFrame = (int)0;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Anim_obj,play,(void))

Void Anim_obj::sync( ::h3d::scene::RenderContext ctx){
{
		HX_STACK_FRAME("h2d.Anim","sync",0xa0d4faa4,"h2d.Anim.sync","h2d/Anim.hx",31,0x16ee3938)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ctx,"ctx")
		HX_STACK_LINE(32)
		hx::AddEq(this->currentFrame,(this->speed * ctx->elapsedTime));
		HX_STACK_LINE(33)
		if ((this->loop)){
			HX_STACK_LINE(34)
			hx::ModEq(this->currentFrame,this->frames->length);
		}
		else{
			HX_STACK_LINE(35)
			if (((this->currentFrame >= this->frames->length))){
				HX_STACK_LINE(36)
				this->currentFrame = (this->frames->length - 0.00001);
			}
		}
	}
return null();
}


::h2d::Tile Anim_obj::getFrame( ){
	HX_STACK_FRAME("h2d.Anim","getFrame",0x46b02080,"h2d.Anim.getFrame","h2d/Anim.hx",39,0x16ee3938)
	HX_STACK_THIS(this)
	HX_STACK_LINE(40)
	int _g = ::Std_obj::_int(this->currentFrame);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(40)
	return this->frames->__get(_g).StaticCast< ::h2d::Tile >();
}


HX_DEFINE_DYNAMIC_FUNC0(Anim_obj,getFrame,return )

::h2d::col::Bounds Anim_obj::getMyBounds( ){
	HX_STACK_FRAME("h2d.Anim","getMyBounds",0x02dac08e,"h2d.Anim.getMyBounds","h2d/Anim.hx",43,0x16ee3938)
	HX_STACK_THIS(this)
	HX_STACK_LINE(44)
	::h2d::Tile tile = this->getFrame();		HX_STACK_VAR(tile,"tile");
	HX_STACK_LINE(45)
	::h2d::Matrix m = this->getPixSpaceMatrix(null(),tile);		HX_STACK_VAR(m,"m");
	HX_STACK_LINE(46)
	::h2d::col::Bounds bounds;		HX_STACK_VAR(bounds,"bounds");
	HX_STACK_LINE(46)
	{
		HX_STACK_LINE(46)
		::h2d::col::Bounds b = ::h2d::col::Bounds_obj::__new();		HX_STACK_VAR(b,"b");
		HX_STACK_LINE(46)
		b->xMin = (int)0;
		HX_STACK_LINE(46)
		b->yMin = (int)0;
		HX_STACK_LINE(46)
		b->xMax = tile->width;
		HX_STACK_LINE(46)
		b->yMax = tile->height;
		HX_STACK_LINE(46)
		bounds = b;
	}
	HX_STACK_LINE(47)
	{
		HX_STACK_LINE(47)
		::h2d::col::Point p0 = ::h2d::col::Point_obj::__new(bounds->xMin,bounds->yMin);		HX_STACK_VAR(p0,"p0");
		HX_STACK_LINE(47)
		::h2d::col::Point p1 = ::h2d::col::Point_obj::__new(bounds->xMin,bounds->yMax);		HX_STACK_VAR(p1,"p1");
		HX_STACK_LINE(47)
		::h2d::col::Point p2 = ::h2d::col::Point_obj::__new(bounds->xMax,bounds->yMin);		HX_STACK_VAR(p2,"p2");
		HX_STACK_LINE(47)
		::h2d::col::Point p3 = ::h2d::col::Point_obj::__new(bounds->xMax,bounds->yMax);		HX_STACK_VAR(p3,"p3");
		HX_STACK_LINE(47)
		{
			HX_STACK_LINE(47)
			::h2d::col::Point p;		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(47)
			if (((p0 == null()))){
				HX_STACK_LINE(47)
				p = ::h2d::col::Point_obj::__new(null(),null());
			}
			else{
				HX_STACK_LINE(47)
				p = p0;
			}
			HX_STACK_LINE(47)
			Float px = p0->x;		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(47)
			Float py = p0->y;		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(47)
			p->x = (((px * m->a) + (py * m->c)) + m->tx);
			HX_STACK_LINE(47)
			p->y = (((px * m->b) + (py * m->d)) + m->ty);
			HX_STACK_LINE(47)
			p;
		}
		HX_STACK_LINE(47)
		{
			HX_STACK_LINE(47)
			::h2d::col::Point p;		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(47)
			if (((p1 == null()))){
				HX_STACK_LINE(47)
				p = ::h2d::col::Point_obj::__new(null(),null());
			}
			else{
				HX_STACK_LINE(47)
				p = p1;
			}
			HX_STACK_LINE(47)
			Float px = p1->x;		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(47)
			Float py = p1->y;		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(47)
			p->x = (((px * m->a) + (py * m->c)) + m->tx);
			HX_STACK_LINE(47)
			p->y = (((px * m->b) + (py * m->d)) + m->ty);
			HX_STACK_LINE(47)
			p;
		}
		HX_STACK_LINE(47)
		{
			HX_STACK_LINE(47)
			::h2d::col::Point p;		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(47)
			if (((p2 == null()))){
				HX_STACK_LINE(47)
				p = ::h2d::col::Point_obj::__new(null(),null());
			}
			else{
				HX_STACK_LINE(47)
				p = p2;
			}
			HX_STACK_LINE(47)
			Float px = p2->x;		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(47)
			Float py = p2->y;		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(47)
			p->x = (((px * m->a) + (py * m->c)) + m->tx);
			HX_STACK_LINE(47)
			p->y = (((px * m->b) + (py * m->d)) + m->ty);
			HX_STACK_LINE(47)
			p;
		}
		HX_STACK_LINE(47)
		{
			HX_STACK_LINE(47)
			::h2d::col::Point p;		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(47)
			if (((p3 == null()))){
				HX_STACK_LINE(47)
				p = ::h2d::col::Point_obj::__new(null(),null());
			}
			else{
				HX_STACK_LINE(47)
				p = p3;
			}
			HX_STACK_LINE(47)
			Float px = p3->x;		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(47)
			Float py = p3->y;		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(47)
			p->x = (((px * m->a) + (py * m->c)) + m->tx);
			HX_STACK_LINE(47)
			p->y = (((px * m->b) + (py * m->d)) + m->ty);
			HX_STACK_LINE(47)
			p;
		}
		HX_STACK_LINE(47)
		{
			HX_STACK_LINE(47)
			bounds->xMin = p0->x;
			HX_STACK_LINE(47)
			bounds->yMin = p0->y;
		}
		HX_STACK_LINE(47)
		{
			HX_STACK_LINE(47)
			bounds->xMax = p0->x;
			HX_STACK_LINE(47)
			bounds->yMax = p0->y;
		}
		HX_STACK_LINE(47)
		{
			HX_STACK_LINE(47)
			if (((p1->x < bounds->xMin))){
				HX_STACK_LINE(47)
				bounds->xMin = p1->x;
			}
			HX_STACK_LINE(47)
			if (((p1->x > bounds->xMax))){
				HX_STACK_LINE(47)
				bounds->xMax = p1->x;
			}
			HX_STACK_LINE(47)
			if (((p1->y < bounds->yMin))){
				HX_STACK_LINE(47)
				bounds->yMin = p1->y;
			}
			HX_STACK_LINE(47)
			if (((p1->y > bounds->yMax))){
				HX_STACK_LINE(47)
				bounds->yMax = p1->y;
			}
		}
		HX_STACK_LINE(47)
		{
			HX_STACK_LINE(47)
			if (((p2->x < bounds->xMin))){
				HX_STACK_LINE(47)
				bounds->xMin = p2->x;
			}
			HX_STACK_LINE(47)
			if (((p2->x > bounds->xMax))){
				HX_STACK_LINE(47)
				bounds->xMax = p2->x;
			}
			HX_STACK_LINE(47)
			if (((p2->y < bounds->yMin))){
				HX_STACK_LINE(47)
				bounds->yMin = p2->y;
			}
			HX_STACK_LINE(47)
			if (((p2->y > bounds->yMax))){
				HX_STACK_LINE(47)
				bounds->yMax = p2->y;
			}
		}
		HX_STACK_LINE(47)
		{
			HX_STACK_LINE(47)
			if (((p3->x < bounds->xMin))){
				HX_STACK_LINE(47)
				bounds->xMin = p3->x;
			}
			HX_STACK_LINE(47)
			if (((p3->x > bounds->xMax))){
				HX_STACK_LINE(47)
				bounds->xMax = p3->x;
			}
			HX_STACK_LINE(47)
			if (((p3->y < bounds->yMin))){
				HX_STACK_LINE(47)
				bounds->yMin = p3->y;
			}
			HX_STACK_LINE(47)
			if (((p3->y > bounds->yMax))){
				HX_STACK_LINE(47)
				bounds->yMax = p3->y;
			}
		}
		HX_STACK_LINE(47)
		p0 = null();
		HX_STACK_LINE(47)
		p1 = null();
		HX_STACK_LINE(47)
		p2 = null();
		HX_STACK_LINE(47)
		p3 = null();
		HX_STACK_LINE(47)
		bounds;
	}
	HX_STACK_LINE(48)
	return bounds;
}


Void Anim_obj::draw( ::h3d::scene::RenderContext ctx){
{
		HX_STACK_FRAME("h2d.Anim","draw",0x96e56c4d,"h2d.Anim.draw","h2d/Anim.hx",51,0x16ee3938)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ctx,"ctx")
		HX_STACK_LINE(52)
		::h2d::Tile t = this->getFrame();		HX_STACK_VAR(t,"t");
		HX_STACK_LINE(53)
		if (((t != null()))){
			HX_STACK_LINE(54)
			this->drawTile(ctx->engine,t);
		}
	}
return null();
}



Anim_obj::Anim_obj()
{
}

void Anim_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Anim);
	HX_MARK_MEMBER_NAME(frames,"frames");
	HX_MARK_MEMBER_NAME(currentFrame,"currentFrame");
	HX_MARK_MEMBER_NAME(speed,"speed");
	HX_MARK_MEMBER_NAME(loop,"loop");
	::h2d::Drawable_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void Anim_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(frames,"frames");
	HX_VISIT_MEMBER_NAME(currentFrame,"currentFrame");
	HX_VISIT_MEMBER_NAME(speed,"speed");
	HX_VISIT_MEMBER_NAME(loop,"loop");
	::h2d::Drawable_obj::__Visit(HX_VISIT_ARG);
}

Dynamic Anim_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"loop") ) { return loop; }
		if (HX_FIELD_EQ(inName,"play") ) { return play_dyn(); }
		if (HX_FIELD_EQ(inName,"sync") ) { return sync_dyn(); }
		if (HX_FIELD_EQ(inName,"draw") ) { return draw_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"speed") ) { return speed; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"frames") ) { return frames; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"getFrame") ) { return getFrame_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"getMyBounds") ) { return getMyBounds_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"currentFrame") ) { return currentFrame; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Anim_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"loop") ) { loop=inValue.Cast< bool >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"speed") ) { speed=inValue.Cast< Float >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"frames") ) { frames=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"currentFrame") ) { currentFrame=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Anim_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("frames"));
	outFields->push(HX_CSTRING("currentFrame"));
	outFields->push(HX_CSTRING("speed"));
	outFields->push(HX_CSTRING("loop"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Anim_obj,frames),HX_CSTRING("frames")},
	{hx::fsFloat,(int)offsetof(Anim_obj,currentFrame),HX_CSTRING("currentFrame")},
	{hx::fsFloat,(int)offsetof(Anim_obj,speed),HX_CSTRING("speed")},
	{hx::fsBool,(int)offsetof(Anim_obj,loop),HX_CSTRING("loop")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("frames"),
	HX_CSTRING("currentFrame"),
	HX_CSTRING("speed"),
	HX_CSTRING("loop"),
	HX_CSTRING("play"),
	HX_CSTRING("sync"),
	HX_CSTRING("getFrame"),
	HX_CSTRING("getMyBounds"),
	HX_CSTRING("draw"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Anim_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Anim_obj::__mClass,"__mClass");
};

#endif

Class Anim_obj::__mClass;

void Anim_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.Anim"), hx::TCanCast< Anim_obj> ,sStaticFields,sMemberFields,
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

void Anim_obj::__boot()
{
}

} // end namespace h2d
