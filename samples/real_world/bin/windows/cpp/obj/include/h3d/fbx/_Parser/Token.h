#ifndef INCLUDED_h3d_fbx__Parser_Token
#define INCLUDED_h3d_fbx__Parser_Token

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS3(h3d,fbx,_Parser,Token)
namespace h3d{
namespace fbx{
namespace _Parser{


class Token_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef Token_obj OBJ_;

	public:
		Token_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("h3d.fbx._Parser.Token"); }
		::String __ToString() const { return HX_CSTRING("Token.") + tag; }

		static ::h3d::fbx::_Parser::Token TBraceClose;
		static inline ::h3d::fbx::_Parser::Token TBraceClose_dyn() { return TBraceClose; }
		static ::h3d::fbx::_Parser::Token TBraceOpen;
		static inline ::h3d::fbx::_Parser::Token TBraceOpen_dyn() { return TBraceOpen; }
		static ::h3d::fbx::_Parser::Token TColon;
		static inline ::h3d::fbx::_Parser::Token TColon_dyn() { return TColon; }
		static ::h3d::fbx::_Parser::Token TEof;
		static inline ::h3d::fbx::_Parser::Token TEof_dyn() { return TEof; }
		static ::h3d::fbx::_Parser::Token TFloat(::String s);
		static Dynamic TFloat_dyn();
		static ::h3d::fbx::_Parser::Token TIdent(::String s);
		static Dynamic TIdent_dyn();
		static ::h3d::fbx::_Parser::Token TInt(::String s);
		static Dynamic TInt_dyn();
		static ::h3d::fbx::_Parser::Token TLength(int v);
		static Dynamic TLength_dyn();
		static ::h3d::fbx::_Parser::Token TNode(::String s);
		static Dynamic TNode_dyn();
		static ::h3d::fbx::_Parser::Token TString(::String s);
		static Dynamic TString_dyn();
};

} // end namespace h3d
} // end namespace fbx
} // end namespace _Parser

#endif /* INCLUDED_h3d_fbx__Parser_Token */ 
