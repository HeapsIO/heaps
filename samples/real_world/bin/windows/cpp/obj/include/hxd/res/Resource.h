#ifndef INCLUDED_hxd_res_Resource
#define INCLUDED_hxd_res_Resource

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(hxd,res,FileEntry)
HX_DECLARE_CLASS2(hxd,res,Resource)
namespace hxd{
namespace res{


class HXCPP_CLASS_ATTRIBUTES  Resource_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Resource_obj OBJ_;
		Resource_obj();
		Void __construct(::hxd::res::FileEntry entry);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Resource_obj > __new(::hxd::res::FileEntry entry);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Resource_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Resource"); }

		::hxd::res::FileEntry entry;
		virtual ::String get_name( );
		Dynamic get_name_dyn();

};

} // end namespace hxd
} // end namespace res

#endif /* INCLUDED_hxd_res_Resource */ 
