#ifndef INCLUDED_h3d_fbx_AnimationMode
#define INCLUDED_h3d_fbx_AnimationMode

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,fbx,AnimationMode)
namespace h3d{
namespace fbx{


class AnimationMode_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef AnimationMode_obj OBJ_;

	public:
		AnimationMode_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("h3d.fbx.AnimationMode"); }
		::String __ToString() const { return HX_CSTRING("AnimationMode.") + tag; }

		static ::h3d::fbx::AnimationMode FrameAnim;
		static inline ::h3d::fbx::AnimationMode FrameAnim_dyn() { return FrameAnim; }
		static ::h3d::fbx::AnimationMode LinearAnim;
		static inline ::h3d::fbx::AnimationMode LinearAnim_dyn() { return LinearAnim; }
};

} // end namespace h3d
} // end namespace fbx

#endif /* INCLUDED_h3d_fbx_AnimationMode */ 
