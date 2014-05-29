#ifndef INCLUDED_h3d_anim_Animation
#define INCLUDED_h3d_anim_Animation

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,anim,AnimatedObject)
HX_DECLARE_CLASS2(h3d,anim,Animation)
HX_DECLARE_CLASS3(h3d,anim,_Animation,AnimWait)
HX_DECLARE_CLASS2(h3d,scene,Object)
namespace h3d{
namespace anim{


class HXCPP_CLASS_ATTRIBUTES  Animation_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Animation_obj OBJ_;
		Animation_obj();
		Void __construct(::String name,int frameCount,Float sampling);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Animation_obj > __new(::String name,int frameCount,Float sampling);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Animation_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Animation"); }

		::String name;
		int frameCount;
		int frameStart;
		int frameEnd;
		Float sampling;
		Float frame;
		Float speed;
		Dynamic onAnimEnd;
		Dynamic &onAnimEnd_dyn() { return onAnimEnd;}
		bool pause;
		bool loop;
		::h3d::anim::_Animation::AnimWait waits;
		bool isInstance;
		Array< ::Dynamic > objects;
		virtual Void setFrameAnimation( int start,int end);
		Dynamic setFrameAnimation_dyn();

		virtual Void waitForFrame( Float f,Dynamic callb);
		Dynamic waitForFrame_dyn();

		virtual Void clearWaits( );
		Dynamic clearWaits_dyn();

		virtual Void setFrame( Float f);
		Dynamic setFrame_dyn();

		virtual ::h3d::anim::Animation clone( ::h3d::anim::Animation a);
		Dynamic clone_dyn();

		virtual Void initInstance( );
		Dynamic initInstance_dyn();

		virtual ::h3d::anim::Animation createInstance( ::h3d::scene::Object base);
		Dynamic createInstance_dyn();

		virtual Void bind( ::h3d::scene::Object base);
		Dynamic bind_dyn();

		virtual Void sync( hx::Null< bool >  decompose);
		Dynamic sync_dyn();

		virtual bool isPlaying( );
		Dynamic isPlaying_dyn();

		virtual int endFrame( );
		Dynamic endFrame_dyn();

		virtual Float update( Float dt);
		Dynamic update_dyn();

		static Float EPSILON;
};

} // end namespace h3d
} // end namespace anim

#endif /* INCLUDED_h3d_anim_Animation */ 
