#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_haxe_ds_IntMap
#include <haxe/ds/IntMap.h>
#endif
#ifndef INCLUDED_hxd_Charset
#include <hxd/Charset.h>
#endif
namespace hxd{

Void Charset_obj::__construct()
{
HX_STACK_FRAME("hxd.Charset","new",0x0edbc944,"hxd.Charset.new","hxd/Charset.hx",30,0xc5d075ed)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(30)
	::hxd::Charset _g = hx::ObjectPtr<OBJ_>(this);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(31)
	::haxe::ds::IntMap _g1 = ::haxe::ds::IntMap_obj::__new();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(31)
	this->map = _g1;
	HX_STACK_LINE(36)
	{
		HX_STACK_LINE(36)
		int _g2 = (int)1;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(36)
		while((true)){
			HX_STACK_LINE(36)
			if ((!(((_g2 < (int)94))))){
				HX_STACK_LINE(36)
				break;
			}
			HX_STACK_LINE(36)
			int i = (_g2)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(37)
			_g->map->set(((int)65281 + i),((int)33 + i));
		}
	}
	HX_STACK_LINE(40)
	{
		HX_STACK_LINE(27)
		int _g11 = (int)192;		HX_STACK_VAR(_g11,"_g11");
		HX_STACK_LINE(40)
		int _g2 = (int)199;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(40)
		while((true)){
			HX_STACK_LINE(40)
			if ((!(((_g11 < _g2))))){
				HX_STACK_LINE(40)
				break;
			}
			HX_STACK_LINE(40)
			int i = (_g11)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(41)
			_g->map->set(i,(int)65);
		}
	}
	HX_STACK_LINE(42)
	{
		HX_STACK_LINE(27)
		int _g11 = (int)224;		HX_STACK_VAR(_g11,"_g11");
		HX_STACK_LINE(42)
		int _g2 = (int)231;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(42)
		while((true)){
			HX_STACK_LINE(42)
			if ((!(((_g11 < _g2))))){
				HX_STACK_LINE(42)
				break;
			}
			HX_STACK_LINE(42)
			int i = (_g11)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(43)
			_g->map->set(i,(int)97);
		}
	}
	HX_STACK_LINE(44)
	{
		HX_STACK_LINE(27)
		int _g11 = (int)200;		HX_STACK_VAR(_g11,"_g11");
		HX_STACK_LINE(44)
		int _g2 = (int)204;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(44)
		while((true)){
			HX_STACK_LINE(44)
			if ((!(((_g11 < _g2))))){
				HX_STACK_LINE(44)
				break;
			}
			HX_STACK_LINE(44)
			int i = (_g11)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(45)
			_g->map->set(i,(int)69);
		}
	}
	HX_STACK_LINE(46)
	{
		HX_STACK_LINE(27)
		int _g11 = (int)232;		HX_STACK_VAR(_g11,"_g11");
		HX_STACK_LINE(46)
		int _g2 = (int)236;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(46)
		while((true)){
			HX_STACK_LINE(46)
			if ((!(((_g11 < _g2))))){
				HX_STACK_LINE(46)
				break;
			}
			HX_STACK_LINE(46)
			int i = (_g11)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(47)
			_g->map->set(i,(int)101);
		}
	}
	HX_STACK_LINE(48)
	{
		HX_STACK_LINE(27)
		int _g11 = (int)204;		HX_STACK_VAR(_g11,"_g11");
		HX_STACK_LINE(48)
		int _g2 = (int)208;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(48)
		while((true)){
			HX_STACK_LINE(48)
			if ((!(((_g11 < _g2))))){
				HX_STACK_LINE(48)
				break;
			}
			HX_STACK_LINE(48)
			int i = (_g11)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(49)
			_g->map->set(i,(int)73);
		}
	}
	HX_STACK_LINE(50)
	{
		HX_STACK_LINE(27)
		int _g11 = (int)236;		HX_STACK_VAR(_g11,"_g11");
		HX_STACK_LINE(50)
		int _g2 = (int)240;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(50)
		while((true)){
			HX_STACK_LINE(50)
			if ((!(((_g11 < _g2))))){
				HX_STACK_LINE(50)
				break;
			}
			HX_STACK_LINE(50)
			int i = (_g11)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(51)
			_g->map->set(i,(int)105);
		}
	}
	HX_STACK_LINE(52)
	{
		HX_STACK_LINE(27)
		int _g11 = (int)210;		HX_STACK_VAR(_g11,"_g11");
		HX_STACK_LINE(52)
		int _g2 = (int)215;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(52)
		while((true)){
			HX_STACK_LINE(52)
			if ((!(((_g11 < _g2))))){
				HX_STACK_LINE(52)
				break;
			}
			HX_STACK_LINE(52)
			int i = (_g11)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(53)
			_g->map->set(i,(int)79);
		}
	}
	HX_STACK_LINE(54)
	{
		HX_STACK_LINE(27)
		int _g11 = (int)242;		HX_STACK_VAR(_g11,"_g11");
		HX_STACK_LINE(54)
		int _g2 = (int)247;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(54)
		while((true)){
			HX_STACK_LINE(54)
			if ((!(((_g11 < _g2))))){
				HX_STACK_LINE(54)
				break;
			}
			HX_STACK_LINE(54)
			int i = (_g11)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(55)
			_g->map->set(i,(int)111);
		}
	}
	HX_STACK_LINE(56)
	{
		HX_STACK_LINE(27)
		int _g11 = (int)217;		HX_STACK_VAR(_g11,"_g11");
		HX_STACK_LINE(56)
		int _g2 = (int)221;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(56)
		while((true)){
			HX_STACK_LINE(56)
			if ((!(((_g11 < _g2))))){
				HX_STACK_LINE(56)
				break;
			}
			HX_STACK_LINE(56)
			int i = (_g11)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(57)
			_g->map->set(i,(int)85);
		}
	}
	HX_STACK_LINE(58)
	{
		HX_STACK_LINE(27)
		int _g11 = (int)249;		HX_STACK_VAR(_g11,"_g11");
		HX_STACK_LINE(58)
		int _g2 = (int)253;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(58)
		while((true)){
			HX_STACK_LINE(58)
			if ((!(((_g11 < _g2))))){
				HX_STACK_LINE(58)
				break;
			}
			HX_STACK_LINE(58)
			int i = (_g11)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(59)
			_g->map->set(i,(int)117);
		}
	}
	HX_STACK_LINE(61)
	_g->map->set((int)199,(int)67);
	HX_STACK_LINE(62)
	_g->map->set((int)231,(int)67);
	HX_STACK_LINE(63)
	_g->map->set((int)208,(int)68);
	HX_STACK_LINE(64)
	_g->map->set((int)222,(int)100);
	HX_STACK_LINE(65)
	_g->map->set((int)209,(int)78);
	HX_STACK_LINE(66)
	_g->map->set((int)241,(int)110);
	HX_STACK_LINE(67)
	_g->map->set((int)221,(int)89);
	HX_STACK_LINE(68)
	_g->map->set((int)253,(int)121);
	HX_STACK_LINE(69)
	_g->map->set((int)255,(int)121);
	HX_STACK_LINE(71)
	_g->map->set((int)12288,(int)32);
	HX_STACK_LINE(72)
	_g->map->set((int)160,(int)32);
	HX_STACK_LINE(74)
	_g->map->set((int)171,(int)34);
	HX_STACK_LINE(75)
	_g->map->set((int)187,(int)34);
	HX_STACK_LINE(76)
	_g->map->set((int)8220,(int)34);
	HX_STACK_LINE(77)
	_g->map->set((int)8221,(int)34);
	HX_STACK_LINE(78)
	_g->map->set((int)8216,(int)39);
	HX_STACK_LINE(79)
	_g->map->set((int)8217,(int)39);
	HX_STACK_LINE(80)
	_g->map->set((int)180,(int)39);
	HX_STACK_LINE(81)
	_g->map->set((int)8216,(int)39);
	HX_STACK_LINE(82)
	_g->map->set((int)8249,(int)60);
	HX_STACK_LINE(83)
	_g->map->set((int)8250,(int)62);
}
;
	return null();
}

//Charset_obj::~Charset_obj() { }

Dynamic Charset_obj::__CreateEmpty() { return  new Charset_obj; }
hx::ObjectPtr< Charset_obj > Charset_obj::__new()
{  hx::ObjectPtr< Charset_obj > result = new Charset_obj();
	result->__construct();
	return result;}

Dynamic Charset_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Charset_obj > result = new Charset_obj();
	result->__construct();
	return result;}

Dynamic Charset_obj::resolveChar( int cc,::haxe::ds::IntMap glyphs){
	HX_STACK_FRAME("hxd.Charset","resolveChar",0x073c00c6,"hxd.Charset.resolveChar","hxd/Charset.hx",86,0xc5d075ed)
	HX_STACK_THIS(this)
	HX_STACK_ARG(cc,"cc")
	HX_STACK_ARG(glyphs,"glyphs")
	HX_STACK_LINE(87)
	Dynamic c = cc;		HX_STACK_VAR(c,"c");
	HX_STACK_LINE(88)
	while((true)){
		HX_STACK_LINE(88)
		if ((!(((c != null()))))){
			HX_STACK_LINE(88)
			break;
		}
		HX_STACK_LINE(89)
		Dynamic g = glyphs->get(c);		HX_STACK_VAR(g,"g");
		HX_STACK_LINE(90)
		if (((g != null()))){
			HX_STACK_LINE(90)
			return g;
		}
		HX_STACK_LINE(92)
		Dynamic _g = this->map->get(c);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(92)
		c = _g;
	}
	HX_STACK_LINE(94)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Charset_obj,resolveChar,return )

bool Charset_obj::isSpace( int cc){
	HX_STACK_FRAME("hxd.Charset","isSpace",0x232c6b60,"hxd.Charset.isSpace","hxd/Charset.hx",98,0xc5d075ed)
	HX_STACK_THIS(this)
	HX_STACK_ARG(cc,"cc")
	HX_STACK_LINE(98)
	return (bool((cc == (int)32)) || bool((cc == (int)12288)));
}


HX_DEFINE_DYNAMIC_FUNC1(Charset_obj,isSpace,return )

bool Charset_obj::isBreakChar( int cc){
	HX_STACK_FRAME("hxd.Charset","isBreakChar",0x3ab1aecf,"hxd.Charset.isBreakChar","hxd/Charset.hx",101,0xc5d075ed)
	HX_STACK_THIS(this)
	HX_STACK_ARG(cc,"cc")
	HX_STACK_LINE(103)
	if (((bool((bool((bool((bool((cc == (int)33)) || bool((cc == (int)63)))) || bool((cc == (int)46)))) || bool((cc == (int)44)))) || bool((cc == (int)58))))){
		HX_STACK_LINE(104)
		return true;
	}
	HX_STACK_LINE(106)
	if (((bool((bool((bool((bool((cc == (int)65281)) || bool((cc == (int)65311)))) || bool((cc == (int)46)))) || bool((cc == (int)44)))) || bool((cc == (int)58))))){
		HX_STACK_LINE(107)
		return true;
	}
	HX_STACK_LINE(109)
	if (((cc == (int)33))){
		HX_STACK_LINE(110)
		return true;
	}
	HX_STACK_LINE(112)
	return this->isSpace(cc);
}


HX_DEFINE_DYNAMIC_FUNC1(Charset_obj,isBreakChar,return )

::String Charset_obj::JP_KANA;

::String Charset_obj::ASCII;

::String Charset_obj::LATIN1;

::String Charset_obj::DEFAULT_CHARS;

::hxd::Charset Charset_obj::inst;

::hxd::Charset Charset_obj::getDefault( ){
	HX_STACK_FRAME("hxd.Charset","getDefault",0x9afa0a67,"hxd.Charset.getDefault","hxd/Charset.hx",116,0xc5d075ed)
	HX_STACK_LINE(117)
	if (((::hxd::Charset_obj::inst == null()))){
		HX_STACK_LINE(117)
		::hxd::Charset _g = ::hxd::Charset_obj::__new();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(117)
		::hxd::Charset_obj::inst = _g;
	}
	HX_STACK_LINE(118)
	return ::hxd::Charset_obj::inst;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Charset_obj,getDefault,return )


Charset_obj::Charset_obj()
{
}

void Charset_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Charset);
	HX_MARK_MEMBER_NAME(map,"map");
	HX_MARK_END_CLASS();
}

void Charset_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(map,"map");
}

Dynamic Charset_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"map") ) { return map; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"inst") ) { return inst; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"ASCII") ) { return ASCII; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"LATIN1") ) { return LATIN1; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"JP_KANA") ) { return JP_KANA; }
		if (HX_FIELD_EQ(inName,"isSpace") ) { return isSpace_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"getDefault") ) { return getDefault_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"resolveChar") ) { return resolveChar_dyn(); }
		if (HX_FIELD_EQ(inName,"isBreakChar") ) { return isBreakChar_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"DEFAULT_CHARS") ) { return DEFAULT_CHARS; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Charset_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"map") ) { map=inValue.Cast< ::haxe::ds::IntMap >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"inst") ) { inst=inValue.Cast< ::hxd::Charset >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"ASCII") ) { ASCII=inValue.Cast< ::String >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"LATIN1") ) { LATIN1=inValue.Cast< ::String >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"JP_KANA") ) { JP_KANA=inValue.Cast< ::String >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"DEFAULT_CHARS") ) { DEFAULT_CHARS=inValue.Cast< ::String >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Charset_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("map"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("JP_KANA"),
	HX_CSTRING("ASCII"),
	HX_CSTRING("LATIN1"),
	HX_CSTRING("DEFAULT_CHARS"),
	HX_CSTRING("inst"),
	HX_CSTRING("getDefault"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::haxe::ds::IntMap*/ ,(int)offsetof(Charset_obj,map),HX_CSTRING("map")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("map"),
	HX_CSTRING("resolveChar"),
	HX_CSTRING("isSpace"),
	HX_CSTRING("isBreakChar"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Charset_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Charset_obj::JP_KANA,"JP_KANA");
	HX_MARK_MEMBER_NAME(Charset_obj::ASCII,"ASCII");
	HX_MARK_MEMBER_NAME(Charset_obj::LATIN1,"LATIN1");
	HX_MARK_MEMBER_NAME(Charset_obj::DEFAULT_CHARS,"DEFAULT_CHARS");
	HX_MARK_MEMBER_NAME(Charset_obj::inst,"inst");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Charset_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Charset_obj::JP_KANA,"JP_KANA");
	HX_VISIT_MEMBER_NAME(Charset_obj::ASCII,"ASCII");
	HX_VISIT_MEMBER_NAME(Charset_obj::LATIN1,"LATIN1");
	HX_VISIT_MEMBER_NAME(Charset_obj::DEFAULT_CHARS,"DEFAULT_CHARS");
	HX_VISIT_MEMBER_NAME(Charset_obj::inst,"inst");
};

#endif

Class Charset_obj::__mClass;

void Charset_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.Charset"), hx::TCanCast< Charset_obj> ,sStaticFields,sMemberFields,
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

void Charset_obj::__boot()
{
	JP_KANA= HX_CSTRING("\xe3""\x80""\x80""\xe3""\x81""\x82""\xe3""\x81""\x84""\xe3""\x81""\x86""\xe3""\x81""\x88""\xe3""\x81""\x8a""\xe3""\x81""\x8b""\xe3""\x81""\x8d""\xe3""\x81""\x8f""\xe3""\x81""\x91""\xe3""\x81""\x93""\xe3""\x81""\x95""\xe3""\x81""\x97""\xe3""\x81""\x99""\xe3""\x81""\x9b""\xe3""\x81""\x9d""\xe3""\x81""\x9f""\xe3""\x81""\xa1""\xe3""\x81""\xa4""\xe3""\x81""\xa6""\xe3""\x81""\xa8""\xe3""\x81""\xaa""\xe3""\x81""\xab""\xe3""\x81""\xac""\xe3""\x81""\xad""\xe3""\x81""\xae""\xe3""\x81""\xaf""\xe3""\x81""\xb2""\xe3""\x81""\xb5""\xe3""\x81""\xb8""\xe3""\x81""\xbb""\xe3""\x81""\xbe""\xe3""\x81""\xbf""\xe3""\x82""\x80""\xe3""\x82""\x81""\xe3""\x82""\x82""\xe3""\x82""\x84""\xe3""\x82""\x86""\xe3""\x82""\x88""\xe3""\x82""\x89""\xe3""\x82""\x8a""\xe3""\x82""\x8b""\xe3""\x82""\x8c""\xe3""\x82""\x8d""\xe3""\x82""\x8f""\xe3""\x82""\x90""\xe3""\x82""\x91""\xe3""\x82""\x92""\xe3""\x82""\x93""\xe3""\x81""\x8c""\xe3""\x81""\x8e""\xe3""\x81""\x90""\xe3""\x81""\x92""\xe3""\x81""\x94""\xe3""\x81""\x96""\xe3""\x81""\x98""\xe3""\x81""\x9a""\xe3""\x81""\x9c""\xe3""\x81""\x9e""\xe3""\x81""\xa0""\xe3""\x81""\xa2""\xe3""\x81""\xa5""\xe3""\x81""\xa7""\xe3""\x81""\xa9""\xe3""\x81""\xb0""\xe3""\x81""\xb3""\xe3""\x81""\xb6""\xe3""\x81""\xb9""\xe3""\x81""\xbc""\xe3""\x81""\xb1""\xe3""\x81""\xb4""\xe3""\x81""\xb7""\xe3""\x81""\xba""\xe3""\x81""\xbd""\xe3""\x82""\x83""\xe3""\x82""\x85""\xe3""\x82""\x87""\xe3""\x82""\xa2""\xe3""\x82""\xa4""\xe3""\x82""\xa6""\xe3""\x82""\xa8""\xe3""\x82""\xaa""\xe3""\x82""\xab""\xe3""\x82""\xad""\xe3""\x82""\xaf""\xe3""\x82""\xb1""\xe3""\x82""\xb3""\xe3""\x82""\xb5""\xe3""\x82""\xb7""\xe3""\x82""\xb9""\xe3""\x82""\xbb""\xe3""\x82""\xbd""\xe3""\x82""\xbf""\xe3""\x83""\x81""\xe3""\x83""\x84""\xe3""\x83""\x86""\xe3""\x83""\x88""\xe3""\x83""\x8a""\xe3""\x83""\x8b""\xe3""\x83""\x8c""\xe3""\x83""\x8d""\xe3""\x83""\x8e""\xe3""\x83""\x8f""\xe3""\x83""\x92""\xe3""\x83""\x95""\xe3""\x83""\x98""\xe3""\x83""\x9b""\xe3""\x83""\x9e""\xe3""\x83""\x9f""\xe3""\x83""\xa0""\xe3""\x83""\xa1""\xe3""\x83""\xa2""\xe3""\x83""\xa4""\xe3""\x83""\xa6""\xe3""\x83""\xa8""\xe3""\x83""\xa9""\xe3""\x83""\xaa""\xe3""\x83""\xab""\xe3""\x83""\xac""\xe3""\x83""\xad""\xe3""\x83""\xaf""\xe3""\x83""\xb0""\xe3""\x83""\xb1""\xe3""\x83""\xb2""\xe3""\x83""\xb3""\xe3""\x82""\xac""\xe3""\x82""\xae""\xe3""\x82""\xb0""\xe3""\x82""\xb2""\xe3""\x82""\xb4""\xe3""\x82""\xb6""\xe3""\x82""\xb8""\xe3""\x82""\xba""\xe3""\x82""\xbc""\xe3""\x82""\xbe""\xe3""\x83""\x80""\xe3""\x83""\x82""\xe3""\x83""\x85""\xe3""\x83""\x87""\xe3""\x83""\x89""\xe3""\x83""\x90""\xe3""\x83""\x93""\xe3""\x83""\x96""\xe3""\x83""\x99""\xe3""\x83""\x9c""\xe3""\x83""\x91""\xe3""\x83""\x94""\xe3""\x83""\x97""\xe3""\x83""\x9a""\xe3""\x83""\x9d""\xe3""\x83""\xb4""\xe3""\x83""\xa3""\xe3""\x81""\x87""\xe3""\x81""\xa3""\xe3""\x83""\x83""\xe3""\x83""\xa5""\xe3""\x83""\xa7""\xe3""\x82""\xa1""\xe3""\x82""\xa3""\xe3""\x82""\xa5""\xe3""\x82""\xa7""\xe3""\x82""\xa9""\xe3""\x83""\xbb""\xe3""\x83""\xbc""\xe3""\x80""\x8c""\xe3""\x80""\x8d""\xe3""\x80""\x81""\xe3""\x80""\x82""\xe3""\x80""\x8e""\xe3""\x80""\x8f""\xe2""\x80""\x9c""\xe2""\x80""\x9d""\xef""\xbc""\x81""\xef""\xbc""\x9a""\xef""\xbc""\x9f""\xef""\xbc""\x85""\xef""\xbc""\x86""\xef""\xbc""\x88""\xef""\xbc""\x89""\xef""\xbc""\x8d""\xef""\xbc""\x90""\xef""\xbc""\x91""\xef""\xbc""\x92""\xef""\xbc""\x93""\xef""\xbc""\x94""\xef""\xbc""\x95""\xef""\xbc""\x96""\xef""\xbc""\x97""\xef""\xbc""\x98""\xef""\xbc""\x99""");
	ASCII= HX_CSTRING(" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~");
	LATIN1= HX_CSTRING("\xc2""\xa1""\xc2""\xa2""\xc2""\xa3""\xc2""\xa4""\xc2""\xa5""\xc2""\xa6""\xc2""\xa7""\xc2""\xa8""\xc2""\xa9""\xc2""\xaa""\xc2""\xab""\xc2""\xac""-\xc2""\xae""\xc2""\xaf""\xc2""\xb0""\xc2""\xb1""\xc2""\xb2""\xc2""\xb3""\xc2""\xb4""\xc2""\xb5""\xc2""\xb6""\xc2""\xb7""\xc2""\xb8""\xc2""\xb9""\xc2""\xba""\xc2""\xbb""\xc2""\xbc""\xc2""\xbd""\xc2""\xbe""\xc2""\xbf""\xc3""\x80""\xc3""\x81""\xc3""\x82""\xc3""\x83""\xc3""\x84""\xc3""\x85""\xc3""\x86""\xc3""\x87""\xc3""\x88""\xc3""\x89""\xc3""\x8a""\xc3""\x8b""\xc3""\x8c""\xc3""\x8d""\xc3""\x8e""\xc3""\x8f""\xc3""\x90""\xc3""\x91""\xc3""\x92""\xc3""\x93""\xc3""\x94""\xc3""\x95""\xc3""\x96""\xc3""\x97""\xc3""\x98""\xc3""\x99""\xc3""\x9a""\xc3""\x9b""\xc3""\x9c""\xc3""\x9d""\xc3""\x9e""\xc3""\x9f""\xc3""\xa0""\xc3""\xa1""\xc3""\xa2""\xc3""\xa3""\xc3""\xa4""\xc3""\xa5""\xc3""\xa6""\xc3""\xa7""\xc3""\xa8""\xc3""\xa9""\xc3""\xaa""\xc3""\xab""\xc3""\xac""\xc3""\xad""\xc3""\xae""\xc3""\xaf""\xc3""\xb0""\xc3""\xb1""\xc3""\xb2""\xc3""\xb3""\xc3""\xb4""\xc3""\xb5""\xc3""\xb6""\xc3""\xb7""\xc3""\xb8""\xc3""\xb9""\xc3""\xba""\xc3""\xbb""\xc3""\xbc""\xc3""\xbd""\xc3""\xbe""\xc3""\xbf""");
	DEFAULT_CHARS= (::hxd::Charset_obj::ASCII + ::hxd::Charset_obj::LATIN1);
}

} // end namespace hxd
