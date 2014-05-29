#include <hxcpp.h>

#ifndef INCLUDED_flash_system_ApplicationDomain
#include <flash/system/ApplicationDomain.h>
#endif
#ifndef INCLUDED_flash_system_LoaderContext
#include <flash/system/LoaderContext.h>
#endif
#ifndef INCLUDED_flash_system_SecurityDomain
#include <flash/system/SecurityDomain.h>
#endif
namespace flash{
namespace system{

Void LoaderContext_obj::__construct(hx::Null< bool >  __o_checkPolicyFile,::flash::system::ApplicationDomain applicationDomain,::flash::system::SecurityDomain securityDomain)
{
HX_STACK_FRAME("flash.system.LoaderContext","new",0x89e2462d,"flash.system.LoaderContext.new","flash/system/LoaderContext.hx",14,0x1b251003)
HX_STACK_THIS(this)
HX_STACK_ARG(__o_checkPolicyFile,"checkPolicyFile")
HX_STACK_ARG(applicationDomain,"applicationDomain")
HX_STACK_ARG(securityDomain,"securityDomain")
bool checkPolicyFile = __o_checkPolicyFile.Default(false);
{
	HX_STACK_LINE(16)
	this->checkPolicyFile = checkPolicyFile;
	HX_STACK_LINE(17)
	this->securityDomain = securityDomain;
	HX_STACK_LINE(19)
	if (((applicationDomain != null()))){
		HX_STACK_LINE(21)
		this->applicationDomain = applicationDomain;
	}
	else{
		HX_STACK_LINE(25)
		this->applicationDomain = ::flash::system::ApplicationDomain_obj::currentDomain;
	}
}
;
	return null();
}

//LoaderContext_obj::~LoaderContext_obj() { }

Dynamic LoaderContext_obj::__CreateEmpty() { return  new LoaderContext_obj; }
hx::ObjectPtr< LoaderContext_obj > LoaderContext_obj::__new(hx::Null< bool >  __o_checkPolicyFile,::flash::system::ApplicationDomain applicationDomain,::flash::system::SecurityDomain securityDomain)
{  hx::ObjectPtr< LoaderContext_obj > result = new LoaderContext_obj();
	result->__construct(__o_checkPolicyFile,applicationDomain,securityDomain);
	return result;}

Dynamic LoaderContext_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< LoaderContext_obj > result = new LoaderContext_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}


LoaderContext_obj::LoaderContext_obj()
{
}

void LoaderContext_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(LoaderContext);
	HX_MARK_MEMBER_NAME(allowCodeImport,"allowCodeImport");
	HX_MARK_MEMBER_NAME(allowLoadBytesCodeExecution,"allowLoadBytesCodeExecution");
	HX_MARK_MEMBER_NAME(applicationDomain,"applicationDomain");
	HX_MARK_MEMBER_NAME(checkPolicyFile,"checkPolicyFile");
	HX_MARK_MEMBER_NAME(securityDomain,"securityDomain");
	HX_MARK_END_CLASS();
}

void LoaderContext_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(allowCodeImport,"allowCodeImport");
	HX_VISIT_MEMBER_NAME(allowLoadBytesCodeExecution,"allowLoadBytesCodeExecution");
	HX_VISIT_MEMBER_NAME(applicationDomain,"applicationDomain");
	HX_VISIT_MEMBER_NAME(checkPolicyFile,"checkPolicyFile");
	HX_VISIT_MEMBER_NAME(securityDomain,"securityDomain");
}

Dynamic LoaderContext_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 14:
		if (HX_FIELD_EQ(inName,"securityDomain") ) { return securityDomain; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"allowCodeImport") ) { return allowCodeImport; }
		if (HX_FIELD_EQ(inName,"checkPolicyFile") ) { return checkPolicyFile; }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"applicationDomain") ) { return applicationDomain; }
		break;
	case 27:
		if (HX_FIELD_EQ(inName,"allowLoadBytesCodeExecution") ) { return allowLoadBytesCodeExecution; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic LoaderContext_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 14:
		if (HX_FIELD_EQ(inName,"securityDomain") ) { securityDomain=inValue.Cast< ::flash::system::SecurityDomain >(); return inValue; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"allowCodeImport") ) { allowCodeImport=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"checkPolicyFile") ) { checkPolicyFile=inValue.Cast< bool >(); return inValue; }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"applicationDomain") ) { applicationDomain=inValue.Cast< ::flash::system::ApplicationDomain >(); return inValue; }
		break;
	case 27:
		if (HX_FIELD_EQ(inName,"allowLoadBytesCodeExecution") ) { allowLoadBytesCodeExecution=inValue.Cast< bool >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void LoaderContext_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("allowCodeImport"));
	outFields->push(HX_CSTRING("allowLoadBytesCodeExecution"));
	outFields->push(HX_CSTRING("applicationDomain"));
	outFields->push(HX_CSTRING("checkPolicyFile"));
	outFields->push(HX_CSTRING("securityDomain"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsBool,(int)offsetof(LoaderContext_obj,allowCodeImport),HX_CSTRING("allowCodeImport")},
	{hx::fsBool,(int)offsetof(LoaderContext_obj,allowLoadBytesCodeExecution),HX_CSTRING("allowLoadBytesCodeExecution")},
	{hx::fsObject /*::flash::system::ApplicationDomain*/ ,(int)offsetof(LoaderContext_obj,applicationDomain),HX_CSTRING("applicationDomain")},
	{hx::fsBool,(int)offsetof(LoaderContext_obj,checkPolicyFile),HX_CSTRING("checkPolicyFile")},
	{hx::fsObject /*::flash::system::SecurityDomain*/ ,(int)offsetof(LoaderContext_obj,securityDomain),HX_CSTRING("securityDomain")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("allowCodeImport"),
	HX_CSTRING("allowLoadBytesCodeExecution"),
	HX_CSTRING("applicationDomain"),
	HX_CSTRING("checkPolicyFile"),
	HX_CSTRING("securityDomain"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(LoaderContext_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(LoaderContext_obj::__mClass,"__mClass");
};

#endif

Class LoaderContext_obj::__mClass;

void LoaderContext_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.system.LoaderContext"), hx::TCanCast< LoaderContext_obj> ,sStaticFields,sMemberFields,
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

void LoaderContext_obj::__boot()
{
}

} // end namespace flash
} // end namespace system
