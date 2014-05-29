#ifndef INCLUDED_sys_io_FileSeek
#define INCLUDED_sys_io_FileSeek

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(sys,io,FileSeek)
namespace sys{
namespace io{


class FileSeek_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef FileSeek_obj OBJ_;

	public:
		FileSeek_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("sys.io.FileSeek"); }
		::String __ToString() const { return HX_CSTRING("FileSeek.") + tag; }

		static ::sys::io::FileSeek SeekBegin;
		static inline ::sys::io::FileSeek SeekBegin_dyn() { return SeekBegin; }
		static ::sys::io::FileSeek SeekCur;
		static inline ::sys::io::FileSeek SeekCur_dyn() { return SeekCur; }
		static ::sys::io::FileSeek SeekEnd;
		static inline ::sys::io::FileSeek SeekEnd_dyn() { return SeekEnd; }
};

} // end namespace sys
} // end namespace io

#endif /* INCLUDED_sys_io_FileSeek */ 
