#include <hxcpp.h>

#ifndef INCLUDED_flash_Memory
#include <flash/Memory.h>
#endif
#ifndef INCLUDED_h3d_fbx_FbxNode
#include <h3d/fbx/FbxNode.h>
#endif
#ifndef INCLUDED_h3d_fbx_FbxProp
#include <h3d/fbx/FbxProp.h>
#endif
#ifndef INCLUDED_h3d_fbx_XBXReader
#include <h3d/fbx/XBXReader.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_haxe_io_Input
#include <haxe/io/Input.h>
#endif
#ifndef INCLUDED_hxd_impl_Memory
#include <hxd/impl/Memory.h>
#endif
#ifndef INCLUDED_hxd_impl_MemoryReader
#include <hxd/impl/MemoryReader.h>
#endif
#ifndef INCLUDED_hxd_impl_Tmp
#include <hxd/impl/Tmp.h>
#endif
namespace h3d{
namespace fbx{

Void XBXReader_obj::__construct(::haxe::io::Input i)
{
HX_STACK_FRAME("h3d.fbx.XBXReader","new",0x33747adc,"h3d.fbx.XBXReader.new","h3d/fbx/XBXReader.hx",10,0x88a5e396)
HX_STACK_THIS(this)
HX_STACK_ARG(i,"i")
{
	HX_STACK_LINE(10)
	this->i = i;
}
;
	return null();
}

//XBXReader_obj::~XBXReader_obj() { }

Dynamic XBXReader_obj::__CreateEmpty() { return  new XBXReader_obj; }
hx::ObjectPtr< XBXReader_obj > XBXReader_obj::__new(::haxe::io::Input i)
{  hx::ObjectPtr< XBXReader_obj > result = new XBXReader_obj();
	result->__construct(i);
	return result;}

Dynamic XBXReader_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< XBXReader_obj > result = new XBXReader_obj();
	result->__construct(inArgs[0]);
	return result;}

Void XBXReader_obj::error( ::String msg){
{
		HX_STACK_FRAME("h3d.fbx.XBXReader","error",0x2fa70d44,"h3d.fbx.XBXReader.error","h3d/fbx/XBXReader.hx",14,0x88a5e396)
		HX_STACK_THIS(this)
		HX_STACK_ARG(msg,"msg")
		HX_STACK_LINE(14)
		HX_STACK_DO_THROW((HX_CSTRING("Invalid XBX data") + ((  (((null() != msg))) ? ::String((HX_CSTRING(": ") + msg)) : ::String(HX_CSTRING("")) ))));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(XBXReader_obj,error,(void))

::String XBXReader_obj::readString( ){
	HX_STACK_FRAME("h3d.fbx.XBXReader","readString",0xafc3e9cb,"h3d.fbx.XBXReader.readString","h3d/fbx/XBXReader.hx",17,0x88a5e396)
	HX_STACK_THIS(this)
	HX_STACK_LINE(18)
	int len = this->i->readByte();		HX_STACK_VAR(len,"len");
	HX_STACK_LINE(19)
	if (((len >= (int)128))){
		HX_STACK_LINE(20)
		int _g = this->i->readUInt24();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(20)
		int _g1 = (int(_g) << int((int)7));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(20)
		int _g2 = (int(_g1) | int((int(len) & int((int)127))));		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(20)
		len = _g2;
	}
	HX_STACK_LINE(21)
	return this->i->readString(len);
}


HX_DEFINE_DYNAMIC_FUNC0(XBXReader_obj,readString,return )

::h3d::fbx::FbxNode XBXReader_obj::read( ){
	HX_STACK_FRAME("h3d.fbx.XBXReader","read",0xd51bcd5a,"h3d.fbx.XBXReader.read","h3d/fbx/XBXReader.hx",24,0x88a5e396)
	HX_STACK_THIS(this)
	HX_STACK_LINE(25)
	::String _g = this->i->readString((int)3);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(25)
	if (((_g != HX_CSTRING("XBX")))){
		HX_STACK_LINE(26)
		this->error(HX_CSTRING("no XBX sig"));
	}
	HX_STACK_LINE(27)
	int _g1 = this->i->readByte();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(27)
	this->version = _g1;
	HX_STACK_LINE(28)
	if (((this->version > (int)0))){
		HX_STACK_LINE(29)
		this->error((HX_CSTRING("version err ") + this->version));
	}
	HX_STACK_LINE(30)
	return this->readNode();
}


HX_DEFINE_DYNAMIC_FUNC0(XBXReader_obj,read,return )

::h3d::fbx::FbxNode XBXReader_obj::readNode( ){
	HX_STACK_FRAME("h3d.fbx.XBXReader","readNode",0x2979b87c,"h3d.fbx.XBXReader.readNode","h3d/fbx/XBXReader.hx",34,0x88a5e396)
	HX_STACK_THIS(this)
	HX_STACK_LINE(35)
	::String name = this->readString();		HX_STACK_VAR(name,"name");
	HX_STACK_LINE(36)
	Array< ::Dynamic > props;		HX_STACK_VAR(props,"props");
	HX_STACK_LINE(36)
	{
		HX_STACK_LINE(37)
		Array< ::Dynamic > a = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(a,"a");
		HX_STACK_LINE(38)
		int l = this->i->readByte();		HX_STACK_VAR(l,"l");
		HX_STACK_LINE(39)
		a[(l - (int)1)] = null();
		HX_STACK_LINE(40)
		{
			HX_STACK_LINE(40)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(40)
			while((true)){
				HX_STACK_LINE(40)
				if ((!(((_g < l))))){
					HX_STACK_LINE(40)
					break;
				}
				HX_STACK_LINE(40)
				int i = (_g)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(41)
				a[i] = this->readProp();
			}
		}
		HX_STACK_LINE(42)
		props = a;
	}
	HX_STACK_LINE(44)
	Array< ::Dynamic > childs;		HX_STACK_VAR(childs,"childs");
	HX_STACK_LINE(44)
	{
		HX_STACK_LINE(45)
		Array< ::Dynamic > a = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(a,"a");
		HX_STACK_LINE(46)
		int l = this->i->readInt24();		HX_STACK_VAR(l,"l");
		HX_STACK_LINE(47)
		a[(l - (int)1)] = null();
		HX_STACK_LINE(48)
		{
			HX_STACK_LINE(48)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(48)
			while((true)){
				HX_STACK_LINE(48)
				if ((!(((_g < l))))){
					HX_STACK_LINE(48)
					break;
				}
				HX_STACK_LINE(48)
				int i = (_g)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(49)
				a[i] = this->readNode();
			}
		}
		HX_STACK_LINE(50)
		childs = a;
	}
	HX_STACK_LINE(52)
	return ::h3d::fbx::FbxNode_obj::__new(name,props,childs);
}


HX_DEFINE_DYNAMIC_FUNC0(XBXReader_obj,readNode,return )

int XBXReader_obj::readInt( ){
	HX_STACK_FRAME("h3d.fbx.XBXReader","readInt",0xca374bb5,"h3d.fbx.XBXReader.readInt","h3d/fbx/XBXReader.hx",57,0x88a5e396)
	HX_STACK_THIS(this)
	HX_STACK_LINE(57)
	return this->i->readInt32();
}


HX_DEFINE_DYNAMIC_FUNC0(XBXReader_obj,readInt,return )

::h3d::fbx::FbxProp XBXReader_obj::readProp( ){
	HX_STACK_FRAME("h3d.fbx.XBXReader","readProp",0x2ace761d,"h3d.fbx.XBXReader.readProp","h3d/fbx/XBXReader.hx",64,0x88a5e396)
	HX_STACK_THIS(this)
	HX_STACK_LINE(65)
	int b = this->i->readByte();		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(66)
	::h3d::fbx::FbxProp t;		HX_STACK_VAR(t,"t");
	HX_STACK_LINE(66)
	switch( (int)(b)){
		case (int)0: {
			HX_STACK_LINE(68)
			int _g = this->i->readInt32();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(68)
			t = ::h3d::fbx::FbxProp_obj::PInt(_g);
		}
		;break;
		case (int)1: {
			HX_STACK_LINE(69)
			Float _g1 = this->i->readDouble();		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(69)
			t = ::h3d::fbx::FbxProp_obj::PFloat(_g1);
		}
		;break;
		case (int)2: {
			HX_STACK_LINE(70)
			::String _g2 = this->readString();		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(70)
			t = ::h3d::fbx::FbxProp_obj::PString(_g2);
		}
		;break;
		case (int)3: {
			HX_STACK_LINE(71)
			::String _g3 = this->readString();		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(71)
			t = ::h3d::fbx::FbxProp_obj::PIdent(_g3);
		}
		;break;
		case (int)4: {
			HX_STACK_LINE(73)
			int l = this->i->readInt32();		HX_STACK_VAR(l,"l");
			HX_STACK_LINE(74)
			Array< int > a = Array_obj< int >::__new();		HX_STACK_VAR(a,"a");
			HX_STACK_LINE(75)
			::haxe::io::Bytes tmp = ::hxd::impl::Tmp_obj::getBytes((l * (int)4));		HX_STACK_VAR(tmp,"tmp");
			HX_STACK_LINE(76)
			this->i->readFullBytes(tmp,(int)0,(l * (int)4));
			HX_STACK_LINE(77)
			::hxd::impl::MemoryReader r = ::hxd::impl::Memory_obj::select(tmp);		HX_STACK_VAR(r,"r");
			HX_STACK_LINE(78)
			a[(l - (int)1)] = (int)0;
			HX_STACK_LINE(79)
			{
				HX_STACK_LINE(79)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(79)
				while((true)){
					HX_STACK_LINE(79)
					if ((!(((_g < l))))){
						HX_STACK_LINE(79)
						break;
					}
					HX_STACK_LINE(79)
					int idx = (_g)++;		HX_STACK_VAR(idx,"idx");
					HX_STACK_LINE(80)
					a[idx] = ::flash::Memory_obj::getI32((int(idx) << int((int)2)));
				}
			}
			HX_STACK_LINE(81)
			::hxd::impl::Memory_obj::end();
			HX_STACK_LINE(82)
			::hxd::impl::Tmp_obj::saveBytes(tmp);
			HX_STACK_LINE(83)
			t = ::h3d::fbx::FbxProp_obj::PInts(a);
		}
		;break;
		case (int)5: {
			HX_STACK_LINE(85)
			int l = this->i->readInt32();		HX_STACK_VAR(l,"l");
			HX_STACK_LINE(86)
			Array< Float > a = Array_obj< Float >::__new();		HX_STACK_VAR(a,"a");
			HX_STACK_LINE(87)
			::haxe::io::Bytes tmp = ::hxd::impl::Tmp_obj::getBytes((l * (int)8));		HX_STACK_VAR(tmp,"tmp");
			HX_STACK_LINE(88)
			this->i->readFullBytes(tmp,(int)0,(l * (int)8));
			HX_STACK_LINE(89)
			::hxd::impl::MemoryReader r = ::hxd::impl::Memory_obj::select(tmp);		HX_STACK_VAR(r,"r");
			HX_STACK_LINE(90)
			a[(l - (int)1)] = 0.;
			HX_STACK_LINE(91)
			{
				HX_STACK_LINE(91)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(91)
				while((true)){
					HX_STACK_LINE(91)
					if ((!(((_g < l))))){
						HX_STACK_LINE(91)
						break;
					}
					HX_STACK_LINE(91)
					int idx = (_g)++;		HX_STACK_VAR(idx,"idx");
					HX_STACK_LINE(92)
					a[idx] = ::flash::Memory_obj::getDouble((int(idx) << int((int)3)));
				}
			}
			HX_STACK_LINE(93)
			::hxd::impl::Memory_obj::end();
			HX_STACK_LINE(94)
			::hxd::impl::Tmp_obj::saveBytes(tmp);
			HX_STACK_LINE(95)
			t = ::h3d::fbx::FbxProp_obj::PFloats(a);
		}
		;break;
		default: {
			HX_STACK_LINE(97)
			this->error((HX_CSTRING("unknown prop ") + b));
			HX_STACK_LINE(98)
			t = null();
		}
	}
	HX_STACK_LINE(101)
	return t;
}


HX_DEFINE_DYNAMIC_FUNC0(XBXReader_obj,readProp,return )


XBXReader_obj::XBXReader_obj()
{
}

void XBXReader_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(XBXReader);
	HX_MARK_MEMBER_NAME(i,"i");
	HX_MARK_MEMBER_NAME(version,"version");
	HX_MARK_END_CLASS();
}

void XBXReader_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(i,"i");
	HX_VISIT_MEMBER_NAME(version,"version");
}

Dynamic XBXReader_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"i") ) { return i; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"read") ) { return read_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"error") ) { return error_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"version") ) { return version; }
		if (HX_FIELD_EQ(inName,"readInt") ) { return readInt_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"readNode") ) { return readNode_dyn(); }
		if (HX_FIELD_EQ(inName,"readProp") ) { return readProp_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"readString") ) { return readString_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic XBXReader_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"i") ) { i=inValue.Cast< ::haxe::io::Input >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"version") ) { version=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void XBXReader_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("i"));
	outFields->push(HX_CSTRING("version"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::haxe::io::Input*/ ,(int)offsetof(XBXReader_obj,i),HX_CSTRING("i")},
	{hx::fsInt,(int)offsetof(XBXReader_obj,version),HX_CSTRING("version")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("i"),
	HX_CSTRING("version"),
	HX_CSTRING("error"),
	HX_CSTRING("readString"),
	HX_CSTRING("read"),
	HX_CSTRING("readNode"),
	HX_CSTRING("readInt"),
	HX_CSTRING("readProp"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(XBXReader_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(XBXReader_obj::__mClass,"__mClass");
};

#endif

Class XBXReader_obj::__mClass;

void XBXReader_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.fbx.XBXReader"), hx::TCanCast< XBXReader_obj> ,sStaticFields,sMemberFields,
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

void XBXReader_obj::__boot()
{
}

} // end namespace h3d
} // end namespace fbx
