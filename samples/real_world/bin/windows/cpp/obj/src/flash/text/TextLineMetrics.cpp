#include <hxcpp.h>

#ifndef INCLUDED_flash_text_TextLineMetrics
#include <flash/text/TextLineMetrics.h>
#endif
namespace flash{
namespace text{

Void TextLineMetrics_obj::__construct(hx::Null< Float >  __o_x,hx::Null< Float >  __o_width,hx::Null< Float >  __o_height,hx::Null< Float >  __o_ascent,hx::Null< Float >  __o_descent,hx::Null< Float >  __o_leading)
{
HX_STACK_FRAME("flash.text.TextLineMetrics","new",0xc75fef11,"flash.text.TextLineMetrics.new","flash/text/TextLineMetrics.hx",15,0x198051df)
HX_STACK_THIS(this)
HX_STACK_ARG(__o_x,"x")
HX_STACK_ARG(__o_width,"width")
HX_STACK_ARG(__o_height,"height")
HX_STACK_ARG(__o_ascent,"ascent")
HX_STACK_ARG(__o_descent,"descent")
HX_STACK_ARG(__o_leading,"leading")
Float x = __o_x.Default(0);
Float width = __o_width.Default(0);
Float height = __o_height.Default(0);
Float ascent = __o_ascent.Default(0);
Float descent = __o_descent.Default(0);
Float leading = __o_leading.Default(0);
{
	HX_STACK_LINE(17)
	this->x = x;
	HX_STACK_LINE(18)
	this->width = width;
	HX_STACK_LINE(19)
	this->height = height;
	HX_STACK_LINE(20)
	this->ascent = ascent;
	HX_STACK_LINE(21)
	this->descent = descent;
	HX_STACK_LINE(22)
	this->leading = leading;
}
;
	return null();
}

//TextLineMetrics_obj::~TextLineMetrics_obj() { }

Dynamic TextLineMetrics_obj::__CreateEmpty() { return  new TextLineMetrics_obj; }
hx::ObjectPtr< TextLineMetrics_obj > TextLineMetrics_obj::__new(hx::Null< Float >  __o_x,hx::Null< Float >  __o_width,hx::Null< Float >  __o_height,hx::Null< Float >  __o_ascent,hx::Null< Float >  __o_descent,hx::Null< Float >  __o_leading)
{  hx::ObjectPtr< TextLineMetrics_obj > result = new TextLineMetrics_obj();
	result->__construct(__o_x,__o_width,__o_height,__o_ascent,__o_descent,__o_leading);
	return result;}

Dynamic TextLineMetrics_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< TextLineMetrics_obj > result = new TextLineMetrics_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4],inArgs[5]);
	return result;}


TextLineMetrics_obj::TextLineMetrics_obj()
{
}

Dynamic TextLineMetrics_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { return x; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"width") ) { return width; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"ascent") ) { return ascent; }
		if (HX_FIELD_EQ(inName,"height") ) { return height; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"descent") ) { return descent; }
		if (HX_FIELD_EQ(inName,"leading") ) { return leading; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic TextLineMetrics_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { x=inValue.Cast< Float >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"width") ) { width=inValue.Cast< Float >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"ascent") ) { ascent=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"height") ) { height=inValue.Cast< Float >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"descent") ) { descent=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"leading") ) { leading=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void TextLineMetrics_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("ascent"));
	outFields->push(HX_CSTRING("descent"));
	outFields->push(HX_CSTRING("height"));
	outFields->push(HX_CSTRING("leading"));
	outFields->push(HX_CSTRING("width"));
	outFields->push(HX_CSTRING("x"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(TextLineMetrics_obj,ascent),HX_CSTRING("ascent")},
	{hx::fsFloat,(int)offsetof(TextLineMetrics_obj,descent),HX_CSTRING("descent")},
	{hx::fsFloat,(int)offsetof(TextLineMetrics_obj,height),HX_CSTRING("height")},
	{hx::fsFloat,(int)offsetof(TextLineMetrics_obj,leading),HX_CSTRING("leading")},
	{hx::fsFloat,(int)offsetof(TextLineMetrics_obj,width),HX_CSTRING("width")},
	{hx::fsFloat,(int)offsetof(TextLineMetrics_obj,x),HX_CSTRING("x")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("ascent"),
	HX_CSTRING("descent"),
	HX_CSTRING("height"),
	HX_CSTRING("leading"),
	HX_CSTRING("width"),
	HX_CSTRING("x"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(TextLineMetrics_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(TextLineMetrics_obj::__mClass,"__mClass");
};

#endif

Class TextLineMetrics_obj::__mClass;

void TextLineMetrics_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.text.TextLineMetrics"), hx::TCanCast< TextLineMetrics_obj> ,sStaticFields,sMemberFields,
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

void TextLineMetrics_obj::__boot()
{
}

} // end namespace flash
} // end namespace text
