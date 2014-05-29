#include <hxcpp.h>

#ifndef INCLUDED_h3d_impl_GLActiveInfo
#include <h3d/impl/GLActiveInfo.h>
#endif
namespace h3d{
namespace impl{

Void GLActiveInfo_obj::__construct(Dynamic g)
{
HX_STACK_FRAME("h3d.impl.GLActiveInfo","new",0x2d142da4,"h3d.impl.GLActiveInfo.new","h3d/impl/GlDriver.hx",41,0xae6eb278)
HX_STACK_THIS(this)
HX_STACK_ARG(g,"g")
{
	HX_STACK_LINE(42)
	this->size = g->__Field(HX_CSTRING("size"),true);
	HX_STACK_LINE(43)
	this->type = g->__Field(HX_CSTRING("type"),true);
	HX_STACK_LINE(44)
	this->name = g->__Field(HX_CSTRING("name"),true);
}
;
	return null();
}

//GLActiveInfo_obj::~GLActiveInfo_obj() { }

Dynamic GLActiveInfo_obj::__CreateEmpty() { return  new GLActiveInfo_obj; }
hx::ObjectPtr< GLActiveInfo_obj > GLActiveInfo_obj::__new(Dynamic g)
{  hx::ObjectPtr< GLActiveInfo_obj > result = new GLActiveInfo_obj();
	result->__construct(g);
	return result;}

Dynamic GLActiveInfo_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< GLActiveInfo_obj > result = new GLActiveInfo_obj();
	result->__construct(inArgs[0]);
	return result;}


GLActiveInfo_obj::GLActiveInfo_obj()
{
}

void GLActiveInfo_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(GLActiveInfo);
	HX_MARK_MEMBER_NAME(size,"size");
	HX_MARK_MEMBER_NAME(type,"type");
	HX_MARK_MEMBER_NAME(name,"name");
	HX_MARK_END_CLASS();
}

void GLActiveInfo_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(size,"size");
	HX_VISIT_MEMBER_NAME(type,"type");
	HX_VISIT_MEMBER_NAME(name,"name");
}

Dynamic GLActiveInfo_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"size") ) { return size; }
		if (HX_FIELD_EQ(inName,"type") ) { return type; }
		if (HX_FIELD_EQ(inName,"name") ) { return name; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic GLActiveInfo_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"size") ) { size=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"type") ) { type=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"name") ) { name=inValue.Cast< ::String >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void GLActiveInfo_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("size"));
	outFields->push(HX_CSTRING("type"));
	outFields->push(HX_CSTRING("name"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(GLActiveInfo_obj,size),HX_CSTRING("size")},
	{hx::fsInt,(int)offsetof(GLActiveInfo_obj,type),HX_CSTRING("type")},
	{hx::fsString,(int)offsetof(GLActiveInfo_obj,name),HX_CSTRING("name")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("size"),
	HX_CSTRING("type"),
	HX_CSTRING("name"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(GLActiveInfo_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(GLActiveInfo_obj::__mClass,"__mClass");
};

#endif

Class GLActiveInfo_obj::__mClass;

void GLActiveInfo_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.impl.GLActiveInfo"), hx::TCanCast< GLActiveInfo_obj> ,sStaticFields,sMemberFields,
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

void GLActiveInfo_obj::__boot()
{
}

} // end namespace h3d
} // end namespace impl
