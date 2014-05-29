#include <hxcpp.h>

#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_hxd_res_BytesFileEntry
#include <hxd/res/BytesFileEntry.h>
#endif
#ifndef INCLUDED_hxd_res_BytesFileSystem
#include <hxd/res/BytesFileSystem.h>
#endif
#ifndef INCLUDED_hxd_res_FileEntry
#include <hxd/res/FileEntry.h>
#endif
#ifndef INCLUDED_hxd_res_FileSystem
#include <hxd/res/FileSystem.h>
#endif
namespace hxd{
namespace res{

Void BytesFileSystem_obj::__construct()
{
HX_STACK_FRAME("hxd.res.BytesFileSystem","new",0x53664d80,"hxd.res.BytesFileSystem.new","hxd/res/BytesFileSystem.hx",65,0x3543bef2)
HX_STACK_THIS(this)
{
}
;
	return null();
}

//BytesFileSystem_obj::~BytesFileSystem_obj() { }

Dynamic BytesFileSystem_obj::__CreateEmpty() { return  new BytesFileSystem_obj; }
hx::ObjectPtr< BytesFileSystem_obj > BytesFileSystem_obj::__new()
{  hx::ObjectPtr< BytesFileSystem_obj > result = new BytesFileSystem_obj();
	result->__construct();
	return result;}

Dynamic BytesFileSystem_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< BytesFileSystem_obj > result = new BytesFileSystem_obj();
	result->__construct();
	return result;}

hx::Object *BytesFileSystem_obj::__ToInterface(const hx::type_info &inType) {
	if (inType==typeid( ::hxd::res::FileSystem_obj)) return operator ::hxd::res::FileSystem_obj *();
	return super::__ToInterface(inType);
}

::hxd::res::FileEntry BytesFileSystem_obj::getRoot( ){
	HX_STACK_FRAME("hxd.res.BytesFileSystem","getRoot",0xe5992af8,"hxd.res.BytesFileSystem.getRoot","hxd/res/BytesFileSystem.hx",68,0x3543bef2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(69)
	HX_STACK_DO_THROW(HX_CSTRING("Not implemented"));
	HX_STACK_LINE(70)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BytesFileSystem_obj,getRoot,return )

::haxe::io::Bytes BytesFileSystem_obj::getBytes( ::String path){
	HX_STACK_FRAME("hxd.res.BytesFileSystem","getBytes",0xd0a306d5,"hxd.res.BytesFileSystem.getBytes","hxd/res/BytesFileSystem.hx",73,0x3543bef2)
	HX_STACK_THIS(this)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(74)
	HX_STACK_DO_THROW(HX_CSTRING("Not implemented"));
	HX_STACK_LINE(75)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(BytesFileSystem_obj,getBytes,return )

bool BytesFileSystem_obj::exists( ::String path){
	HX_STACK_FRAME("hxd.res.BytesFileSystem","exists",0xd8e094bc,"hxd.res.BytesFileSystem.exists","hxd/res/BytesFileSystem.hx",78,0x3543bef2)
	HX_STACK_THIS(this)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(79)
	::haxe::io::Bytes _g = this->getBytes(path);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(79)
	return (_g != null());
}


HX_DEFINE_DYNAMIC_FUNC1(BytesFileSystem_obj,exists,return )

::hxd::res::FileEntry BytesFileSystem_obj::get( ::String path){
	HX_STACK_FRAME("hxd.res.BytesFileSystem","get",0x5360fdb6,"hxd.res.BytesFileSystem.get","hxd/res/BytesFileSystem.hx",82,0x3543bef2)
	HX_STACK_THIS(this)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(83)
	::haxe::io::Bytes bytes = this->getBytes(path);		HX_STACK_VAR(bytes,"bytes");
	HX_STACK_LINE(84)
	if (((bytes == null()))){
		HX_STACK_LINE(84)
		HX_STACK_DO_THROW(((HX_CSTRING("Resource not found '") + path) + HX_CSTRING("'")));
	}
	HX_STACK_LINE(85)
	return ::hxd::res::BytesFileEntry_obj::__new(path,bytes);
}


HX_DEFINE_DYNAMIC_FUNC1(BytesFileSystem_obj,get,return )


BytesFileSystem_obj::BytesFileSystem_obj()
{
}

Dynamic BytesFileSystem_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"get") ) { return get_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"exists") ) { return exists_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"getRoot") ) { return getRoot_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"getBytes") ) { return getBytes_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic BytesFileSystem_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void BytesFileSystem_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("getRoot"),
	HX_CSTRING("getBytes"),
	HX_CSTRING("exists"),
	HX_CSTRING("get"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(BytesFileSystem_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(BytesFileSystem_obj::__mClass,"__mClass");
};

#endif

Class BytesFileSystem_obj::__mClass;

void BytesFileSystem_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.res.BytesFileSystem"), hx::TCanCast< BytesFileSystem_obj> ,sStaticFields,sMemberFields,
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

void BytesFileSystem_obj::__boot()
{
}

} // end namespace hxd
} // end namespace res
