#ifndef INCLUDED_h3d_impl_BigBufferFlag
#define INCLUDED_h3d_impl_BigBufferFlag

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,impl,BigBufferFlag)
namespace h3d{
namespace impl{


class BigBufferFlag_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef BigBufferFlag_obj OBJ_;

	public:
		BigBufferFlag_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("h3d.impl.BigBufferFlag"); }
		::String __ToString() const { return HX_CSTRING("BigBufferFlag.") + tag; }

		static ::h3d::impl::BigBufferFlag BBF_DYNAMIC;
		static inline ::h3d::impl::BigBufferFlag BBF_DYNAMIC_dyn() { return BBF_DYNAMIC; }
};

} // end namespace h3d
} // end namespace impl

#endif /* INCLUDED_h3d_impl_BigBufferFlag */ 
