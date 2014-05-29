#ifndef INCLUDED_cpp_rtti_FieldNumericIntegerLookup
#define INCLUDED_cpp_rtti_FieldNumericIntegerLookup

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(cpp,rtti,FieldNumericIntegerLookup)
namespace cpp{
namespace rtti{


class HXCPP_CLASS_ATTRIBUTES  FieldNumericIntegerLookup_obj : public hx::Interface{
	public:
		typedef hx::Interface super;
		typedef FieldNumericIntegerLookup_obj OBJ_;
		HX_DO_INTERFACE_RTTI;
		static void __boot();
};

#define DELEGATE_cpp_rtti_FieldNumericIntegerLookup \


template<typename IMPL>
class FieldNumericIntegerLookup_delegate_ : public FieldNumericIntegerLookup_obj
{
	protected:
		IMPL *mDelegate;
	public:
		FieldNumericIntegerLookup_delegate_(IMPL *inDelegate) : mDelegate(inDelegate) {}
		hx::Object *__GetRealObject() { return mDelegate; }
		void __Visit(HX_VISIT_PARAMS) { HX_VISIT_OBJECT(mDelegate); }
		DELEGATE_cpp_rtti_FieldNumericIntegerLookup
};

} // end namespace cpp
} // end namespace rtti

#endif /* INCLUDED_cpp_rtti_FieldNumericIntegerLookup */ 
