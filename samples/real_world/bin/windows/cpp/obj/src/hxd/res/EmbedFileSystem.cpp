#include <hxcpp.h>

#ifndef INCLUDED_EReg
#include <EReg.h>
#endif
#ifndef INCLUDED_Reflect
#include <Reflect.h>
#endif
#ifndef INCLUDED_hxd_res_EmbedFileSystem
#include <hxd/res/EmbedFileSystem.h>
#endif
#ifndef INCLUDED_hxd_res_FileEntry
#include <hxd/res/FileEntry.h>
#endif
#ifndef INCLUDED_hxd_res_FileSystem
#include <hxd/res/FileSystem.h>
#endif
#ifndef INCLUDED_hxd_res__EmbedFileSystem_EmbedEntry
#include <hxd/res/_EmbedFileSystem/EmbedEntry.h>
#endif
namespace hxd{
namespace res{

Void EmbedFileSystem_obj::__construct(Dynamic root)
{
HX_STACK_FRAME("hxd.res.EmbedFileSystem","new",0x95fb376e,"hxd.res.EmbedFileSystem.new","hxd/res/EmbedFileSystem.hx",168,0xdf76ecc4)
HX_STACK_THIS(this)
HX_STACK_ARG(root,"root")
{
	HX_STACK_LINE(168)
	this->root = root;
}
;
	return null();
}

//EmbedFileSystem_obj::~EmbedFileSystem_obj() { }

Dynamic EmbedFileSystem_obj::__CreateEmpty() { return  new EmbedFileSystem_obj; }
hx::ObjectPtr< EmbedFileSystem_obj > EmbedFileSystem_obj::__new(Dynamic root)
{  hx::ObjectPtr< EmbedFileSystem_obj > result = new EmbedFileSystem_obj();
	result->__construct(root);
	return result;}

Dynamic EmbedFileSystem_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< EmbedFileSystem_obj > result = new EmbedFileSystem_obj();
	result->__construct(inArgs[0]);
	return result;}

hx::Object *EmbedFileSystem_obj::__ToInterface(const hx::type_info &inType) {
	if (inType==typeid( ::hxd::res::FileSystem_obj)) return operator ::hxd::res::FileSystem_obj *();
	return super::__ToInterface(inType);
}

::hxd::res::FileEntry EmbedFileSystem_obj::getRoot( ){
	HX_STACK_FRAME("hxd.res.EmbedFileSystem","getRoot",0x68b4a3e6,"hxd.res.EmbedFileSystem.getRoot","hxd/res/EmbedFileSystem.hx",172,0xdf76ecc4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(172)
	return ::hxd::res::_EmbedFileSystem::EmbedEntry_obj::__new(hx::ObjectPtr<OBJ_>(this),HX_CSTRING("root"),null(),null());
}


HX_DEFINE_DYNAMIC_FUNC0(EmbedFileSystem_obj,getRoot,return )

Array< ::Dynamic > EmbedFileSystem_obj::subFiles( ::String path){
	HX_STACK_FRAME("hxd.res.EmbedFileSystem","subFiles",0x5dda7b09,"hxd.res.EmbedFileSystem.subFiles","hxd/res/EmbedFileSystem.hx",197,0xdf76ecc4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(198)
	Dynamic r = this->root;		HX_STACK_VAR(r,"r");
	HX_STACK_LINE(199)
	{
		HX_STACK_LINE(199)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(199)
		Array< ::String > _g1 = path.split(HX_CSTRING("/"));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(199)
		while((true)){
			HX_STACK_LINE(199)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(199)
				break;
			}
			HX_STACK_LINE(199)
			::String p = _g1->__get(_g);		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(199)
			++(_g);
			HX_STACK_LINE(200)
			Dynamic _g2 = ::Reflect_obj::field(r,p);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(200)
			r = _g2;
		}
	}
	HX_STACK_LINE(201)
	if (((r == null()))){
		HX_STACK_LINE(202)
		HX_STACK_DO_THROW((path + HX_CSTRING(" is not a directory")));
	}
	HX_STACK_LINE(203)
	Array< ::Dynamic > _g = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(203)
	{
		HX_STACK_LINE(203)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(203)
		Array< ::String > _g2 = ::Reflect_obj::fields(r);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(203)
		while((true)){
			HX_STACK_LINE(203)
			if ((!(((_g1 < _g2->length))))){
				HX_STACK_LINE(203)
				break;
			}
			HX_STACK_LINE(203)
			::String name = _g2->__get(_g1);		HX_STACK_VAR(name,"name");
			HX_STACK_LINE(203)
			++(_g1);
			HX_STACK_LINE(203)
			::hxd::res::_EmbedFileSystem::EmbedEntry _g11 = hx::TCast< ::hxd::res::_EmbedFileSystem::EmbedEntry >::cast(this->get(((path + HX_CSTRING("/")) + name)));		HX_STACK_VAR(_g11,"_g11");
			HX_STACK_LINE(203)
			_g->push(_g11);
		}
	}
	HX_STACK_LINE(203)
	return _g;
}


HX_DEFINE_DYNAMIC_FUNC1(EmbedFileSystem_obj,subFiles,return )

bool EmbedFileSystem_obj::isDirectory( ::String path){
	HX_STACK_FRAME("hxd.res.EmbedFileSystem","isDirectory",0xaddfce31,"hxd.res.EmbedFileSystem.isDirectory","hxd/res/EmbedFileSystem.hx",206,0xdf76ecc4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(207)
	Dynamic r = this->root;		HX_STACK_VAR(r,"r");
	HX_STACK_LINE(208)
	{
		HX_STACK_LINE(208)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(208)
		Array< ::String > _g1 = path.split(HX_CSTRING("/"));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(208)
		while((true)){
			HX_STACK_LINE(208)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(208)
				break;
			}
			HX_STACK_LINE(208)
			::String p = _g1->__get(_g);		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(208)
			++(_g);
			HX_STACK_LINE(209)
			Dynamic _g2 = ::Reflect_obj::field(r,p);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(209)
			r = _g2;
		}
	}
	HX_STACK_LINE(210)
	return (r != null());
}


HX_DEFINE_DYNAMIC_FUNC1(EmbedFileSystem_obj,isDirectory,return )

bool EmbedFileSystem_obj::exists( ::String path){
	HX_STACK_FRAME("hxd.res.EmbedFileSystem","exists",0x0ad4138e,"hxd.res.EmbedFileSystem.exists","hxd/res/EmbedFileSystem.hx",213,0xdf76ecc4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(218)
	Dynamic r = this->root;		HX_STACK_VAR(r,"r");
	HX_STACK_LINE(219)
	{
		HX_STACK_LINE(219)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(219)
		Array< ::String > _g1 = path.split(HX_CSTRING("/"));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(219)
		while((true)){
			HX_STACK_LINE(219)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(219)
				break;
			}
			HX_STACK_LINE(219)
			::String p = _g1->__get(_g);		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(219)
			++(_g);
			HX_STACK_LINE(220)
			Dynamic _g2 = ::Reflect_obj::field(r,p);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(220)
			r = _g2;
			HX_STACK_LINE(221)
			if (((r == null()))){
				HX_STACK_LINE(221)
				return false;
			}
		}
	}
	HX_STACK_LINE(223)
	return true;
}


HX_DEFINE_DYNAMIC_FUNC1(EmbedFileSystem_obj,exists,return )

::hxd::res::FileEntry EmbedFileSystem_obj::get( ::String path){
	HX_STACK_FRAME("hxd.res.EmbedFileSystem","get",0x95f5e7a4,"hxd.res.EmbedFileSystem.get","hxd/res/EmbedFileSystem.hx",227,0xdf76ecc4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(234)
	if ((!(this->exists(path)))){
		HX_STACK_LINE(235)
		HX_STACK_DO_THROW((HX_CSTRING("File not found ") + path));
	}
	HX_STACK_LINE(236)
	::String id = ::hxd::res::EmbedFileSystem_obj::resolve(path);		HX_STACK_VAR(id,"id");
	HX_STACK_LINE(237)
	::String _g = path.split(HX_CSTRING("/"))->pop();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(237)
	return ::hxd::res::_EmbedFileSystem::EmbedEntry_obj::__new(hx::ObjectPtr<OBJ_>(this),_g,path,id);
}


HX_DEFINE_DYNAMIC_FUNC1(EmbedFileSystem_obj,get,return )

::EReg EmbedFileSystem_obj::invalidChars;

::String EmbedFileSystem_obj::resolve( ::String path){
	HX_STACK_FRAME("hxd.res.EmbedFileSystem","resolve",0xb1e318fa,"hxd.res.EmbedFileSystem.resolve","hxd/res/EmbedFileSystem.hx",176,0xdf76ecc4)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(180)
	::String _g = ::hxd::res::EmbedFileSystem_obj::invalidChars->replace(path,HX_CSTRING("_"));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(180)
	return (HX_CSTRING("R_") + _g);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(EmbedFileSystem_obj,resolve,return )


EmbedFileSystem_obj::EmbedFileSystem_obj()
{
}

void EmbedFileSystem_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(EmbedFileSystem);
	HX_MARK_MEMBER_NAME(root,"root");
	HX_MARK_END_CLASS();
}

void EmbedFileSystem_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(root,"root");
}

Dynamic EmbedFileSystem_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"get") ) { return get_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"root") ) { return root; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"exists") ) { return exists_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"resolve") ) { return resolve_dyn(); }
		if (HX_FIELD_EQ(inName,"getRoot") ) { return getRoot_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"subFiles") ) { return subFiles_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"isDirectory") ) { return isDirectory_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"invalidChars") ) { return invalidChars; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic EmbedFileSystem_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"root") ) { root=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"invalidChars") ) { invalidChars=inValue.Cast< ::EReg >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void EmbedFileSystem_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("root"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("invalidChars"),
	HX_CSTRING("resolve"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(EmbedFileSystem_obj,root),HX_CSTRING("root")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("root"),
	HX_CSTRING("getRoot"),
	HX_CSTRING("subFiles"),
	HX_CSTRING("isDirectory"),
	HX_CSTRING("exists"),
	HX_CSTRING("get"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(EmbedFileSystem_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(EmbedFileSystem_obj::invalidChars,"invalidChars");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(EmbedFileSystem_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(EmbedFileSystem_obj::invalidChars,"invalidChars");
};

#endif

Class EmbedFileSystem_obj::__mClass;

void EmbedFileSystem_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.res.EmbedFileSystem"), hx::TCanCast< EmbedFileSystem_obj> ,sStaticFields,sMemberFields,
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

void EmbedFileSystem_obj::__boot()
{
	invalidChars= ::EReg_obj::__new(HX_CSTRING("[^A-Za-z0-9_]"),HX_CSTRING("g"));
}

} // end namespace hxd
} // end namespace res
