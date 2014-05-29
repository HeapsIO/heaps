#include <hxcpp.h>

#ifndef INCLUDED_cpp_Lib
#include <cpp/Lib.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_haxe_io_Eof
#include <haxe/io/Eof.h>
#endif
#ifndef INCLUDED_haxe_io_Error
#include <haxe/io/Error.h>
#endif
#ifndef INCLUDED_haxe_io_Input
#include <haxe/io/Input.h>
#endif
#ifndef INCLUDED_haxe_io_Output
#include <haxe/io/Output.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
namespace haxe{
namespace io{

Void Output_obj::__construct()
{
	return null();
}

//Output_obj::~Output_obj() { }

Dynamic Output_obj::__CreateEmpty() { return  new Output_obj; }
hx::ObjectPtr< Output_obj > Output_obj::__new()
{  hx::ObjectPtr< Output_obj > result = new Output_obj();
	result->__construct();
	return result;}

Dynamic Output_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Output_obj > result = new Output_obj();
	result->__construct();
	return result;}

Void Output_obj::writeByte( int c){
{
		HX_STACK_FRAME("haxe.io.Output","writeByte",0xb4fe513a,"haxe.io.Output.writeByte","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Output.hx",39,0x534e08fe)
		HX_STACK_THIS(this)
		HX_STACK_ARG(c,"c")
		HX_STACK_LINE(39)
		HX_STACK_DO_THROW(HX_CSTRING("Not implemented"));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Output_obj,writeByte,(void))

int Output_obj::writeBytes( ::haxe::io::Bytes s,int pos,int len){
	HX_STACK_FRAME("haxe.io.Output","writeBytes",0xa988c1f9,"haxe.io.Output.writeBytes","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Output.hx",42,0x534e08fe)
	HX_STACK_THIS(this)
	HX_STACK_ARG(s,"s")
	HX_STACK_ARG(pos,"pos")
	HX_STACK_ARG(len,"len")
	HX_STACK_LINE(43)
	int k = len;		HX_STACK_VAR(k,"k");
	HX_STACK_LINE(44)
	Array< unsigned char > b = s->b;		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(46)
	if (((bool((bool((pos < (int)0)) || bool((len < (int)0)))) || bool(((pos + len) > s->length))))){
		HX_STACK_LINE(47)
		HX_STACK_DO_THROW(::haxe::io::Error_obj::OutsideBounds);
	}
	HX_STACK_LINE(49)
	while((true)){
		HX_STACK_LINE(49)
		if ((!(((k > (int)0))))){
			HX_STACK_LINE(49)
			break;
		}
		HX_STACK_LINE(55)
		this->writeByte(b->__get(pos));
		HX_STACK_LINE(59)
		(pos)++;
		HX_STACK_LINE(60)
		(k)--;
	}
	HX_STACK_LINE(62)
	return len;
}


HX_DEFINE_DYNAMIC_FUNC3(Output_obj,writeBytes,return )

Void Output_obj::flush( ){
{
		HX_STACK_FRAME("haxe.io.Output","flush",0xa15f0af7,"haxe.io.Output.flush","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Output.hx",65,0x534e08fe)
		HX_STACK_THIS(this)
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Output_obj,flush,(void))

Void Output_obj::close( ){
{
		HX_STACK_FRAME("haxe.io.Output","close",0xe726bfeb,"haxe.io.Output.close","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Output.hx",68,0x534e08fe)
		HX_STACK_THIS(this)
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Output_obj,close,(void))

bool Output_obj::set_bigEndian( bool b){
	HX_STACK_FRAME("haxe.io.Output","set_bigEndian",0x33881e91,"haxe.io.Output.set_bigEndian","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Output.hx",71,0x534e08fe)
	HX_STACK_THIS(this)
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(72)
	this->bigEndian = b;
	HX_STACK_LINE(73)
	return b;
}


HX_DEFINE_DYNAMIC_FUNC1(Output_obj,set_bigEndian,return )

Void Output_obj::write( ::haxe::io::Bytes s){
{
		HX_STACK_FRAME("haxe.io.Output","write",0x6f1d1512,"haxe.io.Output.write","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Output.hx",78,0x534e08fe)
		HX_STACK_THIS(this)
		HX_STACK_ARG(s,"s")
		HX_STACK_LINE(79)
		int l = s->length;		HX_STACK_VAR(l,"l");
		HX_STACK_LINE(80)
		int p = (int)0;		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(81)
		while((true)){
			HX_STACK_LINE(81)
			if ((!(((l > (int)0))))){
				HX_STACK_LINE(81)
				break;
			}
			HX_STACK_LINE(82)
			int k = this->writeBytes(s,p,l);		HX_STACK_VAR(k,"k");
			HX_STACK_LINE(83)
			if (((k == (int)0))){
				HX_STACK_LINE(83)
				HX_STACK_DO_THROW(::haxe::io::Error_obj::Blocked);
			}
			HX_STACK_LINE(84)
			hx::AddEq(p,k);
			HX_STACK_LINE(85)
			hx::SubEq(l,k);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Output_obj,write,(void))

Void Output_obj::writeFullBytes( ::haxe::io::Bytes s,int pos,int len){
{
		HX_STACK_FRAME("haxe.io.Output","writeFullBytes",0xc2c420ea,"haxe.io.Output.writeFullBytes","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Output.hx",90,0x534e08fe)
		HX_STACK_THIS(this)
		HX_STACK_ARG(s,"s")
		HX_STACK_ARG(pos,"pos")
		HX_STACK_ARG(len,"len")
		HX_STACK_LINE(90)
		while((true)){
			HX_STACK_LINE(90)
			if ((!(((len > (int)0))))){
				HX_STACK_LINE(90)
				break;
			}
			HX_STACK_LINE(91)
			int k = this->writeBytes(s,pos,len);		HX_STACK_VAR(k,"k");
			HX_STACK_LINE(92)
			hx::AddEq(pos,k);
			HX_STACK_LINE(93)
			hx::SubEq(len,k);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Output_obj,writeFullBytes,(void))

Void Output_obj::writeFloat( Float x){
{
		HX_STACK_FRAME("haxe.io.Output","writeFloat",0xee877f2a,"haxe.io.Output.writeFloat","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Output.hx",97,0x534e08fe)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_LINE(101)
		Array< unsigned char > _g = ::haxe::io::Output_obj::_float_bytes(x,this->bigEndian);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(101)
		::haxe::io::Bytes _g1 = ::haxe::io::Bytes_obj::ofData(_g);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(101)
		this->write(_g1);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Output_obj,writeFloat,(void))

Void Output_obj::writeDouble( Float x){
{
		HX_STACK_FRAME("haxe.io.Output","writeDouble",0xb97ccdc3,"haxe.io.Output.writeDouble","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Output.hx",151,0x534e08fe)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_LINE(155)
		Array< unsigned char > _g = ::haxe::io::Output_obj::_double_bytes(x,this->bigEndian);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(155)
		::haxe::io::Bytes _g1 = ::haxe::io::Bytes_obj::ofData(_g);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(155)
		this->write(_g1);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Output_obj,writeDouble,(void))

Void Output_obj::writeInt8( int x){
{
		HX_STACK_FRAME("haxe.io.Output","writeInt8",0xb996769b,"haxe.io.Output.writeInt8","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Output.hx",228,0x534e08fe)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_LINE(229)
		if (((bool((x < (int)-128)) || bool((x >= (int)128))))){
			HX_STACK_LINE(230)
			HX_STACK_DO_THROW(::haxe::io::Error_obj::Overflow);
		}
		HX_STACK_LINE(231)
		this->writeByte((int(x) & int((int)255)));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Output_obj,writeInt8,(void))

Void Output_obj::writeInt16( int x){
{
		HX_STACK_FRAME("haxe.io.Output","writeInt16",0xaa114b22,"haxe.io.Output.writeInt16","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Output.hx",234,0x534e08fe)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_LINE(235)
		if (((bool((x < (int)-32768)) || bool((x >= (int)32768))))){
			HX_STACK_LINE(235)
			HX_STACK_DO_THROW(::haxe::io::Error_obj::Overflow);
		}
		HX_STACK_LINE(236)
		this->writeUInt16((int(x) & int((int)65535)));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Output_obj,writeInt16,(void))

Void Output_obj::writeUInt16( int x){
{
		HX_STACK_FRAME("haxe.io.Output","writeUInt16",0x9fc0db91,"haxe.io.Output.writeUInt16","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Output.hx",239,0x534e08fe)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_LINE(240)
		if (((bool((x < (int)0)) || bool((x >= (int)65536))))){
			HX_STACK_LINE(240)
			HX_STACK_DO_THROW(::haxe::io::Error_obj::Overflow);
		}
		HX_STACK_LINE(241)
		if ((this->bigEndian)){
			HX_STACK_LINE(242)
			this->writeByte((int(x) >> int((int)8)));
			HX_STACK_LINE(243)
			this->writeByte((int(x) & int((int)255)));
		}
		else{
			HX_STACK_LINE(245)
			this->writeByte((int(x) & int((int)255)));
			HX_STACK_LINE(246)
			this->writeByte((int(x) >> int((int)8)));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Output_obj,writeUInt16,(void))

Void Output_obj::writeInt24( int x){
{
		HX_STACK_FRAME("haxe.io.Output","writeInt24",0xaa114bff,"haxe.io.Output.writeInt24","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Output.hx",250,0x534e08fe)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_LINE(251)
		if (((bool((x < (int)-8388608)) || bool((x >= (int)8388608))))){
			HX_STACK_LINE(251)
			HX_STACK_DO_THROW(::haxe::io::Error_obj::Overflow);
		}
		HX_STACK_LINE(252)
		this->writeUInt24((int(x) & int((int)16777215)));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Output_obj,writeInt24,(void))

Void Output_obj::writeUInt24( int x){
{
		HX_STACK_FRAME("haxe.io.Output","writeUInt24",0x9fc0dc6e,"haxe.io.Output.writeUInt24","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Output.hx",255,0x534e08fe)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_LINE(256)
		if (((bool((x < (int)0)) || bool((x >= (int)16777216))))){
			HX_STACK_LINE(256)
			HX_STACK_DO_THROW(::haxe::io::Error_obj::Overflow);
		}
		HX_STACK_LINE(257)
		if ((this->bigEndian)){
			HX_STACK_LINE(258)
			this->writeByte((int(x) >> int((int)16)));
			HX_STACK_LINE(259)
			this->writeByte((int((int(x) >> int((int)8))) & int((int)255)));
			HX_STACK_LINE(260)
			this->writeByte((int(x) & int((int)255)));
		}
		else{
			HX_STACK_LINE(262)
			this->writeByte((int(x) & int((int)255)));
			HX_STACK_LINE(263)
			this->writeByte((int((int(x) >> int((int)8))) & int((int)255)));
			HX_STACK_LINE(264)
			this->writeByte((int(x) >> int((int)16)));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Output_obj,writeUInt24,(void))

Void Output_obj::writeInt32( int x){
{
		HX_STACK_FRAME("haxe.io.Output","writeInt32",0xaa114cdc,"haxe.io.Output.writeInt32","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Output.hx",269,0x534e08fe)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_LINE(269)
		if ((this->bigEndian)){
			HX_STACK_LINE(270)
			this->writeByte(hx::UShr(x,(int)24));
			HX_STACK_LINE(271)
			this->writeByte((int((int(x) >> int((int)16))) & int((int)255)));
			HX_STACK_LINE(272)
			this->writeByte((int((int(x) >> int((int)8))) & int((int)255)));
			HX_STACK_LINE(273)
			this->writeByte((int(x) & int((int)255)));
		}
		else{
			HX_STACK_LINE(275)
			this->writeByte((int(x) & int((int)255)));
			HX_STACK_LINE(276)
			this->writeByte((int((int(x) >> int((int)8))) & int((int)255)));
			HX_STACK_LINE(277)
			this->writeByte((int((int(x) >> int((int)16))) & int((int)255)));
			HX_STACK_LINE(278)
			this->writeByte(hx::UShr(x,(int)24));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Output_obj,writeInt32,(void))

Void Output_obj::prepare( int nbytes){
{
		HX_STACK_FRAME("haxe.io.Output","prepare",0xcd01ec7a,"haxe.io.Output.prepare","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Output.hx",288,0x534e08fe)
		HX_STACK_THIS(this)
		HX_STACK_ARG(nbytes,"nbytes")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Output_obj,prepare,(void))

Void Output_obj::writeInput( ::haxe::io::Input i,Dynamic bufsize){
{
		HX_STACK_FRAME("haxe.io.Output","writeInput",0xaa0e7d98,"haxe.io.Output.writeInput","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Output.hx",291,0x534e08fe)
		HX_STACK_THIS(this)
		HX_STACK_ARG(i,"i")
		HX_STACK_ARG(bufsize,"bufsize")
		HX_STACK_LINE(292)
		if (((bufsize == null()))){
			HX_STACK_LINE(293)
			bufsize = (int)4096;
		}
		HX_STACK_LINE(294)
		::haxe::io::Bytes buf = ::haxe::io::Bytes_obj::alloc(bufsize);		HX_STACK_VAR(buf,"buf");
		HX_STACK_LINE(295)
		try
		{
		HX_STACK_CATCHABLE(::haxe::io::Eof, 0);
		{
			HX_STACK_LINE(296)
			while((true)){
				HX_STACK_LINE(297)
				int len = i->readBytes(buf,(int)0,bufsize);		HX_STACK_VAR(len,"len");
				HX_STACK_LINE(298)
				if (((len == (int)0))){
					HX_STACK_LINE(299)
					HX_STACK_DO_THROW(::haxe::io::Error_obj::Blocked);
				}
				HX_STACK_LINE(300)
				int p = (int)0;		HX_STACK_VAR(p,"p");
				HX_STACK_LINE(301)
				while((true)){
					HX_STACK_LINE(301)
					if ((!(((len > (int)0))))){
						HX_STACK_LINE(301)
						break;
					}
					HX_STACK_LINE(302)
					int k = this->writeBytes(buf,p,len);		HX_STACK_VAR(k,"k");
					HX_STACK_LINE(303)
					if (((k == (int)0))){
						HX_STACK_LINE(304)
						HX_STACK_DO_THROW(::haxe::io::Error_obj::Blocked);
					}
					HX_STACK_LINE(305)
					hx::AddEq(p,k);
					HX_STACK_LINE(306)
					hx::SubEq(len,k);
				}
			}
		}
		}
		catch(Dynamic __e){
			if (__e.IsClass< ::haxe::io::Eof >() ){
				HX_STACK_BEGIN_CATCH
				::haxe::io::Eof e = __e;{
				}
			}
			else {
			    HX_STACK_DO_THROW(__e);
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Output_obj,writeInput,(void))

Void Output_obj::writeString( ::String s){
{
		HX_STACK_FRAME("haxe.io.Output","writeString",0x97e1cb83,"haxe.io.Output.writeString","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Output.hx",313,0x534e08fe)
		HX_STACK_THIS(this)
		HX_STACK_ARG(s,"s")
		HX_STACK_LINE(317)
		::haxe::io::Bytes b = ::haxe::io::Bytes_obj::ofString(s);		HX_STACK_VAR(b,"b");
		HX_STACK_LINE(319)
		this->writeFullBytes(b,(int)0,b->length);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Output_obj,writeString,(void))

Float Output_obj::LN2;

Dynamic Output_obj::_float_bytes;

Dynamic Output_obj::_double_bytes;


Output_obj::Output_obj()
{
}

Dynamic Output_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"LN2") ) { return LN2; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"flush") ) { return flush_dyn(); }
		if (HX_FIELD_EQ(inName,"close") ) { return close_dyn(); }
		if (HX_FIELD_EQ(inName,"write") ) { return write_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"prepare") ) { return prepare_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"bigEndian") ) { return bigEndian; }
		if (HX_FIELD_EQ(inName,"writeByte") ) { return writeByte_dyn(); }
		if (HX_FIELD_EQ(inName,"writeInt8") ) { return writeInt8_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"writeBytes") ) { return writeBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"writeFloat") ) { return writeFloat_dyn(); }
		if (HX_FIELD_EQ(inName,"writeInt16") ) { return writeInt16_dyn(); }
		if (HX_FIELD_EQ(inName,"writeInt24") ) { return writeInt24_dyn(); }
		if (HX_FIELD_EQ(inName,"writeInt32") ) { return writeInt32_dyn(); }
		if (HX_FIELD_EQ(inName,"writeInput") ) { return writeInput_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"writeDouble") ) { return writeDouble_dyn(); }
		if (HX_FIELD_EQ(inName,"writeUInt16") ) { return writeUInt16_dyn(); }
		if (HX_FIELD_EQ(inName,"writeUInt24") ) { return writeUInt24_dyn(); }
		if (HX_FIELD_EQ(inName,"writeString") ) { return writeString_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"_float_bytes") ) { return _float_bytes; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"_double_bytes") ) { return _double_bytes; }
		if (HX_FIELD_EQ(inName,"set_bigEndian") ) { return set_bigEndian_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"writeFullBytes") ) { return writeFullBytes_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Output_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"LN2") ) { LN2=inValue.Cast< Float >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"bigEndian") ) { if (inCallProp) return set_bigEndian(inValue);bigEndian=inValue.Cast< bool >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"_float_bytes") ) { _float_bytes=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"_double_bytes") ) { _double_bytes=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Output_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("bigEndian"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("LN2"),
	HX_CSTRING("_float_bytes"),
	HX_CSTRING("_double_bytes"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsBool,(int)offsetof(Output_obj,bigEndian),HX_CSTRING("bigEndian")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("bigEndian"),
	HX_CSTRING("writeByte"),
	HX_CSTRING("writeBytes"),
	HX_CSTRING("flush"),
	HX_CSTRING("close"),
	HX_CSTRING("set_bigEndian"),
	HX_CSTRING("write"),
	HX_CSTRING("writeFullBytes"),
	HX_CSTRING("writeFloat"),
	HX_CSTRING("writeDouble"),
	HX_CSTRING("writeInt8"),
	HX_CSTRING("writeInt16"),
	HX_CSTRING("writeUInt16"),
	HX_CSTRING("writeInt24"),
	HX_CSTRING("writeUInt24"),
	HX_CSTRING("writeInt32"),
	HX_CSTRING("prepare"),
	HX_CSTRING("writeInput"),
	HX_CSTRING("writeString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Output_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Output_obj::LN2,"LN2");
	HX_MARK_MEMBER_NAME(Output_obj::_float_bytes,"_float_bytes");
	HX_MARK_MEMBER_NAME(Output_obj::_double_bytes,"_double_bytes");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Output_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Output_obj::LN2,"LN2");
	HX_VISIT_MEMBER_NAME(Output_obj::_float_bytes,"_float_bytes");
	HX_VISIT_MEMBER_NAME(Output_obj::_double_bytes,"_double_bytes");
};

#endif

Class Output_obj::__mClass;

void Output_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.io.Output"), hx::TCanCast< Output_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatics
#endif
#ifdef HXCPP_SCRIPTABLE
    , sMemberStorageInfo
#endif
);
}

void Output_obj::__boot()
{
	LN2= ::Math_obj::log((int)2);
	_float_bytes= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("float_bytes"),(int)2);
	_double_bytes= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("double_bytes"),(int)2);
}

} // end namespace haxe
} // end namespace io
