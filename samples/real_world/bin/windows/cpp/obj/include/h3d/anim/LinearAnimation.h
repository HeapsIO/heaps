#ifndef INCLUDED_h3d_anim_LinearAnimation
#define INCLUDED_h3d_anim_LinearAnimation

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h3d/anim/Animation.h>
HX_DECLARE_CLASS2(h3d,anim,AnimatedObject)
HX_DECLARE_CLASS2(h3d,anim,Animation)
HX_DECLARE_CLASS2(h3d,anim,LinearAnimation)
HX_DECLARE_CLASS2(h3d,anim,LinearFrame)
HX_DECLARE_CLASS2(h3d,anim,LinearObject)
namespace h3d{
namespace anim{


class HXCPP_CLASS_ATTRIBUTES  LinearAnimation_obj : public ::h3d::anim::Animation_obj{
	public:
		typedef ::h3d::anim::Animation_obj super;
		typedef LinearAnimation_obj OBJ_;
		LinearAnimation_obj();
		Void __construct(::String name,int frame,Float sampling);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< LinearAnimation_obj > __new(::String name,int frame,Float sampling);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~LinearAnimation_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("LinearAnimation"); }

		Float syncFrame;
		virtual Void addCurve( ::String objName,Array< ::Dynamic > frames,bool hasRot,bool hasScale);
		Dynamic addCurve_dyn();

		virtual Void addAlphaCurve( ::String objName,Array< Float > alphas);
		Dynamic addAlphaCurve_dyn();

		virtual Array< ::Dynamic > getFrames( );
		Dynamic getFrames_dyn();

		virtual Void initInstance( );

		virtual ::h3d::anim::Animation clone( ::h3d::anim::Animation a);

		virtual int endFrame( );

		virtual Void sync( hx::Null< bool >  decompose);

};

} // end namespace h3d
} // end namespace anim

#endif /* INCLUDED_h3d_anim_LinearAnimation */ 
