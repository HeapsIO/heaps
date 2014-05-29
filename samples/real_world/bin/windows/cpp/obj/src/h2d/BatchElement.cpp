#include <hxcpp.h>

#ifndef INCLUDED_h2d_BatchElement
#include <h2d/BatchElement.h>
#endif
#ifndef INCLUDED_h2d_Drawable
#include <h2d/Drawable.h>
#endif
#ifndef INCLUDED_h2d_Sprite
#include <h2d/Sprite.h>
#endif
#ifndef INCLUDED_h2d_SpriteBatch
#include <h2d/SpriteBatch.h>
#endif
#ifndef INCLUDED_h2d_Tile
#include <h2d/Tile.h>
#endif
#ifndef INCLUDED_h3d_Vector
#include <h3d/Vector.h>
#endif
namespace h2d{

Void BatchElement_obj::__construct(::h2d::Tile t)
{
{
	this->x = (int)0;
	this->y = (int)0;
	this->alpha = (int)1;
	this->rotation = (int)0;
	Float _g = this->scaleY = (int)1;
	this->scaleX = _g;
	this->skewX = (int)0;
	this->skewY = (int)0;
	this->priority = (int)0;
	::h3d::Vector _g1 = ::h3d::Vector_obj::__new((int)1,(int)1,(int)1,(int)1);
	this->color = _g1;
	this->t = t;
	this->visible = true;
}
;
	return null();
}

//BatchElement_obj::~BatchElement_obj() { }

Dynamic BatchElement_obj::__CreateEmpty() { return  new BatchElement_obj; }
hx::ObjectPtr< BatchElement_obj > BatchElement_obj::__new(::h2d::Tile t)
{  hx::ObjectPtr< BatchElement_obj > result = new BatchElement_obj();
	result->__construct(t);
	return result;}

Dynamic BatchElement_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< BatchElement_obj > result = new BatchElement_obj();
	result->__construct(inArgs[0]);
	return result;}

Void BatchElement_obj::remove( ){
{
		if (((this->batch != null()))){
			this->batch->_delete(hx::ObjectPtr<OBJ_>(this));
		}
		this->t = null();
		this->color = null();
		this->batch = null();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BatchElement_obj,remove,(void))

Float BatchElement_obj::get_width( ){
	HX_STACK_FRAME("h2d.BatchElement","get_width",0x004250c5,"h2d.BatchElement.get_width","h2d/SpriteBatch.hx",57,0x7caf17de)
	HX_STACK_THIS(this)
	HX_STACK_LINE(57)
	return (this->scaleX * this->t->width);
}


HX_DEFINE_DYNAMIC_FUNC0(BatchElement_obj,get_width,return )

Float BatchElement_obj::get_height( ){
	HX_STACK_FRAME("h2d.BatchElement","get_height",0xf013d448,"h2d.BatchElement.get_height","h2d/SpriteBatch.hx",58,0x7caf17de)
	HX_STACK_THIS(this)
	HX_STACK_LINE(58)
	return (this->scaleY * this->t->height);
}


HX_DEFINE_DYNAMIC_FUNC0(BatchElement_obj,get_height,return )

Float BatchElement_obj::set_width( Float w){
	HX_STACK_FRAME("h2d.BatchElement","set_width",0xe3933cd1,"h2d.BatchElement.set_width","h2d/SpriteBatch.hx",60,0x7caf17de)
	HX_STACK_THIS(this)
	HX_STACK_ARG(w,"w")
	HX_STACK_LINE(61)
	this->scaleX = (Float(w) / Float(this->t->width));
	HX_STACK_LINE(62)
	return w;
}


HX_DEFINE_DYNAMIC_FUNC1(BatchElement_obj,set_width,return )

Float BatchElement_obj::set_height( Float h){
	HX_STACK_FRAME("h2d.BatchElement","set_height",0xf39172bc,"h2d.BatchElement.set_height","h2d/SpriteBatch.hx",65,0x7caf17de)
	HX_STACK_THIS(this)
	HX_STACK_ARG(h,"h")
	HX_STACK_LINE(66)
	this->scaleY = (Float(h) / Float(this->t->height));
	HX_STACK_LINE(67)
	return h;
}


HX_DEFINE_DYNAMIC_FUNC1(BatchElement_obj,set_height,return )

int BatchElement_obj::changePriority( int v){
	HX_STACK_FRAME("h2d.BatchElement","changePriority",0x1400418c,"h2d.BatchElement.changePriority","h2d/SpriteBatch.hx",70,0x7caf17de)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(71)
	this->priority = v;
	HX_STACK_LINE(72)
	if (((this->batch != null()))){
		HX_STACK_LINE(74)
		this->batch->_delete(hx::ObjectPtr<OBJ_>(this));
		HX_STACK_LINE(75)
		this->batch->add(hx::ObjectPtr<OBJ_>(this),v);
	}
	HX_STACK_LINE(77)
	return v;
}


HX_DEFINE_DYNAMIC_FUNC1(BatchElement_obj,changePriority,return )


BatchElement_obj::BatchElement_obj()
{
}

void BatchElement_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(BatchElement);
	HX_MARK_MEMBER_NAME(priority,"priority");
	HX_MARK_MEMBER_NAME(x,"x");
	HX_MARK_MEMBER_NAME(y,"y");
	HX_MARK_MEMBER_NAME(scaleX,"scaleX");
	HX_MARK_MEMBER_NAME(scaleY,"scaleY");
	HX_MARK_MEMBER_NAME(skewX,"skewX");
	HX_MARK_MEMBER_NAME(skewY,"skewY");
	HX_MARK_MEMBER_NAME(rotation,"rotation");
	HX_MARK_MEMBER_NAME(visible,"visible");
	HX_MARK_MEMBER_NAME(alpha,"alpha");
	HX_MARK_MEMBER_NAME(t,"t");
	HX_MARK_MEMBER_NAME(color,"color");
	HX_MARK_MEMBER_NAME(batch,"batch");
	HX_MARK_MEMBER_NAME(prev,"prev");
	HX_MARK_MEMBER_NAME(next,"next");
	HX_MARK_END_CLASS();
}

void BatchElement_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(priority,"priority");
	HX_VISIT_MEMBER_NAME(x,"x");
	HX_VISIT_MEMBER_NAME(y,"y");
	HX_VISIT_MEMBER_NAME(scaleX,"scaleX");
	HX_VISIT_MEMBER_NAME(scaleY,"scaleY");
	HX_VISIT_MEMBER_NAME(skewX,"skewX");
	HX_VISIT_MEMBER_NAME(skewY,"skewY");
	HX_VISIT_MEMBER_NAME(rotation,"rotation");
	HX_VISIT_MEMBER_NAME(visible,"visible");
	HX_VISIT_MEMBER_NAME(alpha,"alpha");
	HX_VISIT_MEMBER_NAME(t,"t");
	HX_VISIT_MEMBER_NAME(color,"color");
	HX_VISIT_MEMBER_NAME(batch,"batch");
	HX_VISIT_MEMBER_NAME(prev,"prev");
	HX_VISIT_MEMBER_NAME(next,"next");
}

Dynamic BatchElement_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { return x; }
		if (HX_FIELD_EQ(inName,"y") ) { return y; }
		if (HX_FIELD_EQ(inName,"t") ) { return t; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"prev") ) { return prev; }
		if (HX_FIELD_EQ(inName,"next") ) { return next; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"skewX") ) { return skewX; }
		if (HX_FIELD_EQ(inName,"skewY") ) { return skewY; }
		if (HX_FIELD_EQ(inName,"alpha") ) { return alpha; }
		if (HX_FIELD_EQ(inName,"color") ) { return color; }
		if (HX_FIELD_EQ(inName,"batch") ) { return batch; }
		if (HX_FIELD_EQ(inName,"width") ) { return get_width(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"scaleX") ) { return scaleX; }
		if (HX_FIELD_EQ(inName,"scaleY") ) { return scaleY; }
		if (HX_FIELD_EQ(inName,"remove") ) { return remove_dyn(); }
		if (HX_FIELD_EQ(inName,"height") ) { return get_height(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"visible") ) { return visible; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"priority") ) { return priority; }
		if (HX_FIELD_EQ(inName,"rotation") ) { return rotation; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"get_width") ) { return get_width_dyn(); }
		if (HX_FIELD_EQ(inName,"set_width") ) { return set_width_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"get_height") ) { return get_height_dyn(); }
		if (HX_FIELD_EQ(inName,"set_height") ) { return set_height_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"changePriority") ) { return changePriority_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic BatchElement_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { x=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"y") ) { y=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"t") ) { t=inValue.Cast< ::h2d::Tile >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"prev") ) { prev=inValue.Cast< ::h2d::BatchElement >(); return inValue; }
		if (HX_FIELD_EQ(inName,"next") ) { next=inValue.Cast< ::h2d::BatchElement >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"skewX") ) { skewX=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"skewY") ) { skewY=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"alpha") ) { alpha=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"color") ) { color=inValue.Cast< ::h3d::Vector >(); return inValue; }
		if (HX_FIELD_EQ(inName,"batch") ) { batch=inValue.Cast< ::h2d::SpriteBatch >(); return inValue; }
		if (HX_FIELD_EQ(inName,"width") ) { return set_width(inValue); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"scaleX") ) { scaleX=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"scaleY") ) { scaleY=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"height") ) { return set_height(inValue); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"visible") ) { visible=inValue.Cast< bool >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"priority") ) { priority=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"rotation") ) { rotation=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void BatchElement_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("priority"));
	outFields->push(HX_CSTRING("x"));
	outFields->push(HX_CSTRING("y"));
	outFields->push(HX_CSTRING("scaleX"));
	outFields->push(HX_CSTRING("scaleY"));
	outFields->push(HX_CSTRING("skewX"));
	outFields->push(HX_CSTRING("skewY"));
	outFields->push(HX_CSTRING("rotation"));
	outFields->push(HX_CSTRING("visible"));
	outFields->push(HX_CSTRING("alpha"));
	outFields->push(HX_CSTRING("t"));
	outFields->push(HX_CSTRING("color"));
	outFields->push(HX_CSTRING("batch"));
	outFields->push(HX_CSTRING("prev"));
	outFields->push(HX_CSTRING("next"));
	outFields->push(HX_CSTRING("width"));
	outFields->push(HX_CSTRING("height"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(BatchElement_obj,priority),HX_CSTRING("priority")},
	{hx::fsFloat,(int)offsetof(BatchElement_obj,x),HX_CSTRING("x")},
	{hx::fsFloat,(int)offsetof(BatchElement_obj,y),HX_CSTRING("y")},
	{hx::fsFloat,(int)offsetof(BatchElement_obj,scaleX),HX_CSTRING("scaleX")},
	{hx::fsFloat,(int)offsetof(BatchElement_obj,scaleY),HX_CSTRING("scaleY")},
	{hx::fsFloat,(int)offsetof(BatchElement_obj,skewX),HX_CSTRING("skewX")},
	{hx::fsFloat,(int)offsetof(BatchElement_obj,skewY),HX_CSTRING("skewY")},
	{hx::fsFloat,(int)offsetof(BatchElement_obj,rotation),HX_CSTRING("rotation")},
	{hx::fsBool,(int)offsetof(BatchElement_obj,visible),HX_CSTRING("visible")},
	{hx::fsFloat,(int)offsetof(BatchElement_obj,alpha),HX_CSTRING("alpha")},
	{hx::fsObject /*::h2d::Tile*/ ,(int)offsetof(BatchElement_obj,t),HX_CSTRING("t")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(BatchElement_obj,color),HX_CSTRING("color")},
	{hx::fsObject /*::h2d::SpriteBatch*/ ,(int)offsetof(BatchElement_obj,batch),HX_CSTRING("batch")},
	{hx::fsObject /*::h2d::BatchElement*/ ,(int)offsetof(BatchElement_obj,prev),HX_CSTRING("prev")},
	{hx::fsObject /*::h2d::BatchElement*/ ,(int)offsetof(BatchElement_obj,next),HX_CSTRING("next")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("priority"),
	HX_CSTRING("x"),
	HX_CSTRING("y"),
	HX_CSTRING("scaleX"),
	HX_CSTRING("scaleY"),
	HX_CSTRING("skewX"),
	HX_CSTRING("skewY"),
	HX_CSTRING("rotation"),
	HX_CSTRING("visible"),
	HX_CSTRING("alpha"),
	HX_CSTRING("t"),
	HX_CSTRING("color"),
	HX_CSTRING("batch"),
	HX_CSTRING("prev"),
	HX_CSTRING("next"),
	HX_CSTRING("remove"),
	HX_CSTRING("get_width"),
	HX_CSTRING("get_height"),
	HX_CSTRING("set_width"),
	HX_CSTRING("set_height"),
	HX_CSTRING("changePriority"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(BatchElement_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(BatchElement_obj::__mClass,"__mClass");
};

#endif

Class BatchElement_obj::__mClass;

void BatchElement_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.BatchElement"), hx::TCanCast< BatchElement_obj> ,sStaticFields,sMemberFields,
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

void BatchElement_obj::__boot()
{
}

} // end namespace h2d
