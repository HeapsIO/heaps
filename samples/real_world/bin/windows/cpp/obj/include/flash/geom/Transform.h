#ifndef INCLUDED_flash_geom_Transform
#define INCLUDED_flash_geom_Transform

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,display,DisplayObject)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(flash,events,EventDispatcher)
HX_DECLARE_CLASS2(flash,events,IEventDispatcher)
HX_DECLARE_CLASS2(flash,geom,ColorTransform)
HX_DECLARE_CLASS2(flash,geom,Matrix)
HX_DECLARE_CLASS2(flash,geom,Rectangle)
HX_DECLARE_CLASS2(flash,geom,Transform)
namespace flash{
namespace geom{


class HXCPP_CLASS_ATTRIBUTES  Transform_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Transform_obj OBJ_;
		Transform_obj();
		Void __construct(::flash::display::DisplayObject parent);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Transform_obj > __new(::flash::display::DisplayObject parent);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Transform_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Transform"); }

		::flash::geom::ColorTransform concatenatedColorTransform;
		::flash::geom::Matrix concatenatedMatrix;
		::flash::geom::Rectangle pixelBounds;
		::flash::display::DisplayObject __parent;
		virtual ::flash::geom::ColorTransform get_colorTransform( );
		Dynamic get_colorTransform_dyn();

		virtual ::flash::geom::ColorTransform set_colorTransform( ::flash::geom::ColorTransform value);
		Dynamic set_colorTransform_dyn();

		virtual ::flash::geom::ColorTransform get_concatenatedColorTransform( );
		Dynamic get_concatenatedColorTransform_dyn();

		virtual ::flash::geom::Matrix get_concatenatedMatrix( );
		Dynamic get_concatenatedMatrix_dyn();

		virtual ::flash::geom::Matrix get_matrix( );
		Dynamic get_matrix_dyn();

		virtual ::flash::geom::Matrix set_matrix( ::flash::geom::Matrix value);
		Dynamic set_matrix_dyn();

		virtual ::flash::geom::Rectangle get_pixelBounds( );
		Dynamic get_pixelBounds_dyn();

};

} // end namespace flash
} // end namespace geom

#endif /* INCLUDED_flash_geom_Transform */ 
