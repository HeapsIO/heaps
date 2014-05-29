#ifndef INCLUDED_haxe__EnumFlags_EnumFlags_Impl_
#define INCLUDED_haxe__EnumFlags_EnumFlags_Impl_

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(haxe,_EnumFlags,EnumFlags_Impl_)
namespace haxe{
namespace _EnumFlags{


class HXCPP_CLASS_ATTRIBUTES  EnumFlags_Impl__obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef EnumFlags_Impl__obj OBJ_;
		EnumFlags_Impl__obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< EnumFlags_Impl__obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~EnumFlags_Impl__obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("EnumFlags_Impl_"); }

		static int _new( hx::Null< int >  i);
		static Dynamic _new_dyn();

		static bool has( int this1,Dynamic v);
		static Dynamic has_dyn();

		static Void set( int this1,Dynamic v);
		static Dynamic set_dyn();

		static Void unset( int this1,Dynamic v);
		static Dynamic unset_dyn();

		static int ofInt( int i);
		static Dynamic ofInt_dyn();

		static int toInt( int this1);
		static Dynamic toInt_dyn();

};

} // end namespace haxe
} // end namespace _EnumFlags

#endif /* INCLUDED_haxe__EnumFlags_EnumFlags_Impl_ */ 
