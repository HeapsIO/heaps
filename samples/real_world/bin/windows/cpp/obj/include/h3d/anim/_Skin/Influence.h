#ifndef INCLUDED_h3d_anim__Skin_Influence
#define INCLUDED_h3d_anim__Skin_Influence

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,anim,Joint)
HX_DECLARE_CLASS3(h3d,anim,_Skin,Influence)
namespace h3d{
namespace anim{
namespace _Skin{


class HXCPP_CLASS_ATTRIBUTES  Influence_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Influence_obj OBJ_;
		Influence_obj();
		Void __construct(::h3d::anim::Joint j,Float w);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Influence_obj > __new(::h3d::anim::Joint j,Float w);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Influence_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Influence"); }

		::h3d::anim::Joint j;
		Float w;
		virtual ::String toString( );
		Dynamic toString_dyn();

};

} // end namespace h3d
} // end namespace anim
} // end namespace _Skin

#endif /* INCLUDED_h3d_anim__Skin_Influence */ 
