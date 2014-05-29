#include <hxcpp.h>

#ifndef INCLUDED_flash_geom_Point
#include <flash/geom/Point.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
namespace flash{
namespace geom{

Void Point_obj::__construct(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y)
{
HX_STACK_FRAME("flash.geom.Point","new",0xdba4cdee,"flash.geom.Point.new","flash/geom/Point.hx",12,0x23ce85a2)
HX_STACK_THIS(this)
HX_STACK_ARG(__o_x,"x")
HX_STACK_ARG(__o_y,"y")
Float x = __o_x.Default(0);
Float y = __o_y.Default(0);
{
	HX_STACK_LINE(14)
	this->x = x;
	HX_STACK_LINE(15)
	this->y = y;
}
;
	return null();
}

//Point_obj::~Point_obj() { }

Dynamic Point_obj::__CreateEmpty() { return  new Point_obj; }
hx::ObjectPtr< Point_obj > Point_obj::__new(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y)
{  hx::ObjectPtr< Point_obj > result = new Point_obj();
	result->__construct(__o_x,__o_y);
	return result;}

Dynamic Point_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Point_obj > result = new Point_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

::flash::geom::Point Point_obj::add( ::flash::geom::Point v){
	HX_STACK_FRAME("flash.geom.Point","add",0xdb9aefaf,"flash.geom.Point.add","flash/geom/Point.hx",22,0x23ce85a2)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(22)
	return ::flash::geom::Point_obj::__new((v->x + this->x),(v->y + this->y));
}


HX_DEFINE_DYNAMIC_FUNC1(Point_obj,add,return )

::flash::geom::Point Point_obj::clone( ){
	HX_STACK_FRAME("flash.geom.Point","clone",0x5819106b,"flash.geom.Point.clone","flash/geom/Point.hx",29,0x23ce85a2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(29)
	return ::flash::geom::Point_obj::__new(this->x,this->y);
}


HX_DEFINE_DYNAMIC_FUNC0(Point_obj,clone,return )

Void Point_obj::copyFrom( ::flash::geom::Point sourcePoint){
{
		HX_STACK_FRAME("flash.geom.Point","copyFrom",0xfc082b71,"flash.geom.Point.copyFrom","flash/geom/Point.hx",34,0x23ce85a2)
		HX_STACK_THIS(this)
		HX_STACK_ARG(sourcePoint,"sourcePoint")
		HX_STACK_LINE(36)
		this->x = sourcePoint->x;
		HX_STACK_LINE(37)
		this->y = sourcePoint->y;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Point_obj,copyFrom,(void))

bool Point_obj::equals( ::flash::geom::Point toCompare){
	HX_STACK_FRAME("flash.geom.Point","equals",0x6f7a5d71,"flash.geom.Point.equals","flash/geom/Point.hx",53,0x23ce85a2)
	HX_STACK_THIS(this)
	HX_STACK_ARG(toCompare,"toCompare")
	HX_STACK_LINE(53)
	return (bool((toCompare->x == this->x)) && bool((toCompare->y == this->y)));
}


HX_DEFINE_DYNAMIC_FUNC1(Point_obj,equals,return )

Void Point_obj::normalize( Float thickness){
{
		HX_STACK_FRAME("flash.geom.Point","normalize",0xaa35d39b,"flash.geom.Point.normalize","flash/geom/Point.hx",67,0x23ce85a2)
		HX_STACK_THIS(this)
		HX_STACK_ARG(thickness,"thickness")
		HX_STACK_LINE(67)
		if (((bool((this->x == (int)0)) && bool((this->y == (int)0))))){
			HX_STACK_LINE(69)
			return null();
		}
		else{
			HX_STACK_LINE(73)
			Float _g = ::Math_obj::sqrt(((this->x * this->x) + (this->y * this->y)));		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(73)
			Float norm = (Float(thickness) / Float(_g));		HX_STACK_VAR(norm,"norm");
			HX_STACK_LINE(74)
			hx::MultEq(this->x,norm);
			HX_STACK_LINE(75)
			hx::MultEq(this->y,norm);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Point_obj,normalize,(void))

Void Point_obj::offset( Float dx,Float dy){
{
		HX_STACK_FRAME("flash.geom.Point","offset",0x0fc706c5,"flash.geom.Point.offset","flash/geom/Point.hx",82,0x23ce85a2)
		HX_STACK_THIS(this)
		HX_STACK_ARG(dx,"dx")
		HX_STACK_ARG(dy,"dy")
		HX_STACK_LINE(84)
		hx::AddEq(this->x,dx);
		HX_STACK_LINE(85)
		hx::AddEq(this->y,dy);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Point_obj,offset,(void))

Void Point_obj::setTo( Float x,Float y){
{
		HX_STACK_FRAME("flash.geom.Point","setTo",0x89e58ecb,"flash.geom.Point.setTo","flash/geom/Point.hx",97,0x23ce85a2)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_LINE(99)
		this->x = x;
		HX_STACK_LINE(100)
		this->y = y;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Point_obj,setTo,(void))

::flash::geom::Point Point_obj::subtract( ::flash::geom::Point v){
	HX_STACK_FRAME("flash.geom.Point","subtract",0x2bb894c6,"flash.geom.Point.subtract","flash/geom/Point.hx",107,0x23ce85a2)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(107)
	return ::flash::geom::Point_obj::__new((this->x - v->x),(this->y - v->y));
}


HX_DEFINE_DYNAMIC_FUNC1(Point_obj,subtract,return )

::String Point_obj::toString( ){
	HX_STACK_FRAME("flash.geom.Point","toString",0x6c15f05e,"flash.geom.Point.toString","flash/geom/Point.hx",114,0x23ce85a2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(114)
	return ((((HX_CSTRING("(") + this->x) + HX_CSTRING(", ")) + this->y) + HX_CSTRING(")"));
}


HX_DEFINE_DYNAMIC_FUNC0(Point_obj,toString,return )

Float Point_obj::get_length( ){
	HX_STACK_FRAME("flash.geom.Point","get_length",0x5302f4e1,"flash.geom.Point.get_length","flash/geom/Point.hx",128,0x23ce85a2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(128)
	return ::Math_obj::sqrt(((this->x * this->x) + (this->y * this->y)));
}


HX_DEFINE_DYNAMIC_FUNC0(Point_obj,get_length,return )

Float Point_obj::distance( ::flash::geom::Point pt1,::flash::geom::Point pt2){
	HX_STACK_FRAME("flash.geom.Point","distance",0x9fa0b2e7,"flash.geom.Point.distance","flash/geom/Point.hx",42,0x23ce85a2)
	HX_STACK_ARG(pt1,"pt1")
	HX_STACK_ARG(pt2,"pt2")
	HX_STACK_LINE(44)
	Float dx = (pt1->x - pt2->x);		HX_STACK_VAR(dx,"dx");
	HX_STACK_LINE(45)
	Float dy = (pt1->y - pt2->y);		HX_STACK_VAR(dy,"dy");
	HX_STACK_LINE(46)
	return ::Math_obj::sqrt(((dx * dx) + (dy * dy)));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Point_obj,distance,return )

::flash::geom::Point Point_obj::interpolate( ::flash::geom::Point pt1,::flash::geom::Point pt2,Float f){
	HX_STACK_FRAME("flash.geom.Point","interpolate",0x6131104f,"flash.geom.Point.interpolate","flash/geom/Point.hx",60,0x23ce85a2)
	HX_STACK_ARG(pt1,"pt1")
	HX_STACK_ARG(pt2,"pt2")
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(60)
	return ::flash::geom::Point_obj::__new((pt2->x + (f * ((pt1->x - pt2->x)))),(pt2->y + (f * ((pt1->y - pt2->y)))));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Point_obj,interpolate,return )

::flash::geom::Point Point_obj::polar( Float len,Float angle){
	HX_STACK_FRAME("flash.geom.Point","polar",0xd647eccc,"flash.geom.Point.polar","flash/geom/Point.hx",90,0x23ce85a2)
	HX_STACK_ARG(len,"len")
	HX_STACK_ARG(angle,"angle")
	HX_STACK_LINE(92)
	Float _g = ::Math_obj::cos(angle);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(92)
	Float _g1 = (len * _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(92)
	Float _g2 = ::Math_obj::sin(angle);		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(92)
	Float _g3 = (len * _g2);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(92)
	return ::flash::geom::Point_obj::__new(_g1,_g3);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Point_obj,polar,return )


Point_obj::Point_obj()
{
}

Dynamic Point_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { return x; }
		if (HX_FIELD_EQ(inName,"y") ) { return y; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"add") ) { return add_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"polar") ) { return polar_dyn(); }
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		if (HX_FIELD_EQ(inName,"setTo") ) { return setTo_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"length") ) { return inCallProp ? get_length() : length; }
		if (HX_FIELD_EQ(inName,"equals") ) { return equals_dyn(); }
		if (HX_FIELD_EQ(inName,"offset") ) { return offset_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"distance") ) { return distance_dyn(); }
		if (HX_FIELD_EQ(inName,"copyFrom") ) { return copyFrom_dyn(); }
		if (HX_FIELD_EQ(inName,"subtract") ) { return subtract_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"normalize") ) { return normalize_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"get_length") ) { return get_length_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"interpolate") ) { return interpolate_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Point_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { x=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"y") ) { y=inValue.Cast< Float >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"length") ) { length=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Point_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("length"));
	outFields->push(HX_CSTRING("x"));
	outFields->push(HX_CSTRING("y"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("distance"),
	HX_CSTRING("interpolate"),
	HX_CSTRING("polar"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(Point_obj,length),HX_CSTRING("length")},
	{hx::fsFloat,(int)offsetof(Point_obj,x),HX_CSTRING("x")},
	{hx::fsFloat,(int)offsetof(Point_obj,y),HX_CSTRING("y")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("length"),
	HX_CSTRING("x"),
	HX_CSTRING("y"),
	HX_CSTRING("add"),
	HX_CSTRING("clone"),
	HX_CSTRING("copyFrom"),
	HX_CSTRING("equals"),
	HX_CSTRING("normalize"),
	HX_CSTRING("offset"),
	HX_CSTRING("setTo"),
	HX_CSTRING("subtract"),
	HX_CSTRING("toString"),
	HX_CSTRING("get_length"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Point_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Point_obj::__mClass,"__mClass");
};

#endif

Class Point_obj::__mClass;

void Point_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.geom.Point"), hx::TCanCast< Point_obj> ,sStaticFields,sMemberFields,
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

void Point_obj::__boot()
{
}

} // end namespace flash
} // end namespace geom
