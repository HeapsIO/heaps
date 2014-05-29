#include <hxcpp.h>

#ifndef INCLUDED_flash_display_BitmapData
#include <flash/display/BitmapData.h>
#endif
#ifndef INCLUDED_flash_display_IBitmapDrawable
#include <flash/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_haxe_Timer
#include <haxe/Timer.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_hxd_impl_ArrayIterator
#include <hxd/impl/ArrayIterator.h>
#endif
#ifndef INCLUDED_hxd_res_BytesFileEntry
#include <hxd/res/BytesFileEntry.h>
#endif
#ifndef INCLUDED_hxd_res_FileEntry
#include <hxd/res/FileEntry.h>
#endif
namespace hxd{
namespace res{

Void BytesFileEntry_obj::__construct(::String path,::haxe::io::Bytes bytes)
{
HX_STACK_FRAME("hxd.res.BytesFileEntry","new",0x6913b125,"hxd.res.BytesFileEntry.new","hxd/res/BytesFileSystem.hx",9,0x3543bef2)
HX_STACK_THIS(this)
HX_STACK_ARG(path,"path")
HX_STACK_ARG(bytes,"bytes")
{
	HX_STACK_LINE(10)
	this->fullPath = path;
	HX_STACK_LINE(11)
	::String _g = path.split(HX_CSTRING("/"))->pop();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(11)
	this->name = _g;
	HX_STACK_LINE(12)
	this->bytes = bytes;
}
;
	return null();
}

//BytesFileEntry_obj::~BytesFileEntry_obj() { }

Dynamic BytesFileEntry_obj::__CreateEmpty() { return  new BytesFileEntry_obj; }
hx::ObjectPtr< BytesFileEntry_obj > BytesFileEntry_obj::__new(::String path,::haxe::io::Bytes bytes)
{  hx::ObjectPtr< BytesFileEntry_obj > result = new BytesFileEntry_obj();
	result->__construct(path,bytes);
	return result;}

Dynamic BytesFileEntry_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< BytesFileEntry_obj > result = new BytesFileEntry_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

::String BytesFileEntry_obj::get_path( ){
	HX_STACK_FRAME("hxd.res.BytesFileEntry","get_path",0x020ed649,"hxd.res.BytesFileEntry.get_path","hxd/res/BytesFileSystem.hx",16,0x3543bef2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(16)
	return this->fullPath;
}


int BytesFileEntry_obj::getSign( ){
	HX_STACK_FRAME("hxd.res.BytesFileEntry","getSign",0x82f66738,"hxd.res.BytesFileEntry.getSign","hxd/res/BytesFileSystem.hx",20,0x3543bef2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(20)
	return (int((int((int(this->bytes->b->__get((int)0)) | int((int(this->bytes->b->__get((int)1)) << int((int)8))))) | int((int(this->bytes->b->__get((int)2)) << int((int)16))))) | int((int(this->bytes->b->__get((int)3)) << int((int)24))));
}


::haxe::io::Bytes BytesFileEntry_obj::getBytes( ){
	HX_STACK_FRAME("hxd.res.BytesFileEntry","getBytes",0x55714d10,"hxd.res.BytesFileEntry.getBytes","hxd/res/BytesFileSystem.hx",24,0x3543bef2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(24)
	return this->bytes;
}


Void BytesFileEntry_obj::open( ){
{
		HX_STACK_FRAME("hxd.res.BytesFileEntry","open",0x88d8cf65,"hxd.res.BytesFileEntry.open","hxd/res/BytesFileSystem.hx",28,0x3543bef2)
		HX_STACK_THIS(this)
		HX_STACK_LINE(28)
		this->pos = (int)0;
	}
return null();
}


Void BytesFileEntry_obj::skip( int nbytes){
{
		HX_STACK_FRAME("hxd.res.BytesFileEntry","skip",0x8b79e21a,"hxd.res.BytesFileEntry.skip","hxd/res/BytesFileSystem.hx",32,0x3543bef2)
		HX_STACK_THIS(this)
		HX_STACK_ARG(nbytes,"nbytes")
		HX_STACK_LINE(32)
		hx::AddEq(this->pos,nbytes);
	}
return null();
}


int BytesFileEntry_obj::readByte( ){
	HX_STACK_FRAME("hxd.res.BytesFileEntry","readByte",0xa11d2e99,"hxd.res.BytesFileEntry.readByte","hxd/res/BytesFileSystem.hx",35,0x3543bef2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(35)
	int pos = (this->pos)++;		HX_STACK_VAR(pos,"pos");
	HX_STACK_LINE(35)
	return this->bytes->b->__get(pos);
}


Void BytesFileEntry_obj::read( ::haxe::io::Bytes out,int pos,int size){
{
		HX_STACK_FRAME("hxd.res.BytesFileEntry","read",0x8acc16f1,"hxd.res.BytesFileEntry.read","hxd/res/BytesFileSystem.hx",38,0x3543bef2)
		HX_STACK_THIS(this)
		HX_STACK_ARG(out,"out")
		HX_STACK_ARG(pos,"pos")
		HX_STACK_ARG(size,"size")
		HX_STACK_LINE(39)
		out->blit(pos,this->bytes,this->pos,size);
		HX_STACK_LINE(40)
		hx::AddEq(this->pos,size);
	}
return null();
}


Void BytesFileEntry_obj::close( ){
{
		HX_STACK_FRAME("hxd.res.BytesFileEntry","close",0x497073bd,"hxd.res.BytesFileEntry.close","hxd/res/BytesFileSystem.hx",43,0x3543bef2)
		HX_STACK_THIS(this)
	}
return null();
}


Void BytesFileEntry_obj::load( Dynamic onReady){
{
		HX_STACK_FRAME("hxd.res.BytesFileEntry","load",0x86dc65c1,"hxd.res.BytesFileEntry.load","hxd/res/BytesFileSystem.hx",47,0x3543bef2)
		HX_STACK_THIS(this)
		HX_STACK_ARG(onReady,"onReady")
		HX_STACK_LINE(47)
		::haxe::Timer_obj::delay(onReady,(int)1);
	}
return null();
}


Void BytesFileEntry_obj::loadBitmap( Dynamic onLoaded){
{
		HX_STACK_FRAME("hxd.res.BytesFileEntry","loadBitmap",0x8b053090,"hxd.res.BytesFileEntry.loadBitmap","hxd/res/BytesFileSystem.hx",51,0x3543bef2)
		HX_STACK_THIS(this)
		HX_STACK_ARG(onLoaded,"onLoaded")
		HX_STACK_LINE(51)
		HX_STACK_DO_THROW(HX_CSTRING("TODO"));
	}
return null();
}


bool BytesFileEntry_obj::exists( ::String name){
	HX_STACK_FRAME("hxd.res.BytesFileEntry","exists",0xaa834637,"hxd.res.BytesFileEntry.exists","hxd/res/BytesFileSystem.hx",54,0x3543bef2)
	HX_STACK_THIS(this)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(54)
	return false;
}


::hxd::res::FileEntry BytesFileEntry_obj::get( ::String name){
	HX_STACK_FRAME("hxd.res.BytesFileEntry","get",0x690e615b,"hxd.res.BytesFileEntry.get","hxd/res/BytesFileSystem.hx",55,0x3543bef2)
	HX_STACK_THIS(this)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(55)
	return null();
}


::hxd::impl::ArrayIterator BytesFileEntry_obj::iterator( ){
	HX_STACK_FRAME("hxd.res.BytesFileEntry","iterator",0xcb9c7f09,"hxd.res.BytesFileEntry.iterator","hxd/res/BytesFileSystem.hx",57,0x3543bef2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(57)
	return ::hxd::impl::ArrayIterator_obj::__new(Array_obj< ::Dynamic >::__new());
}


int BytesFileEntry_obj::get_size( ){
	HX_STACK_FRAME("hxd.res.BytesFileEntry","get_size",0x04109165,"hxd.res.BytesFileEntry.get_size","hxd/res/BytesFileSystem.hx",59,0x3543bef2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(59)
	return this->bytes->length;
}



BytesFileEntry_obj::BytesFileEntry_obj()
{
}

void BytesFileEntry_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(BytesFileEntry);
	HX_MARK_MEMBER_NAME(fullPath,"fullPath");
	HX_MARK_MEMBER_NAME(bytes,"bytes");
	HX_MARK_MEMBER_NAME(pos,"pos");
	::hxd::res::FileEntry_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void BytesFileEntry_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(fullPath,"fullPath");
	HX_VISIT_MEMBER_NAME(bytes,"bytes");
	HX_VISIT_MEMBER_NAME(pos,"pos");
	::hxd::res::FileEntry_obj::__Visit(HX_VISIT_ARG);
}

Dynamic BytesFileEntry_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"pos") ) { return pos; }
		if (HX_FIELD_EQ(inName,"get") ) { return get_dyn(); }
		break;
	case 4:
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
		if (HX_FIELD_EQ(inName,"getSign") ) { return getSign_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"fullPath") ) { return fullPath; }
		if (HX_FIELD_EQ(inName,"get_path") ) { return get_path_dyn(); }
		if (HX_FIELD_EQ(inName,"getBytes") ) { return getBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"readByte") ) { return readByte_dyn(); }
		if (HX_FIELD_EQ(inName,"iterator") ) { return iterator_dyn(); }
		if (HX_FIELD_EQ(inName,"get_size") ) { return get_size_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"loadBitmap") ) { return loadBitmap_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic BytesFileEntry_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"pos") ) { pos=inValue.Cast< int >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"bytes") ) { bytes=inValue.Cast< ::haxe::io::Bytes >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"fullPath") ) { fullPath=inValue.Cast< ::String >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void BytesFileEntry_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("fullPath"));
	outFields->push(HX_CSTRING("bytes"));
	outFields->push(HX_CSTRING("pos"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsString,(int)offsetof(BytesFileEntry_obj,fullPath),HX_CSTRING("fullPath")},
	{hx::fsObject /*::haxe::io::Bytes*/ ,(int)offsetof(BytesFileEntry_obj,bytes),HX_CSTRING("bytes")},
	{hx::fsInt,(int)offsetof(BytesFileEntry_obj,pos),HX_CSTRING("pos")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("fullPath"),
	HX_CSTRING("bytes"),
	HX_CSTRING("pos"),
	HX_CSTRING("get_path"),
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
	HX_CSTRING("get_size"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(BytesFileEntry_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(BytesFileEntry_obj::__mClass,"__mClass");
};

#endif

Class BytesFileEntry_obj::__mClass;

void BytesFileEntry_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.res.BytesFileEntry"), hx::TCanCast< BytesFileEntry_obj> ,sStaticFields,sMemberFields,
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

void BytesFileEntry_obj::__boot()
{
}

} // end namespace hxd
} // end namespace res
