#ifndef INCLUDED_h3d_mat_Blend
#define INCLUDED_h3d_mat_Blend

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,mat,Blend)
namespace h3d{
namespace mat{


class Blend_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef Blend_obj OBJ_;

	public:
		Blend_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("h3d.mat.Blend"); }
		::String __ToString() const { return HX_CSTRING("Blend.") + tag; }

		static ::h3d::mat::Blend ConstantAlpha;
		static inline ::h3d::mat::Blend ConstantAlpha_dyn() { return ConstantAlpha; }
		static ::h3d::mat::Blend ConstantColor;
		static inline ::h3d::mat::Blend ConstantColor_dyn() { return ConstantColor; }
		static ::h3d::mat::Blend DstAlpha;
		static inline ::h3d::mat::Blend DstAlpha_dyn() { return DstAlpha; }
		static ::h3d::mat::Blend DstColor;
		static inline ::h3d::mat::Blend DstColor_dyn() { return DstColor; }
		static ::h3d::mat::Blend One;
		static inline ::h3d::mat::Blend One_dyn() { return One; }
		static ::h3d::mat::Blend OneMinusConstantAlpha;
		static inline ::h3d::mat::Blend OneMinusConstantAlpha_dyn() { return OneMinusConstantAlpha; }
		static ::h3d::mat::Blend OneMinusConstantColor;
		static inline ::h3d::mat::Blend OneMinusConstantColor_dyn() { return OneMinusConstantColor; }
		static ::h3d::mat::Blend OneMinusDstAlpha;
		static inline ::h3d::mat::Blend OneMinusDstAlpha_dyn() { return OneMinusDstAlpha; }
		static ::h3d::mat::Blend OneMinusDstColor;
		static inline ::h3d::mat::Blend OneMinusDstColor_dyn() { return OneMinusDstColor; }
		static ::h3d::mat::Blend OneMinusSrcAlpha;
		static inline ::h3d::mat::Blend OneMinusSrcAlpha_dyn() { return OneMinusSrcAlpha; }
		static ::h3d::mat::Blend OneMinusSrcColor;
		static inline ::h3d::mat::Blend OneMinusSrcColor_dyn() { return OneMinusSrcColor; }
		static ::h3d::mat::Blend SrcAlpha;
		static inline ::h3d::mat::Blend SrcAlpha_dyn() { return SrcAlpha; }
		static ::h3d::mat::Blend SrcAlphaSaturate;
		static inline ::h3d::mat::Blend SrcAlphaSaturate_dyn() { return SrcAlphaSaturate; }
		static ::h3d::mat::Blend SrcColor;
		static inline ::h3d::mat::Blend SrcColor_dyn() { return SrcColor; }
		static ::h3d::mat::Blend Zero;
		static inline ::h3d::mat::Blend Zero_dyn() { return Zero; }
};

} // end namespace h3d
} // end namespace mat

#endif /* INCLUDED_h3d_mat_Blend */ 
