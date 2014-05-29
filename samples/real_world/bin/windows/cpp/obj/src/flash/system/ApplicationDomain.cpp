#include <hxcpp.h>

#ifndef INCLUDED_Type
#include <Type.h>
#endif
#ifndef INCLUDED_flash_system_ApplicationDomain
#include <flash/system/ApplicationDomain.h>
#endif
namespace flash{
namespace system{

Void ApplicationDomain_obj::__construct(::flash::system::ApplicationDomain parentDomain)
{
HX_STACK_FRAME("flash.system.ApplicationDomain","new",0x13282c45,"flash.system.ApplicationDomain.new","flash/system/ApplicationDomain.hx",14,0xa20b04eb)
HX_STACK_THIS(this)
HX_STACK_ARG(parentDomain,"parentDomain")
{
	HX_STACK_LINE(14)
	if (((parentDomain != null()))){
		HX_STACK_LINE(16)
		this->parentDomain = parentDomain;
	}
	else{
		HX_STACK_LINE(20)
		this->parentDomain = ::flash::system::ApplicationDomain_obj::currentDomain;
	}
}
;
	return null();
}

//ApplicationDomain_obj::~ApplicationDomain_obj() { }

Dynamic ApplicationDomain_obj::__CreateEmpty() { return  new ApplicationDomain_obj; }
hx::ObjectPtr< ApplicationDomain_obj > ApplicationDomain_obj::__new(::flash::system::ApplicationDomain parentDomain)
{  hx::ObjectPtr< ApplicationDomain_obj > result = new ApplicationDomain_obj();
	result->__construct(parentDomain);
	return result;}

Dynamic ApplicationDomain_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< ApplicationDomain_obj > result = new ApplicationDomain_obj();
	result->__construct(inArgs[0]);
	return result;}

Dynamic ApplicationDomain_obj::getDefinition( ::String name){
	HX_STACK_FRAME("flash.system.ApplicationDomain","getDefinition",0x036a3dee,"flash.system.ApplicationDomain.getDefinition","flash/system/ApplicationDomain.hx",29,0xa20b04eb)
	HX_STACK_THIS(this)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(29)
	return ::Type_obj::resolveClass(name);
}


HX_DEFINE_DYNAMIC_FUNC1(ApplicationDomain_obj,getDefinition,return )

bool ApplicationDomain_obj::hasDefinition( ::String name){
	HX_STACK_FRAME("flash.system.ApplicationDomain","hasDefinition",0xc14e99b2,"flash.system.ApplicationDomain.hasDefinition","flash/system/ApplicationDomain.hx",34,0xa20b04eb)
	HX_STACK_THIS(this)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(36)
	::Class _g = ::Type_obj::resolveClass(name);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(36)
	return (_g != null());
}


HX_DEFINE_DYNAMIC_FUNC1(ApplicationDomain_obj,hasDefinition,return )

::flash::system::ApplicationDomain ApplicationDomain_obj::currentDomain;


ApplicationDomain_obj::ApplicationDomain_obj()
{
}

void ApplicationDomain_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(ApplicationDomain);
	HX_MARK_MEMBER_NAME(parentDomain,"parentDomain");
	HX_MARK_END_CLASS();
}

void ApplicationDomain_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(parentDomain,"parentDomain");
}

Dynamic ApplicationDomain_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 12:
		if (HX_FIELD_EQ(inName,"parentDomain") ) { return parentDomain; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"currentDomain") ) { return currentDomain; }
		if (HX_FIELD_EQ(inName,"getDefinition") ) { return getDefinition_dyn(); }
		if (HX_FIELD_EQ(inName,"hasDefinition") ) { return hasDefinition_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic ApplicationDomain_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 12:
		if (HX_FIELD_EQ(inName,"parentDomain") ) { parentDomain=inValue.Cast< ::flash::system::ApplicationDomain >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"currentDomain") ) { currentDomain=inValue.Cast< ::flash::system::ApplicationDomain >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void ApplicationDomain_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("parentDomain"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("currentDomain"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::flash::system::ApplicationDomain*/ ,(int)offsetof(ApplicationDomain_obj,parentDomain),HX_CSTRING("parentDomain")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("parentDomain"),
	HX_CSTRING("getDefinition"),
	HX_CSTRING("hasDefinition"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(ApplicationDomain_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(ApplicationDomain_obj::currentDomain,"currentDomain");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(ApplicationDomain_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(ApplicationDomain_obj::currentDomain,"currentDomain");
};

#endif

Class ApplicationDomain_obj::__mClass;

void ApplicationDomain_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.system.ApplicationDomain"), hx::TCanCast< ApplicationDomain_obj> ,sStaticFields,sMemberFields,
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

void ApplicationDomain_obj::__boot()
{
	currentDomain= ::flash::system::ApplicationDomain_obj::__new(null());
}

} // end namespace flash
} // end namespace system
