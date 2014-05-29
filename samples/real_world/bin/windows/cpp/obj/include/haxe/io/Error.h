#ifndef INCLUDED_haxe_io_Error
#define INCLUDED_haxe_io_Error

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(haxe,io,Error)
namespace haxe{
namespace io{


class Error_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef Error_obj OBJ_;

	public:
		Error_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("haxe.io.Error"); }
		::String __ToString() const { return HX_CSTRING("Error.") + tag; }

		static ::haxe::io::Error Blocked;
		static inline ::haxe::io::Error Blocked_dyn() { return Blocked; }
		static ::haxe::io::Error Custom(Dynamic e);
		static Dynamic Custom_dyn();
		static ::haxe::io::Error OutsideBounds;
		static inline ::haxe::io::Error OutsideBounds_dyn() { return OutsideBounds; }
		static ::haxe::io::Error Overflow;
		static inline ::haxe::io::Error Overflow_dyn() { return Overflow; }
};

} // end namespace haxe
} // end namespace io

#endif /* INCLUDED_haxe_io_Error */ 
