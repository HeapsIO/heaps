#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_flash_geom_ColorTransform
#include <flash/geom/ColorTransform.h>
#endif
namespace flash{
namespace geom{

Void ColorTransform_obj::__construct(hx::Null< Float >  __o_redMultiplier,hx::Null< Float >  __o_greenMultiplier,hx::Null< Float >  __o_blueMultiplier,hx::Null< Float >  __o_alphaMultiplier,hx::Null< Float >  __o_redOffset,hx::Null< Float >  __o_greenOffset,hx::Null< Float >  __o_blueOffset,hx::Null< Float >  __o_alphaOffset)
{
HX_STACK_FRAME("flash.geom.ColorTransform","new",0x131deacf,"flash.geom.ColorTransform.new","flash/geom/ColorTransform.hx",18,0x5a6c5b21)
HX_STACK_THIS(this)
HX_STACK_ARG(__o_redMultiplier,"redMultiplier")
HX_STACK_ARG(__o_greenMultiplier,"greenMultiplier")
HX_STACK_ARG(__o_blueMultiplier,"blueMultiplier")
HX_STACK_ARG(__o_alphaMultiplier,"alphaMultiplier")
HX_STACK_ARG(__o_redOffset,"redOffset")
HX_STACK_ARG(__o_greenOffset,"greenOffset")
HX_STACK_ARG(__o_blueOffset,"blueOffset")
HX_STACK_ARG(__o_alphaOffset,"alphaOffset")
Float redMultiplier = __o_redMultiplier.Default(1.0);
Float greenMultiplier = __o_greenMultiplier.Default(1.0);
Float blueMultiplier = __o_blueMultiplier.Default(1.0);
Float alphaMultiplier = __o_alphaMultiplier.Default(1.0);
Float redOffset = __o_redOffset.Default(0.0);
Float greenOffset = __o_greenOffset.Default(0.0);
Float blueOffset = __o_blueOffset.Default(0.0);
Float alphaOffset = __o_alphaOffset.Default(0.0);
{
	HX_STACK_LINE(20)
	this->redMultiplier = redMultiplier;
	HX_STACK_LINE(21)
	this->greenMultiplier = greenMultiplier;
	HX_STACK_LINE(22)
	this->blueMultiplier = blueMultiplier;
	HX_STACK_LINE(23)
	this->alphaMultiplier = alphaMultiplier;
	HX_STACK_LINE(24)
	this->redOffset = redOffset;
	HX_STACK_LINE(25)
	this->greenOffset = greenOffset;
	HX_STACK_LINE(26)
	this->blueOffset = blueOffset;
	HX_STACK_LINE(27)
	this->alphaOffset = alphaOffset;
}
;
	return null();
}

//ColorTransform_obj::~ColorTransform_obj() { }

Dynamic ColorTransform_obj::__CreateEmpty() { return  new ColorTransform_obj; }
hx::ObjectPtr< ColorTransform_obj > ColorTransform_obj::__new(hx::Null< Float >  __o_redMultiplier,hx::Null< Float >  __o_greenMultiplier,hx::Null< Float >  __o_blueMultiplier,hx::Null< Float >  __o_alphaMultiplier,hx::Null< Float >  __o_redOffset,hx::Null< Float >  __o_greenOffset,hx::Null< Float >  __o_blueOffset,hx::Null< Float >  __o_alphaOffset)
{  hx::ObjectPtr< ColorTransform_obj > result = new ColorTransform_obj();
	result->__construct(__o_redMultiplier,__o_greenMultiplier,__o_blueMultiplier,__o_alphaMultiplier,__o_redOffset,__o_greenOffset,__o_blueOffset,__o_alphaOffset);
	return result;}

Dynamic ColorTransform_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< ColorTransform_obj > result = new ColorTransform_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4],inArgs[5],inArgs[6],inArgs[7]);
	return result;}

Void ColorTransform_obj::concat( ::flash::geom::ColorTransform second){
{
		HX_STACK_FRAME("flash.geom.ColorTransform","concat",0x8830de05,"flash.geom.ColorTransform.concat","flash/geom/ColorTransform.hx",32,0x5a6c5b21)
		HX_STACK_THIS(this)
		HX_STACK_ARG(second,"second")
		HX_STACK_LINE(34)
		hx::AddEq(this->redMultiplier,second->redMultiplier);
		HX_STACK_LINE(35)
		hx::AddEq(this->greenMultiplier,second->greenMultiplier);
		HX_STACK_LINE(36)
		hx::AddEq(this->blueMultiplier,second->blueMultiplier);
		HX_STACK_LINE(37)
		hx::AddEq(this->alphaMultiplier,second->alphaMultiplier);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(ColorTransform_obj,concat,(void))

int ColorTransform_obj::get_color( ){
	HX_STACK_FRAME("flash.geom.ColorTransform","get_color",0x0a2de569,"flash.geom.ColorTransform.get_color","flash/geom/ColorTransform.hx",49,0x5a6c5b21)
	HX_STACK_THIS(this)
	HX_STACK_LINE(51)
	int _g = ::Std_obj::_int(this->redOffset);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(51)
	int _g1 = (int(_g) << int((int)16));		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(51)
	int _g2 = ::Std_obj::_int(this->greenOffset);		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(51)
	int _g3 = (int(_g2) << int((int)8));		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(51)
	int _g4 = (int(_g1) | int(_g3));		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(51)
	int _g5 = ::Std_obj::_int(this->blueOffset);		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(51)
	return (int(_g4) | int(_g5));
}


HX_DEFINE_DYNAMIC_FUNC0(ColorTransform_obj,get_color,return )

int ColorTransform_obj::set_color( int value){
	HX_STACK_FRAME("flash.geom.ColorTransform","set_color",0xed7ed175,"flash.geom.ColorTransform.set_color","flash/geom/ColorTransform.hx",56,0x5a6c5b21)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(58)
	this->redOffset = (int((int(value) >> int((int)16))) & int((int)255));
	HX_STACK_LINE(59)
	this->greenOffset = (int((int(value) >> int((int)8))) & int((int)255));
	HX_STACK_LINE(60)
	this->blueOffset = (int(value) & int((int)255));
	HX_STACK_LINE(62)
	this->redMultiplier = (int)0;
	HX_STACK_LINE(63)
	this->greenMultiplier = (int)0;
	HX_STACK_LINE(64)
	this->blueMultiplier = (int)0;
	HX_STACK_LINE(66)
	return this->get_color();
}


HX_DEFINE_DYNAMIC_FUNC1(ColorTransform_obj,set_color,return )


ColorTransform_obj::ColorTransform_obj()
{
}

Dynamic ColorTransform_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"color") ) { return get_color(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"concat") ) { return concat_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"redOffset") ) { return redOffset; }
		if (HX_FIELD_EQ(inName,"get_color") ) { return get_color_dyn(); }
		if (HX_FIELD_EQ(inName,"set_color") ) { return set_color_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"blueOffset") ) { return blueOffset; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"alphaOffset") ) { return alphaOffset; }
		if (HX_FIELD_EQ(inName,"greenOffset") ) { return greenOffset; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"redMultiplier") ) { return redMultiplier; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"blueMultiplier") ) { return blueMultiplier; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"alphaMultiplier") ) { return alphaMultiplier; }
		if (HX_FIELD_EQ(inName,"greenMultiplier") ) { return greenMultiplier; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic ColorTransform_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"color") ) { return set_color(inValue); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"redOffset") ) { redOffset=inValue.Cast< Float >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"blueOffset") ) { blueOffset=inValue.Cast< Float >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"alphaOffset") ) { alphaOffset=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"greenOffset") ) { greenOffset=inValue.Cast< Float >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"redMultiplier") ) { redMultiplier=inValue.Cast< Float >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"blueMultiplier") ) { blueMultiplier=inValue.Cast< Float >(); return inValue; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"alphaMultiplier") ) { alphaMultiplier=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"greenMultiplier") ) { greenMultiplier=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void ColorTransform_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("alphaMultiplier"));
	outFields->push(HX_CSTRING("alphaOffset"));
	outFields->push(HX_CSTRING("blueMultiplier"));
	outFields->push(HX_CSTRING("blueOffset"));
	outFields->push(HX_CSTRING("color"));
	outFields->push(HX_CSTRING("greenMultiplier"));
	outFields->push(HX_CSTRING("greenOffset"));
	outFields->push(HX_CSTRING("redMultiplier"));
	outFields->push(HX_CSTRING("redOffset"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(ColorTransform_obj,alphaMultiplier),HX_CSTRING("alphaMultiplier")},
	{hx::fsFloat,(int)offsetof(ColorTransform_obj,alphaOffset),HX_CSTRING("alphaOffset")},
	{hx::fsFloat,(int)offsetof(ColorTransform_obj,blueMultiplier),HX_CSTRING("blueMultiplier")},
	{hx::fsFloat,(int)offsetof(ColorTransform_obj,blueOffset),HX_CSTRING("blueOffset")},
	{hx::fsFloat,(int)offsetof(ColorTransform_obj,greenMultiplier),HX_CSTRING("greenMultiplier")},
	{hx::fsFloat,(int)offsetof(ColorTransform_obj,greenOffset),HX_CSTRING("greenOffset")},
	{hx::fsFloat,(int)offsetof(ColorTransform_obj,redMultiplier),HX_CSTRING("redMultiplier")},
	{hx::fsFloat,(int)offsetof(ColorTransform_obj,redOffset),HX_CSTRING("redOffset")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("alphaMultiplier"),
	HX_CSTRING("alphaOffset"),
	HX_CSTRING("blueMultiplier"),
	HX_CSTRING("blueOffset"),
	HX_CSTRING("greenMultiplier"),
	HX_CSTRING("greenOffset"),
	HX_CSTRING("redMultiplier"),
	HX_CSTRING("redOffset"),
	HX_CSTRING("concat"),
	HX_CSTRING("get_color"),
	HX_CSTRING("set_color"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(ColorTransform_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(ColorTransform_obj::__mClass,"__mClass");
};

#endif

Class ColorTransform_obj::__mClass;

void ColorTransform_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.geom.ColorTransform"), hx::TCanCast< ColorTransform_obj> ,sStaticFields,sMemberFields,
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

void ColorTransform_obj::__boot()
{
}

} // end namespace flash
} // end namespace geom
