#include <hxcpp.h>

#ifndef INCLUDED_h2d_FontChar
#include <h2d/FontChar.h>
#endif
#ifndef INCLUDED_h2d_Kerning
#include <h2d/Kerning.h>
#endif
#ifndef INCLUDED_h2d_Tile
#include <h2d/Tile.h>
#endif
namespace h2d{

Void FontChar_obj::__construct(::h2d::Tile t,int w)
{
HX_STACK_FRAME("h2d.FontChar","new",0x1120766b,"h2d.FontChar.new","h2d/Font.hx",19,0x32d64c3a)
HX_STACK_THIS(this)
HX_STACK_ARG(t,"t")
HX_STACK_ARG(w,"w")
{
	HX_STACK_LINE(20)
	this->t = t;
	HX_STACK_LINE(21)
	this->width = w;
}
;
	return null();
}

//FontChar_obj::~FontChar_obj() { }

Dynamic FontChar_obj::__CreateEmpty() { return  new FontChar_obj; }
hx::ObjectPtr< FontChar_obj > FontChar_obj::__new(::h2d::Tile t,int w)
{  hx::ObjectPtr< FontChar_obj > result = new FontChar_obj();
	result->__construct(t,w);
	return result;}

Dynamic FontChar_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< FontChar_obj > result = new FontChar_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

Void FontChar_obj::addKerning( int prevChar,int offset){
{
		HX_STACK_FRAME("h2d.FontChar","addKerning",0x23a0e800,"h2d.FontChar.addKerning","h2d/Font.hx",24,0x32d64c3a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(prevChar,"prevChar")
		HX_STACK_ARG(offset,"offset")
		HX_STACK_LINE(25)
		::h2d::Kerning k = ::h2d::Kerning_obj::__new(prevChar,offset);		HX_STACK_VAR(k,"k");
		HX_STACK_LINE(26)
		k->next = this->kerning;
		HX_STACK_LINE(27)
		this->kerning = k;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(FontChar_obj,addKerning,(void))

int FontChar_obj::getKerningOffset( int prevChar){
	HX_STACK_FRAME("h2d.FontChar","getKerningOffset",0x0f04c01e,"h2d.FontChar.getKerningOffset","h2d/Font.hx",30,0x32d64c3a)
	HX_STACK_THIS(this)
	HX_STACK_ARG(prevChar,"prevChar")
	HX_STACK_LINE(31)
	::h2d::Kerning k = this->kerning;		HX_STACK_VAR(k,"k");
	HX_STACK_LINE(32)
	while((true)){
		HX_STACK_LINE(32)
		if ((!(((k != null()))))){
			HX_STACK_LINE(32)
			break;
		}
		HX_STACK_LINE(33)
		if (((k->prevChar == prevChar))){
			HX_STACK_LINE(34)
			return k->offset;
		}
		HX_STACK_LINE(35)
		k = k->next;
	}
	HX_STACK_LINE(37)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC1(FontChar_obj,getKerningOffset,return )


FontChar_obj::FontChar_obj()
{
}

void FontChar_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(FontChar);
	HX_MARK_MEMBER_NAME(t,"t");
	HX_MARK_MEMBER_NAME(width,"width");
	HX_MARK_MEMBER_NAME(kerning,"kerning");
	HX_MARK_END_CLASS();
}

void FontChar_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(t,"t");
	HX_VISIT_MEMBER_NAME(width,"width");
	HX_VISIT_MEMBER_NAME(kerning,"kerning");
}

Dynamic FontChar_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"t") ) { return t; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"width") ) { return width; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"kerning") ) { return kerning; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"addKerning") ) { return addKerning_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"getKerningOffset") ) { return getKerningOffset_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic FontChar_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"t") ) { t=inValue.Cast< ::h2d::Tile >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"width") ) { width=inValue.Cast< int >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"kerning") ) { kerning=inValue.Cast< ::h2d::Kerning >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void FontChar_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("t"));
	outFields->push(HX_CSTRING("width"));
	outFields->push(HX_CSTRING("kerning"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h2d::Tile*/ ,(int)offsetof(FontChar_obj,t),HX_CSTRING("t")},
	{hx::fsInt,(int)offsetof(FontChar_obj,width),HX_CSTRING("width")},
	{hx::fsObject /*::h2d::Kerning*/ ,(int)offsetof(FontChar_obj,kerning),HX_CSTRING("kerning")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("t"),
	HX_CSTRING("width"),
	HX_CSTRING("kerning"),
	HX_CSTRING("addKerning"),
	HX_CSTRING("getKerningOffset"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FontChar_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FontChar_obj::__mClass,"__mClass");
};

#endif

Class FontChar_obj::__mClass;

void FontChar_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.FontChar"), hx::TCanCast< FontChar_obj> ,sStaticFields,sMemberFields,
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

void FontChar_obj::__boot()
{
}

} // end namespace h2d
