#ifndef INCLUDED_flash_system_LoaderContext
#define INCLUDED_flash_system_LoaderContext

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,system,ApplicationDomain)
HX_DECLARE_CLASS2(flash,system,LoaderContext)
HX_DECLARE_CLASS2(flash,system,SecurityDomain)
namespace flash{
namespace system{


class HXCPP_CLASS_ATTRIBUTES  LoaderContext_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef LoaderContext_obj OBJ_;
		LoaderContext_obj();
		Void __construct(hx::Null< bool >  __o_checkPolicyFile,::flash::system::ApplicationDomain applicationDomain,::flash::system::SecurityDomain securityDomain);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< LoaderContext_obj > __new(hx::Null< bool >  __o_checkPolicyFile,::flash::system::ApplicationDomain applicationDomain,::flash::system::SecurityDomain securityDomain);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~LoaderContext_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("LoaderContext"); }

		bool allowCodeImport;
		bool allowLoadBytesCodeExecution;
		::flash::system::ApplicationDomain applicationDomain;
		bool checkPolicyFile;
		::flash::system::SecurityDomain securityDomain;
};

} // end namespace flash
} // end namespace system

#endif /* INCLUDED_flash_system_LoaderContext */ 
