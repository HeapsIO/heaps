#ifndef INCLUDED_hxd_res_BytesFileSystem
#define INCLUDED_hxd_res_BytesFileSystem

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <hxd/res/FileSystem.h>
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(hxd,res,BytesFileSystem)
HX_DECLARE_CLASS2(hxd,res,FileEntry)
HX_DECLARE_CLASS2(hxd,res,FileSystem)
namespace hxd{
namespace res{


class HXCPP_CLASS_ATTRIBUTES  BytesFileSystem_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef BytesFileSystem_obj OBJ_;
		BytesFileSystem_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< BytesFileSystem_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~BytesFileSystem_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		inline operator ::hxd::res::FileSystem_obj *()
			{ return new ::hxd::res::FileSystem_delegate_< BytesFileSystem_obj >(this); }
		hx::Object *__ToInterface(const hx::type_info &inType);
		::String __ToString() const { return HX_CSTRING("BytesFileSystem"); }

		virtual ::hxd::res::FileEntry getRoot( );
		Dynamic getRoot_dyn();

		virtual ::haxe::io::Bytes getBytes( ::String path);
		Dynamic getBytes_dyn();

		virtual bool exists( ::String path);
		Dynamic exists_dyn();

		virtual ::hxd::res::FileEntry get( ::String path);
		Dynamic get_dyn();

};

} // end namespace hxd
} // end namespace res

#endif /* INCLUDED_hxd_res_BytesFileSystem */ 
