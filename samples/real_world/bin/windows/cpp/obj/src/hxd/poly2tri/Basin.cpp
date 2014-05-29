#include <hxcpp.h>

#ifndef INCLUDED_hxd_poly2tri_Basin
#include <hxd/poly2tri/Basin.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Node
#include <hxd/poly2tri/Node.h>
#endif
namespace hxd{
namespace poly2tri{

Void Basin_obj::__construct()
{
HX_STACK_FRAME("hxd.poly2tri.Basin","new",0xb4351bbc,"hxd.poly2tri.Basin.new","hxd/poly2tri/Basin.hx",13,0xacbe0714)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(13)
	this->width = (int)0;
}
;
	return null();
}

//Basin_obj::~Basin_obj() { }

Dynamic Basin_obj::__CreateEmpty() { return  new Basin_obj; }
hx::ObjectPtr< Basin_obj > Basin_obj::__new()
{  hx::ObjectPtr< Basin_obj > result = new Basin_obj();
	result->__construct();
	return result;}

Dynamic Basin_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Basin_obj > result = new Basin_obj();
	result->__construct();
	return result;}

Void Basin_obj::clear( ){
{
		HX_STACK_FRAME("hxd.poly2tri.Basin","clear",0xafab4be9,"hxd.poly2tri.Basin.clear","hxd/poly2tri/Basin.hx",17,0xacbe0714)
		HX_STACK_THIS(this)
		HX_STACK_LINE(19)
		this->left_node = null();
		HX_STACK_LINE(20)
		this->bottom_node = null();
		HX_STACK_LINE(21)
		this->right_node = null();
		HX_STACK_LINE(22)
		this->width = 0.0;
		HX_STACK_LINE(23)
		this->left_highest = false;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Basin_obj,clear,(void))


Basin_obj::Basin_obj()
{
}

void Basin_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Basin);
	HX_MARK_MEMBER_NAME(left_node,"left_node");
	HX_MARK_MEMBER_NAME(bottom_node,"bottom_node");
	HX_MARK_MEMBER_NAME(right_node,"right_node");
	HX_MARK_MEMBER_NAME(width,"width");
	HX_MARK_MEMBER_NAME(left_highest,"left_highest");
	HX_MARK_END_CLASS();
}

void Basin_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(left_node,"left_node");
	HX_VISIT_MEMBER_NAME(bottom_node,"bottom_node");
	HX_VISIT_MEMBER_NAME(right_node,"right_node");
	HX_VISIT_MEMBER_NAME(width,"width");
	HX_VISIT_MEMBER_NAME(left_highest,"left_highest");
}

Dynamic Basin_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"width") ) { return width; }
		if (HX_FIELD_EQ(inName,"clear") ) { return clear_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"left_node") ) { return left_node; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"right_node") ) { return right_node; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"bottom_node") ) { return bottom_node; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"left_highest") ) { return left_highest; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Basin_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"width") ) { width=inValue.Cast< Float >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"left_node") ) { left_node=inValue.Cast< ::hxd::poly2tri::Node >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"right_node") ) { right_node=inValue.Cast< ::hxd::poly2tri::Node >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"bottom_node") ) { bottom_node=inValue.Cast< ::hxd::poly2tri::Node >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"left_highest") ) { left_highest=inValue.Cast< bool >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Basin_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("left_node"));
	outFields->push(HX_CSTRING("bottom_node"));
	outFields->push(HX_CSTRING("right_node"));
	outFields->push(HX_CSTRING("width"));
	outFields->push(HX_CSTRING("left_highest"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::hxd::poly2tri::Node*/ ,(int)offsetof(Basin_obj,left_node),HX_CSTRING("left_node")},
	{hx::fsObject /*::hxd::poly2tri::Node*/ ,(int)offsetof(Basin_obj,bottom_node),HX_CSTRING("bottom_node")},
	{hx::fsObject /*::hxd::poly2tri::Node*/ ,(int)offsetof(Basin_obj,right_node),HX_CSTRING("right_node")},
	{hx::fsFloat,(int)offsetof(Basin_obj,width),HX_CSTRING("width")},
	{hx::fsBool,(int)offsetof(Basin_obj,left_highest),HX_CSTRING("left_highest")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("left_node"),
	HX_CSTRING("bottom_node"),
	HX_CSTRING("right_node"),
	HX_CSTRING("width"),
	HX_CSTRING("left_highest"),
	HX_CSTRING("clear"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Basin_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Basin_obj::__mClass,"__mClass");
};

#endif

Class Basin_obj::__mClass;

void Basin_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.poly2tri.Basin"), hx::TCanCast< Basin_obj> ,sStaticFields,sMemberFields,
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

void Basin_obj::__boot()
{
}

} // end namespace hxd
} // end namespace poly2tri
