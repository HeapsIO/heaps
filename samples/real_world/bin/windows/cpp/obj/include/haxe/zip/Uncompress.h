#ifndef INCLUDED_haxe_zip_Uncompress
#define INCLUDED_haxe_zip_Uncompress

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(haxe,zip,FlushMode)
HX_DECLARE_CLASS2(haxe,zip,Uncompress)
namespace haxe{
namespace zip{


class HXCPP_CLASS_ATTRIBUTES  Uncompress_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Uncompress_obj OBJ_;
		Uncompress_obj();
		Void __construct(Dynamic windowBits);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Uncompress_obj > __new(Dynamic windowBits);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Uncompress_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Uncompress"); }

		Dynamic s;
		virtual Dynamic execute( ::haxe::io::Bytes src,int srcPos,::haxe::io::Bytes dst,int dstPos);
		Dynamic execute_dyn();

		virtual Void setFlushMode( ::haxe::zip::FlushMode f);
		Dynamic setFlushMode_dyn();

		virtual Void close( );
		Dynamic close_dyn();

		static ::haxe::io::Bytes run( ::haxe::io::Bytes src,Dynamic bufsize);
		static Dynamic run_dyn();

		static Dynamic _inflate_init;
		static Dynamic &_inflate_init_dyn() { return _inflate_init;}
		static Dynamic _inflate_buffer;
		static Dynamic &_inflate_buffer_dyn() { return _inflate_buffer;}
		static Dynamic _inflate_end;
		static Dynamic &_inflate_end_dyn() { return _inflate_end;}
		static Dynamic _set_flush_mode;
		static Dynamic &_set_flush_mode_dyn() { return _set_flush_mode;}
};

} // end namespace haxe
} // end namespace zip

#endif /* INCLUDED_haxe_zip_Uncompress */ 
