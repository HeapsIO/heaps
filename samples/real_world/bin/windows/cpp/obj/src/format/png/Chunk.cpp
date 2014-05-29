#include <hxcpp.h>

#ifndef INCLUDED_format_png_Chunk
#include <format/png/Chunk.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
namespace format{
namespace png{

::format::png::Chunk  Chunk_obj::CData(::haxe::io::Bytes b)
	{ return hx::CreateEnum< Chunk_obj >(HX_CSTRING("CData"),2,hx::DynamicArray(0,1).Add(b)); }

::format::png::Chunk Chunk_obj::CEnd;

::format::png::Chunk  Chunk_obj::CHeader(Dynamic h)
	{ return hx::CreateEnum< Chunk_obj >(HX_CSTRING("CHeader"),1,hx::DynamicArray(0,1).Add(h)); }

::format::png::Chunk  Chunk_obj::CPalette(::haxe::io::Bytes b)
	{ return hx::CreateEnum< Chunk_obj >(HX_CSTRING("CPalette"),3,hx::DynamicArray(0,1).Add(b)); }

::format::png::Chunk  Chunk_obj::CUnknown(::String id,::haxe::io::Bytes data)
	{ return hx::CreateEnum< Chunk_obj >(HX_CSTRING("CUnknown"),4,hx::DynamicArray(0,2).Add(id).Add(data)); }

HX_DEFINE_CREATE_ENUM(Chunk_obj)

int Chunk_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("CData")) return 2;
	if (inName==HX_CSTRING("CEnd")) return 0;
	if (inName==HX_CSTRING("CHeader")) return 1;
	if (inName==HX_CSTRING("CPalette")) return 3;
	if (inName==HX_CSTRING("CUnknown")) return 4;
	return super::__FindIndex(inName);
}

STATIC_HX_DEFINE_DYNAMIC_FUNC1(Chunk_obj,CData,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(Chunk_obj,CHeader,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(Chunk_obj,CPalette,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC2(Chunk_obj,CUnknown,return)

int Chunk_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("CData")) return 1;
	if (inName==HX_CSTRING("CEnd")) return 0;
	if (inName==HX_CSTRING("CHeader")) return 1;
	if (inName==HX_CSTRING("CPalette")) return 1;
	if (inName==HX_CSTRING("CUnknown")) return 2;
	return super::__FindArgCount(inName);
}

Dynamic Chunk_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("CData")) return CData_dyn();
	if (inName==HX_CSTRING("CEnd")) return CEnd;
	if (inName==HX_CSTRING("CHeader")) return CHeader_dyn();
	if (inName==HX_CSTRING("CPalette")) return CPalette_dyn();
	if (inName==HX_CSTRING("CUnknown")) return CUnknown_dyn();
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("CEnd"),
	HX_CSTRING("CHeader"),
	HX_CSTRING("CData"),
	HX_CSTRING("CPalette"),
	HX_CSTRING("CUnknown"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Chunk_obj::CEnd,"CEnd");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Chunk_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Chunk_obj::CEnd,"CEnd");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class Chunk_obj::__mClass;

Dynamic __Create_Chunk_obj() { return new Chunk_obj; }

void Chunk_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.png.Chunk"), hx::TCanCast< Chunk_obj >,sStaticFields,sMemberFields,
	&__Create_Chunk_obj, &__Create,
	&super::__SGetClass(), &CreateChunk_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void Chunk_obj::__boot()
{
hx::Static(CEnd) = hx::CreateEnum< Chunk_obj >(HX_CSTRING("CEnd"),0);
}


} // end namespace format
} // end namespace png
