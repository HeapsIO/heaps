#ifndef INCLUDED_sys_io__Process_Stdin
#define INCLUDED_sys_io__Process_Stdin

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <haxe/io/Output.h>
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(haxe,io,Output)
HX_DECLARE_CLASS3(sys,io,_Process,Stdin)
namespace sys{
namespace io{
namespace _Process{


class HXCPP_CLASS_ATTRIBUTES  Stdin_obj : public ::haxe::io::Output_obj{
	public:
		typedef ::haxe::io::Output_obj super;
		typedef Stdin_obj OBJ_;
		Stdin_obj();
		Void __construct(Dynamic p);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Stdin_obj > __new(Dynamic p);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Stdin_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Stdin"); }

		Dynamic p;
		::haxe::io::Bytes buf;
		virtual Void close( );

		virtual Void writeByte( int c);

		virtual int writeBytes( ::haxe::io::Bytes buf,int pos,int len);

		static Dynamic _stdin_write;
		static Dynamic &_stdin_write_dyn() { return _stdin_write;}
		static Dynamic _stdin_close;
		static Dynamic &_stdin_close_dyn() { return _stdin_close;}
};

} // end namespace sys
} // end namespace io
} // end namespace _Process

#endif /* INCLUDED_sys_io__Process_Stdin */ 
