#include <hxcpp.h>

#ifndef INCLUDED_flash_display_BitmapData
#include <flash/display/BitmapData.h>
#endif
#ifndef INCLUDED_flash_display_IBitmapDrawable
#include <flash/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_haxe_Resource
#include <haxe/Resource.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_hxd_impl_ArrayIterator
#include <hxd/impl/ArrayIterator.h>
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
namespace _EmbedFileSystem{

Void EmbedEntry_obj::__construct(::hxd::res::EmbedFileSystem fs,::String name,::String relPath,::String data)
{
HX_STACK_FRAME("hxd.res._EmbedFileSystem.EmbedEntry","new",0x385c966c,"hxd.res._EmbedFileSystem.EmbedEntry.new","hxd/res/EmbedFileSystem.hx",20,0xdf76ecc4)
HX_STACK_THIS(this)
HX_STACK_ARG(fs,"fs")
HX_STACK_ARG(name,"name")
HX_STACK_ARG(relPath,"relPath")
HX_STACK_ARG(data,"data")
{
	HX_STACK_LINE(21)
	this->fs = fs;
	HX_STACK_LINE(22)
	this->name = name;
	HX_STACK_LINE(23)
	this->relPath = relPath;
	HX_STACK_LINE(24)
	this->data = data;
}
;
	return null();
}

//EmbedEntry_obj::~EmbedEntry_obj() { }

Dynamic EmbedEntry_obj::__CreateEmpty() { return  new EmbedEntry_obj; }
hx::ObjectPtr< EmbedEntry_obj > EmbedEntry_obj::__new(::hxd::res::EmbedFileSystem fs,::String name,::String relPath,::String data)
{  hx::ObjectPtr< EmbedEntry_obj > result = new EmbedEntry_obj();
	result->__construct(fs,name,relPath,data);
	return result;}

Dynamic EmbedEntry_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< EmbedEntry_obj > result = new EmbedEntry_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3]);
	return result;}

int EmbedEntry_obj::getSign( ){
	HX_STACK_FRAME("hxd.res._EmbedFileSystem.EmbedEntry","getSign",0x3a88fbff,"hxd.res._EmbedFileSystem.EmbedEntry.getSign","hxd/res/EmbedFileSystem.hx",27,0xdf76ecc4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(36)
	int old = this->readPos;		HX_STACK_VAR(old,"old");
	HX_STACK_LINE(37)
	this->open();
	HX_STACK_LINE(38)
	this->readPos = old;
	HX_STACK_LINE(39)
	return (int((int((int(this->bytes->b->__get((int)0)) | int((int(this->bytes->b->__get((int)1)) << int((int)8))))) | int((int(this->bytes->b->__get((int)2)) << int((int)16))))) | int((int(this->bytes->b->__get((int)3)) << int((int)24))));
}


::haxe::io::Bytes EmbedEntry_obj::getBytes( ){
	HX_STACK_FRAME("hxd.res._EmbedFileSystem.EmbedEntry","getBytes",0x3e20e669,"hxd.res._EmbedFileSystem.EmbedEntry.getBytes","hxd/res/EmbedFileSystem.hx",43,0xdf76ecc4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(49)
	if (((this->bytes == null()))){
		HX_STACK_LINE(50)
		this->open();
	}
	HX_STACK_LINE(51)
	return this->bytes;
}


Void EmbedEntry_obj::open( ){
{
		HX_STACK_FRAME("hxd.res._EmbedFileSystem.EmbedEntry","open",0x1958883e,"hxd.res._EmbedFileSystem.EmbedEntry.open","hxd/res/EmbedFileSystem.hx",55,0xdf76ecc4)
		HX_STACK_THIS(this)
		HX_STACK_LINE(61)
		if (((this->bytes == null()))){
			HX_STACK_LINE(62)
			::haxe::io::Bytes _g = ::haxe::Resource_obj::getBytes(this->data);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(62)
			this->bytes = _g;
			HX_STACK_LINE(63)
			if (((this->bytes == null()))){
				HX_STACK_LINE(63)
				HX_STACK_DO_THROW((HX_CSTRING("Missing resource ") + this->data));
			}
		}
		HX_STACK_LINE(65)
		this->readPos = (int)0;
	}
return null();
}


Void EmbedEntry_obj::skip( int nbytes){
{
		HX_STACK_FRAME("hxd.res._EmbedFileSystem.EmbedEntry","skip",0x1bf99af3,"hxd.res._EmbedFileSystem.EmbedEntry.skip","hxd/res/EmbedFileSystem.hx",73,0xdf76ecc4)
		HX_STACK_THIS(this)
		HX_STACK_ARG(nbytes,"nbytes")
		HX_STACK_LINE(73)
		hx::AddEq(this->readPos,nbytes);
	}
return null();
}


int EmbedEntry_obj::readByte( ){
	HX_STACK_FRAME("hxd.res._EmbedFileSystem.EmbedEntry","readByte",0x89ccc7f2,"hxd.res._EmbedFileSystem.EmbedEntry.readByte","hxd/res/EmbedFileSystem.hx",81,0xdf76ecc4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(81)
	int pos = (this->readPos)++;		HX_STACK_VAR(pos,"pos");
	HX_STACK_LINE(81)
	return this->bytes->b->__get(pos);
}


Void EmbedEntry_obj::read( ::haxe::io::Bytes out,int pos,int size){
{
		HX_STACK_FRAME("hxd.res._EmbedFileSystem.EmbedEntry","read",0x1b4bcfca,"hxd.res._EmbedFileSystem.EmbedEntry.read","hxd/res/EmbedFileSystem.hx",85,0xdf76ecc4)
		HX_STACK_THIS(this)
		HX_STACK_ARG(out,"out")
		HX_STACK_ARG(pos,"pos")
		HX_STACK_ARG(size,"size")
		HX_STACK_LINE(89)
		out->blit(pos,this->bytes,this->readPos,size);
		HX_STACK_LINE(90)
		hx::AddEq(this->readPos,size);
	}
return null();
}


Void EmbedEntry_obj::close( ){
{
		HX_STACK_FRAME("hxd.res._EmbedFileSystem.EmbedEntry","close",0x28b278c4,"hxd.res._EmbedFileSystem.EmbedEntry.close","hxd/res/EmbedFileSystem.hx",94,0xdf76ecc4)
		HX_STACK_THIS(this)
		HX_STACK_LINE(98)
		this->bytes = null();
		HX_STACK_LINE(99)
		this->readPos = (int)0;
	}
return null();
}


Void EmbedEntry_obj::load( Dynamic onReady){
{
		HX_STACK_FRAME("hxd.res._EmbedFileSystem.EmbedEntry","load",0x175c1e9a,"hxd.res._EmbedFileSystem.EmbedEntry.load","hxd/res/EmbedFileSystem.hx",103,0xdf76ecc4)
		HX_STACK_THIS(this)
		HX_STACK_ARG(onReady,"onReady")
	}
return null();
}


Void EmbedEntry_obj::loadBitmap( Dynamic onLoaded){
{
		HX_STACK_FRAME("hxd.res._EmbedFileSystem.EmbedEntry","loadBitmap",0xb1d09229,"hxd.res._EmbedFileSystem.EmbedEntry.loadBitmap","hxd/res/EmbedFileSystem.hx",124,0xdf76ecc4)
		HX_STACK_THIS(this)
		HX_STACK_ARG(onLoaded,"onLoaded")
		HX_STACK_LINE(124)
		HX_STACK_DO_THROW(HX_CSTRING("TODO"));
	}
return null();
}


bool EmbedEntry_obj::get_isDirectory( ){
	HX_STACK_FRAME("hxd.res._EmbedFileSystem.EmbedEntry","get_isDirectory",0xf9c708c6,"hxd.res._EmbedFileSystem.EmbedEntry.get_isDirectory","hxd/res/EmbedFileSystem.hx",129,0xdf76ecc4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(129)
	return this->fs->isDirectory(this->relPath);
}


::String EmbedEntry_obj::get_path( ){
	HX_STACK_FRAME("hxd.res._EmbedFileSystem.EmbedEntry","get_path",0xeabe6fa2,"hxd.res._EmbedFileSystem.EmbedEntry.get_path","hxd/res/EmbedFileSystem.hx",133,0xdf76ecc4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(133)
	if (((this->relPath == null()))){
		HX_STACK_LINE(133)
		return HX_CSTRING("<root>");
	}
	else{
		HX_STACK_LINE(133)
		return this->relPath;
	}
	HX_STACK_LINE(133)
	return null();
}


bool EmbedEntry_obj::exists( ::String name){
	HX_STACK_FRAME("hxd.res._EmbedFileSystem.EmbedEntry","exists",0x2505a750,"hxd.res._EmbedFileSystem.EmbedEntry.exists","hxd/res/EmbedFileSystem.hx",137,0xdf76ecc4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(137)
	return this->fs->exists((  (((this->relPath == null()))) ? ::String(name) : ::String(((this->relPath + HX_CSTRING("/")) + name)) ));
}


::hxd::res::FileEntry EmbedEntry_obj::get( ::String name){
	HX_STACK_FRAME("hxd.res._EmbedFileSystem.EmbedEntry","get",0x385746a2,"hxd.res._EmbedFileSystem.EmbedEntry.get","hxd/res/EmbedFileSystem.hx",141,0xdf76ecc4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(141)
	return hx::TCast< ::hxd::res::_EmbedFileSystem::EmbedEntry >::cast(this->fs->get((  (((this->relPath == null()))) ? ::String(name) : ::String(((this->relPath + HX_CSTRING("/")) + name)) )));
}


int EmbedEntry_obj::get_size( ){
	HX_STACK_FRAME("hxd.res._EmbedFileSystem.EmbedEntry","get_size",0xecc02abe,"hxd.res._EmbedFileSystem.EmbedEntry.get_size","hxd/res/EmbedFileSystem.hx",144,0xdf76ecc4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(149)
	this->open();
	HX_STACK_LINE(150)
	return this->bytes->length;
}


::hxd::impl::ArrayIterator EmbedEntry_obj::iterator( ){
	HX_STACK_FRAME("hxd.res._EmbedFileSystem.EmbedEntry","iterator",0xb44c1862,"hxd.res._EmbedFileSystem.EmbedEntry.iterator","hxd/res/EmbedFileSystem.hx",154,0xdf76ecc4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(155)
	Array< ::Dynamic > _g = this->fs->subFiles(this->relPath);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(155)
	return ::hxd::impl::ArrayIterator_obj::__new(_g);
}



EmbedEntry_obj::EmbedEntry_obj()
{
}

void EmbedEntry_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(EmbedEntry);
	HX_MARK_MEMBER_NAME(fs,"fs");
	HX_MARK_MEMBER_NAME(relPath,"relPath");
	HX_MARK_MEMBER_NAME(data,"data");
	HX_MARK_MEMBER_NAME(bytes,"bytes");
	HX_MARK_MEMBER_NAME(readPos,"readPos");
	::hxd::res::FileEntry_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void EmbedEntry_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(fs,"fs");
	HX_VISIT_MEMBER_NAME(relPath,"relPath");
	HX_VISIT_MEMBER_NAME(data,"data");
	HX_VISIT_MEMBER_NAME(bytes,"bytes");
	HX_VISIT_MEMBER_NAME(readPos,"readPos");
	::hxd::res::FileEntry_obj::__Visit(HX_VISIT_ARG);
}

Dynamic EmbedEntry_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"fs") ) { return fs; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"get") ) { return get_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"data") ) { return data; }
		if (HX_FIELD_EQ(inName,"open") ) { return open_dyn(); }
		if (HX_FIELD_EQ(inName,"skip") ) { return skip_dyn(); }
		if (HX_FIELD_EQ(inName,"read") ) { return read_dyn(); }
		if (HX_FIELD_EQ(inName,"load") ) { return load_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"bytes") ) { return bytes; }
		if (HX_FIELD_EQ(inName,"close") ) { return close_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"exists") ) { return exists_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"relPath") ) { return relPath; }
		if (HX_FIELD_EQ(inName,"readPos") ) { return readPos; }
		if (HX_FIELD_EQ(inName,"getSign") ) { return getSign_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"getBytes") ) { return getBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"readByte") ) { return readByte_dyn(); }
		if (HX_FIELD_EQ(inName,"get_path") ) { return get_path_dyn(); }
		if (HX_FIELD_EQ(inName,"get_size") ) { return get_size_dyn(); }
		if (HX_FIELD_EQ(inName,"iterator") ) { return iterator_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"loadBitmap") ) { return loadBitmap_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"get_isDirectory") ) { return get_isDirectory_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic EmbedEntry_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"fs") ) { fs=inValue.Cast< ::hxd::res::EmbedFileSystem >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"data") ) { data=inValue.Cast< ::String >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"bytes") ) { bytes=inValue.Cast< ::haxe::io::Bytes >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"relPath") ) { relPath=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"readPos") ) { readPos=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void EmbedEntry_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("fs"));
	outFields->push(HX_CSTRING("relPath"));
	outFields->push(HX_CSTRING("data"));
	outFields->push(HX_CSTRING("bytes"));
	outFields->push(HX_CSTRING("readPos"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::hxd::res::EmbedFileSystem*/ ,(int)offsetof(EmbedEntry_obj,fs),HX_CSTRING("fs")},
	{hx::fsString,(int)offsetof(EmbedEntry_obj,relPath),HX_CSTRING("relPath")},
	{hx::fsString,(int)offsetof(EmbedEntry_obj,data),HX_CSTRING("data")},
	{hx::fsObject /*::haxe::io::Bytes*/ ,(int)offsetof(EmbedEntry_obj,bytes),HX_CSTRING("bytes")},
	{hx::fsInt,(int)offsetof(EmbedEntry_obj,readPos),HX_CSTRING("readPos")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("fs"),
	HX_CSTRING("relPath"),
	HX_CSTRING("data"),
	HX_CSTRING("bytes"),
	HX_CSTRING("readPos"),
	HX_CSTRING("getSign"),
	HX_CSTRING("getBytes"),
	HX_CSTRING("open"),
	HX_CSTRING("skip"),
	HX_CSTRING("readByte"),
	HX_CSTRING("read"),
	HX_CSTRING("close"),
	HX_CSTRING("load"),
	HX_CSTRING("loadBitmap"),
	HX_CSTRING("get_isDirectory"),
	HX_CSTRING("get_path"),
	HX_CSTRING("exists"),
	HX_CSTRING("get"),
	HX_CSTRING("get_size"),
	HX_CSTRING("iterator"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(EmbedEntry_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(EmbedEntry_obj::__mClass,"__mClass");
};

#endif

Class EmbedEntry_obj::__mClass;

void EmbedEntry_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.res._EmbedFileSystem.EmbedEntry"), hx::TCanCast< EmbedEntry_obj> ,sStaticFields,sMemberFields,
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

void EmbedEntry_obj::__boot()
{
}

} // end namespace hxd
} // end namespace res
} // end namespace _EmbedFileSystem
