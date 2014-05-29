#ifndef INCLUDED_h3d_impl_Buffer
#define INCLUDED_h3d_impl_Buffer

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,impl,BigBuffer)
HX_DECLARE_CLASS2(h3d,impl,Buffer)
HX_DECLARE_CLASS2(haxe,io,Bytes)
namespace h3d{
namespace impl{


class HXCPP_CLASS_ATTRIBUTES  Buffer_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Buffer_obj OBJ_;
		Buffer_obj();
		Void __construct(::h3d::impl::BigBuffer b,int pos,int nvert);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Buffer_obj > __new(::h3d::impl::BigBuffer b,int pos,int nvert);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Buffer_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Buffer"); }

		int id;
		::h3d::impl::BigBuffer b;
		int pos;
		int nvert;
		::h3d::impl::Buffer next;
		Dynamic allocPos;
		::h3d::impl::Buffer allocNext;
		::h3d::impl::Buffer allocPrev;
		virtual ::String toString( );
		Dynamic toString_dyn();

		virtual bool isDisposed( );
		Dynamic isDisposed_dyn();

		virtual int getDepth( );
		Dynamic getDepth_dyn();

		virtual Void dispose( );
		Dynamic dispose_dyn();

		virtual Void uploadVector( Array< Float > data,int dataPos,int nverts);
		Dynamic uploadVector_dyn();

		virtual Void uploadBytes( ::haxe::io::Bytes data,int dataPos,int nverts);
		Dynamic uploadBytes_dyn();

		static int GUID;
};

} // end namespace h3d
} // end namespace impl

#endif /* INCLUDED_h3d_impl_Buffer */ 
