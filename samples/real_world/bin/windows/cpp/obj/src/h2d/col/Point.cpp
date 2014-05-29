#include <hxcpp.h>

#ifndef INCLUDED_h2d_col_Point
#include <h2d/col/Point.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_hxd_Math
#include <hxd/Math.h>
#endif
namespace h2d{
namespace col{

Void Point_obj::__construct(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y)
{
HX_STACK_FRAME("h2d.col.Point","new",0x59a33260,"h2d.col.Point.new","h2d/col/Point.hx",9,0x8be51f92)
HX_STACK_THIS(this)
HX_STACK_ARG(__o_x,"x")
HX_STACK_ARG(__o_y,"y")
Float x = __o_x.Default(0.);
Float y = __o_y.Default(0.);
{
	HX_STACK_LINE(10)
	this->x = x;
	HX_STACK_LINE(11)
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

Float Point_obj::distanceSq( ::h2d::col::Point p){
	HX_STACK_FRAME("h2d.col.Point","distanceSq",0xda2db133,"h2d.col.Point.distanceSq","h2d/col/Point.hx",14,0x8be51f92)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(15)
	Float dx = (this->x - p->x);		HX_STACK_VAR(dx,"dx");
	HX_STACK_LINE(16)
	Float dy = (this->y - p->y);		HX_STACK_VAR(dy,"dy");
	HX_STACK_LINE(17)
	return ((dx * dx) + (dy * dy));
}


HX_DEFINE_DYNAMIC_FUNC1(Point_obj,distanceSq,return )

Float Point_obj::distance( ::h2d::col::Point p){
	HX_STACK_FRAME("h2d.col.Point","distance",0xeda6f135,"h2d.col.Point.distance","h2d/col/Point.hx",21,0x8be51f92)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	struct _Function_1_1{
		inline static Float Block( hx::ObjectPtr< ::h2d::col::Point_obj > __this,::h2d::col::Point &p){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h2d/col/Point.hx",21,0x8be51f92)
			{
				HX_STACK_LINE(21)
				Float dx = (__this->x - p->x);		HX_STACK_VAR(dx,"dx");
				HX_STACK_LINE(21)
				Float dy = (__this->y - p->y);		HX_STACK_VAR(dy,"dy");
				HX_STACK_LINE(21)
				return ((dx * dx) + (dy * dy));
			}
			return null();
		}
	};
	HX_STACK_LINE(21)
	return ::Math_obj::sqrt(_Function_1_1::Block(this,p));
}


HX_DEFINE_DYNAMIC_FUNC1(Point_obj,distance,return )

::String Point_obj::toString( ){
	HX_STACK_FRAME("h2d.col.Point","toString",0xba1c2eac,"h2d.col.Point.toString","h2d/col/Point.hx",24,0x8be51f92)
	HX_STACK_THIS(this)
	HX_STACK_LINE(25)
	Float _g = ::hxd::Math_obj::fmt(this->x);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(25)
	::String _g1 = (HX_CSTRING("{") + _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(25)
	::String _g2 = (_g1 + HX_CSTRING(","));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(25)
	Float _g3 = ::hxd::Math_obj::fmt(this->y);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(25)
	::String _g4 = (_g2 + _g3);		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(25)
	return (_g4 + HX_CSTRING("}"));
}


HX_DEFINE_DYNAMIC_FUNC0(Point_obj,toString,return )

::h2d::col::Point Point_obj::sub( ::h2d::col::Point p){
	HX_STACK_FRAME("h2d.col.Point","sub",0x59a70b80,"h2d.col.Point.sub","h2d/col/Point.hx",29,0x8be51f92)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(29)
	return ::h2d::col::Point_obj::__new((this->x - p->x),(this->y - p->y));
}


HX_DEFINE_DYNAMIC_FUNC1(Point_obj,sub,return )

::h2d::col::Point Point_obj::add( ::h2d::col::Point p){
	HX_STACK_FRAME("h2d.col.Point","add",0x59995421,"h2d.col.Point.add","h2d/col/Point.hx",33,0x8be51f92)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(33)
	return ::h2d::col::Point_obj::__new((this->x + p->x),(this->y + p->y));
}


HX_DEFINE_DYNAMIC_FUNC1(Point_obj,add,return )

Float Point_obj::dot( ::h2d::col::Point p){
	HX_STACK_FRAME("h2d.col.Point","dot",0x599ba489,"h2d.col.Point.dot","h2d/col/Point.hx",37,0x8be51f92)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(37)
	return ((this->x * p->x) + (this->y * p->y));
}


HX_DEFINE_DYNAMIC_FUNC1(Point_obj,dot,return )

Float Point_obj::lengthSq( ){
	HX_STACK_FRAME("h2d.col.Point","lengthSq",0xa170c124,"h2d.col.Point.lengthSq","h2d/col/Point.hx",41,0x8be51f92)
	HX_STACK_THIS(this)
	HX_STACK_LINE(41)
	return ((this->x * this->x) + (this->y * this->y));
}


HX_DEFINE_DYNAMIC_FUNC0(Point_obj,lengthSq,return )

Float Point_obj::length( ){
	HX_STACK_FRAME("h2d.col.Point","length",0x880172e6,"h2d.col.Point.length","h2d/col/Point.hx",45,0x8be51f92)
	HX_STACK_THIS(this)
	HX_STACK_LINE(45)
	return ::Math_obj::sqrt(((this->x * this->x) + (this->y * this->y)));
}


HX_DEFINE_DYNAMIC_FUNC0(Point_obj,length,return )

Void Point_obj::normalize( ){
{
		HX_STACK_FRAME("h2d.col.Point","normalize",0xa1a6198d,"h2d.col.Point.normalize","h2d/col/Point.hx",48,0x8be51f92)
		HX_STACK_THIS(this)
		HX_STACK_LINE(49)
		Float k = ((this->x * this->x) + (this->y * this->y));		HX_STACK_VAR(k,"k");
		HX_STACK_LINE(50)
		if (((k < 1e-10))){
			HX_STACK_LINE(50)
			k = (int)0;
		}
		else{
			HX_STACK_LINE(50)
			Float _g = ::Math_obj::sqrt(k);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(50)
			Float _g1 = (Float(1.) / Float(_g));		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(50)
			k = _g1;
		}
		HX_STACK_LINE(51)
		hx::MultEq(this->x,k);
		HX_STACK_LINE(52)
		hx::MultEq(this->y,k);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Point_obj,normalize,(void))

Void Point_obj::set( Float x,Float y){
{
		HX_STACK_FRAME("h2d.col.Point","set",0x59a6fda2,"h2d.col.Point.set","h2d/col/Point.hx",55,0x8be51f92)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_LINE(56)
		this->x = x;
		HX_STACK_LINE(57)
		this->y = y;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Point_obj,set,(void))

Void Point_obj::scale( Float f){
{
		HX_STACK_FRAME("h2d.col.Point","scale",0x4e3ab08a,"h2d.col.Point.scale","h2d/col/Point.hx",60,0x8be51f92)
		HX_STACK_THIS(this)
		HX_STACK_ARG(f,"f")
		HX_STACK_LINE(61)
		hx::MultEq(this->x,f);
		HX_STACK_LINE(62)
		hx::MultEq(this->y,f);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Point_obj,scale,(void))

::h2d::col::Point Point_obj::ZERO;


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
		if (HX_FIELD_EQ(inName,"sub") ) { return sub_dyn(); }
		if (HX_FIELD_EQ(inName,"add") ) { return add_dyn(); }
		if (HX_FIELD_EQ(inName,"dot") ) { return dot_dyn(); }
		if (HX_FIELD_EQ(inName,"set") ) { return set_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"ZERO") ) { return ZERO; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"scale") ) { return scale_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"length") ) { return length_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"distance") ) { return distance_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		if (HX_FIELD_EQ(inName,"lengthSq") ) { return lengthSq_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"normalize") ) { return normalize_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"distanceSq") ) { return distanceSq_dyn(); }
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
	case 4:
		if (HX_FIELD_EQ(inName,"ZERO") ) { ZERO=inValue.Cast< ::h2d::col::Point >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Point_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("x"));
	outFields->push(HX_CSTRING("y"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("ZERO"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(Point_obj,x),HX_CSTRING("x")},
	{hx::fsFloat,(int)offsetof(Point_obj,y),HX_CSTRING("y")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("x"),
	HX_CSTRING("y"),
	HX_CSTRING("distanceSq"),
	HX_CSTRING("distance"),
	HX_CSTRING("toString"),
	HX_CSTRING("sub"),
	HX_CSTRING("add"),
	HX_CSTRING("dot"),
	HX_CSTRING("lengthSq"),
	HX_CSTRING("length"),
	HX_CSTRING("normalize"),
	HX_CSTRING("set"),
	HX_CSTRING("scale"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Point_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Point_obj::ZERO,"ZERO");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Point_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Point_obj::ZERO,"ZERO");
};

#endif

Class Point_obj::__mClass;

void Point_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.col.Point"), hx::TCanCast< Point_obj> ,sStaticFields,sMemberFields,
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
	ZERO= ::h2d::col::Point_obj::__new((int)0,(int)0);
}

} // end namespace h2d
} // end namespace col
