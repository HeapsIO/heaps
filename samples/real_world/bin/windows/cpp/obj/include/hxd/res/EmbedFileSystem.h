#ifndef INCLUDED_hxd_res_EmbedFileSystem
#define INCLUDED_hxd_res_EmbedFileSystem

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <hxd/res/FileSystem.h>
HX_DECLARE_CLASS0(EReg)
HX_DECLARE_CLASS2(hxd,res,EmbedFileSystem)
HX_DECLARE_CLASS2(hxd,res,FileEntry)
HX_DECLARE_CLASS2(hxd,res,FileSystem)
namespace hxd{
namespace res{


class HXCPP_CLASS_ATTRIBUTES  EmbedFileSystem_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef EmbedFileSystem_obj OBJ_;
		EmbedFileSystem_obj();
		Void __construct(Dynamic root);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< EmbedFileSystem_obj > __new(Dynamic root);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~EmbedFileSystem_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		inline operator ::hxd::res::FileSystem_obj *()
			{ return new ::hxd::res::FileSystem_delegate_< EmbedFileSystem_obj >(this); }
		hx::Object *__ToInterface(const hx::type_info &inType);
		::String __ToString() const { return HX_CSTRING("EmbedFileSystem"); }

		Dynamic root;
		virtual ::hxd::res::FileEntry getRoot( );
		Dynamic getRoot_dyn();

		virtual Array< ::Dynamic > subFiles( ::String path);
		Dynamic subFiles_dyn();

		virtual bool isDirectory( ::String path);
		Dynamic isDirectory_dyn();

		virtual bool exists( ::String path);
		Dynamic exists_dyn();

		virtual ::hxd::res::FileEntry get( ::String path);
		Dynamic get_dyn();

		static ::EReg invalidChars;
		static ::String resolve( ::String path);
		static Dynamic resolve_dyn();

};

} // end namespace hxd
} // end namespace res

#endif /* INCLUDED_hxd_res_EmbedFileSystem */ 
