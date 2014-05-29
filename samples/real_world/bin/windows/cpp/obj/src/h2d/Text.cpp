#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_h2d_Align
#include <h2d/Align.h>
#endif
#ifndef INCLUDED_h2d_BlendMode
#include <h2d/BlendMode.h>
#endif
#ifndef INCLUDED_h2d_Drawable
#include <h2d/Drawable.h>
#endif
#ifndef INCLUDED_h2d_DrawableShader
#include <h2d/DrawableShader.h>
#endif
#ifndef INCLUDED_h2d_Font
#include <h2d/Font.h>
#endif
#ifndef INCLUDED_h2d_FontChar
#include <h2d/FontChar.h>
#endif
#ifndef INCLUDED_h2d_Matrix
#include <h2d/Matrix.h>
#endif
#ifndef INCLUDED_h2d_Sprite
#include <h2d/Sprite.h>
#endif
#ifndef INCLUDED_h2d_Text
#include <h2d/Text.h>
#endif
#ifndef INCLUDED_h2d_Tile
#include <h2d/Tile.h>
#endif
#ifndef INCLUDED_h2d_TileGroup
#include <h2d/TileGroup.h>
#endif
#ifndef INCLUDED_h2d__TileGroup_TileLayerContent
#include <h2d/_TileGroup/TileLayerContent.h>
#endif
#ifndef INCLUDED_h2d_col_Bounds
#include <h2d/col/Bounds.h>
#endif
#ifndef INCLUDED_h2d_col_Point
#include <h2d/col/Point.h>
#endif
#ifndef INCLUDED_h3d_Vector
#include <h3d/Vector.h>
#endif
#ifndef INCLUDED_h3d_impl_Shader
#include <h3d/impl/Shader.h>
#endif
#ifndef INCLUDED_h3d_prim_Primitive
#include <h3d/prim/Primitive.h>
#endif
#ifndef INCLUDED_h3d_scene_RenderContext
#include <h3d/scene/RenderContext.h>
#endif
#ifndef INCLUDED_haxe_Utf8
#include <haxe/Utf8.h>
#endif
#ifndef INCLUDED_haxe_ds_IntMap
#include <haxe/ds/IntMap.h>
#endif
#ifndef INCLUDED_hxd_Charset
#include <hxd/Charset.h>
#endif
namespace h2d{

Void Text_obj::__construct(::h2d::Font font,::h2d::Sprite parent)
{
HX_STACK_FRAME("h2d.Text","new",0xf63cb0d3,"h2d.Text.new","h2d/Text.hx",42,0x3b72fc1c)
HX_STACK_THIS(this)
HX_STACK_ARG(font,"font")
HX_STACK_ARG(parent,"parent")
{
	HX_STACK_LINE(43)
	super::__construct(parent,null());
	HX_STACK_LINE(44)
	this->set_font(font);
	HX_STACK_LINE(45)
	this->set_textAlign(::h2d::Align_obj::Left);
	HX_STACK_LINE(46)
	this->set_letterSpacing((int)1);
	HX_STACK_LINE(47)
	this->set_text(HX_CSTRING(""));
	HX_STACK_LINE(48)
	this->set_textColor((int)16777215);
}
;
	return null();
}

//Text_obj::~Text_obj() { }

Dynamic Text_obj::__CreateEmpty() { return  new Text_obj; }
hx::ObjectPtr< Text_obj > Text_obj::__new(::h2d::Font font,::h2d::Sprite parent)
{  hx::ObjectPtr< Text_obj > result = new Text_obj();
	result->__construct(font,parent);
	return result;}

Dynamic Text_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Text_obj > result = new Text_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

::h2d::Font Text_obj::set_font( ::h2d::Font font){
	HX_STACK_FRAME("h2d.Text","set_font",0xfece1179,"h2d.Text.set_font","h2d/Text.hx",51,0x3b72fc1c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(font,"font")
	HX_STACK_LINE(52)
	this->font = font;
	HX_STACK_LINE(53)
	if (((this->glyphs != null()))){
		HX_STACK_LINE(53)
		::h2d::TileGroup _this = this->glyphs;		HX_STACK_VAR(_this,"_this");
		HX_STACK_LINE(53)
		if (((bool((_this != null())) && bool((_this->parent != null()))))){
			HX_STACK_LINE(53)
			_this->parent->removeChild(_this);
		}
	}
	HX_STACK_LINE(54)
	::h2d::TileGroup _g = ::h2d::TileGroup_obj::__new((  (((font == null()))) ? ::h2d::Tile(null()) : ::h2d::Tile(font->tile) ),hx::ObjectPtr<OBJ_>(this));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(54)
	this->glyphs = _g;
	HX_STACK_LINE(55)
	this->shader = this->glyphs->shader;
	HX_STACK_LINE(56)
	this->rebuild();
	HX_STACK_LINE(57)
	return font;
}


HX_DEFINE_DYNAMIC_FUNC1(Text_obj,set_font,return )

::h2d::Align Text_obj::set_textAlign( ::h2d::Align a){
	HX_STACK_FRAME("h2d.Text","set_textAlign",0xaa93aaee,"h2d.Text.set_textAlign","h2d/Text.hx",60,0x3b72fc1c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(a,"a")
	HX_STACK_LINE(61)
	this->textAlign = a;
	HX_STACK_LINE(62)
	this->rebuild();
	HX_STACK_LINE(63)
	return a;
}


HX_DEFINE_DYNAMIC_FUNC1(Text_obj,set_textAlign,return )

int Text_obj::set_letterSpacing( int s){
	HX_STACK_FRAME("h2d.Text","set_letterSpacing",0xb39b3e53,"h2d.Text.set_letterSpacing","h2d/Text.hx",66,0x3b72fc1c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(s,"s")
	HX_STACK_LINE(67)
	this->letterSpacing = s;
	HX_STACK_LINE(68)
	this->rebuild();
	HX_STACK_LINE(69)
	return s;
}


HX_DEFINE_DYNAMIC_FUNC1(Text_obj,set_letterSpacing,return )

Void Text_obj::onAlloc( ){
{
		HX_STACK_FRAME("h2d.Text","onAlloc",0xbabed8c9,"h2d.Text.onAlloc","h2d/Text.hx",72,0x3b72fc1c)
		HX_STACK_THIS(this)
		HX_STACK_LINE(73)
		this->super::onAlloc();
		HX_STACK_LINE(74)
		this->rebuild();
	}
return null();
}


Void Text_obj::draw( ::h3d::scene::RenderContext ctx){
{
		HX_STACK_FRAME("h2d.Text","draw",0x784bb031,"h2d.Text.draw","h2d/Text.hx",77,0x3b72fc1c)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ctx,"ctx")
		HX_STACK_LINE(78)
		this->glyphs->set_blendMode(this->blendMode);
		HX_STACK_LINE(79)
		if (((this->dropShadow != null()))){
			HX_STACK_LINE(80)
			{
				HX_STACK_LINE(80)
				::h2d::TileGroup _g = this->glyphs;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(80)
				{
					HX_STACK_LINE(80)
					Float v = (_g->x + this->dropShadow->__Field(HX_CSTRING("dx"),true));		HX_STACK_VAR(v,"v");
					HX_STACK_LINE(80)
					_g->x = v;
					HX_STACK_LINE(80)
					{
						HX_STACK_LINE(80)
						_g->posChanged = true;
						HX_STACK_LINE(80)
						if (((_g->childs != null()))){
							HX_STACK_LINE(80)
							int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
							HX_STACK_LINE(80)
							Array< ::Dynamic > _g11 = _g->childs;		HX_STACK_VAR(_g11,"_g11");
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
						_g->posChanged;
					}
					HX_STACK_LINE(80)
					v;
				}
			}
			HX_STACK_LINE(81)
			{
				HX_STACK_LINE(81)
				::h2d::TileGroup _g = this->glyphs;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(81)
				{
					HX_STACK_LINE(81)
					Float v = (_g->y + this->dropShadow->__Field(HX_CSTRING("dy"),true));		HX_STACK_VAR(v,"v");
					HX_STACK_LINE(81)
					_g->y = v;
					HX_STACK_LINE(81)
					{
						HX_STACK_LINE(81)
						_g->posChanged = true;
						HX_STACK_LINE(81)
						if (((_g->childs != null()))){
							HX_STACK_LINE(81)
							int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
							HX_STACK_LINE(81)
							Array< ::Dynamic > _g11 = _g->childs;		HX_STACK_VAR(_g11,"_g11");
							HX_STACK_LINE(81)
							while((true)){
								HX_STACK_LINE(81)
								if ((!(((_g1 < _g11->length))))){
									HX_STACK_LINE(81)
									break;
								}
								HX_STACK_LINE(81)
								::h2d::Sprite c = _g11->__get(_g1).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
								HX_STACK_LINE(81)
								++(_g1);
								HX_STACK_LINE(81)
								c->set_posChanged(true);
							}
						}
						HX_STACK_LINE(81)
						_g->posChanged;
					}
					HX_STACK_LINE(81)
					v;
				}
			}
			HX_STACK_LINE(82)
			this->glyphs->calcAbsPos();
			HX_STACK_LINE(83)
			::h3d::Vector old = this->glyphs->get_color();		HX_STACK_VAR(old,"old");
			HX_STACK_LINE(84)
			::h3d::Vector _g;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(84)
			{
				HX_STACK_LINE(84)
				int c = this->dropShadow->__Field(HX_CSTRING("color"),true);		HX_STACK_VAR(c,"c");
				HX_STACK_LINE(84)
				Float scale = 1.0;		HX_STACK_VAR(scale,"scale");
				HX_STACK_LINE(84)
				Float s = (Float(scale) / Float((int)255));		HX_STACK_VAR(s,"s");
				HX_STACK_LINE(84)
				_g = ::h3d::Vector_obj::__new((((int((int(c) >> int((int)16))) & int((int)255))) * s),(((int((int(c) >> int((int)8))) & int((int)255))) * s),(((int(c) & int((int)255))) * s),((hx::UShr(c,(int)24)) * s));
			}
			HX_STACK_LINE(84)
			this->glyphs->set_color(_g);
			HX_STACK_LINE(85)
			this->glyphs->get_color()->w = this->dropShadow->__Field(HX_CSTRING("alpha"),true);
			HX_STACK_LINE(86)
			this->glyphs->draw(ctx);
			HX_STACK_LINE(87)
			{
				HX_STACK_LINE(87)
				::h2d::TileGroup _g1 = this->glyphs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(87)
				{
					HX_STACK_LINE(87)
					Float v = (_g1->x - this->dropShadow->__Field(HX_CSTRING("dx"),true));		HX_STACK_VAR(v,"v");
					HX_STACK_LINE(87)
					_g1->x = v;
					HX_STACK_LINE(87)
					{
						HX_STACK_LINE(87)
						_g1->posChanged = true;
						HX_STACK_LINE(87)
						if (((_g1->childs != null()))){
							HX_STACK_LINE(87)
							int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
							HX_STACK_LINE(87)
							Array< ::Dynamic > _g11 = _g1->childs;		HX_STACK_VAR(_g11,"_g11");
							HX_STACK_LINE(87)
							while((true)){
								HX_STACK_LINE(87)
								if ((!(((_g2 < _g11->length))))){
									HX_STACK_LINE(87)
									break;
								}
								HX_STACK_LINE(87)
								::h2d::Sprite c = _g11->__get(_g2).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
								HX_STACK_LINE(87)
								++(_g2);
								HX_STACK_LINE(87)
								c->set_posChanged(true);
							}
						}
						HX_STACK_LINE(87)
						_g1->posChanged;
					}
					HX_STACK_LINE(87)
					v;
				}
			}
			HX_STACK_LINE(88)
			{
				HX_STACK_LINE(88)
				::h2d::TileGroup _g1 = this->glyphs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(88)
				{
					HX_STACK_LINE(88)
					Float v = (_g1->y - this->dropShadow->__Field(HX_CSTRING("dy"),true));		HX_STACK_VAR(v,"v");
					HX_STACK_LINE(88)
					_g1->y = v;
					HX_STACK_LINE(88)
					{
						HX_STACK_LINE(88)
						_g1->posChanged = true;
						HX_STACK_LINE(88)
						if (((_g1->childs != null()))){
							HX_STACK_LINE(88)
							int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
							HX_STACK_LINE(88)
							Array< ::Dynamic > _g11 = _g1->childs;		HX_STACK_VAR(_g11,"_g11");
							HX_STACK_LINE(88)
							while((true)){
								HX_STACK_LINE(88)
								if ((!(((_g2 < _g11->length))))){
									HX_STACK_LINE(88)
									break;
								}
								HX_STACK_LINE(88)
								::h2d::Sprite c = _g11->__get(_g2).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
								HX_STACK_LINE(88)
								++(_g2);
								HX_STACK_LINE(88)
								c->set_posChanged(true);
							}
						}
						HX_STACK_LINE(88)
						_g1->posChanged;
					}
					HX_STACK_LINE(88)
					v;
				}
			}
			HX_STACK_LINE(89)
			this->glyphs->set_color(old);
		}
		HX_STACK_LINE(91)
		this->super::draw(ctx);
	}
return null();
}


::h2d::col::Bounds Text_obj::getMyBounds( ){
	HX_STACK_FRAME("h2d.Text","getMyBounds",0xdf00812a,"h2d.Text.getMyBounds","h2d/Text.hx",95,0x3b72fc1c)
	HX_STACK_THIS(this)
	HX_STACK_LINE(96)
	::h2d::Matrix m = this->getPixSpaceMatrix(null(),null());		HX_STACK_VAR(m,"m");
	HX_STACK_LINE(97)
	::h2d::col::Bounds bounds;		HX_STACK_VAR(bounds,"bounds");
	HX_STACK_LINE(97)
	{
		HX_STACK_LINE(97)
		Float width = this->get_textWidth();		HX_STACK_VAR(width,"width");
		HX_STACK_LINE(97)
		Float height = this->get_textHeight();		HX_STACK_VAR(height,"height");
		HX_STACK_LINE(97)
		::h2d::col::Bounds b = ::h2d::col::Bounds_obj::__new();		HX_STACK_VAR(b,"b");
		HX_STACK_LINE(97)
		b->xMin = (int)0;
		HX_STACK_LINE(97)
		b->yMin = (int)0;
		HX_STACK_LINE(97)
		b->xMax = width;
		HX_STACK_LINE(97)
		b->yMax = height;
		HX_STACK_LINE(97)
		bounds = b;
	}
	HX_STACK_LINE(98)
	{
		HX_STACK_LINE(98)
		::h2d::col::Point p0 = ::h2d::col::Point_obj::__new(bounds->xMin,bounds->yMin);		HX_STACK_VAR(p0,"p0");
		HX_STACK_LINE(98)
		::h2d::col::Point p1 = ::h2d::col::Point_obj::__new(bounds->xMin,bounds->yMax);		HX_STACK_VAR(p1,"p1");
		HX_STACK_LINE(98)
		::h2d::col::Point p2 = ::h2d::col::Point_obj::__new(bounds->xMax,bounds->yMin);		HX_STACK_VAR(p2,"p2");
		HX_STACK_LINE(98)
		::h2d::col::Point p3 = ::h2d::col::Point_obj::__new(bounds->xMax,bounds->yMax);		HX_STACK_VAR(p3,"p3");
		HX_STACK_LINE(98)
		{
			HX_STACK_LINE(98)
			::h2d::col::Point p;		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(98)
			if (((p0 == null()))){
				HX_STACK_LINE(98)
				p = ::h2d::col::Point_obj::__new(null(),null());
			}
			else{
				HX_STACK_LINE(98)
				p = p0;
			}
			HX_STACK_LINE(98)
			Float px = p0->x;		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(98)
			Float py = p0->y;		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(98)
			p->x = (((px * m->a) + (py * m->c)) + m->tx);
			HX_STACK_LINE(98)
			p->y = (((px * m->b) + (py * m->d)) + m->ty);
			HX_STACK_LINE(98)
			p;
		}
		HX_STACK_LINE(98)
		{
			HX_STACK_LINE(98)
			::h2d::col::Point p;		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(98)
			if (((p1 == null()))){
				HX_STACK_LINE(98)
				p = ::h2d::col::Point_obj::__new(null(),null());
			}
			else{
				HX_STACK_LINE(98)
				p = p1;
			}
			HX_STACK_LINE(98)
			Float px = p1->x;		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(98)
			Float py = p1->y;		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(98)
			p->x = (((px * m->a) + (py * m->c)) + m->tx);
			HX_STACK_LINE(98)
			p->y = (((px * m->b) + (py * m->d)) + m->ty);
			HX_STACK_LINE(98)
			p;
		}
		HX_STACK_LINE(98)
		{
			HX_STACK_LINE(98)
			::h2d::col::Point p;		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(98)
			if (((p2 == null()))){
				HX_STACK_LINE(98)
				p = ::h2d::col::Point_obj::__new(null(),null());
			}
			else{
				HX_STACK_LINE(98)
				p = p2;
			}
			HX_STACK_LINE(98)
			Float px = p2->x;		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(98)
			Float py = p2->y;		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(98)
			p->x = (((px * m->a) + (py * m->c)) + m->tx);
			HX_STACK_LINE(98)
			p->y = (((px * m->b) + (py * m->d)) + m->ty);
			HX_STACK_LINE(98)
			p;
		}
		HX_STACK_LINE(98)
		{
			HX_STACK_LINE(98)
			::h2d::col::Point p;		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(98)
			if (((p3 == null()))){
				HX_STACK_LINE(98)
				p = ::h2d::col::Point_obj::__new(null(),null());
			}
			else{
				HX_STACK_LINE(98)
				p = p3;
			}
			HX_STACK_LINE(98)
			Float px = p3->x;		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(98)
			Float py = p3->y;		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(98)
			p->x = (((px * m->a) + (py * m->c)) + m->tx);
			HX_STACK_LINE(98)
			p->y = (((px * m->b) + (py * m->d)) + m->ty);
			HX_STACK_LINE(98)
			p;
		}
		HX_STACK_LINE(98)
		{
			HX_STACK_LINE(98)
			bounds->xMin = p0->x;
			HX_STACK_LINE(98)
			bounds->yMin = p0->y;
		}
		HX_STACK_LINE(98)
		{
			HX_STACK_LINE(98)
			bounds->xMax = p0->x;
			HX_STACK_LINE(98)
			bounds->yMax = p0->y;
		}
		HX_STACK_LINE(98)
		{
			HX_STACK_LINE(98)
			if (((p1->x < bounds->xMin))){
				HX_STACK_LINE(98)
				bounds->xMin = p1->x;
			}
			HX_STACK_LINE(98)
			if (((p1->x > bounds->xMax))){
				HX_STACK_LINE(98)
				bounds->xMax = p1->x;
			}
			HX_STACK_LINE(98)
			if (((p1->y < bounds->yMin))){
				HX_STACK_LINE(98)
				bounds->yMin = p1->y;
			}
			HX_STACK_LINE(98)
			if (((p1->y > bounds->yMax))){
				HX_STACK_LINE(98)
				bounds->yMax = p1->y;
			}
		}
		HX_STACK_LINE(98)
		{
			HX_STACK_LINE(98)
			if (((p2->x < bounds->xMin))){
				HX_STACK_LINE(98)
				bounds->xMin = p2->x;
			}
			HX_STACK_LINE(98)
			if (((p2->x > bounds->xMax))){
				HX_STACK_LINE(98)
				bounds->xMax = p2->x;
			}
			HX_STACK_LINE(98)
			if (((p2->y < bounds->yMin))){
				HX_STACK_LINE(98)
				bounds->yMin = p2->y;
			}
			HX_STACK_LINE(98)
			if (((p2->y > bounds->yMax))){
				HX_STACK_LINE(98)
				bounds->yMax = p2->y;
			}
		}
		HX_STACK_LINE(98)
		{
			HX_STACK_LINE(98)
			if (((p3->x < bounds->xMin))){
				HX_STACK_LINE(98)
				bounds->xMin = p3->x;
			}
			HX_STACK_LINE(98)
			if (((p3->x > bounds->xMax))){
				HX_STACK_LINE(98)
				bounds->xMax = p3->x;
			}
			HX_STACK_LINE(98)
			if (((p3->y < bounds->yMin))){
				HX_STACK_LINE(98)
				bounds->yMin = p3->y;
			}
			HX_STACK_LINE(98)
			if (((p3->y > bounds->yMax))){
				HX_STACK_LINE(98)
				bounds->yMax = p3->y;
			}
		}
		HX_STACK_LINE(98)
		p0 = null();
		HX_STACK_LINE(98)
		p1 = null();
		HX_STACK_LINE(98)
		p2 = null();
		HX_STACK_LINE(98)
		p3 = null();
		HX_STACK_LINE(98)
		bounds;
	}
	HX_STACK_LINE(99)
	return bounds;
}


::String Text_obj::set_text( ::String t){
	HX_STACK_FRAME("h2d.Text","set_text",0x08078057,"h2d.Text.set_text","h2d/Text.hx",102,0x3b72fc1c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(t,"t")
	HX_STACK_LINE(103)
	::String t1;		HX_STACK_VAR(t1,"t1");
	HX_STACK_LINE(103)
	if (((t == null()))){
		HX_STACK_LINE(103)
		t1 = HX_CSTRING("null");
	}
	else{
		HX_STACK_LINE(103)
		t1 = t;
	}
	HX_STACK_LINE(104)
	if (((t1 == this->text))){
		HX_STACK_LINE(104)
		return t1;
	}
	HX_STACK_LINE(105)
	this->text = t1;
	HX_STACK_LINE(106)
	this->rebuild();
	HX_STACK_LINE(107)
	return t1;
}


HX_DEFINE_DYNAMIC_FUNC1(Text_obj,set_text,return )

Void Text_obj::rebuild( ){
{
		HX_STACK_FRAME("h2d.Text","rebuild",0xa472c48e,"h2d.Text.rebuild","h2d/Text.hx",111,0x3b72fc1c)
		HX_STACK_THIS(this)
		HX_STACK_LINE(111)
		if (((bool((bool(this->allocated) && bool((this->text != null())))) && bool((this->font != null()))))){
			HX_STACK_LINE(111)
			this->initGlyphs(this->text,null(),null());
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Text_obj,rebuild,(void))

int Text_obj::calcTextWidth( ::String text){
	HX_STACK_FRAME("h2d.Text","calcTextWidth",0x8c68e0f7,"h2d.Text.calcTextWidth","h2d/Text.hx",115,0x3b72fc1c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(text,"text")
	HX_STACK_LINE(115)
	return this->initGlyphs(text,false,null())->__Field(HX_CSTRING("width"),true);
}


HX_DEFINE_DYNAMIC_FUNC1(Text_obj,calcTextWidth,return )

Dynamic Text_obj::initGlyphs( ::String text,hx::Null< bool >  __o_rebuild,Array< int > lines){
bool rebuild = __o_rebuild.Default(true);
	HX_STACK_FRAME("h2d.Text","initGlyphs",0x9f3ab864,"h2d.Text.initGlyphs","h2d/Text.hx",118,0x3b72fc1c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(text,"text")
	HX_STACK_ARG(rebuild,"rebuild")
	HX_STACK_ARG(lines,"lines")
{
		HX_STACK_LINE(119)
		if ((rebuild)){
			HX_STACK_LINE(119)
			this->glyphs->reset();
		}
		HX_STACK_LINE(120)
		int x = (int)0;		HX_STACK_VAR(x,"x");
		HX_STACK_LINE(120)
		int y = (int)0;		HX_STACK_VAR(y,"y");
		HX_STACK_LINE(120)
		int xMax = (int)0;		HX_STACK_VAR(xMax,"xMax");
		HX_STACK_LINE(120)
		int prevChar = (int)-1;		HX_STACK_VAR(prevChar,"prevChar");
		HX_STACK_LINE(121)
		::h2d::Align align;		HX_STACK_VAR(align,"align");
		HX_STACK_LINE(121)
		if ((rebuild)){
			HX_STACK_LINE(121)
			align = this->textAlign;
		}
		else{
			HX_STACK_LINE(121)
			align = ::h2d::Align_obj::Left;
		}
		HX_STACK_LINE(122)
		switch( (int)(align->__Index())){
			case (int)2: case (int)1: {
				HX_STACK_LINE(124)
				lines = Array_obj< int >::__new();
				HX_STACK_LINE(125)
				Dynamic inf = this->initGlyphs(text,false,lines);		HX_STACK_VAR(inf,"inf");
				HX_STACK_LINE(126)
				int max;		HX_STACK_VAR(max,"max");
				HX_STACK_LINE(126)
				if (((this->maxWidth == null()))){
					HX_STACK_LINE(126)
					max = inf->__Field(HX_CSTRING("width"),true);
				}
				else{
					HX_STACK_LINE(126)
					max = ::Std_obj::_int(this->maxWidth);
				}
				HX_STACK_LINE(127)
				int k;		HX_STACK_VAR(k,"k");
				HX_STACK_LINE(127)
				if (((align == ::h2d::Align_obj::Center))){
					HX_STACK_LINE(127)
					k = (int)1;
				}
				else{
					HX_STACK_LINE(127)
					k = (int)0;
				}
				HX_STACK_LINE(128)
				{
					HX_STACK_LINE(128)
					int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(128)
					int _g = lines->length;		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(128)
					while((true)){
						HX_STACK_LINE(128)
						if ((!(((_g1 < _g))))){
							HX_STACK_LINE(128)
							break;
						}
						HX_STACK_LINE(128)
						int i = (_g1)++;		HX_STACK_VAR(i,"i");
						HX_STACK_LINE(129)
						lines[i] = (int((max - lines->__get(i))) >> int(k));
					}
				}
				HX_STACK_LINE(130)
				Dynamic _g = lines->shift();		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(130)
				x = _g;
			}
			;break;
			default: {
			}
		}
		HX_STACK_LINE(133)
		bool calcLines = (bool(!(rebuild)) && bool((lines != null())));		HX_STACK_VAR(calcLines,"calcLines");
		HX_STACK_LINE(135)
		{
			HX_STACK_LINE(135)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(135)
			int _g = ::haxe::Utf8_obj::length(text);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(135)
			while((true)){
				HX_STACK_LINE(135)
				if ((!(((_g1 < _g))))){
					HX_STACK_LINE(135)
					break;
				}
				HX_STACK_LINE(135)
				int i = (_g1)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(136)
				int cc = ::haxe::Utf8_obj::charCodeAt(text,i);		HX_STACK_VAR(cc,"cc");
				HX_STACK_LINE(137)
				::h2d::FontChar e;		HX_STACK_VAR(e,"e");
				HX_STACK_LINE(137)
				{
					HX_STACK_LINE(137)
					::h2d::Font _this = this->font;		HX_STACK_VAR(_this,"_this");
					HX_STACK_LINE(137)
					::h2d::FontChar c = _this->glyphs->get(cc);		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(137)
					if (((c == null()))){
						HX_STACK_LINE(137)
						::h2d::FontChar _g11 = _this->charset->resolveChar(cc,_this->glyphs);		HX_STACK_VAR(_g11,"_g11");
						HX_STACK_LINE(137)
						c = _g11;
						HX_STACK_LINE(137)
						if (((c == null()))){
							HX_STACK_LINE(137)
							c = _this->defaultChar;
						}
					}
					HX_STACK_LINE(137)
					e = c;
				}
				HX_STACK_LINE(138)
				bool newline = (cc == (int)10);		HX_STACK_VAR(newline,"newline");
				HX_STACK_LINE(139)
				int _g2 = e->getKerningOffset(prevChar);		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(139)
				int esize = (e->width + _g2);		HX_STACK_VAR(esize,"esize");
				HX_STACK_LINE(141)
				if (((  ((this->font->charset->isBreakChar(cc))) ? bool((this->maxWidth != null())) : bool(false) ))){
					HX_STACK_LINE(142)
					int size = ((x + esize) + this->letterSpacing);		HX_STACK_VAR(size,"size");
					HX_STACK_LINE(143)
					int k = (i + (int)1);		HX_STACK_VAR(k,"k");
					HX_STACK_LINE(143)
					int max = text.length;		HX_STACK_VAR(max,"max");
					HX_STACK_LINE(144)
					int prevChar1 = prevChar;		HX_STACK_VAR(prevChar1,"prevChar1");
					HX_STACK_LINE(145)
					while((true)){
						HX_STACK_LINE(145)
						if ((!(((bool((size <= this->maxWidth)) && bool((k < text.length))))))){
							HX_STACK_LINE(145)
							break;
						}
						HX_STACK_LINE(146)
						int _g3 = (k)++;		HX_STACK_VAR(_g3,"_g3");
						HX_STACK_LINE(146)
						int cc1 = ::haxe::Utf8_obj::charCodeAt(text,_g3);		HX_STACK_VAR(cc1,"cc1");
						HX_STACK_LINE(147)
						if (((  ((!(this->font->charset->isSpace(cc1)))) ? bool((cc1 == (int)10)) : bool(true) ))){
							HX_STACK_LINE(147)
							break;
						}
						HX_STACK_LINE(148)
						::h2d::FontChar e1;		HX_STACK_VAR(e1,"e1");
						HX_STACK_LINE(148)
						{
							HX_STACK_LINE(148)
							::h2d::Font _this = this->font;		HX_STACK_VAR(_this,"_this");
							HX_STACK_LINE(148)
							::h2d::FontChar c = _this->glyphs->get(cc1);		HX_STACK_VAR(c,"c");
							HX_STACK_LINE(148)
							if (((c == null()))){
								HX_STACK_LINE(148)
								::h2d::FontChar _g4 = _this->charset->resolveChar(cc1,_this->glyphs);		HX_STACK_VAR(_g4,"_g4");
								HX_STACK_LINE(148)
								c = _g4;
								HX_STACK_LINE(148)
								if (((c == null()))){
									HX_STACK_LINE(148)
									c = _this->defaultChar;
								}
							}
							HX_STACK_LINE(148)
							e1 = c;
						}
						HX_STACK_LINE(149)
						int _g5 = e1->getKerningOffset(prevChar1);		HX_STACK_VAR(_g5,"_g5");
						HX_STACK_LINE(149)
						int _g6 = ((e1->width + this->letterSpacing) + _g5);		HX_STACK_VAR(_g6,"_g6");
						HX_STACK_LINE(149)
						hx::AddEq(size,_g6);
						HX_STACK_LINE(150)
						prevChar1 = cc1;
					}
					HX_STACK_LINE(152)
					if (((size > this->maxWidth))){
						HX_STACK_LINE(153)
						newline = true;
						HX_STACK_LINE(154)
						if ((this->font->charset->isSpace(cc))){
							HX_STACK_LINE(154)
							e = null();
						}
					}
				}
				HX_STACK_LINE(157)
				if (((e != null()))){
					HX_STACK_LINE(158)
					if ((rebuild)){
						HX_STACK_LINE(158)
						this->glyphs->content->add(x,y,e->t);
					}
					HX_STACK_LINE(159)
					hx::AddEq(x,(esize + this->letterSpacing));
				}
				HX_STACK_LINE(161)
				if ((newline)){
					HX_STACK_LINE(162)
					if (((x > xMax))){
						HX_STACK_LINE(162)
						xMax = x;
					}
					HX_STACK_LINE(163)
					if ((calcLines)){
						HX_STACK_LINE(163)
						lines->push(x);
					}
					HX_STACK_LINE(164)
					if ((rebuild)){
						HX_STACK_LINE(165)
						switch( (int)(align->__Index())){
							case (int)0: {
								HX_STACK_LINE(167)
								x = (int)0;
							}
							;break;
							case (int)1: case (int)2: {
								HX_STACK_LINE(169)
								Dynamic _g7 = lines->shift();		HX_STACK_VAR(_g7,"_g7");
								HX_STACK_LINE(169)
								x = _g7;
							}
							;break;
						}
					}
					else{
						HX_STACK_LINE(172)
						x = (int)0;
					}
					HX_STACK_LINE(173)
					hx::AddEq(y,this->font->lineHeight);
					HX_STACK_LINE(174)
					prevChar = (int)-1;
				}
				else{
					HX_STACK_LINE(176)
					prevChar = cc;
				}
			}
		}
		HX_STACK_LINE(178)
		if ((calcLines)){
			HX_STACK_LINE(178)
			lines->push(x);
		}
		struct _Function_1_1{
			inline static Dynamic Block( hx::ObjectPtr< ::h2d::Text_obj > __this,int &xMax,int &x,int &y){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h2d/Text.hx",179,0x3b72fc1c)
				{
					hx::Anon __result = hx::Anon_obj::Create();
					__result->Add(HX_CSTRING("width") , (  (((x > xMax))) ? int(x) : int(xMax) ),false);
					__result->Add(HX_CSTRING("height") , (  (((x > (int)0))) ? int((y + __this->font->lineHeight)) : int((  (((y > (int)0))) ? int(y) : int(__this->font->lineHeight) )) ),false);
					return __result;
				}
				return null();
			}
		};
		HX_STACK_LINE(179)
		return _Function_1_1::Block(this,xMax,x,y);
	}
}


HX_DEFINE_DYNAMIC_FUNC3(Text_obj,initGlyphs,return )

int Text_obj::get_textHeight( ){
	HX_STACK_FRAME("h2d.Text","get_textHeight",0x3b336f2a,"h2d.Text.get_textHeight","h2d/Text.hx",183,0x3b72fc1c)
	HX_STACK_THIS(this)
	HX_STACK_LINE(183)
	return this->initGlyphs(this->text,false,null())->__Field(HX_CSTRING("height"),true);
}


HX_DEFINE_DYNAMIC_FUNC0(Text_obj,get_textHeight,return )

int Text_obj::get_textWidth( ){
	HX_STACK_FRAME("h2d.Text","get_textWidth",0x0e5f2823,"h2d.Text.get_textWidth","h2d/Text.hx",187,0x3b72fc1c)
	HX_STACK_THIS(this)
	HX_STACK_LINE(187)
	return this->initGlyphs(this->text,false,null())->__Field(HX_CSTRING("width"),true);
}


HX_DEFINE_DYNAMIC_FUNC0(Text_obj,get_textWidth,return )

Dynamic Text_obj::set_maxWidth( Dynamic w){
	HX_STACK_FRAME("h2d.Text","set_maxWidth",0xd601d96c,"h2d.Text.set_maxWidth","h2d/Text.hx",190,0x3b72fc1c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(w,"w")
	HX_STACK_LINE(191)
	this->maxWidth = w;
	HX_STACK_LINE(192)
	this->rebuild();
	HX_STACK_LINE(193)
	return w;
}


HX_DEFINE_DYNAMIC_FUNC1(Text_obj,set_maxWidth,return )

int Text_obj::set_textColor( int c){
	HX_STACK_FRAME("h2d.Text","set_textColor",0xd35ec58c,"h2d.Text.set_textColor","h2d/Text.hx",196,0x3b72fc1c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(c,"c")
	HX_STACK_LINE(197)
	this->textColor = c;
	HX_STACK_LINE(198)
	::h3d::Vector _g;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(198)
	{
		HX_STACK_LINE(198)
		Float scale = 1.0;		HX_STACK_VAR(scale,"scale");
		HX_STACK_LINE(198)
		Float s = (Float(scale) / Float((int)255));		HX_STACK_VAR(s,"s");
		HX_STACK_LINE(198)
		_g = ::h3d::Vector_obj::__new((((int((int(c) >> int((int)16))) & int((int)255))) * s),(((int((int(c) >> int((int)8))) & int((int)255))) * s),(((int(c) & int((int)255))) * s),((hx::UShr(c,(int)24)) * s));
	}
	HX_STACK_LINE(198)
	this->glyphs->set_color(_g);
	HX_STACK_LINE(199)
	Float _g1 = this->get_alpha();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(199)
	this->glyphs->get_color()->w = _g1;
	HX_STACK_LINE(200)
	return c;
}


HX_DEFINE_DYNAMIC_FUNC1(Text_obj,set_textColor,return )


Text_obj::Text_obj()
{
}

void Text_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Text);
	HX_MARK_MEMBER_NAME(font,"font");
	HX_MARK_MEMBER_NAME(text,"text");
	HX_MARK_MEMBER_NAME(textColor,"textColor");
	HX_MARK_MEMBER_NAME(maxWidth,"maxWidth");
	HX_MARK_MEMBER_NAME(dropShadow,"dropShadow");
	HX_MARK_MEMBER_NAME(textWidth,"textWidth");
	HX_MARK_MEMBER_NAME(textHeight,"textHeight");
	HX_MARK_MEMBER_NAME(textAlign,"textAlign");
	HX_MARK_MEMBER_NAME(letterSpacing,"letterSpacing");
	HX_MARK_MEMBER_NAME(glyphs,"glyphs");
	::h2d::Drawable_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void Text_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(font,"font");
	HX_VISIT_MEMBER_NAME(text,"text");
	HX_VISIT_MEMBER_NAME(textColor,"textColor");
	HX_VISIT_MEMBER_NAME(maxWidth,"maxWidth");
	HX_VISIT_MEMBER_NAME(dropShadow,"dropShadow");
	HX_VISIT_MEMBER_NAME(textWidth,"textWidth");
	HX_VISIT_MEMBER_NAME(textHeight,"textHeight");
	HX_VISIT_MEMBER_NAME(textAlign,"textAlign");
	HX_VISIT_MEMBER_NAME(letterSpacing,"letterSpacing");
	HX_VISIT_MEMBER_NAME(glyphs,"glyphs");
	::h2d::Drawable_obj::__Visit(HX_VISIT_ARG);
}

Dynamic Text_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"font") ) { return font; }
		if (HX_FIELD_EQ(inName,"text") ) { return text; }
		if (HX_FIELD_EQ(inName,"draw") ) { return draw_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"glyphs") ) { return glyphs; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"onAlloc") ) { return onAlloc_dyn(); }
		if (HX_FIELD_EQ(inName,"rebuild") ) { return rebuild_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"maxWidth") ) { return maxWidth; }
		if (HX_FIELD_EQ(inName,"set_font") ) { return set_font_dyn(); }
		if (HX_FIELD_EQ(inName,"set_text") ) { return set_text_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"textColor") ) { return textColor; }
		if (HX_FIELD_EQ(inName,"textWidth") ) { return inCallProp ? get_textWidth() : textWidth; }
		if (HX_FIELD_EQ(inName,"textAlign") ) { return textAlign; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"dropShadow") ) { return dropShadow; }
		if (HX_FIELD_EQ(inName,"textHeight") ) { return inCallProp ? get_textHeight() : textHeight; }
		if (HX_FIELD_EQ(inName,"initGlyphs") ) { return initGlyphs_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"getMyBounds") ) { return getMyBounds_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"set_maxWidth") ) { return set_maxWidth_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"letterSpacing") ) { return letterSpacing; }
		if (HX_FIELD_EQ(inName,"set_textAlign") ) { return set_textAlign_dyn(); }
		if (HX_FIELD_EQ(inName,"calcTextWidth") ) { return calcTextWidth_dyn(); }
		if (HX_FIELD_EQ(inName,"get_textWidth") ) { return get_textWidth_dyn(); }
		if (HX_FIELD_EQ(inName,"set_textColor") ) { return set_textColor_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"get_textHeight") ) { return get_textHeight_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"set_letterSpacing") ) { return set_letterSpacing_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Text_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"font") ) { if (inCallProp) return set_font(inValue);font=inValue.Cast< ::h2d::Font >(); return inValue; }
		if (HX_FIELD_EQ(inName,"text") ) { if (inCallProp) return set_text(inValue);text=inValue.Cast< ::String >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"glyphs") ) { glyphs=inValue.Cast< ::h2d::TileGroup >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"maxWidth") ) { if (inCallProp) return set_maxWidth(inValue);maxWidth=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"textColor") ) { if (inCallProp) return set_textColor(inValue);textColor=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"textWidth") ) { textWidth=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"textAlign") ) { if (inCallProp) return set_textAlign(inValue);textAlign=inValue.Cast< ::h2d::Align >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"dropShadow") ) { dropShadow=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"textHeight") ) { textHeight=inValue.Cast< int >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"letterSpacing") ) { if (inCallProp) return set_letterSpacing(inValue);letterSpacing=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Text_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("font"));
	outFields->push(HX_CSTRING("text"));
	outFields->push(HX_CSTRING("textColor"));
	outFields->push(HX_CSTRING("maxWidth"));
	outFields->push(HX_CSTRING("dropShadow"));
	outFields->push(HX_CSTRING("textWidth"));
	outFields->push(HX_CSTRING("textHeight"));
	outFields->push(HX_CSTRING("textAlign"));
	outFields->push(HX_CSTRING("letterSpacing"));
	outFields->push(HX_CSTRING("glyphs"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h2d::Font*/ ,(int)offsetof(Text_obj,font),HX_CSTRING("font")},
	{hx::fsString,(int)offsetof(Text_obj,text),HX_CSTRING("text")},
	{hx::fsInt,(int)offsetof(Text_obj,textColor),HX_CSTRING("textColor")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Text_obj,maxWidth),HX_CSTRING("maxWidth")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Text_obj,dropShadow),HX_CSTRING("dropShadow")},
	{hx::fsInt,(int)offsetof(Text_obj,textWidth),HX_CSTRING("textWidth")},
	{hx::fsInt,(int)offsetof(Text_obj,textHeight),HX_CSTRING("textHeight")},
	{hx::fsObject /*::h2d::Align*/ ,(int)offsetof(Text_obj,textAlign),HX_CSTRING("textAlign")},
	{hx::fsInt,(int)offsetof(Text_obj,letterSpacing),HX_CSTRING("letterSpacing")},
	{hx::fsObject /*::h2d::TileGroup*/ ,(int)offsetof(Text_obj,glyphs),HX_CSTRING("glyphs")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("font"),
	HX_CSTRING("text"),
	HX_CSTRING("textColor"),
	HX_CSTRING("maxWidth"),
	HX_CSTRING("dropShadow"),
	HX_CSTRING("textWidth"),
	HX_CSTRING("textHeight"),
	HX_CSTRING("textAlign"),
	HX_CSTRING("letterSpacing"),
	HX_CSTRING("glyphs"),
	HX_CSTRING("set_font"),
	HX_CSTRING("set_textAlign"),
	HX_CSTRING("set_letterSpacing"),
	HX_CSTRING("onAlloc"),
	HX_CSTRING("draw"),
	HX_CSTRING("getMyBounds"),
	HX_CSTRING("set_text"),
	HX_CSTRING("rebuild"),
	HX_CSTRING("calcTextWidth"),
	HX_CSTRING("initGlyphs"),
	HX_CSTRING("get_textHeight"),
	HX_CSTRING("get_textWidth"),
	HX_CSTRING("set_maxWidth"),
	HX_CSTRING("set_textColor"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Text_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Text_obj::__mClass,"__mClass");
};

#endif

Class Text_obj::__mClass;

void Text_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.Text"), hx::TCanCast< Text_obj> ,sStaticFields,sMemberFields,
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

void Text_obj::__boot()
{
}

} // end namespace h2d
