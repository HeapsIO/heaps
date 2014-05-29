#include <hxcpp.h>

#ifndef INCLUDED_h2d_Tools
#include <h2d/Tools.h>
#endif
#ifndef INCLUDED_h2d__Tools_CoreObjects
#include <h2d/_Tools/CoreObjects.h>
#endif
#ifndef INCLUDED_h3d_impl_BigBuffer
#include <h3d/impl/BigBuffer.h>
#endif
#ifndef INCLUDED_h3d_impl_Buffer
#include <h3d/impl/Buffer.h>
#endif
namespace h2d{

Void Tools_obj::__construct()
{
	return null();
}

//Tools_obj::~Tools_obj() { }

Dynamic Tools_obj::__CreateEmpty() { return  new Tools_obj; }
hx::ObjectPtr< Tools_obj > Tools_obj::__new()
{  hx::ObjectPtr< Tools_obj > result = new Tools_obj();
	result->__construct();
	return result;}

Dynamic Tools_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Tools_obj > result = new Tools_obj();
	result->__construct();
	return result;}

::h2d::_Tools::CoreObjects Tools_obj::CORE;

::h2d::_Tools::CoreObjects Tools_obj::getCoreObjects( ){
	HX_STACK_FRAME("h2d.Tools","getCoreObjects",0x6db7ffe6,"h2d.Tools.getCoreObjects","h2d/Tools.hx",59,0x62050538)
	HX_STACK_LINE(60)
	::h2d::_Tools::CoreObjects c = ::h2d::Tools_obj::CORE;		HX_STACK_VAR(c,"c");
	HX_STACK_LINE(61)
	if (((c == null()))){
		HX_STACK_LINE(62)
		::h2d::_Tools::CoreObjects _g = ::h2d::_Tools::CoreObjects_obj::__new();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(62)
		c = _g;
		HX_STACK_LINE(63)
		::h2d::Tools_obj::CORE = c;
	}
	HX_STACK_LINE(65)
	return c;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Tools_obj,getCoreObjects,return )

Void Tools_obj::checkCoreObjects( ){
{
		HX_STACK_FRAME("h2d.Tools","checkCoreObjects",0xfb6ec8b4,"h2d.Tools.checkCoreObjects","h2d/Tools.hx",70,0x62050538)
		HX_STACK_LINE(71)
		::h2d::_Tools::CoreObjects c = ::h2d::Tools_obj::CORE;		HX_STACK_VAR(c,"c");
		HX_STACK_LINE(72)
		if (((c == null()))){
			HX_STACK_LINE(72)
			return null();
		}
		HX_STACK_LINE(74)
		if ((c->planBuffer->b->isDisposed())){
			HX_STACK_LINE(75)
			::h2d::Tools_obj::CORE = null();
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Tools_obj,checkCoreObjects,(void))


Tools_obj::Tools_obj()
{
}

Dynamic Tools_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"CORE") ) { return CORE; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"getCoreObjects") ) { return getCoreObjects_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"checkCoreObjects") ) { return checkCoreObjects_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Tools_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"CORE") ) { CORE=inValue.Cast< ::h2d::_Tools::CoreObjects >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Tools_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("CORE"),
	HX_CSTRING("getCoreObjects"),
	HX_CSTRING("checkCoreObjects"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Tools_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Tools_obj::CORE,"CORE");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Tools_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Tools_obj::CORE,"CORE");
};

#endif

Class Tools_obj::__mClass;

void Tools_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.Tools"), hx::TCanCast< Tools_obj> ,sStaticFields,sMemberFields,
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

void Tools_obj::__boot()
{
	CORE= null();
}

} // end namespace h2d
