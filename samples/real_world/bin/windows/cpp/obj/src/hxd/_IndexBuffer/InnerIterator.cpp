#include <hxcpp.h>

#ifndef INCLUDED_hxd__IndexBuffer_InnerIterator
#include <hxd/_IndexBuffer/InnerIterator.h>
#endif
namespace hxd{
namespace _IndexBuffer{

Void InnerIterator_obj::__construct(Array< int > b)
{
HX_STACK_FRAME("hxd._IndexBuffer.InnerIterator","new",0x2229ccb5,"hxd._IndexBuffer.InnerIterator.new","hxd/IndexBuffer.hx",9,0x7cad6c07)
HX_STACK_THIS(this)
HX_STACK_ARG(b,"b")
{
	HX_STACK_LINE(10)
	this->b = b;
	HX_STACK_LINE(11)
	this->len = this->b->length;
	HX_STACK_LINE(12)
	this->pos = (int)0;
}
;
	return null();
}

//InnerIterator_obj::~InnerIterator_obj() { }

Dynamic InnerIterator_obj::__CreateEmpty() { return  new InnerIterator_obj; }
hx::ObjectPtr< InnerIterator_obj > InnerIterator_obj::__new(Array< int > b)
{  hx::ObjectPtr< InnerIterator_obj > result = new InnerIterator_obj();
	result->__construct(b);
	return result;}

Dynamic InnerIterator_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< InnerIterator_obj > result = new InnerIterator_obj();
	result->__construct(inArgs[0]);
	return result;}

bool InnerIterator_obj::hasNext( ){
	HX_STACK_FRAME("hxd._IndexBuffer.InnerIterator","hasNext",0x33d9f042,"hxd._IndexBuffer.InnerIterator.hasNext","hxd/IndexBuffer.hx",15,0x7cad6c07)
	HX_STACK_THIS(this)
	HX_STACK_LINE(15)
	return (this->pos < this->len);
}


HX_DEFINE_DYNAMIC_FUNC0(InnerIterator_obj,hasNext,return )

int InnerIterator_obj::next( ){
	HX_STACK_FRAME("hxd._IndexBuffer.InnerIterator","next",0xc26952fe,"hxd._IndexBuffer.InnerIterator.next","hxd/IndexBuffer.hx",17,0x7cad6c07)
	HX_STACK_THIS(this)
	HX_STACK_LINE(18)
	int _g = (this->pos)++;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(18)
	return this->b->__get(_g);
}


HX_DEFINE_DYNAMIC_FUNC0(InnerIterator_obj,next,return )


InnerIterator_obj::InnerIterator_obj()
{
}

void InnerIterator_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(InnerIterator);
	HX_MARK_MEMBER_NAME(b,"b");
	HX_MARK_MEMBER_NAME(len,"len");
	HX_MARK_MEMBER_NAME(pos,"pos");
	HX_MARK_END_CLASS();
}

void InnerIterator_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(b,"b");
	HX_VISIT_MEMBER_NAME(len,"len");
	HX_VISIT_MEMBER_NAME(pos,"pos");
}

Dynamic InnerIterator_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"b") ) { return b; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"len") ) { return len; }
		if (HX_FIELD_EQ(inName,"pos") ) { return pos; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"next") ) { return next_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"hasNext") ) { return hasNext_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic InnerIterator_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"b") ) { b=inValue.Cast< Array< int > >(); return inValue; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"len") ) { len=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"pos") ) { pos=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void InnerIterator_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("b"));
	outFields->push(HX_CSTRING("len"));
	outFields->push(HX_CSTRING("pos"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Array< int >*/ ,(int)offsetof(InnerIterator_obj,b),HX_CSTRING("b")},
	{hx::fsInt,(int)offsetof(InnerIterator_obj,len),HX_CSTRING("len")},
	{hx::fsInt,(int)offsetof(InnerIterator_obj,pos),HX_CSTRING("pos")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("b"),
	HX_CSTRING("len"),
	HX_CSTRING("pos"),
	HX_CSTRING("hasNext"),
	HX_CSTRING("next"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(InnerIterator_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(InnerIterator_obj::__mClass,"__mClass");
};

#endif

Class InnerIterator_obj::__mClass;

void InnerIterator_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd._IndexBuffer.InnerIterator"), hx::TCanCast< InnerIterator_obj> ,sStaticFields,sMemberFields,
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

void InnerIterator_obj::__boot()
{
}

} // end namespace hxd
} // end namespace _IndexBuffer
