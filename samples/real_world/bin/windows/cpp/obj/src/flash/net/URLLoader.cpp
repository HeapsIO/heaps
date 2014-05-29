#include <hxcpp.h>

#ifndef INCLUDED_List
#include <List.h>
#endif
#ifndef INCLUDED_flash_Lib
#include <flash/Lib.h>
#endif
#ifndef INCLUDED_flash_events_ErrorEvent
#include <flash/events/ErrorEvent.h>
#endif
#ifndef INCLUDED_flash_events_Event
#include <flash/events/Event.h>
#endif
#ifndef INCLUDED_flash_events_EventDispatcher
#include <flash/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_flash_events_HTTPStatusEvent
#include <flash/events/HTTPStatusEvent.h>
#endif
#ifndef INCLUDED_flash_events_IEventDispatcher
#include <flash/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_flash_events_IOErrorEvent
#include <flash/events/IOErrorEvent.h>
#endif
#ifndef INCLUDED_flash_events_ProgressEvent
#include <flash/events/ProgressEvent.h>
#endif
#ifndef INCLUDED_flash_events_TextEvent
#include <flash/events/TextEvent.h>
#endif
#ifndef INCLUDED_flash_net_URLLoader
#include <flash/net/URLLoader.h>
#endif
#ifndef INCLUDED_flash_net_URLLoaderDataFormat
#include <flash/net/URLLoaderDataFormat.h>
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

Void URLLoader_obj::__construct(::flash::net::URLRequest request)
{
HX_STACK_FRAME("flash.net.URLLoader","new",0x7f9db4a5,"flash.net.URLLoader.new","flash/net/URLLoader.hx",35,0xf174b5ed)
HX_STACK_THIS(this)
HX_STACK_ARG(request,"request")
{
	HX_STACK_LINE(37)
	super::__construct(null());
	HX_STACK_LINE(39)
	this->__handle = (int)0;
	HX_STACK_LINE(40)
	this->bytesLoaded = (int)0;
	HX_STACK_LINE(41)
	this->bytesTotal = (int)-1;
	HX_STACK_LINE(42)
	this->state = (int)0;
	HX_STACK_LINE(43)
	this->dataFormat = ::flash::net::URLLoaderDataFormat_obj::TEXT;
	HX_STACK_LINE(45)
	if (((request != null()))){
		HX_STACK_LINE(47)
		this->load(request);
	}
}
;
	return null();
}

//URLLoader_obj::~URLLoader_obj() { }

Dynamic URLLoader_obj::__CreateEmpty() { return  new URLLoader_obj; }
hx::ObjectPtr< URLLoader_obj > URLLoader_obj::__new(::flash::net::URLRequest request)
{  hx::ObjectPtr< URLLoader_obj > result = new URLLoader_obj();
	result->__construct(request);
	return result;}

Dynamic URLLoader_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< URLLoader_obj > result = new URLLoader_obj();
	result->__construct(inArgs[0]);
	return result;}

Void URLLoader_obj::close( ){
{
		HX_STACK_FRAME("flash.net.URLLoader","close",0x9922573d,"flash.net.URLLoader.close","flash/net/URLLoader.hx",54,0xf174b5ed)
		HX_STACK_THIS(this)
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(URLLoader_obj,close,(void))

Void URLLoader_obj::dispatchHTTPStatus( int code){
{
		HX_STACK_FRAME("flash.net.URLLoader","dispatchHTTPStatus",0xad78016f,"flash.net.URLLoader.dispatchHTTPStatus","flash/net/URLLoader.hx",61,0xf174b5ed)
		HX_STACK_THIS(this)
		HX_STACK_ARG(code,"code")
		HX_STACK_LINE(63)
		::flash::events::HTTPStatusEvent event = ::flash::events::HTTPStatusEvent_obj::__new(::flash::events::HTTPStatusEvent_obj::HTTP_STATUS,false,false,code);		HX_STACK_VAR(event,"event");
		HX_STACK_LINE(64)
		Array< ::String > headers = ::flash::net::URLLoader_obj::lime_curl_get_headers(this->__handle);		HX_STACK_VAR(headers,"headers");
		HX_STACK_LINE(66)
		{
			HX_STACK_LINE(66)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(66)
			while((true)){
				HX_STACK_LINE(66)
				if ((!(((_g < headers->length))))){
					HX_STACK_LINE(66)
					break;
				}
				HX_STACK_LINE(66)
				::String header = headers->__get(_g);		HX_STACK_VAR(header,"header");
				HX_STACK_LINE(66)
				++(_g);
				HX_STACK_LINE(68)
				int index = header.indexOf(HX_CSTRING(": "),null());		HX_STACK_VAR(index,"index");
				HX_STACK_LINE(69)
				if (((index > (int)0))){
					HX_STACK_LINE(71)
					::String _g1 = header.substr((int)0,index);		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(71)
					::String _g11 = header.substr((index + (int)2),((header.length - index) - (int)4));		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(71)
					::flash::net::URLRequestHeader _g2 = ::flash::net::URLRequestHeader_obj::__new(_g1,_g11);		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(71)
					event->responseHeaders->push(_g2);
				}
			}
		}
		HX_STACK_LINE(77)
		this->dispatchEvent(event);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(URLLoader_obj,dispatchHTTPStatus,(void))

Array< ::String > URLLoader_obj::getCookies( ){
	HX_STACK_FRAME("flash.net.URLLoader","getCookies",0x3a631bb4,"flash.net.URLLoader.getCookies","flash/net/URLLoader.hx",84,0xf174b5ed)
	HX_STACK_THIS(this)
	HX_STACK_LINE(84)
	return ::flash::net::URLLoader_obj::lime_curl_get_cookies(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(URLLoader_obj,getCookies,return )

Void URLLoader_obj::load( ::flash::net::URLRequest request){
{
		HX_STACK_FRAME("flash.net.URLLoader","load",0x29157241,"flash.net.URLLoader.load","flash/net/URLLoader.hx",103,0xf174b5ed)
		HX_STACK_THIS(this)
		HX_STACK_ARG(request,"request")
		HX_STACK_LINE(105)
		this->state = (int)1;
		HX_STACK_LINE(107)
		::String pref = request->url.substr((int)0,(int)7);		HX_STACK_VAR(pref,"pref");
		HX_STACK_LINE(108)
		if (((bool((pref != HX_CSTRING("http://"))) && bool((pref != HX_CSTRING("https:/")))))){
			HX_STACK_LINE(110)
			try
			{
			HX_STACK_CATCHABLE(Dynamic, 0);
			{
				HX_STACK_LINE(112)
				::flash::utils::ByteArray bytes = ::flash::utils::ByteArray_obj::readFile(request->url);		HX_STACK_VAR(bytes,"bytes");
				HX_STACK_LINE(114)
				if (((bytes == null()))){
					HX_STACK_LINE(116)
					HX_STACK_DO_THROW(((HX_CSTRING("Could not open file \"") + request->url) + HX_CSTRING("\"")));
				}
				HX_STACK_LINE(120)
				{
					HX_STACK_LINE(120)
					::flash::net::URLLoaderDataFormat _g = this->dataFormat;		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(120)
					switch( (int)(_g->__Index())){
						case (int)1: {
							HX_STACK_LINE(122)
							::String _g1 = bytes->asString();		HX_STACK_VAR(_g1,"_g1");
							HX_STACK_LINE(122)
							this->data = _g1;
						}
						;break;
						case (int)2: {
							HX_STACK_LINE(123)
							::String _g1 = bytes->asString();		HX_STACK_VAR(_g1,"_g1");
							HX_STACK_LINE(123)
							::flash::net::URLVariables _g2 = ::flash::net::URLVariables_obj::__new(_g1);		HX_STACK_VAR(_g2,"_g2");
							HX_STACK_LINE(123)
							this->data = _g2;
						}
						;break;
						default: {
							HX_STACK_LINE(124)
							this->data = bytes;
						}
					}
				}
			}
			}
			catch(Dynamic __e){
				{
					HX_STACK_BEGIN_CATCH
					Dynamic e = __e;{
						HX_STACK_LINE(130)
						this->onError(e);
						HX_STACK_LINE(131)
						return null();
					}
				}
			}
			HX_STACK_LINE(135)
			this->__dataComplete();
		}
		else{
			HX_STACK_LINE(139)
			request->__prepare();
			HX_STACK_LINE(140)
			Dynamic _g3 = ::flash::net::URLLoader_obj::lime_curl_create(request);		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(140)
			this->__handle = _g3;
			HX_STACK_LINE(142)
			if (((this->__handle == null()))){
				HX_STACK_LINE(144)
				this->onError(HX_CSTRING("Could not open URL"));
			}
			else{
				HX_STACK_LINE(148)
				::flash::net::URLLoader_obj::activeLoaders->push(hx::ObjectPtr<OBJ_>(this));
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(URLLoader_obj,load,(void))

Void URLLoader_obj::onError( ::String msg){
{
		HX_STACK_FRAME("flash.net.URLLoader","onError",0x781954ee,"flash.net.URLLoader.onError","flash/net/URLLoader.hx",157,0xf174b5ed)
		HX_STACK_THIS(this)
		HX_STACK_ARG(msg,"msg")
		HX_STACK_LINE(159)
		::flash::net::URLLoader_obj::activeLoaders->remove(hx::ObjectPtr<OBJ_>(this));
		HX_STACK_LINE(160)
		::flash::events::IOErrorEvent _g = ::flash::events::IOErrorEvent_obj::__new(::flash::events::IOErrorEvent_obj::IO_ERROR,true,false,msg,null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(160)
		this->dispatchEvent(_g);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(URLLoader_obj,onError,(void))

Void URLLoader_obj::update( ){
{
		HX_STACK_FRAME("flash.net.URLLoader","update",0xdd9ddae4,"flash.net.URLLoader.update","flash/net/URLLoader.hx",167,0xf174b5ed)
		HX_STACK_THIS(this)
		HX_STACK_LINE(167)
		if (((this->__handle != null()))){
			HX_STACK_LINE(169)
			int old_loaded = this->bytesLoaded;		HX_STACK_VAR(old_loaded,"old_loaded");
			HX_STACK_LINE(170)
			int old_total = this->bytesTotal;		HX_STACK_VAR(old_total,"old_total");
			HX_STACK_LINE(171)
			::flash::net::URLLoader_obj::lime_curl_update_loader(this->__handle,hx::ObjectPtr<OBJ_>(this));
			HX_STACK_LINE(173)
			if (((bool((old_total < (int)0)) && bool((this->bytesTotal > (int)0))))){
				HX_STACK_LINE(175)
				::flash::events::Event _g = ::flash::events::Event_obj::__new(::flash::events::Event_obj::OPEN,null(),null());		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(175)
				this->dispatchEvent(_g);
			}
			HX_STACK_LINE(179)
			if (((bool((this->bytesTotal > (int)0)) && bool((this->bytesLoaded != old_loaded))))){
				HX_STACK_LINE(181)
				::flash::events::ProgressEvent _g1 = ::flash::events::ProgressEvent_obj::__new(HX_CSTRING("progress"),false,false,this->bytesLoaded,this->bytesTotal);		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(181)
				this->dispatchEvent(_g1);
			}
			HX_STACK_LINE(185)
			int code = ::flash::net::URLLoader_obj::lime_curl_get_code(this->__handle);		HX_STACK_VAR(code,"code");
			HX_STACK_LINE(187)
			if (((this->state == (int)3))){
				HX_STACK_LINE(189)
				this->dispatchHTTPStatus(code);
				HX_STACK_LINE(191)
				::flash::utils::ByteArray bytes = ::flash::net::URLLoader_obj::lime_curl_get_data(this->__handle);		HX_STACK_VAR(bytes,"bytes");
				HX_STACK_LINE(193)
				{
					HX_STACK_LINE(193)
					::flash::net::URLLoaderDataFormat _g = this->dataFormat;		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(193)
					switch( (int)(_g->__Index())){
						case (int)1: case (int)2: {
							HX_STACK_LINE(196)
							Dynamic _g2;		HX_STACK_VAR(_g2,"_g2");
							HX_STACK_LINE(196)
							if (((bytes == null()))){
								HX_STACK_LINE(196)
								_g2 = HX_CSTRING("");
							}
							else{
								HX_STACK_LINE(196)
								_g2 = bytes->asString();
							}
							HX_STACK_LINE(196)
							this->data = _g2;
						}
						;break;
						default: {
							HX_STACK_LINE(198)
							this->data = bytes;
						}
					}
				}
				HX_STACK_LINE(202)
				if (((code < (int)400))){
					HX_STACK_LINE(204)
					this->__dataComplete();
				}
				else{
					HX_STACK_LINE(208)
					::flash::events::IOErrorEvent event = ::flash::events::IOErrorEvent_obj::__new(::flash::events::IOErrorEvent_obj::IO_ERROR,true,false,this->data,code);		HX_STACK_VAR(event,"event");
					HX_STACK_LINE(209)
					this->__handle = null();
					HX_STACK_LINE(210)
					this->dispatchEvent(event);
				}
			}
			else{
				HX_STACK_LINE(214)
				if (((this->state == (int)4))){
					HX_STACK_LINE(216)
					this->dispatchHTTPStatus(code);
					HX_STACK_LINE(218)
					::String _g3 = ::flash::net::URLLoader_obj::lime_curl_get_error_message(this->__handle);		HX_STACK_VAR(_g3,"_g3");
					HX_STACK_LINE(218)
					::flash::events::IOErrorEvent event = ::flash::events::IOErrorEvent_obj::__new(::flash::events::IOErrorEvent_obj::IO_ERROR,true,false,_g3,code);		HX_STACK_VAR(event,"event");
					HX_STACK_LINE(219)
					this->__handle = null();
					HX_STACK_LINE(220)
					this->dispatchEvent(event);
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(URLLoader_obj,update,(void))

Void URLLoader_obj::__dataComplete( ){
{
		HX_STACK_FRAME("flash.net.URLLoader","__dataComplete",0x660ff7fe,"flash.net.URLLoader.__dataComplete","flash/net/URLLoader.hx",229,0xf174b5ed)
		HX_STACK_THIS(this)
		HX_STACK_LINE(231)
		::flash::net::URLLoader_obj::activeLoaders->remove(hx::ObjectPtr<OBJ_>(this));
		HX_STACK_LINE(233)
		if (((this->__onComplete_dyn() != null()))){
			HX_STACK_LINE(235)
			if ((this->__onComplete(this->data))){
				HX_STACK_LINE(237)
				::flash::events::Event _g = ::flash::events::Event_obj::__new(::flash::events::Event_obj::COMPLETE,null(),null());		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(237)
				this->dispatchEvent(_g);
			}
			else{
				HX_STACK_LINE(241)
				this->__dispatchIOErrorEvent();
			}
		}
		else{
			HX_STACK_LINE(247)
			::flash::events::Event _g1 = ::flash::events::Event_obj::__new(::flash::events::Event_obj::COMPLETE,null(),null());		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(247)
			this->dispatchEvent(_g1);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(URLLoader_obj,__dataComplete,(void))

::List URLLoader_obj::activeLoaders;

int URLLoader_obj::urlInvalid;

int URLLoader_obj::urlInit;

int URLLoader_obj::urlLoading;

int URLLoader_obj::urlComplete;

int URLLoader_obj::urlError;

bool URLLoader_obj::hasActive( ){
	HX_STACK_FRAME("flash.net.URLLoader","hasActive",0x4644dac5,"flash.net.URLLoader.hasActive","flash/net/URLLoader.hx",91,0xf174b5ed)
	HX_STACK_LINE(91)
	return !(::flash::net::URLLoader_obj::activeLoaders->isEmpty());
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(URLLoader_obj,hasActive,return )

Void URLLoader_obj::initialize( ::String caCertFilePath){
{
		HX_STACK_FRAME("flash.net.URLLoader","initialize",0x30ce8fab,"flash.net.URLLoader.initialize","flash/net/URLLoader.hx",98,0xf174b5ed)
		HX_STACK_ARG(caCertFilePath,"caCertFilePath")
		HX_STACK_LINE(98)
		::flash::net::URLLoader_obj::lime_curl_initialize(caCertFilePath);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(URLLoader_obj,initialize,(void))

bool URLLoader_obj::__loadPending( ){
	HX_STACK_FRAME("flash.net.URLLoader","__loadPending",0xed046436,"flash.net.URLLoader.__loadPending","flash/net/URLLoader.hx",256,0xf174b5ed)
	HX_STACK_LINE(256)
	return !(::flash::net::URLLoader_obj::activeLoaders->isEmpty());
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(URLLoader_obj,__loadPending,return )

Void URLLoader_obj::__pollData( ){
{
		HX_STACK_FRAME("flash.net.URLLoader","__pollData",0x803a5d84,"flash.net.URLLoader.__pollData","flash/net/URLLoader.hx",263,0xf174b5ed)
		HX_STACK_LINE(263)
		if ((!(::flash::net::URLLoader_obj::activeLoaders->isEmpty()))){
			HX_STACK_LINE(265)
			::flash::net::URLLoader_obj::lime_curl_process_loaders();
			HX_STACK_LINE(266)
			::List oldLoaders = ::flash::net::URLLoader_obj::activeLoaders;		HX_STACK_VAR(oldLoaders,"oldLoaders");
			HX_STACK_LINE(267)
			::List _g = ::List_obj::__new();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(267)
			::flash::net::URLLoader_obj::activeLoaders = _g;
			HX_STACK_LINE(269)
			for(::cpp::FastIterator_obj< ::flash::net::URLLoader > *__it = ::cpp::CreateFastIterator< ::flash::net::URLLoader >(oldLoaders->iterator());  __it->hasNext(); ){
				::flash::net::URLLoader loader = __it->next();
				{
					HX_STACK_LINE(271)
					loader->update();
					HX_STACK_LINE(272)
					if (((loader->state == (int)2))){
						HX_STACK_LINE(274)
						::flash::net::URLLoader_obj::activeLoaders->push(loader);
					}
				}
;
			}
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(URLLoader_obj,__pollData,(void))

Dynamic URLLoader_obj::lime_curl_create;

Dynamic URLLoader_obj::lime_curl_process_loaders;

Dynamic URLLoader_obj::lime_curl_update_loader;

Dynamic URLLoader_obj::lime_curl_get_code;

Dynamic URLLoader_obj::lime_curl_get_error_message;

Dynamic URLLoader_obj::lime_curl_get_data;

Dynamic URLLoader_obj::lime_curl_get_cookies;

Dynamic URLLoader_obj::lime_curl_get_headers;

Dynamic URLLoader_obj::lime_curl_initialize;


URLLoader_obj::URLLoader_obj()
{
}

void URLLoader_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(URLLoader);
	HX_MARK_MEMBER_NAME(bytesLoaded,"bytesLoaded");
	HX_MARK_MEMBER_NAME(bytesTotal,"bytesTotal");
	HX_MARK_MEMBER_NAME(data,"data");
	HX_MARK_MEMBER_NAME(dataFormat,"dataFormat");
	HX_MARK_MEMBER_NAME(state,"state");
	HX_MARK_MEMBER_NAME(__handle,"__handle");
	HX_MARK_MEMBER_NAME(__onComplete,"__onComplete");
	::flash::events::EventDispatcher_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void URLLoader_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(bytesLoaded,"bytesLoaded");
	HX_VISIT_MEMBER_NAME(bytesTotal,"bytesTotal");
	HX_VISIT_MEMBER_NAME(data,"data");
	HX_VISIT_MEMBER_NAME(dataFormat,"dataFormat");
	HX_VISIT_MEMBER_NAME(state,"state");
	HX_VISIT_MEMBER_NAME(__handle,"__handle");
	HX_VISIT_MEMBER_NAME(__onComplete,"__onComplete");
	::flash::events::EventDispatcher_obj::__Visit(HX_VISIT_ARG);
}

Dynamic URLLoader_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"data") ) { return data; }
		if (HX_FIELD_EQ(inName,"load") ) { return load_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"state") ) { return state; }
		if (HX_FIELD_EQ(inName,"close") ) { return close_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"update") ) { return update_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"onError") ) { return onError_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"__handle") ) { return __handle; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"hasActive") ) { return hasActive_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"initialize") ) { return initialize_dyn(); }
		if (HX_FIELD_EQ(inName,"__pollData") ) { return __pollData_dyn(); }
		if (HX_FIELD_EQ(inName,"bytesTotal") ) { return bytesTotal; }
		if (HX_FIELD_EQ(inName,"dataFormat") ) { return dataFormat; }
		if (HX_FIELD_EQ(inName,"getCookies") ) { return getCookies_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"bytesLoaded") ) { return bytesLoaded; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"__onComplete") ) { return __onComplete; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"activeLoaders") ) { return activeLoaders; }
		if (HX_FIELD_EQ(inName,"__loadPending") ) { return __loadPending_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"__dataComplete") ) { return __dataComplete_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"lime_curl_create") ) { return lime_curl_create; }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"lime_curl_get_code") ) { return lime_curl_get_code; }
		if (HX_FIELD_EQ(inName,"lime_curl_get_data") ) { return lime_curl_get_data; }
		if (HX_FIELD_EQ(inName,"dispatchHTTPStatus") ) { return dispatchHTTPStatus_dyn(); }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"lime_curl_initialize") ) { return lime_curl_initialize; }
		break;
	case 21:
		if (HX_FIELD_EQ(inName,"lime_curl_get_cookies") ) { return lime_curl_get_cookies; }
		if (HX_FIELD_EQ(inName,"lime_curl_get_headers") ) { return lime_curl_get_headers; }
		break;
	case 23:
		if (HX_FIELD_EQ(inName,"lime_curl_update_loader") ) { return lime_curl_update_loader; }
		break;
	case 25:
		if (HX_FIELD_EQ(inName,"lime_curl_process_loaders") ) { return lime_curl_process_loaders; }
		break;
	case 27:
		if (HX_FIELD_EQ(inName,"lime_curl_get_error_message") ) { return lime_curl_get_error_message; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic URLLoader_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"data") ) { data=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"state") ) { state=inValue.Cast< int >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"__handle") ) { __handle=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"bytesTotal") ) { bytesTotal=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"dataFormat") ) { dataFormat=inValue.Cast< ::flash::net::URLLoaderDataFormat >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"bytesLoaded") ) { bytesLoaded=inValue.Cast< int >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"__onComplete") ) { __onComplete=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"activeLoaders") ) { activeLoaders=inValue.Cast< ::List >(); return inValue; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"lime_curl_create") ) { lime_curl_create=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"lime_curl_get_code") ) { lime_curl_get_code=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_curl_get_data") ) { lime_curl_get_data=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"lime_curl_initialize") ) { lime_curl_initialize=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 21:
		if (HX_FIELD_EQ(inName,"lime_curl_get_cookies") ) { lime_curl_get_cookies=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_curl_get_headers") ) { lime_curl_get_headers=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 23:
		if (HX_FIELD_EQ(inName,"lime_curl_update_loader") ) { lime_curl_update_loader=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 25:
		if (HX_FIELD_EQ(inName,"lime_curl_process_loaders") ) { lime_curl_process_loaders=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 27:
		if (HX_FIELD_EQ(inName,"lime_curl_get_error_message") ) { lime_curl_get_error_message=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void URLLoader_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("bytesLoaded"));
	outFields->push(HX_CSTRING("bytesTotal"));
	outFields->push(HX_CSTRING("data"));
	outFields->push(HX_CSTRING("dataFormat"));
	outFields->push(HX_CSTRING("state"));
	outFields->push(HX_CSTRING("__handle"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("activeLoaders"),
	HX_CSTRING("urlInvalid"),
	HX_CSTRING("urlInit"),
	HX_CSTRING("urlLoading"),
	HX_CSTRING("urlComplete"),
	HX_CSTRING("urlError"),
	HX_CSTRING("hasActive"),
	HX_CSTRING("initialize"),
	HX_CSTRING("__loadPending"),
	HX_CSTRING("__pollData"),
	HX_CSTRING("lime_curl_create"),
	HX_CSTRING("lime_curl_process_loaders"),
	HX_CSTRING("lime_curl_update_loader"),
	HX_CSTRING("lime_curl_get_code"),
	HX_CSTRING("lime_curl_get_error_message"),
	HX_CSTRING("lime_curl_get_data"),
	HX_CSTRING("lime_curl_get_cookies"),
	HX_CSTRING("lime_curl_get_headers"),
	HX_CSTRING("lime_curl_initialize"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(URLLoader_obj,bytesLoaded),HX_CSTRING("bytesLoaded")},
	{hx::fsInt,(int)offsetof(URLLoader_obj,bytesTotal),HX_CSTRING("bytesTotal")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(URLLoader_obj,data),HX_CSTRING("data")},
	{hx::fsObject /*::flash::net::URLLoaderDataFormat*/ ,(int)offsetof(URLLoader_obj,dataFormat),HX_CSTRING("dataFormat")},
	{hx::fsInt,(int)offsetof(URLLoader_obj,state),HX_CSTRING("state")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(URLLoader_obj,__handle),HX_CSTRING("__handle")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(URLLoader_obj,__onComplete),HX_CSTRING("__onComplete")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("bytesLoaded"),
	HX_CSTRING("bytesTotal"),
	HX_CSTRING("data"),
	HX_CSTRING("dataFormat"),
	HX_CSTRING("state"),
	HX_CSTRING("__handle"),
	HX_CSTRING("__onComplete"),
	HX_CSTRING("close"),
	HX_CSTRING("dispatchHTTPStatus"),
	HX_CSTRING("getCookies"),
	HX_CSTRING("load"),
	HX_CSTRING("onError"),
	HX_CSTRING("update"),
	HX_CSTRING("__dataComplete"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(URLLoader_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(URLLoader_obj::activeLoaders,"activeLoaders");
	HX_MARK_MEMBER_NAME(URLLoader_obj::urlInvalid,"urlInvalid");
	HX_MARK_MEMBER_NAME(URLLoader_obj::urlInit,"urlInit");
	HX_MARK_MEMBER_NAME(URLLoader_obj::urlLoading,"urlLoading");
	HX_MARK_MEMBER_NAME(URLLoader_obj::urlComplete,"urlComplete");
	HX_MARK_MEMBER_NAME(URLLoader_obj::urlError,"urlError");
	HX_MARK_MEMBER_NAME(URLLoader_obj::lime_curl_create,"lime_curl_create");
	HX_MARK_MEMBER_NAME(URLLoader_obj::lime_curl_process_loaders,"lime_curl_process_loaders");
	HX_MARK_MEMBER_NAME(URLLoader_obj::lime_curl_update_loader,"lime_curl_update_loader");
	HX_MARK_MEMBER_NAME(URLLoader_obj::lime_curl_get_code,"lime_curl_get_code");
	HX_MARK_MEMBER_NAME(URLLoader_obj::lime_curl_get_error_message,"lime_curl_get_error_message");
	HX_MARK_MEMBER_NAME(URLLoader_obj::lime_curl_get_data,"lime_curl_get_data");
	HX_MARK_MEMBER_NAME(URLLoader_obj::lime_curl_get_cookies,"lime_curl_get_cookies");
	HX_MARK_MEMBER_NAME(URLLoader_obj::lime_curl_get_headers,"lime_curl_get_headers");
	HX_MARK_MEMBER_NAME(URLLoader_obj::lime_curl_initialize,"lime_curl_initialize");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(URLLoader_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(URLLoader_obj::activeLoaders,"activeLoaders");
	HX_VISIT_MEMBER_NAME(URLLoader_obj::urlInvalid,"urlInvalid");
	HX_VISIT_MEMBER_NAME(URLLoader_obj::urlInit,"urlInit");
	HX_VISIT_MEMBER_NAME(URLLoader_obj::urlLoading,"urlLoading");
	HX_VISIT_MEMBER_NAME(URLLoader_obj::urlComplete,"urlComplete");
	HX_VISIT_MEMBER_NAME(URLLoader_obj::urlError,"urlError");
	HX_VISIT_MEMBER_NAME(URLLoader_obj::lime_curl_create,"lime_curl_create");
	HX_VISIT_MEMBER_NAME(URLLoader_obj::lime_curl_process_loaders,"lime_curl_process_loaders");
	HX_VISIT_MEMBER_NAME(URLLoader_obj::lime_curl_update_loader,"lime_curl_update_loader");
	HX_VISIT_MEMBER_NAME(URLLoader_obj::lime_curl_get_code,"lime_curl_get_code");
	HX_VISIT_MEMBER_NAME(URLLoader_obj::lime_curl_get_error_message,"lime_curl_get_error_message");
	HX_VISIT_MEMBER_NAME(URLLoader_obj::lime_curl_get_data,"lime_curl_get_data");
	HX_VISIT_MEMBER_NAME(URLLoader_obj::lime_curl_get_cookies,"lime_curl_get_cookies");
	HX_VISIT_MEMBER_NAME(URLLoader_obj::lime_curl_get_headers,"lime_curl_get_headers");
	HX_VISIT_MEMBER_NAME(URLLoader_obj::lime_curl_initialize,"lime_curl_initialize");
};

#endif

Class URLLoader_obj::__mClass;

void URLLoader_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.net.URLLoader"), hx::TCanCast< URLLoader_obj> ,sStaticFields,sMemberFields,
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

void URLLoader_obj::__boot()
{
	activeLoaders= ::List_obj::__new();
	urlInvalid= (int)0;
	urlInit= (int)1;
	urlLoading= (int)2;
	urlComplete= (int)3;
	urlError= (int)4;
	lime_curl_create= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_curl_create"),(int)1);
	lime_curl_process_loaders= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_curl_process_loaders"),(int)0);
	lime_curl_update_loader= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_curl_update_loader"),(int)2);
	lime_curl_get_code= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_curl_get_code"),(int)1);
	lime_curl_get_error_message= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_curl_get_error_message"),(int)1);
	lime_curl_get_data= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_curl_get_data"),(int)1);
	lime_curl_get_cookies= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_curl_get_cookies"),(int)1);
	lime_curl_get_headers= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_curl_get_headers"),(int)1);
	lime_curl_initialize= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_curl_initialize"),(int)1);
}

} // end namespace flash
} // end namespace net
