#ifndef INCLUDED_hxd_impl_ArrayIterator
#define INCLUDED_hxd_impl_ArrayIterator

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(hxd,impl,ArrayIterator)
namespace hxd{
namespace impl{


class HXCPP_CLASS_ATTRIBUTES  ArrayIterator_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef ArrayIterator_obj OBJ_;
		ArrayIterator_obj();
		Void __construct(Dynamic a);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< ArrayIterator_obj > __new(Dynamic a);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~ArrayIterator_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("ArrayIterator"); }

		int i;
		int l;
		Dynamic a;
		virtual bool hasNext( );
		Dynamic hasNext_dyn();

		virtual Dynamic next( );
		Dynamic next_dyn();

};

} // end namespace hxd
} // end namespace impl

#endif /* INCLUDED_hxd_impl_ArrayIterator */ 
