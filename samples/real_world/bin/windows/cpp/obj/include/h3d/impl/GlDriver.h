#ifndef INCLUDED_h3d_impl_GlDriver
#define INCLUDED_h3d_impl_GlDriver

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h3d/impl/Driver.h>
HX_DECLARE_CLASS0(IMap)
HX_DECLARE_CLASS0(List)
HX_DECLARE_CLASS2(flash,display,BitmapData)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS1(h3d,Matrix)
HX_DECLARE_CLASS1(h3d,Vector)
HX_DECLARE_CLASS2(h3d,impl,BufferOffset)
HX_DECLARE_CLASS2(h3d,impl,Driver)
HX_DECLARE_CLASS2(h3d,impl,FBO)
HX_DECLARE_CLASS2(h3d,impl,GLVB)
HX_DECLARE_CLASS2(h3d,impl,GlDriver)
HX_DECLARE_CLASS2(h3d,impl,Shader)
HX_DECLARE_CLASS2(h3d,impl,ShaderInstance)
HX_DECLARE_CLASS2(h3d,impl,ShaderType)
HX_DECLARE_CLASS2(h3d,impl,Uniform)
HX_DECLARE_CLASS2(h3d,impl,UniformContext)
HX_DECLARE_CLASS2(h3d,mat,Filter)
HX_DECLARE_CLASS2(h3d,mat,MipMap)
HX_DECLARE_CLASS2(h3d,mat,Texture)
HX_DECLARE_CLASS2(h3d,mat,Wrap)
HX_DECLARE_CLASS2(haxe,ds,IntMap)
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS1(hxd,Pixels)
HX_DECLARE_CLASS2(openfl,gl,GLBuffer)
HX_DECLARE_CLASS2(openfl,gl,GLObject)
HX_DECLARE_CLASS2(openfl,gl,GLProgram)
HX_DECLARE_CLASS2(openfl,gl,GLShader)
HX_DECLARE_CLASS2(openfl,gl,GLTexture)
HX_DECLARE_CLASS2(openfl,utils,ArrayBufferView)
HX_DECLARE_CLASS2(openfl,utils,Float32Array)
HX_DECLARE_CLASS2(openfl,utils,IMemoryRange)
HX_DECLARE_CLASS2(openfl,utils,Int16Array)
HX_DECLARE_CLASS2(openfl,utils,UInt8Array)
namespace h3d{
namespace impl{


class HXCPP_CLASS_ATTRIBUTES  GlDriver_obj : public ::h3d::impl::Driver_obj{
	public:
		typedef ::h3d::impl::Driver_obj super;
		typedef GlDriver_obj OBJ_;
		GlDriver_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< GlDriver_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~GlDriver_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("GlDriver"); }

		bool fixMult;
		::h3d::impl::ShaderInstance curShader;
		int curMatBits;
		bool depthMask;
		bool depthTest;
		int depthFunc;
		Array< ::Dynamic > curTex;
		int shaderSwitch;
		int textureSwitch;
		int resetSwitch;
		virtual ::openfl::utils::UInt8Array getUints( ::haxe::io::Bytes h,hx::Null< int >  pos,Dynamic size);
		Dynamic getUints_dyn();

		virtual ::openfl::utils::Int16Array getUints16( ::haxe::io::Bytes h,hx::Null< int >  pos);
		Dynamic getUints16_dyn();

		virtual Void reset( );

		virtual Void selectMaterial( int mbits);

		virtual Void clear( Float r,Float g,Float b,Float a);

		virtual Void begin( );

		virtual Array< ::String > getShaderInputNames( );

		int vpWidth;
		int vpHeight;
		virtual Void resize( int width,int height);

		virtual ::openfl::gl::GLTexture allocTexture( ::h3d::mat::Texture t);

		virtual ::h3d::impl::GLVB allocVertex( int count,int stride,hx::Null< bool >  isDynamic);

		virtual ::openfl::gl::GLBuffer allocIndexes( int count);

		virtual Void setRenderZone( int x,int y,int width,int height);

		::List fboList;
		::List fboStack;
		virtual Void checkFBO( ::h3d::impl::FBO fbo);
		Dynamic checkFBO_dyn();

		virtual Void setRenderTarget( ::h3d::mat::Texture tex,bool useDepth,int clearColor);

		virtual Void disposeTexture( ::openfl::gl::GLTexture t);

		virtual Void disposeIndexes( ::openfl::gl::GLBuffer i);

		virtual Void disposeVertex( ::h3d::impl::GLVB v);

		virtual Void makeMips( );
		Dynamic makeMips_dyn();

		virtual Void uploadTextureBitmap( ::h3d::mat::Texture t,::flash::display::BitmapData bmp,int mipLevel,int side);

		virtual Void uploadTexturePixels( ::h3d::mat::Texture t,::hxd::Pixels pixels,int mipLevel,int side);

		virtual Void uploadVertexBuffer( ::h3d::impl::GLVB v,int startVertex,int vertexCount,Array< Float > buf,int bufPos);

		virtual Void uploadVertexBytes( ::h3d::impl::GLVB v,int startVertex,int vertexCount,::haxe::io::Bytes buf,int bufPos);

		virtual Void uploadIndexesBuffer( ::openfl::gl::GLBuffer i,int startIndice,int indiceCount,Array< int > buf,int bufPos);

		virtual Void uploadIndexesBytes( ::openfl::gl::GLBuffer i,int startIndice,int indiceCount,::haxe::io::Bytes buf,int bufPos);

		virtual ::h3d::impl::ShaderType decodeType( ::String t);
		Dynamic decodeType_dyn();

		virtual ::h3d::impl::ShaderType decodeTypeInt( int t);
		Dynamic decodeTypeInt_dyn();

		virtual int typeSize( ::h3d::impl::ShaderType t);
		Dynamic typeSize_dyn();

		virtual ::h3d::impl::ShaderInstance buildShaderInstance( ::h3d::impl::Shader shader);
		Dynamic buildShaderInstance_dyn();

		::h3d::impl::UniformContext parseUniInfo;
		virtual ::String findVarComment( ::String str,::String code);
		Dynamic findVarComment_dyn();

		virtual bool hasArrayAccess( ::String str,::String code);
		Dynamic hasArrayAccess_dyn();

		virtual ::h3d::impl::Uniform parseUniform( ::String allCode,::openfl::gl::GLProgram p);
		Dynamic parseUniform_dyn();

		virtual Void deleteShader( ::h3d::impl::Shader shader);

		virtual bool selectShader( ::h3d::impl::Shader shader);

		virtual bool setupTexture( ::h3d::mat::Texture t,int stage,::h3d::mat::MipMap mipMap,::h3d::mat::Filter filter,::h3d::mat::Wrap wrap);
		Dynamic setupTexture_dyn();

		virtual ::openfl::utils::Float32Array blitMatrices( Array< ::Dynamic > a,bool transpose);
		Dynamic blitMatrices_dyn();

		virtual ::openfl::utils::Float32Array blitMatrix( ::h3d::Matrix a,bool transpose,hx::Null< int >  ofs,::openfl::utils::Float32Array t);
		Dynamic blitMatrix_dyn();

		virtual ::openfl::utils::Float32Array createF32( int sz);
		Dynamic createF32_dyn();

		virtual Void deleteF32( ::openfl::utils::Float32Array a);
		Dynamic deleteF32_dyn();

		virtual Void setUniform( Dynamic val,::h3d::impl::Uniform u,::h3d::impl::ShaderType t,bool shaderChange);
		Dynamic setUniform_dyn();

		virtual ::openfl::utils::Float32Array packArray4( Array< ::Dynamic > vecs);
		Dynamic packArray4_dyn();

		virtual ::openfl::utils::Float32Array packArray3( Array< ::Dynamic > vecs);
		Dynamic packArray3_dyn();

		::h3d::impl::GLVB curBuffer;
		Array< ::Dynamic > curMultiBuffer;
		virtual Void selectBuffer( ::h3d::impl::GLVB v);

		virtual Void selectMultiBuffers( Array< ::Dynamic > buffers);

		virtual Void checkObject( ::openfl::gl::GLObject o);
		Dynamic checkObject_dyn();

		virtual Void draw( ::openfl::gl::GLBuffer ibuf,int startIndex,int ntriangles);

		virtual Void present( );

		virtual bool isDisposed( );

		virtual Void init( Dynamic onCreate,hx::Null< bool >  forceSoftware);

		virtual ::String glCompareToString( int c);
		Dynamic glCompareToString_dyn();

		virtual Void checkError( );
		Dynamic checkError_dyn();

		virtual ::String getError( );
		Dynamic getError_dyn();

		virtual ::String getShaderInfoLog( ::openfl::gl::GLShader s,Dynamic code);
		Dynamic getShaderInfoLog_dyn();

		virtual ::String getProgramInfoLog( ::openfl::gl::GLProgram p,Dynamic code);
		Dynamic getProgramInfoLog_dyn();

		virtual Void restoreOpenfl( );

		static Dynamic gl;
		static ::haxe::ds::IntMap f32Pool;
		static Array< ::Dynamic > TFILTERS;
		static Array< int > TWRAP;
		static Array< int > FACES;
		static Array< int > BLEND;
		static Array< int > COMPARE;
};

} // end namespace h3d
} // end namespace impl

#endif /* INCLUDED_h3d_impl_GlDriver */ 
