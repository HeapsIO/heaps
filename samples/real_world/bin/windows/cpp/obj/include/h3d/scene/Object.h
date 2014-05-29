#ifndef INCLUDED_h3d_scene_Object
#define INCLUDED_h3d_scene_Object

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(h3d,Matrix)
HX_DECLARE_CLASS1(h3d,Quat)
HX_DECLARE_CLASS1(h3d,Vector)
HX_DECLARE_CLASS2(h3d,anim,Animation)
HX_DECLARE_CLASS2(h3d,col,Bounds)
HX_DECLARE_CLASS2(h3d,scene,Mesh)
HX_DECLARE_CLASS2(h3d,scene,Object)
HX_DECLARE_CLASS2(h3d,scene,RenderContext)
HX_DECLARE_CLASS2(hxd,impl,ArrayIterator)
namespace h3d{
namespace scene{


class HXCPP_CLASS_ATTRIBUTES  Object_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Object_obj OBJ_;
		Object_obj();
		Void __construct(::h3d::scene::Object parent);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Object_obj > __new(::h3d::scene::Object parent);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Object_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Object"); }

		Array< ::Dynamic > childs;
		::h3d::scene::Object parent;
		::String name;
		Float x;
		Float y;
		Float z;
		Float scaleX;
		Float scaleY;
		Float scaleZ;
		bool visible;
		::h3d::scene::Object follow;
		::h3d::Matrix defaultTransform;
		::h3d::anim::Animation currentAnimation;
		::h3d::Matrix absPos;
		::h3d::Matrix invPos;
		::h3d::Quat qRot;
		bool posChanged;
		int lastFrame;
		Array< ::Dynamic > animations;
		virtual ::h3d::anim::Animation get_currentAnimation( );
		Dynamic get_currentAnimation_dyn();

		virtual ::h3d::anim::Animation playAnimation( ::h3d::anim::Animation a,hx::Null< int >  slot);
		Dynamic playAnimation_dyn();

		virtual ::h3d::anim::Animation switchToAnimation( ::h3d::anim::Animation a,hx::Null< int >  slot);
		Dynamic switchToAnimation_dyn();

		virtual Void stopAnimation( hx::Null< int >  slot);
		Dynamic stopAnimation_dyn();

		virtual int getObjectsCount( );
		Dynamic getObjectsCount_dyn();

		virtual ::h3d::Vector localToGlobal( ::h3d::Vector pt);
		Dynamic localToGlobal_dyn();

		virtual ::h3d::Vector globalToLocal( ::h3d::Vector pt);
		Dynamic globalToLocal_dyn();

		virtual ::h3d::Matrix getInvPos( );
		Dynamic getInvPos_dyn();

		virtual ::h3d::col::Bounds getBounds( ::h3d::col::Bounds b);
		Dynamic getBounds_dyn();

		virtual ::h3d::scene::Object getObjectByName( ::String name);
		Dynamic getObjectByName_dyn();

		virtual ::h3d::scene::Object clone( ::h3d::scene::Object o);
		Dynamic clone_dyn();

		virtual Void addChild( ::h3d::scene::Object o);
		Dynamic addChild_dyn();

		virtual Void addChildAt( ::h3d::scene::Object o,int pos);
		Dynamic addChildAt_dyn();

		virtual Void removeChild( ::h3d::scene::Object o);
		Dynamic removeChild_dyn();

		virtual bool isMesh( );
		Dynamic isMesh_dyn();

		virtual ::h3d::scene::Mesh toMesh( );
		Dynamic toMesh_dyn();

		virtual Void remove( );
		Dynamic remove_dyn();

		virtual Void draw( ::h3d::scene::RenderContext ctx);
		Dynamic draw_dyn();

		virtual ::h3d::scene::Object set_follow( ::h3d::scene::Object v);
		Dynamic set_follow_dyn();

		virtual Void calcAbsPos( );
		Dynamic calcAbsPos_dyn();

		virtual Void sync( ::h3d::scene::RenderContext ctx);
		Dynamic sync_dyn();

		virtual Void syncPos( );
		Dynamic syncPos_dyn();

		virtual Void drawRec( ::h3d::scene::RenderContext ctx);
		Dynamic drawRec_dyn();

		virtual Float set_x( Float v);
		Dynamic set_x_dyn();

		virtual Float set_y( Float v);
		Dynamic set_y_dyn();

		virtual Float set_z( Float v);
		Dynamic set_z_dyn();

		virtual Float set_scaleX( Float v);
		Dynamic set_scaleX_dyn();

		virtual Float set_scaleY( Float v);
		Dynamic set_scaleY_dyn();

		virtual Float set_scaleZ( Float v);
		Dynamic set_scaleZ_dyn();

		virtual ::h3d::Matrix set_defaultTransform( ::h3d::Matrix v);
		Dynamic set_defaultTransform_dyn();

		virtual Void move( Float dx,Float dy,Float dz);
		Dynamic move_dyn();

		virtual Void setPos( Float x,Float y,Float z);
		Dynamic setPos_dyn();

		virtual Void rotate( Float rx,Float ry,Float rz);
		Dynamic rotate_dyn();

		virtual Void setRotate( Float rx,Float ry,Float rz);
		Dynamic setRotate_dyn();

		virtual Void setRotateAxis( Float ax,Float ay,Float az,Float angle);
		Dynamic setRotateAxis_dyn();

		virtual ::h3d::Vector getRotation( );
		Dynamic getRotation_dyn();

		virtual ::h3d::Quat getRotationQuat( );
		Dynamic getRotationQuat_dyn();

		virtual Void setRotationQuat( ::h3d::Quat q);
		Dynamic setRotationQuat_dyn();

		virtual Void scale( Float v);
		Dynamic scale_dyn();

		virtual Void setScale( Float v);
		Dynamic setScale_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		virtual ::h3d::scene::Object getChildAt( int n);
		Dynamic getChildAt_dyn();

		virtual int get_numChildren( );
		Dynamic get_numChildren_dyn();

		virtual ::hxd::impl::ArrayIterator iterator( );
		Dynamic iterator_dyn();

		virtual Void dispose( );
		Dynamic dispose_dyn();

		static Float ROT2RAD;
		static int MAX_ANIMATIONS;
};

} // end namespace h3d
} // end namespace scene

#endif /* INCLUDED_h3d_scene_Object */ 
