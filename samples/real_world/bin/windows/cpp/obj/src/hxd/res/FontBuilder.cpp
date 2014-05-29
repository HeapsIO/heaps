#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_Lambda
#include <Lambda.h>
#endif
#ifndef INCLUDED_List
#include <List.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_flash_display_BitmapData
#include <flash/display/BitmapData.h>
#endif
#ifndef INCLUDED_flash_display_BlendMode
#include <flash/display/BlendMode.h>
#endif
#ifndef INCLUDED_flash_display_DisplayObject
#include <flash/display/DisplayObject.h>
#endif
#ifndef INCLUDED_flash_display_IBitmapDrawable
#include <flash/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_flash_display_InteractiveObject
#include <flash/display/InteractiveObject.h>
#endif
#ifndef INCLUDED_flash_events_EventDispatcher
#include <flash/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_flash_events_IEventDispatcher
#include <flash/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_flash_geom_ColorTransform
#include <flash/geom/ColorTransform.h>
#endif
#ifndef INCLUDED_flash_geom_Matrix
#include <flash/geom/Matrix.h>
#endif
#ifndef INCLUDED_flash_geom_Rectangle
#include <flash/geom/Rectangle.h>
#endif
#ifndef INCLUDED_flash_text_AntiAliasType
#include <flash/text/AntiAliasType.h>
#endif
#ifndef INCLUDED_flash_text_Font
#include <flash/text/Font.h>
#endif
#ifndef INCLUDED_flash_text_GridFitType
#include <flash/text/GridFitType.h>
#endif
#ifndef INCLUDED_flash_text_TextField
#include <flash/text/TextField.h>
#endif
#ifndef INCLUDED_flash_text_TextFormat
#include <flash/text/TextFormat.h>
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
#ifndef INCLUDED_haxe_Utf8
#include <haxe/Utf8.h>
#endif
#ifndef INCLUDED_haxe_ds_IntMap
#include <haxe/ds/IntMap.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_hxd_Charset
#include <hxd/Charset.h>
#endif
#ifndef INCLUDED_hxd_PixelFormat
#include <hxd/PixelFormat.h>
#endif
#ifndef INCLUDED_hxd_Pixels
#include <hxd/Pixels.h>
#endif
#ifndef INCLUDED_hxd__BitmapData_BitmapData_Impl_
#include <hxd/_BitmapData/BitmapData_Impl_.h>
#endif
#ifndef INCLUDED_hxd_res_FontBuilder
#include <hxd/res/FontBuilder.h>
#endif
#ifndef INCLUDED_hxd_text_Utf8Tools
#include <hxd/text/Utf8Tools.h>
#endif
namespace hxd{
namespace res{

Void FontBuilder_obj::__construct(::String name,int size,Dynamic opt)
{
HX_STACK_FRAME("hxd.res.FontBuilder","new",0x13b9b2b6,"hxd.res.FontBuilder.new","hxd/res/FontBuilder.hx",22,0x2e36497c)
HX_STACK_THIS(this)
HX_STACK_ARG(name,"name")
HX_STACK_ARG(size,"size")
HX_STACK_ARG(opt,"opt")
{
	HX_STACK_LINE(23)
	::h2d::Font _g = ::h2d::Font_obj::__new(name,size);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(23)
	this->font = _g;
	HX_STACK_LINE(24)
	if (((opt == null()))){
		struct _Function_2_1{
			inline static Dynamic Block( ){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/res/FontBuilder.hx",24,0x2e36497c)
				{
					hx::Anon __result = hx::Anon_obj::Create();
					return __result;
				}
				return null();
			}
		};
		HX_STACK_LINE(24)
		this->options = _Function_2_1::Block();
	}
	else{
		HX_STACK_LINE(24)
		this->options = opt;
	}
	HX_STACK_LINE(25)
	if (((this->options->__Field(HX_CSTRING("antiAliasing"),true) == null()))){
		HX_STACK_LINE(25)
		this->options->__FieldRef(HX_CSTRING("antiAliasing")) = true;
	}
	HX_STACK_LINE(26)
	if (((this->options->__Field(HX_CSTRING("chars"),true) == null()))){
		HX_STACK_LINE(26)
		this->options->__FieldRef(HX_CSTRING("chars")) = ::hxd::Charset_obj::DEFAULT_CHARS;
	}
}
;
	return null();
}

//FontBuilder_obj::~FontBuilder_obj() { }

Dynamic FontBuilder_obj::__CreateEmpty() { return  new FontBuilder_obj; }
hx::ObjectPtr< FontBuilder_obj > FontBuilder_obj::__new(::String name,int size,Dynamic opt)
{  hx::ObjectPtr< FontBuilder_obj > result = new FontBuilder_obj();
	result->__construct(name,size,opt);
	return result;}

Dynamic FontBuilder_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< FontBuilder_obj > result = new FontBuilder_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

Array< int > FontBuilder_obj::getUtf8StringAsArray( ::String str){
	HX_STACK_FRAME("hxd.res.FontBuilder","getUtf8StringAsArray",0xf9cfa9f9,"hxd.res.FontBuilder.getUtf8StringAsArray","hxd/res/FontBuilder.hx",32,0x2e36497c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(str,"str")
	HX_STACK_LINE(33)
	Array< ::Dynamic > a = Array_obj< ::Dynamic >::__new().Add(Array_obj< int >::__new());		HX_STACK_VAR(a,"a");

	HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_1_1,Array< ::Dynamic >,a)
	Void run(int cc){
		HX_STACK_FRAME("*","_Function_1_1",0x5200ed37,"*._Function_1_1","hxd/res/FontBuilder.hx",35,0x2e36497c)
		HX_STACK_ARG(cc,"cc")
		{
			HX_STACK_LINE(35)
			a->__get((int)0).StaticCast< Array< int > >()->push(cc);
		}
		return null();
	}
	HX_END_LOCAL_FUNC1((void))

	HX_STACK_LINE(34)
	::haxe::Utf8_obj::iter(str, Dynamic(new _Function_1_1(a)));
	HX_STACK_LINE(37)
	return a->__get((int)0).StaticCast< Array< int > >();
}


HX_DEFINE_DYNAMIC_FUNC1(FontBuilder_obj,getUtf8StringAsArray,return )

Dynamic FontBuilder_obj::isolateUtf8Blocs( Array< int > codes){
	HX_STACK_FRAME("hxd.res.FontBuilder","isolateUtf8Blocs",0x2fde05e3,"hxd.res.FontBuilder.isolateUtf8Blocs","hxd/res/FontBuilder.hx",43,0x2e36497c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(codes,"codes")
	HX_STACK_LINE(44)
	Dynamic a = Dynamic( Array_obj<Dynamic>::__new());		HX_STACK_VAR(a,"a");
	HX_STACK_LINE(45)
	int i = (int)0;		HX_STACK_VAR(i,"i");
	HX_STACK_LINE(46)
	int cl = (int)0;		HX_STACK_VAR(cl,"cl");
	HX_STACK_LINE(47)
	{
		HX_STACK_LINE(47)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(47)
		while((true)){
			HX_STACK_LINE(47)
			if ((!(((_g < codes->length))))){
				HX_STACK_LINE(47)
				break;
			}
			HX_STACK_LINE(47)
			int cc = codes->__get(_g);		HX_STACK_VAR(cc,"cc");
			HX_STACK_LINE(47)
			++(_g);
			HX_STACK_LINE(48)
			int _g1 = ::hxd::text::Utf8Tools_obj::getByteLength(cc);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(48)
			cl = _g1;
			struct _Function_3_1{
				inline static Dynamic Block( int &i,int &cl){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/res/FontBuilder.hx",49,0x2e36497c)
					{
						hx::Anon __result = hx::Anon_obj::Create();
						__result->Add(HX_CSTRING("pos") , i,false);
						__result->Add(HX_CSTRING("len") , cl,false);
						return __result;
					}
					return null();
				}
			};
			HX_STACK_LINE(49)
			a->__Field(HX_CSTRING("push"),true)(_Function_3_1::Block(i,cl));
			HX_STACK_LINE(50)
			hx::AddEq(i,cl);
		}
	}
	HX_STACK_LINE(53)
	return a;
}


HX_DEFINE_DYNAMIC_FUNC1(FontBuilder_obj,isolateUtf8Blocs,return )

::h2d::Font FontBuilder_obj::build( ){
	HX_STACK_FRAME("hxd.res.FontBuilder","build",0xdd4e7f04,"hxd.res.FontBuilder.build","hxd/res/FontBuilder.hx",57,0x2e36497c)
	HX_STACK_THIS(this)
	HX_STACK_LINE(58)
	this->font->lineHeight = (int)0;
	HX_STACK_LINE(59)
	::flash::text::TextField tf = ::flash::text::TextField_obj::__new();		HX_STACK_VAR(tf,"tf");
	HX_STACK_LINE(60)
	::flash::text::TextFormat fmt = tf->get_defaultTextFormat();		HX_STACK_VAR(fmt,"fmt");
	HX_STACK_LINE(61)
	fmt->font = this->font->name;
	HX_STACK_LINE(62)
	fmt->size = this->font->size;
	HX_STACK_LINE(63)
	fmt->color = (int)16777215;
	HX_STACK_LINE(64)
	tf->set_defaultTextFormat(fmt);
	HX_STACK_LINE(67)
	{
		HX_STACK_LINE(67)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(67)
		Array< ::Dynamic > _g1 = ::flash::text::Font_obj::enumerateFonts(null());		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(67)
		while((true)){
			HX_STACK_LINE(67)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(67)
				break;
			}
			HX_STACK_LINE(67)
			::flash::text::Font f = _g1->__get(_g).StaticCast< ::flash::text::Font >();		HX_STACK_VAR(f,"f");
			HX_STACK_LINE(67)
			++(_g);
			HX_STACK_LINE(68)
			if (((f->fontName == this->font->name))){
				HX_STACK_LINE(69)
				tf->set_embedFonts(true);
				HX_STACK_LINE(70)
				break;
			}
		}
	}
	HX_STACK_LINE(74)
	if ((!(tf->get_embedFonts()))){
		HX_STACK_LINE(76)
		Array< ::Dynamic > _g = ::flash::text::Font_obj::enumerateFonts(null());		HX_STACK_VAR(_g,"_g");

		HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_2_1)
		::String run(::flash::text::Font fnt){
			HX_STACK_FRAME("*","_Function_2_1",0x5201af78,"*._Function_2_1","hxd/res/FontBuilder.hx",76,0x2e36497c)
			HX_STACK_ARG(fnt,"fnt")
			{
				HX_STACK_LINE(76)
				return fnt->fontName;
			}
			return null();
		}
		HX_END_LOCAL_FUNC1(return)

		HX_STACK_LINE(76)
		::List _g1 = ::Lambda_obj::map(_g, Dynamic(new _Function_2_1()));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(76)
		::String _g2 = ::Std_obj::string(_g1);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(75)
		HX_STACK_DO_THROW((HX_CSTRING("Impossible to interpret not embedded fonts, use one among ") + _g2));
	}
	HX_STACK_LINE(79)
	if ((this->options->__Field(HX_CSTRING("antiAliasing"),true))){
		HX_STACK_LINE(80)
		tf->gridFitType = ::flash::text::GridFitType_obj::SUBPIXEL;
		HX_STACK_LINE(81)
		tf->antiAliasType = ::flash::text::AntiAliasType_obj::ADVANCED;
	}
	HX_STACK_LINE(84)
	int surf = (int)0;		HX_STACK_VAR(surf,"surf");
	HX_STACK_LINE(85)
	Dynamic sizes = Dynamic( Array_obj<Dynamic>::__new());		HX_STACK_VAR(sizes,"sizes");
	HX_STACK_LINE(86)
	::String allChars = this->options->__Field(HX_CSTRING("chars"),true);		HX_STACK_VAR(allChars,"allChars");
	HX_STACK_LINE(87)
	Array< int > allCC = this->getUtf8StringAsArray(this->options->__Field(HX_CSTRING("chars"),true));		HX_STACK_VAR(allCC,"allCC");
	HX_STACK_LINE(89)
	Dynamic allCCBytes = this->isolateUtf8Blocs(allCC);		HX_STACK_VAR(allCCBytes,"allCCBytes");
	HX_STACK_LINE(92)
	{
		HX_STACK_LINE(92)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(92)
		int _g = allCC->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(92)
		while((true)){
			HX_STACK_LINE(92)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(92)
				break;
			}
			HX_STACK_LINE(92)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(96)
			::String _g3 = this->options->__Field(HX_CSTRING("chars"),true)->__Field(HX_CSTRING("substr"),true)(allCCBytes->__GetItem(i)->__Field(HX_CSTRING("pos"),true),allCCBytes->__GetItem(i)->__Field(HX_CSTRING("len"),true));		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(96)
			tf->set_text(_g3);
			HX_STACK_LINE(98)
			int _g4;		HX_STACK_VAR(_g4,"_g4");
			HX_STACK_LINE(98)
			{
				HX_STACK_LINE(98)
				Float f = tf->get_textWidth();		HX_STACK_VAR(f,"f");
				HX_STACK_LINE(98)
				_g4 = ::Math_obj::ceil(f);
			}
			HX_STACK_LINE(98)
			int w = (_g4 + (int)1);		HX_STACK_VAR(w,"w");
			HX_STACK_LINE(99)
			if (((w == (int)1))){
				HX_STACK_LINE(99)
				continue;
			}
			HX_STACK_LINE(100)
			int _g5;		HX_STACK_VAR(_g5,"_g5");
			HX_STACK_LINE(100)
			{
				HX_STACK_LINE(100)
				Float f = tf->get_textHeight();		HX_STACK_VAR(f,"f");
				HX_STACK_LINE(100)
				_g5 = ::Math_obj::ceil(f);
			}
			HX_STACK_LINE(100)
			int h = (_g5 + (int)1);		HX_STACK_VAR(h,"h");
			HX_STACK_LINE(101)
			hx::AddEq(surf,(((w + (int)1)) * ((h + (int)1))));
			HX_STACK_LINE(102)
			if (((h > this->font->lineHeight))){
				HX_STACK_LINE(103)
				this->font->lineHeight = h;
			}
			struct _Function_3_1{
				inline static Dynamic Block( int &w,int &h){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/res/FontBuilder.hx",104,0x2e36497c)
					{
						hx::Anon __result = hx::Anon_obj::Create();
						__result->Add(HX_CSTRING("w") , w,false);
						__result->Add(HX_CSTRING("h") , h,false);
						return __result;
					}
					return null();
				}
			};
			HX_STACK_LINE(104)
			hx::IndexRef((sizes).mPtr,i) = _Function_3_1::Block(w,h);
		}
	}
	HX_STACK_LINE(106)
	int side;		HX_STACK_VAR(side,"side");
	HX_STACK_LINE(106)
	{
		HX_STACK_LINE(106)
		Float f = ::Math_obj::sqrt(surf);		HX_STACK_VAR(f,"f");
		HX_STACK_LINE(106)
		side = ::Math_obj::ceil(f);
	}
	HX_STACK_LINE(107)
	int width = (int)1;		HX_STACK_VAR(width,"width");
	HX_STACK_LINE(108)
	while((true)){
		HX_STACK_LINE(108)
		if ((!(((side > width))))){
			HX_STACK_LINE(108)
			break;
		}
		HX_STACK_LINE(109)
		hx::ShlEq(width,(int)1);
	}
	HX_STACK_LINE(110)
	int height = width;		HX_STACK_VAR(height,"height");
	HX_STACK_LINE(111)
	while((true)){
		HX_STACK_LINE(111)
		if ((!((((int((width * height)) >> int((int)1)) > surf))))){
			HX_STACK_LINE(111)
			break;
		}
		HX_STACK_LINE(112)
		hx::ShrEq(height,(int)1);
	}
	HX_STACK_LINE(113)
	Array< ::Dynamic > all;		HX_STACK_VAR(all,"all");
	HX_STACK_LINE(113)
	::flash::display::BitmapData bmp;		HX_STACK_VAR(bmp,"bmp");
	HX_STACK_LINE(114)
	while((true)){
		HX_STACK_LINE(115)
		::flash::display::BitmapData _g6 = ::flash::display::BitmapData_obj::__new(width,height,true,(int)0,null());		HX_STACK_VAR(_g6,"_g6");
		HX_STACK_LINE(115)
		bmp = _g6;
		HX_STACK_LINE(116)
		bmp->lock();
		HX_STACK_LINE(117)
		::haxe::ds::IntMap _g7 = ::haxe::ds::IntMap_obj::__new();		HX_STACK_VAR(_g7,"_g7");
		HX_STACK_LINE(117)
		this->font->glyphs = _g7;
		HX_STACK_LINE(118)
		all = Array_obj< ::Dynamic >::__new();
		HX_STACK_LINE(119)
		::flash::geom::Matrix m = ::flash::geom::Matrix_obj::__new(null(),null(),null(),null(),null(),null());		HX_STACK_VAR(m,"m");
		HX_STACK_LINE(120)
		int x = (int)0;		HX_STACK_VAR(x,"x");
		HX_STACK_LINE(120)
		int y = (int)0;		HX_STACK_VAR(y,"y");
		HX_STACK_LINE(120)
		int lineH = (int)0;		HX_STACK_VAR(lineH,"lineH");
		HX_STACK_LINE(122)
		{
			HX_STACK_LINE(122)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(122)
			int _g = allCC->length;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(122)
			while((true)){
				HX_STACK_LINE(122)
				if ((!(((_g1 < _g))))){
					HX_STACK_LINE(122)
					break;
				}
				HX_STACK_LINE(122)
				int i = (_g1)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(123)
				Dynamic size = sizes->__GetItem(i);		HX_STACK_VAR(size,"size");
				HX_STACK_LINE(124)
				if (((size == null()))){
					HX_STACK_LINE(124)
					continue;
				}
				HX_STACK_LINE(125)
				int w = size->__Field(HX_CSTRING("w"),true);		HX_STACK_VAR(w,"w");
				HX_STACK_LINE(126)
				int h = size->__Field(HX_CSTRING("h"),true);		HX_STACK_VAR(h,"h");
				HX_STACK_LINE(127)
				if ((((x + w) > width))){
					HX_STACK_LINE(128)
					x = (int)0;
					HX_STACK_LINE(129)
					hx::AddEq(y,(lineH + (int)1));
				}
				HX_STACK_LINE(132)
				if ((((y + h) > height))){
					HX_STACK_LINE(133)
					bmp->dispose();
					HX_STACK_LINE(134)
					bmp = null();
					HX_STACK_LINE(135)
					hx::ShlEq(height,(int)1);
					HX_STACK_LINE(136)
					break;
				}
				HX_STACK_LINE(138)
				m->tx = (x - (int)2);
				HX_STACK_LINE(139)
				m->ty = (y - (int)2);
				HX_STACK_LINE(144)
				::String _g8 = this->options->__Field(HX_CSTRING("chars"),true)->__Field(HX_CSTRING("substr"),true)(allCCBytes->__GetItem(i)->__Field(HX_CSTRING("pos"),true),allCCBytes->__GetItem(i)->__Field(HX_CSTRING("len"),true));		HX_STACK_VAR(_g8,"_g8");
				HX_STACK_LINE(144)
				tf->set_text(_g8);
				HX_STACK_LINE(147)
				::flash::geom::Rectangle _g9 = ::flash::geom::Rectangle_obj::__new(x,y,w,h);		HX_STACK_VAR(_g9,"_g9");
				HX_STACK_LINE(147)
				bmp->fillRect(_g9,(int)0);
				HX_STACK_LINE(148)
				bmp->draw(tf,m,null(),null(),null(),true);
				HX_STACK_LINE(149)
				::h2d::Tile t = ::h2d::Tile_obj::__new(null(),x,y,(w - (int)1),(h - (int)1),null(),null());		HX_STACK_VAR(t,"t");
				HX_STACK_LINE(150)
				all->push(t);
				HX_STACK_LINE(151)
				{
					HX_STACK_LINE(151)
					::h2d::FontChar value = ::h2d::FontChar_obj::__new(t,(w - (int)1));		HX_STACK_VAR(value,"value");
					HX_STACK_LINE(151)
					this->font->glyphs->set(allCC->__get(i),value);
				}
				HX_STACK_LINE(153)
				if (((h > lineH))){
					HX_STACK_LINE(153)
					lineH = h;
				}
				HX_STACK_LINE(154)
				hx::AddEq(x,(w + (int)1));
			}
		}
		HX_STACK_LINE(114)
		if ((!(((bmp == null()))))){
			HX_STACK_LINE(114)
			break;
		}
	}
	HX_STACK_LINE(158)
	::hxd::Pixels pixels = ::hxd::_BitmapData::BitmapData_Impl__obj::nativeGetPixels(bmp);		HX_STACK_VAR(pixels,"pixels");
	HX_STACK_LINE(159)
	bmp->dispose();
	HX_STACK_LINE(162)
	pixels->convert(::hxd::PixelFormat_obj::BGRA);
	HX_STACK_LINE(178)
	if (((this->innerTex == null()))){
		HX_STACK_LINE(179)
		::h3d::mat::Texture _g10 = ::h3d::mat::Texture_obj::fromPixels(pixels,hx::SourceInfo(HX_CSTRING("FontBuilder.hx"),179,HX_CSTRING("hxd.res.FontBuilder"),HX_CSTRING("build")));		HX_STACK_VAR(_g10,"_g10");
		HX_STACK_LINE(179)
		this->innerTex = _g10;
		HX_STACK_LINE(180)
		::h2d::Tile _g11 = ::h2d::Tile_obj::fromTexture(this->innerTex);		HX_STACK_VAR(_g11,"_g11");
		HX_STACK_LINE(180)
		this->font->tile = _g11;
		HX_STACK_LINE(181)
		{
			HX_STACK_LINE(181)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(181)
			while((true)){
				HX_STACK_LINE(181)
				if ((!(((_g < all->length))))){
					HX_STACK_LINE(181)
					break;
				}
				HX_STACK_LINE(181)
				::h2d::Tile t = all->__get(_g).StaticCast< ::h2d::Tile >();		HX_STACK_VAR(t,"t");
				HX_STACK_LINE(181)
				++(_g);
				HX_STACK_LINE(182)
				t->setTexture(this->innerTex);
			}
		}
		HX_STACK_LINE(183)
		this->innerTex->onContextLost = this->build_dyn();
	}
	else{
		HX_STACK_LINE(185)
		this->innerTex->uploadPixels(pixels,null(),null());
	}
	HX_STACK_LINE(186)
	pixels->dispose();
	HX_STACK_LINE(187)
	return this->font;
}


HX_DEFINE_DYNAMIC_FUNC0(FontBuilder_obj,build,return )

::h2d::Font FontBuilder_obj::getFont( ::String name,int size,Dynamic options){
	HX_STACK_FRAME("hxd.res.FontBuilder","getFont",0x53b7d2db,"hxd.res.FontBuilder.getFont","hxd/res/FontBuilder.hx",199,0x2e36497c)
	HX_STACK_ARG(name,"name")
	HX_STACK_ARG(size,"size")
	HX_STACK_ARG(options,"options")
	HX_STACK_LINE(200)
	::String key = ((name + HX_CSTRING("#")) + size);		HX_STACK_VAR(key,"key");
	HX_STACK_LINE(201)
	::h2d::Font f = ::hxd::res::FontBuilder_obj::FONTS->get(key);		HX_STACK_VAR(f,"f");
	HX_STACK_LINE(202)
	if (((  (((bool((f != null())) && bool((f->tile->innerTex != null()))))) ? bool(!(f->tile->innerTex->isDisposed())) : bool(false) ))){
		HX_STACK_LINE(203)
		return f;
	}
	HX_STACK_LINE(204)
	::h2d::Font _g = ::hxd::res::FontBuilder_obj::__new(name,size,options)->build();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(204)
	f = _g;
	HX_STACK_LINE(205)
	::hxd::res::FontBuilder_obj::FONTS->set(key,f);
	HX_STACK_LINE(206)
	return f;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(FontBuilder_obj,getFont,return )

Void FontBuilder_obj::dispose( ){
{
		HX_STACK_FRAME("hxd.res.FontBuilder","dispose",0xf8c145f5,"hxd.res.FontBuilder.dispose","hxd/res/FontBuilder.hx",209,0x2e36497c)
		HX_STACK_LINE(210)
		for(::cpp::FastIterator_obj< ::h2d::Font > *__it = ::cpp::CreateFastIterator< ::h2d::Font >(::hxd::res::FontBuilder_obj::FONTS->iterator());  __it->hasNext(); ){
			::h2d::Font f = __it->next();
			f->dispose();
		}
		HX_STACK_LINE(212)
		::haxe::ds::StringMap _g = ::haxe::ds::StringMap_obj::__new();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(212)
		::hxd::res::FontBuilder_obj::FONTS = _g;
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(FontBuilder_obj,dispose,(void))

::haxe::ds::StringMap FontBuilder_obj::FONTS;


FontBuilder_obj::FontBuilder_obj()
{
}

void FontBuilder_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(FontBuilder);
	HX_MARK_MEMBER_NAME(font,"font");
	HX_MARK_MEMBER_NAME(options,"options");
	HX_MARK_MEMBER_NAME(innerTex,"innerTex");
	HX_MARK_END_CLASS();
}

void FontBuilder_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(font,"font");
	HX_VISIT_MEMBER_NAME(options,"options");
	HX_VISIT_MEMBER_NAME(innerTex,"innerTex");
}

Dynamic FontBuilder_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"font") ) { return font; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"FONTS") ) { return FONTS; }
		if (HX_FIELD_EQ(inName,"build") ) { return build_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"getFont") ) { return getFont_dyn(); }
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		if (HX_FIELD_EQ(inName,"options") ) { return options; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"innerTex") ) { return innerTex; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"isolateUtf8Blocs") ) { return isolateUtf8Blocs_dyn(); }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"getUtf8StringAsArray") ) { return getUtf8StringAsArray_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic FontBuilder_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"font") ) { font=inValue.Cast< ::h2d::Font >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"FONTS") ) { FONTS=inValue.Cast< ::haxe::ds::StringMap >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"options") ) { options=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"innerTex") ) { innerTex=inValue.Cast< ::h3d::mat::Texture >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void FontBuilder_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("font"));
	outFields->push(HX_CSTRING("options"));
	outFields->push(HX_CSTRING("innerTex"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("getFont"),
	HX_CSTRING("dispose"),
	HX_CSTRING("FONTS"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h2d::Font*/ ,(int)offsetof(FontBuilder_obj,font),HX_CSTRING("font")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(FontBuilder_obj,options),HX_CSTRING("options")},
	{hx::fsObject /*::h3d::mat::Texture*/ ,(int)offsetof(FontBuilder_obj,innerTex),HX_CSTRING("innerTex")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("font"),
	HX_CSTRING("options"),
	HX_CSTRING("innerTex"),
	HX_CSTRING("getUtf8StringAsArray"),
	HX_CSTRING("isolateUtf8Blocs"),
	HX_CSTRING("build"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FontBuilder_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(FontBuilder_obj::FONTS,"FONTS");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FontBuilder_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(FontBuilder_obj::FONTS,"FONTS");
};

#endif

Class FontBuilder_obj::__mClass;

void FontBuilder_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.res.FontBuilder"), hx::TCanCast< FontBuilder_obj> ,sStaticFields,sMemberFields,
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

void FontBuilder_obj::__boot()
{
	FONTS= ::haxe::ds::StringMap_obj::__new();
}

} // end namespace hxd
} // end namespace res
