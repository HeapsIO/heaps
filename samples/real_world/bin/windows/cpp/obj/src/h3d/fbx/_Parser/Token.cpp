#include <hxcpp.h>

#ifndef INCLUDED_h3d_fbx__Parser_Token
#include <h3d/fbx/_Parser/Token.h>
#endif
namespace h3d{
namespace fbx{
namespace _Parser{

::h3d::fbx::_Parser::Token Token_obj::TBraceClose;

::h3d::fbx::_Parser::Token Token_obj::TBraceOpen;

::h3d::fbx::_Parser::Token Token_obj::TColon;

::h3d::fbx::_Parser::Token Token_obj::TEof;

::h3d::fbx::_Parser::Token  Token_obj::TFloat(::String s)
	{ return hx::CreateEnum< Token_obj >(HX_CSTRING("TFloat"),3,hx::DynamicArray(0,1).Add(s)); }

::h3d::fbx::_Parser::Token  Token_obj::TIdent(::String s)
	{ return hx::CreateEnum< Token_obj >(HX_CSTRING("TIdent"),0,hx::DynamicArray(0,1).Add(s)); }

::h3d::fbx::_Parser::Token  Token_obj::TInt(::String s)
	{ return hx::CreateEnum< Token_obj >(HX_CSTRING("TInt"),2,hx::DynamicArray(0,1).Add(s)); }

::h3d::fbx::_Parser::Token  Token_obj::TLength(int v)
	{ return hx::CreateEnum< Token_obj >(HX_CSTRING("TLength"),5,hx::DynamicArray(0,1).Add(v)); }

::h3d::fbx::_Parser::Token  Token_obj::TNode(::String s)
	{ return hx::CreateEnum< Token_obj >(HX_CSTRING("TNode"),1,hx::DynamicArray(0,1).Add(s)); }

::h3d::fbx::_Parser::Token  Token_obj::TString(::String s)
	{ return hx::CreateEnum< Token_obj >(HX_CSTRING("TString"),4,hx::DynamicArray(0,1).Add(s)); }

HX_DEFINE_CREATE_ENUM(Token_obj)

int Token_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("TBraceClose")) return 7;
	if (inName==HX_CSTRING("TBraceOpen")) return 6;
	if (inName==HX_CSTRING("TColon")) return 8;
	if (inName==HX_CSTRING("TEof")) return 9;
	if (inName==HX_CSTRING("TFloat")) return 3;
	if (inName==HX_CSTRING("TIdent")) return 0;
	if (inName==HX_CSTRING("TInt")) return 2;
	if (inName==HX_CSTRING("TLength")) return 5;
	if (inName==HX_CSTRING("TNode")) return 1;
	if (inName==HX_CSTRING("TString")) return 4;
	return super::__FindIndex(inName);
}

STATIC_HX_DEFINE_DYNAMIC_FUNC1(Token_obj,TFloat,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(Token_obj,TIdent,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(Token_obj,TInt,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(Token_obj,TLength,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(Token_obj,TNode,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(Token_obj,TString,return)

int Token_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("TBraceClose")) return 0;
	if (inName==HX_CSTRING("TBraceOpen")) return 0;
	if (inName==HX_CSTRING("TColon")) return 0;
	if (inName==HX_CSTRING("TEof")) return 0;
	if (inName==HX_CSTRING("TFloat")) return 1;
	if (inName==HX_CSTRING("TIdent")) return 1;
	if (inName==HX_CSTRING("TInt")) return 1;
	if (inName==HX_CSTRING("TLength")) return 1;
	if (inName==HX_CSTRING("TNode")) return 1;
	if (inName==HX_CSTRING("TString")) return 1;
	return super::__FindArgCount(inName);
}

Dynamic Token_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("TBraceClose")) return TBraceClose;
	if (inName==HX_CSTRING("TBraceOpen")) return TBraceOpen;
	if (inName==HX_CSTRING("TColon")) return TColon;
	if (inName==HX_CSTRING("TEof")) return TEof;
	if (inName==HX_CSTRING("TFloat")) return TFloat_dyn();
	if (inName==HX_CSTRING("TIdent")) return TIdent_dyn();
	if (inName==HX_CSTRING("TInt")) return TInt_dyn();
	if (inName==HX_CSTRING("TLength")) return TLength_dyn();
	if (inName==HX_CSTRING("TNode")) return TNode_dyn();
	if (inName==HX_CSTRING("TString")) return TString_dyn();
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("TIdent"),
	HX_CSTRING("TNode"),
	HX_CSTRING("TInt"),
	HX_CSTRING("TFloat"),
	HX_CSTRING("TString"),
	HX_CSTRING("TLength"),
	HX_CSTRING("TBraceOpen"),
	HX_CSTRING("TBraceClose"),
	HX_CSTRING("TColon"),
	HX_CSTRING("TEof"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Token_obj::TBraceClose,"TBraceClose");
	HX_MARK_MEMBER_NAME(Token_obj::TBraceOpen,"TBraceOpen");
	HX_MARK_MEMBER_NAME(Token_obj::TColon,"TColon");
	HX_MARK_MEMBER_NAME(Token_obj::TEof,"TEof");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Token_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Token_obj::TBraceClose,"TBraceClose");
	HX_VISIT_MEMBER_NAME(Token_obj::TBraceOpen,"TBraceOpen");
	HX_VISIT_MEMBER_NAME(Token_obj::TColon,"TColon");
	HX_VISIT_MEMBER_NAME(Token_obj::TEof,"TEof");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class Token_obj::__mClass;

Dynamic __Create_Token_obj() { return new Token_obj; }

void Token_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.fbx._Parser.Token"), hx::TCanCast< Token_obj >,sStaticFields,sMemberFields,
	&__Create_Token_obj, &__Create,
	&super::__SGetClass(), &CreateToken_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void Token_obj::__boot()
{
hx::Static(TBraceClose) = hx::CreateEnum< Token_obj >(HX_CSTRING("TBraceClose"),7);
hx::Static(TBraceOpen) = hx::CreateEnum< Token_obj >(HX_CSTRING("TBraceOpen"),6);
hx::Static(TColon) = hx::CreateEnum< Token_obj >(HX_CSTRING("TColon"),8);
hx::Static(TEof) = hx::CreateEnum< Token_obj >(HX_CSTRING("TEof"),9);
}


} // end namespace h3d
} // end namespace fbx
} // end namespace _Parser
