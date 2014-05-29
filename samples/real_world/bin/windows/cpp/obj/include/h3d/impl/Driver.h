#ifndef INCLUDED_h3d_impl_Driver
#define INCLUDED_h3d_impl_Driver

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,display,BitmapData)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(h3d,impl,BufferOffset)
HX_DECLARE_CLASS2(h3d,impl,Driver)
HX_DECLARE_CLASS2(h3d,impl,GLVB)
HX_DECLARE_CLASS2(h3d,impl,Shader)
HX_DECLARE_CLASS2(h3d,mat,Texture)
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS1(hxd,Pixels)
HX_DECLARE_CLASS2(openfl,gl,GLBuffer)
HX_DECLARE_CLASS2(openfl,gl,GLObject)
HX_DECLARE_CLASS2(openfl,gl,GLTexture)
namespace h3d{
namespace impl{


class HXCPP_CLASS_ATTRIBUTES  Driver_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Driver_obj OBJ_;
		Driver_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Driver_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Driver_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Driver"); }

		virtual bool isDisposed( );
		Dynamic isDisposed_dyn();

		virtual Void begin( );
		Dynamic begin_dyn();

		virtual Void dispose( );
		Dynamic dispose_dyn();

		virtual Void clear( Float r,Float g,Float b,Float a);
		Dynamic clear_dyn();

		virtual Void reset( );
		Dynamic reset_dyn();

		virtual ::String getDriverName( bool details);
		Dynamic getDriverName_dyn();

		virtual Void init( Dynamic onCreate,hx::Null< bool >  forceSoftware);
		Dynamic init_dyn();

		virtual Void resize( int width,int height);
		Dynamic resize_dyn();

		virtual Void selectMaterial( int mbits);
		Dynamic selectMaterial_dyn();

		virtual bool selectShader( ::h3d::impl::Shader shader);
		Dynamic selectShader_dyn();

		virtual Void deleteShader( ::h3d::impl::Shader shader);
		Dynamic deleteShader_dyn();

		virtual Void selectBuffer( ::h3d::impl::GLVB buffer);
		Dynamic selectBuffer_dyn();

		virtual Array< ::String > getShaderInputNames( );
		Dynamic getShaderInputNames_dyn();

		virtual Void selectMultiBuffers( Array< ::Dynamic > buffers);
		Dynamic selectMultiBuffers_dyn();

		virtual Void draw( ::openfl::gl::GLBuffer ibuf,int startIndex,int ntriangles);
		Dynamic draw_dyn();

		virtual Void setRenderZone( int x,int y,int width,int height);
		Dynamic setRenderZone_dyn();

		virtual Void setRenderTarget( ::h3d::mat::Texture tex,bool useDepth,int clearColor);
		Dynamic setRenderTarget_dyn();

		virtual Void present( );
		Dynamic present_dyn();

		virtual bool isHardware( );
		Dynamic isHardware_dyn();

		virtual Void setDebug( bool b);
		Dynamic setDebug_dyn();

		virtual ::openfl::gl::GLTexture allocTexture( ::h3d::mat::Texture t);
		Dynamic allocTexture_dyn();

		virtual ::openfl::gl::GLBuffer allocIndexes( int count);
		Dynamic allocIndexes_dyn();

		virtual ::h3d::impl::GLVB allocVertex( int count,int stride,hx::Null< bool >  isDynamic);
		Dynamic allocVertex_dyn();

		virtual Void disposeTexture( ::openfl::gl::GLTexture t);
		Dynamic disposeTexture_dyn();

		virtual Void disposeIndexes( ::openfl::gl::GLBuffer i);
		Dynamic disposeIndexes_dyn();

		virtual Void disposeVertex( ::h3d::impl::GLVB v);
		Dynamic disposeVertex_dyn();

		virtual Void uploadIndexesBuffer( ::openfl::gl::GLBuffer i,int startIndice,int indiceCount,Array< int > buf,int bufPos);
		Dynamic uploadIndexesBuffer_dyn();

		virtual Void uploadIndexesBytes( ::openfl::gl::GLBuffer i,int startIndice,int indiceCount,::haxe::io::Bytes buf,int bufPos);
		Dynamic uploadIndexesBytes_dyn();

		virtual Void uploadVertexBuffer( ::h3d::impl::GLVB v,int startVertex,int vertexCount,Array< Float > buf,int bufPos);
		Dynamic uploadVertexBuffer_dyn();

		virtual Void uploadVertexBytes( ::h3d::impl::GLVB v,int startVertex,int vertexCount,::haxe::io::Bytes buf,int bufPos);
		Dynamic uploadVertexBytes_dyn();

		virtual Void uploadTextureBitmap( ::h3d::mat::Texture t,::flash::display::BitmapData bmp,int mipLevel,int side);
		Dynamic uploadTextureBitmap_dyn();

		virtual Void uploadTexturePixels( ::h3d::mat::Texture t,::hxd::Pixels pixels,int mipLevel,int side);
		Dynamic uploadTexturePixels_dyn();

		virtual Void resetHardware( );
		Dynamic resetHardware_dyn();

		virtual Void restoreOpenfl( );
		Dynamic restoreOpenfl_dyn();

};

} // end namespace h3d
} // end namespace impl

#endif /* INCLUDED_h3d_impl_Driver */ 
