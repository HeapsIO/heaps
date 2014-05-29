#include <hxcpp.h>

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
namespace h2d{

Void TileGroup_obj::__construct(::h2d::Tile t,::h2d::Sprite parent)
{
HX_STACK_FRAME("h2d.TileGroup","new",0xc25fa96f,"h2d.TileGroup.new","h2d/TileGroup.hx",122,0x10ab1662)
HX_STACK_THIS(this)
HX_STACK_ARG(t,"t")
HX_STACK_ARG(parent,"parent")
{
	HX_STACK_LINE(123)
	this->tile = t;
	HX_STACK_LINE(124)
	int _g = this->rangeMax = (int)-1;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(124)
	this->rangeMin = _g;
	HX_STACK_LINE(125)
	::h2d::_TileGroup::TileLayerContent _g1 = ::h2d::_TileGroup::TileLayerContent_obj::__new();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(125)
	this->content = _g1;
	HX_STACK_LINE(126)
	super::__construct(parent,null());
}
;
	return null();
}

//TileGroup_obj::~TileGroup_obj() { }

Dynamic TileGroup_obj::__CreateEmpty() { return  new TileGroup_obj; }
hx::ObjectPtr< TileGroup_obj > TileGroup_obj::__new(::h2d::Tile t,::h2d::Sprite parent)
{  hx::ObjectPtr< TileGroup_obj > result = new TileGroup_obj();
	result->__construct(t,parent);
	return result;}

Dynamic TileGroup_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< TileGroup_obj > result = new TileGroup_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

Void TileGroup_obj::reset( ){
{
		HX_STACK_FRAME("h2d.TileGroup","reset",0x2647c49e,"h2d.TileGroup.reset","h2d/TileGroup.hx",130,0x10ab1662)
		HX_STACK_THIS(this)
		HX_STACK_LINE(130)
		this->content->reset();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(TileGroup_obj,reset,(void))

Void TileGroup_obj::onDelete( ){
{
		HX_STACK_FRAME("h2d.TileGroup","onDelete",0xb141a73b,"h2d.TileGroup.onDelete","h2d/TileGroup.hx",133,0x10ab1662)
		HX_STACK_THIS(this)
		HX_STACK_LINE(134)
		this->content->dispose();
		HX_STACK_LINE(135)
		this->super::onDelete();
	}
return null();
}


Void TileGroup_obj::add( int x,int y,::h2d::Tile t){
{
		HX_STACK_FRAME("h2d.TileGroup","add",0xc255cb30,"h2d.TileGroup.add","h2d/TileGroup.hx",139,0x10ab1662)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(t,"t")
		HX_STACK_LINE(139)
		this->content->add(x,y,t);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(TileGroup_obj,add,(void))

::h2d::col::Bounds TileGroup_obj::getMyBounds( ){
	HX_STACK_FRAME("h2d.TileGroup","getMyBounds",0x05f775c6,"h2d.TileGroup.getMyBounds","h2d/TileGroup.hx",142,0x10ab1662)
	HX_STACK_THIS(this)
	HX_STACK_LINE(143)
	::h2d::col::Bounds b = ::h2d::col::Bounds_obj::__new();		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(144)
	::h2d::Matrix m = this->getPixSpaceMatrix(null(),null());		HX_STACK_VAR(m,"m");
	HX_STACK_LINE(145)
	int rmin;		HX_STACK_VAR(rmin,"rmin");
	HX_STACK_LINE(145)
	if (((this->rangeMin < (int)0))){
		HX_STACK_LINE(145)
		rmin = (int)0;
	}
	else{
		HX_STACK_LINE(145)
		rmin = this->rangeMin;
	}
	HX_STACK_LINE(146)
	int rmax;		HX_STACK_VAR(rmax,"rmax");
	HX_STACK_LINE(146)
	if (((this->rangeMax < (int)0))){
		HX_STACK_LINE(146)
		int _g = this->content->triCount();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(146)
		rmax = (int(_g) >> int((int)1));
	}
	else{
		HX_STACK_LINE(146)
		rmax = this->rangeMax;
	}
	HX_STACK_LINE(148)
	Float otx = m->tx;		HX_STACK_VAR(otx,"otx");
	HX_STACK_LINE(149)
	Float oty = m->ty;		HX_STACK_VAR(oty,"oty");
	HX_STACK_LINE(150)
	{
		HX_STACK_LINE(150)
		int _g = rmin;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(150)
		while((true)){
			HX_STACK_LINE(150)
			if ((!(((_g < rmax))))){
				HX_STACK_LINE(150)
				break;
			}
			HX_STACK_LINE(150)
			int i = (_g)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(151)
			otx = m->tx;
			HX_STACK_LINE(152)
			oty = m->ty;
			HX_STACK_LINE(154)
			::h2d::col::Bounds nb;		HX_STACK_VAR(nb,"nb");
			HX_STACK_LINE(154)
			{
				HX_STACK_LINE(154)
				::h2d::_TileGroup::TileLayerContent _this = this->content;		HX_STACK_VAR(_this,"_this");
				HX_STACK_LINE(154)
				::h2d::col::Bounds b1 = ::h2d::col::Bounds_obj::__new();		HX_STACK_VAR(b1,"b1");
				HX_STACK_LINE(154)
				Float w = _this->tiles->__get(i).StaticCast< ::h2d::Tile >()->width;		HX_STACK_VAR(w,"w");
				HX_STACK_LINE(154)
				Float h = _this->tiles->__get(i).StaticCast< ::h2d::Tile >()->height;		HX_STACK_VAR(h,"h");
				HX_STACK_LINE(154)
				b1->xMin = (_this->tmp->__get((int(i) << int((int)4))) + _this->tiles->__get(i).StaticCast< ::h2d::Tile >()->dx);
				HX_STACK_LINE(154)
				b1->xMax = (b1->xMin + w);
				HX_STACK_LINE(154)
				b1->yMin = (_this->tmp->__get((((int(i) << int((int)4))) + (int)1)) + _this->tiles->__get(i).StaticCast< ::h2d::Tile >()->dy);
				HX_STACK_LINE(154)
				b1->yMax = (b1->yMin + h);
				HX_STACK_LINE(154)
				nb = b1;
			}
			HX_STACK_LINE(155)
			{
				HX_STACK_LINE(155)
				::h2d::col::Point p0 = ::h2d::col::Point_obj::__new(nb->xMin,nb->yMin);		HX_STACK_VAR(p0,"p0");
				HX_STACK_LINE(155)
				::h2d::col::Point p1 = ::h2d::col::Point_obj::__new(nb->xMin,nb->yMax);		HX_STACK_VAR(p1,"p1");
				HX_STACK_LINE(155)
				::h2d::col::Point p2 = ::h2d::col::Point_obj::__new(nb->xMax,nb->yMin);		HX_STACK_VAR(p2,"p2");
				HX_STACK_LINE(155)
				::h2d::col::Point p3 = ::h2d::col::Point_obj::__new(nb->xMax,nb->yMax);		HX_STACK_VAR(p3,"p3");
				HX_STACK_LINE(155)
				{
					HX_STACK_LINE(155)
					::h2d::col::Point p;		HX_STACK_VAR(p,"p");
					HX_STACK_LINE(155)
					if (((p0 == null()))){
						HX_STACK_LINE(155)
						p = ::h2d::col::Point_obj::__new(null(),null());
					}
					else{
						HX_STACK_LINE(155)
						p = p0;
					}
					HX_STACK_LINE(155)
					Float px = p0->x;		HX_STACK_VAR(px,"px");
					HX_STACK_LINE(155)
					Float py = p0->y;		HX_STACK_VAR(py,"py");
					HX_STACK_LINE(155)
					p->x = (((px * m->a) + (py * m->c)) + m->tx);
					HX_STACK_LINE(155)
					p->y = (((px * m->b) + (py * m->d)) + m->ty);
					HX_STACK_LINE(155)
					p;
				}
				HX_STACK_LINE(155)
				{
					HX_STACK_LINE(155)
					::h2d::col::Point p;		HX_STACK_VAR(p,"p");
					HX_STACK_LINE(155)
					if (((p1 == null()))){
						HX_STACK_LINE(155)
						p = ::h2d::col::Point_obj::__new(null(),null());
					}
					else{
						HX_STACK_LINE(155)
						p = p1;
					}
					HX_STACK_LINE(155)
					Float px = p1->x;		HX_STACK_VAR(px,"px");
					HX_STACK_LINE(155)
					Float py = p1->y;		HX_STACK_VAR(py,"py");
					HX_STACK_LINE(155)
					p->x = (((px * m->a) + (py * m->c)) + m->tx);
					HX_STACK_LINE(155)
					p->y = (((px * m->b) + (py * m->d)) + m->ty);
					HX_STACK_LINE(155)
					p;
				}
				HX_STACK_LINE(155)
				{
					HX_STACK_LINE(155)
					::h2d::col::Point p;		HX_STACK_VAR(p,"p");
					HX_STACK_LINE(155)
					if (((p2 == null()))){
						HX_STACK_LINE(155)
						p = ::h2d::col::Point_obj::__new(null(),null());
					}
					else{
						HX_STACK_LINE(155)
						p = p2;
					}
					HX_STACK_LINE(155)
					Float px = p2->x;		HX_STACK_VAR(px,"px");
					HX_STACK_LINE(155)
					Float py = p2->y;		HX_STACK_VAR(py,"py");
					HX_STACK_LINE(155)
					p->x = (((px * m->a) + (py * m->c)) + m->tx);
					HX_STACK_LINE(155)
					p->y = (((px * m->b) + (py * m->d)) + m->ty);
					HX_STACK_LINE(155)
					p;
				}
				HX_STACK_LINE(155)
				{
					HX_STACK_LINE(155)
					::h2d::col::Point p;		HX_STACK_VAR(p,"p");
					HX_STACK_LINE(155)
					if (((p3 == null()))){
						HX_STACK_LINE(155)
						p = ::h2d::col::Point_obj::__new(null(),null());
					}
					else{
						HX_STACK_LINE(155)
						p = p3;
					}
					HX_STACK_LINE(155)
					Float px = p3->x;		HX_STACK_VAR(px,"px");
					HX_STACK_LINE(155)
					Float py = p3->y;		HX_STACK_VAR(py,"py");
					HX_STACK_LINE(155)
					p->x = (((px * m->a) + (py * m->c)) + m->tx);
					HX_STACK_LINE(155)
					p->y = (((px * m->b) + (py * m->d)) + m->ty);
					HX_STACK_LINE(155)
					p;
				}
				HX_STACK_LINE(155)
				{
					HX_STACK_LINE(155)
					nb->xMin = p0->x;
					HX_STACK_LINE(155)
					nb->yMin = p0->y;
				}
				HX_STACK_LINE(155)
				{
					HX_STACK_LINE(155)
					nb->xMax = p0->x;
					HX_STACK_LINE(155)
					nb->yMax = p0->y;
				}
				HX_STACK_LINE(155)
				{
					HX_STACK_LINE(155)
					if (((p1->x < nb->xMin))){
						HX_STACK_LINE(155)
						nb->xMin = p1->x;
					}
					HX_STACK_LINE(155)
					if (((p1->x > nb->xMax))){
						HX_STACK_LINE(155)
						nb->xMax = p1->x;
					}
					HX_STACK_LINE(155)
					if (((p1->y < nb->yMin))){
						HX_STACK_LINE(155)
						nb->yMin = p1->y;
					}
					HX_STACK_LINE(155)
					if (((p1->y > nb->yMax))){
						HX_STACK_LINE(155)
						nb->yMax = p1->y;
					}
				}
				HX_STACK_LINE(155)
				{
					HX_STACK_LINE(155)
					if (((p2->x < nb->xMin))){
						HX_STACK_LINE(155)
						nb->xMin = p2->x;
					}
					HX_STACK_LINE(155)
					if (((p2->x > nb->xMax))){
						HX_STACK_LINE(155)
						nb->xMax = p2->x;
					}
					HX_STACK_LINE(155)
					if (((p2->y < nb->yMin))){
						HX_STACK_LINE(155)
						nb->yMin = p2->y;
					}
					HX_STACK_LINE(155)
					if (((p2->y > nb->yMax))){
						HX_STACK_LINE(155)
						nb->yMax = p2->y;
					}
				}
				HX_STACK_LINE(155)
				{
					HX_STACK_LINE(155)
					if (((p3->x < nb->xMin))){
						HX_STACK_LINE(155)
						nb->xMin = p3->x;
					}
					HX_STACK_LINE(155)
					if (((p3->x > nb->xMax))){
						HX_STACK_LINE(155)
						nb->xMax = p3->x;
					}
					HX_STACK_LINE(155)
					if (((p3->y < nb->yMin))){
						HX_STACK_LINE(155)
						nb->yMin = p3->y;
					}
					HX_STACK_LINE(155)
					if (((p3->y > nb->yMax))){
						HX_STACK_LINE(155)
						nb->yMax = p3->y;
					}
				}
				HX_STACK_LINE(155)
				p0 = null();
				HX_STACK_LINE(155)
				p1 = null();
				HX_STACK_LINE(155)
				p2 = null();
				HX_STACK_LINE(155)
				p3 = null();
				HX_STACK_LINE(155)
				nb;
			}
			HX_STACK_LINE(157)
			{
				HX_STACK_LINE(157)
				if (((nb->xMin < b->xMin))){
					HX_STACK_LINE(157)
					b->xMin = nb->xMin;
				}
				HX_STACK_LINE(157)
				if (((nb->xMax > b->xMax))){
					HX_STACK_LINE(157)
					b->xMax = nb->xMax;
				}
				HX_STACK_LINE(157)
				if (((nb->yMin < b->yMin))){
					HX_STACK_LINE(157)
					b->yMin = nb->yMin;
				}
				HX_STACK_LINE(157)
				if (((nb->yMax > b->yMax))){
					HX_STACK_LINE(157)
					b->yMax = nb->yMax;
				}
			}
			HX_STACK_LINE(159)
			m->tx = otx;
			HX_STACK_LINE(160)
			m->ty = oty;
		}
	}
	HX_STACK_LINE(163)
	return b;
}


int TileGroup_obj::count( ){
	HX_STACK_FRAME("h2d.TileGroup","count",0x89e2bf9e,"h2d.TileGroup.count","h2d/TileGroup.hx",169,0x10ab1662)
	HX_STACK_THIS(this)
	HX_STACK_LINE(170)
	int _g = this->content->triCount();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(170)
	return (int(_g) >> int((int)1));
}


HX_DEFINE_DYNAMIC_FUNC0(TileGroup_obj,count,return )

Void TileGroup_obj::draw( ::h3d::scene::RenderContext ctx){
{
		HX_STACK_FRAME("h2d.TileGroup","draw",0x4ac24015,"h2d.TileGroup.draw","h2d/TileGroup.hx",176,0x10ab1662)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ctx,"ctx")
		HX_STACK_LINE(177)
		this->setupShader(ctx->engine,this->tile,(int)8);
		HX_STACK_LINE(178)
		int min;		HX_STACK_VAR(min,"min");
		HX_STACK_LINE(178)
		if (((this->rangeMin < (int)0))){
			HX_STACK_LINE(178)
			min = (int)0;
		}
		else{
			HX_STACK_LINE(178)
			min = (this->rangeMin * (int)2);
		}
		HX_STACK_LINE(179)
		int max = this->content->triCount();		HX_STACK_VAR(max,"max");
		HX_STACK_LINE(180)
		if (((bool((this->rangeMax > (int)0)) && bool((this->rangeMax < (max * (int)2)))))){
			HX_STACK_LINE(180)
			max = (this->rangeMax * (int)2);
		}
		HX_STACK_LINE(181)
		this->content->doRender(ctx->engine,min,(max - min));
	}
return null();
}



TileGroup_obj::TileGroup_obj()
{
}

void TileGroup_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(TileGroup);
	HX_MARK_MEMBER_NAME(content,"content");
	HX_MARK_MEMBER_NAME(tile,"tile");
	HX_MARK_MEMBER_NAME(rangeMin,"rangeMin");
	HX_MARK_MEMBER_NAME(rangeMax,"rangeMax");
	::h2d::Drawable_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void TileGroup_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(content,"content");
	HX_VISIT_MEMBER_NAME(tile,"tile");
	HX_VISIT_MEMBER_NAME(rangeMin,"rangeMin");
	HX_VISIT_MEMBER_NAME(rangeMax,"rangeMax");
	::h2d::Drawable_obj::__Visit(HX_VISIT_ARG);
}

Dynamic TileGroup_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"add") ) { return add_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"tile") ) { return tile; }
		if (HX_FIELD_EQ(inName,"draw") ) { return draw_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"reset") ) { return reset_dyn(); }
		if (HX_FIELD_EQ(inName,"count") ) { return count_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"content") ) { return content; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"rangeMin") ) { return rangeMin; }
		if (HX_FIELD_EQ(inName,"rangeMax") ) { return rangeMax; }
		if (HX_FIELD_EQ(inName,"onDelete") ) { return onDelete_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"getMyBounds") ) { return getMyBounds_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic TileGroup_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"tile") ) { tile=inValue.Cast< ::h2d::Tile >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"content") ) { content=inValue.Cast< ::h2d::_TileGroup::TileLayerContent >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"rangeMin") ) { rangeMin=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"rangeMax") ) { rangeMax=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void TileGroup_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("content"));
	outFields->push(HX_CSTRING("tile"));
	outFields->push(HX_CSTRING("rangeMin"));
	outFields->push(HX_CSTRING("rangeMax"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h2d::_TileGroup::TileLayerContent*/ ,(int)offsetof(TileGroup_obj,content),HX_CSTRING("content")},
	{hx::fsObject /*::h2d::Tile*/ ,(int)offsetof(TileGroup_obj,tile),HX_CSTRING("tile")},
	{hx::fsInt,(int)offsetof(TileGroup_obj,rangeMin),HX_CSTRING("rangeMin")},
	{hx::fsInt,(int)offsetof(TileGroup_obj,rangeMax),HX_CSTRING("rangeMax")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("content"),
	HX_CSTRING("tile"),
	HX_CSTRING("rangeMin"),
	HX_CSTRING("rangeMax"),
	HX_CSTRING("reset"),
	HX_CSTRING("onDelete"),
	HX_CSTRING("add"),
	HX_CSTRING("getMyBounds"),
	HX_CSTRING("count"),
	HX_CSTRING("draw"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(TileGroup_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(TileGroup_obj::__mClass,"__mClass");
};

#endif

Class TileGroup_obj::__mClass;

void TileGroup_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.TileGroup"), hx::TCanCast< TileGroup_obj> ,sStaticFields,sMemberFields,
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

void TileGroup_obj::__boot()
{
}

} // end namespace h2d
