#ifndef INCLUDED_hxd_impl_Memory
#define INCLUDED_hxd_impl_Memory

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(hxd,impl,Memory)
HX_DECLARE_CLASS2(hxd,impl,MemoryReader)
namespace hxd{
namespace impl{


class HXCPP_CLASS_ATTRIBUTES  Memory_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Memory_obj OBJ_;
		Memory_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Memory_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Memory_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Memory"); }

		static Array< ::Dynamic > stack;
		static ::haxe::io::Bytes current;
		static ::hxd::impl::MemoryReader inst;
		static ::hxd::impl::MemoryReader select( ::haxe::io::Bytes b);
		static Dynamic select_dyn();

		static Void end( );
		static Dynamic end_dyn();

};

} // end namespace hxd
} // end namespace impl

#endif /* INCLUDED_hxd_impl_Memory */ 
