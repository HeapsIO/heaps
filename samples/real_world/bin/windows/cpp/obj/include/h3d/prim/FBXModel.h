#ifndef INCLUDED_h3d_prim_FBXModel
#define INCLUDED_h3d_prim_FBXModel

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h3d/prim/MeshPrimitive.h>
HX_DECLARE_CLASS1(h3d,Engine)
HX_DECLARE_CLASS2(h3d,anim,Skin)
HX_DECLARE_CLASS2(h3d,col,Bounds)
HX_DECLARE_CLASS2(h3d,fbx,Geometry)
HX_DECLARE_CLASS2(h3d,impl,Indexes)
HX_DECLARE_CLASS2(h3d,prim,FBXBuffers)
HX_DECLARE_CLASS2(h3d,prim,FBXModel)
HX_DECLARE_CLASS2(h3d,prim,MeshPrimitive)
HX_DECLARE_CLASS2(h3d,prim,Primitive)
namespace h3d{
namespace prim{


class HXCPP_CLASS_ATTRIBUTES  FBXModel_obj : public ::h3d::prim::MeshPrimitive_obj{
	public:
		typedef ::h3d::prim::MeshPrimitive_obj super;
		typedef FBXModel_obj OBJ_;
		FBXModel_obj();
		Void __construct(::h3d::fbx::Geometry g,hx::Null< bool >  __o_isDynamic);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< FBXModel_obj > __new(::h3d::fbx::Geometry g,hx::Null< bool >  __o_isDynamic);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~FBXModel_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("FBXModel"); }

		::h3d::fbx::Geometry geom;
		Array< ::Dynamic > blendShapes;
		::h3d::anim::Skin skin;
		bool multiMaterial;
		::h3d::col::Bounds bounds;
		int curMaterial;
		Array< ::Dynamic > groupIndexes;
		bool isDynamic;
		::h3d::prim::FBXBuffers geomCache;
		int id;
		Array< Float > shapeRatios;
		Dynamic onVertexBuffer;
		inline Dynamic &onVertexBuffer_dyn() {return onVertexBuffer; }

		Dynamic onNormalBuffer;
		inline Dynamic &onNormalBuffer_dyn() {return onNormalBuffer; }

		virtual int getVerticesCount( );
		Dynamic getVerticesCount_dyn();

		virtual Array< Float > set_shapeRatios( Array< Float > v);
		Dynamic set_shapeRatios_dyn();

		virtual ::h3d::col::Bounds getBounds( );

		virtual Void render( ::h3d::Engine engine);

		virtual Void selectMaterial( int material);

		virtual Void dispose( );

		Array< Float > tempVert;
		Array< Float > tempNorm;
		virtual Array< Float > processShapesVerts( Array< Float > vbuf);
		Dynamic processShapesVerts_dyn();

		virtual Array< Float > norm3( Array< Float > fb);
		Dynamic norm3_dyn();

		virtual Array< Float > processShapesNorms( Array< Float > nbuf);
		Dynamic processShapesNorms_dyn();

		virtual Void alloc( ::h3d::Engine engine);

		static int uid;
		static Void zero( Array< Float > t);
		static Dynamic zero_dyn();

		static Void blit( Array< Float > d,Dynamic dstPos,Array< Float > src,Dynamic srcPos,Dynamic nb);
		static Dynamic blit_dyn();

};

} // end namespace h3d
} // end namespace prim

#endif /* INCLUDED_h3d_prim_FBXModel */ 
