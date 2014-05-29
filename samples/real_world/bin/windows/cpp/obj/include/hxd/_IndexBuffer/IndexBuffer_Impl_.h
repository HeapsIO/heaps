#ifndef INCLUDED_hxd__IndexBuffer_IndexBuffer_Impl_
#define INCLUDED_hxd__IndexBuffer_IndexBuffer_Impl_

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(hxd,_IndexBuffer,IndexBuffer_Impl_)
HX_DECLARE_CLASS2(hxd,_IndexBuffer,InnerIterator)
namespace hxd{
namespace _IndexBuffer{


class HXCPP_CLASS_ATTRIBUTES  IndexBuffer_Impl__obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef IndexBuffer_Impl__obj OBJ_;
		IndexBuffer_Impl__obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< IndexBuffer_Impl__obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~IndexBuffer_Impl__obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("IndexBuffer_Impl_"); }

		static Array< int > _new( hx::Null< int >  length);
		static Dynamic _new_dyn();

		static Array< int > fromArray( Array< int > arr);
		static Dynamic fromArray_dyn();

		static Void push( Array< int > this1,int v);
		static Dynamic push_dyn();

		static int arrayRead( Array< int > this1,int key);
		static Dynamic arrayRead_dyn();

		static int arrayWrite( Array< int > this1,int key,int value);
		static Dynamic arrayWrite_dyn();

		static Array< int > getNative( Array< int > this1);
		static Dynamic getNative_dyn();

		static ::hxd::_IndexBuffer::InnerIterator iterator( Array< int > this1);
		static Dynamic iterator_dyn();

		static int get_length( Array< int > this1);
		static Dynamic get_length_dyn();

};

} // end namespace hxd
} // end namespace _IndexBuffer

#endif /* INCLUDED_hxd__IndexBuffer_IndexBuffer_Impl_ */ 
