#include <hxcpp.h>

#ifndef INCLUDED_Xml
#include <Xml.h>
#endif
#ifndef INCLUDED_XmlType
#include <XmlType.h>
#endif
#ifndef INCLUDED_haxe_xml__Fast_HasAttribAccess
#include <haxe/xml/_Fast/HasAttribAccess.h>
#endif
namespace haxe{
namespace xml{
namespace _Fast{

Void HasAttribAccess_obj::__construct(::Xml x)
{
HX_STACK_FRAME("haxe.xml._Fast.HasAttribAccess","new",0x4d025ce8,"haxe.xml._Fast.HasAttribAccess.new","D:\\Workspace\\motionTools\\haxe3\\std/haxe/xml/Fast.hx",67,0x9b86f7e0)
HX_STACK_THIS(this)
HX_STACK_ARG(x,"x")
{
	HX_STACK_LINE(67)
	this->__x = x;
}
;
	return null();
}

//HasAttribAccess_obj::~HasAttribAccess_obj() { }

Dynamic HasAttribAccess_obj::__CreateEmpty() { return  new HasAttribAccess_obj; }
hx::ObjectPtr< HasAttribAccess_obj > HasAttribAccess_obj::__new(::Xml x)
{  hx::ObjectPtr< HasAttribAccess_obj > result = new HasAttribAccess_obj();
	result->__construct(x);
	return result;}

Dynamic HasAttribAccess_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< HasAttribAccess_obj > result = new HasAttribAccess_obj();
	result->__construct(inArgs[0]);
	return result;}

bool HasAttribAccess_obj::resolve( ::String name){
	HX_STACK_FRAME("haxe.xml._Fast.HasAttribAccess","resolve",0x0ac38374,"haxe.xml._Fast.HasAttribAccess.resolve","D:\\Workspace\\motionTools\\haxe3\\std/haxe/xml/Fast.hx",70,0x9b86f7e0)
	HX_STACK_THIS(this)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(71)
	if (((this->__x->nodeType == ::Xml_obj::Document))){
		HX_STACK_LINE(72)
		HX_STACK_DO_THROW((HX_CSTRING("Cannot access document attribute ") + name));
	}
	HX_STACK_LINE(73)
	return this->__x->exists(name);
}


HX_DEFINE_DYNAMIC_FUNC1(HasAttribAccess_obj,resolve,return )


HasAttribAccess_obj::HasAttribAccess_obj()
{
	HX_INIT_IMPLEMENT_DYNAMIC;
}

void HasAttribAccess_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(HasAttribAccess);
	HX_MARK_DYNAMIC;
	HX_MARK_MEMBER_NAME(__x,"__x");
	HX_MARK_END_CLASS();
}

void HasAttribAccess_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_DYNAMIC;
	HX_VISIT_MEMBER_NAME(__x,"__x");
}

Dynamic HasAttribAccess_obj::__Field(const ::String &inName,bool inCallProp)
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

Dynamic HasAttribAccess_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"__x") ) { __x=inValue.Cast< ::Xml >(); return inValue; }
	}
	try { return super::__SetField(inName,inValue,inCallProp); }
	catch(Dynamic e) { HX_DYNAMIC_SET_FIELD(inName,inValue); }
	return inValue;
}

void HasAttribAccess_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("__x"));
	HX_APPEND_DYNAMIC_FIELDS(outFields);
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::Xml*/ ,(int)offsetof(HasAttribAccess_obj,__x),HX_CSTRING("__x")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("__x"),
	HX_CSTRING("resolve"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(HasAttribAccess_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(HasAttribAccess_obj::__mClass,"__mClass");
};

#endif

Class HasAttribAccess_obj::__mClass;

void HasAttribAccess_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.xml._Fast.HasAttribAccess"), hx::TCanCast< HasAttribAccess_obj> ,sStaticFields,sMemberFields,
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

void HasAttribAccess_obj::__boot()
{
}

} // end namespace haxe
} // end namespace xml
} // end namespace _Fast
