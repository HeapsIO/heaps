#ifndef INCLUDED_h3d_impl_ShaderType
#define INCLUDED_h3d_impl_ShaderType

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,impl,ShaderType)
namespace h3d{
namespace impl{


class ShaderType_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef ShaderType_obj OBJ_;

	public:
		ShaderType_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("h3d.impl.ShaderType"); }
		::String __ToString() const { return HX_CSTRING("ShaderType.") + tag; }

		static ::h3d::impl::ShaderType Byte3;
		static inline ::h3d::impl::ShaderType Byte3_dyn() { return Byte3; }
		static ::h3d::impl::ShaderType Byte4;
		static inline ::h3d::impl::ShaderType Byte4_dyn() { return Byte4; }
		static ::h3d::impl::ShaderType Elements(::String field,Dynamic size,::h3d::impl::ShaderType t);
		static Dynamic Elements_dyn();
		static ::h3d::impl::ShaderType _Float;
		static inline ::h3d::impl::ShaderType _Float_dyn() { return _Float; }
		static ::h3d::impl::ShaderType Index(int index,::h3d::impl::ShaderType t);
		static Dynamic Index_dyn();
		static ::h3d::impl::ShaderType Mat2;
		static inline ::h3d::impl::ShaderType Mat2_dyn() { return Mat2; }
		static ::h3d::impl::ShaderType Mat3;
		static inline ::h3d::impl::ShaderType Mat3_dyn() { return Mat3; }
		static ::h3d::impl::ShaderType Mat4;
		static inline ::h3d::impl::ShaderType Mat4_dyn() { return Mat4; }
		static ::h3d::impl::ShaderType Struct(::String field,::h3d::impl::ShaderType t);
		static Dynamic Struct_dyn();
		static ::h3d::impl::ShaderType Tex2d;
		static inline ::h3d::impl::ShaderType Tex2d_dyn() { return Tex2d; }
		static ::h3d::impl::ShaderType TexCube;
		static inline ::h3d::impl::ShaderType TexCube_dyn() { return TexCube; }
		static ::h3d::impl::ShaderType Vec2;
		static inline ::h3d::impl::ShaderType Vec2_dyn() { return Vec2; }
		static ::h3d::impl::ShaderType Vec3;
		static inline ::h3d::impl::ShaderType Vec3_dyn() { return Vec3; }
		static ::h3d::impl::ShaderType Vec4;
		static inline ::h3d::impl::ShaderType Vec4_dyn() { return Vec4; }
};

} // end namespace h3d
} // end namespace impl

#endif /* INCLUDED_h3d_impl_ShaderType */ 
