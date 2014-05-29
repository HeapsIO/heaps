#ifndef INCLUDED_h3d_impl_Uniform
#define INCLUDED_h3d_impl_Uniform

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,impl,ShaderType)
HX_DECLARE_CLASS2(h3d,impl,Uniform)
namespace h3d{
namespace impl{


class HXCPP_CLASS_ATTRIBUTES  Uniform_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Uniform_obj OBJ_;
		Uniform_obj();
		Void __construct(::String n,Dynamic l,::h3d::impl::ShaderType t,int i);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Uniform_obj > __new(::String n,Dynamic l,::h3d::impl::ShaderType t,int i);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Uniform_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Uniform"); }

		::String name;
		Dynamic loc;
		::h3d::impl::ShaderType type;
		int index;
};

} // end namespace h3d
} // end namespace impl

#endif /* INCLUDED_h3d_impl_Uniform */ 
