#include <hxcpp.h>

#ifndef INCLUDED_Xml
#include <Xml.h>
#endif
#ifndef INCLUDED_XmlType
#include <XmlType.h>
#endif
#ifndef INCLUDED_haxe_xml__Fast_AttribAccess
#include <haxe/xml/_Fast/AttribAccess.h>
#endif
namespace haxe{
namespace xml{
namespace _Fast{

Void AttribAccess_obj::__construct(::Xml x)
{
HX_STACK_FRAME("haxe.xml._Fast.AttribAccess","new",0x8109dad2,"haxe.xml._Fast.AttribAccess.new","D:\\Workspace\\motionTools\\haxe3\\std/haxe/xml/Fast.hx",48,0x9b86f7e0)
HX_STACK_THIS(this)
HX_STACK_ARG(x,"x")
{
	HX_STACK_LINE(48)
	this->__x = x;
}
;
	return null();
}

//AttribAccess_obj::~AttribAccess_obj() { }

Dynamic AttribAccess_obj::__CreateEmpty() { return  new AttribAccess_obj; }
hx::ObjectPtr< AttribAccess_obj > AttribAccess_obj::__new(::Xml x)
{  hx::ObjectPtr< AttribAccess_obj > result = new AttribAccess_obj();
	result->__construct(x);
	return result;}

Dynamic AttribAccess_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< AttribAccess_obj > result = new AttribAccess_obj();
	result->__construct(inArgs[0]);
	return result;}

::String AttribAccess_obj::resolve( ::String name){
	HX_STACK_FRAME("haxe.xml._Fast.AttribAccess","resolve",0x20913e5e,"haxe.xml._Fast.AttribAccess.resolve","D:\\Workspace\\motionTools\\haxe3\\std/haxe/xml/Fast.hx",51,0x9b86f7e0)
	HX_STACK_THIS(this)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(52)
	if (((this->__x->nodeType == ::Xml_obj::Document))){
		HX_STACK_LINE(53)
		HX_STACK_DO_THROW((HX_CSTRING("Cannot access document attribute ") + name));
	}
	HX_STACK_LINE(54)
	::String v = this->__x->get(name);		HX_STACK_VAR(v,"v");
	HX_STACK_LINE(55)
	if (((v == null()))){
		HX_STACK_LINE(56)
		::String _g = this->__x->get_nodeName();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(56)
		::String _g1 = (_g + HX_CSTRING(" is missing attribute "));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(56)
		HX_STACK_DO_THROW((_g1 + name));
	}
	HX_STACK_LINE(57)
	return v;
}


HX_DEFINE_DYNAMIC_FUNC1(AttribAccess_obj,resolve,return )


AttribAccess_obj::AttribAccess_obj()
{
	HX_INIT_IMPLEMENT_DYNAMIC;
}

void AttribAccess_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(AttribAccess);
	HX_MARK_DYNAMIC;
	HX_MARK_MEMBER_NAME(__x,"__x");
	HX_MARK_END_CLASS();
}

void AttribAccess_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_DYNAMIC;
	HX_VISIT_MEMBER_NAME(__x,"__x");
}

Dynamic AttribAccess_obj::__Field(const ::String &inName,bool inCallProp)
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

Dynamic AttribAccess_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"__x") ) { __x=inValue.Cast< ::Xml >(); return inValue; }
	}
	try { return super::__SetField(inName,inValue,inCallProp); }
	catch(Dynamic e) { HX_DYNAMIC_SET_FIELD(inName,inValue); }
	return inValue;
}

void AttribAccess_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("__x"));
	HX_APPEND_DYNAMIC_FIELDS(outFields);
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::Xml*/ ,(int)offsetof(AttribAccess_obj,__x),HX_CSTRING("__x")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("__x"),
	HX_CSTRING("resolve"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(AttribAccess_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(AttribAccess_obj::__mClass,"__mClass");
};

#endif

Class AttribAccess_obj::__mClass;

void AttribAccess_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.xml._Fast.AttribAccess"), hx::TCanCast< AttribAccess_obj> ,sStaticFields,sMemberFields,
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

void AttribAccess_obj::__boot()
{
}

} // end namespace haxe
} // end namespace xml
} // end namespace _Fast
