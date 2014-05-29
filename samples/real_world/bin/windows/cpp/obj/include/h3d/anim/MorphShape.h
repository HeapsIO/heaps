#ifndef INCLUDED_h3d_anim_MorphShape
#define INCLUDED_h3d_anim_MorphShape

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,anim,MorphShape)
namespace h3d{
namespace anim{


class HXCPP_CLASS_ATTRIBUTES  MorphShape_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef MorphShape_obj OBJ_;
		MorphShape_obj();
		Void __construct(Array< int > i,Array< Float > v,Array< Float > n);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< MorphShape_obj > __new(Array< int > i,Array< Float > v,Array< Float > n);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~MorphShape_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("MorphShape"); }

		Array< int > index;
		Array< Float > vertex;
		Array< Float > normal;
};

} // end namespace h3d
} // end namespace anim

#endif /* INCLUDED_h3d_anim_MorphShape */ 
