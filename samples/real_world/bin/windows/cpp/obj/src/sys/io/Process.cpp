#include <hxcpp.h>

#ifndef INCLUDED_cpp_Lib
#include <cpp/Lib.h>
#endif
#ifndef INCLUDED_haxe_io_Input
#include <haxe/io/Input.h>
#endif
#ifndef INCLUDED_haxe_io_Output
#include <haxe/io/Output.h>
#endif
#ifndef INCLUDED_sys_io_Process
#include <sys/io/Process.h>
#endif
#ifndef INCLUDED_sys_io__Process_Stdin
#include <sys/io/_Process/Stdin.h>
#endif
#ifndef INCLUDED_sys_io__Process_Stdout
#include <sys/io/_Process/Stdout.h>
#endif
namespace sys{
namespace io{

Void Process_obj::__construct(::String cmd,Array< ::String > args)
{
HX_STACK_FRAME("sys.io.Process","new",0x849b4c7a,"sys.io.Process.new","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/Process.hx",100,0x44abb456)
HX_STACK_THIS(this)
HX_STACK_ARG(cmd,"cmd")
HX_STACK_ARG(args,"args")
{
	HX_STACK_LINE(101)
	Dynamic _g;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(101)
	try
	{
	HX_STACK_CATCHABLE(Dynamic, 0);
	{
		HX_STACK_LINE(101)
		_g = ::sys::io::Process_obj::_run(cmd,args);
	}
	}
	catch(Dynamic __e){
		{
			HX_STACK_BEGIN_CATCH
			Dynamic e = __e;{
				HX_STACK_LINE(101)
				HX_STACK_DO_THROW((HX_CSTRING("Process creation failure : ") + cmd));
			}
		}
	}
	HX_STACK_LINE(101)
	this->p = _g;
	HX_STACK_LINE(102)
	::sys::io::_Process::Stdin _g1 = ::sys::io::_Process::Stdin_obj::__new(this->p);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(102)
	this->_stdin = _g1;
	HX_STACK_LINE(103)
	::sys::io::_Process::Stdout _g2 = ::sys::io::_Process::Stdout_obj::__new(this->p,true);		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(103)
	this->_stdout = _g2;
	HX_STACK_LINE(104)
	::sys::io::_Process::Stdout _g3 = ::sys::io::_Process::Stdout_obj::__new(this->p,false);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(104)
	this->_stderr = _g3;
}
;
	return null();
}

//Process_obj::~Process_obj() { }

Dynamic Process_obj::__CreateEmpty() { return  new Process_obj; }
hx::ObjectPtr< Process_obj > Process_obj::__new(::String cmd,Array< ::String > args)
{  hx::ObjectPtr< Process_obj > result = new Process_obj();
	result->__construct(cmd,args);
	return result;}

Dynamic Process_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Process_obj > result = new Process_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

int Process_obj::getPid( ){
	HX_STACK_FRAME("sys.io.Process","getPid",0xcce2217b,"sys.io.Process.getPid","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/Process.hx",108,0x44abb456)
	HX_STACK_THIS(this)
	HX_STACK_LINE(108)
	return ::sys::io::Process_obj::_pid(this->p);
}


HX_DEFINE_DYNAMIC_FUNC0(Process_obj,getPid,return )

int Process_obj::exitCode( ){
	HX_STACK_FRAME("sys.io.Process","exitCode",0x41e72111,"sys.io.Process.exitCode","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/Process.hx",112,0x44abb456)
	HX_STACK_THIS(this)
	HX_STACK_LINE(112)
	return ::sys::io::Process_obj::_exit(this->p);
}


HX_DEFINE_DYNAMIC_FUNC0(Process_obj,exitCode,return )

Void Process_obj::close( ){
{
		HX_STACK_FRAME("sys.io.Process","close",0x0a954e52,"sys.io.Process.close","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/Process.hx",116,0x44abb456)
		HX_STACK_THIS(this)
		HX_STACK_LINE(116)
		::sys::io::Process_obj::_close(this->p);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Process_obj,close,(void))

Void Process_obj::kill( ){
{
		HX_STACK_FRAME("sys.io.Process","kill",0x814efa44,"sys.io.Process.kill","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/sys/io/Process.hx",120,0x44abb456)
		HX_STACK_THIS(this)
		HX_STACK_LINE(120)
		HX_STACK_DO_THROW(HX_CSTRING("Not implemented"));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Process_obj,kill,(void))

Dynamic Process_obj::_run;

Dynamic Process_obj::_exit;

Dynamic Process_obj::_pid;

Dynamic Process_obj::_close;


Process_obj::Process_obj()
{
}

void Process_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Process);
	HX_MARK_MEMBER_NAME(p,"p");
	HX_MARK_MEMBER_NAME(_stdout,"stdout");
	HX_MARK_MEMBER_NAME(_stderr,"stderr");
	HX_MARK_MEMBER_NAME(_stdin,"stdin");
	HX_MARK_END_CLASS();
}

void Process_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(p,"p");
	HX_VISIT_MEMBER_NAME(_stdout,"stdout");
	HX_VISIT_MEMBER_NAME(_stderr,"stderr");
	HX_VISIT_MEMBER_NAME(_stdin,"stdin");
}

Dynamic Process_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"p") ) { return p; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"_run") ) { return _run; }
		if (HX_FIELD_EQ(inName,"_pid") ) { return _pid; }
		if (HX_FIELD_EQ(inName,"kill") ) { return kill_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"_exit") ) { return _exit; }
		if (HX_FIELD_EQ(inName,"stdin") ) { return _stdin; }
		if (HX_FIELD_EQ(inName,"close") ) { return close_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"_close") ) { return _close; }
		if (HX_FIELD_EQ(inName,"stdout") ) { return _stdout; }
		if (HX_FIELD_EQ(inName,"stderr") ) { return _stderr; }
		if (HX_FIELD_EQ(inName,"getPid") ) { return getPid_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"exitCode") ) { return exitCode_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Process_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"p") ) { p=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"_run") ) { _run=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_pid") ) { _pid=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"_exit") ) { _exit=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"stdin") ) { _stdin=inValue.Cast< ::haxe::io::Output >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"_close") ) { _close=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"stdout") ) { _stdout=inValue.Cast< ::haxe::io::Input >(); return inValue; }
		if (HX_FIELD_EQ(inName,"stderr") ) { _stderr=inValue.Cast< ::haxe::io::Input >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Process_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("p"));
	outFields->push(HX_CSTRING("stdout"));
	outFields->push(HX_CSTRING("stderr"));
	outFields->push(HX_CSTRING("stdin"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("_run"),
	HX_CSTRING("_exit"),
	HX_CSTRING("_pid"),
	HX_CSTRING("_close"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Process_obj,p),HX_CSTRING("p")},
	{hx::fsObject /*::haxe::io::Input*/ ,(int)offsetof(Process_obj,_stdout),HX_CSTRING("stdout")},
	{hx::fsObject /*::haxe::io::Input*/ ,(int)offsetof(Process_obj,_stderr),HX_CSTRING("stderr")},
	{hx::fsObject /*::haxe::io::Output*/ ,(int)offsetof(Process_obj,_stdin),HX_CSTRING("stdin")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("p"),
	HX_CSTRING("stdout"),
	HX_CSTRING("stderr"),
	HX_CSTRING("stdin"),
	HX_CSTRING("getPid"),
	HX_CSTRING("exitCode"),
	HX_CSTRING("close"),
	HX_CSTRING("kill"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Process_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Process_obj::_run,"_run");
	HX_MARK_MEMBER_NAME(Process_obj::_exit,"_exit");
	HX_MARK_MEMBER_NAME(Process_obj::_pid,"_pid");
	HX_MARK_MEMBER_NAME(Process_obj::_close,"_close");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Process_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Process_obj::_run,"_run");
	HX_VISIT_MEMBER_NAME(Process_obj::_exit,"_exit");
	HX_VISIT_MEMBER_NAME(Process_obj::_pid,"_pid");
	HX_VISIT_MEMBER_NAME(Process_obj::_close,"_close");
};

#endif

Class Process_obj::__mClass;

void Process_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("sys.io.Process"), hx::TCanCast< Process_obj> ,sStaticFields,sMemberFields,
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

void Process_obj::__boot()
{
	_run= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("process_run"),(int)2);
	_exit= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("process_exit"),(int)1);
	_pid= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("process_pid"),(int)1);
	_close= ::cpp::Lib_obj::loadLazy(HX_CSTRING("std"),HX_CSTRING("process_close"),(int)1);
}

} // end namespace sys
} // end namespace io
