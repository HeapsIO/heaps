#include <hxcpp.h>

#ifndef INCLUDED_flash_display_GraphicsPathWinding
#include <flash/display/GraphicsPathWinding.h>
#endif
namespace flash{
namespace display{

Void GraphicsPathWinding_obj::__construct()
{
	return null();
}

//GraphicsPathWinding_obj::~GraphicsPathWinding_obj() { }

Dynamic GraphicsPathWinding_obj::__CreateEmpty() { return  new GraphicsPathWinding_obj; }
hx::ObjectPtr< GraphicsPathWinding_obj > GraphicsPathWinding_obj::__new()
{  hx::ObjectPtr< GraphicsPathWinding_obj > result = new GraphicsPathWinding_obj();
	result->__construct();
	return result;}

Dynamic GraphicsPathWinding_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< GraphicsPathWinding_obj > result = new GraphicsPathWinding_obj();
	result->__construct();
	return result;}

::String GraphicsPathWinding_obj::EVEN_ODD;

::String GraphicsPathWinding_obj::NON_ZERO;


GraphicsPathWinding_obj::GraphicsPathWinding_obj()
{
}

Dynamic GraphicsPathWinding_obj::__Field(const ::String &inName,bool inCallProp)
{
	return super::__Field(inName,inCallProp);
}

Dynamic GraphicsPathWinding_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void GraphicsPathWinding_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("EVEN_ODD"),
	HX_CSTRING("NON_ZERO"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(GraphicsPathWinding_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(GraphicsPathWinding_obj::EVEN_ODD,"EVEN_ODD");
	HX_MARK_MEMBER_NAME(GraphicsPathWinding_obj::NON_ZERO,"NON_ZERO");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(GraphicsPathWinding_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(GraphicsPathWinding_obj::EVEN_ODD,"EVEN_ODD");
	HX_VISIT_MEMBER_NAME(GraphicsPathWinding_obj::NON_ZERO,"NON_ZERO");
};

#endif

Class GraphicsPathWinding_obj::__mClass;

void GraphicsPathWinding_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.display.GraphicsPathWinding"), hx::TCanCast< GraphicsPathWinding_obj> ,sStaticFields,sMemberFields,
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

void GraphicsPathWinding_obj::__boot()
{
	EVEN_ODD= HX_CSTRING("evenOdd");
	NON_ZERO= HX_CSTRING("nonZero");
}

} // end namespace flash
} // end namespace display
