#ifndef INCLUDED_haxe_zip_Compress
#define INCLUDED_haxe_zip_Compress

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(haxe,zip,Compress)
HX_DECLARE_CLASS2(haxe,zip,FlushMode)
namespace haxe{
namespace zip{


class HXCPP_CLASS_ATTRIBUTES  Compress_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Compress_obj OBJ_;
		Compress_obj();
		Void __construct(int level);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Compress_obj > __new(int level);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Compress_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Compress"); }

		Dynamic s;
		virtual Dynamic execute( ::haxe::io::Bytes src,int srcPos,::haxe::io::Bytes dst,int dstPos);
		Dynamic execute_dyn();

		virtual Void setFlushMode( ::haxe::zip::FlushMode f);
		Dynamic setFlushMode_dyn();

		virtual Void close( );
		Dynamic close_dyn();

		static ::haxe::io::Bytes run( ::haxe::io::Bytes s,int level);
		static Dynamic run_dyn();

		static Dynamic _deflate_init;
		static Dynamic &_deflate_init_dyn() { return _deflate_init;}
		static Dynamic _deflate_bound;
		static Dynamic &_deflate_bound_dyn() { return _deflate_bound;}
		static Dynamic _deflate_buffer;
		static Dynamic &_deflate_buffer_dyn() { return _deflate_buffer;}
		static Dynamic _deflate_end;
		static Dynamic &_deflate_end_dyn() { return _deflate_end;}
		static Dynamic _set_flush_mode;
		static Dynamic &_set_flush_mode_dyn() { return _set_flush_mode;}
};

} // end namespace haxe
} // end namespace zip

#endif /* INCLUDED_haxe_zip_Compress */ 
