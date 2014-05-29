#include <hxcpp.h>

#ifndef INCLUDED_h2d_Kerning
#include <h2d/Kerning.h>
#endif
namespace h2d{

Void Kerning_obj::__construct(int c,int o)
{
HX_STACK_FRAME("h2d.Kerning","new",0x33f3318a,"h2d.Kerning.new","h2d/Font.hx",7,0x32d64c3a)
HX_STACK_THIS(this)
HX_STACK_ARG(c,"c")
HX_STACK_ARG(o,"o")
{
	HX_STACK_LINE(8)
	this->prevChar = c;
	HX_STACK_LINE(9)
	this->offset = o;
}
;
	return null();
}

//Kerning_obj::~Kerning_obj() { }

Dynamic Kerning_obj::__CreateEmpty() { return  new Kerning_obj; }
hx::ObjectPtr< Kerning_obj > Kerning_obj::__new(int c,int o)
{  hx::ObjectPtr< Kerning_obj > result = new Kerning_obj();
	result->__construct(c,o);
	return result;}

Dynamic Kerning_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Kerning_obj > result = new Kerning_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}


Kerning_obj::Kerning_obj()
{
}

void Kerning_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Kerning);
	HX_MARK_MEMBER_NAME(prevChar,"prevChar");
	HX_MARK_MEMBER_NAME(offset,"offset");
	HX_MARK_MEMBER_NAME(next,"next");
	HX_MARK_END_CLASS();
}

void Kerning_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(prevChar,"prevChar");
	HX_VISIT_MEMBER_NAME(offset,"offset");
	HX_VISIT_MEMBER_NAME(next,"next");
}

Dynamic Kerning_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"next") ) { return next; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"offset") ) { return offset; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"prevChar") ) { return prevChar; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Kerning_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"next") ) { next=inValue.Cast< ::h2d::Kerning >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"offset") ) { offset=inValue.Cast< int >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"prevChar") ) { prevChar=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Kerning_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("prevChar"));
	outFields->push(HX_CSTRING("offset"));
	outFields->push(HX_CSTRING("next"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(Kerning_obj,prevChar),HX_CSTRING("prevChar")},
	{hx::fsInt,(int)offsetof(Kerning_obj,offset),HX_CSTRING("offset")},
	{hx::fsObject /*::h2d::Kerning*/ ,(int)offsetof(Kerning_obj,next),HX_CSTRING("next")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("prevChar"),
	HX_CSTRING("offset"),
	HX_CSTRING("next"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Kerning_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Kerning_obj::__mClass,"__mClass");
};

#endif

Class Kerning_obj::__mClass;

void Kerning_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.Kerning"), hx::TCanCast< Kerning_obj> ,sStaticFields,sMemberFields,
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

void Kerning_obj::__boot()
{
}

} // end namespace h2d
