#include <hxcpp.h>

#ifndef INCLUDED_cpp_Lib
#include <cpp/Lib.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_haxe_io_Input
#include <haxe/io/Input.h>
#endif
#ifndef INCLUDED_haxe_io_Output
#include <haxe/io/Output.h>
#endif
#ifndef INCLUDED_sys_io_File
#include <sys/io/File.h>
#endif
#ifndef INCLUDED_sys_io_FileInput
#include <sys/io/FileInput.h>
#endif
#ifndef INCLUDED_sys_io_FileOutput
#include <sys/io/FileOutput.h>
#endif
namespace sys{
namespace io{

Void File_obj::__construct()
{
	return null();
}

//File_obj::~File_obj() { }

Dynamic File_obj::__CreateEmpty() { return  new File_obj; }
hx::ObjectPtr< File_obj > File_obj::__new()
{  hx::ObjectPtr< File_obj > result = new File_obj();
	result->__construct();
	return result;}

Dynamic File_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< File_obj > result = new File_obj();
	result->__construct();
	return result;}

::String File_obj::getContent( ::String path){
	HX_STACK_FRAME("sys.io.File","getContent",0xb28b4a0e,"sys.io.File.getContent","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/File.hx",27,0x1d9b26bb)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(28)
	::haxe::io::Bytes b = ::sys::io::File_obj::getBytes(path);		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(29)
	return b->toString();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(File_obj,getContent,return )

::haxe::io::Bytes File_obj::getBytes( ::String path){
	HX_STACK_FRAME("sys.io.File","getBytes",0xbe457600,"sys.io.File.getBytes","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/File.hx",32,0x1d9b26bb)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(33)
	Array< unsigned char > data = ::sys::io::File_obj::file_contents(path);		HX_STACK_VAR(data,"data");
	HX_STACK_LINE(34)
	return ::haxe::io::Bytes_obj::ofData(data);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(File_obj,getBytes,return )

Void File_obj::saveContent( ::String path,::String content){
{
		HX_STACK_FRAME("sys.io.File","saveContent",0xa5557651,"sys.io.File.saveContent","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/File.hx",37,0x1d9b26bb)
		HX_STACK_ARG(path,"path")
		HX_STACK_ARG(content,"content")
		HX_STACK_LINE(38)
		::sys::io::FileOutput f = ::sys::io::File_obj::write(path,null());		HX_STACK_VAR(f,"f");
		HX_STACK_LINE(39)
		f->writeString(content);
		HX_STACK_LINE(40)
		f->close();
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(File_obj,saveContent,(void))

Void File_obj::saveBytes( ::String path,::haxe::io::Bytes bytes){
{
		HX_STACK_FRAME("sys.io.File","saveBytes",0x6700fb83,"sys.io.File.saveBytes","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/File.hx",43,0x1d9b26bb)
		HX_STACK_ARG(path,"path")
		HX_STACK_ARG(bytes,"bytes")
		HX_STACK_LINE(44)
		::sys::io::FileOutput f = ::sys::io::File_obj::write(path,null());		HX_STACK_VAR(f,"f");
		HX_STACK_LINE(45)
		f->write(bytes);
		HX_STACK_LINE(46)
		f->close();
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(File_obj,saveBytes,(void))

::sys::io::FileInput File_obj::read( ::String path,hx::Null< bool >  __o_binary){
bool binary = __o_binary.Default(true);
	HX_STACK_FRAME("sys.io.File","read",0x203d07e1,"sys.io.File.read","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/File.hx",49,0x1d9b26bb)
	HX_STACK_ARG(path,"path")
	HX_STACK_ARG(binary,"binary")
{
		HX_STACK_LINE(50)
		Dynamic _g = ::sys::io::File_obj::file_open(path,(  ((binary)) ? ::String(HX_CSTRING("rb")) : ::String(HX_CSTRING("r")) ));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(50)
		return ::sys::io::FileInput_obj::__new(_g);
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(File_obj,read,return )

::sys::io::FileOutput File_obj::write( ::String path,hx::Null< bool >  __o_binary){
bool binary = __o_binary.Default(true);
	HX_STACK_FRAME("sys.io.File","write",0xfec8a9f4,"sys.io.File.write","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/File.hx",53,0x1d9b26bb)
	HX_STACK_ARG(path,"path")
	HX_STACK_ARG(binary,"binary")
{
		HX_STACK_LINE(54)
		Dynamic _g = ::sys::io::File_obj::file_open(path,(  ((binary)) ? ::String(HX_CSTRING("wb")) : ::String(HX_CSTRING("w")) ));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(54)
		return ::sys::io::FileOutput_obj::__new(_g);
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(File_obj,write,return )

::sys::io::FileOutput File_obj::append( ::String path,hx::Null< bool >  __o_binary){
bool binary = __o_binary.Default(true);
	HX_STACK_FRAME("sys.io.File","append",0x02ba1725,"sys.io.File.append","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/File.hx",57,0x1d9b26bb)
	HX_STACK_ARG(path,"path")
	HX_STACK_ARG(binary,"binary")
{
		HX_STACK_LINE(58)
		Dynamic _g = ::sys::io::File_obj::file_open(path,(  ((binary)) ? ::String(HX_CSTRING("ab")) : ::String(HX_CSTRING("a")) ));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(58)
		return ::sys::io::FileOutput_obj::__new(_g);
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(File_obj,append,return )

Void File_obj::copy( ::String srcPath,::String dstPath){
{
		HX_STACK_FRAME("sys.io.File","copy",0x165a7840,"sys.io.File.copy","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/File.hx",61,0x1d9b26bb)
		HX_STACK_ARG(srcPath,"srcPath")
		HX_STACK_ARG(dstPath,"dstPath")
		HX_STACK_LINE(62)
		::sys::io::FileInput s = ::sys::io::File_obj::read(srcPath,true);		HX_STACK_VAR(s,"s");
		HX_STACK_LINE(63)
		::sys::io::FileOutput d = ::sys::io::File_obj::write(dstPath,true);		HX_STACK_VAR(d,"d");
		HX_STACK_LINE(64)
		d->writeInput(s,null());
		HX_STACK_LINE(65)
		s->close();
		HX_STACK_LINE(66)
		d->close();
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(File_obj,copy,(void))

Dynamic File_obj::file_contents;

Dynamic File_obj::file_open;


File_obj::File_obj()
{
}

Dynamic File_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"read") ) { return read_dyn(); }
		if (HX_FIELD_EQ(inName,"copy") ) { return copy_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"write") ) { return write_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"append") ) { return append_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"getBytes") ) { return getBytes_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"saveBytes") ) { return saveBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"file_open") ) { return file_open; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"getContent") ) { return getContent_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"saveContent") ) { return saveContent_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"file_contents") ) { return file_contents; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic File_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 9:
		if (HX_FIELD_EQ(inName,"file_open") ) { file_open=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"file_contents") ) { file_contents=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void File_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("getContent"),
	HX_CSTRING("getBytes"),
	HX_CSTRING("saveContent"),
	HX_CSTRING("saveBytes"),
	HX_CSTRING("read"),
	HX_CSTRING("write"),
	HX_CSTRING("append"),
	HX_CSTRING("copy"),
	HX_CSTRING("file_contents"),
	HX_CSTRING("file_open"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(File_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(File_obj::file_contents,"file_contents");
	HX_MARK_MEMBER_NAME(File_obj::file_open,"file_open");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(File_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(File_obj::file_contents,"file_contents");
	HX_VISIT_MEMBER_NAME(File_obj::file_open,"file_open");
};

#endif

Class File_obj::__mClass;

void File_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("sys.io.File"), hx::TCanCast< File_obj> ,sStaticFields,sMemberFields,
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

void File_obj::__boot()
{
	file_contents= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("file_contents"),(int)1);
	file_open= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("file_open"),(int)2);
}

} // end namespace sys
} // end namespace io
