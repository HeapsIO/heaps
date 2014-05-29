#ifndef INCLUDED_hxd_res_Model
#define INCLUDED_hxd_res_Model

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <hxd/res/Resource.h>
HX_DECLARE_CLASS2(h3d,fbx,Library)
HX_DECLARE_CLASS2(hxd,res,FileEntry)
HX_DECLARE_CLASS2(hxd,res,Model)
HX_DECLARE_CLASS2(hxd,res,Resource)
namespace hxd{
namespace res{


class HXCPP_CLASS_ATTRIBUTES  Model_obj : public ::hxd::res::Resource_obj{
	public:
		typedef ::hxd::res::Resource_obj super;
		typedef Model_obj OBJ_;
		Model_obj();
		Void __construct(::hxd::res::FileEntry entry);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Model_obj > __new(::hxd::res::FileEntry entry);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Model_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Model"); }

		virtual ::h3d::fbx::Library toFbx( );
		Dynamic toFbx_dyn();

		static bool isLeftHanded;
};

} // end namespace hxd
} // end namespace res

#endif /* INCLUDED_hxd_res_Model */ 
