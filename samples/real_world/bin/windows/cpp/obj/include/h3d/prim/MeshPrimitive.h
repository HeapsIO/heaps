#ifndef INCLUDED_h3d_prim_MeshPrimitive
#define INCLUDED_h3d_prim_MeshPrimitive

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h3d/prim/Primitive.h>
HX_DECLARE_CLASS0(IMap)
HX_DECLARE_CLASS1(h3d,Engine)
HX_DECLARE_CLASS2(h3d,impl,Buffer)
HX_DECLARE_CLASS2(h3d,impl,BufferOffset)
HX_DECLARE_CLASS2(h3d,prim,MeshPrimitive)
HX_DECLARE_CLASS2(h3d,prim,Primitive)
HX_DECLARE_CLASS2(haxe,ds,StringMap)
namespace h3d{
namespace prim{


class HXCPP_CLASS_ATTRIBUTES  MeshPrimitive_obj : public ::h3d::prim::Primitive_obj{
	public:
		typedef ::h3d::prim::Primitive_obj super;
		typedef MeshPrimitive_obj OBJ_;
		MeshPrimitive_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< MeshPrimitive_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~MeshPrimitive_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("MeshPrimitive"); }

		::haxe::ds::StringMap bufferCache;
		virtual ::h3d::impl::BufferOffset allocBuffer( ::h3d::Engine engine,::String name);
		Dynamic allocBuffer_dyn();

		virtual ::h3d::impl::BufferOffset getBuffer( ::String name);
		Dynamic getBuffer_dyn();

		virtual ::h3d::impl::BufferOffset addBuffer( ::String name,::h3d::impl::Buffer buf,hx::Null< int >  offset,hx::Null< bool >  shared,Dynamic stride);
		Dynamic addBuffer_dyn();

		virtual Void dispose( );

		virtual Array< ::Dynamic > getBuffers( ::h3d::Engine engine);
		Dynamic getBuffers_dyn();

		virtual Void render( ::h3d::Engine engine);

		static int hash( ::String name);
		static Dynamic hash_dyn();

};

} // end namespace h3d
} // end namespace prim

#endif /* INCLUDED_h3d_prim_MeshPrimitive */ 
