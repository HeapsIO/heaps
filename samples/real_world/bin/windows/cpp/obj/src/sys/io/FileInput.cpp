#include <hxcpp.h>

#ifndef INCLUDED_cpp_Lib
#include <cpp/Lib.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_haxe_io_Eof
#include <haxe/io/Eof.h>
#endif
#ifndef INCLUDED_haxe_io_Error
#include <haxe/io/Error.h>
#endif
#ifndef INCLUDED_haxe_io_Input
#include <haxe/io/Input.h>
#endif
#ifndef INCLUDED_sys_io_FileInput
#include <sys/io/FileInput.h>
#endif
#ifndef INCLUDED_sys_io_FileSeek
#include <sys/io/FileSeek.h>
#endif
namespace sys{
namespace io{

Void FileInput_obj::__construct(Dynamic f)
{
HX_STACK_FRAME("sys.io.FileInput","new",0x565591b9,"sys.io.FileInput.new","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/FileInput.hx",31,0x7ea163f7)
HX_STACK_THIS(this)
HX_STACK_ARG(f,"f")
{
	HX_STACK_LINE(31)
	this->__f = f;
}
;
	return null();
}

//FileInput_obj::~FileInput_obj() { }

Dynamic FileInput_obj::__CreateEmpty() { return  new FileInput_obj; }
hx::ObjectPtr< FileInput_obj > FileInput_obj::__new(Dynamic f)
{  hx::ObjectPtr< FileInput_obj > result = new FileInput_obj();
	result->__construct(f);
	return result;}

Dynamic FileInput_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< FileInput_obj > result = new FileInput_obj();
	result->__construct(inArgs[0]);
	return result;}

int FileInput_obj::readByte( ){
	HX_STACK_FRAME("sys.io.FileInput","readByte",0x25e0b585,"sys.io.FileInput.readByte","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/FileInput.hx",35,0x7ea163f7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(35)
	try
	{
	HX_STACK_CATCHABLE(Dynamic, 0);
	{
		HX_STACK_LINE(36)
		return ::sys::io::FileInput_obj::file_read_char(this->__f);
	}
	}
	catch(Dynamic __e){
		{
			HX_STACK_BEGIN_CATCH
			Dynamic e = __e;{
				HX_STACK_LINE(38)
				if ((e->__IsArray())){
					HX_STACK_LINE(39)
					HX_STACK_DO_THROW(::haxe::io::Eof_obj::__new());
				}
				else{
					HX_STACK_LINE(41)
					HX_STACK_DO_THROW(::haxe::io::Error_obj::Custom(e));
				}
			}
		}
	}
	HX_STACK_LINE(35)
	return (int)0;
}


int FileInput_obj::readBytes( ::haxe::io::Bytes s,int p,int l){
	HX_STACK_FRAME("sys.io.FileInput","readBytes",0xfebe1f4e,"sys.io.FileInput.readBytes","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/FileInput.hx",46,0x7ea163f7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(s,"s")
	HX_STACK_ARG(p,"p")
	HX_STACK_ARG(l,"l")
	HX_STACK_LINE(46)
	try
	{
	HX_STACK_CATCHABLE(Dynamic, 0);
	{
		HX_STACK_LINE(47)
		return ::sys::io::FileInput_obj::file_read(this->__f,s->b,p,l);
	}
	}
	catch(Dynamic __e){
		{
			HX_STACK_BEGIN_CATCH
			Dynamic e = __e;{
				HX_STACK_LINE(49)
				if ((e->__IsArray())){
					HX_STACK_LINE(50)
					HX_STACK_DO_THROW(::haxe::io::Eof_obj::__new());
				}
				else{
					HX_STACK_LINE(52)
					HX_STACK_DO_THROW(::haxe::io::Error_obj::Custom(e));
				}
			}
		}
	}
	HX_STACK_LINE(46)
	return (int)0;
}


Void FileInput_obj::close( ){
{
		HX_STACK_FRAME("sys.io.FileInput","close",0x735aa151,"sys.io.FileInput.close","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/FileInput.hx",56,0x7ea163f7)
		HX_STACK_THIS(this)
		HX_STACK_LINE(57)
		this->super::close();
		HX_STACK_LINE(58)
		::sys::io::FileInput_obj::file_close(this->__f);
	}
return null();
}


Void FileInput_obj::seek( int p,::sys::io::FileSeek pos){
{
		HX_STACK_FRAME("sys.io.FileInput","seek",0x37d7f1ff,"sys.io.FileInput.seek","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/FileInput.hx",62,0x7ea163f7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(p,"p")
		HX_STACK_ARG(pos,"pos")
		HX_STACK_LINE(62)
		::sys::io::FileInput_obj::file_seek(this->__f,p,(  (((pos == ::sys::io::FileSeek_obj::SeekBegin))) ? int((int)0) : int((  (((pos == ::sys::io::FileSeek_obj::SeekCur))) ? int((int)1) : int((int)2) )) ));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(FileInput_obj,seek,(void))

int FileInput_obj::tell( ){
	HX_STACK_FRAME("sys.io.FileInput","tell",0x38812eb8,"sys.io.FileInput.tell","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/FileInput.hx",66,0x7ea163f7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(66)
	return ::sys::io::FileInput_obj::file_tell(this->__f);
}


HX_DEFINE_DYNAMIC_FUNC0(FileInput_obj,tell,return )

bool FileInput_obj::eof( ){
	HX_STACK_FRAME("sys.io.FileInput","eof",0x564ec615,"sys.io.FileInput.eof","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/FileInput.hx",71,0x7ea163f7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(71)
	return ::sys::io::FileInput_obj::file_eof(this->__f);
}


HX_DEFINE_DYNAMIC_FUNC0(FileInput_obj,eof,return )

Dynamic FileInput_obj::file_eof;

Dynamic FileInput_obj::file_read;

Dynamic FileInput_obj::file_read_char;

Dynamic FileInput_obj::file_close;

Dynamic FileInput_obj::file_seek;

Dynamic FileInput_obj::file_tell;


FileInput_obj::FileInput_obj()
{
}

void FileInput_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(FileInput);
	HX_MARK_MEMBER_NAME(__f,"__f");
	HX_MARK_END_CLASS();
}

void FileInput_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(__f,"__f");
}

Dynamic FileInput_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"__f") ) { return __f; }
		if (HX_FIELD_EQ(inName,"eof") ) { return eof_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"seek") ) { return seek_dyn(); }
		if (HX_FIELD_EQ(inName,"tell") ) { return tell_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"close") ) { return close_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"file_eof") ) { return file_eof; }
		if (HX_FIELD_EQ(inName,"readByte") ) { return readByte_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"file_read") ) { return file_read; }
		if (HX_FIELD_EQ(inName,"file_seek") ) { return file_seek; }
		if (HX_FIELD_EQ(inName,"file_tell") ) { return file_tell; }
		if (HX_FIELD_EQ(inName,"readBytes") ) { return readBytes_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"file_close") ) { return file_close; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"file_read_char") ) { return file_read_char; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic FileInput_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"__f") ) { __f=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"file_eof") ) { file_eof=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"file_read") ) { file_read=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"file_seek") ) { file_seek=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"file_tell") ) { file_tell=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"file_close") ) { file_close=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"file_read_char") ) { file_read_char=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void FileInput_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("__f"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("file_eof"),
	HX_CSTRING("file_read"),
	HX_CSTRING("file_read_char"),
	HX_CSTRING("file_close"),
	HX_CSTRING("file_seek"),
	HX_CSTRING("file_tell"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(FileInput_obj,__f),HX_CSTRING("__f")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("__f"),
	HX_CSTRING("readByte"),
	HX_CSTRING("readBytes"),
	HX_CSTRING("close"),
	HX_CSTRING("seek"),
	HX_CSTRING("tell"),
	HX_CSTRING("eof"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FileInput_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(FileInput_obj::file_eof,"file_eof");
	HX_MARK_MEMBER_NAME(FileInput_obj::file_read,"file_read");
	HX_MARK_MEMBER_NAME(FileInput_obj::file_read_char,"file_read_char");
	HX_MARK_MEMBER_NAME(FileInput_obj::file_close,"file_close");
	HX_MARK_MEMBER_NAME(FileInput_obj::file_seek,"file_seek");
	HX_MARK_MEMBER_NAME(FileInput_obj::file_tell,"file_tell");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FileInput_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(FileInput_obj::file_eof,"file_eof");
	HX_VISIT_MEMBER_NAME(FileInput_obj::file_read,"file_read");
	HX_VISIT_MEMBER_NAME(FileInput_obj::file_read_char,"file_read_char");
	HX_VISIT_MEMBER_NAME(FileInput_obj::file_close,"file_close");
	HX_VISIT_MEMBER_NAME(FileInput_obj::file_seek,"file_seek");
	HX_VISIT_MEMBER_NAME(FileInput_obj::file_tell,"file_tell");
};

#endif

Class FileInput_obj::__mClass;

void FileInput_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("sys.io.FileInput"), hx::TCanCast< FileInput_obj> ,sStaticFields,sMemberFields,
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
	file_eof= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("file_eof"),(int)1);
	file_read= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("file_read"),(int)4);
	file_read_char= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("file_read_char"),(int)1);
	file_close= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("file_close"),(int)1);
	file_seek= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("file_seek"),(int)3);
	file_tell= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("file_tell"),(int)1);
}

} // end namespace sys
} // end namespace io
