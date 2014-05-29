#include <hxcpp.h>

#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_hxd_res__NanoJpeg_FastBytes_Impl_
#include <hxd/res/_NanoJpeg/FastBytes_Impl_.h>
#endif
namespace hxd{
namespace res{
namespace _NanoJpeg{

Void FastBytes_Impl__obj::__construct()
{
	return null();
}

//FastBytes_Impl__obj::~FastBytes_Impl__obj() { }

Dynamic FastBytes_Impl__obj::__CreateEmpty() { return  new FastBytes_Impl__obj; }
hx::ObjectPtr< FastBytes_Impl__obj > FastBytes_Impl__obj::__new()
{  hx::ObjectPtr< FastBytes_Impl__obj > result = new FastBytes_Impl__obj();
	result->__construct();
	return result;}

Dynamic FastBytes_Impl__obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< FastBytes_Impl__obj > result = new FastBytes_Impl__obj();
	result->__construct();
	return result;}

::haxe::io::Bytes FastBytes_Impl__obj::_new( ::haxe::io::Bytes b){
	HX_STACK_FRAME("hxd.res._NanoJpeg.FastBytes_Impl_","_new",0xf1e4d43b,"hxd.res._NanoJpeg.FastBytes_Impl_._new","hxd/res/NanoJpeg.hx",28,0xbcbe95b8)
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(28)
	return b;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FastBytes_Impl__obj,_new,return )

int FastBytes_Impl__obj::get( ::haxe::io::Bytes this1,int i){
	HX_STACK_FRAME("hxd.res._NanoJpeg.FastBytes_Impl_","get",0x89b7dafc,"hxd.res._NanoJpeg.FastBytes_Impl_.get","hxd/res/NanoJpeg.hx",31,0xbcbe95b8)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_ARG(i,"i")
	HX_STACK_LINE(31)
	return this1->b->__get(i);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(FastBytes_Impl__obj,get,return )

Void FastBytes_Impl__obj::set( ::haxe::io::Bytes this1,int i,int v){
{
		HX_STACK_FRAME("hxd.res._NanoJpeg.FastBytes_Impl_","set",0x89c0f608,"hxd.res._NanoJpeg.FastBytes_Impl_.set","hxd/res/NanoJpeg.hx",34,0xbcbe95b8)
		HX_STACK_ARG(this1,"this1")
		HX_STACK_ARG(i,"i")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(34)
		this1->b[i] = v;
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(FastBytes_Impl__obj,set,(void))


FastBytes_Impl__obj::FastBytes_Impl__obj()
{
}

Dynamic FastBytes_Impl__obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"get") ) { return get_dyn(); }
		if (HX_FIELD_EQ(inName,"set") ) { return set_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"_new") ) { return _new_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic FastBytes_Impl__obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void FastBytes_Impl__obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("_new"),
	HX_CSTRING("get"),
	HX_CSTRING("set"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FastBytes_Impl__obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FastBytes_Impl__obj::__mClass,"__mClass");
};

#endif

Class FastBytes_Impl__obj::__mClass;

void FastBytes_Impl__obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.res._NanoJpeg.FastBytes_Impl_"), hx::TCanCast< FastBytes_Impl__obj> ,sStaticFields,sMemberFields,
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

void FastBytes_Impl__obj::__boot()
{
}

} // end namespace hxd
} // end namespace res
} // end namespace _NanoJpeg
