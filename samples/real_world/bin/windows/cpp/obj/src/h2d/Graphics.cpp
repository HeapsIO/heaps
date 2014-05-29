#include <hxcpp.h>

#ifndef INCLUDED_h2d_Drawable
#include <h2d/Drawable.h>
#endif
#ifndef INCLUDED_h2d_DrawableShader
#include <h2d/DrawableShader.h>
#endif
#ifndef INCLUDED_h2d_Graphics
#include <h2d/Graphics.h>
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
#ifndef INCLUDED_h2d__Graphics_GraphicsContent
#include <h2d/_Graphics/GraphicsContent.h>
#endif
#ifndef INCLUDED_h2d__Graphics_LinePoint
#include <h2d/_Graphics/LinePoint.h>
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
#ifndef INCLUDED_h3d_prim_Primitive
#include <h3d/prim/Primitive.h>
#endif
#ifndef INCLUDED_h3d_scene_RenderContext
#include <h3d/scene/RenderContext.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Point
#include <hxd/poly2tri/Point.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Sweep
#include <hxd/poly2tri/Sweep.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_SweepContext
#include <hxd/poly2tri/SweepContext.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Triangle
#include <hxd/poly2tri/Triangle.h>
#endif
namespace h2d{

Void Graphics_obj::__construct(::h2d::Sprite parent)
{
HX_STACK_FRAME("h2d.Graphics","new",0x93eaadf1,"h2d.Graphics.new","h2d/Graphics.hx",121,0x5cd0883e)
HX_STACK_THIS(this)
HX_STACK_ARG(parent,"parent")
{
	HX_STACK_LINE(122)
	super::__construct(parent,null());
	HX_STACK_LINE(123)
	::h2d::col::Bounds _g = ::h2d::col::Bounds_obj::__new();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(123)
	this->curBounds = _g;
	HX_STACK_LINE(124)
	::h2d::_Graphics::GraphicsContent _g1 = ::h2d::_Graphics::GraphicsContent_obj::__new();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(124)
	this->content = _g1;
	HX_STACK_LINE(125)
	this->shader->hasVertexColor = true;
	HX_STACK_LINE(126)
	::h2d::Tile _g2 = ::h2d::Tile_obj::fromColor((int)-1,null(),null(),hx::SourceInfo(HX_CSTRING("Graphics.hx"),126,HX_CSTRING("h2d.Graphics"),HX_CSTRING("new")));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(126)
	this->tile = _g2;
	HX_STACK_LINE(127)
	this->clear();
}
;
	return null();
}

//Graphics_obj::~Graphics_obj() { }

Dynamic Graphics_obj::__CreateEmpty() { return  new Graphics_obj; }
hx::ObjectPtr< Graphics_obj > Graphics_obj::__new(::h2d::Sprite parent)
{  hx::ObjectPtr< Graphics_obj > result = new Graphics_obj();
	result->__construct(parent);
	return result;}

Dynamic Graphics_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Graphics_obj > result = new Graphics_obj();
	result->__construct(inArgs[0]);
	return result;}

Void Graphics_obj::onDelete( ){
{
		HX_STACK_FRAME("h2d.Graphics","onDelete",0xcfad0b79,"h2d.Graphics.onDelete","h2d/Graphics.hx",130,0x5cd0883e)
		HX_STACK_THIS(this)
		HX_STACK_LINE(131)
		this->super::onDelete();
		HX_STACK_LINE(132)
		this->clear();
	}
return null();
}


Void Graphics_obj::clear( ){
{
		HX_STACK_FRAME("h2d.Graphics","clear",0x1591955e,"h2d.Graphics.clear","h2d/Graphics.hx",135,0x5cd0883e)
		HX_STACK_THIS(this)
		HX_STACK_LINE(136)
		this->content->reset();
		HX_STACK_LINE(137)
		this->pts = Array_obj< ::Dynamic >::__new();
		HX_STACK_LINE(138)
		this->prev = Array_obj< ::Dynamic >::__new();
		HX_STACK_LINE(139)
		this->linePts = Array_obj< ::Dynamic >::__new();
		HX_STACK_LINE(140)
		this->pindex = (int)0;
		HX_STACK_LINE(141)
		this->lineSize = (int)0;
		HX_STACK_LINE(142)
		{
			HX_STACK_LINE(142)
			::h2d::col::Bounds _this = this->curBounds;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(142)
			_this->xMin = 1e20;
			HX_STACK_LINE(142)
			_this->yMin = 1e20;
			HX_STACK_LINE(142)
			_this->xMax = -1e20;
			HX_STACK_LINE(142)
			_this->yMax = -1e20;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Graphics_obj,clear,(void))

bool Graphics_obj::isConvex( Array< ::Dynamic > points){
	HX_STACK_FRAME("h2d.Graphics","isConvex",0xa56f67c0,"h2d.Graphics.isConvex","h2d/Graphics.hx",145,0x5cd0883e)
	HX_STACK_THIS(this)
	HX_STACK_ARG(points,"points")
	HX_STACK_LINE(146)
	{
		HX_STACK_LINE(146)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(146)
		int _g = points->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(146)
		while((true)){
			HX_STACK_LINE(146)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(146)
				break;
			}
			HX_STACK_LINE(146)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(147)
			::hxd::poly2tri::Point p1 = points->__get(i).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(p1,"p1");
			HX_STACK_LINE(148)
			::hxd::poly2tri::Point p2 = points->__get(hx::Mod(((i + (int)1)),points->length)).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(p2,"p2");
			HX_STACK_LINE(149)
			::hxd::poly2tri::Point p3 = points->__get(hx::Mod(((i + (int)2)),points->length)).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(p3,"p3");
			HX_STACK_LINE(150)
			if (((((((p2->x - p1->x)) * ((p3->y - p1->y))) - (((p2->y - p1->y)) * ((p3->x - p1->x)))) > (int)0))){
				HX_STACK_LINE(151)
				return false;
			}
		}
	}
	HX_STACK_LINE(153)
	return true;
}


HX_DEFINE_DYNAMIC_FUNC1(Graphics_obj,isConvex,return )

Void Graphics_obj::flushLine( ){
{
		HX_STACK_FRAME("h2d.Graphics","flushLine",0x3b4d3929,"h2d.Graphics.flushLine","h2d/Graphics.hx",156,0x5cd0883e)
		HX_STACK_THIS(this)
		HX_STACK_LINE(157)
		if (((this->linePts->length == (int)0))){
			HX_STACK_LINE(158)
			return null();
		}
		HX_STACK_LINE(159)
		int last = (this->linePts->length - (int)1);		HX_STACK_VAR(last,"last");
		HX_STACK_LINE(160)
		::h2d::_Graphics::LinePoint prev = this->linePts->__get(last).StaticCast< ::h2d::_Graphics::LinePoint >();		HX_STACK_VAR(prev,"prev");
		HX_STACK_LINE(161)
		::h2d::_Graphics::LinePoint p = this->linePts->__get((int)0).StaticCast< ::h2d::_Graphics::LinePoint >();		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(162)
		int start = this->pindex;		HX_STACK_VAR(start,"start");
		HX_STACK_LINE(163)
		{
			HX_STACK_LINE(163)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(163)
			int _g = this->linePts->length;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(163)
			while((true)){
				HX_STACK_LINE(163)
				if ((!(((_g1 < _g))))){
					HX_STACK_LINE(163)
					break;
				}
				HX_STACK_LINE(163)
				int i = (_g1)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(164)
				::h2d::_Graphics::LinePoint next = this->linePts->__get(hx::Mod(((i + (int)1)),this->linePts->length)).StaticCast< ::h2d::_Graphics::LinePoint >();		HX_STACK_VAR(next,"next");
				HX_STACK_LINE(165)
				Float nx1 = (prev->y - p->y);		HX_STACK_VAR(nx1,"nx1");
				HX_STACK_LINE(166)
				Float ny1 = (p->x - prev->x);		HX_STACK_VAR(ny1,"ny1");
				HX_STACK_LINE(167)
				Float _g2 = ::Math_obj::sqrt(((nx1 * nx1) + (ny1 * ny1)));		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(167)
				Float ns1 = (Float(1.) / Float(_g2));		HX_STACK_VAR(ns1,"ns1");
				HX_STACK_LINE(168)
				Float nx2 = (p->y - next->y);		HX_STACK_VAR(nx2,"nx2");
				HX_STACK_LINE(169)
				Float ny2 = (next->x - p->x);		HX_STACK_VAR(ny2,"ny2");
				HX_STACK_LINE(170)
				Float _g11 = ::Math_obj::sqrt(((nx2 * nx2) + (ny2 * ny2)));		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(170)
				Float ns2 = (Float(1.) / Float(_g11));		HX_STACK_VAR(ns2,"ns2");
				HX_STACK_LINE(172)
				Float nx = (((((nx1 * ns1) + (nx2 * ns2))) * this->lineSize) * 0.5);		HX_STACK_VAR(nx,"nx");
				HX_STACK_LINE(173)
				Float ny = (((((ny1 * ns1) + (ny2 * ns2))) * this->lineSize) * 0.5);		HX_STACK_VAR(ny,"ny");
				HX_STACK_LINE(175)
				{
					HX_STACK_LINE(175)
					::h2d::_Graphics::GraphicsContent _this = this->content;		HX_STACK_VAR(_this,"_this");
					HX_STACK_LINE(175)
					_this->tmp->push((p->x + nx));
					HX_STACK_LINE(175)
					_this->tmp->push((p->y + ny));
					HX_STACK_LINE(175)
					_this->tmp->push((int)0);
					HX_STACK_LINE(175)
					_this->tmp->push((int)0);
					HX_STACK_LINE(175)
					_this->tmp->push(p->r);
					HX_STACK_LINE(175)
					_this->tmp->push(p->g);
					HX_STACK_LINE(175)
					_this->tmp->push(p->b);
					HX_STACK_LINE(175)
					_this->tmp->push(p->a);
				}
				HX_STACK_LINE(176)
				{
					HX_STACK_LINE(176)
					::h2d::_Graphics::GraphicsContent _this = this->content;		HX_STACK_VAR(_this,"_this");
					HX_STACK_LINE(176)
					_this->tmp->push((p->x - nx));
					HX_STACK_LINE(176)
					_this->tmp->push((p->y - ny));
					HX_STACK_LINE(176)
					_this->tmp->push((int)0);
					HX_STACK_LINE(176)
					_this->tmp->push((int)0);
					HX_STACK_LINE(176)
					_this->tmp->push(p->r);
					HX_STACK_LINE(176)
					_this->tmp->push(p->g);
					HX_STACK_LINE(176)
					_this->tmp->push(p->b);
					HX_STACK_LINE(176)
					_this->tmp->push(p->a);
				}
				HX_STACK_LINE(178)
				int pnext;		HX_STACK_VAR(pnext,"pnext");
				HX_STACK_LINE(178)
				if (((i == last))){
					HX_STACK_LINE(178)
					pnext = start;
				}
				else{
					HX_STACK_LINE(178)
					pnext = (this->pindex + (int)2);
				}
				HX_STACK_LINE(180)
				this->content->index->push(this->pindex);
				HX_STACK_LINE(181)
				this->content->index->push((this->pindex + (int)1));
				HX_STACK_LINE(182)
				this->content->index->push(pnext);
				HX_STACK_LINE(184)
				this->content->index->push((this->pindex + (int)1));
				HX_STACK_LINE(185)
				this->content->index->push(pnext);
				HX_STACK_LINE(186)
				this->content->index->push((pnext + (int)1));
				HX_STACK_LINE(188)
				hx::AddEq(this->pindex,(int)2);
				HX_STACK_LINE(190)
				prev = p;
				HX_STACK_LINE(191)
				p = next;
			}
		}
		HX_STACK_LINE(193)
		this->linePts = Array_obj< ::Dynamic >::__new();
		HX_STACK_LINE(194)
		if ((this->content->next())){
			HX_STACK_LINE(195)
			this->pindex = (int)0;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Graphics_obj,flushLine,(void))

Void Graphics_obj::flushFill( ){
{
		HX_STACK_FRAME("h2d.Graphics","flushFill",0x3755efb8,"h2d.Graphics.flushFill","h2d/Graphics.hx",198,0x5cd0883e)
		HX_STACK_THIS(this)
		HX_STACK_LINE(199)
		if (((this->pts->length > (int)0))){
			HX_STACK_LINE(200)
			this->prev->push(this->pts);
			HX_STACK_LINE(201)
			this->pts = Array_obj< ::Dynamic >::__new();
		}
		HX_STACK_LINE(203)
		if (((this->prev->length == (int)0))){
			HX_STACK_LINE(204)
			return null();
		}
		HX_STACK_LINE(206)
		if (((  (((this->prev->length == (int)1))) ? bool(this->isConvex(this->prev->__get((int)0).StaticCast< Array< ::Dynamic > >())) : bool(false) ))){
			HX_STACK_LINE(207)
			int p0 = this->prev->__get((int)0).StaticCast< Array< ::Dynamic > >()->__get((int)0).StaticCast< ::hxd::poly2tri::Point >()->id;		HX_STACK_VAR(p0,"p0");
			HX_STACK_LINE(208)
			{
				HX_STACK_LINE(208)
				int _g1 = (int)1;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(208)
				int _g = (this->prev->__get((int)0).StaticCast< Array< ::Dynamic > >()->length - (int)1);		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(208)
				while((true)){
					HX_STACK_LINE(208)
					if ((!(((_g1 < _g))))){
						HX_STACK_LINE(208)
						break;
					}
					HX_STACK_LINE(208)
					int i = (_g1)++;		HX_STACK_VAR(i,"i");
					HX_STACK_LINE(209)
					this->content->index->push(p0);
					HX_STACK_LINE(210)
					this->content->index->push((p0 + i));
					HX_STACK_LINE(211)
					this->content->index->push(((p0 + i) + (int)1));
				}
			}
		}
		else{
			HX_STACK_LINE(214)
			::hxd::poly2tri::SweepContext ctx = ::hxd::poly2tri::SweepContext_obj::__new();		HX_STACK_VAR(ctx,"ctx");
			HX_STACK_LINE(215)
			{
				HX_STACK_LINE(215)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(215)
				Array< ::Dynamic > _g1 = this->prev;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(215)
				while((true)){
					HX_STACK_LINE(215)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(215)
						break;
					}
					HX_STACK_LINE(215)
					Array< ::Dynamic > p = _g1->__get(_g).StaticCast< Array< ::Dynamic > >();		HX_STACK_VAR(p,"p");
					HX_STACK_LINE(215)
					++(_g);
					HX_STACK_LINE(216)
					ctx->addPolyline(p);
				}
			}
			HX_STACK_LINE(218)
			::hxd::poly2tri::Sweep p = ::hxd::poly2tri::Sweep_obj::__new(ctx);		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(219)
			p->triangulate();
			HX_STACK_LINE(221)
			{
				HX_STACK_LINE(221)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(221)
				Array< ::Dynamic > _g1 = ctx->triangles;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(221)
				while((true)){
					HX_STACK_LINE(221)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(221)
						break;
					}
					HX_STACK_LINE(221)
					::hxd::poly2tri::Triangle t = _g1->__get(_g).StaticCast< ::hxd::poly2tri::Triangle >();		HX_STACK_VAR(t,"t");
					HX_STACK_LINE(221)
					++(_g);
					HX_STACK_LINE(222)
					int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(222)
					Array< ::Dynamic > _g3 = t->points;		HX_STACK_VAR(_g3,"_g3");
					HX_STACK_LINE(222)
					while((true)){
						HX_STACK_LINE(222)
						if ((!(((_g2 < _g3->length))))){
							HX_STACK_LINE(222)
							break;
						}
						HX_STACK_LINE(222)
						::hxd::poly2tri::Point p1 = _g3->__get(_g2).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(p1,"p1");
						HX_STACK_LINE(222)
						++(_g2);
						HX_STACK_LINE(223)
						this->content->index->push(p1->id);
					}
				}
			}
		}
		HX_STACK_LINE(226)
		this->prev = Array_obj< ::Dynamic >::__new();
		HX_STACK_LINE(227)
		if ((this->content->next())){
			HX_STACK_LINE(228)
			this->pindex = (int)0;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Graphics_obj,flushFill,(void))

Void Graphics_obj::flush( ){
{
		HX_STACK_FRAME("h2d.Graphics","flush",0xcfd18695,"h2d.Graphics.flush","h2d/Graphics.hx",231,0x5cd0883e)
		HX_STACK_THIS(this)
		HX_STACK_LINE(232)
		this->flushFill();
		HX_STACK_LINE(233)
		this->flushLine();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Graphics_obj,flush,(void))

Void Graphics_obj::beginFill( hx::Null< int >  __o_color,Dynamic __o_alpha){
int color = __o_color.Default(0);
Dynamic alpha = __o_alpha.Default(1.);
	HX_STACK_FRAME("h2d.Graphics","beginFill",0x89d88d9d,"h2d.Graphics.beginFill","h2d/Graphics.hx",236,0x5cd0883e)
	HX_STACK_THIS(this)
	HX_STACK_ARG(color,"color")
	HX_STACK_ARG(alpha,"alpha")
{
		HX_STACK_LINE(237)
		this->flush();
		HX_STACK_LINE(238)
		{
			HX_STACK_LINE(238)
			this->curA = alpha;
			HX_STACK_LINE(238)
			this->curR = (Float(((int((int(color) >> int((int)16))) & int((int)255)))) / Float(255.));
			HX_STACK_LINE(238)
			this->curG = (Float(((int((int(color) >> int((int)8))) & int((int)255)))) / Float(255.));
			HX_STACK_LINE(238)
			this->curB = (Float(((int(color) & int((int)255)))) / Float(255.));
		}
		HX_STACK_LINE(239)
		this->doFill = true;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Graphics_obj,beginFill,(void))

Void Graphics_obj::lineStyle( hx::Null< Float >  __o_size,hx::Null< int >  __o_color,Dynamic __o_alpha){
Float size = __o_size.Default(0.0);
int color = __o_color.Default(0);
Dynamic alpha = __o_alpha.Default(1.);
	HX_STACK_FRAME("h2d.Graphics","lineStyle",0xc85b88ee,"h2d.Graphics.lineStyle","h2d/Graphics.hx",242,0x5cd0883e)
	HX_STACK_THIS(this)
	HX_STACK_ARG(size,"size")
	HX_STACK_ARG(color,"color")
	HX_STACK_ARG(alpha,"alpha")
{
		HX_STACK_LINE(243)
		this->flush();
		HX_STACK_LINE(244)
		this->lineSize = size;
		HX_STACK_LINE(245)
		this->lineA = alpha;
		HX_STACK_LINE(246)
		this->lineR = (Float(((int((int(color) >> int((int)16))) & int((int)255)))) / Float(255.));
		HX_STACK_LINE(247)
		this->lineG = (Float(((int((int(color) >> int((int)8))) & int((int)255)))) / Float(255.));
		HX_STACK_LINE(248)
		this->lineB = (Float(((int(color) & int((int)255)))) / Float(255.));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Graphics_obj,lineStyle,(void))

Void Graphics_obj::endFill( ){
{
		HX_STACK_FRAME("h2d.Graphics","endFill",0x47c4020f,"h2d.Graphics.endFill","h2d/Graphics.hx",251,0x5cd0883e)
		HX_STACK_THIS(this)
		HX_STACK_LINE(252)
		this->flush();
		HX_STACK_LINE(253)
		this->doFill = false;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Graphics_obj,endFill,(void))

Void Graphics_obj::setColor( int color,Dynamic __o_alpha){
Dynamic alpha = __o_alpha.Default(1.);
	HX_STACK_FRAME("h2d.Graphics","setColor",0xddb82f30,"h2d.Graphics.setColor","h2d/Graphics.hx",256,0x5cd0883e)
	HX_STACK_THIS(this)
	HX_STACK_ARG(color,"color")
	HX_STACK_ARG(alpha,"alpha")
{
		HX_STACK_LINE(257)
		this->curA = alpha;
		HX_STACK_LINE(258)
		this->curR = (Float(((int((int(color) >> int((int)16))) & int((int)255)))) / Float(255.));
		HX_STACK_LINE(259)
		this->curG = (Float(((int((int(color) >> int((int)8))) & int((int)255)))) / Float(255.));
		HX_STACK_LINE(260)
		this->curB = (Float(((int(color) & int((int)255)))) / Float(255.));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Graphics_obj,setColor,(void))

Void Graphics_obj::drawRect( Float x,Float y,Float w,Float h){
{
		HX_STACK_FRAME("h2d.Graphics","drawRect",0xe5384c17,"h2d.Graphics.drawRect","h2d/Graphics.hx",263,0x5cd0883e)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(w,"w")
		HX_STACK_ARG(h,"h")
		HX_STACK_LINE(264)
		this->addPointFull(x,y,this->curR,this->curG,this->curB,this->curA,null(),null());
		HX_STACK_LINE(265)
		this->addPointFull((x + w),y,this->curR,this->curG,this->curB,this->curA,null(),null());
		HX_STACK_LINE(266)
		this->addPointFull((x + w),(y + h),this->curR,this->curG,this->curB,this->curA,null(),null());
		HX_STACK_LINE(267)
		this->addPointFull(x,(y + h),this->curR,this->curG,this->curB,this->curA,null(),null());
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Graphics_obj,drawRect,(void))

Void Graphics_obj::drawCircle( Float cx,Float cy,Float ray,hx::Null< int >  __o_nsegments){
int nsegments = __o_nsegments.Default(0);
	HX_STACK_FRAME("h2d.Graphics","drawCircle",0x351253c3,"h2d.Graphics.drawCircle","h2d/Graphics.hx",270,0x5cd0883e)
	HX_STACK_THIS(this)
	HX_STACK_ARG(cx,"cx")
	HX_STACK_ARG(cy,"cy")
	HX_STACK_ARG(ray,"ray")
	HX_STACK_ARG(nsegments,"nsegments")
{
		HX_STACK_LINE(271)
		if (((nsegments == (int)0))){
			HX_STACK_LINE(272)
			int _g = ::Math_obj::ceil((Float(((ray * 3.14) * (int)2)) / Float((int)4)));		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(272)
			nsegments = _g;
		}
		HX_STACK_LINE(273)
		if (((nsegments < (int)3))){
			HX_STACK_LINE(273)
			nsegments = (int)3;
		}
		HX_STACK_LINE(274)
		Float angle = (Float(6.2831853071795862) / Float(nsegments));		HX_STACK_VAR(angle,"angle");
		HX_STACK_LINE(275)
		{
			HX_STACK_LINE(275)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(275)
			while((true)){
				HX_STACK_LINE(275)
				if ((!(((_g < nsegments))))){
					HX_STACK_LINE(275)
					break;
				}
				HX_STACK_LINE(275)
				int i = (_g)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(276)
				Float a = (i * angle);		HX_STACK_VAR(a,"a");
				HX_STACK_LINE(277)
				{
					HX_STACK_LINE(277)
					Float _g1 = ::Math_obj::cos(a);		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(277)
					Float _g2 = (_g1 * ray);		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(277)
					Float x = (cx + _g2);		HX_STACK_VAR(x,"x");
					HX_STACK_LINE(277)
					Float _g3 = ::Math_obj::sin(a);		HX_STACK_VAR(_g3,"_g3");
					HX_STACK_LINE(277)
					Float _g4 = (_g3 * ray);		HX_STACK_VAR(_g4,"_g4");
					HX_STACK_LINE(277)
					Float y = (cy + _g4);		HX_STACK_VAR(y,"y");
					HX_STACK_LINE(277)
					this->addPointFull(x,y,this->curR,this->curG,this->curB,this->curA,null(),null());
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Graphics_obj,drawCircle,(void))

Void Graphics_obj::addHole( ){
{
		HX_STACK_FRAME("h2d.Graphics","addHole",0xa3338612,"h2d.Graphics.addHole","h2d/Graphics.hx",282,0x5cd0883e)
		HX_STACK_THIS(this)
		HX_STACK_LINE(282)
		if (((this->pts->length > (int)0))){
			HX_STACK_LINE(283)
			this->prev->push(this->pts);
			HX_STACK_LINE(284)
			this->pts = Array_obj< ::Dynamic >::__new();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Graphics_obj,addHole,(void))

Void Graphics_obj::addPoint( Float x,Float y){
{
		HX_STACK_FRAME("h2d.Graphics","addPoint",0xc5142f3e,"h2d.Graphics.addPoint","h2d/Graphics.hx",289,0x5cd0883e)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_LINE(289)
		this->addPointFull(x,y,this->curR,this->curG,this->curB,this->curA,null(),null());
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Graphics_obj,addPoint,(void))

Void Graphics_obj::addPointFull( Float x,Float y,Float r,Float g,Float b,Float a,hx::Null< Float >  __o_u,hx::Null< Float >  __o_v){
Float u = __o_u.Default(0.);
Float v = __o_v.Default(0.);
	HX_STACK_FRAME("h2d.Graphics","addPointFull",0x95cdbbed,"h2d.Graphics.addPointFull","h2d/Graphics.hx",292,0x5cd0883e)
	HX_STACK_THIS(this)
	HX_STACK_ARG(x,"x")
	HX_STACK_ARG(y,"y")
	HX_STACK_ARG(r,"r")
	HX_STACK_ARG(g,"g")
	HX_STACK_ARG(b,"b")
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(u,"u")
	HX_STACK_ARG(v,"v")
{
		HX_STACK_LINE(293)
		if ((this->doFill)){
			HX_STACK_LINE(294)
			::hxd::poly2tri::Point p = ::hxd::poly2tri::Point_obj::__new(x,y);		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(295)
			int _g = (this->pindex)++;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(295)
			p->id = _g;
			HX_STACK_LINE(296)
			this->pts->push(p);
			HX_STACK_LINE(297)
			{
				HX_STACK_LINE(297)
				::h2d::_Graphics::GraphicsContent _this = this->content;		HX_STACK_VAR(_this,"_this");
				HX_STACK_LINE(297)
				_this->tmp->push(x);
				HX_STACK_LINE(297)
				_this->tmp->push(y);
				HX_STACK_LINE(297)
				_this->tmp->push(u);
				HX_STACK_LINE(297)
				_this->tmp->push(v);
				HX_STACK_LINE(297)
				_this->tmp->push(r);
				HX_STACK_LINE(297)
				_this->tmp->push(g);
				HX_STACK_LINE(297)
				_this->tmp->push(b);
				HX_STACK_LINE(297)
				_this->tmp->push(a);
			}
		}
		HX_STACK_LINE(299)
		if (((this->lineSize > (int)0))){
			HX_STACK_LINE(300)
			::h2d::_Graphics::LinePoint _g1 = ::h2d::_Graphics::LinePoint_obj::__new(x,y,this->lineR,this->lineG,this->lineB,this->lineA);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(300)
			this->linePts->push(_g1);
		}
		HX_STACK_LINE(302)
		{
			HX_STACK_LINE(302)
			::h2d::col::Bounds _this = this->curBounds;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(302)
			Float x1 = (x - (this->lineSize * 0.5));		HX_STACK_VAR(x1,"x1");
			HX_STACK_LINE(302)
			Float y1 = (y - (this->lineSize * 0.5));		HX_STACK_VAR(y1,"y1");
			HX_STACK_LINE(302)
			Float ixMin = x1;		HX_STACK_VAR(ixMin,"ixMin");
			HX_STACK_LINE(302)
			Float iyMin = y1;		HX_STACK_VAR(iyMin,"iyMin");
			HX_STACK_LINE(302)
			Float ixMax = (x1 + (this->lineSize * 0.5));		HX_STACK_VAR(ixMax,"ixMax");
			HX_STACK_LINE(302)
			Float iyMax = (y1 + (this->lineSize * 0.5));		HX_STACK_VAR(iyMax,"iyMax");
			HX_STACK_LINE(302)
			if (((ixMin < _this->xMin))){
				HX_STACK_LINE(302)
				_this->xMin = ixMin;
			}
			HX_STACK_LINE(302)
			if (((ixMax > _this->xMax))){
				HX_STACK_LINE(302)
				_this->xMax = ixMax;
			}
			HX_STACK_LINE(302)
			if (((iyMin < _this->yMin))){
				HX_STACK_LINE(302)
				_this->yMin = iyMin;
			}
			HX_STACK_LINE(302)
			if (((iyMax > _this->yMax))){
				HX_STACK_LINE(302)
				_this->yMax = iyMax;
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC8(Graphics_obj,addPointFull,(void))

::h2d::col::Bounds Graphics_obj::getMyBounds( ){
	HX_STACK_FRAME("h2d.Graphics","getMyBounds",0xbebdcc48,"h2d.Graphics.getMyBounds","h2d/Graphics.hx",305,0x5cd0883e)
	HX_STACK_THIS(this)
	HX_STACK_LINE(306)
	::h2d::Matrix m = this->getPixSpaceMatrix(null(),null());		HX_STACK_VAR(m,"m");
	HX_STACK_LINE(307)
	{
		HX_STACK_LINE(307)
		::h2d::col::Bounds _this = this->curBounds;		HX_STACK_VAR(_this,"_this");
		HX_STACK_LINE(307)
		::h2d::col::Point p0 = ::h2d::col::Point_obj::__new(_this->xMin,_this->yMin);		HX_STACK_VAR(p0,"p0");
		HX_STACK_LINE(307)
		::h2d::col::Point p1 = ::h2d::col::Point_obj::__new(_this->xMin,_this->yMax);		HX_STACK_VAR(p1,"p1");
		HX_STACK_LINE(307)
		::h2d::col::Point p2 = ::h2d::col::Point_obj::__new(_this->xMax,_this->yMin);		HX_STACK_VAR(p2,"p2");
		HX_STACK_LINE(307)
		::h2d::col::Point p3 = ::h2d::col::Point_obj::__new(_this->xMax,_this->yMax);		HX_STACK_VAR(p3,"p3");
		HX_STACK_LINE(307)
		{
			HX_STACK_LINE(307)
			::h2d::col::Point p;		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(307)
			if (((p0 == null()))){
				HX_STACK_LINE(307)
				p = ::h2d::col::Point_obj::__new(null(),null());
			}
			else{
				HX_STACK_LINE(307)
				p = p0;
			}
			HX_STACK_LINE(307)
			Float px = p0->x;		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(307)
			Float py = p0->y;		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(307)
			p->x = (((px * m->a) + (py * m->c)) + m->tx);
			HX_STACK_LINE(307)
			p->y = (((px * m->b) + (py * m->d)) + m->ty);
			HX_STACK_LINE(307)
			p;
		}
		HX_STACK_LINE(307)
		{
			HX_STACK_LINE(307)
			::h2d::col::Point p;		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(307)
			if (((p1 == null()))){
				HX_STACK_LINE(307)
				p = ::h2d::col::Point_obj::__new(null(),null());
			}
			else{
				HX_STACK_LINE(307)
				p = p1;
			}
			HX_STACK_LINE(307)
			Float px = p1->x;		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(307)
			Float py = p1->y;		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(307)
			p->x = (((px * m->a) + (py * m->c)) + m->tx);
			HX_STACK_LINE(307)
			p->y = (((px * m->b) + (py * m->d)) + m->ty);
			HX_STACK_LINE(307)
			p;
		}
		HX_STACK_LINE(307)
		{
			HX_STACK_LINE(307)
			::h2d::col::Point p;		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(307)
			if (((p2 == null()))){
				HX_STACK_LINE(307)
				p = ::h2d::col::Point_obj::__new(null(),null());
			}
			else{
				HX_STACK_LINE(307)
				p = p2;
			}
			HX_STACK_LINE(307)
			Float px = p2->x;		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(307)
			Float py = p2->y;		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(307)
			p->x = (((px * m->a) + (py * m->c)) + m->tx);
			HX_STACK_LINE(307)
			p->y = (((px * m->b) + (py * m->d)) + m->ty);
			HX_STACK_LINE(307)
			p;
		}
		HX_STACK_LINE(307)
		{
			HX_STACK_LINE(307)
			::h2d::col::Point p;		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(307)
			if (((p3 == null()))){
				HX_STACK_LINE(307)
				p = ::h2d::col::Point_obj::__new(null(),null());
			}
			else{
				HX_STACK_LINE(307)
				p = p3;
			}
			HX_STACK_LINE(307)
			Float px = p3->x;		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(307)
			Float py = p3->y;		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(307)
			p->x = (((px * m->a) + (py * m->c)) + m->tx);
			HX_STACK_LINE(307)
			p->y = (((px * m->b) + (py * m->d)) + m->ty);
			HX_STACK_LINE(307)
			p;
		}
		HX_STACK_LINE(307)
		{
			HX_STACK_LINE(307)
			_this->xMin = p0->x;
			HX_STACK_LINE(307)
			_this->yMin = p0->y;
		}
		HX_STACK_LINE(307)
		{
			HX_STACK_LINE(307)
			_this->xMax = p0->x;
			HX_STACK_LINE(307)
			_this->yMax = p0->y;
		}
		HX_STACK_LINE(307)
		{
			HX_STACK_LINE(307)
			if (((p1->x < _this->xMin))){
				HX_STACK_LINE(307)
				_this->xMin = p1->x;
			}
			HX_STACK_LINE(307)
			if (((p1->x > _this->xMax))){
				HX_STACK_LINE(307)
				_this->xMax = p1->x;
			}
			HX_STACK_LINE(307)
			if (((p1->y < _this->yMin))){
				HX_STACK_LINE(307)
				_this->yMin = p1->y;
			}
			HX_STACK_LINE(307)
			if (((p1->y > _this->yMax))){
				HX_STACK_LINE(307)
				_this->yMax = p1->y;
			}
		}
		HX_STACK_LINE(307)
		{
			HX_STACK_LINE(307)
			if (((p2->x < _this->xMin))){
				HX_STACK_LINE(307)
				_this->xMin = p2->x;
			}
			HX_STACK_LINE(307)
			if (((p2->x > _this->xMax))){
				HX_STACK_LINE(307)
				_this->xMax = p2->x;
			}
			HX_STACK_LINE(307)
			if (((p2->y < _this->yMin))){
				HX_STACK_LINE(307)
				_this->yMin = p2->y;
			}
			HX_STACK_LINE(307)
			if (((p2->y > _this->yMax))){
				HX_STACK_LINE(307)
				_this->yMax = p2->y;
			}
		}
		HX_STACK_LINE(307)
		{
			HX_STACK_LINE(307)
			if (((p3->x < _this->xMin))){
				HX_STACK_LINE(307)
				_this->xMin = p3->x;
			}
			HX_STACK_LINE(307)
			if (((p3->x > _this->xMax))){
				HX_STACK_LINE(307)
				_this->xMax = p3->x;
			}
			HX_STACK_LINE(307)
			if (((p3->y < _this->yMin))){
				HX_STACK_LINE(307)
				_this->yMin = p3->y;
			}
			HX_STACK_LINE(307)
			if (((p3->y > _this->yMax))){
				HX_STACK_LINE(307)
				_this->yMax = p3->y;
			}
		}
		HX_STACK_LINE(307)
		p0 = null();
		HX_STACK_LINE(307)
		p1 = null();
		HX_STACK_LINE(307)
		p2 = null();
		HX_STACK_LINE(307)
		p3 = null();
		HX_STACK_LINE(307)
		_this;
	}
	HX_STACK_LINE(308)
	return this->curBounds;
}


Void Graphics_obj::draw( ::h3d::scene::RenderContext ctx){
{
		HX_STACK_FRAME("h2d.Graphics","draw",0xd2db2d53,"h2d.Graphics.draw","h2d/Graphics.hx",311,0x5cd0883e)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ctx,"ctx")
		HX_STACK_LINE(312)
		this->flush();
		HX_STACK_LINE(313)
		this->setupShader(ctx->engine,this->tile,(int)0);
		HX_STACK_LINE(314)
		this->content->render(ctx->engine);
	}
return null();
}


Void Graphics_obj::fromBounds( ::h2d::col::Bounds b,::h2d::Sprite parent,Dynamic __o_col,Dynamic __o_alpha){
Dynamic col = __o_col.Default(16711680);
Dynamic alpha = __o_alpha.Default(0.5);
	HX_STACK_FRAME("h2d.Graphics","fromBounds",0x46a2f20e,"h2d.Graphics.fromBounds","h2d/Graphics.hx",318,0x5cd0883e)
	HX_STACK_ARG(b,"b")
	HX_STACK_ARG(parent,"parent")
	HX_STACK_ARG(col,"col")
	HX_STACK_ARG(alpha,"alpha")
{
		HX_STACK_LINE(319)
		::h2d::Graphics g = ::h2d::Graphics_obj::__new(parent);		HX_STACK_VAR(g,"g");
		HX_STACK_LINE(320)
		g->beginFill(col,alpha);
		HX_STACK_LINE(321)
		g->drawRect(b->xMin,b->yMin,(b->xMax - b->xMin),(b->yMax - b->yMin));
		HX_STACK_LINE(322)
		g->endFill();
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(Graphics_obj,fromBounds,(void))


Graphics_obj::Graphics_obj()
{
}

void Graphics_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Graphics);
	HX_MARK_MEMBER_NAME(content,"content");
	HX_MARK_MEMBER_NAME(pts,"pts");
	HX_MARK_MEMBER_NAME(linePts,"linePts");
	HX_MARK_MEMBER_NAME(pindex,"pindex");
	HX_MARK_MEMBER_NAME(prev,"prev");
	HX_MARK_MEMBER_NAME(curR,"curR");
	HX_MARK_MEMBER_NAME(curG,"curG");
	HX_MARK_MEMBER_NAME(curB,"curB");
	HX_MARK_MEMBER_NAME(curA,"curA");
	HX_MARK_MEMBER_NAME(lineSize,"lineSize");
	HX_MARK_MEMBER_NAME(lineR,"lineR");
	HX_MARK_MEMBER_NAME(lineG,"lineG");
	HX_MARK_MEMBER_NAME(lineB,"lineB");
	HX_MARK_MEMBER_NAME(lineA,"lineA");
	HX_MARK_MEMBER_NAME(doFill,"doFill");
	HX_MARK_MEMBER_NAME(curBounds,"curBounds");
	HX_MARK_MEMBER_NAME(tile,"tile");
	::h2d::Drawable_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void Graphics_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(content,"content");
	HX_VISIT_MEMBER_NAME(pts,"pts");
	HX_VISIT_MEMBER_NAME(linePts,"linePts");
	HX_VISIT_MEMBER_NAME(pindex,"pindex");
	HX_VISIT_MEMBER_NAME(prev,"prev");
	HX_VISIT_MEMBER_NAME(curR,"curR");
	HX_VISIT_MEMBER_NAME(curG,"curG");
	HX_VISIT_MEMBER_NAME(curB,"curB");
	HX_VISIT_MEMBER_NAME(curA,"curA");
	HX_VISIT_MEMBER_NAME(lineSize,"lineSize");
	HX_VISIT_MEMBER_NAME(lineR,"lineR");
	HX_VISIT_MEMBER_NAME(lineG,"lineG");
	HX_VISIT_MEMBER_NAME(lineB,"lineB");
	HX_VISIT_MEMBER_NAME(lineA,"lineA");
	HX_VISIT_MEMBER_NAME(doFill,"doFill");
	HX_VISIT_MEMBER_NAME(curBounds,"curBounds");
	HX_VISIT_MEMBER_NAME(tile,"tile");
	::h2d::Drawable_obj::__Visit(HX_VISIT_ARG);
}

Dynamic Graphics_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"pts") ) { return pts; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"prev") ) { return prev; }
		if (HX_FIELD_EQ(inName,"curR") ) { return curR; }
		if (HX_FIELD_EQ(inName,"curG") ) { return curG; }
		if (HX_FIELD_EQ(inName,"curB") ) { return curB; }
		if (HX_FIELD_EQ(inName,"curA") ) { return curA; }
		if (HX_FIELD_EQ(inName,"tile") ) { return tile; }
		if (HX_FIELD_EQ(inName,"draw") ) { return draw_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"lineR") ) { return lineR; }
		if (HX_FIELD_EQ(inName,"lineG") ) { return lineG; }
		if (HX_FIELD_EQ(inName,"lineB") ) { return lineB; }
		if (HX_FIELD_EQ(inName,"lineA") ) { return lineA; }
		if (HX_FIELD_EQ(inName,"clear") ) { return clear_dyn(); }
		if (HX_FIELD_EQ(inName,"flush") ) { return flush_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"pindex") ) { return pindex; }
		if (HX_FIELD_EQ(inName,"doFill") ) { return doFill; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"content") ) { return content; }
		if (HX_FIELD_EQ(inName,"linePts") ) { return linePts; }
		if (HX_FIELD_EQ(inName,"endFill") ) { return endFill_dyn(); }
		if (HX_FIELD_EQ(inName,"addHole") ) { return addHole_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"lineSize") ) { return lineSize; }
		if (HX_FIELD_EQ(inName,"onDelete") ) { return onDelete_dyn(); }
		if (HX_FIELD_EQ(inName,"isConvex") ) { return isConvex_dyn(); }
		if (HX_FIELD_EQ(inName,"setColor") ) { return setColor_dyn(); }
		if (HX_FIELD_EQ(inName,"drawRect") ) { return drawRect_dyn(); }
		if (HX_FIELD_EQ(inName,"addPoint") ) { return addPoint_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"curBounds") ) { return curBounds; }
		if (HX_FIELD_EQ(inName,"flushLine") ) { return flushLine_dyn(); }
		if (HX_FIELD_EQ(inName,"flushFill") ) { return flushFill_dyn(); }
		if (HX_FIELD_EQ(inName,"beginFill") ) { return beginFill_dyn(); }
		if (HX_FIELD_EQ(inName,"lineStyle") ) { return lineStyle_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"fromBounds") ) { return fromBounds_dyn(); }
		if (HX_FIELD_EQ(inName,"drawCircle") ) { return drawCircle_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"getMyBounds") ) { return getMyBounds_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"addPointFull") ) { return addPointFull_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Graphics_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"pts") ) { pts=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"prev") ) { prev=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"curR") ) { curR=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"curG") ) { curG=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"curB") ) { curB=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"curA") ) { curA=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"tile") ) { tile=inValue.Cast< ::h2d::Tile >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"lineR") ) { lineR=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lineG") ) { lineG=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lineB") ) { lineB=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lineA") ) { lineA=inValue.Cast< Float >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"pindex") ) { pindex=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"doFill") ) { doFill=inValue.Cast< bool >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"content") ) { content=inValue.Cast< ::h2d::_Graphics::GraphicsContent >(); return inValue; }
		if (HX_FIELD_EQ(inName,"linePts") ) { linePts=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"lineSize") ) { lineSize=inValue.Cast< Float >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"curBounds") ) { curBounds=inValue.Cast< ::h2d::col::Bounds >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Graphics_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("content"));
	outFields->push(HX_CSTRING("pts"));
	outFields->push(HX_CSTRING("linePts"));
	outFields->push(HX_CSTRING("pindex"));
	outFields->push(HX_CSTRING("prev"));
	outFields->push(HX_CSTRING("curR"));
	outFields->push(HX_CSTRING("curG"));
	outFields->push(HX_CSTRING("curB"));
	outFields->push(HX_CSTRING("curA"));
	outFields->push(HX_CSTRING("lineSize"));
	outFields->push(HX_CSTRING("lineR"));
	outFields->push(HX_CSTRING("lineG"));
	outFields->push(HX_CSTRING("lineB"));
	outFields->push(HX_CSTRING("lineA"));
	outFields->push(HX_CSTRING("doFill"));
	outFields->push(HX_CSTRING("curBounds"));
	outFields->push(HX_CSTRING("tile"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("fromBounds"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h2d::_Graphics::GraphicsContent*/ ,(int)offsetof(Graphics_obj,content),HX_CSTRING("content")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Graphics_obj,pts),HX_CSTRING("pts")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Graphics_obj,linePts),HX_CSTRING("linePts")},
	{hx::fsInt,(int)offsetof(Graphics_obj,pindex),HX_CSTRING("pindex")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Graphics_obj,prev),HX_CSTRING("prev")},
	{hx::fsFloat,(int)offsetof(Graphics_obj,curR),HX_CSTRING("curR")},
	{hx::fsFloat,(int)offsetof(Graphics_obj,curG),HX_CSTRING("curG")},
	{hx::fsFloat,(int)offsetof(Graphics_obj,curB),HX_CSTRING("curB")},
	{hx::fsFloat,(int)offsetof(Graphics_obj,curA),HX_CSTRING("curA")},
	{hx::fsFloat,(int)offsetof(Graphics_obj,lineSize),HX_CSTRING("lineSize")},
	{hx::fsFloat,(int)offsetof(Graphics_obj,lineR),HX_CSTRING("lineR")},
	{hx::fsFloat,(int)offsetof(Graphics_obj,lineG),HX_CSTRING("lineG")},
	{hx::fsFloat,(int)offsetof(Graphics_obj,lineB),HX_CSTRING("lineB")},
	{hx::fsFloat,(int)offsetof(Graphics_obj,lineA),HX_CSTRING("lineA")},
	{hx::fsBool,(int)offsetof(Graphics_obj,doFill),HX_CSTRING("doFill")},
	{hx::fsObject /*::h2d::col::Bounds*/ ,(int)offsetof(Graphics_obj,curBounds),HX_CSTRING("curBounds")},
	{hx::fsObject /*::h2d::Tile*/ ,(int)offsetof(Graphics_obj,tile),HX_CSTRING("tile")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("content"),
	HX_CSTRING("pts"),
	HX_CSTRING("linePts"),
	HX_CSTRING("pindex"),
	HX_CSTRING("prev"),
	HX_CSTRING("curR"),
	HX_CSTRING("curG"),
	HX_CSTRING("curB"),
	HX_CSTRING("curA"),
	HX_CSTRING("lineSize"),
	HX_CSTRING("lineR"),
	HX_CSTRING("lineG"),
	HX_CSTRING("lineB"),
	HX_CSTRING("lineA"),
	HX_CSTRING("doFill"),
	HX_CSTRING("curBounds"),
	HX_CSTRING("tile"),
	HX_CSTRING("onDelete"),
	HX_CSTRING("clear"),
	HX_CSTRING("isConvex"),
	HX_CSTRING("flushLine"),
	HX_CSTRING("flushFill"),
	HX_CSTRING("flush"),
	HX_CSTRING("beginFill"),
	HX_CSTRING("lineStyle"),
	HX_CSTRING("endFill"),
	HX_CSTRING("setColor"),
	HX_CSTRING("drawRect"),
	HX_CSTRING("drawCircle"),
	HX_CSTRING("addHole"),
	HX_CSTRING("addPoint"),
	HX_CSTRING("addPointFull"),
	HX_CSTRING("getMyBounds"),
	HX_CSTRING("draw"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Graphics_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Graphics_obj::__mClass,"__mClass");
};

#endif

Class Graphics_obj::__mClass;

void Graphics_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.Graphics"), hx::TCanCast< Graphics_obj> ,sStaticFields,sMemberFields,
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

void Graphics_obj::__boot()
{
}

} // end namespace h2d
