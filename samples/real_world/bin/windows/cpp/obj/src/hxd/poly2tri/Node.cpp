#include <hxcpp.h>

#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Node
#include <hxd/poly2tri/Node.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Point
#include <hxd/poly2tri/Point.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Triangle
#include <hxd/poly2tri/Triangle.h>
#endif
namespace hxd{
namespace poly2tri{

Void Node_obj::__construct(::hxd::poly2tri::Point point,::hxd::poly2tri::Triangle triangle)
{
HX_STACK_FRAME("hxd.poly2tri.Node","new",0x44e0b183,"hxd.poly2tri.Node.new","hxd/poly2tri/Node.hx",14,0xced3736d)
HX_STACK_THIS(this)
HX_STACK_ARG(point,"point")
HX_STACK_ARG(triangle,"triangle")
{
	HX_STACK_LINE(16)
	this->point = point;
	HX_STACK_LINE(17)
	this->triangle = triangle;
	HX_STACK_LINE(18)
	this->value = this->point->x;
}
;
	return null();
}

//Node_obj::~Node_obj() { }

Dynamic Node_obj::__CreateEmpty() { return  new Node_obj; }
hx::ObjectPtr< Node_obj > Node_obj::__new(::hxd::poly2tri::Point point,::hxd::poly2tri::Triangle triangle)
{  hx::ObjectPtr< Node_obj > result = new Node_obj();
	result->__construct(point,triangle);
	return result;}

Dynamic Node_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Node_obj > result = new Node_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

Float Node_obj::getHoleAngle( ){
	HX_STACK_FRAME("hxd.poly2tri.Node","getHoleAngle",0xb8ef617a,"hxd.poly2tri.Node.getHoleAngle","hxd/poly2tri/Node.hx",27,0xced3736d)
	HX_STACK_THIS(this)
	HX_STACK_LINE(36)
	Float ax = (this->next->point->x - this->point->x);		HX_STACK_VAR(ax,"ax");
	HX_STACK_LINE(37)
	Float ay = (this->next->point->y - this->point->y);		HX_STACK_VAR(ay,"ay");
	HX_STACK_LINE(38)
	Float bx = (this->prev->point->x - this->point->x);		HX_STACK_VAR(bx,"bx");
	HX_STACK_LINE(39)
	Float by = (this->prev->point->y - this->point->y);		HX_STACK_VAR(by,"by");
	HX_STACK_LINE(40)
	return ::Math_obj::atan2(((ax * by) - (ay * bx)),((ax * bx) + (ay * by)));
}


HX_DEFINE_DYNAMIC_FUNC0(Node_obj,getHoleAngle,return )

Float Node_obj::getBasinAngle( ){
	HX_STACK_FRAME("hxd.poly2tri.Node","getBasinAngle",0x5dee3173,"hxd.poly2tri.Node.getBasinAngle","hxd/poly2tri/Node.hx",48,0xced3736d)
	HX_STACK_THIS(this)
	HX_STACK_LINE(48)
	return ::Math_obj::atan2((this->point->y - this->next->next->point->y),(this->point->x - this->next->next->point->x));
}


HX_DEFINE_DYNAMIC_FUNC0(Node_obj,getBasinAngle,return )


Node_obj::Node_obj()
{
}

void Node_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Node);
	HX_MARK_MEMBER_NAME(point,"point");
	HX_MARK_MEMBER_NAME(triangle,"triangle");
	HX_MARK_MEMBER_NAME(prev,"prev");
	HX_MARK_MEMBER_NAME(next,"next");
	HX_MARK_MEMBER_NAME(value,"value");
	HX_MARK_END_CLASS();
}

void Node_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(point,"point");
	HX_VISIT_MEMBER_NAME(triangle,"triangle");
	HX_VISIT_MEMBER_NAME(prev,"prev");
	HX_VISIT_MEMBER_NAME(next,"next");
	HX_VISIT_MEMBER_NAME(value,"value");
}

Dynamic Node_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"prev") ) { return prev; }
		if (HX_FIELD_EQ(inName,"next") ) { return next; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"point") ) { return point; }
		if (HX_FIELD_EQ(inName,"value") ) { return value; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"triangle") ) { return triangle; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"getHoleAngle") ) { return getHoleAngle_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"getBasinAngle") ) { return getBasinAngle_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Node_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"prev") ) { prev=inValue.Cast< ::hxd::poly2tri::Node >(); return inValue; }
		if (HX_FIELD_EQ(inName,"next") ) { next=inValue.Cast< ::hxd::poly2tri::Node >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"point") ) { point=inValue.Cast< ::hxd::poly2tri::Point >(); return inValue; }
		if (HX_FIELD_EQ(inName,"value") ) { value=inValue.Cast< Float >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"triangle") ) { triangle=inValue.Cast< ::hxd::poly2tri::Triangle >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Node_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("point"));
	outFields->push(HX_CSTRING("triangle"));
	outFields->push(HX_CSTRING("prev"));
	outFields->push(HX_CSTRING("next"));
	outFields->push(HX_CSTRING("value"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::hxd::poly2tri::Point*/ ,(int)offsetof(Node_obj,point),HX_CSTRING("point")},
	{hx::fsObject /*::hxd::poly2tri::Triangle*/ ,(int)offsetof(Node_obj,triangle),HX_CSTRING("triangle")},
	{hx::fsObject /*::hxd::poly2tri::Node*/ ,(int)offsetof(Node_obj,prev),HX_CSTRING("prev")},
	{hx::fsObject /*::hxd::poly2tri::Node*/ ,(int)offsetof(Node_obj,next),HX_CSTRING("next")},
	{hx::fsFloat,(int)offsetof(Node_obj,value),HX_CSTRING("value")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("point"),
	HX_CSTRING("triangle"),
	HX_CSTRING("prev"),
	HX_CSTRING("next"),
	HX_CSTRING("value"),
	HX_CSTRING("getHoleAngle"),
	HX_CSTRING("getBasinAngle"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Node_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Node_obj::__mClass,"__mClass");
};

#endif

Class Node_obj::__mClass;

void Node_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.poly2tri.Node"), hx::TCanCast< Node_obj> ,sStaticFields,sMemberFields,
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

void Node_obj::__boot()
{
}

} // end namespace hxd
} // end namespace poly2tri
