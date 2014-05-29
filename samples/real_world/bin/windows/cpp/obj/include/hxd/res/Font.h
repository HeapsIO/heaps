#ifndef INCLUDED_hxd_res_Font
#define INCLUDED_hxd_res_Font

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <hxd/res/Resource.h>
HX_DECLARE_CLASS1(h2d,Font)
HX_DECLARE_CLASS2(hxd,res,FileEntry)
HX_DECLARE_CLASS2(hxd,res,Font)
HX_DECLARE_CLASS2(hxd,res,Resource)
namespace hxd{
namespace res{


class HXCPP_CLASS_ATTRIBUTES  Font_obj : public ::hxd::res::Resource_obj{
	public:
		typedef ::hxd::res::Resource_obj super;
		typedef Font_obj OBJ_;
		Font_obj();
		Void __construct(::hxd::res::FileEntry entry);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Font_obj > __new(::hxd::res::FileEntry entry);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Font_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Font"); }

		virtual ::h2d::Font build( int size,Dynamic options);
		Dynamic build_dyn();

};

} // end namespace hxd
} // end namespace res

#endif /* INCLUDED_hxd_res_Font */ 
