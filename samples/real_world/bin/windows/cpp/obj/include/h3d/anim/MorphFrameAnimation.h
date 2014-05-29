#ifndef INCLUDED_h3d_anim_MorphFrameAnimation
#define INCLUDED_h3d_anim_MorphFrameAnimation

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h3d/anim/Animation.h>
HX_DECLARE_CLASS2(h3d,anim,AnimatedObject)
HX_DECLARE_CLASS2(h3d,anim,Animation)
HX_DECLARE_CLASS2(h3d,anim,MorphFrameAnimation)
HX_DECLARE_CLASS2(h3d,anim,MorphObject)
HX_DECLARE_CLASS2(h3d,anim,MorphShape)
HX_DECLARE_CLASS2(h3d,scene,Object)
namespace h3d{
namespace anim{


class HXCPP_CLASS_ATTRIBUTES  MorphFrameAnimation_obj : public ::h3d::anim::Animation_obj{
	public:
		typedef ::h3d::anim::Animation_obj super;
		typedef MorphFrameAnimation_obj OBJ_;
		MorphFrameAnimation_obj();
		Void __construct(::String name,int frame,Float sampling);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< MorphFrameAnimation_obj > __new(::String name,int frame,Float sampling);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~MorphFrameAnimation_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("MorphFrameAnimation"); }

		int syncFrame;
		Array< ::Dynamic > shapes;
		virtual Array< ::Dynamic > getObjects( );
		Dynamic getObjects_dyn();

		virtual ::h3d::anim::MorphObject addObject( ::String name,int nbShape);
		Dynamic addObject_dyn();

		virtual Void addShape( Array< int > index,Array< Float > vertex,Array< Float > normal);
		Dynamic addShape_dyn();

		virtual ::h3d::anim::Animation clone( ::h3d::anim::Animation a);

		virtual Void sync( hx::Null< bool >  decompose);

		virtual Array< Float > norm3( Array< Float > fb);
		Dynamic norm3_dyn();

		virtual Void writeTarget( int fr);
		Dynamic writeTarget_dyn();

		virtual Void manualBind( ::h3d::scene::Object base);
		Dynamic manualBind_dyn();

		virtual Void bind( ::h3d::scene::Object base);

};

} // end namespace h3d
} // end namespace anim

#endif /* INCLUDED_h3d_anim_MorphFrameAnimation */ 
