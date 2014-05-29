#ifndef INCLUDED_flash_text_TextLineMetrics
#define INCLUDED_flash_text_TextLineMetrics

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,text,TextLineMetrics)
namespace flash{
namespace text{


class HXCPP_CLASS_ATTRIBUTES  TextLineMetrics_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef TextLineMetrics_obj OBJ_;
		TextLineMetrics_obj();
		Void __construct(hx::Null< Float >  __o_x,hx::Null< Float >  __o_width,hx::Null< Float >  __o_height,hx::Null< Float >  __o_ascent,hx::Null< Float >  __o_descent,hx::Null< Float >  __o_leading);

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< TextLineMetrics_obj > __new(hx::Null< Float >  __o_x,hx::Null< Float >  __o_width,hx::Null< Float >  __o_height,hx::Null< Float >  __o_ascent,hx::Null< Float >  __o_descent,hx::Null< Float >  __o_leading);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~TextLineMetrics_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("TextLineMetrics"); }

		Float ascent;
		Float descent;
		Float height;
		Float leading;
		Float width;
		Float x;
};

} // end namespace flash
} // end namespace text

#endif /* INCLUDED_flash_text_TextLineMetrics */ 
