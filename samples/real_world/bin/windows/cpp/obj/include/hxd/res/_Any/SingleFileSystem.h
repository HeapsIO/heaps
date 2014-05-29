#ifndef INCLUDED_hxd_res__Any_SingleFileSystem
#define INCLUDED_hxd_res__Any_SingleFileSystem

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <hxd/res/BytesFileSystem.h>
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(hxd,res,BytesFileSystem)
HX_DECLARE_CLASS2(hxd,res,FileSystem)
HX_DECLARE_CLASS3(hxd,res,_Any,SingleFileSystem)
namespace hxd{
namespace res{
namespace _Any{


class HXCPP_CLASS_ATTRIBUTES  SingleFileSystem_obj : public ::hxd::res::BytesFileSystem_obj{
	public:
		typedef ::hxd::res::BytesFileSystem_obj super;
		typedef SingleFileSystem_obj OBJ_;
		SingleFileSystem_obj();
		Void __construct(::String path,::haxe::io::Bytes bytes);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< SingleFileSystem_obj > __new(::String path,::haxe::io::Bytes bytes);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~SingleFileSystem_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("SingleFileSystem"); }

		::String path;
		::haxe::io::Bytes bytes;
		virtual ::haxe::io::Bytes getBytes( ::String p);

};

} // end namespace hxd
} // end namespace res
} // end namespace _Any

#endif /* INCLUDED_hxd_res__Any_SingleFileSystem */ 
