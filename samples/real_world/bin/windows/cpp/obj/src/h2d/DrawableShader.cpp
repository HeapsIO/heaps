#include <hxcpp.h>

#ifndef INCLUDED_h2d_DrawableShader
#include <h2d/DrawableShader.h>
#endif
#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
#endif
#ifndef INCLUDED_h3d_Vector
#include <h3d/Vector.h>
#endif
#ifndef INCLUDED_h3d_impl_Shader
#include <h3d/impl/Shader.h>
#endif
#ifndef INCLUDED_h3d_mat_Texture
#include <h3d/mat/Texture.h>
#endif
namespace h2d{

Void DrawableShader_obj::__construct()
{
HX_STACK_FRAME("h2d.DrawableShader","new",0x6d538989,"h2d.DrawableShader.new","h2d/Drawable.hx",3,0xa05adb4b)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(4)
	this->ref = (int)1;
	HX_STACK_LINE(3)
	super::__construct();
}
;
	return null();
}

//DrawableShader_obj::~DrawableShader_obj() { }

Dynamic DrawableShader_obj::__CreateEmpty() { return  new DrawableShader_obj; }
hx::ObjectPtr< DrawableShader_obj > DrawableShader_obj::__new()
{  hx::ObjectPtr< DrawableShader_obj > result = new DrawableShader_obj();
	result->__construct();
	return result;}

Dynamic DrawableShader_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< DrawableShader_obj > result = new DrawableShader_obj();
	result->__construct();
	return result;}

::String DrawableShader_obj::getConstants( bool vertex){
	HX_STACK_FRAME("h2d.DrawableShader","getConstants",0x6b706cd0,"h2d.DrawableShader.getConstants","h2d/Drawable.hx",119,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(vertex,"vertex")
	HX_STACK_LINE(120)
	Array< ::String > cst = Array_obj< ::String >::__new();		HX_STACK_VAR(cst,"cst");
	HX_STACK_LINE(121)
	if ((vertex)){
		HX_STACK_LINE(122)
		if (((this->size != null()))){
			HX_STACK_LINE(122)
			cst->push(HX_CSTRING("#define hasSize"));
		}
		HX_STACK_LINE(123)
		if (((this->uvScale != null()))){
			HX_STACK_LINE(123)
			cst->push(HX_CSTRING("#define hasUVScale"));
		}
		HX_STACK_LINE(124)
		if (((this->uvPos != null()))){
			HX_STACK_LINE(124)
			cst->push(HX_CSTRING("#define hasUVPos"));
		}
	}
	else{
		HX_STACK_LINE(126)
		if ((this->killAlpha)){
			HX_STACK_LINE(126)
			cst->push(HX_CSTRING("#define killAlpha"));
		}
		HX_STACK_LINE(127)
		if ((this->hasColorKey)){
			HX_STACK_LINE(127)
			cst->push(HX_CSTRING("#define hasColorKey"));
		}
		HX_STACK_LINE(128)
		if ((this->hasAlpha)){
			HX_STACK_LINE(128)
			cst->push(HX_CSTRING("#define hasAlpha"));
		}
		HX_STACK_LINE(129)
		if (((this->colorMatrix != null()))){
			HX_STACK_LINE(129)
			cst->push(HX_CSTRING("#define hasColorMatrix"));
		}
		HX_STACK_LINE(130)
		if (((this->colorMul != null()))){
			HX_STACK_LINE(130)
			cst->push(HX_CSTRING("#define hasColorMul"));
		}
		HX_STACK_LINE(131)
		if (((this->colorAdd != null()))){
			HX_STACK_LINE(131)
			cst->push(HX_CSTRING("#define hasColorAdd"));
		}
	}
	HX_STACK_LINE(133)
	if ((this->hasVertexAlpha)){
		HX_STACK_LINE(133)
		cst->push(HX_CSTRING("#define hasVertexAlpha"));
	}
	HX_STACK_LINE(134)
	if ((this->hasVertexColor)){
		HX_STACK_LINE(134)
		cst->push(HX_CSTRING("#define hasVertexColor"));
	}
	HX_STACK_LINE(135)
	if ((this->hasAlphaMap)){
		HX_STACK_LINE(135)
		cst->push(HX_CSTRING("#define hasAlphaMap"));
	}
	HX_STACK_LINE(136)
	if ((this->hasMultMap)){
		HX_STACK_LINE(136)
		cst->push(HX_CSTRING("#define hasMultMap"));
	}
	HX_STACK_LINE(137)
	if ((this->isAlphaPremul)){
		HX_STACK_LINE(137)
		cst->push(HX_CSTRING("#define isAlphaPremul"));
	}
	HX_STACK_LINE(138)
	return cst->join(HX_CSTRING("\n"));
}


::String DrawableShader_obj::VERTEX;

::String DrawableShader_obj::FRAGMENT;


DrawableShader_obj::DrawableShader_obj()
{
}

void DrawableShader_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(DrawableShader);
	HX_MARK_MEMBER_NAME(ref,"ref");
	HX_MARK_MEMBER_NAME(hasColorKey,"hasColorKey");
	HX_MARK_MEMBER_NAME(sinusDeform,"sinusDeform");
	HX_MARK_MEMBER_NAME(filter,"filter");
	HX_MARK_MEMBER_NAME(tileWrap,"tileWrap");
	HX_MARK_MEMBER_NAME(killAlpha,"killAlpha");
	HX_MARK_MEMBER_NAME(hasAlpha,"hasAlpha");
	HX_MARK_MEMBER_NAME(hasVertexAlpha,"hasVertexAlpha");
	HX_MARK_MEMBER_NAME(hasVertexColor,"hasVertexColor");
	HX_MARK_MEMBER_NAME(hasAlphaMap,"hasAlphaMap");
	HX_MARK_MEMBER_NAME(hasMultMap,"hasMultMap");
	HX_MARK_MEMBER_NAME(isAlphaPremul,"isAlphaPremul");
	HX_MARK_MEMBER_NAME(size,"size");
	HX_MARK_MEMBER_NAME(matA,"matA");
	HX_MARK_MEMBER_NAME(matB,"matB");
	HX_MARK_MEMBER_NAME(zValue,"zValue");
	HX_MARK_MEMBER_NAME(uvPos,"uvPos");
	HX_MARK_MEMBER_NAME(uvScale,"uvScale");
	HX_MARK_MEMBER_NAME(tex,"tex");
	HX_MARK_MEMBER_NAME(alphaUV,"alphaUV");
	HX_MARK_MEMBER_NAME(alphaMap,"alphaMap");
	HX_MARK_MEMBER_NAME(multMapFactor,"multMapFactor");
	HX_MARK_MEMBER_NAME(multUV,"multUV");
	HX_MARK_MEMBER_NAME(multMap,"multMap");
	HX_MARK_MEMBER_NAME(alpha,"alpha");
	HX_MARK_MEMBER_NAME(colorKey,"colorKey");
	HX_MARK_MEMBER_NAME(colorAdd,"colorAdd");
	HX_MARK_MEMBER_NAME(colorMul,"colorMul");
	HX_MARK_MEMBER_NAME(colorMatrix,"colorMatrix");
	::h3d::impl::Shader_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void DrawableShader_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(ref,"ref");
	HX_VISIT_MEMBER_NAME(hasColorKey,"hasColorKey");
	HX_VISIT_MEMBER_NAME(sinusDeform,"sinusDeform");
	HX_VISIT_MEMBER_NAME(filter,"filter");
	HX_VISIT_MEMBER_NAME(tileWrap,"tileWrap");
	HX_VISIT_MEMBER_NAME(killAlpha,"killAlpha");
	HX_VISIT_MEMBER_NAME(hasAlpha,"hasAlpha");
	HX_VISIT_MEMBER_NAME(hasVertexAlpha,"hasVertexAlpha");
	HX_VISIT_MEMBER_NAME(hasVertexColor,"hasVertexColor");
	HX_VISIT_MEMBER_NAME(hasAlphaMap,"hasAlphaMap");
	HX_VISIT_MEMBER_NAME(hasMultMap,"hasMultMap");
	HX_VISIT_MEMBER_NAME(isAlphaPremul,"isAlphaPremul");
	HX_VISIT_MEMBER_NAME(size,"size");
	HX_VISIT_MEMBER_NAME(matA,"matA");
	HX_VISIT_MEMBER_NAME(matB,"matB");
	HX_VISIT_MEMBER_NAME(zValue,"zValue");
	HX_VISIT_MEMBER_NAME(uvPos,"uvPos");
	HX_VISIT_MEMBER_NAME(uvScale,"uvScale");
	HX_VISIT_MEMBER_NAME(tex,"tex");
	HX_VISIT_MEMBER_NAME(alphaUV,"alphaUV");
	HX_VISIT_MEMBER_NAME(alphaMap,"alphaMap");
	HX_VISIT_MEMBER_NAME(multMapFactor,"multMapFactor");
	HX_VISIT_MEMBER_NAME(multUV,"multUV");
	HX_VISIT_MEMBER_NAME(multMap,"multMap");
	HX_VISIT_MEMBER_NAME(alpha,"alpha");
	HX_VISIT_MEMBER_NAME(colorKey,"colorKey");
	HX_VISIT_MEMBER_NAME(colorAdd,"colorAdd");
	HX_VISIT_MEMBER_NAME(colorMul,"colorMul");
	HX_VISIT_MEMBER_NAME(colorMatrix,"colorMatrix");
	::h3d::impl::Shader_obj::__Visit(HX_VISIT_ARG);
}

Dynamic DrawableShader_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"ref") ) { return ref; }
		if (HX_FIELD_EQ(inName,"tex") ) { return tex; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"size") ) { return size; }
		if (HX_FIELD_EQ(inName,"matA") ) { return matA; }
		if (HX_FIELD_EQ(inName,"matB") ) { return matB; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"uvPos") ) { return uvPos; }
		if (HX_FIELD_EQ(inName,"alpha") ) { return alpha; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"VERTEX") ) { return VERTEX; }
		if (HX_FIELD_EQ(inName,"filter") ) { return filter; }
		if (HX_FIELD_EQ(inName,"zValue") ) { return zValue; }
		if (HX_FIELD_EQ(inName,"multUV") ) { return multUV; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"uvScale") ) { return uvScale; }
		if (HX_FIELD_EQ(inName,"alphaUV") ) { return alphaUV; }
		if (HX_FIELD_EQ(inName,"multMap") ) { return multMap; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"FRAGMENT") ) { return FRAGMENT; }
		if (HX_FIELD_EQ(inName,"tileWrap") ) { return tileWrap; }
		if (HX_FIELD_EQ(inName,"hasAlpha") ) { return hasAlpha; }
		if (HX_FIELD_EQ(inName,"alphaMap") ) { return alphaMap; }
		if (HX_FIELD_EQ(inName,"colorKey") ) { return colorKey; }
		if (HX_FIELD_EQ(inName,"colorAdd") ) { return colorAdd; }
		if (HX_FIELD_EQ(inName,"colorMul") ) { return colorMul; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"killAlpha") ) { return killAlpha; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"hasMultMap") ) { return hasMultMap; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"hasColorKey") ) { return hasColorKey; }
		if (HX_FIELD_EQ(inName,"sinusDeform") ) { return sinusDeform; }
		if (HX_FIELD_EQ(inName,"hasAlphaMap") ) { return hasAlphaMap; }
		if (HX_FIELD_EQ(inName,"colorMatrix") ) { return colorMatrix; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"getConstants") ) { return getConstants_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"isAlphaPremul") ) { return isAlphaPremul; }
		if (HX_FIELD_EQ(inName,"multMapFactor") ) { return multMapFactor; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"hasVertexAlpha") ) { return hasVertexAlpha; }
		if (HX_FIELD_EQ(inName,"hasVertexColor") ) { return hasVertexColor; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic DrawableShader_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"ref") ) { ref=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"tex") ) { tex=inValue.Cast< ::h3d::mat::Texture >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"size") ) { size=inValue.Cast< ::h3d::Vector >(); return inValue; }
		if (HX_FIELD_EQ(inName,"matA") ) { matA=inValue.Cast< ::h3d::Vector >(); return inValue; }
		if (HX_FIELD_EQ(inName,"matB") ) { matB=inValue.Cast< ::h3d::Vector >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"uvPos") ) { uvPos=inValue.Cast< ::h3d::Vector >(); return inValue; }
		if (HX_FIELD_EQ(inName,"alpha") ) { alpha=inValue.Cast< Float >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"VERTEX") ) { VERTEX=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"filter") ) { filter=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"zValue") ) { zValue=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"multUV") ) { multUV=inValue.Cast< ::h3d::Vector >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"uvScale") ) { uvScale=inValue.Cast< ::h3d::Vector >(); return inValue; }
		if (HX_FIELD_EQ(inName,"alphaUV") ) { alphaUV=inValue.Cast< ::h3d::Vector >(); return inValue; }
		if (HX_FIELD_EQ(inName,"multMap") ) { multMap=inValue.Cast< ::h3d::mat::Texture >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"FRAGMENT") ) { FRAGMENT=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"tileWrap") ) { tileWrap=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"hasAlpha") ) { hasAlpha=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"alphaMap") ) { alphaMap=inValue.Cast< ::h3d::mat::Texture >(); return inValue; }
		if (HX_FIELD_EQ(inName,"colorKey") ) { colorKey=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"colorAdd") ) { colorAdd=inValue.Cast< ::h3d::Vector >(); return inValue; }
		if (HX_FIELD_EQ(inName,"colorMul") ) { colorMul=inValue.Cast< ::h3d::Vector >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"killAlpha") ) { killAlpha=inValue.Cast< bool >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"hasMultMap") ) { hasMultMap=inValue.Cast< bool >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"hasColorKey") ) { hasColorKey=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"sinusDeform") ) { sinusDeform=inValue.Cast< ::h3d::Vector >(); return inValue; }
		if (HX_FIELD_EQ(inName,"hasAlphaMap") ) { hasAlphaMap=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"colorMatrix") ) { colorMatrix=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"isAlphaPremul") ) { isAlphaPremul=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"multMapFactor") ) { multMapFactor=inValue.Cast< Float >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"hasVertexAlpha") ) { hasVertexAlpha=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"hasVertexColor") ) { hasVertexColor=inValue.Cast< bool >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void DrawableShader_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("ref"));
	outFields->push(HX_CSTRING("hasColorKey"));
	outFields->push(HX_CSTRING("sinusDeform"));
	outFields->push(HX_CSTRING("filter"));
	outFields->push(HX_CSTRING("tileWrap"));
	outFields->push(HX_CSTRING("killAlpha"));
	outFields->push(HX_CSTRING("hasAlpha"));
	outFields->push(HX_CSTRING("hasVertexAlpha"));
	outFields->push(HX_CSTRING("hasVertexColor"));
	outFields->push(HX_CSTRING("hasAlphaMap"));
	outFields->push(HX_CSTRING("hasMultMap"));
	outFields->push(HX_CSTRING("isAlphaPremul"));
	outFields->push(HX_CSTRING("size"));
	outFields->push(HX_CSTRING("matA"));
	outFields->push(HX_CSTRING("matB"));
	outFields->push(HX_CSTRING("zValue"));
	outFields->push(HX_CSTRING("uvPos"));
	outFields->push(HX_CSTRING("uvScale"));
	outFields->push(HX_CSTRING("tex"));
	outFields->push(HX_CSTRING("alphaUV"));
	outFields->push(HX_CSTRING("alphaMap"));
	outFields->push(HX_CSTRING("multMapFactor"));
	outFields->push(HX_CSTRING("multUV"));
	outFields->push(HX_CSTRING("multMap"));
	outFields->push(HX_CSTRING("alpha"));
	outFields->push(HX_CSTRING("colorKey"));
	outFields->push(HX_CSTRING("colorAdd"));
	outFields->push(HX_CSTRING("colorMul"));
	outFields->push(HX_CSTRING("colorMatrix"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("VERTEX"),
	HX_CSTRING("FRAGMENT"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(DrawableShader_obj,ref),HX_CSTRING("ref")},
	{hx::fsBool,(int)offsetof(DrawableShader_obj,hasColorKey),HX_CSTRING("hasColorKey")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(DrawableShader_obj,sinusDeform),HX_CSTRING("sinusDeform")},
	{hx::fsBool,(int)offsetof(DrawableShader_obj,filter),HX_CSTRING("filter")},
	{hx::fsBool,(int)offsetof(DrawableShader_obj,tileWrap),HX_CSTRING("tileWrap")},
	{hx::fsBool,(int)offsetof(DrawableShader_obj,killAlpha),HX_CSTRING("killAlpha")},
	{hx::fsBool,(int)offsetof(DrawableShader_obj,hasAlpha),HX_CSTRING("hasAlpha")},
	{hx::fsBool,(int)offsetof(DrawableShader_obj,hasVertexAlpha),HX_CSTRING("hasVertexAlpha")},
	{hx::fsBool,(int)offsetof(DrawableShader_obj,hasVertexColor),HX_CSTRING("hasVertexColor")},
	{hx::fsBool,(int)offsetof(DrawableShader_obj,hasAlphaMap),HX_CSTRING("hasAlphaMap")},
	{hx::fsBool,(int)offsetof(DrawableShader_obj,hasMultMap),HX_CSTRING("hasMultMap")},
	{hx::fsBool,(int)offsetof(DrawableShader_obj,isAlphaPremul),HX_CSTRING("isAlphaPremul")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(DrawableShader_obj,size),HX_CSTRING("size")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(DrawableShader_obj,matA),HX_CSTRING("matA")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(DrawableShader_obj,matB),HX_CSTRING("matB")},
	{hx::fsFloat,(int)offsetof(DrawableShader_obj,zValue),HX_CSTRING("zValue")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(DrawableShader_obj,uvPos),HX_CSTRING("uvPos")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(DrawableShader_obj,uvScale),HX_CSTRING("uvScale")},
	{hx::fsObject /*::h3d::mat::Texture*/ ,(int)offsetof(DrawableShader_obj,tex),HX_CSTRING("tex")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(DrawableShader_obj,alphaUV),HX_CSTRING("alphaUV")},
	{hx::fsObject /*::h3d::mat::Texture*/ ,(int)offsetof(DrawableShader_obj,alphaMap),HX_CSTRING("alphaMap")},
	{hx::fsFloat,(int)offsetof(DrawableShader_obj,multMapFactor),HX_CSTRING("multMapFactor")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(DrawableShader_obj,multUV),HX_CSTRING("multUV")},
	{hx::fsObject /*::h3d::mat::Texture*/ ,(int)offsetof(DrawableShader_obj,multMap),HX_CSTRING("multMap")},
	{hx::fsFloat,(int)offsetof(DrawableShader_obj,alpha),HX_CSTRING("alpha")},
	{hx::fsInt,(int)offsetof(DrawableShader_obj,colorKey),HX_CSTRING("colorKey")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(DrawableShader_obj,colorAdd),HX_CSTRING("colorAdd")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(DrawableShader_obj,colorMul),HX_CSTRING("colorMul")},
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(DrawableShader_obj,colorMatrix),HX_CSTRING("colorMatrix")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("ref"),
	HX_CSTRING("hasColorKey"),
	HX_CSTRING("sinusDeform"),
	HX_CSTRING("filter"),
	HX_CSTRING("tileWrap"),
	HX_CSTRING("killAlpha"),
	HX_CSTRING("hasAlpha"),
	HX_CSTRING("hasVertexAlpha"),
	HX_CSTRING("hasVertexColor"),
	HX_CSTRING("hasAlphaMap"),
	HX_CSTRING("hasMultMap"),
	HX_CSTRING("isAlphaPremul"),
	HX_CSTRING("getConstants"),
	HX_CSTRING("size"),
	HX_CSTRING("matA"),
	HX_CSTRING("matB"),
	HX_CSTRING("zValue"),
	HX_CSTRING("uvPos"),
	HX_CSTRING("uvScale"),
	HX_CSTRING("tex"),
	HX_CSTRING("alphaUV"),
	HX_CSTRING("alphaMap"),
	HX_CSTRING("multMapFactor"),
	HX_CSTRING("multUV"),
	HX_CSTRING("multMap"),
	HX_CSTRING("alpha"),
	HX_CSTRING("colorKey"),
	HX_CSTRING("colorAdd"),
	HX_CSTRING("colorMul"),
	HX_CSTRING("colorMatrix"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(DrawableShader_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(DrawableShader_obj::VERTEX,"VERTEX");
	HX_MARK_MEMBER_NAME(DrawableShader_obj::FRAGMENT,"FRAGMENT");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(DrawableShader_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(DrawableShader_obj::VERTEX,"VERTEX");
	HX_VISIT_MEMBER_NAME(DrawableShader_obj::FRAGMENT,"FRAGMENT");
};

#endif

Class DrawableShader_obj::__mClass;

void DrawableShader_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.DrawableShader"), hx::TCanCast< DrawableShader_obj> ,sStaticFields,sMemberFields,
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

void DrawableShader_obj::__boot()
{
	VERTEX= HX_CSTRING("\r\n\t\r\n\t\tattribute vec2 pos;\r\n\t\tattribute vec2 uv;\r\n\t\t#if hasVertexAlpha\r\n\t\tattribute float valpha;\r\n\t\tvarying lowp float talpha;\r\n\t\t#end\r\n\t\t#if hasVertexColor\r\n\t\tattribute vec4 vcolor;\r\n\t\tvarying lowp vec4 tcolor;\r\n\t\t#end\r\n\r\n        #if hasSize\r\n\t\tuniform vec3 size;\r\n\t\t#end\r\n\t\tuniform vec3 matA;\r\n\t\tuniform vec3 matB;\r\n\t\tuniform float zValue;\r\n\t\t\r\n        #if hasUVPos\r\n\t\tuniform vec2 uvPos;\r\n\t\t#end\r\n        #if hasUVScale\r\n\t\tuniform vec2 uvScale;\r\n\t\t#end\r\n\t\t\r\n\t\tvarying vec2 tuv;\r\n\r\n\t\tvoid main(void) {\r\n\t\t\tvec3 spos = vec3(pos.x,pos.y, 1.0);\r\n\t\t\t#if hasSize\r\n\t\t\t\tspos = spos * size;\r\n\t\t\t#end\r\n\t\t\tvec4 tmp;\r\n\t\t\ttmp.x = dot(spos,matA);\r\n\t\t\ttmp.y = dot(spos,matB);\r\n\t\t\ttmp.z = zValue;\r\n\t\t\ttmp.w = 1.;\r\n\t\t\tgl_Position = tmp;\r\n\t\t\tlowp vec2 t = uv;\r\n\t\t\t#if hasUVScale\r\n\t\t\t\tt *= uvScale;\r\n\t\t\t#end\r\n\t\t\t#if hasUVPos\r\n\t\t\t\tt += uvPos;\r\n\t\t\t#end\r\n\t\t\ttuv = t;\r\n\t\t\t#if hasVertexAlpha\r\n\t\t\t\ttalpha = valpha;\r\n\t\t\t#end\r\n\t\t\t#if hasVertexColor\r\n\t\t\t\ttcolor = vcolor;\r\n\t\t\t#end\r\n\t\t}\r\n\r\n\t");
	FRAGMENT= HX_CSTRING("\r\n\t\r\n\t\tvarying vec2 tuv;\r\n\t\tuniform sampler2D tex;\r\n\t\t\r\n\t\t#if hasVertexAlpha\r\n\t\tvarying float talpha;\r\n\t\t#end\r\n\t\t\r\n\t\t#if hasVertexColor\r\n\t\tvarying vec4 tcolor;\r\n\t\t#end\r\n\t\t\r\n\t\t#if hasAlphaMap\r\n\t\t\tuniform vec4 alphaUV;\r\n\t\t\tuniform sampler2D alphaMap;\r\n\t\t#end\r\n\t\t\r\n\t\t#if hasMultMap\r\n\t\t\tuniform float multMapFactor;\r\n\t\t\tuniform vec4 multUV;\r\n\t\t\tuniform sampler2D multMap;\r\n\t\t#end\r\n\t\t\r\n\t\tuniform float alpha;\r\n\t\tuniform vec3 colorKey/*byte4*/;\r\n\t\r\n\t\tuniform vec4 colorAdd;\r\n\t\tuniform vec4 colorMul;\r\n\t\tuniform mat4 colorMatrix;\r\n\r\n\t\tvoid main(void) {\r\n\t\t\tvec4 col = texture2D(tex, tuv).rgba;\r\n\t\t\t\r\n\t\t\t#if killAlpha\r\n\t\t\t\tif( col.a - 0.001 <= 0.0 ) discard;\r\n\t\t\t#end\r\n\t\t\t\r\n\t\t\t#if hasColorKey\r\n\t\t\t\tvec3 dc = col.rgb - colorKey;\r\n\t\t\t\tif( dot(dc, dc) < 0.001 ) discard;\r\n\t\t\t#end\r\n\t\t\t\r\n\t\t\t#if isAlphaPremul\r\n\t\t\t\tcol.rgb /= col.a;\r\n\t\t\t#end \r\n\t\t\t\r\n\t\t\t#if hasVertexAlpha\r\n\t\t\t\tcol.a *= talpha;\r\n\t\t\t#end \r\n\t\t\t\r\n\t\t\t#if hasVertexColor\r\n\t\t\t\tcol *= tcolor;\r\n\t\t\t#end\r\n\t\t\t\r\n\t\t\t#if hasAlphaMap\r\n\t\t\t\tcol.a *= texture2D( alphaMap, tuv * alphaUV.zw + alphaUV.xy).r;\r\n\t\t\t#end\r\n\t\t\t\r\n\t\t\t#if hasMultMap\r\n\t\t\t\tcol *= multMapFactor * texture2D(multMap,tuv * multUV.zw + multUV.xy);\r\n\t\t\t#end\r\n\t\t\t\r\n\t\t\t#if hasAlpha\r\n\t\t\t\tcol.a *= alpha;\r\n\t\t\t#end\r\n\t\t\t#if hasColorMatrix\r\n\t\t\t\tcol *= colorMatrix;\r\n\t\t\t#end\r\n\t\t\t#if hasColorMul\r\n\t\t\t\tcol *= colorMul;\r\n\t\t\t#end\r\n\t\t\t#if hasColorAdd\r\n\t\t\t\tcol += colorAdd;\r\n\t\t\t#end\r\n\t\t\t\r\n\t\t\t#if isAlphaPremul\r\n\t\t\t\tcol.rgb *= col.a;\r\n\t\t\t#end \r\n\t\t\t\r\n\t\t\tgl_FragColor = col;\r\n\t\t}\r\n\t\t\t\r\n\t");
}

} // end namespace h2d
