#ifndef INCLUDED_flash_net_URLVariables
#define INCLUDED_flash_net_URLVariables

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,net,URLVariables)
namespace flash{
namespace net{


class HXCPP_CLASS_ATTRIBUTES  URLVariables_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef URLVariables_obj OBJ_;
		URLVariables_obj();
		Void __construct(::String encoded);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< URLVariables_obj > __new(::String encoded);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~URLVariables_obj();

		HX_DO_RTTI;
		HX_DECLARE_IMPLEMENT_DYNAMIC;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("URLVariables"); }

		virtual Void decode( ::String data);
		Dynamic decode_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

};

} // end namespace flash
} // end namespace net

#endif /* INCLUDED_flash_net_URLVariables */ 
