#include <hxcpp.h>

#ifndef INCLUDED_Reflect
#include <Reflect.h>
#endif
#ifndef INCLUDED_haxe_ds_BalancedTree
#include <haxe/ds/BalancedTree.h>
#endif
#ifndef INCLUDED_haxe_ds_TreeNode
#include <haxe/ds/TreeNode.h>
#endif
namespace haxe{
namespace ds{

Void BalancedTree_obj::__construct()
{
HX_STACK_FRAME("haxe.ds.BalancedTree","new",0xfb50b0cf,"haxe.ds.BalancedTree.new","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",41,0xd9343842)
HX_STACK_THIS(this)
{
}
;
	return null();
}

//BalancedTree_obj::~BalancedTree_obj() { }

Dynamic BalancedTree_obj::__CreateEmpty() { return  new BalancedTree_obj; }
hx::ObjectPtr< BalancedTree_obj > BalancedTree_obj::__new()
{  hx::ObjectPtr< BalancedTree_obj > result = new BalancedTree_obj();
	result->__construct();
	return result;}

Dynamic BalancedTree_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< BalancedTree_obj > result = new BalancedTree_obj();
	result->__construct();
	return result;}

Void BalancedTree_obj::set( Dynamic key,Dynamic value){
{
		HX_STACK_FRAME("haxe.ds.BalancedTree","set",0xfb547c11,"haxe.ds.BalancedTree.set","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",50,0xd9343842)
		HX_STACK_THIS(this)
		HX_STACK_ARG(key,"key")
		HX_STACK_ARG(value,"value")
		HX_STACK_LINE(51)
		::haxe::ds::TreeNode _g = this->setLoop(key,value,this->root);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(51)
		this->root = _g;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(BalancedTree_obj,set,(void))

Dynamic BalancedTree_obj::get( Dynamic key){
	HX_STACK_FRAME("haxe.ds.BalancedTree","get",0xfb4b6105,"haxe.ds.BalancedTree.get","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",61,0xd9343842)
	HX_STACK_THIS(this)
	HX_STACK_ARG(key,"key")
	HX_STACK_LINE(62)
	::haxe::ds::TreeNode node = this->root;		HX_STACK_VAR(node,"node");
	HX_STACK_LINE(63)
	while((true)){
		HX_STACK_LINE(63)
		if ((!(((node != null()))))){
			HX_STACK_LINE(63)
			break;
		}
		HX_STACK_LINE(64)
		int c = this->compare(key,node->key);		HX_STACK_VAR(c,"c");
		HX_STACK_LINE(65)
		if (((c == (int)0))){
			HX_STACK_LINE(65)
			return node->value;
		}
		HX_STACK_LINE(66)
		if (((c < (int)0))){
			HX_STACK_LINE(66)
			node = node->left;
		}
		else{
			HX_STACK_LINE(67)
			node = node->right;
		}
	}
	HX_STACK_LINE(69)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(BalancedTree_obj,get,return )

bool BalancedTree_obj::remove( Dynamic key){
	HX_STACK_FRAME("haxe.ds.BalancedTree","remove",0x68366b35,"haxe.ds.BalancedTree.remove","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",83,0xd9343842)
	HX_STACK_THIS(this)
	HX_STACK_ARG(key,"key")
	HX_STACK_LINE(83)
	try
	{
	HX_STACK_CATCHABLE(::String, 0);
	{
		HX_STACK_LINE(84)
		::haxe::ds::TreeNode _g = this->removeLoop(key,this->root);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(84)
		this->root = _g;
		HX_STACK_LINE(85)
		return true;
	}
	}
	catch(Dynamic __e){
		if (__e.IsClass< ::String >() ){
			HX_STACK_BEGIN_CATCH
			::String e = __e;{
				HX_STACK_LINE(88)
				return false;
			}
		}
		else {
		    HX_STACK_DO_THROW(__e);
		}
	}
	HX_STACK_LINE(83)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC1(BalancedTree_obj,remove,return )

bool BalancedTree_obj::exists( Dynamic key){
	HX_STACK_FRAME("haxe.ds.BalancedTree","exists",0x238deccd,"haxe.ds.BalancedTree.exists","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",99,0xd9343842)
	HX_STACK_THIS(this)
	HX_STACK_ARG(key,"key")
	HX_STACK_LINE(100)
	::haxe::ds::TreeNode node = this->root;		HX_STACK_VAR(node,"node");
	HX_STACK_LINE(101)
	while((true)){
		HX_STACK_LINE(101)
		if ((!(((node != null()))))){
			HX_STACK_LINE(101)
			break;
		}
		HX_STACK_LINE(102)
		int c = this->compare(key,node->key);		HX_STACK_VAR(c,"c");
		HX_STACK_LINE(103)
		if (((c == (int)0))){
			HX_STACK_LINE(103)
			return true;
		}
		else{
			HX_STACK_LINE(104)
			if (((c < (int)0))){
				HX_STACK_LINE(104)
				node = node->left;
			}
			else{
				HX_STACK_LINE(105)
				node = node->right;
			}
		}
	}
	HX_STACK_LINE(107)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC1(BalancedTree_obj,exists,return )

Dynamic BalancedTree_obj::iterator( ){
	HX_STACK_FRAME("haxe.ds.BalancedTree","iterator",0x998e771f,"haxe.ds.BalancedTree.iterator","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",115,0xd9343842)
	HX_STACK_THIS(this)
	HX_STACK_LINE(116)
	Dynamic ret = Dynamic( Array_obj<Dynamic>::__new());		HX_STACK_VAR(ret,"ret");
	HX_STACK_LINE(117)
	this->iteratorLoop(this->root,ret);
	HX_STACK_LINE(118)
	return ret->__Field(HX_CSTRING("iterator"),true)();
}


HX_DEFINE_DYNAMIC_FUNC0(BalancedTree_obj,iterator,return )

Dynamic BalancedTree_obj::keys( ){
	HX_STACK_FRAME("haxe.ds.BalancedTree","keys",0xe94e62a5,"haxe.ds.BalancedTree.keys","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",126,0xd9343842)
	HX_STACK_THIS(this)
	HX_STACK_LINE(127)
	Dynamic ret = Dynamic( Array_obj<Dynamic>::__new());		HX_STACK_VAR(ret,"ret");
	HX_STACK_LINE(128)
	this->keysLoop(this->root,ret);
	HX_STACK_LINE(129)
	return ret->__Field(HX_CSTRING("iterator"),true)();
}


HX_DEFINE_DYNAMIC_FUNC0(BalancedTree_obj,keys,return )

::haxe::ds::TreeNode BalancedTree_obj::setLoop( Dynamic k,Dynamic v,::haxe::ds::TreeNode node){
	HX_STACK_FRAME("haxe.ds.BalancedTree","setLoop",0xe1a32b15,"haxe.ds.BalancedTree.setLoop","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",132,0xd9343842)
	HX_STACK_THIS(this)
	HX_STACK_ARG(k,"k")
	HX_STACK_ARG(v,"v")
	HX_STACK_ARG(node,"node")
	HX_STACK_LINE(133)
	if (((node == null()))){
		HX_STACK_LINE(133)
		return ::haxe::ds::TreeNode_obj::__new(null(),k,v,null(),null());
	}
	HX_STACK_LINE(134)
	int c = this->compare(k,node->key);		HX_STACK_VAR(c,"c");
	HX_STACK_LINE(135)
	if (((c == (int)0))){
		HX_STACK_LINE(135)
		return ::haxe::ds::TreeNode_obj::__new(node->left,k,v,node->right,(  (((node == null()))) ? int((int)0) : int(node->_height) ));
	}
	else{
		HX_STACK_LINE(136)
		if (((c < (int)0))){
			HX_STACK_LINE(137)
			::haxe::ds::TreeNode nl = this->setLoop(k,v,node->left);		HX_STACK_VAR(nl,"nl");
			HX_STACK_LINE(138)
			return this->balance(nl,node->key,node->value,node->right);
		}
		else{
			HX_STACK_LINE(140)
			::haxe::ds::TreeNode nr = this->setLoop(k,v,node->right);		HX_STACK_VAR(nr,"nr");
			HX_STACK_LINE(141)
			return this->balance(node->left,node->key,node->value,nr);
		}
	}
	HX_STACK_LINE(135)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC3(BalancedTree_obj,setLoop,return )

::haxe::ds::TreeNode BalancedTree_obj::removeLoop( Dynamic k,::haxe::ds::TreeNode node){
	HX_STACK_FRAME("haxe.ds.BalancedTree","removeLoop",0x52157c39,"haxe.ds.BalancedTree.removeLoop","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",145,0xd9343842)
	HX_STACK_THIS(this)
	HX_STACK_ARG(k,"k")
	HX_STACK_ARG(node,"node")
	HX_STACK_LINE(146)
	if (((node == null()))){
		HX_STACK_LINE(146)
		HX_STACK_DO_THROW(HX_CSTRING("Not_found"));
	}
	HX_STACK_LINE(147)
	int c = this->compare(k,node->key);		HX_STACK_VAR(c,"c");
	HX_STACK_LINE(148)
	if (((c == (int)0))){
		HX_STACK_LINE(148)
		return this->merge(node->left,node->right);
	}
	else{
		HX_STACK_LINE(149)
		if (((c < (int)0))){
			HX_STACK_LINE(149)
			::haxe::ds::TreeNode _g = this->removeLoop(k,node->left);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(149)
			return this->balance(_g,node->key,node->value,node->right);
		}
		else{
			HX_STACK_LINE(150)
			::haxe::ds::TreeNode _g1 = this->removeLoop(k,node->right);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(150)
			return this->balance(node->left,node->key,node->value,_g1);
		}
	}
	HX_STACK_LINE(148)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC2(BalancedTree_obj,removeLoop,return )

Void BalancedTree_obj::iteratorLoop( ::haxe::ds::TreeNode node,Dynamic acc){
{
		HX_STACK_FRAME("haxe.ds.BalancedTree","iteratorLoop",0x3392c523,"haxe.ds.BalancedTree.iteratorLoop","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",154,0xd9343842)
		HX_STACK_THIS(this)
		HX_STACK_ARG(node,"node")
		HX_STACK_ARG(acc,"acc")
		HX_STACK_LINE(154)
		if (((node != null()))){
			HX_STACK_LINE(155)
			this->iteratorLoop(node->left,acc);
			HX_STACK_LINE(156)
			acc->__Field(HX_CSTRING("push"),true)(node->value);
			HX_STACK_LINE(157)
			this->iteratorLoop(node->right,acc);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(BalancedTree_obj,iteratorLoop,(void))

Void BalancedTree_obj::keysLoop( ::haxe::ds::TreeNode node,Dynamic acc){
{
		HX_STACK_FRAME("haxe.ds.BalancedTree","keysLoop",0x20d5eba9,"haxe.ds.BalancedTree.keysLoop","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",162,0xd9343842)
		HX_STACK_THIS(this)
		HX_STACK_ARG(node,"node")
		HX_STACK_ARG(acc,"acc")
		HX_STACK_LINE(162)
		if (((node != null()))){
			HX_STACK_LINE(163)
			this->keysLoop(node->left,acc);
			HX_STACK_LINE(164)
			acc->__Field(HX_CSTRING("push"),true)(node->key);
			HX_STACK_LINE(165)
			this->keysLoop(node->right,acc);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(BalancedTree_obj,keysLoop,(void))

::haxe::ds::TreeNode BalancedTree_obj::merge( ::haxe::ds::TreeNode t1,::haxe::ds::TreeNode t2){
	HX_STACK_FRAME("haxe.ds.BalancedTree","merge",0x620fbce7,"haxe.ds.BalancedTree.merge","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",169,0xd9343842)
	HX_STACK_THIS(this)
	HX_STACK_ARG(t1,"t1")
	HX_STACK_ARG(t2,"t2")
	HX_STACK_LINE(170)
	if (((t1 == null()))){
		HX_STACK_LINE(170)
		return t2;
	}
	HX_STACK_LINE(171)
	if (((t2 == null()))){
		HX_STACK_LINE(171)
		return t1;
	}
	HX_STACK_LINE(172)
	::haxe::ds::TreeNode t = this->minBinding(t2);		HX_STACK_VAR(t,"t");
	HX_STACK_LINE(173)
	::haxe::ds::TreeNode _g = this->removeMinBinding(t2);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(173)
	return this->balance(t1,t->key,t->value,_g);
}


HX_DEFINE_DYNAMIC_FUNC2(BalancedTree_obj,merge,return )

::haxe::ds::TreeNode BalancedTree_obj::minBinding( ::haxe::ds::TreeNode t){
	HX_STACK_FRAME("haxe.ds.BalancedTree","minBinding",0xd2237344,"haxe.ds.BalancedTree.minBinding","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",177,0xd9343842)
	HX_STACK_THIS(this)
	HX_STACK_ARG(t,"t")
	HX_STACK_LINE(177)
	if (((t == null()))){
		HX_STACK_LINE(177)
		HX_STACK_DO_THROW(HX_CSTRING("Not_found"));
	}
	else{
		HX_STACK_LINE(178)
		if (((t->left == null()))){
			HX_STACK_LINE(178)
			return t;
		}
		else{
			HX_STACK_LINE(179)
			return this->minBinding(t->left);
		}
	}
	HX_STACK_LINE(177)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(BalancedTree_obj,minBinding,return )

::haxe::ds::TreeNode BalancedTree_obj::removeMinBinding( ::haxe::ds::TreeNode t){
	HX_STACK_FRAME("haxe.ds.BalancedTree","removeMinBinding",0xe82c3b68,"haxe.ds.BalancedTree.removeMinBinding","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",183,0xd9343842)
	HX_STACK_THIS(this)
	HX_STACK_ARG(t,"t")
	HX_STACK_LINE(183)
	if (((t->left == null()))){
		HX_STACK_LINE(183)
		return t->right;
	}
	else{
		HX_STACK_LINE(184)
		::haxe::ds::TreeNode _g = this->removeMinBinding(t->left);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(184)
		return this->balance(_g,t->key,t->value,t->right);
	}
	HX_STACK_LINE(183)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(BalancedTree_obj,removeMinBinding,return )

::haxe::ds::TreeNode BalancedTree_obj::balance( ::haxe::ds::TreeNode l,Dynamic k,Dynamic v,::haxe::ds::TreeNode r){
	HX_STACK_FRAME("haxe.ds.BalancedTree","balance",0xf7f4e10b,"haxe.ds.BalancedTree.balance","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",187,0xd9343842)
	HX_STACK_THIS(this)
	HX_STACK_ARG(l,"l")
	HX_STACK_ARG(k,"k")
	HX_STACK_ARG(v,"v")
	HX_STACK_ARG(r,"r")
	HX_STACK_LINE(188)
	int hl;		HX_STACK_VAR(hl,"hl");
	HX_STACK_LINE(188)
	if (((l == null()))){
		HX_STACK_LINE(188)
		hl = (int)0;
	}
	else{
		HX_STACK_LINE(188)
		hl = l->_height;
	}
	HX_STACK_LINE(189)
	int hr;		HX_STACK_VAR(hr,"hr");
	HX_STACK_LINE(189)
	if (((r == null()))){
		HX_STACK_LINE(189)
		hr = (int)0;
	}
	else{
		HX_STACK_LINE(189)
		hr = r->_height;
	}
	HX_STACK_LINE(190)
	if (((hl > (hr + (int)2)))){
		struct _Function_2_1{
			inline static int Block( ::haxe::ds::TreeNode &l){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",191,0xd9343842)
				{
					HX_STACK_LINE(191)
					::haxe::ds::TreeNode _this = l->left;		HX_STACK_VAR(_this,"_this");
					HX_STACK_LINE(191)
					return (  (((_this == null()))) ? int((int)0) : int(_this->_height) );
				}
				return null();
			}
		};
		struct _Function_2_2{
			inline static int Block( ::haxe::ds::TreeNode &l){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",191,0xd9343842)
				{
					HX_STACK_LINE(191)
					::haxe::ds::TreeNode _this = l->right;		HX_STACK_VAR(_this,"_this");
					HX_STACK_LINE(191)
					return (  (((_this == null()))) ? int((int)0) : int(_this->_height) );
				}
				return null();
			}
		};
		HX_STACK_LINE(191)
		if (((_Function_2_1::Block(l) >= _Function_2_2::Block(l)))){
			HX_STACK_LINE(191)
			::haxe::ds::TreeNode _g = ::haxe::ds::TreeNode_obj::__new(l->right,k,v,r,null());		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(191)
			return ::haxe::ds::TreeNode_obj::__new(l->left,l->key,l->value,_g,null());
		}
		else{
			HX_STACK_LINE(192)
			::haxe::ds::TreeNode _g1 = ::haxe::ds::TreeNode_obj::__new(l->left,l->key,l->value,l->right->left,null());		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(192)
			::haxe::ds::TreeNode _g2 = ::haxe::ds::TreeNode_obj::__new(l->right->right,k,v,r,null());		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(192)
			return ::haxe::ds::TreeNode_obj::__new(_g1,l->right->key,l->right->value,_g2,null());
		}
	}
	else{
		HX_STACK_LINE(193)
		if (((hr > (hl + (int)2)))){
			struct _Function_3_1{
				inline static int Block( ::haxe::ds::TreeNode &r){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",194,0xd9343842)
					{
						HX_STACK_LINE(194)
						::haxe::ds::TreeNode _this = r->right;		HX_STACK_VAR(_this,"_this");
						HX_STACK_LINE(194)
						return (  (((_this == null()))) ? int((int)0) : int(_this->_height) );
					}
					return null();
				}
			};
			struct _Function_3_2{
				inline static int Block( ::haxe::ds::TreeNode &r){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",194,0xd9343842)
					{
						HX_STACK_LINE(194)
						::haxe::ds::TreeNode _this = r->left;		HX_STACK_VAR(_this,"_this");
						HX_STACK_LINE(194)
						return (  (((_this == null()))) ? int((int)0) : int(_this->_height) );
					}
					return null();
				}
			};
			HX_STACK_LINE(194)
			if (((_Function_3_1::Block(r) > _Function_3_2::Block(r)))){
				HX_STACK_LINE(194)
				::haxe::ds::TreeNode _g3 = ::haxe::ds::TreeNode_obj::__new(l,k,v,r->left,null());		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(194)
				return ::haxe::ds::TreeNode_obj::__new(_g3,r->key,r->value,r->right,null());
			}
			else{
				HX_STACK_LINE(195)
				::haxe::ds::TreeNode _g4 = ::haxe::ds::TreeNode_obj::__new(l,k,v,r->left->left,null());		HX_STACK_VAR(_g4,"_g4");
				HX_STACK_LINE(195)
				::haxe::ds::TreeNode _g5 = ::haxe::ds::TreeNode_obj::__new(r->left->right,r->key,r->value,r->right,null());		HX_STACK_VAR(_g5,"_g5");
				HX_STACK_LINE(195)
				return ::haxe::ds::TreeNode_obj::__new(_g4,r->left->key,r->left->value,_g5,null());
			}
		}
		else{
			HX_STACK_LINE(197)
			return ::haxe::ds::TreeNode_obj::__new(l,k,v,r,(((  (((hl > hr))) ? int(hl) : int(hr) )) + (int)1));
		}
	}
	HX_STACK_LINE(190)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC4(BalancedTree_obj,balance,return )

int BalancedTree_obj::compare( Dynamic k1,Dynamic k2){
	HX_STACK_FRAME("haxe.ds.BalancedTree","compare",0x57d05c94,"haxe.ds.BalancedTree.compare","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",202,0xd9343842)
	HX_STACK_THIS(this)
	HX_STACK_ARG(k1,"k1")
	HX_STACK_ARG(k2,"k2")
	HX_STACK_LINE(202)
	return ::Reflect_obj::compare(k1,k2);
}


HX_DEFINE_DYNAMIC_FUNC2(BalancedTree_obj,compare,return )

::String BalancedTree_obj::toString( ){
	HX_STACK_FRAME("haxe.ds.BalancedTree","toString",0x3e62fddd,"haxe.ds.BalancedTree.toString","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/BalancedTree.hx",205,0xd9343842)
	HX_STACK_THIS(this)
	HX_STACK_LINE(206)
	::String _g = this->root->toString();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(206)
	::String _g1 = (HX_CSTRING("{") + _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(206)
	return (_g1 + HX_CSTRING("}"));
}


HX_DEFINE_DYNAMIC_FUNC0(BalancedTree_obj,toString,return )


BalancedTree_obj::BalancedTree_obj()
{
}

void BalancedTree_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(BalancedTree);
	HX_MARK_MEMBER_NAME(root,"root");
	HX_MARK_END_CLASS();
}

void BalancedTree_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(root,"root");
}

Dynamic BalancedTree_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"set") ) { return set_dyn(); }
		if (HX_FIELD_EQ(inName,"get") ) { return get_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"root") ) { return root; }
		if (HX_FIELD_EQ(inName,"keys") ) { return keys_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"merge") ) { return merge_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"remove") ) { return remove_dyn(); }
		if (HX_FIELD_EQ(inName,"exists") ) { return exists_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"setLoop") ) { return setLoop_dyn(); }
		if (HX_FIELD_EQ(inName,"balance") ) { return balance_dyn(); }
		if (HX_FIELD_EQ(inName,"compare") ) { return compare_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"iterator") ) { return iterator_dyn(); }
		if (HX_FIELD_EQ(inName,"keysLoop") ) { return keysLoop_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"removeLoop") ) { return removeLoop_dyn(); }
		if (HX_FIELD_EQ(inName,"minBinding") ) { return minBinding_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"iteratorLoop") ) { return iteratorLoop_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"removeMinBinding") ) { return removeMinBinding_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic BalancedTree_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"root") ) { root=inValue.Cast< ::haxe::ds::TreeNode >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void BalancedTree_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("root"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::haxe::ds::TreeNode*/ ,(int)offsetof(BalancedTree_obj,root),HX_CSTRING("root")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("root"),
	HX_CSTRING("set"),
	HX_CSTRING("get"),
	HX_CSTRING("remove"),
	HX_CSTRING("exists"),
	HX_CSTRING("iterator"),
	HX_CSTRING("keys"),
	HX_CSTRING("setLoop"),
	HX_CSTRING("removeLoop"),
	HX_CSTRING("iteratorLoop"),
	HX_CSTRING("keysLoop"),
	HX_CSTRING("merge"),
	HX_CSTRING("minBinding"),
	HX_CSTRING("removeMinBinding"),
	HX_CSTRING("balance"),
	HX_CSTRING("compare"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(BalancedTree_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(BalancedTree_obj::__mClass,"__mClass");
};

#endif

Class BalancedTree_obj::__mClass;

void BalancedTree_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.ds.BalancedTree"), hx::TCanCast< BalancedTree_obj> ,sStaticFields,sMemberFields,
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

void BalancedTree_obj::__boot()
{
}

} // end namespace haxe
} // end namespace ds
