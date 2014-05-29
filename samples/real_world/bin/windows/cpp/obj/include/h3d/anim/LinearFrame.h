#ifndef INCLUDED_h3d_anim_LinearFrame
#define INCLUDED_h3d_anim_LinearFrame

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,anim,LinearFrame)
namespace h3d{
namespace anim{


class HXCPP_CLASS_ATTRIBUTES  LinearFrame_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef LinearFrame_obj OBJ_;
		LinearFrame_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< LinearFrame_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~LinearFrame_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("LinearFrame"); }

		Float tx;
		Float ty;
		Float tz;
		Float qx;
		Float qy;
		Float qz;
		Float qw;
		Float sx;
		Float sy;
		Float sz;
};

} // end namespace h3d
} // end namespace anim

#endif /* INCLUDED_h3d_anim_LinearFrame */ 
