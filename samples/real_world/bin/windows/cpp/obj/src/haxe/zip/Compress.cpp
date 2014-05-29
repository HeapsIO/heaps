#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_cpp_Lib
#include <cpp/Lib.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_haxe_zip_Compress
#include <haxe/zip/Compress.h>
#endif
#ifndef INCLUDED_haxe_zip_FlushMode
#include <haxe/zip/FlushMode.h>
#endif
namespace haxe{
namespace zip{

Void Compress_obj::__construct(int level)
{
HX_STACK_FRAME("haxe.zip.Compress","new",0x4ddc50a9,"haxe.zip.Compress.new","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/zip/Compress.hx",29,0xdaeba825)
HX_STACK_THIS(this)
HX_STACK_ARG(level,"level")
{
	HX_STACK_LINE(30)
	Dynamic _g = ::haxe::zip::Compress_obj::_deflate_init(level);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(30)
	this->s = _g;
}
;
	return null();
}

//Compress_obj::~Compress_obj() { }

Dynamic Compress_obj::__CreateEmpty() { return  new Compress_obj; }
hx::ObjectPtr< Compress_obj > Compress_obj::__new(int level)
{  hx::ObjectPtr< Compress_obj > result = new Compress_obj();
	result->__construct(level);
	return result;}

Dynamic Compress_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Compress_obj > result = new Compress_obj();
	result->__construct(inArgs[0]);
	return result;}

Dynamic Compress_obj::execute( ::haxe::io::Bytes src,int srcPos,::haxe::io::Bytes dst,int dstPos){
	HX_STACK_FRAME("haxe.zip.Compress","execute",0xd015e2fe,"haxe.zip.Compress.execute","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/zip/Compress.hx",34,0xdaeba825)
	HX_STACK_THIS(this)
	HX_STACK_ARG(src,"src")
	HX_STACK_ARG(srcPos,"srcPos")
	HX_STACK_ARG(dst,"dst")
	HX_STACK_ARG(dstPos,"dstPos")
	HX_STACK_LINE(34)
	return ::haxe::zip::Compress_obj::_deflate_buffer(this->s,src->b,srcPos,dst->b,dstPos);
}


HX_DEFINE_DYNAMIC_FUNC4(Compress_obj,execute,return )

Void Compress_obj::setFlushMode( ::haxe::zip::FlushMode f){
{
		HX_STACK_FRAME("haxe.zip.Compress","setFlushMode",0x35ab82dc,"haxe.zip.Compress.setFlushMode","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/zip/Compress.hx",37,0xdaeba825)
		HX_STACK_THIS(this)
		HX_STACK_ARG(f,"f")
		HX_STACK_LINE(38)
		::String _g = ::Std_obj::string(f);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(38)
		::haxe::zip::Compress_obj::_set_flush_mode(this->s,_g);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Compress_obj,setFlushMode,(void))

Void Compress_obj::close( ){
{
		HX_STACK_FRAME("haxe.zip.Compress","close",0x6942fc41,"haxe.zip.Compress.close","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/zip/Compress.hx",42,0xdaeba825)
		HX_STACK_THIS(this)
		HX_STACK_LINE(42)
		::haxe::zip::Compress_obj::_deflate_end(this->s);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Compress_obj,close,(void))

::haxe::io::Bytes Compress_obj::run( ::haxe::io::Bytes s,int level){
	HX_STACK_FRAME("haxe.zip.Compress","run",0x4ddf6794,"haxe.zip.Compress.run","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/zip/Compress.hx",45,0xdaeba825)
	HX_STACK_ARG(s,"s")
	HX_STACK_ARG(level,"level")
	HX_STACK_LINE(46)
	::haxe::zip::Compress c = ::haxe::zip::Compress_obj::__new(level);		HX_STACK_VAR(c,"c");
	HX_STACK_LINE(47)
	c->setFlushMode(::haxe::zip::FlushMode_obj::FINISH);
	HX_STACK_LINE(48)
	int _g = ::haxe::zip::Compress_obj::_deflate_bound(c->s,s->length);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(48)
	::haxe::io::Bytes out = ::haxe::io::Bytes_obj::alloc(_g);		HX_STACK_VAR(out,"out");
	HX_STACK_LINE(49)
	Dynamic r = c->execute(s,(int)0,out,(int)0);		HX_STACK_VAR(r,"r");
	HX_STACK_LINE(50)
	c->close();
	HX_STACK_LINE(51)
	if (((bool(!(r->__Field(HX_CSTRING("done"),true))) || bool((r->__Field(HX_CSTRING("read"),true) != s->length))))){
		HX_STACK_LINE(52)
		HX_STACK_DO_THROW(HX_CSTRING("Compression failed"));
	}
	HX_STACK_LINE(53)
	return out->sub((int)0,r->__Field(HX_CSTRING("write"),true));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Compress_obj,run,return )

Dynamic Compress_obj::_deflate_init;

Dynamic Compress_obj::_deflate_bound;

Dynamic Compress_obj::_deflate_buffer;

Dynamic Compress_obj::_deflate_end;

Dynamic Compress_obj::_set_flush_mode;


Compress_obj::Compress_obj()
{
}

void Compress_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Compress);
	HX_MARK_MEMBER_NAME(s,"s");
	HX_MARK_END_CLASS();
}

void Compress_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(s,"s");
}

Dynamic Compress_obj::__Field(const ::String &inName,bool inCallProp)
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
		if (HX_FIELD_EQ(inName,"_deflate_end") ) { return _deflate_end; }
		if (HX_FIELD_EQ(inName,"setFlushMode") ) { return setFlushMode_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"_deflate_init") ) { return _deflate_init; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"_deflate_bound") ) { return _deflate_bound; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"_deflate_buffer") ) { return _deflate_buffer; }
		if (HX_FIELD_EQ(inName,"_set_flush_mode") ) { return _set_flush_mode; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Compress_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"s") ) { s=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"_deflate_end") ) { _deflate_end=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"_deflate_init") ) { _deflate_init=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"_deflate_bound") ) { _deflate_bound=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"_deflate_buffer") ) { _deflate_buffer=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_set_flush_mode") ) { _set_flush_mode=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Compress_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("s"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("run"),
	HX_CSTRING("_deflate_init"),
	HX_CSTRING("_deflate_bound"),
	HX_CSTRING("_deflate_buffer"),
	HX_CSTRING("_deflate_end"),
	HX_CSTRING("_set_flush_mode"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Compress_obj,s),HX_CSTRING("s")},
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
	HX_MARK_MEMBER_NAME(Compress_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Compress_obj::_deflate_init,"_deflate_init");
	HX_MARK_MEMBER_NAME(Compress_obj::_deflate_bound,"_deflate_bound");
	HX_MARK_MEMBER_NAME(Compress_obj::_deflate_buffer,"_deflate_buffer");
	HX_MARK_MEMBER_NAME(Compress_obj::_deflate_end,"_deflate_end");
	HX_MARK_MEMBER_NAME(Compress_obj::_set_flush_mode,"_set_flush_mode");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Compress_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Compress_obj::_deflate_init,"_deflate_init");
	HX_VISIT_MEMBER_NAME(Compress_obj::_deflate_bound,"_deflate_bound");
	HX_VISIT_MEMBER_NAME(Compress_obj::_deflate_buffer,"_deflate_buffer");
	HX_VISIT_MEMBER_NAME(Compress_obj::_deflate_end,"_deflate_end");
	HX_VISIT_MEMBER_NAME(Compress_obj::_set_flush_mode,"_set_flush_mode");
};

#endif

Class Compress_obj::__mClass;

void Compress_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.zip.Compress"), hx::TCanCast< Compress_obj> ,sStaticFields,sMemberFields,
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

void Compress_obj::__boot()
{
	_deflate_init= ::cpp::Lib_obj::load(HX_CSTRING("zlib"),HX_CSTRING("deflate_init"),(int)1);
	_deflate_bound= ::cpp::Lib_obj::load(HX_CSTRING("zlib"),HX_CSTRING("deflate_bound"),(int)2);
	_deflate_buffer= ::cpp::Lib_obj::load(HX_CSTRING("zlib"),HX_CSTRING("deflate_buffer"),(int)5);
	_deflate_end= ::cpp::Lib_obj::load(HX_CSTRING("zlib"),HX_CSTRING("deflate_end"),(int)1);
	_set_flush_mode= ::cpp::Lib_obj::load(HX_CSTRING("zlib"),HX_CSTRING("set_flush_mode"),(int)2);
}

} // end namespace haxe
} // end namespace zip
