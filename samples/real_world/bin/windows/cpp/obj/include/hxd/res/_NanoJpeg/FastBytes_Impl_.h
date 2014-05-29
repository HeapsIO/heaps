#ifndef INCLUDED_hxd_res__NanoJpeg_FastBytes_Impl_
#define INCLUDED_hxd_res__NanoJpeg_FastBytes_Impl_

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS3(hxd,res,_NanoJpeg,FastBytes_Impl_)
namespace hxd{
namespace res{
namespace _NanoJpeg{


class HXCPP_CLASS_ATTRIBUTES  FastBytes_Impl__obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef FastBytes_Impl__obj OBJ_;
		FastBytes_Impl__obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< FastBytes_Impl__obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~FastBytes_Impl__obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("FastBytes_Impl_"); }

		static ::haxe::io::Bytes _new( ::haxe::io::Bytes b);
		static Dynamic _new_dyn();

		static int get( ::haxe::io::Bytes this1,int i);
		static Dynamic get_dyn();

		static Void set( ::haxe::io::Bytes this1,int i,int v);
		static Dynamic set_dyn();

};

} // end namespace hxd
} // end namespace res
} // end namespace _NanoJpeg

#endif /* INCLUDED_hxd_res__NanoJpeg_FastBytes_Impl_ */ 
