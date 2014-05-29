#ifndef INCLUDED_openfl_utils_Float32Array
#define INCLUDED_openfl_utils_Float32Array

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <openfl/utils/ArrayBufferView.h>
HX_DECLARE_CLASS2(flash,geom,Matrix3D)
HX_DECLARE_CLASS2(openfl,utils,ArrayBufferView)
HX_DECLARE_CLASS2(openfl,utils,Float32Array)
HX_DECLARE_CLASS2(openfl,utils,IMemoryRange)
namespace openfl{
namespace utils{


class HXCPP_CLASS_ATTRIBUTES  Float32Array_obj : public ::openfl::utils::ArrayBufferView_obj{
	public:
		typedef ::openfl::utils::ArrayBufferView_obj super;
		typedef Float32Array_obj OBJ_;
		Float32Array_obj();
		Void __construct(Dynamic bufferOrArray,hx::Null< int >  __o_start,Dynamic length);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Float32Array_obj > __new(Dynamic bufferOrArray,hx::Null< int >  __o_start,Dynamic length);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Float32Array_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Float32Array"); }

		typedef Float __array_access;
		int BYTES_PER_ELEMENT;
		int length;
		virtual Float __get( int index);
		Dynamic __get_dyn();

		virtual Void __set( int index,Float value);
		Dynamic __set_dyn();

		static int SBYTES_PER_ELEMENT;
		static ::openfl::utils::Float32Array fromMatrix( ::flash::geom::Matrix3D matrix);
		static Dynamic fromMatrix_dyn();

};

} // end namespace openfl
} // end namespace utils

#endif /* INCLUDED_openfl_utils_Float32Array */ 
