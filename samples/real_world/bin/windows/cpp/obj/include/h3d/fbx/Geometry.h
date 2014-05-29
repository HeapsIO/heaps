#ifndef INCLUDED_h3d_fbx_Geometry
#define INCLUDED_h3d_fbx_Geometry

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,col,Point)
HX_DECLARE_CLASS2(h3d,fbx,FbxNode)
HX_DECLARE_CLASS2(h3d,fbx,Geometry)
HX_DECLARE_CLASS2(h3d,fbx,Library)
namespace h3d{
namespace fbx{


class HXCPP_CLASS_ATTRIBUTES  Geometry_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Geometry_obj OBJ_;
		Geometry_obj();
		Void __construct(::h3d::fbx::Library l,::h3d::fbx::FbxNode root);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Geometry_obj > __new(::h3d::fbx::Library l,::h3d::fbx::FbxNode root);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Geometry_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Geometry"); }

		::h3d::fbx::Library lib;
		::h3d::fbx::FbxNode root;
		virtual Array< Float > getVertices( );
		Dynamic getVertices_dyn();

		virtual Array< int > getPolygons( );
		Dynamic getPolygons_dyn();

		virtual Array< int > getMaterials( );
		Dynamic getMaterials_dyn();

		virtual Array< int > getShapeIndexes( );
		Dynamic getShapeIndexes_dyn();

		virtual Dynamic getIndexes( );
		Dynamic getIndexes_dyn();

		virtual Array< Float > getNormals( );
		Dynamic getNormals_dyn();

		virtual Array< Float > getShapeNormals( );
		Dynamic getShapeNormals_dyn();

		virtual Dynamic getColors( );
		Dynamic getColors_dyn();

		virtual Dynamic getUVs( );
		Dynamic getUVs_dyn();

		virtual ::h3d::col::Point getGeomTranslate( );
		Dynamic getGeomTranslate_dyn();

};

} // end namespace h3d
} // end namespace fbx

#endif /* INCLUDED_h3d_fbx_Geometry */ 
