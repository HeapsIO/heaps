#ifndef INCLUDED_haxe_ds__Vector_Vector_Impl_
#define INCLUDED_haxe_ds__Vector_Vector_Impl_

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS3(haxe,ds,_Vector,Vector_Impl_)
namespace haxe{
namespace ds{
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

		static Dynamic _new( int length);
		static Dynamic _new_dyn();

		static Dynamic get( Dynamic this1,int index);
		static Dynamic get_dyn();

		static Dynamic set( Dynamic this1,int index,Dynamic val);
		static Dynamic set_dyn();

		static int get_length( Dynamic this1);
		static Dynamic get_length_dyn();

		static Void blit( Dynamic src,int srcPos,Dynamic dest,int destPos,int len);
		static Dynamic blit_dyn();

		static Dynamic toArray( Dynamic this1);
		static Dynamic toArray_dyn();

		static Dynamic toData( Dynamic this1);
		static Dynamic toData_dyn();

		static Dynamic fromData( Dynamic data);
		static Dynamic fromData_dyn();

		static Dynamic fromArrayCopy( Dynamic array);
		static Dynamic fromArrayCopy_dyn();

};

} // end namespace haxe
} // end namespace ds
} // end namespace _Vector

#endif /* INCLUDED_haxe_ds__Vector_Vector_Impl_ */ 
