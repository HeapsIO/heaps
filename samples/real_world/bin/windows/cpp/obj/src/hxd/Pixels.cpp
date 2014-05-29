#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_flash_Memory
#include <flash/Memory.h>
#endif
#ifndef INCLUDED_haxe_Log
#include <haxe/Log.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_hxd_Assert
#include <hxd/Assert.h>
#endif
#ifndef INCLUDED_hxd_Flags
#include <hxd/Flags.h>
#endif
#ifndef INCLUDED_hxd_PixelFormat
#include <hxd/PixelFormat.h>
#endif
#ifndef INCLUDED_hxd_Pixels
#include <hxd/Pixels.h>
#endif
#ifndef INCLUDED_hxd_System
#include <hxd/System.h>
#endif
#ifndef INCLUDED_hxd_impl_Memory
#include <hxd/impl/Memory.h>
#endif
#ifndef INCLUDED_hxd_impl_MemoryReader
#include <hxd/impl/MemoryReader.h>
#endif
#ifndef INCLUDED_hxd_impl_Tmp
#include <hxd/impl/Tmp.h>
#endif
namespace hxd{

Void Pixels_obj::__construct(int width,int height,::haxe::io::Bytes bytes,::hxd::PixelFormat format,Dynamic __o_offset)
{
HX_STACK_FRAME("hxd.Pixels","new",0xf7a4f999,"hxd.Pixels.new","hxd/Pixels.hx",24,0x892673d6)
HX_STACK_THIS(this)
HX_STACK_ARG(width,"width")
HX_STACK_ARG(height,"height")
HX_STACK_ARG(bytes,"bytes")
HX_STACK_ARG(format,"format")
HX_STACK_ARG(__o_offset,"offset")
Dynamic offset = __o_offset.Default(0);
{
	HX_STACK_LINE(25)
	::hxd::Assert_obj::notNull(bytes,null());
	HX_STACK_LINE(26)
	this->width = width;
	HX_STACK_LINE(27)
	this->height = height;
	HX_STACK_LINE(28)
	this->bytes = bytes;
	HX_STACK_LINE(29)
	this->format = format;
	HX_STACK_LINE(30)
	this->offset = offset;
}
;
	return null();
}

//Pixels_obj::~Pixels_obj() { }

Dynamic Pixels_obj::__CreateEmpty() { return  new Pixels_obj; }
hx::ObjectPtr< Pixels_obj > Pixels_obj::__new(int width,int height,::haxe::io::Bytes bytes,::hxd::PixelFormat format,Dynamic __o_offset)
{  hx::ObjectPtr< Pixels_obj > result = new Pixels_obj();
	result->__construct(width,height,bytes,format,__o_offset);
	return result;}

Dynamic Pixels_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Pixels_obj > result = new Pixels_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4]);
	return result;}

::hxd::Pixels Pixels_obj::makeSquare( Dynamic copy){
	HX_STACK_FRAME("hxd.Pixels","makeSquare",0x80133512,"hxd.Pixels.makeSquare","hxd/Pixels.hx",33,0x892673d6)
	HX_STACK_THIS(this)
	HX_STACK_ARG(copy,"copy")
	HX_STACK_LINE(34)
	int w = this->width;		HX_STACK_VAR(w,"w");
	HX_STACK_LINE(34)
	int h = this->height;		HX_STACK_VAR(h,"h");
	HX_STACK_LINE(35)
	int tw;		HX_STACK_VAR(tw,"tw");
	HX_STACK_LINE(35)
	if (((w == (int)0))){
		HX_STACK_LINE(35)
		tw = (int)0;
	}
	else{
		HX_STACK_LINE(35)
		tw = (int)1;
	}
	HX_STACK_LINE(35)
	int th;		HX_STACK_VAR(th,"th");
	HX_STACK_LINE(35)
	if (((h == (int)0))){
		HX_STACK_LINE(35)
		th = (int)0;
	}
	else{
		HX_STACK_LINE(35)
		th = (int)1;
	}
	HX_STACK_LINE(36)
	while((true)){
		HX_STACK_LINE(36)
		if ((!(((tw < w))))){
			HX_STACK_LINE(36)
			break;
		}
		HX_STACK_LINE(36)
		hx::ShlEq(tw,(int)1);
	}
	HX_STACK_LINE(37)
	while((true)){
		HX_STACK_LINE(37)
		if ((!(((th < h))))){
			HX_STACK_LINE(37)
			break;
		}
		HX_STACK_LINE(37)
		hx::ShlEq(th,(int)1);
	}
	HX_STACK_LINE(38)
	if (((bool((w == tw)) && bool((h == th))))){
		HX_STACK_LINE(38)
		return hx::ObjectPtr<OBJ_>(this);
	}
	HX_STACK_LINE(40)
	int _g = ::hxd::Flags_obj::NO_CONVERSION->__Index();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(40)
	int _g1 = (int((int)1) << int(_g));		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(40)
	int _g2 = (int(this->flags) & int(_g1));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(40)
	if (((_g2 != (int)0))){
		HX_STACK_LINE(41)
		{
			HX_STACK_LINE(41)
			::String pos_fileName = HX_CSTRING("Pixels.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
			HX_STACK_LINE(41)
			int pos_lineNumber = (int)41;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
			HX_STACK_LINE(41)
			::String pos_className = HX_CSTRING("hxd.Pixels");		HX_STACK_VAR(pos_className,"pos_className");
			HX_STACK_LINE(41)
			::String pos_methodName = HX_CSTRING("makeSquare");		HX_STACK_VAR(pos_methodName,"pos_methodName");
			HX_STACK_LINE(41)
			if (((::hxd::System_obj::debugLevel >= (int)1))){
				HX_STACK_LINE(41)
				::String _g3 = HX_CSTRING("makeSquare::texture bits cant be modified");		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(41)
				::String _g4 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g3);		HX_STACK_VAR(_g4,"_g4");
				HX_STACK_LINE(41)
				::haxe::Log_obj::trace(_g4,hx::SourceInfo(HX_CSTRING("System.hx"),305,HX_CSTRING("hxd.System"),HX_CSTRING("trace1")));
			}
			HX_STACK_LINE(41)
			HX_CSTRING("makeSquare::texture bits cant be modified");
		}
		HX_STACK_LINE(42)
		return hx::ObjectPtr<OBJ_>(this);
	}
	HX_STACK_LINE(44)
	::haxe::io::Bytes out = ::hxd::impl::Tmp_obj::getBytes(((tw * th) * (int)4));		HX_STACK_VAR(out,"out");
	HX_STACK_LINE(45)
	int p = (int)0;		HX_STACK_VAR(p,"p");
	HX_STACK_LINE(45)
	int b = (int)0;		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(46)
	{
		HX_STACK_LINE(46)
		int _g3 = (int)0;		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(46)
		while((true)){
			HX_STACK_LINE(46)
			if ((!(((_g3 < h))))){
				HX_STACK_LINE(46)
				break;
			}
			HX_STACK_LINE(46)
			int y = (_g3)++;		HX_STACK_VAR(y,"y");
			HX_STACK_LINE(47)
			out->blit(p,this->bytes,(b + this->offset),(w * (int)4));
			HX_STACK_LINE(48)
			hx::AddEq(p,(w * (int)4));
			HX_STACK_LINE(49)
			hx::AddEq(b,(w * (int)4));
			HX_STACK_LINE(50)
			{
				HX_STACK_LINE(50)
				int _g21 = (int)0;		HX_STACK_VAR(_g21,"_g21");
				HX_STACK_LINE(50)
				int _g11 = (((tw - w)) * (int)4);		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(50)
				while((true)){
					HX_STACK_LINE(50)
					if ((!(((_g21 < _g11))))){
						HX_STACK_LINE(50)
						break;
					}
					HX_STACK_LINE(50)
					int i = (_g21)++;		HX_STACK_VAR(i,"i");
					HX_STACK_LINE(51)
					int pos = (p)++;		HX_STACK_VAR(pos,"pos");
					HX_STACK_LINE(51)
					out->b[pos] = (int)0;
				}
			}
		}
	}
	HX_STACK_LINE(53)
	{
		HX_STACK_LINE(53)
		int _g11 = (int)0;		HX_STACK_VAR(_g11,"_g11");
		HX_STACK_LINE(53)
		int _g3 = ((((th - h)) * tw) * (int)4);		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(53)
		while((true)){
			HX_STACK_LINE(53)
			if ((!(((_g11 < _g3))))){
				HX_STACK_LINE(53)
				break;
			}
			HX_STACK_LINE(53)
			int i = (_g11)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(54)
			int pos = (p)++;		HX_STACK_VAR(pos,"pos");
			HX_STACK_LINE(54)
			out->b[pos] = (int)0;
		}
	}
	HX_STACK_LINE(55)
	if ((copy)){
		HX_STACK_LINE(56)
		return ::hxd::Pixels_obj::__new(tw,th,out,this->format,null());
	}
	HX_STACK_LINE(57)
	::hxd::impl::Tmp_obj::saveBytes(this->bytes);
	HX_STACK_LINE(58)
	this->bytes = out;
	HX_STACK_LINE(59)
	this->width = tw;
	HX_STACK_LINE(60)
	this->height = th;
	HX_STACK_LINE(61)
	return hx::ObjectPtr<OBJ_>(this);
}


HX_DEFINE_DYNAMIC_FUNC1(Pixels_obj,makeSquare,return )

bool Pixels_obj::convert( ::hxd::PixelFormat target){
	HX_STACK_FRAME("hxd.Pixels","convert",0xce3ab7ac,"hxd.Pixels.convert","hxd/Pixels.hx",68,0x892673d6)
	HX_STACK_THIS(this)
	HX_STACK_ARG(target,"target")
	HX_STACK_LINE(69)
	if (((this->format == target))){
		HX_STACK_LINE(70)
		{
			HX_STACK_LINE(70)
			::String pos_fileName = HX_CSTRING("Pixels.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
			HX_STACK_LINE(70)
			int pos_lineNumber = (int)70;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
			HX_STACK_LINE(70)
			::String pos_className = HX_CSTRING("hxd.Pixels");		HX_STACK_VAR(pos_className,"pos_className");
			HX_STACK_LINE(70)
			::String pos_methodName = HX_CSTRING("convert");		HX_STACK_VAR(pos_methodName,"pos_methodName");
			HX_STACK_LINE(70)
			if (((::hxd::System_obj::debugLevel >= (int)1))){
				HX_STACK_LINE(70)
				::String _g = HX_CSTRING("already good format");		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(70)
				::String _g1 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g);		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(70)
				::haxe::Log_obj::trace(_g1,hx::SourceInfo(HX_CSTRING("System.hx"),305,HX_CSTRING("hxd.System"),HX_CSTRING("trace1")));
			}
			HX_STACK_LINE(70)
			HX_CSTRING("already good format");
		}
		HX_STACK_LINE(71)
		return false;
	}
	HX_STACK_LINE(74)
	int _g2 = ::hxd::Flags_obj::NO_CONVERSION->__Index();		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(74)
	int _g3 = (int((int)1) << int(_g2));		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(74)
	int _g4 = (int(this->flags) & int(_g3));		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(74)
	if (((_g4 != (int)0))){
		HX_STACK_LINE(75)
		{
			HX_STACK_LINE(75)
			::String pos_fileName = HX_CSTRING("Pixels.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
			HX_STACK_LINE(75)
			int pos_lineNumber = (int)75;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
			HX_STACK_LINE(75)
			::String pos_className = HX_CSTRING("hxd.Pixels");		HX_STACK_VAR(pos_className,"pos_className");
			HX_STACK_LINE(75)
			::String pos_methodName = HX_CSTRING("convert");		HX_STACK_VAR(pos_methodName,"pos_methodName");
			HX_STACK_LINE(75)
			if (((::hxd::System_obj::debugLevel >= (int)1))){
				HX_STACK_LINE(75)
				::String _g5 = HX_CSTRING("convert::texture bits cant be modified");		HX_STACK_VAR(_g5,"_g5");
				HX_STACK_LINE(75)
				::String _g6 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g5);		HX_STACK_VAR(_g6,"_g6");
				HX_STACK_LINE(75)
				::haxe::Log_obj::trace(_g6,hx::SourceInfo(HX_CSTRING("System.hx"),305,HX_CSTRING("hxd.System"),HX_CSTRING("trace1")));
			}
			HX_STACK_LINE(75)
			HX_CSTRING("convert::texture bits cant be modified");
		}
		HX_STACK_LINE(76)
		return false;
	}
	HX_STACK_LINE(79)
	{
		HX_STACK_LINE(79)
		::hxd::PixelFormat _g = this->format;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(79)
		switch( (int)(_g->__Index())){
			case (int)1: {
				HX_STACK_LINE(79)
				switch( (int)(target->__Index())){
					case (int)0: {
						HX_STACK_LINE(82)
						::hxd::impl::MemoryReader mem = ::hxd::impl::Memory_obj::select(this->bytes);		HX_STACK_VAR(mem,"mem");
						HX_STACK_LINE(83)
						{
							HX_STACK_LINE(83)
							int _g21 = (int)0;		HX_STACK_VAR(_g21,"_g21");
							HX_STACK_LINE(83)
							int _g1 = (this->width * this->height);		HX_STACK_VAR(_g1,"_g1");
							HX_STACK_LINE(83)
							while((true)){
								HX_STACK_LINE(83)
								if ((!(((_g21 < _g1))))){
									HX_STACK_LINE(83)
									break;
								}
								HX_STACK_LINE(83)
								int i = (_g21)++;		HX_STACK_VAR(i,"i");
								HX_STACK_LINE(84)
								int p = (((int(i) << int((int)2))) + this->offset);		HX_STACK_VAR(p,"p");
								HX_STACK_LINE(85)
								int a = ::flash::Memory_obj::getByte(p);		HX_STACK_VAR(a,"a");
								HX_STACK_LINE(86)
								int r = ::flash::Memory_obj::getByte((p + (int)1));		HX_STACK_VAR(r,"r");
								HX_STACK_LINE(87)
								int g = ::flash::Memory_obj::getByte((p + (int)2));		HX_STACK_VAR(g,"g");
								HX_STACK_LINE(88)
								int b = ::flash::Memory_obj::getByte((p + (int)3));		HX_STACK_VAR(b,"b");
								HX_STACK_LINE(89)
								::flash::Memory_obj::setByte(p,b);
								HX_STACK_LINE(90)
								::flash::Memory_obj::setByte((p + (int)1),g);
								HX_STACK_LINE(91)
								::flash::Memory_obj::setByte((p + (int)2),r);
								HX_STACK_LINE(92)
								::flash::Memory_obj::setByte((p + (int)3),a);
							}
						}
						HX_STACK_LINE(94)
						::hxd::impl::Memory_obj::end();
					}
					;break;
					case (int)2: {
						HX_STACK_LINE(96)
						::hxd::impl::MemoryReader mem = ::hxd::impl::Memory_obj::select(this->bytes);		HX_STACK_VAR(mem,"mem");
						HX_STACK_LINE(97)
						{
							HX_STACK_LINE(97)
							int _g21 = (int)0;		HX_STACK_VAR(_g21,"_g21");
							HX_STACK_LINE(97)
							int _g1 = (this->width * this->height);		HX_STACK_VAR(_g1,"_g1");
							HX_STACK_LINE(97)
							while((true)){
								HX_STACK_LINE(97)
								if ((!(((_g21 < _g1))))){
									HX_STACK_LINE(97)
									break;
								}
								HX_STACK_LINE(97)
								int i = (_g21)++;		HX_STACK_VAR(i,"i");
								HX_STACK_LINE(98)
								int p = (((int(i) << int((int)2))) + this->offset);		HX_STACK_VAR(p,"p");
								HX_STACK_LINE(99)
								int b = ::flash::Memory_obj::getByte(p);		HX_STACK_VAR(b,"b");
								HX_STACK_LINE(100)
								int r = ::flash::Memory_obj::getByte((p + (int)2));		HX_STACK_VAR(r,"r");
								HX_STACK_LINE(101)
								::flash::Memory_obj::setByte(p,r);
								HX_STACK_LINE(102)
								::flash::Memory_obj::setByte((p + (int)2),b);
							}
						}
						HX_STACK_LINE(104)
						::hxd::impl::Memory_obj::end();
					}
					;break;
					default: {
						HX_STACK_LINE(121)
						::String _g7 = ::Std_obj::string(this->format);		HX_STACK_VAR(_g7,"_g7");
						HX_STACK_LINE(121)
						::String _g8 = (HX_CSTRING("Cannot convert from ") + _g7);		HX_STACK_VAR(_g8,"_g8");
						HX_STACK_LINE(121)
						::String _g9 = (_g8 + HX_CSTRING(" to "));		HX_STACK_VAR(_g9,"_g9");
						HX_STACK_LINE(121)
						::String _g10 = ::Std_obj::string(target);		HX_STACK_VAR(_g10,"_g10");
						HX_STACK_LINE(121)
						HX_STACK_DO_THROW((_g9 + _g10));
					}
				}
			}
			;break;
			case (int)0: {
				HX_STACK_LINE(79)
				switch( (int)(target->__Index())){
					case (int)1: {
						HX_STACK_LINE(82)
						::hxd::impl::MemoryReader mem = ::hxd::impl::Memory_obj::select(this->bytes);		HX_STACK_VAR(mem,"mem");
						HX_STACK_LINE(83)
						{
							HX_STACK_LINE(83)
							int _g21 = (int)0;		HX_STACK_VAR(_g21,"_g21");
							HX_STACK_LINE(83)
							int _g1 = (this->width * this->height);		HX_STACK_VAR(_g1,"_g1");
							HX_STACK_LINE(83)
							while((true)){
								HX_STACK_LINE(83)
								if ((!(((_g21 < _g1))))){
									HX_STACK_LINE(83)
									break;
								}
								HX_STACK_LINE(83)
								int i = (_g21)++;		HX_STACK_VAR(i,"i");
								HX_STACK_LINE(84)
								int p = (((int(i) << int((int)2))) + this->offset);		HX_STACK_VAR(p,"p");
								HX_STACK_LINE(85)
								int a = ::flash::Memory_obj::getByte(p);		HX_STACK_VAR(a,"a");
								HX_STACK_LINE(86)
								int r = ::flash::Memory_obj::getByte((p + (int)1));		HX_STACK_VAR(r,"r");
								HX_STACK_LINE(87)
								int g = ::flash::Memory_obj::getByte((p + (int)2));		HX_STACK_VAR(g,"g");
								HX_STACK_LINE(88)
								int b = ::flash::Memory_obj::getByte((p + (int)3));		HX_STACK_VAR(b,"b");
								HX_STACK_LINE(89)
								::flash::Memory_obj::setByte(p,b);
								HX_STACK_LINE(90)
								::flash::Memory_obj::setByte((p + (int)1),g);
								HX_STACK_LINE(91)
								::flash::Memory_obj::setByte((p + (int)2),r);
								HX_STACK_LINE(92)
								::flash::Memory_obj::setByte((p + (int)3),a);
							}
						}
						HX_STACK_LINE(94)
						::hxd::impl::Memory_obj::end();
					}
					;break;
					case (int)2: {
						HX_STACK_LINE(107)
						::hxd::impl::MemoryReader mem = ::hxd::impl::Memory_obj::select(this->bytes);		HX_STACK_VAR(mem,"mem");
						HX_STACK_LINE(108)
						{
							HX_STACK_LINE(108)
							int _g21 = (int)0;		HX_STACK_VAR(_g21,"_g21");
							HX_STACK_LINE(108)
							int _g1 = (this->width * this->height);		HX_STACK_VAR(_g1,"_g1");
							HX_STACK_LINE(108)
							while((true)){
								HX_STACK_LINE(108)
								if ((!(((_g21 < _g1))))){
									HX_STACK_LINE(108)
									break;
								}
								HX_STACK_LINE(108)
								int i = (_g21)++;		HX_STACK_VAR(i,"i");
								HX_STACK_LINE(109)
								int p = (((int(i) << int((int)2))) + this->offset);		HX_STACK_VAR(p,"p");
								HX_STACK_LINE(110)
								int a = ::flash::Memory_obj::getByte(p);		HX_STACK_VAR(a,"a");
								HX_STACK_LINE(112)
								{
									HX_STACK_LINE(112)
									int v = ::flash::Memory_obj::getByte((p + (int)1));		HX_STACK_VAR(v,"v");
									HX_STACK_LINE(112)
									::flash::Memory_obj::setByte(p,v);
								}
								HX_STACK_LINE(113)
								{
									HX_STACK_LINE(113)
									int v = ::flash::Memory_obj::getByte((p + (int)2));		HX_STACK_VAR(v,"v");
									HX_STACK_LINE(113)
									::flash::Memory_obj::setByte((p + (int)1),v);
								}
								HX_STACK_LINE(114)
								{
									HX_STACK_LINE(114)
									int v = ::flash::Memory_obj::getByte((p + (int)3));		HX_STACK_VAR(v,"v");
									HX_STACK_LINE(114)
									::flash::Memory_obj::setByte((p + (int)2),v);
								}
								HX_STACK_LINE(115)
								::flash::Memory_obj::setByte((p + (int)3),a);
							}
						}
						HX_STACK_LINE(117)
						::hxd::impl::Memory_obj::end();
					}
					;break;
					default: {
						HX_STACK_LINE(121)
						::String _g11 = ::Std_obj::string(this->format);		HX_STACK_VAR(_g11,"_g11");
						HX_STACK_LINE(121)
						::String _g12 = (HX_CSTRING("Cannot convert from ") + _g11);		HX_STACK_VAR(_g12,"_g12");
						HX_STACK_LINE(121)
						::String _g13 = (_g12 + HX_CSTRING(" to "));		HX_STACK_VAR(_g13,"_g13");
						HX_STACK_LINE(121)
						::String _g14 = ::Std_obj::string(target);		HX_STACK_VAR(_g14,"_g14");
						HX_STACK_LINE(121)
						HX_STACK_DO_THROW((_g13 + _g14));
					}
				}
			}
			;break;
			default: {
				HX_STACK_LINE(121)
				::String _g15 = ::Std_obj::string(this->format);		HX_STACK_VAR(_g15,"_g15");
				HX_STACK_LINE(121)
				::String _g16 = (HX_CSTRING("Cannot convert from ") + _g15);		HX_STACK_VAR(_g16,"_g16");
				HX_STACK_LINE(121)
				::String _g17 = (_g16 + HX_CSTRING(" to "));		HX_STACK_VAR(_g17,"_g17");
				HX_STACK_LINE(121)
				::String _g18 = ::Std_obj::string(target);		HX_STACK_VAR(_g18,"_g18");
				HX_STACK_LINE(121)
				HX_STACK_DO_THROW((_g17 + _g18));
			}
		}
	}
	HX_STACK_LINE(123)
	this->format = target;
	HX_STACK_LINE(124)
	return true;
}


HX_DEFINE_DYNAMIC_FUNC1(Pixels_obj,convert,return )

int Pixels_obj::getPixel( int x,int y){
	HX_STACK_FRAME("hxd.Pixels","getPixel",0x71ac9e37,"hxd.Pixels.getPixel","hxd/Pixels.hx",129,0x892673d6)
	HX_STACK_THIS(this)
	HX_STACK_ARG(x,"x")
	HX_STACK_ARG(y,"y")
	HX_STACK_LINE(129)
	::hxd::PixelFormat _g = this->format;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(129)
	switch( (int)(_g->__Index())){
		case (int)0: case (int)1: case (int)2: {
			HX_STACK_LINE(131)
			int u = (int)0;		HX_STACK_VAR(u,"u");
			HX_STACK_LINE(132)
			int p = (((int)4 * (((y * this->width) + x))) + this->offset);		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(133)
			hx::OrEq(u,this->bytes->b->__get(p));
			HX_STACK_LINE(134)
			hx::OrEq(u,(int(this->bytes->b->__get((p + (int)1))) << int((int)8)));
			HX_STACK_LINE(135)
			hx::OrEq(u,(int(this->bytes->b->__get((p + (int)2))) << int((int)16)));
			HX_STACK_LINE(136)
			hx::OrEq(u,(int(this->bytes->b->__get((p + (int)3))) << int((int)24)));
			HX_STACK_LINE(137)
			return u;
		}
		;break;
	}
	HX_STACK_LINE(129)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Pixels_obj,getPixel,return )

Void Pixels_obj::dispose( ){
{
		HX_STACK_FRAME("hxd.Pixels","dispose",0x6ebd3a58,"hxd.Pixels.dispose","hxd/Pixels.hx",142,0x892673d6)
		HX_STACK_THIS(this)
		struct _Function_1_1{
			inline static bool Block( hx::ObjectPtr< ::hxd::Pixels_obj > __this){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/Pixels.hx",142,0x892673d6)
				{
					HX_STACK_LINE(142)
					int _g = ::hxd::Flags_obj::NO_REUSE->__Index();		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(142)
					int _g1 = (int((int)1) << int(_g));		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(142)
					int _g2 = (int(__this->flags) & int(_g1));		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(142)
					return !(((_g2 != (int)0)));
				}
				return null();
			}
		};
		HX_STACK_LINE(142)
		if (((  (((this->bytes != null()))) ? bool(_Function_1_1::Block(this)) : bool(false) ))){
			HX_STACK_LINE(143)
			::hxd::impl::Tmp_obj::saveBytes(this->bytes);
			HX_STACK_LINE(144)
			this->bytes = null();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Pixels_obj,dispose,(void))

int Pixels_obj::bytesPerPixel( ::hxd::PixelFormat format){
	HX_STACK_FRAME("hxd.Pixels","bytesPerPixel",0xf547126d,"hxd.Pixels.bytesPerPixel","hxd/Pixels.hx",149,0x892673d6)
	HX_STACK_ARG(format,"format")
	HX_STACK_LINE(149)
	switch( (int)(format->__Index())){
		case (int)0: case (int)1: case (int)2: {
			HX_STACK_LINE(150)
			return (int)4;
		}
		;break;
	}
	HX_STACK_LINE(149)
	return (int)0;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Pixels_obj,bytesPerPixel,return )

::hxd::Pixels Pixels_obj::alloc( int width,int height,::hxd::PixelFormat format){
	HX_STACK_FRAME("hxd.Pixels","alloc",0x6e6c4dee,"hxd.Pixels.alloc","hxd/Pixels.hx",154,0x892673d6)
	HX_STACK_ARG(width,"width")
	HX_STACK_ARG(height,"height")
	HX_STACK_ARG(format,"format")
	HX_STACK_LINE(155)
	int _g = ::hxd::Pixels_obj::bytesPerPixel(format);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(155)
	int _g1 = ((width * height) * _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(155)
	::haxe::io::Bytes _g2 = ::hxd::impl::Tmp_obj::getBytes(_g1);		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(155)
	return ::hxd::Pixels_obj::__new(width,height,_g2,format,null());
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Pixels_obj,alloc,return )


Pixels_obj::Pixels_obj()
{
}

void Pixels_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Pixels);
	HX_MARK_MEMBER_NAME(bytes,"bytes");
	HX_MARK_MEMBER_NAME(format,"format");
	HX_MARK_MEMBER_NAME(width,"width");
	HX_MARK_MEMBER_NAME(height,"height");
	HX_MARK_MEMBER_NAME(offset,"offset");
	HX_MARK_MEMBER_NAME(flags,"flags");
	HX_MARK_END_CLASS();
}

void Pixels_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(bytes,"bytes");
	HX_VISIT_MEMBER_NAME(format,"format");
	HX_VISIT_MEMBER_NAME(width,"width");
	HX_VISIT_MEMBER_NAME(height,"height");
	HX_VISIT_MEMBER_NAME(offset,"offset");
	HX_VISIT_MEMBER_NAME(flags,"flags");
}

Dynamic Pixels_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"alloc") ) { return alloc_dyn(); }
		if (HX_FIELD_EQ(inName,"bytes") ) { return bytes; }
		if (HX_FIELD_EQ(inName,"width") ) { return width; }
		if (HX_FIELD_EQ(inName,"flags") ) { return flags; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"format") ) { return format; }
		if (HX_FIELD_EQ(inName,"height") ) { return height; }
		if (HX_FIELD_EQ(inName,"offset") ) { return offset; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"convert") ) { return convert_dyn(); }
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"getPixel") ) { return getPixel_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"makeSquare") ) { return makeSquare_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"bytesPerPixel") ) { return bytesPerPixel_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Pixels_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"bytes") ) { bytes=inValue.Cast< ::haxe::io::Bytes >(); return inValue; }
		if (HX_FIELD_EQ(inName,"width") ) { width=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"flags") ) { flags=inValue.Cast< int >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"format") ) { format=inValue.Cast< ::hxd::PixelFormat >(); return inValue; }
		if (HX_FIELD_EQ(inName,"height") ) { height=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"offset") ) { offset=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Pixels_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("bytes"));
	outFields->push(HX_CSTRING("format"));
	outFields->push(HX_CSTRING("width"));
	outFields->push(HX_CSTRING("height"));
	outFields->push(HX_CSTRING("offset"));
	outFields->push(HX_CSTRING("flags"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("bytesPerPixel"),
	HX_CSTRING("alloc"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::haxe::io::Bytes*/ ,(int)offsetof(Pixels_obj,bytes),HX_CSTRING("bytes")},
	{hx::fsObject /*::hxd::PixelFormat*/ ,(int)offsetof(Pixels_obj,format),HX_CSTRING("format")},
	{hx::fsInt,(int)offsetof(Pixels_obj,width),HX_CSTRING("width")},
	{hx::fsInt,(int)offsetof(Pixels_obj,height),HX_CSTRING("height")},
	{hx::fsInt,(int)offsetof(Pixels_obj,offset),HX_CSTRING("offset")},
	{hx::fsInt,(int)offsetof(Pixels_obj,flags),HX_CSTRING("flags")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("bytes"),
	HX_CSTRING("format"),
	HX_CSTRING("width"),
	HX_CSTRING("height"),
	HX_CSTRING("offset"),
	HX_CSTRING("flags"),
	HX_CSTRING("makeSquare"),
	HX_CSTRING("convert"),
	HX_CSTRING("getPixel"),
	HX_CSTRING("dispose"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Pixels_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Pixels_obj::__mClass,"__mClass");
};

#endif

Class Pixels_obj::__mClass;

void Pixels_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.Pixels"), hx::TCanCast< Pixels_obj> ,sStaticFields,sMemberFields,
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

void Pixels_obj::__boot()
{
}

} // end namespace hxd
