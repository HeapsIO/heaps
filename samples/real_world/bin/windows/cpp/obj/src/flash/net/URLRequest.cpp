#include <hxcpp.h>

#ifndef INCLUDED_Reflect
#include <Reflect.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_flash_net_URLRequest
#include <flash/net/URLRequest.h>
#endif
#ifndef INCLUDED_flash_net_URLRequestHeader
#include <flash/net/URLRequestHeader.h>
#endif
#ifndef INCLUDED_flash_net_URLVariables
#include <flash/net/URLVariables.h>
#endif
#ifndef INCLUDED_flash_utils_ByteArray
#include <flash/utils/ByteArray.h>
#endif
#ifndef INCLUDED_flash_utils_IDataInput
#include <flash/utils/IDataInput.h>
#endif
#ifndef INCLUDED_flash_utils_IDataOutput
#include <flash/utils/IDataOutput.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_openfl_utils_IMemoryRange
#include <openfl/utils/IMemoryRange.h>
#endif
namespace flash{
namespace net{

Void URLRequest_obj::__construct(::String url)
{
HX_STACK_FRAME("flash.net.URLRequest","new",0x323f69a1,"flash.net.URLRequest.new","flash/net/URLRequest.hx",31,0xb08ea72d)
HX_STACK_THIS(this)
HX_STACK_ARG(url,"url")
{
	HX_STACK_LINE(33)
	if (((url != null()))){
		HX_STACK_LINE(35)
		this->url = url;
	}
	HX_STACK_LINE(39)
	this->requestHeaders = Array_obj< ::Dynamic >::__new();
	HX_STACK_LINE(40)
	this->method = HX_CSTRING("GET");
	HX_STACK_LINE(42)
	this->verbose = false;
	HX_STACK_LINE(43)
	this->cookieString = HX_CSTRING("");
	HX_STACK_LINE(44)
	this->authType = (int)0;
	HX_STACK_LINE(45)
	this->contentType = HX_CSTRING("application/x-www-form-urlencoded");
	HX_STACK_LINE(46)
	this->credentials = HX_CSTRING("");
	HX_STACK_LINE(47)
	this->followRedirects = true;
}
;
	return null();
}

//URLRequest_obj::~URLRequest_obj() { }

Dynamic URLRequest_obj::__CreateEmpty() { return  new URLRequest_obj; }
hx::ObjectPtr< URLRequest_obj > URLRequest_obj::__new(::String url)
{  hx::ObjectPtr< URLRequest_obj > result = new URLRequest_obj();
	result->__construct(url);
	return result;}

Dynamic URLRequest_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< URLRequest_obj > result = new URLRequest_obj();
	result->__construct(inArgs[0]);
	return result;}

Void URLRequest_obj::basicAuth( ::String user,::String password){
{
		HX_STACK_FRAME("flash.net.URLRequest","basicAuth",0x1937a537,"flash.net.URLRequest.basicAuth","flash/net/URLRequest.hx",52,0xb08ea72d)
		HX_STACK_THIS(this)
		HX_STACK_ARG(user,"user")
		HX_STACK_ARG(password,"password")
		HX_STACK_LINE(54)
		this->authType = (int)1;
		HX_STACK_LINE(55)
		this->credentials = ((user + HX_CSTRING(":")) + password);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(URLRequest_obj,basicAuth,(void))

Void URLRequest_obj::digestAuth( ::String user,::String password){
{
		HX_STACK_FRAME("flash.net.URLRequest","digestAuth",0x5bacfeab,"flash.net.URLRequest.digestAuth","flash/net/URLRequest.hx",60,0xb08ea72d)
		HX_STACK_THIS(this)
		HX_STACK_ARG(user,"user")
		HX_STACK_ARG(password,"password")
		HX_STACK_LINE(62)
		this->authType = (int)2;
		HX_STACK_LINE(63)
		this->credentials = ((user + HX_CSTRING(":")) + password);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(URLRequest_obj,digestAuth,(void))

Void URLRequest_obj::__prepare( ){
{
		HX_STACK_FRAME("flash.net.URLRequest","__prepare",0x90436268,"flash.net.URLRequest.__prepare","flash/net/URLRequest.hx",70,0xb08ea72d)
		HX_STACK_THIS(this)
		HX_STACK_LINE(70)
		if (((this->data == null()))){
			HX_STACK_LINE(72)
			::flash::utils::ByteArray _g = ::flash::utils::ByteArray_obj::__new(null());		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(72)
			this->__bytes = _g;
		}
		else{
			HX_STACK_LINE(74)
			if ((::Std_obj::is(this->data,hx::ClassOf< ::flash::utils::ByteArray >()))){
				HX_STACK_LINE(76)
				this->__bytes = this->data;
			}
			else{
				HX_STACK_LINE(78)
				if ((::Std_obj::is(this->data,hx::ClassOf< ::flash::net::URLVariables >()))){
					HX_STACK_LINE(80)
					::flash::net::URLVariables vars = this->data;		HX_STACK_VAR(vars,"vars");
					HX_STACK_LINE(81)
					::String str = vars->toString();		HX_STACK_VAR(str,"str");
					HX_STACK_LINE(82)
					::flash::utils::ByteArray _g1 = ::flash::utils::ByteArray_obj::__new(null());		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(82)
					this->__bytes = _g1;
					HX_STACK_LINE(83)
					this->__bytes->writeUTFBytes(str);
				}
				else{
					HX_STACK_LINE(85)
					if ((::Std_obj::is(this->data,hx::ClassOf< ::String >()))){
						HX_STACK_LINE(87)
						::String str = this->data;		HX_STACK_VAR(str,"str");
						HX_STACK_LINE(88)
						::flash::utils::ByteArray _g2 = ::flash::utils::ByteArray_obj::__new(null());		HX_STACK_VAR(_g2,"_g2");
						HX_STACK_LINE(88)
						this->__bytes = _g2;
						HX_STACK_LINE(89)
						this->__bytes->writeUTFBytes(str);
					}
					else{
						HX_STACK_LINE(91)
						if ((::Std_obj::is(this->data,hx::ClassOf< ::Dynamic >()))){
							HX_STACK_LINE(93)
							::flash::net::URLVariables vars = ::flash::net::URLVariables_obj::__new(null());		HX_STACK_VAR(vars,"vars");
							HX_STACK_LINE(95)
							{
								HX_STACK_LINE(95)
								int _g = (int)0;		HX_STACK_VAR(_g,"_g");
								HX_STACK_LINE(95)
								Array< ::String > _g1 = ::Reflect_obj::fields(this->data);		HX_STACK_VAR(_g1,"_g1");
								HX_STACK_LINE(95)
								while((true)){
									HX_STACK_LINE(95)
									if ((!(((_g < _g1->length))))){
										HX_STACK_LINE(95)
										break;
									}
									HX_STACK_LINE(95)
									::String i = _g1->__get(_g);		HX_STACK_VAR(i,"i");
									HX_STACK_LINE(95)
									++(_g);
									HX_STACK_LINE(97)
									{
										HX_STACK_LINE(97)
										Dynamic value = ::Reflect_obj::field(this->data,i);		HX_STACK_VAR(value,"value");
										HX_STACK_LINE(97)
										if (((vars != null()))){
											HX_STACK_LINE(97)
											vars->__SetField(i,value,false);
										}
									}
								}
							}
							HX_STACK_LINE(101)
							::String str = vars->toString();		HX_STACK_VAR(str,"str");
							HX_STACK_LINE(102)
							::flash::utils::ByteArray _g3 = ::flash::utils::ByteArray_obj::__new(null());		HX_STACK_VAR(_g3,"_g3");
							HX_STACK_LINE(102)
							this->__bytes = _g3;
							HX_STACK_LINE(103)
							this->__bytes->writeUTFBytes(str);
						}
						else{
							HX_STACK_LINE(107)
							HX_STACK_DO_THROW(HX_CSTRING("Unknown data type"));
						}
					}
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(URLRequest_obj,__prepare,(void))

int URLRequest_obj::AUTH_BASIC;

int URLRequest_obj::AUTH_DIGEST;

int URLRequest_obj::AUTH_GSSNEGOTIATE;

int URLRequest_obj::AUTH_NTLM;

int URLRequest_obj::AUTH_DIGEST_IE;

int URLRequest_obj::AUTH_DIGEST_ANY;


URLRequest_obj::URLRequest_obj()
{
}

void URLRequest_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(URLRequest);
	HX_MARK_MEMBER_NAME(authType,"authType");
	HX_MARK_MEMBER_NAME(contentType,"contentType");
	HX_MARK_MEMBER_NAME(cookieString,"cookieString");
	HX_MARK_MEMBER_NAME(credentials,"credentials");
	HX_MARK_MEMBER_NAME(data,"data");
	HX_MARK_MEMBER_NAME(followRedirects,"followRedirects");
	HX_MARK_MEMBER_NAME(method,"method");
	HX_MARK_MEMBER_NAME(requestHeaders,"requestHeaders");
	HX_MARK_MEMBER_NAME(url,"url");
	HX_MARK_MEMBER_NAME(verbose,"verbose");
	HX_MARK_MEMBER_NAME(__bytes,"__bytes");
	HX_MARK_END_CLASS();
}

void URLRequest_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(authType,"authType");
	HX_VISIT_MEMBER_NAME(contentType,"contentType");
	HX_VISIT_MEMBER_NAME(cookieString,"cookieString");
	HX_VISIT_MEMBER_NAME(credentials,"credentials");
	HX_VISIT_MEMBER_NAME(data,"data");
	HX_VISIT_MEMBER_NAME(followRedirects,"followRedirects");
	HX_VISIT_MEMBER_NAME(method,"method");
	HX_VISIT_MEMBER_NAME(requestHeaders,"requestHeaders");
	HX_VISIT_MEMBER_NAME(url,"url");
	HX_VISIT_MEMBER_NAME(verbose,"verbose");
	HX_VISIT_MEMBER_NAME(__bytes,"__bytes");
}

Dynamic URLRequest_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"url") ) { return url; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"data") ) { return data; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"method") ) { return method; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"verbose") ) { return verbose; }
		if (HX_FIELD_EQ(inName,"__bytes") ) { return __bytes; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"authType") ) { return authType; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"basicAuth") ) { return basicAuth_dyn(); }
		if (HX_FIELD_EQ(inName,"__prepare") ) { return __prepare_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"digestAuth") ) { return digestAuth_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"contentType") ) { return contentType; }
		if (HX_FIELD_EQ(inName,"credentials") ) { return credentials; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"cookieString") ) { return cookieString; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"requestHeaders") ) { return requestHeaders; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"followRedirects") ) { return followRedirects; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic URLRequest_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"url") ) { url=inValue.Cast< ::String >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"data") ) { data=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"method") ) { method=inValue.Cast< ::String >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"verbose") ) { verbose=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"__bytes") ) { __bytes=inValue.Cast< ::flash::utils::ByteArray >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"authType") ) { authType=inValue.Cast< int >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"contentType") ) { contentType=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"credentials") ) { credentials=inValue.Cast< ::String >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"cookieString") ) { cookieString=inValue.Cast< ::String >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"requestHeaders") ) { requestHeaders=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"followRedirects") ) { followRedirects=inValue.Cast< bool >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void URLRequest_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("authType"));
	outFields->push(HX_CSTRING("contentType"));
	outFields->push(HX_CSTRING("cookieString"));
	outFields->push(HX_CSTRING("credentials"));
	outFields->push(HX_CSTRING("data"));
	outFields->push(HX_CSTRING("followRedirects"));
	outFields->push(HX_CSTRING("method"));
	outFields->push(HX_CSTRING("requestHeaders"));
	outFields->push(HX_CSTRING("url"));
	outFields->push(HX_CSTRING("verbose"));
	outFields->push(HX_CSTRING("__bytes"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("AUTH_BASIC"),
	HX_CSTRING("AUTH_DIGEST"),
	HX_CSTRING("AUTH_GSSNEGOTIATE"),
	HX_CSTRING("AUTH_NTLM"),
	HX_CSTRING("AUTH_DIGEST_IE"),
	HX_CSTRING("AUTH_DIGEST_ANY"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(URLRequest_obj,authType),HX_CSTRING("authType")},
	{hx::fsString,(int)offsetof(URLRequest_obj,contentType),HX_CSTRING("contentType")},
	{hx::fsString,(int)offsetof(URLRequest_obj,cookieString),HX_CSTRING("cookieString")},
	{hx::fsString,(int)offsetof(URLRequest_obj,credentials),HX_CSTRING("credentials")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(URLRequest_obj,data),HX_CSTRING("data")},
	{hx::fsBool,(int)offsetof(URLRequest_obj,followRedirects),HX_CSTRING("followRedirects")},
	{hx::fsString,(int)offsetof(URLRequest_obj,method),HX_CSTRING("method")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(URLRequest_obj,requestHeaders),HX_CSTRING("requestHeaders")},
	{hx::fsString,(int)offsetof(URLRequest_obj,url),HX_CSTRING("url")},
	{hx::fsBool,(int)offsetof(URLRequest_obj,verbose),HX_CSTRING("verbose")},
	{hx::fsObject /*::flash::utils::ByteArray*/ ,(int)offsetof(URLRequest_obj,__bytes),HX_CSTRING("__bytes")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("authType"),
	HX_CSTRING("contentType"),
	HX_CSTRING("cookieString"),
	HX_CSTRING("credentials"),
	HX_CSTRING("data"),
	HX_CSTRING("followRedirects"),
	HX_CSTRING("method"),
	HX_CSTRING("requestHeaders"),
	HX_CSTRING("url"),
	HX_CSTRING("verbose"),
	HX_CSTRING("__bytes"),
	HX_CSTRING("basicAuth"),
	HX_CSTRING("digestAuth"),
	HX_CSTRING("__prepare"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(URLRequest_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(URLRequest_obj::AUTH_BASIC,"AUTH_BASIC");
	HX_MARK_MEMBER_NAME(URLRequest_obj::AUTH_DIGEST,"AUTH_DIGEST");
	HX_MARK_MEMBER_NAME(URLRequest_obj::AUTH_GSSNEGOTIATE,"AUTH_GSSNEGOTIATE");
	HX_MARK_MEMBER_NAME(URLRequest_obj::AUTH_NTLM,"AUTH_NTLM");
	HX_MARK_MEMBER_NAME(URLRequest_obj::AUTH_DIGEST_IE,"AUTH_DIGEST_IE");
	HX_MARK_MEMBER_NAME(URLRequest_obj::AUTH_DIGEST_ANY,"AUTH_DIGEST_ANY");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(URLRequest_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(URLRequest_obj::AUTH_BASIC,"AUTH_BASIC");
	HX_VISIT_MEMBER_NAME(URLRequest_obj::AUTH_DIGEST,"AUTH_DIGEST");
	HX_VISIT_MEMBER_NAME(URLRequest_obj::AUTH_GSSNEGOTIATE,"AUTH_GSSNEGOTIATE");
	HX_VISIT_MEMBER_NAME(URLRequest_obj::AUTH_NTLM,"AUTH_NTLM");
	HX_VISIT_MEMBER_NAME(URLRequest_obj::AUTH_DIGEST_IE,"AUTH_DIGEST_IE");
	HX_VISIT_MEMBER_NAME(URLRequest_obj::AUTH_DIGEST_ANY,"AUTH_DIGEST_ANY");
};

#endif

Class URLRequest_obj::__mClass;

void URLRequest_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.net.URLRequest"), hx::TCanCast< URLRequest_obj> ,sStaticFields,sMemberFields,
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

void URLRequest_obj::__boot()
{
	AUTH_BASIC= (int)1;
	AUTH_DIGEST= (int)2;
	AUTH_GSSNEGOTIATE= (int)4;
	AUTH_NTLM= (int)8;
	AUTH_DIGEST_IE= (int)16;
	AUTH_DIGEST_ANY= (int)15;
}

} // end namespace flash
} // end namespace net
