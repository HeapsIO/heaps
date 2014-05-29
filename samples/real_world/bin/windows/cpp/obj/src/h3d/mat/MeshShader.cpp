#include <hxcpp.h>

#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
#endif
#ifndef INCLUDED_h3d_Vector
#include <h3d/Vector.h>
#endif
#ifndef INCLUDED_h3d_impl_Shader
#include <h3d/impl/Shader.h>
#endif
#ifndef INCLUDED_h3d_mat_MeshShader
#include <h3d/mat/MeshShader.h>
#endif
#ifndef INCLUDED_h3d_mat_Texture
#include <h3d/mat/Texture.h>
#endif
namespace h3d{
namespace mat{

Void MeshShader_obj::__construct()
{
HX_STACK_FRAME("h3d.mat.MeshShader","new",0x162ff527,"h3d.mat.MeshShader.new","h3d/mat/MeshMaterial.hx",22,0xfa8cf5a5)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(189)
	this->maxSkinMatrixes = (int)34;
	HX_STACK_LINE(22)
	super::__construct();
}
;
	return null();
}

//MeshShader_obj::~MeshShader_obj() { }

Dynamic MeshShader_obj::__CreateEmpty() { return  new MeshShader_obj; }
hx::ObjectPtr< MeshShader_obj > MeshShader_obj::__new()
{  hx::ObjectPtr< MeshShader_obj > result = new MeshShader_obj();
	result->__construct();
	return result;}

Dynamic MeshShader_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< MeshShader_obj > result = new MeshShader_obj();
	result->__construct();
	return result;}

Dynamic MeshShader_obj::set_lightSystem( Dynamic l){
	HX_STACK_FRAME("h3d.mat.MeshShader","set_lightSystem",0xce01c84f,"h3d.mat.MeshShader.set_lightSystem","h3d/mat/MeshMaterial.hx",210,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(l,"l")
	HX_STACK_LINE(211)
	this->lightSystem = l;
	HX_STACK_LINE(212)
	Dynamic _g5;		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(212)
	if (((l == null()))){
		HX_STACK_LINE(212)
		_g5 = null();
	}
	else{
		HX_STACK_LINE(214)
		Array< ::Dynamic > _g;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(214)
		{
			HX_STACK_LINE(214)
			Array< ::Dynamic > _g1 = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(214)
			{
				HX_STACK_LINE(214)
				int _g11 = (int)0;		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(214)
				Dynamic _g2 = l->__Field(HX_CSTRING("dirs"),true);		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(214)
				while((true)){
					HX_STACK_LINE(214)
					if ((!(((_g11 < _g2->__Field(HX_CSTRING("length"),true)))))){
						HX_STACK_LINE(214)
						break;
					}
					HX_STACK_LINE(214)
					Dynamic l1 = _g2->__GetItem(_g11);		HX_STACK_VAR(l1,"l1");
					HX_STACK_LINE(214)
					++(_g11);
					HX_STACK_LINE(214)
					_g1->push(l1->__Field(HX_CSTRING("dir"),true));
				}
			}
			HX_STACK_LINE(214)
			_g = _g1;
		}
		HX_STACK_LINE(215)
		Array< ::Dynamic > _g1;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(215)
		{
			HX_STACK_LINE(215)
			Array< ::Dynamic > _g11 = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g11,"_g11");
			HX_STACK_LINE(215)
			{
				HX_STACK_LINE(215)
				int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(215)
				Dynamic _g3 = l->__Field(HX_CSTRING("dirs"),true);		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(215)
				while((true)){
					HX_STACK_LINE(215)
					if ((!(((_g2 < _g3->__Field(HX_CSTRING("length"),true)))))){
						HX_STACK_LINE(215)
						break;
					}
					HX_STACK_LINE(215)
					Dynamic l1 = _g3->__GetItem(_g2);		HX_STACK_VAR(l1,"l1");
					HX_STACK_LINE(215)
					++(_g2);
					HX_STACK_LINE(215)
					_g11->push(l1->__Field(HX_CSTRING("color"),true));
				}
			}
			HX_STACK_LINE(215)
			_g1 = _g11;
		}
		HX_STACK_LINE(216)
		Array< ::Dynamic > _g2;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(216)
		{
			HX_STACK_LINE(216)
			Array< ::Dynamic > _g21 = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g21,"_g21");
			HX_STACK_LINE(216)
			{
				HX_STACK_LINE(216)
				int _g3 = (int)0;		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(216)
				Dynamic _g4 = l->__Field(HX_CSTRING("points"),true);		HX_STACK_VAR(_g4,"_g4");
				HX_STACK_LINE(216)
				while((true)){
					HX_STACK_LINE(216)
					if ((!(((_g3 < _g4->__Field(HX_CSTRING("length"),true)))))){
						HX_STACK_LINE(216)
						break;
					}
					HX_STACK_LINE(216)
					Dynamic p = _g4->__GetItem(_g3);		HX_STACK_VAR(p,"p");
					HX_STACK_LINE(216)
					++(_g3);
					HX_STACK_LINE(216)
					_g21->push(p->__Field(HX_CSTRING("pos"),true));
				}
			}
			HX_STACK_LINE(216)
			_g2 = _g21;
		}
		HX_STACK_LINE(217)
		Array< ::Dynamic > _g3;		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(217)
		{
			HX_STACK_LINE(217)
			Array< ::Dynamic > _g31 = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g31,"_g31");
			HX_STACK_LINE(217)
			{
				HX_STACK_LINE(217)
				int _g4 = (int)0;		HX_STACK_VAR(_g4,"_g4");
				HX_STACK_LINE(217)
				Dynamic _g51 = l->__Field(HX_CSTRING("points"),true);		HX_STACK_VAR(_g51,"_g51");
				HX_STACK_LINE(217)
				while((true)){
					HX_STACK_LINE(217)
					if ((!(((_g4 < _g51->__Field(HX_CSTRING("length"),true)))))){
						HX_STACK_LINE(217)
						break;
					}
					HX_STACK_LINE(217)
					Dynamic p = _g51->__GetItem(_g4);		HX_STACK_VAR(p,"p");
					HX_STACK_LINE(217)
					++(_g4);
					HX_STACK_LINE(217)
					_g31->push(p->__Field(HX_CSTRING("color"),true));
				}
			}
			HX_STACK_LINE(217)
			_g3 = _g31;
		}
		HX_STACK_LINE(218)
		Array< ::Dynamic > _g4;		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(218)
		{
			HX_STACK_LINE(218)
			Array< ::Dynamic > _g41 = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g41,"_g41");
			HX_STACK_LINE(218)
			{
				HX_STACK_LINE(218)
				int _g51 = (int)0;		HX_STACK_VAR(_g51,"_g51");
				HX_STACK_LINE(218)
				Dynamic _g6 = l->__Field(HX_CSTRING("points"),true);		HX_STACK_VAR(_g6,"_g6");
				HX_STACK_LINE(218)
				while((true)){
					HX_STACK_LINE(218)
					if ((!(((_g51 < _g6->__Field(HX_CSTRING("length"),true)))))){
						HX_STACK_LINE(218)
						break;
					}
					HX_STACK_LINE(218)
					Dynamic p = _g6->__GetItem(_g51);		HX_STACK_VAR(p,"p");
					HX_STACK_LINE(218)
					++(_g51);
					HX_STACK_LINE(218)
					_g41->push(p->__Field(HX_CSTRING("att"),true));
				}
			}
			HX_STACK_LINE(218)
			_g4 = _g41;
		}
		struct _Function_2_1{
			inline static Dynamic Block( Array< ::Dynamic > &_g1,Array< ::Dynamic > &_g,Array< ::Dynamic > &_g4,Array< ::Dynamic > &_g2,Array< ::Dynamic > &_g3,Dynamic &l){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/mat/MeshMaterial.hx",212,0xfa8cf5a5)
				{
					hx::Anon __result = hx::Anon_obj::Create();
					__result->Add(HX_CSTRING("ambient") , l->__Field(HX_CSTRING("ambient"),true),false);
					__result->Add(HX_CSTRING("dirsDir") , _g,false);
					__result->Add(HX_CSTRING("dirsColor") , _g1,false);
					__result->Add(HX_CSTRING("pointsPos") , _g2,false);
					__result->Add(HX_CSTRING("pointsColor") , _g3,false);
					__result->Add(HX_CSTRING("pointsAtt") , _g4,false);
					return __result;
				}
				return null();
			}
		};
		HX_STACK_LINE(212)
		_g5 = _Function_2_1::Block(_g1,_g,_g4,_g2,_g3,l);
	}
	HX_STACK_LINE(212)
	this->lights = _g5;
	HX_STACK_LINE(220)
	return l;
}


HX_DEFINE_DYNAMIC_FUNC1(MeshShader_obj,set_lightSystem,return )

::String MeshShader_obj::getConstants( bool vertex){
	HX_STACK_FRAME("h3d.mat.MeshShader","getConstants",0x95249d72,"h3d.mat.MeshShader.getConstants","h3d/mat/MeshMaterial.hx",223,0xfa8cf5a5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(vertex,"vertex")
	HX_STACK_LINE(224)
	Array< ::String > cst = Array_obj< ::String >::__new();		HX_STACK_VAR(cst,"cst");
	HX_STACK_LINE(225)
	if ((this->hasVertexColor)){
		HX_STACK_LINE(225)
		cst->push(HX_CSTRING("#define hasVertexColor"));
	}
	HX_STACK_LINE(226)
	if ((this->hasVertexColorAdd)){
		HX_STACK_LINE(226)
		cst->push(HX_CSTRING("#define hasVertexColorAdd"));
	}
	HX_STACK_LINE(227)
	if (((this->fog != null()))){
		HX_STACK_LINE(227)
		cst->push(HX_CSTRING("#define hasFog"));
	}
	HX_STACK_LINE(228)
	if ((this->hasBlend)){
		HX_STACK_LINE(228)
		cst->push(HX_CSTRING("#define hasBlend"));
	}
	HX_STACK_LINE(229)
	if ((this->hasShadowMap)){
		HX_STACK_LINE(229)
		cst->push(HX_CSTRING("#define hasShadowMap"));
	}
	HX_STACK_LINE(230)
	if (((this->lightSystem != null()))){
		HX_STACK_LINE(231)
		cst->push(HX_CSTRING("#define hasLightSystem"));
		HX_STACK_LINE(232)
		cst->push(((HX_CSTRING("const int numDirLights = ") + this->lightSystem->__Field(HX_CSTRING("dirs"),true)->__Field(HX_CSTRING("length"),true)) + HX_CSTRING(";")));
		HX_STACK_LINE(233)
		cst->push(((HX_CSTRING("const int numPointLights = ") + this->lightSystem->__Field(HX_CSTRING("points"),true)->__Field(HX_CSTRING("length"),true)) + HX_CSTRING(";")));
	}
	else{
	}
	HX_STACK_LINE(240)
	if ((vertex)){
		HX_STACK_LINE(241)
		if (((this->mpos != null()))){
			HX_STACK_LINE(241)
			cst->push(HX_CSTRING("#define hasPos"));
		}
		HX_STACK_LINE(242)
		if ((this->hasSkin)){
			HX_STACK_LINE(243)
			cst->push(HX_CSTRING("#define hasSkin"));
			HX_STACK_LINE(244)
			cst->push(((HX_CSTRING("const int maxSkinMatrixes = ") + this->maxSkinMatrixes) + HX_CSTRING(";")));
		}
		HX_STACK_LINE(246)
		if (((this->uvScale != null()))){
			HX_STACK_LINE(246)
			cst->push(HX_CSTRING("#define hasUVScale"));
		}
		HX_STACK_LINE(247)
		if (((this->uvDelta != null()))){
			HX_STACK_LINE(247)
			cst->push(HX_CSTRING("#define hasUVDelta"));
		}
		HX_STACK_LINE(248)
		if ((this->hasZBias)){
			HX_STACK_LINE(248)
			cst->push(HX_CSTRING("#define hasZBias"));
		}
	}
	else{
		HX_STACK_LINE(250)
		if ((this->killAlpha)){
			HX_STACK_LINE(250)
			cst->push(HX_CSTRING("#define killAlpha"));
		}
		HX_STACK_LINE(251)
		if (((this->colorAdd != null()))){
			HX_STACK_LINE(251)
			cst->push(HX_CSTRING("#define hasColorAdd"));
		}
		HX_STACK_LINE(252)
		if (((this->colorMul != null()))){
			HX_STACK_LINE(252)
			cst->push(HX_CSTRING("#define hasColorMul"));
		}
		HX_STACK_LINE(253)
		if (((this->colorMatrix != null()))){
			HX_STACK_LINE(253)
			cst->push(HX_CSTRING("#define hasColorMatrix"));
		}
		HX_STACK_LINE(254)
		if ((this->hasAlphaMap)){
			HX_STACK_LINE(254)
			cst->push(HX_CSTRING("#define hasAlphaMap"));
		}
		HX_STACK_LINE(255)
		if ((this->hasGlow)){
			HX_STACK_LINE(255)
			cst->push(HX_CSTRING("#define hasGlow"));
		}
		HX_STACK_LINE(256)
		if (((bool(this->hasVertexColorAdd) || bool((this->lightSystem != null()))))){
			HX_STACK_LINE(256)
			cst->push(HX_CSTRING("#define hasFragColor"));
		}
	}
	HX_STACK_LINE(258)
	return cst->join(HX_CSTRING("\n"));
}


::String MeshShader_obj::VERTEX;

::String MeshShader_obj::FRAGMENT;


MeshShader_obj::MeshShader_obj()
{
}

void MeshShader_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(MeshShader);
	HX_MARK_MEMBER_NAME(maxSkinMatrixes,"maxSkinMatrixes");
	HX_MARK_MEMBER_NAME(hasVertexColor,"hasVertexColor");
	HX_MARK_MEMBER_NAME(hasVertexColorAdd,"hasVertexColorAdd");
	HX_MARK_MEMBER_NAME(lightSystem,"lightSystem");
	HX_MARK_MEMBER_NAME(hasSkin,"hasSkin");
	HX_MARK_MEMBER_NAME(hasZBias,"hasZBias");
	HX_MARK_MEMBER_NAME(hasShadowMap,"hasShadowMap");
	HX_MARK_MEMBER_NAME(killAlpha,"killAlpha");
	HX_MARK_MEMBER_NAME(hasAlphaMap,"hasAlphaMap");
	HX_MARK_MEMBER_NAME(hasBlend,"hasBlend");
	HX_MARK_MEMBER_NAME(hasGlow,"hasGlow");
	HX_MARK_MEMBER_NAME(lights,"lights");
	HX_MARK_MEMBER_NAME(skinMatrixes,"skinMatrixes");
	HX_MARK_MEMBER_NAME(mpos,"mpos");
	HX_MARK_MEMBER_NAME(mproj,"mproj");
	HX_MARK_MEMBER_NAME(zBias,"zBias");
	HX_MARK_MEMBER_NAME(uvScale,"uvScale");
	HX_MARK_MEMBER_NAME(uvDelta,"uvDelta");
	HX_MARK_MEMBER_NAME(shadowLightProj,"shadowLightProj");
	HX_MARK_MEMBER_NAME(shadowLightCenter,"shadowLightCenter");
	HX_MARK_MEMBER_NAME(fog,"fog");
	HX_MARK_MEMBER_NAME(mposInv,"mposInv");
	HX_MARK_MEMBER_NAME(tex,"tex");
	HX_MARK_MEMBER_NAME(colorAdd,"colorAdd");
	HX_MARK_MEMBER_NAME(colorMul,"colorMul");
	HX_MARK_MEMBER_NAME(colorMatrix,"colorMatrix");
	HX_MARK_MEMBER_NAME(killAlphaThreshold,"killAlphaThreshold");
	HX_MARK_MEMBER_NAME(alphaMap,"alphaMap");
	HX_MARK_MEMBER_NAME(blendTexture,"blendTexture");
	HX_MARK_MEMBER_NAME(glowTexture,"glowTexture");
	HX_MARK_MEMBER_NAME(glowAmount,"glowAmount");
	HX_MARK_MEMBER_NAME(shadowTexture,"shadowTexture");
	HX_MARK_MEMBER_NAME(shadowColor,"shadowColor");
	::h3d::impl::Shader_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void MeshShader_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(maxSkinMatrixes,"maxSkinMatrixes");
	HX_VISIT_MEMBER_NAME(hasVertexColor,"hasVertexColor");
	HX_VISIT_MEMBER_NAME(hasVertexColorAdd,"hasVertexColorAdd");
	HX_VISIT_MEMBER_NAME(lightSystem,"lightSystem");
	HX_VISIT_MEMBER_NAME(hasSkin,"hasSkin");
	HX_VISIT_MEMBER_NAME(hasZBias,"hasZBias");
	HX_VISIT_MEMBER_NAME(hasShadowMap,"hasShadowMap");
	HX_VISIT_MEMBER_NAME(killAlpha,"killAlpha");
	HX_VISIT_MEMBER_NAME(hasAlphaMap,"hasAlphaMap");
	HX_VISIT_MEMBER_NAME(hasBlend,"hasBlend");
	HX_VISIT_MEMBER_NAME(hasGlow,"hasGlow");
	HX_VISIT_MEMBER_NAME(lights,"lights");
	HX_VISIT_MEMBER_NAME(skinMatrixes,"skinMatrixes");
	HX_VISIT_MEMBER_NAME(mpos,"mpos");
	HX_VISIT_MEMBER_NAME(mproj,"mproj");
	HX_VISIT_MEMBER_NAME(zBias,"zBias");
	HX_VISIT_MEMBER_NAME(uvScale,"uvScale");
	HX_VISIT_MEMBER_NAME(uvDelta,"uvDelta");
	HX_VISIT_MEMBER_NAME(shadowLightProj,"shadowLightProj");
	HX_VISIT_MEMBER_NAME(shadowLightCenter,"shadowLightCenter");
	HX_VISIT_MEMBER_NAME(fog,"fog");
	HX_VISIT_MEMBER_NAME(mposInv,"mposInv");
	HX_VISIT_MEMBER_NAME(tex,"tex");
	HX_VISIT_MEMBER_NAME(colorAdd,"colorAdd");
	HX_VISIT_MEMBER_NAME(colorMul,"colorMul");
	HX_VISIT_MEMBER_NAME(colorMatrix,"colorMatrix");
	HX_VISIT_MEMBER_NAME(killAlphaThreshold,"killAlphaThreshold");
	HX_VISIT_MEMBER_NAME(alphaMap,"alphaMap");
	HX_VISIT_MEMBER_NAME(blendTexture,"blendTexture");
	HX_VISIT_MEMBER_NAME(glowTexture,"glowTexture");
	HX_VISIT_MEMBER_NAME(glowAmount,"glowAmount");
	HX_VISIT_MEMBER_NAME(shadowTexture,"shadowTexture");
	HX_VISIT_MEMBER_NAME(shadowColor,"shadowColor");
	::h3d::impl::Shader_obj::__Visit(HX_VISIT_ARG);
}

Dynamic MeshShader_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"fog") ) { return fog; }
		if (HX_FIELD_EQ(inName,"tex") ) { return tex; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"mpos") ) { return mpos; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"mproj") ) { return mproj; }
		if (HX_FIELD_EQ(inName,"zBias") ) { return zBias; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"VERTEX") ) { return VERTEX; }
		if (HX_FIELD_EQ(inName,"lights") ) { return lights; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"hasSkin") ) { return hasSkin; }
		if (HX_FIELD_EQ(inName,"hasGlow") ) { return hasGlow; }
		if (HX_FIELD_EQ(inName,"uvScale") ) { return uvScale; }
		if (HX_FIELD_EQ(inName,"uvDelta") ) { return uvDelta; }
		if (HX_FIELD_EQ(inName,"mposInv") ) { return mposInv; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"FRAGMENT") ) { return FRAGMENT; }
		if (HX_FIELD_EQ(inName,"hasZBias") ) { return hasZBias; }
		if (HX_FIELD_EQ(inName,"hasBlend") ) { return hasBlend; }
		if (HX_FIELD_EQ(inName,"colorAdd") ) { return colorAdd; }
		if (HX_FIELD_EQ(inName,"colorMul") ) { return colorMul; }
		if (HX_FIELD_EQ(inName,"alphaMap") ) { return alphaMap; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"killAlpha") ) { return killAlpha; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"glowAmount") ) { return glowAmount; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"lightSystem") ) { return lightSystem; }
		if (HX_FIELD_EQ(inName,"hasAlphaMap") ) { return hasAlphaMap; }
		if (HX_FIELD_EQ(inName,"colorMatrix") ) { return colorMatrix; }
		if (HX_FIELD_EQ(inName,"glowTexture") ) { return glowTexture; }
		if (HX_FIELD_EQ(inName,"shadowColor") ) { return shadowColor; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"hasShadowMap") ) { return hasShadowMap; }
		if (HX_FIELD_EQ(inName,"getConstants") ) { return getConstants_dyn(); }
		if (HX_FIELD_EQ(inName,"skinMatrixes") ) { return skinMatrixes; }
		if (HX_FIELD_EQ(inName,"blendTexture") ) { return blendTexture; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"shadowTexture") ) { return shadowTexture; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"hasVertexColor") ) { return hasVertexColor; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"maxSkinMatrixes") ) { return maxSkinMatrixes; }
		if (HX_FIELD_EQ(inName,"set_lightSystem") ) { return set_lightSystem_dyn(); }
		if (HX_FIELD_EQ(inName,"shadowLightProj") ) { return shadowLightProj; }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"hasVertexColorAdd") ) { return hasVertexColorAdd; }
		if (HX_FIELD_EQ(inName,"shadowLightCenter") ) { return shadowLightCenter; }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"killAlphaThreshold") ) { return killAlphaThreshold; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic MeshShader_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"fog") ) { fog=inValue.Cast< ::h3d::Vector >(); return inValue; }
		if (HX_FIELD_EQ(inName,"tex") ) { tex=inValue.Cast< ::h3d::mat::Texture >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"mpos") ) { mpos=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"mproj") ) { mproj=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		if (HX_FIELD_EQ(inName,"zBias") ) { zBias=inValue.Cast< Float >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"VERTEX") ) { VERTEX=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lights") ) { lights=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"hasSkin") ) { hasSkin=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"hasGlow") ) { hasGlow=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"uvScale") ) { uvScale=inValue.Cast< ::h3d::Vector >(); return inValue; }
		if (HX_FIELD_EQ(inName,"uvDelta") ) { uvDelta=inValue.Cast< ::h3d::Vector >(); return inValue; }
		if (HX_FIELD_EQ(inName,"mposInv") ) { mposInv=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"FRAGMENT") ) { FRAGMENT=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"hasZBias") ) { hasZBias=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"hasBlend") ) { hasBlend=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"colorAdd") ) { colorAdd=inValue.Cast< ::h3d::Vector >(); return inValue; }
		if (HX_FIELD_EQ(inName,"colorMul") ) { colorMul=inValue.Cast< ::h3d::Vector >(); return inValue; }
		if (HX_FIELD_EQ(inName,"alphaMap") ) { alphaMap=inValue.Cast< ::h3d::mat::Texture >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"killAlpha") ) { killAlpha=inValue.Cast< bool >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"glowAmount") ) { glowAmount=inValue.Cast< Float >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"lightSystem") ) { if (inCallProp) return set_lightSystem(inValue);lightSystem=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"hasAlphaMap") ) { hasAlphaMap=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"colorMatrix") ) { colorMatrix=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		if (HX_FIELD_EQ(inName,"glowTexture") ) { glowTexture=inValue.Cast< ::h3d::mat::Texture >(); return inValue; }
		if (HX_FIELD_EQ(inName,"shadowColor") ) { shadowColor=inValue.Cast< ::h3d::Vector >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"hasShadowMap") ) { hasShadowMap=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"skinMatrixes") ) { skinMatrixes=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"blendTexture") ) { blendTexture=inValue.Cast< ::h3d::mat::Texture >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"shadowTexture") ) { shadowTexture=inValue.Cast< ::h3d::mat::Texture >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"hasVertexColor") ) { hasVertexColor=inValue.Cast< bool >(); return inValue; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"maxSkinMatrixes") ) { maxSkinMatrixes=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"shadowLightProj") ) { shadowLightProj=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"hasVertexColorAdd") ) { hasVertexColorAdd=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"shadowLightCenter") ) { shadowLightCenter=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"killAlphaThreshold") ) { killAlphaThreshold=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void MeshShader_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("maxSkinMatrixes"));
	outFields->push(HX_CSTRING("hasVertexColor"));
	outFields->push(HX_CSTRING("hasVertexColorAdd"));
	outFields->push(HX_CSTRING("lightSystem"));
	outFields->push(HX_CSTRING("hasSkin"));
	outFields->push(HX_CSTRING("hasZBias"));
	outFields->push(HX_CSTRING("hasShadowMap"));
	outFields->push(HX_CSTRING("killAlpha"));
	outFields->push(HX_CSTRING("hasAlphaMap"));
	outFields->push(HX_CSTRING("hasBlend"));
	outFields->push(HX_CSTRING("hasGlow"));
	outFields->push(HX_CSTRING("lights"));
	outFields->push(HX_CSTRING("skinMatrixes"));
	outFields->push(HX_CSTRING("mpos"));
	outFields->push(HX_CSTRING("mproj"));
	outFields->push(HX_CSTRING("zBias"));
	outFields->push(HX_CSTRING("uvScale"));
	outFields->push(HX_CSTRING("uvDelta"));
	outFields->push(HX_CSTRING("shadowLightProj"));
	outFields->push(HX_CSTRING("shadowLightCenter"));
	outFields->push(HX_CSTRING("fog"));
	outFields->push(HX_CSTRING("mposInv"));
	outFields->push(HX_CSTRING("tex"));
	outFields->push(HX_CSTRING("colorAdd"));
	outFields->push(HX_CSTRING("colorMul"));
	outFields->push(HX_CSTRING("colorMatrix"));
	outFields->push(HX_CSTRING("killAlphaThreshold"));
	outFields->push(HX_CSTRING("alphaMap"));
	outFields->push(HX_CSTRING("blendTexture"));
	outFields->push(HX_CSTRING("glowTexture"));
	outFields->push(HX_CSTRING("glowAmount"));
	outFields->push(HX_CSTRING("shadowTexture"));
	outFields->push(HX_CSTRING("shadowColor"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("VERTEX"),
	HX_CSTRING("FRAGMENT"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(MeshShader_obj,maxSkinMatrixes),HX_CSTRING("maxSkinMatrixes")},
	{hx::fsBool,(int)offsetof(MeshShader_obj,hasVertexColor),HX_CSTRING("hasVertexColor")},
	{hx::fsBool,(int)offsetof(MeshShader_obj,hasVertexColorAdd),HX_CSTRING("hasVertexColorAdd")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(MeshShader_obj,lightSystem),HX_CSTRING("lightSystem")},
	{hx::fsBool,(int)offsetof(MeshShader_obj,hasSkin),HX_CSTRING("hasSkin")},
	{hx::fsBool,(int)offsetof(MeshShader_obj,hasZBias),HX_CSTRING("hasZBias")},
	{hx::fsBool,(int)offsetof(MeshShader_obj,hasShadowMap),HX_CSTRING("hasShadowMap")},
	{hx::fsBool,(int)offsetof(MeshShader_obj,killAlpha),HX_CSTRING("killAlpha")},
	{hx::fsBool,(int)offsetof(MeshShader_obj,hasAlphaMap),HX_CSTRING("hasAlphaMap")},
	{hx::fsBool,(int)offsetof(MeshShader_obj,hasBlend),HX_CSTRING("hasBlend")},
	{hx::fsBool,(int)offsetof(MeshShader_obj,hasGlow),HX_CSTRING("hasGlow")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(MeshShader_obj,lights),HX_CSTRING("lights")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(MeshShader_obj,skinMatrixes),HX_CSTRING("skinMatrixes")},
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(MeshShader_obj,mpos),HX_CSTRING("mpos")},
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(MeshShader_obj,mproj),HX_CSTRING("mproj")},
	{hx::fsFloat,(int)offsetof(MeshShader_obj,zBias),HX_CSTRING("zBias")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(MeshShader_obj,uvScale),HX_CSTRING("uvScale")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(MeshShader_obj,uvDelta),HX_CSTRING("uvDelta")},
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(MeshShader_obj,shadowLightProj),HX_CSTRING("shadowLightProj")},
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(MeshShader_obj,shadowLightCenter),HX_CSTRING("shadowLightCenter")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(MeshShader_obj,fog),HX_CSTRING("fog")},
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(MeshShader_obj,mposInv),HX_CSTRING("mposInv")},
	{hx::fsObject /*::h3d::mat::Texture*/ ,(int)offsetof(MeshShader_obj,tex),HX_CSTRING("tex")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(MeshShader_obj,colorAdd),HX_CSTRING("colorAdd")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(MeshShader_obj,colorMul),HX_CSTRING("colorMul")},
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(MeshShader_obj,colorMatrix),HX_CSTRING("colorMatrix")},
	{hx::fsFloat,(int)offsetof(MeshShader_obj,killAlphaThreshold),HX_CSTRING("killAlphaThreshold")},
	{hx::fsObject /*::h3d::mat::Texture*/ ,(int)offsetof(MeshShader_obj,alphaMap),HX_CSTRING("alphaMap")},
	{hx::fsObject /*::h3d::mat::Texture*/ ,(int)offsetof(MeshShader_obj,blendTexture),HX_CSTRING("blendTexture")},
	{hx::fsObject /*::h3d::mat::Texture*/ ,(int)offsetof(MeshShader_obj,glowTexture),HX_CSTRING("glowTexture")},
	{hx::fsFloat,(int)offsetof(MeshShader_obj,glowAmount),HX_CSTRING("glowAmount")},
	{hx::fsObject /*::h3d::mat::Texture*/ ,(int)offsetof(MeshShader_obj,shadowTexture),HX_CSTRING("shadowTexture")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(MeshShader_obj,shadowColor),HX_CSTRING("shadowColor")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("maxSkinMatrixes"),
	HX_CSTRING("hasVertexColor"),
	HX_CSTRING("hasVertexColorAdd"),
	HX_CSTRING("lightSystem"),
	HX_CSTRING("hasSkin"),
	HX_CSTRING("hasZBias"),
	HX_CSTRING("hasShadowMap"),
	HX_CSTRING("killAlpha"),
	HX_CSTRING("hasAlphaMap"),
	HX_CSTRING("hasBlend"),
	HX_CSTRING("hasGlow"),
	HX_CSTRING("lights"),
	HX_CSTRING("set_lightSystem"),
	HX_CSTRING("getConstants"),
	HX_CSTRING("skinMatrixes"),
	HX_CSTRING("mpos"),
	HX_CSTRING("mproj"),
	HX_CSTRING("zBias"),
	HX_CSTRING("uvScale"),
	HX_CSTRING("uvDelta"),
	HX_CSTRING("shadowLightProj"),
	HX_CSTRING("shadowLightCenter"),
	HX_CSTRING("fog"),
	HX_CSTRING("mposInv"),
	HX_CSTRING("tex"),
	HX_CSTRING("colorAdd"),
	HX_CSTRING("colorMul"),
	HX_CSTRING("colorMatrix"),
	HX_CSTRING("killAlphaThreshold"),
	HX_CSTRING("alphaMap"),
	HX_CSTRING("blendTexture"),
	HX_CSTRING("glowTexture"),
	HX_CSTRING("glowAmount"),
	HX_CSTRING("shadowTexture"),
	HX_CSTRING("shadowColor"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(MeshShader_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(MeshShader_obj::VERTEX,"VERTEX");
	HX_MARK_MEMBER_NAME(MeshShader_obj::FRAGMENT,"FRAGMENT");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(MeshShader_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(MeshShader_obj::VERTEX,"VERTEX");
	HX_VISIT_MEMBER_NAME(MeshShader_obj::FRAGMENT,"FRAGMENT");
};

#endif

Class MeshShader_obj::__mClass;

void MeshShader_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.mat.MeshShader"), hx::TCanCast< MeshShader_obj> ,sStaticFields,sMemberFields,
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

void MeshShader_obj::__boot()
{
	VERTEX= HX_CSTRING("\r\n\t\r\n\t\tattribute vec3 pos;\r\n\t\tattribute vec2 uv;\r\n\t\t#if hasLightSystem\r\n\t\tattribute vec3 normal;\r\n\t\t#end\r\n\t\t#if hasVertexColor\r\n\t\tattribute vec3 color;\r\n\t\t#end\r\n\t\t#if hasVertexColorAdd\r\n\t\tattribute vec3 colorAdd;\r\n\t\t#end\r\n\t\t#if hasBlend\r\n\t\tattribute float blending;\r\n\t\t#end\r\n\t\t\r\n\t\t#if hasSkin\r\n\t\tuniform mat4 skinMatrixes[maxSkinMatrixes];\r\n\t\t\r\n\t\tattribute vec4 indexes/*byte4*/;\r\n\t\tattribute vec3 weights;\r\n\t\t#end\r\n\r\n\t\tuniform mat4 mpos;\r\n\t\tuniform mat4 mproj;\r\n\t\tuniform float zBias;\r\n\t\tuniform vec2 uvScale;\r\n\t\tuniform vec2 uvDelta;\r\n\t\t\r\n\t\t#if hasLightSystem\r\n\t\t// we can't use Array of structures in GLSL\r\n\t\tstruct LightSystem {\r\n\t\t\tvec3 ambient;\r\n\t\t\tvec3 dirsDir[numDirLights];\r\n\t\t\tvec3 dirsColor[numDirLights];\r\n\t\t\tvec3 pointsPos[numPointLights];\r\n\t\t\tvec3 pointsColor[numPointLights];\r\n\t\t\tvec3 pointsAtt[numPointLights];\r\n\t\t};\r\n\t\tuniform LightSystem lights;\r\n\t\t#end\r\n\t\t\t\r\n\t\t#if hasShadowMap\r\n\t\tuniform mat4 shadowLightProj;\r\n\t\tuniform mat4 shadowLightCenter;\r\n\t\t#end\r\n\r\n\t\tuniform vec4 fog;\r\n\t\t\r\n\t\tvarying lowp vec2 tuv;\r\n\t\tvarying lowp vec3 tcolor;\r\n\t\tvarying lowp vec3 acolor;\r\n\t\tvarying mediump float talpha;\r\n\t\tvarying mediump float tblend;\r\n\t\t\r\n\t\t//varying vec4 dbgweight;\r\n\t\t\r\n\t\t#if hasShadowMap\r\n\t\tvarying mediump vec4 tshadowPos;\r\n\t\t#end\r\n\t\t\r\n\t\tuniform mat3 mposInv;\r\n\r\n\t\tvoid main(void) {\r\n\t\t\tvec4 tpos = vec4(pos.xyz, 1.0);\r\n\t\t\t\r\n\t\t\t#if hasSkin\r\n\t\t\t\r\n\t\t\t\tint ix = int(indexes.x); int iy = int(indexes.y); int iz = int(indexes.z);\r\n\t\t\t\t\r\n\t\t\t\tfloat wx = weights.x;\r\n\t\t\t\tfloat wy = weights.y;\r\n\t\t\t\tfloat wz = weights.z;\r\n\t\t\t\t\r\n\t\t\t\t//dbgweight.x = wx;\r\n\t\t\t\t//dbgweight.y = wy;\r\n\t\t\t\t//dbgweight.z = wz;\r\n\t\t\t\t\r\n\t\t\t\t/*\r\n\t\t\t\tmat4 id = mat4(\r\n\t\t\t\t1,0,0,0,\r\n\t\t\t\t0,1,0,0,\r\n\t\t\t\t0,0,1,0,\r\n\t\t\t\t0,0,0,1\r\n\t\t\t\t);\r\n\t\t\t\t*/\r\n\t\t\t\ttpos.xyz = (tpos * wx * skinMatrixes[ix] + tpos * wy * skinMatrixes[iy] + tpos * wz * skinMatrixes[iz]).xyz;\r\n\t\t\t\t//tpos.xyz = (tpos * wx * id + tpos * wy * id + tpos * wz * id).xyz;\r\n\t\t\t\t\r\n\t\t\t#elseif hasPos\r\n\t\t\t\ttpos *= mpos;\r\n\t\t\t#end\r\n\t\t\t\r\n\t\t\tvec4 ppos = tpos * mproj;\r\n\t\t\t#if hasZBias\r\n\t\t\t\tppos.z += zBias;\r\n\t\t\t#end\r\n\t\t\tgl_Position = ppos;\r\n\t\t\tvec2 t = uv;\r\n\t\t\t#if hasUVScale\r\n\t\t\t\tt *= uvScale;\r\n\t\t\t#end\r\n\t\t\t#if hasUVDelta\r\n\t\t\t\tt += uvDelta;\r\n\t\t\t#end\r\n\t\t\ttuv = t;\r\n\t\t\t#if hasLightSystem\r\n\t\t\t\tvec3 n = normal;\r\n\t\t\t\t#if hasPos\r\n\t\t\t\t\tn *= mat3(mpos);\r\n\t\t\t\t#elseif hasSkin\r\n\t\t\t\t\r\n\t\t\t\t\tn = \tn*wx*skinMatrixes[ix]  \r\n\t\t\t\t\t\t+ \tn*wy*skinMatrixes[iy]  \r\n\t\t\t\t\t\t+ \tn*wz*skinMatrixes[iz];\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t#if hasPos\r\n\t\t\t\t\t\tn = mposInv * n;\r\n\t\t\t\t\t#end\r\n\t\t\t\t#end\r\n\t\t\t\tn = normalize(n);\r\n\t\t\t\tvec3 col = lights.ambient;\r\n\t\t\t\t\r\n\t\t\t\tfor (int i = 0; i < numDirLights; i++ )\r\n\t\t\t\t\tcol += lights.dirsColor[i] * max(dot(n, -lights.dirsDir[i]), 0.);\r\n\t\t\t\t\r\n\t\t\t\tfor(int i = 0; i < numPointLights; i++ ) {\r\n\t\t\t\t\tvec3 d = tpos.xyz - lights.pointsPos[i];\r\n\t\t\t\t\tfloat dist2 = dot(d,d);\r\n\t\t\t\t\tfloat dist = sqrt(dist2);\r\n\t\t\t\t\tcol += lights.pointsColor[i] * (max(dot(n,d),0.) / dot(lights.pointsAtt[i],vec3(dist,dist2,dist2*dist)));\r\n\t\t\t\t}\r\n\t\t\t\t\r\n\t\t\t\t#if hasVertexColor\r\n\t\t\t\t\ttcolor = col.rgb * color;\r\n\t\t\t\t#else\r\n\t\t\t\t\ttcolor = col.rgb;\r\n\t\t\t\t#end\r\n\t\t\t\t\r\n\t\t\t#elseif hasVertexColor\r\n\t\t\t\ttcolor = color;\r\n\t\t\t#else\r\n\t\t\t\ttcolor = vec3(1.,1.,1.);\r\n\t\t\t#end \r\n\t\t\t\r\n\t\t\t#if hasVertexColorAdd\r\n\t\t\t\tacolor = colorAdd;\r\n\t\t\t#end\r\n\t\t\t#if hasFog\r\n\t\t\t\tvec3 dist = tpos.xyz - fog.xyz;\r\n\t\t\t\ttalpha = (fog.w * dist.dot(dist).rsqrt()).min(1.);\r\n\t\t\t#end\r\n\t\t\t#if hasBlend\r\n\t\t\t\ttblend = blending;\r\n\t\t\t#end\r\n\t\t\t#if hasShadowMap\r\n\t\t\t\ttshadowPos = shadowLightCenter * shadowLightProj * tpos;\r\n\t\t\t#end\r\n\t\t\t\r\n\t\t}\r\n\r\n\t");
	FRAGMENT= HX_CSTRING("\r\n\t\tvarying lowp vec2 tuv;\r\n\t\tvarying lowp vec3 tcolor;\r\n\t\tvarying lowp vec3 acolor;\r\n\t\tvarying mediump float talpha;\r\n\t\tvarying mediump float tblend;\r\n\t\tvarying mediump vec4 tshadowPos;\r\n\t\t\r\n\t\t//varying vec4 dbgweight;\r\n\r\n\t\tuniform sampler2D tex;\r\n\t\tuniform lowp vec4 colorAdd;\r\n\t\tuniform lowp vec4 colorMul;\r\n\t\tuniform mediump mat4 colorMatrix;\r\n\t\t\r\n\t\tuniform lowp float killAlphaThreshold;\r\n\r\n\t\t#if hasAlphaMap\r\n\t\tuniform sampler2D alphaMap;\r\n\t\t#end\r\n\t\t\r\n\t\t#if hasBlend\r\n\t\tuniform sampler2D blendTexture;\r\n\t\t#end\r\n\r\n\t\t#if hasGlow\r\n\t\tuniform sampler2D glowTexture;\r\n\t\tuniform float glowAmount;\r\n\t\t#end\r\n\r\n\t\t#if hasShadowMap\r\n\t\tuniform sampler2D shadowTexture;\r\n\t\tuniform vec4 shadowColor;\r\n\t\t#end\r\n\r\n\t\tvoid main(void) {\r\n\t\t\tlowp vec4 c = texture2D(tex, tuv);\r\n\t\t\t#if hasFog\r\n\t\t\t\tc.a *= talpha;\r\n\t\t\t#end\r\n\t\t\t#if hasAlphaMap\r\n\t\t\t\tc.a *= texture2D(alphaMap, tuv).b;\r\n\t\t\t#end\r\n\t\t\t#if killAlpha\r\n\t\t\t\tif( c.a - killAlphaThreshold ) discard;\r\n\t\t\t#end\r\n\t\t\t#if hasBlend\r\n\t\t\t\tc.rgb = c.rgb * (1. - tblend) + tblend * texture2D(blendTexture, tuv).rgb;\r\n\t\t\t#end\r\n\t\t\t#if hasColorAdd\r\n\t\t\t\tc += colorAdd;\r\n\t\t\t#end\r\n\t\t\t#if hasColorMul\r\n\t\t\t\tc *= colorMul;\r\n\t\t\t#end\r\n\t\t\t#if hasColorMatrix\r\n\t\t\t\tc = colorMatrix * c;\r\n\t\t\t#end\r\n\t\t\t#if hasVertexColorAdd\r\n\t\t\t\tc.rgb += acolor;\r\n\t\t\t#end\r\n\t\t\t#if hasFragColor\r\n\t\t\t\tc.rgb *= tcolor;\r\n\t\t\t#end\r\n\t\t\t#if hasShadowMap\r\n\t\t\t\t// ESM filtering\r\n\t\t\t\tmediump float shadow = exp( shadowColor.w * (tshadowPos.z - shadowTexture.get(tshadowPos.xy).dot([1., 1. / 255., 1. / (255. * 255.), 1. / (255. * 255. * 255.)]))).sat();\r\n\t\t\t\tc.rgb *= (1. - shadow) * shadowColor.rgb + shadow.xxx;\r\n\t\t\t#end\r\n\t\t\t#if hasGlow\r\n\t\t\t\tc.rgb += texture2D(glowTexture,tuv).rgb * glowAmount;\r\n\t\t\t#end\r\n\t\t\tgl_FragColor = c;\r\n\t\t\t\r\n\t\t\t//gl_FragColor.r = dbgweight.x;\r\n\t\t\t//gl_FragColor.r = 0;\r\n\t\t\t//gl_FragColor.g = dbgweight.y;\r\n\t\t\t//gl_FragColor.g = 0;\r\n\t\t\t//gl_FragColor.b = dbgweight.z;\r\n\t\t}\r\n\r\n\t");
}

} // end namespace h3d
} // end namespace mat
