#ifndef INCLUDED_flash_system_SecurityDomain
#define INCLUDED_flash_system_SecurityDomain

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,system,SecurityDomain)
namespace flash{
namespace system{


class HXCPP_CLASS_ATTRIBUTES  SecurityDomain_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef SecurityDomain_obj OBJ_;
		SecurityDomain_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< SecurityDomain_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~SecurityDomain_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("SecurityDomain"); }

		static ::flash::system::SecurityDomain currentDomain;
};

} // end namespace flash
} // end namespace system

#endif /* INCLUDED_flash_system_SecurityDomain */ 
