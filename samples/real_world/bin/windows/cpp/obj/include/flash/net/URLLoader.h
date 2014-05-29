#ifndef INCLUDED_flash_net_URLLoader
#define INCLUDED_flash_net_URLLoader

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <flash/events/EventDispatcher.h>
HX_DECLARE_CLASS0(List)
HX_DECLARE_CLASS2(flash,events,EventDispatcher)
HX_DECLARE_CLASS2(flash,events,IEventDispatcher)
HX_DECLARE_CLASS2(flash,net,URLLoader)
HX_DECLARE_CLASS2(flash,net,URLLoaderDataFormat)
HX_DECLARE_CLASS2(flash,net,URLRequest)
HX_DECLARE_CLASS2(flash,utils,ByteArray)
HX_DECLARE_CLASS2(flash,utils,IDataInput)
HX_DECLARE_CLASS2(flash,utils,IDataOutput)
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(openfl,utils,IMemoryRange)
namespace flash{
namespace net{


class HXCPP_CLASS_ATTRIBUTES  URLLoader_obj : public ::flash::events::EventDispatcher_obj{
	public:
		typedef ::flash::events::EventDispatcher_obj super;
		typedef URLLoader_obj OBJ_;
		URLLoader_obj();
		Void __construct(::flash::net::URLRequest request);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< URLLoader_obj > __new(::flash::net::URLRequest request);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~URLLoader_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("URLLoader"); }

		int bytesLoaded;
		int bytesTotal;
		Dynamic data;
		::flash::net::URLLoaderDataFormat dataFormat;
		int state;
		Dynamic __handle;
		Dynamic __onComplete;
		Dynamic &__onComplete_dyn() { return __onComplete;}
		virtual Void close( );
		Dynamic close_dyn();

		virtual Void dispatchHTTPStatus( int code);
		Dynamic dispatchHTTPStatus_dyn();

		virtual Array< ::String > getCookies( );
		Dynamic getCookies_dyn();

		virtual Void load( ::flash::net::URLRequest request);
		Dynamic load_dyn();

		virtual Void onError( ::String msg);
		Dynamic onError_dyn();

		virtual Void update( );
		Dynamic update_dyn();

		virtual Void __dataComplete( );
		Dynamic __dataComplete_dyn();

		static ::List activeLoaders;
		static int urlInvalid;
		static int urlInit;
		static int urlLoading;
		static int urlComplete;
		static int urlError;
		static bool hasActive( );
		static Dynamic hasActive_dyn();

		static Void initialize( ::String caCertFilePath);
		static Dynamic initialize_dyn();

		static bool __loadPending( );
		static Dynamic __loadPending_dyn();

		static Void __pollData( );
		static Dynamic __pollData_dyn();

		static Dynamic lime_curl_create;
		static Dynamic &lime_curl_create_dyn() { return lime_curl_create;}
		static Dynamic lime_curl_process_loaders;
		static Dynamic &lime_curl_process_loaders_dyn() { return lime_curl_process_loaders;}
		static Dynamic lime_curl_update_loader;
		static Dynamic &lime_curl_update_loader_dyn() { return lime_curl_update_loader;}
		static Dynamic lime_curl_get_code;
		static Dynamic &lime_curl_get_code_dyn() { return lime_curl_get_code;}
		static Dynamic lime_curl_get_error_message;
		static Dynamic &lime_curl_get_error_message_dyn() { return lime_curl_get_error_message;}
		static Dynamic lime_curl_get_data;
		static Dynamic &lime_curl_get_data_dyn() { return lime_curl_get_data;}
		static Dynamic lime_curl_get_cookies;
		static Dynamic &lime_curl_get_cookies_dyn() { return lime_curl_get_cookies;}
		static Dynamic lime_curl_get_headers;
		static Dynamic &lime_curl_get_headers_dyn() { return lime_curl_get_headers;}
		static Dynamic lime_curl_initialize;
		static Dynamic &lime_curl_initialize_dyn() { return lime_curl_initialize;}
};

} // end namespace flash
} // end namespace net

#endif /* INCLUDED_flash_net_URLLoader */ 
