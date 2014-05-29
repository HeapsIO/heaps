#ifndef INCLUDED_flash_errors_EOFError
#define INCLUDED_flash_errors_EOFError

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <flash/errors/Error.h>
HX_DECLARE_CLASS2(flash,errors,EOFError)
HX_DECLARE_CLASS2(flash,errors,Error)
namespace flash{
namespace errors{


class HXCPP_CLASS_ATTRIBUTES  EOFError_obj : public ::flash::errors::Error_obj{
	public:
		typedef ::flash::errors::Error_obj super;
		typedef EOFError_obj OBJ_;
		EOFError_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< EOFError_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~EOFError_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("EOFError"); }

};

} // end namespace flash
} // end namespace errors

#endif /* INCLUDED_flash_errors_EOFError */ 
