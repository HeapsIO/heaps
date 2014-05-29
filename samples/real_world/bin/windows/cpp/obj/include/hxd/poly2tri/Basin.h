#ifndef INCLUDED_hxd_poly2tri_Basin
#define INCLUDED_hxd_poly2tri_Basin

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(hxd,poly2tri,Basin)
HX_DECLARE_CLASS2(hxd,poly2tri,Node)
namespace hxd{
namespace poly2tri{


class HXCPP_CLASS_ATTRIBUTES  Basin_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Basin_obj OBJ_;
		Basin_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Basin_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Basin_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Basin"); }

		::hxd::poly2tri::Node left_node;
		::hxd::poly2tri::Node bottom_node;
		::hxd::poly2tri::Node right_node;
		Float width;
		bool left_highest;
		virtual Void clear( );
		Dynamic clear_dyn();

};

} // end namespace hxd
} // end namespace poly2tri

#endif /* INCLUDED_hxd_poly2tri_Basin */ 
