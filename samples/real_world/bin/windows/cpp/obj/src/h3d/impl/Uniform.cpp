#include <hxcpp.h>

#ifndef INCLUDED_h3d_impl_ShaderType
#include <h3d/impl/ShaderType.h>
#endif
#ifndef INCLUDED_h3d_impl_Uniform
#include <h3d/impl/Uniform.h>
#endif
namespace h3d{
namespace impl{

Void Uniform_obj::__construct(::String n,Dynamic l,::h3d::impl::ShaderType t,int i)
{
HX_STACK_FRAME("h3d.impl.Uniform","new",0x13871a4d,"h3d.impl.Uniform.new","h3d/impl/Shader.hx",38,0x8487c6c0)
HX_STACK_THIS(this)
HX_STACK_ARG(n,"n")
HX_STACK_ARG(l,"l")
HX_STACK_ARG(t,"t")
HX_STACK_ARG(i,"i")
{
	HX_STACK_LINE(39)
	this->name = n;
	HX_STACK_LINE(40)
	this->loc = l;
	HX_STACK_LINE(41)
	this->type = t;
	HX_STACK_LINE(42)
	this->index = i;
}
;
	return null();
}

//Uniform_obj::~Uniform_obj() { }

Dynamic Uniform_obj::__CreateEmpty() { return  new Uniform_obj; }
hx::ObjectPtr< Uniform_obj > Uniform_obj::__new(::String n,Dynamic l,::h3d::impl::ShaderType t,int i)
{  hx::ObjectPtr< Uniform_obj > result = new Uniform_obj();
	result->__construct(n,l,t,i);
	return result;}

Dynamic Uniform_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Uniform_obj > result = new Uniform_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3]);
	return result;}


Uniform_obj::Uniform_obj()
{
}

void Uniform_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Uniform);
	HX_MARK_MEMBER_NAME(name,"name");
	HX_MARK_MEMBER_NAME(loc,"loc");
	HX_MARK_MEMBER_NAME(type,"type");
	HX_MARK_MEMBER_NAME(index,"index");
	HX_MARK_END_CLASS();
}

void Uniform_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(name,"name");
	HX_VISIT_MEMBER_NAME(loc,"loc");
	HX_VISIT_MEMBER_NAME(type,"type");
	HX_VISIT_MEMBER_NAME(index,"index");
}

Dynamic Uniform_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"loc") ) { return loc; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { return name; }
		if (HX_FIELD_EQ(inName,"type") ) { return type; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"index") ) { return index; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Uniform_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"loc") ) { loc=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { name=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"type") ) { type=inValue.Cast< ::h3d::impl::ShaderType >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"index") ) { index=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Uniform_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("name"));
	outFields->push(HX_CSTRING("loc"));
	outFields->push(HX_CSTRING("type"));
	outFields->push(HX_CSTRING("index"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsString,(int)offsetof(Uniform_obj,name),HX_CSTRING("name")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Uniform_obj,loc),HX_CSTRING("loc")},
	{hx::fsObject /*::h3d::impl::ShaderType*/ ,(int)offsetof(Uniform_obj,type),HX_CSTRING("type")},
	{hx::fsInt,(int)offsetof(Uniform_obj,index),HX_CSTRING("index")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("name"),
	HX_CSTRING("loc"),
	HX_CSTRING("type"),
	HX_CSTRING("index"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Uniform_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Uniform_obj::__mClass,"__mClass");
};

#endif

Class Uniform_obj::__mClass;

void Uniform_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.impl.Uniform"), hx::TCanCast< Uniform_obj> ,sStaticFields,sMemberFields,
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

void Uniform_obj::__boot()
{
}

} // end namespace h3d
} // end namespace impl
