#ifndef INCLUDED_h3d_IDrawable
#define INCLUDED_h3d_IDrawable

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(h3d,Engine)
HX_DECLARE_CLASS1(h3d,IDrawable)
namespace h3d{


class HXCPP_CLASS_ATTRIBUTES  IDrawable_obj : public hx::Interface{
	public:
		typedef hx::Interface super;
		typedef IDrawable_obj OBJ_;
		HX_DO_INTERFACE_RTTI;
		static void __boot();
virtual Void render( ::h3d::Engine engine)=0;
		Dynamic render_dyn();
};

#define DELEGATE_h3d_IDrawable \
virtual Void render( ::h3d::Engine engine) { return mDelegate->render(engine);}  \
virtual Dynamic render_dyn() { return mDelegate->render_dyn();}  \


template<typename IMPL>
class IDrawable_delegate_ : public IDrawable_obj
{
	protected:
		IMPL *mDelegate;
	public:
		IDrawable_delegate_(IMPL *inDelegate) : mDelegate(inDelegate) {}
		hx::Object *__GetRealObject() { return mDelegate; }
		void __Visit(HX_VISIT_PARAMS) { HX_VISIT_OBJECT(mDelegate); }
		DELEGATE_h3d_IDrawable
};

} // end namespace h3d

#endif /* INCLUDED_h3d_IDrawable */ 
