#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_h3d_impl_Attribute
#include <h3d/impl/Attribute.h>
#endif
#ifndef INCLUDED_h3d_impl_ShaderType
#include <h3d/impl/ShaderType.h>
#endif
namespace h3d{
namespace impl{

Void Attribute_obj::__construct(::String n,::h3d::impl::ShaderType t,int e,int o,int i,int s)
{
HX_STACK_FRAME("h3d.impl.Attribute","new",0x6d95f4f5,"h3d.impl.Attribute.new","h3d/impl/Shader.hx",56,0x8487c6c0)
HX_STACK_THIS(this)
HX_STACK_ARG(n,"n")
HX_STACK_ARG(t,"t")
HX_STACK_ARG(e,"e")
HX_STACK_ARG(o,"o")
HX_STACK_ARG(i,"i")
HX_STACK_ARG(s,"s")
{
	HX_STACK_LINE(57)
	this->name = n;
	HX_STACK_LINE(58)
	this->type = t;
	HX_STACK_LINE(59)
	this->etype = e;
	HX_STACK_LINE(60)
	this->offset = o;
	HX_STACK_LINE(61)
	this->index = i;
	HX_STACK_LINE(62)
	this->size = s;
}
;
	return null();
}

//Attribute_obj::~Attribute_obj() { }

Dynamic Attribute_obj::__CreateEmpty() { return  new Attribute_obj; }
hx::ObjectPtr< Attribute_obj > Attribute_obj::__new(::String n,::h3d::impl::ShaderType t,int e,int o,int i,int s)
{  hx::ObjectPtr< Attribute_obj > result = new Attribute_obj();
	result->__construct(n,t,e,o,i,s);
	return result;}

Dynamic Attribute_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Attribute_obj > result = new Attribute_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4],inArgs[5]);
	return result;}

::String Attribute_obj::toString( ){
	HX_STACK_FRAME("h3d.impl.Attribute","toString",0xe816eff7,"h3d.impl.Attribute.toString","h3d/impl/Shader.hx",65,0x8487c6c0)
	HX_STACK_THIS(this)
	HX_STACK_LINE(66)
	::String _g = ::Std_obj::string(this->type);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(66)
	return (((((((((((HX_CSTRING("etype:") + this->etype) + HX_CSTRING(" offset::")) + this->offset) + HX_CSTRING(" index:")) + this->index) + HX_CSTRING(" size:")) + this->size) + HX_CSTRING(" name:")) + this->name) + HX_CSTRING(" type:")) + _g);
}


HX_DEFINE_DYNAMIC_FUNC0(Attribute_obj,toString,return )


Attribute_obj::Attribute_obj()
{
}

void Attribute_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Attribute);
	HX_MARK_MEMBER_NAME(etype,"etype");
	HX_MARK_MEMBER_NAME(offset,"offset");
	HX_MARK_MEMBER_NAME(index,"index");
	HX_MARK_MEMBER_NAME(size,"size");
	HX_MARK_MEMBER_NAME(name,"name");
	HX_MARK_MEMBER_NAME(type,"type");
	HX_MARK_END_CLASS();
}

void Attribute_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(etype,"etype");
	HX_VISIT_MEMBER_NAME(offset,"offset");
	HX_VISIT_MEMBER_NAME(index,"index");
	HX_VISIT_MEMBER_NAME(size,"size");
	HX_VISIT_MEMBER_NAME(name,"name");
	HX_VISIT_MEMBER_NAME(type,"type");
}

Dynamic Attribute_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"size") ) { return size; }
		if (HX_FIELD_EQ(inName,"name") ) { return name; }
		if (HX_FIELD_EQ(inName,"type") ) { return type; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"etype") ) { return etype; }
		if (HX_FIELD_EQ(inName,"index") ) { return index; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"offset") ) { return offset; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Attribute_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"size") ) { size=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"name") ) { name=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"type") ) { type=inValue.Cast< ::h3d::impl::ShaderType >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"etype") ) { etype=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"index") ) { index=inValue.Cast< int >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"offset") ) { offset=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Attribute_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("etype"));
	outFields->push(HX_CSTRING("offset"));
	outFields->push(HX_CSTRING("index"));
	outFields->push(HX_CSTRING("size"));
	outFields->push(HX_CSTRING("name"));
	outFields->push(HX_CSTRING("type"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(Attribute_obj,etype),HX_CSTRING("etype")},
	{hx::fsInt,(int)offsetof(Attribute_obj,offset),HX_CSTRING("offset")},
	{hx::fsInt,(int)offsetof(Attribute_obj,index),HX_CSTRING("index")},
	{hx::fsInt,(int)offsetof(Attribute_obj,size),HX_CSTRING("size")},
	{hx::fsString,(int)offsetof(Attribute_obj,name),HX_CSTRING("name")},
	{hx::fsObject /*::h3d::impl::ShaderType*/ ,(int)offsetof(Attribute_obj,type),HX_CSTRING("type")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("etype"),
	HX_CSTRING("offset"),
	HX_CSTRING("index"),
	HX_CSTRING("size"),
	HX_CSTRING("name"),
	HX_CSTRING("type"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Attribute_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Attribute_obj::__mClass,"__mClass");
};

#endif

Class Attribute_obj::__mClass;

void Attribute_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.impl.Attribute"), hx::TCanCast< Attribute_obj> ,sStaticFields,sMemberFields,
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

void Attribute_obj::__boot()
{
}

} // end namespace h3d
} // end namespace impl
