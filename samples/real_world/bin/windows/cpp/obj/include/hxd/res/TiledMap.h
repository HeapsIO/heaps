#ifndef INCLUDED_hxd_res_TiledMap
#define INCLUDED_hxd_res_TiledMap

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <hxd/res/Resource.h>
HX_DECLARE_CLASS2(hxd,res,FileEntry)
HX_DECLARE_CLASS2(hxd,res,Resource)
HX_DECLARE_CLASS2(hxd,res,TiledMap)
namespace hxd{
namespace res{


class HXCPP_CLASS_ATTRIBUTES  TiledMap_obj : public ::hxd::res::Resource_obj{
	public:
		typedef ::hxd::res::Resource_obj super;
		typedef TiledMap_obj OBJ_;
		TiledMap_obj();
		Void __construct(::hxd::res::FileEntry entry);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< TiledMap_obj > __new(::hxd::res::FileEntry entry);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~TiledMap_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("TiledMap"); }

		virtual Dynamic toMap( );
		Dynamic toMap_dyn();

};

} // end namespace hxd
} // end namespace res

#endif /* INCLUDED_hxd_res_TiledMap */ 
