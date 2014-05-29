#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
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
#ifndef INCLUDED_h3d_mat_Texture
#include <h3d/mat/Texture.h>
#endif
#ifndef INCLUDED_haxe_ds_IntMap
#include <haxe/ds/IntMap.h>
#endif
#ifndef INCLUDED_hxd_Charset
#include <hxd/Charset.h>
#endif
namespace h2d{

Void Font_obj::__construct(::String name,int size)
{
HX_STACK_FRAME("h2d.Font","new",0x75bf7af5,"h2d.Font.new","h2d/Font.hx",60,0x32d64c3a)
HX_STACK_THIS(this)
HX_STACK_ARG(name,"name")
HX_STACK_ARG(size,"size")
{
	HX_STACK_LINE(61)
	this->name = name;
	HX_STACK_LINE(62)
	this->size = size;
	HX_STACK_LINE(63)
	::haxe::ds::IntMap _g = ::haxe::ds::IntMap_obj::__new();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(63)
	this->glyphs = _g;
	HX_STACK_LINE(64)
	::h2d::Tile _g1 = ::h2d::Tile_obj::__new(null(),(int)0,(int)0,(int)0,(int)0,null(),null());		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(64)
	::h2d::FontChar _g2 = ::h2d::FontChar_obj::__new(_g1,(int)0);		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(64)
	this->defaultChar = _g2;
	HX_STACK_LINE(65)
	::hxd::Charset _g3 = ::hxd::Charset_obj::getDefault();		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(65)
	this->charset = _g3;
}
;
	return null();
}

//Font_obj::~Font_obj() { }

Dynamic Font_obj::__CreateEmpty() { return  new Font_obj; }
hx::ObjectPtr< Font_obj > Font_obj::__new(::String name,int size)
{  hx::ObjectPtr< Font_obj > result = new Font_obj();
	result->__construct(name,size);
	return result;}

Dynamic Font_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Font_obj > result = new Font_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

::h2d::FontChar Font_obj::getChar( int code){
	HX_STACK_FRAME("h2d.Font","getChar",0x047f27a1,"h2d.Font.getChar","h2d/Font.hx",68,0x32d64c3a)
	HX_STACK_THIS(this)
	HX_STACK_ARG(code,"code")
	HX_STACK_LINE(69)
	::h2d::FontChar c = this->glyphs->get(code);		HX_STACK_VAR(c,"c");
	HX_STACK_LINE(70)
	if (((c == null()))){
		HX_STACK_LINE(71)
		::h2d::FontChar _g = this->charset->resolveChar(code,this->glyphs);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(71)
		c = _g;
		HX_STACK_LINE(72)
		if (((c == null()))){
			HX_STACK_LINE(72)
			c = this->defaultChar;
		}
	}
	HX_STACK_LINE(74)
	return c;
}


HX_DEFINE_DYNAMIC_FUNC1(Font_obj,getChar,return )

Void Font_obj::resizeTo( int size){
{
		HX_STACK_FRAME("h2d.Font","resizeTo",0xe6b5e1da,"h2d.Font.resizeTo","h2d/Font.hx",80,0x32d64c3a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(size,"size")
		HX_STACK_LINE(81)
		Float ratio = (Float(size) / Float(this->size));		HX_STACK_VAR(ratio,"ratio");
		HX_STACK_LINE(82)
		for(::cpp::FastIterator_obj< ::h2d::FontChar > *__it = ::cpp::CreateFastIterator< ::h2d::FontChar >(this->glyphs->iterator());  __it->hasNext(); ){
			::h2d::FontChar c = __it->next();
			{
				HX_STACK_LINE(83)
				int _g = ::Std_obj::_int((c->width * ratio));		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(83)
				c->width = _g;
				HX_STACK_LINE(84)
				int _g1 = ::Std_obj::_int((c->t->width * ratio));		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(84)
				int _g2 = ::Std_obj::_int((c->t->height * ratio));		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(84)
				c->t->scaleToSize(_g1,_g2);
			}
;
		}
		HX_STACK_LINE(86)
		int _g3 = ::Std_obj::_int((this->lineHeight * ratio));		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(86)
		this->lineHeight = _g3;
		HX_STACK_LINE(87)
		this->size = size;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Font_obj,resizeTo,(void))

bool Font_obj::hasChar( int code){
	HX_STACK_FRAME("h2d.Font","hasChar",0x01409865,"h2d.Font.hasChar","h2d/Font.hx",90,0x32d64c3a)
	HX_STACK_THIS(this)
	HX_STACK_ARG(code,"code")
	HX_STACK_LINE(91)
	::h2d::FontChar _g = this->glyphs->get(code);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(91)
	return (_g != null());
}


HX_DEFINE_DYNAMIC_FUNC1(Font_obj,hasChar,return )

Void Font_obj::dispose( ){
{
		HX_STACK_FRAME("h2d.Font","dispose",0xab8999b4,"h2d.Font.dispose","h2d/Font.hx",95,0x32d64c3a)
		HX_STACK_THIS(this)
		HX_STACK_LINE(95)
		this->tile->dispose();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Font_obj,dispose,(void))


Font_obj::Font_obj()
{
}

void Font_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Font);
	HX_MARK_MEMBER_NAME(name,"name");
	HX_MARK_MEMBER_NAME(size,"size");
	HX_MARK_MEMBER_NAME(lineHeight,"lineHeight");
	HX_MARK_MEMBER_NAME(tile,"tile");
	HX_MARK_MEMBER_NAME(charset,"charset");
	HX_MARK_MEMBER_NAME(glyphs,"glyphs");
	HX_MARK_MEMBER_NAME(defaultChar,"defaultChar");
	HX_MARK_END_CLASS();
}

void Font_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(name,"name");
	HX_VISIT_MEMBER_NAME(size,"size");
	HX_VISIT_MEMBER_NAME(lineHeight,"lineHeight");
	HX_VISIT_MEMBER_NAME(tile,"tile");
	HX_VISIT_MEMBER_NAME(charset,"charset");
	HX_VISIT_MEMBER_NAME(glyphs,"glyphs");
	HX_VISIT_MEMBER_NAME(defaultChar,"defaultChar");
}

Dynamic Font_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { return name; }
		if (HX_FIELD_EQ(inName,"size") ) { return size; }
		if (HX_FIELD_EQ(inName,"tile") ) { return tile; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"glyphs") ) { return glyphs; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"charset") ) { return charset; }
		if (HX_FIELD_EQ(inName,"getChar") ) { return getChar_dyn(); }
		if (HX_FIELD_EQ(inName,"hasChar") ) { return hasChar_dyn(); }
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"resizeTo") ) { return resizeTo_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"lineHeight") ) { return lineHeight; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"defaultChar") ) { return defaultChar; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Font_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { name=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"size") ) { size=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"tile") ) { tile=inValue.Cast< ::h2d::Tile >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"glyphs") ) { glyphs=inValue.Cast< ::haxe::ds::IntMap >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"charset") ) { charset=inValue.Cast< ::hxd::Charset >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"lineHeight") ) { lineHeight=inValue.Cast< int >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"defaultChar") ) { defaultChar=inValue.Cast< ::h2d::FontChar >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Font_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("name"));
	outFields->push(HX_CSTRING("size"));
	outFields->push(HX_CSTRING("lineHeight"));
	outFields->push(HX_CSTRING("tile"));
	outFields->push(HX_CSTRING("charset"));
	outFields->push(HX_CSTRING("glyphs"));
	outFields->push(HX_CSTRING("defaultChar"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsString,(int)offsetof(Font_obj,name),HX_CSTRING("name")},
	{hx::fsInt,(int)offsetof(Font_obj,size),HX_CSTRING("size")},
	{hx::fsInt,(int)offsetof(Font_obj,lineHeight),HX_CSTRING("lineHeight")},
	{hx::fsObject /*::h2d::Tile*/ ,(int)offsetof(Font_obj,tile),HX_CSTRING("tile")},
	{hx::fsObject /*::hxd::Charset*/ ,(int)offsetof(Font_obj,charset),HX_CSTRING("charset")},
	{hx::fsObject /*::haxe::ds::IntMap*/ ,(int)offsetof(Font_obj,glyphs),HX_CSTRING("glyphs")},
	{hx::fsObject /*::h2d::FontChar*/ ,(int)offsetof(Font_obj,defaultChar),HX_CSTRING("defaultChar")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("name"),
	HX_CSTRING("size"),
	HX_CSTRING("lineHeight"),
	HX_CSTRING("tile"),
	HX_CSTRING("charset"),
	HX_CSTRING("glyphs"),
	HX_CSTRING("defaultChar"),
	HX_CSTRING("getChar"),
	HX_CSTRING("resizeTo"),
	HX_CSTRING("hasChar"),
	HX_CSTRING("dispose"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Font_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Font_obj::__mClass,"__mClass");
};

#endif

Class Font_obj::__mClass;

void Font_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.Font"), hx::TCanCast< Font_obj> ,sStaticFields,sMemberFields,
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

void Font_obj::__boot()
{
}

} // end namespace h2d
