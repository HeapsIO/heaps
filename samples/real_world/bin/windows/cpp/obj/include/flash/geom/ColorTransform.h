#ifndef INCLUDED_flash_geom_ColorTransform
#define INCLUDED_flash_geom_ColorTransform

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,geom,ColorTransform)
namespace flash{
namespace geom{


class HXCPP_CLASS_ATTRIBUTES  ColorTransform_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef ColorTransform_obj OBJ_;
		ColorTransform_obj();
		Void __construct(hx::Null< Float >  __o_redMultiplier,hx::Null< Float >  __o_greenMultiplier,hx::Null< Float >  __o_blueMultiplier,hx::Null< Float >  __o_alphaMultiplier,hx::Null< Float >  __o_redOffset,hx::Null< Float >  __o_greenOffset,hx::Null< Float >  __o_blueOffset,hx::Null< Float >  __o_alphaOffset);

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< ColorTransform_obj > __new(hx::Null< Float >  __o_redMultiplier,hx::Null< Float >  __o_greenMultiplier,hx::Null< Float >  __o_blueMultiplier,hx::Null< Float >  __o_alphaMultiplier,hx::Null< Float >  __o_redOffset,hx::Null< Float >  __o_greenOffset,hx::Null< Float >  __o_blueOffset,hx::Null< Float >  __o_alphaOffset);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~ColorTransform_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("ColorTransform"); }

		Float alphaMultiplier;
		Float alphaOffset;
		Float blueMultiplier;
		Float blueOffset;
		Float greenMultiplier;
		Float greenOffset;
		Float redMultiplier;
		Float redOffset;
		virtual Void concat( ::flash::geom::ColorTransform second);
		Dynamic concat_dyn();

		virtual int get_color( );
		Dynamic get_color_dyn();

		virtual int set_color( int value);
		Dynamic set_color_dyn();

};

} // end namespace flash
} // end namespace geom

#endif /* INCLUDED_flash_geom_ColorTransform */ 
