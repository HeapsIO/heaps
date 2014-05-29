#ifndef INCLUDED_flash_utils_CompressionAlgorithm
#define INCLUDED_flash_utils_CompressionAlgorithm

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,utils,CompressionAlgorithm)
namespace flash{
namespace utils{


class CompressionAlgorithm_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef CompressionAlgorithm_obj OBJ_;

	public:
		CompressionAlgorithm_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.utils.CompressionAlgorithm"); }
		::String __ToString() const { return HX_CSTRING("CompressionAlgorithm.") + tag; }

		static ::flash::utils::CompressionAlgorithm DEFLATE;
		static inline ::flash::utils::CompressionAlgorithm DEFLATE_dyn() { return DEFLATE; }
		static ::flash::utils::CompressionAlgorithm GZIP;
		static inline ::flash::utils::CompressionAlgorithm GZIP_dyn() { return GZIP; }
		static ::flash::utils::CompressionAlgorithm LZMA;
		static inline ::flash::utils::CompressionAlgorithm LZMA_dyn() { return LZMA; }
		static ::flash::utils::CompressionAlgorithm ZLIB;
		static inline ::flash::utils::CompressionAlgorithm ZLIB_dyn() { return ZLIB; }
};

} // end namespace flash
} // end namespace utils

#endif /* INCLUDED_flash_utils_CompressionAlgorithm */ 
