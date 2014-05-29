#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_Type
#include <Type.h>
#endif
#ifndef INCLUDED_h3d_fbx_FbxNode
#include <h3d/fbx/FbxNode.h>
#endif
#ifndef INCLUDED_h3d_fbx_FbxProp
#include <h3d/fbx/FbxProp.h>
#endif
#ifndef INCLUDED_h3d_fbx_Parser
#include <h3d/fbx/Parser.h>
#endif
#ifndef INCLUDED_h3d_fbx__Parser_Token
#include <h3d/fbx/_Parser/Token.h>
#endif
namespace h3d{
namespace fbx{

Void Parser_obj::__construct()
{
HX_STACK_FRAME("h3d.fbx.Parser","new",0xb1732e78,"h3d.fbx.Parser.new","h3d/fbx/Parser.hx",24,0x07c81336)
HX_STACK_THIS(this)
{
}
;
	return null();
}

//Parser_obj::~Parser_obj() { }

Dynamic Parser_obj::__CreateEmpty() { return  new Parser_obj; }
hx::ObjectPtr< Parser_obj > Parser_obj::__new()
{  hx::ObjectPtr< Parser_obj > result = new Parser_obj();
	result->__construct();
	return result;}

Dynamic Parser_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Parser_obj > result = new Parser_obj();
	result->__construct();
	return result;}

::h3d::fbx::FbxNode Parser_obj::parseText( ::String str){
	this->buf = str;
	this->pos = (int)0;
	this->line = (int)1;
	this->token = null();
	::h3d::fbx::FbxProp _g = ::h3d::fbx::FbxProp_obj::PInt((int)0);
	::h3d::fbx::FbxProp _g1 = ::h3d::fbx::FbxProp_obj::PString(HX_CSTRING("Root"));
	::h3d::fbx::FbxProp _g2 = ::h3d::fbx::FbxProp_obj::PString(HX_CSTRING("Root"));
	Array< ::Dynamic > _g3 = Array_obj< ::Dynamic >::__new().Add(_g).Add(_g1).Add(_g2);
	Array< ::Dynamic > _g4 = this->parseNodes();
	return ::h3d::fbx::FbxNode_obj::__new(HX_CSTRING("Root"),_g3,_g4);
}


HX_DEFINE_DYNAMIC_FUNC1(Parser_obj,parseText,return )

Array< ::Dynamic > Parser_obj::parseNodes( ){
	Array< ::Dynamic > nodes = Array_obj< ::Dynamic >::__new();
	while((true)){
		{
			::h3d::fbx::_Parser::Token _g;
			{
				if (((this->token == null()))){
					::h3d::fbx::_Parser::Token _g1 = this->nextToken();
					this->token = _g1;
				}
				_g = this->token;
			}
			switch( (int)(_g->__Index())){
				case (int)9: case (int)7: {
					return nodes;
				}
				;break;
				default: {
				}
			}
		}
		::h3d::fbx::FbxNode _g1 = this->parseNode();
		nodes->push(_g1);
	}
	return nodes;
}


HX_DEFINE_DYNAMIC_FUNC0(Parser_obj,parseNodes,return )

::h3d::fbx::FbxNode Parser_obj::parseNode( ){
	::h3d::fbx::_Parser::Token t;
	if (((this->token == null()))){
		t = this->nextToken();
	}
	else{
		::h3d::fbx::_Parser::Token tmp = this->token;
		this->token = null();
		t = tmp;
	}
	::String name;
	switch( (int)(t->__Index())){
		case (int)1: {
			::String n = (::h3d::fbx::_Parser::Token(t))->__Param(0);
			name = n;
		}
		;break;
		default: {
			name = this->unexpected(t);
		}
	}
	Array< ::Dynamic > props = Array_obj< ::Dynamic >::__new();
	Array< ::Dynamic > childs = null();
	while((true)){
		::h3d::fbx::_Parser::Token _g;
		if (((this->token == null()))){
			_g = this->nextToken();
		}
		else{
			::h3d::fbx::_Parser::Token tmp = this->token;
			this->token = null();
			_g = tmp;
		}
		t = _g;
		int _switch_1 = (t->__Index());
		if (  ( _switch_1==(int)3)){
			::String s = (::h3d::fbx::_Parser::Token(t))->__Param(0);
			{
				Float _g1 = ::Std_obj::parseFloat(s);
				::h3d::fbx::FbxProp _g2 = ::h3d::fbx::FbxProp_obj::PFloat(_g1);
				props->push(_g2);
			}
		}
		else if (  ( _switch_1==(int)2)){
			::String s = (::h3d::fbx::_Parser::Token(t))->__Param(0);
			{
				Dynamic _g3 = ::Std_obj::parseInt(s);
				::h3d::fbx::FbxProp _g4 = ::h3d::fbx::FbxProp_obj::PInt(_g3);
				props->push(_g4);
			}
		}
		else if (  ( _switch_1==(int)4)){
			::String s = (::h3d::fbx::_Parser::Token(t))->__Param(0);
			{
				::h3d::fbx::FbxProp _g5 = ::h3d::fbx::FbxProp_obj::PString(s);
				props->push(_g5);
			}
		}
		else if (  ( _switch_1==(int)0)){
			::String s = (::h3d::fbx::_Parser::Token(t))->__Param(0);
			{
				::h3d::fbx::FbxProp _g6 = ::h3d::fbx::FbxProp_obj::PIdent(s);
				props->push(_g6);
			}
		}
		else if (  ( _switch_1==(int)6) ||  ( _switch_1==(int)7)){
			this->token = t;
		}
		else if (  ( _switch_1==(int)5)){
			int v = (::h3d::fbx::_Parser::Token(t))->__Param(0);
			{
				this->except(::h3d::fbx::_Parser::Token_obj::TBraceOpen);
				::h3d::fbx::_Parser::Token _g7 = ::h3d::fbx::_Parser::Token_obj::TNode(HX_CSTRING("a"));
				this->except(_g7);
				Array< ::Dynamic > ints = Array_obj< ::Dynamic >::__new();
				Array< Float > floats = null();
				int i = (int)0;
				while((true)){
					if ((!(((i < v))))){
						break;
					}
					::h3d::fbx::_Parser::Token _g8;
					if (((this->token == null()))){
						_g8 = this->nextToken();
					}
					else{
						::h3d::fbx::_Parser::Token tmp = this->token;
						this->token = null();
						_g8 = tmp;
					}
					t = _g8;
					switch( (int)(t->__Index())){
						case (int)8: {
							continue;
						}
						;break;
						case (int)2: {
							::String s = (::h3d::fbx::_Parser::Token(t))->__Param(0);
							{
								(i)++;
								if (((floats == null()))){
									Dynamic _g9 = ::Std_obj::parseInt(s);
									ints->push(_g9);
								}
								else{
									Dynamic _g10 = ::Std_obj::parseInt(s);
									floats->push(_g10);
								}
							}
						}
						;break;
						case (int)3: {
							::String s = (::h3d::fbx::_Parser::Token(t))->__Param(0);
							{
								(i)++;
								if (((floats == null()))){
									floats = Array_obj< Float >::__new();
									{
										int _g1 = (int)0;
										while((true)){
											if ((!(((_g1 < ints->length))))){
												break;
											}
											Dynamic i1 = ints->__get(_g1);
											++(_g1);
											floats->push(i1);
										}
									}
									ints = null();
								}
								Float _g11 = ::Std_obj::parseFloat(s);
								floats->push(_g11);
							}
						}
						;break;
						default: {
							this->unexpected(t);
						}
					}
				}
				::h3d::fbx::FbxProp _g12;
				if (((floats == null()))){
					_g12 = ::h3d::fbx::FbxProp_obj::PInts(ints);
				}
				else{
					_g12 = ::h3d::fbx::FbxProp_obj::PFloats(floats);
				}
				props->push(_g12);
				this->except(::h3d::fbx::_Parser::Token_obj::TBraceClose);
				break;
			}
		}
		else  {
			this->unexpected(t);
		}
;
;
		::h3d::fbx::_Parser::Token _g13;
		if (((this->token == null()))){
			_g13 = this->nextToken();
		}
		else{
			::h3d::fbx::_Parser::Token tmp = this->token;
			this->token = null();
			_g13 = tmp;
		}
		t = _g13;
		int _switch_2 = (t->__Index());
		if (  ( _switch_2==(int)1) ||  ( _switch_2==(int)7)){
			this->token = t;
			break;
		}
		else if (  ( _switch_2==(int)8)){
		}
		else if (  ( _switch_2==(int)6)){
			Array< ::Dynamic > _g14 = this->parseNodes();
			childs = _g14;
			this->except(::h3d::fbx::_Parser::Token_obj::TBraceClose);
			break;
		}
		else  {
			this->unexpected(t);
		}
;
;
	}
	if (((childs == null()))){
		childs = Array_obj< ::Dynamic >::__new();
	}
	return ::h3d::fbx::FbxNode_obj::__new(name,props,childs);
}


HX_DEFINE_DYNAMIC_FUNC0(Parser_obj,parseNode,return )

Void Parser_obj::except( ::h3d::fbx::_Parser::Token except){
{
		HX_STACK_FRAME("h3d.fbx.Parser","except",0x7a0ab401,"h3d.fbx.Parser.except","h3d/fbx/Parser.hx",129,0x07c81336)
		HX_STACK_THIS(this)
		HX_STACK_ARG(except,"except")
		HX_STACK_LINE(130)
		::h3d::fbx::_Parser::Token t;		HX_STACK_VAR(t,"t");
		HX_STACK_LINE(130)
		if (((this->token == null()))){
			HX_STACK_LINE(130)
			t = this->nextToken();
		}
		else{
			HX_STACK_LINE(130)
			::h3d::fbx::_Parser::Token tmp = this->token;		HX_STACK_VAR(tmp,"tmp");
			HX_STACK_LINE(130)
			this->token = null();
			HX_STACK_LINE(130)
			t = tmp;
		}
		HX_STACK_LINE(131)
		if ((!(::Type_obj::enumEq(t,except)))){
			HX_STACK_LINE(132)
			::String _g = this->tokenStr(t);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(132)
			::String _g1 = (HX_CSTRING("Unexpected '") + _g);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(132)
			::String _g2 = (_g1 + HX_CSTRING("' ("));		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(132)
			::String _g3 = this->tokenStr(except);		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(132)
			::String _g4 = (_g2 + _g3);		HX_STACK_VAR(_g4,"_g4");
			HX_STACK_LINE(132)
			::String _g5 = (_g4 + HX_CSTRING(" expected)"));		HX_STACK_VAR(_g5,"_g5");
			HX_STACK_LINE(132)
			this->error(_g5);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Parser_obj,except,(void))

::h3d::fbx::_Parser::Token Parser_obj::peek( ){
	HX_STACK_FRAME("h3d.fbx.Parser","peek",0x94a7d883,"h3d.fbx.Parser.peek","h3d/fbx/Parser.hx",135,0x07c81336)
	HX_STACK_THIS(this)
	HX_STACK_LINE(136)
	if (((this->token == null()))){
		HX_STACK_LINE(137)
		::h3d::fbx::_Parser::Token _g = this->nextToken();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(137)
		this->token = _g;
	}
	HX_STACK_LINE(138)
	return this->token;
}


HX_DEFINE_DYNAMIC_FUNC0(Parser_obj,peek,return )

::h3d::fbx::_Parser::Token Parser_obj::next( ){
	HX_STACK_FRAME("h3d.fbx.Parser","next",0x93557bdb,"h3d.fbx.Parser.next","h3d/fbx/Parser.hx",141,0x07c81336)
	HX_STACK_THIS(this)
	HX_STACK_LINE(142)
	if (((this->token == null()))){
		HX_STACK_LINE(143)
		return this->nextToken();
	}
	HX_STACK_LINE(144)
	::h3d::fbx::_Parser::Token tmp = this->token;		HX_STACK_VAR(tmp,"tmp");
	HX_STACK_LINE(145)
	this->token = null();
	HX_STACK_LINE(146)
	return tmp;
}


HX_DEFINE_DYNAMIC_FUNC0(Parser_obj,next,return )

Dynamic Parser_obj::error( ::String msg){
	HX_STACK_FRAME("h3d.fbx.Parser","error",0x316edfe0,"h3d.fbx.Parser.error","h3d/fbx/Parser.hx",149,0x07c81336)
	HX_STACK_THIS(this)
	HX_STACK_ARG(msg,"msg")
	HX_STACK_LINE(150)
	HX_STACK_DO_THROW((((msg + HX_CSTRING(" (line ")) + this->line) + HX_CSTRING(")")));
	HX_STACK_LINE(151)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Parser_obj,error,return )

Dynamic Parser_obj::unexpected( ::h3d::fbx::_Parser::Token t){
	HX_STACK_FRAME("h3d.fbx.Parser","unexpected",0xe9572ab9,"h3d.fbx.Parser.unexpected","h3d/fbx/Parser.hx",154,0x07c81336)
	HX_STACK_THIS(this)
	HX_STACK_ARG(t,"t")
	HX_STACK_LINE(155)
	::String _g = this->tokenStr(t);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(155)
	::String _g1 = (HX_CSTRING("Unexpected ") + _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(155)
	return this->error(_g1);
}


HX_DEFINE_DYNAMIC_FUNC1(Parser_obj,unexpected,return )

::String Parser_obj::tokenStr( ::h3d::fbx::_Parser::Token t){
	switch( (int)(t->__Index())){
		case (int)9: {
			return HX_CSTRING("<eof>");
		}
		;break;
		case (int)6: {
			return HX_CSTRING("{");
		}
		;break;
		case (int)7: {
			return HX_CSTRING("}");
		}
		;break;
		case (int)0: {
			::String i = (::h3d::fbx::_Parser::Token(t))->__Param(0);
			return i;
		}
		;break;
		case (int)1: {
			::String i = (::h3d::fbx::_Parser::Token(t))->__Param(0);
			return (i + HX_CSTRING(":"));
		}
		;break;
		case (int)3: {
			::String f = (::h3d::fbx::_Parser::Token(t))->__Param(0);
			return f;
		}
		;break;
		case (int)2: {
			::String i = (::h3d::fbx::_Parser::Token(t))->__Param(0);
			return i;
		}
		;break;
		case (int)4: {
			::String s = (::h3d::fbx::_Parser::Token(t))->__Param(0);
			return ((HX_CSTRING("\"") + s) + HX_CSTRING("\""));
		}
		;break;
		case (int)8: {
			return HX_CSTRING(",");
		}
		;break;
		case (int)5: {
			int l = (::h3d::fbx::_Parser::Token(t))->__Param(0);
			return (HX_CSTRING("*") + l);
		}
		;break;
	}
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Parser_obj,tokenStr,return )

int Parser_obj::nextChar( ){
	int index = (this->pos)++;
	return this->buf.cca(index);
}


HX_DEFINE_DYNAMIC_FUNC0(Parser_obj,nextChar,return )

::String Parser_obj::getBuf( int pos,int len){
	return this->buf.substr(pos,len);
}


HX_DEFINE_DYNAMIC_FUNC2(Parser_obj,getBuf,return )

bool Parser_obj::isIdentChar( int c){
	return (bool((bool((bool((bool((bool((c >= (int)97)) && bool((c <= (int)122)))) || bool((bool((c >= (int)65)) && bool((c <= (int)90)))))) || bool((bool((c >= (int)48)) && bool((c <= (int)57)))))) || bool((c == (int)95)))) || bool((c == (int)45)));
}


HX_DEFINE_DYNAMIC_FUNC1(Parser_obj,isIdentChar,return )

::h3d::fbx::_Parser::Token Parser_obj::nextToken( ){
	int start = this->pos;
	while((true)){
		int c;
		{
			int index = (this->pos)++;
			c = this->buf.cca(index);
		}
		switch( (int)(c)){
			case (int)32: case (int)13: case (int)9: {
				(start)++;
			}
			;break;
			case (int)10: {
				(this->line)++;
				(start)++;
			}
			;break;
			case (int)59: {
				while((true)){
					int c1;
					{
						int index = (this->pos)++;
						c1 = this->buf.cca(index);
					}
					if (((bool((c1 == (int)0)) || bool((c1 == (int)10))))){
						(this->pos)--;
						break;
					}
				}
				start = this->pos;
			}
			;break;
			case (int)44: {
				return ::h3d::fbx::_Parser::Token_obj::TColon;
			}
			;break;
			case (int)123: {
				return ::h3d::fbx::_Parser::Token_obj::TBraceOpen;
			}
			;break;
			case (int)125: {
				return ::h3d::fbx::_Parser::Token_obj::TBraceClose;
			}
			;break;
			case (int)34: {
				start = this->pos;
				while((true)){
					int _g;
					{
						int index = (this->pos)++;
						_g = this->buf.cca(index);
					}
					c = _g;
					if (((c == (int)34))){
						break;
					}
					if (((bool((c == (int)0)) || bool((c == (int)10))))){
						this->error(HX_CSTRING("Unclosed string"));
					}
				}
				::String _g1 = this->buf.substr(start,((this->pos - start) - (int)1));
				return ::h3d::fbx::_Parser::Token_obj::TString(_g1);
			}
			;break;
			case (int)42: {
				start = this->pos;
				while((true)){
					int _g2;
					{
						int index = (this->pos)++;
						_g2 = this->buf.cca(index);
					}
					c = _g2;
					if ((!(((bool((c >= (int)48)) && bool((c <= (int)57))))))){
						break;
					}
				}
				(this->pos)--;
				::String _g3 = this->buf.substr(start,(this->pos - start));
				Dynamic _g4 = ::Std_obj::parseInt(_g3);
				return ::h3d::fbx::_Parser::Token_obj::TLength(_g4);
			}
			;break;
			default: {
				if (((bool((bool((bool((c >= (int)97)) && bool((c <= (int)122)))) || bool((bool((c >= (int)65)) && bool((c <= (int)90)))))) || bool((c == (int)95))))){
					while((true)){
						int _g5;
						{
							int index = (this->pos)++;
							_g5 = this->buf.cca(index);
						}
						c = _g5;
						if ((!(((bool((bool((bool((bool((bool((c >= (int)97)) && bool((c <= (int)122)))) || bool((bool((c >= (int)65)) && bool((c <= (int)90)))))) || bool((bool((c >= (int)48)) && bool((c <= (int)57)))))) || bool((c == (int)95)))) || bool((c == (int)45))))))){
							break;
						}
					}
					if (((c == (int)58))){
						::String _g6 = this->buf.substr(start,((this->pos - start) - (int)1));
						return ::h3d::fbx::_Parser::Token_obj::TNode(_g6);
					}
					(this->pos)--;
					::String _g7 = this->buf.substr(start,(this->pos - start));
					return ::h3d::fbx::_Parser::Token_obj::TIdent(_g7);
				}
				if (((bool((bool((c >= (int)48)) && bool((c <= (int)57)))) || bool((c == (int)45))))){
					while((true)){
						int _g8;
						{
							int index = (this->pos)++;
							_g8 = this->buf.cca(index);
						}
						c = _g8;
						if ((!(((bool((c >= (int)48)) && bool((c <= (int)57))))))){
							break;
						}
					}
					if (((bool((bool((bool((c != (int)46)) && bool((c != (int)69)))) && bool((c != (int)101)))) && bool(((this->pos - start) < (int)10))))){
						(this->pos)--;
						::String _g9 = this->buf.substr(start,(this->pos - start));
						return ::h3d::fbx::_Parser::Token_obj::TInt(_g9);
					}
					if (((c == (int)46))){
						while((true)){
							int _g10;
							{
								int index = (this->pos)++;
								_g10 = this->buf.cca(index);
							}
							c = _g10;
							if ((!(((bool((c >= (int)48)) && bool((c <= (int)57))))))){
								break;
							}
						}
					}
					if (((bool((c == (int)101)) || bool((c == (int)69))))){
						int _g11;
						{
							int index = (this->pos)++;
							_g11 = this->buf.cca(index);
						}
						c = _g11;
						if (((bool((c != (int)45)) && bool((c != (int)43))))){
							(this->pos)--;
						}
						while((true)){
							int _g12;
							{
								int index = (this->pos)++;
								_g12 = this->buf.cca(index);
							}
							c = _g12;
							if ((!(((bool((c >= (int)48)) && bool((c <= (int)57))))))){
								break;
							}
						}
					}
					(this->pos)--;
					::String _g13 = this->buf.substr(start,(this->pos - start));
					return ::h3d::fbx::_Parser::Token_obj::TFloat(_g13);
				}
				if (((c == (int)0))){
					(this->pos)--;
					return ::h3d::fbx::_Parser::Token_obj::TEof;
				}
				::String _g14 = ::String::fromCharCode(c);
				::String _g15 = (HX_CSTRING("Unexpected char '") + _g14);
				::String _g16 = (_g15 + HX_CSTRING("'"));
				this->error(_g16);
			}
		}
	}
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Parser_obj,nextToken,return )

::h3d::fbx::FbxNode Parser_obj::parse( ::String text){
	return ::h3d::fbx::Parser_obj::__new()->parseText(text);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Parser_obj,parse,return )


Parser_obj::Parser_obj()
{
}

void Parser_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Parser);
	HX_MARK_MEMBER_NAME(line,"line");
	HX_MARK_MEMBER_NAME(buf,"buf");
	HX_MARK_MEMBER_NAME(pos,"pos");
	HX_MARK_MEMBER_NAME(token,"token");
	HX_MARK_END_CLASS();
}

void Parser_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(line,"line");
	HX_VISIT_MEMBER_NAME(buf,"buf");
	HX_VISIT_MEMBER_NAME(pos,"pos");
	HX_VISIT_MEMBER_NAME(token,"token");
}

Dynamic Parser_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"buf") ) { return buf; }
		if (HX_FIELD_EQ(inName,"pos") ) { return pos; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"line") ) { return line; }
		if (HX_FIELD_EQ(inName,"peek") ) { return peek_dyn(); }
		if (HX_FIELD_EQ(inName,"next") ) { return next_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"parse") ) { return parse_dyn(); }
		if (HX_FIELD_EQ(inName,"token") ) { return token; }
		if (HX_FIELD_EQ(inName,"error") ) { return error_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"except") ) { return except_dyn(); }
		if (HX_FIELD_EQ(inName,"getBuf") ) { return getBuf_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"tokenStr") ) { return tokenStr_dyn(); }
		if (HX_FIELD_EQ(inName,"nextChar") ) { return nextChar_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"parseText") ) { return parseText_dyn(); }
		if (HX_FIELD_EQ(inName,"parseNode") ) { return parseNode_dyn(); }
		if (HX_FIELD_EQ(inName,"nextToken") ) { return nextToken_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"parseNodes") ) { return parseNodes_dyn(); }
		if (HX_FIELD_EQ(inName,"unexpected") ) { return unexpected_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"isIdentChar") ) { return isIdentChar_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Parser_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"buf") ) { buf=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"pos") ) { pos=inValue.Cast< int >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"line") ) { line=inValue.Cast< int >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"token") ) { token=inValue.Cast< ::h3d::fbx::_Parser::Token >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Parser_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("line"));
	outFields->push(HX_CSTRING("buf"));
	outFields->push(HX_CSTRING("pos"));
	outFields->push(HX_CSTRING("token"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("parse"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(Parser_obj,line),HX_CSTRING("line")},
	{hx::fsString,(int)offsetof(Parser_obj,buf),HX_CSTRING("buf")},
	{hx::fsInt,(int)offsetof(Parser_obj,pos),HX_CSTRING("pos")},
	{hx::fsObject /*::h3d::fbx::_Parser::Token*/ ,(int)offsetof(Parser_obj,token),HX_CSTRING("token")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("line"),
	HX_CSTRING("buf"),
	HX_CSTRING("pos"),
	HX_CSTRING("token"),
	HX_CSTRING("parseText"),
	HX_CSTRING("parseNodes"),
	HX_CSTRING("parseNode"),
	HX_CSTRING("except"),
	HX_CSTRING("peek"),
	HX_CSTRING("next"),
	HX_CSTRING("error"),
	HX_CSTRING("unexpected"),
	HX_CSTRING("tokenStr"),
	HX_CSTRING("nextChar"),
	HX_CSTRING("getBuf"),
	HX_CSTRING("isIdentChar"),
	HX_CSTRING("nextToken"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Parser_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Parser_obj::__mClass,"__mClass");
};

#endif

Class Parser_obj::__mClass;

void Parser_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.fbx.Parser"), hx::TCanCast< Parser_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatics
#endif
#ifdef HXCPP_SCRIPTABLE
    , sMemberStorageInfo
#endif
);
}

void Parser_obj::__boot()
{
}

} // end namespace h3d
} // end namespace fbx
