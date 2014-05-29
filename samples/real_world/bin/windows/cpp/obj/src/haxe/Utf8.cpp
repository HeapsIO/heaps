#include <hxcpp.h>

#ifndef INCLUDED_haxe_Utf8
#include <haxe/Utf8.h>
#endif
namespace haxe{

Void Utf8_obj::__construct(Dynamic size)
{
HX_STACK_FRAME("haxe.Utf8","new",0x67cc940b,"haxe.Utf8.new","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/Utf8.hx",29,0xc486c264)
HX_STACK_THIS(this)
HX_STACK_ARG(size,"size")
{
	HX_STACK_LINE(30)
	Array< int > _g = Array_obj< int >::__new();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(30)
	this->__s = _g;
	HX_STACK_LINE(31)
	if (((bool((size != null())) && bool((size > (int)0))))){
		HX_STACK_LINE(32)
		this->__s[(size - (int)1)] = (int)0;
	}
}
;
	return null();
}

//Utf8_obj::~Utf8_obj() { }

Dynamic Utf8_obj::__CreateEmpty() { return  new Utf8_obj; }
hx::ObjectPtr< Utf8_obj > Utf8_obj::__new(Dynamic size)
{  hx::ObjectPtr< Utf8_obj > result = new Utf8_obj();
	result->__construct(size);
	return result;}

Dynamic Utf8_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Utf8_obj > result = new Utf8_obj();
	result->__construct(inArgs[0]);
	return result;}

Void Utf8_obj::addChar( int c){
{
		HX_STACK_FRAME("haxe.Utf8","addChar",0x9a1816c2,"haxe.Utf8.addChar","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/Utf8.hx",36,0xc486c264)
		HX_STACK_THIS(this)
		HX_STACK_ARG(c,"c")
		HX_STACK_LINE(36)
		this->__s->push(c);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Utf8_obj,addChar,(void))

::String Utf8_obj::toString( ){
	HX_STACK_FRAME("haxe.Utf8","toString",0xb459e121,"haxe.Utf8.toString","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/Utf8.hx",40,0xc486c264)
	HX_STACK_THIS(this)
	HX_STACK_LINE(40)
	return ::__hxcpp_char_array_to_utf8_string(this->__s);
}


HX_DEFINE_DYNAMIC_FUNC0(Utf8_obj,toString,return )

::String Utf8_obj::encode( ::String s){
	HX_STACK_FRAME("haxe.Utf8","encode",0xe30e8b4b,"haxe.Utf8.encode","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/Utf8.hx",46,0xc486c264)
	HX_STACK_ARG(s,"s")
	HX_STACK_LINE(46)
	return ::__hxcpp_char_bytes_to_utf8_string(s);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Utf8_obj,encode,return )

::String Utf8_obj::decode( ::String s){
	HX_STACK_FRAME("haxe.Utf8","decode",0x4e17f663,"haxe.Utf8.decode","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/Utf8.hx",52,0xc486c264)
	HX_STACK_ARG(s,"s")
	HX_STACK_LINE(52)
	return ::__hxcpp_utf8_string_to_char_bytes(s);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Utf8_obj,decode,return )

Void Utf8_obj::iter( ::String s,Dynamic chars){
{
		HX_STACK_FRAME("haxe.Utf8","iter",0x67f2370d,"haxe.Utf8.iter","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/Utf8.hx",55,0xc486c264)
		HX_STACK_ARG(s,"s")
		HX_STACK_ARG(chars,"chars")
		HX_STACK_LINE(56)
		Array< int > array = ::__hxcpp_utf8_string_to_char_array(s);		HX_STACK_VAR(array,"array");
		HX_STACK_LINE(57)
		{
			HX_STACK_LINE(57)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(57)
			while((true)){
				HX_STACK_LINE(57)
				if ((!(((_g < array->length))))){
					HX_STACK_LINE(57)
					break;
				}
				HX_STACK_LINE(57)
				int a = array->__get(_g);		HX_STACK_VAR(a,"a");
				HX_STACK_LINE(57)
				++(_g);
				HX_STACK_LINE(58)
				chars(a).Cast< Void >();
			}
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Utf8_obj,iter,(void))

int Utf8_obj::charCodeAt( ::String s,int index){
	HX_STACK_FRAME("haxe.Utf8","charCodeAt",0xce7cbeab,"haxe.Utf8.charCodeAt","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/Utf8.hx",61,0xc486c264)
	HX_STACK_ARG(s,"s")
	HX_STACK_ARG(index,"index")
	HX_STACK_LINE(62)
	Array< int > array = ::__hxcpp_utf8_string_to_char_array(s);		HX_STACK_VAR(array,"array");
	HX_STACK_LINE(63)
	return array->__get(index);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Utf8_obj,charCodeAt,return )

bool Utf8_obj::validate( ::String s){
	HX_STACK_FRAME("haxe.Utf8","validate",0x80cee10b,"haxe.Utf8.validate","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/Utf8.hx",66,0xc486c264)
	HX_STACK_ARG(s,"s")
	HX_STACK_LINE(67)
	try
	{
	HX_STACK_CATCHABLE(Dynamic, 0);
	{
		HX_STACK_LINE(68)
		::__hxcpp_utf8_string_to_char_array(s);
		HX_STACK_LINE(69)
		return true;
	}
	}
	catch(Dynamic __e){
		{
			HX_STACK_BEGIN_CATCH
			Dynamic e = __e;{
			}
		}
	}
	HX_STACK_LINE(71)
	return false;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Utf8_obj,validate,return )

int Utf8_obj::length( ::String s){
	HX_STACK_FRAME("haxe.Utf8","length",0x88322e1b,"haxe.Utf8.length","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/Utf8.hx",74,0xc486c264)
	HX_STACK_ARG(s,"s")
	HX_STACK_LINE(75)
	Array< int > array = ::__hxcpp_utf8_string_to_char_array(s);		HX_STACK_VAR(array,"array");
	HX_STACK_LINE(76)
	return array->length;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Utf8_obj,length,return )

int Utf8_obj::compare( ::String a,::String b){
	HX_STACK_FRAME("haxe.Utf8","compare",0x9f848dd0,"haxe.Utf8.compare","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/Utf8.hx",79,0xc486c264)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(80)
	Array< int > a_ = ::__hxcpp_utf8_string_to_char_array(a);		HX_STACK_VAR(a_,"a_");
	HX_STACK_LINE(81)
	Array< int > b_ = ::__hxcpp_utf8_string_to_char_array(b);		HX_STACK_VAR(b_,"b_");
	HX_STACK_LINE(82)
	int min;		HX_STACK_VAR(min,"min");
	HX_STACK_LINE(82)
	if (((a_->length < b_->length))){
		HX_STACK_LINE(82)
		min = a_->length;
	}
	else{
		HX_STACK_LINE(82)
		min = b_->length;
	}
	HX_STACK_LINE(83)
	{
		HX_STACK_LINE(83)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(83)
		while((true)){
			HX_STACK_LINE(83)
			if ((!(((_g < min))))){
				HX_STACK_LINE(83)
				break;
			}
			HX_STACK_LINE(83)
			int i = (_g)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(85)
			if (((a_->__get(i) < b_->__get(i)))){
				HX_STACK_LINE(85)
				return (int)-1;
			}
			HX_STACK_LINE(86)
			if (((a_->__get(i) > b_->__get(i)))){
				HX_STACK_LINE(86)
				return (int)1;
			}
		}
	}
	HX_STACK_LINE(88)
	if (((a_->length == b_->length))){
		HX_STACK_LINE(88)
		return (int)0;
	}
	else{
		HX_STACK_LINE(88)
		if (((a_->length < b_->length))){
			HX_STACK_LINE(88)
			return (int)-1;
		}
		else{
			HX_STACK_LINE(88)
			return (int)1;
		}
	}
	HX_STACK_LINE(88)
	return (int)0;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Utf8_obj,compare,return )

::String Utf8_obj::sub( ::String s,int pos,int len){
	HX_STACK_FRAME("haxe.Utf8","sub",0x67d06d2b,"haxe.Utf8.sub","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/Utf8.hx",91,0xc486c264)
	HX_STACK_ARG(s,"s")
	HX_STACK_ARG(pos,"pos")
	HX_STACK_ARG(len,"len")
	HX_STACK_LINE(92)
	Array< int > array = ::__hxcpp_utf8_string_to_char_array(s);		HX_STACK_VAR(array,"array");
	HX_STACK_LINE(93)
	int last;		HX_STACK_VAR(last,"last");
	HX_STACK_LINE(93)
	if (((len < (int)0))){
		HX_STACK_LINE(93)
		last = array->length;
	}
	else{
		HX_STACK_LINE(93)
		last = (pos + len);
	}
	HX_STACK_LINE(94)
	if (((last > array->length))){
		HX_STACK_LINE(94)
		last = array->length;
	}
	HX_STACK_LINE(95)
	Array< int > sub = array->slice(pos,last);		HX_STACK_VAR(sub,"sub");
	HX_STACK_LINE(96)
	return ::__hxcpp_char_array_to_utf8_string(sub);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Utf8_obj,sub,return )


Utf8_obj::Utf8_obj()
{
}

void Utf8_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Utf8);
	HX_MARK_MEMBER_NAME(__s,"__s");
	HX_MARK_END_CLASS();
}

void Utf8_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(__s,"__s");
}

Dynamic Utf8_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"sub") ) { return sub_dyn(); }
		if (HX_FIELD_EQ(inName,"__s") ) { return __s; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"iter") ) { return iter_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"encode") ) { return encode_dyn(); }
		if (HX_FIELD_EQ(inName,"decode") ) { return decode_dyn(); }
		if (HX_FIELD_EQ(inName,"length") ) { return length_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"compare") ) { return compare_dyn(); }
		if (HX_FIELD_EQ(inName,"addChar") ) { return addChar_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"validate") ) { return validate_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"charCodeAt") ) { return charCodeAt_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Utf8_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"__s") ) { __s=inValue.Cast< Array< int > >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Utf8_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("__s"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("encode"),
	HX_CSTRING("decode"),
	HX_CSTRING("iter"),
	HX_CSTRING("charCodeAt"),
	HX_CSTRING("validate"),
	HX_CSTRING("length"),
	HX_CSTRING("compare"),
	HX_CSTRING("sub"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Array< int >*/ ,(int)offsetof(Utf8_obj,__s),HX_CSTRING("__s")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("__s"),
	HX_CSTRING("addChar"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Utf8_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Utf8_obj::__mClass,"__mClass");
};

#endif

Class Utf8_obj::__mClass;

void Utf8_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.Utf8"), hx::TCanCast< Utf8_obj> ,sStaticFields,sMemberFields,
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

void Utf8_obj::__boot()
{
}

} // end namespace haxe
