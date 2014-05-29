#include <hxcpp.h>

#ifndef INCLUDED_h2d_Tile
#include <h2d/Tile.h>
#endif
#ifndef INCLUDED_h2d__TileGroup_TileLayerContent
#include <h2d/_TileGroup/TileLayerContent.h>
#endif
#ifndef INCLUDED_h2d_col_Bounds
#include <h2d/col/Bounds.h>
#endif
#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
#endif
#ifndef INCLUDED_h3d_impl_Buffer
#include <h3d/impl/Buffer.h>
#endif
#ifndef INCLUDED_h3d_impl_Indexes
#include <h3d/impl/Indexes.h>
#endif
#ifndef INCLUDED_h3d_impl_MemoryManager
#include <h3d/impl/MemoryManager.h>
#endif
#ifndef INCLUDED_h3d_prim_Primitive
#include <h3d/prim/Primitive.h>
#endif
namespace h2d{
namespace _TileGroup{

Void TileLayerContent_obj::__construct()
{
HX_STACK_FRAME("h2d._TileGroup.TileLayerContent","new",0x82302ad0,"h2d._TileGroup.TileLayerContent.new","h2d/TileGroup.hx",10,0x10ab1662)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(10)
	this->reset();
}
;
	return null();
}

//TileLayerContent_obj::~TileLayerContent_obj() { }

Dynamic TileLayerContent_obj::__CreateEmpty() { return  new TileLayerContent_obj; }
hx::ObjectPtr< TileLayerContent_obj > TileLayerContent_obj::__new()
{  hx::ObjectPtr< TileLayerContent_obj > result = new TileLayerContent_obj();
	result->__construct();
	return result;}

Dynamic TileLayerContent_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< TileLayerContent_obj > result = new TileLayerContent_obj();
	result->__construct();
	return result;}

bool TileLayerContent_obj::isEmpty( ){
	HX_STACK_FRAME("h2d._TileGroup.TileLayerContent","isEmpty",0x395230b3,"h2d._TileGroup.TileLayerContent.isEmpty","h2d/TileGroup.hx",14,0x10ab1662)
	HX_STACK_THIS(this)
	HX_STACK_LINE(14)
	return (this->buffer == null());
}


HX_DEFINE_DYNAMIC_FUNC0(TileLayerContent_obj,isEmpty,return )

Void TileLayerContent_obj::reset( ){
{
		HX_STACK_FRAME("h2d._TileGroup.TileLayerContent","reset",0xdc44203f,"h2d._TileGroup.TileLayerContent.reset","h2d/TileGroup.hx",17,0x10ab1662)
		HX_STACK_THIS(this)
		HX_STACK_LINE(18)
		Array< Float > _g;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(18)
		{
			HX_STACK_LINE(18)
			int length = (int)0;		HX_STACK_VAR(length,"length");
			HX_STACK_LINE(18)
			_g = Array_obj< Float >::__new();
		}
		HX_STACK_LINE(18)
		this->tmp = _g;
		HX_STACK_LINE(19)
		this->tiles = Array_obj< ::Dynamic >::__new();
		HX_STACK_LINE(21)
		if (((this->buffer != null()))){
			HX_STACK_LINE(21)
			this->buffer->dispose();
		}
		HX_STACK_LINE(22)
		this->buffer = null();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(TileLayerContent_obj,reset,(void))

Float TileLayerContent_obj::getX( int idx){
	HX_STACK_FRAME("h2d._TileGroup.TileLayerContent","getX",0x6354ca92,"h2d._TileGroup.TileLayerContent.getX","h2d/TileGroup.hx",26,0x10ab1662)
	HX_STACK_THIS(this)
	HX_STACK_ARG(idx,"idx")
	HX_STACK_LINE(26)
	return (this->tmp->__get((int(idx) << int((int)4))) + this->tiles->__get(idx).StaticCast< ::h2d::Tile >()->dx);
}


HX_DEFINE_DYNAMIC_FUNC1(TileLayerContent_obj,getX,return )

Float TileLayerContent_obj::getY( int idx){
	HX_STACK_FRAME("h2d._TileGroup.TileLayerContent","getY",0x6354ca93,"h2d._TileGroup.TileLayerContent.getY","h2d/TileGroup.hx",30,0x10ab1662)
	HX_STACK_THIS(this)
	HX_STACK_ARG(idx,"idx")
	HX_STACK_LINE(30)
	return (this->tmp->__get((((int(idx) << int((int)4))) + (int)1)) + this->tiles->__get(idx).StaticCast< ::h2d::Tile >()->dy);
}


HX_DEFINE_DYNAMIC_FUNC1(TileLayerContent_obj,getY,return )

Float TileLayerContent_obj::getWidth( int idx){
	HX_STACK_FRAME("h2d._TileGroup.TileLayerContent","getWidth",0x514f9520,"h2d._TileGroup.TileLayerContent.getWidth","h2d/TileGroup.hx",34,0x10ab1662)
	HX_STACK_THIS(this)
	HX_STACK_ARG(idx,"idx")
	HX_STACK_LINE(34)
	return this->tiles->__get(idx).StaticCast< ::h2d::Tile >()->width;
}


HX_DEFINE_DYNAMIC_FUNC1(TileLayerContent_obj,getWidth,return )

Float TileLayerContent_obj::getHeight( int idx){
	HX_STACK_FRAME("h2d._TileGroup.TileLayerContent","getHeight",0x8aa25f8d,"h2d._TileGroup.TileLayerContent.getHeight","h2d/TileGroup.hx",38,0x10ab1662)
	HX_STACK_THIS(this)
	HX_STACK_ARG(idx,"idx")
	HX_STACK_LINE(38)
	return this->tiles->__get(idx).StaticCast< ::h2d::Tile >()->height;
}


HX_DEFINE_DYNAMIC_FUNC1(TileLayerContent_obj,getHeight,return )

::h2d::Tile TileLayerContent_obj::getTile( int idx){
	HX_STACK_FRAME("h2d._TileGroup.TileLayerContent","getTile",0x4c71cd54,"h2d._TileGroup.TileLayerContent.getTile","h2d/TileGroup.hx",42,0x10ab1662)
	HX_STACK_THIS(this)
	HX_STACK_ARG(idx,"idx")
	HX_STACK_LINE(42)
	return this->tiles->__get(idx).StaticCast< ::h2d::Tile >();
}


HX_DEFINE_DYNAMIC_FUNC1(TileLayerContent_obj,getTile,return )

::h2d::col::Bounds TileLayerContent_obj::get2DBounds( int idx){
	HX_STACK_FRAME("h2d._TileGroup.TileLayerContent","get2DBounds",0x04e620ed,"h2d._TileGroup.TileLayerContent.get2DBounds","h2d/TileGroup.hx",45,0x10ab1662)
	HX_STACK_THIS(this)
	HX_STACK_ARG(idx,"idx")
	HX_STACK_LINE(46)
	::h2d::col::Bounds b = ::h2d::col::Bounds_obj::__new();		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(47)
	Float w = this->tiles->__get(idx).StaticCast< ::h2d::Tile >()->width;		HX_STACK_VAR(w,"w");
	HX_STACK_LINE(48)
	Float h = this->tiles->__get(idx).StaticCast< ::h2d::Tile >()->height;		HX_STACK_VAR(h,"h");
	HX_STACK_LINE(50)
	b->xMin = (this->tmp->__get((int(idx) << int((int)4))) + this->tiles->__get(idx).StaticCast< ::h2d::Tile >()->dx);
	HX_STACK_LINE(51)
	b->xMax = (b->xMin + w);
	HX_STACK_LINE(53)
	b->yMin = (this->tmp->__get((((int(idx) << int((int)4))) + (int)1)) + this->tiles->__get(idx).StaticCast< ::h2d::Tile >()->dy);
	HX_STACK_LINE(54)
	b->yMax = (b->yMin + h);
	HX_STACK_LINE(56)
	return b;
}


HX_DEFINE_DYNAMIC_FUNC1(TileLayerContent_obj,get2DBounds,return )

Void TileLayerContent_obj::add( int x,int y,::h2d::Tile t){
{
		HX_STACK_FRAME("h2d._TileGroup.TileLayerContent","add",0x82264c91,"h2d._TileGroup.TileLayerContent.add","h2d/TileGroup.hx",59,0x10ab1662)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(t,"t")
		HX_STACK_LINE(60)
		int sx = (x + t->dx);		HX_STACK_VAR(sx,"sx");
		HX_STACK_LINE(61)
		int sy = (y + t->dy);		HX_STACK_VAR(sy,"sy");
		HX_STACK_LINE(62)
		int sx2 = (sx + t->width);		HX_STACK_VAR(sx2,"sx2");
		HX_STACK_LINE(63)
		int sy2 = (sy + t->height);		HX_STACK_VAR(sy2,"sy2");
		HX_STACK_LINE(64)
		this->tiles[(int(this->tmp->length) >> int((int)4))] = t;
		HX_STACK_LINE(66)
		this->tmp->push(sx);
		HX_STACK_LINE(67)
		this->tmp->push(sy);
		HX_STACK_LINE(68)
		this->tmp->push(t->u);
		HX_STACK_LINE(69)
		this->tmp->push(t->v);
		HX_STACK_LINE(71)
		this->tmp->push(sx2);
		HX_STACK_LINE(72)
		this->tmp->push(sy);
		HX_STACK_LINE(73)
		this->tmp->push(t->u2);
		HX_STACK_LINE(74)
		this->tmp->push(t->v);
		HX_STACK_LINE(76)
		this->tmp->push(sx);
		HX_STACK_LINE(77)
		this->tmp->push(sy2);
		HX_STACK_LINE(78)
		this->tmp->push(t->u);
		HX_STACK_LINE(79)
		this->tmp->push(t->v2);
		HX_STACK_LINE(81)
		this->tmp->push(sx2);
		HX_STACK_LINE(82)
		this->tmp->push(sy2);
		HX_STACK_LINE(83)
		this->tmp->push(t->u2);
		HX_STACK_LINE(84)
		this->tmp->push(t->v2);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(TileLayerContent_obj,add,(void))

int TileLayerContent_obj::triCount( ){
	HX_STACK_FRAME("h2d._TileGroup.TileLayerContent","triCount",0x6f89ff34,"h2d._TileGroup.TileLayerContent.triCount","h2d/TileGroup.hx",87,0x10ab1662)
	HX_STACK_THIS(this)
	HX_STACK_LINE(88)
	if (((this->buffer == null()))){
		HX_STACK_LINE(89)
		return (int(this->tmp->length) >> int((int)3));
	}
	HX_STACK_LINE(90)
	int v = (int)0;		HX_STACK_VAR(v,"v");
	HX_STACK_LINE(91)
	::h3d::impl::Buffer b = this->buffer;		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(92)
	while((true)){
		HX_STACK_LINE(92)
		if ((!(((b != null()))))){
			HX_STACK_LINE(92)
			break;
		}
		HX_STACK_LINE(93)
		hx::AddEq(v,b->nvert);
		HX_STACK_LINE(94)
		b = b->next;
	}
	HX_STACK_LINE(96)
	return (int(v) >> int((int)1));
}


Void TileLayerContent_obj::alloc( ::h3d::Engine engine){
{
		HX_STACK_FRAME("h2d._TileGroup.TileLayerContent","alloc",0x170f7ae5,"h2d._TileGroup.TileLayerContent.alloc","h2d/TileGroup.hx",99,0x10ab1662)
		HX_STACK_THIS(this)
		HX_STACK_ARG(engine,"engine")
		HX_STACK_LINE(100)
		if (((this->tmp == null()))){
			HX_STACK_LINE(100)
			this->reset();
		}
		HX_STACK_LINE(101)
		::h3d::impl::Buffer _g = engine->mem->allocVector(this->tmp,(int)4,(int)4,true,hx::SourceInfo(HX_CSTRING("TileGroup.hx"),101,HX_CSTRING("h2d._TileGroup.TileLayerContent"),HX_CSTRING("alloc")));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(101)
		this->buffer = _g;
	}
return null();
}


Void TileLayerContent_obj::doRender( ::h3d::Engine engine,int min,int len){
{
		HX_STACK_FRAME("h2d._TileGroup.TileLayerContent","doRender",0xc056c0d1,"h2d._TileGroup.TileLayerContent.doRender","h2d/TileGroup.hx",104,0x10ab1662)
		HX_STACK_THIS(this)
		HX_STACK_ARG(engine,"engine")
		HX_STACK_ARG(min,"min")
		HX_STACK_ARG(len,"len")
		HX_STACK_LINE(105)
		if (((  ((!(((this->buffer == null()))))) ? bool(this->buffer->isDisposed()) : bool(true) ))){
			HX_STACK_LINE(105)
			this->alloc(engine);
		}
		HX_STACK_LINE(106)
		{
			HX_STACK_LINE(106)
			bool v = engine->renderBuffer(this->buffer,engine->mem->quadIndexes,(int)2,min,len);		HX_STACK_VAR(v,"v");
			HX_STACK_LINE(106)
			v;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(TileLayerContent_obj,doRender,(void))


TileLayerContent_obj::TileLayerContent_obj()
{
}

void TileLayerContent_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(TileLayerContent);
	HX_MARK_MEMBER_NAME(tmp,"tmp");
	HX_MARK_MEMBER_NAME(tiles,"tiles");
	::h3d::prim::Primitive_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void TileLayerContent_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(tmp,"tmp");
	HX_VISIT_MEMBER_NAME(tiles,"tiles");
	::h3d::prim::Primitive_obj::__Visit(HX_VISIT_ARG);
}

Dynamic TileLayerContent_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"tmp") ) { return tmp; }
		if (HX_FIELD_EQ(inName,"add") ) { return add_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"getX") ) { return getX_dyn(); }
		if (HX_FIELD_EQ(inName,"getY") ) { return getY_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"tiles") ) { return tiles; }
		if (HX_FIELD_EQ(inName,"reset") ) { return reset_dyn(); }
		if (HX_FIELD_EQ(inName,"alloc") ) { return alloc_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"isEmpty") ) { return isEmpty_dyn(); }
		if (HX_FIELD_EQ(inName,"getTile") ) { return getTile_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"getWidth") ) { return getWidth_dyn(); }
		if (HX_FIELD_EQ(inName,"triCount") ) { return triCount_dyn(); }
		if (HX_FIELD_EQ(inName,"doRender") ) { return doRender_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"getHeight") ) { return getHeight_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"get2DBounds") ) { return get2DBounds_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic TileLayerContent_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"tmp") ) { tmp=inValue.Cast< Array< Float > >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"tiles") ) { tiles=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void TileLayerContent_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("tmp"));
	outFields->push(HX_CSTRING("tiles"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Array< Float >*/ ,(int)offsetof(TileLayerContent_obj,tmp),HX_CSTRING("tmp")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(TileLayerContent_obj,tiles),HX_CSTRING("tiles")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("tmp"),
	HX_CSTRING("tiles"),
	HX_CSTRING("isEmpty"),
	HX_CSTRING("reset"),
	HX_CSTRING("getX"),
	HX_CSTRING("getY"),
	HX_CSTRING("getWidth"),
	HX_CSTRING("getHeight"),
	HX_CSTRING("getTile"),
	HX_CSTRING("get2DBounds"),
	HX_CSTRING("add"),
	HX_CSTRING("triCount"),
	HX_CSTRING("alloc"),
	HX_CSTRING("doRender"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(TileLayerContent_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(TileLayerContent_obj::__mClass,"__mClass");
};

#endif

Class TileLayerContent_obj::__mClass;

void TileLayerContent_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d._TileGroup.TileLayerContent"), hx::TCanCast< TileLayerContent_obj> ,sStaticFields,sMemberFields,
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

void TileLayerContent_obj::__boot()
{
}

} // end namespace h2d
} // end namespace _TileGroup
