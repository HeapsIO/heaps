#ifndef INCLUDED_hxd_impl_MemoryReader
#define INCLUDED_hxd_impl_MemoryReader

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(hxd,impl,MemoryReader)
namespace hxd{
namespace impl{


class HXCPP_CLASS_ATTRIBUTES  MemoryReader_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef MemoryReader_obj OBJ_;
		MemoryReader_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< MemoryReader_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~MemoryReader_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("MemoryReader"); }

		virtual int b( int addr);
		Dynamic b_dyn();

		virtual Void wb( int addr,int v);
		Dynamic wb_dyn();

		virtual Float _double( int addr);
		Dynamic _double_dyn();

		virtual int i32( int addr);
		Dynamic i32_dyn();

		virtual Void end( );
		Dynamic end_dyn();

};

} // end namespace hxd
} // end namespace impl

#endif /* INCLUDED_hxd_impl_MemoryReader */ 
