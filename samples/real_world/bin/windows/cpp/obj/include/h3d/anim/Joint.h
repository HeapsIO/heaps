#ifndef INCLUDED_h3d_anim_Joint
#define INCLUDED_h3d_anim_Joint

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(h3d,Matrix)
HX_DECLARE_CLASS2(h3d,anim,Joint)
namespace h3d{
namespace anim{


class HXCPP_CLASS_ATTRIBUTES  Joint_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Joint_obj OBJ_;
		Joint_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Joint_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Joint_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Joint"); }

		int index;
		::String name;
		int bindIndex;
		int splitIndex;
		::h3d::Matrix defMat;
		::h3d::Matrix transPos;
		::h3d::anim::Joint parent;
		Array< ::Dynamic > subs;
		virtual ::String toString( );
		Dynamic toString_dyn();

};

} // end namespace h3d
} // end namespace anim

#endif /* INCLUDED_h3d_anim_Joint */ 
