#ifndef INCLUDED_flash_net_URLLoaderDataFormat
#define INCLUDED_flash_net_URLLoaderDataFormat

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,net,URLLoaderDataFormat)
namespace flash{
namespace net{


class URLLoaderDataFormat_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef URLLoaderDataFormat_obj OBJ_;

	public:
		URLLoaderDataFormat_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.net.URLLoaderDataFormat"); }
		::String __ToString() const { return HX_CSTRING("URLLoaderDataFormat.") + tag; }

		static ::flash::net::URLLoaderDataFormat BINARY;
		static inline ::flash::net::URLLoaderDataFormat BINARY_dyn() { return BINARY; }
		static ::flash::net::URLLoaderDataFormat TEXT;
		static inline ::flash::net::URLLoaderDataFormat TEXT_dyn() { return TEXT; }
		static ::flash::net::URLLoaderDataFormat VARIABLES;
		static inline ::flash::net::URLLoaderDataFormat VARIABLES_dyn() { return VARIABLES; }
};

} // end namespace flash
} // end namespace net

#endif /* INCLUDED_flash_net_URLLoaderDataFormat */ 
