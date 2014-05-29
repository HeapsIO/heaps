#ifndef INCLUDED_flash_net_URLRequestMethod
#define INCLUDED_flash_net_URLRequestMethod

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,net,URLRequestMethod)
namespace flash{
namespace net{


class HXCPP_CLASS_ATTRIBUTES  URLRequestMethod_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef URLRequestMethod_obj OBJ_;
		URLRequestMethod_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< URLRequestMethod_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~URLRequestMethod_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("URLRequestMethod"); }

		static ::String DELETE;
		static ::String GET;
		static ::String HEAD;
		static ::String OPTIONS;
		static ::String POST;
		static ::String PUT;
};

} // end namespace flash
} // end namespace net

#endif /* INCLUDED_flash_net_URLRequestMethod */ 
