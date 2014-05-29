#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_StringTools
#include <StringTools.h>
#endif
#ifndef INCLUDED_Xml
#include <Xml.h>
#endif
#ifndef INCLUDED_h2d_Font
#include <h2d/Font.h>
#endif
#ifndef INCLUDED_h2d_FontChar
#include <h2d/FontChar.h>
#endif
#ifndef INCLUDED_h2d_Tile
#include <h2d/Tile.h>
#endif
#ifndef INCLUDED_haxe_ds_IntMap
#include <haxe/ds/IntMap.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_haxe_xml_Fast
#include <haxe/xml/Fast.h>
#endif
#ifndef INCLUDED_haxe_xml__Fast_AttribAccess
#include <haxe/xml/_Fast/AttribAccess.h>
#endif
#ifndef INCLUDED_hxd_res_Any
#include <hxd/res/Any.h>
#endif
#ifndef INCLUDED_hxd_res_BitmapFont
#include <hxd/res/BitmapFont.h>
#endif
#ifndef INCLUDED_hxd_res_FileEntry
#include <hxd/res/FileEntry.h>
#endif
#ifndef INCLUDED_hxd_res_Loader
#include <hxd/res/Loader.h>
#endif
#ifndef INCLUDED_hxd_res_Resource
#include <hxd/res/Resource.h>
#endif
namespace hxd{
namespace res{

Void BitmapFont_obj::__construct(::hxd::res::Loader loader,::hxd::res::FileEntry entry)
{
HX_STACK_FRAME("hxd.res.BitmapFont","new",0x36579598,"hxd.res.BitmapFont.new","hxd/res/BitmapFont.hx",8,0xa63e6716)
HX_STACK_THIS(this)
HX_STACK_ARG(loader,"loader")
HX_STACK_ARG(entry,"entry")
{
	HX_STACK_LINE(9)
	super::__construct(entry);
	HX_STACK_LINE(10)
	this->loader = loader;
}
;
	return null();
}

//BitmapFont_obj::~BitmapFont_obj() { }

Dynamic BitmapFont_obj::__CreateEmpty() { return  new BitmapFont_obj; }
hx::ObjectPtr< BitmapFont_obj > BitmapFont_obj::__new(::hxd::res::Loader loader,::hxd::res::FileEntry entry)
{  hx::ObjectPtr< BitmapFont_obj > result = new BitmapFont_obj();
	result->__construct(loader,entry);
	return result;}

Dynamic BitmapFont_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< BitmapFont_obj > result = new BitmapFont_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

::h2d::Font BitmapFont_obj::toFont( ){
	HX_STACK_FRAME("hxd.res.BitmapFont","toFont",0x036316b2,"hxd.res.BitmapFont.toFont","hxd/res/BitmapFont.hx",14,0xa63e6716)
	HX_STACK_THIS(this)
	HX_STACK_LINE(15)
	if (((  (((this->font != null()))) ? bool(!(this->font->tile->isDisposed())) : bool(false) ))){
		HX_STACK_LINE(16)
		return this->font;
	}
	HX_STACK_LINE(17)
	::String _g = this->entry->get_path().substr((int)0,(int)-3);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(17)
	::String _g1 = (_g + HX_CSTRING("png"));		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(17)
	::h2d::Tile tile = this->loader->load(_g1)->toTile();		HX_STACK_VAR(tile,"tile");
	HX_STACK_LINE(18)
	if (((this->font != null()))){
		HX_STACK_LINE(19)
		this->font->tile = tile;
		HX_STACK_LINE(20)
		return this->font;
	}
	HX_STACK_LINE(22)
	::String name = this->entry->get_path();		HX_STACK_VAR(name,"name");
	HX_STACK_LINE(22)
	int size = (int)0;		HX_STACK_VAR(size,"size");
	HX_STACK_LINE(22)
	int lineHeight = (int)0;		HX_STACK_VAR(lineHeight,"lineHeight");
	HX_STACK_LINE(22)
	::haxe::ds::IntMap glyphs = ::haxe::ds::IntMap_obj::__new();		HX_STACK_VAR(glyphs,"glyphs");
	HX_STACK_LINE(23)
	{
		HX_STACK_LINE(23)
		int _g2 = this->entry->getSign();		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(23)
		{
			HX_STACK_LINE(23)
			int sign = _g2;		HX_STACK_VAR(sign,"sign");
			HX_STACK_LINE(23)
			switch( (int)(_g2)){
				case (int)1836597052: {
					HX_STACK_LINE(25)
					::String _g21 = this->entry->getBytes()->toString();		HX_STACK_VAR(_g21,"_g21");
					HX_STACK_LINE(25)
					::Xml xml = ::Xml_obj::parse(_g21);		HX_STACK_VAR(xml,"xml");
					HX_STACK_LINE(27)
					::Xml _g3 = xml->firstElement();		HX_STACK_VAR(_g3,"_g3");
					HX_STACK_LINE(27)
					::haxe::xml::Fast xml1 = ::haxe::xml::Fast_obj::__new(_g3);		HX_STACK_VAR(xml1,"xml1");
					HX_STACK_LINE(28)
					::String _g4 = xml1->att->resolve(HX_CSTRING("size"));		HX_STACK_VAR(_g4,"_g4");
					HX_STACK_LINE(28)
					Dynamic _g5 = ::Std_obj::parseInt(_g4);		HX_STACK_VAR(_g5,"_g5");
					HX_STACK_LINE(28)
					size = _g5;
					HX_STACK_LINE(29)
					::String _g6 = xml1->att->resolve(HX_CSTRING("height"));		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(29)
					Dynamic _g7 = ::Std_obj::parseInt(_g6);		HX_STACK_VAR(_g7,"_g7");
					HX_STACK_LINE(29)
					lineHeight = _g7;
					HX_STACK_LINE(30)
					::String _g8 = xml1->att->resolve(HX_CSTRING("family"));		HX_STACK_VAR(_g8,"_g8");
					HX_STACK_LINE(30)
					name = _g8;
					HX_STACK_LINE(31)
					for(::cpp::FastIterator_obj< ::haxe::xml::Fast > *__it = ::cpp::CreateFastIterator< ::haxe::xml::Fast >(xml1->get_elements());  __it->hasNext(); ){
						::haxe::xml::Fast c = __it->next();
						{
							HX_STACK_LINE(32)
							Array< ::String > r = c->att->resolve(HX_CSTRING("rect")).split(HX_CSTRING(" "));		HX_STACK_VAR(r,"r");
							HX_STACK_LINE(33)
							Array< ::String > o = c->att->resolve(HX_CSTRING("offset")).split(HX_CSTRING(" "));		HX_STACK_VAR(o,"o");
							HX_STACK_LINE(34)
							Dynamic _g9 = ::Std_obj::parseInt(r->__get((int)0));		HX_STACK_VAR(_g9,"_g9");
							HX_STACK_LINE(34)
							Dynamic _g10 = ::Std_obj::parseInt(r->__get((int)1));		HX_STACK_VAR(_g10,"_g10");
							HX_STACK_LINE(34)
							Dynamic _g11 = ::Std_obj::parseInt(r->__get((int)2));		HX_STACK_VAR(_g11,"_g11");
							HX_STACK_LINE(34)
							Dynamic _g12 = ::Std_obj::parseInt(r->__get((int)3));		HX_STACK_VAR(_g12,"_g12");
							HX_STACK_LINE(34)
							Dynamic _g13 = ::Std_obj::parseInt(o->__get((int)0));		HX_STACK_VAR(_g13,"_g13");
							HX_STACK_LINE(34)
							Dynamic _g14 = ::Std_obj::parseInt(o->__get((int)1));		HX_STACK_VAR(_g14,"_g14");
							HX_STACK_LINE(34)
							::h2d::Tile t = tile->sub(_g9,_g10,_g11,_g12,_g13,_g14);		HX_STACK_VAR(t,"t");
							HX_STACK_LINE(35)
							::String _g15 = c->att->resolve(HX_CSTRING("width"));		HX_STACK_VAR(_g15,"_g15");
							HX_STACK_LINE(35)
							Dynamic _g16 = ::Std_obj::parseInt(_g15);		HX_STACK_VAR(_g16,"_g16");
							HX_STACK_LINE(35)
							::h2d::FontChar fc = ::h2d::FontChar_obj::__new(t,_g16);		HX_STACK_VAR(fc,"fc");
							HX_STACK_LINE(36)
							for(::cpp::FastIterator_obj< ::haxe::xml::Fast > *__it = ::cpp::CreateFastIterator< ::haxe::xml::Fast >(c->get_elements());  __it->hasNext(); ){
								::haxe::xml::Fast k = __it->next();
								{
									HX_STACK_LINE(37)
									Dynamic _g17 = k->att->resolve(HX_CSTRING("id")).charCodeAt((int)0);		HX_STACK_VAR(_g17,"_g17");
									HX_STACK_LINE(37)
									::String _g18 = k->att->resolve(HX_CSTRING("advance"));		HX_STACK_VAR(_g18,"_g18");
									HX_STACK_LINE(37)
									Dynamic _g19 = ::Std_obj::parseInt(_g18);		HX_STACK_VAR(_g19,"_g19");
									HX_STACK_LINE(37)
									fc->addKerning(_g17,_g19);
								}
;
							}
							HX_STACK_LINE(38)
							{
								HX_STACK_LINE(38)
								Dynamic key = c->att->resolve(HX_CSTRING("code")).charCodeAt((int)0);		HX_STACK_VAR(key,"key");
								HX_STACK_LINE(38)
								glyphs->set(key,fc);
							}
						}
;
					}
				}
				;break;
				default: {
					HX_STACK_LINE(41)
					::String _g20 = ::StringTools_obj::hex(sign,(int)8);		HX_STACK_VAR(_g20,"_g20");
					HX_STACK_LINE(41)
					HX_STACK_DO_THROW((HX_CSTRING("Unknown font signature ") + _g20));
				}
			}
		}
	}
	HX_STACK_LINE(43)
	::h2d::FontChar _g21 = glyphs->get((int)32);		HX_STACK_VAR(_g21,"_g21");
	HX_STACK_LINE(43)
	if (((_g21 == null()))){
		HX_STACK_LINE(44)
		::h2d::Tile _g22 = tile->sub((int)0,(int)0,(int)0,(int)0,null(),null());		HX_STACK_VAR(_g22,"_g22");
		HX_STACK_LINE(44)
		::h2d::FontChar value = ::h2d::FontChar_obj::__new(_g22,(int(size) >> int((int)1)));		HX_STACK_VAR(value,"value");
		HX_STACK_LINE(44)
		glyphs->set((int)32,value);
	}
	HX_STACK_LINE(46)
	::h2d::Font _g23 = ::h2d::Font_obj::__new(name,size);		HX_STACK_VAR(_g23,"_g23");
	HX_STACK_LINE(46)
	this->font = _g23;
	HX_STACK_LINE(47)
	this->font->glyphs = glyphs;
	HX_STACK_LINE(48)
	this->font->lineHeight = lineHeight;
	HX_STACK_LINE(49)
	this->font->tile = tile;
	HX_STACK_LINE(50)
	return this->font;
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapFont_obj,toFont,return )


BitmapFont_obj::BitmapFont_obj()
{
}

void BitmapFont_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(BitmapFont);
	HX_MARK_MEMBER_NAME(loader,"loader");
	HX_MARK_MEMBER_NAME(font,"font");
	::hxd::res::Resource_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void BitmapFont_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(loader,"loader");
	HX_VISIT_MEMBER_NAME(font,"font");
	::hxd::res::Resource_obj::__Visit(HX_VISIT_ARG);
}

Dynamic BitmapFont_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"font") ) { return font; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"loader") ) { return loader; }
		if (HX_FIELD_EQ(inName,"toFont") ) { return toFont_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic BitmapFont_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"font") ) { font=inValue.Cast< ::h2d::Font >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"loader") ) { loader=inValue.Cast< ::hxd::res::Loader >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void BitmapFont_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("loader"));
	outFields->push(HX_CSTRING("font"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::hxd::res::Loader*/ ,(int)offsetof(BitmapFont_obj,loader),HX_CSTRING("loader")},
	{hx::fsObject /*::h2d::Font*/ ,(int)offsetof(BitmapFont_obj,font),HX_CSTRING("font")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("loader"),
	HX_CSTRING("font"),
	HX_CSTRING("toFont"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(BitmapFont_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(BitmapFont_obj::__mClass,"__mClass");
};

#endif

Class BitmapFont_obj::__mClass;

void BitmapFont_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.res.BitmapFont"), hx::TCanCast< BitmapFont_obj> ,sStaticFields,sMemberFields,
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

void BitmapFont_obj::__boot()
{
}

} // end namespace hxd
} // end namespace res
