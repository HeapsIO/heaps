#include <hxcpp.h>

#ifndef INCLUDED_Reflect
#include <Reflect.h>
#endif
#ifndef INCLUDED_h3d_impl_Shader
#include <h3d/impl/Shader.h>
#endif
#ifndef INCLUDED_h3d_mat_Blend
#include <h3d/mat/Blend.h>
#endif
#ifndef INCLUDED_h3d_mat_Compare
#include <h3d/mat/Compare.h>
#endif
#ifndef INCLUDED_h3d_mat_Face
#include <h3d/mat/Face.h>
#endif
#ifndef INCLUDED_h3d_mat_Material
#include <h3d/mat/Material.h>
#endif
#ifndef INCLUDED_h3d_scene_RenderContext
#include <h3d/scene/RenderContext.h>
#endif
namespace h3d{
namespace mat{

Void Material_obj::__construct(::h3d::impl::Shader shader)
{
HX_STACK_FRAME("h3d.mat.Material","new",0xe68c7c9c,"h3d.mat.Material.new","h3d/mat/Material.hx",16,0xb750a112)
HX_STACK_THIS(this)
HX_STACK_ARG(shader,"shader")
{
	HX_STACK_LINE(17)
	this->bits = (int)0;
	HX_STACK_LINE(18)
	this->renderPass = (int)0;
	HX_STACK_LINE(19)
	this->shader = shader;
	HX_STACK_LINE(20)
	this->set_culling(::h3d::mat::Face_obj::Back);
	HX_STACK_LINE(21)
	this->set_depthWrite(true);
	HX_STACK_LINE(22)
	this->set_depthTest(::h3d::mat::Compare_obj::Less);
	HX_STACK_LINE(23)
	this->set_blendSrc(::h3d::mat::Blend_obj::One);
	HX_STACK_LINE(24)
	this->set_blendDst(::h3d::mat::Blend_obj::Zero);
	HX_STACK_LINE(25)
	this->set_colorMask((int)15);
	HX_STACK_LINE(27)
	this->depth(this->depthWrite,this->depthTest);
}
;
	return null();
}

//Material_obj::~Material_obj() { }

Dynamic Material_obj::__CreateEmpty() { return  new Material_obj; }
hx::ObjectPtr< Material_obj > Material_obj::__new(::h3d::impl::Shader shader)
{  hx::ObjectPtr< Material_obj > result = new Material_obj();
	result->__construct(shader);
	return result;}

Dynamic Material_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Material_obj > result = new Material_obj();
	result->__construct(inArgs[0]);
	return result;}

Void Material_obj::setup( ::h3d::scene::RenderContext ctx){
{
		HX_STACK_FRAME("h3d.mat.Material","setup",0xe118e1b9,"h3d.mat.Material.setup","h3d/mat/Material.hx",32,0xb750a112)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ctx,"ctx")
		HX_STACK_LINE(32)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(32)
		Array< ::String > _g1 = ::Reflect_obj::fields(hx::ObjectPtr<OBJ_>(this));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(32)
		while((true)){
			HX_STACK_LINE(32)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(32)
				break;
			}
			HX_STACK_LINE(32)
			::String r = _g1->__get(_g);		HX_STACK_VAR(r,"r");
			HX_STACK_LINE(32)
			++(_g);
			HX_STACK_LINE(33)
			Dynamic _g2 = this->__Field(r,true);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(33)
			if (((_g2 == null()))){
				HX_STACK_LINE(34)
				HX_STACK_DO_THROW(HX_CSTRING("shader property $r should not be left null"));
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Material_obj,setup,(void))

Void Material_obj::blend( ::h3d::mat::Blend src,::h3d::mat::Blend dst){
{
		HX_STACK_FRAME("h3d.mat.Material","blend",0x1bde1b8d,"h3d.mat.Material.blend","h3d/mat/Material.hx",38,0xb750a112)
		HX_STACK_THIS(this)
		HX_STACK_ARG(src,"src")
		HX_STACK_ARG(dst,"dst")
		HX_STACK_LINE(39)
		this->set_blendSrc(src);
		HX_STACK_LINE(40)
		this->set_blendDst(dst);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Material_obj,blend,(void))

::h3d::mat::Material Material_obj::clone( ::h3d::mat::Material m){
	HX_STACK_FRAME("h3d.mat.Material","clone",0xaf4c4699,"h3d.mat.Material.clone","h3d/mat/Material.hx",43,0xb750a112)
	HX_STACK_THIS(this)
	HX_STACK_ARG(m,"m")
	HX_STACK_LINE(44)
	if (((m == null()))){
		HX_STACK_LINE(44)
		::h3d::mat::Material _g = ::h3d::mat::Material_obj::__new(null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(44)
		m = _g;
	}
	HX_STACK_LINE(45)
	m->set_culling(this->culling);
	HX_STACK_LINE(46)
	m->set_depthWrite(this->depthWrite);
	HX_STACK_LINE(47)
	m->set_depthTest(this->depthTest);
	HX_STACK_LINE(48)
	m->set_blendSrc(this->blendSrc);
	HX_STACK_LINE(49)
	m->set_blendDst(this->blendDst);
	HX_STACK_LINE(50)
	m->set_colorMask(this->colorMask);
	HX_STACK_LINE(51)
	return m;
}


HX_DEFINE_DYNAMIC_FUNC1(Material_obj,clone,return )

Void Material_obj::depth( bool write,::h3d::mat::Compare test){
{
		HX_STACK_FRAME("h3d.mat.Material","depth",0x3e13243f,"h3d.mat.Material.depth","h3d/mat/Material.hx",54,0xb750a112)
		HX_STACK_THIS(this)
		HX_STACK_ARG(write,"write")
		HX_STACK_ARG(test,"test")
		HX_STACK_LINE(55)
		this->set_depthWrite(write);
		HX_STACK_LINE(56)
		this->set_depthTest(test);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Material_obj,depth,(void))

Void Material_obj::setColorMask( bool r,bool g,bool b,bool a){
{
		HX_STACK_FRAME("h3d.mat.Material","setColorMask",0xf4d97831,"h3d.mat.Material.setColorMask","h3d/mat/Material.hx",60,0xb750a112)
		HX_STACK_THIS(this)
		HX_STACK_ARG(r,"r")
		HX_STACK_ARG(g,"g")
		HX_STACK_ARG(b,"b")
		HX_STACK_ARG(a,"a")
		HX_STACK_LINE(60)
		this->set_colorMask((int((int((int(((  ((r)) ? int((int)1) : int((int)0) ))) | int(((  ((g)) ? int((int)2) : int((int)0) ))))) | int(((  ((b)) ? int((int)4) : int((int)0) ))))) | int(((  ((a)) ? int((int)8) : int((int)0) )))));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Material_obj,setColorMask,(void))

::h3d::mat::Face Material_obj::set_culling( ::h3d::mat::Face f){
	HX_STACK_FRAME("h3d.mat.Material","set_culling",0x654891cf,"h3d.mat.Material.set_culling","h3d/mat/Material.hx",63,0xb750a112)
	HX_STACK_THIS(this)
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(64)
	this->culling = f;
	HX_STACK_LINE(65)
	int _g = f->__Index();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(65)
	int _g1 = _g;		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(65)
	int _g2 = (int((int(this->bits) & int((int)-4))) | int(_g1));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(65)
	this->bits = _g2;
	HX_STACK_LINE(66)
	return f;
}


HX_DEFINE_DYNAMIC_FUNC1(Material_obj,set_culling,return )

bool Material_obj::set_depthWrite( bool b){
	HX_STACK_FRAME("h3d.mat.Material","set_depthWrite",0x9e2756dd,"h3d.mat.Material.set_depthWrite","h3d/mat/Material.hx",69,0xb750a112)
	HX_STACK_THIS(this)
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(70)
	this->depthWrite = b;
	HX_STACK_LINE(71)
	this->bits = (int((int(this->bits) & int((int)-5))) | int((int(((  ((b)) ? int((int)1) : int((int)0) ))) << int((int)2))));
	HX_STACK_LINE(72)
	return b;
}


HX_DEFINE_DYNAMIC_FUNC1(Material_obj,set_depthWrite,return )

::h3d::mat::Compare Material_obj::set_depthTest( ::h3d::mat::Compare c){
	HX_STACK_FRAME("h3d.mat.Material","set_depthTest",0x2a4fa814,"h3d.mat.Material.set_depthTest","h3d/mat/Material.hx",75,0xb750a112)
	HX_STACK_THIS(this)
	HX_STACK_ARG(c,"c")
	HX_STACK_LINE(76)
	this->depthTest = c;
	HX_STACK_LINE(77)
	int _g = c->__Index();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(77)
	int _g1 = (int(_g) << int((int)3));		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(77)
	int _g2 = (int((int(this->bits) & int((int)-57))) | int(_g1));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(77)
	this->bits = _g2;
	HX_STACK_LINE(78)
	return c;
}


HX_DEFINE_DYNAMIC_FUNC1(Material_obj,set_depthTest,return )

::h3d::mat::Blend Material_obj::set_blendSrc( ::h3d::mat::Blend b){
	HX_STACK_FRAME("h3d.mat.Material","set_blendSrc",0xe1ae82d4,"h3d.mat.Material.set_blendSrc","h3d/mat/Material.hx",81,0xb750a112)
	HX_STACK_THIS(this)
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(82)
	this->blendSrc = b;
	HX_STACK_LINE(83)
	int _g = b->__Index();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(83)
	int _g1 = (int(_g) << int((int)6));		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(83)
	int _g2 = (int((int(this->bits) & int((int)-961))) | int(_g1));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(83)
	this->bits = _g2;
	HX_STACK_LINE(84)
	return b;
}


HX_DEFINE_DYNAMIC_FUNC1(Material_obj,set_blendSrc,return )

::h3d::mat::Blend Material_obj::set_blendDst( ::h3d::mat::Blend b){
	HX_STACK_FRAME("h3d.mat.Material","set_blendDst",0xe1a321f5,"h3d.mat.Material.set_blendDst","h3d/mat/Material.hx",87,0xb750a112)
	HX_STACK_THIS(this)
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(88)
	this->blendDst = b;
	HX_STACK_LINE(89)
	int _g = b->__Index();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(89)
	int _g1 = (int(_g) << int((int)10));		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(89)
	int _g2 = (int((int(this->bits) & int((int)-15361))) | int(_g1));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(89)
	this->bits = _g2;
	HX_STACK_LINE(90)
	return b;
}


HX_DEFINE_DYNAMIC_FUNC1(Material_obj,set_blendDst,return )

int Material_obj::set_colorMask( int m){
	HX_STACK_FRAME("h3d.mat.Material","set_colorMask",0xaa96510e,"h3d.mat.Material.set_colorMask","h3d/mat/Material.hx",93,0xb750a112)
	HX_STACK_THIS(this)
	HX_STACK_ARG(m,"m")
	HX_STACK_LINE(94)
	hx::AndEq(m,(int)15);
	HX_STACK_LINE(95)
	this->colorMask = m;
	HX_STACK_LINE(96)
	this->bits = (int((int(this->bits) & int((int)-245761))) | int((int(m) << int((int)14))));
	HX_STACK_LINE(97)
	return m;
}


HX_DEFINE_DYNAMIC_FUNC1(Material_obj,set_colorMask,return )


Material_obj::Material_obj()
{
}

void Material_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Material);
	HX_MARK_MEMBER_NAME(bits,"bits");
	HX_MARK_MEMBER_NAME(culling,"culling");
	HX_MARK_MEMBER_NAME(depthWrite,"depthWrite");
	HX_MARK_MEMBER_NAME(depthTest,"depthTest");
	HX_MARK_MEMBER_NAME(blendSrc,"blendSrc");
	HX_MARK_MEMBER_NAME(blendDst,"blendDst");
	HX_MARK_MEMBER_NAME(colorMask,"colorMask");
	HX_MARK_MEMBER_NAME(shader,"shader");
	HX_MARK_MEMBER_NAME(renderPass,"renderPass");
	HX_MARK_END_CLASS();
}

void Material_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(bits,"bits");
	HX_VISIT_MEMBER_NAME(culling,"culling");
	HX_VISIT_MEMBER_NAME(depthWrite,"depthWrite");
	HX_VISIT_MEMBER_NAME(depthTest,"depthTest");
	HX_VISIT_MEMBER_NAME(blendSrc,"blendSrc");
	HX_VISIT_MEMBER_NAME(blendDst,"blendDst");
	HX_VISIT_MEMBER_NAME(colorMask,"colorMask");
	HX_VISIT_MEMBER_NAME(shader,"shader");
	HX_VISIT_MEMBER_NAME(renderPass,"renderPass");
}

Dynamic Material_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"bits") ) { return bits; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"setup") ) { return setup_dyn(); }
		if (HX_FIELD_EQ(inName,"blend") ) { return blend_dyn(); }
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		if (HX_FIELD_EQ(inName,"depth") ) { return depth_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"shader") ) { return shader; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"culling") ) { return culling; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"blendSrc") ) { return blendSrc; }
		if (HX_FIELD_EQ(inName,"blendDst") ) { return blendDst; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"depthTest") ) { return depthTest; }
		if (HX_FIELD_EQ(inName,"colorMask") ) { return colorMask; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"depthWrite") ) { return depthWrite; }
		if (HX_FIELD_EQ(inName,"renderPass") ) { return renderPass; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"set_culling") ) { return set_culling_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"setColorMask") ) { return setColorMask_dyn(); }
		if (HX_FIELD_EQ(inName,"set_blendSrc") ) { return set_blendSrc_dyn(); }
		if (HX_FIELD_EQ(inName,"set_blendDst") ) { return set_blendDst_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"set_depthTest") ) { return set_depthTest_dyn(); }
		if (HX_FIELD_EQ(inName,"set_colorMask") ) { return set_colorMask_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"set_depthWrite") ) { return set_depthWrite_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Material_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"bits") ) { bits=inValue.Cast< int >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"shader") ) { shader=inValue.Cast< ::h3d::impl::Shader >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"culling") ) { if (inCallProp) return set_culling(inValue);culling=inValue.Cast< ::h3d::mat::Face >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"blendSrc") ) { if (inCallProp) return set_blendSrc(inValue);blendSrc=inValue.Cast< ::h3d::mat::Blend >(); return inValue; }
		if (HX_FIELD_EQ(inName,"blendDst") ) { if (inCallProp) return set_blendDst(inValue);blendDst=inValue.Cast< ::h3d::mat::Blend >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"depthTest") ) { if (inCallProp) return set_depthTest(inValue);depthTest=inValue.Cast< ::h3d::mat::Compare >(); return inValue; }
		if (HX_FIELD_EQ(inName,"colorMask") ) { if (inCallProp) return set_colorMask(inValue);colorMask=inValue.Cast< int >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"depthWrite") ) { if (inCallProp) return set_depthWrite(inValue);depthWrite=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"renderPass") ) { renderPass=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Material_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("bits"));
	outFields->push(HX_CSTRING("culling"));
	outFields->push(HX_CSTRING("depthWrite"));
	outFields->push(HX_CSTRING("depthTest"));
	outFields->push(HX_CSTRING("blendSrc"));
	outFields->push(HX_CSTRING("blendDst"));
	outFields->push(HX_CSTRING("colorMask"));
	outFields->push(HX_CSTRING("shader"));
	outFields->push(HX_CSTRING("renderPass"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(Material_obj,bits),HX_CSTRING("bits")},
	{hx::fsObject /*::h3d::mat::Face*/ ,(int)offsetof(Material_obj,culling),HX_CSTRING("culling")},
	{hx::fsBool,(int)offsetof(Material_obj,depthWrite),HX_CSTRING("depthWrite")},
	{hx::fsObject /*::h3d::mat::Compare*/ ,(int)offsetof(Material_obj,depthTest),HX_CSTRING("depthTest")},
	{hx::fsObject /*::h3d::mat::Blend*/ ,(int)offsetof(Material_obj,blendSrc),HX_CSTRING("blendSrc")},
	{hx::fsObject /*::h3d::mat::Blend*/ ,(int)offsetof(Material_obj,blendDst),HX_CSTRING("blendDst")},
	{hx::fsInt,(int)offsetof(Material_obj,colorMask),HX_CSTRING("colorMask")},
	{hx::fsObject /*::h3d::impl::Shader*/ ,(int)offsetof(Material_obj,shader),HX_CSTRING("shader")},
	{hx::fsInt,(int)offsetof(Material_obj,renderPass),HX_CSTRING("renderPass")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("bits"),
	HX_CSTRING("culling"),
	HX_CSTRING("depthWrite"),
	HX_CSTRING("depthTest"),
	HX_CSTRING("blendSrc"),
	HX_CSTRING("blendDst"),
	HX_CSTRING("colorMask"),
	HX_CSTRING("shader"),
	HX_CSTRING("renderPass"),
	HX_CSTRING("setup"),
	HX_CSTRING("blend"),
	HX_CSTRING("clone"),
	HX_CSTRING("depth"),
	HX_CSTRING("setColorMask"),
	HX_CSTRING("set_culling"),
	HX_CSTRING("set_depthWrite"),
	HX_CSTRING("set_depthTest"),
	HX_CSTRING("set_blendSrc"),
	HX_CSTRING("set_blendDst"),
	HX_CSTRING("set_colorMask"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Material_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Material_obj::__mClass,"__mClass");
};

#endif

Class Material_obj::__mClass;

void Material_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.mat.Material"), hx::TCanCast< Material_obj> ,sStaticFields,sMemberFields,
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

void Material_obj::__boot()
{
}

} // end namespace h3d
} // end namespace mat
