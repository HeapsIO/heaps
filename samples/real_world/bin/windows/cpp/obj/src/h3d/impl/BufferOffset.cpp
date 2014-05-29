#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_h3d_impl_Buffer
#include <h3d/impl/Buffer.h>
#endif
#ifndef INCLUDED_h3d_impl_BufferOffset
#include <h3d/impl/BufferOffset.h>
#endif
namespace h3d{
namespace impl{

Void BufferOffset_obj::__construct(::h3d::impl::Buffer b,int offset,Dynamic __o_shared,Dynamic stride)
{
HX_STACK_FRAME("h3d.impl.BufferOffset","new",0x1439c39e,"h3d.impl.BufferOffset.new","h3d/impl/Buffer.hx",94,0x06b1a3c5)
HX_STACK_THIS(this)
HX_STACK_ARG(b,"b")
HX_STACK_ARG(offset,"offset")
HX_STACK_ARG(__o_shared,"shared")
HX_STACK_ARG(stride,"stride")
Dynamic shared = __o_shared.Default(false);
{
	HX_STACK_LINE(95)
	this->b = b;
	HX_STACK_LINE(96)
	this->offset = offset;
	HX_STACK_LINE(97)
	this->shared = shared;
	HX_STACK_LINE(98)
	this->stride = stride;
}
;
	return null();
}

//BufferOffset_obj::~BufferOffset_obj() { }

Dynamic BufferOffset_obj::__CreateEmpty() { return  new BufferOffset_obj; }
hx::ObjectPtr< BufferOffset_obj > BufferOffset_obj::__new(::h3d::impl::Buffer b,int offset,Dynamic __o_shared,Dynamic stride)
{  hx::ObjectPtr< BufferOffset_obj > result = new BufferOffset_obj();
	result->__construct(b,offset,__o_shared,stride);
	return result;}

Dynamic BufferOffset_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< BufferOffset_obj > result = new BufferOffset_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3]);
	return result;}

Void BufferOffset_obj::dispose( ){
{
		HX_STACK_FRAME("h3d.impl.BufferOffset","dispose",0x377feadd,"h3d.impl.BufferOffset.dispose","h3d/impl/Buffer.hx",101,0x06b1a3c5)
		HX_STACK_THIS(this)
		HX_STACK_LINE(101)
		if (((this->b != null()))){
			HX_STACK_LINE(102)
			this->b->dispose();
			HX_STACK_LINE(103)
			this->b = null();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BufferOffset_obj,dispose,(void))

::String BufferOffset_obj::toString( ){
	HX_STACK_FRAME("h3d.impl.BufferOffset","toString",0x69385cae,"h3d.impl.BufferOffset.toString","h3d/impl/Buffer.hx",108,0x06b1a3c5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(109)
	::String _g = ::Std_obj::string(this->b);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(109)
	::String _g1 = (HX_CSTRING("b:") + _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(109)
	::String _g2 = (_g1 + HX_CSTRING(" ofs:"));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(109)
	::String _g3 = (_g2 + this->offset);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(109)
	::String _g4 = (_g3 + HX_CSTRING(" shared:"));		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(109)
	::String _g5 = ::Std_obj::string(this->shared);		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(109)
	::String _g6 = (_g4 + _g5);		HX_STACK_VAR(_g6,"_g6");
	HX_STACK_LINE(109)
	::String _g7 = (_g6 + HX_CSTRING(" stride:"));		HX_STACK_VAR(_g7,"_g7");
	HX_STACK_LINE(109)
	return (_g7 + this->stride);
}


HX_DEFINE_DYNAMIC_FUNC0(BufferOffset_obj,toString,return )


BufferOffset_obj::BufferOffset_obj()
{
}

void BufferOffset_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(BufferOffset);
	HX_MARK_MEMBER_NAME(b,"b");
	HX_MARK_MEMBER_NAME(offset,"offset");
	HX_MARK_MEMBER_NAME(shared,"shared");
	HX_MARK_MEMBER_NAME(stride,"stride");
	HX_MARK_END_CLASS();
}

void BufferOffset_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(b,"b");
	HX_VISIT_MEMBER_NAME(offset,"offset");
	HX_VISIT_MEMBER_NAME(shared,"shared");
	HX_VISIT_MEMBER_NAME(stride,"stride");
}

Dynamic BufferOffset_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"b") ) { return b; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"offset") ) { return offset; }
		if (HX_FIELD_EQ(inName,"shared") ) { return shared; }
		if (HX_FIELD_EQ(inName,"stride") ) { return stride; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic BufferOffset_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"b") ) { b=inValue.Cast< ::h3d::impl::Buffer >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"offset") ) { offset=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"shared") ) { shared=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"stride") ) { stride=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void BufferOffset_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("b"));
	outFields->push(HX_CSTRING("offset"));
	outFields->push(HX_CSTRING("shared"));
	outFields->push(HX_CSTRING("stride"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h3d::impl::Buffer*/ ,(int)offsetof(BufferOffset_obj,b),HX_CSTRING("b")},
	{hx::fsInt,(int)offsetof(BufferOffset_obj,offset),HX_CSTRING("offset")},
	{hx::fsBool,(int)offsetof(BufferOffset_obj,shared),HX_CSTRING("shared")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(BufferOffset_obj,stride),HX_CSTRING("stride")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("b"),
	HX_CSTRING("offset"),
	HX_CSTRING("shared"),
	HX_CSTRING("stride"),
	HX_CSTRING("dispose"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(BufferOffset_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(BufferOffset_obj::__mClass,"__mClass");
};

#endif

Class BufferOffset_obj::__mClass;

void BufferOffset_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.impl.BufferOffset"), hx::TCanCast< BufferOffset_obj> ,sStaticFields,sMemberFields,
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

void BufferOffset_obj::__boot()
{
}

} // end namespace h3d
} // end namespace impl
