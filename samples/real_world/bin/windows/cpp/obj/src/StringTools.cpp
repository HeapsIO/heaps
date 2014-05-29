#include <hxcpp.h>

#ifndef INCLUDED_StringTools
#include <StringTools.h>
#endif

Void StringTools_obj::__construct()
{
	return null();
}

//StringTools_obj::~StringTools_obj() { }

Dynamic StringTools_obj::__CreateEmpty() { return  new StringTools_obj; }
hx::ObjectPtr< StringTools_obj > StringTools_obj::__new()
{  hx::ObjectPtr< StringTools_obj > result = new StringTools_obj();
	result->__construct();
	return result;}

Dynamic StringTools_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< StringTools_obj > result = new StringTools_obj();
	result->__construct();
	return result;}

::String StringTools_obj::urlEncode( ::String s){
	HX_STACK_FRAME("StringTools","urlEncode",0x06afdce1,"StringTools.urlEncode","D:\\Workspace\\motionTools\\haxe3\\std/StringTools.hx",46,0x3696b853)
	HX_STACK_ARG(s,"s")
	HX_STACK_LINE(46)
	return s.__URLEncode();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(StringTools_obj,urlEncode,return )

::String StringTools_obj::urlDecode( ::String s){
	HX_STACK_FRAME("StringTools","urlDecode",0x71b947f9,"StringTools.urlDecode","D:\\Workspace\\motionTools\\haxe3\\std/StringTools.hx",71,0x3696b853)
	HX_STACK_ARG(s,"s")
	HX_STACK_LINE(71)
	return s.__URLDecode();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(StringTools_obj,urlDecode,return )

::String StringTools_obj::htmlEscape( ::String s,Dynamic quotes){
	HX_STACK_FRAME("StringTools","htmlEscape",0x0e1a5dd0,"StringTools.htmlEscape","D:\\Workspace\\motionTools\\haxe3\\std/StringTools.hx",97,0x3696b853)
	HX_STACK_ARG(s,"s")
	HX_STACK_ARG(quotes,"quotes")
	HX_STACK_LINE(98)
	::String _g = s.split(HX_CSTRING("&"))->join(HX_CSTRING("&amp;")).split(HX_CSTRING("<"))->join(HX_CSTRING("&lt;")).split(HX_CSTRING(">"))->join(HX_CSTRING("&gt;"));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(98)
	s = _g;
	HX_STACK_LINE(99)
	if ((quotes)){
		HX_STACK_LINE(99)
		return s.split(HX_CSTRING("\""))->join(HX_CSTRING("&quot;")).split(HX_CSTRING("'"))->join(HX_CSTRING("&#039;"));
	}
	else{
		HX_STACK_LINE(99)
		return s;
	}
	HX_STACK_LINE(99)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(StringTools_obj,htmlEscape,return )

::String StringTools_obj::htmlUnescape( ::String s){
	HX_STACK_FRAME("StringTools","htmlUnescape",0x7457fea9,"StringTools.htmlUnescape","D:\\Workspace\\motionTools\\haxe3\\std/StringTools.hx",117,0x3696b853)
	HX_STACK_ARG(s,"s")
	HX_STACK_LINE(117)
	return s.split(HX_CSTRING("&gt;"))->join(HX_CSTRING(">")).split(HX_CSTRING("&lt;"))->join(HX_CSTRING("<")).split(HX_CSTRING("&quot;"))->join(HX_CSTRING("\"")).split(HX_CSTRING("&#039;"))->join(HX_CSTRING("'")).split(HX_CSTRING("&amp;"))->join(HX_CSTRING("&"));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(StringTools_obj,htmlUnescape,return )

bool StringTools_obj::startsWith( ::String s,::String start){
	HX_STACK_FRAME("StringTools","startsWith",0x5f4e6efb,"StringTools.startsWith","D:\\Workspace\\motionTools\\haxe3\\std/StringTools.hx",133,0x3696b853)
	HX_STACK_ARG(s,"s")
	HX_STACK_ARG(start,"start")
	HX_STACK_LINE(133)
	if (((s.length >= start.length))){
		HX_STACK_LINE(133)
		::String _g = s.substr((int)0,start.length);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(133)
		return (_g == start);
	}
	else{
		HX_STACK_LINE(133)
		return false;
	}
	HX_STACK_LINE(133)
	return false;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(StringTools_obj,startsWith,return )

bool StringTools_obj::endsWith( ::String s,::String end){
	HX_STACK_FRAME("StringTools","endsWith",0x0eb5bfe2,"StringTools.endsWith","D:\\Workspace\\motionTools\\haxe3\\std/StringTools.hx",144,0x3696b853)
	HX_STACK_ARG(s,"s")
	HX_STACK_ARG(end,"end")
	HX_STACK_LINE(150)
	int elen = end.length;		HX_STACK_VAR(elen,"elen");
	HX_STACK_LINE(151)
	int slen = s.length;		HX_STACK_VAR(slen,"slen");
	HX_STACK_LINE(152)
	if (((slen >= elen))){
		HX_STACK_LINE(152)
		::String _g = s.substr((slen - elen),elen);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(152)
		return (_g == end);
	}
	else{
		HX_STACK_LINE(152)
		return false;
	}
	HX_STACK_LINE(152)
	return false;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(StringTools_obj,endsWith,return )

bool StringTools_obj::isSpace( ::String s,int pos){
	HX_STACK_FRAME("StringTools","isSpace",0xe0290778,"StringTools.isSpace","D:\\Workspace\\motionTools\\haxe3\\std/StringTools.hx",165,0x3696b853)
	HX_STACK_ARG(s,"s")
	HX_STACK_ARG(pos,"pos")
	HX_STACK_LINE(166)
	Dynamic c = s.charCodeAt(pos);		HX_STACK_VAR(c,"c");
	HX_STACK_LINE(167)
	return (bool((bool((c > (int)8)) && bool((c < (int)14)))) || bool((c == (int)32)));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(StringTools_obj,isSpace,return )

::String StringTools_obj::ltrim( ::String s){
	HX_STACK_FRAME("StringTools","ltrim",0x24d2234a,"StringTools.ltrim","D:\\Workspace\\motionTools\\haxe3\\std/StringTools.hx",179,0x3696b853)
	HX_STACK_ARG(s,"s")
	HX_STACK_LINE(183)
	int l = s.length;		HX_STACK_VAR(l,"l");
	HX_STACK_LINE(184)
	int r = (int)0;		HX_STACK_VAR(r,"r");
	HX_STACK_LINE(185)
	while((true)){
		HX_STACK_LINE(185)
		if ((!(((  (((r < l))) ? bool(::StringTools_obj::isSpace(s,r)) : bool(false) ))))){
			HX_STACK_LINE(185)
			break;
		}
		HX_STACK_LINE(186)
		(r)++;
	}
	HX_STACK_LINE(188)
	if (((r > (int)0))){
		HX_STACK_LINE(189)
		return s.substr(r,(l - r));
	}
	else{
		HX_STACK_LINE(191)
		return s;
	}
	HX_STACK_LINE(188)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(StringTools_obj,ltrim,return )

::String StringTools_obj::rtrim( ::String s){
	HX_STACK_FRAME("StringTools","rtrim",0x99399e50,"StringTools.rtrim","D:\\Workspace\\motionTools\\haxe3\\std/StringTools.hx",204,0x3696b853)
	HX_STACK_ARG(s,"s")
	HX_STACK_LINE(208)
	int l = s.length;		HX_STACK_VAR(l,"l");
	HX_STACK_LINE(209)
	int r = (int)0;		HX_STACK_VAR(r,"r");
	HX_STACK_LINE(210)
	while((true)){
		HX_STACK_LINE(210)
		if ((!(((  (((r < l))) ? bool(::StringTools_obj::isSpace(s,((l - r) - (int)1))) : bool(false) ))))){
			HX_STACK_LINE(210)
			break;
		}
		HX_STACK_LINE(211)
		(r)++;
	}
	HX_STACK_LINE(213)
	if (((r > (int)0))){
		HX_STACK_LINE(214)
		return s.substr((int)0,(l - r));
	}
	else{
		HX_STACK_LINE(216)
		return s;
	}
	HX_STACK_LINE(213)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(StringTools_obj,rtrim,return )

::String StringTools_obj::trim( ::String s){
	HX_STACK_FRAME("StringTools","trim",0x2908d066,"StringTools.trim","D:\\Workspace\\motionTools\\haxe3\\std/StringTools.hx",226,0x3696b853)
	HX_STACK_ARG(s,"s")
	HX_STACK_LINE(232)
	::String _g = ::StringTools_obj::rtrim(s);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(232)
	return ::StringTools_obj::ltrim(_g);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(StringTools_obj,trim,return )

::String StringTools_obj::lpad( ::String s,::String c,int l){
	HX_STACK_FRAME("StringTools","lpad",0x23bd8feb,"StringTools.lpad","D:\\Workspace\\motionTools\\haxe3\\std/StringTools.hx",248,0x3696b853)
	HX_STACK_ARG(s,"s")
	HX_STACK_ARG(c,"c")
	HX_STACK_ARG(l,"l")
	HX_STACK_LINE(249)
	if (((c.length <= (int)0))){
		HX_STACK_LINE(250)
		return s;
	}
	HX_STACK_LINE(252)
	while((true)){
		HX_STACK_LINE(252)
		if ((!(((s.length < l))))){
			HX_STACK_LINE(252)
			break;
		}
		HX_STACK_LINE(253)
		s = (c + s);
	}
	HX_STACK_LINE(255)
	return s;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(StringTools_obj,lpad,return )

::String StringTools_obj::rpad( ::String s,::String c,int l){
	HX_STACK_FRAME("StringTools","rpad",0x27b4d7a5,"StringTools.rpad","D:\\Workspace\\motionTools\\haxe3\\std/StringTools.hx",270,0x3696b853)
	HX_STACK_ARG(s,"s")
	HX_STACK_ARG(c,"c")
	HX_STACK_ARG(l,"l")
	HX_STACK_LINE(271)
	if (((c.length <= (int)0))){
		HX_STACK_LINE(272)
		return s;
	}
	HX_STACK_LINE(274)
	while((true)){
		HX_STACK_LINE(274)
		if ((!(((s.length < l))))){
			HX_STACK_LINE(274)
			break;
		}
		HX_STACK_LINE(275)
		s = (s + c);
	}
	HX_STACK_LINE(277)
	return s;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(StringTools_obj,rpad,return )

::String StringTools_obj::replace( ::String s,::String sub,::String by){
	HX_STACK_FRAME("StringTools","replace",0x6d651f30,"StringTools.replace","D:\\Workspace\\motionTools\\haxe3\\std/StringTools.hx",303,0x3696b853)
	HX_STACK_ARG(s,"s")
	HX_STACK_ARG(sub,"sub")
	HX_STACK_ARG(by,"by")
	HX_STACK_LINE(303)
	return s.split(sub)->join(by);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(StringTools_obj,replace,return )

::String StringTools_obj::hex( int n,Dynamic digits){
	HX_STACK_FRAME("StringTools","hex",0xd91debd7,"StringTools.hex","D:\\Workspace\\motionTools\\haxe3\\std/StringTools.hx",313,0x3696b853)
	HX_STACK_ARG(n,"n")
	HX_STACK_ARG(digits,"digits")
	HX_STACK_LINE(319)
	::String s = HX_CSTRING("");		HX_STACK_VAR(s,"s");
	HX_STACK_LINE(320)
	::String hexChars = HX_CSTRING("0123456789ABCDEF");		HX_STACK_VAR(hexChars,"hexChars");
	HX_STACK_LINE(321)
	while((true)){
		HX_STACK_LINE(322)
		::String _g = hexChars.charAt((int(n) & int((int)15)));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(322)
		::String _g1 = (_g + s);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(322)
		s = _g1;
		HX_STACK_LINE(323)
		hx::UShrEq(n,(int)4);
		HX_STACK_LINE(321)
		if ((!(((n > (int)0))))){
			HX_STACK_LINE(321)
			break;
		}
	}
	HX_STACK_LINE(326)
	if (((digits != null()))){
		HX_STACK_LINE(327)
		while((true)){
			HX_STACK_LINE(327)
			if ((!(((s.length < digits))))){
				HX_STACK_LINE(327)
				break;
			}
			HX_STACK_LINE(328)
			s = (HX_CSTRING("0") + s);
		}
	}
	HX_STACK_LINE(329)
	return s;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(StringTools_obj,hex,return )

int StringTools_obj::fastCodeAt( ::String s,int index){
	HX_STACK_FRAME("StringTools","fastCodeAt",0x6fd011c0,"StringTools.fastCodeAt","D:\\Workspace\\motionTools\\haxe3\\std/StringTools.hx",346,0x3696b853)
	HX_STACK_ARG(s,"s")
	HX_STACK_ARG(index,"index")
	HX_STACK_LINE(346)
	return s.cca(index);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(StringTools_obj,fastCodeAt,return )

bool StringTools_obj::isEof( int c){
	HX_STACK_FRAME("StringTools","isEof",0x69d30eee,"StringTools.isEof","D:\\Workspace\\motionTools\\haxe3\\std/StringTools.hx",371,0x3696b853)
	HX_STACK_ARG(c,"c")
	HX_STACK_LINE(371)
	return (c == (int)0);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(StringTools_obj,isEof,return )


StringTools_obj::StringTools_obj()
{
}

Dynamic StringTools_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"hex") ) { return hex_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"trim") ) { return trim_dyn(); }
		if (HX_FIELD_EQ(inName,"lpad") ) { return lpad_dyn(); }
		if (HX_FIELD_EQ(inName,"rpad") ) { return rpad_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"ltrim") ) { return ltrim_dyn(); }
		if (HX_FIELD_EQ(inName,"rtrim") ) { return rtrim_dyn(); }
		if (HX_FIELD_EQ(inName,"isEof") ) { return isEof_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"isSpace") ) { return isSpace_dyn(); }
		if (HX_FIELD_EQ(inName,"replace") ) { return replace_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"endsWith") ) { return endsWith_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"urlEncode") ) { return urlEncode_dyn(); }
		if (HX_FIELD_EQ(inName,"urlDecode") ) { return urlDecode_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"htmlEscape") ) { return htmlEscape_dyn(); }
		if (HX_FIELD_EQ(inName,"startsWith") ) { return startsWith_dyn(); }
		if (HX_FIELD_EQ(inName,"fastCodeAt") ) { return fastCodeAt_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"htmlUnescape") ) { return htmlUnescape_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic StringTools_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void StringTools_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("urlEncode"),
	HX_CSTRING("urlDecode"),
	HX_CSTRING("htmlEscape"),
	HX_CSTRING("htmlUnescape"),
	HX_CSTRING("startsWith"),
	HX_CSTRING("endsWith"),
	HX_CSTRING("isSpace"),
	HX_CSTRING("ltrim"),
	HX_CSTRING("rtrim"),
	HX_CSTRING("trim"),
	HX_CSTRING("lpad"),
	HX_CSTRING("rpad"),
	HX_CSTRING("replace"),
	HX_CSTRING("hex"),
	HX_CSTRING("fastCodeAt"),
	HX_CSTRING("isEof"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(StringTools_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(StringTools_obj::__mClass,"__mClass");
};

#endif

Class StringTools_obj::__mClass;

void StringTools_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("StringTools"), hx::TCanCast< StringTools_obj> ,sStaticFields,sMemberFields,
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

void StringTools_obj::__boot()
{
}

