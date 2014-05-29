#ifndef INCLUDED_h3d_anim_AnimatedObject
#define INCLUDED_h3d_anim_AnimatedObject

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,anim,AnimatedObject)
HX_DECLARE_CLASS2(h3d,scene,Mesh)
HX_DECLARE_CLASS2(h3d,scene,Object)
HX_DECLARE_CLASS2(h3d,scene,Skin)
namespace h3d{
namespace anim{


class HXCPP_CLASS_ATTRIBUTES  AnimatedObject_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef AnimatedObject_obj OBJ_;
		AnimatedObject_obj();
		Void __construct(::String name);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< AnimatedObject_obj > __new(::String name);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~AnimatedObject_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("AnimatedObject"); }

		::String objectName;
		::h3d::scene::Object targetObject;
		::h3d::scene::Skin targetSkin;
		int targetJoint;
		virtual ::h3d::anim::AnimatedObject clone( );
		Dynamic clone_dyn();

};

} // end namespace h3d
} // end namespace anim

#endif /* INCLUDED_h3d_anim_AnimatedObject */ 
