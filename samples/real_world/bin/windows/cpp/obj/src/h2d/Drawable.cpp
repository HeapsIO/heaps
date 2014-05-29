#include <hxcpp.h>

#ifndef INCLUDED_h2d_BlendMode
#include <h2d/BlendMode.h>
#endif
#ifndef INCLUDED_h2d_Drawable
#include <h2d/Drawable.h>
#endif
#ifndef INCLUDED_h2d_DrawableShader
#include <h2d/DrawableShader.h>
#endif
#ifndef INCLUDED_h2d_Sprite
#include <h2d/Sprite.h>
#endif
#ifndef INCLUDED_h2d_Tile
#include <h2d/Tile.h>
#endif
#ifndef INCLUDED_h2d_Tools
#include <h2d/Tools.h>
#endif
#ifndef INCLUDED_h2d__Tools_CoreObjects
#include <h2d/_Tools/CoreObjects.h>
#endif
#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
#endif
#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
#endif
#ifndef INCLUDED_h3d_Vector
#include <h3d/Vector.h>
#endif
#ifndef INCLUDED_h3d_impl_Buffer
#include <h3d/impl/Buffer.h>
#endif
#ifndef INCLUDED_h3d_impl_Indexes
#include <h3d/impl/Indexes.h>
#endif
#ifndef INCLUDED_h3d_impl_MemoryManager
#include <h3d/impl/MemoryManager.h>
#endif
#ifndef INCLUDED_h3d_impl_Shader
#include <h3d/impl/Shader.h>
#endif
#ifndef INCLUDED_h3d_mat_Blend
#include <h3d/mat/Blend.h>
#endif
#ifndef INCLUDED_h3d_mat_Filter
#include <h3d/mat/Filter.h>
#endif
#ifndef INCLUDED_h3d_mat_Material
#include <h3d/mat/Material.h>
#endif
#ifndef INCLUDED_h3d_mat_Texture
#include <h3d/mat/Texture.h>
#endif
namespace h2d{

Void Drawable_obj::__construct(::h2d::Sprite parent,::h2d::DrawableShader sh)
{
HX_STACK_FRAME("h2d.Drawable","new",0x69690644,"h2d.Drawable.new","h2d/Drawable.hx",323,0xa05adb4b)
HX_STACK_THIS(this)
HX_STACK_ARG(parent,"parent")
HX_STACK_ARG(sh,"sh")
{
	HX_STACK_LINE(324)
	super::__construct(parent);
	HX_STACK_LINE(326)
	this->writeAlpha = true;
	HX_STACK_LINE(327)
	this->set_blendMode(::h2d::BlendMode_obj::Normal);
	HX_STACK_LINE(329)
	::h2d::DrawableShader _g;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(329)
	if (((sh == null()))){
		HX_STACK_LINE(329)
		_g = ::h2d::DrawableShader_obj::__new();
	}
	else{
		HX_STACK_LINE(329)
		_g = sh;
	}
	HX_STACK_LINE(329)
	this->shader = _g;
	HX_STACK_LINE(330)
	this->shader->alpha = (int)1;
	HX_STACK_LINE(331)
	this->shader->multMapFactor = 1.0;
	HX_STACK_LINE(332)
	this->shader->zValue = (int)0;
	HX_STACK_LINE(333)
	if (((sh != null()))){
		HX_STACK_LINE(334)
		(this->shader->ref)++;
	}
}
;
	return null();
}

//Drawable_obj::~Drawable_obj() { }

Dynamic Drawable_obj::__CreateEmpty() { return  new Drawable_obj; }
hx::ObjectPtr< Drawable_obj > Drawable_obj::__new(::h2d::Sprite parent,::h2d::DrawableShader sh)
{  hx::ObjectPtr< Drawable_obj > result = new Drawable_obj();
	result->__construct(parent,sh);
	return result;}

Dynamic Drawable_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Drawable_obj > result = new Drawable_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

bool Drawable_obj::get_hasAlpha( ){
	HX_STACK_FRAME("h2d.Drawable","get_hasAlpha",0x5c779349,"h2d.Drawable.get_hasAlpha","h2d/Drawable.hx",341,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(341)
	return this->shader->hasAlpha;
}


HX_DEFINE_DYNAMIC_FUNC0(Drawable_obj,get_hasAlpha,return )

bool Drawable_obj::set_hasAlpha( bool v){
	HX_STACK_FRAME("h2d.Drawable","set_hasAlpha",0x7170b6bd,"h2d.Drawable.set_hasAlpha","h2d/Drawable.hx",342,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(342)
	return this->shader->hasAlpha = v;
}


HX_DEFINE_DYNAMIC_FUNC1(Drawable_obj,set_hasAlpha,return )

Float Drawable_obj::get_alpha( ){
	HX_STACK_FRAME("h2d.Drawable","get_alpha",0x46c8bc99,"h2d.Drawable.get_alpha","h2d/Drawable.hx",344,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(344)
	return this->shader->alpha;
}


HX_DEFINE_DYNAMIC_FUNC0(Drawable_obj,get_alpha,return )

Float Drawable_obj::set_alpha( Float v){
	HX_STACK_FRAME("h2d.Drawable","set_alpha",0x2a19a8a5,"h2d.Drawable.set_alpha","h2d/Drawable.hx",345,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(346)
	this->shader->alpha = v;
	HX_STACK_LINE(347)
	this->shader->hasAlpha = (v < (int)1);
	HX_STACK_LINE(348)
	return v;
}


HX_DEFINE_DYNAMIC_FUNC1(Drawable_obj,set_alpha,return )

::h2d::BlendMode Drawable_obj::set_blendMode( ::h2d::BlendMode b){
	HX_STACK_FRAME("h2d.Drawable","set_blendMode",0x5a42951b,"h2d.Drawable.set_blendMode","h2d/Drawable.hx",364,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(365)
	this->blendMode = b;
	HX_STACK_LINE(366)
	return b;
}


HX_DEFINE_DYNAMIC_FUNC1(Drawable_obj,set_blendMode,return )

Float Drawable_obj::get_multiplyFactor( ){
	HX_STACK_FRAME("h2d.Drawable","get_multiplyFactor",0x01960d78,"h2d.Drawable.get_multiplyFactor","h2d/Drawable.hx",371,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(371)
	return this->shader->multMapFactor;
}


HX_DEFINE_DYNAMIC_FUNC0(Drawable_obj,get_multiplyFactor,return )

Float Drawable_obj::set_multiplyFactor( Float v){
	HX_STACK_FRAME("h2d.Drawable","set_multiplyFactor",0xde453fec,"h2d.Drawable.set_multiplyFactor","h2d/Drawable.hx",375,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(375)
	return this->shader->multMapFactor = v;
}


HX_DEFINE_DYNAMIC_FUNC1(Drawable_obj,set_multiplyFactor,return )

::h2d::Tile Drawable_obj::set_multiplyMap( ::h2d::Tile t){
	HX_STACK_FRAME("h2d.Drawable","set_multiplyMap",0xe9e07f5f,"h2d.Drawable.set_multiplyMap","h2d/Drawable.hx",378,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(t,"t")
	HX_STACK_LINE(379)
	this->multiplyMap = t;
	HX_STACK_LINE(380)
	this->shader->hasMultMap = (t != null());
	HX_STACK_LINE(381)
	return t;
}


HX_DEFINE_DYNAMIC_FUNC1(Drawable_obj,set_multiplyMap,return )

::h2d::Tile Drawable_obj::set_alphaMap( ::h2d::Tile t){
	HX_STACK_FRAME("h2d.Drawable","set_alphaMap",0xe4aa4ef7,"h2d.Drawable.set_alphaMap","h2d/Drawable.hx",384,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(t,"t")
	HX_STACK_LINE(385)
	this->alphaMap = t;
	HX_STACK_LINE(386)
	this->shader->hasAlphaMap = (t != null());
	HX_STACK_LINE(387)
	return t;
}


HX_DEFINE_DYNAMIC_FUNC1(Drawable_obj,set_alphaMap,return )

::h3d::Vector Drawable_obj::get_sinusDeform( ){
	HX_STACK_FRAME("h2d.Drawable","get_sinusDeform",0xc2c2acd6,"h2d.Drawable.get_sinusDeform","h2d/Drawable.hx",391,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(391)
	return this->shader->sinusDeform;
}


HX_DEFINE_DYNAMIC_FUNC0(Drawable_obj,get_sinusDeform,return )

::h3d::Vector Drawable_obj::set_sinusDeform( ::h3d::Vector v){
	HX_STACK_FRAME("h2d.Drawable","set_sinusDeform",0xbe8e29e2,"h2d.Drawable.set_sinusDeform","h2d/Drawable.hx",395,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(395)
	return this->shader->sinusDeform = v;
}


HX_DEFINE_DYNAMIC_FUNC1(Drawable_obj,set_sinusDeform,return )

::h3d::Matrix Drawable_obj::get_colorMatrix( ){
	HX_STACK_FRAME("h2d.Drawable","get_colorMatrix",0x64d2fb7f,"h2d.Drawable.get_colorMatrix","h2d/Drawable.hx",399,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(399)
	return this->shader->colorMatrix;
}


HX_DEFINE_DYNAMIC_FUNC0(Drawable_obj,get_colorMatrix,return )

::h3d::Matrix Drawable_obj::set_colorMatrix( ::h3d::Matrix m){
	HX_STACK_FRAME("h2d.Drawable","set_colorMatrix",0x609e788b,"h2d.Drawable.set_colorMatrix","h2d/Drawable.hx",403,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(m,"m")
	HX_STACK_LINE(403)
	return this->shader->colorMatrix = m;
}


HX_DEFINE_DYNAMIC_FUNC1(Drawable_obj,set_colorMatrix,return )

::h3d::Vector Drawable_obj::set_color( ::h3d::Vector m){
	HX_STACK_FRAME("h2d.Drawable","set_color",0x52df72aa,"h2d.Drawable.set_color","h2d/Drawable.hx",407,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(m,"m")
	HX_STACK_LINE(407)
	return this->shader->colorMul = m;
}


HX_DEFINE_DYNAMIC_FUNC1(Drawable_obj,set_color,return )

::h3d::Vector Drawable_obj::set_colorAdd( ::h3d::Vector m){
	HX_STACK_FRAME("h2d.Drawable","set_colorAdd",0x4d63bd97,"h2d.Drawable.set_colorAdd","h2d/Drawable.hx",411,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(m,"m")
	HX_STACK_LINE(411)
	return this->shader->colorAdd = m;
}


HX_DEFINE_DYNAMIC_FUNC1(Drawable_obj,set_colorAdd,return )

::h3d::Vector Drawable_obj::get_colorAdd( ){
	HX_STACK_FRAME("h2d.Drawable","get_colorAdd",0x386a9a23,"h2d.Drawable.get_colorAdd","h2d/Drawable.hx",415,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(415)
	return this->shader->colorAdd;
}


HX_DEFINE_DYNAMIC_FUNC0(Drawable_obj,get_colorAdd,return )

::h3d::Vector Drawable_obj::get_color( ){
	HX_STACK_FRAME("h2d.Drawable","get_color",0x6f8e869e,"h2d.Drawable.get_color","h2d/Drawable.hx",419,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(419)
	return this->shader->colorMul;
}


HX_DEFINE_DYNAMIC_FUNC0(Drawable_obj,get_color,return )

bool Drawable_obj::get_filter( ){
	HX_STACK_FRAME("h2d.Drawable","get_filter",0xebd59e1d,"h2d.Drawable.get_filter","h2d/Drawable.hx",423,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(423)
	return this->shader->filter;
}


HX_DEFINE_DYNAMIC_FUNC0(Drawable_obj,get_filter,return )

bool Drawable_obj::set_filter( bool v){
	HX_STACK_FRAME("h2d.Drawable","set_filter",0xef533c91,"h2d.Drawable.set_filter","h2d/Drawable.hx",427,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(427)
	return this->shader->filter = v;
}


HX_DEFINE_DYNAMIC_FUNC1(Drawable_obj,set_filter,return )

bool Drawable_obj::get_tileWrap( ){
	HX_STACK_FRAME("h2d.Drawable","get_tileWrap",0x378e01bd,"h2d.Drawable.get_tileWrap","h2d/Drawable.hx",431,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(431)
	return this->shader->tileWrap;
}


HX_DEFINE_DYNAMIC_FUNC0(Drawable_obj,get_tileWrap,return )

bool Drawable_obj::set_tileWrap( bool v){
	HX_STACK_FRAME("h2d.Drawable","set_tileWrap",0x4c872531,"h2d.Drawable.set_tileWrap","h2d/Drawable.hx",435,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(435)
	return this->shader->tileWrap = v;
}


HX_DEFINE_DYNAMIC_FUNC1(Drawable_obj,set_tileWrap,return )

bool Drawable_obj::get_killAlpha( ){
	HX_STACK_FRAME("h2d.Drawable","get_killAlpha",0x17f9a99b,"h2d.Drawable.get_killAlpha","h2d/Drawable.hx",439,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(439)
	return this->shader->killAlpha;
}


HX_DEFINE_DYNAMIC_FUNC0(Drawable_obj,get_killAlpha,return )

bool Drawable_obj::set_killAlpha( bool v){
	HX_STACK_FRAME("h2d.Drawable","set_killAlpha",0x5cff8ba7,"h2d.Drawable.set_killAlpha","h2d/Drawable.hx",443,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(443)
	return this->shader->killAlpha = v;
}


HX_DEFINE_DYNAMIC_FUNC1(Drawable_obj,set_killAlpha,return )

int Drawable_obj::get_colorKey( ){
	HX_STACK_FRAME("h2d.Drawable","get_colorKey",0x387231a1,"h2d.Drawable.get_colorKey","h2d/Drawable.hx",447,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(447)
	return this->shader->colorKey;
}


HX_DEFINE_DYNAMIC_FUNC0(Drawable_obj,get_colorKey,return )

int Drawable_obj::set_colorKey( int v){
	HX_STACK_FRAME("h2d.Drawable","set_colorKey",0x4d6b5515,"h2d.Drawable.set_colorKey","h2d/Drawable.hx",450,0xa05adb4b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(451)
	this->shader->hasColorKey = true;
	HX_STACK_LINE(452)
	return this->shader->colorKey = v;
}


HX_DEFINE_DYNAMIC_FUNC1(Drawable_obj,set_colorKey,return )

Void Drawable_obj::drawTile( ::h3d::Engine engine,::h2d::Tile tile){
{
		HX_STACK_FRAME("h2d.Drawable","drawTile",0xffaf64ee,"h2d.Drawable.drawTile","h2d/Drawable.hx",455,0xa05adb4b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(engine,"engine")
		HX_STACK_ARG(tile,"tile")
		HX_STACK_LINE(456)
		this->setupShader(engine,tile,(int)7);
		HX_STACK_LINE(457)
		{
			HX_STACK_LINE(457)
			int start = (int)0;		HX_STACK_VAR(start,"start");
			HX_STACK_LINE(457)
			int max = (int)-1;		HX_STACK_VAR(max,"max");
			HX_STACK_LINE(457)
			bool v = engine->renderBuffer(::h2d::Tools_obj::getCoreObjects()->planBuffer,engine->mem->quadIndexes,(int)2,start,max);		HX_STACK_VAR(v,"v");
			HX_STACK_LINE(457)
			v;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Drawable_obj,drawTile,(void))

Void Drawable_obj::setupShader( ::h3d::Engine engine,::h2d::Tile tile,int options){
{
		HX_STACK_FRAME("h2d.Drawable","setupShader",0xddaa1766,"h2d.Drawable.setupShader","h2d/Drawable.hx",460,0xa05adb4b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(engine,"engine")
		HX_STACK_ARG(tile,"tile")
		HX_STACK_ARG(options,"options")
		HX_STACK_LINE(461)
		::h2d::_Tools::CoreObjects core = ::h2d::Tools_obj::getCoreObjects();		HX_STACK_VAR(core,"core");
		HX_STACK_LINE(462)
		::h2d::DrawableShader shader = this->shader;		HX_STACK_VAR(shader,"shader");
		HX_STACK_LINE(463)
		::h3d::mat::Material mat = core->tmpMaterial;		HX_STACK_VAR(mat,"mat");
		HX_STACK_LINE(465)
		if (((tile == null()))){
			HX_STACK_LINE(466)
			::h3d::mat::Texture _g = core->getEmptyTexture();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(466)
			::h2d::Tile _g1 = ::h2d::Tile_obj::__new(_g,(int)0,(int)0,(int)5,(int)5,null(),null());		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(466)
			tile = _g1;
		}
		HX_STACK_LINE(468)
		::h3d::mat::Texture tex = tile->getTexture();		HX_STACK_VAR(tex,"tex");
		HX_STACK_LINE(470)
		::h3d::mat::Filter _g2;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(470)
		if ((this->get_filter())){
			HX_STACK_LINE(470)
			_g2 = ::h3d::mat::Filter_obj::Linear;
		}
		else{
			HX_STACK_LINE(470)
			_g2 = ::h3d::mat::Filter_obj::Nearest;
		}
		HX_STACK_LINE(470)
		tex->set_filter(_g2);
		HX_STACK_LINE(472)
		{
			HX_STACK_LINE(472)
			::h2d::BlendMode _g = this->blendMode;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(472)
			switch( (int)(_g->__Index())){
				case (int)0: {
					HX_STACK_LINE(474)
					if ((tex->alpha_premultiplied)){
						HX_STACK_LINE(475)
						mat->blend(::h3d::mat::Blend_obj::One,::h3d::mat::Blend_obj::OneMinusSrcAlpha);
					}
					else{
						HX_STACK_LINE(477)
						mat->blend(::h3d::mat::Blend_obj::SrcAlpha,::h3d::mat::Blend_obj::OneMinusSrcAlpha);
					}
				}
				;break;
				case (int)3: {
					HX_STACK_LINE(479)
					mat->blend(::h3d::mat::Blend_obj::One,::h3d::mat::Blend_obj::Zero);
				}
				;break;
				case (int)1: {
					HX_STACK_LINE(481)
					if ((tex->alpha_premultiplied)){
						HX_STACK_LINE(481)
						mat->blend(::h3d::mat::Blend_obj::One,::h3d::mat::Blend_obj::One);
					}
					else{
						HX_STACK_LINE(482)
						mat->blend(::h3d::mat::Blend_obj::SrcAlpha,::h3d::mat::Blend_obj::One);
					}
				}
				;break;
				case (int)4: {
					HX_STACK_LINE(484)
					if ((tex->alpha_premultiplied)){
						HX_STACK_LINE(484)
						HX_STACK_DO_THROW(HX_CSTRING("Unsupported please improve"));
					}
					HX_STACK_LINE(485)
					mat->blend(::h3d::mat::Blend_obj::OneMinusDstColor,::h3d::mat::Blend_obj::One);
				}
				;break;
				case (int)2: {
					HX_STACK_LINE(488)
					mat->blend(::h3d::mat::Blend_obj::DstColor,::h3d::mat::Blend_obj::OneMinusSrcAlpha);
				}
				;break;
				case (int)5: {
					HX_STACK_LINE(490)
					if ((tex->alpha_premultiplied)){
						HX_STACK_LINE(490)
						HX_STACK_DO_THROW(HX_CSTRING("Unsupported please improve"));
					}
					HX_STACK_LINE(491)
					mat->blend(::h3d::mat::Blend_obj::Zero,::h3d::mat::Blend_obj::OneMinusSrcAlpha);
				}
				;break;
				case (int)6: {
					HX_STACK_LINE(493)
					if ((tex->alpha_premultiplied)){
						HX_STACK_LINE(493)
						HX_STACK_DO_THROW(HX_CSTRING("Unsupported please improve"));
					}
					HX_STACK_LINE(494)
					mat->blend(::h3d::mat::Blend_obj::Zero,::h3d::mat::Blend_obj::One);
				}
				;break;
				case (int)7: {
					HX_STACK_LINE(496)
					mat->blend(::h3d::mat::Blend_obj::One,::h3d::mat::Blend_obj::OneMinusSrcColor);
				}
				;break;
			}
		}
		HX_STACK_LINE(499)
		if (((((int(options) & int((int)1))) != (int)0))){
			HX_STACK_LINE(500)
			::h3d::Vector tmp = core->tmpSize;		HX_STACK_VAR(tmp,"tmp");
			HX_STACK_LINE(502)
			tmp->x = (tile->width + 0.1);
			HX_STACK_LINE(503)
			tmp->y = (tile->height + 0.1);
			HX_STACK_LINE(504)
			tmp->z = (int)1;
			HX_STACK_LINE(505)
			shader->size = tmp;
		}
		HX_STACK_LINE(507)
		if (((((int(options) & int((int)4))) != (int)0))){
			HX_STACK_LINE(508)
			core->tmpUVPos->x = tile->u;
			HX_STACK_LINE(509)
			core->tmpUVPos->y = tile->v;
			HX_STACK_LINE(510)
			shader->uvPos = core->tmpUVPos;
		}
		HX_STACK_LINE(512)
		if (((((int(options) & int((int)2))) != (int)0))){
			HX_STACK_LINE(513)
			core->tmpUVScale->x = (tile->u2 - tile->u);
			HX_STACK_LINE(514)
			core->tmpUVScale->y = (tile->v2 - tile->v);
			HX_STACK_LINE(515)
			shader->uvScale = core->tmpUVScale;
		}
		HX_STACK_LINE(518)
		if ((shader->hasAlphaMap)){
			HX_STACK_LINE(519)
			::h3d::mat::Texture _g3 = this->alphaMap->getTexture();		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(519)
			shader->alphaMap = _g3;
			HX_STACK_LINE(520)
			::h3d::Vector _g4 = ::h3d::Vector_obj::__new(this->alphaMap->u,this->alphaMap->v,(Float(((this->alphaMap->u2 - this->alphaMap->u))) / Float(tile->u2)),(Float(((this->alphaMap->v2 - this->alphaMap->v))) / Float(tile->v2)));		HX_STACK_VAR(_g4,"_g4");
			HX_STACK_LINE(520)
			shader->alphaUV = _g4;
		}
		HX_STACK_LINE(523)
		if ((shader->hasMultMap)){
			HX_STACK_LINE(524)
			::h3d::mat::Texture _g5 = this->multiplyMap->getTexture();		HX_STACK_VAR(_g5,"_g5");
			HX_STACK_LINE(524)
			shader->multMap = _g5;
			HX_STACK_LINE(525)
			::h3d::Vector _g6 = ::h3d::Vector_obj::__new(this->multiplyMap->u,this->multiplyMap->v,(Float(((this->multiplyMap->u2 - this->multiplyMap->u))) / Float(tile->u2)),(Float(((this->multiplyMap->v2 - this->multiplyMap->v))) / Float(tile->v2)));		HX_STACK_VAR(_g6,"_g6");
			HX_STACK_LINE(525)
			shader->multUV = _g6;
		}
		HX_STACK_LINE(528)
		int cm;		HX_STACK_VAR(cm,"cm");
		HX_STACK_LINE(528)
		if ((this->writeAlpha)){
			HX_STACK_LINE(528)
			cm = (int)15;
		}
		else{
			HX_STACK_LINE(528)
			cm = (int)7;
		}
		HX_STACK_LINE(529)
		if (((mat->colorMask != cm))){
			HX_STACK_LINE(529)
			mat->set_colorMask(cm);
		}
		HX_STACK_LINE(531)
		::h3d::Vector tmp = core->tmpMatA;		HX_STACK_VAR(tmp,"tmp");
		HX_STACK_LINE(532)
		tmp->x = this->matA;
		HX_STACK_LINE(533)
		tmp->y = this->matC;
		HX_STACK_LINE(535)
		if (((((int(options) & int((int)8))) != (int)0))){
			HX_STACK_LINE(535)
			tmp->z = this->absX;
		}
		else{
			HX_STACK_LINE(536)
			tmp->z = ((this->absX + (tile->dx * this->matA)) + (tile->dy * this->matC));
		}
		HX_STACK_LINE(538)
		shader->matA = tmp;
		HX_STACK_LINE(539)
		::h3d::Vector tmp1 = core->tmpMatB;		HX_STACK_VAR(tmp1,"tmp1");
		HX_STACK_LINE(540)
		tmp1->x = this->matB;
		HX_STACK_LINE(541)
		tmp1->y = this->matD;
		HX_STACK_LINE(543)
		if (((((int(options) & int((int)8))) != (int)0))){
			HX_STACK_LINE(543)
			tmp1->z = this->absY;
		}
		else{
			HX_STACK_LINE(544)
			tmp1->z = ((this->absY + (tile->dx * this->matB)) + (tile->dy * this->matD));
		}
		HX_STACK_LINE(546)
		shader->matB = tmp1;
		HX_STACK_LINE(547)
		::h3d::mat::Texture _g7 = tile->getTexture();		HX_STACK_VAR(_g7,"_g7");
		HX_STACK_LINE(547)
		shader->tex = _g7;
		HX_STACK_LINE(549)
		shader->isAlphaPremul = (bool(tex->alpha_premultiplied) && bool(((bool((bool((bool((bool((bool((bool((bool(shader->hasAlphaMap) || bool(shader->hasAlpha))) || bool(shader->hasMultMap))) || bool(shader->hasVertexAlpha))) || bool(shader->hasVertexColor))) || bool((shader->colorMatrix != null())))) || bool((shader->colorAdd != null())))) || bool((shader->colorMul != null()))))));
		HX_STACK_LINE(555)
		mat->shader = shader;
		HX_STACK_LINE(556)
		engine->selectMaterial(mat);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Drawable_obj,setupShader,(void))

Void Drawable_obj::dispose( ){
{
		HX_STACK_FRAME("h2d.Drawable","dispose",0x56fc7883,"h2d.Drawable.dispose","h2d/Drawable.hx",559,0xa05adb4b)
		HX_STACK_THIS(this)
		HX_STACK_LINE(560)
		this->super::dispose();
		HX_STACK_LINE(561)
		if (((this->shader != null()))){
			HX_STACK_LINE(562)
			(this->shader->ref)--;
			HX_STACK_LINE(564)
			if (((this->shader->ref == (int)0))){
				HX_STACK_LINE(564)
				this->shader->_delete();
			}
			HX_STACK_LINE(566)
			this->shader = null();
		}
	}
return null();
}


int Drawable_obj::HAS_SIZE;

int Drawable_obj::HAS_UV_SCALE;

int Drawable_obj::HAS_UV_POS;

int Drawable_obj::BASE_TILE_DONT_CARE;


Drawable_obj::Drawable_obj()
{
}

void Drawable_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Drawable);
	HX_MARK_MEMBER_NAME(shader,"shader");
	HX_MARK_MEMBER_NAME(blendMode,"blendMode");
	HX_MARK_MEMBER_NAME(alphaMap,"alphaMap");
	HX_MARK_MEMBER_NAME(multiplyMap,"multiplyMap");
	HX_MARK_MEMBER_NAME(writeAlpha,"writeAlpha");
	::h2d::Sprite_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void Drawable_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(shader,"shader");
	HX_VISIT_MEMBER_NAME(blendMode,"blendMode");
	HX_VISIT_MEMBER_NAME(alphaMap,"alphaMap");
	HX_VISIT_MEMBER_NAME(multiplyMap,"multiplyMap");
	HX_VISIT_MEMBER_NAME(writeAlpha,"writeAlpha");
	::h2d::Sprite_obj::__Visit(HX_VISIT_ARG);
}

Dynamic Drawable_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"color") ) { return get_color(); }
		if (HX_FIELD_EQ(inName,"alpha") ) { return get_alpha(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"shader") ) { return shader; }
		if (HX_FIELD_EQ(inName,"filter") ) { return get_filter(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"colorAdd") ) { return get_colorAdd(); }
		if (HX_FIELD_EQ(inName,"tileWrap") ) { return get_tileWrap(); }
		if (HX_FIELD_EQ(inName,"alphaMap") ) { return alphaMap; }
		if (HX_FIELD_EQ(inName,"colorKey") ) { return get_colorKey(); }
		if (HX_FIELD_EQ(inName,"hasAlpha") ) { return get_hasAlpha(); }
		if (HX_FIELD_EQ(inName,"drawTile") ) { return drawTile_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"blendMode") ) { return blendMode; }
		if (HX_FIELD_EQ(inName,"killAlpha") ) { return get_killAlpha(); }
		if (HX_FIELD_EQ(inName,"get_alpha") ) { return get_alpha_dyn(); }
		if (HX_FIELD_EQ(inName,"set_alpha") ) { return set_alpha_dyn(); }
		if (HX_FIELD_EQ(inName,"set_color") ) { return set_color_dyn(); }
		if (HX_FIELD_EQ(inName,"get_color") ) { return get_color_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"writeAlpha") ) { return writeAlpha; }
		if (HX_FIELD_EQ(inName,"get_filter") ) { return get_filter_dyn(); }
		if (HX_FIELD_EQ(inName,"set_filter") ) { return set_filter_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"colorMatrix") ) { return get_colorMatrix(); }
		if (HX_FIELD_EQ(inName,"sinusDeform") ) { return get_sinusDeform(); }
		if (HX_FIELD_EQ(inName,"multiplyMap") ) { return multiplyMap; }
		if (HX_FIELD_EQ(inName,"setupShader") ) { return setupShader_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"get_hasAlpha") ) { return get_hasAlpha_dyn(); }
		if (HX_FIELD_EQ(inName,"set_hasAlpha") ) { return set_hasAlpha_dyn(); }
		if (HX_FIELD_EQ(inName,"set_alphaMap") ) { return set_alphaMap_dyn(); }
		if (HX_FIELD_EQ(inName,"set_colorAdd") ) { return set_colorAdd_dyn(); }
		if (HX_FIELD_EQ(inName,"get_colorAdd") ) { return get_colorAdd_dyn(); }
		if (HX_FIELD_EQ(inName,"get_tileWrap") ) { return get_tileWrap_dyn(); }
		if (HX_FIELD_EQ(inName,"set_tileWrap") ) { return set_tileWrap_dyn(); }
		if (HX_FIELD_EQ(inName,"get_colorKey") ) { return get_colorKey_dyn(); }
		if (HX_FIELD_EQ(inName,"set_colorKey") ) { return set_colorKey_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"set_blendMode") ) { return set_blendMode_dyn(); }
		if (HX_FIELD_EQ(inName,"get_killAlpha") ) { return get_killAlpha_dyn(); }
		if (HX_FIELD_EQ(inName,"set_killAlpha") ) { return set_killAlpha_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"multiplyFactor") ) { return get_multiplyFactor(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"set_multiplyMap") ) { return set_multiplyMap_dyn(); }
		if (HX_FIELD_EQ(inName,"get_sinusDeform") ) { return get_sinusDeform_dyn(); }
		if (HX_FIELD_EQ(inName,"set_sinusDeform") ) { return set_sinusDeform_dyn(); }
		if (HX_FIELD_EQ(inName,"get_colorMatrix") ) { return get_colorMatrix_dyn(); }
		if (HX_FIELD_EQ(inName,"set_colorMatrix") ) { return set_colorMatrix_dyn(); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"get_multiplyFactor") ) { return get_multiplyFactor_dyn(); }
		if (HX_FIELD_EQ(inName,"set_multiplyFactor") ) { return set_multiplyFactor_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Drawable_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"color") ) { return set_color(inValue); }
		if (HX_FIELD_EQ(inName,"alpha") ) { return set_alpha(inValue); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"shader") ) { shader=inValue.Cast< ::h2d::DrawableShader >(); return inValue; }
		if (HX_FIELD_EQ(inName,"filter") ) { return set_filter(inValue); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"colorAdd") ) { return set_colorAdd(inValue); }
		if (HX_FIELD_EQ(inName,"tileWrap") ) { return set_tileWrap(inValue); }
		if (HX_FIELD_EQ(inName,"alphaMap") ) { if (inCallProp) return set_alphaMap(inValue);alphaMap=inValue.Cast< ::h2d::Tile >(); return inValue; }
		if (HX_FIELD_EQ(inName,"colorKey") ) { return set_colorKey(inValue); }
		if (HX_FIELD_EQ(inName,"hasAlpha") ) { return set_hasAlpha(inValue); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"blendMode") ) { if (inCallProp) return set_blendMode(inValue);blendMode=inValue.Cast< ::h2d::BlendMode >(); return inValue; }
		if (HX_FIELD_EQ(inName,"killAlpha") ) { return set_killAlpha(inValue); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"writeAlpha") ) { writeAlpha=inValue.Cast< bool >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"colorMatrix") ) { return set_colorMatrix(inValue); }
		if (HX_FIELD_EQ(inName,"sinusDeform") ) { return set_sinusDeform(inValue); }
		if (HX_FIELD_EQ(inName,"multiplyMap") ) { if (inCallProp) return set_multiplyMap(inValue);multiplyMap=inValue.Cast< ::h2d::Tile >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"multiplyFactor") ) { return set_multiplyFactor(inValue); }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Drawable_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("shader"));
	outFields->push(HX_CSTRING("filter"));
	outFields->push(HX_CSTRING("color"));
	outFields->push(HX_CSTRING("colorAdd"));
	outFields->push(HX_CSTRING("colorMatrix"));
	outFields->push(HX_CSTRING("blendMode"));
	outFields->push(HX_CSTRING("sinusDeform"));
	outFields->push(HX_CSTRING("tileWrap"));
	outFields->push(HX_CSTRING("killAlpha"));
	outFields->push(HX_CSTRING("alphaMap"));
	outFields->push(HX_CSTRING("multiplyMap"));
	outFields->push(HX_CSTRING("multiplyFactor"));
	outFields->push(HX_CSTRING("colorKey"));
	outFields->push(HX_CSTRING("writeAlpha"));
	outFields->push(HX_CSTRING("alpha"));
	outFields->push(HX_CSTRING("hasAlpha"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("HAS_SIZE"),
	HX_CSTRING("HAS_UV_SCALE"),
	HX_CSTRING("HAS_UV_POS"),
	HX_CSTRING("BASE_TILE_DONT_CARE"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h2d::DrawableShader*/ ,(int)offsetof(Drawable_obj,shader),HX_CSTRING("shader")},
	{hx::fsObject /*::h2d::BlendMode*/ ,(int)offsetof(Drawable_obj,blendMode),HX_CSTRING("blendMode")},
	{hx::fsObject /*::h2d::Tile*/ ,(int)offsetof(Drawable_obj,alphaMap),HX_CSTRING("alphaMap")},
	{hx::fsObject /*::h2d::Tile*/ ,(int)offsetof(Drawable_obj,multiplyMap),HX_CSTRING("multiplyMap")},
	{hx::fsBool,(int)offsetof(Drawable_obj,writeAlpha),HX_CSTRING("writeAlpha")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("shader"),
	HX_CSTRING("blendMode"),
	HX_CSTRING("alphaMap"),
	HX_CSTRING("multiplyMap"),
	HX_CSTRING("writeAlpha"),
	HX_CSTRING("get_hasAlpha"),
	HX_CSTRING("set_hasAlpha"),
	HX_CSTRING("get_alpha"),
	HX_CSTRING("set_alpha"),
	HX_CSTRING("set_blendMode"),
	HX_CSTRING("get_multiplyFactor"),
	HX_CSTRING("set_multiplyFactor"),
	HX_CSTRING("set_multiplyMap"),
	HX_CSTRING("set_alphaMap"),
	HX_CSTRING("get_sinusDeform"),
	HX_CSTRING("set_sinusDeform"),
	HX_CSTRING("get_colorMatrix"),
	HX_CSTRING("set_colorMatrix"),
	HX_CSTRING("set_color"),
	HX_CSTRING("set_colorAdd"),
	HX_CSTRING("get_colorAdd"),
	HX_CSTRING("get_color"),
	HX_CSTRING("get_filter"),
	HX_CSTRING("set_filter"),
	HX_CSTRING("get_tileWrap"),
	HX_CSTRING("set_tileWrap"),
	HX_CSTRING("get_killAlpha"),
	HX_CSTRING("set_killAlpha"),
	HX_CSTRING("get_colorKey"),
	HX_CSTRING("set_colorKey"),
	HX_CSTRING("drawTile"),
	HX_CSTRING("setupShader"),
	HX_CSTRING("dispose"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Drawable_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Drawable_obj::HAS_SIZE,"HAS_SIZE");
	HX_MARK_MEMBER_NAME(Drawable_obj::HAS_UV_SCALE,"HAS_UV_SCALE");
	HX_MARK_MEMBER_NAME(Drawable_obj::HAS_UV_POS,"HAS_UV_POS");
	HX_MARK_MEMBER_NAME(Drawable_obj::BASE_TILE_DONT_CARE,"BASE_TILE_DONT_CARE");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Drawable_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Drawable_obj::HAS_SIZE,"HAS_SIZE");
	HX_VISIT_MEMBER_NAME(Drawable_obj::HAS_UV_SCALE,"HAS_UV_SCALE");
	HX_VISIT_MEMBER_NAME(Drawable_obj::HAS_UV_POS,"HAS_UV_POS");
	HX_VISIT_MEMBER_NAME(Drawable_obj::BASE_TILE_DONT_CARE,"BASE_TILE_DONT_CARE");
};

#endif

Class Drawable_obj::__mClass;

void Drawable_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.Drawable"), hx::TCanCast< Drawable_obj> ,sStaticFields,sMemberFields,
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

void Drawable_obj::__boot()
{
	HAS_SIZE= (int)1;
	HAS_UV_SCALE= (int)2;
	HAS_UV_POS= (int)4;
	BASE_TILE_DONT_CARE= (int)8;
}

} // end namespace h2d
