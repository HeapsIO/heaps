#ifndef INCLUDED_haxe_ds_StringMap
#define INCLUDED_haxe_ds_StringMap

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <IMap.h>
HX_DECLARE_CLASS0(IMap)
HX_DECLARE_CLASS2(haxe,ds,StringMap)
namespace haxe{
namespace ds{


class HXCPP_CLASS_ATTRIBUTES  StringMap_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef StringMap_obj OBJ_;
		StringMap_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< StringMap_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~StringMap_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		inline operator ::IMap_obj *()
			{ return new ::IMap_delegate_< StringMap_obj >(this); }
		hx::Object *__ToInterface(const hx::type_info &inType);
		::String __ToString() const { return HX_CSTRING("StringMap"); }

		Dynamic __Internal;
		virtual Void set( Dynamic _tmp_key,Dynamic value);
		Dynamic set_dyn();

		virtual Dynamic get( Dynamic _tmp_key);
		Dynamic get_dyn();

		virtual bool exists( Dynamic _tmp_key);
		Dynamic exists_dyn();

		virtual bool remove( Dynamic _tmp_key);
		Dynamic remove_dyn();

		virtual Dynamic keys( );
		Dynamic keys_dyn();

		virtual Dynamic iterator( );
		Dynamic iterator_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

};

} // end namespace haxe
} // end namespace ds

#endif /* INCLUDED_haxe_ds_StringMap */ 
