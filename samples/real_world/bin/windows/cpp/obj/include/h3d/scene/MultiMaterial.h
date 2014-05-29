#ifndef INCLUDED_h3d_scene_MultiMaterial
#define INCLUDED_h3d_scene_MultiMaterial

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h3d/scene/Mesh.h>
HX_DECLARE_CLASS2(h3d,mat,Material)
HX_DECLARE_CLASS2(h3d,mat,MeshMaterial)
HX_DECLARE_CLASS2(h3d,prim,Primitive)
HX_DECLARE_CLASS2(h3d,scene,Mesh)
HX_DECLARE_CLASS2(h3d,scene,MultiMaterial)
HX_DECLARE_CLASS2(h3d,scene,Object)
HX_DECLARE_CLASS2(h3d,scene,RenderContext)
namespace h3d{
namespace scene{


class HXCPP_CLASS_ATTRIBUTES  MultiMaterial_obj : public ::h3d::scene::Mesh_obj{
	public:
		typedef ::h3d::scene::Mesh_obj super;
		typedef MultiMaterial_obj OBJ_;
		MultiMaterial_obj();
		Void __construct(::h3d::prim::Primitive prim,Array< ::Dynamic > mats,::h3d::scene::Object parent);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< MultiMaterial_obj > __new(::h3d::prim::Primitive prim,Array< ::Dynamic > mats,::h3d::scene::Object parent);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~MultiMaterial_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("MultiMaterial"); }

		Array< ::Dynamic > materials;
		virtual ::h3d::scene::Object clone( ::h3d::scene::Object o);

		virtual Void drawMaterial( ::h3d::scene::RenderContext ctx,int mid);
		Dynamic drawMaterial_dyn();

		virtual Void draw( ::h3d::scene::RenderContext ctx);

};

} // end namespace h3d
} // end namespace scene

#endif /* INCLUDED_h3d_scene_MultiMaterial */ 
