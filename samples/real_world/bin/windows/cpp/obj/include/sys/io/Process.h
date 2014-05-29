#ifndef INCLUDED_sys_io_Process
#define INCLUDED_sys_io_Process

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(haxe,io,Input)
HX_DECLARE_CLASS2(haxe,io,Output)
HX_DECLARE_CLASS2(sys,io,Process)
namespace sys{
namespace io{


class HXCPP_CLASS_ATTRIBUTES  Process_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Process_obj OBJ_;
		Process_obj();
		Void __construct(::String cmd,Array< ::String > args);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Process_obj > __new(::String cmd,Array< ::String > args);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Process_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Process"); }

		Dynamic p;
		::haxe::io::Input _stdout;
		::haxe::io::Input _stderr;
		::haxe::io::Output _stdin;
		virtual int getPid( );
		Dynamic getPid_dyn();

		virtual int exitCode( );
		Dynamic exitCode_dyn();

		virtual Void close( );
		Dynamic close_dyn();

		virtual Void kill( );
		Dynamic kill_dyn();

		static Dynamic _run;
		static Dynamic &_run_dyn() { return _run;}
		static Dynamic _exit;
		static Dynamic &_exit_dyn() { return _exit;}
		static Dynamic _pid;
		static Dynamic &_pid_dyn() { return _pid;}
		static Dynamic _close;
		static Dynamic &_close_dyn() { return _close;}
};

} // end namespace sys
} // end namespace io

#endif /* INCLUDED_sys_io_Process */ 
