#include <hxcpp.h>

#ifndef INCLUDED_h2d_col_Circle
#include <h2d/col/Circle.h>
#endif
#ifndef INCLUDED_h2d_col_Point
#include <h2d/col/Point.h>
#endif
#ifndef INCLUDED_hxd_Math
#include <hxd/Math.h>
#endif
namespace h2d{
namespace col{

Void Circle_obj::__construct(Float x,Float y,Float ray)
{
HX_STACK_FRAME("h2d.col.Circle","new",0xe6fa6024,"h2d.col.Circle.new","h2d/col/Circle.hx",10,0x6873bb0a)
HX_STACK_THIS(this)
HX_STACK_ARG(x,"x")
HX_STACK_ARG(y,"y")
HX_STACK_ARG(ray,"ray")
{
	HX_STACK_LINE(11)
	this->x = x;
	HX_STACK_LINE(12)
	this->y = y;
	HX_STACK_LINE(13)
	this->ray = ray;
}
;
	return null();
}

//Circle_obj::~Circle_obj() { }

Dynamic Circle_obj::__CreateEmpty() { return  new Circle_obj; }
hx::ObjectPtr< Circle_obj > Circle_obj::__new(Float x,Float y,Float ray)
{  hx::ObjectPtr< Circle_obj > result = new Circle_obj();
	result->__construct(x,y,ray);
	return result;}

Dynamic Circle_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Circle_obj > result = new Circle_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

Float Circle_obj::distanceSq( ::h2d::col::Point p){
	HX_STACK_FRAME("h2d.col.Circle","distanceSq",0x5e6583ef,"h2d.col.Circle.distanceSq","h2d/col/Circle.hx",16,0x6873bb0a)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(17)
	Float dx = (p->x - this->x);		HX_STACK_VAR(dx,"dx");
	HX_STACK_LINE(18)
	Float dy = (p->y - this->y);		HX_STACK_VAR(dy,"dy");
	HX_STACK_LINE(19)
	Float d = (((dx * dx) + (dy * dy)) - (this->ray * this->ray));		HX_STACK_VAR(d,"d");
	HX_STACK_LINE(20)
	if (((d < (int)0))){
		HX_STACK_LINE(20)
		return (int)0;
	}
	else{
		HX_STACK_LINE(20)
		return d;
	}
	HX_STACK_LINE(20)
	return 0.;
}


HX_DEFINE_DYNAMIC_FUNC1(Circle_obj,distanceSq,return )

Float Circle_obj::side( ::h2d::col::Point p){
	HX_STACK_FRAME("h2d.col.Circle","side",0x376ac953,"h2d.col.Circle.side","h2d/col/Circle.hx",23,0x6873bb0a)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(24)
	Float dx = (p->x - this->x);		HX_STACK_VAR(dx,"dx");
	HX_STACK_LINE(25)
	Float dy = (p->y - this->y);		HX_STACK_VAR(dy,"dy");
	HX_STACK_LINE(26)
	return ((this->ray * this->ray) - (((dx * dx) + (dy * dy))));
}


HX_DEFINE_DYNAMIC_FUNC1(Circle_obj,side,return )

bool Circle_obj::collideCircle( ::h2d::col::Circle c){
	HX_STACK_FRAME("h2d.col.Circle","collideCircle",0xa25cb4f2,"h2d.col.Circle.collideCircle","h2d/col/Circle.hx",29,0x6873bb0a)
	HX_STACK_THIS(this)
	HX_STACK_ARG(c,"c")
	HX_STACK_LINE(30)
	Float dx = (this->x - c->x);		HX_STACK_VAR(dx,"dx");
	HX_STACK_LINE(31)
	Float dy = (this->y - c->y);		HX_STACK_VAR(dy,"dy");
	HX_STACK_LINE(32)
	return (((dx * dx) + (dy * dy)) < (((this->ray + c->ray)) * ((this->ray + c->ray))));
}


HX_DEFINE_DYNAMIC_FUNC1(Circle_obj,collideCircle,return )

::String Circle_obj::toString( ){
	HX_STACK_FRAME("h2d.col.Circle","toString",0xde949a68,"h2d.col.Circle.toString","h2d/col/Circle.hx",35,0x6873bb0a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(36)
	Float _g = ::hxd::Math_obj::fmt(this->x);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(36)
	::String _g1 = (HX_CSTRING("{") + _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(36)
	::String _g2 = (_g1 + HX_CSTRING(","));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(36)
	Float _g3 = ::hxd::Math_obj::fmt(this->y);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(36)
	::String _g4 = (_g2 + _g3);		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(36)
	::String _g5 = (_g4 + HX_CSTRING(","));		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(36)
	Float _g6 = ::hxd::Math_obj::fmt(this->ray);		HX_STACK_VAR(_g6,"_g6");
	HX_STACK_LINE(36)
	::String _g7 = (_g5 + _g6);		HX_STACK_VAR(_g7,"_g7");
	HX_STACK_LINE(36)
	return (_g7 + HX_CSTRING("}"));
}


HX_DEFINE_DYNAMIC_FUNC0(Circle_obj,toString,return )


Circle_obj::Circle_obj()
{
}

Dynamic Circle_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { return x; }
		if (HX_FIELD_EQ(inName,"y") ) { return y; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"ray") ) { return ray; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"side") ) { return side_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"distanceSq") ) { return distanceSq_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"collideCircle") ) { return collideCircle_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Circle_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { x=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"y") ) { y=inValue.Cast< Float >(); return inValue; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"ray") ) { ray=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Circle_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("x"));
	outFields->push(HX_CSTRING("y"));
	outFields->push(HX_CSTRING("ray"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(Circle_obj,x),HX_CSTRING("x")},
	{hx::fsFloat,(int)offsetof(Circle_obj,y),HX_CSTRING("y")},
	{hx::fsFloat,(int)offsetof(Circle_obj,ray),HX_CSTRING("ray")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("x"),
	HX_CSTRING("y"),
	HX_CSTRING("ray"),
	HX_CSTRING("distanceSq"),
	HX_CSTRING("side"),
	HX_CSTRING("collideCircle"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Circle_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Circle_obj::__mClass,"__mClass");
};

#endif

Class Circle_obj::__mClass;

void Circle_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.col.Circle"), hx::TCanCast< Circle_obj> ,sStaticFields,sMemberFields,
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

void Circle_obj::__boot()
{
}

} // end namespace h2d
} // end namespace col
