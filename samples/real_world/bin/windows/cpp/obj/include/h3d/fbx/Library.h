#ifndef INCLUDED_h3d_fbx_Library
#define INCLUDED_h3d_fbx_Library

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(IMap)
HX_DECLARE_CLASS2(h3d,anim,Animation)
HX_DECLARE_CLASS2(h3d,anim,Joint)
HX_DECLARE_CLASS2(h3d,anim,MorphFrameAnimation)
HX_DECLARE_CLASS2(h3d,anim,Skin)
HX_DECLARE_CLASS2(h3d,fbx,AnimationMode)
HX_DECLARE_CLASS2(h3d,fbx,DefaultMatrixes)
HX_DECLARE_CLASS2(h3d,fbx,FbxNode)
HX_DECLARE_CLASS2(h3d,fbx,Geometry)
HX_DECLARE_CLASS2(h3d,fbx,Library)
HX_DECLARE_CLASS2(h3d,mat,Material)
HX_DECLARE_CLASS2(h3d,mat,MeshMaterial)
HX_DECLARE_CLASS2(h3d,scene,Object)
HX_DECLARE_CLASS2(haxe,ds,IntMap)
HX_DECLARE_CLASS2(haxe,ds,StringMap)
namespace h3d{
namespace fbx{


class HXCPP_CLASS_ATTRIBUTES  Library_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Library_obj OBJ_;
		Library_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Library_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Library_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Library"); }

		::h3d::fbx::FbxNode root;
		::haxe::ds::IntMap ids;
		::haxe::ds::IntMap connect;
		::haxe::ds::IntMap invConnect;
		bool leftHand;
		::haxe::ds::StringMap defaultModelMatrixes;
		::haxe::ds::StringMap keepJoints;
		::haxe::ds::StringMap skipObjects;
		int bonesPerVertex;
		int maxBonesPerSkin;
		bool unskinnedJointsAsObjects;
		virtual Void reset( );
		Dynamic reset_dyn();

		virtual Void loadTextFile( ::String data);
		Dynamic loadTextFile_dyn();

		virtual Void load( ::h3d::fbx::FbxNode root);
		Dynamic load_dyn();

		virtual Void convertPoints( Array< Float > a);
		Dynamic convertPoints_dyn();

		virtual Void leftHandConvert( );
		Dynamic leftHandConvert_dyn();

		virtual Void init( ::h3d::fbx::FbxNode n);
		Dynamic init_dyn();

		virtual ::h3d::fbx::Geometry getGeometry( ::String name);
		Dynamic getGeometry_dyn();

		virtual Array< ::Dynamic > collectByName( ::String nodeName);
		Dynamic collectByName_dyn();

		virtual ::h3d::fbx::FbxNode getParent( ::h3d::fbx::FbxNode node,::String nodeName,Dynamic opt);
		Dynamic getParent_dyn();

		virtual bool hasChild( ::h3d::fbx::FbxNode node,::String nodeName);
		Dynamic hasChild_dyn();

		virtual ::h3d::fbx::FbxNode getChild( ::h3d::fbx::FbxNode node,::String nodeName,Dynamic opt);
		Dynamic getChild_dyn();

		virtual Array< ::Dynamic > getChilds( ::h3d::fbx::FbxNode node,::String nodeName);
		Dynamic getChilds_dyn();

		virtual Dynamic dumpParents( ::h3d::fbx::FbxNode node,Dynamic rep,Dynamic depth);
		Dynamic dumpParents_dyn();

		virtual Dynamic dumpChildren( ::h3d::fbx::FbxNode node,Dynamic proc,Dynamic rep,Dynamic depth);
		Dynamic dumpChildren_dyn();

		virtual Array< ::Dynamic > getParents( ::h3d::fbx::FbxNode node,::String nodeName);
		Dynamic getParents_dyn();

		virtual ::h3d::fbx::FbxNode getRoot( );
		Dynamic getRoot_dyn();

		virtual Void ignoreMissingObject( ::String name);
		Dynamic ignoreMissingObject_dyn();

		virtual ::h3d::anim::Animation loadAnimation( ::h3d::fbx::AnimationMode mode,::String animName,::h3d::fbx::FbxNode root,::h3d::fbx::Library lib);
		Dynamic loadAnimation_dyn();

		virtual Array< ::Dynamic > getTakes( );
		Dynamic getTakes_dyn();

		virtual ::h3d::anim::MorphFrameAnimation loadMorphAnimation( ::h3d::fbx::AnimationMode mode,::String animName,::h3d::fbx::FbxNode root,::h3d::fbx::Library lib);
		Dynamic loadMorphAnimation_dyn();

		virtual bool isNullJoint( ::h3d::fbx::FbxNode model);
		Dynamic isNullJoint_dyn();

		virtual int sortDistinctFloats( Float a,Float b);
		Dynamic sortDistinctFloats_dyn();

		virtual ::h3d::scene::Object makeObject( Dynamic textureLoader,hx::Null< bool >  dynamicVertices);
		Dynamic makeObject_dyn();

		virtual Dynamic keepJoint( ::h3d::anim::Joint j);
		Dynamic keepJoint_dyn();

		virtual ::h3d::anim::Skin createSkin( ::haxe::ds::IntMap hskins,::haxe::ds::IntMap hgeom,Array< ::Dynamic > rootJoints,int bonesPerVertex);
		Dynamic createSkin_dyn();

		virtual ::h3d::fbx::DefaultMatrixes getDefaultMatrixes( ::h3d::fbx::FbxNode model);
		Dynamic getDefaultMatrixes_dyn();

};

} // end namespace h3d
} // end namespace fbx

#endif /* INCLUDED_h3d_fbx_Library */ 
