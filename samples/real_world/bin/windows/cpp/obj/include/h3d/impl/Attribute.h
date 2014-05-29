#ifndef INCLUDED_h3d_impl_Attribute
#define INCLUDED_h3d_impl_Attribute

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,impl,Attribute)
HX_DECLARE_CLASS2(h3d,impl,ShaderType)
namespace h3d{
namespace impl{


class HXCPP_CLASS_ATTRIBUTES  Attribute_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Attribute_obj OBJ_;
		Attribute_obj();
		Void __construct(::String n,::h3d::impl::ShaderType t,int e,int o,int i,int s);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Attribute_obj > __new(::String n,::h3d::impl::ShaderType t,int e,int o,int i,int s);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Attribute_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Attribute"); }

		int etype;
		int offset;
		int index;
		int size;
		::String name;
		::h3d::impl::ShaderType type;
		virtual ::String toString( );
		Dynamic toString_dyn();

};

} // end namespace h3d
} // end namespace impl

#endif /* INCLUDED_h3d_impl_Attribute */ 
