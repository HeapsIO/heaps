#ifndef INCLUDED_hxd_res_FileSystem
#define INCLUDED_hxd_res_FileSystem

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(hxd,res,FileEntry)
HX_DECLARE_CLASS2(hxd,res,FileSystem)
namespace hxd{
namespace res{


class HXCPP_CLASS_ATTRIBUTES  FileSystem_obj : public hx::Interface{
	public:
		typedef hx::Interface super;
		typedef FileSystem_obj OBJ_;
		HX_DO_INTERFACE_RTTI;
		static void __boot();
virtual ::hxd::res::FileEntry getRoot( )=0;
		Dynamic getRoot_dyn();
virtual ::hxd::res::FileEntry get( ::String path)=0;
		Dynamic get_dyn();
virtual bool exists( ::String path)=0;
		Dynamic exists_dyn();
};

#define DELEGATE_hxd_res_FileSystem \
virtual ::hxd::res::FileEntry getRoot( ) { return mDelegate->getRoot();}  \
virtual Dynamic getRoot_dyn() { return mDelegate->getRoot_dyn();}  \
virtual ::hxd::res::FileEntry get( ::String path) { return mDelegate->get(path);}  \
virtual Dynamic get_dyn() { return mDelegate->get_dyn();}  \
virtual bool exists( ::String path) { return mDelegate->exists(path);}  \
virtual Dynamic exists_dyn() { return mDelegate->exists_dyn();}  \


template<typename IMPL>
class FileSystem_delegate_ : public FileSystem_obj
{
	protected:
		IMPL *mDelegate;
	public:
		FileSystem_delegate_(IMPL *inDelegate) : mDelegate(inDelegate) {}
		hx::Object *__GetRealObject() { return mDelegate; }
		void __Visit(HX_VISIT_PARAMS) { HX_VISIT_OBJECT(mDelegate); }
		DELEGATE_hxd_res_FileSystem
};

} // end namespace hxd
} // end namespace res

#endif /* INCLUDED_hxd_res_FileSystem */ 
