#include <hxcpp.h>

#ifndef INCLUDED_Xml
#include <Xml.h>
#endif
#ifndef INCLUDED_XmlType
#include <XmlType.h>
#endif
#ifndef INCLUDED_haxe_xml_Fast
#include <haxe/xml/Fast.h>
#endif
#ifndef INCLUDED_haxe_xml__Fast_NodeAccess
#include <haxe/xml/_Fast/NodeAccess.h>
#endif
namespace haxe{
namespace xml{
namespace _Fast{

Void NodeAccess_obj::__construct(::Xml x)
{
HX_STACK_FRAME("haxe.xml._Fast.NodeAccess","new",0xde09fb0a,"haxe.xml._Fast.NodeAccess.new","D:\\Workspace\\motionTools\\haxe3\\std/haxe/xml/Fast.hx",29,0x9b86f7e0)
HX_STACK_THIS(this)
HX_STACK_ARG(x,"x")
{
	HX_STACK_LINE(29)
	this->__x = x;
}
;
	return null();
}

//NodeAccess_obj::~NodeAccess_obj() { }

Dynamic NodeAccess_obj::__CreateEmpty() { return  new NodeAccess_obj; }
hx::ObjectPtr< NodeAccess_obj > NodeAccess_obj::__new(::Xml x)
{  hx::ObjectPtr< NodeAccess_obj > result = new NodeAccess_obj();
	result->__construct(x);
	return result;}

Dynamic NodeAccess_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< NodeAccess_obj > result = new NodeAccess_obj();
	result->__construct(inArgs[0]);
	return result;}

::haxe::xml::Fast NodeAccess_obj::resolve( ::String name){
	HX_STACK_FRAME("haxe.xml._Fast.NodeAccess","resolve",0x0e91da96,"haxe.xml._Fast.NodeAccess.resolve","D:\\Workspace\\motionTools\\haxe3\\std/haxe/xml/Fast.hx",32,0x9b86f7e0)
	HX_STACK_THIS(this)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(33)
	::Xml x = this->__x->elementsNamed(name)->__Field(HX_CSTRING("next"),true)();		HX_STACK_VAR(x,"x");
	HX_STACK_LINE(34)
	if (((x == null()))){
		HX_STACK_LINE(35)
		::String xname;		HX_STACK_VAR(xname,"xname");
		HX_STACK_LINE(35)
		if (((this->__x->nodeType == ::Xml_obj::Document))){
			HX_STACK_LINE(35)
			xname = HX_CSTRING("Document");
		}
		else{
			HX_STACK_LINE(35)
			xname = this->__x->get_nodeName();
		}
		HX_STACK_LINE(36)
		HX_STACK_DO_THROW(((xname + HX_CSTRING(" is missing element ")) + name));
	}
	HX_STACK_LINE(38)
	return ::haxe::xml::Fast_obj::__new(x);
}


HX_DEFINE_DYNAMIC_FUNC1(NodeAccess_obj,resolve,return )


NodeAccess_obj::NodeAccess_obj()
{
	HX_INIT_IMPLEMENT_DYNAMIC;
}

void NodeAccess_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(NodeAccess);
	HX_MARK_DYNAMIC;
	HX_MARK_MEMBER_NAME(__x,"__x");
	HX_MARK_END_CLASS();
}

void NodeAccess_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_DYNAMIC;
	HX_VISIT_MEMBER_NAME(__x,"__x");
}

Dynamic NodeAccess_obj::__Field(const ::String &inName,bool inCallProp)
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

Dynamic NodeAccess_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"__x") ) { __x=inValue.Cast< ::Xml >(); return inValue; }
	}
	try { return super::__SetField(inName,inValue,inCallProp); }
	catch(Dynamic e) { HX_DYNAMIC_SET_FIELD(inName,inValue); }
	return inValue;
}

void NodeAccess_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("__x"));
	HX_APPEND_DYNAMIC_FIELDS(outFields);
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::Xml*/ ,(int)offsetof(NodeAccess_obj,__x),HX_CSTRING("__x")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("__x"),
	HX_CSTRING("resolve"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(NodeAccess_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(NodeAccess_obj::__mClass,"__mClass");
};

#endif

Class NodeAccess_obj::__mClass;

void NodeAccess_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.xml._Fast.NodeAccess"), hx::TCanCast< NodeAccess_obj> ,sStaticFields,sMemberFields,
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

void NodeAccess_obj::__boot()
{
}

} // end namespace haxe
} // end namespace xml
} // end namespace _Fast
