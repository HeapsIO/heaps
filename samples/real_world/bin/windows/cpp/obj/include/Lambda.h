#ifndef INCLUDED_Lambda
#define INCLUDED_Lambda

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(Lambda)
HX_DECLARE_CLASS0(List)


class HXCPP_CLASS_ATTRIBUTES  Lambda_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Lambda_obj OBJ_;
		Lambda_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Lambda_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Lambda_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Lambda"); }

		static Dynamic array( Dynamic it);
		static Dynamic array_dyn();

		static ::List list( Dynamic it);
		static Dynamic list_dyn();

		static ::List map( Dynamic it,Dynamic f);
		static Dynamic map_dyn();

		static ::List mapi( Dynamic it,Dynamic f);
		static Dynamic mapi_dyn();

		static bool has( Dynamic it,Dynamic elt);
		static Dynamic has_dyn();

		static bool exists( Dynamic it,Dynamic f);
		static Dynamic exists_dyn();

		static bool foreach( Dynamic it,Dynamic f);
		static Dynamic foreach_dyn();

		static Void iter( Dynamic it,Dynamic f);
		static Dynamic iter_dyn();

		static ::List filter( Dynamic it,Dynamic f);
		static Dynamic filter_dyn();

		static Dynamic fold( Dynamic it,Dynamic f,Dynamic first);
		static Dynamic fold_dyn();

		static int count( Dynamic it,Dynamic pred);
		static Dynamic count_dyn();

		static bool empty( Dynamic it);
		static Dynamic empty_dyn();

		static int indexOf( Dynamic it,Dynamic v);
		static Dynamic indexOf_dyn();

		static Dynamic find( Dynamic it,Dynamic f);
		static Dynamic find_dyn();

		static ::List concat( Dynamic a,Dynamic b);
		static Dynamic concat_dyn();

};


#endif /* INCLUDED_Lambda */ 
