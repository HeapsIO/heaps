#ifndef INCLUDED_h3d_anim__Animation_AnimWait
#define INCLUDED_h3d_anim__Animation_AnimWait

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS3(h3d,anim,_Animation,AnimWait)
namespace h3d{
namespace anim{
namespace _Animation{


class HXCPP_CLASS_ATTRIBUTES  AnimWait_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef AnimWait_obj OBJ_;
		AnimWait_obj();
		Void __construct(Float f,Dynamic c,::h3d::anim::_Animation::AnimWait n);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< AnimWait_obj > __new(Float f,Dynamic c,::h3d::anim::_Animation::AnimWait n);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~AnimWait_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("AnimWait"); }

		Float frame;
		Dynamic callb;
		Dynamic &callb_dyn() { return callb;}
		::h3d::anim::_Animation::AnimWait next;
};

} // end namespace h3d
} // end namespace anim
} // end namespace _Animation

#endif /* INCLUDED_h3d_anim__Animation_AnimWait */ 
