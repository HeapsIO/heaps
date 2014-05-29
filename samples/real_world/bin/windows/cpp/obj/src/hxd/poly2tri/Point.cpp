#include <hxcpp.h>

#ifndef INCLUDED_hxd_poly2tri_Edge
#include <hxd/poly2tri/Edge.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Point
#include <hxd/poly2tri/Point.h>
#endif
namespace hxd{
namespace poly2tri{

Void Point_obj::__construct(Float x,Float y)
{
HX_STACK_FRAME("hxd.poly2tri.Point","new",0x3284bcd3,"hxd.poly2tri.Point.new","hxd/poly2tri/Point.hx",23,0xf91355dd)
HX_STACK_THIS(this)
HX_STACK_ARG(x,"x")
HX_STACK_ARG(y,"y")
{
	HX_STACK_LINE(24)
	this->x = x;
	HX_STACK_LINE(25)
	this->y = y;
	HX_STACK_LINE(27)
	this->id = ::hxd::poly2tri::Point_obj::C_ID;
	HX_STACK_LINE(28)
	(::hxd::poly2tri::Point_obj::C_ID)++;
}
;
	return null();
}

//Point_obj::~Point_obj() { }

Dynamic Point_obj::__CreateEmpty() { return  new Point_obj; }
hx::ObjectPtr< Point_obj > Point_obj::__new(Float x,Float y)
{  hx::ObjectPtr< Point_obj > result = new Point_obj();
	result->__construct(x,y);
	return result;}

Dynamic Point_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Point_obj > result = new Point_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

Array< ::Dynamic > Point_obj::get_edge_list( ){
	HX_STACK_FRAME("hxd.poly2tri.Point","get_edge_list",0x274360ea,"hxd.poly2tri.Point.get_edge_list","hxd/poly2tri/Point.hx",34,0xf91355dd)
	HX_STACK_THIS(this)
	HX_STACK_LINE(35)
	if (((this->edge_list == null()))){
		HX_STACK_LINE(35)
		Array< ::Dynamic > _g = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(35)
		this->edge_list = _g;
	}
	HX_STACK_LINE(36)
	return this->edge_list;
}


HX_DEFINE_DYNAMIC_FUNC0(Point_obj,get_edge_list,return )

bool Point_obj::equals( ::hxd::poly2tri::Point that){
	HX_STACK_FRAME("hxd.poly2tri.Point","equals",0x56210bac,"hxd.poly2tri.Point.equals","hxd/poly2tri/Point.hx",46,0xf91355dd)
	HX_STACK_THIS(this)
	HX_STACK_ARG(that,"that")
	HX_STACK_LINE(46)
	return (bool((this->x == that->x)) && bool((this->y == that->y)));
}


HX_DEFINE_DYNAMIC_FUNC1(Point_obj,equals,return )

::String Point_obj::toString( ){
	HX_STACK_FRAME("hxd.poly2tri.Point","toString",0x4c70e359,"hxd.poly2tri.Point.toString","hxd/poly2tri/Point.hx",66,0xf91355dd)
	HX_STACK_THIS(this)
	HX_STACK_LINE(66)
	return ((((HX_CSTRING("Point(") + this->x) + HX_CSTRING(", ")) + this->y) + HX_CSTRING(")"));
}


HX_DEFINE_DYNAMIC_FUNC0(Point_obj,toString,return )

Void Point_obj::sortPoints( Array< ::Dynamic > points){
{
		HX_STACK_FRAME("hxd.poly2tri.Point","sortPoints",0xfac1600e,"hxd.poly2tri.Point.sortPoints","hxd/poly2tri/Point.hx",52,0xf91355dd)
		HX_STACK_ARG(points,"points")
		HX_STACK_LINE(52)
		points->sort(::hxd::poly2tri::Point_obj::cmpPoints_dyn());
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Point_obj,sortPoints,(void))

int Point_obj::cmpPoints( ::hxd::poly2tri::Point l,::hxd::poly2tri::Point r){
	HX_STACK_FRAME("hxd.poly2tri.Point","cmpPoints",0xb8caf1fc,"hxd.poly2tri.Point.cmpPoints","hxd/poly2tri/Point.hx",56,0xf91355dd)
	HX_STACK_ARG(l,"l")
	HX_STACK_ARG(r,"r")
	HX_STACK_LINE(57)
	Float ret = (l->y - r->y);		HX_STACK_VAR(ret,"ret");
	HX_STACK_LINE(58)
	if (((ret == (int)0))){
		HX_STACK_LINE(58)
		ret = (l->x - r->x);
	}
	HX_STACK_LINE(59)
	if (((ret < (int)0))){
		HX_STACK_LINE(59)
		return (int)-1;
	}
	HX_STACK_LINE(60)
	if (((ret > (int)0))){
		HX_STACK_LINE(60)
		return (int)1;
	}
	HX_STACK_LINE(61)
	return (int)0;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Point_obj,cmpPoints,return )

int Point_obj::C_ID;


Point_obj::Point_obj()
{
}

void Point_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Point);
	HX_MARK_MEMBER_NAME(id,"id");
	HX_MARK_MEMBER_NAME(x,"x");
	HX_MARK_MEMBER_NAME(y,"y");
	HX_MARK_MEMBER_NAME(edge_list,"edge_list");
	HX_MARK_END_CLASS();
}

void Point_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(id,"id");
	HX_VISIT_MEMBER_NAME(x,"x");
	HX_VISIT_MEMBER_NAME(y,"y");
	HX_VISIT_MEMBER_NAME(edge_list,"edge_list");
}

Dynamic Point_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { return x; }
		if (HX_FIELD_EQ(inName,"y") ) { return y; }
		break;
	case 2:
		if (HX_FIELD_EQ(inName,"id") ) { return id; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"C_ID") ) { return C_ID; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"equals") ) { return equals_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"cmpPoints") ) { return cmpPoints_dyn(); }
		if (HX_FIELD_EQ(inName,"edge_list") ) { return inCallProp ? get_edge_list() : edge_list; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"sortPoints") ) { return sortPoints_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"get_edge_list") ) { return get_edge_list_dyn(); }
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
	case 2:
		if (HX_FIELD_EQ(inName,"id") ) { id=inValue.Cast< int >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"C_ID") ) { C_ID=inValue.Cast< int >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"edge_list") ) { edge_list=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Point_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("id"));
	outFields->push(HX_CSTRING("x"));
	outFields->push(HX_CSTRING("y"));
	outFields->push(HX_CSTRING("edge_list"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("sortPoints"),
	HX_CSTRING("cmpPoints"),
	HX_CSTRING("C_ID"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(Point_obj,id),HX_CSTRING("id")},
	{hx::fsFloat,(int)offsetof(Point_obj,x),HX_CSTRING("x")},
	{hx::fsFloat,(int)offsetof(Point_obj,y),HX_CSTRING("y")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Point_obj,edge_list),HX_CSTRING("edge_list")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("id"),
	HX_CSTRING("x"),
	HX_CSTRING("y"),
	HX_CSTRING("edge_list"),
	HX_CSTRING("get_edge_list"),
	HX_CSTRING("equals"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Point_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Point_obj::C_ID,"C_ID");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Point_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Point_obj::C_ID,"C_ID");
};

#endif

Class Point_obj::__mClass;

void Point_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.poly2tri.Point"), hx::TCanCast< Point_obj> ,sStaticFields,sMemberFields,
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
	C_ID= (int)0;
}

} // end namespace hxd
} // end namespace poly2tri
