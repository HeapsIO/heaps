#include <hxcpp.h>

#ifndef INCLUDED_hxd_impl_ArrayIterator
#include <hxd/impl/ArrayIterator.h>
#endif
namespace hxd{
namespace impl{

Void ArrayIterator_obj::__construct(Dynamic a)
{
HX_STACK_FRAME("hxd.impl.ArrayIterator","new",0x791bc1c5,"hxd.impl.ArrayIterator.new","hxd/impl/ArrayIterator.hx",7,0x093c79ab)
HX_STACK_THIS(this)
HX_STACK_ARG(a,"a")
{
	HX_STACK_LINE(8)
	this->i = (int)0;
	HX_STACK_LINE(9)
	this->a = a;
	HX_STACK_LINE(10)
	this->l = this->a->__Field(HX_CSTRING("length"),true);
}
;
	return null();
}

//ArrayIterator_obj::~ArrayIterator_obj() { }

Dynamic ArrayIterator_obj::__CreateEmpty() { return  new ArrayIterator_obj; }
hx::ObjectPtr< ArrayIterator_obj > ArrayIterator_obj::__new(Dynamic a)
{  hx::ObjectPtr< ArrayIterator_obj > result = new ArrayIterator_obj();
	result->__construct(a);
	return result;}

Dynamic ArrayIterator_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< ArrayIterator_obj > result = new ArrayIterator_obj();
	result->__construct(inArgs[0]);
	return result;}

bool ArrayIterator_obj::hasNext( ){
	HX_STACK_FRAME("hxd.impl.ArrayIterator","hasNext",0xb9d3ad52,"hxd.impl.ArrayIterator.hasNext","hxd/impl/ArrayIterator.hx",13,0x093c79ab)
	HX_STACK_THIS(this)
	HX_STACK_LINE(13)
	return (this->i < this->l);
}


HX_DEFINE_DYNAMIC_FUNC0(ArrayIterator_obj,hasNext,return )

Dynamic ArrayIterator_obj::next( ){
	HX_STACK_FRAME("hxd.impl.ArrayIterator","next",0x7f2dcbee,"hxd.impl.ArrayIterator.next","hxd/impl/ArrayIterator.hx",15,0x093c79ab)
	HX_STACK_THIS(this)
	HX_STACK_LINE(16)
	int _g = (this->i)++;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(16)
	return this->a->__GetItem(_g);
}


HX_DEFINE_DYNAMIC_FUNC0(ArrayIterator_obj,next,return )


ArrayIterator_obj::ArrayIterator_obj()
{
}

void ArrayIterator_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(ArrayIterator);
	HX_MARK_MEMBER_NAME(i,"i");
	HX_MARK_MEMBER_NAME(l,"l");
	HX_MARK_MEMBER_NAME(a,"a");
	HX_MARK_END_CLASS();
}

void ArrayIterator_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(i,"i");
	HX_VISIT_MEMBER_NAME(l,"l");
	HX_VISIT_MEMBER_NAME(a,"a");
}

Dynamic ArrayIterator_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"i") ) { return i; }
		if (HX_FIELD_EQ(inName,"l") ) { return l; }
		if (HX_FIELD_EQ(inName,"a") ) { return a; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"next") ) { return next_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"hasNext") ) { return hasNext_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic ArrayIterator_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"i") ) { i=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"l") ) { l=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"a") ) { a=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void ArrayIterator_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("i"));
	outFields->push(HX_CSTRING("l"));
	outFields->push(HX_CSTRING("a"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(ArrayIterator_obj,i),HX_CSTRING("i")},
	{hx::fsInt,(int)offsetof(ArrayIterator_obj,l),HX_CSTRING("l")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(ArrayIterator_obj,a),HX_CSTRING("a")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("i"),
	HX_CSTRING("l"),
	HX_CSTRING("a"),
	HX_CSTRING("hasNext"),
	HX_CSTRING("next"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(ArrayIterator_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(ArrayIterator_obj::__mClass,"__mClass");
};

#endif

Class ArrayIterator_obj::__mClass;

void ArrayIterator_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.impl.ArrayIterator"), hx::TCanCast< ArrayIterator_obj> ,sStaticFields,sMemberFields,
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

void ArrayIterator_obj::__boot()
{
}

} // end namespace hxd
} // end namespace impl
