#ifndef INCLUDED_h2d__Graphics_LinePoint
#define INCLUDED_h2d__Graphics_LinePoint

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h2d,_Graphics,LinePoint)
namespace h2d{
namespace _Graphics{


class HXCPP_CLASS_ATTRIBUTES  LinePoint_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef LinePoint_obj OBJ_;
		LinePoint_obj();
		Void __construct(Float x,Float y,Float r,Float g,Float b,Float a);

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< LinePoint_obj > __new(Float x,Float y,Float r,Float g,Float b,Float a);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~LinePoint_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("LinePoint"); }

		Float x;
		Float y;
		Float r;
		Float g;
		Float b;
		Float a;
};

} // end namespace h2d
} // end namespace _Graphics

#endif /* INCLUDED_h2d__Graphics_LinePoint */ 
