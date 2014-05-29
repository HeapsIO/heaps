#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_haxe_ds_TreeNode
#include <haxe/ds/TreeNode.h>
#endif
namespace haxe{
namespace ds{

Void TreeNode_obj::__construct(::haxe::ds::TreeNode l,Dynamic k,Dynamic v,::haxe::ds::TreeNode r,hx::Null< int >  __o_h)
{
HX_STACK_FRAME("haxe.ds.TreeNode","new",0x88d32f89,"haxe.ds.TreeNode.new","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",220,0xd9343842)
HX_STACK_THIS(this)
HX_STACK_ARG(l,"l")
HX_STACK_ARG(k,"k")
HX_STACK_ARG(v,"v")
HX_STACK_ARG(r,"r")
HX_STACK_ARG(__o_h,"h")
int h = __o_h.Default(-1);
{
	HX_STACK_LINE(221)
	this->left = l;
	HX_STACK_LINE(222)
	this->key = k;
	HX_STACK_LINE(223)
	this->value = v;
	HX_STACK_LINE(224)
	this->right = r;
	HX_STACK_LINE(225)
	if (((h == (int)-1))){
		struct _Function_2_1{
			inline static int Block( hx::ObjectPtr< ::haxe::ds::TreeNode_obj > __this){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",226,0xd9343842)
				{
					HX_STACK_LINE(226)
					::haxe::ds::TreeNode _this = __this->left;		HX_STACK_VAR(_this,"_this");
					HX_STACK_LINE(226)
					return (  (((_this == null()))) ? int((int)0) : int(_this->_height) );
				}
				return null();
			}
		};
		struct _Function_2_2{
			inline static int Block( hx::ObjectPtr< ::haxe::ds::TreeNode_obj > __this){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",226,0xd9343842)
				{
					HX_STACK_LINE(226)
					::haxe::ds::TreeNode _this = __this->right;		HX_STACK_VAR(_this,"_this");
					HX_STACK_LINE(226)
					return (  (((_this == null()))) ? int((int)0) : int(_this->_height) );
				}
				return null();
			}
		};
		struct _Function_2_3{
			inline static int Block( hx::ObjectPtr< ::haxe::ds::TreeNode_obj > __this){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",226,0xd9343842)
				{
					HX_STACK_LINE(226)
					::haxe::ds::TreeNode _this = __this->left;		HX_STACK_VAR(_this,"_this");
					HX_STACK_LINE(226)
					return (  (((_this == null()))) ? int((int)0) : int(_this->_height) );
				}
				return null();
			}
		};
		struct _Function_2_4{
			inline static int Block( hx::ObjectPtr< ::haxe::ds::TreeNode_obj > __this){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",226,0xd9343842)
				{
					HX_STACK_LINE(226)
					::haxe::ds::TreeNode _this = __this->right;		HX_STACK_VAR(_this,"_this");
					HX_STACK_LINE(226)
					return (  (((_this == null()))) ? int((int)0) : int(_this->_height) );
				}
				return null();
			}
		};
		HX_STACK_LINE(226)
		this->_height = (((  (((_Function_2_1::Block(this) > _Function_2_2::Block(this)))) ? int(_Function_2_3::Block(this)) : int(_Function_2_4::Block(this)) )) + (int)1);
	}
	else{
		HX_STACK_LINE(228)
		this->_height = h;
	}
}
;
	return null();
}

//TreeNode_obj::~TreeNode_obj() { }

Dynamic TreeNode_obj::__CreateEmpty() { return  new TreeNode_obj; }
hx::ObjectPtr< TreeNode_obj > TreeNode_obj::__new(::haxe::ds::TreeNode l,Dynamic k,Dynamic v,::haxe::ds::TreeNode r,hx::Null< int >  __o_h)
{  hx::ObjectPtr< TreeNode_obj > result = new TreeNode_obj();
	result->__construct(l,k,v,r,__o_h);
	return result;}

Dynamic TreeNode_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< TreeNode_obj > result = new TreeNode_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4]);
	return result;}

::String TreeNode_obj::toString( ){
	HX_STACK_FRAME("haxe.ds.TreeNode","toString",0xcf78dce3,"haxe.ds.TreeNode.toString","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",233,0xd9343842)
	HX_STACK_THIS(this)
	HX_STACK_LINE(234)
	::String _g1;		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(234)
	if (((this->left == null()))){
		HX_STACK_LINE(234)
		_g1 = HX_CSTRING("");
	}
	else{
		HX_STACK_LINE(234)
		::String _g = this->left->toString();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(234)
		_g1 = (_g + HX_CSTRING(", "));
	}
	HX_STACK_LINE(234)
	::String _g2 = ::Std_obj::string(this->key);		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(234)
	::String _g3 = (HX_CSTRING("") + _g2);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(234)
	::String _g4 = (_g3 + HX_CSTRING("="));		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(234)
	::String _g5 = ::Std_obj::string(this->value);		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(234)
	::String _g6 = (_g4 + _g5);		HX_STACK_VAR(_g6,"_g6");
	HX_STACK_LINE(234)
	::String _g7 = (_g1 + _g6);		HX_STACK_VAR(_g7,"_g7");
	HX_STACK_LINE(234)
	::String _g9;		HX_STACK_VAR(_g9,"_g9");
	HX_STACK_LINE(234)
	if (((this->right == null()))){
		HX_STACK_LINE(234)
		_g9 = HX_CSTRING("");
	}
	else{
		HX_STACK_LINE(234)
		::String _g8 = this->right->toString();		HX_STACK_VAR(_g8,"_g8");
		HX_STACK_LINE(234)
		_g9 = (HX_CSTRING(", ") + _g8);
	}
	HX_STACK_LINE(234)
	return (_g7 + _g9);
}


HX_DEFINE_DYNAMIC_FUNC0(TreeNode_obj,toString,return )


TreeNode_obj::TreeNode_obj()
{
}

void TreeNode_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(TreeNode);
	HX_MARK_MEMBER_NAME(left,"left");
	HX_MARK_MEMBER_NAME(right,"right");
	HX_MARK_MEMBER_NAME(key,"key");
	HX_MARK_MEMBER_NAME(value,"value");
	HX_MARK_MEMBER_NAME(_height,"_height");
	HX_MARK_END_CLASS();
}

void TreeNode_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(left,"left");
	HX_VISIT_MEMBER_NAME(right,"right");
	HX_VISIT_MEMBER_NAME(key,"key");
	HX_VISIT_MEMBER_NAME(value,"value");
	HX_VISIT_MEMBER_NAME(_height,"_height");
}

Dynamic TreeNode_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"key") ) { return key; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"left") ) { return left; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"right") ) { return right; }
		if (HX_FIELD_EQ(inName,"value") ) { return value; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"_height") ) { return _height; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic TreeNode_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"key") ) { key=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"left") ) { left=inValue.Cast< ::haxe::ds::TreeNode >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"right") ) { right=inValue.Cast< ::haxe::ds::TreeNode >(); return inValue; }
		if (HX_FIELD_EQ(inName,"value") ) { value=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"_height") ) { _height=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void TreeNode_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("left"));
	outFields->push(HX_CSTRING("right"));
	outFields->push(HX_CSTRING("key"));
	outFields->push(HX_CSTRING("value"));
	outFields->push(HX_CSTRING("_height"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::haxe::ds::TreeNode*/ ,(int)offsetof(TreeNode_obj,left),HX_CSTRING("left")},
	{hx::fsObject /*::haxe::ds::TreeNode*/ ,(int)offsetof(TreeNode_obj,right),HX_CSTRING("right")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(TreeNode_obj,key),HX_CSTRING("key")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(TreeNode_obj,value),HX_CSTRING("value")},
	{hx::fsInt,(int)offsetof(TreeNode_obj,_height),HX_CSTRING("_height")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("left"),
	HX_CSTRING("right"),
	HX_CSTRING("key"),
	HX_CSTRING("value"),
	HX_CSTRING("_height"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(TreeNode_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(TreeNode_obj::__mClass,"__mClass");
};

#endif

Class TreeNode_obj::__mClass;

void TreeNode_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.ds.TreeNode"), hx::TCanCast< TreeNode_obj> ,sStaticFields,sMemberFields,
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

void TreeNode_obj::__boot()
{
}

} // end namespace haxe
} // end namespace ds
