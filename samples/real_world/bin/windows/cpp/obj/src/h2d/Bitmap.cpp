#include <hxcpp.h>

#ifndef INCLUDED_flash_display_BitmapData
#include <flash/display/BitmapData.h>
#endif
#ifndef INCLUDED_flash_display_IBitmapDrawable
#include <flash/display/IBitmapDrawable.h>
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
#ifndef INCLUDED_hxd_Pixels
#include <hxd/Pixels.h>
#endif
namespace h2d{

Void Bitmap_obj::__construct(::h2d::Tile tile,::h2d::Sprite parent,::h2d::DrawableShader sh)
{
HX_STACK_FRAME("h2d.Bitmap","new",0xa8b15215,"h2d.Bitmap.new","h2d/Bitmap.hx",13,0x3abbbeda)
HX_STACK_THIS(this)
HX_STACK_ARG(tile,"tile")
HX_STACK_ARG(parent,"parent")
HX_STACK_ARG(sh,"sh")
{
	HX_STACK_LINE(14)
	super::__construct(parent,sh);
	HX_STACK_LINE(15)
	this->tile = tile;
}
;
	return null();
}

//Bitmap_obj::~Bitmap_obj() { }

Dynamic Bitmap_obj::__CreateEmpty() { return  new Bitmap_obj; }
hx::ObjectPtr< Bitmap_obj > Bitmap_obj::__new(::h2d::Tile tile,::h2d::Sprite parent,::h2d::DrawableShader sh)
{  hx::ObjectPtr< Bitmap_obj > result = new Bitmap_obj();
	result->__construct(tile,parent,sh);
	return result;}

Dynamic Bitmap_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Bitmap_obj > result = new Bitmap_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

::h2d::Bitmap Bitmap_obj::clone( ){
	HX_STACK_FRAME("h2d.Bitmap","clone",0xe46c2c52,"h2d.Bitmap.clone","h2d/Bitmap.hx",18,0x3abbbeda)
	HX_STACK_THIS(this)
	HX_STACK_LINE(19)
	::h2d::Bitmap b = ::h2d::Bitmap_obj::__new(this->tile,this->parent,this->shader);		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(21)
	{
		HX_STACK_LINE(21)
		Float v = this->x;		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(21)
		b->x = v;
		HX_STACK_LINE(21)
		{
			HX_STACK_LINE(21)
			b->posChanged = true;
			HX_STACK_LINE(21)
			if (((b->childs != null()))){
				HX_STACK_LINE(21)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(21)
				Array< ::Dynamic > _g1 = b->childs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(21)
				while((true)){
					HX_STACK_LINE(21)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(21)
						break;
					}
					HX_STACK_LINE(21)
					::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(21)
					++(_g);
					HX_STACK_LINE(21)
					c->set_posChanged(true);
				}
			}
			HX_STACK_LINE(21)
			b->posChanged;
		}
		HX_STACK_LINE(21)
		v;
	}
	HX_STACK_LINE(22)
	{
		HX_STACK_LINE(22)
		Float v = this->y;		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(22)
		b->y = v;
		HX_STACK_LINE(22)
		{
			HX_STACK_LINE(22)
			b->posChanged = true;
			HX_STACK_LINE(22)
			if (((b->childs != null()))){
				HX_STACK_LINE(22)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(22)
				Array< ::Dynamic > _g1 = b->childs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(22)
				while((true)){
					HX_STACK_LINE(22)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(22)
						break;
					}
					HX_STACK_LINE(22)
					::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(22)
					++(_g);
					HX_STACK_LINE(22)
					c->set_posChanged(true);
				}
			}
			HX_STACK_LINE(22)
			b->posChanged;
		}
		HX_STACK_LINE(22)
		v;
	}
	HX_STACK_LINE(24)
	{
		HX_STACK_LINE(24)
		Float v = this->rotation;		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(24)
		b->rotation = v;
		HX_STACK_LINE(24)
		{
			HX_STACK_LINE(24)
			b->posChanged = true;
			HX_STACK_LINE(24)
			if (((b->childs != null()))){
				HX_STACK_LINE(24)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(24)
				Array< ::Dynamic > _g1 = b->childs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(24)
				while((true)){
					HX_STACK_LINE(24)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(24)
						break;
					}
					HX_STACK_LINE(24)
					::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(24)
					++(_g);
					HX_STACK_LINE(24)
					c->set_posChanged(true);
				}
			}
			HX_STACK_LINE(24)
			b->posChanged;
		}
		HX_STACK_LINE(24)
		v;
	}
	HX_STACK_LINE(26)
	{
		HX_STACK_LINE(26)
		Float v = this->scaleX;		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(26)
		b->scaleX = v;
		HX_STACK_LINE(26)
		{
			HX_STACK_LINE(26)
			b->posChanged = true;
			HX_STACK_LINE(26)
			if (((b->childs != null()))){
				HX_STACK_LINE(26)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(26)
				Array< ::Dynamic > _g1 = b->childs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(26)
				while((true)){
					HX_STACK_LINE(26)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(26)
						break;
					}
					HX_STACK_LINE(26)
					::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(26)
					++(_g);
					HX_STACK_LINE(26)
					c->set_posChanged(true);
				}
			}
			HX_STACK_LINE(26)
			b->posChanged;
		}
		HX_STACK_LINE(26)
		v;
	}
	HX_STACK_LINE(27)
	{
		HX_STACK_LINE(27)
		Float v = this->scaleY;		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(27)
		b->scaleY = v;
		HX_STACK_LINE(27)
		{
			HX_STACK_LINE(27)
			b->posChanged = true;
			HX_STACK_LINE(27)
			if (((b->childs != null()))){
				HX_STACK_LINE(27)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(27)
				Array< ::Dynamic > _g1 = b->childs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(27)
				while((true)){
					HX_STACK_LINE(27)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(27)
						break;
					}
					HX_STACK_LINE(27)
					::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(27)
					++(_g);
					HX_STACK_LINE(27)
					c->set_posChanged(true);
				}
			}
			HX_STACK_LINE(27)
			b->posChanged;
		}
		HX_STACK_LINE(27)
		v;
	}
	HX_STACK_LINE(29)
	{
		HX_STACK_LINE(29)
		Float v = this->skewX;		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(29)
		b->skewX = v;
		HX_STACK_LINE(29)
		{
			HX_STACK_LINE(29)
			b->posChanged = true;
			HX_STACK_LINE(29)
			if (((b->childs != null()))){
				HX_STACK_LINE(29)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(29)
				Array< ::Dynamic > _g1 = b->childs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(29)
				while((true)){
					HX_STACK_LINE(29)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(29)
						break;
					}
					HX_STACK_LINE(29)
					::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(29)
					++(_g);
					HX_STACK_LINE(29)
					c->set_posChanged(true);
				}
			}
			HX_STACK_LINE(29)
			b->posChanged;
		}
		HX_STACK_LINE(29)
		v;
	}
	HX_STACK_LINE(30)
	{
		HX_STACK_LINE(30)
		Float v = this->skewY;		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(30)
		b->skewY = v;
		HX_STACK_LINE(30)
		{
			HX_STACK_LINE(30)
			b->posChanged = true;
			HX_STACK_LINE(30)
			if (((b->childs != null()))){
				HX_STACK_LINE(30)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(30)
				Array< ::Dynamic > _g1 = b->childs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(30)
				while((true)){
					HX_STACK_LINE(30)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(30)
						break;
					}
					HX_STACK_LINE(30)
					::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(30)
					++(_g);
					HX_STACK_LINE(30)
					c->set_posChanged(true);
				}
			}
			HX_STACK_LINE(30)
			b->posChanged;
		}
		HX_STACK_LINE(30)
		v;
	}
	HX_STACK_LINE(31)
	return b;
}


HX_DEFINE_DYNAMIC_FUNC0(Bitmap_obj,clone,return )

Void Bitmap_obj::draw( ::h3d::scene::RenderContext ctx){
{
		HX_STACK_FRAME("h2d.Bitmap","draw",0xebe428af,"h2d.Bitmap.draw","h2d/Bitmap.hx",35,0x3abbbeda)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ctx,"ctx")
		HX_STACK_LINE(35)
		this->drawTile(ctx->engine,this->tile);
	}
return null();
}


::h2d::col::Bounds Bitmap_obj::getMyBounds( ){
	HX_STACK_FRAME("h2d.Bitmap","getMyBounds",0x5abb346c,"h2d.Bitmap.getMyBounds","h2d/Bitmap.hx",38,0x3abbbeda)
	HX_STACK_THIS(this)
	HX_STACK_LINE(39)
	::h2d::Matrix m = this->getPixSpaceMatrix(null(),this->tile);		HX_STACK_VAR(m,"m");
	HX_STACK_LINE(40)
	::h2d::col::Bounds bounds;		HX_STACK_VAR(bounds,"bounds");
	HX_STACK_LINE(40)
	{
		HX_STACK_LINE(40)
		::h2d::col::Bounds b = ::h2d::col::Bounds_obj::__new();		HX_STACK_VAR(b,"b");
		HX_STACK_LINE(40)
		b->xMin = (int)0;
		HX_STACK_LINE(40)
		b->yMin = (int)0;
		HX_STACK_LINE(40)
		b->xMax = this->tile->width;
		HX_STACK_LINE(40)
		b->yMax = this->tile->height;
		HX_STACK_LINE(40)
		bounds = b;
	}
	HX_STACK_LINE(41)
	{
		HX_STACK_LINE(41)
		::h2d::col::Point p0 = ::h2d::col::Point_obj::__new(bounds->xMin,bounds->yMin);		HX_STACK_VAR(p0,"p0");
		HX_STACK_LINE(41)
		::h2d::col::Point p1 = ::h2d::col::Point_obj::__new(bounds->xMin,bounds->yMax);		HX_STACK_VAR(p1,"p1");
		HX_STACK_LINE(41)
		::h2d::col::Point p2 = ::h2d::col::Point_obj::__new(bounds->xMax,bounds->yMin);		HX_STACK_VAR(p2,"p2");
		HX_STACK_LINE(41)
		::h2d::col::Point p3 = ::h2d::col::Point_obj::__new(bounds->xMax,bounds->yMax);		HX_STACK_VAR(p3,"p3");
		HX_STACK_LINE(41)
		{
			HX_STACK_LINE(41)
			::h2d::col::Point p;		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(41)
			if (((p0 == null()))){
				HX_STACK_LINE(41)
				p = ::h2d::col::Point_obj::__new(null(),null());
			}
			else{
				HX_STACK_LINE(41)
				p = p0;
			}
			HX_STACK_LINE(41)
			Float px = p0->x;		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(41)
			Float py = p0->y;		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(41)
			p->x = (((px * m->a) + (py * m->c)) + m->tx);
			HX_STACK_LINE(41)
			p->y = (((px * m->b) + (py * m->d)) + m->ty);
			HX_STACK_LINE(41)
			p;
		}
		HX_STACK_LINE(41)
		{
			HX_STACK_LINE(41)
			::h2d::col::Point p;		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(41)
			if (((p1 == null()))){
				HX_STACK_LINE(41)
				p = ::h2d::col::Point_obj::__new(null(),null());
			}
			else{
				HX_STACK_LINE(41)
				p = p1;
			}
			HX_STACK_LINE(41)
			Float px = p1->x;		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(41)
			Float py = p1->y;		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(41)
			p->x = (((px * m->a) + (py * m->c)) + m->tx);
			HX_STACK_LINE(41)
			p->y = (((px * m->b) + (py * m->d)) + m->ty);
			HX_STACK_LINE(41)
			p;
		}
		HX_STACK_LINE(41)
		{
			HX_STACK_LINE(41)
			::h2d::col::Point p;		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(41)
			if (((p2 == null()))){
				HX_STACK_LINE(41)
				p = ::h2d::col::Point_obj::__new(null(),null());
			}
			else{
				HX_STACK_LINE(41)
				p = p2;
			}
			HX_STACK_LINE(41)
			Float px = p2->x;		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(41)
			Float py = p2->y;		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(41)
			p->x = (((px * m->a) + (py * m->c)) + m->tx);
			HX_STACK_LINE(41)
			p->y = (((px * m->b) + (py * m->d)) + m->ty);
			HX_STACK_LINE(41)
			p;
		}
		HX_STACK_LINE(41)
		{
			HX_STACK_LINE(41)
			::h2d::col::Point p;		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(41)
			if (((p3 == null()))){
				HX_STACK_LINE(41)
				p = ::h2d::col::Point_obj::__new(null(),null());
			}
			else{
				HX_STACK_LINE(41)
				p = p3;
			}
			HX_STACK_LINE(41)
			Float px = p3->x;		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(41)
			Float py = p3->y;		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(41)
			p->x = (((px * m->a) + (py * m->c)) + m->tx);
			HX_STACK_LINE(41)
			p->y = (((px * m->b) + (py * m->d)) + m->ty);
			HX_STACK_LINE(41)
			p;
		}
		HX_STACK_LINE(41)
		{
			HX_STACK_LINE(41)
			bounds->xMin = p0->x;
			HX_STACK_LINE(41)
			bounds->yMin = p0->y;
		}
		HX_STACK_LINE(41)
		{
			HX_STACK_LINE(41)
			bounds->xMax = p0->x;
			HX_STACK_LINE(41)
			bounds->yMax = p0->y;
		}
		HX_STACK_LINE(41)
		{
			HX_STACK_LINE(41)
			if (((p1->x < bounds->xMin))){
				HX_STACK_LINE(41)
				bounds->xMin = p1->x;
			}
			HX_STACK_LINE(41)
			if (((p1->x > bounds->xMax))){
				HX_STACK_LINE(41)
				bounds->xMax = p1->x;
			}
			HX_STACK_LINE(41)
			if (((p1->y < bounds->yMin))){
				HX_STACK_LINE(41)
				bounds->yMin = p1->y;
			}
			HX_STACK_LINE(41)
			if (((p1->y > bounds->yMax))){
				HX_STACK_LINE(41)
				bounds->yMax = p1->y;
			}
		}
		HX_STACK_LINE(41)
		{
			HX_STACK_LINE(41)
			if (((p2->x < bounds->xMin))){
				HX_STACK_LINE(41)
				bounds->xMin = p2->x;
			}
			HX_STACK_LINE(41)
			if (((p2->x > bounds->xMax))){
				HX_STACK_LINE(41)
				bounds->xMax = p2->x;
			}
			HX_STACK_LINE(41)
			if (((p2->y < bounds->yMin))){
				HX_STACK_LINE(41)
				bounds->yMin = p2->y;
			}
			HX_STACK_LINE(41)
			if (((p2->y > bounds->yMax))){
				HX_STACK_LINE(41)
				bounds->yMax = p2->y;
			}
		}
		HX_STACK_LINE(41)
		{
			HX_STACK_LINE(41)
			if (((p3->x < bounds->xMin))){
				HX_STACK_LINE(41)
				bounds->xMin = p3->x;
			}
			HX_STACK_LINE(41)
			if (((p3->x > bounds->xMax))){
				HX_STACK_LINE(41)
				bounds->xMax = p3->x;
			}
			HX_STACK_LINE(41)
			if (((p3->y < bounds->yMin))){
				HX_STACK_LINE(41)
				bounds->yMin = p3->y;
			}
			HX_STACK_LINE(41)
			if (((p3->y > bounds->yMax))){
				HX_STACK_LINE(41)
				bounds->yMax = p3->y;
			}
		}
		HX_STACK_LINE(41)
		p0 = null();
		HX_STACK_LINE(41)
		p1 = null();
		HX_STACK_LINE(41)
		p2 = null();
		HX_STACK_LINE(41)
		p3 = null();
		HX_STACK_LINE(41)
		bounds;
	}
	HX_STACK_LINE(42)
	return bounds;
}


::h2d::Bitmap Bitmap_obj::create( ::flash::display::BitmapData bmp,::h2d::Sprite parent,Dynamic allocPos){
	HX_STACK_FRAME("h2d.Bitmap","create",0x67fc2467,"h2d.Bitmap.create","h2d/Bitmap.hx",49,0x3abbbeda)
	HX_STACK_ARG(bmp,"bmp")
	HX_STACK_ARG(parent,"parent")
	HX_STACK_ARG(allocPos,"allocPos")
	HX_STACK_LINE(50)
	::h2d::Tile _g = ::h2d::Tile_obj::fromBitmap(bmp,allocPos);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(50)
	return ::h2d::Bitmap_obj::__new(_g,parent,null());
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Bitmap_obj,create,return )

::h2d::Bitmap Bitmap_obj::fromBitmapData( ::flash::display::BitmapData bmd,::h2d::Sprite parent){
	HX_STACK_FRAME("h2d.Bitmap","fromBitmapData",0x4945a82e,"h2d.Bitmap.fromBitmapData","h2d/Bitmap.hx",55,0x3abbbeda)
	HX_STACK_ARG(bmd,"bmd")
	HX_STACK_ARG(parent,"parent")
	HX_STACK_LINE(55)
	return ::h2d::Bitmap_obj::create(bmd,parent,hx::SourceInfo(HX_CSTRING("Bitmap.hx"),55,HX_CSTRING("h2d.Bitmap"),HX_CSTRING("fromBitmapData")));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Bitmap_obj,fromBitmapData,return )

::h2d::Bitmap Bitmap_obj::fromPixels( ::hxd::Pixels pix,::h2d::Sprite parent){
	HX_STACK_FRAME("h2d.Bitmap","fromPixels",0x795d4322,"h2d.Bitmap.fromPixels","h2d/Bitmap.hx",59,0x3abbbeda)
	HX_STACK_ARG(pix,"pix")
	HX_STACK_ARG(parent,"parent")
	HX_STACK_LINE(60)
	::h2d::Tile _g = ::h2d::Tile_obj::fromPixels(pix,hx::SourceInfo(HX_CSTRING("Bitmap.hx"),60,HX_CSTRING("h2d.Bitmap"),HX_CSTRING("fromPixels")));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(60)
	return ::h2d::Bitmap_obj::__new(_g,parent,null());
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Bitmap_obj,fromPixels,return )


Bitmap_obj::Bitmap_obj()
{
}

void Bitmap_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Bitmap);
	HX_MARK_MEMBER_NAME(tile,"tile");
	::h2d::Drawable_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void Bitmap_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(tile,"tile");
	::h2d::Drawable_obj::__Visit(HX_VISIT_ARG);
}

Dynamic Bitmap_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"tile") ) { return tile; }
		if (HX_FIELD_EQ(inName,"draw") ) { return draw_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"create") ) { return create_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"fromPixels") ) { return fromPixels_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"getMyBounds") ) { return getMyBounds_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"fromBitmapData") ) { return fromBitmapData_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Bitmap_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"tile") ) { tile=inValue.Cast< ::h2d::Tile >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Bitmap_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("tile"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("create"),
	HX_CSTRING("fromBitmapData"),
	HX_CSTRING("fromPixels"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h2d::Tile*/ ,(int)offsetof(Bitmap_obj,tile),HX_CSTRING("tile")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("tile"),
	HX_CSTRING("clone"),
	HX_CSTRING("draw"),
	HX_CSTRING("getMyBounds"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Bitmap_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Bitmap_obj::__mClass,"__mClass");
};

#endif

Class Bitmap_obj::__mClass;

void Bitmap_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.Bitmap"), hx::TCanCast< Bitmap_obj> ,sStaticFields,sMemberFields,
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

void Bitmap_obj::__boot()
{
}

} // end namespace h2d
