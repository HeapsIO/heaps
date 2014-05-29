#ifndef INCLUDED_openfl_utils_ArrayBufferView
#define INCLUDED_openfl_utils_ArrayBufferView

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <openfl/utils/IMemoryRange.h>
HX_DECLARE_CLASS2(flash,utils,ByteArray)
HX_DECLARE_CLASS2(flash,utils,IDataInput)
HX_DECLARE_CLASS2(flash,utils,IDataOutput)
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(openfl,utils,ArrayBufferView)
HX_DECLARE_CLASS2(openfl,utils,IMemoryRange)
namespace openfl{
namespace utils{


class HXCPP_CLASS_ATTRIBUTES  ArrayBufferView_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef ArrayBufferView_obj OBJ_;
		ArrayBufferView_obj();
		Void __construct(Dynamic lengthOrBuffer,hx::Null< int >  __o_byteOffset,Dynamic length);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< ArrayBufferView_obj > __new(Dynamic lengthOrBuffer,hx::Null< int >  __o_byteOffset,Dynamic length);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~ArrayBufferView_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		inline operator ::openfl::utils::IMemoryRange_obj *()
			{ return new ::openfl::utils::IMemoryRange_delegate_< ArrayBufferView_obj >(this); }
		hx::Object *__ToInterface(const hx::type_info &inType);
		::String __ToString() const { return HX_CSTRING("ArrayBufferView"); }

		::flash::utils::ByteArray buffer;
		int byteOffset;
		int byteLength;
		Array< unsigned char > bytes;
		virtual ::flash::utils::ByteArray getByteBuffer( );
		Dynamic getByteBuffer_dyn();

		virtual Float getFloat32( int position);
		Dynamic getFloat32_dyn();

		virtual int getInt16( int position);
		Dynamic getInt16_dyn();

		virtual int getInt32( int position);
		Dynamic getInt32_dyn();

		virtual int getLength( );
		Dynamic getLength_dyn();

		virtual Dynamic getNativePointer( );
		Dynamic getNativePointer_dyn();

		virtual int getStart( );
		Dynamic getStart_dyn();

		virtual int getUInt8( int position);
		Dynamic getUInt8_dyn();

		virtual Void setFloat32( int position,Float value);
		Dynamic setFloat32_dyn();

		virtual Void setInt16( int position,int value);
		Dynamic setInt16_dyn();

		virtual Void setInt32( int position,int value);
		Dynamic setInt32_dyn();

		virtual Void setUInt8( int position,int value);
		Dynamic setUInt8_dyn();

		static ::String invalidDataIndex;
};

} // end namespace openfl
} // end namespace utils

#endif /* INCLUDED_openfl_utils_ArrayBufferView */ 
