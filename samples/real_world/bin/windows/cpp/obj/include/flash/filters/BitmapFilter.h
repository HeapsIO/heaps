#ifndef INCLUDED_flash_filters_BitmapFilter
#define INCLUDED_flash_filters_BitmapFilter

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,filters,BitmapFilter)
namespace flash{
namespace filters{


class HXCPP_CLASS_ATTRIBUTES  BitmapFilter_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef BitmapFilter_obj OBJ_;
		BitmapFilter_obj();
		Void __construct(::String type);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< BitmapFilter_obj > __new(::String type);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~BitmapFilter_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("BitmapFilter"); }

		::String type;
		virtual ::flash::filters::BitmapFilter clone( );
		Dynamic clone_dyn();

};

} // end namespace flash
} // end namespace filters

#endif /* INCLUDED_flash_filters_BitmapFilter */ 
