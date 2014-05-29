#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_h3d_anim_AnimatedObject
#include <h3d/anim/AnimatedObject.h>
#endif
#ifndef INCLUDED_h3d_anim_Animation
#include <h3d/anim/Animation.h>
#endif
#ifndef INCLUDED_h3d_anim_Joint
#include <h3d/anim/Joint.h>
#endif
#ifndef INCLUDED_h3d_anim_Skin
#include <h3d/anim/Skin.h>
#endif
#ifndef INCLUDED_h3d_anim__Animation_AnimWait
#include <h3d/anim/_Animation/AnimWait.h>
#endif
#ifndef INCLUDED_h3d_scene_Joint
#include <h3d/scene/Joint.h>
#endif
#ifndef INCLUDED_h3d_scene_Mesh
#include <h3d/scene/Mesh.h>
#endif
#ifndef INCLUDED_h3d_scene_Object
#include <h3d/scene/Object.h>
#endif
#ifndef INCLUDED_h3d_scene_Skin
#include <h3d/scene/Skin.h>
#endif
#ifndef INCLUDED_haxe_Log
#include <haxe/Log.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
#ifndef INCLUDED_hxd_System
#include <hxd/System.h>
#endif
namespace h3d{
namespace anim{

Void Animation_obj::__construct(::String name,int frameCount,Float sampling)
{
HX_STACK_FRAME("h3d.anim.Animation","new",0x5466e2ce,"h3d.anim.Animation.new","h3d/anim/Animation.hx",62,0x61b45cc2)
HX_STACK_THIS(this)
HX_STACK_ARG(name,"name")
HX_STACK_ARG(frameCount,"frameCount")
HX_STACK_ARG(sampling,"sampling")
{
	HX_STACK_LINE(64)
	this->name = name;
	HX_STACK_LINE(65)
	this->frameCount = frameCount;
	HX_STACK_LINE(66)
	this->sampling = sampling;
	HX_STACK_LINE(67)
	this->objects = Array_obj< ::Dynamic >::__new();
	HX_STACK_LINE(68)
	this->frame = 0.0;
	HX_STACK_LINE(69)
	this->speed = 1.0;
	HX_STACK_LINE(70)
	this->loop = true;
	HX_STACK_LINE(71)
	this->pause = false;
	HX_STACK_LINE(72)
	this->setFrameAnimation((int)0,(frameCount - (int)1));
	HX_STACK_LINE(74)
	{
		HX_STACK_LINE(74)
		Dynamic msg = (((((HX_CSTRING("adding anim ") + name) + HX_CSTRING(" ")) + frameCount) + HX_CSTRING(" ")) + sampling);		HX_STACK_VAR(msg,"msg");
		HX_STACK_LINE(74)
		::String pos_fileName = HX_CSTRING("Animation.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
		HX_STACK_LINE(74)
		int pos_lineNumber = (int)74;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
		HX_STACK_LINE(74)
		::String pos_className = HX_CSTRING("h3d.anim.Animation");		HX_STACK_VAR(pos_className,"pos_className");
		HX_STACK_LINE(74)
		::String pos_methodName = HX_CSTRING("new");		HX_STACK_VAR(pos_methodName,"pos_methodName");
		HX_STACK_LINE(74)
		if (((::hxd::System_obj::debugLevel >= (int)3))){
			HX_STACK_LINE(74)
			::String _g = ::Std_obj::string(msg);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(74)
			::String _g1 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(74)
			::haxe::Log_obj::trace(_g1,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
		}
		HX_STACK_LINE(74)
		msg;
	}
}
;
	return null();
}

//Animation_obj::~Animation_obj() { }

Dynamic Animation_obj::__CreateEmpty() { return  new Animation_obj; }
hx::ObjectPtr< Animation_obj > Animation_obj::__new(::String name,int frameCount,Float sampling)
{  hx::ObjectPtr< Animation_obj > result = new Animation_obj();
	result->__construct(name,frameCount,sampling);
	return result;}

Dynamic Animation_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Animation_obj > result = new Animation_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

Void Animation_obj::setFrameAnimation( int start,int end){
{
		HX_STACK_FRAME("h3d.anim.Animation","setFrameAnimation",0xadfb2747,"h3d.anim.Animation.setFrameAnimation","h3d/anim/Animation.hx",77,0x61b45cc2)
		HX_STACK_THIS(this)
		HX_STACK_ARG(start,"start")
		HX_STACK_ARG(end,"end")
		HX_STACK_LINE(79)
		this->frameStart = start;
		HX_STACK_LINE(80)
		this->frameEnd = end;
		HX_STACK_LINE(81)
		this->frame = start;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Animation_obj,setFrameAnimation,(void))

Void Animation_obj::waitForFrame( Float f,Dynamic callb){
{
		HX_STACK_FRAME("h3d.anim.Animation","waitForFrame",0xa02543cb,"h3d.anim.Animation.waitForFrame","h3d/anim/Animation.hx",87,0x61b45cc2)
		HX_STACK_THIS(this)
		HX_STACK_ARG(f,"f")
		HX_STACK_ARG(callb,"callb")
		HX_STACK_LINE(89)
		::h3d::anim::_Animation::AnimWait prev = null();		HX_STACK_VAR(prev,"prev");
		HX_STACK_LINE(90)
		::h3d::anim::_Animation::AnimWait cur = this->waits;		HX_STACK_VAR(cur,"cur");
		HX_STACK_LINE(91)
		while((true)){
			HX_STACK_LINE(91)
			if ((!(((cur != null()))))){
				HX_STACK_LINE(91)
				break;
			}
			HX_STACK_LINE(92)
			if (((cur->frame > f))){
				HX_STACK_LINE(93)
				break;
			}
			HX_STACK_LINE(94)
			prev = cur;
			HX_STACK_LINE(95)
			cur = cur->next;
		}
		HX_STACK_LINE(97)
		if (((prev == null()))){
			HX_STACK_LINE(98)
			::h3d::anim::_Animation::AnimWait _g = ::h3d::anim::_Animation::AnimWait_obj::__new(f,callb,this->waits);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(98)
			this->waits = _g;
		}
		else{
			HX_STACK_LINE(100)
			::h3d::anim::_Animation::AnimWait _g1 = ::h3d::anim::_Animation::AnimWait_obj::__new(f,callb,prev->next);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(100)
			prev->next = _g1;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Animation_obj,waitForFrame,(void))

Void Animation_obj::clearWaits( ){
{
		HX_STACK_FRAME("h3d.anim.Animation","clearWaits",0x5e2742e3,"h3d.anim.Animation.clearWaits","h3d/anim/Animation.hx",107,0x61b45cc2)
		HX_STACK_THIS(this)
		HX_STACK_LINE(107)
		this->waits = null();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Animation_obj,clearWaits,(void))

Void Animation_obj::setFrame( Float f){
{
		HX_STACK_FRAME("h3d.anim.Animation","setFrame",0x83853ffd,"h3d.anim.Animation.setFrame","h3d/anim/Animation.hx",110,0x61b45cc2)
		HX_STACK_THIS(this)
		HX_STACK_ARG(f,"f")
		HX_STACK_LINE(111)
		this->frame = f;
		HX_STACK_LINE(112)
		if (((this->frame > this->frameEnd))){
			HX_STACK_LINE(112)
			this->frame = this->frameEnd;
		}
		HX_STACK_LINE(113)
		if (((this->frame < this->frameStart))){
			HX_STACK_LINE(113)
			this->frame = this->frameStart;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Animation_obj,setFrame,(void))

::h3d::anim::Animation Animation_obj::clone( ::h3d::anim::Animation a){
	HX_STACK_FRAME("h3d.anim.Animation","clone",0x15321d4b,"h3d.anim.Animation.clone","h3d/anim/Animation.hx",116,0x61b45cc2)
	HX_STACK_THIS(this)
	HX_STACK_ARG(a,"a")
	HX_STACK_LINE(117)
	if (((a == null()))){
		HX_STACK_LINE(118)
		::h3d::anim::Animation _g = ::h3d::anim::Animation_obj::__new(this->name,this->frameCount,this->sampling);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(118)
		a = _g;
	}
	HX_STACK_LINE(119)
	a->objects = this->objects;
	HX_STACK_LINE(120)
	a->speed = this->speed;
	HX_STACK_LINE(121)
	a->loop = this->loop;
	HX_STACK_LINE(122)
	a->pause = this->pause;
	HX_STACK_LINE(123)
	a->frameStart = this->frameStart;
	HX_STACK_LINE(124)
	a->frameEnd = this->frameEnd;
	HX_STACK_LINE(125)
	return a;
}


HX_DEFINE_DYNAMIC_FUNC1(Animation_obj,clone,return )

Void Animation_obj::initInstance( ){
{
		HX_STACK_FRAME("h3d.anim.Animation","initInstance",0xec91d697,"h3d.anim.Animation.initInstance","h3d/anim/Animation.hx",129,0x61b45cc2)
		HX_STACK_THIS(this)
		HX_STACK_LINE(129)
		this->isInstance = true;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Animation_obj,initInstance,(void))

::h3d::anim::Animation Animation_obj::createInstance( ::h3d::scene::Object base){
	HX_STACK_FRAME("h3d.anim.Animation","createInstance",0xb0dee703,"h3d.anim.Animation.createInstance","h3d/anim/Animation.hx",132,0x61b45cc2)
	HX_STACK_THIS(this)
	HX_STACK_ARG(base,"base")
	HX_STACK_LINE(133)
	Array< ::Dynamic > objects;		HX_STACK_VAR(objects,"objects");
	HX_STACK_LINE(133)
	{
		HX_STACK_LINE(133)
		Array< ::Dynamic > _g = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(133)
		{
			HX_STACK_LINE(133)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(133)
			Array< ::Dynamic > _g2 = this->objects;		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(133)
			while((true)){
				HX_STACK_LINE(133)
				if ((!(((_g1 < _g2->length))))){
					HX_STACK_LINE(133)
					break;
				}
				HX_STACK_LINE(133)
				::h3d::anim::AnimatedObject a = _g2->__get(_g1).StaticCast< ::h3d::anim::AnimatedObject >();		HX_STACK_VAR(a,"a");
				HX_STACK_LINE(133)
				++(_g1);
				HX_STACK_LINE(133)
				::h3d::anim::AnimatedObject _g3 = a->clone();		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(133)
				_g->push(_g3);
			}
		}
		HX_STACK_LINE(133)
		objects = _g;
	}
	HX_STACK_LINE(134)
	::h3d::anim::Animation a = this->clone(null());		HX_STACK_VAR(a,"a");
	HX_STACK_LINE(135)
	a->objects = objects;
	HX_STACK_LINE(136)
	a->bind(base);
	HX_STACK_LINE(137)
	a->initInstance();
	HX_STACK_LINE(138)
	return a;
}


HX_DEFINE_DYNAMIC_FUNC1(Animation_obj,createInstance,return )

Void Animation_obj::bind( ::h3d::scene::Object base){
{
		HX_STACK_FRAME("h3d.anim.Animation","bind",0x7db4038f,"h3d.anim.Animation.bind","h3d/anim/Animation.hx",145,0x61b45cc2)
		HX_STACK_THIS(this)
		HX_STACK_ARG(base,"base")
		HX_STACK_LINE(146)
		::h3d::scene::Skin currentSkin = null();		HX_STACK_VAR(currentSkin,"currentSkin");
		HX_STACK_LINE(147)
		{
			HX_STACK_LINE(147)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(147)
			Array< ::Dynamic > _g1 = this->objects;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(147)
			while((true)){
				HX_STACK_LINE(147)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(147)
					break;
				}
				HX_STACK_LINE(147)
				::h3d::anim::AnimatedObject a = _g1->__get(_g).StaticCast< ::h3d::anim::AnimatedObject >();		HX_STACK_VAR(a,"a");
				HX_STACK_LINE(147)
				++(_g);
				HX_STACK_LINE(148)
				if (((currentSkin != null()))){
					HX_STACK_LINE(150)
					::h3d::anim::Joint j = currentSkin->skinData->namedJoints->get(a->objectName);		HX_STACK_VAR(j,"j");
					HX_STACK_LINE(151)
					if (((j != null()))){
						HX_STACK_LINE(152)
						a->targetSkin = currentSkin;
						HX_STACK_LINE(153)
						a->targetJoint = j->index;
					}
				}
				HX_STACK_LINE(156)
				::h3d::scene::Object obj = base->getObjectByName(a->objectName);		HX_STACK_VAR(obj,"obj");
				HX_STACK_LINE(157)
				if (((obj == null()))){
					HX_STACK_LINE(157)
					HX_STACK_DO_THROW((a->objectName + HX_CSTRING(" was not found")));
				}
				HX_STACK_LINE(158)
				::h3d::scene::Joint joint = ::Std_obj::instance(obj,hx::ClassOf< ::h3d::scene::Joint >());		HX_STACK_VAR(joint,"joint");
				HX_STACK_LINE(159)
				if (((joint != null()))){
					HX_STACK_LINE(160)
					currentSkin = joint->parent;
					HX_STACK_LINE(161)
					a->targetSkin = currentSkin;
					HX_STACK_LINE(162)
					a->targetJoint = joint->index;
				}
				else{
					HX_STACK_LINE(164)
					a->targetObject = obj;
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Animation_obj,bind,(void))

Void Animation_obj::sync( hx::Null< bool >  __o_decompose){
bool decompose = __o_decompose.Default(false);
	HX_STACK_FRAME("h3d.anim.Animation","sync",0x88fcc82d,"h3d.anim.Animation.sync","h3d/anim/Animation.hx",177,0x61b45cc2)
	HX_STACK_THIS(this)
	HX_STACK_ARG(decompose,"decompose")
{
		HX_STACK_LINE(177)
		HX_STACK_DO_THROW(HX_CSTRING("assert"));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Animation_obj,sync,(void))

bool Animation_obj::isPlaying( ){
	HX_STACK_FRAME("h3d.anim.Animation","isPlaying",0x12fc2592,"h3d.anim.Animation.isPlaying","h3d/anim/Animation.hx",181,0x61b45cc2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(181)
	return (bool(!(this->pause)) && bool((((  (((this->speed < (int)0))) ? Float(-(this->speed)) : Float(this->speed) )) > 0.000001)));
}


HX_DEFINE_DYNAMIC_FUNC0(Animation_obj,isPlaying,return )

int Animation_obj::endFrame( ){
	HX_STACK_FRAME("h3d.anim.Animation","endFrame",0x734e6924,"h3d.anim.Animation.endFrame","h3d/anim/Animation.hx",185,0x61b45cc2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(185)
	return this->frameEnd;
}


HX_DEFINE_DYNAMIC_FUNC0(Animation_obj,endFrame,return )

Float Animation_obj::update( Float dt){
	HX_STACK_FRAME("h3d.anim.Animation","update",0xef5f2c5b,"h3d.anim.Animation.update","h3d/anim/Animation.hx",189,0x61b45cc2)
	HX_STACK_THIS(this)
	HX_STACK_ARG(dt,"dt")
	HX_STACK_LINE(190)
	if ((!(this->isInstance))){
		HX_STACK_LINE(191)
		HX_STACK_DO_THROW(HX_CSTRING("You must instanciate this animation first"));
	}
	HX_STACK_LINE(193)
	if ((!(this->isPlaying()))){
		HX_STACK_LINE(194)
		return (int)0;
	}
	HX_STACK_LINE(197)
	::h3d::anim::_Animation::AnimWait w = this->waits;		HX_STACK_VAR(w,"w");
	HX_STACK_LINE(198)
	::h3d::anim::_Animation::AnimWait prev = null();		HX_STACK_VAR(prev,"prev");
	HX_STACK_LINE(199)
	while((true)){
		HX_STACK_LINE(199)
		if ((!(((w != null()))))){
			HX_STACK_LINE(199)
			break;
		}
		HX_STACK_LINE(200)
		Float wt = (Float(((w->frame - this->frame))) / Float(((this->speed * this->sampling))));		HX_STACK_VAR(wt,"wt");
		HX_STACK_LINE(202)
		if (((wt <= (int)0))){
			HX_STACK_LINE(203)
			prev = w;
			HX_STACK_LINE(204)
			w = w->next;
			HX_STACK_LINE(205)
			continue;
		}
		HX_STACK_LINE(207)
		if (((wt > dt))){
			HX_STACK_LINE(208)
			break;
		}
		HX_STACK_LINE(209)
		this->frame = w->frame;
		HX_STACK_LINE(210)
		hx::SubEq(dt,wt);
		HX_STACK_LINE(211)
		if (((prev == null()))){
			HX_STACK_LINE(212)
			this->waits = w->next;
		}
		else{
			HX_STACK_LINE(214)
			prev->next = w->next;
		}
		HX_STACK_LINE(215)
		w->callb();
		HX_STACK_LINE(216)
		return dt;
	}
	HX_STACK_LINE(221)
	if (((this->onAnimEnd_dyn() != null()))){
		HX_STACK_LINE(222)
		int end = this->endFrame();		HX_STACK_VAR(end,"end");
		HX_STACK_LINE(223)
		Float et = (Float(((end - this->frame))) / Float(((this->speed * this->sampling))));		HX_STACK_VAR(et,"et");
		HX_STACK_LINE(224)
		if (((et <= dt))){
			HX_STACK_LINE(225)
			Float f = (end - 0.000001);		HX_STACK_VAR(f,"f");
			HX_STACK_LINE(226)
			this->frame = f;
			HX_STACK_LINE(227)
			hx::SubEq(dt,et);
			HX_STACK_LINE(228)
			this->onAnimEnd();
			HX_STACK_LINE(230)
			if (((  (((this->frame == f))) ? bool(this->isPlaying()) : bool(false) ))){
				HX_STACK_LINE(231)
				if ((this->loop)){
					HX_STACK_LINE(232)
					this->frame = this->frameStart;
				}
				else{
					HX_STACK_LINE(235)
					dt = (int)0;
				}
			}
			HX_STACK_LINE(238)
			return dt;
		}
	}
	HX_STACK_LINE(244)
	hx::AddEq(this->frame,((dt * this->speed) * this->sampling));
	HX_STACK_LINE(245)
	if (((this->frame >= this->frameEnd))){
		HX_STACK_LINE(246)
		if ((this->loop)){
			HX_STACK_LINE(247)
			this->frame = this->frameStart;
		}
		else{
			HX_STACK_LINE(249)
			this->frame = (this->frameEnd - 0.000001);
		}
	}
	HX_STACK_LINE(253)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC1(Animation_obj,update,return )

Float Animation_obj::EPSILON;


Animation_obj::Animation_obj()
{
}

void Animation_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Animation);
	HX_MARK_MEMBER_NAME(name,"name");
	HX_MARK_MEMBER_NAME(frameCount,"frameCount");
	HX_MARK_MEMBER_NAME(frameStart,"frameStart");
	HX_MARK_MEMBER_NAME(frameEnd,"frameEnd");
	HX_MARK_MEMBER_NAME(sampling,"sampling");
	HX_MARK_MEMBER_NAME(frame,"frame");
	HX_MARK_MEMBER_NAME(speed,"speed");
	HX_MARK_MEMBER_NAME(onAnimEnd,"onAnimEnd");
	HX_MARK_MEMBER_NAME(pause,"pause");
	HX_MARK_MEMBER_NAME(loop,"loop");
	HX_MARK_MEMBER_NAME(waits,"waits");
	HX_MARK_MEMBER_NAME(isInstance,"isInstance");
	HX_MARK_MEMBER_NAME(objects,"objects");
	HX_MARK_END_CLASS();
}

void Animation_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(name,"name");
	HX_VISIT_MEMBER_NAME(frameCount,"frameCount");
	HX_VISIT_MEMBER_NAME(frameStart,"frameStart");
	HX_VISIT_MEMBER_NAME(frameEnd,"frameEnd");
	HX_VISIT_MEMBER_NAME(sampling,"sampling");
	HX_VISIT_MEMBER_NAME(frame,"frame");
	HX_VISIT_MEMBER_NAME(speed,"speed");
	HX_VISIT_MEMBER_NAME(onAnimEnd,"onAnimEnd");
	HX_VISIT_MEMBER_NAME(pause,"pause");
	HX_VISIT_MEMBER_NAME(loop,"loop");
	HX_VISIT_MEMBER_NAME(waits,"waits");
	HX_VISIT_MEMBER_NAME(isInstance,"isInstance");
	HX_VISIT_MEMBER_NAME(objects,"objects");
}

Dynamic Animation_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { return name; }
		if (HX_FIELD_EQ(inName,"loop") ) { return loop; }
		if (HX_FIELD_EQ(inName,"bind") ) { return bind_dyn(); }
		if (HX_FIELD_EQ(inName,"sync") ) { return sync_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"frame") ) { return frame; }
		if (HX_FIELD_EQ(inName,"speed") ) { return speed; }
		if (HX_FIELD_EQ(inName,"pause") ) { return pause; }
		if (HX_FIELD_EQ(inName,"waits") ) { return waits; }
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"update") ) { return update_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"objects") ) { return objects; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"frameEnd") ) { return frameEnd; }
		if (HX_FIELD_EQ(inName,"sampling") ) { return sampling; }
		if (HX_FIELD_EQ(inName,"setFrame") ) { return setFrame_dyn(); }
		if (HX_FIELD_EQ(inName,"endFrame") ) { return endFrame_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"onAnimEnd") ) { return onAnimEnd; }
		if (HX_FIELD_EQ(inName,"isPlaying") ) { return isPlaying_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"frameCount") ) { return frameCount; }
		if (HX_FIELD_EQ(inName,"frameStart") ) { return frameStart; }
		if (HX_FIELD_EQ(inName,"isInstance") ) { return isInstance; }
		if (HX_FIELD_EQ(inName,"clearWaits") ) { return clearWaits_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"waitForFrame") ) { return waitForFrame_dyn(); }
		if (HX_FIELD_EQ(inName,"initInstance") ) { return initInstance_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"createInstance") ) { return createInstance_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"setFrameAnimation") ) { return setFrameAnimation_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Animation_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { name=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"loop") ) { loop=inValue.Cast< bool >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"frame") ) { frame=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"speed") ) { speed=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"pause") ) { pause=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"waits") ) { waits=inValue.Cast< ::h3d::anim::_Animation::AnimWait >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"objects") ) { objects=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"frameEnd") ) { frameEnd=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"sampling") ) { sampling=inValue.Cast< Float >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"onAnimEnd") ) { onAnimEnd=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"frameCount") ) { frameCount=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"frameStart") ) { frameStart=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"isInstance") ) { isInstance=inValue.Cast< bool >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Animation_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("name"));
	outFields->push(HX_CSTRING("frameCount"));
	outFields->push(HX_CSTRING("frameStart"));
	outFields->push(HX_CSTRING("frameEnd"));
	outFields->push(HX_CSTRING("sampling"));
	outFields->push(HX_CSTRING("frame"));
	outFields->push(HX_CSTRING("speed"));
	outFields->push(HX_CSTRING("pause"));
	outFields->push(HX_CSTRING("loop"));
	outFields->push(HX_CSTRING("waits"));
	outFields->push(HX_CSTRING("isInstance"));
	outFields->push(HX_CSTRING("objects"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("EPSILON"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsString,(int)offsetof(Animation_obj,name),HX_CSTRING("name")},
	{hx::fsInt,(int)offsetof(Animation_obj,frameCount),HX_CSTRING("frameCount")},
	{hx::fsInt,(int)offsetof(Animation_obj,frameStart),HX_CSTRING("frameStart")},
	{hx::fsInt,(int)offsetof(Animation_obj,frameEnd),HX_CSTRING("frameEnd")},
	{hx::fsFloat,(int)offsetof(Animation_obj,sampling),HX_CSTRING("sampling")},
	{hx::fsFloat,(int)offsetof(Animation_obj,frame),HX_CSTRING("frame")},
	{hx::fsFloat,(int)offsetof(Animation_obj,speed),HX_CSTRING("speed")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Animation_obj,onAnimEnd),HX_CSTRING("onAnimEnd")},
	{hx::fsBool,(int)offsetof(Animation_obj,pause),HX_CSTRING("pause")},
	{hx::fsBool,(int)offsetof(Animation_obj,loop),HX_CSTRING("loop")},
	{hx::fsObject /*::h3d::anim::_Animation::AnimWait*/ ,(int)offsetof(Animation_obj,waits),HX_CSTRING("waits")},
	{hx::fsBool,(int)offsetof(Animation_obj,isInstance),HX_CSTRING("isInstance")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Animation_obj,objects),HX_CSTRING("objects")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("name"),
	HX_CSTRING("frameCount"),
	HX_CSTRING("frameStart"),
	HX_CSTRING("frameEnd"),
	HX_CSTRING("sampling"),
	HX_CSTRING("frame"),
	HX_CSTRING("speed"),
	HX_CSTRING("onAnimEnd"),
	HX_CSTRING("pause"),
	HX_CSTRING("loop"),
	HX_CSTRING("waits"),
	HX_CSTRING("isInstance"),
	HX_CSTRING("objects"),
	HX_CSTRING("setFrameAnimation"),
	HX_CSTRING("waitForFrame"),
	HX_CSTRING("clearWaits"),
	HX_CSTRING("setFrame"),
	HX_CSTRING("clone"),
	HX_CSTRING("initInstance"),
	HX_CSTRING("createInstance"),
	HX_CSTRING("bind"),
	HX_CSTRING("sync"),
	HX_CSTRING("isPlaying"),
	HX_CSTRING("endFrame"),
	HX_CSTRING("update"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Animation_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Animation_obj::EPSILON,"EPSILON");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Animation_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Animation_obj::EPSILON,"EPSILON");
};

#endif

Class Animation_obj::__mClass;

void Animation_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.anim.Animation"), hx::TCanCast< Animation_obj> ,sStaticFields,sMemberFields,
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

void Animation_obj::__boot()
{
	EPSILON= 0.000001;
}

} // end namespace h3d
} // end namespace anim
