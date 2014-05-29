#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Edge
#include <hxd/poly2tri/Edge.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Point
#include <hxd/poly2tri/Point.h>
#endif
namespace hxd{
namespace poly2tri{

Void Edge_obj::__construct(::hxd::poly2tri::Point p1,::hxd::poly2tri::Point p2)
{
HX_STACK_FRAME("hxd.poly2tri.Edge","new",0xabc0a93e,"hxd.poly2tri.Edge.new","hxd/poly2tri/Edge.hx",9,0xacd90c12)
HX_STACK_THIS(this)
HX_STACK_ARG(p1,"p1")
HX_STACK_ARG(p2,"p2")
{
	HX_STACK_LINE(10)
	if (((bool((p1 == null())) || bool((p2 == null()))))){
		HX_STACK_LINE(10)
		HX_STACK_DO_THROW(HX_CSTRING("Edge::new p1 or p2 is null"));
	}
	HX_STACK_LINE(12)
	bool swap = false;		HX_STACK_VAR(swap,"swap");
	HX_STACK_LINE(14)
	if (((p1->y > p2->y))){
		HX_STACK_LINE(16)
		swap = true;
	}
	else{
		HX_STACK_LINE(18)
		if (((p1->y == p2->y))){
			HX_STACK_LINE(20)
			if (((p1->x == p2->x))){
				HX_STACK_LINE(20)
				::String _g = ::Std_obj::string(p1);		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(20)
				HX_STACK_DO_THROW((HX_CSTRING("Edge::repeat points ") + _g));
			}
			HX_STACK_LINE(22)
			swap = (p1->x > p2->x);
		}
	}
	HX_STACK_LINE(26)
	if ((swap)){
		HX_STACK_LINE(28)
		this->q = p1;
		HX_STACK_LINE(29)
		this->p = p2;
	}
	else{
		HX_STACK_LINE(33)
		this->p = p1;
		HX_STACK_LINE(34)
		this->q = p2;
	}
	HX_STACK_LINE(37)
	this->q->get_edge_list()->push(hx::ObjectPtr<OBJ_>(this));
}
;
	return null();
}

//Edge_obj::~Edge_obj() { }

Dynamic Edge_obj::__CreateEmpty() { return  new Edge_obj; }
hx::ObjectPtr< Edge_obj > Edge_obj::__new(::hxd::poly2tri::Point p1,::hxd::poly2tri::Point p2)
{  hx::ObjectPtr< Edge_obj > result = new Edge_obj();
	result->__construct(p1,p2);
	return result;}

Dynamic Edge_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Edge_obj > result = new Edge_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

::String Edge_obj::toString( ){
	HX_STACK_FRAME("hxd.poly2tri.Edge","toString",0x7ead130e,"hxd.poly2tri.Edge.toString","hxd/poly2tri/Edge.hx",43,0xacd90c12)
	HX_STACK_THIS(this)
	HX_STACK_LINE(44)
	::String _g = ::Std_obj::string(this->p);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(44)
	::String _g1 = (HX_CSTRING("Edge(") + _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(44)
	::String _g2 = (_g1 + HX_CSTRING(", "));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(44)
	::String _g3 = ::Std_obj::string(this->q);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(44)
	::String _g4 = (_g2 + _g3);		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(44)
	return (_g4 + HX_CSTRING(")"));
}


HX_DEFINE_DYNAMIC_FUNC0(Edge_obj,toString,return )


Edge_obj::Edge_obj()
{
}

void Edge_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Edge);
	HX_MARK_MEMBER_NAME(p,"p");
	HX_MARK_MEMBER_NAME(q,"q");
	HX_MARK_END_CLASS();
}

void Edge_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(p,"p");
	HX_VISIT_MEMBER_NAME(q,"q");
}

Dynamic Edge_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"p") ) { return p; }
		if (HX_FIELD_EQ(inName,"q") ) { return q; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Edge_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"p") ) { p=inValue.Cast< ::hxd::poly2tri::Point >(); return inValue; }
		if (HX_FIELD_EQ(inName,"q") ) { q=inValue.Cast< ::hxd::poly2tri::Point >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Edge_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("p"));
	outFields->push(HX_CSTRING("q"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::hxd::poly2tri::Point*/ ,(int)offsetof(Edge_obj,p),HX_CSTRING("p")},
	{hx::fsObject /*::hxd::poly2tri::Point*/ ,(int)offsetof(Edge_obj,q),HX_CSTRING("q")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("p"),
	HX_CSTRING("q"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Edge_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Edge_obj::__mClass,"__mClass");
};

#endif

Class Edge_obj::__mClass;

void Edge_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.poly2tri.Edge"), hx::TCanCast< Edge_obj> ,sStaticFields,sMemberFields,
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

void Edge_obj::__boot()
{
}

} // end namespace hxd
} // end namespace poly2tri
