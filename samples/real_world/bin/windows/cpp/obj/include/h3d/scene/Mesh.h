#ifndef INCLUDED_h3d_scene_Mesh
#define INCLUDED_h3d_scene_Mesh

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h3d/scene/Object.h>
HX_DECLARE_CLASS2(h3d,col,Bounds)
HX_DECLARE_CLASS2(h3d,mat,Material)
HX_DECLARE_CLASS2(h3d,mat,MeshMaterial)
HX_DECLARE_CLASS2(h3d,prim,Primitive)
HX_DECLARE_CLASS2(h3d,scene,Mesh)
HX_DECLARE_CLASS2(h3d,scene,Object)
HX_DECLARE_CLASS2(h3d,scene,RenderContext)
namespace h3d{
namespace scene{


class HXCPP_CLASS_ATTRIBUTES  Mesh_obj : public ::h3d::scene::Object_obj{
	public:
		typedef ::h3d::scene::Object_obj super;
		typedef Mesh_obj OBJ_;
		Mesh_obj();
		Void __construct(::h3d::prim::Primitive prim,::h3d::mat::MeshMaterial mat,::h3d::scene::Object parent);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Mesh_obj > __new(::h3d::prim::Primitive prim,::h3d::mat::MeshMaterial mat,::h3d::scene::Object parent);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Mesh_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Mesh"); }

		::h3d::prim::Primitive primitive;
		::h3d::mat::MeshMaterial material;
		virtual ::h3d::col::Bounds getBounds( ::h3d::col::Bounds b);

		virtual ::h3d::scene::Object clone( ::h3d::scene::Object o);

		virtual Void draw( ::h3d::scene::RenderContext ctx);

		virtual Void dispose( );

};

} // end namespace h3d
} // end namespace scene

#endif /* INCLUDED_h3d_scene_Mesh */ 
