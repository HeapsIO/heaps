#include <hxcpp.h>

#ifndef INCLUDED_flash_display_BitmapData
#include <flash/display/BitmapData.h>
#endif
#ifndef INCLUDED_flash_display_IBitmapDrawable
#include <flash/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_h3d_impl_BufferOffset
#include <h3d/impl/BufferOffset.h>
#endif
#ifndef INCLUDED_h3d_impl_Driver
#include <h3d/impl/Driver.h>
#endif
#ifndef INCLUDED_h3d_impl_GLVB
#include <h3d/impl/GLVB.h>
#endif
#ifndef INCLUDED_h3d_impl_Shader
#include <h3d/impl/Shader.h>
#endif
#ifndef INCLUDED_h3d_mat_Texture
#include <h3d/mat/Texture.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_hxd_Pixels
#include <hxd/Pixels.h>
#endif
#ifndef INCLUDED_openfl_gl_GLBuffer
#include <openfl/gl/GLBuffer.h>
#endif
#ifndef INCLUDED_openfl_gl_GLObject
#include <openfl/gl/GLObject.h>
#endif
#ifndef INCLUDED_openfl_gl_GLTexture
#include <openfl/gl/GLTexture.h>
#endif
namespace h3d{
namespace impl{

Void Driver_obj::__construct()
{
	return null();
}

//Driver_obj::~Driver_obj() { }

Dynamic Driver_obj::__CreateEmpty() { return  new Driver_obj; }
hx::ObjectPtr< Driver_obj > Driver_obj::__new()
{  hx::ObjectPtr< Driver_obj > result = new Driver_obj();
	result->__construct();
	return result;}

Dynamic Driver_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Driver_obj > result = new Driver_obj();
	result->__construct();
	return result;}

bool Driver_obj::isDisposed( ){
	HX_STACK_FRAME("h3d.impl.Driver","isDisposed",0x53c428dc,"h3d.impl.Driver.isDisposed","h3d/impl/Driver.hx",38,0xe373499d)
	HX_STACK_THIS(this)
	HX_STACK_LINE(38)
	return true;
}


HX_DEFINE_DYNAMIC_FUNC0(Driver_obj,isDisposed,return )

Void Driver_obj::begin( ){
{
		HX_STACK_FRAME("h3d.impl.Driver","begin",0x55fa655c,"h3d.impl.Driver.begin","h3d/impl/Driver.hx",41,0xe373499d)
		HX_STACK_THIS(this)
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Driver_obj,begin,(void))

Void Driver_obj::dispose( ){
{
		HX_STACK_FRAME("h3d.impl.Driver","dispose",0x6f6c6e92,"h3d.impl.Driver.dispose","h3d/impl/Driver.hx",45,0xe373499d)
		HX_STACK_THIS(this)
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Driver_obj,dispose,(void))

Void Driver_obj::clear( Float r,Float g,Float b,Float a){
{
		HX_STACK_FRAME("h3d.impl.Driver","clear",0xedffecc0,"h3d.impl.Driver.clear","h3d/impl/Driver.hx",49,0xe373499d)
		HX_STACK_THIS(this)
		HX_STACK_ARG(r,"r")
		HX_STACK_ARG(g,"g")
		HX_STACK_ARG(b,"b")
		HX_STACK_ARG(a,"a")
		HX_STACK_LINE(49)
		Dynamic();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Driver_obj,clear,(void))

Void Driver_obj::reset( ){
{
		HX_STACK_FRAME("h3d.impl.Driver","reset",0x8c6cc502,"h3d.impl.Driver.reset","h3d/impl/Driver.hx",52,0xe373499d)
		HX_STACK_THIS(this)
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Driver_obj,reset,(void))

::String Driver_obj::getDriverName( bool details){
	HX_STACK_FRAME("h3d.impl.Driver","getDriverName",0x306114fc,"h3d.impl.Driver.getDriverName","h3d/impl/Driver.hx",56,0xe373499d)
	HX_STACK_THIS(this)
	HX_STACK_ARG(details,"details")
	HX_STACK_LINE(56)
	return HX_CSTRING("Not available");
}


HX_DEFINE_DYNAMIC_FUNC1(Driver_obj,getDriverName,return )

Void Driver_obj::init( Dynamic onCreate,hx::Null< bool >  __o_forceSoftware){
bool forceSoftware = __o_forceSoftware.Default(false);
	HX_STACK_FRAME("h3d.impl.Driver","init",0x59fd673d,"h3d.impl.Driver.init","h3d/impl/Driver.hx",59,0xe373499d)
	HX_STACK_THIS(this)
	HX_STACK_ARG(onCreate,"onCreate")
	HX_STACK_ARG(forceSoftware,"forceSoftware")
{
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Driver_obj,init,(void))

Void Driver_obj::resize( int width,int height){
{
		HX_STACK_FRAME("h3d.impl.Driver","resize",0x52c2ab61,"h3d.impl.Driver.resize","h3d/impl/Driver.hx",62,0xe373499d)
		HX_STACK_THIS(this)
		HX_STACK_ARG(width,"width")
		HX_STACK_ARG(height,"height")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Driver_obj,resize,(void))

Void Driver_obj::selectMaterial( int mbits){
{
		HX_STACK_FRAME("h3d.impl.Driver","selectMaterial",0xe6219630,"h3d.impl.Driver.selectMaterial","h3d/impl/Driver.hx",65,0xe373499d)
		HX_STACK_THIS(this)
		HX_STACK_ARG(mbits,"mbits")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Driver_obj,selectMaterial,(void))

bool Driver_obj::selectShader( ::h3d::impl::Shader shader){
	HX_STACK_FRAME("h3d.impl.Driver","selectShader",0xba16546e,"h3d.impl.Driver.selectShader","h3d/impl/Driver.hx",70,0xe373499d)
	HX_STACK_THIS(this)
	HX_STACK_ARG(shader,"shader")
	HX_STACK_LINE(70)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC1(Driver_obj,selectShader,return )

Void Driver_obj::deleteShader( ::h3d::impl::Shader shader){
{
		HX_STACK_FRAME("h3d.impl.Driver","deleteShader",0x3c7686dd,"h3d.impl.Driver.deleteShader","h3d/impl/Driver.hx",73,0xe373499d)
		HX_STACK_THIS(this)
		HX_STACK_ARG(shader,"shader")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Driver_obj,deleteShader,(void))

Void Driver_obj::selectBuffer( ::h3d::impl::GLVB buffer){
{
		HX_STACK_FRAME("h3d.impl.Driver","selectBuffer",0x6d8a5249,"h3d.impl.Driver.selectBuffer","h3d/impl/Driver.hx",78,0xe373499d)
		HX_STACK_THIS(this)
		HX_STACK_ARG(buffer,"buffer")
		HX_STACK_LINE(78)
		HX_STACK_DO_THROW(HX_CSTRING("selectBuffer is not implemented"));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Driver_obj,selectBuffer,(void))

Array< ::String > Driver_obj::getShaderInputNames( ){
	HX_STACK_FRAME("h3d.impl.Driver","getShaderInputNames",0x6d68520c,"h3d.impl.Driver.getShaderInputNames","h3d/impl/Driver.hx",82,0xe373499d)
	HX_STACK_THIS(this)
	HX_STACK_LINE(82)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Driver_obj,getShaderInputNames,return )

Void Driver_obj::selectMultiBuffers( Array< ::Dynamic > buffers){
{
		HX_STACK_FRAME("h3d.impl.Driver","selectMultiBuffers",0xa9fba403,"h3d.impl.Driver.selectMultiBuffers","h3d/impl/Driver.hx",86,0xe373499d)
		HX_STACK_THIS(this)
		HX_STACK_ARG(buffers,"buffers")
		HX_STACK_LINE(86)
		HX_STACK_DO_THROW(HX_CSTRING("selectMultiBuffers is not implemented"));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Driver_obj,selectMultiBuffers,(void))

Void Driver_obj::draw( ::openfl::gl::GLBuffer ibuf,int startIndex,int ntriangles){
{
		HX_STACK_FRAME("h3d.impl.Driver","draw",0x56b25831,"h3d.impl.Driver.draw","h3d/impl/Driver.hx",90,0xe373499d)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ibuf,"ibuf")
		HX_STACK_ARG(startIndex,"startIndex")
		HX_STACK_ARG(ntriangles,"ntriangles")
		HX_STACK_LINE(90)
		HX_STACK_DO_THROW(HX_CSTRING("draw is not implemented"));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Driver_obj,draw,(void))

Void Driver_obj::setRenderZone( int x,int y,int width,int height){
{
		HX_STACK_FRAME("h3d.impl.Driver","setRenderZone",0x7caa4117,"h3d.impl.Driver.setRenderZone","h3d/impl/Driver.hx",94,0xe373499d)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(width,"width")
		HX_STACK_ARG(height,"height")
		HX_STACK_LINE(94)
		HX_STACK_DO_THROW(HX_CSTRING("setRenderZone is not implemented"));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Driver_obj,setRenderZone,(void))

Void Driver_obj::setRenderTarget( ::h3d::mat::Texture tex,bool useDepth,int clearColor){
{
		HX_STACK_FRAME("h3d.impl.Driver","setRenderTarget",0x397462fc,"h3d.impl.Driver.setRenderTarget","h3d/impl/Driver.hx",104,0xe373499d)
		HX_STACK_THIS(this)
		HX_STACK_ARG(tex,"tex")
		HX_STACK_ARG(useDepth,"useDepth")
		HX_STACK_ARG(clearColor,"clearColor")
		HX_STACK_LINE(104)
		HX_STACK_DO_THROW(HX_CSTRING("setRenderTarget is not implemented"));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Driver_obj,setRenderTarget,(void))

Void Driver_obj::present( ){
{
		HX_STACK_FRAME("h3d.impl.Driver","present",0xedfc28ee,"h3d.impl.Driver.present","h3d/impl/Driver.hx",107,0xe373499d)
		HX_STACK_THIS(this)
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Driver_obj,present,(void))

bool Driver_obj::isHardware( ){
	HX_STACK_FRAME("h3d.impl.Driver","isHardware",0xa1f4009f,"h3d.impl.Driver.isHardware","h3d/impl/Driver.hx",111,0xe373499d)
	HX_STACK_THIS(this)
	HX_STACK_LINE(111)
	return true;
}


HX_DEFINE_DYNAMIC_FUNC0(Driver_obj,isHardware,return )

Void Driver_obj::setDebug( bool b){
{
		HX_STACK_FRAME("h3d.impl.Driver","setDebug",0xcd2401fe,"h3d.impl.Driver.setDebug","h3d/impl/Driver.hx",114,0xe373499d)
		HX_STACK_THIS(this)
		HX_STACK_ARG(b,"b")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Driver_obj,setDebug,(void))

::openfl::gl::GLTexture Driver_obj::allocTexture( ::h3d::mat::Texture t){
	HX_STACK_FRAME("h3d.impl.Driver","allocTexture",0x20e69613,"h3d.impl.Driver.allocTexture","h3d/impl/Driver.hx",118,0xe373499d)
	HX_STACK_THIS(this)
	HX_STACK_ARG(t,"t")
	HX_STACK_LINE(118)
	HX_STACK_DO_THROW(HX_CSTRING("assert"));
	HX_STACK_LINE(118)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Driver_obj,allocTexture,return )

::openfl::gl::GLBuffer Driver_obj::allocIndexes( int count){
	HX_STACK_FRAME("h3d.impl.Driver","allocIndexes",0x62c52938,"h3d.impl.Driver.allocIndexes","h3d/impl/Driver.hx",122,0xe373499d)
	HX_STACK_THIS(this)
	HX_STACK_ARG(count,"count")
	HX_STACK_LINE(122)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Driver_obj,allocIndexes,return )

::h3d::impl::GLVB Driver_obj::allocVertex( int count,int stride,hx::Null< bool >  __o_isDynamic){
bool isDynamic = __o_isDynamic.Default(false);
	HX_STACK_FRAME("h3d.impl.Driver","allocVertex",0x3a8b9d2c,"h3d.impl.Driver.allocVertex","h3d/impl/Driver.hx",126,0xe373499d)
	HX_STACK_THIS(this)
	HX_STACK_ARG(count,"count")
	HX_STACK_ARG(stride,"stride")
	HX_STACK_ARG(isDynamic,"isDynamic")
{
		HX_STACK_LINE(126)
		return null();
	}
}


HX_DEFINE_DYNAMIC_FUNC3(Driver_obj,allocVertex,return )

Void Driver_obj::disposeTexture( ::openfl::gl::GLTexture t){
{
		HX_STACK_FRAME("h3d.impl.Driver","disposeTexture",0x4e145869,"h3d.impl.Driver.disposeTexture","h3d/impl/Driver.hx",129,0xe373499d)
		HX_STACK_THIS(this)
		HX_STACK_ARG(t,"t")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Driver_obj,disposeTexture,(void))

Void Driver_obj::disposeIndexes( ::openfl::gl::GLBuffer i){
{
		HX_STACK_FRAME("h3d.impl.Driver","disposeIndexes",0x8ff2eb8e,"h3d.impl.Driver.disposeIndexes","h3d/impl/Driver.hx",132,0xe373499d)
		HX_STACK_THIS(this)
		HX_STACK_ARG(i,"i")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Driver_obj,disposeIndexes,(void))

Void Driver_obj::disposeVertex( ::h3d::impl::GLVB v){
{
		HX_STACK_FRAME("h3d.impl.Driver","disposeVertex",0x8e8cf796,"h3d.impl.Driver.disposeVertex","h3d/impl/Driver.hx",135,0xe373499d)
		HX_STACK_THIS(this)
		HX_STACK_ARG(v,"v")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Driver_obj,disposeVertex,(void))

Void Driver_obj::uploadIndexesBuffer( ::openfl::gl::GLBuffer i,int startIndice,int indiceCount,Array< int > buf,int bufPos){
{
		HX_STACK_FRAME("h3d.impl.Driver","uploadIndexesBuffer",0x44c9b4d2,"h3d.impl.Driver.uploadIndexesBuffer","h3d/impl/Driver.hx",138,0xe373499d)
		HX_STACK_THIS(this)
		HX_STACK_ARG(i,"i")
		HX_STACK_ARG(startIndice,"startIndice")
		HX_STACK_ARG(indiceCount,"indiceCount")
		HX_STACK_ARG(buf,"buf")
		HX_STACK_ARG(bufPos,"bufPos")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC5(Driver_obj,uploadIndexesBuffer,(void))

Void Driver_obj::uploadIndexesBytes( ::openfl::gl::GLBuffer i,int startIndice,int indiceCount,::haxe::io::Bytes buf,int bufPos){
{
		HX_STACK_FRAME("h3d.impl.Driver","uploadIndexesBytes",0x02fe70d9,"h3d.impl.Driver.uploadIndexesBytes","h3d/impl/Driver.hx",141,0xe373499d)
		HX_STACK_THIS(this)
		HX_STACK_ARG(i,"i")
		HX_STACK_ARG(startIndice,"startIndice")
		HX_STACK_ARG(indiceCount,"indiceCount")
		HX_STACK_ARG(buf,"buf")
		HX_STACK_ARG(bufPos,"bufPos")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC5(Driver_obj,uploadIndexesBytes,(void))

Void Driver_obj::uploadVertexBuffer( ::h3d::impl::GLVB v,int startVertex,int vertexCount,Array< Float > buf,int bufPos){
{
		HX_STACK_FRAME("h3d.impl.Driver","uploadVertexBuffer",0x42cf8412,"h3d.impl.Driver.uploadVertexBuffer","h3d/impl/Driver.hx",144,0xe373499d)
		HX_STACK_THIS(this)
		HX_STACK_ARG(v,"v")
		HX_STACK_ARG(startVertex,"startVertex")
		HX_STACK_ARG(vertexCount,"vertexCount")
		HX_STACK_ARG(buf,"buf")
		HX_STACK_ARG(bufPos,"bufPos")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC5(Driver_obj,uploadVertexBuffer,(void))

Void Driver_obj::uploadVertexBytes( ::h3d::impl::GLVB v,int startVertex,int vertexCount,::haxe::io::Bytes buf,int bufPos){
{
		HX_STACK_FRAME("h3d.impl.Driver","uploadVertexBytes",0x01d64999,"h3d.impl.Driver.uploadVertexBytes","h3d/impl/Driver.hx",147,0xe373499d)
		HX_STACK_THIS(this)
		HX_STACK_ARG(v,"v")
		HX_STACK_ARG(startVertex,"startVertex")
		HX_STACK_ARG(vertexCount,"vertexCount")
		HX_STACK_ARG(buf,"buf")
		HX_STACK_ARG(bufPos,"bufPos")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC5(Driver_obj,uploadVertexBytes,(void))

Void Driver_obj::uploadTextureBitmap( ::h3d::mat::Texture t,::flash::display::BitmapData bmp,int mipLevel,int side){
{
		HX_STACK_FRAME("h3d.impl.Driver","uploadTextureBitmap",0x93180adc,"h3d.impl.Driver.uploadTextureBitmap","h3d/impl/Driver.hx",151,0xe373499d)
		HX_STACK_THIS(this)
		HX_STACK_ARG(t,"t")
		HX_STACK_ARG(bmp,"bmp")
		HX_STACK_ARG(mipLevel,"mipLevel")
		HX_STACK_ARG(side,"side")
		HX_STACK_LINE(151)
		HX_STACK_DO_THROW(HX_CSTRING("not implemented"));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Driver_obj,uploadTextureBitmap,(void))

Void Driver_obj::uploadTexturePixels( ::h3d::mat::Texture t,::hxd::Pixels pixels,int mipLevel,int side){
{
		HX_STACK_FRAME("h3d.impl.Driver","uploadTexturePixels",0x2eb5ea1a,"h3d.impl.Driver.uploadTexturePixels","h3d/impl/Driver.hx",154,0xe373499d)
		HX_STACK_THIS(this)
		HX_STACK_ARG(t,"t")
		HX_STACK_ARG(pixels,"pixels")
		HX_STACK_ARG(mipLevel,"mipLevel")
		HX_STACK_ARG(side,"side")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Driver_obj,uploadTexturePixels,(void))

Void Driver_obj::resetHardware( ){
{
		HX_STACK_FRAME("h3d.impl.Driver","resetHardware",0x93a235ca,"h3d.impl.Driver.resetHardware","h3d/impl/Driver.hx",158,0xe373499d)
		HX_STACK_THIS(this)
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Driver_obj,resetHardware,(void))

Void Driver_obj::restoreOpenfl( ){
{
		HX_STACK_FRAME("h3d.impl.Driver","restoreOpenfl",0xa05a13b1,"h3d.impl.Driver.restoreOpenfl","h3d/impl/Driver.hx",163,0xe373499d)
		HX_STACK_THIS(this)
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Driver_obj,restoreOpenfl,(void))


Driver_obj::Driver_obj()
{
}

Dynamic Driver_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"init") ) { return init_dyn(); }
		if (HX_FIELD_EQ(inName,"draw") ) { return draw_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"begin") ) { return begin_dyn(); }
		if (HX_FIELD_EQ(inName,"clear") ) { return clear_dyn(); }
		if (HX_FIELD_EQ(inName,"reset") ) { return reset_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"resize") ) { return resize_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		if (HX_FIELD_EQ(inName,"present") ) { return present_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"setDebug") ) { return setDebug_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"isDisposed") ) { return isDisposed_dyn(); }
		if (HX_FIELD_EQ(inName,"isHardware") ) { return isHardware_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"allocVertex") ) { return allocVertex_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"selectShader") ) { return selectShader_dyn(); }
		if (HX_FIELD_EQ(inName,"deleteShader") ) { return deleteShader_dyn(); }
		if (HX_FIELD_EQ(inName,"selectBuffer") ) { return selectBuffer_dyn(); }
		if (HX_FIELD_EQ(inName,"allocTexture") ) { return allocTexture_dyn(); }
		if (HX_FIELD_EQ(inName,"allocIndexes") ) { return allocIndexes_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"getDriverName") ) { return getDriverName_dyn(); }
		if (HX_FIELD_EQ(inName,"setRenderZone") ) { return setRenderZone_dyn(); }
		if (HX_FIELD_EQ(inName,"disposeVertex") ) { return disposeVertex_dyn(); }
		if (HX_FIELD_EQ(inName,"resetHardware") ) { return resetHardware_dyn(); }
		if (HX_FIELD_EQ(inName,"restoreOpenfl") ) { return restoreOpenfl_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"selectMaterial") ) { return selectMaterial_dyn(); }
		if (HX_FIELD_EQ(inName,"disposeTexture") ) { return disposeTexture_dyn(); }
		if (HX_FIELD_EQ(inName,"disposeIndexes") ) { return disposeIndexes_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"setRenderTarget") ) { return setRenderTarget_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"uploadVertexBytes") ) { return uploadVertexBytes_dyn(); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"selectMultiBuffers") ) { return selectMultiBuffers_dyn(); }
		if (HX_FIELD_EQ(inName,"uploadIndexesBytes") ) { return uploadIndexesBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"uploadVertexBuffer") ) { return uploadVertexBuffer_dyn(); }
		break;
	case 19:
		if (HX_FIELD_EQ(inName,"getShaderInputNames") ) { return getShaderInputNames_dyn(); }
		if (HX_FIELD_EQ(inName,"uploadIndexesBuffer") ) { return uploadIndexesBuffer_dyn(); }
		if (HX_FIELD_EQ(inName,"uploadTextureBitmap") ) { return uploadTextureBitmap_dyn(); }
		if (HX_FIELD_EQ(inName,"uploadTexturePixels") ) { return uploadTexturePixels_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Driver_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void Driver_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("isDisposed"),
	HX_CSTRING("begin"),
	HX_CSTRING("dispose"),
	HX_CSTRING("clear"),
	HX_CSTRING("reset"),
	HX_CSTRING("getDriverName"),
	HX_CSTRING("init"),
	HX_CSTRING("resize"),
	HX_CSTRING("selectMaterial"),
	HX_CSTRING("selectShader"),
	HX_CSTRING("deleteShader"),
	HX_CSTRING("selectBuffer"),
	HX_CSTRING("getShaderInputNames"),
	HX_CSTRING("selectMultiBuffers"),
	HX_CSTRING("draw"),
	HX_CSTRING("setRenderZone"),
	HX_CSTRING("setRenderTarget"),
	HX_CSTRING("present"),
	HX_CSTRING("isHardware"),
	HX_CSTRING("setDebug"),
	HX_CSTRING("allocTexture"),
	HX_CSTRING("allocIndexes"),
	HX_CSTRING("allocVertex"),
	HX_CSTRING("disposeTexture"),
	HX_CSTRING("disposeIndexes"),
	HX_CSTRING("disposeVertex"),
	HX_CSTRING("uploadIndexesBuffer"),
	HX_CSTRING("uploadIndexesBytes"),
	HX_CSTRING("uploadVertexBuffer"),
	HX_CSTRING("uploadVertexBytes"),
	HX_CSTRING("uploadTextureBitmap"),
	HX_CSTRING("uploadTexturePixels"),
	HX_CSTRING("resetHardware"),
	HX_CSTRING("restoreOpenfl"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Driver_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Driver_obj::__mClass,"__mClass");
};

#endif

Class Driver_obj::__mClass;

void Driver_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.impl.Driver"), hx::TCanCast< Driver_obj> ,sStaticFields,sMemberFields,
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

void Driver_obj::__boot()
{
}

} // end namespace h3d
} // end namespace impl
