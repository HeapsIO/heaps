#ifndef INCLUDED_hxd__FloatBuffer_FloatBuffer_Impl_
#define INCLUDED_hxd__FloatBuffer_FloatBuffer_Impl_

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(hxd,_FloatBuffer,FloatBuffer_Impl_)
HX_DECLARE_CLASS2(hxd,_FloatBuffer,InnerIterator)
namespace hxd{
namespace _FloatBuffer{


class HXCPP_CLASS_ATTRIBUTES  FloatBuffer_Impl__obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef FloatBuffer_Impl__obj OBJ_;
		FloatBuffer_Impl__obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< FloatBuffer_Impl__obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~FloatBuffer_Impl__obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("FloatBuffer_Impl_"); }

		static Array< Float > _new( hx::Null< int >  length);
		static Dynamic _new_dyn();

		static Void push( Array< Float > this1,Float v);
		static Dynamic push_dyn();

		static Array< Float > fromArray( Array< Float > arr);
		static Dynamic fromArray_dyn();

		static Array< Float > makeView( Array< Float > arr);
		static Dynamic makeView_dyn();

		static Void grow( Array< Float > this1,int v);
		static Dynamic grow_dyn();

		static Void resize( Array< Float > this1,int v);
		static Dynamic resize_dyn();

		static Float arrayRead( Array< Float > this1,int key);
		static Dynamic arrayRead_dyn();

		static Float arrayWrite( Array< Float > this1,int key,Float value);
		static Dynamic arrayWrite_dyn();

		static Array< Float > getNative( Array< Float > this1);
		static Dynamic getNative_dyn();

		static ::hxd::_FloatBuffer::InnerIterator iterator( Array< Float > this1);
		static Dynamic iterator_dyn();

		static int get_length( Array< Float > this1);
		static Dynamic get_length_dyn();

		static Void blit( Array< Float > this1,Array< Float > src,int count);
		static Dynamic blit_dyn();

		static Void zero( Array< Float > this1);
		static Dynamic zero_dyn();

		static Array< Float > clone( Array< Float > this1);
		static Dynamic clone_dyn();

};

} // end namespace hxd
} // end namespace _FloatBuffer

#endif /* INCLUDED_hxd__FloatBuffer_FloatBuffer_Impl_ */ 
