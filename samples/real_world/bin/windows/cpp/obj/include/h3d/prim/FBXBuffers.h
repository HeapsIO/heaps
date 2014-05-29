#ifndef INCLUDED_h3d_prim_FBXBuffers
#define INCLUDED_h3d_prim_FBXBuffers

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(IMap)
HX_DECLARE_CLASS2(h3d,col,Point)
HX_DECLARE_CLASS2(h3d,prim,FBXBuffers)
HX_DECLARE_CLASS2(haxe,ds,IntMap)
HX_DECLARE_CLASS2(haxe,io,BytesOutput)
HX_DECLARE_CLASS2(haxe,io,Output)
namespace h3d{
namespace prim{


class HXCPP_CLASS_ATTRIBUTES  FBXBuffers_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef FBXBuffers_obj OBJ_;
		FBXBuffers_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< FBXBuffers_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~FBXBuffers_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("FBXBuffers"); }

		Array< int > index;
		::h3d::col::Point gt;
		Array< int > idx;
		Array< ::Dynamic > midx;
		Array< Float > pbuf;
		Array< Float > nbuf;
		::haxe::io::BytesOutput sbuf;
		Array< Float > tbuf;
		Array< Float > cbuf;
		::haxe::ds::IntMap oldToNew;
		Array< Float > originalVerts;
};

} // end namespace h3d
} // end namespace prim

#endif /* INCLUDED_h3d_prim_FBXBuffers */ 
