#include <hxcpp.h>

#ifndef INCLUDED_cpp_Lib
#include <cpp/Lib.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_haxe_io_BytesBuffer
#include <haxe/io/BytesBuffer.h>
#endif
#ifndef INCLUDED_haxe_io_Error
#include <haxe/io/Error.h>
#endif
#ifndef INCLUDED_haxe_zip_FlushMode
#include <haxe/zip/FlushMode.h>
#endif
#ifndef INCLUDED_haxe_zip_Uncompress
#include <haxe/zip/Uncompress.h>
#endif
namespace haxe{
namespace zip{

Void Uncompress_obj::__construct(Dynamic windowBits)
{
HX_STACK_FRAME("haxe.zip.Uncompress","new",0x34f307c2,"haxe.zip.Uncompress.new","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/zip/Uncompress.hx",28,0x5da362ac)
HX_STACK_THIS(this)
HX_STACK_ARG(windowBits,"windowBits")
{
	HX_STACK_LINE(29)
	Dynamic _g = ::haxe::zip::Uncompress_obj::_inflate_init(windowBits);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(29)
	this->s = _g;
}
;
	return null();
}

//Uncompress_obj::~Uncompress_obj() { }

Dynamic Uncompress_obj::__CreateEmpty() { return  new Uncompress_obj; }
hx::ObjectPtr< Uncompress_obj > Uncompress_obj::__new(Dynamic windowBits)
{  hx::ObjectPtr< Uncompress_obj > result = new Uncompress_obj();
	result->__construct(windowBits);
	return result;}

Dynamic Uncompress_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Uncompress_obj > result = new Uncompress_obj();
	result->__construct(inArgs[0]);
	return result;}

Dynamic Uncompress_obj::execute( ::haxe::io::Bytes src,int srcPos,::haxe::io::Bytes dst,int dstPos){
	HX_STACK_FRAME("haxe.zip.Uncompress","execute",0xb3589a97,"haxe.zip.Uncompress.execute","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/zip/Uncompress.hx",33,0x5da362ac)
	HX_STACK_THIS(this)
	HX_STACK_ARG(src,"src")
	HX_STACK_ARG(srcPos,"srcPos")
	HX_STACK_ARG(dst,"dst")
	HX_STACK_ARG(dstPos,"dstPos")
	HX_STACK_LINE(33)
	return ::haxe::zip::Uncompress_obj::_inflate_buffer(this->s,src->b,srcPos,dst->b,dstPos);
}


HX_DEFINE_DYNAMIC_FUNC4(Uncompress_obj,execute,return )

Void Uncompress_obj::setFlushMode( ::haxe::zip::FlushMode f){
{
		HX_STACK_FRAME("haxe.zip.Uncompress","setFlushMode",0xbecba0a3,"haxe.zip.Uncompress.setFlushMode","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/zip/Uncompress.hx",36,0x5da362ac)
		HX_STACK_THIS(this)
		HX_STACK_ARG(f,"f")
		HX_STACK_LINE(37)
		Dynamic _g = f->__Tag();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(37)
		::haxe::zip::Uncompress_obj::_set_flush_mode(this->s,_g);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Uncompress_obj,setFlushMode,(void))

Void Uncompress_obj::close( ){
{
		HX_STACK_FRAME("haxe.zip.Uncompress","close",0x4cc86b9a,"haxe.zip.Uncompress.close","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/zip/Uncompress.hx",41,0x5da362ac)
		HX_STACK_THIS(this)
		HX_STACK_LINE(41)
		::haxe::zip::Uncompress_obj::_inflate_end(this->s);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Uncompress_obj,close,(void))

::haxe::io::Bytes Uncompress_obj::run( ::haxe::io::Bytes src,Dynamic bufsize){
	HX_STACK_FRAME("haxe.zip.Uncompress","run",0x34f61ead,"haxe.zip.Uncompress.run","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/zip/Uncompress.hx",44,0x5da362ac)
	HX_STACK_ARG(src,"src")
	HX_STACK_ARG(bufsize,"bufsize")
	HX_STACK_LINE(45)
	::haxe::zip::Uncompress u = ::haxe::zip::Uncompress_obj::__new(null());		HX_STACK_VAR(u,"u");
	HX_STACK_LINE(46)
	if (((bufsize == null()))){
		HX_STACK_LINE(46)
		bufsize = (int)65536;
	}
	HX_STACK_LINE(47)
	::haxe::io::Bytes tmp = ::haxe::io::Bytes_obj::alloc(bufsize);		HX_STACK_VAR(tmp,"tmp");
	HX_STACK_LINE(48)
	::haxe::io::BytesBuffer b = ::haxe::io::BytesBuffer_obj::__new();		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(49)
	int pos = (int)0;		HX_STACK_VAR(pos,"pos");
	HX_STACK_LINE(50)
	u->setFlushMode(::haxe::zip::FlushMode_obj::SYNC);
	HX_STACK_LINE(51)
	while((true)){
		HX_STACK_LINE(52)
		Dynamic r = u->execute(src,pos,tmp,(int)0);		HX_STACK_VAR(r,"r");
		HX_STACK_LINE(53)
		{
			HX_STACK_LINE(53)
			int len = r->__Field(HX_CSTRING("write"),true);		HX_STACK_VAR(len,"len");
			HX_STACK_LINE(53)
			if (((bool((len < (int)0)) || bool((len > tmp->length))))){
				HX_STACK_LINE(53)
				HX_STACK_DO_THROW(::haxe::io::Error_obj::OutsideBounds);
			}
			HX_STACK_LINE(53)
			Array< unsigned char > b1 = b->b;		HX_STACK_VAR(b1,"b1");
			HX_STACK_LINE(53)
			Array< unsigned char > b2 = tmp->b;		HX_STACK_VAR(b2,"b2");
			HX_STACK_LINE(53)
			{
				HX_STACK_LINE(53)
				int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(53)
				int _g = len;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(53)
				while((true)){
					HX_STACK_LINE(53)
					if ((!(((_g1 < _g))))){
						HX_STACK_LINE(53)
						break;
					}
					HX_STACK_LINE(53)
					int i = (_g1)++;		HX_STACK_VAR(i,"i");
					HX_STACK_LINE(53)
					b->b->push(b2->__get(i));
				}
			}
		}
		HX_STACK_LINE(54)
		hx::AddEq(pos,r->__Field(HX_CSTRING("read"),true));
		HX_STACK_LINE(55)
		if ((r->__Field(HX_CSTRING("done"),true))){
			HX_STACK_LINE(56)
			break;
		}
	}
	HX_STACK_LINE(58)
	u->close();
	HX_STACK_LINE(59)
	return b->getBytes();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Uncompress_obj,run,return )

Dynamic Uncompress_obj::_inflate_init;

Dynamic Uncompress_obj::_inflate_buffer;

Dynamic Uncompress_obj::_inflate_end;

Dynamic Uncompress_obj::_set_flush_mode;


Uncompress_obj::Uncompress_obj()
{
}

void Uncompress_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Uncompress);
	HX_MARK_MEMBER_NAME(s,"s");
	HX_MARK_END_CLASS();
}

void Uncompress_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(s,"s");
}

Dynamic Uncompress_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"s") ) { return s; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"run") ) { return run_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"close") ) { return close_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"execute") ) { return execute_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"_inflate_end") ) { return _inflate_end; }
		if (HX_FIELD_EQ(inName,"setFlushMode") ) { return setFlushMode_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"_inflate_init") ) { return _inflate_init; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"_inflate_buffer") ) { return _inflate_buffer; }
		if (HX_FIELD_EQ(inName,"_set_flush_mode") ) { return _set_flush_mode; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Uncompress_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"s") ) { s=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"_inflate_end") ) { _inflate_end=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"_inflate_init") ) { _inflate_init=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"_inflate_buffer") ) { _inflate_buffer=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_set_flush_mode") ) { _set_flush_mode=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Uncompress_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("s"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("run"),
	HX_CSTRING("_inflate_init"),
	HX_CSTRING("_inflate_buffer"),
	HX_CSTRING("_inflate_end"),
	HX_CSTRING("_set_flush_mode"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Uncompress_obj,s),HX_CSTRING("s")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("s"),
	HX_CSTRING("execute"),
	HX_CSTRING("setFlushMode"),
	HX_CSTRING("close"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Uncompress_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Uncompress_obj::_inflate_init,"_inflate_init");
	HX_MARK_MEMBER_NAME(Uncompress_obj::_inflate_buffer,"_inflate_buffer");
	HX_MARK_MEMBER_NAME(Uncompress_obj::_inflate_end,"_inflate_end");
	HX_MARK_MEMBER_NAME(Uncompress_obj::_set_flush_mode,"_set_flush_mode");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Uncompress_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Uncompress_obj::_inflate_init,"_inflate_init");
	HX_VISIT_MEMBER_NAME(Uncompress_obj::_inflate_buffer,"_inflate_buffer");
	HX_VISIT_MEMBER_NAME(Uncompress_obj::_inflate_end,"_inflate_end");
	HX_VISIT_MEMBER_NAME(Uncompress_obj::_set_flush_mode,"_set_flush_mode");
};

#endif

Class Uncompress_obj::__mClass;

void Uncompress_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.zip.Uncompress"), hx::TCanCast< Uncompress_obj> ,sStaticFields,sMemberFields,
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

void Uncompress_obj::__boot()
{
	_inflate_init= ::cpp::Lib_obj::load(HX_CSTRING("zlib"),HX_CSTRING("inflate_init"),(int)1);
	_inflate_buffer= ::cpp::Lib_obj::load(HX_CSTRING("zlib"),HX_CSTRING("inflate_buffer"),(int)5);
	_inflate_end= ::cpp::Lib_obj::load(HX_CSTRING("zlib"),HX_CSTRING("inflate_end"),(int)1);
	_set_flush_mode= ::cpp::Lib_obj::load(HX_CSTRING("zlib"),HX_CSTRING("set_flush_mode"),(int)2);
}

} // end namespace haxe
} // end namespace zip
