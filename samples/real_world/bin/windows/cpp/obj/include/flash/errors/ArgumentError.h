#ifndef INCLUDED_flash_errors_ArgumentError
#define INCLUDED_flash_errors_ArgumentError

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <flash/errors/Error.h>
HX_DECLARE_CLASS2(flash,errors,ArgumentError)
HX_DECLARE_CLASS2(flash,errors,Error)
namespace flash{
namespace errors{


class HXCPP_CLASS_ATTRIBUTES  ArgumentError_obj : public ::flash::errors::Error_obj{
	public:
		typedef ::flash::errors::Error_obj super;
		typedef ArgumentError_obj OBJ_;
		ArgumentError_obj();
		Void __construct(Dynamic message,Dynamic id);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< ArgumentError_obj > __new(Dynamic message,Dynamic id);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~ArgumentError_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("ArgumentError"); }

};

} // end namespace flash
} // end namespace errors

#endif /* INCLUDED_flash_errors_ArgumentError */ 
