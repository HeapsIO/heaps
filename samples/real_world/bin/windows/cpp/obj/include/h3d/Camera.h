#ifndef INCLUDED_h3d_Camera
#define INCLUDED_h3d_Camera

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(h3d,Camera)
HX_DECLARE_CLASS1(h3d,Matrix)
HX_DECLARE_CLASS1(h3d,Vector)
HX_DECLARE_CLASS2(h3d,col,Bounds)
namespace h3d{


class HXCPP_CLASS_ATTRIBUTES  Camera_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Camera_obj OBJ_;
		Camera_obj();
		Void __construct(hx::Null< Float >  __o_fovX,hx::Null< Float >  __o_zoom,hx::Null< Float >  __o_screenRatio,hx::Null< Float >  __o_zNear,hx::Null< Float >  __o_zFar,hx::Null< bool >  __o_rightHanded);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Camera_obj > __new(hx::Null< Float >  __o_fovX,hx::Null< Float >  __o_zoom,hx::Null< Float >  __o_screenRatio,hx::Null< Float >  __o_zNear,hx::Null< Float >  __o_zFar,hx::Null< bool >  __o_rightHanded);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Camera_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Camera"); }

		Float zoom;
		Float screenRatio;
		Float fovX;
		Float zNear;
		Float zFar;
		::h3d::col::Bounds orthoBounds;
		bool rightHanded;
		::h3d::Matrix mproj;
		::h3d::Matrix mcam;
		::h3d::Matrix m;
		::h3d::Vector pos;
		::h3d::Vector up;
		::h3d::Vector target;
		::h3d::Matrix minv;
		bool needInv;
		virtual Void setFovY( Float value);
		Dynamic setFovY_dyn();

		virtual ::h3d::Camera clone( );
		Dynamic clone_dyn();

		virtual ::h3d::Matrix getInverseViewProj( );
		Dynamic getInverseViewProj_dyn();

		virtual ::h3d::Vector unproject( Float screenX,Float screenY,Float camZ);
		Dynamic unproject_dyn();

		virtual Void update( );
		Dynamic update_dyn();

		virtual bool lostUp( );
		Dynamic lostUp_dyn();

		virtual Void movePosAxis( Float dx,Float dy,hx::Null< Float >  dz);
		Dynamic movePosAxis_dyn();

		virtual Void moveTargetAxis( Float dx,Float dy,hx::Null< Float >  dz);
		Dynamic moveTargetAxis_dyn();

		virtual Void makeCameraMatrix( ::h3d::Matrix m);
		Dynamic makeCameraMatrix_dyn();

		virtual Void makeFrustumMatrix( ::h3d::Matrix m);
		Dynamic makeFrustumMatrix_dyn();

};

} // end namespace h3d

#endif /* INCLUDED_h3d_Camera */ 
