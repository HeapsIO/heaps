#ifndef INCLUDED_h3d_fbx_Parser
#define INCLUDED_h3d_fbx_Parser

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,fbx,FbxNode)
HX_DECLARE_CLASS2(h3d,fbx,Parser)
HX_DECLARE_CLASS3(h3d,fbx,_Parser,Token)
namespace h3d{
namespace fbx{


class HXCPP_CLASS_ATTRIBUTES  Parser_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Parser_obj OBJ_;
		Parser_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Parser_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Parser_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Parser"); }

		int line;
		::String buf;
		int pos;
		::h3d::fbx::_Parser::Token token;
		virtual ::h3d::fbx::FbxNode parseText( ::String str);
		Dynamic parseText_dyn();

		virtual Array< ::Dynamic > parseNodes( );
		Dynamic parseNodes_dyn();

		virtual ::h3d::fbx::FbxNode parseNode( );
		Dynamic parseNode_dyn();

		virtual Void except( ::h3d::fbx::_Parser::Token except);
		Dynamic except_dyn();

		virtual ::h3d::fbx::_Parser::Token peek( );
		Dynamic peek_dyn();

		virtual ::h3d::fbx::_Parser::Token next( );
		Dynamic next_dyn();

		virtual Dynamic error( ::String msg);
		Dynamic error_dyn();

		virtual Dynamic unexpected( ::h3d::fbx::_Parser::Token t);
		Dynamic unexpected_dyn();

		virtual ::String tokenStr( ::h3d::fbx::_Parser::Token t);
		Dynamic tokenStr_dyn();

		virtual int nextChar( );
		Dynamic nextChar_dyn();

		virtual ::String getBuf( int pos,int len);
		Dynamic getBuf_dyn();

		virtual bool isIdentChar( int c);
		Dynamic isIdentChar_dyn();

		virtual ::h3d::fbx::_Parser::Token nextToken( );
		Dynamic nextToken_dyn();

		static ::h3d::fbx::FbxNode parse( ::String text);
		static Dynamic parse_dyn();

};

} // end namespace h3d
} // end namespace fbx

#endif /* INCLUDED_h3d_fbx_Parser */ 
