#ifndef INCLUDED_flash_display_Loader
#define INCLUDED_flash_display_Loader

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <flash/display/Sprite.h>
HX_DECLARE_CLASS2(flash,display,BitmapData)
HX_DECLARE_CLASS2(flash,display,DisplayObject)
HX_DECLARE_CLASS2(flash,display,DisplayObjectContainer)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(flash,display,InteractiveObject)
HX_DECLARE_CLASS2(flash,display,Loader)
HX_DECLARE_CLASS2(flash,display,LoaderInfo)
HX_DECLARE_CLASS2(flash,display,Sprite)
HX_DECLARE_CLASS2(flash,events,Event)
HX_DECLARE_CLASS2(flash,events,EventDispatcher)
HX_DECLARE_CLASS2(flash,events,IEventDispatcher)
HX_DECLARE_CLASS2(flash,net,URLLoader)
HX_DECLARE_CLASS2(flash,net,URLRequest)
HX_DECLARE_CLASS2(flash,system,LoaderContext)
HX_DECLARE_CLASS2(flash,utils,ByteArray)
HX_DECLARE_CLASS2(flash,utils,IDataInput)
HX_DECLARE_CLASS2(flash,utils,IDataOutput)
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(openfl,utils,IMemoryRange)
namespace flash{
namespace display{


class HXCPP_CLASS_ATTRIBUTES  Loader_obj : public ::flash::display::Sprite_obj{
	public:
		typedef ::flash::display::Sprite_obj super;
		typedef Loader_obj OBJ_;
		Loader_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Loader_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Loader_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Loader"); }

		::flash::display::DisplayObject content;
		::flash::display::LoaderInfo contentLoaderInfo;
		::flash::display::BitmapData __image;
		virtual Void load( ::flash::net::URLRequest request,::flash::system::LoaderContext context);
		Dynamic load_dyn();

		virtual Void loadBytes( ::flash::utils::ByteArray bytes,::flash::system::LoaderContext context);
		Dynamic loadBytes_dyn();

		virtual Void unload( );
		Dynamic unload_dyn();

		virtual bool __onComplete( ::flash::utils::ByteArray bytes);
		Dynamic __onComplete_dyn();

		virtual Void contentLoaderInfo_onData( ::flash::events::Event event);
		Dynamic contentLoaderInfo_onData_dyn();

};

} // end namespace flash
} // end namespace display

#endif /* INCLUDED_flash_display_Loader */ 
