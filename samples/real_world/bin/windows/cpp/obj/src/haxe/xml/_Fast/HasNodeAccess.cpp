#include <hxcpp.h>

#ifndef INCLUDED_Xml
#include <Xml.h>
#endif
#ifndef INCLUDED_haxe_xml__Fast_HasNodeAccess
#include <haxe/xml/_Fast/HasNodeAccess.h>
#endif
namespace haxe{
namespace xml{
namespace _Fast{

Void HasNodeAccess_obj::__construct(::Xml x)
{
HX_STACK_FRAME("haxe.xml._Fast.HasNodeAccess","new",0xd184aba0,"haxe.xml._Fast.HasNodeAccess.new","D:\\Workspace\\motionTools\\haxe3\\std/haxe/xml/Fast.hx",83,0x9b86f7e0)
HX_STACK_THIS(this)
HX_STACK_ARG(x,"x")
{
	HX_STACK_LINE(83)
	this->__x = x;
}
;
	return null();
}

//HasNodeAccess_obj::~HasNodeAccess_obj() { }

Dynamic HasNodeAccess_obj::__CreateEmpty() { return  new HasNodeAccess_obj; }
hx::ObjectPtr< HasNodeAccess_obj > HasNodeAccess_obj::__new(::Xml x)
{  hx::ObjectPtr< HasNodeAccess_obj > result = new HasNodeAccess_obj();
	result->__construct(x);
	return result;}

Dynamic HasNodeAccess_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< HasNodeAccess_obj > result = new HasNodeAccess_obj();
	result->__construct(inArgs[0]);
	return result;}

bool HasNodeAccess_obj::resolve( ::String name){
	HX_STACK_FRAME("haxe.xml._Fast.HasNodeAccess","resolve",0x2b3f8e2c,"haxe.xml._Fast.HasNodeAccess.resolve","D:\\Workspace\\motionTools\\haxe3\\std/haxe/xml/Fast.hx",87,0x9b86f7e0)
	HX_STACK_THIS(this)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(87)
	return this->__x->elementsNamed(name)->__Field(HX_CSTRING("hasNext"),true)();
}


HX_DEFINE_DYNAMIC_FUNC1(HasNodeAccess_obj,resolve,return )


HasNodeAccess_obj::HasNodeAccess_obj()
{
	HX_INIT_IMPLEMENT_DYNAMIC;
}

void HasNodeAccess_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(HasNodeAccess);
	HX_MARK_DYNAMIC;
	HX_MARK_MEMBER_NAME(__x,"__x");
	HX_MARK_END_CLASS();
}

void HasNodeAccess_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_DYNAMIC;
	HX_VISIT_MEMBER_NAME(__x,"__x");
}

Dynamic HasNodeAccess_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"__x") ) { return __x; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"resolve") ) { return resolve_dyn(); }
	}
	HX_CHECK_DYNAMIC_GET_FIELD(inName);
	return super::__Field(inName,inCallProp);
}

Dynamic HasNodeAccess_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"__x") ) { __x=inValue.Cast< ::Xml >(); return inValue; }
	}
	try { return super::__SetField(inName,inValue,inCallProp); }
	catch(Dynamic e) { HX_DYNAMIC_SET_FIELD(inName,inValue); }
	return inValue;
}

void HasNodeAccess_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("__x"));
	HX_APPEND_DYNAMIC_FIELDS(outFields);
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::Xml*/ ,(int)offsetof(HasNodeAccess_obj,__x),HX_CSTRING("__x")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("__x"),
	HX_CSTRING("resolve"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(HasNodeAccess_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(HasNodeAccess_obj::__mClass,"__mClass");
};

#endif

Class HasNodeAccess_obj::__mClass;

void HasNodeAccess_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.xml._Fast.HasNodeAccess"), hx::TCanCast< HasNodeAccess_obj> ,sStaticFields,sMemberFields,
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

void HasNodeAccess_obj::__boot()
{
}

} // end namespace haxe
} // end namespace xml
} // end namespace _Fast
