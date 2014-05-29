#ifndef INCLUDED__Map_Map_Impl_
#define INCLUDED__Map_Map_Impl_

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(IMap)
HX_DECLARE_CLASS1(_Map,Map_Impl_)
HX_DECLARE_CLASS2(haxe,ds,BalancedTree)
HX_DECLARE_CLASS2(haxe,ds,EnumValueMap)
HX_DECLARE_CLASS2(haxe,ds,IntMap)
HX_DECLARE_CLASS2(haxe,ds,ObjectMap)
HX_DECLARE_CLASS2(haxe,ds,StringMap)
namespace _Map{


class HXCPP_CLASS_ATTRIBUTES  Map_Impl__obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Map_Impl__obj OBJ_;
		Map_Impl__obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Map_Impl__obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Map_Impl__obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Map_Impl_"); }

		static Dynamic _new;
		static Dynamic &_new_dyn() { return _new;}
		static Void set( ::IMap this1,Dynamic key,Dynamic value);
		static Dynamic set_dyn();

		static Dynamic get( ::IMap this1,Dynamic key);
		static Dynamic get_dyn();

		static bool exists( ::IMap this1,Dynamic key);
		static Dynamic exists_dyn();

		static bool remove( ::IMap this1,Dynamic key);
		static Dynamic remove_dyn();

		static Dynamic keys( ::IMap this1);
		static Dynamic keys_dyn();

		static Dynamic iterator( ::IMap this1);
		static Dynamic iterator_dyn();

		static ::String toString( ::IMap this1);
		static Dynamic toString_dyn();

		static Dynamic arrayWrite( ::IMap this1,Dynamic k,Dynamic v);
		static Dynamic arrayWrite_dyn();

		static ::haxe::ds::StringMap toStringMap( ::IMap t);
		static Dynamic toStringMap_dyn();

		static ::haxe::ds::IntMap toIntMap( ::IMap t);
		static Dynamic toIntMap_dyn();

		static ::haxe::ds::EnumValueMap toEnumValueMapMap( ::IMap t);
		static Dynamic toEnumValueMapMap_dyn();

		static ::haxe::ds::ObjectMap toObjectMap( ::IMap t);
		static Dynamic toObjectMap_dyn();

		static ::haxe::ds::StringMap fromStringMap( ::haxe::ds::StringMap map);
		static Dynamic fromStringMap_dyn();

		static ::haxe::ds::IntMap fromIntMap( ::haxe::ds::IntMap map);
		static Dynamic fromIntMap_dyn();

		static ::haxe::ds::ObjectMap fromObjectMap( ::haxe::ds::ObjectMap map);
		static Dynamic fromObjectMap_dyn();

};

} // end namespace _Map

#endif /* INCLUDED__Map_Map_Impl_ */ 
