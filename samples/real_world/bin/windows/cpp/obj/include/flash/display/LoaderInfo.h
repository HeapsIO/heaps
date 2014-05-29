#ifndef INCLUDED_flash_display_LoaderInfo
#define INCLUDED_flash_display_LoaderInfo

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <flash/net/URLLoader.h>
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
HX_DECLARE_CLASS2(flash,events,UncaughtErrorEvents)
HX_DECLARE_CLASS2(flash,net,URLLoader)
HX_DECLARE_CLASS2(flash,net,URLRequest)
HX_DECLARE_CLASS2(flash,system,ApplicationDomain)
HX_DECLARE_CLASS2(flash,utils,ByteArray)
HX_DECLARE_CLASS2(flash,utils,IDataInput)
HX_DECLARE_CLASS2(flash,utils,IDataOutput)
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(openfl,utils,IMemoryRange)
namespace flash{
namespace display{


class HXCPP_CLASS_ATTRIBUTES  LoaderInfo_obj : public ::flash::net::URLLoader_obj{
	public:
		typedef ::flash::net::URLLoader_obj super;
		typedef LoaderInfo_obj OBJ_;
		LoaderInfo_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< LoaderInfo_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~LoaderInfo_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("LoaderInfo"); }

		::flash::system::ApplicationDomain applicationDomain;
		::flash::utils::ByteArray bytes;
		bool childAllowsParent;
		::flash::display::DisplayObject content;
		::String contentType;
		Float frameRate;
		int height;
		::flash::display::Loader loader;
		::String loaderURL;
		Dynamic parameters;
		bool parentAllowsChild;
		bool sameDomain;
		::flash::events::EventDispatcher sharedEvents;
		::String url;
		int width;
		::flash::events::UncaughtErrorEvents uncaughtErrorEvents;
		::String __pendingURL;
		virtual Void load( ::flash::net::URLRequest request);

		virtual Void this_onComplete( ::flash::events::Event event);
		Dynamic this_onComplete_dyn();

		virtual ::flash::utils::ByteArray get_bytes( );
		Dynamic get_bytes_dyn();

		static ::flash::display::LoaderInfo create( ::flash::display::Loader loader);
		static Dynamic create_dyn();

};

} // end namespace flash
} // end namespace display

#endif /* INCLUDED_flash_display_LoaderInfo */ 
