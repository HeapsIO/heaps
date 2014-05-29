#ifndef INCLUDED_flash__Vector_Vector_Impl_
#define INCLUDED_flash__Vector_Vector_Impl_

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,_Vector,Vector_Impl_)
namespace flash{
namespace _Vector{


class HXCPP_CLASS_ATTRIBUTES  Vector_Impl__obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Vector_Impl__obj OBJ_;
		Vector_Impl__obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Vector_Impl__obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Vector_Impl__obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Vector_Impl_"); }

		static Dynamic _new( Dynamic length,Dynamic fixed);
		static Dynamic _new_dyn();

		static Dynamic concat( Dynamic this1,Dynamic a);
		static Dynamic concat_dyn();

		static Dynamic copy( Dynamic this1);
		static Dynamic copy_dyn();

		static Dynamic iterator( Dynamic this1);
		static Dynamic iterator_dyn();

		static ::String join( Dynamic this1,::String sep);
		static Dynamic join_dyn();

		static Dynamic pop( Dynamic this1);
		static Dynamic pop_dyn();

		static int push( Dynamic this1,Dynamic x);
		static Dynamic push_dyn();

		static Void reverse( Dynamic this1);
		static Dynamic reverse_dyn();

		static Dynamic shift( Dynamic this1);
		static Dynamic shift_dyn();

		static Void unshift( Dynamic this1,Dynamic x);
		static Dynamic unshift_dyn();

		static Dynamic slice( Dynamic this1,Dynamic pos,Dynamic end);
		static Dynamic slice_dyn();

		static Void sort( Dynamic this1,Dynamic f);
		static Dynamic sort_dyn();

		static Dynamic splice( Dynamic this1,int pos,int len);
		static Dynamic splice_dyn();

		static ::String toString( Dynamic this1);
		static Dynamic toString_dyn();

		static int indexOf( Dynamic this1,Dynamic x,Dynamic from);
		static Dynamic indexOf_dyn();

		static int lastIndexOf( Dynamic this1,Dynamic x,Dynamic from);
		static Dynamic lastIndexOf_dyn();

		static Dynamic ofArray( Dynamic a);
		static Dynamic ofArray_dyn();

		static Dynamic convert( Dynamic v);
		static Dynamic convert_dyn();

		static int get_length( Dynamic this1);
		static Dynamic get_length_dyn();

		static int set_length( Dynamic this1,int value);
		static Dynamic set_length_dyn();

		static bool get_fixed( Dynamic this1);
		static Dynamic get_fixed_dyn();

		static bool set_fixed( Dynamic this1,bool value);
		static Dynamic set_fixed_dyn();

};

} // end namespace flash
} // end namespace _Vector

#endif /* INCLUDED_flash__Vector_Vector_Impl_ */ 
