#ifndef INCLUDED_h3d_impl_FreeCell
#define INCLUDED_h3d_impl_FreeCell

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,impl,FreeCell)
namespace h3d{
namespace impl{


class HXCPP_CLASS_ATTRIBUTES  FreeCell_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef FreeCell_obj OBJ_;
		FreeCell_obj();
		Void __construct(int pos,int count,::h3d::impl::FreeCell next);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< FreeCell_obj > __new(int pos,int count,::h3d::impl::FreeCell next);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~FreeCell_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("FreeCell"); }

		int pos;
		int count;
		::h3d::impl::FreeCell next;
};

} // end namespace h3d
} // end namespace impl

#endif /* INCLUDED_h3d_impl_FreeCell */ 
