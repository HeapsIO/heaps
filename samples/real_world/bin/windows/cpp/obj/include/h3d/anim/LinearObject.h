#ifndef INCLUDED_h3d_anim_LinearObject
#define INCLUDED_h3d_anim_LinearObject

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h3d/anim/AnimatedObject.h>
HX_DECLARE_CLASS1(h3d,Matrix)
HX_DECLARE_CLASS2(h3d,anim,AnimatedObject)
HX_DECLARE_CLASS2(h3d,anim,LinearFrame)
HX_DECLARE_CLASS2(h3d,anim,LinearObject)
namespace h3d{
namespace anim{


class HXCPP_CLASS_ATTRIBUTES  LinearObject_obj : public ::h3d::anim::AnimatedObject_obj{
	public:
		typedef ::h3d::anim::AnimatedObject_obj super;
		typedef LinearObject_obj OBJ_;
		LinearObject_obj();
		Void __construct(::String name);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< LinearObject_obj > __new(::String name);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~LinearObject_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("LinearObject"); }

		bool hasRotation;
		bool hasScale;
		Array< ::Dynamic > frames;
		Array< Float > alphas;
		::h3d::Matrix matrix;
		virtual ::h3d::anim::AnimatedObject clone( );

};

} // end namespace h3d
} // end namespace anim

#endif /* INCLUDED_h3d_anim_LinearObject */ 
