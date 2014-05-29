#include <hxcpp.h>

#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_hxd_res_BytesFileSystem
#include <hxd/res/BytesFileSystem.h>
#endif
#ifndef INCLUDED_hxd_res_FileSystem
#include <hxd/res/FileSystem.h>
#endif
#ifndef INCLUDED_hxd_res__Any_SingleFileSystem
#include <hxd/res/_Any/SingleFileSystem.h>
#endif
namespace hxd{
namespace res{
namespace _Any{

Void SingleFileSystem_obj::__construct(::String path,::haxe::io::Bytes bytes)
{
HX_STACK_FRAME("hxd.res._Any.SingleFileSystem","new",0x6b908cde,"hxd.res._Any.SingleFileSystem.new","hxd/res/Any.hx",8,0xf2276d9c)
HX_STACK_THIS(this)
HX_STACK_ARG(path,"path")
HX_STACK_ARG(bytes,"bytes")
{
	HX_STACK_LINE(9)
	super::__construct();
	HX_STACK_LINE(10)
	this->path = path;
	HX_STACK_LINE(11)
	this->bytes = bytes;
}
;
	return null();
}

//SingleFileSystem_obj::~SingleFileSystem_obj() { }

Dynamic SingleFileSystem_obj::__CreateEmpty() { return  new SingleFileSystem_obj; }
hx::ObjectPtr< SingleFileSystem_obj > SingleFileSystem_obj::__new(::String path,::haxe::io::Bytes bytes)
{  hx::ObjectPtr< SingleFileSystem_obj > result = new SingleFileSystem_obj();
	result->__construct(path,bytes);
	return result;}

Dynamic SingleFileSystem_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< SingleFileSystem_obj > result = new SingleFileSystem_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

::haxe::io::Bytes SingleFileSystem_obj::getBytes( ::String p){
	HX_STACK_FRAME("hxd.res._Any.SingleFileSystem","getBytes",0xf18052b7,"hxd.res._Any.SingleFileSystem.getBytes","hxd/res/Any.hx",15,0xf2276d9c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(15)
	if (((p == this->path))){
		HX_STACK_LINE(15)
		return this->bytes;
	}
	else{
		HX_STACK_LINE(15)
		return null();
	}
	HX_STACK_LINE(15)
	return null();
}



SingleFileSystem_obj::SingleFileSystem_obj()
{
}

void SingleFileSystem_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(SingleFileSystem);
	HX_MARK_MEMBER_NAME(path,"path");
	HX_MARK_MEMBER_NAME(bytes,"bytes");
	HX_MARK_END_CLASS();
}

void SingleFileSystem_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(path,"path");
	HX_VISIT_MEMBER_NAME(bytes,"bytes");
}

Dynamic SingleFileSystem_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"path") ) { return path; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"bytes") ) { return bytes; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"getBytes") ) { return getBytes_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic SingleFileSystem_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"path") ) { path=inValue.Cast< ::String >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"bytes") ) { bytes=inValue.Cast< ::haxe::io::Bytes >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void SingleFileSystem_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("path"));
	outFields->push(HX_CSTRING("bytes"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsString,(int)offsetof(SingleFileSystem_obj,path),HX_CSTRING("path")},
	{hx::fsObject /*::haxe::io::Bytes*/ ,(int)offsetof(SingleFileSystem_obj,bytes),HX_CSTRING("bytes")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("path"),
	HX_CSTRING("bytes"),
	HX_CSTRING("getBytes"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(SingleFileSystem_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(SingleFileSystem_obj::__mClass,"__mClass");
};

#endif

Class SingleFileSystem_obj::__mClass;

void SingleFileSystem_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.res._Any.SingleFileSystem"), hx::TCanCast< SingleFileSystem_obj> ,sStaticFields,sMemberFields,
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

void SingleFileSystem_obj::__boot()
{
}

} // end namespace hxd
} // end namespace res
} // end namespace _Any
