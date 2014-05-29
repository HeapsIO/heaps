#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_h3d_fbx_FBxTools
#include <h3d/fbx/FBxTools.h>
#endif
#ifndef INCLUDED_h3d_fbx_FbxProp
#include <h3d/fbx/FbxProp.h>
#endif
namespace h3d{
namespace fbx{

Void FBxTools_obj::__construct()
{
	return null();
}

//FBxTools_obj::~FBxTools_obj() { }

Dynamic FBxTools_obj::__CreateEmpty() { return  new FBxTools_obj; }
hx::ObjectPtr< FBxTools_obj > FBxTools_obj::__new()
{  hx::ObjectPtr< FBxTools_obj > result = new FBxTools_obj();
	result->__construct();
	return result;}

Dynamic FBxTools_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< FBxTools_obj > result = new FBxTools_obj();
	result->__construct();
	return result;}

::String FBxTools_obj::toString( ::h3d::fbx::FbxProp n){
	HX_STACK_FRAME("h3d.fbx.FBxTools","toString",0x7d58ac14,"h3d.fbx.FBxTools.toString","h3d/fbx/Data.hx",141,0xd5b13f0b)
	HX_STACK_ARG(n,"n")
	HX_STACK_LINE(142)
	if (((n == null()))){
		HX_STACK_LINE(142)
		HX_STACK_DO_THROW(HX_CSTRING("null prop"));
	}
	HX_STACK_LINE(143)
	switch( (int)(n->__Index())){
		case (int)2: {
			HX_STACK_LINE(143)
			::String v = (::h3d::fbx::FbxProp(n))->__Param(0);		HX_STACK_VAR(v,"v");
			HX_STACK_LINE(144)
			return v;
		}
		;break;
		default: {
			HX_STACK_LINE(145)
			::String _g = ::Std_obj::string(n);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(145)
			HX_STACK_DO_THROW((HX_CSTRING("Invalid prop ") + _g));
		}
	}
	HX_STACK_LINE(143)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FBxTools_obj,toString,return )

int FBxTools_obj::toInt( ::h3d::fbx::FbxProp n){
	HX_STACK_FRAME("h3d.fbx.FBxTools","toInt",0x962a31cc,"h3d.fbx.FBxTools.toInt","h3d/fbx/Data.hx",149,0xd5b13f0b)
	HX_STACK_ARG(n,"n")
	HX_STACK_LINE(150)
	if (((n == null()))){
		HX_STACK_LINE(150)
		HX_STACK_DO_THROW(HX_CSTRING("null prop"));
	}
	HX_STACK_LINE(151)
	switch( (int)(n->__Index())){
		case (int)0: {
			HX_STACK_LINE(151)
			int v = (::h3d::fbx::FbxProp(n))->__Param(0);		HX_STACK_VAR(v,"v");
			HX_STACK_LINE(152)
			return v;
		}
		;break;
		case (int)1: {
			HX_STACK_LINE(151)
			Float f = (::h3d::fbx::FbxProp(n))->__Param(0);		HX_STACK_VAR(f,"f");
			HX_STACK_LINE(153)
			return ::Std_obj::_int(f);
		}
		;break;
		default: {
			HX_STACK_LINE(154)
			::String _g = ::Std_obj::string(n);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(154)
			HX_STACK_DO_THROW((HX_CSTRING("Invalid prop ") + _g));
		}
	}
	HX_STACK_LINE(151)
	return (int)0;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FBxTools_obj,toInt,return )

Float FBxTools_obj::toFloat( ::h3d::fbx::FbxProp n){
	HX_STACK_FRAME("h3d.fbx.FBxTools","toFloat",0x5ee99bb9,"h3d.fbx.FBxTools.toFloat","h3d/fbx/Data.hx",158,0xd5b13f0b)
	HX_STACK_ARG(n,"n")
	HX_STACK_LINE(159)
	if (((n == null()))){
		HX_STACK_LINE(159)
		HX_STACK_DO_THROW(HX_CSTRING("null prop"));
	}
	HX_STACK_LINE(160)
	switch( (int)(n->__Index())){
		case (int)0: {
			HX_STACK_LINE(160)
			int v = (::h3d::fbx::FbxProp(n))->__Param(0);		HX_STACK_VAR(v,"v");
			HX_STACK_LINE(161)
			return (v * 1.0);
		}
		;break;
		case (int)1: {
			HX_STACK_LINE(160)
			Float v = (::h3d::fbx::FbxProp(n))->__Param(0);		HX_STACK_VAR(v,"v");
			HX_STACK_LINE(162)
			return v;
		}
		;break;
		default: {
			HX_STACK_LINE(163)
			::String _g = ::Std_obj::string(n);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(163)
			HX_STACK_DO_THROW((HX_CSTRING("Invalid prop ") + _g));
		}
	}
	HX_STACK_LINE(160)
	return 0.;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FBxTools_obj,toFloat,return )


FBxTools_obj::FBxTools_obj()
{
}

Dynamic FBxTools_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"toInt") ) { return toInt_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"toFloat") ) { return toFloat_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic FBxTools_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void FBxTools_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("toString"),
	HX_CSTRING("toInt"),
	HX_CSTRING("toFloat"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FBxTools_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FBxTools_obj::__mClass,"__mClass");
};

#endif

Class FBxTools_obj::__mClass;

void FBxTools_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.fbx.FBxTools"), hx::TCanCast< FBxTools_obj> ,sStaticFields,sMemberFields,
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

void FBxTools_obj::__boot()
{
}

} // end namespace h3d
} // end namespace fbx
