#include <hxcpp.h>

#ifndef INCLUDED_haxe_crypto_Crc32
#include <haxe/crypto/Crc32.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
namespace haxe{
namespace crypto{

Void Crc32_obj::__construct()
{
HX_STACK_FRAME("haxe.crypto.Crc32","new",0x50ecd2a0,"haxe.crypto.Crc32.new","D:\\Workspace\\motionTools\\haxe3\\std/haxe/crypto/Crc32.hx",29,0xbe66deef)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(29)
	this->crc = (int)-1;
}
;
	return null();
}

//Crc32_obj::~Crc32_obj() { }

Dynamic Crc32_obj::__CreateEmpty() { return  new Crc32_obj; }
hx::ObjectPtr< Crc32_obj > Crc32_obj::__new()
{  hx::ObjectPtr< Crc32_obj > result = new Crc32_obj();
	result->__construct();
	return result;}

Dynamic Crc32_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Crc32_obj > result = new Crc32_obj();
	result->__construct();
	return result;}

Void Crc32_obj::byte( int b){
{
		HX_STACK_FRAME("haxe.crypto.Crc32","byte",0x766c14c8,"haxe.crypto.Crc32.byte","D:\\Workspace\\motionTools\\haxe3\\std/haxe/crypto/Crc32.hx",32,0xbe66deef)
		HX_STACK_THIS(this)
		HX_STACK_ARG(b,"b")
		HX_STACK_LINE(33)
		int tmp = (int(((int(this->crc) ^ int(b)))) & int((int)255));		HX_STACK_VAR(tmp,"tmp");
		HX_STACK_LINE(34)
		{
			HX_STACK_LINE(34)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(34)
			while((true)){
				HX_STACK_LINE(34)
				if ((!(((_g < (int)8))))){
					HX_STACK_LINE(34)
					break;
				}
				HX_STACK_LINE(34)
				int j = (_g)++;		HX_STACK_VAR(j,"j");
				HX_STACK_LINE(35)
				if (((((int(tmp) & int((int)1))) == (int)1))){
					HX_STACK_LINE(36)
					tmp = (int(hx::UShr(tmp,(int)1)) ^ int((int)-306674912));
				}
				else{
					HX_STACK_LINE(38)
					hx::UShrEq(tmp,(int)1);
				}
			}
		}
		HX_STACK_LINE(40)
		this->crc = (int(hx::UShr(this->crc,(int)8)) ^ int(tmp));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Crc32_obj,byte,(void))

Void Crc32_obj::update( ::haxe::io::Bytes b,int pos,int len){
{
		HX_STACK_FRAME("haxe.crypto.Crc32","update",0x58c76bc9,"haxe.crypto.Crc32.update","D:\\Workspace\\motionTools\\haxe3\\std/haxe/crypto/Crc32.hx",43,0xbe66deef)
		HX_STACK_THIS(this)
		HX_STACK_ARG(b,"b")
		HX_STACK_ARG(pos,"pos")
		HX_STACK_ARG(len,"len")
		HX_STACK_LINE(44)
		Array< unsigned char > b1 = b->b;		HX_STACK_VAR(b1,"b1");
		HX_STACK_LINE(45)
		{
			HX_STACK_LINE(45)
			int _g1 = pos;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(45)
			int _g = (pos + len);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(45)
			while((true)){
				HX_STACK_LINE(45)
				if ((!(((_g1 < _g))))){
					HX_STACK_LINE(45)
					break;
				}
				HX_STACK_LINE(45)
				int i = (_g1)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(46)
				int _g2 = b1->__unsafe_get(i);		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(46)
				int _g11 = (int(this->crc) ^ int(_g2));		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(46)
				int tmp = (int(_g11) & int((int)255));		HX_STACK_VAR(tmp,"tmp");
				HX_STACK_LINE(47)
				{
					HX_STACK_LINE(47)
					int _g21 = (int)0;		HX_STACK_VAR(_g21,"_g21");
					HX_STACK_LINE(47)
					while((true)){
						HX_STACK_LINE(47)
						if ((!(((_g21 < (int)8))))){
							HX_STACK_LINE(47)
							break;
						}
						HX_STACK_LINE(47)
						int j = (_g21)++;		HX_STACK_VAR(j,"j");
						HX_STACK_LINE(48)
						if (((((int(tmp) & int((int)1))) == (int)1))){
							HX_STACK_LINE(49)
							tmp = (int(hx::UShr(tmp,(int)1)) ^ int((int)-306674912));
						}
						else{
							HX_STACK_LINE(51)
							hx::UShrEq(tmp,(int)1);
						}
					}
				}
				HX_STACK_LINE(53)
				this->crc = (int(hx::UShr(this->crc,(int)8)) ^ int(tmp));
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Crc32_obj,update,(void))

int Crc32_obj::get( ){
	HX_STACK_FRAME("haxe.crypto.Crc32","get",0x50e782d6,"haxe.crypto.Crc32.get","D:\\Workspace\\motionTools\\haxe3\\std/haxe/crypto/Crc32.hx",58,0xbe66deef)
	HX_STACK_THIS(this)
	HX_STACK_LINE(58)
	return (int(this->crc) ^ int((int)-1));
}


HX_DEFINE_DYNAMIC_FUNC0(Crc32_obj,get,return )

int Crc32_obj::make( ::haxe::io::Bytes data){
	HX_STACK_FRAME("haxe.crypto.Crc32","make",0x7d9f2fae,"haxe.crypto.Crc32.make","D:\\Workspace\\motionTools\\haxe3\\std/haxe/crypto/Crc32.hx",64,0xbe66deef)
	HX_STACK_ARG(data,"data")
	HX_STACK_LINE(65)
	int init = (int)-1;		HX_STACK_VAR(init,"init");
	HX_STACK_LINE(66)
	int crc = init;		HX_STACK_VAR(crc,"crc");
	HX_STACK_LINE(67)
	Array< unsigned char > b = data->b;		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(68)
	{
		HX_STACK_LINE(68)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(68)
		int _g = data->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(68)
		while((true)){
			HX_STACK_LINE(68)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(68)
				break;
			}
			HX_STACK_LINE(68)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(69)
			int _g2 = b->__unsafe_get(i);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(69)
			int _g11 = (int(crc) ^ int(_g2));		HX_STACK_VAR(_g11,"_g11");
			HX_STACK_LINE(69)
			int tmp = (int(_g11) & int((int)255));		HX_STACK_VAR(tmp,"tmp");
			HX_STACK_LINE(70)
			{
				HX_STACK_LINE(70)
				int _g21 = (int)0;		HX_STACK_VAR(_g21,"_g21");
				HX_STACK_LINE(70)
				while((true)){
					HX_STACK_LINE(70)
					if ((!(((_g21 < (int)8))))){
						HX_STACK_LINE(70)
						break;
					}
					HX_STACK_LINE(70)
					int j = (_g21)++;		HX_STACK_VAR(j,"j");
					HX_STACK_LINE(71)
					if (((((int(tmp) & int((int)1))) == (int)1))){
						HX_STACK_LINE(72)
						tmp = (int(hx::UShr(tmp,(int)1)) ^ int((int)-306674912));
					}
					else{
						HX_STACK_LINE(74)
						hx::UShrEq(tmp,(int)1);
					}
				}
			}
			HX_STACK_LINE(76)
			crc = (int(hx::UShr(crc,(int)8)) ^ int(tmp));
		}
	}
	HX_STACK_LINE(78)
	return (int(crc) ^ int(init));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Crc32_obj,make,return )


Crc32_obj::Crc32_obj()
{
}

Dynamic Crc32_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"crc") ) { return crc; }
		if (HX_FIELD_EQ(inName,"get") ) { return get_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"make") ) { return make_dyn(); }
		if (HX_FIELD_EQ(inName,"byte") ) { return byte_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"update") ) { return update_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Crc32_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"crc") ) { crc=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Crc32_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("crc"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("make"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(Crc32_obj,crc),HX_CSTRING("crc")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("crc"),
	HX_CSTRING("byte"),
	HX_CSTRING("update"),
	HX_CSTRING("get"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Crc32_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Crc32_obj::__mClass,"__mClass");
};

#endif

Class Crc32_obj::__mClass;

void Crc32_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.crypto.Crc32"), hx::TCanCast< Crc32_obj> ,sStaticFields,sMemberFields,
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

void Crc32_obj::__boot()
{
}

} // end namespace haxe
} // end namespace crypto
