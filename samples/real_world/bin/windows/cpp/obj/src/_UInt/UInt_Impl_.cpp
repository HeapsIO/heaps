#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED__UInt_UInt_Impl_
#include <_UInt/UInt_Impl_.h>
#endif
namespace _UInt{

Void UInt_Impl__obj::__construct()
{
	return null();
}

//UInt_Impl__obj::~UInt_Impl__obj() { }

Dynamic UInt_Impl__obj::__CreateEmpty() { return  new UInt_Impl__obj; }
hx::ObjectPtr< UInt_Impl__obj > UInt_Impl__obj::__new()
{  hx::ObjectPtr< UInt_Impl__obj > result = new UInt_Impl__obj();
	result->__construct();
	return result;}

Dynamic UInt_Impl__obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< UInt_Impl__obj > result = new UInt_Impl__obj();
	result->__construct();
	return result;}

int UInt_Impl__obj::add( int a,int b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","add",0x721d7cc2,"_UInt.UInt_Impl_.add","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",37,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(37)
	return (a + b);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,add,return )

Float UInt_Impl__obj::div( int a,int b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","div",0x721fc7f2,"_UInt.UInt_Impl_.div","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",41,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	struct _Function_1_1{
		inline static Float Block( int &a){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",41,0x0a0262c5)
			{
				HX_STACK_LINE(41)
				int _int = a;		HX_STACK_VAR(_int,"int");
				HX_STACK_LINE(41)
				return (  (((_int < (int)0))) ? Float((4294967296.0 + _int)) : Float((_int + 0.0)) );
			}
			return null();
		}
	};
	struct _Function_1_2{
		inline static Float Block( int &b){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",41,0x0a0262c5)
			{
				HX_STACK_LINE(41)
				int _int = b;		HX_STACK_VAR(_int,"int");
				HX_STACK_LINE(41)
				return (  (((_int < (int)0))) ? Float((4294967296.0 + _int)) : Float((_int + 0.0)) );
			}
			return null();
		}
	};
	HX_STACK_LINE(41)
	return (Float(_Function_1_1::Block(a)) / Float(_Function_1_2::Block(b)));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,div,return )

int UInt_Impl__obj::mul( int a,int b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","mul",0x7226a6a5,"_UInt.UInt_Impl_.mul","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",45,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(45)
	return (a * b);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,mul,return )

int UInt_Impl__obj::sub( int a,int b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","sub",0x722b3421,"_UInt.UInt_Impl_.sub","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",49,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(49)
	return (a - b);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,sub,return )

bool UInt_Impl__obj::gt( int a,int b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","gt",0x5204beac,"_UInt.UInt_Impl_.gt","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",52,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(53)
	bool aNeg = (a < (int)0);		HX_STACK_VAR(aNeg,"aNeg");
	HX_STACK_LINE(54)
	bool bNeg = (b < (int)0);		HX_STACK_VAR(bNeg,"bNeg");
	HX_STACK_LINE(56)
	if (((aNeg != bNeg))){
		HX_STACK_LINE(56)
		return aNeg;
	}
	else{
		HX_STACK_LINE(57)
		return (a > b);
	}
	HX_STACK_LINE(56)
	return false;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,gt,return )

bool UInt_Impl__obj::gte( int a,int b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","gte",0x72221839,"_UInt.UInt_Impl_.gte","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",60,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(61)
	bool aNeg = (a < (int)0);		HX_STACK_VAR(aNeg,"aNeg");
	HX_STACK_LINE(62)
	bool bNeg = (b < (int)0);		HX_STACK_VAR(bNeg,"bNeg");
	HX_STACK_LINE(64)
	if (((aNeg != bNeg))){
		HX_STACK_LINE(64)
		return aNeg;
	}
	else{
		HX_STACK_LINE(65)
		return (a >= b);
	}
	HX_STACK_LINE(64)
	return false;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,gte,return )

bool UInt_Impl__obj::lt( int a,int b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","lt",0x5204c307,"_UInt.UInt_Impl_.lt","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",69,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(69)
	bool aNeg = (b < (int)0);		HX_STACK_VAR(aNeg,"aNeg");
	HX_STACK_LINE(69)
	bool bNeg = (a < (int)0);		HX_STACK_VAR(bNeg,"bNeg");
	HX_STACK_LINE(69)
	if (((aNeg != bNeg))){
		HX_STACK_LINE(69)
		return aNeg;
	}
	else{
		HX_STACK_LINE(69)
		return (b > a);
	}
	HX_STACK_LINE(69)
	return false;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,lt,return )

bool UInt_Impl__obj::lte( int a,int b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","lte",0x7225e37e,"_UInt.UInt_Impl_.lte","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",73,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(73)
	bool aNeg = (b < (int)0);		HX_STACK_VAR(aNeg,"aNeg");
	HX_STACK_LINE(73)
	bool bNeg = (a < (int)0);		HX_STACK_VAR(bNeg,"bNeg");
	HX_STACK_LINE(73)
	if (((aNeg != bNeg))){
		HX_STACK_LINE(73)
		return aNeg;
	}
	else{
		HX_STACK_LINE(73)
		return (b >= a);
	}
	HX_STACK_LINE(73)
	return false;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,lte,return )

int UInt_Impl__obj::_and( int a,int b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","and",0x721d8578,"_UInt.UInt_Impl_.and","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",77,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(77)
	return (int(a) & int(b));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,_and,return )

int UInt_Impl__obj::_or( int a,int b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","or",0x5204c5a2,"_UInt.UInt_Impl_.or","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",81,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(81)
	return (int(a) | int(b));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,_or,return )

int UInt_Impl__obj::_xor( int a,int b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","xor",0x722efa3c,"_UInt.UInt_Impl_.xor","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",85,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(85)
	return (int(a) ^ int(b));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,_xor,return )

int UInt_Impl__obj::shl( int a,int b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","shl",0x722b28d8,"_UInt.UInt_Impl_.shl","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",89,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(89)
	return (int(a) << int(b));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,shl,return )

int UInt_Impl__obj::shr( int a,int b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","shr",0x722b28de,"_UInt.UInt_Impl_.shr","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",93,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(93)
	return (int(a) >> int(b));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,shr,return )

int UInt_Impl__obj::ushr( int a,int b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","ushr",0x74f35727,"_UInt.UInt_Impl_.ushr","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",97,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(97)
	return hx::UShr(a,b);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,ushr,return )

int UInt_Impl__obj::mod( int a,int b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","mod",0x7226a163,"_UInt.UInt_Impl_.mod","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",101,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	struct _Function_1_1{
		inline static Float Block( int &a){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",101,0x0a0262c5)
			{
				HX_STACK_LINE(101)
				int _int = a;		HX_STACK_VAR(_int,"int");
				HX_STACK_LINE(101)
				return (  (((_int < (int)0))) ? Float((4294967296.0 + _int)) : Float((_int + 0.0)) );
			}
			return null();
		}
	};
	struct _Function_1_2{
		inline static Float Block( int &b){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",101,0x0a0262c5)
			{
				HX_STACK_LINE(101)
				int _int = b;		HX_STACK_VAR(_int,"int");
				HX_STACK_LINE(101)
				return (  (((_int < (int)0))) ? Float((4294967296.0 + _int)) : Float((_int + 0.0)) );
			}
			return null();
		}
	};
	HX_STACK_LINE(101)
	return ::Std_obj::_int(hx::Mod(_Function_1_1::Block(a),_Function_1_2::Block(b)));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,mod,return )

Float UInt_Impl__obj::addWithFloat( int a,Float b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","addWithFloat",0xd518e494,"_UInt.UInt_Impl_.addWithFloat","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",105,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	struct _Function_1_1{
		inline static Float Block( int &a){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",105,0x0a0262c5)
			{
				HX_STACK_LINE(105)
				int _int = a;		HX_STACK_VAR(_int,"int");
				HX_STACK_LINE(105)
				return (  (((_int < (int)0))) ? Float((4294967296.0 + _int)) : Float((_int + 0.0)) );
			}
			return null();
		}
	};
	HX_STACK_LINE(105)
	return (_Function_1_1::Block(a) + b);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,addWithFloat,return )

Float UInt_Impl__obj::mulWithFloat( int a,Float b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","mulWithFloat",0x7b2ae651,"_UInt.UInt_Impl_.mulWithFloat","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",109,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	struct _Function_1_1{
		inline static Float Block( int &a){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",109,0x0a0262c5)
			{
				HX_STACK_LINE(109)
				int _int = a;		HX_STACK_VAR(_int,"int");
				HX_STACK_LINE(109)
				return (  (((_int < (int)0))) ? Float((4294967296.0 + _int)) : Float((_int + 0.0)) );
			}
			return null();
		}
	};
	HX_STACK_LINE(109)
	return (_Function_1_1::Block(a) * b);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,mulWithFloat,return )

Float UInt_Impl__obj::divFloat( int a,Float b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","divFloat",0xda70604a,"_UInt.UInt_Impl_.divFloat","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",113,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	struct _Function_1_1{
		inline static Float Block( int &a){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",113,0x0a0262c5)
			{
				HX_STACK_LINE(113)
				int _int = a;		HX_STACK_VAR(_int,"int");
				HX_STACK_LINE(113)
				return (  (((_int < (int)0))) ? Float((4294967296.0 + _int)) : Float((_int + 0.0)) );
			}
			return null();
		}
	};
	HX_STACK_LINE(113)
	return (Float(_Function_1_1::Block(a)) / Float(b));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,divFloat,return )

Float UInt_Impl__obj::floatDiv( Float a,int b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","floatDiv",0x8e10e6d4,"_UInt.UInt_Impl_.floatDiv","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",117,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	struct _Function_1_1{
		inline static Float Block( int &b){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",117,0x0a0262c5)
			{
				HX_STACK_LINE(117)
				int _int = b;		HX_STACK_VAR(_int,"int");
				HX_STACK_LINE(117)
				return (  (((_int < (int)0))) ? Float((4294967296.0 + _int)) : Float((_int + 0.0)) );
			}
			return null();
		}
	};
	HX_STACK_LINE(117)
	return (Float(a) / Float(_Function_1_1::Block(b)));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,floatDiv,return )

Float UInt_Impl__obj::subFloat( int a,Float b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","subFloat",0x284369bb,"_UInt.UInt_Impl_.subFloat","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",121,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	struct _Function_1_1{
		inline static Float Block( int &a){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",121,0x0a0262c5)
			{
				HX_STACK_LINE(121)
				int _int = a;		HX_STACK_VAR(_int,"int");
				HX_STACK_LINE(121)
				return (  (((_int < (int)0))) ? Float((4294967296.0 + _int)) : Float((_int + 0.0)) );
			}
			return null();
		}
	};
	HX_STACK_LINE(121)
	return (_Function_1_1::Block(a) - b);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,subFloat,return )

Float UInt_Impl__obj::floatSub( Float a,int b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","floatSub",0x8e1c5303,"_UInt.UInt_Impl_.floatSub","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",125,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	struct _Function_1_1{
		inline static Float Block( int &b){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",125,0x0a0262c5)
			{
				HX_STACK_LINE(125)
				int _int = b;		HX_STACK_VAR(_int,"int");
				HX_STACK_LINE(125)
				return (  (((_int < (int)0))) ? Float((4294967296.0 + _int)) : Float((_int + 0.0)) );
			}
			return null();
		}
	};
	HX_STACK_LINE(125)
	return (a - _Function_1_1::Block(b));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,floatSub,return )

bool UInt_Impl__obj::gtFloat( int a,Float b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","gtFloat",0x0930c750,"_UInt.UInt_Impl_.gtFloat","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",129,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	struct _Function_1_1{
		inline static Float Block( int &a){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",129,0x0a0262c5)
			{
				HX_STACK_LINE(129)
				int _int = a;		HX_STACK_VAR(_int,"int");
				HX_STACK_LINE(129)
				return (  (((_int < (int)0))) ? Float((4294967296.0 + _int)) : Float((_int + 0.0)) );
			}
			return null();
		}
	};
	HX_STACK_LINE(129)
	return (_Function_1_1::Block(a) > b);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,gtFloat,return )

bool UInt_Impl__obj::equalsFloat( int a,Float b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","equalsFloat",0xb22ed67e,"_UInt.UInt_Impl_.equalsFloat","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",133,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	struct _Function_1_1{
		inline static Float Block( int &a){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",133,0x0a0262c5)
			{
				HX_STACK_LINE(133)
				int _int = a;		HX_STACK_VAR(_int,"int");
				HX_STACK_LINE(133)
				return (  (((_int < (int)0))) ? Float((4294967296.0 + _int)) : Float((_int + 0.0)) );
			}
			return null();
		}
	};
	HX_STACK_LINE(133)
	return (_Function_1_1::Block(a) == b);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,equalsFloat,return )

bool UInt_Impl__obj::notEqualsFloat( int a,Float b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","notEqualsFloat",0x90576b89,"_UInt.UInt_Impl_.notEqualsFloat","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",137,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	struct _Function_1_1{
		inline static Float Block( int &a){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",137,0x0a0262c5)
			{
				HX_STACK_LINE(137)
				int _int = a;		HX_STACK_VAR(_int,"int");
				HX_STACK_LINE(137)
				return (  (((_int < (int)0))) ? Float((4294967296.0 + _int)) : Float((_int + 0.0)) );
			}
			return null();
		}
	};
	HX_STACK_LINE(137)
	return (_Function_1_1::Block(a) != b);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,notEqualsFloat,return )

bool UInt_Impl__obj::gteFloat( int a,Float b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","gteFloat",0x8362aea3,"_UInt.UInt_Impl_.gteFloat","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",141,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	struct _Function_1_1{
		inline static Float Block( int &a){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",141,0x0a0262c5)
			{
				HX_STACK_LINE(141)
				int _int = a;		HX_STACK_VAR(_int,"int");
				HX_STACK_LINE(141)
				return (  (((_int < (int)0))) ? Float((4294967296.0 + _int)) : Float((_int + 0.0)) );
			}
			return null();
		}
	};
	HX_STACK_LINE(141)
	return (_Function_1_1::Block(a) >= b);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,gteFloat,return )

bool UInt_Impl__obj::floatGt( Float a,int b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","floatGt",0x40ec920a,"_UInt.UInt_Impl_.floatGt","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",146,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	struct _Function_1_1{
		inline static Float Block( int &b){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",146,0x0a0262c5)
			{
				HX_STACK_LINE(146)
				int _int = b;		HX_STACK_VAR(_int,"int");
				HX_STACK_LINE(146)
				return (  (((_int < (int)0))) ? Float((4294967296.0 + _int)) : Float((_int + 0.0)) );
			}
			return null();
		}
	};
	HX_STACK_LINE(146)
	return (a > _Function_1_1::Block(b));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,floatGt,return )

bool UInt_Impl__obj::floatGte( Float a,int b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","floatGte",0x8e13371b,"_UInt.UInt_Impl_.floatGte","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",150,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	struct _Function_1_1{
		inline static Float Block( int &b){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",150,0x0a0262c5)
			{
				HX_STACK_LINE(150)
				int _int = b;		HX_STACK_VAR(_int,"int");
				HX_STACK_LINE(150)
				return (  (((_int < (int)0))) ? Float((4294967296.0 + _int)) : Float((_int + 0.0)) );
			}
			return null();
		}
	};
	HX_STACK_LINE(150)
	return (a >= _Function_1_1::Block(b));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,floatGte,return )

bool UInt_Impl__obj::ltFloat( int a,Float b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","ltFloat",0xd91c1915,"_UInt.UInt_Impl_.ltFloat","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",154,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	struct _Function_1_1{
		inline static Float Block( int &a){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",154,0x0a0262c5)
			{
				HX_STACK_LINE(154)
				int _int = a;		HX_STACK_VAR(_int,"int");
				HX_STACK_LINE(154)
				return (  (((_int < (int)0))) ? Float((4294967296.0 + _int)) : Float((_int + 0.0)) );
			}
			return null();
		}
	};
	HX_STACK_LINE(154)
	return (_Function_1_1::Block(a) < b);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,ltFloat,return )

bool UInt_Impl__obj::lteFloat( int a,Float b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","lteFloat",0xa15ee93e,"_UInt.UInt_Impl_.lteFloat","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",158,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	struct _Function_1_1{
		inline static Float Block( int &a){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",158,0x0a0262c5)
			{
				HX_STACK_LINE(158)
				int _int = a;		HX_STACK_VAR(_int,"int");
				HX_STACK_LINE(158)
				return (  (((_int < (int)0))) ? Float((4294967296.0 + _int)) : Float((_int + 0.0)) );
			}
			return null();
		}
	};
	HX_STACK_LINE(158)
	return (_Function_1_1::Block(a) <= b);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,lteFloat,return )

bool UInt_Impl__obj::floatLt( Float a,int b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","floatLt",0x40ec9665,"_UInt.UInt_Impl_.floatLt","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",163,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	struct _Function_1_1{
		inline static Float Block( int &b){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",163,0x0a0262c5)
			{
				HX_STACK_LINE(163)
				int _int = b;		HX_STACK_VAR(_int,"int");
				HX_STACK_LINE(163)
				return (  (((_int < (int)0))) ? Float((4294967296.0 + _int)) : Float((_int + 0.0)) );
			}
			return null();
		}
	};
	HX_STACK_LINE(163)
	return (a < _Function_1_1::Block(b));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,floatLt,return )

bool UInt_Impl__obj::floatLte( Float a,int b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","floatLte",0x8e170260,"_UInt.UInt_Impl_.floatLte","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",167,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	struct _Function_1_1{
		inline static Float Block( int &b){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",167,0x0a0262c5)
			{
				HX_STACK_LINE(167)
				int _int = b;		HX_STACK_VAR(_int,"int");
				HX_STACK_LINE(167)
				return (  (((_int < (int)0))) ? Float((4294967296.0 + _int)) : Float((_int + 0.0)) );
			}
			return null();
		}
	};
	HX_STACK_LINE(167)
	return (a <= _Function_1_1::Block(b));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,floatLte,return )

Float UInt_Impl__obj::modFloat( int a,Float b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","modFloat",0xa44aad39,"_UInt.UInt_Impl_.modFloat","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",171,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	struct _Function_1_1{
		inline static Float Block( int &a){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",171,0x0a0262c5)
			{
				HX_STACK_LINE(171)
				int _int = a;		HX_STACK_VAR(_int,"int");
				HX_STACK_LINE(171)
				return (  (((_int < (int)0))) ? Float((4294967296.0 + _int)) : Float((_int + 0.0)) );
			}
			return null();
		}
	};
	HX_STACK_LINE(171)
	return hx::Mod(_Function_1_1::Block(a),b);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,modFloat,return )

Float UInt_Impl__obj::floatMod( Float a,int b){
	HX_STACK_FRAME("_UInt.UInt_Impl_","floatMod",0x8e17c045,"_UInt.UInt_Impl_.floatMod","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",175,0x0a0262c5)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	struct _Function_1_1{
		inline static Float Block( int &b){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",175,0x0a0262c5)
			{
				HX_STACK_LINE(175)
				int _int = b;		HX_STACK_VAR(_int,"int");
				HX_STACK_LINE(175)
				return (  (((_int < (int)0))) ? Float((4294967296.0 + _int)) : Float((_int + 0.0)) );
			}
			return null();
		}
	};
	HX_STACK_LINE(175)
	return hx::Mod(a,_Function_1_1::Block(b));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,floatMod,return )

int UInt_Impl__obj::negBits( int this1){
	HX_STACK_FRAME("_UInt.UInt_Impl_","negBits",0x115e4e97,"_UInt.UInt_Impl_.negBits","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",179,0x0a0262c5)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(179)
	return ~(int)(this1);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(UInt_Impl__obj,negBits,return )

int UInt_Impl__obj::prefixIncrement( int this1){
	HX_STACK_FRAME("_UInt.UInt_Impl_","prefixIncrement",0x6c79c25e,"_UInt.UInt_Impl_.prefixIncrement","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",183,0x0a0262c5)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(183)
	return ++(this1);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(UInt_Impl__obj,prefixIncrement,return )

int UInt_Impl__obj::postfixIncrement( int this1){
	HX_STACK_FRAME("_UInt.UInt_Impl_","postfixIncrement",0x55bafab9,"_UInt.UInt_Impl_.postfixIncrement","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",187,0x0a0262c5)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(187)
	return (this1)++;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(UInt_Impl__obj,postfixIncrement,return )

int UInt_Impl__obj::prefixDecrement( int this1){
	HX_STACK_FRAME("_UInt.UInt_Impl_","prefixDecrement",0x4afcb242,"_UInt.UInt_Impl_.prefixDecrement","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",191,0x0a0262c5)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(191)
	return --(this1);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(UInt_Impl__obj,prefixDecrement,return )

int UInt_Impl__obj::postfixDecrement( int this1){
	HX_STACK_FRAME("_UInt.UInt_Impl_","postfixDecrement",0x343dea9d,"_UInt.UInt_Impl_.postfixDecrement","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",195,0x0a0262c5)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(195)
	return (this1)--;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(UInt_Impl__obj,postfixDecrement,return )

::String UInt_Impl__obj::toString( int this1,Dynamic radix){
	HX_STACK_FRAME("_UInt.UInt_Impl_","toString",0xe8fc1e6b,"_UInt.UInt_Impl_.toString","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",200,0x0a0262c5)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_ARG(radix,"radix")
	struct _Function_1_1{
		inline static Float Block( int &this1){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",200,0x0a0262c5)
			{
				HX_STACK_LINE(200)
				int _int = this1;		HX_STACK_VAR(_int,"int");
				HX_STACK_LINE(200)
				return (  (((_int < (int)0))) ? Float((4294967296.0 + _int)) : Float((_int + 0.0)) );
			}
			return null();
		}
	};
	HX_STACK_LINE(200)
	return ::Std_obj::string(_Function_1_1::Block(this1));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(UInt_Impl__obj,toString,return )

int UInt_Impl__obj::toInt( int this1){
	HX_STACK_FRAME("_UInt.UInt_Impl_","toInt",0x49d5f315,"_UInt.UInt_Impl_.toInt","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",204,0x0a0262c5)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(204)
	return this1;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(UInt_Impl__obj,toInt,return )

Float UInt_Impl__obj::toFloat( int this1){
	HX_STACK_FRAME("_UInt.UInt_Impl_","toFloat",0x25ff0142,"_UInt.UInt_Impl_.toFloat","D:\\Workspace\\motionTools\\haxe3\\std/UInt.hx",207,0x0a0262c5)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(208)
	int _int = this1;		HX_STACK_VAR(_int,"int");
	HX_STACK_LINE(209)
	if (((_int < (int)0))){
		HX_STACK_LINE(210)
		return (4294967296.0 + _int);
	}
	else{
		HX_STACK_LINE(215)
		return (_int + 0.0);
	}
	HX_STACK_LINE(209)
	return 0.;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(UInt_Impl__obj,toFloat,return )


UInt_Impl__obj::UInt_Impl__obj()
{
}

Dynamic UInt_Impl__obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"gt") ) { return gt_dyn(); }
		if (HX_FIELD_EQ(inName,"lt") ) { return lt_dyn(); }
		if (HX_FIELD_EQ(inName,"or") ) { return _or_dyn(); }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"add") ) { return add_dyn(); }
		if (HX_FIELD_EQ(inName,"div") ) { return div_dyn(); }
		if (HX_FIELD_EQ(inName,"mul") ) { return mul_dyn(); }
		if (HX_FIELD_EQ(inName,"sub") ) { return sub_dyn(); }
		if (HX_FIELD_EQ(inName,"gte") ) { return gte_dyn(); }
		if (HX_FIELD_EQ(inName,"lte") ) { return lte_dyn(); }
		if (HX_FIELD_EQ(inName,"and") ) { return _and_dyn(); }
		if (HX_FIELD_EQ(inName,"xor") ) { return _xor_dyn(); }
		if (HX_FIELD_EQ(inName,"shl") ) { return shl_dyn(); }
		if (HX_FIELD_EQ(inName,"shr") ) { return shr_dyn(); }
		if (HX_FIELD_EQ(inName,"mod") ) { return mod_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"ushr") ) { return ushr_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"toInt") ) { return toInt_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"gtFloat") ) { return gtFloat_dyn(); }
		if (HX_FIELD_EQ(inName,"floatGt") ) { return floatGt_dyn(); }
		if (HX_FIELD_EQ(inName,"ltFloat") ) { return ltFloat_dyn(); }
		if (HX_FIELD_EQ(inName,"floatLt") ) { return floatLt_dyn(); }
		if (HX_FIELD_EQ(inName,"negBits") ) { return negBits_dyn(); }
		if (HX_FIELD_EQ(inName,"toFloat") ) { return toFloat_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"divFloat") ) { return divFloat_dyn(); }
		if (HX_FIELD_EQ(inName,"floatDiv") ) { return floatDiv_dyn(); }
		if (HX_FIELD_EQ(inName,"subFloat") ) { return subFloat_dyn(); }
		if (HX_FIELD_EQ(inName,"floatSub") ) { return floatSub_dyn(); }
		if (HX_FIELD_EQ(inName,"gteFloat") ) { return gteFloat_dyn(); }
		if (HX_FIELD_EQ(inName,"floatGte") ) { return floatGte_dyn(); }
		if (HX_FIELD_EQ(inName,"lteFloat") ) { return lteFloat_dyn(); }
		if (HX_FIELD_EQ(inName,"floatLte") ) { return floatLte_dyn(); }
		if (HX_FIELD_EQ(inName,"modFloat") ) { return modFloat_dyn(); }
		if (HX_FIELD_EQ(inName,"floatMod") ) { return floatMod_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"equalsFloat") ) { return equalsFloat_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"addWithFloat") ) { return addWithFloat_dyn(); }
		if (HX_FIELD_EQ(inName,"mulWithFloat") ) { return mulWithFloat_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"notEqualsFloat") ) { return notEqualsFloat_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"prefixIncrement") ) { return prefixIncrement_dyn(); }
		if (HX_FIELD_EQ(inName,"prefixDecrement") ) { return prefixDecrement_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"postfixIncrement") ) { return postfixIncrement_dyn(); }
		if (HX_FIELD_EQ(inName,"postfixDecrement") ) { return postfixDecrement_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic UInt_Impl__obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void UInt_Impl__obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("add"),
	HX_CSTRING("div"),
	HX_CSTRING("mul"),
	HX_CSTRING("sub"),
	HX_CSTRING("gt"),
	HX_CSTRING("gte"),
	HX_CSTRING("lt"),
	HX_CSTRING("lte"),
	HX_CSTRING("and"),
	HX_CSTRING("or"),
	HX_CSTRING("xor"),
	HX_CSTRING("shl"),
	HX_CSTRING("shr"),
	HX_CSTRING("ushr"),
	HX_CSTRING("mod"),
	HX_CSTRING("addWithFloat"),
	HX_CSTRING("mulWithFloat"),
	HX_CSTRING("divFloat"),
	HX_CSTRING("floatDiv"),
	HX_CSTRING("subFloat"),
	HX_CSTRING("floatSub"),
	HX_CSTRING("gtFloat"),
	HX_CSTRING("equalsFloat"),
	HX_CSTRING("notEqualsFloat"),
	HX_CSTRING("gteFloat"),
	HX_CSTRING("floatGt"),
	HX_CSTRING("floatGte"),
	HX_CSTRING("ltFloat"),
	HX_CSTRING("lteFloat"),
	HX_CSTRING("floatLt"),
	HX_CSTRING("floatLte"),
	HX_CSTRING("modFloat"),
	HX_CSTRING("floatMod"),
	HX_CSTRING("negBits"),
	HX_CSTRING("prefixIncrement"),
	HX_CSTRING("postfixIncrement"),
	HX_CSTRING("prefixDecrement"),
	HX_CSTRING("postfixDecrement"),
	HX_CSTRING("toString"),
	HX_CSTRING("toInt"),
	HX_CSTRING("toFloat"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(UInt_Impl__obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(UInt_Impl__obj::__mClass,"__mClass");
};

#endif

Class UInt_Impl__obj::__mClass;

void UInt_Impl__obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("_UInt.UInt_Impl_"), hx::TCanCast< UInt_Impl__obj> ,sStaticFields,sMemberFields,
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

void UInt_Impl__obj::__boot()
{
}

} // end namespace _UInt
