#ifndef INCLUDED_h3d_impl_BufferOffset
#define INCLUDED_h3d_impl_BufferOffset

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,impl,Buffer)
HX_DECLARE_CLASS2(h3d,impl,BufferOffset)
namespace h3d{
namespace impl{


class HXCPP_CLASS_ATTRIBUTES  BufferOffset_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef BufferOffset_obj OBJ_;
		BufferOffset_obj();
		Void __construct(::h3d::impl::Buffer b,int offset,Dynamic __o_shared,Dynamic stride);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< BufferOffset_obj > __new(::h3d::impl::Buffer b,int offset,Dynamic __o_shared,Dynamic stride);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~BufferOffset_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("BufferOffset"); }

		::h3d::impl::Buffer b;
		int offset;
		bool shared;
		Dynamic stride;
		virtual Void dispose( );
		Dynamic dispose_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

};

} // end namespace h3d
} // end namespace impl

#endif /* INCLUDED_h3d_impl_BufferOffset */ 
