#ifndef INCLUDED_h2d_Drawable
#define INCLUDED_h2d_Drawable

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h2d/Sprite.h>
HX_DECLARE_CLASS1(h2d,BlendMode)
HX_DECLARE_CLASS1(h2d,Drawable)
HX_DECLARE_CLASS1(h2d,DrawableShader)
HX_DECLARE_CLASS1(h2d,Sprite)
HX_DECLARE_CLASS1(h2d,Tile)
HX_DECLARE_CLASS1(h3d,Engine)
HX_DECLARE_CLASS1(h3d,Matrix)
HX_DECLARE_CLASS1(h3d,Vector)
HX_DECLARE_CLASS2(h3d,impl,Shader)
namespace h2d{


class HXCPP_CLASS_ATTRIBUTES  Drawable_obj : public ::h2d::Sprite_obj{
	public:
		typedef ::h2d::Sprite_obj super;
		typedef Drawable_obj OBJ_;
		Drawable_obj();
		Void __construct(::h2d::Sprite parent,::h2d::DrawableShader sh);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Drawable_obj > __new(::h2d::Sprite parent,::h2d::DrawableShader sh);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Drawable_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Drawable"); }

		::h2d::DrawableShader shader;
		::h2d::BlendMode blendMode;
		::h2d::Tile alphaMap;
		::h2d::Tile multiplyMap;
		bool writeAlpha;
		virtual bool get_hasAlpha( );
		Dynamic get_hasAlpha_dyn();

		virtual bool set_hasAlpha( bool v);
		Dynamic set_hasAlpha_dyn();

		virtual Float get_alpha( );
		Dynamic get_alpha_dyn();

		virtual Float set_alpha( Float v);
		Dynamic set_alpha_dyn();

		virtual ::h2d::BlendMode set_blendMode( ::h2d::BlendMode b);
		Dynamic set_blendMode_dyn();

		virtual Float get_multiplyFactor( );
		Dynamic get_multiplyFactor_dyn();

		virtual Float set_multiplyFactor( Float v);
		Dynamic set_multiplyFactor_dyn();

		virtual ::h2d::Tile set_multiplyMap( ::h2d::Tile t);
		Dynamic set_multiplyMap_dyn();

		virtual ::h2d::Tile set_alphaMap( ::h2d::Tile t);
		Dynamic set_alphaMap_dyn();

		virtual ::h3d::Vector get_sinusDeform( );
		Dynamic get_sinusDeform_dyn();

		virtual ::h3d::Vector set_sinusDeform( ::h3d::Vector v);
		Dynamic set_sinusDeform_dyn();

		virtual ::h3d::Matrix get_colorMatrix( );
		Dynamic get_colorMatrix_dyn();

		virtual ::h3d::Matrix set_colorMatrix( ::h3d::Matrix m);
		Dynamic set_colorMatrix_dyn();

		virtual ::h3d::Vector set_color( ::h3d::Vector m);
		Dynamic set_color_dyn();

		virtual ::h3d::Vector set_colorAdd( ::h3d::Vector m);
		Dynamic set_colorAdd_dyn();

		virtual ::h3d::Vector get_colorAdd( );
		Dynamic get_colorAdd_dyn();

		virtual ::h3d::Vector get_color( );
		Dynamic get_color_dyn();

		virtual bool get_filter( );
		Dynamic get_filter_dyn();

		virtual bool set_filter( bool v);
		Dynamic set_filter_dyn();

		virtual bool get_tileWrap( );
		Dynamic get_tileWrap_dyn();

		virtual bool set_tileWrap( bool v);
		Dynamic set_tileWrap_dyn();

		virtual bool get_killAlpha( );
		Dynamic get_killAlpha_dyn();

		virtual bool set_killAlpha( bool v);
		Dynamic set_killAlpha_dyn();

		virtual int get_colorKey( );
		Dynamic get_colorKey_dyn();

		virtual int set_colorKey( int v);
		Dynamic set_colorKey_dyn();

		virtual Void drawTile( ::h3d::Engine engine,::h2d::Tile tile);
		Dynamic drawTile_dyn();

		virtual Void setupShader( ::h3d::Engine engine,::h2d::Tile tile,int options);
		Dynamic setupShader_dyn();

		virtual Void dispose( );

		static int HAS_SIZE;
		static int HAS_UV_SCALE;
		static int HAS_UV_POS;
		static int BASE_TILE_DONT_CARE;
};

} // end namespace h2d

#endif /* INCLUDED_h2d_Drawable */ 
