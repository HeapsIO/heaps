#ifndef INCLUDED_hxd_res__NanoJpeg_Component
#define INCLUDED_hxd_res__NanoJpeg_Component

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS3(hxd,res,_NanoJpeg,Component)
namespace hxd{
namespace res{
namespace _NanoJpeg{


class HXCPP_CLASS_ATTRIBUTES  Component_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Component_obj OBJ_;
		Component_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Component_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Component_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Component"); }

		int cid;
		int ssx;
		int ssy;
		int width;
		int height;
		int stride;
		int qtsel;
		int actabsel;
		int dctabsel;
		int dcpred;
		::haxe::io::Bytes pixels;
};

} // end namespace hxd
} // end namespace res
} // end namespace _NanoJpeg

#endif /* INCLUDED_hxd_res__NanoJpeg_Component */ 
