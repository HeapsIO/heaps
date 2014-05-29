#ifndef INCLUDED_flash_utils_IDataOutput
#define INCLUDED_flash_utils_IDataOutput

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,utils,IDataOutput)
HX_DECLARE_CLASS2(haxe,io,Bytes)
namespace flash{
namespace utils{


class HXCPP_CLASS_ATTRIBUTES  IDataOutput_obj : public hx::Interface{
	public:
		typedef hx::Interface super;
		typedef IDataOutput_obj OBJ_;
		HX_DO_INTERFACE_RTTI;
		static void __boot();
virtual Void writeBoolean( bool value)=0;
		Dynamic writeBoolean_dyn();
virtual Void writeByte( int value)=0;
		Dynamic writeByte_dyn();
virtual Void writeBytes( ::haxe::io::Bytes bytes,hx::Null< int >  offset,hx::Null< int >  length)=0;
		Dynamic writeBytes_dyn();
virtual Void writeDouble( Float value)=0;
		Dynamic writeDouble_dyn();
virtual Void writeFloat( Float value)=0;
		Dynamic writeFloat_dyn();
virtual Void writeInt( int value)=0;
		Dynamic writeInt_dyn();
virtual Void writeShort( int value)=0;
		Dynamic writeShort_dyn();
virtual Void writeUnsignedInt( int value)=0;
		Dynamic writeUnsignedInt_dyn();
virtual Void writeUTF( ::String value)=0;
		Dynamic writeUTF_dyn();
virtual Void writeUTFBytes( ::String value)=0;
		Dynamic writeUTFBytes_dyn();
};

#define DELEGATE_flash_utils_IDataOutput \
virtual Void writeBoolean( bool value) { return mDelegate->writeBoolean(value);}  \
virtual Dynamic writeBoolean_dyn() { return mDelegate->writeBoolean_dyn();}  \
virtual Void writeByte( int value) { return mDelegate->writeByte(value);}  \
virtual Dynamic writeByte_dyn() { return mDelegate->writeByte_dyn();}  \
virtual Void writeBytes( ::haxe::io::Bytes bytes,hx::Null< int >  offset,hx::Null< int >  length) { return mDelegate->writeBytes(bytes,offset,length);}  \
virtual Dynamic writeBytes_dyn() { return mDelegate->writeBytes_dyn();}  \
virtual Void writeDouble( Float value) { return mDelegate->writeDouble(value);}  \
virtual Dynamic writeDouble_dyn() { return mDelegate->writeDouble_dyn();}  \
virtual Void writeFloat( Float value) { return mDelegate->writeFloat(value);}  \
virtual Dynamic writeFloat_dyn() { return mDelegate->writeFloat_dyn();}  \
virtual Void writeInt( int value) { return mDelegate->writeInt(value);}  \
virtual Dynamic writeInt_dyn() { return mDelegate->writeInt_dyn();}  \
virtual Void writeShort( int value) { return mDelegate->writeShort(value);}  \
virtual Dynamic writeShort_dyn() { return mDelegate->writeShort_dyn();}  \
virtual Void writeUnsignedInt( int value) { return mDelegate->writeUnsignedInt(value);}  \
virtual Dynamic writeUnsignedInt_dyn() { return mDelegate->writeUnsignedInt_dyn();}  \
virtual Void writeUTF( ::String value) { return mDelegate->writeUTF(value);}  \
virtual Dynamic writeUTF_dyn() { return mDelegate->writeUTF_dyn();}  \
virtual Void writeUTFBytes( ::String value) { return mDelegate->writeUTFBytes(value);}  \
virtual Dynamic writeUTFBytes_dyn() { return mDelegate->writeUTFBytes_dyn();}  \


template<typename IMPL>
class IDataOutput_delegate_ : public IDataOutput_obj
{
	protected:
		IMPL *mDelegate;
	public:
		IDataOutput_delegate_(IMPL *inDelegate) : mDelegate(inDelegate) {}
		hx::Object *__GetRealObject() { return mDelegate; }
		void __Visit(HX_VISIT_PARAMS) { HX_VISIT_OBJECT(mDelegate); }
		DELEGATE_flash_utils_IDataOutput
};

} // end namespace flash
} // end namespace utils

#endif /* INCLUDED_flash_utils_IDataOutput */ 
