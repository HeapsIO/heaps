#ifndef INCLUDED_hxd_ArrayTools
#define INCLUDED_hxd_ArrayTools

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(hxd,ArrayTools)
namespace hxd{


class HXCPP_CLASS_ATTRIBUTES  ArrayTools_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef ArrayTools_obj OBJ_;
		ArrayTools_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< ArrayTools_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~ArrayTools_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("ArrayTools"); }

		static Void zeroF( Array< Float > t);
		static Dynamic zeroF_dyn();

		static Void zeroI( Array< int > t);
		static Dynamic zeroI_dyn();

		static Void zeroNull( Dynamic t);
		static Dynamic zeroNull_dyn();

		static Void blit( Array< Float > d,Dynamic dstPos,Array< Float > src,Dynamic srcPos,Dynamic nb);
		static Dynamic blit_dyn();

};

} // end namespace hxd

#endif /* INCLUDED_hxd_ArrayTools */ 
