#ifndef INCLUDED_h3d_impl_UniformContext
#define INCLUDED_h3d_impl_UniformContext

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,impl,GLActiveInfo)
HX_DECLARE_CLASS2(h3d,impl,UniformContext)
namespace h3d{
namespace impl{


class HXCPP_CLASS_ATTRIBUTES  UniformContext_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef UniformContext_obj OBJ_;
		UniformContext_obj();
		Void __construct(int t,::h3d::impl::GLActiveInfo i);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< UniformContext_obj > __new(int t,::h3d::impl::GLActiveInfo i);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~UniformContext_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("UniformContext"); }

		int texIndex;
		::h3d::impl::GLActiveInfo inf;
};

} // end namespace h3d
} // end namespace impl

#endif /* INCLUDED_h3d_impl_UniformContext */ 
