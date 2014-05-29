#include <hxcpp.h>

#ifndef INCLUDED_flash_display_BitmapData
#include <flash/display/BitmapData.h>
#endif
#ifndef INCLUDED_flash_display_IBitmapDrawable
#include <flash/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
#endif
#ifndef INCLUDED_h3d_impl_Driver
#include <h3d/impl/Driver.h>
#endif
#ifndef INCLUDED_h3d_impl_MemoryManager
#include <h3d/impl/MemoryManager.h>
#endif
#ifndef INCLUDED_h3d_mat_Filter
#include <h3d/mat/Filter.h>
#endif
#ifndef INCLUDED_h3d_mat_MipMap
#include <h3d/mat/MipMap.h>
#endif
#ifndef INCLUDED_h3d_mat_Texture
#include <h3d/mat/Texture.h>
#endif
#ifndef INCLUDED_h3d_mat_TextureFormat
#include <h3d/mat/TextureFormat.h>
#endif
#ifndef INCLUDED_h3d_mat_Wrap
#include <h3d/mat/Wrap.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
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
#ifndef INCLUDED_openfl_gl_GLObject
#include <openfl/gl/GLObject.h>
#endif
#ifndef INCLUDED_openfl_gl_GLTexture
#include <openfl/gl/GLTexture.h>
#endif
namespace h3d{
namespace mat{

Void Texture_obj::__construct(::h3d::impl::MemoryManager m,::h3d::mat::TextureFormat fmt,int w,int h,bool c,bool ta,int mm)
{
HX_STACK_FRAME("h3d.mat.Texture","new",0x1620752a,"h3d.mat.Texture.new","h3d/mat/Texture.hx",6,0x24dfe888)
HX_STACK_THIS(this)
HX_STACK_ARG(m,"m")
HX_STACK_ARG(fmt,"fmt")
HX_STACK_ARG(w,"w")
HX_STACK_ARG(h,"h")
HX_STACK_ARG(c,"c")
HX_STACK_ARG(ta,"ta")
HX_STACK_ARG(mm,"mm")
{
	HX_STACK_LINE(27)
	this->alpha_premultiplied = false;
	HX_STACK_LINE(36)
	int _g = ++(::h3d::mat::Texture_obj::UID);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(36)
	this->id = _g;
	HX_STACK_LINE(37)
	this->format = fmt;
	HX_STACK_LINE(38)
	this->mem = m;
	HX_STACK_LINE(39)
	this->isTarget = ta;
	HX_STACK_LINE(40)
	this->width = w;
	HX_STACK_LINE(41)
	this->height = h;
	HX_STACK_LINE(42)
	this->isCubic = c;
	HX_STACK_LINE(43)
	this->mipLevels = mm;
	HX_STACK_LINE(44)
	this->set_mipMap((  (((mm > (int)0))) ? ::h3d::mat::MipMap(::h3d::mat::MipMap_obj::Nearest) : ::h3d::mat::MipMap(::h3d::mat::MipMap_obj::None) ));
	HX_STACK_LINE(45)
	this->set_filter(::h3d::mat::Filter_obj::Linear);
	HX_STACK_LINE(46)
	this->set_wrap(::h3d::mat::Wrap_obj::Clamp);
	HX_STACK_LINE(47)
	hx::AndEq(this->bits,(int)32767);
}
;
	return null();
}

//Texture_obj::~Texture_obj() { }

Dynamic Texture_obj::__CreateEmpty() { return  new Texture_obj; }
hx::ObjectPtr< Texture_obj > Texture_obj::__new(::h3d::impl::MemoryManager m,::h3d::mat::TextureFormat fmt,int w,int h,bool c,bool ta,int mm)
{  hx::ObjectPtr< Texture_obj > result = new Texture_obj();
	result->__construct(m,fmt,w,h,c,ta,mm);
	return result;}

Dynamic Texture_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Texture_obj > result = new Texture_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4],inArgs[5],inArgs[6]);
	return result;}

::h3d::mat::MipMap Texture_obj::set_mipMap( ::h3d::mat::MipMap m){
	HX_STACK_FRAME("h3d.mat.Texture","set_mipMap",0x36dedc1b,"h3d.mat.Texture.set_mipMap","h3d/mat/Texture.hx",50,0x24dfe888)
	HX_STACK_THIS(this)
	HX_STACK_ARG(m,"m")
	HX_STACK_LINE(51)
	hx::OrEq(this->bits,(int)524288);
	HX_STACK_LINE(52)
	int _g = m->__Index();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(52)
	int _g1 = _g;		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(52)
	int _g2 = (int((int(this->bits) & int((int)-4))) | int(_g1));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(52)
	this->bits = _g2;
	HX_STACK_LINE(53)
	return this->mipMap = m;
}


HX_DEFINE_DYNAMIC_FUNC1(Texture_obj,set_mipMap,return )

::h3d::mat::Filter Texture_obj::set_filter( ::h3d::mat::Filter f){
	HX_STACK_FRAME("h3d.mat.Texture","set_filter",0x67d8166b,"h3d.mat.Texture.set_filter","h3d/mat/Texture.hx",56,0x24dfe888)
	HX_STACK_THIS(this)
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(57)
	hx::OrEq(this->bits,(int)524288);
	HX_STACK_LINE(58)
	int _g = f->__Index();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(58)
	int _g1 = (int(_g) << int((int)3));		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(58)
	int _g2 = (int((int(this->bits) & int((int)-25))) | int(_g1));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(58)
	this->bits = _g2;
	HX_STACK_LINE(59)
	return this->filter = f;
}


HX_DEFINE_DYNAMIC_FUNC1(Texture_obj,set_filter,return )

::h3d::mat::Wrap Texture_obj::set_wrap( ::h3d::mat::Wrap w){
	HX_STACK_FRAME("h3d.mat.Texture","set_wrap",0x2f0f0dbd,"h3d.mat.Texture.set_wrap","h3d/mat/Texture.hx",62,0x24dfe888)
	HX_STACK_THIS(this)
	HX_STACK_ARG(w,"w")
	HX_STACK_LINE(63)
	hx::OrEq(this->bits,(int)524288);
	HX_STACK_LINE(64)
	int _g = w->__Index();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(64)
	int _g1 = (int(_g) << int((int)6));		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(64)
	int _g2 = (int((int(this->bits) & int((int)-193))) | int(_g1));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(64)
	this->bits = _g2;
	HX_STACK_LINE(65)
	return this->wrap = w;
}


HX_DEFINE_DYNAMIC_FUNC1(Texture_obj,set_wrap,return )

bool Texture_obj::hasDefaultFlags( ){
	HX_STACK_FRAME("h3d.mat.Texture","hasDefaultFlags",0x116d3d0a,"h3d.mat.Texture.hasDefaultFlags","h3d/mat/Texture.hx",69,0x24dfe888)
	HX_STACK_THIS(this)
	HX_STACK_LINE(69)
	return (((int(this->bits) & int((int)524288))) == (int)0);
}


HX_DEFINE_DYNAMIC_FUNC0(Texture_obj,hasDefaultFlags,return )

bool Texture_obj::isDisposed( ){
	HX_STACK_FRAME("h3d.mat.Texture","isDisposed",0x90f10565,"h3d.mat.Texture.isDisposed","h3d/mat/Texture.hx",73,0x24dfe888)
	HX_STACK_THIS(this)
	HX_STACK_LINE(73)
	return (this->t == null());
}


HX_DEFINE_DYNAMIC_FUNC0(Texture_obj,isDisposed,return )

Void Texture_obj::resize( int width,int height){
{
		HX_STACK_FRAME("h3d.mat.Texture","resize",0x86b24f6a,"h3d.mat.Texture.resize","h3d/mat/Texture.hx",77,0x24dfe888)
		HX_STACK_THIS(this)
		HX_STACK_ARG(width,"width")
		HX_STACK_ARG(height,"height")
		HX_STACK_LINE(77)
		this->mem->resizeTexture(hx::ObjectPtr<OBJ_>(this),width,height);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Texture_obj,resize,(void))

Void Texture_obj::clear( int color){
{
		HX_STACK_FRAME("h3d.mat.Texture","clear",0xe6325cd7,"h3d.mat.Texture.clear","h3d/mat/Texture.hx",80,0x24dfe888)
		HX_STACK_THIS(this)
		HX_STACK_ARG(color,"color")
		HX_STACK_LINE(81)
		::hxd::Pixels p = ::hxd::Pixels_obj::alloc(this->width,this->height,::hxd::PixelFormat_obj::BGRA);		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(82)
		int k = (int)0;		HX_STACK_VAR(k,"k");
		HX_STACK_LINE(83)
		int b = (int(color) & int((int)255));		HX_STACK_VAR(b,"b");
		HX_STACK_LINE(83)
		int g = (int((int(color) >> int((int)8))) & int((int)255));		HX_STACK_VAR(g,"g");
		HX_STACK_LINE(83)
		int r = (int((int(color) >> int((int)16))) & int((int)255));		HX_STACK_VAR(r,"r");
		HX_STACK_LINE(83)
		int a = hx::UShr(color,(int)24);		HX_STACK_VAR(a,"a");
		HX_STACK_LINE(84)
		{
			HX_STACK_LINE(84)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(84)
			int _g = (this->width * this->height);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(84)
			while((true)){
				HX_STACK_LINE(84)
				if ((!(((_g1 < _g))))){
					HX_STACK_LINE(84)
					break;
				}
				HX_STACK_LINE(84)
				int i = (_g1)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(85)
				{
					HX_STACK_LINE(85)
					int pos = (k)++;		HX_STACK_VAR(pos,"pos");
					HX_STACK_LINE(85)
					p->bytes->b[pos] = b;
				}
				HX_STACK_LINE(86)
				{
					HX_STACK_LINE(86)
					int pos = (k)++;		HX_STACK_VAR(pos,"pos");
					HX_STACK_LINE(86)
					p->bytes->b[pos] = g;
				}
				HX_STACK_LINE(87)
				{
					HX_STACK_LINE(87)
					int pos = (k)++;		HX_STACK_VAR(pos,"pos");
					HX_STACK_LINE(87)
					p->bytes->b[pos] = r;
				}
				HX_STACK_LINE(88)
				{
					HX_STACK_LINE(88)
					int pos = (k)++;		HX_STACK_VAR(pos,"pos");
					HX_STACK_LINE(88)
					p->bytes->b[pos] = a;
				}
			}
		}
		HX_STACK_LINE(90)
		this->uploadPixels(p,null(),null());
		HX_STACK_LINE(91)
		p->dispose();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Texture_obj,clear,(void))

Void Texture_obj::uploadBitmap( ::flash::display::BitmapData bmp,Dynamic __o_mipLevel,Dynamic __o_side){
Dynamic mipLevel = __o_mipLevel.Default(0);
Dynamic side = __o_side.Default(0);
	HX_STACK_FRAME("h3d.mat.Texture","uploadBitmap",0x5444b6c6,"h3d.mat.Texture.uploadBitmap","h3d/mat/Texture.hx",94,0x24dfe888)
	HX_STACK_THIS(this)
	HX_STACK_ARG(bmp,"bmp")
	HX_STACK_ARG(mipLevel,"mipLevel")
	HX_STACK_ARG(side,"side")
{
		HX_STACK_LINE(95)
		this->mem->driver->uploadTextureBitmap(hx::ObjectPtr<OBJ_>(this),bmp,mipLevel,side);
		HX_STACK_LINE(100)
		bool _g = bmp->get_premultipliedAlpha();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(100)
		this->alpha_premultiplied = _g;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Texture_obj,uploadBitmap,(void))

Void Texture_obj::uploadPixels( ::hxd::Pixels pixels,hx::Null< int >  __o_mipLevel,hx::Null< int >  __o_side){
int mipLevel = __o_mipLevel.Default(0);
int side = __o_side.Default(0);
	HX_STACK_FRAME("h3d.mat.Texture","uploadPixels",0xefe29604,"h3d.mat.Texture.uploadPixels","h3d/mat/Texture.hx",104,0x24dfe888)
	HX_STACK_THIS(this)
	HX_STACK_ARG(pixels,"pixels")
	HX_STACK_ARG(mipLevel,"mipLevel")
	HX_STACK_ARG(side,"side")
{
		HX_STACK_LINE(105)
		this->mem->driver->uploadTexturePixels(hx::ObjectPtr<OBJ_>(this),pixels,mipLevel,side);
		HX_STACK_LINE(106)
		int _g = ::hxd::Flags_obj::ALPHA_PREMULTIPLIED->__Index();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(106)
		int _g1 = (int((int)1) << int(_g));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(106)
		int _g2 = (int(pixels->flags) & int(_g1));		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(106)
		bool _g3 = (_g2 != (int)0);		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(106)
		this->alpha_premultiplied = _g3;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Texture_obj,uploadPixels,(void))

Void Texture_obj::dispose( ){
{
		HX_STACK_FRAME("h3d.mat.Texture","dispose",0xad2c5269,"h3d.mat.Texture.dispose","h3d/mat/Texture.hx",110,0x24dfe888)
		HX_STACK_THIS(this)
		HX_STACK_LINE(110)
		if (((this->t != null()))){
			HX_STACK_LINE(111)
			this->mem->deleteTexture(hx::ObjectPtr<OBJ_>(this));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Texture_obj,dispose,(void))

int Texture_obj::UID;

::h3d::mat::Texture Texture_obj::fromBitmap( ::flash::display::BitmapData bmp,Dynamic allocPos){
	HX_STACK_FRAME("h3d.mat.Texture","fromBitmap",0x22edfd6f,"h3d.mat.Texture.fromBitmap","h3d/mat/Texture.hx",114,0x24dfe888)
	HX_STACK_ARG(bmp,"bmp")
	HX_STACK_ARG(allocPos,"allocPos")
	struct _Function_1_1{
		inline static ::h3d::Engine Block( ){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/mat/Texture.hx",115,0x24dfe888)
			{
				HX_STACK_LINE(115)
				if (((::hxd::System_obj::debugLevel >= (int)1))){
					HX_STACK_LINE(115)
					if (((::h3d::Engine_obj::CURRENT == null()))){
						HX_STACK_LINE(115)
						HX_STACK_DO_THROW(HX_CSTRING("no current context, please do this operation after engine init/creation"));
					}
				}
				HX_STACK_LINE(115)
				return ::h3d::Engine_obj::CURRENT;
			}
			return null();
		}
	};
	HX_STACK_LINE(115)
	::h3d::impl::MemoryManager mem = (_Function_1_1::Block())->mem;		HX_STACK_VAR(mem,"mem");
	HX_STACK_LINE(116)
	int _g = bmp->get_width();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(116)
	int _g1 = bmp->get_height();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(116)
	::h3d::mat::Texture t = mem->allocTexture(_g,_g1,false,allocPos);		HX_STACK_VAR(t,"t");
	HX_STACK_LINE(117)
	t->uploadBitmap(bmp,null(),null());
	HX_STACK_LINE(118)
	return t;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Texture_obj,fromBitmap,return )

::h3d::mat::Texture Texture_obj::fromPixels( ::hxd::Pixels pixels,Dynamic allocPos){
	HX_STACK_FRAME("h3d.mat.Texture","fromPixels",0xbe8bdcad,"h3d.mat.Texture.fromPixels","h3d/mat/Texture.hx",121,0x24dfe888)
	HX_STACK_ARG(pixels,"pixels")
	HX_STACK_ARG(allocPos,"allocPos")
	struct _Function_1_1{
		inline static ::h3d::Engine Block( ){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/mat/Texture.hx",122,0x24dfe888)
			{
				HX_STACK_LINE(122)
				if (((::hxd::System_obj::debugLevel >= (int)1))){
					HX_STACK_LINE(122)
					if (((::h3d::Engine_obj::CURRENT == null()))){
						HX_STACK_LINE(122)
						HX_STACK_DO_THROW(HX_CSTRING("no current context, please do this operation after engine init/creation"));
					}
				}
				HX_STACK_LINE(122)
				return ::h3d::Engine_obj::CURRENT;
			}
			return null();
		}
	};
	HX_STACK_LINE(122)
	::h3d::impl::MemoryManager mem = (_Function_1_1::Block())->mem;		HX_STACK_VAR(mem,"mem");
	HX_STACK_LINE(123)
	::h3d::mat::Texture t = mem->allocTexture(pixels->width,pixels->height,false,allocPos);		HX_STACK_VAR(t,"t");
	HX_STACK_LINE(124)
	t->uploadPixels(pixels,null(),null());
	HX_STACK_LINE(125)
	return t;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Texture_obj,fromPixels,return )

::hxd::Pixels Texture_obj::tmpPixels;

::h3d::mat::Texture Texture_obj::fromColor( int color,Dynamic allocPos){
	HX_STACK_FRAME("h3d.mat.Texture","fromColor",0x05b4b3e3,"h3d.mat.Texture.fromColor","h3d/mat/Texture.hx",132,0x24dfe888)
	HX_STACK_ARG(color,"color")
	HX_STACK_ARG(allocPos,"allocPos")
	struct _Function_1_1{
		inline static ::h3d::Engine Block( ){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/mat/Texture.hx",133,0x24dfe888)
			{
				HX_STACK_LINE(133)
				if (((::hxd::System_obj::debugLevel >= (int)1))){
					HX_STACK_LINE(133)
					if (((::h3d::Engine_obj::CURRENT == null()))){
						HX_STACK_LINE(133)
						HX_STACK_DO_THROW(HX_CSTRING("no current context, please do this operation after engine init/creation"));
					}
				}
				HX_STACK_LINE(133)
				return ::h3d::Engine_obj::CURRENT;
			}
			return null();
		}
	};
	HX_STACK_LINE(133)
	::h3d::impl::MemoryManager mem = (_Function_1_1::Block())->mem;		HX_STACK_VAR(mem,"mem");
	HX_STACK_LINE(134)
	::h3d::mat::Texture t = mem->allocTexture((int)1,(int)1,false,allocPos);		HX_STACK_VAR(t,"t");
	HX_STACK_LINE(135)
	if (((::h3d::mat::Texture_obj::tmpPixels == null()))){
		HX_STACK_LINE(135)
		::haxe::io::Bytes _g = ::haxe::io::Bytes_obj::alloc((int)4);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(135)
		::hxd::Pixels _g1 = ::hxd::Pixels_obj::__new((int)1,(int)1,_g,::hxd::PixelFormat_obj::BGRA,null());		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(135)
		::h3d::mat::Texture_obj::tmpPixels = _g1;
	}
	HX_STACK_LINE(136)
	::h3d::mat::Texture_obj::tmpPixels->format = ::hxd::PixelFormat_obj::BGRA;
	HX_STACK_LINE(137)
	::h3d::mat::Texture_obj::tmpPixels->bytes->b[(int)0] = (int(color) & int((int)255));
	HX_STACK_LINE(138)
	::h3d::mat::Texture_obj::tmpPixels->bytes->b[(int)1] = (int((int(color) >> int((int)8))) & int((int)255));
	HX_STACK_LINE(139)
	::h3d::mat::Texture_obj::tmpPixels->bytes->b[(int)2] = (int((int(color) >> int((int)16))) & int((int)255));
	HX_STACK_LINE(140)
	::h3d::mat::Texture_obj::tmpPixels->bytes->b[(int)3] = hx::UShr(color,(int)24);
	HX_STACK_LINE(141)
	t->uploadPixels(::h3d::mat::Texture_obj::tmpPixels,null(),null());
	HX_STACK_LINE(142)
	return t;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Texture_obj,fromColor,return )


Texture_obj::Texture_obj()
{
}

void Texture_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Texture);
	HX_MARK_MEMBER_NAME(t,"t");
	HX_MARK_MEMBER_NAME(mem,"mem");
	HX_MARK_MEMBER_NAME(allocPos,"allocPos");
	HX_MARK_MEMBER_NAME(id,"id");
	HX_MARK_MEMBER_NAME(width,"width");
	HX_MARK_MEMBER_NAME(height,"height");
	HX_MARK_MEMBER_NAME(isCubic,"isCubic");
	HX_MARK_MEMBER_NAME(isTarget,"isTarget");
	HX_MARK_MEMBER_NAME(mipLevels,"mipLevels");
	HX_MARK_MEMBER_NAME(format,"format");
	HX_MARK_MEMBER_NAME(bits,"bits");
	HX_MARK_MEMBER_NAME(mipMap,"mipMap");
	HX_MARK_MEMBER_NAME(filter,"filter");
	HX_MARK_MEMBER_NAME(wrap,"wrap");
	HX_MARK_MEMBER_NAME(alpha_premultiplied,"alpha_premultiplied");
	HX_MARK_MEMBER_NAME(onContextLost,"onContextLost");
	HX_MARK_END_CLASS();
}

void Texture_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(t,"t");
	HX_VISIT_MEMBER_NAME(mem,"mem");
	HX_VISIT_MEMBER_NAME(allocPos,"allocPos");
	HX_VISIT_MEMBER_NAME(id,"id");
	HX_VISIT_MEMBER_NAME(width,"width");
	HX_VISIT_MEMBER_NAME(height,"height");
	HX_VISIT_MEMBER_NAME(isCubic,"isCubic");
	HX_VISIT_MEMBER_NAME(isTarget,"isTarget");
	HX_VISIT_MEMBER_NAME(mipLevels,"mipLevels");
	HX_VISIT_MEMBER_NAME(format,"format");
	HX_VISIT_MEMBER_NAME(bits,"bits");
	HX_VISIT_MEMBER_NAME(mipMap,"mipMap");
	HX_VISIT_MEMBER_NAME(filter,"filter");
	HX_VISIT_MEMBER_NAME(wrap,"wrap");
	HX_VISIT_MEMBER_NAME(alpha_premultiplied,"alpha_premultiplied");
	HX_VISIT_MEMBER_NAME(onContextLost,"onContextLost");
}

Dynamic Texture_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"t") ) { return t; }
		break;
	case 2:
		if (HX_FIELD_EQ(inName,"id") ) { return id; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"UID") ) { return UID; }
		if (HX_FIELD_EQ(inName,"mem") ) { return mem; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"bits") ) { return bits; }
		if (HX_FIELD_EQ(inName,"wrap") ) { return wrap; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"width") ) { return width; }
		if (HX_FIELD_EQ(inName,"clear") ) { return clear_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"height") ) { return height; }
		if (HX_FIELD_EQ(inName,"format") ) { return format; }
		if (HX_FIELD_EQ(inName,"mipMap") ) { return mipMap; }
		if (HX_FIELD_EQ(inName,"filter") ) { return filter; }
		if (HX_FIELD_EQ(inName,"resize") ) { return resize_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"isCubic") ) { return isCubic; }
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"allocPos") ) { return allocPos; }
		if (HX_FIELD_EQ(inName,"isTarget") ) { return isTarget; }
		if (HX_FIELD_EQ(inName,"set_wrap") ) { return set_wrap_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"tmpPixels") ) { return tmpPixels; }
		if (HX_FIELD_EQ(inName,"fromColor") ) { return fromColor_dyn(); }
		if (HX_FIELD_EQ(inName,"mipLevels") ) { return mipLevels; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"fromBitmap") ) { return fromBitmap_dyn(); }
		if (HX_FIELD_EQ(inName,"fromPixels") ) { return fromPixels_dyn(); }
		if (HX_FIELD_EQ(inName,"set_mipMap") ) { return set_mipMap_dyn(); }
		if (HX_FIELD_EQ(inName,"set_filter") ) { return set_filter_dyn(); }
		if (HX_FIELD_EQ(inName,"isDisposed") ) { return isDisposed_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"uploadBitmap") ) { return uploadBitmap_dyn(); }
		if (HX_FIELD_EQ(inName,"uploadPixels") ) { return uploadPixels_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"onContextLost") ) { return onContextLost; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"hasDefaultFlags") ) { return hasDefaultFlags_dyn(); }
		break;
	case 19:
		if (HX_FIELD_EQ(inName,"alpha_premultiplied") ) { return alpha_premultiplied; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Texture_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"t") ) { t=inValue.Cast< ::openfl::gl::GLTexture >(); return inValue; }
		break;
	case 2:
		if (HX_FIELD_EQ(inName,"id") ) { id=inValue.Cast< int >(); return inValue; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"UID") ) { UID=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"mem") ) { mem=inValue.Cast< ::h3d::impl::MemoryManager >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"bits") ) { bits=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"wrap") ) { if (inCallProp) return set_wrap(inValue);wrap=inValue.Cast< ::h3d::mat::Wrap >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"width") ) { width=inValue.Cast< int >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"height") ) { height=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"format") ) { format=inValue.Cast< ::h3d::mat::TextureFormat >(); return inValue; }
		if (HX_FIELD_EQ(inName,"mipMap") ) { if (inCallProp) return set_mipMap(inValue);mipMap=inValue.Cast< ::h3d::mat::MipMap >(); return inValue; }
		if (HX_FIELD_EQ(inName,"filter") ) { if (inCallProp) return set_filter(inValue);filter=inValue.Cast< ::h3d::mat::Filter >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"isCubic") ) { isCubic=inValue.Cast< bool >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"allocPos") ) { allocPos=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"isTarget") ) { isTarget=inValue.Cast< bool >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"tmpPixels") ) { tmpPixels=inValue.Cast< ::hxd::Pixels >(); return inValue; }
		if (HX_FIELD_EQ(inName,"mipLevels") ) { mipLevels=inValue.Cast< int >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"onContextLost") ) { onContextLost=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 19:
		if (HX_FIELD_EQ(inName,"alpha_premultiplied") ) { alpha_premultiplied=inValue.Cast< bool >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Texture_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("t"));
	outFields->push(HX_CSTRING("mem"));
	outFields->push(HX_CSTRING("allocPos"));
	outFields->push(HX_CSTRING("id"));
	outFields->push(HX_CSTRING("width"));
	outFields->push(HX_CSTRING("height"));
	outFields->push(HX_CSTRING("isCubic"));
	outFields->push(HX_CSTRING("isTarget"));
	outFields->push(HX_CSTRING("mipLevels"));
	outFields->push(HX_CSTRING("format"));
	outFields->push(HX_CSTRING("bits"));
	outFields->push(HX_CSTRING("mipMap"));
	outFields->push(HX_CSTRING("filter"));
	outFields->push(HX_CSTRING("wrap"));
	outFields->push(HX_CSTRING("alpha_premultiplied"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("UID"),
	HX_CSTRING("fromBitmap"),
	HX_CSTRING("fromPixels"),
	HX_CSTRING("tmpPixels"),
	HX_CSTRING("fromColor"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::openfl::gl::GLTexture*/ ,(int)offsetof(Texture_obj,t),HX_CSTRING("t")},
	{hx::fsObject /*::h3d::impl::MemoryManager*/ ,(int)offsetof(Texture_obj,mem),HX_CSTRING("mem")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Texture_obj,allocPos),HX_CSTRING("allocPos")},
	{hx::fsInt,(int)offsetof(Texture_obj,id),HX_CSTRING("id")},
	{hx::fsInt,(int)offsetof(Texture_obj,width),HX_CSTRING("width")},
	{hx::fsInt,(int)offsetof(Texture_obj,height),HX_CSTRING("height")},
	{hx::fsBool,(int)offsetof(Texture_obj,isCubic),HX_CSTRING("isCubic")},
	{hx::fsBool,(int)offsetof(Texture_obj,isTarget),HX_CSTRING("isTarget")},
	{hx::fsInt,(int)offsetof(Texture_obj,mipLevels),HX_CSTRING("mipLevels")},
	{hx::fsObject /*::h3d::mat::TextureFormat*/ ,(int)offsetof(Texture_obj,format),HX_CSTRING("format")},
	{hx::fsInt,(int)offsetof(Texture_obj,bits),HX_CSTRING("bits")},
	{hx::fsObject /*::h3d::mat::MipMap*/ ,(int)offsetof(Texture_obj,mipMap),HX_CSTRING("mipMap")},
	{hx::fsObject /*::h3d::mat::Filter*/ ,(int)offsetof(Texture_obj,filter),HX_CSTRING("filter")},
	{hx::fsObject /*::h3d::mat::Wrap*/ ,(int)offsetof(Texture_obj,wrap),HX_CSTRING("wrap")},
	{hx::fsBool,(int)offsetof(Texture_obj,alpha_premultiplied),HX_CSTRING("alpha_premultiplied")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Texture_obj,onContextLost),HX_CSTRING("onContextLost")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("t"),
	HX_CSTRING("mem"),
	HX_CSTRING("allocPos"),
	HX_CSTRING("id"),
	HX_CSTRING("width"),
	HX_CSTRING("height"),
	HX_CSTRING("isCubic"),
	HX_CSTRING("isTarget"),
	HX_CSTRING("mipLevels"),
	HX_CSTRING("format"),
	HX_CSTRING("bits"),
	HX_CSTRING("mipMap"),
	HX_CSTRING("filter"),
	HX_CSTRING("wrap"),
	HX_CSTRING("alpha_premultiplied"),
	HX_CSTRING("onContextLost"),
	HX_CSTRING("set_mipMap"),
	HX_CSTRING("set_filter"),
	HX_CSTRING("set_wrap"),
	HX_CSTRING("hasDefaultFlags"),
	HX_CSTRING("isDisposed"),
	HX_CSTRING("resize"),
	HX_CSTRING("clear"),
	HX_CSTRING("uploadBitmap"),
	HX_CSTRING("uploadPixels"),
	HX_CSTRING("dispose"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Texture_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Texture_obj::UID,"UID");
	HX_MARK_MEMBER_NAME(Texture_obj::tmpPixels,"tmpPixels");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Texture_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Texture_obj::UID,"UID");
	HX_VISIT_MEMBER_NAME(Texture_obj::tmpPixels,"tmpPixels");
};

#endif

Class Texture_obj::__mClass;

void Texture_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.mat.Texture"), hx::TCanCast< Texture_obj> ,sStaticFields,sMemberFields,
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

void Texture_obj::__boot()
{
	UID= (int)0;
	tmpPixels= null();
}

} // end namespace h3d
} // end namespace mat
