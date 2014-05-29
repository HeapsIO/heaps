#ifndef INCLUDED_hxd_res_FileInput
#define INCLUDED_hxd_res_FileInput

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <haxe/io/Input.h>
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(haxe,io,Input)
HX_DECLARE_CLASS2(hxd,res,FileEntry)
HX_DECLARE_CLASS2(hxd,res,FileInput)
namespace hxd{
namespace res{


class HXCPP_CLASS_ATTRIBUTES  FileInput_obj : public ::haxe::io::Input_obj{
	public:
		typedef ::haxe::io::Input_obj super;
		typedef FileInput_obj OBJ_;
		FileInput_obj();
		Void __construct(::hxd::res::FileEntry f);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< FileInput_obj > __new(::hxd::res::FileEntry f);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~FileInput_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("FileInput"); }

		::hxd::res::FileEntry f;
		virtual Void skip( int nbytes);
		Dynamic skip_dyn();

		virtual int readByte( );

		virtual int readBytes( ::haxe::io::Bytes b,int pos,int len);

		virtual Void close( );

};

} // end namespace hxd
} // end namespace res

#endif /* INCLUDED_hxd_res_FileInput */ 
