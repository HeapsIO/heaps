#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_flash_Lib
#include <flash/Lib.h>
#endif
#ifndef INCLUDED_flash_Memory
#include <flash/Memory.h>
#endif
#ifndef INCLUDED_flash_display_BitmapData
#include <flash/display/BitmapData.h>
#endif
#ifndef INCLUDED_flash_display_BlendMode
#include <flash/display/BlendMode.h>
#endif
#ifndef INCLUDED_flash_display_IBitmapDrawable
#include <flash/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_flash_display_OptimizedPerlin
#include <flash/display/OptimizedPerlin.h>
#endif
#ifndef INCLUDED_flash_filters_BitmapFilter
#include <flash/filters/BitmapFilter.h>
#endif
#ifndef INCLUDED_flash_geom_ColorTransform
#include <flash/geom/ColorTransform.h>
#endif
#ifndef INCLUDED_flash_geom_Matrix
#include <flash/geom/Matrix.h>
#endif
#ifndef INCLUDED_flash_geom_Point
#include <flash/geom/Point.h>
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
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_openfl_utils_IMemoryRange
#include <openfl/utils/IMemoryRange.h>
#endif
namespace flash{
namespace display{

Void BitmapData_obj::__construct(int width,int height,hx::Null< bool >  __o_transparent,hx::Null< int >  __o_fillColor,Dynamic gpuMode)
{
HX_STACK_FRAME("flash.display.BitmapData","new",0x539cb2f5,"flash.display.BitmapData.new","flash/display/BitmapData.hx",42,0x1e513fd9)
HX_STACK_THIS(this)
HX_STACK_ARG(width,"width")
HX_STACK_ARG(height,"height")
HX_STACK_ARG(__o_transparent,"transparent")
HX_STACK_ARG(__o_fillColor,"fillColor")
HX_STACK_ARG(gpuMode,"gpuMode")
bool transparent = __o_transparent.Default(true);
int fillColor = __o_fillColor.Default(-1);
{
	HX_STACK_LINE(44)
	this->__transparent = transparent;
	HX_STACK_LINE(46)
	if (((bool((width < (int)1)) || bool((height < (int)1))))){
		HX_STACK_LINE(48)
		this->__handle = null();
	}
	else{
		HX_STACK_LINE(52)
		int flags = (int)2;		HX_STACK_VAR(flags,"flags");
		HX_STACK_LINE(53)
		if ((transparent)){
			HX_STACK_LINE(53)
			hx::OrEq(flags,(int)1);
		}
		HX_STACK_LINE(54)
		int alpha = hx::UShr(fillColor,(int)24);		HX_STACK_VAR(alpha,"alpha");
		HX_STACK_LINE(56)
		if (((bool(transparent) && bool((alpha == (int)0))))){
			HX_STACK_LINE(58)
			fillColor = (int)0;
		}
		HX_STACK_LINE(62)
		Dynamic _g = ::flash::display::BitmapData_obj::lime_bitmap_data_create(width,height,flags,(int(fillColor) & int((int)16777215)),alpha,gpuMode);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(62)
		this->__handle = _g;
	}
}
;
	return null();
}

//BitmapData_obj::~BitmapData_obj() { }

Dynamic BitmapData_obj::__CreateEmpty() { return  new BitmapData_obj; }
hx::ObjectPtr< BitmapData_obj > BitmapData_obj::__new(int width,int height,hx::Null< bool >  __o_transparent,hx::Null< int >  __o_fillColor,Dynamic gpuMode)
{  hx::ObjectPtr< BitmapData_obj > result = new BitmapData_obj();
	result->__construct(width,height,__o_transparent,__o_fillColor,gpuMode);
	return result;}

Dynamic BitmapData_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< BitmapData_obj > result = new BitmapData_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4]);
	return result;}

hx::Object *BitmapData_obj::__ToInterface(const hx::type_info &inType) {
	if (inType==typeid( ::flash::display::IBitmapDrawable_obj)) return operator ::flash::display::IBitmapDrawable_obj *();
	return super::__ToInterface(inType);
}

Void BitmapData_obj::applyFilter( ::flash::display::BitmapData sourceBitmapData,::flash::geom::Rectangle sourceRect,::flash::geom::Point destPoint,::flash::filters::BitmapFilter filter){
{
		HX_STACK_FRAME("flash.display.BitmapData","applyFilter",0x81acdf5b,"flash.display.BitmapData.applyFilter","flash/display/BitmapData.hx",71,0x1e513fd9)
		HX_STACK_THIS(this)
		HX_STACK_ARG(sourceBitmapData,"sourceBitmapData")
		HX_STACK_ARG(sourceRect,"sourceRect")
		HX_STACK_ARG(destPoint,"destPoint")
		HX_STACK_ARG(filter,"filter")
		HX_STACK_LINE(71)
		::flash::display::BitmapData_obj::lime_bitmap_data_apply_filter(this->__handle,sourceBitmapData->__handle,sourceRect,destPoint,filter);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(BitmapData_obj,applyFilter,(void))

Void BitmapData_obj::clear( int color){
{
		HX_STACK_FRAME("flash.display.BitmapData","clear",0xa991e362,"flash.display.BitmapData.clear","flash/display/BitmapData.hx",78,0x1e513fd9)
		HX_STACK_THIS(this)
		HX_STACK_ARG(color,"color")
		HX_STACK_LINE(78)
		::flash::display::BitmapData_obj::lime_bitmap_data_clear(this->__handle,color);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(BitmapData_obj,clear,(void))

::flash::display::BitmapData BitmapData_obj::clone( ){
	HX_STACK_FRAME("flash.display.BitmapData","clone",0xa9998532,"flash.display.BitmapData.clone","flash/display/BitmapData.hx",83,0x1e513fd9)
	HX_STACK_THIS(this)
	HX_STACK_LINE(85)
	bool _g = this->get_transparent();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(85)
	::flash::display::BitmapData bitmapData = ::flash::display::BitmapData_obj::__new((int)0,(int)0,_g,null(),null());		HX_STACK_VAR(bitmapData,"bitmapData");
	HX_STACK_LINE(86)
	Dynamic _g1 = ::flash::display::BitmapData_obj::lime_bitmap_data_clone(this->__handle);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(86)
	bitmapData->__handle = _g1;
	HX_STACK_LINE(87)
	return bitmapData;
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapData_obj,clone,return )

Void BitmapData_obj::colorTransform( ::flash::geom::Rectangle rect,::flash::geom::ColorTransform colorTransform){
{
		HX_STACK_FRAME("flash.display.BitmapData","colorTransform",0x52290314,"flash.display.BitmapData.colorTransform","flash/display/BitmapData.hx",94,0x1e513fd9)
		HX_STACK_THIS(this)
		HX_STACK_ARG(rect,"rect")
		HX_STACK_ARG(colorTransform,"colorTransform")
		HX_STACK_LINE(94)
		::flash::display::BitmapData_obj::lime_bitmap_data_color_transform(this->__handle,rect,colorTransform);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,colorTransform,(void))

Void BitmapData_obj::copyChannel( ::flash::display::BitmapData sourceBitmapData,::flash::geom::Rectangle sourceRect,::flash::geom::Point destPoint,int sourceChannel,int destChannel){
{
		HX_STACK_FRAME("flash.display.BitmapData","copyChannel",0xe3637d23,"flash.display.BitmapData.copyChannel","flash/display/BitmapData.hx",101,0x1e513fd9)
		HX_STACK_THIS(this)
		HX_STACK_ARG(sourceBitmapData,"sourceBitmapData")
		HX_STACK_ARG(sourceRect,"sourceRect")
		HX_STACK_ARG(destPoint,"destPoint")
		HX_STACK_ARG(sourceChannel,"sourceChannel")
		HX_STACK_ARG(destChannel,"destChannel")
		HX_STACK_LINE(101)
		::flash::display::BitmapData_obj::lime_bitmap_data_copy_channel(sourceBitmapData->__handle,sourceRect,this->__handle,destPoint,sourceChannel,destChannel);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC5(BitmapData_obj,copyChannel,(void))

Void BitmapData_obj::copyPixels( ::flash::display::BitmapData sourceBitmapData,::flash::geom::Rectangle sourceRect,::flash::geom::Point destPoint,::flash::display::BitmapData alphaBitmapData,::flash::geom::Point alphaPoint,hx::Null< bool >  __o_mergeAlpha){
bool mergeAlpha = __o_mergeAlpha.Default(false);
	HX_STACK_FRAME("flash.display.BitmapData","copyPixels",0x3b421ecd,"flash.display.BitmapData.copyPixels","flash/display/BitmapData.hx",108,0x1e513fd9)
	HX_STACK_THIS(this)
	HX_STACK_ARG(sourceBitmapData,"sourceBitmapData")
	HX_STACK_ARG(sourceRect,"sourceRect")
	HX_STACK_ARG(destPoint,"destPoint")
	HX_STACK_ARG(alphaBitmapData,"alphaBitmapData")
	HX_STACK_ARG(alphaPoint,"alphaPoint")
	HX_STACK_ARG(mergeAlpha,"mergeAlpha")
{
		HX_STACK_LINE(108)
		::flash::display::BitmapData_obj::lime_bitmap_data_copy(sourceBitmapData->__handle,sourceRect,this->__handle,destPoint,mergeAlpha);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC6(BitmapData_obj,copyPixels,(void))

Void BitmapData_obj::createHardwareSurface( ){
{
		HX_STACK_FRAME("flash.display.BitmapData","createHardwareSurface",0xc9efd89e,"flash.display.BitmapData.createHardwareSurface","flash/display/BitmapData.hx",123,0x1e513fd9)
		HX_STACK_THIS(this)
		HX_STACK_LINE(123)
		::flash::display::BitmapData_obj::lime_bitmap_data_create_hardware_surface(this->__handle);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapData_obj,createHardwareSurface,(void))

Void BitmapData_obj::destroyHardwareSurface( ){
{
		HX_STACK_FRAME("flash.display.BitmapData","destroyHardwareSurface",0xd1818316,"flash.display.BitmapData.destroyHardwareSurface","flash/display/BitmapData.hx",130,0x1e513fd9)
		HX_STACK_THIS(this)
		HX_STACK_LINE(130)
		::flash::display::BitmapData_obj::lime_bitmap_data_destroy_hardware_surface(this->__handle);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapData_obj,destroyHardwareSurface,(void))

Void BitmapData_obj::dispose( ){
{
		HX_STACK_FRAME("flash.display.BitmapData","dispose",0xac62d1b4,"flash.display.BitmapData.dispose","flash/display/BitmapData.hx",136,0x1e513fd9)
		HX_STACK_THIS(this)
		HX_STACK_LINE(138)
		if (((this->__handle != null()))){
			HX_STACK_LINE(140)
			::flash::display::BitmapData_obj::lime_bitmap_data_dispose(this->__handle);
		}
		HX_STACK_LINE(144)
		this->__handle = null();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapData_obj,dispose,(void))

Void BitmapData_obj::draw( ::flash::display::IBitmapDrawable source,::flash::geom::Matrix matrix,::flash::geom::ColorTransform colorTransform,::flash::display::BlendMode blendMode,::flash::geom::Rectangle clipRect,hx::Null< bool >  __o_smoothing){
bool smoothing = __o_smoothing.Default(false);
	HX_STACK_FRAME("flash.display.BitmapData","draw",0xceed8bcf,"flash.display.BitmapData.draw","flash/display/BitmapData.hx",149,0x1e513fd9)
	HX_STACK_THIS(this)
	HX_STACK_ARG(source,"source")
	HX_STACK_ARG(matrix,"matrix")
	HX_STACK_ARG(colorTransform,"colorTransform")
	HX_STACK_ARG(blendMode,"blendMode")
	HX_STACK_ARG(clipRect,"clipRect")
	HX_STACK_ARG(smoothing,"smoothing")
{
		HX_STACK_LINE(151)
		::String _g = ::Std_obj::string(blendMode);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(151)
		source->__drawToSurface(this->__handle,matrix,colorTransform,_g,clipRect,smoothing);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC6(BitmapData_obj,draw,(void))

Void BitmapData_obj::dumpBits( ){
{
		HX_STACK_FRAME("flash.display.BitmapData","dumpBits",0x992befa5,"flash.display.BitmapData.dumpBits","flash/display/BitmapData.hx",158,0x1e513fd9)
		HX_STACK_THIS(this)
		HX_STACK_LINE(158)
		::flash::display::BitmapData_obj::lime_bitmap_data_dump_bits(this->__handle);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapData_obj,dumpBits,(void))

::flash::utils::ByteArray BitmapData_obj::encode( ::String format,hx::Null< Float >  __o_quality){
Float quality = __o_quality.Default(0.9);
	HX_STACK_FRAME("flash.display.BitmapData","encode",0xa8511aa1,"flash.display.BitmapData.encode","flash/display/BitmapData.hx",165,0x1e513fd9)
	HX_STACK_THIS(this)
	HX_STACK_ARG(format,"format")
	HX_STACK_ARG(quality,"quality")
{
		HX_STACK_LINE(165)
		return ::flash::display::BitmapData_obj::lime_bitmap_data_encode(this->__handle,format,quality);
	}
}


HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,encode,return )

Void BitmapData_obj::fillRect( ::flash::geom::Rectangle rect,int color){
{
		HX_STACK_FRAME("flash.display.BitmapData","fillRect",0x6f29e692,"flash.display.BitmapData.fillRect","flash/display/BitmapData.hx",186,0x1e513fd9)
		HX_STACK_THIS(this)
		HX_STACK_ARG(rect,"rect")
		HX_STACK_ARG(color,"color")
		HX_STACK_LINE(186)
		::flash::display::BitmapData_obj::lime_bitmap_data_fill(this->__handle,rect,(int(color) & int((int)16777215)),hx::UShr(color,(int)24));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,fillRect,(void))

Void BitmapData_obj::fillRectEx( ::flash::geom::Rectangle rect,int color,hx::Null< int >  __o_alpha){
int alpha = __o_alpha.Default(255);
	HX_STACK_FRAME("flash.display.BitmapData","fillRectEx",0xfa5e6ba5,"flash.display.BitmapData.fillRectEx","flash/display/BitmapData.hx",193,0x1e513fd9)
	HX_STACK_THIS(this)
	HX_STACK_ARG(rect,"rect")
	HX_STACK_ARG(color,"color")
	HX_STACK_ARG(alpha,"alpha")
{
		HX_STACK_LINE(193)
		::flash::display::BitmapData_obj::lime_bitmap_data_fill(this->__handle,rect,color,alpha);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(BitmapData_obj,fillRectEx,(void))

Void BitmapData_obj::floodFill( int x,int y,int color){
{
		HX_STACK_FRAME("flash.display.BitmapData","floodFill",0x79a703b6,"flash.display.BitmapData.floodFill","flash/display/BitmapData.hx",200,0x1e513fd9)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(color,"color")
		HX_STACK_LINE(200)
		::flash::display::BitmapData_obj::lime_bitmap_data_flood_fill(this->__handle,x,y,color);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(BitmapData_obj,floodFill,(void))

::flash::geom::Rectangle BitmapData_obj::generateFilterRect( ::flash::geom::Rectangle sourceRect,::flash::filters::BitmapFilter filter){
	HX_STACK_FRAME("flash.display.BitmapData","generateFilterRect",0x8fa5799c,"flash.display.BitmapData.generateFilterRect","flash/display/BitmapData.hx",205,0x1e513fd9)
	HX_STACK_THIS(this)
	HX_STACK_ARG(sourceRect,"sourceRect")
	HX_STACK_ARG(filter,"filter")
	HX_STACK_LINE(207)
	::flash::geom::Rectangle result = ::flash::geom::Rectangle_obj::__new(null(),null(),null(),null());		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(208)
	::flash::display::BitmapData_obj::lime_bitmap_data_generate_filter_rect(sourceRect,filter,result);
	HX_STACK_LINE(209)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,generateFilterRect,return )

::flash::geom::Rectangle BitmapData_obj::getColorBoundsRect( int mask,int color,hx::Null< bool >  __o_findColor){
bool findColor = __o_findColor.Default(true);
	HX_STACK_FRAME("flash.display.BitmapData","getColorBoundsRect",0x91f5fa91,"flash.display.BitmapData.getColorBoundsRect","flash/display/BitmapData.hx",214,0x1e513fd9)
	HX_STACK_THIS(this)
	HX_STACK_ARG(mask,"mask")
	HX_STACK_ARG(color,"color")
	HX_STACK_ARG(findColor,"findColor")
{
		HX_STACK_LINE(216)
		::flash::geom::Rectangle result = ::flash::geom::Rectangle_obj::__new(null(),null(),null(),null());		HX_STACK_VAR(result,"result");
		HX_STACK_LINE(217)
		::flash::display::BitmapData_obj::lime_bitmap_data_get_color_bounds_rect(this->__handle,mask,color,findColor,result);
		HX_STACK_LINE(218)
		return result;
	}
}


HX_DEFINE_DYNAMIC_FUNC3(BitmapData_obj,getColorBoundsRect,return )

int BitmapData_obj::getPixel( int x,int y){
	HX_STACK_FRAME("flash.display.BitmapData","getPixel",0x24eb775b,"flash.display.BitmapData.getPixel","flash/display/BitmapData.hx",225,0x1e513fd9)
	HX_STACK_THIS(this)
	HX_STACK_ARG(x,"x")
	HX_STACK_ARG(y,"y")
	HX_STACK_LINE(225)
	return ::flash::display::BitmapData_obj::lime_bitmap_data_get_pixel(this->__handle,x,y);
}


HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,getPixel,return )

int BitmapData_obj::getPixel32( int x,int y){
	HX_STACK_FRAME("flash.display.BitmapData","getPixel32",0xd03c70ba,"flash.display.BitmapData.getPixel32","flash/display/BitmapData.hx",232,0x1e513fd9)
	HX_STACK_THIS(this)
	HX_STACK_ARG(x,"x")
	HX_STACK_ARG(y,"y")
	HX_STACK_LINE(232)
	return ::flash::display::BitmapData_obj::lime_bitmap_data_get_pixel32(this->__handle,x,y);
}


HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,getPixel32,return )

::flash::utils::ByteArray BitmapData_obj::getPixels( ::flash::geom::Rectangle rect){
	HX_STACK_FRAME("flash.display.BitmapData","getPixels",0x291cf8b8,"flash.display.BitmapData.getPixels","flash/display/BitmapData.hx",237,0x1e513fd9)
	HX_STACK_THIS(this)
	HX_STACK_ARG(rect,"rect")
	HX_STACK_LINE(239)
	::flash::utils::ByteArray result = ::flash::display::BitmapData_obj::lime_bitmap_data_get_pixels(this->__handle,rect);		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(240)
	if (((result != null()))){
		HX_STACK_LINE(240)
		result->position = result->length;
	}
	HX_STACK_LINE(241)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC1(BitmapData_obj,getPixels,return )

Array< int > BitmapData_obj::getVector( ::flash::geom::Rectangle rect){
	HX_STACK_FRAME("flash.display.BitmapData","getVector",0x33d0ba4e,"flash.display.BitmapData.getVector","flash/display/BitmapData.hx",272,0x1e513fd9)
	HX_STACK_THIS(this)
	HX_STACK_ARG(rect,"rect")
	HX_STACK_LINE(274)
	int pixels = ::Std_obj::_int((rect->width * rect->height));		HX_STACK_VAR(pixels,"pixels");
	HX_STACK_LINE(275)
	if (((pixels < (int)1))){
		HX_STACK_LINE(275)
		return Array_obj< int >::__new();
	}
	HX_STACK_LINE(277)
	Array< int > result = Array_obj< int >::__new();		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(278)
	result[(pixels - (int)1)] = (int)0;
	HX_STACK_LINE(281)
	::flash::display::BitmapData_obj::lime_bitmap_data_get_array(this->__handle,rect,result);
	HX_STACK_LINE(288)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC1(BitmapData_obj,getVector,return )

Void BitmapData_obj::lock( ){
{
		HX_STACK_FRAME("flash.display.BitmapData","lock",0xd434fbb6,"flash.display.BitmapData.lock","flash/display/BitmapData.hx",318,0x1e513fd9)
		HX_STACK_THIS(this)
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapData_obj,lock,(void))

Void BitmapData_obj::multiplyAlpha( ){
{
		HX_STACK_FRAME("flash.display.BitmapData","multiplyAlpha",0x0488c16f,"flash.display.BitmapData.multiplyAlpha","flash/display/BitmapData.hx",327,0x1e513fd9)
		HX_STACK_THIS(this)
		HX_STACK_LINE(327)
		::flash::display::BitmapData_obj::lime_bitmap_data_multiply_alpha(this->__handle);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapData_obj,multiplyAlpha,(void))

Void BitmapData_obj::noise( int randomSeed,hx::Null< int >  __o_low,hx::Null< int >  __o_high,hx::Null< int >  __o_channelOptions,hx::Null< bool >  __o_grayScale){
int low = __o_low.Default(0);
int high = __o_high.Default(255);
int channelOptions = __o_channelOptions.Default(7);
bool grayScale = __o_grayScale.Default(false);
	HX_STACK_FRAME("flash.display.BitmapData","noise",0x00f9016f,"flash.display.BitmapData.noise","flash/display/BitmapData.hx",334,0x1e513fd9)
	HX_STACK_THIS(this)
	HX_STACK_ARG(randomSeed,"randomSeed")
	HX_STACK_ARG(low,"low")
	HX_STACK_ARG(high,"high")
	HX_STACK_ARG(channelOptions,"channelOptions")
	HX_STACK_ARG(grayScale,"grayScale")
{
		HX_STACK_LINE(334)
		::flash::display::BitmapData_obj::lime_bitmap_data_noise(this->__handle,randomSeed,low,high,channelOptions,grayScale);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC5(BitmapData_obj,noise,(void))

Void BitmapData_obj::paletteMap( ::flash::display::BitmapData sourceBitmapData,::flash::geom::Rectangle sourceRect,::flash::geom::Point destPoint,Array< int > redArray,Array< int > greenArray,Array< int > blueArray,Array< int > alphaArray){
{
		HX_STACK_FRAME("flash.display.BitmapData","paletteMap",0xfeff78ec,"flash.display.BitmapData.paletteMap","flash/display/BitmapData.hx",339,0x1e513fd9)
		HX_STACK_THIS(this)
		HX_STACK_ARG(sourceBitmapData,"sourceBitmapData")
		HX_STACK_ARG(sourceRect,"sourceRect")
		HX_STACK_ARG(destPoint,"destPoint")
		HX_STACK_ARG(redArray,"redArray")
		HX_STACK_ARG(greenArray,"greenArray")
		HX_STACK_ARG(blueArray,"blueArray")
		HX_STACK_ARG(alphaArray,"alphaArray")
		HX_STACK_LINE(340)
		::flash::utils::ByteArray memory = ::flash::utils::ByteArray_obj::__new(null());		HX_STACK_VAR(memory,"memory");
		HX_STACK_LINE(341)
		int sw = ::Std_obj::_int(sourceRect->width);		HX_STACK_VAR(sw,"sw");
		HX_STACK_LINE(342)
		int sh = ::Std_obj::_int(sourceRect->height);		HX_STACK_VAR(sh,"sh");
		HX_STACK_LINE(343)
		memory->setLength(((sw * sh) * (int)4));
		HX_STACK_LINE(344)
		::flash::utils::ByteArray _g = this->getPixels(sourceRect);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(344)
		memory = _g;
		HX_STACK_LINE(345)
		memory->position = (int)0;
		HX_STACK_LINE(346)
		::flash::Memory_obj::select(memory);
		HX_STACK_LINE(348)
		int position;		HX_STACK_VAR(position,"position");
		HX_STACK_LINE(348)
		int pixelValue;		HX_STACK_VAR(pixelValue,"pixelValue");
		HX_STACK_LINE(348)
		int r;		HX_STACK_VAR(r,"r");
		HX_STACK_LINE(348)
		int g;		HX_STACK_VAR(g,"g");
		HX_STACK_LINE(348)
		int b;		HX_STACK_VAR(b,"b");
		HX_STACK_LINE(348)
		int color;		HX_STACK_VAR(color,"color");
		HX_STACK_LINE(350)
		{
			HX_STACK_LINE(350)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(350)
			int _g2 = (sh * sw);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(350)
			while((true)){
				HX_STACK_LINE(350)
				if ((!(((_g1 < _g2))))){
					HX_STACK_LINE(350)
					break;
				}
				HX_STACK_LINE(350)
				int i = (_g1)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(351)
				position = (i * (int)4);
				HX_STACK_LINE(352)
				int _g11 = ::flash::Memory_obj::getI32(position);		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(352)
				pixelValue = _g11;
				HX_STACK_LINE(354)
				r = (int((int(pixelValue) >> int((int)8))) & int((int)255));
				HX_STACK_LINE(355)
				g = (int((int(pixelValue) >> int((int)16))) & int((int)255));
				HX_STACK_LINE(356)
				b = (int((int(pixelValue) >> int((int)24))) & int((int)255));
				HX_STACK_LINE(358)
				{
					HX_STACK_LINE(358)
					int pixel = (int((int((int((int)-16777216) | int(redArray->__get(r)))) | int(greenArray->__get(g)))) | int(blueArray->__get(b)));		HX_STACK_VAR(pixel,"pixel");
					HX_STACK_LINE(358)
					color = (int((int((int((int(((int(pixel) & int((int)255)))) << int((int)24))) | int((int(((int((int(pixel) >> int((int)8))) & int((int)255)))) << int((int)16))))) | int((int(((int((int(pixel) >> int((int)16))) & int((int)255)))) << int((int)8))))) | int((int((int(pixel) >> int((int)24))) & int((int)255))));
				}
				HX_STACK_LINE(363)
				::flash::Memory_obj::setI32(position,color);
			}
		}
		HX_STACK_LINE(366)
		memory->position = (int)0;
		HX_STACK_LINE(367)
		::flash::geom::Rectangle destRect = ::flash::geom::Rectangle_obj::__new(destPoint->x,destPoint->y,sw,sh);		HX_STACK_VAR(destRect,"destRect");
		HX_STACK_LINE(368)
		this->setPixels(destRect,memory);
		HX_STACK_LINE(369)
		::flash::Memory_obj::select(null());
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC7(BitmapData_obj,paletteMap,(void))

Void BitmapData_obj::perlinNoise( Float baseX,Float baseY,int numOctaves,int randomSeed,bool stitch,bool fractalNoise,hx::Null< int >  __o_channelOptions,hx::Null< bool >  __o_grayScale,Array< ::Dynamic > offsets){
int channelOptions = __o_channelOptions.Default(7);
bool grayScale = __o_grayScale.Default(false);
	HX_STACK_FRAME("flash.display.BitmapData","perlinNoise",0x4c7583fb,"flash.display.BitmapData.perlinNoise","flash/display/BitmapData.hx",373,0x1e513fd9)
	HX_STACK_THIS(this)
	HX_STACK_ARG(baseX,"baseX")
	HX_STACK_ARG(baseY,"baseY")
	HX_STACK_ARG(numOctaves,"numOctaves")
	HX_STACK_ARG(randomSeed,"randomSeed")
	HX_STACK_ARG(stitch,"stitch")
	HX_STACK_ARG(fractalNoise,"fractalNoise")
	HX_STACK_ARG(channelOptions,"channelOptions")
	HX_STACK_ARG(grayScale,"grayScale")
	HX_STACK_ARG(offsets,"offsets")
{
		HX_STACK_LINE(375)
		::flash::display::OptimizedPerlin perlin = ::flash::display::OptimizedPerlin_obj::__new(randomSeed,numOctaves,null());		HX_STACK_VAR(perlin,"perlin");
		HX_STACK_LINE(376)
		perlin->fill(hx::ObjectPtr<OBJ_>(this),baseX,baseY,(int)0,null());
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC9(BitmapData_obj,perlinNoise,(void))

Void BitmapData_obj::scroll( int x,int y){
{
		HX_STACK_FRAME("flash.display.BitmapData","scroll",0xf5d20098,"flash.display.BitmapData.scroll","flash/display/BitmapData.hx",390,0x1e513fd9)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_LINE(390)
		::flash::display::BitmapData_obj::lime_bitmap_data_scroll(this->__handle,x,y);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,scroll,(void))

Void BitmapData_obj::setFlags( int flags){
{
		HX_STACK_FRAME("flash.display.BitmapData","setFlags",0x13313590,"flash.display.BitmapData.setFlags","flash/display/BitmapData.hx",398,0x1e513fd9)
		HX_STACK_THIS(this)
		HX_STACK_ARG(flags,"flags")
		HX_STACK_LINE(398)
		::flash::display::BitmapData_obj::lime_bitmap_data_set_flags(this->__handle,flags);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(BitmapData_obj,setFlags,(void))

Void BitmapData_obj::setFormat( int format){
{
		HX_STACK_FRAME("flash.display.BitmapData","setFormat",0x7d5284ce,"flash.display.BitmapData.setFormat","flash/display/BitmapData.hx",405,0x1e513fd9)
		HX_STACK_THIS(this)
		HX_STACK_ARG(format,"format")
		HX_STACK_LINE(405)
		::flash::display::BitmapData_obj::lime_bitmap_data_set_format(this->__handle,format);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(BitmapData_obj,setFormat,(void))

Void BitmapData_obj::setPixel( int x,int y,int color){
{
		HX_STACK_FRAME("flash.display.BitmapData","setPixel",0xd348d0cf,"flash.display.BitmapData.setPixel","flash/display/BitmapData.hx",412,0x1e513fd9)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(color,"color")
		HX_STACK_LINE(412)
		::flash::display::BitmapData_obj::lime_bitmap_data_set_pixel(this->__handle,x,y,color);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(BitmapData_obj,setPixel,(void))

Void BitmapData_obj::setPixel32( int x,int y,int color){
{
		HX_STACK_FRAME("flash.display.BitmapData","setPixel32",0xd3ba0f2e,"flash.display.BitmapData.setPixel32","flash/display/BitmapData.hx",419,0x1e513fd9)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(color,"color")
		HX_STACK_LINE(419)
		::flash::display::BitmapData_obj::lime_bitmap_data_set_pixel32(this->__handle,x,y,color);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(BitmapData_obj,setPixel32,(void))

Void BitmapData_obj::setPixels( ::flash::geom::Rectangle rect,::flash::utils::ByteArray pixels){
{
		HX_STACK_FRAME("flash.display.BitmapData","setPixels",0x0c6de4c4,"flash.display.BitmapData.setPixels","flash/display/BitmapData.hx",424,0x1e513fd9)
		HX_STACK_THIS(this)
		HX_STACK_ARG(rect,"rect")
		HX_STACK_ARG(pixels,"pixels")
		HX_STACK_LINE(426)
		int size = ::Std_obj::_int(((rect->width * rect->height) * (int)4));		HX_STACK_VAR(size,"size");
		HX_STACK_LINE(427)
		int _g = ::Std_obj::_int(size);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(427)
		pixels->checkData(_g);
		HX_STACK_LINE(428)
		::flash::display::BitmapData_obj::lime_bitmap_data_set_bytes(this->__handle,rect,pixels,pixels->position);
		HX_STACK_LINE(429)
		hx::AddEq(pixels->position,size);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,setPixels,(void))

Void BitmapData_obj::setVector( ::flash::geom::Rectangle rect,Array< int > pixels){
{
		HX_STACK_FRAME("flash.display.BitmapData","setVector",0x1721a65a,"flash.display.BitmapData.setVector","flash/display/BitmapData.hx",434,0x1e513fd9)
		HX_STACK_THIS(this)
		HX_STACK_ARG(rect,"rect")
		HX_STACK_ARG(pixels,"pixels")
		HX_STACK_LINE(436)
		int count = ::Std_obj::_int((rect->width * rect->height));		HX_STACK_VAR(count,"count");
		HX_STACK_LINE(437)
		if (((pixels->length < count))){
			HX_STACK_LINE(437)
			return null();
		}
		HX_STACK_LINE(440)
		::flash::display::BitmapData_obj::lime_bitmap_data_set_array(this->__handle,rect,pixels);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,setVector,(void))

int BitmapData_obj::threshold( ::flash::display::BitmapData sourceBitmapData,::flash::geom::Rectangle sourceRect,::flash::geom::Point destPoint,::String operation,int threshold,hx::Null< int >  __o_color,hx::Null< int >  __o_mask,hx::Null< bool >  __o_copySource){
int color = __o_color.Default(0);
int mask = __o_mask.Default(-1);
bool copySource = __o_copySource.Default(false);
	HX_STACK_FRAME("flash.display.BitmapData","threshold",0x54c04400,"flash.display.BitmapData.threshold","flash/display/BitmapData.hx",458,0x1e513fd9)
	HX_STACK_THIS(this)
	HX_STACK_ARG(sourceBitmapData,"sourceBitmapData")
	HX_STACK_ARG(sourceRect,"sourceRect")
	HX_STACK_ARG(destPoint,"destPoint")
	HX_STACK_ARG(operation,"operation")
	HX_STACK_ARG(threshold,"threshold")
	HX_STACK_ARG(color,"color")
	HX_STACK_ARG(mask,"mask")
	HX_STACK_ARG(copySource,"copySource")
{
		struct _Function_1_1{
			inline static bool Block( hx::ObjectPtr< ::flash::display::BitmapData_obj > __this,::flash::geom::Rectangle &sourceRect){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","flash/display/BitmapData.hx",458,0x1e513fd9)
				{
					HX_STACK_LINE(458)
					::flash::geom::Rectangle _g = __this->get_rect();		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(458)
					return sourceRect->equals(_g);
				}
				return null();
			}
		};
		HX_STACK_LINE(458)
		if (((  (((  (((  (((sourceBitmapData == hx::ObjectPtr<OBJ_>(this)))) ? bool(_Function_1_1::Block(this,sourceRect)) : bool(false) ))) ? bool((destPoint->x == (int)0)) : bool(false) ))) ? bool((destPoint->y == (int)0)) : bool(false) ))){
			HX_STACK_LINE(460)
			int hits = (int)0;		HX_STACK_VAR(hits,"hits");
			HX_STACK_LINE(462)
			threshold = (int((int((int((int(((int(threshold) & int((int)255)))) << int((int)24))) | int((int(((int((int(threshold) >> int((int)8))) & int((int)255)))) << int((int)16))))) | int((int(((int((int(threshold) >> int((int)16))) & int((int)255)))) << int((int)8))))) | int((int((int(threshold) >> int((int)24))) & int((int)255))));
			HX_STACK_LINE(463)
			color = (int((int((int((int(((int(color) & int((int)255)))) << int((int)24))) | int((int(((int((int(color) >> int((int)8))) & int((int)255)))) << int((int)16))))) | int((int(((int((int(color) >> int((int)16))) & int((int)255)))) << int((int)8))))) | int((int((int(color) >> int((int)24))) & int((int)255))));
			HX_STACK_LINE(465)
			::flash::utils::ByteArray memory = ::flash::utils::ByteArray_obj::__new(null());		HX_STACK_VAR(memory,"memory");
			HX_STACK_LINE(466)
			int _g1 = this->get_width();		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(466)
			int _g2 = this->get_height();		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(466)
			int _g3 = (_g1 * _g2);		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(466)
			int _g4 = (_g3 * (int)4);		HX_STACK_VAR(_g4,"_g4");
			HX_STACK_LINE(466)
			memory->setLength(_g4);
			HX_STACK_LINE(467)
			::flash::geom::Rectangle _g5 = this->get_rect();		HX_STACK_VAR(_g5,"_g5");
			HX_STACK_LINE(467)
			::flash::utils::ByteArray _g6 = this->getPixels(_g5);		HX_STACK_VAR(_g6,"_g6");
			HX_STACK_LINE(467)
			memory = _g6;
			HX_STACK_LINE(468)
			memory->position = (int)0;
			HX_STACK_LINE(469)
			::flash::Memory_obj::select(memory);
			HX_STACK_LINE(471)
			int thresholdMask = (int(threshold) & int(mask));		HX_STACK_VAR(thresholdMask,"thresholdMask");
			HX_STACK_LINE(473)
			int width_yy;		HX_STACK_VAR(width_yy,"width_yy");
			HX_STACK_LINE(473)
			int position;		HX_STACK_VAR(position,"position");
			HX_STACK_LINE(473)
			int pixelMask;		HX_STACK_VAR(pixelMask,"pixelMask");
			HX_STACK_LINE(473)
			int pixelValue;		HX_STACK_VAR(pixelValue,"pixelValue");
			HX_STACK_LINE(473)
			int i;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(473)
			bool test;		HX_STACK_VAR(test,"test");
			HX_STACK_LINE(475)
			{
				HX_STACK_LINE(475)
				int _g11 = (int)0;		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(475)
				int _g = this->get_height();		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(475)
				while((true)){
					HX_STACK_LINE(475)
					if ((!(((_g11 < _g))))){
						HX_STACK_LINE(475)
						break;
					}
					HX_STACK_LINE(475)
					int yy = (_g11)++;		HX_STACK_VAR(yy,"yy");
					HX_STACK_LINE(477)
					int _g7 = this->get_width();		HX_STACK_VAR(_g7,"_g7");
					HX_STACK_LINE(477)
					int _g8 = (_g7 * yy);		HX_STACK_VAR(_g8,"_g8");
					HX_STACK_LINE(477)
					width_yy = _g8;
					HX_STACK_LINE(479)
					{
						HX_STACK_LINE(479)
						int _g31 = (int)0;		HX_STACK_VAR(_g31,"_g31");
						HX_STACK_LINE(479)
						int _g21 = this->get_width();		HX_STACK_VAR(_g21,"_g21");
						HX_STACK_LINE(479)
						while((true)){
							HX_STACK_LINE(479)
							if ((!(((_g31 < _g21))))){
								HX_STACK_LINE(479)
								break;
							}
							HX_STACK_LINE(479)
							int xx = (_g31)++;		HX_STACK_VAR(xx,"xx");
							HX_STACK_LINE(481)
							position = (((width_yy + xx)) * (int)4);
							HX_STACK_LINE(482)
							int _g9 = ::flash::Memory_obj::getI32(position);		HX_STACK_VAR(_g9,"_g9");
							HX_STACK_LINE(482)
							pixelValue = _g9;
							HX_STACK_LINE(483)
							pixelMask = (int(pixelValue) & int(mask));
							HX_STACK_LINE(485)
							int _g10 = ::flash::display::BitmapData_obj::__ucompare(pixelMask,thresholdMask);		HX_STACK_VAR(_g10,"_g10");
							HX_STACK_LINE(485)
							i = _g10;
							HX_STACK_LINE(486)
							test = false;
							HX_STACK_LINE(488)
							if (((operation == HX_CSTRING("==")))){
								HX_STACK_LINE(488)
								test = (i == (int)0);
							}
							else{
								HX_STACK_LINE(489)
								if (((operation == HX_CSTRING("<")))){
									HX_STACK_LINE(489)
									test = (i == (int)-1);
								}
								else{
									HX_STACK_LINE(490)
									if (((operation == HX_CSTRING(">")))){
										HX_STACK_LINE(490)
										test = (i == (int)1);
									}
									else{
										HX_STACK_LINE(491)
										if (((operation == HX_CSTRING("!=")))){
											HX_STACK_LINE(491)
											test = (i != (int)0);
										}
										else{
											HX_STACK_LINE(492)
											if (((operation == HX_CSTRING("<=")))){
												HX_STACK_LINE(492)
												test = (bool((i == (int)0)) || bool((i == (int)-1)));
											}
											else{
												HX_STACK_LINE(493)
												if (((operation == HX_CSTRING(">=")))){
													HX_STACK_LINE(493)
													test = (bool((i == (int)0)) || bool((i == (int)1)));
												}
											}
										}
									}
								}
							}
							HX_STACK_LINE(495)
							if ((test)){
								HX_STACK_LINE(497)
								::flash::Memory_obj::setI32(position,color);
								HX_STACK_LINE(498)
								(hits)++;
							}
						}
					}
				}
			}
			HX_STACK_LINE(506)
			memory->position = (int)0;
			HX_STACK_LINE(507)
			::flash::geom::Rectangle _g11 = this->get_rect();		HX_STACK_VAR(_g11,"_g11");
			HX_STACK_LINE(507)
			this->setPixels(_g11,memory);
			HX_STACK_LINE(508)
			::flash::Memory_obj::select(null());
			HX_STACK_LINE(509)
			return hits;
		}
		else{
			HX_STACK_LINE(513)
			int sx = ::Std_obj::_int(sourceRect->x);		HX_STACK_VAR(sx,"sx");
			HX_STACK_LINE(514)
			int sy = ::Std_obj::_int(sourceRect->y);		HX_STACK_VAR(sy,"sy");
			HX_STACK_LINE(515)
			int _g12 = sourceBitmapData->get_width();		HX_STACK_VAR(_g12,"_g12");
			HX_STACK_LINE(515)
			int sw = ::Std_obj::_int(_g12);		HX_STACK_VAR(sw,"sw");
			HX_STACK_LINE(516)
			int _g13 = sourceBitmapData->get_height();		HX_STACK_VAR(_g13,"_g13");
			HX_STACK_LINE(516)
			int sh = ::Std_obj::_int(_g13);		HX_STACK_VAR(sh,"sh");
			HX_STACK_LINE(518)
			int dx = ::Std_obj::_int(destPoint->x);		HX_STACK_VAR(dx,"dx");
			HX_STACK_LINE(519)
			int dy = ::Std_obj::_int(destPoint->y);		HX_STACK_VAR(dy,"dy");
			HX_STACK_LINE(521)
			int _g14 = this->get_width();		HX_STACK_VAR(_g14,"_g14");
			HX_STACK_LINE(521)
			int _g15 = (_g14 - sw);		HX_STACK_VAR(_g15,"_g15");
			HX_STACK_LINE(521)
			int bw = (_g15 - dx);		HX_STACK_VAR(bw,"bw");
			HX_STACK_LINE(522)
			int _g16 = this->get_height();		HX_STACK_VAR(_g16,"_g16");
			HX_STACK_LINE(522)
			int _g17 = (_g16 - sh);		HX_STACK_VAR(_g17,"_g17");
			HX_STACK_LINE(522)
			int bh = (_g17 - dy);		HX_STACK_VAR(bh,"bh");
			HX_STACK_LINE(524)
			int dw;		HX_STACK_VAR(dw,"dw");
			HX_STACK_LINE(524)
			if (((bw < (int)0))){
				HX_STACK_LINE(524)
				int _g18 = this->get_width();		HX_STACK_VAR(_g18,"_g18");
				HX_STACK_LINE(524)
				int _g19 = (_g18 - sw);		HX_STACK_VAR(_g19,"_g19");
				HX_STACK_LINE(524)
				int _g20 = (_g19 - dx);		HX_STACK_VAR(_g20,"_g20");
				HX_STACK_LINE(524)
				dw = (sw + _g20);
			}
			else{
				HX_STACK_LINE(524)
				dw = sw;
			}
			HX_STACK_LINE(525)
			int dh;		HX_STACK_VAR(dh,"dh");
			HX_STACK_LINE(525)
			if (((bw < (int)0))){
				HX_STACK_LINE(525)
				int _g21 = this->get_height();		HX_STACK_VAR(_g21,"_g21");
				HX_STACK_LINE(525)
				int _g22 = (_g21 - sh);		HX_STACK_VAR(_g22,"_g22");
				HX_STACK_LINE(525)
				int _g23 = (_g22 - dy);		HX_STACK_VAR(_g23,"_g23");
				HX_STACK_LINE(525)
				dh = (sh + _g23);
			}
			else{
				HX_STACK_LINE(525)
				dh = sh;
			}
			HX_STACK_LINE(527)
			int hits = (int)0;		HX_STACK_VAR(hits,"hits");
			HX_STACK_LINE(529)
			threshold = (int((int((int((int(((int(threshold) & int((int)255)))) << int((int)24))) | int((int(((int((int(threshold) >> int((int)8))) & int((int)255)))) << int((int)16))))) | int((int(((int((int(threshold) >> int((int)16))) & int((int)255)))) << int((int)8))))) | int((int((int(threshold) >> int((int)24))) & int((int)255))));
			HX_STACK_LINE(530)
			color = (int((int((int((int(((int(color) & int((int)255)))) << int((int)24))) | int((int(((int((int(color) >> int((int)8))) & int((int)255)))) << int((int)16))))) | int((int(((int((int(color) >> int((int)16))) & int((int)255)))) << int((int)8))))) | int((int((int(color) >> int((int)24))) & int((int)255))));
			HX_STACK_LINE(532)
			int canvasMemory = ((sw * sh) * (int)4);		HX_STACK_VAR(canvasMemory,"canvasMemory");
			HX_STACK_LINE(533)
			int sourceMemory = (int)0;		HX_STACK_VAR(sourceMemory,"sourceMemory");
			HX_STACK_LINE(535)
			if ((copySource)){
				HX_STACK_LINE(537)
				sourceMemory = ((sw * sh) * (int)4);
			}
			HX_STACK_LINE(541)
			int totalMemory = (canvasMemory + sourceMemory);		HX_STACK_VAR(totalMemory,"totalMemory");
			HX_STACK_LINE(542)
			::flash::utils::ByteArray memory = ::flash::utils::ByteArray_obj::__new(null());		HX_STACK_VAR(memory,"memory");
			HX_STACK_LINE(543)
			memory->setLength(totalMemory);
			HX_STACK_LINE(544)
			memory->position = (int)0;
			HX_STACK_LINE(545)
			::flash::display::BitmapData bitmapData = sourceBitmapData->clone();		HX_STACK_VAR(bitmapData,"bitmapData");
			HX_STACK_LINE(546)
			::flash::utils::ByteArray pixels = bitmapData->getPixels(sourceRect);		HX_STACK_VAR(pixels,"pixels");
			HX_STACK_LINE(547)
			memory->writeBytes(pixels,null(),null());
			HX_STACK_LINE(548)
			memory->position = canvasMemory;
			HX_STACK_LINE(550)
			if ((copySource)){
				HX_STACK_LINE(552)
				memory->writeBytes(pixels,null(),null());
			}
			HX_STACK_LINE(556)
			memory->position = (int)0;
			HX_STACK_LINE(557)
			::flash::Memory_obj::select(memory);
			HX_STACK_LINE(559)
			int thresholdMask = (int(threshold) & int(mask));		HX_STACK_VAR(thresholdMask,"thresholdMask");
			HX_STACK_LINE(561)
			int position;		HX_STACK_VAR(position,"position");
			HX_STACK_LINE(561)
			int pixelMask;		HX_STACK_VAR(pixelMask,"pixelMask");
			HX_STACK_LINE(561)
			int pixelValue;		HX_STACK_VAR(pixelValue,"pixelValue");
			HX_STACK_LINE(561)
			int i;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(561)
			bool test;		HX_STACK_VAR(test,"test");
			HX_STACK_LINE(563)
			{
				HX_STACK_LINE(563)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(563)
				while((true)){
					HX_STACK_LINE(563)
					if ((!(((_g < dh))))){
						HX_STACK_LINE(563)
						break;
					}
					HX_STACK_LINE(563)
					int yy = (_g)++;		HX_STACK_VAR(yy,"yy");
					HX_STACK_LINE(565)
					{
						HX_STACK_LINE(565)
						int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
						HX_STACK_LINE(565)
						while((true)){
							HX_STACK_LINE(565)
							if ((!(((_g1 < dw))))){
								HX_STACK_LINE(565)
								break;
							}
							HX_STACK_LINE(565)
							int xx = (_g1)++;		HX_STACK_VAR(xx,"xx");
							HX_STACK_LINE(567)
							position = ((((xx + sx) + (((yy + sy)) * sw))) * (int)4);
							HX_STACK_LINE(568)
							int _g24 = ::flash::Memory_obj::getI32(position);		HX_STACK_VAR(_g24,"_g24");
							HX_STACK_LINE(568)
							pixelValue = _g24;
							HX_STACK_LINE(569)
							pixelMask = (int(pixelValue) & int(mask));
							HX_STACK_LINE(571)
							int _g25 = ::flash::display::BitmapData_obj::__ucompare(pixelMask,thresholdMask);		HX_STACK_VAR(_g25,"_g25");
							HX_STACK_LINE(571)
							i = _g25;
							HX_STACK_LINE(572)
							test = false;
							HX_STACK_LINE(574)
							if (((operation == HX_CSTRING("==")))){
								HX_STACK_LINE(574)
								test = (i == (int)0);
							}
							else{
								HX_STACK_LINE(575)
								if (((operation == HX_CSTRING("<")))){
									HX_STACK_LINE(575)
									test = (i == (int)-1);
								}
								else{
									HX_STACK_LINE(576)
									if (((operation == HX_CSTRING(">")))){
										HX_STACK_LINE(576)
										test = (i == (int)1);
									}
									else{
										HX_STACK_LINE(577)
										if (((operation == HX_CSTRING("!=")))){
											HX_STACK_LINE(577)
											test = (i != (int)0);
										}
										else{
											HX_STACK_LINE(578)
											if (((operation == HX_CSTRING("<=")))){
												HX_STACK_LINE(578)
												test = (bool((i == (int)0)) || bool((i == (int)-1)));
											}
											else{
												HX_STACK_LINE(579)
												if (((operation == HX_CSTRING(">=")))){
													HX_STACK_LINE(579)
													test = (bool((i == (int)0)) || bool((i == (int)1)));
												}
											}
										}
									}
								}
							}
							HX_STACK_LINE(581)
							if ((test)){
								HX_STACK_LINE(583)
								::flash::Memory_obj::setI32(position,color);
								HX_STACK_LINE(584)
								(hits)++;
							}
							else{
								HX_STACK_LINE(586)
								if ((copySource)){
									HX_STACK_LINE(588)
									int _g26 = ::flash::Memory_obj::getI32((canvasMemory + position));		HX_STACK_VAR(_g26,"_g26");
									HX_STACK_LINE(588)
									::flash::Memory_obj::setI32(position,_g26);
								}
							}
						}
					}
				}
			}
			HX_STACK_LINE(596)
			memory->position = (int)0;
			HX_STACK_LINE(597)
			bitmapData->setPixels(sourceRect,memory);
			HX_STACK_LINE(598)
			::flash::geom::Rectangle _g27 = bitmapData->get_rect();		HX_STACK_VAR(_g27,"_g27");
			HX_STACK_LINE(598)
			this->copyPixels(bitmapData,_g27,destPoint,null(),null(),null());
			HX_STACK_LINE(599)
			::flash::Memory_obj::select(null());
			HX_STACK_LINE(600)
			return hits;
		}
		HX_STACK_LINE(458)
		return (int)0;
	}
}


HX_DEFINE_DYNAMIC_FUNC8(BitmapData_obj,threshold,return )

Void BitmapData_obj::unlock( ::flash::geom::Rectangle changeRect){
{
		HX_STACK_FRAME("flash.display.BitmapData","unlock",0x13f9cb4f,"flash.display.BitmapData.unlock","flash/display/BitmapData.hx",607,0x1e513fd9)
		HX_STACK_THIS(this)
		HX_STACK_ARG(changeRect,"changeRect")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(BitmapData_obj,unlock,(void))

Void BitmapData_obj::unmultiplyAlpha( ){
{
		HX_STACK_FRAME("flash.display.BitmapData","unmultiplyAlpha",0xcfb3b6b6,"flash.display.BitmapData.unmultiplyAlpha","flash/display/BitmapData.hx",616,0x1e513fd9)
		HX_STACK_THIS(this)
		HX_STACK_LINE(616)
		::flash::display::BitmapData_obj::lime_bitmap_data_unmultiply_alpha(this->__handle);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapData_obj,unmultiplyAlpha,(void))

Void BitmapData_obj::__drawToSurface( Dynamic surface,::flash::geom::Matrix matrix,::flash::geom::ColorTransform colorTransform,::String blendMode,::flash::geom::Rectangle clipRect,bool smoothing){
{
		HX_STACK_FRAME("flash.display.BitmapData","__drawToSurface",0x1ad3d843,"flash.display.BitmapData.__drawToSurface","flash/display/BitmapData.hx",623,0x1e513fd9)
		HX_STACK_THIS(this)
		HX_STACK_ARG(surface,"surface")
		HX_STACK_ARG(matrix,"matrix")
		HX_STACK_ARG(colorTransform,"colorTransform")
		HX_STACK_ARG(blendMode,"blendMode")
		HX_STACK_ARG(clipRect,"clipRect")
		HX_STACK_ARG(smoothing,"smoothing")
		HX_STACK_LINE(623)
		::flash::display::BitmapData_obj::lime_render_surface_to_surface(surface,this->__handle,matrix,colorTransform,blendMode,clipRect,smoothing);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC6(BitmapData_obj,__drawToSurface,(void))

Void BitmapData_obj::__loadFromBytes( ::flash::utils::ByteArray bytes,::flash::utils::ByteArray rawAlpha){
{
		HX_STACK_FRAME("flash.display.BitmapData","__loadFromBytes",0x2355ea90,"flash.display.BitmapData.__loadFromBytes","flash/display/BitmapData.hx",635,0x1e513fd9)
		HX_STACK_THIS(this)
		HX_STACK_ARG(bytes,"bytes")
		HX_STACK_ARG(rawAlpha,"rawAlpha")
		HX_STACK_LINE(637)
		Dynamic _g = ::flash::display::BitmapData_obj::lime_bitmap_data_from_bytes(bytes,rawAlpha);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(637)
		this->__handle = _g;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,__loadFromBytes,(void))

bool BitmapData_obj::get_premultipliedAlpha( ){
	HX_STACK_FRAME("flash.display.BitmapData","get_premultipliedAlpha",0xbf9135fc,"flash.display.BitmapData.get_premultipliedAlpha","flash/display/BitmapData.hx",703,0x1e513fd9)
	HX_STACK_THIS(this)
	HX_STACK_LINE(703)
	return ::flash::display::BitmapData_obj::lime_bitmap_data_get_prem_alpha(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapData_obj,get_premultipliedAlpha,return )

bool BitmapData_obj::set_premultipliedAlpha( bool value){
	HX_STACK_FRAME("flash.display.BitmapData","set_premultipliedAlpha",0xf33cb270,"flash.display.BitmapData.set_premultipliedAlpha","flash/display/BitmapData.hx",704,0x1e513fd9)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(704)
	::flash::display::BitmapData_obj::lime_bitmap_data_set_prem_alpha(this->__handle,value);
	HX_STACK_LINE(704)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(BitmapData_obj,set_premultipliedAlpha,return )

::flash::geom::Rectangle BitmapData_obj::get_rect( ){
	HX_STACK_FRAME("flash.display.BitmapData","get_rect",0xcdd2a9f8,"flash.display.BitmapData.get_rect","flash/display/BitmapData.hx",705,0x1e513fd9)
	HX_STACK_THIS(this)
	HX_STACK_LINE(705)
	int _g = this->get_width();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(705)
	int _g1 = this->get_height();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(705)
	return ::flash::geom::Rectangle_obj::__new((int)0,(int)0,_g,_g1);
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapData_obj,get_rect,return )

int BitmapData_obj::get_width( ){
	HX_STACK_FRAME("flash.display.BitmapData","get_width",0x2e2892b2,"flash.display.BitmapData.get_width","flash/display/BitmapData.hx",706,0x1e513fd9)
	HX_STACK_THIS(this)
	HX_STACK_LINE(706)
	return ::flash::display::BitmapData_obj::lime_bitmap_data_width(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapData_obj,get_width,return )

int BitmapData_obj::get_height( ){
	HX_STACK_FRAME("flash.display.BitmapData","get_height",0xeba741bb,"flash.display.BitmapData.get_height","flash/display/BitmapData.hx",707,0x1e513fd9)
	HX_STACK_THIS(this)
	HX_STACK_LINE(707)
	return ::flash::display::BitmapData_obj::lime_bitmap_data_height(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapData_obj,get_height,return )

bool BitmapData_obj::get_transparent( ){
	HX_STACK_FRAME("flash.display.BitmapData","get_transparent",0x8ab8d0fe,"flash.display.BitmapData.get_transparent","flash/display/BitmapData.hx",708,0x1e513fd9)
	HX_STACK_THIS(this)
	HX_STACK_LINE(708)
	return this->__transparent;
}


HX_DEFINE_DYNAMIC_FUNC0(BitmapData_obj,get_transparent,return )

int BitmapData_obj::CLEAR;

int BitmapData_obj::BLACK;

int BitmapData_obj::WHITE;

int BitmapData_obj::RED;

int BitmapData_obj::GREEN;

int BitmapData_obj::BLUE;

::String BitmapData_obj::PNG;

::String BitmapData_obj::JPG;

int BitmapData_obj::TRANSPARENT;

int BitmapData_obj::HARDWARE;

int BitmapData_obj::FORMAT_8888;

int BitmapData_obj::FORMAT_4444;

int BitmapData_obj::FORMAT_565;

int BitmapData_obj::createColor( int rgb,hx::Null< int >  __o_alpha){
int alpha = __o_alpha.Default(255);
	HX_STACK_FRAME("flash.display.BitmapData","createColor",0x3454a85c,"flash.display.BitmapData.createColor","flash/display/BitmapData.hx",115,0x1e513fd9)
	HX_STACK_ARG(rgb,"rgb")
	HX_STACK_ARG(alpha,"alpha")
{
		HX_STACK_LINE(115)
		return (int(rgb) | int((int(alpha) << int((int)24))));
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,createColor,return )

int BitmapData_obj::extractAlpha( int argb){
	HX_STACK_FRAME("flash.display.BitmapData","extractAlpha",0xedfe5928,"flash.display.BitmapData.extractAlpha","flash/display/BitmapData.hx",172,0x1e513fd9)
	HX_STACK_ARG(argb,"argb")
	HX_STACK_LINE(172)
	return hx::UShr(argb,(int)24);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(BitmapData_obj,extractAlpha,return )

int BitmapData_obj::extractColor( int argb){
	HX_STACK_FRAME("flash.display.BitmapData","extractColor",0x16c4232d,"flash.display.BitmapData.extractColor","flash/display/BitmapData.hx",179,0x1e513fd9)
	HX_STACK_ARG(argb,"argb")
	HX_STACK_LINE(179)
	return (int(argb) & int((int)16777215));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(BitmapData_obj,extractColor,return )

::flash::utils::ByteArray BitmapData_obj::getRGBAPixels( ::flash::display::BitmapData bitmapData){
	HX_STACK_FRAME("flash.display.BitmapData","getRGBAPixels",0x272ea1ec,"flash.display.BitmapData.getRGBAPixels","flash/display/BitmapData.hx",246,0x1e513fd9)
	HX_STACK_ARG(bitmapData,"bitmapData")
	HX_STACK_LINE(248)
	int _g = bitmapData->get_width();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(248)
	int _g1 = bitmapData->get_height();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(248)
	::flash::geom::Rectangle _g2 = ::flash::geom::Rectangle_obj::__new((int)0,(int)0,_g,_g1);		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(248)
	::flash::utils::ByteArray data = bitmapData->getPixels(_g2);		HX_STACK_VAR(data,"data");
	HX_STACK_LINE(249)
	int _g3 = bitmapData->get_width();		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(249)
	int _g4 = bitmapData->get_height();		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(249)
	int size = (_g3 * _g4);		HX_STACK_VAR(size,"size");
	HX_STACK_LINE(251)
	int alpha;		HX_STACK_VAR(alpha,"alpha");
	HX_STACK_LINE(251)
	int red;		HX_STACK_VAR(red,"red");
	HX_STACK_LINE(251)
	int green;		HX_STACK_VAR(green,"green");
	HX_STACK_LINE(251)
	int blue;		HX_STACK_VAR(blue,"blue");
	HX_STACK_LINE(253)
	{
		HX_STACK_LINE(253)
		int _g5 = (int)0;		HX_STACK_VAR(_g5,"_g5");
		HX_STACK_LINE(253)
		while((true)){
			HX_STACK_LINE(253)
			if ((!(((_g5 < size))))){
				HX_STACK_LINE(253)
				break;
			}
			HX_STACK_LINE(253)
			int i = (_g5)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(255)
			alpha = data->__get((i * (int)4));
			HX_STACK_LINE(256)
			red = data->__get(((i * (int)4) + (int)1));
			HX_STACK_LINE(257)
			green = data->__get(((i * (int)4) + (int)2));
			HX_STACK_LINE(258)
			blue = data->__get(((i * (int)4) + (int)3));
			HX_STACK_LINE(260)
			hx::__ArrayImplRef(data,(i * (int)4)) = red;
			HX_STACK_LINE(261)
			hx::__ArrayImplRef(data,((i * (int)4) + (int)1)) = green;
			HX_STACK_LINE(262)
			hx::__ArrayImplRef(data,((i * (int)4) + (int)2)) = blue;
			HX_STACK_LINE(263)
			hx::__ArrayImplRef(data,((i * (int)4) + (int)3)) = alpha;
		}
	}
	HX_STACK_LINE(267)
	return data;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(BitmapData_obj,getRGBAPixels,return )

::flash::display::BitmapData BitmapData_obj::load( ::String filename,hx::Null< int >  __o_format){
int format = __o_format.Default(0);
	HX_STACK_FRAME("flash.display.BitmapData","load",0xd434f9f1,"flash.display.BitmapData.load","flash/display/BitmapData.hx",293,0x1e513fd9)
	HX_STACK_ARG(filename,"filename")
	HX_STACK_ARG(format,"format")
{
		HX_STACK_LINE(295)
		::flash::display::BitmapData result = ::flash::display::BitmapData_obj::__new((int)0,(int)0,null(),null(),null());		HX_STACK_VAR(result,"result");
		HX_STACK_LINE(296)
		Dynamic _g = ::flash::display::BitmapData_obj::lime_bitmap_data_load(filename,format);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(296)
		result->__handle = _g;
		HX_STACK_LINE(297)
		return result;
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,load,return )

::flash::display::BitmapData BitmapData_obj::loadFromBytes( ::flash::utils::ByteArray bytes,::flash::utils::ByteArray rawAlpha){
	HX_STACK_FRAME("flash.display.BitmapData","loadFromBytes",0x8df29270,"flash.display.BitmapData.loadFromBytes","flash/display/BitmapData.hx",302,0x1e513fd9)
	HX_STACK_ARG(bytes,"bytes")
	HX_STACK_ARG(rawAlpha,"rawAlpha")
	HX_STACK_LINE(304)
	::flash::display::BitmapData result = ::flash::display::BitmapData_obj::__new((int)0,(int)0,true,null(),null());		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(305)
	{
		HX_STACK_LINE(305)
		Dynamic _g = ::flash::display::BitmapData_obj::lime_bitmap_data_from_bytes(bytes,rawAlpha);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(305)
		result->__handle = _g;
	}
	HX_STACK_LINE(306)
	return result;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,loadFromBytes,return )

::flash::display::BitmapData BitmapData_obj::loadFromHaxeBytes( ::haxe::io::Bytes bytes,::haxe::io::Bytes rawAlpha){
	HX_STACK_FRAME("flash.display.BitmapData","loadFromHaxeBytes",0xc178eaea,"flash.display.BitmapData.loadFromHaxeBytes","flash/display/BitmapData.hx",311,0x1e513fd9)
	HX_STACK_ARG(bytes,"bytes")
	HX_STACK_ARG(rawAlpha,"rawAlpha")
	HX_STACK_LINE(313)
	::flash::utils::ByteArray _g = ::flash::utils::ByteArray_obj::fromBytes(bytes);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(313)
	::flash::utils::ByteArray _g1;		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(313)
	if (((rawAlpha == null()))){
		HX_STACK_LINE(313)
		_g1 = null();
	}
	else{
		HX_STACK_LINE(313)
		_g1 = ::flash::utils::ByteArray_obj::fromBytes(rawAlpha);
	}
	HX_STACK_LINE(313)
	return ::flash::display::BitmapData_obj::loadFromBytes(_g,_g1);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,loadFromHaxeBytes,return )

bool BitmapData_obj::sameValue( int a,int b){
	HX_STACK_FRAME("flash.display.BitmapData","sameValue",0x6a40da80,"flash.display.BitmapData.sameValue","flash/display/BitmapData.hx",383,0x1e513fd9)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(383)
	return (a == b);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,sameValue,return )

int BitmapData_obj::__flipPixel( int pixel){
	HX_STACK_FRAME("flash.display.BitmapData","__flipPixel",0x4838990e,"flash.display.BitmapData.__flipPixel","flash/display/BitmapData.hx",630,0x1e513fd9)
	HX_STACK_ARG(pixel,"pixel")
	HX_STACK_LINE(630)
	return (int((int((int((int(((int(pixel) & int((int)255)))) << int((int)24))) | int((int(((int((int(pixel) >> int((int)8))) & int((int)255)))) << int((int)16))))) | int((int(((int((int(pixel) >> int((int)16))) & int((int)255)))) << int((int)8))))) | int((int((int(pixel) >> int((int)24))) & int((int)255))));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(BitmapData_obj,__flipPixel,return )

int BitmapData_obj::__ucompare( int n1,int n2){
	HX_STACK_FRAME("flash.display.BitmapData","__ucompare",0x43837dfb,"flash.display.BitmapData.__ucompare","flash/display/BitmapData.hx",642,0x1e513fd9)
	HX_STACK_ARG(n1,"n1")
	HX_STACK_ARG(n2,"n2")
	HX_STACK_LINE(644)
	int tmp1;		HX_STACK_VAR(tmp1,"tmp1");
	HX_STACK_LINE(645)
	int tmp2;		HX_STACK_VAR(tmp2,"tmp2");
	HX_STACK_LINE(647)
	tmp1 = (int((int(n1) >> int((int)24))) & int((int)255));
	HX_STACK_LINE(648)
	tmp2 = (int((int(n2) >> int((int)24))) & int((int)255));
	HX_STACK_LINE(650)
	if (((tmp1 != tmp2))){
		HX_STACK_LINE(652)
		if (((tmp1 > tmp2))){
			HX_STACK_LINE(652)
			return (int)1;
		}
		else{
			HX_STACK_LINE(652)
			return (int)-1;
		}
	}
	else{
		HX_STACK_LINE(656)
		tmp1 = (int((int(n1) >> int((int)16))) & int((int)255));
		HX_STACK_LINE(657)
		tmp2 = (int((int(n2) >> int((int)16))) & int((int)255));
		HX_STACK_LINE(659)
		if (((tmp1 != tmp2))){
			HX_STACK_LINE(661)
			if (((tmp1 > tmp2))){
				HX_STACK_LINE(661)
				return (int)1;
			}
			else{
				HX_STACK_LINE(661)
				return (int)-1;
			}
		}
		else{
			HX_STACK_LINE(665)
			tmp1 = (int((int(n1) >> int((int)8))) & int((int)255));
			HX_STACK_LINE(666)
			tmp2 = (int((int(n2) >> int((int)8))) & int((int)255));
			HX_STACK_LINE(668)
			if (((tmp1 != tmp2))){
				HX_STACK_LINE(670)
				if (((tmp1 > tmp2))){
					HX_STACK_LINE(670)
					return (int)1;
				}
				else{
					HX_STACK_LINE(670)
					return (int)-1;
				}
			}
			else{
				HX_STACK_LINE(674)
				tmp1 = (int(n1) & int((int)255));
				HX_STACK_LINE(675)
				tmp2 = (int(n2) & int((int)255));
				HX_STACK_LINE(677)
				if (((tmp1 != tmp2))){
					HX_STACK_LINE(679)
					if (((tmp1 > tmp2))){
						HX_STACK_LINE(679)
						return (int)1;
					}
					else{
						HX_STACK_LINE(679)
						return (int)-1;
					}
				}
				else{
					HX_STACK_LINE(683)
					return (int)0;
				}
			}
		}
	}
	HX_STACK_LINE(650)
	return (int)0;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(BitmapData_obj,__ucompare,return )

Dynamic BitmapData_obj::lime_bitmap_data_create;

Dynamic BitmapData_obj::lime_bitmap_data_load;

Dynamic BitmapData_obj::lime_bitmap_data_from_bytes;

Dynamic BitmapData_obj::lime_bitmap_data_clear;

Dynamic BitmapData_obj::lime_bitmap_data_clone;

Dynamic BitmapData_obj::lime_bitmap_data_apply_filter;

Dynamic BitmapData_obj::lime_bitmap_data_color_transform;

Dynamic BitmapData_obj::lime_bitmap_data_copy;

Dynamic BitmapData_obj::lime_bitmap_data_copy_channel;

Dynamic BitmapData_obj::lime_bitmap_data_fill;

Dynamic BitmapData_obj::lime_bitmap_data_get_pixels;

Dynamic BitmapData_obj::lime_bitmap_data_get_pixel;

Dynamic BitmapData_obj::lime_bitmap_data_get_pixel32;

Dynamic BitmapData_obj::lime_bitmap_data_get_pixel_rgba;

Dynamic BitmapData_obj::lime_bitmap_data_get_array;

Dynamic BitmapData_obj::lime_bitmap_data_get_color_bounds_rect;

Dynamic BitmapData_obj::lime_bitmap_data_scroll;

Dynamic BitmapData_obj::lime_bitmap_data_set_pixel;

Dynamic BitmapData_obj::lime_bitmap_data_set_pixel32;

Dynamic BitmapData_obj::lime_bitmap_data_set_pixel_rgba;

Dynamic BitmapData_obj::lime_bitmap_data_set_bytes;

Dynamic BitmapData_obj::lime_bitmap_data_set_format;

Dynamic BitmapData_obj::lime_bitmap_data_set_array;

Dynamic BitmapData_obj::lime_bitmap_data_create_hardware_surface;

Dynamic BitmapData_obj::lime_bitmap_data_destroy_hardware_surface;

Dynamic BitmapData_obj::lime_bitmap_data_dispose;

Dynamic BitmapData_obj::lime_bitmap_data_generate_filter_rect;

Dynamic BitmapData_obj::lime_render_surface_to_surface;

Dynamic BitmapData_obj::lime_bitmap_data_height;

Dynamic BitmapData_obj::lime_bitmap_data_width;

Dynamic BitmapData_obj::lime_bitmap_data_get_transparent;

Dynamic BitmapData_obj::lime_bitmap_data_set_flags;

Dynamic BitmapData_obj::lime_bitmap_data_encode;

Dynamic BitmapData_obj::lime_bitmap_data_dump_bits;

Dynamic BitmapData_obj::lime_bitmap_data_flood_fill;

Dynamic BitmapData_obj::lime_bitmap_data_noise;

Dynamic BitmapData_obj::lime_bitmap_data_unmultiply_alpha;

Dynamic BitmapData_obj::lime_bitmap_data_multiply_alpha;

Dynamic BitmapData_obj::lime_bitmap_data_get_prem_alpha;

Dynamic BitmapData_obj::lime_bitmap_data_set_prem_alpha;


BitmapData_obj::BitmapData_obj()
{
}

void BitmapData_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(BitmapData);
	HX_MARK_MEMBER_NAME(height,"height");
	HX_MARK_MEMBER_NAME(rect,"rect");
	HX_MARK_MEMBER_NAME(transparent,"transparent");
	HX_MARK_MEMBER_NAME(width,"width");
	HX_MARK_MEMBER_NAME(__handle,"__handle");
	HX_MARK_MEMBER_NAME(__transparent,"__transparent");
	HX_MARK_END_CLASS();
}

void BitmapData_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(height,"height");
	HX_VISIT_MEMBER_NAME(rect,"rect");
	HX_VISIT_MEMBER_NAME(transparent,"transparent");
	HX_VISIT_MEMBER_NAME(width,"width");
	HX_VISIT_MEMBER_NAME(__handle,"__handle");
	HX_VISIT_MEMBER_NAME(__transparent,"__transparent");
}

Dynamic BitmapData_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"load") ) { return load_dyn(); }
		if (HX_FIELD_EQ(inName,"rect") ) { return inCallProp ? get_rect() : rect; }
		if (HX_FIELD_EQ(inName,"draw") ) { return draw_dyn(); }
		if (HX_FIELD_EQ(inName,"lock") ) { return lock_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"width") ) { return inCallProp ? get_width() : width; }
		if (HX_FIELD_EQ(inName,"clear") ) { return clear_dyn(); }
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		if (HX_FIELD_EQ(inName,"noise") ) { return noise_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"height") ) { return inCallProp ? get_height() : height; }
		if (HX_FIELD_EQ(inName,"encode") ) { return encode_dyn(); }
		if (HX_FIELD_EQ(inName,"scroll") ) { return scroll_dyn(); }
		if (HX_FIELD_EQ(inName,"unlock") ) { return unlock_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"__handle") ) { return __handle; }
		if (HX_FIELD_EQ(inName,"dumpBits") ) { return dumpBits_dyn(); }
		if (HX_FIELD_EQ(inName,"fillRect") ) { return fillRect_dyn(); }
		if (HX_FIELD_EQ(inName,"getPixel") ) { return getPixel_dyn(); }
		if (HX_FIELD_EQ(inName,"setFlags") ) { return setFlags_dyn(); }
		if (HX_FIELD_EQ(inName,"setPixel") ) { return setPixel_dyn(); }
		if (HX_FIELD_EQ(inName,"get_rect") ) { return get_rect_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"sameValue") ) { return sameValue_dyn(); }
		if (HX_FIELD_EQ(inName,"floodFill") ) { return floodFill_dyn(); }
		if (HX_FIELD_EQ(inName,"getPixels") ) { return getPixels_dyn(); }
		if (HX_FIELD_EQ(inName,"getVector") ) { return getVector_dyn(); }
		if (HX_FIELD_EQ(inName,"setFormat") ) { return setFormat_dyn(); }
		if (HX_FIELD_EQ(inName,"setPixels") ) { return setPixels_dyn(); }
		if (HX_FIELD_EQ(inName,"setVector") ) { return setVector_dyn(); }
		if (HX_FIELD_EQ(inName,"threshold") ) { return threshold_dyn(); }
		if (HX_FIELD_EQ(inName,"get_width") ) { return get_width_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"__ucompare") ) { return __ucompare_dyn(); }
		if (HX_FIELD_EQ(inName,"copyPixels") ) { return copyPixels_dyn(); }
		if (HX_FIELD_EQ(inName,"fillRectEx") ) { return fillRectEx_dyn(); }
		if (HX_FIELD_EQ(inName,"getPixel32") ) { return getPixel32_dyn(); }
		if (HX_FIELD_EQ(inName,"paletteMap") ) { return paletteMap_dyn(); }
		if (HX_FIELD_EQ(inName,"setPixel32") ) { return setPixel32_dyn(); }
		if (HX_FIELD_EQ(inName,"get_height") ) { return get_height_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"createColor") ) { return createColor_dyn(); }
		if (HX_FIELD_EQ(inName,"__flipPixel") ) { return __flipPixel_dyn(); }
		if (HX_FIELD_EQ(inName,"transparent") ) { return inCallProp ? get_transparent() : transparent; }
		if (HX_FIELD_EQ(inName,"applyFilter") ) { return applyFilter_dyn(); }
		if (HX_FIELD_EQ(inName,"copyChannel") ) { return copyChannel_dyn(); }
		if (HX_FIELD_EQ(inName,"perlinNoise") ) { return perlinNoise_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"extractAlpha") ) { return extractAlpha_dyn(); }
		if (HX_FIELD_EQ(inName,"extractColor") ) { return extractColor_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"getRGBAPixels") ) { return getRGBAPixels_dyn(); }
		if (HX_FIELD_EQ(inName,"loadFromBytes") ) { return loadFromBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"__transparent") ) { return __transparent; }
		if (HX_FIELD_EQ(inName,"multiplyAlpha") ) { return multiplyAlpha_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"colorTransform") ) { return colorTransform_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"unmultiplyAlpha") ) { return unmultiplyAlpha_dyn(); }
		if (HX_FIELD_EQ(inName,"__drawToSurface") ) { return __drawToSurface_dyn(); }
		if (HX_FIELD_EQ(inName,"__loadFromBytes") ) { return __loadFromBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"get_transparent") ) { return get_transparent_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"loadFromHaxeBytes") ) { return loadFromHaxeBytes_dyn(); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"premultipliedAlpha") ) { return get_premultipliedAlpha(); }
		if (HX_FIELD_EQ(inName,"generateFilterRect") ) { return generateFilterRect_dyn(); }
		if (HX_FIELD_EQ(inName,"getColorBoundsRect") ) { return getColorBoundsRect_dyn(); }
		break;
	case 21:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_load") ) { return lime_bitmap_data_load; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_copy") ) { return lime_bitmap_data_copy; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_fill") ) { return lime_bitmap_data_fill; }
		if (HX_FIELD_EQ(inName,"createHardwareSurface") ) { return createHardwareSurface_dyn(); }
		break;
	case 22:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_clear") ) { return lime_bitmap_data_clear; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_clone") ) { return lime_bitmap_data_clone; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_width") ) { return lime_bitmap_data_width; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_noise") ) { return lime_bitmap_data_noise; }
		if (HX_FIELD_EQ(inName,"destroyHardwareSurface") ) { return destroyHardwareSurface_dyn(); }
		if (HX_FIELD_EQ(inName,"get_premultipliedAlpha") ) { return get_premultipliedAlpha_dyn(); }
		if (HX_FIELD_EQ(inName,"set_premultipliedAlpha") ) { return set_premultipliedAlpha_dyn(); }
		break;
	case 23:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_create") ) { return lime_bitmap_data_create; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_scroll") ) { return lime_bitmap_data_scroll; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_height") ) { return lime_bitmap_data_height; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_encode") ) { return lime_bitmap_data_encode; }
		break;
	case 24:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_dispose") ) { return lime_bitmap_data_dispose; }
		break;
	case 26:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_get_pixel") ) { return lime_bitmap_data_get_pixel; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_get_array") ) { return lime_bitmap_data_get_array; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_set_pixel") ) { return lime_bitmap_data_set_pixel; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_set_bytes") ) { return lime_bitmap_data_set_bytes; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_set_array") ) { return lime_bitmap_data_set_array; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_set_flags") ) { return lime_bitmap_data_set_flags; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_dump_bits") ) { return lime_bitmap_data_dump_bits; }
		break;
	case 27:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_from_bytes") ) { return lime_bitmap_data_from_bytes; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_get_pixels") ) { return lime_bitmap_data_get_pixels; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_set_format") ) { return lime_bitmap_data_set_format; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_flood_fill") ) { return lime_bitmap_data_flood_fill; }
		break;
	case 28:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_get_pixel32") ) { return lime_bitmap_data_get_pixel32; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_set_pixel32") ) { return lime_bitmap_data_set_pixel32; }
		break;
	case 29:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_apply_filter") ) { return lime_bitmap_data_apply_filter; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_copy_channel") ) { return lime_bitmap_data_copy_channel; }
		break;
	case 30:
		if (HX_FIELD_EQ(inName,"lime_render_surface_to_surface") ) { return lime_render_surface_to_surface; }
		break;
	case 31:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_get_pixel_rgba") ) { return lime_bitmap_data_get_pixel_rgba; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_set_pixel_rgba") ) { return lime_bitmap_data_set_pixel_rgba; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_multiply_alpha") ) { return lime_bitmap_data_multiply_alpha; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_get_prem_alpha") ) { return lime_bitmap_data_get_prem_alpha; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_set_prem_alpha") ) { return lime_bitmap_data_set_prem_alpha; }
		break;
	case 32:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_color_transform") ) { return lime_bitmap_data_color_transform; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_get_transparent") ) { return lime_bitmap_data_get_transparent; }
		break;
	case 33:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_unmultiply_alpha") ) { return lime_bitmap_data_unmultiply_alpha; }
		break;
	case 37:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_generate_filter_rect") ) { return lime_bitmap_data_generate_filter_rect; }
		break;
	case 38:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_get_color_bounds_rect") ) { return lime_bitmap_data_get_color_bounds_rect; }
		break;
	case 40:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_create_hardware_surface") ) { return lime_bitmap_data_create_hardware_surface; }
		break;
	case 41:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_destroy_hardware_surface") ) { return lime_bitmap_data_destroy_hardware_surface; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic BitmapData_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"rect") ) { rect=inValue.Cast< ::flash::geom::Rectangle >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"width") ) { width=inValue.Cast< int >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"height") ) { height=inValue.Cast< int >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"__handle") ) { __handle=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"transparent") ) { transparent=inValue.Cast< bool >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"__transparent") ) { __transparent=inValue.Cast< bool >(); return inValue; }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"premultipliedAlpha") ) { return set_premultipliedAlpha(inValue); }
		break;
	case 21:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_load") ) { lime_bitmap_data_load=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_copy") ) { lime_bitmap_data_copy=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_fill") ) { lime_bitmap_data_fill=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 22:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_clear") ) { lime_bitmap_data_clear=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_clone") ) { lime_bitmap_data_clone=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_width") ) { lime_bitmap_data_width=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_noise") ) { lime_bitmap_data_noise=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 23:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_create") ) { lime_bitmap_data_create=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_scroll") ) { lime_bitmap_data_scroll=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_height") ) { lime_bitmap_data_height=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_encode") ) { lime_bitmap_data_encode=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 24:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_dispose") ) { lime_bitmap_data_dispose=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 26:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_get_pixel") ) { lime_bitmap_data_get_pixel=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_get_array") ) { lime_bitmap_data_get_array=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_set_pixel") ) { lime_bitmap_data_set_pixel=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_set_bytes") ) { lime_bitmap_data_set_bytes=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_set_array") ) { lime_bitmap_data_set_array=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_set_flags") ) { lime_bitmap_data_set_flags=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_dump_bits") ) { lime_bitmap_data_dump_bits=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 27:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_from_bytes") ) { lime_bitmap_data_from_bytes=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_get_pixels") ) { lime_bitmap_data_get_pixels=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_set_format") ) { lime_bitmap_data_set_format=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_flood_fill") ) { lime_bitmap_data_flood_fill=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 28:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_get_pixel32") ) { lime_bitmap_data_get_pixel32=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_set_pixel32") ) { lime_bitmap_data_set_pixel32=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 29:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_apply_filter") ) { lime_bitmap_data_apply_filter=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_copy_channel") ) { lime_bitmap_data_copy_channel=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 30:
		if (HX_FIELD_EQ(inName,"lime_render_surface_to_surface") ) { lime_render_surface_to_surface=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 31:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_get_pixel_rgba") ) { lime_bitmap_data_get_pixel_rgba=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_set_pixel_rgba") ) { lime_bitmap_data_set_pixel_rgba=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_multiply_alpha") ) { lime_bitmap_data_multiply_alpha=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_get_prem_alpha") ) { lime_bitmap_data_get_prem_alpha=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_set_prem_alpha") ) { lime_bitmap_data_set_prem_alpha=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 32:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_color_transform") ) { lime_bitmap_data_color_transform=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_get_transparent") ) { lime_bitmap_data_get_transparent=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 33:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_unmultiply_alpha") ) { lime_bitmap_data_unmultiply_alpha=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 37:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_generate_filter_rect") ) { lime_bitmap_data_generate_filter_rect=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 38:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_get_color_bounds_rect") ) { lime_bitmap_data_get_color_bounds_rect=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 40:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_create_hardware_surface") ) { lime_bitmap_data_create_hardware_surface=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 41:
		if (HX_FIELD_EQ(inName,"lime_bitmap_data_destroy_hardware_surface") ) { lime_bitmap_data_destroy_hardware_surface=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void BitmapData_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("height"));
	outFields->push(HX_CSTRING("premultipliedAlpha"));
	outFields->push(HX_CSTRING("rect"));
	outFields->push(HX_CSTRING("transparent"));
	outFields->push(HX_CSTRING("width"));
	outFields->push(HX_CSTRING("__handle"));
	outFields->push(HX_CSTRING("__transparent"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("CLEAR"),
	HX_CSTRING("BLACK"),
	HX_CSTRING("WHITE"),
	HX_CSTRING("RED"),
	HX_CSTRING("GREEN"),
	HX_CSTRING("BLUE"),
	HX_CSTRING("PNG"),
	HX_CSTRING("JPG"),
	HX_CSTRING("TRANSPARENT"),
	HX_CSTRING("HARDWARE"),
	HX_CSTRING("FORMAT_8888"),
	HX_CSTRING("FORMAT_4444"),
	HX_CSTRING("FORMAT_565"),
	HX_CSTRING("createColor"),
	HX_CSTRING("extractAlpha"),
	HX_CSTRING("extractColor"),
	HX_CSTRING("getRGBAPixels"),
	HX_CSTRING("load"),
	HX_CSTRING("loadFromBytes"),
	HX_CSTRING("loadFromHaxeBytes"),
	HX_CSTRING("sameValue"),
	HX_CSTRING("__flipPixel"),
	HX_CSTRING("__ucompare"),
	HX_CSTRING("lime_bitmap_data_create"),
	HX_CSTRING("lime_bitmap_data_load"),
	HX_CSTRING("lime_bitmap_data_from_bytes"),
	HX_CSTRING("lime_bitmap_data_clear"),
	HX_CSTRING("lime_bitmap_data_clone"),
	HX_CSTRING("lime_bitmap_data_apply_filter"),
	HX_CSTRING("lime_bitmap_data_color_transform"),
	HX_CSTRING("lime_bitmap_data_copy"),
	HX_CSTRING("lime_bitmap_data_copy_channel"),
	HX_CSTRING("lime_bitmap_data_fill"),
	HX_CSTRING("lime_bitmap_data_get_pixels"),
	HX_CSTRING("lime_bitmap_data_get_pixel"),
	HX_CSTRING("lime_bitmap_data_get_pixel32"),
	HX_CSTRING("lime_bitmap_data_get_pixel_rgba"),
	HX_CSTRING("lime_bitmap_data_get_array"),
	HX_CSTRING("lime_bitmap_data_get_color_bounds_rect"),
	HX_CSTRING("lime_bitmap_data_scroll"),
	HX_CSTRING("lime_bitmap_data_set_pixel"),
	HX_CSTRING("lime_bitmap_data_set_pixel32"),
	HX_CSTRING("lime_bitmap_data_set_pixel_rgba"),
	HX_CSTRING("lime_bitmap_data_set_bytes"),
	HX_CSTRING("lime_bitmap_data_set_format"),
	HX_CSTRING("lime_bitmap_data_set_array"),
	HX_CSTRING("lime_bitmap_data_create_hardware_surface"),
	HX_CSTRING("lime_bitmap_data_destroy_hardware_surface"),
	HX_CSTRING("lime_bitmap_data_dispose"),
	HX_CSTRING("lime_bitmap_data_generate_filter_rect"),
	HX_CSTRING("lime_render_surface_to_surface"),
	HX_CSTRING("lime_bitmap_data_height"),
	HX_CSTRING("lime_bitmap_data_width"),
	HX_CSTRING("lime_bitmap_data_get_transparent"),
	HX_CSTRING("lime_bitmap_data_set_flags"),
	HX_CSTRING("lime_bitmap_data_encode"),
	HX_CSTRING("lime_bitmap_data_dump_bits"),
	HX_CSTRING("lime_bitmap_data_flood_fill"),
	HX_CSTRING("lime_bitmap_data_noise"),
	HX_CSTRING("lime_bitmap_data_unmultiply_alpha"),
	HX_CSTRING("lime_bitmap_data_multiply_alpha"),
	HX_CSTRING("lime_bitmap_data_get_prem_alpha"),
	HX_CSTRING("lime_bitmap_data_set_prem_alpha"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(BitmapData_obj,height),HX_CSTRING("height")},
	{hx::fsObject /*::flash::geom::Rectangle*/ ,(int)offsetof(BitmapData_obj,rect),HX_CSTRING("rect")},
	{hx::fsBool,(int)offsetof(BitmapData_obj,transparent),HX_CSTRING("transparent")},
	{hx::fsInt,(int)offsetof(BitmapData_obj,width),HX_CSTRING("width")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(BitmapData_obj,__handle),HX_CSTRING("__handle")},
	{hx::fsBool,(int)offsetof(BitmapData_obj,__transparent),HX_CSTRING("__transparent")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("height"),
	HX_CSTRING("rect"),
	HX_CSTRING("transparent"),
	HX_CSTRING("width"),
	HX_CSTRING("__handle"),
	HX_CSTRING("__transparent"),
	HX_CSTRING("applyFilter"),
	HX_CSTRING("clear"),
	HX_CSTRING("clone"),
	HX_CSTRING("colorTransform"),
	HX_CSTRING("copyChannel"),
	HX_CSTRING("copyPixels"),
	HX_CSTRING("createHardwareSurface"),
	HX_CSTRING("destroyHardwareSurface"),
	HX_CSTRING("dispose"),
	HX_CSTRING("draw"),
	HX_CSTRING("dumpBits"),
	HX_CSTRING("encode"),
	HX_CSTRING("fillRect"),
	HX_CSTRING("fillRectEx"),
	HX_CSTRING("floodFill"),
	HX_CSTRING("generateFilterRect"),
	HX_CSTRING("getColorBoundsRect"),
	HX_CSTRING("getPixel"),
	HX_CSTRING("getPixel32"),
	HX_CSTRING("getPixels"),
	HX_CSTRING("getVector"),
	HX_CSTRING("lock"),
	HX_CSTRING("multiplyAlpha"),
	HX_CSTRING("noise"),
	HX_CSTRING("paletteMap"),
	HX_CSTRING("perlinNoise"),
	HX_CSTRING("scroll"),
	HX_CSTRING("setFlags"),
	HX_CSTRING("setFormat"),
	HX_CSTRING("setPixel"),
	HX_CSTRING("setPixel32"),
	HX_CSTRING("setPixels"),
	HX_CSTRING("setVector"),
	HX_CSTRING("threshold"),
	HX_CSTRING("unlock"),
	HX_CSTRING("unmultiplyAlpha"),
	HX_CSTRING("__drawToSurface"),
	HX_CSTRING("__loadFromBytes"),
	HX_CSTRING("get_premultipliedAlpha"),
	HX_CSTRING("set_premultipliedAlpha"),
	HX_CSTRING("get_rect"),
	HX_CSTRING("get_width"),
	HX_CSTRING("get_height"),
	HX_CSTRING("get_transparent"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(BitmapData_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(BitmapData_obj::CLEAR,"CLEAR");
	HX_MARK_MEMBER_NAME(BitmapData_obj::BLACK,"BLACK");
	HX_MARK_MEMBER_NAME(BitmapData_obj::WHITE,"WHITE");
	HX_MARK_MEMBER_NAME(BitmapData_obj::RED,"RED");
	HX_MARK_MEMBER_NAME(BitmapData_obj::GREEN,"GREEN");
	HX_MARK_MEMBER_NAME(BitmapData_obj::BLUE,"BLUE");
	HX_MARK_MEMBER_NAME(BitmapData_obj::PNG,"PNG");
	HX_MARK_MEMBER_NAME(BitmapData_obj::JPG,"JPG");
	HX_MARK_MEMBER_NAME(BitmapData_obj::TRANSPARENT,"TRANSPARENT");
	HX_MARK_MEMBER_NAME(BitmapData_obj::HARDWARE,"HARDWARE");
	HX_MARK_MEMBER_NAME(BitmapData_obj::FORMAT_8888,"FORMAT_8888");
	HX_MARK_MEMBER_NAME(BitmapData_obj::FORMAT_4444,"FORMAT_4444");
	HX_MARK_MEMBER_NAME(BitmapData_obj::FORMAT_565,"FORMAT_565");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_create,"lime_bitmap_data_create");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_load,"lime_bitmap_data_load");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_from_bytes,"lime_bitmap_data_from_bytes");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_clear,"lime_bitmap_data_clear");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_clone,"lime_bitmap_data_clone");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_apply_filter,"lime_bitmap_data_apply_filter");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_color_transform,"lime_bitmap_data_color_transform");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_copy,"lime_bitmap_data_copy");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_copy_channel,"lime_bitmap_data_copy_channel");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_fill,"lime_bitmap_data_fill");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_get_pixels,"lime_bitmap_data_get_pixels");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_get_pixel,"lime_bitmap_data_get_pixel");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_get_pixel32,"lime_bitmap_data_get_pixel32");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_get_pixel_rgba,"lime_bitmap_data_get_pixel_rgba");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_get_array,"lime_bitmap_data_get_array");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_get_color_bounds_rect,"lime_bitmap_data_get_color_bounds_rect");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_scroll,"lime_bitmap_data_scroll");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_set_pixel,"lime_bitmap_data_set_pixel");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_set_pixel32,"lime_bitmap_data_set_pixel32");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_set_pixel_rgba,"lime_bitmap_data_set_pixel_rgba");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_set_bytes,"lime_bitmap_data_set_bytes");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_set_format,"lime_bitmap_data_set_format");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_set_array,"lime_bitmap_data_set_array");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_create_hardware_surface,"lime_bitmap_data_create_hardware_surface");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_destroy_hardware_surface,"lime_bitmap_data_destroy_hardware_surface");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_dispose,"lime_bitmap_data_dispose");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_generate_filter_rect,"lime_bitmap_data_generate_filter_rect");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_render_surface_to_surface,"lime_render_surface_to_surface");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_height,"lime_bitmap_data_height");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_width,"lime_bitmap_data_width");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_get_transparent,"lime_bitmap_data_get_transparent");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_set_flags,"lime_bitmap_data_set_flags");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_encode,"lime_bitmap_data_encode");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_dump_bits,"lime_bitmap_data_dump_bits");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_flood_fill,"lime_bitmap_data_flood_fill");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_noise,"lime_bitmap_data_noise");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_unmultiply_alpha,"lime_bitmap_data_unmultiply_alpha");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_multiply_alpha,"lime_bitmap_data_multiply_alpha");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_get_prem_alpha,"lime_bitmap_data_get_prem_alpha");
	HX_MARK_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_set_prem_alpha,"lime_bitmap_data_set_prem_alpha");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(BitmapData_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::CLEAR,"CLEAR");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::BLACK,"BLACK");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::WHITE,"WHITE");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::RED,"RED");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::GREEN,"GREEN");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::BLUE,"BLUE");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::PNG,"PNG");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::JPG,"JPG");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::TRANSPARENT,"TRANSPARENT");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::HARDWARE,"HARDWARE");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::FORMAT_8888,"FORMAT_8888");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::FORMAT_4444,"FORMAT_4444");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::FORMAT_565,"FORMAT_565");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_create,"lime_bitmap_data_create");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_load,"lime_bitmap_data_load");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_from_bytes,"lime_bitmap_data_from_bytes");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_clear,"lime_bitmap_data_clear");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_clone,"lime_bitmap_data_clone");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_apply_filter,"lime_bitmap_data_apply_filter");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_color_transform,"lime_bitmap_data_color_transform");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_copy,"lime_bitmap_data_copy");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_copy_channel,"lime_bitmap_data_copy_channel");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_fill,"lime_bitmap_data_fill");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_get_pixels,"lime_bitmap_data_get_pixels");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_get_pixel,"lime_bitmap_data_get_pixel");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_get_pixel32,"lime_bitmap_data_get_pixel32");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_get_pixel_rgba,"lime_bitmap_data_get_pixel_rgba");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_get_array,"lime_bitmap_data_get_array");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_get_color_bounds_rect,"lime_bitmap_data_get_color_bounds_rect");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_scroll,"lime_bitmap_data_scroll");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_set_pixel,"lime_bitmap_data_set_pixel");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_set_pixel32,"lime_bitmap_data_set_pixel32");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_set_pixel_rgba,"lime_bitmap_data_set_pixel_rgba");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_set_bytes,"lime_bitmap_data_set_bytes");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_set_format,"lime_bitmap_data_set_format");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_set_array,"lime_bitmap_data_set_array");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_create_hardware_surface,"lime_bitmap_data_create_hardware_surface");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_destroy_hardware_surface,"lime_bitmap_data_destroy_hardware_surface");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_dispose,"lime_bitmap_data_dispose");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_generate_filter_rect,"lime_bitmap_data_generate_filter_rect");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_render_surface_to_surface,"lime_render_surface_to_surface");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_height,"lime_bitmap_data_height");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_width,"lime_bitmap_data_width");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_get_transparent,"lime_bitmap_data_get_transparent");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_set_flags,"lime_bitmap_data_set_flags");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_encode,"lime_bitmap_data_encode");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_dump_bits,"lime_bitmap_data_dump_bits");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_flood_fill,"lime_bitmap_data_flood_fill");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_noise,"lime_bitmap_data_noise");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_unmultiply_alpha,"lime_bitmap_data_unmultiply_alpha");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_multiply_alpha,"lime_bitmap_data_multiply_alpha");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_get_prem_alpha,"lime_bitmap_data_get_prem_alpha");
	HX_VISIT_MEMBER_NAME(BitmapData_obj::lime_bitmap_data_set_prem_alpha,"lime_bitmap_data_set_prem_alpha");
};

#endif

Class BitmapData_obj::__mClass;

void BitmapData_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.display.BitmapData"), hx::TCanCast< BitmapData_obj> ,sStaticFields,sMemberFields,
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

void BitmapData_obj::__boot()
{
	CLEAR= (int)0;
	BLACK= (int)-16777216;
	WHITE= (int)-16777216;
	RED= (int)-65536;
	GREEN= (int)-16711936;
	BLUE= (int)-16776961;
	PNG= HX_CSTRING("png");
	JPG= HX_CSTRING("jpg");
	TRANSPARENT= (int)1;
	HARDWARE= (int)2;
	FORMAT_8888= (int)0;
	FORMAT_4444= (int)1;
	FORMAT_565= (int)2;
	lime_bitmap_data_create= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_create"),(int)-1);
	lime_bitmap_data_load= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_load"),(int)2);
	lime_bitmap_data_from_bytes= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_from_bytes"),(int)2);
	lime_bitmap_data_clear= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_clear"),(int)2);
	lime_bitmap_data_clone= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_clone"),(int)1);
	lime_bitmap_data_apply_filter= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_apply_filter"),(int)5);
	lime_bitmap_data_color_transform= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_color_transform"),(int)3);
	lime_bitmap_data_copy= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_copy"),(int)5);
	lime_bitmap_data_copy_channel= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_copy_channel"),(int)-1);
	lime_bitmap_data_fill= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_fill"),(int)4);
	lime_bitmap_data_get_pixels= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_get_pixels"),(int)2);
	lime_bitmap_data_get_pixel= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_get_pixel"),(int)3);
	lime_bitmap_data_get_pixel32= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_get_pixel32"),(int)3);
	lime_bitmap_data_get_pixel_rgba= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_get_pixel_rgba"),(int)3);
	lime_bitmap_data_get_array= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_get_array"),(int)3);
	lime_bitmap_data_get_color_bounds_rect= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_get_color_bounds_rect"),(int)5);
	lime_bitmap_data_scroll= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_scroll"),(int)3);
	lime_bitmap_data_set_pixel= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_set_pixel"),(int)4);
	lime_bitmap_data_set_pixel32= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_set_pixel32"),(int)4);
	lime_bitmap_data_set_pixel_rgba= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_set_pixel_rgba"),(int)4);
	lime_bitmap_data_set_bytes= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_set_bytes"),(int)4);
	lime_bitmap_data_set_format= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_set_format"),(int)2);
	lime_bitmap_data_set_array= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_set_array"),(int)3);
	lime_bitmap_data_create_hardware_surface= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_create_hardware_surface"),(int)1);
	lime_bitmap_data_destroy_hardware_surface= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_destroy_hardware_surface"),(int)1);
	lime_bitmap_data_dispose= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_dispose"),(int)1);
	lime_bitmap_data_generate_filter_rect= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_generate_filter_rect"),(int)3);
	lime_render_surface_to_surface= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_render_surface_to_surface"),(int)-1);
	lime_bitmap_data_height= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_height"),(int)1);
	lime_bitmap_data_width= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_width"),(int)1);
	lime_bitmap_data_get_transparent= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_get_transparent"),(int)1);
	lime_bitmap_data_set_flags= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_set_flags"),(int)2);
	lime_bitmap_data_encode= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_encode"),(int)3);
	lime_bitmap_data_dump_bits= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_dump_bits"),(int)1);
	lime_bitmap_data_flood_fill= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_flood_fill"),(int)4);
	lime_bitmap_data_noise= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_noise"),(int)-1);
	lime_bitmap_data_unmultiply_alpha= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_unmultiply_alpha"),(int)1);
	lime_bitmap_data_multiply_alpha= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_multiply_alpha"),(int)1);
	lime_bitmap_data_get_prem_alpha= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_get_prem_alpha"),(int)1);
	lime_bitmap_data_set_prem_alpha= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_bitmap_data_set_prem_alpha"),(int)2);
}

} // end namespace flash
} // end namespace display
