#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_Type
#include <Type.h>
#endif
#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
#endif
#ifndef INCLUDED_h3d_Quat
#include <h3d/Quat.h>
#endif
#ifndef INCLUDED_h3d_Vector
#include <h3d/Vector.h>
#endif
#ifndef INCLUDED_h3d_anim_Animation
#include <h3d/anim/Animation.h>
#endif
#ifndef INCLUDED_h3d_col_Bounds
#include <h3d/col/Bounds.h>
#endif
#ifndef INCLUDED_h3d_scene_Mesh
#include <h3d/scene/Mesh.h>
#endif
#ifndef INCLUDED_h3d_scene_Object
#include <h3d/scene/Object.h>
#endif
#ifndef INCLUDED_h3d_scene_RenderContext
#include <h3d/scene/RenderContext.h>
#endif
#ifndef INCLUDED_haxe_Timer
#include <haxe/Timer.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
#ifndef INCLUDED_hxd_Profiler
#include <hxd/Profiler.h>
#endif
#ifndef INCLUDED_hxd_impl_ArrayIterator
#include <hxd/impl/ArrayIterator.h>
#endif
namespace h3d{
namespace scene{

Void Object_obj::__construct(::h3d::scene::Object parent)
{
HX_STACK_FRAME("h3d.scene.Object","new",0xf5a97c08,"h3d.scene.Object.new","h3d/scene/Object.hx",5,0x76367d66)
HX_STACK_THIS(this)
HX_STACK_ARG(parent,"parent")
{
	HX_STACK_LINE(21)
	this->visible = true;
	HX_STACK_LINE(45)
	::h3d::Matrix _g = ::h3d::Matrix_obj::__new();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(45)
	this->absPos = _g;
	HX_STACK_LINE(46)
	this->absPos->identity();
	HX_STACK_LINE(47)
	{
		HX_STACK_LINE(47)
		this->x = (int)0;
		HX_STACK_LINE(47)
		this->posChanged = true;
		HX_STACK_LINE(47)
		(int)0;
	}
	HX_STACK_LINE(47)
	{
		HX_STACK_LINE(47)
		this->y = (int)0;
		HX_STACK_LINE(47)
		this->posChanged = true;
		HX_STACK_LINE(47)
		(int)0;
	}
	HX_STACK_LINE(47)
	{
		HX_STACK_LINE(47)
		this->z = (int)0;
		HX_STACK_LINE(47)
		this->posChanged = true;
		HX_STACK_LINE(47)
		(int)0;
	}
	HX_STACK_LINE(47)
	{
		HX_STACK_LINE(47)
		this->scaleX = (int)1;
		HX_STACK_LINE(47)
		this->posChanged = true;
		HX_STACK_LINE(47)
		(int)1;
	}
	HX_STACK_LINE(47)
	{
		HX_STACK_LINE(47)
		this->scaleY = (int)1;
		HX_STACK_LINE(47)
		this->posChanged = true;
		HX_STACK_LINE(47)
		(int)1;
	}
	HX_STACK_LINE(47)
	{
		HX_STACK_LINE(47)
		this->scaleZ = (int)1;
		HX_STACK_LINE(47)
		this->posChanged = true;
		HX_STACK_LINE(47)
		(int)1;
	}
	HX_STACK_LINE(48)
	::h3d::Quat _g1 = ::h3d::Quat_obj::__new(null(),null(),null(),null());		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(48)
	this->qRot = _g1;
	HX_STACK_LINE(49)
	this->posChanged = false;
	HX_STACK_LINE(50)
	this->childs = Array_obj< ::Dynamic >::__new();
	HX_STACK_LINE(51)
	if (((parent != null()))){
		HX_STACK_LINE(51)
		parent->addChild(hx::ObjectPtr<OBJ_>(this));
	}
	HX_STACK_LINE(52)
	Array< ::Dynamic > _g3;		HX_STACK_VAR(_g3,"_g3");
	struct _Function_1_1{
		inline static Array< ::Dynamic > Block( ){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/scene/Object.hx",52,0x76367d66)
			{
				HX_STACK_LINE(52)
				Array< ::Dynamic > this1;		HX_STACK_VAR(this1,"this1");
				HX_STACK_LINE(52)
				Array< ::Dynamic > _g2 = Array_obj< ::Dynamic >::__new()->__SetSizeExact((int)4);		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(52)
				this1 = _g2;
				HX_STACK_LINE(52)
				return this1;
			}
			return null();
		}
	};
	HX_STACK_LINE(52)
	_g3 = _Function_1_1::Block();
	HX_STACK_LINE(52)
	this->animations = _g3;
}
;
	return null();
}

//Object_obj::~Object_obj() { }

Dynamic Object_obj::__CreateEmpty() { return  new Object_obj; }
hx::ObjectPtr< Object_obj > Object_obj::__new(::h3d::scene::Object parent)
{  hx::ObjectPtr< Object_obj > result = new Object_obj();
	result->__construct(parent);
	return result;}

Dynamic Object_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Object_obj > result = new Object_obj();
	result->__construct(inArgs[0]);
	return result;}

::h3d::anim::Animation Object_obj::get_currentAnimation( ){
	HX_STACK_FRAME("h3d.scene.Object","get_currentAnimation",0xe9fe7fec,"h3d.scene.Object.get_currentAnimation","h3d/scene/Object.hx",56,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_LINE(56)
	return this->animations->__unsafe_get((int)0);
}


HX_DEFINE_DYNAMIC_FUNC0(Object_obj,get_currentAnimation,return )

::h3d::anim::Animation Object_obj::playAnimation( ::h3d::anim::Animation a,hx::Null< int >  __o_slot){
int slot = __o_slot.Default(0);
	HX_STACK_FRAME("h3d.scene.Object","playAnimation",0xdaaa1018,"h3d.scene.Object.playAnimation","h3d/scene/Object.hx",60,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(slot,"slot")
{
		HX_STACK_LINE(60)
		::h3d::anim::Animation val = a->createInstance(hx::ObjectPtr<OBJ_>(this));		HX_STACK_VAR(val,"val");
		HX_STACK_LINE(60)
		return this->animations->__unsafe_set(slot,val);
	}
}


HX_DEFINE_DYNAMIC_FUNC2(Object_obj,playAnimation,return )

::h3d::anim::Animation Object_obj::switchToAnimation( ::h3d::anim::Animation a,hx::Null< int >  __o_slot){
int slot = __o_slot.Default(0);
	HX_STACK_FRAME("h3d.scene.Object","switchToAnimation",0x9b168e1d,"h3d.scene.Object.switchToAnimation","h3d/scene/Object.hx",67,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(slot,"slot")
{
		HX_STACK_LINE(67)
		return this->animations->__unsafe_set(slot,a);
	}
}


HX_DEFINE_DYNAMIC_FUNC2(Object_obj,switchToAnimation,return )

Void Object_obj::stopAnimation( hx::Null< int >  __o_slot){
int slot = __o_slot.Default(0);
	HX_STACK_FRAME("h3d.scene.Object","stopAnimation",0x03729c4a,"h3d.scene.Object.stopAnimation","h3d/scene/Object.hx",71,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_ARG(slot,"slot")
{
		HX_STACK_LINE(71)
		this->animations->__unsafe_set(slot,null());
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Object_obj,stopAnimation,(void))

int Object_obj::getObjectsCount( ){
	HX_STACK_FRAME("h3d.scene.Object","getObjectsCount",0x1bf7a8b9,"h3d.scene.Object.getObjectsCount","h3d/scene/Object.hx",74,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_LINE(75)
	int k = (int)0;		HX_STACK_VAR(k,"k");
	HX_STACK_LINE(76)
	{
		HX_STACK_LINE(76)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(76)
		Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(76)
		while((true)){
			HX_STACK_LINE(76)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(76)
				break;
			}
			HX_STACK_LINE(76)
			::h3d::scene::Object c = _g1->__get(_g).StaticCast< ::h3d::scene::Object >();		HX_STACK_VAR(c,"c");
			HX_STACK_LINE(76)
			++(_g);
			HX_STACK_LINE(77)
			int _g2 = c->getObjectsCount();		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(77)
			int _g11 = (_g2 + (int)1);		HX_STACK_VAR(_g11,"_g11");
			HX_STACK_LINE(77)
			hx::AddEq(k,_g11);
		}
	}
	HX_STACK_LINE(78)
	return k;
}


HX_DEFINE_DYNAMIC_FUNC0(Object_obj,getObjectsCount,return )

::h3d::Vector Object_obj::localToGlobal( ::h3d::Vector pt){
	HX_STACK_FRAME("h3d.scene.Object","localToGlobal",0x3d1b0f71,"h3d.scene.Object.localToGlobal","h3d/scene/Object.hx",84,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_ARG(pt,"pt")
	HX_STACK_LINE(85)
	this->syncPos();
	HX_STACK_LINE(86)
	if (((pt == null()))){
		HX_STACK_LINE(86)
		::h3d::Vector _g = ::h3d::Vector_obj::__new(null(),null(),null(),null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(86)
		pt = _g;
	}
	HX_STACK_LINE(87)
	{
		HX_STACK_LINE(87)
		::h3d::Matrix m = this->absPos;		HX_STACK_VAR(m,"m");
		HX_STACK_LINE(87)
		Float px = ((((pt->x * m->_11) + (pt->y * m->_21)) + (pt->z * m->_31)) + (pt->w * m->_41));		HX_STACK_VAR(px,"px");
		HX_STACK_LINE(87)
		Float py = ((((pt->x * m->_12) + (pt->y * m->_22)) + (pt->z * m->_32)) + (pt->w * m->_42));		HX_STACK_VAR(py,"py");
		HX_STACK_LINE(87)
		Float pz = ((((pt->x * m->_13) + (pt->y * m->_23)) + (pt->z * m->_33)) + (pt->w * m->_43));		HX_STACK_VAR(pz,"pz");
		HX_STACK_LINE(87)
		pt->x = px;
		HX_STACK_LINE(87)
		pt->y = py;
		HX_STACK_LINE(87)
		pt->z = pz;
	}
	HX_STACK_LINE(88)
	return pt;
}


HX_DEFINE_DYNAMIC_FUNC1(Object_obj,localToGlobal,return )

::h3d::Vector Object_obj::globalToLocal( ::h3d::Vector pt){
	HX_STACK_FRAME("h3d.scene.Object","globalToLocal",0x60de1c75,"h3d.scene.Object.globalToLocal","h3d/scene/Object.hx",94,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_ARG(pt,"pt")
	HX_STACK_LINE(95)
	this->syncPos();
	HX_STACK_LINE(96)
	{
		HX_STACK_LINE(96)
		::h3d::Matrix m = this->getInvPos();		HX_STACK_VAR(m,"m");
		HX_STACK_LINE(96)
		Float px = ((((pt->x * m->_11) + (pt->y * m->_21)) + (pt->z * m->_31)) + (pt->w * m->_41));		HX_STACK_VAR(px,"px");
		HX_STACK_LINE(96)
		Float py = ((((pt->x * m->_12) + (pt->y * m->_22)) + (pt->z * m->_32)) + (pt->w * m->_42));		HX_STACK_VAR(py,"py");
		HX_STACK_LINE(96)
		Float pz = ((((pt->x * m->_13) + (pt->y * m->_23)) + (pt->z * m->_33)) + (pt->w * m->_43));		HX_STACK_VAR(pz,"pz");
		HX_STACK_LINE(96)
		pt->x = px;
		HX_STACK_LINE(96)
		pt->y = py;
		HX_STACK_LINE(96)
		pt->z = pz;
	}
	HX_STACK_LINE(97)
	return pt;
}


HX_DEFINE_DYNAMIC_FUNC1(Object_obj,globalToLocal,return )

::h3d::Matrix Object_obj::getInvPos( ){
	HX_STACK_FRAME("h3d.scene.Object","getInvPos",0x5f9d5801,"h3d.scene.Object.getInvPos","h3d/scene/Object.hx",100,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_LINE(101)
	if (((this->invPos == null()))){
		HX_STACK_LINE(102)
		::h3d::Matrix _g = ::h3d::Matrix_obj::__new();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(102)
		this->invPos = _g;
		HX_STACK_LINE(103)
		this->invPos->_44 = (int)0;
	}
	HX_STACK_LINE(105)
	if (((this->invPos->_44 == (int)0))){
		HX_STACK_LINE(106)
		this->invPos->inverse3x4(this->absPos);
	}
	HX_STACK_LINE(107)
	return this->invPos;
}


HX_DEFINE_DYNAMIC_FUNC0(Object_obj,getInvPos,return )

::h3d::col::Bounds Object_obj::getBounds( ::h3d::col::Bounds b){
	HX_STACK_FRAME("h3d.scene.Object","getBounds",0x25f1e953,"h3d.scene.Object.getBounds","h3d/scene/Object.hx",110,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(111)
	if (((b == null()))){
		HX_STACK_LINE(112)
		::h3d::col::Bounds _g = ::h3d::col::Bounds_obj::__new();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(112)
		b = _g;
		HX_STACK_LINE(113)
		this->syncPos();
	}
	else{
		HX_STACK_LINE(114)
		if ((this->posChanged)){
			HX_STACK_LINE(115)
			{
				HX_STACK_LINE(115)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(115)
				Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(115)
				while((true)){
					HX_STACK_LINE(115)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(115)
						break;
					}
					HX_STACK_LINE(115)
					::h3d::scene::Object c = _g1->__get(_g).StaticCast< ::h3d::scene::Object >();		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(115)
					++(_g);
					HX_STACK_LINE(116)
					c->posChanged = true;
				}
			}
			HX_STACK_LINE(117)
			this->calcAbsPos();
			HX_STACK_LINE(118)
			this->posChanged = false;
		}
	}
	HX_STACK_LINE(120)
	{
		HX_STACK_LINE(120)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(120)
		Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(120)
		while((true)){
			HX_STACK_LINE(120)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(120)
				break;
			}
			HX_STACK_LINE(120)
			::h3d::scene::Object c = _g1->__get(_g).StaticCast< ::h3d::scene::Object >();		HX_STACK_VAR(c,"c");
			HX_STACK_LINE(120)
			++(_g);
			HX_STACK_LINE(121)
			c->getBounds(b);
		}
	}
	HX_STACK_LINE(122)
	return b;
}


HX_DEFINE_DYNAMIC_FUNC1(Object_obj,getBounds,return )

::h3d::scene::Object Object_obj::getObjectByName( ::String name){
	HX_STACK_FRAME("h3d.scene.Object","getObjectByName",0x863f153f,"h3d.scene.Object.getObjectByName","h3d/scene/Object.hx",125,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(126)
	if (((this->name == name))){
		HX_STACK_LINE(127)
		return hx::ObjectPtr<OBJ_>(this);
	}
	HX_STACK_LINE(128)
	{
		HX_STACK_LINE(128)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(128)
		Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(128)
		while((true)){
			HX_STACK_LINE(128)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(128)
				break;
			}
			HX_STACK_LINE(128)
			::h3d::scene::Object c = _g1->__get(_g).StaticCast< ::h3d::scene::Object >();		HX_STACK_VAR(c,"c");
			HX_STACK_LINE(128)
			++(_g);
			HX_STACK_LINE(129)
			::h3d::scene::Object o = c->getObjectByName(name);		HX_STACK_VAR(o,"o");
			HX_STACK_LINE(130)
			if (((o != null()))){
				HX_STACK_LINE(130)
				return o;
			}
		}
	}
	HX_STACK_LINE(132)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Object_obj,getObjectByName,return )

::h3d::scene::Object Object_obj::clone( ::h3d::scene::Object o){
	HX_STACK_FRAME("h3d.scene.Object","clone",0x7f38f905,"h3d.scene.Object.clone","h3d/scene/Object.hx",135,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_ARG(o,"o")
	HX_STACK_LINE(136)
	if (((o == null()))){
		HX_STACK_LINE(136)
		::h3d::scene::Object _g = ::h3d::scene::Object_obj::__new(null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(136)
		o = _g;
	}
	HX_STACK_LINE(137)
	{
		HX_STACK_LINE(137)
		Float v = this->x;		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(137)
		o->x = v;
		HX_STACK_LINE(137)
		o->posChanged = true;
		HX_STACK_LINE(137)
		v;
	}
	HX_STACK_LINE(138)
	{
		HX_STACK_LINE(138)
		Float v = this->y;		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(138)
		o->y = v;
		HX_STACK_LINE(138)
		o->posChanged = true;
		HX_STACK_LINE(138)
		v;
	}
	HX_STACK_LINE(139)
	{
		HX_STACK_LINE(139)
		Float v = this->z;		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(139)
		o->z = v;
		HX_STACK_LINE(139)
		o->posChanged = true;
		HX_STACK_LINE(139)
		v;
	}
	HX_STACK_LINE(140)
	{
		HX_STACK_LINE(140)
		Float v = this->scaleX;		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(140)
		o->scaleX = v;
		HX_STACK_LINE(140)
		o->posChanged = true;
		HX_STACK_LINE(140)
		v;
	}
	HX_STACK_LINE(141)
	{
		HX_STACK_LINE(141)
		Float v = this->scaleY;		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(141)
		o->scaleY = v;
		HX_STACK_LINE(141)
		o->posChanged = true;
		HX_STACK_LINE(141)
		v;
	}
	HX_STACK_LINE(142)
	{
		HX_STACK_LINE(142)
		Float v = this->scaleZ;		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(142)
		o->scaleZ = v;
		HX_STACK_LINE(142)
		o->posChanged = true;
		HX_STACK_LINE(142)
		v;
	}
	HX_STACK_LINE(143)
	o->name = this->name;
	HX_STACK_LINE(144)
	o->qRot = this->qRot;
	HX_STACK_LINE(146)
	if (((this->defaultTransform != null()))){
		HX_STACK_LINE(147)
		::h3d::Matrix v = this->defaultTransform->clone();		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(147)
		o->defaultTransform = v;
		HX_STACK_LINE(147)
		o->posChanged = true;
		HX_STACK_LINE(147)
		v;
	}
	HX_STACK_LINE(148)
	{
		HX_STACK_LINE(148)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(148)
		Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(148)
		while((true)){
			HX_STACK_LINE(148)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(148)
				break;
			}
			HX_STACK_LINE(148)
			::h3d::scene::Object c = _g1->__get(_g).StaticCast< ::h3d::scene::Object >();		HX_STACK_VAR(c,"c");
			HX_STACK_LINE(148)
			++(_g);
			HX_STACK_LINE(149)
			::h3d::scene::Object c1 = c->clone(null());		HX_STACK_VAR(c1,"c1");
			HX_STACK_LINE(150)
			c1->parent = o;
			HX_STACK_LINE(151)
			o->childs->push(c1);
		}
	}
	HX_STACK_LINE(153)
	return o;
}


HX_DEFINE_DYNAMIC_FUNC1(Object_obj,clone,return )

Void Object_obj::addChild( ::h3d::scene::Object o){
{
		HX_STACK_FRAME("h3d.scene.Object","addChild",0x8849e313,"h3d.scene.Object.addChild","h3d/scene/Object.hx",157,0x76367d66)
		HX_STACK_THIS(this)
		HX_STACK_ARG(o,"o")
		HX_STACK_LINE(157)
		this->addChildAt(o,this->childs->length);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Object_obj,addChild,(void))

Void Object_obj::addChildAt( ::h3d::scene::Object o,int pos){
{
		HX_STACK_FRAME("h3d.scene.Object","addChildAt",0x98d746e6,"h3d.scene.Object.addChildAt","h3d/scene/Object.hx",160,0x76367d66)
		HX_STACK_THIS(this)
		HX_STACK_ARG(o,"o")
		HX_STACK_ARG(pos,"pos")
		HX_STACK_LINE(161)
		if (((pos < (int)0))){
			HX_STACK_LINE(161)
			pos = (int)0;
		}
		HX_STACK_LINE(162)
		if (((pos > this->childs->length))){
			HX_STACK_LINE(162)
			pos = this->childs->length;
		}
		HX_STACK_LINE(163)
		::h3d::scene::Object p = hx::ObjectPtr<OBJ_>(this);		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(164)
		while((true)){
			HX_STACK_LINE(164)
			if ((!(((p != null()))))){
				HX_STACK_LINE(164)
				break;
			}
			HX_STACK_LINE(165)
			if (((p == o))){
				HX_STACK_LINE(165)
				HX_STACK_DO_THROW(HX_CSTRING("Recursive addChild"));
			}
			HX_STACK_LINE(166)
			p = p->parent;
		}
		HX_STACK_LINE(168)
		if (((o->parent != null()))){
			HX_STACK_LINE(169)
			o->parent->removeChild(o);
		}
		HX_STACK_LINE(170)
		this->childs->insert(pos,o);
		HX_STACK_LINE(171)
		o->parent = hx::ObjectPtr<OBJ_>(this);
		HX_STACK_LINE(172)
		o->lastFrame = (int)-1;
		HX_STACK_LINE(173)
		o->posChanged = true;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Object_obj,addChildAt,(void))

Void Object_obj::removeChild( ::h3d::scene::Object o){
{
		HX_STACK_FRAME("h3d.scene.Object","removeChild",0xc5d31a60,"h3d.scene.Object.removeChild","h3d/scene/Object.hx",177,0x76367d66)
		HX_STACK_THIS(this)
		HX_STACK_ARG(o,"o")
		HX_STACK_LINE(177)
		if ((this->childs->remove(o))){
			HX_STACK_LINE(178)
			o->parent = null();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Object_obj,removeChild,(void))

bool Object_obj::isMesh( ){
	HX_STACK_FRAME("h3d.scene.Object","isMesh",0x2a131c4f,"h3d.scene.Object.isMesh","h3d/scene/Object.hx",182,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_LINE(182)
	return ::Std_obj::is(hx::ObjectPtr<OBJ_>(this),hx::ClassOf< ::h3d::scene::Mesh >());
}


HX_DEFINE_DYNAMIC_FUNC0(Object_obj,isMesh,return )

::h3d::scene::Mesh Object_obj::toMesh( ){
	HX_STACK_FRAME("h3d.scene.Object","toMesh",0x4265c260,"h3d.scene.Object.toMesh","h3d/scene/Object.hx",185,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_LINE(186)
	if ((::Std_obj::is(hx::ObjectPtr<OBJ_>(this),hx::ClassOf< ::h3d::scene::Mesh >()))){
		HX_STACK_LINE(187)
		return hx::ObjectPtr<OBJ_>(this);
	}
	HX_STACK_LINE(188)
	HX_STACK_DO_THROW((((  (((this->name == null()))) ? ::String(HX_CSTRING("Object")) : ::String(this->name) )) + HX_CSTRING(" is not a Mesh")));
	HX_STACK_LINE(188)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Object_obj,toMesh,return )

Void Object_obj::remove( ){
{
		HX_STACK_FRAME("h3d.scene.Object","remove",0xc8dba99c,"h3d.scene.Object.remove","h3d/scene/Object.hx",193,0x76367d66)
		HX_STACK_THIS(this)
		HX_STACK_LINE(193)
		if (((this->parent != null()))){
			HX_STACK_LINE(193)
			this->parent->removeChild(hx::ObjectPtr<OBJ_>(this));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Object_obj,remove,(void))

Void Object_obj::draw( ::h3d::scene::RenderContext ctx){
{
		HX_STACK_FRAME("h3d.scene.Object","draw",0xf810b35c,"h3d.scene.Object.draw","h3d/scene/Object.hx",197,0x76367d66)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ctx,"ctx")
		HX_STACK_LINE(197)
		ctx->localPos = this->absPos;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Object_obj,draw,(void))

::h3d::scene::Object Object_obj::set_follow( ::h3d::scene::Object v){
	HX_STACK_FRAME("h3d.scene.Object","set_follow",0xb83c3906,"h3d.scene.Object.set_follow","h3d/scene/Object.hx",201,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(202)
	this->posChanged = true;
	HX_STACK_LINE(203)
	return this->follow = v;
}


HX_DEFINE_DYNAMIC_FUNC1(Object_obj,set_follow,return )

Void Object_obj::calcAbsPos( ){
{
		HX_STACK_FRAME("h3d.scene.Object","calcAbsPos",0x01b2bc0f,"h3d.scene.Object.calcAbsPos","h3d/scene/Object.hx",206,0x76367d66)
		HX_STACK_THIS(this)
		HX_STACK_LINE(207)
		if ((::hxd::Profiler_obj::enable)){
			HX_STACK_LINE(207)
			Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
			HX_STACK_LINE(207)
			Dynamic ent = ::hxd::Profiler_obj::h->get(HX_CSTRING("Object:calcAbsPos"));		HX_STACK_VAR(ent,"ent");
			HX_STACK_LINE(207)
			if (((null() == ent))){
				struct _Function_3_1{
					inline static Dynamic Block( ){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/scene/Object.hx",207,0x76367d66)
						{
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("start") , null(),false);
							__result->Add(HX_CSTRING("total") , 0.0,false);
							__result->Add(HX_CSTRING("hit") , (int)0,false);
							return __result;
						}
						return null();
					}
				};
				HX_STACK_LINE(207)
				ent = _Function_3_1::Block();
				HX_STACK_LINE(207)
				::hxd::Profiler_obj::h->set(HX_CSTRING("Object:calcAbsPos"),ent);
			}
			HX_STACK_LINE(207)
			ent->__FieldRef(HX_CSTRING("start")) = t;
			HX_STACK_LINE(207)
			(ent->__FieldRef(HX_CSTRING("hit")))++;
		}
		HX_STACK_LINE(209)
		this->qRot->saveToMatrix(this->absPos);
		HX_STACK_LINE(211)
		hx::MultEq(this->absPos->_11,this->scaleX);
		HX_STACK_LINE(212)
		hx::MultEq(this->absPos->_12,this->scaleX);
		HX_STACK_LINE(213)
		hx::MultEq(this->absPos->_13,this->scaleX);
		HX_STACK_LINE(214)
		hx::MultEq(this->absPos->_21,this->scaleY);
		HX_STACK_LINE(215)
		hx::MultEq(this->absPos->_22,this->scaleY);
		HX_STACK_LINE(216)
		hx::MultEq(this->absPos->_23,this->scaleY);
		HX_STACK_LINE(217)
		hx::MultEq(this->absPos->_31,this->scaleZ);
		HX_STACK_LINE(218)
		hx::MultEq(this->absPos->_32,this->scaleZ);
		HX_STACK_LINE(219)
		hx::MultEq(this->absPos->_33,this->scaleZ);
		HX_STACK_LINE(220)
		this->absPos->_41 = this->x;
		HX_STACK_LINE(221)
		this->absPos->_42 = this->y;
		HX_STACK_LINE(222)
		this->absPos->_43 = this->z;
		HX_STACK_LINE(223)
		if (((this->follow != null()))){
			HX_STACK_LINE(224)
			this->follow->syncPos();
			HX_STACK_LINE(225)
			this->absPos->multiply3x4(this->absPos,this->follow->absPos);
			HX_STACK_LINE(226)
			this->posChanged = true;
		}
		else{
			HX_STACK_LINE(228)
			if (((this->defaultTransform != null()))){
				HX_STACK_LINE(229)
				this->absPos->multiply3x4(this->absPos,this->defaultTransform);
			}
			HX_STACK_LINE(230)
			if (((this->parent != null()))){
				HX_STACK_LINE(231)
				this->absPos->multiply3x4(this->absPos,this->parent->absPos);
			}
		}
		HX_STACK_LINE(233)
		if (((this->invPos != null()))){
			HX_STACK_LINE(234)
			this->invPos->_44 = (int)0;
		}
		HX_STACK_LINE(236)
		if ((::hxd::Profiler_obj::enable)){
			HX_STACK_LINE(236)
			Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
			HX_STACK_LINE(236)
			Dynamic ent = ::hxd::Profiler_obj::h->get(HX_CSTRING("Object:calcAbsPos"));		HX_STACK_VAR(ent,"ent");
			HX_STACK_LINE(236)
			if (((null() != ent))){
				HX_STACK_LINE(236)
				if (((ent->__Field(HX_CSTRING("start"),true) != null()))){
					HX_STACK_LINE(236)
					hx::AddEq(ent->__FieldRef(HX_CSTRING("total")),(t - ent->__Field(HX_CSTRING("start"),true)));
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Object_obj,calcAbsPos,(void))

Void Object_obj::sync( ::h3d::scene::RenderContext ctx){
{
		HX_STACK_FRAME("h3d.scene.Object","sync",0x020041b3,"h3d.scene.Object.sync","h3d/scene/Object.hx",239,0x76367d66)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ctx,"ctx")
		HX_STACK_LINE(241)
		{
			HX_STACK_LINE(241)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(241)
			Array< ::Dynamic > _g1 = this->animations;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(241)
			while((true)){
				HX_STACK_LINE(241)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(241)
					break;
				}
				HX_STACK_LINE(241)
				::h3d::anim::Animation ca = _g1->__unsafe_get(_g);		HX_STACK_VAR(ca,"ca");
				HX_STACK_LINE(241)
				++(_g);
				HX_STACK_LINE(242)
				if (((ca == null()))){
					HX_STACK_LINE(242)
					continue;
				}
				HX_STACK_LINE(244)
				if ((::hxd::Profiler_obj::enable)){
					HX_STACK_LINE(244)
					Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
					HX_STACK_LINE(244)
					Dynamic ent = ::hxd::Profiler_obj::h->get(HX_CSTRING("Object:sync.animation"));		HX_STACK_VAR(ent,"ent");
					HX_STACK_LINE(244)
					if (((null() == ent))){
						struct _Function_5_1{
							inline static Dynamic Block( ){
								HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/scene/Object.hx",244,0x76367d66)
								{
									hx::Anon __result = hx::Anon_obj::Create();
									__result->Add(HX_CSTRING("start") , null(),false);
									__result->Add(HX_CSTRING("total") , 0.0,false);
									__result->Add(HX_CSTRING("hit") , (int)0,false);
									return __result;
								}
								return null();
							}
						};
						HX_STACK_LINE(244)
						ent = _Function_5_1::Block();
						HX_STACK_LINE(244)
						::hxd::Profiler_obj::h->set(HX_CSTRING("Object:sync.animation"),ent);
					}
					HX_STACK_LINE(244)
					ent->__FieldRef(HX_CSTRING("start")) = t;
					HX_STACK_LINE(244)
					(ent->__FieldRef(HX_CSTRING("hit")))++;
				}
				HX_STACK_LINE(246)
				::h3d::scene::Object old = this->parent;		HX_STACK_VAR(old,"old");
				HX_STACK_LINE(247)
				Float dt = ctx->elapsedTime;		HX_STACK_VAR(dt,"dt");
				HX_STACK_LINE(248)
				while((true)){
					HX_STACK_LINE(248)
					if ((!(((bool((dt > (int)0)) && bool((ca != null()))))))){
						HX_STACK_LINE(248)
						break;
					}
					HX_STACK_LINE(249)
					Float _g2 = ca->update(dt);		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(249)
					dt = _g2;
				}
				HX_STACK_LINE(250)
				if (((ca != null()))){
					HX_STACK_LINE(251)
					ca->sync(null());
				}
				HX_STACK_LINE(253)
				if ((::hxd::Profiler_obj::enable)){
					HX_STACK_LINE(253)
					Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
					HX_STACK_LINE(253)
					Dynamic ent = ::hxd::Profiler_obj::h->get(HX_CSTRING("Object:sync.animation"));		HX_STACK_VAR(ent,"ent");
					HX_STACK_LINE(253)
					if (((null() != ent))){
						HX_STACK_LINE(253)
						if (((ent->__Field(HX_CSTRING("start"),true) != null()))){
							HX_STACK_LINE(253)
							hx::AddEq(ent->__FieldRef(HX_CSTRING("total")),(t - ent->__Field(HX_CSTRING("start"),true)));
						}
					}
				}
				HX_STACK_LINE(255)
				if (((bool((this->parent == null())) && bool((old != null()))))){
					HX_STACK_LINE(255)
					return null();
				}
			}
		}
		HX_STACK_LINE(259)
		bool changed = this->posChanged;		HX_STACK_VAR(changed,"changed");
		HX_STACK_LINE(260)
		if ((changed)){
			HX_STACK_LINE(261)
			this->posChanged = false;
			HX_STACK_LINE(262)
			this->calcAbsPos();
		}
		HX_STACK_LINE(265)
		this->lastFrame = ctx->frame;
		HX_STACK_LINE(266)
		int p = (int)0;		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(266)
		int len = this->childs->length;		HX_STACK_VAR(len,"len");
		HX_STACK_LINE(267)
		while((true)){
			HX_STACK_LINE(267)
			if ((!(((p < len))))){
				HX_STACK_LINE(267)
				break;
			}
			HX_STACK_LINE(268)
			::h3d::scene::Object c = this->childs->__get(p).StaticCast< ::h3d::scene::Object >();		HX_STACK_VAR(c,"c");
			HX_STACK_LINE(269)
			if (((c == null()))){
				HX_STACK_LINE(270)
				break;
			}
			HX_STACK_LINE(271)
			if (((c->lastFrame != ctx->frame))){
				HX_STACK_LINE(272)
				if ((changed)){
					HX_STACK_LINE(272)
					c->posChanged = true;
				}
				HX_STACK_LINE(273)
				c->sync(ctx);
			}
			HX_STACK_LINE(277)
			if (((this->childs->__get(p).StaticCast< ::h3d::scene::Object >() != c))){
				HX_STACK_LINE(278)
				p = (int)0;
				HX_STACK_LINE(279)
				len = this->childs->length;
			}
			else{
				HX_STACK_LINE(281)
				(p)++;
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Object_obj,sync,(void))

Void Object_obj::syncPos( ){
{
		HX_STACK_FRAME("h3d.scene.Object","syncPos",0xab6ca5a1,"h3d.scene.Object.syncPos","h3d/scene/Object.hx",285,0x76367d66)
		HX_STACK_THIS(this)
		HX_STACK_LINE(286)
		if (((this->parent != null()))){
			HX_STACK_LINE(286)
			this->parent->syncPos();
		}
		HX_STACK_LINE(287)
		if ((this->posChanged)){
			HX_STACK_LINE(288)
			this->calcAbsPos();
			HX_STACK_LINE(289)
			{
				HX_STACK_LINE(289)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(289)
				Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(289)
				while((true)){
					HX_STACK_LINE(289)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(289)
						break;
					}
					HX_STACK_LINE(289)
					::h3d::scene::Object c = _g1->__get(_g).StaticCast< ::h3d::scene::Object >();		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(289)
					++(_g);
					HX_STACK_LINE(290)
					c->posChanged = true;
				}
			}
			HX_STACK_LINE(291)
			this->posChanged = false;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Object_obj,syncPos,(void))

Void Object_obj::drawRec( ::h3d::scene::RenderContext ctx){
{
		HX_STACK_FRAME("h3d.scene.Object","drawRec",0x002f5f54,"h3d.scene.Object.drawRec","h3d/scene/Object.hx",295,0x76367d66)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ctx,"ctx")
		HX_STACK_LINE(296)
		if ((!(this->visible))){
			HX_STACK_LINE(296)
			return null();
		}
		HX_STACK_LINE(298)
		if ((this->posChanged)){
			HX_STACK_LINE(300)
			{
				HX_STACK_LINE(300)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(300)
				Array< ::Dynamic > _g1 = this->animations;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(300)
				while((true)){
					HX_STACK_LINE(300)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(300)
						break;
					}
					HX_STACK_LINE(300)
					::h3d::anim::Animation ca = _g1->__unsafe_get(_g);		HX_STACK_VAR(ca,"ca");
					HX_STACK_LINE(300)
					++(_g);
					HX_STACK_LINE(300)
					if (((ca != null()))){
						HX_STACK_LINE(300)
						ca->sync(null());
					}
				}
			}
			HX_STACK_LINE(301)
			this->calcAbsPos();
			HX_STACK_LINE(302)
			{
				HX_STACK_LINE(302)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(302)
				Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(302)
				while((true)){
					HX_STACK_LINE(302)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(302)
						break;
					}
					HX_STACK_LINE(302)
					::h3d::scene::Object c = _g1->__get(_g).StaticCast< ::h3d::scene::Object >();		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(302)
					++(_g);
					HX_STACK_LINE(303)
					c->posChanged = true;
				}
			}
			HX_STACK_LINE(304)
			this->posChanged = false;
		}
		HX_STACK_LINE(306)
		{
			HX_STACK_LINE(306)
			::String tag = (HX_CSTRING("draw ") + this->name);		HX_STACK_VAR(tag,"tag");
			HX_STACK_LINE(306)
			if ((::hxd::Profiler_obj::enable)){
				HX_STACK_LINE(306)
				Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
				HX_STACK_LINE(306)
				Dynamic ent = ::hxd::Profiler_obj::h->get(tag);		HX_STACK_VAR(ent,"ent");
				HX_STACK_LINE(306)
				if (((null() == ent))){
					struct _Function_4_1{
						inline static Dynamic Block( ){
							HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/scene/Object.hx",306,0x76367d66)
							{
								hx::Anon __result = hx::Anon_obj::Create();
								__result->Add(HX_CSTRING("start") , null(),false);
								__result->Add(HX_CSTRING("total") , 0.0,false);
								__result->Add(HX_CSTRING("hit") , (int)0,false);
								return __result;
							}
							return null();
						}
					};
					HX_STACK_LINE(306)
					ent = _Function_4_1::Block();
					HX_STACK_LINE(306)
					::hxd::Profiler_obj::h->set(tag,ent);
				}
				HX_STACK_LINE(306)
				ent->__FieldRef(HX_CSTRING("start")) = t;
				HX_STACK_LINE(306)
				(ent->__FieldRef(HX_CSTRING("hit")))++;
			}
		}
		HX_STACK_LINE(307)
		this->draw(ctx);
		HX_STACK_LINE(308)
		if ((::hxd::Profiler_obj::enable)){
			HX_STACK_LINE(308)
			Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
			HX_STACK_LINE(308)
			Dynamic ent = ::hxd::Profiler_obj::h->get((HX_CSTRING("draw ") + this->name));		HX_STACK_VAR(ent,"ent");
			HX_STACK_LINE(308)
			if (((null() != ent))){
				HX_STACK_LINE(308)
				if (((ent->__Field(HX_CSTRING("start"),true) != null()))){
					HX_STACK_LINE(308)
					hx::AddEq(ent->__FieldRef(HX_CSTRING("total")),(t - ent->__Field(HX_CSTRING("start"),true)));
				}
			}
		}
		HX_STACK_LINE(309)
		{
			HX_STACK_LINE(309)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(309)
			Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(309)
			while((true)){
				HX_STACK_LINE(309)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(309)
					break;
				}
				HX_STACK_LINE(309)
				::h3d::scene::Object c = _g1->__get(_g).StaticCast< ::h3d::scene::Object >();		HX_STACK_VAR(c,"c");
				HX_STACK_LINE(309)
				++(_g);
				HX_STACK_LINE(310)
				c->drawRec(ctx);
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Object_obj,drawRec,(void))

Float Object_obj::set_x( Float v){
	HX_STACK_FRAME("h3d.scene.Object","set_x",0xb1058103,"h3d.scene.Object.set_x","h3d/scene/Object.hx",313,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(314)
	this->x = v;
	HX_STACK_LINE(315)
	this->posChanged = true;
	HX_STACK_LINE(316)
	return v;
}


HX_DEFINE_DYNAMIC_FUNC1(Object_obj,set_x,return )

Float Object_obj::set_y( Float v){
	HX_STACK_FRAME("h3d.scene.Object","set_y",0xb1058104,"h3d.scene.Object.set_y","h3d/scene/Object.hx",319,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(320)
	this->y = v;
	HX_STACK_LINE(321)
	this->posChanged = true;
	HX_STACK_LINE(322)
	return v;
}


HX_DEFINE_DYNAMIC_FUNC1(Object_obj,set_y,return )

Float Object_obj::set_z( Float v){
	HX_STACK_FRAME("h3d.scene.Object","set_z",0xb1058105,"h3d.scene.Object.set_z","h3d/scene/Object.hx",325,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(326)
	this->z = v;
	HX_STACK_LINE(327)
	this->posChanged = true;
	HX_STACK_LINE(328)
	return v;
}


HX_DEFINE_DYNAMIC_FUNC1(Object_obj,set_z,return )

Float Object_obj::set_scaleX( Float v){
	HX_STACK_FRAME("h3d.scene.Object","set_scaleX",0xfacb9223,"h3d.scene.Object.set_scaleX","h3d/scene/Object.hx",331,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(332)
	this->scaleX = v;
	HX_STACK_LINE(333)
	this->posChanged = true;
	HX_STACK_LINE(334)
	return v;
}


HX_DEFINE_DYNAMIC_FUNC1(Object_obj,set_scaleX,return )

Float Object_obj::set_scaleY( Float v){
	HX_STACK_FRAME("h3d.scene.Object","set_scaleY",0xfacb9224,"h3d.scene.Object.set_scaleY","h3d/scene/Object.hx",337,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(338)
	this->scaleY = v;
	HX_STACK_LINE(339)
	this->posChanged = true;
	HX_STACK_LINE(340)
	return v;
}


HX_DEFINE_DYNAMIC_FUNC1(Object_obj,set_scaleY,return )

Float Object_obj::set_scaleZ( Float v){
	HX_STACK_FRAME("h3d.scene.Object","set_scaleZ",0xfacb9225,"h3d.scene.Object.set_scaleZ","h3d/scene/Object.hx",343,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(344)
	this->scaleZ = v;
	HX_STACK_LINE(345)
	this->posChanged = true;
	HX_STACK_LINE(346)
	return v;
}


HX_DEFINE_DYNAMIC_FUNC1(Object_obj,set_scaleZ,return )

::h3d::Matrix Object_obj::set_defaultTransform( ::h3d::Matrix v){
	HX_STACK_FRAME("h3d.scene.Object","set_defaultTransform",0x80dc6840,"h3d.scene.Object.set_defaultTransform","h3d/scene/Object.hx",349,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(350)
	this->defaultTransform = v;
	HX_STACK_LINE(351)
	this->posChanged = true;
	HX_STACK_LINE(352)
	return v;
}


HX_DEFINE_DYNAMIC_FUNC1(Object_obj,set_defaultTransform,return )

Void Object_obj::move( Float dx,Float dy,Float dz){
{
		HX_STACK_FRAME("h3d.scene.Object","move",0xfe016a69,"h3d.scene.Object.move","h3d/scene/Object.hx",358,0x76367d66)
		HX_STACK_THIS(this)
		HX_STACK_ARG(dx,"dx")
		HX_STACK_ARG(dy,"dy")
		HX_STACK_ARG(dz,"dz")
		HX_STACK_LINE(359)
		{
			HX_STACK_LINE(359)
			::h3d::scene::Object _g = hx::ObjectPtr<OBJ_>(this);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(359)
			{
				HX_STACK_LINE(359)
				Float v = (_g->x + dx);		HX_STACK_VAR(v,"v");
				HX_STACK_LINE(359)
				_g->x = v;
				HX_STACK_LINE(359)
				_g->posChanged = true;
				HX_STACK_LINE(359)
				v;
			}
		}
		HX_STACK_LINE(360)
		{
			HX_STACK_LINE(360)
			::h3d::scene::Object _g = hx::ObjectPtr<OBJ_>(this);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(360)
			{
				HX_STACK_LINE(360)
				Float v = (_g->y + dy);		HX_STACK_VAR(v,"v");
				HX_STACK_LINE(360)
				_g->y = v;
				HX_STACK_LINE(360)
				_g->posChanged = true;
				HX_STACK_LINE(360)
				v;
			}
		}
		HX_STACK_LINE(361)
		{
			HX_STACK_LINE(361)
			::h3d::scene::Object _g = hx::ObjectPtr<OBJ_>(this);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(361)
			{
				HX_STACK_LINE(361)
				Float v = (_g->z + dz);		HX_STACK_VAR(v,"v");
				HX_STACK_LINE(361)
				_g->z = v;
				HX_STACK_LINE(361)
				_g->posChanged = true;
				HX_STACK_LINE(361)
				v;
			}
		}
		HX_STACK_LINE(362)
		this->posChanged = true;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Object_obj,move,(void))

Void Object_obj::setPos( Float x,Float y,Float z){
{
		HX_STACK_FRAME("h3d.scene.Object","setPos",0x33bff86a,"h3d.scene.Object.setPos","h3d/scene/Object.hx",365,0x76367d66)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(z,"z")
		HX_STACK_LINE(366)
		{
			HX_STACK_LINE(366)
			this->x = x;
			HX_STACK_LINE(366)
			this->posChanged = true;
			HX_STACK_LINE(366)
			x;
		}
		HX_STACK_LINE(367)
		{
			HX_STACK_LINE(367)
			this->y = y;
			HX_STACK_LINE(367)
			this->posChanged = true;
			HX_STACK_LINE(367)
			y;
		}
		HX_STACK_LINE(368)
		{
			HX_STACK_LINE(368)
			this->z = z;
			HX_STACK_LINE(368)
			this->posChanged = true;
			HX_STACK_LINE(368)
			z;
		}
		HX_STACK_LINE(369)
		this->posChanged = true;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Object_obj,setPos,(void))

Void Object_obj::rotate( Float rx,Float ry,Float rz){
{
		HX_STACK_FRAME("h3d.scene.Object","rotate",0x8f7353b3,"h3d.scene.Object.rotate","h3d/scene/Object.hx",375,0x76367d66)
		HX_STACK_THIS(this)
		HX_STACK_ARG(rx,"rx")
		HX_STACK_ARG(ry,"ry")
		HX_STACK_ARG(rz,"rz")
		HX_STACK_LINE(376)
		::h3d::Quat qTmp = ::h3d::Quat_obj::__new(null(),null(),null(),null());		HX_STACK_VAR(qTmp,"qTmp");
		HX_STACK_LINE(377)
		qTmp->initRotate(rx,ry,rz);
		HX_STACK_LINE(378)
		{
			HX_STACK_LINE(378)
			::h3d::Quat _this = this->qRot;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(378)
			_this->multiply(_this,qTmp);
		}
		HX_STACK_LINE(379)
		this->posChanged = true;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Object_obj,rotate,(void))

Void Object_obj::setRotate( Float rx,Float ry,Float rz){
{
		HX_STACK_FRAME("h3d.scene.Object","setRotate",0x6e459545,"h3d.scene.Object.setRotate","h3d/scene/Object.hx",387,0x76367d66)
		HX_STACK_THIS(this)
		HX_STACK_ARG(rx,"rx")
		HX_STACK_ARG(ry,"ry")
		HX_STACK_ARG(rz,"rz")
		HX_STACK_LINE(388)
		this->qRot->initRotate(rx,ry,rz);
		HX_STACK_LINE(389)
		this->posChanged = true;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Object_obj,setRotate,(void))

Void Object_obj::setRotateAxis( Float ax,Float ay,Float az,Float angle){
{
		HX_STACK_FRAME("h3d.scene.Object","setRotateAxis",0x0f2c6486,"h3d.scene.Object.setRotateAxis","h3d/scene/Object.hx",392,0x76367d66)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ax,"ax")
		HX_STACK_ARG(ay,"ay")
		HX_STACK_ARG(az,"az")
		HX_STACK_ARG(angle,"angle")
		HX_STACK_LINE(393)
		this->qRot->initRotateAxis(ax,ay,az,angle);
		HX_STACK_LINE(394)
		this->posChanged = true;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Object_obj,setRotateAxis,(void))

::h3d::Vector Object_obj::getRotation( ){
	HX_STACK_FRAME("h3d.scene.Object","getRotation",0xb05f939c,"h3d.scene.Object.getRotation","h3d/scene/Object.hx",398,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_LINE(398)
	return this->qRot->toEuler();
}


HX_DEFINE_DYNAMIC_FUNC0(Object_obj,getRotation,return )

::h3d::Quat Object_obj::getRotationQuat( ){
	HX_STACK_FRAME("h3d.scene.Object","getRotationQuat",0xbb8af693,"h3d.scene.Object.getRotationQuat","h3d/scene/Object.hx",402,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_LINE(402)
	return this->qRot;
}


HX_DEFINE_DYNAMIC_FUNC0(Object_obj,getRotationQuat,return )

Void Object_obj::setRotationQuat( ::h3d::Quat q){
{
		HX_STACK_FRAME("h3d.scene.Object","setRotationQuat",0xb756739f,"h3d.scene.Object.setRotationQuat","h3d/scene/Object.hx",405,0x76367d66)
		HX_STACK_THIS(this)
		HX_STACK_ARG(q,"q")
		HX_STACK_LINE(406)
		this->qRot = q;
		HX_STACK_LINE(407)
		this->posChanged = true;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Object_obj,setRotationQuat,(void))

Void Object_obj::scale( Float v){
{
		HX_STACK_FRAME("h3d.scene.Object","scale",0xafa4b432,"h3d.scene.Object.scale","h3d/scene/Object.hx",410,0x76367d66)
		HX_STACK_THIS(this)
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(411)
		{
			HX_STACK_LINE(411)
			::h3d::scene::Object _g = hx::ObjectPtr<OBJ_>(this);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(411)
			{
				HX_STACK_LINE(411)
				Float v1 = (_g->scaleX * v);		HX_STACK_VAR(v1,"v1");
				HX_STACK_LINE(411)
				_g->scaleX = v1;
				HX_STACK_LINE(411)
				_g->posChanged = true;
				HX_STACK_LINE(411)
				v1;
			}
		}
		HX_STACK_LINE(412)
		{
			HX_STACK_LINE(412)
			::h3d::scene::Object _g = hx::ObjectPtr<OBJ_>(this);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(412)
			{
				HX_STACK_LINE(412)
				Float v1 = (_g->scaleY * v);		HX_STACK_VAR(v1,"v1");
				HX_STACK_LINE(412)
				_g->scaleY = v1;
				HX_STACK_LINE(412)
				_g->posChanged = true;
				HX_STACK_LINE(412)
				v1;
			}
		}
		HX_STACK_LINE(413)
		{
			HX_STACK_LINE(413)
			::h3d::scene::Object _g = hx::ObjectPtr<OBJ_>(this);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(413)
			{
				HX_STACK_LINE(413)
				Float v1 = (_g->scaleZ * v);		HX_STACK_VAR(v1,"v1");
				HX_STACK_LINE(413)
				_g->scaleZ = v1;
				HX_STACK_LINE(413)
				_g->posChanged = true;
				HX_STACK_LINE(413)
				v1;
			}
		}
		HX_STACK_LINE(414)
		this->posChanged = true;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Object_obj,scale,(void))

Void Object_obj::setScale( Float v){
{
		HX_STACK_FRAME("h3d.scene.Object","setScale",0x50364ae0,"h3d.scene.Object.setScale","h3d/scene/Object.hx",417,0x76367d66)
		HX_STACK_THIS(this)
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(418)
		{
			HX_STACK_LINE(418)
			this->scaleX = v;
			HX_STACK_LINE(418)
			this->posChanged = true;
			HX_STACK_LINE(418)
			v;
		}
		HX_STACK_LINE(419)
		{
			HX_STACK_LINE(419)
			this->scaleY = v;
			HX_STACK_LINE(419)
			this->posChanged = true;
			HX_STACK_LINE(419)
			v;
		}
		HX_STACK_LINE(420)
		{
			HX_STACK_LINE(420)
			this->scaleZ = v;
			HX_STACK_LINE(420)
			this->posChanged = true;
			HX_STACK_LINE(420)
			v;
		}
		HX_STACK_LINE(421)
		this->posChanged = true;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Object_obj,setScale,(void))

::String Object_obj::toString( ){
	HX_STACK_FRAME("h3d.scene.Object","toString",0x01a1e404,"h3d.scene.Object.toString","h3d/scene/Object.hx",424,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_LINE(425)
	::Class _g = ::Type_obj::getClass(hx::ObjectPtr<OBJ_>(this));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(425)
	::String _g1 = ::Type_obj::getClassName(_g).split(HX_CSTRING("."))->pop();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(425)
	return (_g1 + ((  (((this->name == null()))) ? ::String(HX_CSTRING("")) : ::String(((HX_CSTRING("(") + this->name) + HX_CSTRING(")"))) )));
}


HX_DEFINE_DYNAMIC_FUNC0(Object_obj,toString,return )

::h3d::scene::Object Object_obj::getChildAt( int n){
	HX_STACK_FRAME("h3d.scene.Object","getChildAt",0x80aea111,"h3d.scene.Object.getChildAt","h3d/scene/Object.hx",429,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_ARG(n,"n")
	HX_STACK_LINE(429)
	return this->childs->__get(n).StaticCast< ::h3d::scene::Object >();
}


HX_DEFINE_DYNAMIC_FUNC1(Object_obj,getChildAt,return )

int Object_obj::get_numChildren( ){
	HX_STACK_FRAME("h3d.scene.Object","get_numChildren",0x985ea8e4,"h3d.scene.Object.get_numChildren","h3d/scene/Object.hx",433,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_LINE(433)
	return this->childs->length;
}


HX_DEFINE_DYNAMIC_FUNC0(Object_obj,get_numChildren,return )

::hxd::impl::ArrayIterator Object_obj::iterator( ){
	HX_STACK_FRAME("h3d.scene.Object","iterator",0x5ccd5d46,"h3d.scene.Object.iterator","h3d/scene/Object.hx",437,0x76367d66)
	HX_STACK_THIS(this)
	HX_STACK_LINE(437)
	return ::hxd::impl::ArrayIterator_obj::__new(this->childs);
}


HX_DEFINE_DYNAMIC_FUNC0(Object_obj,iterator,return )

Void Object_obj::dispose( ){
{
		HX_STACK_FRAME("h3d.scene.Object","dispose",0xbfa52047,"h3d.scene.Object.dispose","h3d/scene/Object.hx",441,0x76367d66)
		HX_STACK_THIS(this)
		HX_STACK_LINE(441)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(441)
		Array< ::Dynamic > _g1 = this->childs;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(441)
		while((true)){
			HX_STACK_LINE(441)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(441)
				break;
			}
			HX_STACK_LINE(441)
			::h3d::scene::Object c = _g1->__get(_g).StaticCast< ::h3d::scene::Object >();		HX_STACK_VAR(c,"c");
			HX_STACK_LINE(441)
			++(_g);
			HX_STACK_LINE(442)
			c->dispose();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Object_obj,dispose,(void))

Float Object_obj::ROT2RAD;

int Object_obj::MAX_ANIMATIONS;


Object_obj::Object_obj()
{
}

void Object_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Object);
	HX_MARK_MEMBER_NAME(childs,"childs");
	HX_MARK_MEMBER_NAME(parent,"parent");
	HX_MARK_MEMBER_NAME(name,"name");
	HX_MARK_MEMBER_NAME(x,"x");
	HX_MARK_MEMBER_NAME(y,"y");
	HX_MARK_MEMBER_NAME(z,"z");
	HX_MARK_MEMBER_NAME(scaleX,"scaleX");
	HX_MARK_MEMBER_NAME(scaleY,"scaleY");
	HX_MARK_MEMBER_NAME(scaleZ,"scaleZ");
	HX_MARK_MEMBER_NAME(visible,"visible");
	HX_MARK_MEMBER_NAME(follow,"follow");
	HX_MARK_MEMBER_NAME(defaultTransform,"defaultTransform");
	HX_MARK_MEMBER_NAME(currentAnimation,"currentAnimation");
	HX_MARK_MEMBER_NAME(absPos,"absPos");
	HX_MARK_MEMBER_NAME(invPos,"invPos");
	HX_MARK_MEMBER_NAME(qRot,"qRot");
	HX_MARK_MEMBER_NAME(posChanged,"posChanged");
	HX_MARK_MEMBER_NAME(lastFrame,"lastFrame");
	HX_MARK_MEMBER_NAME(animations,"animations");
	HX_MARK_END_CLASS();
}

void Object_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(childs,"childs");
	HX_VISIT_MEMBER_NAME(parent,"parent");
	HX_VISIT_MEMBER_NAME(name,"name");
	HX_VISIT_MEMBER_NAME(x,"x");
	HX_VISIT_MEMBER_NAME(y,"y");
	HX_VISIT_MEMBER_NAME(z,"z");
	HX_VISIT_MEMBER_NAME(scaleX,"scaleX");
	HX_VISIT_MEMBER_NAME(scaleY,"scaleY");
	HX_VISIT_MEMBER_NAME(scaleZ,"scaleZ");
	HX_VISIT_MEMBER_NAME(visible,"visible");
	HX_VISIT_MEMBER_NAME(follow,"follow");
	HX_VISIT_MEMBER_NAME(defaultTransform,"defaultTransform");
	HX_VISIT_MEMBER_NAME(currentAnimation,"currentAnimation");
	HX_VISIT_MEMBER_NAME(absPos,"absPos");
	HX_VISIT_MEMBER_NAME(invPos,"invPos");
	HX_VISIT_MEMBER_NAME(qRot,"qRot");
	HX_VISIT_MEMBER_NAME(posChanged,"posChanged");
	HX_VISIT_MEMBER_NAME(lastFrame,"lastFrame");
	HX_VISIT_MEMBER_NAME(animations,"animations");
}

Dynamic Object_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { return x; }
		if (HX_FIELD_EQ(inName,"y") ) { return y; }
		if (HX_FIELD_EQ(inName,"z") ) { return z; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { return name; }
		if (HX_FIELD_EQ(inName,"qRot") ) { return qRot; }
		if (HX_FIELD_EQ(inName,"draw") ) { return draw_dyn(); }
		if (HX_FIELD_EQ(inName,"sync") ) { return sync_dyn(); }
		if (HX_FIELD_EQ(inName,"move") ) { return move_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		if (HX_FIELD_EQ(inName,"set_x") ) { return set_x_dyn(); }
		if (HX_FIELD_EQ(inName,"set_y") ) { return set_y_dyn(); }
		if (HX_FIELD_EQ(inName,"set_z") ) { return set_z_dyn(); }
		if (HX_FIELD_EQ(inName,"scale") ) { return scale_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"childs") ) { return childs; }
		if (HX_FIELD_EQ(inName,"parent") ) { return parent; }
		if (HX_FIELD_EQ(inName,"scaleX") ) { return scaleX; }
		if (HX_FIELD_EQ(inName,"scaleY") ) { return scaleY; }
		if (HX_FIELD_EQ(inName,"scaleZ") ) { return scaleZ; }
		if (HX_FIELD_EQ(inName,"follow") ) { return follow; }
		if (HX_FIELD_EQ(inName,"absPos") ) { return absPos; }
		if (HX_FIELD_EQ(inName,"invPos") ) { return invPos; }
		if (HX_FIELD_EQ(inName,"isMesh") ) { return isMesh_dyn(); }
		if (HX_FIELD_EQ(inName,"toMesh") ) { return toMesh_dyn(); }
		if (HX_FIELD_EQ(inName,"remove") ) { return remove_dyn(); }
		if (HX_FIELD_EQ(inName,"setPos") ) { return setPos_dyn(); }
		if (HX_FIELD_EQ(inName,"rotate") ) { return rotate_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"visible") ) { return visible; }
		if (HX_FIELD_EQ(inName,"syncPos") ) { return syncPos_dyn(); }
		if (HX_FIELD_EQ(inName,"drawRec") ) { return drawRec_dyn(); }
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"addChild") ) { return addChild_dyn(); }
		if (HX_FIELD_EQ(inName,"setScale") ) { return setScale_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		if (HX_FIELD_EQ(inName,"iterator") ) { return iterator_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"lastFrame") ) { return lastFrame; }
		if (HX_FIELD_EQ(inName,"getInvPos") ) { return getInvPos_dyn(); }
		if (HX_FIELD_EQ(inName,"getBounds") ) { return getBounds_dyn(); }
		if (HX_FIELD_EQ(inName,"setRotate") ) { return setRotate_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"posChanged") ) { return posChanged; }
		if (HX_FIELD_EQ(inName,"animations") ) { return animations; }
		if (HX_FIELD_EQ(inName,"addChildAt") ) { return addChildAt_dyn(); }
		if (HX_FIELD_EQ(inName,"set_follow") ) { return set_follow_dyn(); }
		if (HX_FIELD_EQ(inName,"calcAbsPos") ) { return calcAbsPos_dyn(); }
		if (HX_FIELD_EQ(inName,"set_scaleX") ) { return set_scaleX_dyn(); }
		if (HX_FIELD_EQ(inName,"set_scaleY") ) { return set_scaleY_dyn(); }
		if (HX_FIELD_EQ(inName,"set_scaleZ") ) { return set_scaleZ_dyn(); }
		if (HX_FIELD_EQ(inName,"getChildAt") ) { return getChildAt_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"numChildren") ) { return get_numChildren(); }
		if (HX_FIELD_EQ(inName,"removeChild") ) { return removeChild_dyn(); }
		if (HX_FIELD_EQ(inName,"getRotation") ) { return getRotation_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"playAnimation") ) { return playAnimation_dyn(); }
		if (HX_FIELD_EQ(inName,"stopAnimation") ) { return stopAnimation_dyn(); }
		if (HX_FIELD_EQ(inName,"localToGlobal") ) { return localToGlobal_dyn(); }
		if (HX_FIELD_EQ(inName,"globalToLocal") ) { return globalToLocal_dyn(); }
		if (HX_FIELD_EQ(inName,"setRotateAxis") ) { return setRotateAxis_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"getObjectsCount") ) { return getObjectsCount_dyn(); }
		if (HX_FIELD_EQ(inName,"getObjectByName") ) { return getObjectByName_dyn(); }
		if (HX_FIELD_EQ(inName,"getRotationQuat") ) { return getRotationQuat_dyn(); }
		if (HX_FIELD_EQ(inName,"setRotationQuat") ) { return setRotationQuat_dyn(); }
		if (HX_FIELD_EQ(inName,"get_numChildren") ) { return get_numChildren_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"defaultTransform") ) { return defaultTransform; }
		if (HX_FIELD_EQ(inName,"currentAnimation") ) { return inCallProp ? get_currentAnimation() : currentAnimation; }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"switchToAnimation") ) { return switchToAnimation_dyn(); }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"get_currentAnimation") ) { return get_currentAnimation_dyn(); }
		if (HX_FIELD_EQ(inName,"set_defaultTransform") ) { return set_defaultTransform_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Object_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { if (inCallProp) return set_x(inValue);x=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"y") ) { if (inCallProp) return set_y(inValue);y=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"z") ) { if (inCallProp) return set_z(inValue);z=inValue.Cast< Float >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { name=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"qRot") ) { qRot=inValue.Cast< ::h3d::Quat >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"childs") ) { childs=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"parent") ) { parent=inValue.Cast< ::h3d::scene::Object >(); return inValue; }
		if (HX_FIELD_EQ(inName,"scaleX") ) { if (inCallProp) return set_scaleX(inValue);scaleX=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"scaleY") ) { if (inCallProp) return set_scaleY(inValue);scaleY=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"scaleZ") ) { if (inCallProp) return set_scaleZ(inValue);scaleZ=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"follow") ) { if (inCallProp) return set_follow(inValue);follow=inValue.Cast< ::h3d::scene::Object >(); return inValue; }
		if (HX_FIELD_EQ(inName,"absPos") ) { absPos=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		if (HX_FIELD_EQ(inName,"invPos") ) { invPos=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"visible") ) { visible=inValue.Cast< bool >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"lastFrame") ) { lastFrame=inValue.Cast< int >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"posChanged") ) { posChanged=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"animations") ) { animations=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"defaultTransform") ) { if (inCallProp) return set_defaultTransform(inValue);defaultTransform=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		if (HX_FIELD_EQ(inName,"currentAnimation") ) { currentAnimation=inValue.Cast< ::h3d::anim::Animation >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Object_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("childs"));
	outFields->push(HX_CSTRING("parent"));
	outFields->push(HX_CSTRING("numChildren"));
	outFields->push(HX_CSTRING("name"));
	outFields->push(HX_CSTRING("x"));
	outFields->push(HX_CSTRING("y"));
	outFields->push(HX_CSTRING("z"));
	outFields->push(HX_CSTRING("scaleX"));
	outFields->push(HX_CSTRING("scaleY"));
	outFields->push(HX_CSTRING("scaleZ"));
	outFields->push(HX_CSTRING("visible"));
	outFields->push(HX_CSTRING("follow"));
	outFields->push(HX_CSTRING("defaultTransform"));
	outFields->push(HX_CSTRING("currentAnimation"));
	outFields->push(HX_CSTRING("absPos"));
	outFields->push(HX_CSTRING("invPos"));
	outFields->push(HX_CSTRING("qRot"));
	outFields->push(HX_CSTRING("posChanged"));
	outFields->push(HX_CSTRING("lastFrame"));
	outFields->push(HX_CSTRING("animations"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("ROT2RAD"),
	HX_CSTRING("MAX_ANIMATIONS"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Object_obj,childs),HX_CSTRING("childs")},
	{hx::fsObject /*::h3d::scene::Object*/ ,(int)offsetof(Object_obj,parent),HX_CSTRING("parent")},
	{hx::fsString,(int)offsetof(Object_obj,name),HX_CSTRING("name")},
	{hx::fsFloat,(int)offsetof(Object_obj,x),HX_CSTRING("x")},
	{hx::fsFloat,(int)offsetof(Object_obj,y),HX_CSTRING("y")},
	{hx::fsFloat,(int)offsetof(Object_obj,z),HX_CSTRING("z")},
	{hx::fsFloat,(int)offsetof(Object_obj,scaleX),HX_CSTRING("scaleX")},
	{hx::fsFloat,(int)offsetof(Object_obj,scaleY),HX_CSTRING("scaleY")},
	{hx::fsFloat,(int)offsetof(Object_obj,scaleZ),HX_CSTRING("scaleZ")},
	{hx::fsBool,(int)offsetof(Object_obj,visible),HX_CSTRING("visible")},
	{hx::fsObject /*::h3d::scene::Object*/ ,(int)offsetof(Object_obj,follow),HX_CSTRING("follow")},
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(Object_obj,defaultTransform),HX_CSTRING("defaultTransform")},
	{hx::fsObject /*::h3d::anim::Animation*/ ,(int)offsetof(Object_obj,currentAnimation),HX_CSTRING("currentAnimation")},
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(Object_obj,absPos),HX_CSTRING("absPos")},
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(Object_obj,invPos),HX_CSTRING("invPos")},
	{hx::fsObject /*::h3d::Quat*/ ,(int)offsetof(Object_obj,qRot),HX_CSTRING("qRot")},
	{hx::fsBool,(int)offsetof(Object_obj,posChanged),HX_CSTRING("posChanged")},
	{hx::fsInt,(int)offsetof(Object_obj,lastFrame),HX_CSTRING("lastFrame")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Object_obj,animations),HX_CSTRING("animations")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("childs"),
	HX_CSTRING("parent"),
	HX_CSTRING("name"),
	HX_CSTRING("x"),
	HX_CSTRING("y"),
	HX_CSTRING("z"),
	HX_CSTRING("scaleX"),
	HX_CSTRING("scaleY"),
	HX_CSTRING("scaleZ"),
	HX_CSTRING("visible"),
	HX_CSTRING("follow"),
	HX_CSTRING("defaultTransform"),
	HX_CSTRING("currentAnimation"),
	HX_CSTRING("absPos"),
	HX_CSTRING("invPos"),
	HX_CSTRING("qRot"),
	HX_CSTRING("posChanged"),
	HX_CSTRING("lastFrame"),
	HX_CSTRING("animations"),
	HX_CSTRING("get_currentAnimation"),
	HX_CSTRING("playAnimation"),
	HX_CSTRING("switchToAnimation"),
	HX_CSTRING("stopAnimation"),
	HX_CSTRING("getObjectsCount"),
	HX_CSTRING("localToGlobal"),
	HX_CSTRING("globalToLocal"),
	HX_CSTRING("getInvPos"),
	HX_CSTRING("getBounds"),
	HX_CSTRING("getObjectByName"),
	HX_CSTRING("clone"),
	HX_CSTRING("addChild"),
	HX_CSTRING("addChildAt"),
	HX_CSTRING("removeChild"),
	HX_CSTRING("isMesh"),
	HX_CSTRING("toMesh"),
	HX_CSTRING("remove"),
	HX_CSTRING("draw"),
	HX_CSTRING("set_follow"),
	HX_CSTRING("calcAbsPos"),
	HX_CSTRING("sync"),
	HX_CSTRING("syncPos"),
	HX_CSTRING("drawRec"),
	HX_CSTRING("set_x"),
	HX_CSTRING("set_y"),
	HX_CSTRING("set_z"),
	HX_CSTRING("set_scaleX"),
	HX_CSTRING("set_scaleY"),
	HX_CSTRING("set_scaleZ"),
	HX_CSTRING("set_defaultTransform"),
	HX_CSTRING("move"),
	HX_CSTRING("setPos"),
	HX_CSTRING("rotate"),
	HX_CSTRING("setRotate"),
	HX_CSTRING("setRotateAxis"),
	HX_CSTRING("getRotation"),
	HX_CSTRING("getRotationQuat"),
	HX_CSTRING("setRotationQuat"),
	HX_CSTRING("scale"),
	HX_CSTRING("setScale"),
	HX_CSTRING("toString"),
	HX_CSTRING("getChildAt"),
	HX_CSTRING("get_numChildren"),
	HX_CSTRING("iterator"),
	HX_CSTRING("dispose"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Object_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Object_obj::ROT2RAD,"ROT2RAD");
	HX_MARK_MEMBER_NAME(Object_obj::MAX_ANIMATIONS,"MAX_ANIMATIONS");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Object_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Object_obj::ROT2RAD,"ROT2RAD");
	HX_VISIT_MEMBER_NAME(Object_obj::MAX_ANIMATIONS,"MAX_ANIMATIONS");
};

#endif

Class Object_obj::__mClass;

void Object_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.scene.Object"), hx::TCanCast< Object_obj> ,sStaticFields,sMemberFields,
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

void Object_obj::__boot()
{
	ROT2RAD= -0.017453292519943295769236907684886;
	MAX_ANIMATIONS= (int)4;
}

} // end namespace h3d
} // end namespace scene
