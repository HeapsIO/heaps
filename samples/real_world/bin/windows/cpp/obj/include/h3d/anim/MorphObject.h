#ifndef INCLUDED_h3d_anim_MorphObject
#define INCLUDED_h3d_anim_MorphObject

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h3d/anim/AnimatedObject.h>
HX_DECLARE_CLASS2(h3d,anim,AnimatedObject)
HX_DECLARE_CLASS2(h3d,anim,MorphObject)
HX_DECLARE_CLASS2(h3d,prim,FBXModel)
HX_DECLARE_CLASS2(h3d,prim,MeshPrimitive)
HX_DECLARE_CLASS2(h3d,prim,Primitive)
namespace h3d{
namespace anim{


class HXCPP_CLASS_ATTRIBUTES  MorphObject_obj : public ::h3d::anim::AnimatedObject_obj{
	public:
		typedef ::h3d::anim::AnimatedObject_obj super;
		typedef MorphObject_obj OBJ_;
		MorphObject_obj();
		Void __construct(::String name);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< MorphObject_obj > __new(::String name);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~MorphObject_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("MorphObject"); }

		Array< ::Dynamic > ratio;
		::h3d::prim::FBXModel targetFbxPrim;
		Array< Float > workBuf;
		virtual ::h3d::anim::AnimatedObject clone( );

};

} // end namespace h3d
} // end namespace anim

#endif /* INCLUDED_h3d_anim_MorphObject */ 
