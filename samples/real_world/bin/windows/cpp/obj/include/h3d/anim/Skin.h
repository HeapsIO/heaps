#ifndef INCLUDED_h3d_anim_Skin
#define INCLUDED_h3d_anim_Skin

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(IMap)
HX_DECLARE_CLASS2(h3d,anim,Joint)
HX_DECLARE_CLASS2(h3d,anim,Skin)
HX_DECLARE_CLASS3(h3d,anim,_Skin,Influence)
HX_DECLARE_CLASS2(h3d,prim,Primitive)
HX_DECLARE_CLASS2(haxe,ds,StringMap)
namespace h3d{
namespace anim{


class HXCPP_CLASS_ATTRIBUTES  Skin_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Skin_obj OBJ_;
		Skin_obj();
		Void __construct(int vertexCount,int bonesPerVertex);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Skin_obj > __new(int vertexCount,int bonesPerVertex);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Skin_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Skin"); }

		int vertexCount;
		int bonesPerVertex;
		Array< int > vertexJoints;
		Array< Float > vertexWeights;
		Array< ::Dynamic > rootJoints;
		::haxe::ds::StringMap namedJoints;
		Array< ::Dynamic > allJoints;
		Array< ::Dynamic > boundJoints;
		::h3d::prim::Primitive primitive;
		Array< ::Dynamic > splitJoints;
		Array< int > triangleGroups;
		Array< ::Dynamic > envelop;
		virtual Void setJoints( Array< ::Dynamic > joints,Array< ::Dynamic > roots);
		Dynamic setJoints_dyn();

		virtual Void addInfluence( int vid,::h3d::anim::Joint j,Float w);
		Dynamic addInfluence_dyn();

		virtual int sortInfluences( ::h3d::anim::_Skin::Influence i1,::h3d::anim::_Skin::Influence i2);
		Dynamic sortInfluences_dyn();

		virtual bool isSplit( );
		Dynamic isSplit_dyn();

		virtual Void initWeights( );
		Dynamic initWeights_dyn();

		virtual bool split( int maxBones,Array< int > index);
		Dynamic split_dyn();

};

} // end namespace h3d
} // end namespace anim

#endif /* INCLUDED_h3d_anim_Skin */ 
