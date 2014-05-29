#ifndef INCLUDED_h2d_Kerning
#define INCLUDED_h2d_Kerning

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(h2d,Kerning)
namespace h2d{


class HXCPP_CLASS_ATTRIBUTES  Kerning_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Kerning_obj OBJ_;
		Kerning_obj();
		Void __construct(int c,int o);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Kerning_obj > __new(int c,int o);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Kerning_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Kerning"); }

		int prevChar;
		int offset;
		::h2d::Kerning next;
};

} // end namespace h2d

#endif /* INCLUDED_h2d_Kerning */ 
