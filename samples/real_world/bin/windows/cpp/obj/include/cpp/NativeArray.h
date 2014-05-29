#ifndef INCLUDED_cpp_NativeArray
#define INCLUDED_cpp_NativeArray

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(cpp,NativeArray)
namespace cpp{


class HXCPP_CLASS_ATTRIBUTES  NativeArray_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef NativeArray_obj OBJ_;
		NativeArray_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< NativeArray_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~NativeArray_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("NativeArray"); }

		static Void blit( Dynamic ioDestArray,int inDestElement,Dynamic inSourceArray,int inSourceElement,int inElementCount);
		static Dynamic blit_dyn();

		static Void zero( Dynamic ioDestArray,Dynamic inFirst,Dynamic inElements);
		static Dynamic zero_dyn();

		static Dynamic unsafeGet( Dynamic inDestArray,int inIndex);
		static Dynamic unsafeGet_dyn();

		static Dynamic unsafeSet( Dynamic ioDestArray,int inIndex,Dynamic inValue);
		static Dynamic unsafeSet_dyn();

		static int memcmp( Dynamic inArrayA,Dynamic inArrayB);
		static Dynamic memcmp_dyn();

		static Dynamic setSize( Dynamic ioArray,int inSize);
		static Dynamic setSize_dyn();

};

} // end namespace cpp

#endif /* INCLUDED_cpp_NativeArray */ 
