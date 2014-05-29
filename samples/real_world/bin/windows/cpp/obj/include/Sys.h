#ifndef INCLUDED_Sys
#define INCLUDED_Sys

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(IMap)
HX_DECLARE_CLASS0(Sys)
HX_DECLARE_CLASS2(haxe,ds,StringMap)
HX_DECLARE_CLASS2(haxe,io,Input)
HX_DECLARE_CLASS2(haxe,io,Output)


class HXCPP_CLASS_ATTRIBUTES  Sys_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Sys_obj OBJ_;
		Sys_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Sys_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Sys_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Sys"); }

		static Void print( Dynamic v);
		static Dynamic print_dyn();

		static Void println( Dynamic v);
		static Dynamic println_dyn();

		static ::haxe::io::Input _stdin( );
		static Dynamic _stdin_dyn();

		static ::haxe::io::Output _stdout( );
		static Dynamic _stdout_dyn();

		static ::haxe::io::Output _stderr( );
		static Dynamic _stderr_dyn();

		static int getChar( bool echo);
		static Dynamic getChar_dyn();

		static Array< ::String > args( );
		static Dynamic args_dyn();

		static ::String getEnv( ::String s);
		static Dynamic getEnv_dyn();

		static Void putEnv( ::String s,::String v);
		static Dynamic putEnv_dyn();

		static Void sleep( Float seconds);
		static Dynamic sleep_dyn();

		static bool setTimeLocale( ::String loc);
		static Dynamic setTimeLocale_dyn();

		static ::String getCwd( );
		static Dynamic getCwd_dyn();

		static Void setCwd( ::String s);
		static Dynamic setCwd_dyn();

		static ::String systemName( );
		static Dynamic systemName_dyn();

		static ::String escapeArgument( ::String arg);
		static Dynamic escapeArgument_dyn();

		static int command( ::String cmd,Array< ::String > args);
		static Dynamic command_dyn();

		static Void exit( int code);
		static Dynamic exit_dyn();

		static Float time( );
		static Dynamic time_dyn();

		static Float cpuTime( );
		static Dynamic cpuTime_dyn();

		static ::String executablePath( );
		static Dynamic executablePath_dyn();

		static ::haxe::ds::StringMap environment( );
		static Dynamic environment_dyn();

		static Dynamic get_env;
		static Dynamic &get_env_dyn() { return get_env;}
		static Dynamic put_env;
		static Dynamic &put_env_dyn() { return put_env;}
		static Dynamic _sleep;
		static Dynamic &_sleep_dyn() { return _sleep;}
		static Dynamic set_time_locale;
		static Dynamic &set_time_locale_dyn() { return set_time_locale;}
		static Dynamic get_cwd;
		static Dynamic &get_cwd_dyn() { return get_cwd;}
		static Dynamic set_cwd;
		static Dynamic &set_cwd_dyn() { return set_cwd;}
		static Dynamic sys_string;
		static Dynamic &sys_string_dyn() { return sys_string;}
		static Dynamic sys_command;
		static Dynamic &sys_command_dyn() { return sys_command;}
		static Dynamic sys_exit;
		static Dynamic &sys_exit_dyn() { return sys_exit;}
		static Dynamic sys_time;
		static Dynamic &sys_time_dyn() { return sys_time;}
		static Dynamic sys_cpu_time;
		static Dynamic &sys_cpu_time_dyn() { return sys_cpu_time;}
		static Dynamic sys_exe_path;
		static Dynamic &sys_exe_path_dyn() { return sys_exe_path;}
		static Dynamic sys_env;
		static Dynamic &sys_env_dyn() { return sys_env;}
		static Dynamic file_stdin;
		static Dynamic &file_stdin_dyn() { return file_stdin;}
		static Dynamic file_stdout;
		static Dynamic &file_stdout_dyn() { return file_stdout;}
		static Dynamic file_stderr;
		static Dynamic &file_stderr_dyn() { return file_stderr;}
		static Dynamic getch;
		static Dynamic &getch_dyn() { return getch;}
};


#endif /* INCLUDED_Sys */ 
