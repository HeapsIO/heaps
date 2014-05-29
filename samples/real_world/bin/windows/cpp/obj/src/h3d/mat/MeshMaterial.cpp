#include <hxcpp.h>

#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
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
#ifndef INCLUDED_h3d_mat_Material
#include <h3d/mat/Material.h>
#endif
#ifndef INCLUDED_h3d_mat_MeshMaterial
#include <h3d/mat/MeshMaterial.h>
#endif
#ifndef INCLUDED_h3d_mat_MeshShader
#include <h3d/mat/MeshShader.h>
#endif
#ifndef INCLUDED_h3d_mat_Texture
#include <h3d/mat/Texture.h>
#endif
#ifndef INCLUDED_h3d_scene_RenderContext
#include <h3d/scene/RenderContext.h>
#endif
namespace h3d{
namespace mat{

Void MeshMaterial_obj::__construct(::h3d::mat::Texture texture,::h3d::mat::MeshShader sh)
{
HX_STACK_FRAME("h3d.mat.MeshMaterial","new",0x8c2f3fa9,"h3d.mat.MeshMaterial.new","h3d/mat/MeshMaterial.hx",514,0xfa8cf5a5)
HX_STACK_THIS(this)
HX_STACK_ARG(texture,"texture")
HX_STACK_ARG(sh,"sh")
{
	HX_STACK_LINE(552)
	this->id = (int)-1;
	HX_STACK_LINE(555)
	::h3d::mat::MeshShader _g;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(555)
	if (((sh == null()))){
		HX_STACK_LINE(555)
		_g = ::h3d::mat::MeshShader_obj::__new();
	}
	else{
		HX_STACK_LINE(555)
		_g = sh;
	}
	HX_STACK_LINE(555)
	this->set_mshader(_g);
	HX_STACK_LINE(556)
	::h3d::mat::MeshShader _g1 = this->get_mshader();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(556)
	super::__construct(_g1);
	HX_STACK_LINE(557)
	this->texture = texture;
	HX_STACK_LINE(558)
	this->useMatrixPos = true;
	HX_STACK_LINE(559)
	this->get_mshader()->killAlphaThreshold = 0.001;
	HX_STACK_LINE(560)
	int _g2 = (::h3d::mat::MeshMaterial_obj::uid)++;		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(560)
	this->id = _g2;
}
;
	return null();
}

//MeshMaterial_obj::~MeshMaterial_obj() { }

Dynamic MeshMaterial_obj::__CreateEmpty() { return  new MeshMaterial_obj; }
hx::ObjectPtr< MeshMaterial_obj > MeshMaterial_obj::__new(::h3d::mat::Texture texture,::h3d::mat::MeshShader sh)
{  hx::ObjectPtr< MeshMaterial_obj > result = new MeshMaterial_obj();
	result->__construct(texture,sh);
	return result;}

Dynamic MeshMaterial_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< MeshMaterial_obj > result = new MeshMaterial_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

::h3d::mat::Material MeshMaterial_obj::clone( ::h3d::mat::Material m){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","clone",0x156fa6e6,"h3d.mat.MeshMaterial.clone","h3d/mat/MeshMaterial.hx",563,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(m,"m")
	HX_STACK_LINE(564)
	::h3d::mat::MeshMaterial m1;		HX_STACK_VAR(m1,"m1");
	HX_STACK_LINE(564)
	if (((m == null()))){
		HX_STACK_LINE(564)
		m1 = ::h3d::mat::MeshMaterial_obj::__new(this->texture,null());
	}
	else{
		HX_STACK_LINE(564)
		m1 = m;
	}
	HX_STACK_LINE(565)
	this->super::clone(m1);
	HX_STACK_LINE(566)
	m1->useMatrixPos = this->useMatrixPos;
	HX_STACK_LINE(567)
	m1->get_mshader()->uvScale = this->get_mshader()->uvScale;
	HX_STACK_LINE(568)
	m1->get_mshader()->uvDelta = this->get_mshader()->uvDelta;
	HX_STACK_LINE(569)
	m1->get_mshader()->killAlpha = this->get_mshader()->killAlpha;
	HX_STACK_LINE(570)
	m1->get_mshader()->hasVertexColor = this->get_mshader()->hasVertexColor;
	HX_STACK_LINE(571)
	m1->get_mshader()->hasVertexColorAdd = this->get_mshader()->hasVertexColorAdd;
	HX_STACK_LINE(572)
	m1->get_mshader()->colorAdd = this->get_mshader()->colorAdd;
	HX_STACK_LINE(573)
	m1->get_mshader()->colorMul = this->get_mshader()->colorMul;
	HX_STACK_LINE(574)
	m1->get_mshader()->colorMatrix = this->get_mshader()->colorMatrix;
	HX_STACK_LINE(575)
	m1->get_mshader()->hasSkin = this->get_mshader()->hasSkin;
	HX_STACK_LINE(576)
	m1->set_skinMatrixes(this->get_mshader()->skinMatrixes);
	HX_STACK_LINE(577)
	{
		HX_STACK_LINE(577)
		Dynamic v = this->get_mshader()->lightSystem;		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(577)
		if (((bool((bool((v != null())) && bool(m1->get_mshader()->hasSkin))) && bool(((v->__Field(HX_CSTRING("dirs"),true)->__Field(HX_CSTRING("length"),true) + v->__Field(HX_CSTRING("points"),true)->__Field(HX_CSTRING("length"),true)) > (int)6))))){
			HX_STACK_LINE(577)
			HX_STACK_DO_THROW(((HX_CSTRING("Maximum 6 lights are allowed with skinning (") + ((v->__Field(HX_CSTRING("dirs"),true)->__Field(HX_CSTRING("length"),true) + v->__Field(HX_CSTRING("points"),true)->__Field(HX_CSTRING("length"),true)))) + HX_CSTRING(" set)")));
		}
		HX_STACK_LINE(577)
		m1->get_mshader()->set_lightSystem(v);
	}
	HX_STACK_LINE(578)
	{
		HX_STACK_LINE(578)
		::h3d::mat::Texture m2 = this->get_mshader()->alphaMap;		HX_STACK_VAR(m2,"m2");
		HX_STACK_LINE(578)
		m1->get_mshader()->hasAlphaMap = (m2 != null());
		HX_STACK_LINE(578)
		m1->get_mshader()->alphaMap = m2;
	}
	HX_STACK_LINE(579)
	m1->get_mshader()->fog = this->get_mshader()->fog;
	HX_STACK_LINE(580)
	{
		HX_STACK_LINE(580)
		Dynamic v;		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(580)
		if ((this->get_mshader()->hasZBias)){
			HX_STACK_LINE(580)
			v = this->get_mshader()->zBias;
		}
		else{
			HX_STACK_LINE(580)
			v = null();
		}
		HX_STACK_LINE(580)
		m1->get_mshader()->hasZBias = (v != null());
		HX_STACK_LINE(580)
		m1->get_mshader()->zBias = v;
		HX_STACK_LINE(580)
		v;
	}
	HX_STACK_LINE(581)
	{
		HX_STACK_LINE(581)
		::h3d::mat::Texture v = this->get_mshader()->blendTexture;		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(581)
		m1->get_mshader()->hasBlend = (v != null());
		HX_STACK_LINE(581)
		m1->get_mshader()->blendTexture = v;
	}
	HX_STACK_LINE(582)
	m1->get_mshader()->killAlphaThreshold = this->get_mshader()->killAlphaThreshold;
	HX_STACK_LINE(583)
	return m1;
}


Void MeshMaterial_obj::setup( ::h3d::scene::RenderContext ctx){
{
		HX_STACK_FRAME("h3d.mat.MeshMaterial","setup",0x473c4206,"h3d.mat.MeshMaterial.setup","h3d/mat/MeshMaterial.hx",586,0xfa8cf5a5)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ctx,"ctx")
		HX_STACK_LINE(588)
		if (((this->texture == null()))){
			HX_STACK_LINE(588)
			HX_STACK_DO_THROW(HX_CSTRING("At some stage, you must pass a texture for this to work"));
		}
		HX_STACK_LINE(590)
		if ((this->useMatrixPos)){
			HX_STACK_LINE(590)
			this->get_mshader()->mpos = ctx->localPos;
		}
		else{
			HX_STACK_LINE(590)
			this->get_mshader()->mpos = null();
		}
		HX_STACK_LINE(591)
		this->get_mshader()->mproj = ctx->engine->curProjMatrix;
		HX_STACK_LINE(592)
		this->get_mshader()->tex = this->texture;
	}
return null();
}


::h3d::mat::MeshShader MeshMaterial_obj::get_mshader( ){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","get_mshader",0x89f80fb2,"h3d.mat.MeshMaterial.get_mshader","h3d/mat/MeshMaterial.hx",603,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(603)
	return this->shader;
}


HX_DEFINE_DYNAMIC_FUNC0(MeshMaterial_obj,get_mshader,return )

::h3d::mat::MeshShader MeshMaterial_obj::set_mshader( ::h3d::mat::MeshShader v){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","set_mshader",0x946516be,"h3d.mat.MeshMaterial.set_mshader","h3d/mat/MeshMaterial.hx",606,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(607)
	this->shader = v;
	HX_STACK_LINE(608)
	return v;
}


HX_DEFINE_DYNAMIC_FUNC1(MeshMaterial_obj,set_mshader,return )

Void MeshMaterial_obj::setDXTSupport( bool enable,hx::Null< bool >  __o_alpha){
bool alpha = __o_alpha.Default(false);
	HX_STACK_FRAME("h3d.mat.MeshMaterial","setDXTSupport",0x4c15945a,"h3d.mat.MeshMaterial.setDXTSupport","h3d/mat/MeshMaterial.hx",624,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(enable,"enable")
	HX_STACK_ARG(alpha,"alpha")
{
		HX_STACK_LINE(624)
		HX_STACK_DO_THROW(HX_CSTRING("Not implemented"));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(MeshMaterial_obj,setDXTSupport,(void))

::h3d::Vector MeshMaterial_obj::get_uvScale( ){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","get_uvScale",0xf39bd8c9,"h3d.mat.MeshMaterial.get_uvScale","h3d/mat/MeshMaterial.hx",629,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(629)
	return this->get_mshader()->uvScale;
}


HX_DEFINE_DYNAMIC_FUNC0(MeshMaterial_obj,get_uvScale,return )

::h3d::Vector MeshMaterial_obj::set_uvScale( ::h3d::Vector v){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","set_uvScale",0xfe08dfd5,"h3d.mat.MeshMaterial.set_uvScale","h3d/mat/MeshMaterial.hx",633,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(633)
	return this->get_mshader()->uvScale = v;
}


HX_DEFINE_DYNAMIC_FUNC1(MeshMaterial_obj,set_uvScale,return )

::h3d::Vector MeshMaterial_obj::get_uvDelta( ){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","get_uvDelta",0x51f3f237,"h3d.mat.MeshMaterial.get_uvDelta","h3d/mat/MeshMaterial.hx",637,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(637)
	return this->get_mshader()->uvDelta;
}


HX_DEFINE_DYNAMIC_FUNC0(MeshMaterial_obj,get_uvDelta,return )

::h3d::Vector MeshMaterial_obj::set_uvDelta( ::h3d::Vector v){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","set_uvDelta",0x5c60f943,"h3d.mat.MeshMaterial.set_uvDelta","h3d/mat/MeshMaterial.hx",641,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(641)
	return this->get_mshader()->uvDelta = v;
}


HX_DEFINE_DYNAMIC_FUNC1(MeshMaterial_obj,set_uvDelta,return )

bool MeshMaterial_obj::get_killAlpha( ){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","get_killAlpha",0x0be17340,"h3d.mat.MeshMaterial.get_killAlpha","h3d/mat/MeshMaterial.hx",645,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(645)
	return this->get_mshader()->killAlpha;
}


HX_DEFINE_DYNAMIC_FUNC0(MeshMaterial_obj,get_killAlpha,return )

bool MeshMaterial_obj::set_killAlpha( bool v){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","set_killAlpha",0x50e7554c,"h3d.mat.MeshMaterial.set_killAlpha","h3d/mat/MeshMaterial.hx",649,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(649)
	return this->get_mshader()->killAlpha = v;
}


HX_DEFINE_DYNAMIC_FUNC1(MeshMaterial_obj,set_killAlpha,return )

::h3d::Vector MeshMaterial_obj::get_colorAdd( ){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","get_colorAdd",0xfef68c1e,"h3d.mat.MeshMaterial.get_colorAdd","h3d/mat/MeshMaterial.hx",653,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(653)
	return this->get_mshader()->colorAdd;
}


HX_DEFINE_DYNAMIC_FUNC0(MeshMaterial_obj,get_colorAdd,return )

::h3d::Vector MeshMaterial_obj::set_colorAdd( ::h3d::Vector v){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","set_colorAdd",0x13efaf92,"h3d.mat.MeshMaterial.set_colorAdd","h3d/mat/MeshMaterial.hx",657,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(657)
	return this->get_mshader()->colorAdd = v;
}


HX_DEFINE_DYNAMIC_FUNC1(MeshMaterial_obj,set_colorAdd,return )

::h3d::Vector MeshMaterial_obj::get_colorMul( ){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","get_colorMul",0xfeffb601,"h3d.mat.MeshMaterial.get_colorMul","h3d/mat/MeshMaterial.hx",661,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(661)
	return this->get_mshader()->colorMul;
}


HX_DEFINE_DYNAMIC_FUNC0(MeshMaterial_obj,get_colorMul,return )

::h3d::Vector MeshMaterial_obj::set_colorMul( ::h3d::Vector v){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","set_colorMul",0x13f8d975,"h3d.mat.MeshMaterial.set_colorMul","h3d/mat/MeshMaterial.hx",665,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(665)
	return this->get_mshader()->colorMul = v;
}


HX_DEFINE_DYNAMIC_FUNC1(MeshMaterial_obj,set_colorMul,return )

::h3d::Matrix MeshMaterial_obj::get_colorMatrix( ){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","get_colorMatrix",0xf97c3864,"h3d.mat.MeshMaterial.get_colorMatrix","h3d/mat/MeshMaterial.hx",669,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(669)
	return this->get_mshader()->colorMatrix;
}


HX_DEFINE_DYNAMIC_FUNC0(MeshMaterial_obj,get_colorMatrix,return )

::h3d::Matrix MeshMaterial_obj::set_colorMatrix( ::h3d::Matrix v){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","set_colorMatrix",0xf547b570,"h3d.mat.MeshMaterial.set_colorMatrix","h3d/mat/MeshMaterial.hx",673,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(673)
	return this->get_mshader()->colorMatrix = v;
}


HX_DEFINE_DYNAMIC_FUNC1(MeshMaterial_obj,set_colorMatrix,return )

bool MeshMaterial_obj::get_hasSkin( ){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","get_hasSkin",0xd3ccf757,"h3d.mat.MeshMaterial.get_hasSkin","h3d/mat/MeshMaterial.hx",677,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(677)
	return this->get_mshader()->hasSkin;
}


HX_DEFINE_DYNAMIC_FUNC0(MeshMaterial_obj,get_hasSkin,return )

bool MeshMaterial_obj::set_hasSkin( bool v){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","set_hasSkin",0xde39fe63,"h3d.mat.MeshMaterial.set_hasSkin","h3d/mat/MeshMaterial.hx",681,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(681)
	return this->get_mshader()->hasSkin = v;
}


HX_DEFINE_DYNAMIC_FUNC1(MeshMaterial_obj,set_hasSkin,return )

bool MeshMaterial_obj::get_hasVertexColor( ){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","get_hasVertexColor",0x9cd189c5,"h3d.mat.MeshMaterial.get_hasVertexColor","h3d/mat/MeshMaterial.hx",685,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(685)
	return this->get_mshader()->hasVertexColor;
}


HX_DEFINE_DYNAMIC_FUNC0(MeshMaterial_obj,get_hasVertexColor,return )

bool MeshMaterial_obj::set_hasVertexColor( bool v){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","set_hasVertexColor",0x7980bc39,"h3d.mat.MeshMaterial.set_hasVertexColor","h3d/mat/MeshMaterial.hx",689,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(689)
	return this->get_mshader()->hasVertexColor = v;
}


HX_DEFINE_DYNAMIC_FUNC1(MeshMaterial_obj,set_hasVertexColor,return )

bool MeshMaterial_obj::get_hasVertexColorAdd( ){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","get_hasVertexColorAdd",0x8c72c95c,"h3d.mat.MeshMaterial.get_hasVertexColorAdd","h3d/mat/MeshMaterial.hx",693,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(693)
	return this->get_mshader()->hasVertexColorAdd;
}


HX_DEFINE_DYNAMIC_FUNC0(MeshMaterial_obj,get_hasVertexColorAdd,return )

bool MeshMaterial_obj::set_hasVertexColorAdd( bool v){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","set_hasVertexColorAdd",0xe07b9768,"h3d.mat.MeshMaterial.set_hasVertexColorAdd","h3d/mat/MeshMaterial.hx",697,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(697)
	return this->get_mshader()->hasVertexColorAdd = v;
}


HX_DEFINE_DYNAMIC_FUNC1(MeshMaterial_obj,set_hasVertexColorAdd,return )

Array< ::Dynamic > MeshMaterial_obj::get_skinMatrixes( ){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","get_skinMatrixes",0xbf575c2c,"h3d.mat.MeshMaterial.get_skinMatrixes","h3d/mat/MeshMaterial.hx",701,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(701)
	return this->get_mshader()->skinMatrixes;
}


HX_DEFINE_DYNAMIC_FUNC0(MeshMaterial_obj,get_skinMatrixes,return )

Array< ::Dynamic > MeshMaterial_obj::set_skinMatrixes( Array< ::Dynamic > v){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","set_skinMatrixes",0x159949a0,"h3d.mat.MeshMaterial.set_skinMatrixes","h3d/mat/MeshMaterial.hx",704,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(707)
	if (((bool((v != null())) && bool((v->length > (int)35))))){
		HX_STACK_LINE(708)
		HX_STACK_DO_THROW(((HX_CSTRING("Maximum 35 bones are allowed for skinning (has ") + v->length) + HX_CSTRING(")")));
	}
	HX_STACK_LINE(710)
	return this->get_mshader()->skinMatrixes = v;
}


HX_DEFINE_DYNAMIC_FUNC1(MeshMaterial_obj,set_skinMatrixes,return )

Dynamic MeshMaterial_obj::get_lightSystem( ){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","get_lightSystem",0xdabc50c5,"h3d.mat.MeshMaterial.get_lightSystem","h3d/mat/MeshMaterial.hx",714,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(714)
	return this->get_mshader()->lightSystem;
}


HX_DEFINE_DYNAMIC_FUNC0(MeshMaterial_obj,get_lightSystem,return )

Dynamic MeshMaterial_obj::set_lightSystem( Dynamic v){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","set_lightSystem",0xd687cdd1,"h3d.mat.MeshMaterial.set_lightSystem","h3d/mat/MeshMaterial.hx",717,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(718)
	if (((bool((bool((v != null())) && bool(this->get_mshader()->hasSkin))) && bool(((v->__Field(HX_CSTRING("dirs"),true)->__Field(HX_CSTRING("length"),true) + v->__Field(HX_CSTRING("points"),true)->__Field(HX_CSTRING("length"),true)) > (int)6))))){
		HX_STACK_LINE(719)
		HX_STACK_DO_THROW(((HX_CSTRING("Maximum 6 lights are allowed with skinning (") + ((v->__Field(HX_CSTRING("dirs"),true)->__Field(HX_CSTRING("length"),true) + v->__Field(HX_CSTRING("points"),true)->__Field(HX_CSTRING("length"),true)))) + HX_CSTRING(" set)")));
	}
	HX_STACK_LINE(720)
	return this->get_mshader()->set_lightSystem(v);
}


HX_DEFINE_DYNAMIC_FUNC1(MeshMaterial_obj,set_lightSystem,return )

::h3d::mat::Texture MeshMaterial_obj::get_alphaMap( ){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","get_alphaMap",0x963d1d7e,"h3d.mat.MeshMaterial.get_alphaMap","h3d/mat/MeshMaterial.hx",724,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(724)
	return this->get_mshader()->alphaMap;
}


HX_DEFINE_DYNAMIC_FUNC0(MeshMaterial_obj,get_alphaMap,return )

::h3d::mat::Texture MeshMaterial_obj::set_alphaMap( ::h3d::mat::Texture m){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","set_alphaMap",0xab3640f2,"h3d.mat.MeshMaterial.set_alphaMap","h3d/mat/MeshMaterial.hx",727,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(m,"m")
	HX_STACK_LINE(728)
	this->get_mshader()->hasAlphaMap = (m != null());
	HX_STACK_LINE(729)
	return this->get_mshader()->alphaMap = m;
}


HX_DEFINE_DYNAMIC_FUNC1(MeshMaterial_obj,set_alphaMap,return )

Dynamic MeshMaterial_obj::get_zBias( ){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","get_zBias",0xbab3c473,"h3d.mat.MeshMaterial.get_zBias","h3d/mat/MeshMaterial.hx",733,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(733)
	if ((this->get_mshader()->hasZBias)){
		HX_STACK_LINE(733)
		return this->get_mshader()->zBias;
	}
	else{
		HX_STACK_LINE(733)
		return null();
	}
	HX_STACK_LINE(733)
	return 0.;
}


HX_DEFINE_DYNAMIC_FUNC0(MeshMaterial_obj,get_zBias,return )

Dynamic MeshMaterial_obj::set_zBias( Dynamic v){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","set_zBias",0x9e04b07f,"h3d.mat.MeshMaterial.set_zBias","h3d/mat/MeshMaterial.hx",736,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(737)
	this->get_mshader()->hasZBias = (v != null());
	HX_STACK_LINE(738)
	this->get_mshader()->zBias = v;
	HX_STACK_LINE(739)
	return v;
}


HX_DEFINE_DYNAMIC_FUNC1(MeshMaterial_obj,set_zBias,return )

::h3d::mat::Texture MeshMaterial_obj::get_glowTexture( ){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","get_glowTexture",0xf5c4ae2e,"h3d.mat.MeshMaterial.get_glowTexture","h3d/mat/MeshMaterial.hx",743,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(743)
	return this->get_mshader()->glowTexture;
}


HX_DEFINE_DYNAMIC_FUNC0(MeshMaterial_obj,get_glowTexture,return )

::h3d::mat::Texture MeshMaterial_obj::set_glowTexture( ::h3d::mat::Texture t){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","set_glowTexture",0xf1902b3a,"h3d.mat.MeshMaterial.set_glowTexture","h3d/mat/MeshMaterial.hx",746,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(t,"t")
	HX_STACK_LINE(747)
	this->get_mshader()->hasGlow = (t != null());
	HX_STACK_LINE(748)
	return this->get_mshader()->glowTexture = t;
}


HX_DEFINE_DYNAMIC_FUNC1(MeshMaterial_obj,set_glowTexture,return )

Float MeshMaterial_obj::get_glowAmount( ){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","get_glowAmount",0xd8d877e5,"h3d.mat.MeshMaterial.get_glowAmount","h3d/mat/MeshMaterial.hx",752,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(752)
	return this->get_mshader()->glowAmount;
}


HX_DEFINE_DYNAMIC_FUNC0(MeshMaterial_obj,get_glowAmount,return )

Float MeshMaterial_obj::set_glowAmount( Float v){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","set_glowAmount",0xf8f86059,"h3d.mat.MeshMaterial.set_glowAmount","h3d/mat/MeshMaterial.hx",756,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(756)
	return this->get_mshader()->glowAmount = v;
}


HX_DEFINE_DYNAMIC_FUNC1(MeshMaterial_obj,set_glowAmount,return )

::h3d::Vector MeshMaterial_obj::get_fog( ){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","get_fog",0xbec1d75e,"h3d.mat.MeshMaterial.get_fog","h3d/mat/MeshMaterial.hx",760,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(760)
	return this->get_mshader()->fog;
}


HX_DEFINE_DYNAMIC_FUNC0(MeshMaterial_obj,get_fog,return )

::h3d::Vector MeshMaterial_obj::set_fog( ::h3d::Vector v){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","set_fog",0xb1c3686a,"h3d.mat.MeshMaterial.set_fog","h3d/mat/MeshMaterial.hx",764,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(764)
	return this->get_mshader()->fog = v;
}


HX_DEFINE_DYNAMIC_FUNC1(MeshMaterial_obj,set_fog,return )

::h3d::mat::Texture MeshMaterial_obj::get_blendTexture( ){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","get_blendTexture",0x6497082a,"h3d.mat.MeshMaterial.get_blendTexture","h3d/mat/MeshMaterial.hx",768,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(768)
	return this->get_mshader()->blendTexture;
}


HX_DEFINE_DYNAMIC_FUNC0(MeshMaterial_obj,get_blendTexture,return )

::h3d::mat::Texture MeshMaterial_obj::set_blendTexture( ::h3d::mat::Texture v){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","set_blendTexture",0xbad8f59e,"h3d.mat.MeshMaterial.set_blendTexture","h3d/mat/MeshMaterial.hx",771,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(772)
	this->get_mshader()->hasBlend = (v != null());
	HX_STACK_LINE(773)
	return this->get_mshader()->blendTexture = v;
}


HX_DEFINE_DYNAMIC_FUNC1(MeshMaterial_obj,set_blendTexture,return )

Float MeshMaterial_obj::get_killAlphaThreshold( ){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","get_killAlphaThreshold",0x4cecc84b,"h3d.mat.MeshMaterial.get_killAlphaThreshold","h3d/mat/MeshMaterial.hx",777,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(777)
	return this->get_mshader()->killAlphaThreshold;
}


HX_DEFINE_DYNAMIC_FUNC0(MeshMaterial_obj,get_killAlphaThreshold,return )

Float MeshMaterial_obj::set_killAlphaThreshold( Float v){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","set_killAlphaThreshold",0x809844bf,"h3d.mat.MeshMaterial.set_killAlphaThreshold","h3d/mat/MeshMaterial.hx",781,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(781)
	return this->get_mshader()->killAlphaThreshold = v;
}


HX_DEFINE_DYNAMIC_FUNC1(MeshMaterial_obj,set_killAlphaThreshold,return )

Dynamic MeshMaterial_obj::set_shadowMap( Dynamic v){
	HX_STACK_FRAME("h3d.mat.MeshMaterial","set_shadowMap",0x3692a108,"h3d.mat.MeshMaterial.set_shadowMap","h3d/mat/MeshMaterial.hx",784,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(785)
	if (((v != null()))){
		HX_STACK_LINE(786)
		this->get_mshader()->hasShadowMap = true;
		HX_STACK_LINE(787)
		this->get_mshader()->shadowColor = v->__Field(HX_CSTRING("color"),true);
		HX_STACK_LINE(788)
		this->get_mshader()->shadowTexture = v->__Field(HX_CSTRING("texture"),true);
		HX_STACK_LINE(789)
		this->get_mshader()->shadowLightProj = v->__Field(HX_CSTRING("lightProj"),true);
		HX_STACK_LINE(790)
		this->get_mshader()->shadowLightCenter = v->__Field(HX_CSTRING("lightCenter"),true);
	}
	else{
		HX_STACK_LINE(792)
		this->get_mshader()->hasShadowMap = false;
	}
	HX_STACK_LINE(793)
	return v;
}


HX_DEFINE_DYNAMIC_FUNC1(MeshMaterial_obj,set_shadowMap,return )

int MeshMaterial_obj::uid;


MeshMaterial_obj::MeshMaterial_obj()
{
}

void MeshMaterial_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(MeshMaterial);
	HX_MARK_MEMBER_NAME(texture,"texture");
	HX_MARK_MEMBER_NAME(useMatrixPos,"useMatrixPos");
	HX_MARK_MEMBER_NAME(shadowMap,"shadowMap");
	HX_MARK_MEMBER_NAME(id,"id");
	::h3d::mat::Material_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void MeshMaterial_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(texture,"texture");
	HX_VISIT_MEMBER_NAME(useMatrixPos,"useMatrixPos");
	HX_VISIT_MEMBER_NAME(shadowMap,"shadowMap");
	HX_VISIT_MEMBER_NAME(id,"id");
	::h3d::mat::Material_obj::__Visit(HX_VISIT_ARG);
}

Dynamic MeshMaterial_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"id") ) { return id; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"uid") ) { return uid; }
		if (HX_FIELD_EQ(inName,"fog") ) { return get_fog(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"zBias") ) { return get_zBias(); }
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		if (HX_FIELD_EQ(inName,"setup") ) { return setup_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"mshader") ) { return get_mshader(); }
		if (HX_FIELD_EQ(inName,"texture") ) { return texture; }
		if (HX_FIELD_EQ(inName,"uvScale") ) { return get_uvScale(); }
		if (HX_FIELD_EQ(inName,"uvDelta") ) { return get_uvDelta(); }
		if (HX_FIELD_EQ(inName,"hasSkin") ) { return get_hasSkin(); }
		if (HX_FIELD_EQ(inName,"get_fog") ) { return get_fog_dyn(); }
		if (HX_FIELD_EQ(inName,"set_fog") ) { return set_fog_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"colorAdd") ) { return get_colorAdd(); }
		if (HX_FIELD_EQ(inName,"colorMul") ) { return get_colorMul(); }
		if (HX_FIELD_EQ(inName,"alphaMap") ) { return get_alphaMap(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"killAlpha") ) { return get_killAlpha(); }
		if (HX_FIELD_EQ(inName,"shadowMap") ) { return shadowMap; }
		if (HX_FIELD_EQ(inName,"get_zBias") ) { return get_zBias_dyn(); }
		if (HX_FIELD_EQ(inName,"set_zBias") ) { return set_zBias_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"glowAmount") ) { return get_glowAmount(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"glowTexture") ) { return get_glowTexture(); }
		if (HX_FIELD_EQ(inName,"colorMatrix") ) { return get_colorMatrix(); }
		if (HX_FIELD_EQ(inName,"lightSystem") ) { return get_lightSystem(); }
		if (HX_FIELD_EQ(inName,"get_mshader") ) { return get_mshader_dyn(); }
		if (HX_FIELD_EQ(inName,"set_mshader") ) { return set_mshader_dyn(); }
		if (HX_FIELD_EQ(inName,"get_uvScale") ) { return get_uvScale_dyn(); }
		if (HX_FIELD_EQ(inName,"set_uvScale") ) { return set_uvScale_dyn(); }
		if (HX_FIELD_EQ(inName,"get_uvDelta") ) { return get_uvDelta_dyn(); }
		if (HX_FIELD_EQ(inName,"set_uvDelta") ) { return set_uvDelta_dyn(); }
		if (HX_FIELD_EQ(inName,"get_hasSkin") ) { return get_hasSkin_dyn(); }
		if (HX_FIELD_EQ(inName,"set_hasSkin") ) { return set_hasSkin_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"useMatrixPos") ) { return useMatrixPos; }
		if (HX_FIELD_EQ(inName,"skinMatrixes") ) { return get_skinMatrixes(); }
		if (HX_FIELD_EQ(inName,"blendTexture") ) { return get_blendTexture(); }
		if (HX_FIELD_EQ(inName,"get_colorAdd") ) { return get_colorAdd_dyn(); }
		if (HX_FIELD_EQ(inName,"set_colorAdd") ) { return set_colorAdd_dyn(); }
		if (HX_FIELD_EQ(inName,"get_colorMul") ) { return get_colorMul_dyn(); }
		if (HX_FIELD_EQ(inName,"set_colorMul") ) { return set_colorMul_dyn(); }
		if (HX_FIELD_EQ(inName,"get_alphaMap") ) { return get_alphaMap_dyn(); }
		if (HX_FIELD_EQ(inName,"set_alphaMap") ) { return set_alphaMap_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"setDXTSupport") ) { return setDXTSupport_dyn(); }
		if (HX_FIELD_EQ(inName,"get_killAlpha") ) { return get_killAlpha_dyn(); }
		if (HX_FIELD_EQ(inName,"set_killAlpha") ) { return set_killAlpha_dyn(); }
		if (HX_FIELD_EQ(inName,"set_shadowMap") ) { return set_shadowMap_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"hasVertexColor") ) { return get_hasVertexColor(); }
		if (HX_FIELD_EQ(inName,"get_glowAmount") ) { return get_glowAmount_dyn(); }
		if (HX_FIELD_EQ(inName,"set_glowAmount") ) { return set_glowAmount_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"get_colorMatrix") ) { return get_colorMatrix_dyn(); }
		if (HX_FIELD_EQ(inName,"set_colorMatrix") ) { return set_colorMatrix_dyn(); }
		if (HX_FIELD_EQ(inName,"get_lightSystem") ) { return get_lightSystem_dyn(); }
		if (HX_FIELD_EQ(inName,"set_lightSystem") ) { return set_lightSystem_dyn(); }
		if (HX_FIELD_EQ(inName,"get_glowTexture") ) { return get_glowTexture_dyn(); }
		if (HX_FIELD_EQ(inName,"set_glowTexture") ) { return set_glowTexture_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"get_skinMatrixes") ) { return get_skinMatrixes_dyn(); }
		if (HX_FIELD_EQ(inName,"set_skinMatrixes") ) { return set_skinMatrixes_dyn(); }
		if (HX_FIELD_EQ(inName,"get_blendTexture") ) { return get_blendTexture_dyn(); }
		if (HX_FIELD_EQ(inName,"set_blendTexture") ) { return set_blendTexture_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"hasVertexColorAdd") ) { return get_hasVertexColorAdd(); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"killAlphaThreshold") ) { return get_killAlphaThreshold(); }
		if (HX_FIELD_EQ(inName,"get_hasVertexColor") ) { return get_hasVertexColor_dyn(); }
		if (HX_FIELD_EQ(inName,"set_hasVertexColor") ) { return set_hasVertexColor_dyn(); }
		break;
	case 21:
		if (HX_FIELD_EQ(inName,"get_hasVertexColorAdd") ) { return get_hasVertexColorAdd_dyn(); }
		if (HX_FIELD_EQ(inName,"set_hasVertexColorAdd") ) { return set_hasVertexColorAdd_dyn(); }
		break;
	case 22:
		if (HX_FIELD_EQ(inName,"get_killAlphaThreshold") ) { return get_killAlphaThreshold_dyn(); }
		if (HX_FIELD_EQ(inName,"set_killAlphaThreshold") ) { return set_killAlphaThreshold_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic MeshMaterial_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"id") ) { id=inValue.Cast< int >(); return inValue; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"uid") ) { uid=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"fog") ) { return set_fog(inValue); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"zBias") ) { return set_zBias(inValue); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"mshader") ) { return set_mshader(inValue); }
		if (HX_FIELD_EQ(inName,"texture") ) { texture=inValue.Cast< ::h3d::mat::Texture >(); return inValue; }
		if (HX_FIELD_EQ(inName,"uvScale") ) { return set_uvScale(inValue); }
		if (HX_FIELD_EQ(inName,"uvDelta") ) { return set_uvDelta(inValue); }
		if (HX_FIELD_EQ(inName,"hasSkin") ) { return set_hasSkin(inValue); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"colorAdd") ) { return set_colorAdd(inValue); }
		if (HX_FIELD_EQ(inName,"colorMul") ) { return set_colorMul(inValue); }
		if (HX_FIELD_EQ(inName,"alphaMap") ) { return set_alphaMap(inValue); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"killAlpha") ) { return set_killAlpha(inValue); }
		if (HX_FIELD_EQ(inName,"shadowMap") ) { if (inCallProp) return set_shadowMap(inValue);shadowMap=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"glowAmount") ) { return set_glowAmount(inValue); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"glowTexture") ) { return set_glowTexture(inValue); }
		if (HX_FIELD_EQ(inName,"colorMatrix") ) { return set_colorMatrix(inValue); }
		if (HX_FIELD_EQ(inName,"lightSystem") ) { return set_lightSystem(inValue); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"useMatrixPos") ) { useMatrixPos=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"skinMatrixes") ) { return set_skinMatrixes(inValue); }
		if (HX_FIELD_EQ(inName,"blendTexture") ) { return set_blendTexture(inValue); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"hasVertexColor") ) { return set_hasVertexColor(inValue); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"hasVertexColorAdd") ) { return set_hasVertexColorAdd(inValue); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"killAlphaThreshold") ) { return set_killAlphaThreshold(inValue); }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void MeshMaterial_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("mshader"));
	outFields->push(HX_CSTRING("texture"));
	outFields->push(HX_CSTRING("glowTexture"));
	outFields->push(HX_CSTRING("glowAmount"));
	outFields->push(HX_CSTRING("useMatrixPos"));
	outFields->push(HX_CSTRING("uvScale"));
	outFields->push(HX_CSTRING("uvDelta"));
	outFields->push(HX_CSTRING("killAlpha"));
	outFields->push(HX_CSTRING("hasVertexColor"));
	outFields->push(HX_CSTRING("hasVertexColorAdd"));
	outFields->push(HX_CSTRING("colorAdd"));
	outFields->push(HX_CSTRING("colorMul"));
	outFields->push(HX_CSTRING("colorMatrix"));
	outFields->push(HX_CSTRING("hasSkin"));
	outFields->push(HX_CSTRING("skinMatrixes"));
	outFields->push(HX_CSTRING("lightSystem"));
	outFields->push(HX_CSTRING("alphaMap"));
	outFields->push(HX_CSTRING("fog"));
	outFields->push(HX_CSTRING("zBias"));
	outFields->push(HX_CSTRING("blendTexture"));
	outFields->push(HX_CSTRING("killAlphaThreshold"));
	outFields->push(HX_CSTRING("shadowMap"));
	outFields->push(HX_CSTRING("id"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("uid"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h3d::mat::Texture*/ ,(int)offsetof(MeshMaterial_obj,texture),HX_CSTRING("texture")},
	{hx::fsBool,(int)offsetof(MeshMaterial_obj,useMatrixPos),HX_CSTRING("useMatrixPos")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(MeshMaterial_obj,shadowMap),HX_CSTRING("shadowMap")},
	{hx::fsInt,(int)offsetof(MeshMaterial_obj,id),HX_CSTRING("id")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("texture"),
	HX_CSTRING("useMatrixPos"),
	HX_CSTRING("shadowMap"),
	HX_CSTRING("id"),
	HX_CSTRING("clone"),
	HX_CSTRING("setup"),
	HX_CSTRING("get_mshader"),
	HX_CSTRING("set_mshader"),
	HX_CSTRING("setDXTSupport"),
	HX_CSTRING("get_uvScale"),
	HX_CSTRING("set_uvScale"),
	HX_CSTRING("get_uvDelta"),
	HX_CSTRING("set_uvDelta"),
	HX_CSTRING("get_killAlpha"),
	HX_CSTRING("set_killAlpha"),
	HX_CSTRING("get_colorAdd"),
	HX_CSTRING("set_colorAdd"),
	HX_CSTRING("get_colorMul"),
	HX_CSTRING("set_colorMul"),
	HX_CSTRING("get_colorMatrix"),
	HX_CSTRING("set_colorMatrix"),
	HX_CSTRING("get_hasSkin"),
	HX_CSTRING("set_hasSkin"),
	HX_CSTRING("get_hasVertexColor"),
	HX_CSTRING("set_hasVertexColor"),
	HX_CSTRING("get_hasVertexColorAdd"),
	HX_CSTRING("set_hasVertexColorAdd"),
	HX_CSTRING("get_skinMatrixes"),
	HX_CSTRING("set_skinMatrixes"),
	HX_CSTRING("get_lightSystem"),
	HX_CSTRING("set_lightSystem"),
	HX_CSTRING("get_alphaMap"),
	HX_CSTRING("set_alphaMap"),
	HX_CSTRING("get_zBias"),
	HX_CSTRING("set_zBias"),
	HX_CSTRING("get_glowTexture"),
	HX_CSTRING("set_glowTexture"),
	HX_CSTRING("get_glowAmount"),
	HX_CSTRING("set_glowAmount"),
	HX_CSTRING("get_fog"),
	HX_CSTRING("set_fog"),
	HX_CSTRING("get_blendTexture"),
	HX_CSTRING("set_blendTexture"),
	HX_CSTRING("get_killAlphaThreshold"),
	HX_CSTRING("set_killAlphaThreshold"),
	HX_CSTRING("set_shadowMap"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(MeshMaterial_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(MeshMaterial_obj::uid,"uid");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(MeshMaterial_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(MeshMaterial_obj::uid,"uid");
};

#endif

Class MeshMaterial_obj::__mClass;

void MeshMaterial_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.mat.MeshMaterial"), hx::TCanCast< MeshMaterial_obj> ,sStaticFields,sMemberFields,
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

void MeshMaterial_obj::__boot()
{
	uid= (int)0;
}

} // end namespace h3d
} // end namespace mat
