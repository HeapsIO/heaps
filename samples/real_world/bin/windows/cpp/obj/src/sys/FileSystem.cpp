#include <hxcpp.h>

#ifndef INCLUDED_Date
#include <Date.h>
#endif
#ifndef INCLUDED_cpp_Lib
#include <cpp/Lib.h>
#endif
#ifndef INCLUDED_haxe_io_Path
#include <haxe/io/Path.h>
#endif
#ifndef INCLUDED_sys_FileSystem
#include <sys/FileSystem.h>
#endif
#ifndef INCLUDED_sys__FileSystem_FileKind
#include <sys/_FileSystem/FileKind.h>
#endif
namespace sys{

Void FileSystem_obj::__construct()
{
	return null();
}

//FileSystem_obj::~FileSystem_obj() { }

Dynamic FileSystem_obj::__CreateEmpty() { return  new FileSystem_obj; }
hx::ObjectPtr< FileSystem_obj > FileSystem_obj::__new()
{  hx::ObjectPtr< FileSystem_obj > result = new FileSystem_obj();
	result->__construct();
	return result;}

Dynamic FileSystem_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< FileSystem_obj > result = new FileSystem_obj();
	result->__construct();
	return result;}

bool FileSystem_obj::exists( ::String path){
	HX_STACK_FRAME("sys.FileSystem","exists",0xf55bed9e,"sys.FileSystem.exists","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/FileSystem.hx",33,0xe1d48ab1)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(34)
	::String _g = ::haxe::io::Path_obj::removeTrailingSlashes(path);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(34)
	return ::sys::FileSystem_obj::sys_exists(_g);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FileSystem_obj,exists,return )

Void FileSystem_obj::rename( ::String path,::String newPath){
{
		HX_STACK_FRAME("sys.FileSystem","rename",0x3aa2fb40,"sys.FileSystem.rename","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/FileSystem.hx",37,0xe1d48ab1)
		HX_STACK_ARG(path,"path")
		HX_STACK_ARG(newPath,"newPath")
		HX_STACK_LINE(38)
		Dynamic _g = ::sys::FileSystem_obj::sys_rename(path,newPath);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(38)
		if (((_g == null()))){
			HX_STACK_LINE(39)
			HX_STACK_DO_THROW((((HX_CSTRING("Could not rename:") + path) + HX_CSTRING(" to ")) + newPath));
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(FileSystem_obj,rename,(void))

Dynamic FileSystem_obj::stat( ::String path){
	HX_STACK_FRAME("sys.FileSystem","stat",0xa630df16,"sys.FileSystem.stat","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/FileSystem.hx",42,0xe1d48ab1)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(43)
	Dynamic s = ::sys::FileSystem_obj::sys_stat(path);		HX_STACK_VAR(s,"s");
	HX_STACK_LINE(44)
	if (((s == null()))){
		HX_STACK_LINE(45)
		::Date _g = ::Date_obj::fromTime((int)0);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(45)
		::Date _g1 = ::Date_obj::fromTime((int)0);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(45)
		::Date _g2 = ::Date_obj::fromTime((int)0);		HX_STACK_VAR(_g2,"_g2");
		struct _Function_2_1{
			inline static Dynamic Block( ::Date &_g1,::Date &_g,::Date &_g2){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/FileSystem.hx",45,0xe1d48ab1)
				{
					hx::Anon __result = hx::Anon_obj::Create();
					__result->Add(HX_CSTRING("gid") , (int)0,false);
					__result->Add(HX_CSTRING("uid") , (int)0,false);
					__result->Add(HX_CSTRING("atime") , _g,false);
					__result->Add(HX_CSTRING("mtime") , _g1,false);
					__result->Add(HX_CSTRING("ctime") , _g2,false);
					__result->Add(HX_CSTRING("dev") , (int)0,false);
					__result->Add(HX_CSTRING("ino") , (int)0,false);
					__result->Add(HX_CSTRING("nlink") , (int)0,false);
					__result->Add(HX_CSTRING("rdev") , (int)0,false);
					__result->Add(HX_CSTRING("size") , (int)0,false);
					__result->Add(HX_CSTRING("mode") , (int)0,false);
					return __result;
				}
				return null();
			}
		};
		HX_STACK_LINE(45)
		return _Function_2_1::Block(_g1,_g,_g2);
	}
	HX_STACK_LINE(46)
	::Date _g3 = ::Date_obj::fromTime((1000.0 * s->__Field(HX_CSTRING("atime"),true)));		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(46)
	s->__FieldRef(HX_CSTRING("atime")) = _g3;
	HX_STACK_LINE(47)
	::Date _g4 = ::Date_obj::fromTime((1000.0 * s->__Field(HX_CSTRING("mtime"),true)));		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(47)
	s->__FieldRef(HX_CSTRING("mtime")) = _g4;
	HX_STACK_LINE(48)
	::Date _g5 = ::Date_obj::fromTime((1000.0 * s->__Field(HX_CSTRING("ctime"),true)));		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(48)
	s->__FieldRef(HX_CSTRING("ctime")) = _g5;
	HX_STACK_LINE(49)
	return s;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FileSystem_obj,stat,return )

::String FileSystem_obj::fullPath( ::String relPath){
	HX_STACK_FRAME("sys.FileSystem","fullPath",0xc6463316,"sys.FileSystem.fullPath","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/FileSystem.hx",52,0xe1d48ab1)
	HX_STACK_ARG(relPath,"relPath")
	HX_STACK_LINE(53)
	::String _g = ::sys::FileSystem_obj::file_full_path(relPath);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(53)
	return ::String(_g);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FileSystem_obj,fullPath,return )

::sys::_FileSystem::FileKind FileSystem_obj::kind( ::String path){
	HX_STACK_FRAME("sys.FileSystem","kind",0xa0dedc96,"sys.FileSystem.kind","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/FileSystem.hx",56,0xe1d48ab1)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(57)
	::String _g = ::haxe::io::Path_obj::removeTrailingSlashes(path);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(57)
	::String k = ::sys::FileSystem_obj::sys_file_type(_g);		HX_STACK_VAR(k,"k");
	HX_STACK_LINE(58)
	::String _switch_1 = (k);
	if (  ( _switch_1==HX_CSTRING("file"))){
		HX_STACK_LINE(59)
		return ::sys::_FileSystem::FileKind_obj::kfile;
	}
	else if (  ( _switch_1==HX_CSTRING("dir"))){
		HX_STACK_LINE(60)
		return ::sys::_FileSystem::FileKind_obj::kdir;
	}
	else  {
		HX_STACK_LINE(61)
		return ::sys::_FileSystem::FileKind_obj::kother(k);
	}
;
;
	HX_STACK_LINE(58)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FileSystem_obj,kind,return )

bool FileSystem_obj::isDirectory( ::String path){
	HX_STACK_FRAME("sys.FileSystem","isDirectory",0x6c577a21,"sys.FileSystem.isDirectory","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/FileSystem.hx",65,0xe1d48ab1)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(66)
	::sys::_FileSystem::FileKind _g = ::sys::FileSystem_obj::kind(path);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(66)
	return (_g == ::sys::_FileSystem::FileKind_obj::kdir);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FileSystem_obj,isDirectory,return )

Void FileSystem_obj::createDirectory( ::String path){
{
		HX_STACK_FRAME("sys.FileSystem","createDirectory",0x63bad3cf,"sys.FileSystem.createDirectory","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/FileSystem.hx",69,0xe1d48ab1)
		HX_STACK_ARG(path,"path")
		HX_STACK_LINE(70)
		::String path1 = ::haxe::io::Path_obj::addTrailingSlash(path);		HX_STACK_VAR(path1,"path1");
		HX_STACK_LINE(71)
		Array< ::String > parts;		HX_STACK_VAR(parts,"parts");
		HX_STACK_LINE(71)
		{
			HX_STACK_LINE(71)
			Array< ::String > _g = Array_obj< ::String >::__new();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(71)
			while((true)){
				HX_STACK_LINE(71)
				::String _g1 = ::haxe::io::Path_obj::directory(path1);		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(71)
				::String _g11 = path1 = _g1;		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(71)
				if ((!(((_g11 != HX_CSTRING("")))))){
					HX_STACK_LINE(71)
					break;
				}
				HX_STACK_LINE(71)
				_g->push(path1);
			}
			HX_STACK_LINE(71)
			parts = _g;
		}
		HX_STACK_LINE(72)
		parts->reverse();
		HX_STACK_LINE(73)
		{
			HX_STACK_LINE(73)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(73)
			while((true)){
				HX_STACK_LINE(73)
				if ((!(((_g1 < parts->length))))){
					HX_STACK_LINE(73)
					break;
				}
				HX_STACK_LINE(73)
				::String part = parts->__get(_g1);		HX_STACK_VAR(part,"part");
				HX_STACK_LINE(73)
				++(_g1);
				HX_STACK_LINE(74)
				Dynamic _g2 = part.charCodeAt((part.length - (int)1));		HX_STACK_VAR(_g2,"_g2");
				struct _Function_3_1{
					inline static bool Block( ::String &part){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/FileSystem.hx",74,0xe1d48ab1)
						{
							HX_STACK_LINE(74)
							::String _g3 = ::haxe::io::Path_obj::removeTrailingSlashes(part);		HX_STACK_VAR(_g3,"_g3");
							HX_STACK_LINE(74)
							return !(::sys::FileSystem_obj::sys_exists(_g3));
						}
						return null();
					}
				};
				struct _Function_3_2{
					inline static bool Block( ::String &part){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/FileSystem.hx",74,0xe1d48ab1)
						{
							HX_STACK_LINE(74)
							Dynamic _g4 = ::sys::FileSystem_obj::sys_create_dir(part,(int)493);		HX_STACK_VAR(_g4,"_g4");
							HX_STACK_LINE(74)
							return (_g4 == null());
						}
						return null();
					}
				};
				HX_STACK_LINE(74)
				if (((  (((  (((_g2 != (int)58))) ? bool(_Function_3_1::Block(part)) : bool(false) ))) ? bool(_Function_3_2::Block(part)) : bool(false) ))){
					HX_STACK_LINE(75)
					HX_STACK_DO_THROW((HX_CSTRING("Could not create directory:") + part));
				}
			}
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FileSystem_obj,createDirectory,(void))

Void FileSystem_obj::deleteFile( ::String path){
{
		HX_STACK_FRAME("sys.FileSystem","deleteFile",0x4bd48509,"sys.FileSystem.deleteFile","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/FileSystem.hx",79,0xe1d48ab1)
		HX_STACK_ARG(path,"path")
		HX_STACK_LINE(80)
		Dynamic _g = ::sys::FileSystem_obj::file_delete(path);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(80)
		if (((_g == null()))){
			HX_STACK_LINE(81)
			HX_STACK_DO_THROW((HX_CSTRING("Could not delete file:") + path));
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FileSystem_obj,deleteFile,(void))

Void FileSystem_obj::deleteDirectory( ::String path){
{
		HX_STACK_FRAME("sys.FileSystem","deleteDirectory",0x052a5cc0,"sys.FileSystem.deleteDirectory","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/FileSystem.hx",84,0xe1d48ab1)
		HX_STACK_ARG(path,"path")
		HX_STACK_LINE(85)
		Dynamic _g = ::sys::FileSystem_obj::sys_remove_dir(path);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(85)
		if (((_g == null()))){
			HX_STACK_LINE(86)
			HX_STACK_DO_THROW((HX_CSTRING("Could not delete directory:") + path));
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FileSystem_obj,deleteDirectory,(void))

Array< ::String > FileSystem_obj::readDirectory( ::String path){
	HX_STACK_FRAME("sys.FileSystem","readDirectory",0x0619f8b5,"sys.FileSystem.readDirectory","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/FileSystem.hx",90,0xe1d48ab1)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(90)
	return ::sys::FileSystem_obj::sys_read_dir(path);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FileSystem_obj,readDirectory,return )

Dynamic FileSystem_obj::sys_exists;

Dynamic FileSystem_obj::file_delete;

Dynamic FileSystem_obj::sys_rename;

Dynamic FileSystem_obj::sys_stat;

Dynamic FileSystem_obj::sys_file_type;

Dynamic FileSystem_obj::sys_create_dir;

Dynamic FileSystem_obj::sys_remove_dir;

Dynamic FileSystem_obj::sys_read_dir;

Dynamic FileSystem_obj::file_full_path;


FileSystem_obj::FileSystem_obj()
{
}

Dynamic FileSystem_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"stat") ) { return stat_dyn(); }
		if (HX_FIELD_EQ(inName,"kind") ) { return kind_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"exists") ) { return exists_dyn(); }
		if (HX_FIELD_EQ(inName,"rename") ) { return rename_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"fullPath") ) { return fullPath_dyn(); }
		if (HX_FIELD_EQ(inName,"sys_stat") ) { return sys_stat; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"deleteFile") ) { return deleteFile_dyn(); }
		if (HX_FIELD_EQ(inName,"sys_exists") ) { return sys_exists; }
		if (HX_FIELD_EQ(inName,"sys_rename") ) { return sys_rename; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"isDirectory") ) { return isDirectory_dyn(); }
		if (HX_FIELD_EQ(inName,"file_delete") ) { return file_delete; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"sys_read_dir") ) { return sys_read_dir; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"readDirectory") ) { return readDirectory_dyn(); }
		if (HX_FIELD_EQ(inName,"sys_file_type") ) { return sys_file_type; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"sys_create_dir") ) { return sys_create_dir; }
		if (HX_FIELD_EQ(inName,"sys_remove_dir") ) { return sys_remove_dir; }
		if (HX_FIELD_EQ(inName,"file_full_path") ) { return file_full_path; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"createDirectory") ) { return createDirectory_dyn(); }
		if (HX_FIELD_EQ(inName,"deleteDirectory") ) { return deleteDirectory_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic FileSystem_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 8:
		if (HX_FIELD_EQ(inName,"sys_stat") ) { sys_stat=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"sys_exists") ) { sys_exists=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"sys_rename") ) { sys_rename=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"file_delete") ) { file_delete=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"sys_read_dir") ) { sys_read_dir=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"sys_file_type") ) { sys_file_type=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"sys_create_dir") ) { sys_create_dir=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"sys_remove_dir") ) { sys_remove_dir=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"file_full_path") ) { file_full_path=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void FileSystem_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("exists"),
	HX_CSTRING("rename"),
	HX_CSTRING("stat"),
	HX_CSTRING("fullPath"),
	HX_CSTRING("kind"),
	HX_CSTRING("isDirectory"),
	HX_CSTRING("createDirectory"),
	HX_CSTRING("deleteFile"),
	HX_CSTRING("deleteDirectory"),
	HX_CSTRING("readDirectory"),
	HX_CSTRING("sys_exists"),
	HX_CSTRING("file_delete"),
	HX_CSTRING("sys_rename"),
	HX_CSTRING("sys_stat"),
	HX_CSTRING("sys_file_type"),
	HX_CSTRING("sys_create_dir"),
	HX_CSTRING("sys_remove_dir"),
	HX_CSTRING("sys_read_dir"),
	HX_CSTRING("file_full_path"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FileSystem_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(FileSystem_obj::sys_exists,"sys_exists");
	HX_MARK_MEMBER_NAME(FileSystem_obj::file_delete,"file_delete");
	HX_MARK_MEMBER_NAME(FileSystem_obj::sys_rename,"sys_rename");
	HX_MARK_MEMBER_NAME(FileSystem_obj::sys_stat,"sys_stat");
	HX_MARK_MEMBER_NAME(FileSystem_obj::sys_file_type,"sys_file_type");
	HX_MARK_MEMBER_NAME(FileSystem_obj::sys_create_dir,"sys_create_dir");
	HX_MARK_MEMBER_NAME(FileSystem_obj::sys_remove_dir,"sys_remove_dir");
	HX_MARK_MEMBER_NAME(FileSystem_obj::sys_read_dir,"sys_read_dir");
	HX_MARK_MEMBER_NAME(FileSystem_obj::file_full_path,"file_full_path");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FileSystem_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(FileSystem_obj::sys_exists,"sys_exists");
	HX_VISIT_MEMBER_NAME(FileSystem_obj::file_delete,"file_delete");
	HX_VISIT_MEMBER_NAME(FileSystem_obj::sys_rename,"sys_rename");
	HX_VISIT_MEMBER_NAME(FileSystem_obj::sys_stat,"sys_stat");
	HX_VISIT_MEMBER_NAME(FileSystem_obj::sys_file_type,"sys_file_type");
	HX_VISIT_MEMBER_NAME(FileSystem_obj::sys_create_dir,"sys_create_dir");
	HX_VISIT_MEMBER_NAME(FileSystem_obj::sys_remove_dir,"sys_remove_dir");
	HX_VISIT_MEMBER_NAME(FileSystem_obj::sys_read_dir,"sys_read_dir");
	HX_VISIT_MEMBER_NAME(FileSystem_obj::file_full_path,"file_full_path");
};

#endif

Class FileSystem_obj::__mClass;

void FileSystem_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("sys.FileSystem"), hx::TCanCast< FileSystem_obj> ,sStaticFields,sMemberFields,
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

void FileSystem_obj::__boot()
{
	sys_exists= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("sys_exists"),(int)1);
	file_delete= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("file_delete"),(int)1);
	sys_rename= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("sys_rename"),(int)2);
	sys_stat= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("sys_stat"),(int)1);
	sys_file_type= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("sys_file_type"),(int)1);
	sys_create_dir= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("sys_create_dir"),(int)2);
	sys_remove_dir= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("sys_remove_dir"),(int)1);
	sys_read_dir= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("sys_read_dir"),(int)1);
	file_full_path= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("file_full_path"),(int)1);
}

} // end namespace sys
