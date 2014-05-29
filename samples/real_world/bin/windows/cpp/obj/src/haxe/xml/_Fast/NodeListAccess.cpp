#include <hxcpp.h>

#ifndef INCLUDED_List
#include <List.h>
#endif
#ifndef INCLUDED_Xml
#include <Xml.h>
#endif
#ifndef INCLUDED_haxe_xml_Fast
#include <haxe/xml/Fast.h>
#endif
#ifndef INCLUDED_haxe_xml__Fast_NodeListAccess
#include <haxe/xml/_Fast/NodeListAccess.h>
#endif
namespace haxe{
namespace xml{
namespace _Fast{

Void NodeListAccess_obj::__construct(::Xml x)
{
HX_STACK_FRAME("haxe.xml._Fast.NodeListAccess","new",0x22c8c708,"haxe.xml._Fast.NodeListAccess.new","D:\\Workspace\\motionTools\\haxe3\\std/haxe/xml/Fast.hx",97,0x9b86f7e0)
HX_STACK_THIS(this)
HX_STACK_ARG(x,"x")
{
	HX_STACK_LINE(97)
	this->__x = x;
}
;
	return null();
}

//NodeListAccess_obj::~NodeListAccess_obj() { }

Dynamic NodeListAccess_obj::__CreateEmpty() { return  new NodeListAccess_obj; }
hx::ObjectPtr< NodeListAccess_obj > NodeListAccess_obj::__new(::Xml x)
{  hx::ObjectPtr< NodeListAccess_obj > result = new NodeListAccess_obj();
	result->__construct(x);
	return result;}

Dynamic NodeListAccess_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< NodeListAccess_obj > result = new NodeListAccess_obj();
	result->__construct(inArgs[0]);
	return result;}

::List NodeListAccess_obj::resolve( ::String name){
	HX_STACK_FRAME("haxe.xml._Fast.NodeListAccess","resolve",0x21d97d94,"haxe.xml._Fast.NodeListAccess.resolve","D:\\Workspace\\motionTools\\haxe3\\std/haxe/xml/Fast.hx",100,0x9b86f7e0)
	HX_STACK_THIS(this)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(101)
	::List l = ::List_obj::__new();		HX_STACK_VAR(l,"l");
	HX_STACK_LINE(102)
	for(::cpp::FastIterator_obj< ::Xml > *__it = ::cpp::CreateFastIterator< ::Xml >(this->__x->elementsNamed(name));  __it->hasNext(); ){
		::Xml x = __it->next();
		{
			HX_STACK_LINE(103)
			::haxe::xml::Fast _g = ::haxe::xml::Fast_obj::__new(x);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(103)
			l->add(_g);
		}
;
	}
	HX_STACK_LINE(104)
	return l;
}


HX_DEFINE_DYNAMIC_FUNC1(NodeListAccess_obj,resolve,return )


NodeListAccess_obj::NodeListAccess_obj()
{
	HX_INIT_IMPLEMENT_DYNAMIC;
}

void NodeListAccess_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(NodeListAccess);
	HX_MARK_DYNAMIC;
	HX_MARK_MEMBER_NAME(__x,"__x");
	HX_MARK_END_CLASS();
}

void NodeListAccess_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_DYNAMIC;
	HX_VISIT_MEMBER_NAME(__x,"__x");
}

Dynamic NodeListAccess_obj::__Field(const ::String &inName,bool inCallProp)
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

Dynamic NodeListAccess_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"__x") ) { __x=inValue.Cast< ::Xml >(); return inValue; }
	}
	try { return super::__SetField(inName,inValue,inCallProp); }
	catch(Dynamic e) { HX_DYNAMIC_SET_FIELD(inName,inValue); }
	return inValue;
}

void NodeListAccess_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("__x"));
	HX_APPEND_DYNAMIC_FIELDS(outFields);
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::Xml*/ ,(int)offsetof(NodeListAccess_obj,__x),HX_CSTRING("__x")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("__x"),
	HX_CSTRING("resolve"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(NodeListAccess_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(NodeListAccess_obj::__mClass,"__mClass");
};

#endif

Class NodeListAccess_obj::__mClass;

void NodeListAccess_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.xml._Fast.NodeListAccess"), hx::TCanCast< NodeListAccess_obj> ,sStaticFields,sMemberFields,
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

void NodeListAccess_obj::__boot()
{
}

} // end namespace haxe
} // end namespace xml
} // end namespace _Fast
