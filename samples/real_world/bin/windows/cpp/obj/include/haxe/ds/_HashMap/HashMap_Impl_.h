#ifndef INCLUDED_haxe_ds__HashMap_HashMap_Impl_
#define INCLUDED_haxe_ds__HashMap_HashMap_Impl_

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS3(haxe,ds,_HashMap,HashMap_Impl_)
namespace haxe{
namespace ds{
namespace _HashMap{


class HXCPP_CLASS_ATTRIBUTES  HashMap_Impl__obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef HashMap_Impl__obj OBJ_;
		HashMap_Impl__obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< HashMap_Impl__obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~HashMap_Impl__obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("HashMap_Impl_"); }

		static Dynamic _new( );
		static Dynamic _new_dyn();

		static Void set( Dynamic this1,Dynamic k,Dynamic v);
		static Dynamic set_dyn();

		static Dynamic get( Dynamic this1,Dynamic k);
		static Dynamic get_dyn();

		static bool exists( Dynamic this1,Dynamic k);
		static Dynamic exists_dyn();

		static bool remove( Dynamic this1,Dynamic k);
		static Dynamic remove_dyn();

		static Dynamic keys( Dynamic this1);
		static Dynamic keys_dyn();

		static Dynamic iterator( Dynamic this1);
		static Dynamic iterator_dyn();

};

} // end namespace haxe
} // end namespace ds
} // end namespace _HashMap

#endif /* INCLUDED_haxe_ds__HashMap_HashMap_Impl_ */ 
