#include <hxcpp.h>

#ifndef INCLUDED_flash_display_BitmapData
#include <flash/display/BitmapData.h>
#endif
#ifndef INCLUDED_flash_display_IBitmapDrawable
#include <flash/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_hxd_impl_ArrayIterator
#include <hxd/impl/ArrayIterator.h>
#endif
#ifndef INCLUDED_hxd_res_FileEntry
#include <hxd/res/FileEntry.h>
#endif
namespace hxd{
namespace res{

Void FileEntry_obj::__construct()
{
	return null();
}

//FileEntry_obj::~FileEntry_obj() { }

Dynamic FileEntry_obj::__CreateEmpty() { return  new FileEntry_obj; }
hx::ObjectPtr< FileEntry_obj > FileEntry_obj::__new()
{  hx::ObjectPtr< FileEntry_obj > result = new FileEntry_obj();
	result->__construct();
	return result;}

Dynamic FileEntry_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< FileEntry_obj > result = new FileEntry_obj();
	result->__construct();
	return result;}

int FileEntry_obj::getSign( ){
	HX_STACK_FRAME("hxd.res.FileEntry","getSign",0x2f4a4c93,"hxd.res.FileEntry.getSign","hxd/res/FileEntry.hx",13,0xb9fbe1f2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(13)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC0(FileEntry_obj,getSign,return )

::haxe::io::Bytes FileEntry_obj::getBytes( ){
	HX_STACK_FRAME("hxd.res.FileEntry","getBytes",0x72861755,"hxd.res.FileEntry.getBytes","hxd/res/FileEntry.hx",15,0xb9fbe1f2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(15)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(FileEntry_obj,getBytes,return )

Void FileEntry_obj::open( ){
{
		HX_STACK_FRAME("hxd.res.FileEntry","open",0x84bfd32a,"hxd.res.FileEntry.open","hxd/res/FileEntry.hx",17,0xb9fbe1f2)
		HX_STACK_THIS(this)
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(FileEntry_obj,open,(void))

Void FileEntry_obj::skip( int nbytes){
{
		HX_STACK_FRAME("hxd.res.FileEntry","skip",0x8760e5df,"hxd.res.FileEntry.skip","hxd/res/FileEntry.hx",18,0xb9fbe1f2)
		HX_STACK_THIS(this)
		HX_STACK_ARG(nbytes,"nbytes")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(FileEntry_obj,skip,(void))

int FileEntry_obj::readByte( ){
	HX_STACK_FRAME("hxd.res.FileEntry","readByte",0xbe31f8de,"hxd.res.FileEntry.readByte","hxd/res/FileEntry.hx",19,0xb9fbe1f2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(19)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC0(FileEntry_obj,readByte,return )

Void FileEntry_obj::read( ::haxe::io::Bytes out,int pos,int size){
{
		HX_STACK_FRAME("hxd.res.FileEntry","read",0x86b31ab6,"hxd.res.FileEntry.read","hxd/res/FileEntry.hx",20,0xb9fbe1f2)
		HX_STACK_THIS(this)
		HX_STACK_ARG(out,"out")
		HX_STACK_ARG(pos,"pos")
		HX_STACK_ARG(size,"size")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(FileEntry_obj,read,(void))

Void FileEntry_obj::close( ){
{
		HX_STACK_FRAME("hxd.res.FileEntry","close",0xb7acbc58,"hxd.res.FileEntry.close","hxd/res/FileEntry.hx",21,0xb9fbe1f2)
		HX_STACK_THIS(this)
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(FileEntry_obj,close,(void))

Void FileEntry_obj::load( Dynamic onReady){
{
		HX_STACK_FRAME("hxd.res.FileEntry","load",0x82c36986,"hxd.res.FileEntry.load","hxd/res/FileEntry.hx",23,0xb9fbe1f2)
		HX_STACK_THIS(this)
		HX_STACK_ARG(onReady,"onReady")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(FileEntry_obj,load,(void))

Void FileEntry_obj::loadBitmap( Dynamic onLoaded){
{
		HX_STACK_FRAME("hxd.res.FileEntry","loadBitmap",0xae94d615,"hxd.res.FileEntry.loadBitmap","hxd/res/FileEntry.hx",26,0xb9fbe1f2)
		HX_STACK_THIS(this)
		HX_STACK_ARG(onLoaded,"onLoaded")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(FileEntry_obj,loadBitmap,(void))

bool FileEntry_obj::exists( ::String name){
	HX_STACK_FRAME("hxd.res.FileEntry","exists",0xb106853c,"hxd.res.FileEntry.exists","hxd/res/FileEntry.hx",30,0xb9fbe1f2)
	HX_STACK_THIS(this)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(30)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC1(FileEntry_obj,exists,return )

::hxd::res::FileEntry FileEntry_obj::get( ::String name){
	HX_STACK_FRAME("hxd.res.FileEntry","get",0x2d57bd36,"hxd.res.FileEntry.get","hxd/res/FileEntry.hx",31,0xb9fbe1f2)
	HX_STACK_THIS(this)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(31)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(FileEntry_obj,get,return )

::hxd::impl::ArrayIterator FileEntry_obj::iterator( ){
	HX_STACK_FRAME("hxd.res.FileEntry","iterator",0xe8b1494e,"hxd.res.FileEntry.iterator","hxd/res/FileEntry.hx",33,0xb9fbe1f2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(33)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(FileEntry_obj,iterator,return )

bool FileEntry_obj::get_isAvailable( ){
	HX_STACK_FRAME("hxd.res.FileEntry","get_isAvailable",0xe32774b6,"hxd.res.FileEntry.get_isAvailable","hxd/res/FileEntry.hx",35,0xb9fbe1f2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(35)
	return true;
}


HX_DEFINE_DYNAMIC_FUNC0(FileEntry_obj,get_isAvailable,return )

bool FileEntry_obj::get_isDirectory( ){
	HX_STACK_FRAME("hxd.res.FileEntry","get_isDirectory",0x7be90d5a,"hxd.res.FileEntry.get_isDirectory","hxd/res/FileEntry.hx",36,0xb9fbe1f2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(36)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC0(FileEntry_obj,get_isDirectory,return )

int FileEntry_obj::get_size( ){
	HX_STACK_FRAME("hxd.res.FileEntry","get_size",0x21255baa,"hxd.res.FileEntry.get_size","hxd/res/FileEntry.hx",37,0xb9fbe1f2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(37)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC0(FileEntry_obj,get_size,return )

::String FileEntry_obj::get_path( ){
	HX_STACK_FRAME("hxd.res.FileEntry","get_path",0x1f23a08e,"hxd.res.FileEntry.get_path","hxd/res/FileEntry.hx",38,0xb9fbe1f2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(38)
	return this->name;
}


HX_DEFINE_DYNAMIC_FUNC0(FileEntry_obj,get_path,return )

::String FileEntry_obj::get_extension( ){
	HX_STACK_FRAME("hxd.res.FileEntry","get_extension",0x84e3abf6,"hxd.res.FileEntry.get_extension","hxd/res/FileEntry.hx",39,0xb9fbe1f2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(40)
	Array< ::String > np = this->name.split(HX_CSTRING("."));		HX_STACK_VAR(np,"np");
	HX_STACK_LINE(41)
	if (((np->length == (int)1))){
		HX_STACK_LINE(41)
		return HX_CSTRING("");
	}
	else{
		HX_STACK_LINE(41)
		return np->pop().toLowerCase();
	}
	HX_STACK_LINE(41)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(FileEntry_obj,get_extension,return )


FileEntry_obj::FileEntry_obj()
{
}

void FileEntry_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(FileEntry);
	HX_MARK_MEMBER_NAME(name,"name");
	HX_MARK_END_CLASS();
}

void FileEntry_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(name,"name");
}

Dynamic FileEntry_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"get") ) { return get_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { return name; }
		if (HX_FIELD_EQ(inName,"path") ) { return get_path(); }
		if (HX_FIELD_EQ(inName,"size") ) { return get_size(); }
		if (HX_FIELD_EQ(inName,"open") ) { return open_dyn(); }
		if (HX_FIELD_EQ(inName,"skip") ) { return skip_dyn(); }
		if (HX_FIELD_EQ(inName,"read") ) { return read_dyn(); }
		if (HX_FIELD_EQ(inName,"load") ) { return load_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"close") ) { return close_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"exists") ) { return exists_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"getSign") ) { return getSign_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"getBytes") ) { return getBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"readByte") ) { return readByte_dyn(); }
		if (HX_FIELD_EQ(inName,"iterator") ) { return iterator_dyn(); }
		if (HX_FIELD_EQ(inName,"get_size") ) { return get_size_dyn(); }
		if (HX_FIELD_EQ(inName,"get_path") ) { return get_path_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"extension") ) { return get_extension(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"loadBitmap") ) { return loadBitmap_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"isDirectory") ) { return get_isDirectory(); }
		if (HX_FIELD_EQ(inName,"isAvailable") ) { return get_isAvailable(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"get_extension") ) { return get_extension_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"get_isAvailable") ) { return get_isAvailable_dyn(); }
		if (HX_FIELD_EQ(inName,"get_isDirectory") ) { return get_isDirectory_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic FileEntry_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { name=inValue.Cast< ::String >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void FileEntry_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("name"));
	outFields->push(HX_CSTRING("path"));
	outFields->push(HX_CSTRING("extension"));
	outFields->push(HX_CSTRING("size"));
	outFields->push(HX_CSTRING("isDirectory"));
	outFields->push(HX_CSTRING("isAvailable"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsString,(int)offsetof(FileEntry_obj,name),HX_CSTRING("name")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("name"),
	HX_CSTRING("getSign"),
	HX_CSTRING("getBytes"),
	HX_CSTRING("open"),
	HX_CSTRING("skip"),
	HX_CSTRING("readByte"),
	HX_CSTRING("read"),
	HX_CSTRING("close"),
	HX_CSTRING("load"),
	HX_CSTRING("loadBitmap"),
	HX_CSTRING("exists"),
	HX_CSTRING("get"),
	HX_CSTRING("iterator"),
	HX_CSTRING("get_isAvailable"),
	HX_CSTRING("get_isDirectory"),
	HX_CSTRING("get_size"),
	HX_CSTRING("get_path"),
	HX_CSTRING("get_extension"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FileEntry_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FileEntry_obj::__mClass,"__mClass");
};

#endif

Class FileEntry_obj::__mClass;

void FileEntry_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.res.FileEntry"), hx::TCanCast< FileEntry_obj> ,sStaticFields,sMemberFields,
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

void FileEntry_obj::__boot()
{
}

} // end namespace hxd
} // end namespace res
