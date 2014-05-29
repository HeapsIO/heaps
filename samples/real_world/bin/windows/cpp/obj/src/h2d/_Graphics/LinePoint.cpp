#include <hxcpp.h>

#ifndef INCLUDED_h2d__Graphics_LinePoint
#include <h2d/_Graphics/LinePoint.h>
#endif
namespace h2d{
namespace _Graphics{

Void LinePoint_obj::__construct(Float x,Float y,Float r,Float g,Float b,Float a)
{
HX_STACK_FRAME("h2d._Graphics.LinePoint","new",0x4bb52556,"h2d._Graphics.LinePoint.new","h2d/Graphics.hx",14,0x5cd0883e)
HX_STACK_THIS(this)
HX_STACK_ARG(x,"x")
HX_STACK_ARG(y,"y")
HX_STACK_ARG(r,"r")
HX_STACK_ARG(g,"g")
HX_STACK_ARG(b,"b")
HX_STACK_ARG(a,"a")
{
	HX_STACK_LINE(15)
	this->x = x;
	HX_STACK_LINE(16)
	this->y = y;
	HX_STACK_LINE(17)
	this->r = r;
	HX_STACK_LINE(18)
	this->g = g;
	HX_STACK_LINE(19)
	this->b = b;
	HX_STACK_LINE(20)
	this->a = a;
}
;
	return null();
}

//LinePoint_obj::~LinePoint_obj() { }

Dynamic LinePoint_obj::__CreateEmpty() { return  new LinePoint_obj; }
hx::ObjectPtr< LinePoint_obj > LinePoint_obj::__new(Float x,Float y,Float r,Float g,Float b,Float a)
{  hx::ObjectPtr< LinePoint_obj > result = new LinePoint_obj();
	result->__construct(x,y,r,g,b,a);
	return result;}

Dynamic LinePoint_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< LinePoint_obj > result = new LinePoint_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4],inArgs[5]);
	return result;}


LinePoint_obj::LinePoint_obj()
{
}

Dynamic LinePoint_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { return x; }
		if (HX_FIELD_EQ(inName,"y") ) { return y; }
		if (HX_FIELD_EQ(inName,"r") ) { return r; }
		if (HX_FIELD_EQ(inName,"g") ) { return g; }
		if (HX_FIELD_EQ(inName,"b") ) { return b; }
		if (HX_FIELD_EQ(inName,"a") ) { return a; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic LinePoint_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { x=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"y") ) { y=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"r") ) { r=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"g") ) { g=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"b") ) { b=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"a") ) { a=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void LinePoint_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("x"));
	outFields->push(HX_CSTRING("y"));
	outFields->push(HX_CSTRING("r"));
	outFields->push(HX_CSTRING("g"));
	outFields->push(HX_CSTRING("b"));
	outFields->push(HX_CSTRING("a"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(LinePoint_obj,x),HX_CSTRING("x")},
	{hx::fsFloat,(int)offsetof(LinePoint_obj,y),HX_CSTRING("y")},
	{hx::fsFloat,(int)offsetof(LinePoint_obj,r),HX_CSTRING("r")},
	{hx::fsFloat,(int)offsetof(LinePoint_obj,g),HX_CSTRING("g")},
	{hx::fsFloat,(int)offsetof(LinePoint_obj,b),HX_CSTRING("b")},
	{hx::fsFloat,(int)offsetof(LinePoint_obj,a),HX_CSTRING("a")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("x"),
	HX_CSTRING("y"),
	HX_CSTRING("r"),
	HX_CSTRING("g"),
	HX_CSTRING("b"),
	HX_CSTRING("a"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(LinePoint_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(LinePoint_obj::__mClass,"__mClass");
};

#endif

Class LinePoint_obj::__mClass;

void LinePoint_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d._Graphics.LinePoint"), hx::TCanCast< LinePoint_obj> ,sStaticFields,sMemberFields,
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

void LinePoint_obj::__boot()
{
}

} // end namespace h2d
} // end namespace _Graphics
