#ifndef INCLUDED_h3d_anim_FrameAnimation
#define INCLUDED_h3d_anim_FrameAnimation

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h3d/anim/Animation.h>
HX_DECLARE_CLASS1(h3d,Matrix)
HX_DECLARE_CLASS2(h3d,anim,AnimatedObject)
HX_DECLARE_CLASS2(h3d,anim,Animation)
HX_DECLARE_CLASS2(h3d,anim,FrameAnimation)
HX_DECLARE_CLASS2(h3d,anim,FrameObject)
namespace h3d{
namespace anim{


class HXCPP_CLASS_ATTRIBUTES  FrameAnimation_obj : public ::h3d::anim::Animation_obj{
	public:
		typedef ::h3d::anim::Animation_obj super;
		typedef FrameAnimation_obj OBJ_;
		FrameAnimation_obj();
		Void __construct(::String name,int frame,Float sampling);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< FrameAnimation_obj > __new(::String name,int frame,Float sampling);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~FrameAnimation_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("FrameAnimation"); }

		int syncFrame;
		virtual Void addCurve( ::String objName,Array< ::Dynamic > frames);
		Dynamic addCurve_dyn();

		virtual Void addAlphaCurve( ::String objName,Array< Float > alphas);
		Dynamic addAlphaCurve_dyn();

		virtual Array< ::Dynamic > getFrames( );
		Dynamic getFrames_dyn();

		virtual Void initInstance( );

		virtual ::h3d::anim::Animation clone( ::h3d::anim::Animation a);

		virtual Void sync( hx::Null< bool >  decompose);

};

} // end namespace h3d
} // end namespace anim

#endif /* INCLUDED_h3d_anim_FrameAnimation */ 
