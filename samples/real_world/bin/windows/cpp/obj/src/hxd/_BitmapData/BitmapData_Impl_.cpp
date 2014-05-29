#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_flash_display_BitmapData
#include <flash/display/BitmapData.h>
#endif
#ifndef INCLUDED_flash_display_IBitmapDrawable
#include <flash/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_flash_geom_Rectangle
#include <flash/geom/Rectangle.h>
#endif
#ifndef INCLUDED_flash_utils_ByteArray
#include <flash/utils/ByteArray.h>
#endif
#ifndef INCLUDED_flash_utils_IDataInput
#include <flash/utils/IDataInput.h>
#endif
#ifndef INCLUDED_flash_utils_IDataOutput
#include <flash/utils/IDataOutput.h>
#endif
#ifndef INCLUDED_h2d_col_Bounds
#include <h2d/col/Bounds.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_hxd_ByteConversions
#include <hxd/ByteConversions.h>
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
#ifndef INCLUDED_hxd__BitmapData_BitmapData_Impl_
#include <hxd/_BitmapData/BitmapData_Impl_.h>
#endif
#ifndef INCLUDED_openfl_utils_IMemoryRange
#include <openfl/utils/IMemoryRange.h>
#endif
namespace hxd{
namespace _BitmapData{

Void BitmapData_Impl__obj::__construct()
{
	return null();
}

//BitmapData_Impl__obj::~BitmapData_Impl__obj() { }

Dynamic BitmapData_Impl__obj::__CreateEmpty() { return  new BitmapData_Impl__obj; }
hx::ObjectPtr< BitmapData_Impl__obj > BitmapData_Impl__obj::__new()
{  hx::ObjectPtr< BitmapData_Impl__obj > result = new BitmapData_Impl__obj();
	result->__construct();
	return result;}

Dynamic BitmapData_Impl__obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< BitmapData_Impl__obj > result = new BitmapData_Impl__obj();
	result->__construct();
	return result;}

::flash::display::BitmapData BitmapData_Impl__obj::_new( int width,int height){
	HX_STACK_FRAME("hxd._BitmapData.BitmapData_Impl_","_new",0xeaf0c526,"hxd._BitmapData.BitmapData_Impl_._new","hxd/BitmapData.hx",21,0x8bf7c34a)
	HX_STACK_ARG(width,"width")
	HX_STACK_ARG(height,"height")
	HX_STACK_LINE(21)
	return ::flash::display::BitmapData_obj::__new(width,height,true,(int)0,null());
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(BitmapData_Impl__obj,_new,return )

Void BitmapData_Impl__obj::clear( ::flash::display::BitmapData this1,int color){
{
		HX_STACK_FRAME("hxd._BitmapData.BitmapData_Impl_","clear",0xf4038e28,"hxd._BitmapData.BitmapData_Impl_.clear","hxd/BitmapData.hx",27,0x8bf7c34a)
		HX_STACK_ARG(this1,"this1")
		HX_STACK_ARG(color,"color")
		HX_STACK_LINE(29)
		::flash::geom::Rectangle _g = this1->get_rect();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(29)
		this1->fillRect(_g,color);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(BitmapData_Impl__obj,clear,(void))

Void BitmapData_Impl__obj::fill( ::flash::display::BitmapData this1,::h2d::col::Bounds rect,int color){
{
		HX_STACK_FRAME("hxd._BitmapData.BitmapData_Impl_","fill",0xef8d7e48,"hxd._BitmapData.BitmapData_Impl_.fill","hxd/BitmapData.hx",35,0x8bf7c34a)
		HX_STACK_ARG(this1,"this1")
		HX_STACK_ARG(rect,"rect")
		HX_STACK_ARG(color,"color")
		HX_STACK_LINE(37)
		int _g = ::Std_obj::_int(rect->xMin);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(37)
		int _g1 = ::Std_obj::_int(rect->yMin);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(37)
		int _g2 = ::Math_obj::ceil((rect->xMax - rect->xMin));		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(37)
		int _g3 = ::Math_obj::ceil((rect->yMax - rect->yMin));		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(37)
		::flash::geom::Rectangle _g4 = ::flash::geom::Rectangle_obj::__new(_g,_g1,_g2,_g3);		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(37)
		this1->fillRect(_g4,color);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(BitmapData_Impl__obj,fill,(void))

Void BitmapData_Impl__obj::line( ::flash::display::BitmapData this1,int x0,int y0,int x1,int y1,int color){
{
		HX_STACK_FRAME("hxd._BitmapData.BitmapData_Impl_","line",0xf384c7b9,"hxd._BitmapData.BitmapData_Impl_.line","hxd/BitmapData.hx",43,0x8bf7c34a)
		HX_STACK_ARG(this1,"this1")
		HX_STACK_ARG(x0,"x0")
		HX_STACK_ARG(y0,"y0")
		HX_STACK_ARG(x1,"x1")
		HX_STACK_ARG(y1,"y1")
		HX_STACK_ARG(color,"color")
		HX_STACK_LINE(44)
		int dx = (x1 - x0);		HX_STACK_VAR(dx,"dx");
		HX_STACK_LINE(45)
		int dy = (y1 - y0);		HX_STACK_VAR(dy,"dy");
		HX_STACK_LINE(46)
		if (((dx == (int)0))){
			HX_STACK_LINE(47)
			if (((y1 < y0))){
				HX_STACK_LINE(48)
				int tmp = y0;		HX_STACK_VAR(tmp,"tmp");
				HX_STACK_LINE(49)
				y0 = y1;
				HX_STACK_LINE(50)
				y1 = tmp;
			}
			HX_STACK_LINE(52)
			{
				HX_STACK_LINE(52)
				int _g1 = y0;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(52)
				int _g = (y1 + (int)1);		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(52)
				while((true)){
					HX_STACK_LINE(52)
					if ((!(((_g1 < _g))))){
						HX_STACK_LINE(52)
						break;
					}
					HX_STACK_LINE(52)
					int y = (_g1)++;		HX_STACK_VAR(y,"y");
					HX_STACK_LINE(53)
					this1->setPixel32(x0,y,color);
				}
			}
		}
		else{
			HX_STACK_LINE(54)
			if (((dy == (int)0))){
				HX_STACK_LINE(55)
				if (((x1 < x0))){
					HX_STACK_LINE(56)
					int tmp = x0;		HX_STACK_VAR(tmp,"tmp");
					HX_STACK_LINE(57)
					x0 = x1;
					HX_STACK_LINE(58)
					x1 = tmp;
				}
				HX_STACK_LINE(60)
				{
					HX_STACK_LINE(60)
					int _g1 = x0;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(60)
					int _g = (x1 + (int)1);		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(60)
					while((true)){
						HX_STACK_LINE(60)
						if ((!(((_g1 < _g))))){
							HX_STACK_LINE(60)
							break;
						}
						HX_STACK_LINE(60)
						int x = (_g1)++;		HX_STACK_VAR(x,"x");
						HX_STACK_LINE(61)
						this1->setPixel32(x,y0,color);
					}
				}
			}
			else{
				HX_STACK_LINE(63)
				HX_STACK_DO_THROW(HX_CSTRING("TODO"));
			}
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC6(BitmapData_Impl__obj,line,(void))

Void BitmapData_Impl__obj::dispose( ::flash::display::BitmapData this1){
{
		HX_STACK_FRAME("hxd._BitmapData.BitmapData_Impl_","dispose",0xb6a939fa,"hxd._BitmapData.BitmapData_Impl_.dispose","hxd/BitmapData.hx",69,0x8bf7c34a)
		HX_STACK_ARG(this1,"this1")
		HX_STACK_LINE(69)
		this1->dispose();
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(BitmapData_Impl__obj,dispose,(void))

int BitmapData_Impl__obj::getPixel( ::flash::display::BitmapData this1,int x,int y){
	HX_STACK_FRAME("hxd._BitmapData.BitmapData_Impl_","getPixel",0x18404c55,"hxd._BitmapData.BitmapData_Impl_.getPixel","hxd/BitmapData.hx",75,0x8bf7c34a)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_ARG(x,"x")
	HX_STACK_ARG(y,"y")
	HX_STACK_LINE(75)
	return this1->getPixel32(x,y);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(BitmapData_Impl__obj,getPixel,return )

Void BitmapData_Impl__obj::setPixel( ::flash::display::BitmapData this1,int x,int y,int c){
{
		HX_STACK_FRAME("hxd._BitmapData.BitmapData_Impl_","setPixel",0xc69da5c9,"hxd._BitmapData.BitmapData_Impl_.setPixel","hxd/BitmapData.hx",84,0x8bf7c34a)
		HX_STACK_ARG(this1,"this1")
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(c,"c")
		HX_STACK_LINE(84)
		this1->setPixel32(x,y,c);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(BitmapData_Impl__obj,setPixel,(void))

int BitmapData_Impl__obj::get_width( ::flash::display::BitmapData this1){
	HX_STACK_FRAME("hxd._BitmapData.BitmapData_Impl_","get_width",0x250e1878,"hxd._BitmapData.BitmapData_Impl_.get_width","hxd/BitmapData.hx",91,0x8bf7c34a)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(91)
	return this1->get_width();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(BitmapData_Impl__obj,get_width,return )

int BitmapData_Impl__obj::get_height( ::flash::display::BitmapData this1){
	HX_STACK_FRAME("hxd._BitmapData.BitmapData_Impl_","get_height",0xfd96c935,"hxd._BitmapData.BitmapData_Impl_.get_height","hxd/BitmapData.hx",95,0x8bf7c34a)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(95)
	return this1->get_height();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(BitmapData_Impl__obj,get_height,return )

::hxd::Pixels BitmapData_Impl__obj::getPixels( ::flash::display::BitmapData this1){
	HX_STACK_FRAME("hxd._BitmapData.BitmapData_Impl_","getPixels",0x20027e7e,"hxd._BitmapData.BitmapData_Impl_.getPixels","hxd/BitmapData.hx",99,0x8bf7c34a)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(99)
	return ::hxd::_BitmapData::BitmapData_Impl__obj::nativeGetPixels(this1);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(BitmapData_Impl__obj,getPixels,return )

Void BitmapData_Impl__obj::setPixels( ::flash::display::BitmapData this1,::hxd::Pixels pixels){
{
		HX_STACK_FRAME("hxd._BitmapData.BitmapData_Impl_","setPixels",0x03536a8a,"hxd._BitmapData.BitmapData_Impl_.setPixels","hxd/BitmapData.hx",103,0x8bf7c34a)
		HX_STACK_ARG(this1,"this1")
		HX_STACK_ARG(pixels,"pixels")
		HX_STACK_LINE(103)
		::hxd::_BitmapData::BitmapData_Impl__obj::nativeSetPixels(this1,pixels);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(BitmapData_Impl__obj,setPixels,(void))

::flash::display::BitmapData BitmapData_Impl__obj::toNative( ::flash::display::BitmapData this1){
	HX_STACK_FRAME("hxd._BitmapData.BitmapData_Impl_","toNative",0x3f20e7b7,"hxd._BitmapData.BitmapData_Impl_.toNative","hxd/BitmapData.hx",107,0x8bf7c34a)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(107)
	return this1;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(BitmapData_Impl__obj,toNative,return )

::flash::display::BitmapData BitmapData_Impl__obj::fromNative( ::flash::display::BitmapData bmp){
	HX_STACK_FRAME("hxd._BitmapData.BitmapData_Impl_","fromNative",0x70242026,"hxd._BitmapData.BitmapData_Impl_.fromNative","hxd/BitmapData.hx",111,0x8bf7c34a)
	HX_STACK_ARG(bmp,"bmp")
	HX_STACK_LINE(111)
	return bmp;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(BitmapData_Impl__obj,fromNative,return )

::hxd::Pixels BitmapData_Impl__obj::nativeGetPixels( ::flash::display::BitmapData b){
	HX_STACK_FRAME("hxd._BitmapData.BitmapData_Impl_","nativeGetPixels",0x71503027,"hxd._BitmapData.BitmapData_Impl_.nativeGetPixels","hxd/BitmapData.hx",114,0x8bf7c34a)
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(120)
	::flash::geom::Rectangle bRect = b->get_rect();		HX_STACK_VAR(bRect,"bRect");
	HX_STACK_LINE(121)
	::flash::geom::Rectangle _g = b->get_rect();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(121)
	::flash::utils::ByteArray _g1 = b->getPixels(_g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(121)
	::haxe::io::Bytes bPixels = ::hxd::ByteConversions_obj::byteArrayToBytes(_g1);		HX_STACK_VAR(bPixels,"bPixels");
	HX_STACK_LINE(122)
	int _g2 = b->get_width();		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(122)
	int _g3 = b->get_height();		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(122)
	::hxd::Pixels p = ::hxd::Pixels_obj::__new(_g2,_g3,bPixels,::hxd::PixelFormat_obj::ARGB,null());		HX_STACK_VAR(p,"p");
	HX_STACK_LINE(123)
	{
		HX_STACK_LINE(123)
		int _g4 = ::hxd::Flags_obj::ALPHA_PREMULTIPLIED->__Index();		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(123)
		int _g5 = (int((int)1) << int(_g4));		HX_STACK_VAR(_g5,"_g5");
		HX_STACK_LINE(123)
		hx::OrEq(p->flags,_g5);
	}
	HX_STACK_LINE(124)
	return p;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(BitmapData_Impl__obj,nativeGetPixels,return )

Void BitmapData_Impl__obj::nativeSetPixels( ::flash::display::BitmapData b,::hxd::Pixels pixels){
{
		HX_STACK_FRAME("hxd._BitmapData.BitmapData_Impl_","nativeSetPixels",0x54a11c33,"hxd._BitmapData.BitmapData_Impl_.nativeSetPixels","hxd/BitmapData.hx",131,0x8bf7c34a)
		HX_STACK_ARG(b,"b")
		HX_STACK_ARG(pixels,"pixels")
		HX_STACK_LINE(146)
		::flash::geom::Rectangle _g = b->get_rect();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(146)
		::flash::utils::ByteArray _g1 = ::flash::utils::ByteArray_obj::fromBytes(pixels->bytes);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(146)
		b->setPixels(_g,_g1);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(BitmapData_Impl__obj,nativeSetPixels,(void))


BitmapData_Impl__obj::BitmapData_Impl__obj()
{
}

Dynamic BitmapData_Impl__obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"_new") ) { return _new_dyn(); }
		if (HX_FIELD_EQ(inName,"fill") ) { return fill_dyn(); }
		if (HX_FIELD_EQ(inName,"line") ) { return line_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"clear") ) { return clear_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"getPixel") ) { return getPixel_dyn(); }
		if (HX_FIELD_EQ(inName,"setPixel") ) { return setPixel_dyn(); }
		if (HX_FIELD_EQ(inName,"toNative") ) { return toNative_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"get_width") ) { return get_width_dyn(); }
		if (HX_FIELD_EQ(inName,"getPixels") ) { return getPixels_dyn(); }
		if (HX_FIELD_EQ(inName,"setPixels") ) { return setPixels_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"get_height") ) { return get_height_dyn(); }
		if (HX_FIELD_EQ(inName,"fromNative") ) { return fromNative_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"nativeGetPixels") ) { return nativeGetPixels_dyn(); }
		if (HX_FIELD_EQ(inName,"nativeSetPixels") ) { return nativeSetPixels_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic BitmapData_Impl__obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void BitmapData_Impl__obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("_new"),
	HX_CSTRING("clear"),
	HX_CSTRING("fill"),
	HX_CSTRING("line"),
	HX_CSTRING("dispose"),
	HX_CSTRING("getPixel"),
	HX_CSTRING("setPixel"),
	HX_CSTRING("get_width"),
	HX_CSTRING("get_height"),
	HX_CSTRING("getPixels"),
	HX_CSTRING("setPixels"),
	HX_CSTRING("toNative"),
	HX_CSTRING("fromNative"),
	HX_CSTRING("nativeGetPixels"),
	HX_CSTRING("nativeSetPixels"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(BitmapData_Impl__obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(BitmapData_Impl__obj::__mClass,"__mClass");
};

#endif

Class BitmapData_Impl__obj::__mClass;

void BitmapData_Impl__obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd._BitmapData.BitmapData_Impl_"), hx::TCanCast< BitmapData_Impl__obj> ,sStaticFields,sMemberFields,
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

void BitmapData_Impl__obj::__boot()
{
}

} // end namespace hxd
} // end namespace _BitmapData
