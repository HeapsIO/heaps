#ifndef INCLUDED_hxd_EventKind
#define INCLUDED_hxd_EventKind

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(hxd,EventKind)
namespace hxd{


class EventKind_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef EventKind_obj OBJ_;

	public:
		EventKind_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("hxd.EventKind"); }
		::String __ToString() const { return HX_CSTRING("EventKind.") + tag; }

		static ::hxd::EventKind EFocus;
		static inline ::hxd::EventKind EFocus_dyn() { return EFocus; }
		static ::hxd::EventKind EFocusLost;
		static inline ::hxd::EventKind EFocusLost_dyn() { return EFocusLost; }
		static ::hxd::EventKind EKeyDown;
		static inline ::hxd::EventKind EKeyDown_dyn() { return EKeyDown; }
		static ::hxd::EventKind EKeyUp;
		static inline ::hxd::EventKind EKeyUp_dyn() { return EKeyUp; }
		static ::hxd::EventKind EMove;
		static inline ::hxd::EventKind EMove_dyn() { return EMove; }
		static ::hxd::EventKind EOut;
		static inline ::hxd::EventKind EOut_dyn() { return EOut; }
		static ::hxd::EventKind EOver;
		static inline ::hxd::EventKind EOver_dyn() { return EOver; }
		static ::hxd::EventKind EPush;
		static inline ::hxd::EventKind EPush_dyn() { return EPush; }
		static ::hxd::EventKind ERelease;
		static inline ::hxd::EventKind ERelease_dyn() { return ERelease; }
		static ::hxd::EventKind EWheel;
		static inline ::hxd::EventKind EWheel_dyn() { return EWheel; }
};

} // end namespace hxd

#endif /* INCLUDED_hxd_EventKind */ 
