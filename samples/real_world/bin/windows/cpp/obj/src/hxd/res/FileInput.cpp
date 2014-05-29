#include <hxcpp.h>

#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_haxe_io_Input
#include <haxe/io/Input.h>
#endif
#ifndef INCLUDED_hxd_res_FileEntry
#include <hxd/res/FileEntry.h>
#endif
#ifndef INCLUDED_hxd_res_FileInput
#include <hxd/res/FileInput.h>
#endif
namespace hxd{
namespace res{

Void FileInput_obj::__construct(::hxd::res::FileEntry f)
{
HX_STACK_FRAME("hxd.res.FileInput","new",0x24de0498,"hxd.res.FileInput.new","hxd/res/FileInput.hx",7,0xbc3de55a)
HX_STACK_THIS(this)
HX_STACK_ARG(f,"f")
{
	HX_STACK_LINE(8)
	this->f = f;
	HX_STACK_LINE(9)
	f->open();
}
;
	return null();
}

//FileInput_obj::~FileInput_obj() { }

Dynamic FileInput_obj::__CreateEmpty() { return  new FileInput_obj; }
hx::ObjectPtr< FileInput_obj > FileInput_obj::__new(::hxd::res::FileEntry f)
{  hx::ObjectPtr< FileInput_obj > result = new FileInput_obj();
	result->__construct(f);
	return result;}

Dynamic FileInput_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< FileInput_obj > result = new FileInput_obj();
	result->__construct(inArgs[0]);
	return result;}

Void FileInput_obj::skip( int nbytes){
{
		HX_STACK_FRAME("hxd.res.FileInput","skip",0x20b89347,"hxd.res.FileInput.skip","hxd/res/FileInput.hx",13,0xbc3de55a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(nbytes,"nbytes")
		HX_STACK_LINE(13)
		this->f->skip(nbytes);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(FileInput_obj,skip,(void))

int FileInput_obj::readByte( ){
	HX_STACK_FRAME("hxd.res.FileInput","readByte",0x83107a46,"hxd.res.FileInput.readByte","hxd/res/FileInput.hx",17,0xbc3de55a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(17)
	return this->f->readByte();
}


int FileInput_obj::readBytes( ::haxe::io::Bytes b,int pos,int len){
	HX_STACK_FRAME("hxd.res.FileInput","readBytes",0x2b5a836d,"hxd.res.FileInput.readBytes","hxd/res/FileInput.hx",20,0xbc3de55a)
	HX_STACK_THIS(this)
	HX_STACK_ARG(b,"b")
	HX_STACK_ARG(pos,"pos")
	HX_STACK_ARG(len,"len")
	HX_STACK_LINE(21)
	this->f->read(b,pos,len);
	HX_STACK_LINE(22)
	return len;
}


Void FileInput_obj::close( ){
{
		HX_STACK_FRAME("hxd.res.FileInput","close",0x4b0cc9f0,"hxd.res.FileInput.close","hxd/res/FileInput.hx",26,0xbc3de55a)
		HX_STACK_THIS(this)
		HX_STACK_LINE(26)
		this->f->close();
	}
return null();
}



FileInput_obj::FileInput_obj()
{
}

void FileInput_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(FileInput);
	HX_MARK_MEMBER_NAME(f,"f");
	HX_MARK_END_CLASS();
}

void FileInput_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(f,"f");
}

Dynamic FileInput_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"f") ) { return f; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"skip") ) { return skip_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"close") ) { return close_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"readByte") ) { return readByte_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"readBytes") ) { return readBytes_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic FileInput_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"f") ) { f=inValue.Cast< ::hxd::res::FileEntry >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void FileInput_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("f"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::hxd::res::FileEntry*/ ,(int)offsetof(FileInput_obj,f),HX_CSTRING("f")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("f"),
	HX_CSTRING("skip"),
	HX_CSTRING("readByte"),
	HX_CSTRING("readBytes"),
	HX_CSTRING("close"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FileInput_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FileInput_obj::__mClass,"__mClass");
};

#endif

Class FileInput_obj::__mClass;

void FileInput_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.res.FileInput"), hx::TCanCast< FileInput_obj> ,sStaticFields,sMemberFields,
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

void FileInput_obj::__boot()
{
}

} // end namespace hxd
} // end namespace res
