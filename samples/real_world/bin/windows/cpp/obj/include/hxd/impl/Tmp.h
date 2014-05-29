#ifndef INCLUDED_hxd_impl_Tmp
#define INCLUDED_hxd_impl_Tmp

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(hxd,impl,Tmp)
namespace hxd{
namespace impl{


class HXCPP_CLASS_ATTRIBUTES  Tmp_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Tmp_obj OBJ_;
		Tmp_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Tmp_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Tmp_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Tmp"); }

		static Array< ::Dynamic > bytes;
		static ::haxe::io::Bytes getBytes( int size);
		static Dynamic getBytes_dyn();

		static Void saveBytes( ::haxe::io::Bytes b);
		static Dynamic saveBytes_dyn();

};

} // end namespace hxd
} // end namespace impl

#endif /* INCLUDED_hxd_impl_Tmp */ 
