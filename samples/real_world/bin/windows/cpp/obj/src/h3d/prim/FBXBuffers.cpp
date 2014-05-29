#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_h3d_col_Point
#include <h3d/col/Point.h>
#endif
#ifndef INCLUDED_h3d_prim_FBXBuffers
#include <h3d/prim/FBXBuffers.h>
#endif
#ifndef INCLUDED_haxe_ds_IntMap
#include <haxe/ds/IntMap.h>
#endif
#ifndef INCLUDED_haxe_io_BytesOutput
#include <haxe/io/BytesOutput.h>
#endif
#ifndef INCLUDED_haxe_io_Output
#include <haxe/io/Output.h>
#endif
namespace h3d{
namespace prim{

Void FBXBuffers_obj::__construct()
{
HX_STACK_FRAME("h3d.prim.FBXBuffers","new",0x432a7afc,"h3d.prim.FBXBuffers.new","h3d/prim/FBXModel.hx",29,0xe945c8de)
HX_STACK_THIS(this)
{
}
;
	return null();
}

//FBXBuffers_obj::~FBXBuffers_obj() { }

Dynamic FBXBuffers_obj::__CreateEmpty() { return  new FBXBuffers_obj; }
hx::ObjectPtr< FBXBuffers_obj > FBXBuffers_obj::__new()
{  hx::ObjectPtr< FBXBuffers_obj > result = new FBXBuffers_obj();
	result->__construct();
	return result;}

Dynamic FBXBuffers_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< FBXBuffers_obj > result = new FBXBuffers_obj();
	result->__construct();
	return result;}


FBXBuffers_obj::FBXBuffers_obj()
{
}

void FBXBuffers_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(FBXBuffers);
	HX_MARK_MEMBER_NAME(index,"index");
	HX_MARK_MEMBER_NAME(gt,"gt");
	HX_MARK_MEMBER_NAME(idx,"idx");
	HX_MARK_MEMBER_NAME(midx,"midx");
	HX_MARK_MEMBER_NAME(pbuf,"pbuf");
	HX_MARK_MEMBER_NAME(nbuf,"nbuf");
	HX_MARK_MEMBER_NAME(sbuf,"sbuf");
	HX_MARK_MEMBER_NAME(tbuf,"tbuf");
	HX_MARK_MEMBER_NAME(cbuf,"cbuf");
	HX_MARK_MEMBER_NAME(oldToNew,"oldToNew");
	HX_MARK_MEMBER_NAME(originalVerts,"originalVerts");
	HX_MARK_END_CLASS();
}

void FBXBuffers_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(index,"index");
	HX_VISIT_MEMBER_NAME(gt,"gt");
	HX_VISIT_MEMBER_NAME(idx,"idx");
	HX_VISIT_MEMBER_NAME(midx,"midx");
	HX_VISIT_MEMBER_NAME(pbuf,"pbuf");
	HX_VISIT_MEMBER_NAME(nbuf,"nbuf");
	HX_VISIT_MEMBER_NAME(sbuf,"sbuf");
	HX_VISIT_MEMBER_NAME(tbuf,"tbuf");
	HX_VISIT_MEMBER_NAME(cbuf,"cbuf");
	HX_VISIT_MEMBER_NAME(oldToNew,"oldToNew");
	HX_VISIT_MEMBER_NAME(originalVerts,"originalVerts");
}

Dynamic FBXBuffers_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"gt") ) { return gt; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"idx") ) { return idx; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"midx") ) { return midx; }
		if (HX_FIELD_EQ(inName,"pbuf") ) { return pbuf; }
		if (HX_FIELD_EQ(inName,"nbuf") ) { return nbuf; }
		if (HX_FIELD_EQ(inName,"sbuf") ) { return sbuf; }
		if (HX_FIELD_EQ(inName,"tbuf") ) { return tbuf; }
		if (HX_FIELD_EQ(inName,"cbuf") ) { return cbuf; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"index") ) { return index; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"oldToNew") ) { return oldToNew; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"originalVerts") ) { return originalVerts; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic FBXBuffers_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"gt") ) { gt=inValue.Cast< ::h3d::col::Point >(); return inValue; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"idx") ) { idx=inValue.Cast< Array< int > >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"midx") ) { midx=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"pbuf") ) { pbuf=inValue.Cast< Array< Float > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nbuf") ) { nbuf=inValue.Cast< Array< Float > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"sbuf") ) { sbuf=inValue.Cast< ::haxe::io::BytesOutput >(); return inValue; }
		if (HX_FIELD_EQ(inName,"tbuf") ) { tbuf=inValue.Cast< Array< Float > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"cbuf") ) { cbuf=inValue.Cast< Array< Float > >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"index") ) { index=inValue.Cast< Array< int > >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"oldToNew") ) { oldToNew=inValue.Cast< ::haxe::ds::IntMap >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"originalVerts") ) { originalVerts=inValue.Cast< Array< Float > >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void FBXBuffers_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("index"));
	outFields->push(HX_CSTRING("gt"));
	outFields->push(HX_CSTRING("idx"));
	outFields->push(HX_CSTRING("midx"));
	outFields->push(HX_CSTRING("pbuf"));
	outFields->push(HX_CSTRING("nbuf"));
	outFields->push(HX_CSTRING("sbuf"));
	outFields->push(HX_CSTRING("tbuf"));
	outFields->push(HX_CSTRING("cbuf"));
	outFields->push(HX_CSTRING("oldToNew"));
	outFields->push(HX_CSTRING("originalVerts"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Array< int >*/ ,(int)offsetof(FBXBuffers_obj,index),HX_CSTRING("index")},
	{hx::fsObject /*::h3d::col::Point*/ ,(int)offsetof(FBXBuffers_obj,gt),HX_CSTRING("gt")},
	{hx::fsObject /*Array< int >*/ ,(int)offsetof(FBXBuffers_obj,idx),HX_CSTRING("idx")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(FBXBuffers_obj,midx),HX_CSTRING("midx")},
	{hx::fsObject /*Array< Float >*/ ,(int)offsetof(FBXBuffers_obj,pbuf),HX_CSTRING("pbuf")},
	{hx::fsObject /*Array< Float >*/ ,(int)offsetof(FBXBuffers_obj,nbuf),HX_CSTRING("nbuf")},
	{hx::fsObject /*::haxe::io::BytesOutput*/ ,(int)offsetof(FBXBuffers_obj,sbuf),HX_CSTRING("sbuf")},
	{hx::fsObject /*Array< Float >*/ ,(int)offsetof(FBXBuffers_obj,tbuf),HX_CSTRING("tbuf")},
	{hx::fsObject /*Array< Float >*/ ,(int)offsetof(FBXBuffers_obj,cbuf),HX_CSTRING("cbuf")},
	{hx::fsObject /*::haxe::ds::IntMap*/ ,(int)offsetof(FBXBuffers_obj,oldToNew),HX_CSTRING("oldToNew")},
	{hx::fsObject /*Array< Float >*/ ,(int)offsetof(FBXBuffers_obj,originalVerts),HX_CSTRING("originalVerts")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("index"),
	HX_CSTRING("gt"),
	HX_CSTRING("idx"),
	HX_CSTRING("midx"),
	HX_CSTRING("pbuf"),
	HX_CSTRING("nbuf"),
	HX_CSTRING("sbuf"),
	HX_CSTRING("tbuf"),
	HX_CSTRING("cbuf"),
	HX_CSTRING("oldToNew"),
	HX_CSTRING("originalVerts"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FBXBuffers_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FBXBuffers_obj::__mClass,"__mClass");
};

#endif

Class FBXBuffers_obj::__mClass;

void FBXBuffers_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.prim.FBXBuffers"), hx::TCanCast< FBXBuffers_obj> ,sStaticFields,sMemberFields,
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

void FBXBuffers_obj::__boot()
{
}

} // end namespace h3d
} // end namespace prim
