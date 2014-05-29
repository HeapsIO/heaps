#ifndef INCLUDED_hxd_Cursor
#define INCLUDED_hxd_Cursor

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(hxd,Cursor)
namespace hxd{


class Cursor_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef Cursor_obj OBJ_;

	public:
		Cursor_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("hxd.Cursor"); }
		::String __ToString() const { return HX_CSTRING("Cursor.") + tag; }

		static ::hxd::Cursor Button;
		static inline ::hxd::Cursor Button_dyn() { return Button; }
		static ::hxd::Cursor Default;
		static inline ::hxd::Cursor Default_dyn() { return Default; }
		static ::hxd::Cursor Hide;
		static inline ::hxd::Cursor Hide_dyn() { return Hide; }
		static ::hxd::Cursor Move;
		static inline ::hxd::Cursor Move_dyn() { return Move; }
		static ::hxd::Cursor TextInput;
		static inline ::hxd::Cursor TextInput_dyn() { return TextInput; }
};

} // end namespace hxd

#endif /* INCLUDED_hxd_Cursor */ 
