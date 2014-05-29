#ifndef INCLUDED_h2d_Anim
#define INCLUDED_h2d_Anim

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h2d/Drawable.h>
HX_DECLARE_CLASS1(h2d,Anim)
HX_DECLARE_CLASS1(h2d,Drawable)
HX_DECLARE_CLASS1(h2d,DrawableShader)
HX_DECLARE_CLASS1(h2d,Sprite)
HX_DECLARE_CLASS1(h2d,Tile)
HX_DECLARE_CLASS2(h2d,col,Bounds)
HX_DECLARE_CLASS2(h3d,impl,Shader)
HX_DECLARE_CLASS2(h3d,scene,RenderContext)
namespace h2d{


class HXCPP_CLASS_ATTRIBUTES  Anim_obj : public ::h2d::Drawable_obj{
	public:
		typedef ::h2d::Drawable_obj super;
		typedef Anim_obj OBJ_;
		Anim_obj();
		Void __construct(Array< ::Dynamic > frames,Dynamic speed,::h2d::DrawableShader sh,::h2d::Sprite parent);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Anim_obj > __new(Array< ::Dynamic > frames,Dynamic speed,::h2d::DrawableShader sh,::h2d::Sprite parent);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Anim_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Anim"); }

		Array< ::Dynamic > frames;
		Float currentFrame;
		Float speed;
		bool loop;
		virtual Void play( Array< ::Dynamic > frames);
		Dynamic play_dyn();

		virtual Void sync( ::h3d::scene::RenderContext ctx);

		virtual ::h2d::Tile getFrame( );
		Dynamic getFrame_dyn();

		virtual ::h2d::col::Bounds getMyBounds( );

		virtual Void draw( ::h3d::scene::RenderContext ctx);

};

} // end namespace h2d

#endif /* INCLUDED_h2d_Anim */ 
