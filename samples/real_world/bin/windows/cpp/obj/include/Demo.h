#ifndef INCLUDED_Demo
#define INCLUDED_Demo

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(Demo)
HX_DECLARE_CLASS0(List)
HX_DECLARE_CLASS1(h2d,Anim)
HX_DECLARE_CLASS1(h2d,Bitmap)
HX_DECLARE_CLASS1(h2d,Drawable)
HX_DECLARE_CLASS1(h2d,Graphics)
HX_DECLARE_CLASS1(h2d,Layers)
HX_DECLARE_CLASS1(h2d,Scene)
HX_DECLARE_CLASS1(h2d,Sprite)
HX_DECLARE_CLASS1(h2d,SpriteBatch)
HX_DECLARE_CLASS1(h2d,Text)
HX_DECLARE_CLASS1(h3d,Engine)
HX_DECLARE_CLASS1(h3d,IDrawable)


class HXCPP_CLASS_ATTRIBUTES  Demo_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Demo_obj OBJ_;
		Demo_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Demo_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Demo_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Demo"); }

		::h3d::Engine engine;
		::h2d::Scene scene;
		::List actions;
		virtual Void onResize( Dynamic _);
		Dynamic onResize_dyn();

		virtual Void init( );
		Dynamic init_dyn();

		int spin;
		int count;
		virtual Void update( );
		Dynamic update_dyn();

		static ::h2d::Sprite square;
		static ::h2d::Sprite sphere;
		static ::h2d::Graphics bds;
		static ::h2d::Text fps;
		static ::h2d::Text tf;
		static ::h2d::SpriteBatch batch;
		static ::h2d::Bitmap bmp;
		static ::h2d::Anim anim;
		static Array< ::Dynamic > anims;
		static Void main( );
		static Dynamic main_dyn();

};


#endif /* INCLUDED_Demo */ 
