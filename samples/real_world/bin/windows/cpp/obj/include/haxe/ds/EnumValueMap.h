#ifndef INCLUDED_haxe_ds_EnumValueMap
#define INCLUDED_haxe_ds_EnumValueMap

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <haxe/ds/BalancedTree.h>
#include <IMap.h>
HX_DECLARE_CLASS0(IMap)
HX_DECLARE_CLASS2(haxe,ds,BalancedTree)
HX_DECLARE_CLASS2(haxe,ds,EnumValueMap)
namespace haxe{
namespace ds{


class HXCPP_CLASS_ATTRIBUTES  EnumValueMap_obj : public ::haxe::ds::BalancedTree_obj{
	public:
		typedef ::haxe::ds::BalancedTree_obj super;
		typedef EnumValueMap_obj OBJ_;
		EnumValueMap_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< EnumValueMap_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~EnumValueMap_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		inline operator ::IMap_obj *()
			{ return new ::IMap_delegate_< EnumValueMap_obj >(this); }
		hx::Object *__ToInterface(const hx::type_info &inType);
		::String __ToString() const { return HX_CSTRING("EnumValueMap"); }

		virtual int compare( Dynamic _tmp_k1,Dynamic _tmp_k2);

		virtual int compareArgs( Dynamic a1,Dynamic a2);
		Dynamic compareArgs_dyn();

		virtual int compareArg( Dynamic v1,Dynamic v2);
		Dynamic compareArg_dyn();

};

} // end namespace haxe
} // end namespace ds

#endif /* INCLUDED_haxe_ds_EnumValueMap */ 
