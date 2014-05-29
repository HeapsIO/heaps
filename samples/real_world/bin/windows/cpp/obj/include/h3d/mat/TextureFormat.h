#ifndef INCLUDED_h3d_mat_TextureFormat
#define INCLUDED_h3d_mat_TextureFormat

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,mat,TextureFormat)
namespace h3d{
namespace mat{


class TextureFormat_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef TextureFormat_obj OBJ_;

	public:
		TextureFormat_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("h3d.mat.TextureFormat"); }
		::String __ToString() const { return HX_CSTRING("TextureFormat.") + tag; }

		static ::h3d::mat::TextureFormat Atf;
		static inline ::h3d::mat::TextureFormat Atf_dyn() { return Atf; }
		static ::h3d::mat::TextureFormat AtfCompressed(bool alpha);
		static Dynamic AtfCompressed_dyn();
		static ::h3d::mat::TextureFormat Rgba;
		static inline ::h3d::mat::TextureFormat Rgba_dyn() { return Rgba; }
};

} // end namespace h3d
} // end namespace mat

#endif /* INCLUDED_h3d_mat_TextureFormat */ 
