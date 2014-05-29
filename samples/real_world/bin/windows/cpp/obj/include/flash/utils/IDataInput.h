#ifndef INCLUDED_flash_utils_IDataInput
#define INCLUDED_flash_utils_IDataInput

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,utils,ByteArray)
HX_DECLARE_CLASS2(flash,utils,IDataInput)
HX_DECLARE_CLASS2(flash,utils,IDataOutput)
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(openfl,utils,IMemoryRange)
namespace flash{
namespace utils{


class HXCPP_CLASS_ATTRIBUTES  IDataInput_obj : public hx::Interface{
	public:
		typedef hx::Interface super;
		typedef IDataInput_obj OBJ_;
		HX_DO_INTERFACE_RTTI;
		static void __boot();
virtual bool readBoolean( )=0;
		Dynamic readBoolean_dyn();
virtual int readByte( )=0;
		Dynamic readByte_dyn();
virtual Void readBytes( ::flash::utils::ByteArray data,hx::Null< int >  offset,hx::Null< int >  length)=0;
		Dynamic readBytes_dyn();
virtual Float readDouble( )=0;
		Dynamic readDouble_dyn();
virtual Float readFloat( )=0;
		Dynamic readFloat_dyn();
virtual int readInt( )=0;
		Dynamic readInt_dyn();
virtual int readShort( )=0;
		Dynamic readShort_dyn();
virtual int readUnsignedByte( )=0;
		Dynamic readUnsignedByte_dyn();
virtual int readUnsignedInt( )=0;
		Dynamic readUnsignedInt_dyn();
virtual int readUnsignedShort( )=0;
		Dynamic readUnsignedShort_dyn();
virtual ::String readUTF( )=0;
		Dynamic readUTF_dyn();
virtual ::String readUTFBytes( int length)=0;
		Dynamic readUTFBytes_dyn();
};

#define DELEGATE_flash_utils_IDataInput \
virtual bool readBoolean( ) { return mDelegate->readBoolean();}  \
virtual Dynamic readBoolean_dyn() { return mDelegate->readBoolean_dyn();}  \
virtual int readByte( ) { return mDelegate->readByte();}  \
virtual Dynamic readByte_dyn() { return mDelegate->readByte_dyn();}  \
virtual Void readBytes( ::flash::utils::ByteArray data,hx::Null< int >  offset,hx::Null< int >  length) { return mDelegate->readBytes(data,offset,length);}  \
virtual Dynamic readBytes_dyn() { return mDelegate->readBytes_dyn();}  \
virtual Float readDouble( ) { return mDelegate->readDouble();}  \
virtual Dynamic readDouble_dyn() { return mDelegate->readDouble_dyn();}  \
virtual Float readFloat( ) { return mDelegate->readFloat();}  \
virtual Dynamic readFloat_dyn() { return mDelegate->readFloat_dyn();}  \
virtual int readInt( ) { return mDelegate->readInt();}  \
virtual Dynamic readInt_dyn() { return mDelegate->readInt_dyn();}  \
virtual int readShort( ) { return mDelegate->readShort();}  \
virtual Dynamic readShort_dyn() { return mDelegate->readShort_dyn();}  \
virtual int readUnsignedByte( ) { return mDelegate->readUnsignedByte();}  \
virtual Dynamic readUnsignedByte_dyn() { return mDelegate->readUnsignedByte_dyn();}  \
virtual int readUnsignedInt( ) { return mDelegate->readUnsignedInt();}  \
virtual Dynamic readUnsignedInt_dyn() { return mDelegate->readUnsignedInt_dyn();}  \
virtual int readUnsignedShort( ) { return mDelegate->readUnsignedShort();}  \
virtual Dynamic readUnsignedShort_dyn() { return mDelegate->readUnsignedShort_dyn();}  \
virtual ::String readUTF( ) { return mDelegate->readUTF();}  \
virtual Dynamic readUTF_dyn() { return mDelegate->readUTF_dyn();}  \
virtual ::String readUTFBytes( int length) { return mDelegate->readUTFBytes(length);}  \
virtual Dynamic readUTFBytes_dyn() { return mDelegate->readUTFBytes_dyn();}  \


template<typename IMPL>
class IDataInput_delegate_ : public IDataInput_obj
{
	protected:
		IMPL *mDelegate;
	public:
		IDataInput_delegate_(IMPL *inDelegate) : mDelegate(inDelegate) {}
		hx::Object *__GetRealObject() { return mDelegate; }
		void __Visit(HX_VISIT_PARAMS) { HX_VISIT_OBJECT(mDelegate); }
		DELEGATE_flash_utils_IDataInput
};

} // end namespace flash
} // end namespace utils

#endif /* INCLUDED_flash_utils_IDataInput */ 
