#ifndef INCLUDED_hxd_res_BitmapFont
#define INCLUDED_hxd_res_BitmapFont

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <hxd/res/Resource.h>
HX_DECLARE_CLASS1(h2d,Font)
HX_DECLARE_CLASS2(hxd,res,BitmapFont)
HX_DECLARE_CLASS2(hxd,res,FileEntry)
HX_DECLARE_CLASS2(hxd,res,Loader)
HX_DECLARE_CLASS2(hxd,res,Resource)
namespace hxd{
namespace res{


class HXCPP_CLASS_ATTRIBUTES  BitmapFont_obj : public ::hxd::res::Resource_obj{
	public:
		typedef ::hxd::res::Resource_obj super;
		typedef BitmapFont_obj OBJ_;
		BitmapFont_obj();
		Void __construct(::hxd::res::Loader loader,::hxd::res::FileEntry entry);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< BitmapFont_obj > __new(::hxd::res::Loader loader,::hxd::res::FileEntry entry);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~BitmapFont_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("BitmapFont"); }

		::hxd::res::Loader loader;
		::h2d::Font font;
		virtual ::h2d::Font toFont( );
		Dynamic toFont_dyn();

};

} // end namespace hxd
} // end namespace res

#endif /* INCLUDED_hxd_res_BitmapFont */ 
