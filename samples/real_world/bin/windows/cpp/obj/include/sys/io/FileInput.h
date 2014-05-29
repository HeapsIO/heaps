#ifndef INCLUDED_sys_io_FileInput
#define INCLUDED_sys_io_FileInput

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <haxe/io/Input.h>
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(haxe,io,Input)
HX_DECLARE_CLASS2(sys,io,FileInput)
HX_DECLARE_CLASS2(sys,io,FileSeek)
namespace sys{
namespace io{


class HXCPP_CLASS_ATTRIBUTES  FileInput_obj : public ::haxe::io::Input_obj{
	public:
		typedef ::haxe::io::Input_obj super;
		typedef FileInput_obj OBJ_;
		FileInput_obj();
		Void __construct(Dynamic f);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< FileInput_obj > __new(Dynamic f);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~FileInput_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("FileInput"); }

		Dynamic __f;
		virtual int readByte( );

		virtual int readBytes( ::haxe::io::Bytes s,int p,int l);

		virtual Void close( );

		virtual Void seek( int p,::sys::io::FileSeek pos);
		Dynamic seek_dyn();

		virtual int tell( );
		Dynamic tell_dyn();

		virtual bool eof( );
		Dynamic eof_dyn();

		static Dynamic file_eof;
		static Dynamic &file_eof_dyn() { return file_eof;}
		static Dynamic file_read;
		static Dynamic &file_read_dyn() { return file_read;}
		static Dynamic file_read_char;
		static Dynamic &file_read_char_dyn() { return file_read_char;}
		static Dynamic file_close;
		static Dynamic &file_close_dyn() { return file_close;}
		static Dynamic file_seek;
		static Dynamic &file_seek_dyn() { return file_seek;}
		static Dynamic file_tell;
		static Dynamic &file_tell_dyn() { return file_tell;}
};

} // end namespace sys
} // end namespace io

#endif /* INCLUDED_sys_io_FileInput */ 
