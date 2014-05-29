#include <hxcpp.h>

#ifndef INCLUDED_hxd_text_Utf8Tools
#include <hxd/text/Utf8Tools.h>
#endif
namespace hxd{
namespace text{

Void Utf8Tools_obj::__construct()
{
	return null();
}

//Utf8Tools_obj::~Utf8Tools_obj() { }

Dynamic Utf8Tools_obj::__CreateEmpty() { return  new Utf8Tools_obj; }
hx::ObjectPtr< Utf8Tools_obj > Utf8Tools_obj::__new()
{  hx::ObjectPtr< Utf8Tools_obj > result = new Utf8Tools_obj();
	result->__construct();
	return result;}

Dynamic Utf8Tools_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Utf8Tools_obj > result = new Utf8Tools_obj();
	result->__construct();
	return result;}

int Utf8Tools_obj::getLastBits( int code,int nth){
	HX_STACK_FRAME("hxd.text.Utf8Tools","getLastBits",0xf7b17e27,"hxd.text.Utf8Tools.getLastBits","hxd/text/Utf8Tools.hx",4,0xf2cbd31b)
	HX_STACK_ARG(code,"code")
	HX_STACK_ARG(nth,"nth")
	HX_STACK_LINE(5)
	int mask = (((int((int)1) << int(nth))) - (int)1);		HX_STACK_VAR(mask,"mask");
	HX_STACK_LINE(6)
	return (int(code) & int(mask));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Utf8Tools_obj,getLastBits,return )

int Utf8Tools_obj::toCharCode( ::String str){
	HX_STACK_FRAME("hxd.text.Utf8Tools","toCharCode",0x6eac2269,"hxd.text.Utf8Tools.toCharCode","hxd/text/Utf8Tools.hx",9,0xf2cbd31b)
	HX_STACK_ARG(str,"str")
	HX_STACK_LINE(10)
	Dynamic c0 = str.charCodeAt((int)0);		HX_STACK_VAR(c0,"c0");
	HX_STACK_LINE(11)
	if (((((int(c0) & int((int)256))) == (int)0))){
		HX_STACK_LINE(12)
		return ::hxd::text::Utf8Tools_obj::getLastBits(c0,(int)7);
	}
	else{
		HX_STACK_LINE(14)
		if (((((int(c0) & int((int)64))) == (int)0))){
			HX_STACK_LINE(15)
			int _g = ::hxd::text::Utf8Tools_obj::getLastBits(c0,(int)5);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(15)
			int _g1 = (int(_g) << int((int)6));		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(15)
			Dynamic _g2 = str.charCodeAt((int)1);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(15)
			int _g3 = ::hxd::text::Utf8Tools_obj::getLastBits(_g2,(int)6);		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(15)
			return (int(_g1) | int(_g3));
		}
		else{
			HX_STACK_LINE(17)
			if (((((int(c0) & int((int)32))) == (int)0))){
				HX_STACK_LINE(18)
				int _g4 = ::hxd::text::Utf8Tools_obj::getLastBits(c0,(int)4);		HX_STACK_VAR(_g4,"_g4");
				HX_STACK_LINE(18)
				int _g5 = (int(_g4) << int((int)12));		HX_STACK_VAR(_g5,"_g5");
				HX_STACK_LINE(18)
				Dynamic _g6 = str.charCodeAt((int)1);		HX_STACK_VAR(_g6,"_g6");
				HX_STACK_LINE(18)
				int _g7 = ::hxd::text::Utf8Tools_obj::getLastBits(_g6,(int)6);		HX_STACK_VAR(_g7,"_g7");
				HX_STACK_LINE(18)
				int _g8 = (int(_g7) << int((int)6));		HX_STACK_VAR(_g8,"_g8");
				HX_STACK_LINE(18)
				int _g9 = (int(_g5) | int(_g8));		HX_STACK_VAR(_g9,"_g9");
				HX_STACK_LINE(18)
				Dynamic _g10 = str.charCodeAt((int)2);		HX_STACK_VAR(_g10,"_g10");
				HX_STACK_LINE(18)
				int _g11 = ::hxd::text::Utf8Tools_obj::getLastBits(_g10,(int)6);		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(18)
				return (int(_g9) | int(_g11));
			}
			else{
				HX_STACK_LINE(21)
				int _g12 = ::hxd::text::Utf8Tools_obj::getLastBits(c0,(int)3);		HX_STACK_VAR(_g12,"_g12");
				HX_STACK_LINE(21)
				int _g13 = (int(_g12) << int((int)18));		HX_STACK_VAR(_g13,"_g13");
				HX_STACK_LINE(21)
				Dynamic _g14 = str.charCodeAt((int)1);		HX_STACK_VAR(_g14,"_g14");
				HX_STACK_LINE(21)
				int _g15 = ::hxd::text::Utf8Tools_obj::getLastBits(_g14,(int)6);		HX_STACK_VAR(_g15,"_g15");
				HX_STACK_LINE(21)
				int _g16 = (int(_g15) << int((int)12));		HX_STACK_VAR(_g16,"_g16");
				HX_STACK_LINE(21)
				int _g17 = (int(_g13) | int(_g16));		HX_STACK_VAR(_g17,"_g17");
				HX_STACK_LINE(21)
				Dynamic _g18 = str.charCodeAt((int)2);		HX_STACK_VAR(_g18,"_g18");
				HX_STACK_LINE(21)
				int _g19 = ::hxd::text::Utf8Tools_obj::getLastBits(_g18,(int)6);		HX_STACK_VAR(_g19,"_g19");
				HX_STACK_LINE(21)
				int _g20 = (int(_g19) << int((int)6));		HX_STACK_VAR(_g20,"_g20");
				HX_STACK_LINE(21)
				int _g21 = (int(_g17) | int(_g20));		HX_STACK_VAR(_g21,"_g21");
				HX_STACK_LINE(21)
				Dynamic _g22 = str.charCodeAt((int)3);		HX_STACK_VAR(_g22,"_g22");
				HX_STACK_LINE(21)
				int _g23 = ::hxd::text::Utf8Tools_obj::getLastBits(_g22,(int)6);		HX_STACK_VAR(_g23,"_g23");
				HX_STACK_LINE(21)
				return (int(_g21) | int(_g23));
			}
		}
	}
	HX_STACK_LINE(11)
	return (int)0;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Utf8Tools_obj,toCharCode,return )

int Utf8Tools_obj::getByteLength( int cc){
	HX_STACK_FRAME("hxd.text.Utf8Tools","getByteLength",0x20cb8879,"hxd.text.Utf8Tools.getByteLength","hxd/text/Utf8Tools.hx",26,0xf2cbd31b)
	HX_STACK_ARG(cc,"cc")
	HX_STACK_LINE(26)
	if (((cc < (int)127))){
		HX_STACK_LINE(26)
		return (int)1;
	}
	else{
		HX_STACK_LINE(27)
		if (((cc < (int)2047))){
			HX_STACK_LINE(27)
			return (int)2;
		}
		else{
			HX_STACK_LINE(28)
			if (((cc < (int)65535))){
				HX_STACK_LINE(28)
				return (int)3;
			}
			else{
				HX_STACK_LINE(29)
				return (int)4;
			}
		}
	}
	HX_STACK_LINE(26)
	return (int)0;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Utf8Tools_obj,getByteLength,return )


Utf8Tools_obj::Utf8Tools_obj()
{
}

Dynamic Utf8Tools_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 10:
		if (HX_FIELD_EQ(inName,"toCharCode") ) { return toCharCode_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"getLastBits") ) { return getLastBits_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"getByteLength") ) { return getByteLength_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Utf8Tools_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void Utf8Tools_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("getLastBits"),
	HX_CSTRING("toCharCode"),
	HX_CSTRING("getByteLength"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Utf8Tools_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Utf8Tools_obj::__mClass,"__mClass");
};

#endif

Class Utf8Tools_obj::__mClass;

void Utf8Tools_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.text.Utf8Tools"), hx::TCanCast< Utf8Tools_obj> ,sStaticFields,sMemberFields,
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

void Utf8Tools_obj::__boot()
{
}

} // end namespace hxd
} // end namespace text
