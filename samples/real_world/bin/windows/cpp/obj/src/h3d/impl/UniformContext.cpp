#include <hxcpp.h>

#ifndef INCLUDED_h3d_impl_GLActiveInfo
#include <h3d/impl/GLActiveInfo.h>
#endif
#ifndef INCLUDED_h3d_impl_UniformContext
#include <h3d/impl/UniformContext.h>
#endif
namespace h3d{
namespace impl{

Void UniformContext_obj::__construct(int t,::h3d::impl::GLActiveInfo i)
{
HX_STACK_FRAME("h3d.impl.UniformContext","new",0x2c8d2a46,"h3d.impl.UniformContext.new","h3d/impl/GlDriver.hx",82,0xae6eb278)
HX_STACK_THIS(this)
HX_STACK_ARG(t,"t")
HX_STACK_ARG(i,"i")
{
	HX_STACK_LINE(83)
	this->texIndex = t;
	HX_STACK_LINE(84)
	this->inf = i;
}
;
	return null();
}

//UniformContext_obj::~UniformContext_obj() { }

Dynamic UniformContext_obj::__CreateEmpty() { return  new UniformContext_obj; }
hx::ObjectPtr< UniformContext_obj > UniformContext_obj::__new(int t,::h3d::impl::GLActiveInfo i)
{  hx::ObjectPtr< UniformContext_obj > result = new UniformContext_obj();
	result->__construct(t,i);
	return result;}

Dynamic UniformContext_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< UniformContext_obj > result = new UniformContext_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}


UniformContext_obj::UniformContext_obj()
{
}

void UniformContext_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(UniformContext);
	HX_MARK_MEMBER_NAME(texIndex,"texIndex");
	HX_MARK_MEMBER_NAME(inf,"inf");
	HX_MARK_END_CLASS();
}

void UniformContext_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(texIndex,"texIndex");
	HX_VISIT_MEMBER_NAME(inf,"inf");
}

Dynamic UniformContext_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"inf") ) { return inf; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"texIndex") ) { return texIndex; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic UniformContext_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"inf") ) { inf=inValue.Cast< ::h3d::impl::GLActiveInfo >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"texIndex") ) { texIndex=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void UniformContext_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("texIndex"));
	outFields->push(HX_CSTRING("inf"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(UniformContext_obj,texIndex),HX_CSTRING("texIndex")},
	{hx::fsObject /*::h3d::impl::GLActiveInfo*/ ,(int)offsetof(UniformContext_obj,inf),HX_CSTRING("inf")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("texIndex"),
	HX_CSTRING("inf"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(UniformContext_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(UniformContext_obj::__mClass,"__mClass");
};

#endif

Class UniformContext_obj::__mClass;

void UniformContext_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.impl.UniformContext"), hx::TCanCast< UniformContext_obj> ,sStaticFields,sMemberFields,
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

void UniformContext_obj::__boot()
{
}

} // end namespace h3d
} // end namespace impl
