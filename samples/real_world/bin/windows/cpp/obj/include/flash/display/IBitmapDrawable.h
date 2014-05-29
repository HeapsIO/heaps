#ifndef INCLUDED_flash_display_IBitmapDrawable
#define INCLUDED_flash_display_IBitmapDrawable

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(flash,geom,ColorTransform)
HX_DECLARE_CLASS2(flash,geom,Matrix)
HX_DECLARE_CLASS2(flash,geom,Rectangle)
namespace flash{
namespace display{


class HXCPP_CLASS_ATTRIBUTES  IBitmapDrawable_obj : public hx::Interface{
	public:
		typedef hx::Interface super;
		typedef IBitmapDrawable_obj OBJ_;
		HX_DO_INTERFACE_RTTI;
		static void __boot();
virtual Void __drawToSurface( Dynamic surface,::flash::geom::Matrix matrix,::flash::geom::ColorTransform colorTransform,::String blendMode,::flash::geom::Rectangle clipRect,bool smoothing)=0;
		Dynamic __drawToSurface_dyn();
};

#define DELEGATE_flash_display_IBitmapDrawable \
virtual Void __drawToSurface( Dynamic surface,::flash::geom::Matrix matrix,::flash::geom::ColorTransform colorTransform,::String blendMode,::flash::geom::Rectangle clipRect,bool smoothing) { return mDelegate->__drawToSurface(surface,matrix,colorTransform,blendMode,clipRect,smoothing);}  \
virtual Dynamic __drawToSurface_dyn() { return mDelegate->__drawToSurface_dyn();}  \


template<typename IMPL>
class IBitmapDrawable_delegate_ : public IBitmapDrawable_obj
{
	protected:
		IMPL *mDelegate;
	public:
		IBitmapDrawable_delegate_(IMPL *inDelegate) : mDelegate(inDelegate) {}
		hx::Object *__GetRealObject() { return mDelegate; }
		void __Visit(HX_VISIT_PARAMS) { HX_VISIT_OBJECT(mDelegate); }
		DELEGATE_flash_display_IBitmapDrawable
};

} // end namespace flash
} // end namespace display

#endif /* INCLUDED_flash_display_IBitmapDrawable */ 
