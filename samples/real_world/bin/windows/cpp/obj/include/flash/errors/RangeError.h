#ifndef INCLUDED_flash_errors_RangeError
#define INCLUDED_flash_errors_RangeError

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <flash/errors/Error.h>
HX_DECLARE_CLASS2(flash,errors,Error)
HX_DECLARE_CLASS2(flash,errors,RangeError)
namespace flash{
namespace errors{


class HXCPP_CLASS_ATTRIBUTES  RangeError_obj : public ::flash::errors::Error_obj{
	public:
		typedef ::flash::errors::Error_obj super;
		typedef RangeError_obj OBJ_;
		RangeError_obj();
		Void __construct(::String __o_message);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< RangeError_obj > __new(::String __o_message);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~RangeError_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("RangeError"); }

};

} // end namespace flash
} // end namespace errors

#endif /* INCLUDED_flash_errors_RangeError */ 
