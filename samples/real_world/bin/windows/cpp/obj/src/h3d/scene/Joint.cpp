#include <hxcpp.h>

#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
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
namespace h3d{
namespace scene{

Void Joint_obj::__construct(::h3d::scene::Skin skin,int index)
{
HX_STACK_FRAME("h3d.scene.Joint","new",0xc2f0de45,"h3d.scene.Joint.new","h3d/scene/Skin.hx",10,0xc713f0a8)
HX_STACK_THIS(this)
HX_STACK_ARG(skin,"skin")
HX_STACK_ARG(index,"index")
{
	HX_STACK_LINE(11)
	super::__construct(null());
	HX_STACK_LINE(12)
	this->skin = skin;
	HX_STACK_LINE(14)
	this->parent = skin;
	HX_STACK_LINE(15)
	this->index = index;
}
;
	return null();
}

//Joint_obj::~Joint_obj() { }

Dynamic Joint_obj::__CreateEmpty() { return  new Joint_obj; }
hx::ObjectPtr< Joint_obj > Joint_obj::__new(::h3d::scene::Skin skin,int index)
{  hx::ObjectPtr< Joint_obj > result = new Joint_obj();
	result->__construct(skin,index);
	return result;}

Dynamic Joint_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Joint_obj > result = new Joint_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

Void Joint_obj::syncPos( ){
{
		HX_STACK_FRAME("h3d.scene.Joint","syncPos",0x8c7e6a5e,"h3d.scene.Joint.syncPos","h3d/scene/Skin.hx",19,0xc713f0a8)
		HX_STACK_THIS(this)
		HX_STACK_LINE(23)
		::h3d::scene::Object p = this->parent;		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(24)
		while((true)){
			HX_STACK_LINE(24)
			if ((!(((p != null()))))){
				HX_STACK_LINE(24)
				break;
			}
			HX_STACK_LINE(25)
			if ((p->posChanged)){
				HX_STACK_LINE(27)
				if (((this->skin->jointsAbsPosInv == null()))){
					HX_STACK_LINE(28)
					::h3d::Matrix _g = ::h3d::Matrix_obj::__new();		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(28)
					this->skin->jointsAbsPosInv = _g;
					HX_STACK_LINE(29)
					this->skin->jointsAbsPosInv->zero();
				}
				HX_STACK_LINE(31)
				if (((this->skin->jointsAbsPosInv->_44 == (int)0))){
					HX_STACK_LINE(32)
					this->skin->jointsAbsPosInv->inverse3x4(this->parent->absPos);
				}
				HX_STACK_LINE(33)
				this->parent->syncPos();
				HX_STACK_LINE(34)
				this->lastFrame = (int)-1;
				HX_STACK_LINE(35)
				break;
			}
			HX_STACK_LINE(37)
			p = p->parent;
		}
		HX_STACK_LINE(39)
		if (((this->lastFrame != this->skin->lastFrame))){
			HX_STACK_LINE(40)
			this->lastFrame = this->skin->lastFrame;
			HX_STACK_LINE(41)
			this->absPos->loadFrom(this->skin->currentAbsPose->__get(this->index).StaticCast< ::h3d::Matrix >());
			HX_STACK_LINE(42)
			if (((bool((this->skin->jointsAbsPosInv != null())) && bool((this->skin->jointsAbsPosInv->_44 != (int)0))))){
				HX_STACK_LINE(43)
				this->absPos->multiply3x4(this->absPos,this->skin->jointsAbsPosInv);
				HX_STACK_LINE(44)
				this->absPos->multiply3x4(this->absPos,this->parent->absPos);
			}
		}
	}
return null();
}



Joint_obj::Joint_obj()
{
}

void Joint_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Joint);
	HX_MARK_MEMBER_NAME(skin,"skin");
	HX_MARK_MEMBER_NAME(index,"index");
	::h3d::scene::Object_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void Joint_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(skin,"skin");
	HX_VISIT_MEMBER_NAME(index,"index");
	::h3d::scene::Object_obj::__Visit(HX_VISIT_ARG);
}

Dynamic Joint_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"skin") ) { return skin; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"index") ) { return index; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"syncPos") ) { return syncPos_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Joint_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"skin") ) { skin=inValue.Cast< ::h3d::scene::Skin >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"index") ) { index=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Joint_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("skin"));
	outFields->push(HX_CSTRING("index"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h3d::scene::Skin*/ ,(int)offsetof(Joint_obj,skin),HX_CSTRING("skin")},
	{hx::fsInt,(int)offsetof(Joint_obj,index),HX_CSTRING("index")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("skin"),
	HX_CSTRING("index"),
	HX_CSTRING("syncPos"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Joint_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Joint_obj::__mClass,"__mClass");
};

#endif

Class Joint_obj::__mClass;

void Joint_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.scene.Joint"), hx::TCanCast< Joint_obj> ,sStaticFields,sMemberFields,
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

void Joint_obj::__boot()
{
}

} // end namespace h3d
} // end namespace scene
