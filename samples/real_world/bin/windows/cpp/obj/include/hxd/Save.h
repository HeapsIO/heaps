#ifndef INCLUDED_hxd_Save
#define INCLUDED_hxd_Save

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(IMap)
HX_DECLARE_CLASS2(haxe,ds,StringMap)
HX_DECLARE_CLASS1(hxd,Save)
namespace hxd{


class HXCPP_CLASS_ATTRIBUTES  Save_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Save_obj OBJ_;
		Save_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Save_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Save_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Save"); }

		static ::haxe::ds::StringMap cur;
		static Dynamic load( Dynamic defValue,::String name);
		static Dynamic load_dyn();

		static bool save( Dynamic val,::String name,Dynamic quick);
		static Dynamic save_dyn();

};

} // end namespace hxd

#endif /* INCLUDED_hxd_Save */ 
