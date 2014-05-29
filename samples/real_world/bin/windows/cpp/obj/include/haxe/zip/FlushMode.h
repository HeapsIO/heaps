#ifndef INCLUDED_haxe_zip_FlushMode
#define INCLUDED_haxe_zip_FlushMode

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(haxe,zip,FlushMode)
namespace haxe{
namespace zip{


class FlushMode_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef FlushMode_obj OBJ_;

	public:
		FlushMode_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("haxe.zip.FlushMode"); }
		::String __ToString() const { return HX_CSTRING("FlushMode.") + tag; }

		static ::haxe::zip::FlushMode BLOCK;
		static inline ::haxe::zip::FlushMode BLOCK_dyn() { return BLOCK; }
		static ::haxe::zip::FlushMode FINISH;
		static inline ::haxe::zip::FlushMode FINISH_dyn() { return FINISH; }
		static ::haxe::zip::FlushMode FULL;
		static inline ::haxe::zip::FlushMode FULL_dyn() { return FULL; }
		static ::haxe::zip::FlushMode NO;
		static inline ::haxe::zip::FlushMode NO_dyn() { return NO; }
		static ::haxe::zip::FlushMode SYNC;
		static inline ::haxe::zip::FlushMode SYNC_dyn() { return SYNC; }
};

} // end namespace haxe
} // end namespace zip

#endif /* INCLUDED_haxe_zip_FlushMode */ 
