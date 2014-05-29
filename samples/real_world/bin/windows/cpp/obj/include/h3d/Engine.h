#ifndef INCLUDED_h3d_Engine
#define INCLUDED_h3d_Engine

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(h3d,Drawable)
HX_DECLARE_CLASS1(h3d,Engine)
HX_DECLARE_CLASS1(h3d,IDrawable)
HX_DECLARE_CLASS1(h3d,Matrix)
HX_DECLARE_CLASS2(h3d,impl,BigBuffer)
HX_DECLARE_CLASS2(h3d,impl,Buffer)
HX_DECLARE_CLASS2(h3d,impl,BufferOffset)
HX_DECLARE_CLASS2(h3d,impl,Driver)
HX_DECLARE_CLASS2(h3d,impl,Indexes)
HX_DECLARE_CLASS2(h3d,impl,MemoryManager)
HX_DECLARE_CLASS2(h3d,impl,Shader)
HX_DECLARE_CLASS2(h3d,mat,Material)
HX_DECLARE_CLASS2(h3d,mat,Texture)
namespace h3d{


class HXCPP_CLASS_ATTRIBUTES  Engine_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Engine_obj OBJ_;
		Engine_obj();
		Void __construct(hx::Null< bool >  __o_hardware,hx::Null< int >  __o_aa);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Engine_obj > __new(hx::Null< bool >  __o_hardware,hx::Null< int >  __o_aa);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Engine_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Engine"); }

		::h3d::impl::Driver driver;
		::h3d::impl::MemoryManager mem;
		bool hardware;
		int width;
		int height;
		bool debug;
		int drawTriangles;
		int drawCalls;
		int shaderSwitches;
		int backgroundColor;
		bool autoResize;
		bool fullScreen;
		bool triggerClear;
		int frameCount;
		int forcedMatBits;
		int forcedMatMask;
		Float realFps;
		Float lastTime;
		int antiAlias;
		::h3d::Drawable debugPoint;
		::h3d::Drawable debugLine;
		::h3d::Matrix curProjMatrix;
		virtual ::h3d::impl::Driver get_driver( );
		Dynamic get_driver_dyn();

		virtual Void start( );
		Dynamic start_dyn();

		virtual Void setCurrent( );
		Dynamic setCurrent_dyn();

		virtual Void init( );
		Dynamic init_dyn();

		virtual ::String driverName( hx::Null< bool >  details);
		Dynamic driverName_dyn();

		virtual Void selectShader( ::h3d::impl::Shader shader);
		Dynamic selectShader_dyn();

		virtual Void selectMaterial( ::h3d::mat::Material m);
		Dynamic selectMaterial_dyn();

		virtual bool selectBuffer( ::h3d::impl::BigBuffer buf);
		Dynamic selectBuffer_dyn();

		virtual bool renderTriBuffer( ::h3d::impl::Buffer b,hx::Null< int >  start,hx::Null< int >  max);
		Dynamic renderTriBuffer_dyn();

		virtual bool renderQuadBuffer( ::h3d::impl::Buffer b,hx::Null< int >  start,hx::Null< int >  max);
		Dynamic renderQuadBuffer_dyn();

		virtual bool renderBuffer( ::h3d::impl::Buffer b,::h3d::impl::Indexes indexes,int vertPerTri,hx::Null< int >  startTri,hx::Null< int >  drawTri);
		Dynamic renderBuffer_dyn();

		virtual Void renderIndexed( ::h3d::impl::Buffer b,::h3d::impl::Indexes indexes,hx::Null< int >  startTri,hx::Null< int >  drawTri);
		Dynamic renderIndexed_dyn();

		virtual Void renderMultiBuffers( Array< ::Dynamic > buffers,::h3d::impl::Indexes indexes,hx::Null< int >  startTri,hx::Null< int >  drawTri);
		Dynamic renderMultiBuffers_dyn();

		virtual bool set_debug( bool d);
		Dynamic set_debug_dyn();

		virtual Void onCreate( bool disposed);
		Dynamic onCreate_dyn();

		Dynamic onContextLost;
		inline Dynamic &onContextLost_dyn() {return onContextLost; }

		Dynamic onReady;
		inline Dynamic &onReady_dyn() {return onReady; }

		virtual Void onStageResize( );
		Dynamic onStageResize_dyn();

		virtual bool set_fullScreen( bool v);
		Dynamic set_fullScreen_dyn();

		Dynamic onResized;
		inline Dynamic &onResized_dyn() {return onResized; }

		virtual Void resize( int width,int height);
		Dynamic resize_dyn();

		virtual bool begin( );
		Dynamic begin_dyn();

		virtual Void reset( );
		Dynamic reset_dyn();

		virtual Void end( );
		Dynamic end_dyn();

		virtual Void setTarget( ::h3d::mat::Texture tex,Dynamic bindDepth,Dynamic clearColor);
		Dynamic setTarget_dyn();

		virtual Void setRenderZone( hx::Null< int >  x,hx::Null< int >  y,Dynamic width,Dynamic height);
		Dynamic setRenderZone_dyn();

		virtual bool render( Dynamic obj);
		Dynamic render_dyn();

		virtual Void point( Float x,Float y,Float z,hx::Null< int >  color,hx::Null< Float >  size,hx::Null< bool >  depth);
		Dynamic point_dyn();

		virtual Void line( Float x1,Float y1,Float z1,Float x2,Float y2,Float z2,hx::Null< int >  color,hx::Null< bool >  depth);
		Dynamic line_dyn();

		virtual Void lineP( Dynamic a,Dynamic b,hx::Null< int >  color,hx::Null< bool >  depth);
		Dynamic lineP_dyn();

		virtual Void dispose( );
		Dynamic dispose_dyn();

		virtual Float get_fps( );
		Dynamic get_fps_dyn();

		virtual Void restoreOpenfl( );
		Dynamic restoreOpenfl_dyn();

		static ::h3d::Engine CURRENT;
		static Void check( );
		static Dynamic check_dyn();

		static ::h3d::Engine getCurrent( );
		static Dynamic getCurrent_dyn();

};

} // end namespace h3d

#endif /* INCLUDED_h3d_Engine */ 
