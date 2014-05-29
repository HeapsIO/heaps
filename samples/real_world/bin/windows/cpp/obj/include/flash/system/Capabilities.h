#ifndef INCLUDED_flash_system_Capabilities
#define INCLUDED_flash_system_Capabilities

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,system,Capabilities)
HX_DECLARE_CLASS2(flash,system,ScreenMode)
namespace flash{
namespace system{


class HXCPP_CLASS_ATTRIBUTES  Capabilities_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Capabilities_obj OBJ_;
		Capabilities_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Capabilities_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Capabilities_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Capabilities"); }

		static ::String language;
		static Float pixelAspectRatio;
		static Float screenDPI;
		static Array< ::Dynamic > screenResolutions;
		static Float screenResolutionX;
		static Float screenResolutionY;
		static Array< ::Dynamic > screenModes;
		static ::String get_language( );
		static Dynamic get_language_dyn();

		static Float get_pixelAspectRatio( );
		static Dynamic get_pixelAspectRatio_dyn();

		static Float get_screenDPI( );
		static Dynamic get_screenDPI_dyn();

		static Array< ::Dynamic > get_screenResolutions( );
		static Dynamic get_screenResolutions_dyn();

		static Float get_screenResolutionX( );
		static Dynamic get_screenResolutionX_dyn();

		static Float get_screenResolutionY( );
		static Dynamic get_screenResolutionY_dyn();

		static Array< ::Dynamic > get_screenModes( );
		static Dynamic get_screenModes_dyn();

		static Dynamic lime_capabilities_get_pixel_aspect_ratio;
		static Dynamic &lime_capabilities_get_pixel_aspect_ratio_dyn() { return lime_capabilities_get_pixel_aspect_ratio;}
		static Dynamic lime_capabilities_get_screen_dpi;
		static Dynamic &lime_capabilities_get_screen_dpi_dyn() { return lime_capabilities_get_screen_dpi;}
		static Dynamic lime_capabilities_get_screen_resolution_x;
		static Dynamic &lime_capabilities_get_screen_resolution_x_dyn() { return lime_capabilities_get_screen_resolution_x;}
		static Dynamic lime_capabilities_get_screen_resolution_y;
		static Dynamic &lime_capabilities_get_screen_resolution_y_dyn() { return lime_capabilities_get_screen_resolution_y;}
		static Dynamic lime_capabilities_get_screen_resolutions;
		static Dynamic &lime_capabilities_get_screen_resolutions_dyn() { return lime_capabilities_get_screen_resolutions;}
		static Dynamic lime_capabilities_get_screen_modes;
		static Dynamic &lime_capabilities_get_screen_modes_dyn() { return lime_capabilities_get_screen_modes;}
		static Dynamic lime_capabilities_get_language;
		static Dynamic &lime_capabilities_get_language_dyn() { return lime_capabilities_get_language;}
};

} // end namespace flash
} // end namespace system

#endif /* INCLUDED_flash_system_Capabilities */ 
