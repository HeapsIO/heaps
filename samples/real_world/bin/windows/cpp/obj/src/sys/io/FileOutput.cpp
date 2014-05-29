#include <hxcpp.h>

#ifndef INCLUDED_cpp_Lib
#include <cpp/Lib.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_haxe_io_Error
#include <haxe/io/Error.h>
#endif
#ifndef INCLUDED_haxe_io_Output
#include <haxe/io/Output.h>
#endif
#ifndef INCLUDED_sys_io_FileOutput
#include <sys/io/FileOutput.h>
#endif
#ifndef INCLUDED_sys_io_FileSeek
#include <sys/io/FileSeek.h>
#endif
namespace sys{
namespace io{

Void FileOutput_obj::__construct(Dynamic f)
{
HX_STACK_FRAME("sys.io.FileOutput","new",0x19e22a16,"sys.io.FileOutput.new","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/FileOutput.hx",31,0x38ac29fa)
HX_STACK_THIS(this)
HX_STACK_ARG(f,"f")
{
	HX_STACK_LINE(31)
	this->__f = f;
}
;
	return null();
}

//FileOutput_obj::~FileOutput_obj() { }

Dynamic FileOutput_obj::__CreateEmpty() { return  new FileOutput_obj; }
hx::ObjectPtr< FileOutput_obj > FileOutput_obj::__new(Dynamic f)
{  hx::ObjectPtr< FileOutput_obj > result = new FileOutput_obj();
	result->__construct(f);
	return result;}

Dynamic FileOutput_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< FileOutput_obj > result = new FileOutput_obj();
	result->__construct(inArgs[0]);
	return result;}

Void FileOutput_obj::writeByte( int c){
{
		HX_STACK_FRAME("sys.io.FileOutput","writeByte",0x887099bd,"sys.io.FileOutput.writeByte","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/FileOutput.hx",35,0x38ac29fa)
		HX_STACK_THIS(this)
		HX_STACK_ARG(c,"c")
		HX_STACK_LINE(35)
		try
		{
		HX_STACK_CATCHABLE(Dynamic, 0);
		{
			HX_STACK_LINE(35)
			::sys::io::FileOutput_obj::file_write_char(this->__f,c);
		}
		}
		catch(Dynamic __e){
			{
				HX_STACK_BEGIN_CATCH
				Dynamic e = __e;{
					HX_STACK_LINE(35)
					HX_STACK_DO_THROW(::haxe::io::Error_obj::Custom(e));
				}
			}
		}
	}
return null();
}


int FileOutput_obj::writeBytes( ::haxe::io::Bytes s,int p,int l){
	HX_STACK_FRAME("sys.io.FileOutput","writeBytes",0xda15ec16,"sys.io.FileOutput.writeBytes","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/FileOutput.hx",39,0x38ac29fa)
	HX_STACK_THIS(this)
	HX_STACK_ARG(s,"s")
	HX_STACK_ARG(p,"p")
	HX_STACK_ARG(l,"l")
	HX_STACK_LINE(39)
	try
	{
	HX_STACK_CATCHABLE(Dynamic, 0);
	{
		HX_STACK_LINE(39)
		return ::sys::io::FileOutput_obj::file_write(this->__f,s->b,p,l);
	}
	}
	catch(Dynamic __e){
		{
			HX_STACK_BEGIN_CATCH
			Dynamic e = __e;{
				HX_STACK_LINE(39)
				HX_STACK_DO_THROW(::haxe::io::Error_obj::Custom(e));
			}
		}
	}
	HX_STACK_LINE(39)
	return (int)0;
}


Void FileOutput_obj::flush( ){
{
		HX_STACK_FRAME("sys.io.FileOutput","flush",0x5fbc15fa,"sys.io.FileOutput.flush","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/FileOutput.hx",43,0x38ac29fa)
		HX_STACK_THIS(this)
		HX_STACK_LINE(43)
		::sys::io::FileOutput_obj::file_flush(this->__f);
	}
return null();
}


Void FileOutput_obj::close( ){
{
		HX_STACK_FRAME("sys.io.FileOutput","close",0xa583caee,"sys.io.FileOutput.close","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/FileOutput.hx",46,0x38ac29fa)
		HX_STACK_THIS(this)
		HX_STACK_LINE(47)
		this->super::close();
		HX_STACK_LINE(48)
		::sys::io::FileOutput_obj::file_close(this->__f);
	}
return null();
}


Void FileOutput_obj::seek( int p,::sys::io::FileSeek pos){
{
		HX_STACK_FRAME("sys.io.FileOutput","seek",0x8f50ab02,"sys.io.FileOutput.seek","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/FileOutput.hx",52,0x38ac29fa)
		HX_STACK_THIS(this)
		HX_STACK_ARG(p,"p")
		HX_STACK_ARG(pos,"pos")
		HX_STACK_LINE(52)
		::sys::io::FileOutput_obj::file_seek(this->__f,p,(  (((pos == ::sys::io::FileSeek_obj::SeekBegin))) ? int((int)0) : int((  (((pos == ::sys::io::FileSeek_obj::SeekCur))) ? int((int)1) : int((int)2) )) ));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(FileOutput_obj,seek,(void))

int FileOutput_obj::tell( ){
	HX_STACK_FRAME("sys.io.FileOutput","tell",0x8ff9e7bb,"sys.io.FileOutput.tell","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/FileOutput.hx",56,0x38ac29fa)
	HX_STACK_THIS(this)
	HX_STACK_LINE(56)
	return ::sys::io::FileOutput_obj::file_tell(this->__f);
}


HX_DEFINE_DYNAMIC_FUNC0(FileOutput_obj,tell,return )

Dynamic FileOutput_obj::file_close;

Dynamic FileOutput_obj::file_seek;

Dynamic FileOutput_obj::file_tell;

Dynamic FileOutput_obj::file_flush;

Dynamic FileOutput_obj::file_write;

Dynamic FileOutput_obj::file_write_char;


FileOutput_obj::FileOutput_obj()
{
}

void FileOutput_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(FileOutput);
	HX_MARK_MEMBER_NAME(__f,"__f");
	HX_MARK_END_CLASS();
}

void FileOutput_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(__f,"__f");
}

Dynamic FileOutput_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"__f") ) { return __f; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"seek") ) { return seek_dyn(); }
		if (HX_FIELD_EQ(inName,"tell") ) { return tell_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"flush") ) { return flush_dyn(); }
		if (HX_FIELD_EQ(inName,"close") ) { return close_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"file_seek") ) { return file_seek; }
		if (HX_FIELD_EQ(inName,"file_tell") ) { return file_tell; }
		if (HX_FIELD_EQ(inName,"writeByte") ) { return writeByte_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"file_close") ) { return file_close; }
		if (HX_FIELD_EQ(inName,"file_flush") ) { return file_flush; }
		if (HX_FIELD_EQ(inName,"file_write") ) { return file_write; }
		if (HX_FIELD_EQ(inName,"writeBytes") ) { return writeBytes_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"file_write_char") ) { return file_write_char; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic FileOutput_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"__f") ) { __f=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"file_seek") ) { file_seek=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"file_tell") ) { file_tell=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"file_close") ) { file_close=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"file_flush") ) { file_flush=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"file_write") ) { file_write=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"file_write_char") ) { file_write_char=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void FileOutput_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("__f"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("file_close"),
	HX_CSTRING("file_seek"),
	HX_CSTRING("file_tell"),
	HX_CSTRING("file_flush"),
	HX_CSTRING("file_write"),
	HX_CSTRING("file_write_char"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(FileOutput_obj,__f),HX_CSTRING("__f")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("__f"),
	HX_CSTRING("writeByte"),
	HX_CSTRING("writeBytes"),
	HX_CSTRING("flush"),
	HX_CSTRING("close"),
	HX_CSTRING("seek"),
	HX_CSTRING("tell"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FileOutput_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(FileOutput_obj::file_close,"file_close");
	HX_MARK_MEMBER_NAME(FileOutput_obj::file_seek,"file_seek");
	HX_MARK_MEMBER_NAME(FileOutput_obj::file_tell,"file_tell");
	HX_MARK_MEMBER_NAME(FileOutput_obj::file_flush,"file_flush");
	HX_MARK_MEMBER_NAME(FileOutput_obj::file_write,"file_write");
	HX_MARK_MEMBER_NAME(FileOutput_obj::file_write_char,"file_write_char");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FileOutput_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(FileOutput_obj::file_close,"file_close");
	HX_VISIT_MEMBER_NAME(FileOutput_obj::file_seek,"file_seek");
	HX_VISIT_MEMBER_NAME(FileOutput_obj::file_tell,"file_tell");
	HX_VISIT_MEMBER_NAME(FileOutput_obj::file_flush,"file_flush");
	HX_VISIT_MEMBER_NAME(FileOutput_obj::file_write,"file_write");
	HX_VISIT_MEMBER_NAME(FileOutput_obj::file_write_char,"file_write_char");
};

#endif

Class FileOutput_obj::__mClass;

void FileOutput_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("sys.io.FileOutput"), hx::TCanCast< FileOutput_obj> ,sStaticFields,sMemberFields,
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

void FileOutput_obj::__boot()
{
	file_close= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("file_close"),(int)1);
	file_seek= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("file_seek"),(int)3);
	file_tell= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("file_tell"),(int)1);
	file_flush= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("file_flush"),(int)1);
	file_write= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("file_write"),(int)4);
	file_write_char= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("file_write_char"),(int)2);
}

} // end namespace sys
} // end namespace io
