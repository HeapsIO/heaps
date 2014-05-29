#include <hxcpp.h>

#ifndef INCLUDED_EReg
#include <EReg.h>
#endif
#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_List
#include <List.h>
#endif
#ifndef INCLUDED_Reflect
#include <Reflect.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_StringTools
#include <StringTools.h>
#endif
#ifndef INCLUDED_Type
#include <Type.h>
#endif
#ifndef INCLUDED_ValueType
#include <ValueType.h>
#endif
#ifndef INCLUDED_flash_display_BitmapData
#include <flash/display/BitmapData.h>
#endif
#ifndef INCLUDED_flash_display_IBitmapDrawable
#include <flash/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_flash_utils_ByteArray
#include <flash/utils/ByteArray.h>
#endif
#ifndef INCLUDED_flash_utils_IDataInput
#include <flash/utils/IDataInput.h>
#endif
#ifndef INCLUDED_flash_utils_IDataOutput
#include <flash/utils/IDataOutput.h>
#endif
#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
#endif
#ifndef INCLUDED_h3d_Vector
#include <h3d/Vector.h>
#endif
#ifndef INCLUDED_h3d_impl_Attribute
#include <h3d/impl/Attribute.h>
#endif
#ifndef INCLUDED_h3d_impl_BigBuffer
#include <h3d/impl/BigBuffer.h>
#endif
#ifndef INCLUDED_h3d_impl_Buffer
#include <h3d/impl/Buffer.h>
#endif
#ifndef INCLUDED_h3d_impl_BufferOffset
#include <h3d/impl/BufferOffset.h>
#endif
#ifndef INCLUDED_h3d_impl_Driver
#include <h3d/impl/Driver.h>
#endif
#ifndef INCLUDED_h3d_impl_FBO
#include <h3d/impl/FBO.h>
#endif
#ifndef INCLUDED_h3d_impl_GLActiveInfo
#include <h3d/impl/GLActiveInfo.h>
#endif
#ifndef INCLUDED_h3d_impl_GLVB
#include <h3d/impl/GLVB.h>
#endif
#ifndef INCLUDED_h3d_impl_GlDriver
#include <h3d/impl/GlDriver.h>
#endif
#ifndef INCLUDED_h3d_impl_Shader
#include <h3d/impl/Shader.h>
#endif
#ifndef INCLUDED_h3d_impl_ShaderInstance
#include <h3d/impl/ShaderInstance.h>
#endif
#ifndef INCLUDED_h3d_impl_ShaderType
#include <h3d/impl/ShaderType.h>
#endif
#ifndef INCLUDED_h3d_impl_Uniform
#include <h3d/impl/Uniform.h>
#endif
#ifndef INCLUDED_h3d_impl_UniformContext
#include <h3d/impl/UniformContext.h>
#endif
#ifndef INCLUDED_h3d_mat_Filter
#include <h3d/mat/Filter.h>
#endif
#ifndef INCLUDED_h3d_mat_MipMap
#include <h3d/mat/MipMap.h>
#endif
#ifndef INCLUDED_h3d_mat_Texture
#include <h3d/mat/Texture.h>
#endif
#ifndef INCLUDED_h3d_mat_Wrap
#include <h3d/mat/Wrap.h>
#endif
#ifndef INCLUDED_haxe_CallStack
#include <haxe/CallStack.h>
#endif
#ifndef INCLUDED_haxe_Log
#include <haxe/Log.h>
#endif
#ifndef INCLUDED_haxe_StackItem
#include <haxe/StackItem.h>
#endif
#ifndef INCLUDED_haxe_Timer
#include <haxe/Timer.h>
#endif
#ifndef INCLUDED_haxe_ds_IntMap
#include <haxe/ds/IntMap.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_hxd_Assert
#include <hxd/Assert.h>
#endif
#ifndef INCLUDED_hxd_PixelFormat
#include <hxd/PixelFormat.h>
#endif
#ifndef INCLUDED_hxd_Pixels
#include <hxd/Pixels.h>
#endif
#ifndef INCLUDED_hxd_System
#include <hxd/System.h>
#endif
#ifndef INCLUDED_hxd__BitmapData_BitmapData_Impl_
#include <hxd/_BitmapData/BitmapData_Impl_.h>
#endif
#ifndef INCLUDED_openfl_gl_GL
#include <openfl/gl/GL.h>
#endif
#ifndef INCLUDED_openfl_gl_GLBuffer
#include <openfl/gl/GLBuffer.h>
#endif
#ifndef INCLUDED_openfl_gl_GLFramebuffer
#include <openfl/gl/GLFramebuffer.h>
#endif
#ifndef INCLUDED_openfl_gl_GLObject
#include <openfl/gl/GLObject.h>
#endif
#ifndef INCLUDED_openfl_gl_GLProgram
#include <openfl/gl/GLProgram.h>
#endif
#ifndef INCLUDED_openfl_gl_GLRenderbuffer
#include <openfl/gl/GLRenderbuffer.h>
#endif
#ifndef INCLUDED_openfl_gl_GLShader
#include <openfl/gl/GLShader.h>
#endif
#ifndef INCLUDED_openfl_gl_GLTexture
#include <openfl/gl/GLTexture.h>
#endif
#ifndef INCLUDED_openfl_utils_ArrayBufferView
#include <openfl/utils/ArrayBufferView.h>
#endif
#ifndef INCLUDED_openfl_utils_Float32Array
#include <openfl/utils/Float32Array.h>
#endif
#ifndef INCLUDED_openfl_utils_IMemoryRange
#include <openfl/utils/IMemoryRange.h>
#endif
#ifndef INCLUDED_openfl_utils_Int16Array
#include <openfl/utils/Int16Array.h>
#endif
#ifndef INCLUDED_openfl_utils_UInt8Array
#include <openfl/utils/UInt8Array.h>
#endif
namespace h3d{
namespace impl{

Void GlDriver_obj::__construct()
{
HX_STACK_FRAME("h3d.impl.GlDriver","new",0x9a4d8798,"h3d.impl.GlDriver.new","h3d/impl/GlDriver.hx",90,0xae6eb278)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(310)
	this->vpHeight = (int)0;
	HX_STACK_LINE(309)
	this->vpWidth = (int)0;
	HX_STACK_LINE(110)
	this->resetSwitch = (int)0;
	HX_STACK_LINE(109)
	this->textureSwitch = (int)0;
	HX_STACK_LINE(108)
	this->shaderSwitch = (int)0;
	HX_STACK_LINE(106)
	this->curTex = Array_obj< ::Dynamic >::__new();
	HX_STACK_LINE(126)
	::openfl::utils::Float32Array tmp = ::openfl::utils::Float32Array_obj::__new((int)8,null(),null());		HX_STACK_VAR(tmp,"tmp");
	HX_STACK_LINE(127)
	::openfl::utils::Float32Array sub = ::openfl::utils::Float32Array_obj::__new(tmp->buffer,(int)0,(int)4);		HX_STACK_VAR(sub,"sub");
	HX_STACK_LINE(128)
	this->fixMult = (sub->length == (int)1);
	HX_STACK_LINE(131)
	this->depthMask = false;
	HX_STACK_LINE(132)
	this->depthTest = false;
	HX_STACK_LINE(133)
	this->depthFunc = (int)0;
	HX_STACK_LINE(136)
	this->curMatBits = (int)-1;
	HX_STACK_LINE(137)
	this->selectMaterial((int)0);
	HX_STACK_LINE(139)
	{
		HX_STACK_LINE(139)
		::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
		HX_STACK_LINE(139)
		int pos_lineNumber = (int)139;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
		HX_STACK_LINE(139)
		::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
		HX_STACK_LINE(139)
		::String pos_methodName = HX_CSTRING("new");		HX_STACK_VAR(pos_methodName,"pos_methodName");
		HX_STACK_LINE(139)
		if (((::hxd::System_obj::debugLevel >= (int)3))){
			HX_STACK_LINE(139)
			::String _g = HX_CSTRING("gldriver newed");		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(139)
			::String _g1 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(139)
			::haxe::Log_obj::trace(_g1,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
		}
		HX_STACK_LINE(139)
		HX_CSTRING("gldriver newed");
	}
	HX_STACK_LINE(141)
	::List _g2 = ::List_obj::__new();		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(141)
	this->fboList = _g2;
	HX_STACK_LINE(142)
	::List _g3 = ::List_obj::__new();		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(142)
	this->fboStack = _g3;
}
;
	return null();
}

//GlDriver_obj::~GlDriver_obj() { }

Dynamic GlDriver_obj::__CreateEmpty() { return  new GlDriver_obj; }
hx::ObjectPtr< GlDriver_obj > GlDriver_obj::__new()
{  hx::ObjectPtr< GlDriver_obj > result = new GlDriver_obj();
	result->__construct();
	return result;}

Dynamic GlDriver_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< GlDriver_obj > result = new GlDriver_obj();
	result->__construct();
	return result;}

::openfl::utils::UInt8Array GlDriver_obj::getUints( ::haxe::io::Bytes h,hx::Null< int >  __o_pos,Dynamic size){
int pos = __o_pos.Default(0);
	HX_STACK_FRAME("h3d.impl.GlDriver","getUints",0x55df50eb,"h3d.impl.GlDriver.getUints","h3d/impl/GlDriver.hx",147,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_ARG(h,"h")
	HX_STACK_ARG(pos,"pos")
	HX_STACK_ARG(size,"size")
{
		HX_STACK_LINE(151)
		::flash::utils::ByteArray _g = ::flash::utils::ByteArray_obj::fromBytes(h);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(149)
		return ::openfl::utils::UInt8Array_obj::__new(_g,pos,size);
	}
}


HX_DEFINE_DYNAMIC_FUNC3(GlDriver_obj,getUints,return )

::openfl::utils::Int16Array GlDriver_obj::getUints16( ::haxe::io::Bytes h,hx::Null< int >  __o_pos){
int pos = __o_pos.Default(0);
	HX_STACK_FRAME("h3d.impl.GlDriver","getUints16",0x0905cc90,"h3d.impl.GlDriver.getUints16","h3d/impl/GlDriver.hx",159,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_ARG(h,"h")
	HX_STACK_ARG(pos,"pos")
{
		HX_STACK_LINE(163)
		::flash::utils::ByteArray _g = ::flash::utils::ByteArray_obj::fromBytes(h);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(161)
		return ::openfl::utils::Int16Array_obj::__new(_g,pos,null());
	}
}


HX_DEFINE_DYNAMIC_FUNC2(GlDriver_obj,getUints16,return )

Void GlDriver_obj::reset( ){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","reset",0x3c083f07,"h3d.impl.GlDriver.reset","h3d/impl/GlDriver.hx",171,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_LINE(172)
		(this->resetSwitch)++;
		HX_STACK_LINE(173)
		this->curShader = null();
		HX_STACK_LINE(174)
		{
			HX_STACK_LINE(174)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(174)
			int _g = this->curTex->length;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(174)
			while((true)){
				HX_STACK_LINE(174)
				if ((!(((_g1 < _g))))){
					HX_STACK_LINE(174)
					break;
				}
				HX_STACK_LINE(174)
				int i = (_g1)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(175)
				this->curTex[i] = null();
			}
		}
		HX_STACK_LINE(176)
		::openfl::gl::GL_obj::lime_gl_use_program(null());
	}
return null();
}


Void GlDriver_obj::selectMaterial( int mbits){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","selectMaterial",0x29bb338b,"h3d.impl.GlDriver.selectMaterial","h3d/impl/GlDriver.hx",179,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_ARG(mbits,"mbits")
		HX_STACK_LINE(180)
		int diff = (int(this->curMatBits) ^ int(mbits));		HX_STACK_VAR(diff,"diff");
		HX_STACK_LINE(181)
		if (((diff == (int)0))){
			HX_STACK_LINE(182)
			return null();
		}
		HX_STACK_LINE(184)
		if (((((int(diff) & int((int)3))) != (int)0))){
			HX_STACK_LINE(185)
			if (((((int(mbits) & int((int)3))) == (int)0))){
				HX_STACK_LINE(186)
				::openfl::gl::GL_obj::lime_gl_disable((int)2884);
			}
			else{
				HX_STACK_LINE(189)
				if (((((int(this->curMatBits) & int((int)3))) == (int)0))){
					HX_STACK_LINE(190)
					::openfl::gl::GL_obj::lime_gl_enable((int)2884);
				}
				HX_STACK_LINE(192)
				::openfl::gl::GL_obj::lime_gl_cull_face(::h3d::impl::GlDriver_obj::FACES->__get((int(mbits) & int((int)3))));
			}
		}
		HX_STACK_LINE(196)
		if (((((int(diff) & int((int)16320))) != (int)0))){
			HX_STACK_LINE(197)
			int src = (int((int(mbits) >> int((int)6))) & int((int)15));		HX_STACK_VAR(src,"src");
			HX_STACK_LINE(198)
			int dst = (int((int(mbits) >> int((int)10))) & int((int)15));		HX_STACK_VAR(dst,"dst");
			HX_STACK_LINE(199)
			if (((bool((src == (int)0)) && bool((dst == (int)1))))){
				HX_STACK_LINE(200)
				::openfl::gl::GL_obj::lime_gl_disable((int)3042);
				HX_STACK_LINE(201)
				Dynamic();
			}
			else{
				HX_STACK_LINE(204)
				if (((bool((this->curMatBits < (int)0)) || bool((((int((int(this->curMatBits) >> int((int)6))) & int((int)255))) == (int)16))))){
					HX_STACK_LINE(205)
					::openfl::gl::GL_obj::lime_gl_enable((int)3042);
					HX_STACK_LINE(206)
					Dynamic();
				}
				HX_STACK_LINE(209)
				::openfl::gl::GL_obj::lime_gl_blend_func(::h3d::impl::GlDriver_obj::BLEND->__get(src),::h3d::impl::GlDriver_obj::BLEND->__get(dst));
				HX_STACK_LINE(210)
				Dynamic();
			}
		}
		HX_STACK_LINE(214)
		if (((((int(diff) & int((int)60))) != (int)0))){
			HX_STACK_LINE(215)
			bool write = (((int((int(mbits) >> int((int)2))) & int((int)1))) == (int)1);		HX_STACK_VAR(write,"write");
			HX_STACK_LINE(216)
			if (((bool((this->curMatBits < (int)0)) || bool((((int(diff) & int((int)4))) != (int)0))))){
				HX_STACK_LINE(217)
				if (((this->depthMask != write))){
					HX_STACK_LINE(218)
					bool flag = this->depthMask = write;		HX_STACK_VAR(flag,"flag");
					HX_STACK_LINE(218)
					::openfl::gl::GL_obj::lime_gl_depth_mask(flag);
				}
			}
			HX_STACK_LINE(221)
			if ((!(this->depthTest))){
				HX_STACK_LINE(222)
				::openfl::gl::GL_obj::lime_gl_enable((int)2929);
				HX_STACK_LINE(223)
				this->depthTest = true;
				HX_STACK_LINE(224)
				Dynamic();
			}
			HX_STACK_LINE(227)
			int cmp = (int((int(mbits) >> int((int)3))) & int((int)7));		HX_STACK_VAR(cmp,"cmp");
			HX_STACK_LINE(228)
			if (((cmp == (int)0))){
				HX_STACK_LINE(231)
				if ((this->depthTest)){
					HX_STACK_LINE(232)
					::openfl::gl::GL_obj::lime_gl_disable((int)2929);
					HX_STACK_LINE(233)
					this->depthTest = false;
				}
			}
			else{
				HX_STACK_LINE(238)
				if (((bool((this->curMatBits < (int)0)) || bool((((int((int(this->curMatBits) >> int((int)3))) & int((int)7))) == (int)0))))){
					HX_STACK_LINE(240)
					if ((!(this->depthTest))){
						HX_STACK_LINE(241)
						::openfl::gl::GL_obj::lime_gl_enable((int)2929);
						HX_STACK_LINE(242)
						this->depthTest = true;
					}
				}
				HX_STACK_LINE(246)
				{
					HX_STACK_LINE(246)
					::String _g = this->glCompareToString(::h3d::impl::GlDriver_obj::COMPARE->__get(cmp));		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(246)
					::String _ = (HX_CSTRING("using ") + _g);		HX_STACK_VAR(_,"_");
					HX_STACK_LINE(246)
					Dynamic();
				}
				HX_STACK_LINE(248)
				if (((cmp != this->depthFunc))){
					HX_STACK_LINE(249)
					int _g1 = this->depthFunc = cmp;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(249)
					int func = ::h3d::impl::GlDriver_obj::COMPARE->__get(_g1);		HX_STACK_VAR(func,"func");
					HX_STACK_LINE(249)
					::openfl::gl::GL_obj::lime_gl_depth_func(func);
				}
			}
		}
		else{
			HX_STACK_LINE(253)
			if ((this->depthTest)){
				HX_STACK_LINE(254)
				::openfl::gl::GL_obj::lime_gl_disable((int)2929);
				HX_STACK_LINE(255)
				this->depthTest = false;
			}
		}
		HX_STACK_LINE(259)
		{
			HX_STACK_LINE(259)
			int _g2 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(259)
			if (((_g2 != (int)0))){
				HX_STACK_LINE(259)
				::String s;		HX_STACK_VAR(s,"s");
				HX_STACK_LINE(259)
				{
					HX_STACK_LINE(259)
					int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(259)
					switch( (int)(_g)){
						case (int)0: {
							HX_STACK_LINE(259)
							s = null();
						}
						;break;
						case (int)1280: {
							HX_STACK_LINE(259)
							s = HX_CSTRING("INVALID_ENUM");
						}
						;break;
						case (int)1281: {
							HX_STACK_LINE(259)
							s = HX_CSTRING("INVALID_VALUE");
						}
						;break;
						case (int)1282: {
							HX_STACK_LINE(259)
							s = HX_CSTRING("INVALID_OPERATION");
						}
						;break;
						case (int)1285: {
							HX_STACK_LINE(259)
							s = HX_CSTRING("OUT_OF_MEMORY");
						}
						;break;
						default: {
							HX_STACK_LINE(259)
							s = null();
						}
					}
				}
				HX_STACK_LINE(259)
				if (((s != null()))){
					HX_STACK_LINE(259)
					::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
					HX_STACK_LINE(259)
					::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
					HX_STACK_LINE(259)
					HX_STACK_DO_THROW(s);
				}
			}
		}
		HX_STACK_LINE(262)
		if (((((int(diff) & int((int)245760))) != (int)0))){
			HX_STACK_LINE(264)
			::openfl::gl::GL_obj::lime_gl_color_mask((((int((int(mbits) >> int((int)14))) & int((int)1))) != (int)0),(((int((int(mbits) >> int((int)14))) & int((int)2))) != (int)0),(((int((int(mbits) >> int((int)14))) & int((int)4))) != (int)0),(((int((int(mbits) >> int((int)14))) & int((int)8))) != (int)0));
			HX_STACK_LINE(265)
			{
				HX_STACK_LINE(265)
				int _g3 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(265)
				if (((_g3 != (int)0))){
					HX_STACK_LINE(265)
					::String s;		HX_STACK_VAR(s,"s");
					HX_STACK_LINE(265)
					{
						HX_STACK_LINE(265)
						int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
						HX_STACK_LINE(265)
						switch( (int)(_g)){
							case (int)0: {
								HX_STACK_LINE(265)
								s = null();
							}
							;break;
							case (int)1280: {
								HX_STACK_LINE(265)
								s = HX_CSTRING("INVALID_ENUM");
							}
							;break;
							case (int)1281: {
								HX_STACK_LINE(265)
								s = HX_CSTRING("INVALID_VALUE");
							}
							;break;
							case (int)1282: {
								HX_STACK_LINE(265)
								s = HX_CSTRING("INVALID_OPERATION");
							}
							;break;
							case (int)1285: {
								HX_STACK_LINE(265)
								s = HX_CSTRING("OUT_OF_MEMORY");
							}
							;break;
							default: {
								HX_STACK_LINE(265)
								s = null();
							}
						}
					}
					HX_STACK_LINE(265)
					if (((s != null()))){
						HX_STACK_LINE(265)
						::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
						HX_STACK_LINE(265)
						::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
						HX_STACK_LINE(265)
						HX_STACK_DO_THROW(s);
					}
				}
			}
		}
		HX_STACK_LINE(269)
		this->curMatBits = mbits;
		HX_STACK_LINE(270)
		Dynamic();
	}
return null();
}


Void GlDriver_obj::clear( Float r,Float g,Float b,Float a){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","clear",0x9d9b66c5,"h3d.impl.GlDriver.clear","h3d/impl/GlDriver.hx",273,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_ARG(r,"r")
		HX_STACK_ARG(g,"g")
		HX_STACK_ARG(b,"b")
		HX_STACK_ARG(a,"a")
		HX_STACK_LINE(274)
		this->super::clear(r,g,b,a);
		HX_STACK_LINE(276)
		this->curMatBits = (int)0;
		HX_STACK_LINE(277)
		::openfl::gl::GL_obj::lime_gl_clear_color(r,g,b,a);
		HX_STACK_LINE(278)
		{
			HX_STACK_LINE(278)
			bool flag = this->depthMask = true;		HX_STACK_VAR(flag,"flag");
			HX_STACK_LINE(278)
			::openfl::gl::GL_obj::lime_gl_depth_mask(flag);
		}
		HX_STACK_LINE(279)
		::openfl::gl::GL_obj::lime_gl_clear_depth(1.0);
		HX_STACK_LINE(280)
		::openfl::gl::GL_obj::lime_gl_depth_range((int)0,(int)1);
		HX_STACK_LINE(281)
		::openfl::gl::GL_obj::lime_gl_front_face((int)2304);
		HX_STACK_LINE(282)
		::openfl::gl::GL_obj::lime_gl_disable((int)3089);
		HX_STACK_LINE(285)
		::openfl::gl::GL_obj::lime_gl_clear((int)17664);
		HX_STACK_LINE(286)
		Dynamic();
	}
return null();
}


Void GlDriver_obj::begin( ){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","begin",0x0595df61,"h3d.impl.GlDriver.begin","h3d/impl/GlDriver.hx",290,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_LINE(291)
		this->depthTest = true;
		HX_STACK_LINE(292)
		::openfl::gl::GL_obj::lime_gl_enable((int)2929);
		HX_STACK_LINE(294)
		this->depthFunc = (int)6;
		HX_STACK_LINE(295)
		::openfl::gl::GL_obj::lime_gl_depth_func(::h3d::impl::GlDriver_obj::COMPARE->__get(this->depthFunc));
		HX_STACK_LINE(297)
		this->curTex = Array_obj< ::Dynamic >::__new();
		HX_STACK_LINE(298)
		this->curShader = null();
		HX_STACK_LINE(299)
		this->textureSwitch = (int)0;
		HX_STACK_LINE(300)
		this->shaderSwitch = (int)0;
		HX_STACK_LINE(301)
		this->resetSwitch = (int)0;
	}
return null();
}


Array< ::String > GlDriver_obj::getShaderInputNames( ){
	HX_STACK_FRAME("h3d.impl.GlDriver","getShaderInputNames",0xe94f6ad1,"h3d.impl.GlDriver.getShaderInputNames","h3d/impl/GlDriver.hx",306,0xae6eb278)
	HX_STACK_THIS(this)

	HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_1_1)
	::String run(::h3d::impl::Attribute t){
		HX_STACK_FRAME("*","_Function_1_1",0x5200ed37,"*._Function_1_1","h3d/impl/GlDriver.hx",306,0xae6eb278)
		HX_STACK_ARG(t,"t")
		{
			HX_STACK_LINE(306)
			return t->name;
		}
		return null();
	}
	HX_END_LOCAL_FUNC1(return)

	HX_STACK_LINE(306)
	return this->curShader->attribs->map( Dynamic(new _Function_1_1())).StaticCast< Array< ::String > >();
}


Void GlDriver_obj::resize( int width,int height){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","resize",0x4b31f5bc,"h3d.impl.GlDriver.resize","h3d/impl/GlDriver.hx",312,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_ARG(width,"width")
		HX_STACK_ARG(height,"height")
		HX_STACK_LINE(319)
		::openfl::gl::GL_obj::lime_gl_viewport((int)0,(int)0,width,height);
		HX_STACK_LINE(320)
		this->vpWidth = width;
		HX_STACK_LINE(320)
		this->vpHeight = height;
		HX_STACK_LINE(321)
		{
			HX_STACK_LINE(321)
			::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
			HX_STACK_LINE(321)
			int pos_lineNumber = (int)321;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
			HX_STACK_LINE(321)
			::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
			HX_STACK_LINE(321)
			::String pos_methodName = HX_CSTRING("resize");		HX_STACK_VAR(pos_methodName,"pos_methodName");
			HX_STACK_LINE(321)
			if (((::hxd::System_obj::debugLevel >= (int)2))){
				HX_STACK_LINE(321)
				::String _g = HX_CSTRING("resizing");		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(321)
				::String _g1 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g);		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(321)
				::haxe::Log_obj::trace(_g1,hx::SourceInfo(HX_CSTRING("System.hx"),315,HX_CSTRING("hxd.System"),HX_CSTRING("trace2")));
			}
			HX_STACK_LINE(321)
			HX_CSTRING("resizing");
		}
	}
return null();
}


::openfl::gl::GLTexture GlDriver_obj::allocTexture( ::h3d::mat::Texture t){
	HX_STACK_FRAME("h3d.impl.GlDriver","allocTexture",0x930a96ae,"h3d.impl.GlDriver.allocTexture","h3d/impl/GlDriver.hx",324,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_ARG(t,"t")
	HX_STACK_LINE(326)
	int _g = ::openfl::gl::GL_obj::get_version();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(326)
	Dynamic _g1 = ::openfl::gl::GL_obj::lime_gl_create_texture();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(326)
	::openfl::gl::GLTexture tt = ::openfl::gl::GLTexture_obj::__new(_g,_g1);		HX_STACK_VAR(tt,"tt");
	HX_STACK_LINE(327)
	{
		HX_STACK_LINE(327)
		int _g2 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(327)
		if (((_g2 != (int)0))){
			HX_STACK_LINE(327)
			::String s;		HX_STACK_VAR(s,"s");
			HX_STACK_LINE(327)
			{
				HX_STACK_LINE(327)
				int _g3 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(327)
				switch( (int)(_g3)){
					case (int)0: {
						HX_STACK_LINE(327)
						s = null();
					}
					;break;
					case (int)1280: {
						HX_STACK_LINE(327)
						s = HX_CSTRING("INVALID_ENUM");
					}
					;break;
					case (int)1281: {
						HX_STACK_LINE(327)
						s = HX_CSTRING("INVALID_VALUE");
					}
					;break;
					case (int)1282: {
						HX_STACK_LINE(327)
						s = HX_CSTRING("INVALID_OPERATION");
					}
					;break;
					case (int)1285: {
						HX_STACK_LINE(327)
						s = HX_CSTRING("OUT_OF_MEMORY");
					}
					;break;
					default: {
						HX_STACK_LINE(327)
						s = null();
					}
				}
			}
			HX_STACK_LINE(327)
			if (((s != null()))){
				HX_STACK_LINE(327)
				::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
				HX_STACK_LINE(327)
				::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
				HX_STACK_LINE(327)
				HX_STACK_DO_THROW(s);
			}
		}
	}
	HX_STACK_LINE(328)
	::openfl::gl::GL_obj::lime_gl_bind_texture((int)3553,(  (((tt == null()))) ? Dynamic(null()) : Dynamic(tt->id) ));
	HX_STACK_LINE(328)
	{
		HX_STACK_LINE(328)
		int _g3 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(328)
		if (((_g3 != (int)0))){
			HX_STACK_LINE(328)
			::String s;		HX_STACK_VAR(s,"s");
			HX_STACK_LINE(328)
			{
				HX_STACK_LINE(328)
				int _g2 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(328)
				switch( (int)(_g2)){
					case (int)0: {
						HX_STACK_LINE(328)
						s = null();
					}
					;break;
					case (int)1280: {
						HX_STACK_LINE(328)
						s = HX_CSTRING("INVALID_ENUM");
					}
					;break;
					case (int)1281: {
						HX_STACK_LINE(328)
						s = HX_CSTRING("INVALID_VALUE");
					}
					;break;
					case (int)1282: {
						HX_STACK_LINE(328)
						s = HX_CSTRING("INVALID_OPERATION");
					}
					;break;
					case (int)1285: {
						HX_STACK_LINE(328)
						s = HX_CSTRING("OUT_OF_MEMORY");
					}
					;break;
					default: {
						HX_STACK_LINE(328)
						s = null();
					}
				}
			}
			HX_STACK_LINE(328)
			if (((s != null()))){
				HX_STACK_LINE(328)
				::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
				HX_STACK_LINE(328)
				::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
				HX_STACK_LINE(328)
				HX_STACK_DO_THROW(s);
			}
		}
	}
	HX_STACK_LINE(329)
	{
		HX_STACK_LINE(329)
		::flash::utils::ByteArray _g4 = null();		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(329)
		Dynamic _g5 = null();		HX_STACK_VAR(_g5,"_g5");
		HX_STACK_LINE(329)
		::openfl::gl::GL_obj::lime_gl_tex_image_2d((int)3553,(int)0,(int)6408,t->width,t->height,(int)0,(int)6408,(int)5121,_g4,_g5);
	}
	HX_STACK_LINE(329)
	{
		HX_STACK_LINE(329)
		int _g6 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g6,"_g6");
		HX_STACK_LINE(329)
		if (((_g6 != (int)0))){
			HX_STACK_LINE(329)
			::String s;		HX_STACK_VAR(s,"s");
			HX_STACK_LINE(329)
			{
				HX_STACK_LINE(329)
				int _g2 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(329)
				switch( (int)(_g2)){
					case (int)0: {
						HX_STACK_LINE(329)
						s = null();
					}
					;break;
					case (int)1280: {
						HX_STACK_LINE(329)
						s = HX_CSTRING("INVALID_ENUM");
					}
					;break;
					case (int)1281: {
						HX_STACK_LINE(329)
						s = HX_CSTRING("INVALID_VALUE");
					}
					;break;
					case (int)1282: {
						HX_STACK_LINE(329)
						s = HX_CSTRING("INVALID_OPERATION");
					}
					;break;
					case (int)1285: {
						HX_STACK_LINE(329)
						s = HX_CSTRING("OUT_OF_MEMORY");
					}
					;break;
					default: {
						HX_STACK_LINE(329)
						s = null();
					}
				}
			}
			HX_STACK_LINE(329)
			if (((s != null()))){
				HX_STACK_LINE(329)
				::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
				HX_STACK_LINE(329)
				::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
				HX_STACK_LINE(329)
				HX_STACK_DO_THROW(s);
			}
		}
	}
	HX_STACK_LINE(330)
	::openfl::gl::GL_obj::lime_gl_bind_texture((int)3553,null());
	HX_STACK_LINE(330)
	{
		HX_STACK_LINE(330)
		int _g7 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g7,"_g7");
		HX_STACK_LINE(330)
		if (((_g7 != (int)0))){
			HX_STACK_LINE(330)
			::String s;		HX_STACK_VAR(s,"s");
			HX_STACK_LINE(330)
			{
				HX_STACK_LINE(330)
				int _g2 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(330)
				switch( (int)(_g2)){
					case (int)0: {
						HX_STACK_LINE(330)
						s = null();
					}
					;break;
					case (int)1280: {
						HX_STACK_LINE(330)
						s = HX_CSTRING("INVALID_ENUM");
					}
					;break;
					case (int)1281: {
						HX_STACK_LINE(330)
						s = HX_CSTRING("INVALID_VALUE");
					}
					;break;
					case (int)1282: {
						HX_STACK_LINE(330)
						s = HX_CSTRING("INVALID_OPERATION");
					}
					;break;
					case (int)1285: {
						HX_STACK_LINE(330)
						s = HX_CSTRING("OUT_OF_MEMORY");
					}
					;break;
					default: {
						HX_STACK_LINE(330)
						s = null();
					}
				}
			}
			HX_STACK_LINE(330)
			if (((s != null()))){
				HX_STACK_LINE(330)
				::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
				HX_STACK_LINE(330)
				::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
				HX_STACK_LINE(330)
				HX_STACK_DO_THROW(s);
			}
		}
	}
	HX_STACK_LINE(333)
	Array< ::Dynamic > cs = ::haxe::CallStack_obj::callStack();		HX_STACK_VAR(cs,"cs");
	HX_STACK_LINE(334)
	{
		HX_STACK_LINE(334)
		::String _g8 = ::Std_obj::string(tt);		HX_STACK_VAR(_g8,"_g8");
		HX_STACK_LINE(334)
		::String _g9 = (HX_CSTRING("allocated ") + _g8);		HX_STACK_VAR(_g9,"_g9");
		HX_STACK_LINE(334)
		::String _g10 = (_g9 + HX_CSTRING(" "));		HX_STACK_VAR(_g10,"_g10");
		HX_STACK_LINE(334)
		::String _g11 = ::Std_obj::string(cs->__get((int)6).StaticCast< ::haxe::StackItem >());		HX_STACK_VAR(_g11,"_g11");
		HX_STACK_LINE(334)
		Dynamic msg = (_g10 + _g11);		HX_STACK_VAR(msg,"msg");
		HX_STACK_LINE(334)
		::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
		HX_STACK_LINE(334)
		int pos_lineNumber = (int)334;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
		HX_STACK_LINE(334)
		::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
		HX_STACK_LINE(334)
		::String pos_methodName = HX_CSTRING("allocTexture");		HX_STACK_VAR(pos_methodName,"pos_methodName");
		HX_STACK_LINE(334)
		if (((::hxd::System_obj::debugLevel >= (int)1))){
			HX_STACK_LINE(334)
			::String _g12 = ::Std_obj::string(msg);		HX_STACK_VAR(_g12,"_g12");
			HX_STACK_LINE(334)
			::String _g13 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g12);		HX_STACK_VAR(_g13,"_g13");
			HX_STACK_LINE(334)
			::haxe::Log_obj::trace(_g13,hx::SourceInfo(HX_CSTRING("System.hx"),305,HX_CSTRING("hxd.System"),HX_CSTRING("trace1")));
		}
		HX_STACK_LINE(334)
		msg;
	}
	HX_STACK_LINE(336)
	return tt;
}


::h3d::impl::GLVB GlDriver_obj::allocVertex( int count,int stride,hx::Null< bool >  __o_isDynamic){
bool isDynamic = __o_isDynamic.Default(false);
	HX_STACK_FRAME("h3d.impl.GlDriver","allocVertex",0x1ae9e8f1,"h3d.impl.GlDriver.allocVertex","h3d/impl/GlDriver.hx",339,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_ARG(count,"count")
	HX_STACK_ARG(stride,"stride")
	HX_STACK_ARG(isDynamic,"isDynamic")
{
		HX_STACK_LINE(342)
		int _g = ::openfl::gl::GL_obj::get_version();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(342)
		Dynamic _g1 = ::openfl::gl::GL_obj::lime_gl_create_buffer();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(342)
		::openfl::gl::GLBuffer b = ::openfl::gl::GLBuffer_obj::__new(_g,_g1);		HX_STACK_VAR(b,"b");
		HX_STACK_LINE(348)
		::openfl::utils::UInt8Array tmp = ::openfl::utils::UInt8Array_obj::__new(((count * stride) * (int)4),null(),null());		HX_STACK_VAR(tmp,"tmp");
		HX_STACK_LINE(349)
		::openfl::gl::GL_obj::lime_gl_bind_buffer((int)34962,(  (((b == null()))) ? Dynamic(null()) : Dynamic(b->id) ));
		HX_STACK_LINE(350)
		{
			HX_STACK_LINE(350)
			::flash::utils::ByteArray _g2 = tmp->getByteBuffer();		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(350)
			int _g3 = tmp->getStart();		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(350)
			int _g4 = tmp->getLength();		HX_STACK_VAR(_g4,"_g4");
			HX_STACK_LINE(350)
			::openfl::gl::GL_obj::lime_gl_buffer_data((int)34962,_g2,_g3,_g4,(  ((isDynamic)) ? int((int)35048) : int((int)35044) ));
		}
		HX_STACK_LINE(351)
		::openfl::gl::GL_obj::lime_gl_bind_buffer((int)34962,null());
		HX_STACK_LINE(351)
		this->curBuffer = null();
		HX_STACK_LINE(351)
		this->curMultiBuffer = null();
		HX_STACK_LINE(354)
		return ::h3d::impl::GLVB_obj::__new(b,stride);
	}
}


::openfl::gl::GLBuffer GlDriver_obj::allocIndexes( int count){
	HX_STACK_FRAME("h3d.impl.GlDriver","allocIndexes",0xd4e929d3,"h3d.impl.GlDriver.allocIndexes","h3d/impl/GlDriver.hx",357,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_ARG(count,"count")
	HX_STACK_LINE(359)
	int _g = ::openfl::gl::GL_obj::get_version();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(359)
	Dynamic _g1 = ::openfl::gl::GL_obj::lime_gl_create_buffer();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(359)
	::openfl::gl::GLBuffer b = ::openfl::gl::GLBuffer_obj::__new(_g,_g1);		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(365)
	::openfl::utils::Int16Array tmp = ::openfl::utils::Int16Array_obj::__new(count,null(),null());		HX_STACK_VAR(tmp,"tmp");
	HX_STACK_LINE(366)
	::openfl::gl::GL_obj::lime_gl_bind_buffer((int)34963,(  (((b == null()))) ? Dynamic(null()) : Dynamic(b->id) ));
	HX_STACK_LINE(367)
	{
		HX_STACK_LINE(367)
		::flash::utils::ByteArray _g2 = tmp->getByteBuffer();		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(367)
		int _g3 = tmp->getStart();		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(367)
		int _g4 = tmp->getLength();		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(367)
		::openfl::gl::GL_obj::lime_gl_buffer_data((int)34963,_g2,_g3,_g4,(int)35044);
	}
	HX_STACK_LINE(368)
	::openfl::gl::GL_obj::lime_gl_bind_buffer((int)34963,null());
	HX_STACK_LINE(370)
	return b;
}


Void GlDriver_obj::setRenderZone( int x,int y,int width,int height){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","setRenderZone",0xea06c81c,"h3d.impl.GlDriver.setRenderZone","h3d/impl/GlDriver.hx",374,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(width,"width")
		HX_STACK_ARG(height,"height")
		HX_STACK_LINE(374)
		if (((bool((bool((bool((x == (int)0)) && bool((y == (int)0)))) && bool((width < (int)0)))) && bool((height < (int)0))))){
			HX_STACK_LINE(375)
			::openfl::gl::GL_obj::lime_gl_disable((int)3089);
		}
		else{
			HX_STACK_LINE(378)
			if (((x < (int)0))){
				HX_STACK_LINE(379)
				hx::AddEq(width,x);
				HX_STACK_LINE(380)
				x = (int)0;
			}
			HX_STACK_LINE(382)
			if (((y < (int)0))){
				HX_STACK_LINE(383)
				hx::AddEq(height,y);
				HX_STACK_LINE(384)
				y = (int)0;
			}
			HX_STACK_LINE(388)
			int tw = this->vpWidth;		HX_STACK_VAR(tw,"tw");
			HX_STACK_LINE(389)
			int th = this->vpHeight;		HX_STACK_VAR(th,"th");
			HX_STACK_LINE(390)
			if ((((x + width) > tw))){
				HX_STACK_LINE(390)
				width = (tw - x);
			}
			HX_STACK_LINE(391)
			if ((((y + height) > th))){
				HX_STACK_LINE(391)
				height = (th - y);
			}
			HX_STACK_LINE(392)
			if (((width <= (int)0))){
				HX_STACK_LINE(392)
				x = (int)0;
				HX_STACK_LINE(392)
				width = (int)1;
			}
			HX_STACK_LINE(393)
			if (((height <= (int)0))){
				HX_STACK_LINE(393)
				y = (int)0;
				HX_STACK_LINE(393)
				height = (int)1;
			}
			HX_STACK_LINE(395)
			::openfl::gl::GL_obj::lime_gl_enable((int)3089);
			HX_STACK_LINE(396)
			::openfl::gl::GL_obj::lime_gl_scissor(x,y,width,height);
		}
	}
return null();
}


Void GlDriver_obj::checkFBO( ::h3d::impl::FBO fbo){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","checkFBO",0xff4b8993,"h3d.impl.GlDriver.checkFBO","h3d/impl/GlDriver.hx",403,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_ARG(fbo,"fbo")
		HX_STACK_LINE(406)
		{
			HX_STACK_LINE(406)
			::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
			HX_STACK_LINE(406)
			int pos_lineNumber = (int)406;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
			HX_STACK_LINE(406)
			::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
			HX_STACK_LINE(406)
			::String pos_methodName = HX_CSTRING("checkFBO");		HX_STACK_VAR(pos_methodName,"pos_methodName");
			HX_STACK_LINE(406)
			if (((::hxd::System_obj::debugLevel >= (int)3))){
				HX_STACK_LINE(406)
				::String _g = HX_CSTRING("checking fbo");		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(406)
				::String _g1 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g);		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(406)
				::haxe::Log_obj::trace(_g1,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
			}
			HX_STACK_LINE(406)
			HX_CSTRING("checking fbo");
		}
		HX_STACK_LINE(407)
		int st = ::openfl::gl::GL_obj::lime_gl_check_framebuffer_status((int)36160);		HX_STACK_VAR(st,"st");
		HX_STACK_LINE(408)
		if (((st == (int)36053))){
			HX_STACK_LINE(409)
			{
				HX_STACK_LINE(409)
				::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
				HX_STACK_LINE(409)
				int pos_lineNumber = (int)409;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
				HX_STACK_LINE(409)
				::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
				HX_STACK_LINE(409)
				::String pos_methodName = HX_CSTRING("checkFBO");		HX_STACK_VAR(pos_methodName,"pos_methodName");
				HX_STACK_LINE(409)
				if (((::hxd::System_obj::debugLevel >= (int)3))){
					HX_STACK_LINE(409)
					::String _g2 = HX_CSTRING("fbo is complete");		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(409)
					::String _g3 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g2);		HX_STACK_VAR(_g3,"_g3");
					HX_STACK_LINE(409)
					::haxe::Log_obj::trace(_g3,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
				}
				HX_STACK_LINE(409)
				HX_CSTRING("fbo is complete");
			}
			HX_STACK_LINE(410)
			return null();
		}
		HX_STACK_LINE(413)
		::String msg;		HX_STACK_VAR(msg,"msg");
		HX_STACK_LINE(413)
		switch( (int)(st)){
			case (int)36054: {
				HX_STACK_LINE(415)
				msg = HX_CSTRING("FRAMEBUFFER_INCOMPLETE_ATTACHMENT\xe2""\x80""\x8b""");
			}
			;break;
			case (int)36055: {
				HX_STACK_LINE(416)
				msg = HX_CSTRING("FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT");
			}
			;break;
			case (int)36057: {
				HX_STACK_LINE(417)
				msg = HX_CSTRING("FRAMEBUFFER_INCOMPLETE_DIMENSIONS");
			}
			;break;
			case (int)36061: {
				HX_STACK_LINE(419)
				msg = HX_CSTRING("FRAMEBUFFER_UNSUPPORTED");
			}
			;break;
			default: {
				HX_STACK_LINE(414)
				msg = HX_CSTRING("UNKNOWN ERROR");
			}
		}
		HX_STACK_LINE(422)
		{
			HX_STACK_LINE(422)
			Dynamic msg1 = (HX_CSTRING("whoops ") + msg);		HX_STACK_VAR(msg1,"msg1");
			HX_STACK_LINE(422)
			::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
			HX_STACK_LINE(422)
			int pos_lineNumber = (int)422;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
			HX_STACK_LINE(422)
			::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
			HX_STACK_LINE(422)
			::String pos_methodName = HX_CSTRING("checkFBO");		HX_STACK_VAR(pos_methodName,"pos_methodName");
			HX_STACK_LINE(422)
			if (((::hxd::System_obj::debugLevel >= (int)3))){
				HX_STACK_LINE(422)
				::String _g4 = ::Std_obj::string(msg1);		HX_STACK_VAR(_g4,"_g4");
				HX_STACK_LINE(422)
				::String _g5 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g4);		HX_STACK_VAR(_g5,"_g5");
				HX_STACK_LINE(422)
				::haxe::Log_obj::trace(_g5,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
			}
			HX_STACK_LINE(422)
			msg1;
		}
		HX_STACK_LINE(423)
		HX_STACK_DO_THROW(msg);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(GlDriver_obj,checkFBO,(void))

Void GlDriver_obj::setRenderTarget( ::h3d::mat::Texture tex,bool useDepth,int clearColor){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","setRenderTarget",0x1c447541,"h3d.impl.GlDriver.setRenderTarget","h3d/impl/GlDriver.hx",429,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_ARG(tex,"tex")
		HX_STACK_ARG(useDepth,"useDepth")
		HX_STACK_ARG(clearColor,"clearColor")
		HX_STACK_LINE(429)
		if (((tex == null()))){
			HX_STACK_LINE(430)
			::h3d::impl::FBO prev = this->fboStack->pop();		HX_STACK_VAR(prev,"prev");
			HX_STACK_LINE(432)
			if (((bool((prev == null())) || bool((this->fboStack->length == (int)0))))){
				HX_STACK_LINE(433)
				::openfl::gl::GL_obj::lime_gl_bind_renderbuffer((int)36161,null());
				HX_STACK_LINE(434)
				::openfl::gl::GL_obj::lime_gl_bind_framebuffer((int)36160,null());
				HX_STACK_LINE(435)
				::openfl::gl::GL_obj::lime_gl_viewport((int)0,(int)0,this->vpWidth,this->vpHeight);
			}
			else{
				HX_STACK_LINE(438)
				::h3d::impl::FBO curFbo = this->fboStack->last();		HX_STACK_VAR(curFbo,"curFbo");
				HX_STACK_LINE(440)
				{
					HX_STACK_LINE(440)
					::openfl::gl::GLFramebuffer framebuffer = curFbo->fbo;		HX_STACK_VAR(framebuffer,"framebuffer");
					HX_STACK_LINE(440)
					::openfl::gl::GL_obj::lime_gl_bind_framebuffer((int)36160,(  (((framebuffer == null()))) ? Dynamic(null()) : Dynamic(framebuffer->id) ));
				}
				HX_STACK_LINE(441)
				if (((curFbo != null()))){
					HX_STACK_LINE(441)
					::openfl::gl::GLRenderbuffer renderbuffer = curFbo->rbo;		HX_STACK_VAR(renderbuffer,"renderbuffer");
					HX_STACK_LINE(441)
					::openfl::gl::GL_obj::lime_gl_bind_renderbuffer((int)36161,(  (((renderbuffer == null()))) ? Dynamic(null()) : Dynamic(renderbuffer->id) ));
				}
			}
		}
		else{
			HX_STACK_LINE(445)
			::h3d::impl::FBO fbo = null();		HX_STACK_VAR(fbo,"fbo");
			HX_STACK_LINE(448)
			for(::cpp::FastIterator_obj< ::h3d::impl::FBO > *__it = ::cpp::CreateFastIterator< ::h3d::impl::FBO >(this->fboList->iterator());  __it->hasNext(); ){
				::h3d::impl::FBO f = __it->next();
				if ((f->color->isDisposed())){
					HX_STACK_LINE(450)
					f->color = null();
					HX_STACK_LINE(451)
					{
						HX_STACK_LINE(451)
						::openfl::gl::GLFramebuffer framebuffer = f->fbo;		HX_STACK_VAR(framebuffer,"framebuffer");
						HX_STACK_LINE(451)
						::openfl::gl::GL_obj::lime_gl_delete_framebuffer(framebuffer->id);
						HX_STACK_LINE(451)
						framebuffer->invalidate();
					}
					HX_STACK_LINE(452)
					if (((f->rbo != null()))){
						HX_STACK_LINE(452)
						::h3d::impl::GlDriver_obj::gl->__Field(HX_CSTRING("deleteRenderbuffer"),true)(f->rbo);
					}
					HX_STACK_LINE(453)
					this->fboList->remove(f);
				}
;
			}
			HX_STACK_LINE(457)
			for(::cpp::FastIterator_obj< ::h3d::impl::FBO > *__it = ::cpp::CreateFastIterator< ::h3d::impl::FBO >(this->fboList->iterator());  __it->hasNext(); ){
				::h3d::impl::FBO f = __it->next();
				if (((f->color == tex))){
					HX_STACK_LINE(459)
					fbo = f;
					HX_STACK_LINE(460)
					{
						HX_STACK_LINE(460)
						Dynamic msg = (((HX_CSTRING("reusing render target of ") + tex->width) + HX_CSTRING(" ")) + tex->height);		HX_STACK_VAR(msg,"msg");
						HX_STACK_LINE(460)
						::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
						HX_STACK_LINE(460)
						int pos_lineNumber = (int)460;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
						HX_STACK_LINE(460)
						::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
						HX_STACK_LINE(460)
						::String pos_methodName = HX_CSTRING("setRenderTarget");		HX_STACK_VAR(pos_methodName,"pos_methodName");
						HX_STACK_LINE(460)
						if (((::hxd::System_obj::debugLevel >= (int)2))){
							HX_STACK_LINE(460)
							::String _g = ::Std_obj::string(msg);		HX_STACK_VAR(_g,"_g");
							HX_STACK_LINE(460)
							::String _g1 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g);		HX_STACK_VAR(_g1,"_g1");
							HX_STACK_LINE(460)
							::haxe::Log_obj::trace(_g1,hx::SourceInfo(HX_CSTRING("System.hx"),315,HX_CSTRING("hxd.System"),HX_CSTRING("trace2")));
						}
						HX_STACK_LINE(460)
						msg;
					}
					HX_STACK_LINE(461)
					break;
				}
;
			}
			HX_STACK_LINE(465)
			if (((fbo == null()))){
				HX_STACK_LINE(466)
				{
					HX_STACK_LINE(466)
					::String _g2 = ::Std_obj::string(tex->t);		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(466)
					Dynamic msg = (HX_CSTRING("creating new fbo for ") + _g2);		HX_STACK_VAR(msg,"msg");
					HX_STACK_LINE(466)
					::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
					HX_STACK_LINE(466)
					int pos_lineNumber = (int)466;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
					HX_STACK_LINE(466)
					::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
					HX_STACK_LINE(466)
					::String pos_methodName = HX_CSTRING("setRenderTarget");		HX_STACK_VAR(pos_methodName,"pos_methodName");
					HX_STACK_LINE(466)
					if (((::hxd::System_obj::debugLevel >= (int)2))){
						HX_STACK_LINE(466)
						::String _g3 = ::Std_obj::string(msg);		HX_STACK_VAR(_g3,"_g3");
						HX_STACK_LINE(466)
						::String _g4 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g3);		HX_STACK_VAR(_g4,"_g4");
						HX_STACK_LINE(466)
						::haxe::Log_obj::trace(_g4,hx::SourceInfo(HX_CSTRING("System.hx"),315,HX_CSTRING("hxd.System"),HX_CSTRING("trace2")));
					}
					HX_STACK_LINE(466)
					msg;
				}
				HX_STACK_LINE(467)
				int i = (int)0;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(468)
				for(::cpp::FastIterator_obj< ::h3d::impl::FBO > *__it = ::cpp::CreateFastIterator< ::h3d::impl::FBO >(this->fboList->iterator());  __it->hasNext(); ){
					::h3d::impl::FBO f = __it->next();
					{
						HX_STACK_LINE(469)
						{
							HX_STACK_LINE(469)
							::String _g5 = ::Std_obj::string(f->color);		HX_STACK_VAR(_g5,"_g5");
							HX_STACK_LINE(469)
							Dynamic msg = (((HX_CSTRING("previous : ") + i) + HX_CSTRING(":")) + _g5);		HX_STACK_VAR(msg,"msg");
							HX_STACK_LINE(469)
							::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
							HX_STACK_LINE(469)
							int pos_lineNumber = (int)469;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
							HX_STACK_LINE(469)
							::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
							HX_STACK_LINE(469)
							::String pos_methodName = HX_CSTRING("setRenderTarget");		HX_STACK_VAR(pos_methodName,"pos_methodName");
							HX_STACK_LINE(469)
							if (((::hxd::System_obj::debugLevel >= (int)2))){
								HX_STACK_LINE(469)
								::String _g6 = ::Std_obj::string(msg);		HX_STACK_VAR(_g6,"_g6");
								HX_STACK_LINE(469)
								::String _g7 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g6);		HX_STACK_VAR(_g7,"_g7");
								HX_STACK_LINE(469)
								::haxe::Log_obj::trace(_g7,hx::SourceInfo(HX_CSTRING("System.hx"),315,HX_CSTRING("hxd.System"),HX_CSTRING("trace2")));
							}
							HX_STACK_LINE(469)
							msg;
						}
						HX_STACK_LINE(470)
						(i)++;
					}
;
				}
				HX_STACK_LINE(473)
				{
					HX_STACK_LINE(473)
					::String _g8 = ::Std_obj::string(tex->t);		HX_STACK_VAR(_g8,"_g8");
					HX_STACK_LINE(473)
					Dynamic msg = (HX_CSTRING("newing fbo for ") + _g8);		HX_STACK_VAR(msg,"msg");
					HX_STACK_LINE(473)
					::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
					HX_STACK_LINE(473)
					int pos_lineNumber = (int)473;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
					HX_STACK_LINE(473)
					::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
					HX_STACK_LINE(473)
					::String pos_methodName = HX_CSTRING("setRenderTarget");		HX_STACK_VAR(pos_methodName,"pos_methodName");
					HX_STACK_LINE(473)
					if (((::hxd::System_obj::debugLevel >= (int)3))){
						HX_STACK_LINE(473)
						::String _g9 = ::Std_obj::string(msg);		HX_STACK_VAR(_g9,"_g9");
						HX_STACK_LINE(473)
						::String _g10 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g9);		HX_STACK_VAR(_g10,"_g10");
						HX_STACK_LINE(473)
						::haxe::Log_obj::trace(_g10,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
					}
					HX_STACK_LINE(473)
					msg;
				}
				HX_STACK_LINE(474)
				::h3d::impl::FBO _g11 = ::h3d::impl::FBO_obj::__new();		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(474)
				fbo = _g11;
				HX_STACK_LINE(475)
				this->fboList->push(fbo);
			}
			HX_STACK_LINE(478)
			{
				HX_STACK_LINE(478)
				::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
				HX_STACK_LINE(478)
				int pos_lineNumber = (int)478;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
				HX_STACK_LINE(478)
				::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
				HX_STACK_LINE(478)
				::String pos_methodName = HX_CSTRING("setRenderTarget");		HX_STACK_VAR(pos_methodName,"pos_methodName");
				HX_STACK_LINE(478)
				if (((::hxd::System_obj::debugLevel >= (int)3))){
					HX_STACK_LINE(478)
					::String _g12 = HX_CSTRING("creating fbo");		HX_STACK_VAR(_g12,"_g12");
					HX_STACK_LINE(478)
					::String _g13 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g12);		HX_STACK_VAR(_g13,"_g13");
					HX_STACK_LINE(478)
					::haxe::Log_obj::trace(_g13,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
				}
				HX_STACK_LINE(478)
				HX_CSTRING("creating fbo");
			}
			HX_STACK_LINE(479)
			if (((fbo->fbo == null()))){
				HX_STACK_LINE(479)
				int _g14 = ::openfl::gl::GL_obj::get_version();		HX_STACK_VAR(_g14,"_g14");
				HX_STACK_LINE(479)
				Dynamic _g15 = ::openfl::gl::GL_obj::lime_gl_create_framebuffer();		HX_STACK_VAR(_g15,"_g15");
				HX_STACK_LINE(479)
				::openfl::gl::GLFramebuffer _g16 = ::openfl::gl::GLFramebuffer_obj::__new(_g14,_g15);		HX_STACK_VAR(_g16,"_g16");
				HX_STACK_LINE(479)
				fbo->fbo = _g16;
			}
			HX_STACK_LINE(480)
			{
				HX_STACK_LINE(480)
				::openfl::gl::GLFramebuffer framebuffer = fbo->fbo;		HX_STACK_VAR(framebuffer,"framebuffer");
				HX_STACK_LINE(480)
				::openfl::gl::GL_obj::lime_gl_bind_framebuffer((int)36160,(  (((framebuffer == null()))) ? Dynamic(null()) : Dynamic(framebuffer->id) ));
			}
			HX_STACK_LINE(481)
			{
				HX_STACK_LINE(481)
				int _g17 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g17,"_g17");
				HX_STACK_LINE(481)
				if (((_g17 != (int)0))){
					HX_STACK_LINE(481)
					::String s;		HX_STACK_VAR(s,"s");
					HX_STACK_LINE(481)
					{
						HX_STACK_LINE(481)
						int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
						HX_STACK_LINE(481)
						switch( (int)(_g)){
							case (int)0: {
								HX_STACK_LINE(481)
								s = null();
							}
							;break;
							case (int)1280: {
								HX_STACK_LINE(481)
								s = HX_CSTRING("INVALID_ENUM");
							}
							;break;
							case (int)1281: {
								HX_STACK_LINE(481)
								s = HX_CSTRING("INVALID_VALUE");
							}
							;break;
							case (int)1282: {
								HX_STACK_LINE(481)
								s = HX_CSTRING("INVALID_OPERATION");
							}
							;break;
							case (int)1285: {
								HX_STACK_LINE(481)
								s = HX_CSTRING("OUT_OF_MEMORY");
							}
							;break;
							default: {
								HX_STACK_LINE(481)
								s = null();
							}
						}
					}
					HX_STACK_LINE(481)
					if (((s != null()))){
						HX_STACK_LINE(481)
						::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
						HX_STACK_LINE(481)
						::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
						HX_STACK_LINE(481)
						HX_STACK_DO_THROW(s);
					}
				}
			}
			HX_STACK_LINE(483)
			int bw;		HX_STACK_VAR(bw,"bw");
			HX_STACK_LINE(483)
			{
				HX_STACK_LINE(483)
				int v = tex->width;		HX_STACK_VAR(v,"v");
				HX_STACK_LINE(483)
				v = (v - ((int((int(v) >> int((int)1))) & int((int)1431655765))));
				HX_STACK_LINE(483)
				v = (((int(v) & int((int)858993459))) + ((int((int(v) >> int((int)2))) & int((int)858993459))));
				HX_STACK_LINE(483)
				bw = (int((((int((v + ((int(v) >> int((int)4))))) & int((int)252645135))) * (int)16843009)) >> int((int)24));
			}
			HX_STACK_LINE(484)
			int bh;		HX_STACK_VAR(bh,"bh");
			HX_STACK_LINE(484)
			{
				HX_STACK_LINE(484)
				int v = tex->height;		HX_STACK_VAR(v,"v");
				HX_STACK_LINE(484)
				v = (v - ((int((int(v) >> int((int)1))) & int((int)1431655765))));
				HX_STACK_LINE(484)
				v = (((int(v) & int((int)858993459))) + ((int((int(v) >> int((int)2))) & int((int)858993459))));
				HX_STACK_LINE(484)
				bh = (int((((int((v + ((int(v) >> int((int)4))))) & int((int)252645135))) * (int)16843009)) >> int((int)24));
			}
			HX_STACK_LINE(486)
			{
				HX_STACK_LINE(486)
				Dynamic msg = (((HX_CSTRING("allocating render target of ") + tex->width) + HX_CSTRING(" ")) + tex->height);		HX_STACK_VAR(msg,"msg");
				HX_STACK_LINE(486)
				::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
				HX_STACK_LINE(486)
				int pos_lineNumber = (int)486;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
				HX_STACK_LINE(486)
				::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
				HX_STACK_LINE(486)
				::String pos_methodName = HX_CSTRING("setRenderTarget");		HX_STACK_VAR(pos_methodName,"pos_methodName");
				HX_STACK_LINE(486)
				if (((::hxd::System_obj::debugLevel >= (int)3))){
					HX_STACK_LINE(486)
					::String _g18 = ::Std_obj::string(msg);		HX_STACK_VAR(_g18,"_g18");
					HX_STACK_LINE(486)
					::String _g19 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g18);		HX_STACK_VAR(_g19,"_g19");
					HX_STACK_LINE(486)
					::haxe::Log_obj::trace(_g19,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
				}
				HX_STACK_LINE(486)
				msg;
			}
			HX_STACK_LINE(488)
			if (((bool((bh > (int)1)) || bool((bw > (int)1))))){
				HX_STACK_LINE(488)
				HX_STACK_DO_THROW(HX_CSTRING("invalid texture size, must be a power of two texture"));
			}
			HX_STACK_LINE(490)
			fbo->width = tex->width;
			HX_STACK_LINE(491)
			fbo->height = tex->height;
			HX_STACK_LINE(492)
			fbo->color = tex;
			HX_STACK_LINE(494)
			::openfl::gl::GL_obj::lime_gl_framebuffer_texture2D((int)36160,(int)36064,(int)3553,fbo->color->t->id,(int)0);
			HX_STACK_LINE(495)
			{
				HX_STACK_LINE(495)
				int _g20 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g20,"_g20");
				HX_STACK_LINE(495)
				if (((_g20 != (int)0))){
					HX_STACK_LINE(495)
					::String s;		HX_STACK_VAR(s,"s");
					HX_STACK_LINE(495)
					{
						HX_STACK_LINE(495)
						int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
						HX_STACK_LINE(495)
						switch( (int)(_g)){
							case (int)0: {
								HX_STACK_LINE(495)
								s = null();
							}
							;break;
							case (int)1280: {
								HX_STACK_LINE(495)
								s = HX_CSTRING("INVALID_ENUM");
							}
							;break;
							case (int)1281: {
								HX_STACK_LINE(495)
								s = HX_CSTRING("INVALID_VALUE");
							}
							;break;
							case (int)1282: {
								HX_STACK_LINE(495)
								s = HX_CSTRING("INVALID_OPERATION");
							}
							;break;
							case (int)1285: {
								HX_STACK_LINE(495)
								s = HX_CSTRING("OUT_OF_MEMORY");
							}
							;break;
							default: {
								HX_STACK_LINE(495)
								s = null();
							}
						}
					}
					HX_STACK_LINE(495)
					if (((s != null()))){
						HX_STACK_LINE(495)
						::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
						HX_STACK_LINE(495)
						::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
						HX_STACK_LINE(495)
						HX_STACK_DO_THROW(s);
					}
				}
			}
			HX_STACK_LINE(497)
			if ((useDepth)){
				HX_STACK_LINE(498)
				{
					HX_STACK_LINE(498)
					::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
					HX_STACK_LINE(498)
					int pos_lineNumber = (int)498;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
					HX_STACK_LINE(498)
					::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
					HX_STACK_LINE(498)
					::String pos_methodName = HX_CSTRING("setRenderTarget");		HX_STACK_VAR(pos_methodName,"pos_methodName");
					HX_STACK_LINE(498)
					if (((::hxd::System_obj::debugLevel >= (int)3))){
						HX_STACK_LINE(498)
						::String _g21 = HX_CSTRING("fbo : using depth");		HX_STACK_VAR(_g21,"_g21");
						HX_STACK_LINE(498)
						::String _g22 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g21);		HX_STACK_VAR(_g22,"_g22");
						HX_STACK_LINE(498)
						::haxe::Log_obj::trace(_g22,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
					}
					HX_STACK_LINE(498)
					HX_CSTRING("fbo : using depth");
				}
				HX_STACK_LINE(499)
				{
					HX_STACK_LINE(499)
					int _g23 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g23,"_g23");
					HX_STACK_LINE(499)
					if (((_g23 != (int)0))){
						HX_STACK_LINE(499)
						::String s;		HX_STACK_VAR(s,"s");
						HX_STACK_LINE(499)
						{
							HX_STACK_LINE(499)
							int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
							HX_STACK_LINE(499)
							switch( (int)(_g)){
								case (int)0: {
									HX_STACK_LINE(499)
									s = null();
								}
								;break;
								case (int)1280: {
									HX_STACK_LINE(499)
									s = HX_CSTRING("INVALID_ENUM");
								}
								;break;
								case (int)1281: {
									HX_STACK_LINE(499)
									s = HX_CSTRING("INVALID_VALUE");
								}
								;break;
								case (int)1282: {
									HX_STACK_LINE(499)
									s = HX_CSTRING("INVALID_OPERATION");
								}
								;break;
								case (int)1285: {
									HX_STACK_LINE(499)
									s = HX_CSTRING("OUT_OF_MEMORY");
								}
								;break;
								default: {
									HX_STACK_LINE(499)
									s = null();
								}
							}
						}
						HX_STACK_LINE(499)
						if (((s != null()))){
							HX_STACK_LINE(499)
							::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
							HX_STACK_LINE(499)
							::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
							HX_STACK_LINE(499)
							HX_STACK_DO_THROW(s);
						}
					}
				}
				HX_STACK_LINE(500)
				if (((fbo->rbo == null()))){
					HX_STACK_LINE(501)
					int _g24 = ::openfl::gl::GL_obj::get_version();		HX_STACK_VAR(_g24,"_g24");
					HX_STACK_LINE(501)
					Dynamic _g25 = ::openfl::gl::GL_obj::lime_gl_create_render_buffer();		HX_STACK_VAR(_g25,"_g25");
					HX_STACK_LINE(501)
					::openfl::gl::GLRenderbuffer _g26 = ::openfl::gl::GLRenderbuffer_obj::__new(_g24,_g25);		HX_STACK_VAR(_g26,"_g26");
					HX_STACK_LINE(501)
					fbo->rbo = _g26;
				}
				HX_STACK_LINE(504)
				{
					HX_STACK_LINE(504)
					::openfl::gl::GLRenderbuffer renderbuffer = fbo->rbo;		HX_STACK_VAR(renderbuffer,"renderbuffer");
					HX_STACK_LINE(504)
					::openfl::gl::GL_obj::lime_gl_bind_renderbuffer((int)36161,(  (((renderbuffer == null()))) ? Dynamic(null()) : Dynamic(renderbuffer->id) ));
				}
				HX_STACK_LINE(505)
				::openfl::gl::GL_obj::lime_gl_renderbuffer_storage((int)36161,(int)6402,fbo->width,fbo->height);
				HX_STACK_LINE(507)
				{
					HX_STACK_LINE(507)
					::String _g27 = ::Std_obj::string(fbo->rbo);		HX_STACK_VAR(_g27,"_g27");
					HX_STACK_LINE(507)
					Dynamic msg = (HX_CSTRING("fbo : allocated ") + _g27);		HX_STACK_VAR(msg,"msg");
					HX_STACK_LINE(507)
					::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
					HX_STACK_LINE(507)
					int pos_lineNumber = (int)507;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
					HX_STACK_LINE(507)
					::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
					HX_STACK_LINE(507)
					::String pos_methodName = HX_CSTRING("setRenderTarget");		HX_STACK_VAR(pos_methodName,"pos_methodName");
					HX_STACK_LINE(507)
					if (((::hxd::System_obj::debugLevel >= (int)3))){
						HX_STACK_LINE(507)
						::String _g28 = ::Std_obj::string(msg);		HX_STACK_VAR(_g28,"_g28");
						HX_STACK_LINE(507)
						::String _g29 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g28);		HX_STACK_VAR(_g29,"_g29");
						HX_STACK_LINE(507)
						::haxe::Log_obj::trace(_g29,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
					}
					HX_STACK_LINE(507)
					msg;
				}
				HX_STACK_LINE(508)
				{
					HX_STACK_LINE(508)
					int _g30 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g30,"_g30");
					HX_STACK_LINE(508)
					if (((_g30 != (int)0))){
						HX_STACK_LINE(508)
						::String s;		HX_STACK_VAR(s,"s");
						HX_STACK_LINE(508)
						{
							HX_STACK_LINE(508)
							int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
							HX_STACK_LINE(508)
							switch( (int)(_g)){
								case (int)0: {
									HX_STACK_LINE(508)
									s = null();
								}
								;break;
								case (int)1280: {
									HX_STACK_LINE(508)
									s = HX_CSTRING("INVALID_ENUM");
								}
								;break;
								case (int)1281: {
									HX_STACK_LINE(508)
									s = HX_CSTRING("INVALID_VALUE");
								}
								;break;
								case (int)1282: {
									HX_STACK_LINE(508)
									s = HX_CSTRING("INVALID_OPERATION");
								}
								;break;
								case (int)1285: {
									HX_STACK_LINE(508)
									s = HX_CSTRING("OUT_OF_MEMORY");
								}
								;break;
								default: {
									HX_STACK_LINE(508)
									s = null();
								}
							}
						}
						HX_STACK_LINE(508)
						if (((s != null()))){
							HX_STACK_LINE(508)
							::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
							HX_STACK_LINE(508)
							::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
							HX_STACK_LINE(508)
							HX_STACK_DO_THROW(s);
						}
					}
				}
				HX_STACK_LINE(510)
				{
					HX_STACK_LINE(510)
					::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
					HX_STACK_LINE(510)
					int pos_lineNumber = (int)510;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
					HX_STACK_LINE(510)
					::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
					HX_STACK_LINE(510)
					::String pos_methodName = HX_CSTRING("setRenderTarget");		HX_STACK_VAR(pos_methodName,"pos_methodName");
					HX_STACK_LINE(510)
					if (((::hxd::System_obj::debugLevel >= (int)3))){
						HX_STACK_LINE(510)
						::String _g31 = HX_CSTRING("fbo : bound rbo");		HX_STACK_VAR(_g31,"_g31");
						HX_STACK_LINE(510)
						::String _g32 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g31);		HX_STACK_VAR(_g32,"_g32");
						HX_STACK_LINE(510)
						::haxe::Log_obj::trace(_g32,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
					}
					HX_STACK_LINE(510)
					HX_CSTRING("fbo : bound rbo");
				}
				HX_STACK_LINE(511)
				{
					HX_STACK_LINE(511)
					int _g33 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g33,"_g33");
					HX_STACK_LINE(511)
					if (((_g33 != (int)0))){
						HX_STACK_LINE(511)
						::String s;		HX_STACK_VAR(s,"s");
						HX_STACK_LINE(511)
						{
							HX_STACK_LINE(511)
							int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
							HX_STACK_LINE(511)
							switch( (int)(_g)){
								case (int)0: {
									HX_STACK_LINE(511)
									s = null();
								}
								;break;
								case (int)1280: {
									HX_STACK_LINE(511)
									s = HX_CSTRING("INVALID_ENUM");
								}
								;break;
								case (int)1281: {
									HX_STACK_LINE(511)
									s = HX_CSTRING("INVALID_VALUE");
								}
								;break;
								case (int)1282: {
									HX_STACK_LINE(511)
									s = HX_CSTRING("INVALID_OPERATION");
								}
								;break;
								case (int)1285: {
									HX_STACK_LINE(511)
									s = HX_CSTRING("OUT_OF_MEMORY");
								}
								;break;
								default: {
									HX_STACK_LINE(511)
									s = null();
								}
							}
						}
						HX_STACK_LINE(511)
						if (((s != null()))){
							HX_STACK_LINE(511)
							::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
							HX_STACK_LINE(511)
							::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
							HX_STACK_LINE(511)
							HX_STACK_DO_THROW(s);
						}
					}
				}
				HX_STACK_LINE(513)
				::openfl::gl::GL_obj::lime_gl_framebuffer_renderbuffer((int)36160,(int)36096,(int)36161,fbo->rbo->id);
				HX_STACK_LINE(516)
				{
					HX_STACK_LINE(516)
					::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
					HX_STACK_LINE(516)
					int pos_lineNumber = (int)516;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
					HX_STACK_LINE(516)
					::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
					HX_STACK_LINE(516)
					::String pos_methodName = HX_CSTRING("setRenderTarget");		HX_STACK_VAR(pos_methodName,"pos_methodName");
					HX_STACK_LINE(516)
					if (((::hxd::System_obj::debugLevel >= (int)3))){
						HX_STACK_LINE(516)
						::String _g34 = HX_CSTRING("fbo : framebufferRenderbuffer");		HX_STACK_VAR(_g34,"_g34");
						HX_STACK_LINE(516)
						::String _g35 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g34);		HX_STACK_VAR(_g35,"_g35");
						HX_STACK_LINE(516)
						::haxe::Log_obj::trace(_g35,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
					}
					HX_STACK_LINE(516)
					HX_CSTRING("fbo : framebufferRenderbuffer");
				}
				HX_STACK_LINE(517)
				{
					HX_STACK_LINE(517)
					int _g36 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g36,"_g36");
					HX_STACK_LINE(517)
					if (((_g36 != (int)0))){
						HX_STACK_LINE(517)
						::String s;		HX_STACK_VAR(s,"s");
						HX_STACK_LINE(517)
						{
							HX_STACK_LINE(517)
							int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
							HX_STACK_LINE(517)
							switch( (int)(_g)){
								case (int)0: {
									HX_STACK_LINE(517)
									s = null();
								}
								;break;
								case (int)1280: {
									HX_STACK_LINE(517)
									s = HX_CSTRING("INVALID_ENUM");
								}
								;break;
								case (int)1281: {
									HX_STACK_LINE(517)
									s = HX_CSTRING("INVALID_VALUE");
								}
								;break;
								case (int)1282: {
									HX_STACK_LINE(517)
									s = HX_CSTRING("INVALID_OPERATION");
								}
								;break;
								case (int)1285: {
									HX_STACK_LINE(517)
									s = HX_CSTRING("OUT_OF_MEMORY");
								}
								;break;
								default: {
									HX_STACK_LINE(517)
									s = null();
								}
							}
						}
						HX_STACK_LINE(517)
						if (((s != null()))){
							HX_STACK_LINE(517)
							::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
							HX_STACK_LINE(517)
							::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
							HX_STACK_LINE(517)
							HX_STACK_DO_THROW(s);
						}
					}
				}
			}
			HX_STACK_LINE(519)
			{
				HX_STACK_LINE(519)
				int _g37 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g37,"_g37");
				HX_STACK_LINE(519)
				if (((_g37 != (int)0))){
					HX_STACK_LINE(519)
					::String s;		HX_STACK_VAR(s,"s");
					HX_STACK_LINE(519)
					{
						HX_STACK_LINE(519)
						int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
						HX_STACK_LINE(519)
						switch( (int)(_g)){
							case (int)0: {
								HX_STACK_LINE(519)
								s = null();
							}
							;break;
							case (int)1280: {
								HX_STACK_LINE(519)
								s = HX_CSTRING("INVALID_ENUM");
							}
							;break;
							case (int)1281: {
								HX_STACK_LINE(519)
								s = HX_CSTRING("INVALID_VALUE");
							}
							;break;
							case (int)1282: {
								HX_STACK_LINE(519)
								s = HX_CSTRING("INVALID_OPERATION");
							}
							;break;
							case (int)1285: {
								HX_STACK_LINE(519)
								s = HX_CSTRING("OUT_OF_MEMORY");
							}
							;break;
							default: {
								HX_STACK_LINE(519)
								s = null();
							}
						}
					}
					HX_STACK_LINE(519)
					if (((s != null()))){
						HX_STACK_LINE(519)
						::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
						HX_STACK_LINE(519)
						::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
						HX_STACK_LINE(519)
						HX_STACK_DO_THROW(s);
					}
				}
			}
			HX_STACK_LINE(520)
			this->checkFBO(fbo);
			HX_STACK_LINE(522)
			this->begin();
			HX_STACK_LINE(523)
			this->reset();
			HX_STACK_LINE(527)
			this->clear((((int((int(clearColor) >> int((int)16))) & int((int)255))) * 0.0039215686274509803921568627451),(((int((int(clearColor) >> int((int)8))) & int((int)255))) * 0.0039215686274509803921568627451),(((int(clearColor) & int((int)255))) * 0.0039215686274509803921568627451),(((int((int(clearColor) >> int((int)24))) & int((int)255))) * 0.0039215686274509803921568627451));
			HX_STACK_LINE(532)
			::openfl::gl::GL_obj::lime_gl_viewport((int)0,(int)0,tex->width,tex->height);
			HX_STACK_LINE(534)
			{
				HX_STACK_LINE(534)
				int _g38 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g38,"_g38");
				HX_STACK_LINE(534)
				if (((_g38 != (int)0))){
					HX_STACK_LINE(534)
					::String s;		HX_STACK_VAR(s,"s");
					HX_STACK_LINE(534)
					{
						HX_STACK_LINE(534)
						int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
						HX_STACK_LINE(534)
						switch( (int)(_g)){
							case (int)0: {
								HX_STACK_LINE(534)
								s = null();
							}
							;break;
							case (int)1280: {
								HX_STACK_LINE(534)
								s = HX_CSTRING("INVALID_ENUM");
							}
							;break;
							case (int)1281: {
								HX_STACK_LINE(534)
								s = HX_CSTRING("INVALID_VALUE");
							}
							;break;
							case (int)1282: {
								HX_STACK_LINE(534)
								s = HX_CSTRING("INVALID_OPERATION");
							}
							;break;
							case (int)1285: {
								HX_STACK_LINE(534)
								s = HX_CSTRING("OUT_OF_MEMORY");
							}
							;break;
							default: {
								HX_STACK_LINE(534)
								s = null();
							}
						}
					}
					HX_STACK_LINE(534)
					if (((s != null()))){
						HX_STACK_LINE(534)
						::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
						HX_STACK_LINE(534)
						::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
						HX_STACK_LINE(534)
						HX_STACK_DO_THROW(s);
					}
				}
			}
			HX_STACK_LINE(536)
			Dynamic _g39 = ::openfl::gl::GL_obj::lime_gl_get_parameter((int)3386);		HX_STACK_VAR(_g39,"_g39");
			HX_STACK_LINE(536)
			if (((tex->width > _g39))){
				HX_STACK_LINE(537)
				HX_STACK_DO_THROW(HX_CSTRING("invalid texture size, must be within gpu range"));
			}
			HX_STACK_LINE(538)
			Dynamic _g40 = ::openfl::gl::GL_obj::lime_gl_get_parameter((int)3386);		HX_STACK_VAR(_g40,"_g40");
			HX_STACK_LINE(538)
			if (((tex->height > _g40))){
				HX_STACK_LINE(539)
				HX_STACK_DO_THROW(HX_CSTRING("invalid texture size, must be within gpu range"));
			}
			HX_STACK_LINE(541)
			if (((this->fboList->length > (int)256))){
				HX_STACK_LINE(542)
				HX_STACK_DO_THROW(HX_CSTRING("it is unsafe to have more than 256 active fbo"));
			}
			HX_STACK_LINE(544)
			if (((this->fboStack->length > (int)8))){
				HX_STACK_LINE(545)
				HX_STACK_DO_THROW(HX_CSTRING("it is unsafe to have more than 8 fbo depth"));
			}
			HX_STACK_LINE(548)
			this->fboStack->push(fbo);
		}
	}
return null();
}


Void GlDriver_obj::disposeTexture( ::openfl::gl::GLTexture t){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","disposeTexture",0x91adf5c4,"h3d.impl.GlDriver.disposeTexture","h3d/impl/GlDriver.hx",553,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_ARG(t,"t")
		HX_STACK_LINE(553)
		::openfl::gl::GL_obj::lime_gl_delete_texture(t->id);
		HX_STACK_LINE(553)
		t->invalidate();
	}
return null();
}


Void GlDriver_obj::disposeIndexes( ::openfl::gl::GLBuffer i){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","disposeIndexes",0xd38c88e9,"h3d.impl.GlDriver.disposeIndexes","h3d/impl/GlDriver.hx",557,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_ARG(i,"i")
		HX_STACK_LINE(557)
		::openfl::gl::GL_obj::lime_gl_delete_buffer(i->id);
		HX_STACK_LINE(557)
		i->invalidate();
	}
return null();
}


Void GlDriver_obj::disposeVertex( ::h3d::impl::GLVB v){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","disposeVertex",0xfbe97e9b,"h3d.impl.GlDriver.disposeVertex","h3d/impl/GlDriver.hx",561,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(561)
		::openfl::gl::GLBuffer buffer = v->b;		HX_STACK_VAR(buffer,"buffer");
		HX_STACK_LINE(561)
		::openfl::gl::GL_obj::lime_gl_delete_buffer(buffer->id);
		HX_STACK_LINE(561)
		buffer->invalidate();
	}
return null();
}


Void GlDriver_obj::makeMips( ){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","makeMips",0x91656335,"h3d.impl.GlDriver.makeMips","h3d/impl/GlDriver.hx",565,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_LINE(566)
		::openfl::gl::GL_obj::lime_gl_hint((int)33170,(int)4352);
		HX_STACK_LINE(567)
		::openfl::gl::GL_obj::lime_gl_generate_mipmap((int)3553);
		HX_STACK_LINE(568)
		{
			HX_STACK_LINE(568)
			int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(568)
			if (((_g != (int)0))){
				HX_STACK_LINE(568)
				::String s;		HX_STACK_VAR(s,"s");
				HX_STACK_LINE(568)
				{
					HX_STACK_LINE(568)
					int _g1 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(568)
					switch( (int)(_g1)){
						case (int)0: {
							HX_STACK_LINE(568)
							s = null();
						}
						;break;
						case (int)1280: {
							HX_STACK_LINE(568)
							s = HX_CSTRING("INVALID_ENUM");
						}
						;break;
						case (int)1281: {
							HX_STACK_LINE(568)
							s = HX_CSTRING("INVALID_VALUE");
						}
						;break;
						case (int)1282: {
							HX_STACK_LINE(568)
							s = HX_CSTRING("INVALID_OPERATION");
						}
						;break;
						case (int)1285: {
							HX_STACK_LINE(568)
							s = HX_CSTRING("OUT_OF_MEMORY");
						}
						;break;
						default: {
							HX_STACK_LINE(568)
							s = null();
						}
					}
				}
				HX_STACK_LINE(568)
				if (((s != null()))){
					HX_STACK_LINE(568)
					::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
					HX_STACK_LINE(568)
					::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
					HX_STACK_LINE(568)
					HX_STACK_DO_THROW(s);
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(GlDriver_obj,makeMips,(void))

Void GlDriver_obj::uploadTextureBitmap( ::h3d::mat::Texture t,::flash::display::BitmapData bmp,int mipLevel,int side){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","uploadTextureBitmap",0x0eff23a1,"h3d.impl.GlDriver.uploadTextureBitmap","h3d/impl/GlDriver.hx",571,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_ARG(t,"t")
		HX_STACK_ARG(bmp,"bmp")
		HX_STACK_ARG(mipLevel,"mipLevel")
		HX_STACK_ARG(side,"side")
		HX_STACK_LINE(572)
		{
			HX_STACK_LINE(572)
			::openfl::gl::GLTexture texture = t->t;		HX_STACK_VAR(texture,"texture");
			HX_STACK_LINE(572)
			::openfl::gl::GL_obj::lime_gl_bind_texture((int)3553,(  (((texture == null()))) ? Dynamic(null()) : Dynamic(texture->id) ));
		}
		HX_STACK_LINE(573)
		::hxd::Pixels pix = ::hxd::_BitmapData::BitmapData_Impl__obj::nativeGetPixels(bmp);		HX_STACK_VAR(pix,"pix");
		HX_STACK_LINE(574)
		::hxd::PixelFormat oldFormat = pix->format;		HX_STACK_VAR(oldFormat,"oldFormat");
		HX_STACK_LINE(576)
		Float s = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(s,"s");
		HX_STACK_LINE(577)
		{
			HX_STACK_LINE(577)
			::String _g = ::Std_obj::string(oldFormat);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(577)
			::String _g1 = (HX_CSTRING("converting from ") + _g);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(577)
			Dynamic msg = (_g1 + HX_CSTRING(" to RGBA"));		HX_STACK_VAR(msg,"msg");
			HX_STACK_LINE(577)
			::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
			HX_STACK_LINE(577)
			int pos_lineNumber = (int)577;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
			HX_STACK_LINE(577)
			::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
			HX_STACK_LINE(577)
			::String pos_methodName = HX_CSTRING("uploadTextureBitmap");		HX_STACK_VAR(pos_methodName,"pos_methodName");
			HX_STACK_LINE(577)
			if (((::hxd::System_obj::debugLevel >= (int)2))){
				HX_STACK_LINE(577)
				::String _g2 = ::Std_obj::string(msg);		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(577)
				::String _g3 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g2);		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(577)
				::haxe::Log_obj::trace(_g3,hx::SourceInfo(HX_CSTRING("System.hx"),315,HX_CSTRING("hxd.System"),HX_CSTRING("trace2")));
			}
			HX_STACK_LINE(577)
			msg;
		}
		HX_STACK_LINE(578)
		bool rgbaConv = pix->convert(::hxd::PixelFormat_obj::RGBA);		HX_STACK_VAR(rgbaConv,"rgbaConv");
		HX_STACK_LINE(579)
		if ((rgbaConv)){
			HX_STACK_LINE(579)
			::String _g4 = ::Std_obj::string(oldFormat);		HX_STACK_VAR(_g4,"_g4");
			HX_STACK_LINE(579)
			::String _g5 = (HX_CSTRING("WARNING : texture format converted from ") + _g4);		HX_STACK_VAR(_g5,"_g5");
			HX_STACK_LINE(579)
			::String _g6 = (_g5 + HX_CSTRING(" to "));		HX_STACK_VAR(_g6,"_g6");
			HX_STACK_LINE(579)
			::String _g7 = ::Std_obj::string(::hxd::PixelFormat_obj::RGBA);		HX_STACK_VAR(_g7,"_g7");
			HX_STACK_LINE(579)
			Dynamic msg = (_g6 + _g7);		HX_STACK_VAR(msg,"msg");
			HX_STACK_LINE(579)
			::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
			HX_STACK_LINE(579)
			int pos_lineNumber = (int)579;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
			HX_STACK_LINE(579)
			::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
			HX_STACK_LINE(579)
			::String pos_methodName = HX_CSTRING("uploadTextureBitmap");		HX_STACK_VAR(pos_methodName,"pos_methodName");
			HX_STACK_LINE(579)
			if (((::hxd::System_obj::debugLevel >= (int)2))){
				HX_STACK_LINE(579)
				::String _g8 = ::Std_obj::string(msg);		HX_STACK_VAR(_g8,"_g8");
				HX_STACK_LINE(579)
				::String _g9 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g8);		HX_STACK_VAR(_g9,"_g9");
				HX_STACK_LINE(579)
				::haxe::Log_obj::trace(_g9,hx::SourceInfo(HX_CSTRING("System.hx"),315,HX_CSTRING("hxd.System"),HX_CSTRING("trace2")));
			}
			HX_STACK_LINE(579)
			msg;
		}
		HX_STACK_LINE(580)
		Float ss = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(ss,"ss");
		HX_STACK_LINE(581)
		{
			HX_STACK_LINE(581)
			Dynamic msg = (((HX_CSTRING("pixel conversion:") + t->width) + HX_CSTRING(":")) + ((ss - s)));		HX_STACK_VAR(msg,"msg");
			HX_STACK_LINE(581)
			::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
			HX_STACK_LINE(581)
			int pos_lineNumber = (int)581;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
			HX_STACK_LINE(581)
			::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
			HX_STACK_LINE(581)
			::String pos_methodName = HX_CSTRING("uploadTextureBitmap");		HX_STACK_VAR(pos_methodName,"pos_methodName");
			HX_STACK_LINE(581)
			if (((::hxd::System_obj::debugLevel >= (int)3))){
				HX_STACK_LINE(581)
				::String _g10 = ::Std_obj::string(msg);		HX_STACK_VAR(_g10,"_g10");
				HX_STACK_LINE(581)
				::String _g11 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g10);		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(581)
				::haxe::Log_obj::trace(_g11,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
			}
			HX_STACK_LINE(581)
			msg;
		}
		HX_STACK_LINE(582)
		::openfl::utils::UInt8Array pixels;		HX_STACK_VAR(pixels,"pixels");
		HX_STACK_LINE(582)
		{
			HX_STACK_LINE(582)
			int pos = (int)0;		HX_STACK_VAR(pos,"pos");
			HX_STACK_LINE(582)
			::flash::utils::ByteArray _g12 = ::flash::utils::ByteArray_obj::fromBytes(pix->bytes);		HX_STACK_VAR(_g12,"_g12");
			HX_STACK_LINE(582)
			pixels = ::openfl::utils::UInt8Array_obj::__new(_g12,pos,null());
		}
		HX_STACK_LINE(585)
		int sz = ::openfl::gl::GL_obj::lime_gl_get_parameter((int)3379);		HX_STACK_VAR(sz,"sz");
		HX_STACK_LINE(586)
		if (((false == ((t->width * t->height) <= (sz * sz))))){
			HX_STACK_LINE(586)
			::String _g13 = ::haxe::CallStack_obj::callStack()->join(HX_CSTRING(",\n"));		HX_STACK_VAR(_g13,"_g13");
			HX_STACK_LINE(586)
			::String msg = ((((::hxd::Assert_obj::ASSERT_HEADER + HX_CSTRING("\n msg: ")) + (HX_CSTRING("value should be true\ntexture too big for video driver"))) + HX_CSTRING("\nstatck:\n")) + _g13);		HX_STACK_VAR(msg,"msg");
			HX_STACK_LINE(586)
			HX_STACK_DO_THROW(msg);
		}
		HX_STACK_LINE(589)
		{
			HX_STACK_LINE(589)
			Dynamic msg = (((HX_CSTRING("uploading tex of ") + t->width) + HX_CSTRING(" ")) + t->height);		HX_STACK_VAR(msg,"msg");
			HX_STACK_LINE(589)
			::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
			HX_STACK_LINE(589)
			int pos_lineNumber = (int)589;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
			HX_STACK_LINE(589)
			::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
			HX_STACK_LINE(589)
			::String pos_methodName = HX_CSTRING("uploadTextureBitmap");		HX_STACK_VAR(pos_methodName,"pos_methodName");
			HX_STACK_LINE(589)
			if (((::hxd::System_obj::debugLevel >= (int)3))){
				HX_STACK_LINE(589)
				::String _g14 = ::Std_obj::string(msg);		HX_STACK_VAR(_g14,"_g14");
				HX_STACK_LINE(589)
				::String _g15 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g14);		HX_STACK_VAR(_g15,"_g15");
				HX_STACK_LINE(589)
				::haxe::Log_obj::trace(_g15,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
			}
			HX_STACK_LINE(589)
			msg;
		}
		HX_STACK_LINE(591)
		{
			HX_STACK_LINE(591)
			::flash::utils::ByteArray _g16;		HX_STACK_VAR(_g16,"_g16");
			HX_STACK_LINE(591)
			if (((pixels == null()))){
				HX_STACK_LINE(591)
				_g16 = null();
			}
			else{
				HX_STACK_LINE(591)
				_g16 = pixels->getByteBuffer();
			}
			HX_STACK_LINE(591)
			Dynamic _g17;		HX_STACK_VAR(_g17,"_g17");
			HX_STACK_LINE(591)
			if (((pixels == null()))){
				HX_STACK_LINE(591)
				_g17 = null();
			}
			else{
				HX_STACK_LINE(591)
				_g17 = pixels->getStart();
			}
			HX_STACK_LINE(591)
			::openfl::gl::GL_obj::lime_gl_tex_image_2d((int)3553,mipLevel,(int)6408,t->width,t->height,(int)0,(int)6408,(int)5121,_g16,_g17);
		}
		HX_STACK_LINE(593)
		if (((mipLevel > (int)0))){
			HX_STACK_LINE(593)
			::openfl::gl::GL_obj::lime_gl_hint((int)33170,(int)4352);
			HX_STACK_LINE(593)
			::openfl::gl::GL_obj::lime_gl_generate_mipmap((int)3553);
			HX_STACK_LINE(593)
			{
				HX_STACK_LINE(593)
				int _g18 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g18,"_g18");
				HX_STACK_LINE(593)
				if (((_g18 != (int)0))){
					HX_STACK_LINE(593)
					::String s1;		HX_STACK_VAR(s1,"s1");
					HX_STACK_LINE(593)
					{
						HX_STACK_LINE(593)
						int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
						HX_STACK_LINE(593)
						switch( (int)(_g)){
							case (int)0: {
								HX_STACK_LINE(593)
								s1 = null();
							}
							;break;
							case (int)1280: {
								HX_STACK_LINE(593)
								s1 = HX_CSTRING("INVALID_ENUM");
							}
							;break;
							case (int)1281: {
								HX_STACK_LINE(593)
								s1 = HX_CSTRING("INVALID_VALUE");
							}
							;break;
							case (int)1282: {
								HX_STACK_LINE(593)
								s1 = HX_CSTRING("INVALID_OPERATION");
							}
							;break;
							case (int)1285: {
								HX_STACK_LINE(593)
								s1 = HX_CSTRING("OUT_OF_MEMORY");
							}
							;break;
							default: {
								HX_STACK_LINE(593)
								s1 = null();
							}
						}
					}
					HX_STACK_LINE(593)
					if (((s1 != null()))){
						HX_STACK_LINE(593)
						::String str = (HX_CSTRING("GL_ERROR:") + s1);		HX_STACK_VAR(str,"str");
						HX_STACK_LINE(593)
						::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
						HX_STACK_LINE(593)
						HX_STACK_DO_THROW(s1);
					}
				}
			}
		}
		HX_STACK_LINE(595)
		::openfl::gl::GL_obj::lime_gl_bind_texture((int)3553,null());
		HX_STACK_LINE(596)
		{
			HX_STACK_LINE(596)
			int _g19 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g19,"_g19");
			HX_STACK_LINE(596)
			if (((_g19 != (int)0))){
				HX_STACK_LINE(596)
				::String s1;		HX_STACK_VAR(s1,"s1");
				HX_STACK_LINE(596)
				{
					HX_STACK_LINE(596)
					int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(596)
					switch( (int)(_g)){
						case (int)0: {
							HX_STACK_LINE(596)
							s1 = null();
						}
						;break;
						case (int)1280: {
							HX_STACK_LINE(596)
							s1 = HX_CSTRING("INVALID_ENUM");
						}
						;break;
						case (int)1281: {
							HX_STACK_LINE(596)
							s1 = HX_CSTRING("INVALID_VALUE");
						}
						;break;
						case (int)1282: {
							HX_STACK_LINE(596)
							s1 = HX_CSTRING("INVALID_OPERATION");
						}
						;break;
						case (int)1285: {
							HX_STACK_LINE(596)
							s1 = HX_CSTRING("OUT_OF_MEMORY");
						}
						;break;
						default: {
							HX_STACK_LINE(596)
							s1 = null();
						}
					}
				}
				HX_STACK_LINE(596)
				if (((s1 != null()))){
					HX_STACK_LINE(596)
					::String str = (HX_CSTRING("GL_ERROR:") + s1);		HX_STACK_VAR(str,"str");
					HX_STACK_LINE(596)
					::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
					HX_STACK_LINE(596)
					HX_STACK_DO_THROW(s1);
				}
			}
		}
	}
return null();
}


Void GlDriver_obj::uploadTexturePixels( ::h3d::mat::Texture t,::hxd::Pixels pixels,int mipLevel,int side){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","uploadTexturePixels",0xaa9d02df,"h3d.impl.GlDriver.uploadTexturePixels","h3d/impl/GlDriver.hx",599,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_ARG(t,"t")
		HX_STACK_ARG(pixels,"pixels")
		HX_STACK_ARG(mipLevel,"mipLevel")
		HX_STACK_ARG(side,"side")
		HX_STACK_LINE(600)
		{
			HX_STACK_LINE(600)
			::openfl::gl::GLTexture texture = t->t;		HX_STACK_VAR(texture,"texture");
			HX_STACK_LINE(600)
			::openfl::gl::GL_obj::lime_gl_bind_texture((int)3553,(  (((texture == null()))) ? Dynamic(null()) : Dynamic(texture->id) ));
		}
		HX_STACK_LINE(600)
		{
			HX_STACK_LINE(600)
			int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(600)
			if (((_g != (int)0))){
				HX_STACK_LINE(600)
				::String s;		HX_STACK_VAR(s,"s");
				HX_STACK_LINE(600)
				{
					HX_STACK_LINE(600)
					int _g1 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(600)
					switch( (int)(_g1)){
						case (int)0: {
							HX_STACK_LINE(600)
							s = null();
						}
						;break;
						case (int)1280: {
							HX_STACK_LINE(600)
							s = HX_CSTRING("INVALID_ENUM");
						}
						;break;
						case (int)1281: {
							HX_STACK_LINE(600)
							s = HX_CSTRING("INVALID_VALUE");
						}
						;break;
						case (int)1282: {
							HX_STACK_LINE(600)
							s = HX_CSTRING("INVALID_OPERATION");
						}
						;break;
						case (int)1285: {
							HX_STACK_LINE(600)
							s = HX_CSTRING("OUT_OF_MEMORY");
						}
						;break;
						default: {
							HX_STACK_LINE(600)
							s = null();
						}
					}
				}
				HX_STACK_LINE(600)
				if (((s != null()))){
					HX_STACK_LINE(600)
					::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
					HX_STACK_LINE(600)
					::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
					HX_STACK_LINE(600)
					HX_STACK_DO_THROW(s);
				}
			}
		}
		HX_STACK_LINE(601)
		pixels->convert(::hxd::PixelFormat_obj::RGBA);
		HX_STACK_LINE(604)
		int sz = ::openfl::gl::GL_obj::lime_gl_get_parameter((int)3379);		HX_STACK_VAR(sz,"sz");
		HX_STACK_LINE(605)
		if (((false == ((t->width * t->height) <= (sz * sz))))){
			HX_STACK_LINE(605)
			::String _g1 = ::haxe::CallStack_obj::callStack()->join(HX_CSTRING(",\n"));		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(605)
			::String msg = ((((::hxd::Assert_obj::ASSERT_HEADER + HX_CSTRING("\n msg: ")) + (HX_CSTRING("value should be true\ntexture too big for video driver"))) + HX_CSTRING("\nstatck:\n")) + _g1);		HX_STACK_VAR(msg,"msg");
			HX_STACK_LINE(605)
			HX_STACK_DO_THROW(msg);
		}
		HX_STACK_LINE(606)
		::hxd::Assert_obj::notNull(pixels,null());
		HX_STACK_LINE(607)
		::hxd::Assert_obj::notNull(pixels->bytes,null());
		HX_STACK_LINE(610)
		{
			HX_STACK_LINE(610)
			Dynamic msg = (((HX_CSTRING("uploading tex of ") + t->width) + HX_CSTRING(" ")) + t->height);		HX_STACK_VAR(msg,"msg");
			HX_STACK_LINE(610)
			::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
			HX_STACK_LINE(610)
			int pos_lineNumber = (int)610;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
			HX_STACK_LINE(610)
			::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
			HX_STACK_LINE(610)
			::String pos_methodName = HX_CSTRING("uploadTexturePixels");		HX_STACK_VAR(pos_methodName,"pos_methodName");
			HX_STACK_LINE(610)
			if (((::hxd::System_obj::debugLevel >= (int)3))){
				HX_STACK_LINE(610)
				::String _g2 = ::Std_obj::string(msg);		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(610)
				::String _g3 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g2);		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(610)
				::haxe::Log_obj::trace(_g3,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
			}
			HX_STACK_LINE(610)
			msg;
		}
		HX_STACK_LINE(613)
		::flash::utils::ByteArray _g4 = ::flash::utils::ByteArray_obj::fromBytes(pixels->bytes);		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(613)
		::openfl::utils::UInt8Array pix = ::openfl::utils::UInt8Array_obj::__new(_g4,pixels->offset,null());		HX_STACK_VAR(pix,"pix");
		HX_STACK_LINE(614)
		{
			HX_STACK_LINE(614)
			::flash::utils::ByteArray _g5;		HX_STACK_VAR(_g5,"_g5");
			HX_STACK_LINE(614)
			if (((pix == null()))){
				HX_STACK_LINE(614)
				_g5 = null();
			}
			else{
				HX_STACK_LINE(614)
				_g5 = pix->getByteBuffer();
			}
			HX_STACK_LINE(614)
			Dynamic _g6;		HX_STACK_VAR(_g6,"_g6");
			HX_STACK_LINE(614)
			if (((pix == null()))){
				HX_STACK_LINE(614)
				_g6 = null();
			}
			else{
				HX_STACK_LINE(614)
				_g6 = pix->getStart();
			}
			HX_STACK_LINE(614)
			::openfl::gl::GL_obj::lime_gl_tex_image_2d((int)3553,mipLevel,(int)6408,t->width,t->height,(int)0,(int)6408,(int)5121,_g5,_g6);
		}
		HX_STACK_LINE(616)
		if (((mipLevel > (int)0))){
			HX_STACK_LINE(616)
			::openfl::gl::GL_obj::lime_gl_hint((int)33170,(int)4352);
			HX_STACK_LINE(616)
			::openfl::gl::GL_obj::lime_gl_generate_mipmap((int)3553);
			HX_STACK_LINE(616)
			{
				HX_STACK_LINE(616)
				int _g7 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g7,"_g7");
				HX_STACK_LINE(616)
				if (((_g7 != (int)0))){
					HX_STACK_LINE(616)
					::String s;		HX_STACK_VAR(s,"s");
					HX_STACK_LINE(616)
					{
						HX_STACK_LINE(616)
						int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
						HX_STACK_LINE(616)
						switch( (int)(_g)){
							case (int)0: {
								HX_STACK_LINE(616)
								s = null();
							}
							;break;
							case (int)1280: {
								HX_STACK_LINE(616)
								s = HX_CSTRING("INVALID_ENUM");
							}
							;break;
							case (int)1281: {
								HX_STACK_LINE(616)
								s = HX_CSTRING("INVALID_VALUE");
							}
							;break;
							case (int)1282: {
								HX_STACK_LINE(616)
								s = HX_CSTRING("INVALID_OPERATION");
							}
							;break;
							case (int)1285: {
								HX_STACK_LINE(616)
								s = HX_CSTRING("OUT_OF_MEMORY");
							}
							;break;
							default: {
								HX_STACK_LINE(616)
								s = null();
							}
						}
					}
					HX_STACK_LINE(616)
					if (((s != null()))){
						HX_STACK_LINE(616)
						::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
						HX_STACK_LINE(616)
						::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
						HX_STACK_LINE(616)
						HX_STACK_DO_THROW(s);
					}
				}
			}
		}
		HX_STACK_LINE(618)
		::openfl::gl::GL_obj::lime_gl_bind_texture((int)3553,null());
		HX_STACK_LINE(619)
		{
			HX_STACK_LINE(619)
			int _g8 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g8,"_g8");
			HX_STACK_LINE(619)
			if (((_g8 != (int)0))){
				HX_STACK_LINE(619)
				::String s;		HX_STACK_VAR(s,"s");
				HX_STACK_LINE(619)
				{
					HX_STACK_LINE(619)
					int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(619)
					switch( (int)(_g)){
						case (int)0: {
							HX_STACK_LINE(619)
							s = null();
						}
						;break;
						case (int)1280: {
							HX_STACK_LINE(619)
							s = HX_CSTRING("INVALID_ENUM");
						}
						;break;
						case (int)1281: {
							HX_STACK_LINE(619)
							s = HX_CSTRING("INVALID_VALUE");
						}
						;break;
						case (int)1282: {
							HX_STACK_LINE(619)
							s = HX_CSTRING("INVALID_OPERATION");
						}
						;break;
						case (int)1285: {
							HX_STACK_LINE(619)
							s = HX_CSTRING("OUT_OF_MEMORY");
						}
						;break;
						default: {
							HX_STACK_LINE(619)
							s = null();
						}
					}
				}
				HX_STACK_LINE(619)
				if (((s != null()))){
					HX_STACK_LINE(619)
					::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
					HX_STACK_LINE(619)
					::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
					HX_STACK_LINE(619)
					HX_STACK_DO_THROW(s);
				}
			}
		}
	}
return null();
}


Void GlDriver_obj::uploadVertexBuffer( ::h3d::impl::GLVB v,int startVertex,int vertexCount,Array< Float > buf,int bufPos){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","uploadVertexBuffer",0x15726aed,"h3d.impl.GlDriver.uploadVertexBuffer","h3d/impl/GlDriver.hx",622,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_ARG(v,"v")
		HX_STACK_ARG(startVertex,"startVertex")
		HX_STACK_ARG(vertexCount,"vertexCount")
		HX_STACK_ARG(buf,"buf")
		HX_STACK_ARG(bufPos,"bufPos")
		HX_STACK_LINE(623)
		int stride = v->stride;		HX_STACK_VAR(stride,"stride");
		HX_STACK_LINE(624)
		Array< Float > _g;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(624)
		_g = hx::TCastToArray(buf);
		HX_STACK_LINE(624)
		::openfl::utils::Float32Array buf1 = ::openfl::utils::Float32Array_obj::__new(_g,null(),null());		HX_STACK_VAR(buf1,"buf1");
		HX_STACK_LINE(625)
		::openfl::utils::Float32Array sub = ::openfl::utils::Float32Array_obj::__new(buf1->buffer,bufPos,((vertexCount * stride) * ((  ((this->fixMult)) ? int((int)4) : int((int)1) ))));		HX_STACK_VAR(sub,"sub");
		HX_STACK_LINE(626)
		{
			HX_STACK_LINE(626)
			::openfl::gl::GLBuffer buffer = v->b;		HX_STACK_VAR(buffer,"buffer");
			HX_STACK_LINE(626)
			::openfl::gl::GL_obj::lime_gl_bind_buffer((int)34962,(  (((buffer == null()))) ? Dynamic(null()) : Dynamic(buffer->id) ));
		}
		HX_STACK_LINE(627)
		{
			HX_STACK_LINE(627)
			::flash::utils::ByteArray _g1 = sub->getByteBuffer();		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(627)
			int _g2 = sub->getStart();		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(627)
			int _g3 = sub->getLength();		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(627)
			::openfl::gl::GL_obj::lime_gl_buffer_sub_data((int)34962,((startVertex * stride) * (int)4),_g1,_g2,_g3);
		}
		HX_STACK_LINE(628)
		::openfl::gl::GL_obj::lime_gl_bind_buffer((int)34962,null());
		HX_STACK_LINE(629)
		this->curBuffer = null();
		HX_STACK_LINE(629)
		this->curMultiBuffer = null();
		HX_STACK_LINE(630)
		{
			HX_STACK_LINE(630)
			int _g4 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g4,"_g4");
			HX_STACK_LINE(630)
			if (((_g4 != (int)0))){
				HX_STACK_LINE(630)
				::String s;		HX_STACK_VAR(s,"s");
				HX_STACK_LINE(630)
				{
					HX_STACK_LINE(630)
					int _g1 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(630)
					switch( (int)(_g1)){
						case (int)0: {
							HX_STACK_LINE(630)
							s = null();
						}
						;break;
						case (int)1280: {
							HX_STACK_LINE(630)
							s = HX_CSTRING("INVALID_ENUM");
						}
						;break;
						case (int)1281: {
							HX_STACK_LINE(630)
							s = HX_CSTRING("INVALID_VALUE");
						}
						;break;
						case (int)1282: {
							HX_STACK_LINE(630)
							s = HX_CSTRING("INVALID_OPERATION");
						}
						;break;
						case (int)1285: {
							HX_STACK_LINE(630)
							s = HX_CSTRING("OUT_OF_MEMORY");
						}
						;break;
						default: {
							HX_STACK_LINE(630)
							s = null();
						}
					}
				}
				HX_STACK_LINE(630)
				if (((s != null()))){
					HX_STACK_LINE(630)
					::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
					HX_STACK_LINE(630)
					::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
					HX_STACK_LINE(630)
					HX_STACK_DO_THROW(s);
				}
			}
		}
	}
return null();
}


Void GlDriver_obj::uploadVertexBytes( ::h3d::impl::GLVB v,int startVertex,int vertexCount,::haxe::io::Bytes buf,int bufPos){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","uploadVertexBytes",0x4683371e,"h3d.impl.GlDriver.uploadVertexBytes","h3d/impl/GlDriver.hx",633,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_ARG(v,"v")
		HX_STACK_ARG(startVertex,"startVertex")
		HX_STACK_ARG(vertexCount,"vertexCount")
		HX_STACK_ARG(buf,"buf")
		HX_STACK_ARG(bufPos,"bufPos")
		HX_STACK_LINE(634)
		int stride = v->stride;		HX_STACK_VAR(stride,"stride");
		HX_STACK_LINE(635)
		::openfl::utils::UInt8Array buf1;		HX_STACK_VAR(buf1,"buf1");
		HX_STACK_LINE(635)
		{
			HX_STACK_LINE(635)
			int pos = (int)0;		HX_STACK_VAR(pos,"pos");
			HX_STACK_LINE(635)
			::flash::utils::ByteArray _g = ::flash::utils::ByteArray_obj::fromBytes(buf);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(635)
			buf1 = ::openfl::utils::UInt8Array_obj::__new(_g,pos,null());
		}
		HX_STACK_LINE(636)
		::flash::utils::ByteArray _g1 = ::flash::utils::ByteArray_obj::fromBytes(buf1->buffer);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(636)
		::openfl::utils::UInt8Array sub = ::openfl::utils::UInt8Array_obj::__new(_g1,bufPos,((vertexCount * stride) * (int)4));		HX_STACK_VAR(sub,"sub");
		HX_STACK_LINE(637)
		{
			HX_STACK_LINE(637)
			::openfl::gl::GLBuffer buffer = v->b;		HX_STACK_VAR(buffer,"buffer");
			HX_STACK_LINE(637)
			::openfl::gl::GL_obj::lime_gl_bind_buffer((int)34962,(  (((buffer == null()))) ? Dynamic(null()) : Dynamic(buffer->id) ));
		}
		HX_STACK_LINE(638)
		{
			HX_STACK_LINE(638)
			::flash::utils::ByteArray _g2 = sub->getByteBuffer();		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(638)
			int _g3 = sub->getStart();		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(638)
			int _g4 = sub->getLength();		HX_STACK_VAR(_g4,"_g4");
			HX_STACK_LINE(638)
			::openfl::gl::GL_obj::lime_gl_buffer_sub_data((int)34962,((startVertex * stride) * (int)4),_g2,_g3,_g4);
		}
		HX_STACK_LINE(639)
		::openfl::gl::GL_obj::lime_gl_bind_buffer((int)34962,null());
		HX_STACK_LINE(640)
		this->curBuffer = null();
		HX_STACK_LINE(640)
		this->curMultiBuffer = null();
		HX_STACK_LINE(641)
		{
			HX_STACK_LINE(641)
			int _g5 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g5,"_g5");
			HX_STACK_LINE(641)
			if (((_g5 != (int)0))){
				HX_STACK_LINE(641)
				::String s;		HX_STACK_VAR(s,"s");
				HX_STACK_LINE(641)
				{
					HX_STACK_LINE(641)
					int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(641)
					switch( (int)(_g)){
						case (int)0: {
							HX_STACK_LINE(641)
							s = null();
						}
						;break;
						case (int)1280: {
							HX_STACK_LINE(641)
							s = HX_CSTRING("INVALID_ENUM");
						}
						;break;
						case (int)1281: {
							HX_STACK_LINE(641)
							s = HX_CSTRING("INVALID_VALUE");
						}
						;break;
						case (int)1282: {
							HX_STACK_LINE(641)
							s = HX_CSTRING("INVALID_OPERATION");
						}
						;break;
						case (int)1285: {
							HX_STACK_LINE(641)
							s = HX_CSTRING("OUT_OF_MEMORY");
						}
						;break;
						default: {
							HX_STACK_LINE(641)
							s = null();
						}
					}
				}
				HX_STACK_LINE(641)
				if (((s != null()))){
					HX_STACK_LINE(641)
					::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
					HX_STACK_LINE(641)
					::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
					HX_STACK_LINE(641)
					HX_STACK_DO_THROW(s);
				}
			}
		}
	}
return null();
}


Void GlDriver_obj::uploadIndexesBuffer( ::openfl::gl::GLBuffer i,int startIndice,int indiceCount,Array< int > buf,int bufPos){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","uploadIndexesBuffer",0xc0b0cd97,"h3d.impl.GlDriver.uploadIndexesBuffer","h3d/impl/GlDriver.hx",644,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_ARG(i,"i")
		HX_STACK_ARG(startIndice,"startIndice")
		HX_STACK_ARG(indiceCount,"indiceCount")
		HX_STACK_ARG(buf,"buf")
		HX_STACK_ARG(bufPos,"bufPos")
		HX_STACK_LINE(645)
		Array< int > _g;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(645)
		_g = hx::TCastToArray(buf);
		HX_STACK_LINE(645)
		::openfl::utils::Int16Array buf1 = ::openfl::utils::Int16Array_obj::__new(_g,null(),null());		HX_STACK_VAR(buf1,"buf1");
		HX_STACK_LINE(646)
		::flash::utils::ByteArray _g1 = buf1->getByteBuffer();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(646)
		::openfl::utils::Int16Array sub = ::openfl::utils::Int16Array_obj::__new(_g1,bufPos,(indiceCount * ((  ((this->fixMult)) ? int((int)2) : int((int)1) ))));		HX_STACK_VAR(sub,"sub");
		HX_STACK_LINE(647)
		::openfl::gl::GL_obj::lime_gl_bind_buffer((int)34963,(  (((i == null()))) ? Dynamic(null()) : Dynamic(i->id) ));
		HX_STACK_LINE(648)
		{
			HX_STACK_LINE(648)
			::flash::utils::ByteArray _g2 = sub->getByteBuffer();		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(648)
			int _g3 = sub->getStart();		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(648)
			int _g4 = sub->getLength();		HX_STACK_VAR(_g4,"_g4");
			HX_STACK_LINE(648)
			::openfl::gl::GL_obj::lime_gl_buffer_sub_data((int)34963,(startIndice * (int)2),_g2,_g3,_g4);
		}
		HX_STACK_LINE(649)
		::openfl::gl::GL_obj::lime_gl_bind_buffer((int)34963,null());
	}
return null();
}


Void GlDriver_obj::uploadIndexesBytes( ::openfl::gl::GLBuffer i,int startIndice,int indiceCount,::haxe::io::Bytes buf,int bufPos){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","uploadIndexesBytes",0xd5a157b4,"h3d.impl.GlDriver.uploadIndexesBytes","h3d/impl/GlDriver.hx",652,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_ARG(i,"i")
		HX_STACK_ARG(startIndice,"startIndice")
		HX_STACK_ARG(indiceCount,"indiceCount")
		HX_STACK_ARG(buf,"buf")
		HX_STACK_ARG(bufPos,"bufPos")
		HX_STACK_LINE(653)
		::openfl::utils::UInt8Array buf1 = ::openfl::utils::UInt8Array_obj::__new(buf->b,null(),null());		HX_STACK_VAR(buf1,"buf1");
		HX_STACK_LINE(654)
		::flash::utils::ByteArray _g = buf1->getByteBuffer();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(654)
		::openfl::utils::UInt8Array sub = ::openfl::utils::UInt8Array_obj::__new(_g,bufPos,(indiceCount * (int)2));		HX_STACK_VAR(sub,"sub");
		HX_STACK_LINE(655)
		::openfl::gl::GL_obj::lime_gl_bind_buffer((int)34963,(  (((i == null()))) ? Dynamic(null()) : Dynamic(i->id) ));
		HX_STACK_LINE(656)
		{
			HX_STACK_LINE(656)
			::flash::utils::ByteArray _g1 = sub->getByteBuffer();		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(656)
			int _g2 = sub->getStart();		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(656)
			int _g3 = sub->getLength();		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(656)
			::openfl::gl::GL_obj::lime_gl_buffer_sub_data((int)34963,(startIndice * (int)2),_g1,_g2,_g3);
		}
		HX_STACK_LINE(657)
		::openfl::gl::GL_obj::lime_gl_bind_buffer((int)34963,null());
	}
return null();
}


::h3d::impl::ShaderType GlDriver_obj::decodeType( ::String t){
	HX_STACK_FRAME("h3d.impl.GlDriver","decodeType",0xf174cad0,"h3d.impl.GlDriver.decodeType","h3d/impl/GlDriver.hx",661,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_ARG(t,"t")
	HX_STACK_LINE(661)
	::String _switch_1 = (t);
	if (  ( _switch_1==HX_CSTRING("float"))){
		HX_STACK_LINE(662)
		return ::h3d::impl::ShaderType_obj::_Float;
	}
	else if (  ( _switch_1==HX_CSTRING("vec2"))){
		HX_STACK_LINE(663)
		return ::h3d::impl::ShaderType_obj::Vec2;
	}
	else if (  ( _switch_1==HX_CSTRING("vec3"))){
		HX_STACK_LINE(664)
		return ::h3d::impl::ShaderType_obj::Vec3;
	}
	else if (  ( _switch_1==HX_CSTRING("vec4"))){
		HX_STACK_LINE(665)
		return ::h3d::impl::ShaderType_obj::Vec4;
	}
	else if (  ( _switch_1==HX_CSTRING("mat4"))){
		HX_STACK_LINE(666)
		return ::h3d::impl::ShaderType_obj::Mat4;
	}
	else  {
		HX_STACK_LINE(667)
		HX_STACK_DO_THROW((HX_CSTRING("Unknown type ") + t));
	}
;
;
	HX_STACK_LINE(661)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(GlDriver_obj,decodeType,return )

::h3d::impl::ShaderType GlDriver_obj::decodeTypeInt( int t){
	HX_STACK_FRAME("h3d.impl.GlDriver","decodeTypeInt",0x7dd99bff,"h3d.impl.GlDriver.decodeTypeInt","h3d/impl/GlDriver.hx",672,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_ARG(t,"t")
	HX_STACK_LINE(672)
	switch( (int)(t)){
		case (int)35678: {
			HX_STACK_LINE(673)
			return ::h3d::impl::ShaderType_obj::Tex2d;
		}
		;break;
		case (int)35680: {
			HX_STACK_LINE(674)
			return ::h3d::impl::ShaderType_obj::TexCube;
		}
		;break;
		case (int)5126: {
			HX_STACK_LINE(675)
			return ::h3d::impl::ShaderType_obj::_Float;
		}
		;break;
		case (int)35664: {
			HX_STACK_LINE(676)
			return ::h3d::impl::ShaderType_obj::Vec2;
		}
		;break;
		case (int)35665: {
			HX_STACK_LINE(677)
			return ::h3d::impl::ShaderType_obj::Vec3;
		}
		;break;
		case (int)35666: {
			HX_STACK_LINE(678)
			return ::h3d::impl::ShaderType_obj::Vec4;
		}
		;break;
		case (int)35674: {
			HX_STACK_LINE(679)
			return ::h3d::impl::ShaderType_obj::Mat2;
		}
		;break;
		case (int)35675: {
			HX_STACK_LINE(680)
			return ::h3d::impl::ShaderType_obj::Mat3;
		}
		;break;
		case (int)35676: {
			HX_STACK_LINE(681)
			return ::h3d::impl::ShaderType_obj::Mat4;
		}
		;break;
		default: {
			HX_STACK_LINE(683)
			::openfl::gl::GL_obj::lime_gl_pixel_storei(t,(int)0);
			HX_STACK_LINE(684)
			HX_STACK_DO_THROW((HX_CSTRING("Unknown type ") + t));
		}
	}
	HX_STACK_LINE(672)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(GlDriver_obj,decodeTypeInt,return )

int GlDriver_obj::typeSize( ::h3d::impl::ShaderType t){
	HX_STACK_FRAME("h3d.impl.GlDriver","typeSize",0x0b89c263,"h3d.impl.GlDriver.typeSize","h3d/impl/GlDriver.hx",689,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_ARG(t,"t")
	HX_STACK_LINE(689)
	switch( (int)(t->__Index())){
		case (int)0: case (int)10: case (int)9: {
			HX_STACK_LINE(690)
			return (int)1;
		}
		;break;
		case (int)1: {
			HX_STACK_LINE(691)
			return (int)2;
		}
		;break;
		case (int)2: {
			HX_STACK_LINE(692)
			return (int)3;
		}
		;break;
		case (int)3: {
			HX_STACK_LINE(693)
			return (int)4;
		}
		;break;
		case (int)4: {
			HX_STACK_LINE(694)
			return (int)4;
		}
		;break;
		case (int)5: {
			HX_STACK_LINE(695)
			return (int)9;
		}
		;break;
		case (int)6: {
			HX_STACK_LINE(696)
			return (int)16;
		}
		;break;
		case (int)7: case (int)8: case (int)11: case (int)12: {
			HX_STACK_LINE(697)
			::String _g = ::Std_obj::string(t);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(697)
			HX_STACK_DO_THROW((HX_CSTRING("Unexpected ") + _g));
		}
		;break;
		case (int)13: {
			HX_STACK_LINE(689)
			::h3d::impl::ShaderType t1 = (::h3d::impl::ShaderType(t))->__Param(2);		HX_STACK_VAR(t1,"t1");
			HX_STACK_LINE(689)
			Dynamic nb = (::h3d::impl::ShaderType(t))->__Param(1);		HX_STACK_VAR(nb,"nb");
			HX_STACK_LINE(698)
			{
				HX_STACK_LINE(698)
				int _g1 = this->typeSize(t1);		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(698)
				return (nb * _g1);
			}
		}
		;break;
	}
	HX_STACK_LINE(689)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC1(GlDriver_obj,typeSize,return )

::h3d::impl::ShaderInstance GlDriver_obj::buildShaderInstance( ::h3d::impl::Shader shader){
	HX_STACK_FRAME("h3d.impl.GlDriver","buildShaderInstance",0xc8fcd2e0,"h3d.impl.GlDriver.buildShaderInstance","h3d/impl/GlDriver.hx",704,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_ARG(shader,"shader")
	HX_STACK_LINE(704)
	Array< ::Dynamic > shader1 = Array_obj< ::Dynamic >::__new().Add(shader);		HX_STACK_VAR(shader1,"shader1");
	HX_STACK_LINE(704)
	::h3d::impl::GlDriver _g = hx::ObjectPtr<OBJ_>(this);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(705)
	Array< ::Dynamic > cl = Array_obj< ::Dynamic >::__new().Add(::Type_obj::getClass(shader1->__get((int)0).StaticCast< ::h3d::impl::Shader >()));		HX_STACK_VAR(cl,"cl");
	HX_STACK_LINE(706)
	Array< ::String > fullCode = Array_obj< ::String >::__new().Add(HX_CSTRING(""));		HX_STACK_VAR(fullCode,"fullCode");

	HX_BEGIN_LOCAL_FUNC_S3(hx::LocalFunc,_Function_1_1,Array< ::Dynamic >,cl,Array< ::String >,fullCode,Array< ::Dynamic >,shader1)
	::openfl::gl::GLShader run(int type){
		HX_STACK_FRAME("*","_Function_1_1",0x5200ed37,"*._Function_1_1","h3d/impl/GlDriver.hx",707,0xae6eb278)
		HX_STACK_ARG(type,"type")
		{
			HX_STACK_LINE(708)
			bool vertex = (type == (int)35633);		HX_STACK_VAR(vertex,"vertex");
			HX_STACK_LINE(709)
			::String name;		HX_STACK_VAR(name,"name");
			HX_STACK_LINE(709)
			if ((vertex)){
				HX_STACK_LINE(709)
				name = HX_CSTRING("VERTEX");
			}
			else{
				HX_STACK_LINE(709)
				name = HX_CSTRING("FRAGMENT");
			}
			HX_STACK_LINE(710)
			::String code = ::Reflect_obj::field(cl->__get((int)0).StaticCast< ::Class >(),name);		HX_STACK_VAR(code,"code");
			HX_STACK_LINE(711)
			if (((code == null()))){
				HX_STACK_LINE(711)
				::String _g1 = ::Type_obj::getClassName(cl->__get((int)0).StaticCast< ::Class >());		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(711)
				::String _g11 = (HX_CSTRING("Missing ") + _g1);		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(711)
				::String _g2 = (_g11 + HX_CSTRING("."));		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(711)
				::String _g3 = (_g2 + name);		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(711)
				HX_STACK_DO_THROW((_g3 + HX_CSTRING(" shader source")));
			}
			HX_STACK_LINE(713)
			hx::AddEq(fullCode[(int)0],code);
			HX_STACK_LINE(714)
			::String cst = shader1->__get((int)0).StaticCast< ::h3d::impl::Shader >()->getConstants(vertex);		HX_STACK_VAR(cst,"cst");
			HX_STACK_LINE(718)
			::String _g4 = ::StringTools_obj::trim((cst + code));		HX_STACK_VAR(_g4,"_g4");
			HX_STACK_LINE(718)
			code = _g4;
			HX_STACK_LINE(720)
			Array< ::String > gles = Array_obj< ::String >::__new().Add(HX_CSTRING("#ifndef GL_FRAGMENT_PRECISION_HIGH\n precision mediump float;\n precision mediump int;\n #else\nprecision highp float;\n precision highp int;\n #end"));		HX_STACK_VAR(gles,"gles");
			HX_STACK_LINE(721)
			Array< ::String > notgles = Array_obj< ::String >::__new().Add(HX_CSTRING("#define lowp  ")).Add(HX_CSTRING("#define mediump  ")).Add(HX_CSTRING("#define highp  "));		HX_STACK_VAR(notgles,"notgles");

			HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_2_1)
			::String run(::String s){
				HX_STACK_FRAME("*","_Function_2_1",0x5201af78,"*._Function_2_1","h3d/impl/GlDriver.hx",723,0xae6eb278)
				HX_STACK_ARG(s,"s")
				{
					HX_STACK_LINE(723)
					return ((HX_CSTRING("#if GL_ES \n\t") + s) + HX_CSTRING(" \n #end \n"));
				}
				return null();
			}
			HX_END_LOCAL_FUNC1(return)

			HX_STACK_LINE(723)
			::String _g5 = gles->map( Dynamic(new _Function_2_1())).StaticCast< Array< ::String > >()->join(HX_CSTRING(""));		HX_STACK_VAR(_g5,"_g5");
			HX_STACK_LINE(723)
			::String _g6 = (_g5 + code);		HX_STACK_VAR(_g6,"_g6");
			HX_STACK_LINE(723)
			code = _g6;

			HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_2_2)
			::String run(::String s){
				HX_STACK_FRAME("*","_Function_2_2",0x5201af79,"*._Function_2_2","h3d/impl/GlDriver.hx",724,0xae6eb278)
				HX_STACK_ARG(s,"s")
				{
					HX_STACK_LINE(724)
					return ((HX_CSTRING("#if !defined(GL_ES) \n\t") + s) + HX_CSTRING(" \n #end \n"));
				}
				return null();
			}
			HX_END_LOCAL_FUNC1(return)

			HX_STACK_LINE(724)
			::String _g7 = notgles->map( Dynamic(new _Function_2_2())).StaticCast< Array< ::String > >()->join(HX_CSTRING(""));		HX_STACK_VAR(_g7,"_g7");
			HX_STACK_LINE(724)
			::String _g8 = (_g7 + code);		HX_STACK_VAR(_g8,"_g8");
			HX_STACK_LINE(724)
			code = _g8;
			HX_STACK_LINE(727)
			::String _g9 = ::EReg_obj::__new(HX_CSTRING("#if ([A-Za-z0-9_]+)"),HX_CSTRING("g"))->replace(code,HX_CSTRING("#if defined ( $1 ) \n"));		HX_STACK_VAR(_g9,"_g9");
			HX_STACK_LINE(727)
			code = _g9;
			HX_STACK_LINE(728)
			::String _g10 = ::EReg_obj::__new(HX_CSTRING("#elseif ([A-Za-z0-9_]+)"),HX_CSTRING("g"))->replace(code,HX_CSTRING("#elif defined ( $1 ) \n"));		HX_STACK_VAR(_g10,"_g10");
			HX_STACK_LINE(728)
			code = _g10;
			HX_STACK_LINE(729)
			::String _g11 = code.split(HX_CSTRING("#end"))->join(HX_CSTRING("#endif"));		HX_STACK_VAR(_g11,"_g11");
			HX_STACK_LINE(729)
			code = _g11;
			HX_STACK_LINE(733)
			code = (HX_CSTRING("#version 120 \n") + code);
			HX_STACK_LINE(741)
			int _g12 = ::openfl::gl::GL_obj::get_version();		HX_STACK_VAR(_g12,"_g12");
			HX_STACK_LINE(741)
			Dynamic _g13 = ::openfl::gl::GL_obj::lime_gl_create_shader(type);		HX_STACK_VAR(_g13,"_g13");
			HX_STACK_LINE(741)
			::openfl::gl::GLShader s = ::openfl::gl::GLShader_obj::__new(_g12,_g13);		HX_STACK_VAR(s,"s");
			HX_STACK_LINE(742)
			::openfl::gl::GL_obj::lime_gl_shader_source(s->id,code);
			HX_STACK_LINE(743)
			{
				HX_STACK_LINE(743)
				::String _g18;		HX_STACK_VAR(_g18,"_g18");
				HX_STACK_LINE(743)
				{
					HX_STACK_LINE(743)
					::String log = ::openfl::gl::GL_obj::lime_gl_get_shader_info_log(s->id);		HX_STACK_VAR(log,"log");
					HX_STACK_LINE(743)
					if (((log == null()))){
						HX_STACK_LINE(743)
						_g18 = HX_CSTRING("");
					}
					else{
						HX_STACK_LINE(743)
						Array< ::String > lines = code.split(HX_CSTRING("\n"));		HX_STACK_VAR(lines,"lines");
						HX_STACK_LINE(743)
						::String _g14 = log.substr((int)9,null());		HX_STACK_VAR(_g14,"_g14");
						HX_STACK_LINE(743)
						Dynamic index = ::Std_obj::parseInt(_g14);		HX_STACK_VAR(index,"index");
						HX_STACK_LINE(743)
						if (((index == null()))){
							HX_STACK_LINE(743)
							_g18 = HX_CSTRING("");
						}
						else{
							HX_STACK_LINE(743)
							(index)--;
							HX_STACK_LINE(743)
							if (((lines->__get(index) == null()))){
								HX_STACK_LINE(743)
								_g18 = HX_CSTRING("");
							}
							else{
								HX_STACK_LINE(743)
								::String line = lines->__get(index);		HX_STACK_VAR(line,"line");
								HX_STACK_LINE(743)
								if (((line == null()))){
									HX_STACK_LINE(743)
									line = HX_CSTRING("-");
								}
								else{
									HX_STACK_LINE(743)
									::String _g15 = ::StringTools_obj::trim(line);		HX_STACK_VAR(_g15,"_g15");
									HX_STACK_LINE(743)
									::String _g16 = (HX_CSTRING("(") + _g15);		HX_STACK_VAR(_g16,"_g16");
									HX_STACK_LINE(743)
									::String _g17 = (_g16 + HX_CSTRING(")."));		HX_STACK_VAR(_g17,"_g17");
									HX_STACK_LINE(743)
									line = _g17;
								}
								HX_STACK_LINE(743)
								_g18 = (log + line);
							}
						}
					}
				}
				HX_STACK_LINE(743)
				Dynamic msg = (HX_CSTRING("source shaderInfoLog:") + _g18);		HX_STACK_VAR(msg,"msg");
				HX_STACK_LINE(743)
				::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
				HX_STACK_LINE(743)
				int pos_lineNumber = (int)743;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
				HX_STACK_LINE(743)
				::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
				HX_STACK_LINE(743)
				::String pos_methodName = HX_CSTRING("buildShaderInstance");		HX_STACK_VAR(pos_methodName,"pos_methodName");
				HX_STACK_LINE(743)
				if (((::hxd::System_obj::debugLevel >= (int)3))){
					HX_STACK_LINE(743)
					::String _g19 = ::Std_obj::string(msg);		HX_STACK_VAR(_g19,"_g19");
					HX_STACK_LINE(743)
					::String _g20 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g19);		HX_STACK_VAR(_g20,"_g20");
					HX_STACK_LINE(743)
					::haxe::Log_obj::trace(_g20,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
				}
				HX_STACK_LINE(743)
				msg;
			}
			HX_STACK_LINE(745)
			::openfl::gl::GL_obj::lime_gl_compile_shader(s->id);
			HX_STACK_LINE(749)
			int _g21 = ::openfl::gl::GL_obj::lime_gl_get_shader_parameter(s->id,(int)35713);		HX_STACK_VAR(_g21,"_g21");
			HX_STACK_LINE(749)
			if (((_g21 != (int)1))){
				HX_STACK_LINE(750)
				{
					HX_STACK_LINE(750)
					::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
					HX_STACK_LINE(750)
					int pos_lineNumber = (int)750;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
					HX_STACK_LINE(750)
					::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
					HX_STACK_LINE(750)
					::String pos_methodName = HX_CSTRING("buildShaderInstance");		HX_STACK_VAR(pos_methodName,"pos_methodName");
					HX_STACK_LINE(750)
					if (((::hxd::System_obj::debugLevel >= (int)1))){
						HX_STACK_LINE(750)
						::String _g22 = HX_CSTRING("error occured");		HX_STACK_VAR(_g22,"_g22");
						HX_STACK_LINE(750)
						::String _g23 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g22);		HX_STACK_VAR(_g23,"_g23");
						HX_STACK_LINE(750)
						::haxe::Log_obj::trace(_g23,hx::SourceInfo(HX_CSTRING("System.hx"),305,HX_CSTRING("hxd.System"),HX_CSTRING("trace1")));
					}
					HX_STACK_LINE(750)
					HX_CSTRING("error occured");
				}
				HX_STACK_LINE(751)
				::Class _g24 = ::Type_obj::getClass(shader1->__get((int)0).StaticCast< ::h3d::impl::Shader >());		HX_STACK_VAR(_g24,"_g24");
				HX_STACK_LINE(751)
				::String _g25 = ::Std_obj::string(_g24);		HX_STACK_VAR(_g25,"_g25");
				HX_STACK_LINE(751)
				::String _g26 = (HX_CSTRING("An error occurred compiling the ") + _g25);		HX_STACK_VAR(_g26,"_g26");
				HX_STACK_LINE(751)
				::String _g27 = (_g26 + HX_CSTRING(" : "));		HX_STACK_VAR(_g27,"_g27");
				HX_STACK_LINE(751)
				::String _g32;		HX_STACK_VAR(_g32,"_g32");
				HX_STACK_LINE(751)
				{
					HX_STACK_LINE(751)
					::String log = ::openfl::gl::GL_obj::lime_gl_get_shader_info_log(s->id);		HX_STACK_VAR(log,"log");
					HX_STACK_LINE(751)
					if (((log == null()))){
						HX_STACK_LINE(751)
						_g32 = HX_CSTRING("");
					}
					else{
						HX_STACK_LINE(751)
						Array< ::String > lines = code.split(HX_CSTRING("\n"));		HX_STACK_VAR(lines,"lines");
						HX_STACK_LINE(751)
						::String _g28 = log.substr((int)9,null());		HX_STACK_VAR(_g28,"_g28");
						HX_STACK_LINE(751)
						Dynamic index = ::Std_obj::parseInt(_g28);		HX_STACK_VAR(index,"index");
						HX_STACK_LINE(751)
						if (((index == null()))){
							HX_STACK_LINE(751)
							_g32 = HX_CSTRING("");
						}
						else{
							HX_STACK_LINE(751)
							(index)--;
							HX_STACK_LINE(751)
							if (((lines->__get(index) == null()))){
								HX_STACK_LINE(751)
								_g32 = HX_CSTRING("");
							}
							else{
								HX_STACK_LINE(751)
								::String line = lines->__get(index);		HX_STACK_VAR(line,"line");
								HX_STACK_LINE(751)
								if (((line == null()))){
									HX_STACK_LINE(751)
									line = HX_CSTRING("-");
								}
								else{
									HX_STACK_LINE(751)
									::String _g29 = ::StringTools_obj::trim(line);		HX_STACK_VAR(_g29,"_g29");
									HX_STACK_LINE(751)
									::String _g30 = (HX_CSTRING("(") + _g29);		HX_STACK_VAR(_g30,"_g30");
									HX_STACK_LINE(751)
									::String _g31 = (_g30 + HX_CSTRING(")."));		HX_STACK_VAR(_g31,"_g31");
									HX_STACK_LINE(751)
									line = _g31;
								}
								HX_STACK_LINE(751)
								_g32 = (log + line);
							}
						}
					}
				}
				HX_STACK_LINE(751)
				HX_STACK_DO_THROW((_g27 + _g32));
			}
			else{
				HX_STACK_LINE(755)
				::String _g37;		HX_STACK_VAR(_g37,"_g37");
				HX_STACK_LINE(755)
				{
					HX_STACK_LINE(755)
					::String log = ::openfl::gl::GL_obj::lime_gl_get_shader_info_log(s->id);		HX_STACK_VAR(log,"log");
					HX_STACK_LINE(755)
					if (((log == null()))){
						HX_STACK_LINE(755)
						_g37 = HX_CSTRING("");
					}
					else{
						HX_STACK_LINE(755)
						Array< ::String > lines = code.split(HX_CSTRING("\n"));		HX_STACK_VAR(lines,"lines");
						HX_STACK_LINE(755)
						::String _g33 = log.substr((int)9,null());		HX_STACK_VAR(_g33,"_g33");
						HX_STACK_LINE(755)
						Dynamic index = ::Std_obj::parseInt(_g33);		HX_STACK_VAR(index,"index");
						HX_STACK_LINE(755)
						if (((index == null()))){
							HX_STACK_LINE(755)
							_g37 = HX_CSTRING("");
						}
						else{
							HX_STACK_LINE(755)
							(index)--;
							HX_STACK_LINE(755)
							if (((lines->__get(index) == null()))){
								HX_STACK_LINE(755)
								_g37 = HX_CSTRING("");
							}
							else{
								HX_STACK_LINE(755)
								::String line = lines->__get(index);		HX_STACK_VAR(line,"line");
								HX_STACK_LINE(755)
								if (((line == null()))){
									HX_STACK_LINE(755)
									line = HX_CSTRING("-");
								}
								else{
									HX_STACK_LINE(755)
									::String _g34 = ::StringTools_obj::trim(line);		HX_STACK_VAR(_g34,"_g34");
									HX_STACK_LINE(755)
									::String _g35 = (HX_CSTRING("(") + _g34);		HX_STACK_VAR(_g35,"_g35");
									HX_STACK_LINE(755)
									::String _g36 = (_g35 + HX_CSTRING(")."));		HX_STACK_VAR(_g36,"_g36");
									HX_STACK_LINE(755)
									line = _g36;
								}
								HX_STACK_LINE(755)
								_g37 = (log + line);
							}
						}
					}
				}
				HX_STACK_LINE(755)
				Dynamic msg = (HX_CSTRING("compile shaderInfoLog ok:") + _g37);		HX_STACK_VAR(msg,"msg");
				HX_STACK_LINE(755)
				::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
				HX_STACK_LINE(755)
				int pos_lineNumber = (int)755;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
				HX_STACK_LINE(755)
				::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
				HX_STACK_LINE(755)
				::String pos_methodName = HX_CSTRING("buildShaderInstance");		HX_STACK_VAR(pos_methodName,"pos_methodName");
				HX_STACK_LINE(755)
				if (((::hxd::System_obj::debugLevel >= (int)3))){
					HX_STACK_LINE(755)
					::String _g38 = ::Std_obj::string(msg);		HX_STACK_VAR(_g38,"_g38");
					HX_STACK_LINE(755)
					::String _g39 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g38);		HX_STACK_VAR(_g39,"_g39");
					HX_STACK_LINE(755)
					::haxe::Log_obj::trace(_g39,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
				}
				HX_STACK_LINE(755)
				msg;
			}
			HX_STACK_LINE(758)
			return s;
		}
		return null();
	}
	HX_END_LOCAL_FUNC1(return)

	HX_STACK_LINE(707)
	Dynamic compileShader =  Dynamic(new _Function_1_1(cl,fullCode,shader1));		HX_STACK_VAR(compileShader,"compileShader");
	HX_STACK_LINE(761)
	::openfl::gl::GLShader vs = compileShader((int)35633).Cast< ::openfl::gl::GLShader >();		HX_STACK_VAR(vs,"vs");
	HX_STACK_LINE(762)
	::openfl::gl::GLShader fs = compileShader((int)35632).Cast< ::openfl::gl::GLShader >();		HX_STACK_VAR(fs,"fs");
	HX_STACK_LINE(764)
	int _g40 = ::openfl::gl::GL_obj::get_version();		HX_STACK_VAR(_g40,"_g40");
	HX_STACK_LINE(764)
	Dynamic _g41 = ::openfl::gl::GL_obj::lime_gl_create_program();		HX_STACK_VAR(_g41,"_g41");
	HX_STACK_LINE(764)
	::openfl::gl::GLProgram p = ::openfl::gl::GLProgram_obj::__new(_g40,_g41);		HX_STACK_VAR(p,"p");
	HX_STACK_LINE(767)
	::openfl::gl::GL_obj::lime_gl_bind_attrib_location(p->id,(int)0,HX_CSTRING("pos"));
	HX_STACK_LINE(768)
	::openfl::gl::GL_obj::lime_gl_bind_attrib_location(p->id,(int)1,HX_CSTRING("uv"));
	HX_STACK_LINE(769)
	::openfl::gl::GL_obj::lime_gl_bind_attrib_location(p->id,(int)2,HX_CSTRING("normal"));
	HX_STACK_LINE(770)
	::openfl::gl::GL_obj::lime_gl_bind_attrib_location(p->id,(int)3,HX_CSTRING("color"));
	HX_STACK_LINE(771)
	::openfl::gl::GL_obj::lime_gl_bind_attrib_location(p->id,(int)4,HX_CSTRING("weights"));
	HX_STACK_LINE(772)
	::openfl::gl::GL_obj::lime_gl_bind_attrib_location(p->id,(int)5,HX_CSTRING("indexes"));
	HX_STACK_LINE(774)
	{
		HX_STACK_LINE(774)
		p->attach(vs);
		HX_STACK_LINE(774)
		::openfl::gl::GL_obj::lime_gl_attach_shader(p->id,vs->id);
	}
	HX_STACK_LINE(775)
	{
		HX_STACK_LINE(775)
		int _g42 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g42,"_g42");
		HX_STACK_LINE(775)
		if (((_g42 != (int)0))){
			HX_STACK_LINE(775)
			::String s;		HX_STACK_VAR(s,"s");
			HX_STACK_LINE(775)
			{
				HX_STACK_LINE(775)
				int _g1 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(775)
				switch( (int)(_g1)){
					case (int)0: {
						HX_STACK_LINE(775)
						s = null();
					}
					;break;
					case (int)1280: {
						HX_STACK_LINE(775)
						s = HX_CSTRING("INVALID_ENUM");
					}
					;break;
					case (int)1281: {
						HX_STACK_LINE(775)
						s = HX_CSTRING("INVALID_VALUE");
					}
					;break;
					case (int)1282: {
						HX_STACK_LINE(775)
						s = HX_CSTRING("INVALID_OPERATION");
					}
					;break;
					case (int)1285: {
						HX_STACK_LINE(775)
						s = HX_CSTRING("OUT_OF_MEMORY");
					}
					;break;
					default: {
						HX_STACK_LINE(775)
						s = null();
					}
				}
			}
			HX_STACK_LINE(775)
			if (((s != null()))){
				HX_STACK_LINE(775)
				::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
				HX_STACK_LINE(775)
				::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
				HX_STACK_LINE(775)
				HX_STACK_DO_THROW(s);
			}
		}
	}
	HX_STACK_LINE(777)
	{
		HX_STACK_LINE(777)
		::String _g48;		HX_STACK_VAR(_g48,"_g48");
		HX_STACK_LINE(777)
		{
			HX_STACK_LINE(777)
			::String log = ::openfl::gl::GL_obj::lime_gl_get_program_info_log(p->id);		HX_STACK_VAR(log,"log");
			HX_STACK_LINE(777)
			::String hnt = log.substr((int)26,null());		HX_STACK_VAR(hnt,"hnt");
			HX_STACK_LINE(777)
			Array< ::String > _g43 = fullCode->__get((int)0).split(HX_CSTRING("\n"));		HX_STACK_VAR(_g43,"_g43");
			HX_STACK_LINE(777)
			Dynamic _g44 = ::Std_obj::parseInt(hnt);		HX_STACK_VAR(_g44,"_g44");
			HX_STACK_LINE(777)
			::String line = _g43->__get(_g44);		HX_STACK_VAR(line,"line");
			HX_STACK_LINE(777)
			if (((line == null()))){
				HX_STACK_LINE(777)
				line = HX_CSTRING("-");
			}
			else{
				HX_STACK_LINE(777)
				::String _g45 = ::StringTools_obj::trim(line);		HX_STACK_VAR(_g45,"_g45");
				HX_STACK_LINE(777)
				::String _g46 = (HX_CSTRING("(") + _g45);		HX_STACK_VAR(_g46,"_g46");
				HX_STACK_LINE(777)
				::String _g47 = (_g46 + HX_CSTRING(")."));		HX_STACK_VAR(_g47,"_g47");
				HX_STACK_LINE(777)
				line = _g47;
			}
			HX_STACK_LINE(777)
			_g48 = (log + line);
		}
		HX_STACK_LINE(777)
		Dynamic msg = (HX_CSTRING("attach vs programInfoLog:") + _g48);		HX_STACK_VAR(msg,"msg");
		HX_STACK_LINE(777)
		::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
		HX_STACK_LINE(777)
		int pos_lineNumber = (int)777;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
		HX_STACK_LINE(777)
		::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
		HX_STACK_LINE(777)
		::String pos_methodName = HX_CSTRING("buildShaderInstance");		HX_STACK_VAR(pos_methodName,"pos_methodName");
		HX_STACK_LINE(777)
		if (((::hxd::System_obj::debugLevel >= (int)3))){
			HX_STACK_LINE(777)
			::String _g49 = ::Std_obj::string(msg);		HX_STACK_VAR(_g49,"_g49");
			HX_STACK_LINE(777)
			::String _g50 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g49);		HX_STACK_VAR(_g50,"_g50");
			HX_STACK_LINE(777)
			::haxe::Log_obj::trace(_g50,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
		}
		HX_STACK_LINE(777)
		msg;
	}
	HX_STACK_LINE(779)
	{
		HX_STACK_LINE(779)
		p->attach(fs);
		HX_STACK_LINE(779)
		::openfl::gl::GL_obj::lime_gl_attach_shader(p->id,fs->id);
	}
	HX_STACK_LINE(780)
	{
		HX_STACK_LINE(780)
		int _g51 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g51,"_g51");
		HX_STACK_LINE(780)
		if (((_g51 != (int)0))){
			HX_STACK_LINE(780)
			::String s;		HX_STACK_VAR(s,"s");
			HX_STACK_LINE(780)
			{
				HX_STACK_LINE(780)
				int _g1 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(780)
				switch( (int)(_g1)){
					case (int)0: {
						HX_STACK_LINE(780)
						s = null();
					}
					;break;
					case (int)1280: {
						HX_STACK_LINE(780)
						s = HX_CSTRING("INVALID_ENUM");
					}
					;break;
					case (int)1281: {
						HX_STACK_LINE(780)
						s = HX_CSTRING("INVALID_VALUE");
					}
					;break;
					case (int)1282: {
						HX_STACK_LINE(780)
						s = HX_CSTRING("INVALID_OPERATION");
					}
					;break;
					case (int)1285: {
						HX_STACK_LINE(780)
						s = HX_CSTRING("OUT_OF_MEMORY");
					}
					;break;
					default: {
						HX_STACK_LINE(780)
						s = null();
					}
				}
			}
			HX_STACK_LINE(780)
			if (((s != null()))){
				HX_STACK_LINE(780)
				::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
				HX_STACK_LINE(780)
				::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
				HX_STACK_LINE(780)
				HX_STACK_DO_THROW(s);
			}
		}
	}
	HX_STACK_LINE(782)
	{
		HX_STACK_LINE(782)
		::String _g57;		HX_STACK_VAR(_g57,"_g57");
		HX_STACK_LINE(782)
		{
			HX_STACK_LINE(782)
			::String log = ::openfl::gl::GL_obj::lime_gl_get_program_info_log(p->id);		HX_STACK_VAR(log,"log");
			HX_STACK_LINE(782)
			::String hnt = log.substr((int)26,null());		HX_STACK_VAR(hnt,"hnt");
			HX_STACK_LINE(782)
			Array< ::String > _g52 = fullCode->__get((int)0).split(HX_CSTRING("\n"));		HX_STACK_VAR(_g52,"_g52");
			HX_STACK_LINE(782)
			Dynamic _g53 = ::Std_obj::parseInt(hnt);		HX_STACK_VAR(_g53,"_g53");
			HX_STACK_LINE(782)
			::String line = _g52->__get(_g53);		HX_STACK_VAR(line,"line");
			HX_STACK_LINE(782)
			if (((line == null()))){
				HX_STACK_LINE(782)
				line = HX_CSTRING("-");
			}
			else{
				HX_STACK_LINE(782)
				::String _g54 = ::StringTools_obj::trim(line);		HX_STACK_VAR(_g54,"_g54");
				HX_STACK_LINE(782)
				::String _g55 = (HX_CSTRING("(") + _g54);		HX_STACK_VAR(_g55,"_g55");
				HX_STACK_LINE(782)
				::String _g56 = (_g55 + HX_CSTRING(")."));		HX_STACK_VAR(_g56,"_g56");
				HX_STACK_LINE(782)
				line = _g56;
			}
			HX_STACK_LINE(782)
			_g57 = (log + line);
		}
		HX_STACK_LINE(782)
		Dynamic msg = (HX_CSTRING("attach fs programInfoLog:") + _g57);		HX_STACK_VAR(msg,"msg");
		HX_STACK_LINE(782)
		::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
		HX_STACK_LINE(782)
		int pos_lineNumber = (int)782;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
		HX_STACK_LINE(782)
		::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
		HX_STACK_LINE(782)
		::String pos_methodName = HX_CSTRING("buildShaderInstance");		HX_STACK_VAR(pos_methodName,"pos_methodName");
		HX_STACK_LINE(782)
		if (((::hxd::System_obj::debugLevel >= (int)3))){
			HX_STACK_LINE(782)
			::String _g58 = ::Std_obj::string(msg);		HX_STACK_VAR(_g58,"_g58");
			HX_STACK_LINE(782)
			::String _g59 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g58);		HX_STACK_VAR(_g59,"_g59");
			HX_STACK_LINE(782)
			::haxe::Log_obj::trace(_g59,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
		}
		HX_STACK_LINE(782)
		msg;
	}
	HX_STACK_LINE(784)
	::openfl::gl::GL_obj::lime_gl_link_program(p->id);
	HX_STACK_LINE(785)
	{
		HX_STACK_LINE(785)
		int _g60 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g60,"_g60");
		HX_STACK_LINE(785)
		if (((_g60 != (int)0))){
			HX_STACK_LINE(785)
			::String s;		HX_STACK_VAR(s,"s");
			HX_STACK_LINE(785)
			{
				HX_STACK_LINE(785)
				int _g1 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(785)
				switch( (int)(_g1)){
					case (int)0: {
						HX_STACK_LINE(785)
						s = null();
					}
					;break;
					case (int)1280: {
						HX_STACK_LINE(785)
						s = HX_CSTRING("INVALID_ENUM");
					}
					;break;
					case (int)1281: {
						HX_STACK_LINE(785)
						s = HX_CSTRING("INVALID_VALUE");
					}
					;break;
					case (int)1282: {
						HX_STACK_LINE(785)
						s = HX_CSTRING("INVALID_OPERATION");
					}
					;break;
					case (int)1285: {
						HX_STACK_LINE(785)
						s = HX_CSTRING("OUT_OF_MEMORY");
					}
					;break;
					default: {
						HX_STACK_LINE(785)
						s = null();
					}
				}
			}
			HX_STACK_LINE(785)
			if (((s != null()))){
				HX_STACK_LINE(785)
				::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
				HX_STACK_LINE(785)
				::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
				HX_STACK_LINE(785)
				HX_STACK_DO_THROW(s);
			}
		}
	}
	HX_STACK_LINE(787)
	{
		HX_STACK_LINE(787)
		::String _g66;		HX_STACK_VAR(_g66,"_g66");
		HX_STACK_LINE(787)
		{
			HX_STACK_LINE(787)
			::String log = ::openfl::gl::GL_obj::lime_gl_get_program_info_log(p->id);		HX_STACK_VAR(log,"log");
			HX_STACK_LINE(787)
			::String hnt = log.substr((int)26,null());		HX_STACK_VAR(hnt,"hnt");
			HX_STACK_LINE(787)
			Array< ::String > _g61 = fullCode->__get((int)0).split(HX_CSTRING("\n"));		HX_STACK_VAR(_g61,"_g61");
			HX_STACK_LINE(787)
			Dynamic _g62 = ::Std_obj::parseInt(hnt);		HX_STACK_VAR(_g62,"_g62");
			HX_STACK_LINE(787)
			::String line = _g61->__get(_g62);		HX_STACK_VAR(line,"line");
			HX_STACK_LINE(787)
			if (((line == null()))){
				HX_STACK_LINE(787)
				line = HX_CSTRING("-");
			}
			else{
				HX_STACK_LINE(787)
				::String _g63 = ::StringTools_obj::trim(line);		HX_STACK_VAR(_g63,"_g63");
				HX_STACK_LINE(787)
				::String _g64 = (HX_CSTRING("(") + _g63);		HX_STACK_VAR(_g64,"_g64");
				HX_STACK_LINE(787)
				::String _g65 = (_g64 + HX_CSTRING(")."));		HX_STACK_VAR(_g65,"_g65");
				HX_STACK_LINE(787)
				line = _g65;
			}
			HX_STACK_LINE(787)
			_g66 = (log + line);
		}
		HX_STACK_LINE(787)
		Dynamic msg = (HX_CSTRING("link programInfoLog:") + _g66);		HX_STACK_VAR(msg,"msg");
		HX_STACK_LINE(787)
		::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
		HX_STACK_LINE(787)
		int pos_lineNumber = (int)787;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
		HX_STACK_LINE(787)
		::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
		HX_STACK_LINE(787)
		::String pos_methodName = HX_CSTRING("buildShaderInstance");		HX_STACK_VAR(pos_methodName,"pos_methodName");
		HX_STACK_LINE(787)
		if (((::hxd::System_obj::debugLevel >= (int)3))){
			HX_STACK_LINE(787)
			::String _g67 = ::Std_obj::string(msg);		HX_STACK_VAR(_g67,"_g67");
			HX_STACK_LINE(787)
			::String _g68 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g67);		HX_STACK_VAR(_g68,"_g68");
			HX_STACK_LINE(787)
			::haxe::Log_obj::trace(_g68,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
		}
		HX_STACK_LINE(787)
		msg;
	}
	HX_STACK_LINE(789)
	int _g69 = ::openfl::gl::GL_obj::lime_gl_get_program_parameter(p->id,(int)35714);		HX_STACK_VAR(_g69,"_g69");
	HX_STACK_LINE(789)
	if (((_g69 != (int)1))){
		HX_STACK_LINE(790)
		::String log = ::openfl::gl::GL_obj::lime_gl_get_program_info_log(p->id);		HX_STACK_VAR(log,"log");
		HX_STACK_LINE(791)
		HX_STACK_DO_THROW((HX_CSTRING("Program linkage failure: ") + log));
	}
	else{
		HX_STACK_LINE(794)
		::String _g75;		HX_STACK_VAR(_g75,"_g75");
		HX_STACK_LINE(794)
		{
			HX_STACK_LINE(794)
			::String log = ::openfl::gl::GL_obj::lime_gl_get_program_info_log(p->id);		HX_STACK_VAR(log,"log");
			HX_STACK_LINE(794)
			::String hnt = log.substr((int)26,null());		HX_STACK_VAR(hnt,"hnt");
			HX_STACK_LINE(794)
			Array< ::String > _g70 = fullCode->__get((int)0).split(HX_CSTRING("\n"));		HX_STACK_VAR(_g70,"_g70");
			HX_STACK_LINE(794)
			Dynamic _g71 = ::Std_obj::parseInt(hnt);		HX_STACK_VAR(_g71,"_g71");
			HX_STACK_LINE(794)
			::String line = _g70->__get(_g71);		HX_STACK_VAR(line,"line");
			HX_STACK_LINE(794)
			if (((line == null()))){
				HX_STACK_LINE(794)
				line = HX_CSTRING("-");
			}
			else{
				HX_STACK_LINE(794)
				::String _g72 = ::StringTools_obj::trim(line);		HX_STACK_VAR(_g72,"_g72");
				HX_STACK_LINE(794)
				::String _g73 = (HX_CSTRING("(") + _g72);		HX_STACK_VAR(_g73,"_g73");
				HX_STACK_LINE(794)
				::String _g74 = (_g73 + HX_CSTRING(")."));		HX_STACK_VAR(_g74,"_g74");
				HX_STACK_LINE(794)
				line = _g74;
			}
			HX_STACK_LINE(794)
			_g75 = (log + line);
		}
		HX_STACK_LINE(794)
		Dynamic msg = (HX_CSTRING("linked programInfoLog:") + _g75);		HX_STACK_VAR(msg,"msg");
		HX_STACK_LINE(794)
		::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
		HX_STACK_LINE(794)
		int pos_lineNumber = (int)794;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
		HX_STACK_LINE(794)
		::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
		HX_STACK_LINE(794)
		::String pos_methodName = HX_CSTRING("buildShaderInstance");		HX_STACK_VAR(pos_methodName,"pos_methodName");
		HX_STACK_LINE(794)
		if (((::hxd::System_obj::debugLevel >= (int)3))){
			HX_STACK_LINE(794)
			::String _g76 = ::Std_obj::string(msg);		HX_STACK_VAR(_g76,"_g76");
			HX_STACK_LINE(794)
			::String _g77 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g76);		HX_STACK_VAR(_g77,"_g77");
			HX_STACK_LINE(794)
			::haxe::Log_obj::trace(_g77,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
		}
		HX_STACK_LINE(794)
		msg;
	}
	HX_STACK_LINE(797)
	{
		HX_STACK_LINE(797)
		int _g78 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g78,"_g78");
		HX_STACK_LINE(797)
		if (((_g78 != (int)0))){
			HX_STACK_LINE(797)
			::String s;		HX_STACK_VAR(s,"s");
			HX_STACK_LINE(797)
			{
				HX_STACK_LINE(797)
				int _g1 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(797)
				switch( (int)(_g1)){
					case (int)0: {
						HX_STACK_LINE(797)
						s = null();
					}
					;break;
					case (int)1280: {
						HX_STACK_LINE(797)
						s = HX_CSTRING("INVALID_ENUM");
					}
					;break;
					case (int)1281: {
						HX_STACK_LINE(797)
						s = HX_CSTRING("INVALID_VALUE");
					}
					;break;
					case (int)1282: {
						HX_STACK_LINE(797)
						s = HX_CSTRING("INVALID_OPERATION");
					}
					;break;
					case (int)1285: {
						HX_STACK_LINE(797)
						s = HX_CSTRING("OUT_OF_MEMORY");
					}
					;break;
					default: {
						HX_STACK_LINE(797)
						s = null();
					}
				}
			}
			HX_STACK_LINE(797)
			if (((s != null()))){
				HX_STACK_LINE(797)
				::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
				HX_STACK_LINE(797)
				::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
				HX_STACK_LINE(797)
				HX_STACK_DO_THROW(s);
			}
		}
	}
	HX_STACK_LINE(799)
	::h3d::impl::ShaderInstance inst = ::h3d::impl::ShaderInstance_obj::__new();		HX_STACK_VAR(inst,"inst");
	HX_STACK_LINE(801)
	int nattr = ::openfl::gl::GL_obj::lime_gl_get_program_parameter(p->id,(int)35721);		HX_STACK_VAR(nattr,"nattr");
	HX_STACK_LINE(802)
	inst->attribs = Array_obj< ::Dynamic >::__new();
	HX_STACK_LINE(804)
	::haxe::ds::StringMap amap = ::haxe::ds::StringMap_obj::__new();		HX_STACK_VAR(amap,"amap");
	HX_STACK_LINE(805)
	{
		HX_STACK_LINE(805)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(805)
		while((true)){
			HX_STACK_LINE(805)
			if ((!(((_g1 < nattr))))){
				HX_STACK_LINE(805)
				break;
			}
			HX_STACK_LINE(805)
			int k = (_g1)++;		HX_STACK_VAR(k,"k");
			HX_STACK_LINE(806)
			Dynamic inf = ::openfl::gl::GL_obj::lime_gl_get_active_attrib(p->id,k);		HX_STACK_VAR(inf,"inf");
			HX_STACK_LINE(807)
			{
				HX_STACK_LINE(807)
				int _g79 = ::openfl::gl::GL_obj::lime_gl_get_attrib_location(p->id,inf->__Field(HX_CSTRING("name"),true));		HX_STACK_VAR(_g79,"_g79");
				struct _Function_4_1{
					inline static Dynamic Block( int &_g79,Dynamic &inf){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/impl/GlDriver.hx",807,0xae6eb278)
						{
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("index") , _g79,false);
							__result->Add(HX_CSTRING("inf") , inf,false);
							return __result;
						}
						return null();
					}
				};
				HX_STACK_LINE(807)
				Dynamic value = _Function_4_1::Block(_g79,inf);		HX_STACK_VAR(value,"value");
				HX_STACK_LINE(807)
				amap->set(inf->__Field(HX_CSTRING("name"),true),value);
			}
			HX_STACK_LINE(808)
			{
				HX_STACK_LINE(808)
				::String _g80 = ::Std_obj::string(inf);		HX_STACK_VAR(_g80,"_g80");
				HX_STACK_LINE(808)
				::String _ = (HX_CSTRING("adding attributes ") + _g80);		HX_STACK_VAR(_,"_");
				HX_STACK_LINE(808)
				Dynamic();
			}
			HX_STACK_LINE(809)
			{
				HX_STACK_LINE(809)
				int _g81 = ::openfl::gl::GL_obj::lime_gl_get_attrib_location(p->id,inf->__Field(HX_CSTRING("name"),true));		HX_STACK_VAR(_g81,"_g81");
				HX_STACK_LINE(809)
				::String _ = (HX_CSTRING("attr loc ") + _g81);		HX_STACK_VAR(_,"_");
				HX_STACK_LINE(809)
				Dynamic();
			}
		}
	}
	HX_STACK_LINE(813)
	::String code = ::openfl::gl::GL_obj::lime_gl_get_shader_source(vs->id);		HX_STACK_VAR(code,"code");
	HX_STACK_LINE(816)
	::EReg rdef = ::EReg_obj::__new(HX_CSTRING("#define ([A-Za-z0-9_]+)"),HX_CSTRING(""));		HX_STACK_VAR(rdef,"rdef");
	HX_STACK_LINE(817)
	::haxe::ds::StringMap defs = ::haxe::ds::StringMap_obj::__new();		HX_STACK_VAR(defs,"defs");
	HX_STACK_LINE(818)
	while((true)){
		HX_STACK_LINE(818)
		if ((!(rdef->match(code)))){
			HX_STACK_LINE(818)
			break;
		}
		HX_STACK_LINE(819)
		{
			HX_STACK_LINE(819)
			::String key = rdef->matched((int)1);		HX_STACK_VAR(key,"key");
			HX_STACK_LINE(819)
			defs->set(key,true);
		}
		HX_STACK_LINE(820)
		::String _g82 = rdef->matchedLeft();		HX_STACK_VAR(_g82,"_g82");
		HX_STACK_LINE(820)
		::String _g83 = rdef->matchedRight();		HX_STACK_VAR(_g83,"_g83");
		HX_STACK_LINE(820)
		::String _g84 = (_g82 + _g83);		HX_STACK_VAR(_g84,"_g84");
		HX_STACK_LINE(820)
		code = _g84;
	}
	HX_STACK_LINE(824)
	::EReg rif = ::EReg_obj::__new(HX_CSTRING("#if defined\\(([A-Za-z0-9_]+)\\)([^#]+)#endif"),HX_CSTRING(""));		HX_STACK_VAR(rif,"rif");
	HX_STACK_LINE(825)
	while((true)){
		HX_STACK_LINE(825)
		if ((!(rif->match(code)))){
			HX_STACK_LINE(825)
			break;
		}
		struct _Function_2_1{
			inline static Dynamic Block( ::EReg &rif,::haxe::ds::StringMap &defs){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/impl/GlDriver.hx",826,0xae6eb278)
				{
					HX_STACK_LINE(826)
					::String key = rif->matched((int)1);		HX_STACK_VAR(key,"key");
					HX_STACK_LINE(826)
					return defs->get(key);
				}
				return null();
			}
		};
		HX_STACK_LINE(826)
		if ((_Function_2_1::Block(rif,defs))){
			HX_STACK_LINE(827)
			::String _g85 = rif->matchedLeft();		HX_STACK_VAR(_g85,"_g85");
			HX_STACK_LINE(827)
			::String _g86 = rif->matched((int)2);		HX_STACK_VAR(_g86,"_g86");
			HX_STACK_LINE(827)
			::String _g87 = (_g85 + _g86);		HX_STACK_VAR(_g87,"_g87");
			HX_STACK_LINE(827)
			::String _g88 = rif->matchedRight();		HX_STACK_VAR(_g88,"_g88");
			HX_STACK_LINE(827)
			::String _g89 = (_g87 + _g88);		HX_STACK_VAR(_g89,"_g89");
			HX_STACK_LINE(827)
			code = _g89;
		}
		else{
			HX_STACK_LINE(829)
			::String _g90 = rif->matchedLeft();		HX_STACK_VAR(_g90,"_g90");
			HX_STACK_LINE(829)
			::String _g91 = rif->matchedRight();		HX_STACK_VAR(_g91,"_g91");
			HX_STACK_LINE(829)
			::String _g92 = (_g90 + _g91);		HX_STACK_VAR(_g92,"_g92");
			HX_STACK_LINE(829)
			code = _g92;
		}
	}
	HX_STACK_LINE(833)
	::EReg r = ::EReg_obj::__new(HX_CSTRING("attribute[ \t\r\n]+([A-Za-z0-9_]+)[ \t\r\n]+([A-Za-z0-9_]+)"),HX_CSTRING(""));		HX_STACK_VAR(r,"r");
	HX_STACK_LINE(834)
	int offset = (int)0;		HX_STACK_VAR(offset,"offset");
	HX_STACK_LINE(835)
	::String ccode = code;		HX_STACK_VAR(ccode,"ccode");
	HX_STACK_LINE(836)
	while((true)){
		HX_STACK_LINE(836)
		if ((!(r->match(ccode)))){
			HX_STACK_LINE(836)
			break;
		}
		HX_STACK_LINE(837)
		::String aname = r->matched((int)2);		HX_STACK_VAR(aname,"aname");
		HX_STACK_LINE(838)
		::String _g93 = r->matched((int)1);		HX_STACK_VAR(_g93,"_g93");
		HX_STACK_LINE(838)
		::h3d::impl::ShaderType atype = this->decodeType(_g93);		HX_STACK_VAR(atype,"atype");
		HX_STACK_LINE(839)
		Dynamic a = amap->get(aname);		HX_STACK_VAR(a,"a");
		HX_STACK_LINE(840)
		int size = this->typeSize(atype);		HX_STACK_VAR(size,"size");
		HX_STACK_LINE(841)
		if (((a != null()))){
			HX_STACK_LINE(843)
			int etype = (int)5126;		HX_STACK_VAR(etype,"etype");
			HX_STACK_LINE(844)
			::String com = this->findVarComment(aname,ccode);		HX_STACK_VAR(com,"com");
			HX_STACK_LINE(845)
			if (((com != null()))){
				HX_STACK_LINE(847)
				if ((::StringTools_obj::startsWith(com,HX_CSTRING("byte")))){
					HX_STACK_LINE(848)
					etype = (int)5121;
				}
			}
			else{
			}
			HX_STACK_LINE(855)
			{
				HX_STACK_LINE(855)
				Dynamic msg = (HX_CSTRING("setting attribute offset ") + offset);		HX_STACK_VAR(msg,"msg");
				HX_STACK_LINE(855)
				::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
				HX_STACK_LINE(855)
				int pos_lineNumber = (int)855;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
				HX_STACK_LINE(855)
				::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
				HX_STACK_LINE(855)
				::String pos_methodName = HX_CSTRING("buildShaderInstance");		HX_STACK_VAR(pos_methodName,"pos_methodName");
				HX_STACK_LINE(855)
				if (((::hxd::System_obj::debugLevel >= (int)3))){
					HX_STACK_LINE(855)
					::String _g94 = ::Std_obj::string(msg);		HX_STACK_VAR(_g94,"_g94");
					HX_STACK_LINE(855)
					::String _g95 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g94);		HX_STACK_VAR(_g95,"_g95");
					HX_STACK_LINE(855)
					::haxe::Log_obj::trace(_g95,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
				}
				HX_STACK_LINE(855)
				msg;
			}
			HX_STACK_LINE(856)
			::h3d::impl::Attribute _g96 = ::h3d::impl::Attribute_obj::__new(aname,atype,etype,offset,a->__Field(HX_CSTRING("index"),true),size);		HX_STACK_VAR(_g96,"_g96");
			HX_STACK_LINE(856)
			inst->attribs->push(_g96);
			HX_STACK_LINE(857)
			hx::AddEq(offset,size);
		}
		else{
			HX_STACK_LINE(859)
			Dynamic msg = (HX_CSTRING("skipping attribute ") + aname);		HX_STACK_VAR(msg,"msg");
			HX_STACK_LINE(859)
			::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
			HX_STACK_LINE(859)
			int pos_lineNumber = (int)859;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
			HX_STACK_LINE(859)
			::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
			HX_STACK_LINE(859)
			::String pos_methodName = HX_CSTRING("buildShaderInstance");		HX_STACK_VAR(pos_methodName,"pos_methodName");
			HX_STACK_LINE(859)
			if (((::hxd::System_obj::debugLevel >= (int)3))){
				HX_STACK_LINE(859)
				::String _g97 = ::Std_obj::string(msg);		HX_STACK_VAR(_g97,"_g97");
				HX_STACK_LINE(859)
				::String _g98 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g97);		HX_STACK_VAR(_g98,"_g98");
				HX_STACK_LINE(859)
				::haxe::Log_obj::trace(_g98,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
			}
			HX_STACK_LINE(859)
			msg;
		}
		HX_STACK_LINE(860)
		::String _g99 = r->matchedRight();		HX_STACK_VAR(_g99,"_g99");
		HX_STACK_LINE(860)
		ccode = _g99;
	}
	HX_STACK_LINE(862)
	inst->stride = offset;
	HX_STACK_LINE(865)
	::String _g100 = ::openfl::gl::GL_obj::lime_gl_get_shader_source(fs->id);		HX_STACK_VAR(_g100,"_g100");
	HX_STACK_LINE(865)
	::String allCode = (code + _g100);		HX_STACK_VAR(allCode,"allCode");
	HX_STACK_LINE(867)
	int nuni = ::openfl::gl::GL_obj::lime_gl_get_program_parameter(p->id,(int)35718);		HX_STACK_VAR(nuni,"nuni");
	HX_STACK_LINE(868)
	inst->uniforms = Array_obj< ::Dynamic >::__new();
	HX_STACK_LINE(870)
	::h3d::impl::UniformContext _g101 = ::h3d::impl::UniformContext_obj::__new((int)-1,null());		HX_STACK_VAR(_g101,"_g101");
	HX_STACK_LINE(870)
	this->parseUniInfo = _g101;
	HX_STACK_LINE(871)
	{
		HX_STACK_LINE(871)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(871)
		while((true)){
			HX_STACK_LINE(871)
			if ((!(((_g1 < nuni))))){
				HX_STACK_LINE(871)
				break;
			}
			HX_STACK_LINE(871)
			int k = (_g1)++;		HX_STACK_VAR(k,"k");
			HX_STACK_LINE(872)
			Dynamic _g102 = ::openfl::gl::GL_obj::lime_gl_get_active_uniform(p->id,k);		HX_STACK_VAR(_g102,"_g102");
			HX_STACK_LINE(872)
			::h3d::impl::GLActiveInfo _g103 = ::h3d::impl::GLActiveInfo_obj::__new(_g102);		HX_STACK_VAR(_g103,"_g103");
			HX_STACK_LINE(872)
			this->parseUniInfo->inf = _g103;
			HX_STACK_LINE(874)
			::String _g104 = this->parseUniInfo->inf->name.substr((int)0,(int)6);		HX_STACK_VAR(_g104,"_g104");
			HX_STACK_LINE(874)
			if (((_g104 == HX_CSTRING("webgl_")))){
				HX_STACK_LINE(874)
				continue;
			}
			HX_STACK_LINE(875)
			::String _g105 = this->parseUniInfo->inf->name.substr((int)0,(int)3);		HX_STACK_VAR(_g105,"_g105");
			HX_STACK_LINE(875)
			if (((_g105 == HX_CSTRING("gl_")))){
				HX_STACK_LINE(875)
				continue;
			}
			HX_STACK_LINE(877)
			::h3d::impl::Uniform tu = this->parseUniform(allCode,p);		HX_STACK_VAR(tu,"tu");
			HX_STACK_LINE(878)
			inst->uniforms->push(tu);
			HX_STACK_LINE(879)
			{
				HX_STACK_LINE(879)
				::String _g106 = ::Std_obj::string(tu->type);		HX_STACK_VAR(_g106,"_g106");
				HX_STACK_LINE(879)
				::String _g107 = (((HX_CSTRING("adding uniform ") + tu->name) + HX_CSTRING(" ")) + _g106);		HX_STACK_VAR(_g107,"_g107");
				HX_STACK_LINE(879)
				::String _g108 = (_g107 + HX_CSTRING(" "));		HX_STACK_VAR(_g108,"_g108");
				HX_STACK_LINE(879)
				::String _g109 = ::Std_obj::string(tu->loc);		HX_STACK_VAR(_g109,"_g109");
				HX_STACK_LINE(879)
				::String _g110 = (_g108 + _g109);		HX_STACK_VAR(_g110,"_g110");
				HX_STACK_LINE(879)
				::String _g111 = (_g110 + HX_CSTRING(" "));		HX_STACK_VAR(_g111,"_g111");
				HX_STACK_LINE(879)
				::String _ = (_g111 + tu->index);		HX_STACK_VAR(_,"_");
				HX_STACK_LINE(879)
				Dynamic();
			}
		}
	}
	HX_STACK_LINE(882)
	inst->program = p;
	HX_STACK_LINE(883)
	{
		HX_STACK_LINE(883)
		int _g112 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g112,"_g112");
		HX_STACK_LINE(883)
		if (((_g112 != (int)0))){
			HX_STACK_LINE(883)
			::String s;		HX_STACK_VAR(s,"s");
			HX_STACK_LINE(883)
			{
				HX_STACK_LINE(883)
				int _g1 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(883)
				switch( (int)(_g1)){
					case (int)0: {
						HX_STACK_LINE(883)
						s = null();
					}
					;break;
					case (int)1280: {
						HX_STACK_LINE(883)
						s = HX_CSTRING("INVALID_ENUM");
					}
					;break;
					case (int)1281: {
						HX_STACK_LINE(883)
						s = HX_CSTRING("INVALID_VALUE");
					}
					;break;
					case (int)1282: {
						HX_STACK_LINE(883)
						s = HX_CSTRING("INVALID_OPERATION");
					}
					;break;
					case (int)1285: {
						HX_STACK_LINE(883)
						s = HX_CSTRING("OUT_OF_MEMORY");
					}
					;break;
					default: {
						HX_STACK_LINE(883)
						s = null();
					}
				}
			}
			HX_STACK_LINE(883)
			if (((s != null()))){
				HX_STACK_LINE(883)
				::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
				HX_STACK_LINE(883)
				::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
				HX_STACK_LINE(883)
				HX_STACK_DO_THROW(s);
			}
		}
	}
	HX_STACK_LINE(885)
	{
		HX_STACK_LINE(885)
		::openfl::gl::GL_obj::lime_gl_delete_shader(vs->id);
		HX_STACK_LINE(885)
		vs->invalidate();
	}
	HX_STACK_LINE(886)
	{
		HX_STACK_LINE(886)
		::openfl::gl::GL_obj::lime_gl_delete_shader(fs->id);
		HX_STACK_LINE(886)
		fs->invalidate();
	}
	HX_STACK_LINE(888)
	{
		HX_STACK_LINE(888)
		int _g113 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g113,"_g113");
		HX_STACK_LINE(888)
		if (((_g113 != (int)0))){
			HX_STACK_LINE(888)
			::String s;		HX_STACK_VAR(s,"s");
			HX_STACK_LINE(888)
			{
				HX_STACK_LINE(888)
				int _g1 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(888)
				switch( (int)(_g1)){
					case (int)0: {
						HX_STACK_LINE(888)
						s = null();
					}
					;break;
					case (int)1280: {
						HX_STACK_LINE(888)
						s = HX_CSTRING("INVALID_ENUM");
					}
					;break;
					case (int)1281: {
						HX_STACK_LINE(888)
						s = HX_CSTRING("INVALID_VALUE");
					}
					;break;
					case (int)1282: {
						HX_STACK_LINE(888)
						s = HX_CSTRING("INVALID_OPERATION");
					}
					;break;
					case (int)1285: {
						HX_STACK_LINE(888)
						s = HX_CSTRING("OUT_OF_MEMORY");
					}
					;break;
					default: {
						HX_STACK_LINE(888)
						s = null();
					}
				}
			}
			HX_STACK_LINE(888)
			if (((s != null()))){
				HX_STACK_LINE(888)
				::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
				HX_STACK_LINE(888)
				::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
				HX_STACK_LINE(888)
				HX_STACK_DO_THROW(s);
			}
		}
	}
	HX_STACK_LINE(890)
	return inst;
}


HX_DEFINE_DYNAMIC_FUNC1(GlDriver_obj,buildShaderInstance,return )

::String GlDriver_obj::findVarComment( ::String str,::String code){
	HX_STACK_FRAME("h3d.impl.GlDriver","findVarComment",0xf1bed799,"h3d.impl.GlDriver.findVarComment","h3d/impl/GlDriver.hx",896,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_ARG(str,"str")
	HX_STACK_ARG(code,"code")
	HX_STACK_LINE(897)
	::EReg r = ::EReg_obj::__new((str + HX_CSTRING("[ \\t]*\\/\\*([A-Za-z0-9_]+)\\*\\/")),HX_CSTRING("g"));		HX_STACK_VAR(r,"r");
	HX_STACK_LINE(899)
	if ((r->match(code))){
		HX_STACK_LINE(900)
		return r->matched((int)1);
	}
	else{
		HX_STACK_LINE(902)
		return null();
	}
	HX_STACK_LINE(899)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC2(GlDriver_obj,findVarComment,return )

bool GlDriver_obj::hasArrayAccess( ::String str,::String code){
	HX_STACK_FRAME("h3d.impl.GlDriver","hasArrayAccess",0xc9bc16ab,"h3d.impl.GlDriver.hasArrayAccess","h3d/impl/GlDriver.hx",905,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_ARG(str,"str")
	HX_STACK_ARG(code,"code")
	HX_STACK_LINE(906)
	::EReg r = ::EReg_obj::__new(((HX_CSTRING("[A-Z0-9_]+[ \t]+") + str) + HX_CSTRING("\\[[a-z](.+?)\\]")),HX_CSTRING("gi"));		HX_STACK_VAR(r,"r");
	HX_STACK_LINE(908)
	if ((r->match(code))){
		HX_STACK_LINE(909)
		return true;
	}
	else{
		HX_STACK_LINE(910)
		return false;
	}
	HX_STACK_LINE(908)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC2(GlDriver_obj,hasArrayAccess,return )

::h3d::impl::Uniform GlDriver_obj::parseUniform( ::String allCode,::openfl::gl::GLProgram p){
	HX_STACK_FRAME("h3d.impl.GlDriver","parseUniform",0x3a203709,"h3d.impl.GlDriver.parseUniform","h3d/impl/GlDriver.hx",915,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_ARG(allCode,"allCode")
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(916)
	::h3d::impl::GLActiveInfo inf = this->parseUniInfo->inf;		HX_STACK_VAR(inf,"inf");
	HX_STACK_LINE(918)
	{
		HX_STACK_LINE(918)
		::String _g = ::Std_obj::string(inf);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(918)
		::String _ = (HX_CSTRING("retrieved uniform ") + _g);		HX_STACK_VAR(_,"_");
		HX_STACK_LINE(918)
		Dynamic();
	}
	HX_STACK_LINE(920)
	bool isSubscriptArray = false;		HX_STACK_VAR(isSubscriptArray,"isSubscriptArray");
	HX_STACK_LINE(921)
	::h3d::impl::ShaderType t = this->decodeTypeInt(inf->type);		HX_STACK_VAR(t,"t");
	HX_STACK_LINE(922)
	bool scanSubscript = true;		HX_STACK_VAR(scanSubscript,"scanSubscript");
	HX_STACK_LINE(923)
	::EReg r_array = ::EReg_obj::__new(HX_CSTRING("\\[([0-9]+)\\]$"),HX_CSTRING("g"));		HX_STACK_VAR(r_array,"r_array");
	HX_STACK_LINE(925)
	switch( (int)(t->__Index())){
		case (int)7: case (int)8: {
			HX_STACK_LINE(926)
			(this->parseUniInfo->texIndex)++;
		}
		;break;
		case (int)2: {
			HX_STACK_LINE(928)
			::String c = this->findVarComment(inf->name,allCode);		HX_STACK_VAR(c,"c");
			HX_STACK_LINE(929)
			if (((  (((c != null()))) ? bool(::StringTools_obj::startsWith(c,HX_CSTRING("byte"))) : bool(false) ))){
				HX_STACK_LINE(930)
				t = ::h3d::impl::ShaderType_obj::Byte3;
			}
			else{
				HX_STACK_LINE(934)
				::String _g1 = inf->name.split(HX_CSTRING("."))->pop();		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(934)
				if ((this->hasArrayAccess(_g1,allCode))){
					HX_STACK_LINE(935)
					isSubscriptArray = true;
				}
			}
		}
		;break;
		case (int)3: {
			HX_STACK_LINE(939)
			::String c = this->findVarComment(inf->name,allCode);		HX_STACK_VAR(c,"c");
			HX_STACK_LINE(940)
			if (((  (((c != null()))) ? bool(::StringTools_obj::startsWith(c,HX_CSTRING("byte"))) : bool(false) ))){
				HX_STACK_LINE(941)
				t = ::h3d::impl::ShaderType_obj::Byte4;
			}
			else{
				HX_STACK_LINE(945)
				::String _g2 = inf->name.split(HX_CSTRING("."))->pop();		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(945)
				if ((this->hasArrayAccess(_g2,allCode))){
					HX_STACK_LINE(946)
					isSubscriptArray = true;
				}
			}
		}
		;break;
		case (int)6: {
			HX_STACK_LINE(950)
			int li = inf->name.lastIndexOf(HX_CSTRING("["),null());		HX_STACK_VAR(li,"li");
			HX_STACK_LINE(951)
			if (((li >= (int)0))){
				HX_STACK_LINE(952)
				::String _g3 = inf->name.substr((int)0,li);		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(952)
				inf->name = _g3;
			}
			HX_STACK_LINE(954)
			if ((this->hasArrayAccess(inf->name,allCode))){
				HX_STACK_LINE(955)
				scanSubscript = false;
				HX_STACK_LINE(956)
				::h3d::impl::ShaderType _g4 = ::h3d::impl::ShaderType_obj::Elements(inf->name,null(),t);		HX_STACK_VAR(_g4,"_g4");
				HX_STACK_LINE(956)
				t = _g4;
				HX_STACK_LINE(957)
				{
					HX_STACK_LINE(957)
					::String _g5 = ::Std_obj::string(t);		HX_STACK_VAR(_g5,"_g5");
					HX_STACK_LINE(957)
					::String _g6 = (((HX_CSTRING("subtyped ") + inf->name) + HX_CSTRING(" ")) + _g5);		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(957)
					::String _g7 = (_g6 + HX_CSTRING(" "));		HX_STACK_VAR(_g7,"_g7");
					HX_STACK_LINE(957)
					::String _g8 = (_g7 + inf->type);		HX_STACK_VAR(_g8,"_g8");
					HX_STACK_LINE(957)
					::String _ = (_g8 + HX_CSTRING(" as array"));		HX_STACK_VAR(_,"_");
					HX_STACK_LINE(957)
					Dynamic();
				}
			}
			else{
				HX_STACK_LINE(959)
				::String _g9 = ::Std_obj::string(t);		HX_STACK_VAR(_g9,"_g9");
				HX_STACK_LINE(959)
				::String _g10 = (((HX_CSTRING("can t subtype ") + inf->name) + HX_CSTRING(" ")) + _g9);		HX_STACK_VAR(_g10,"_g10");
				HX_STACK_LINE(959)
				::String _g11 = (_g10 + HX_CSTRING(" "));		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(959)
				::String _ = (_g11 + inf->type);		HX_STACK_VAR(_,"_");
				HX_STACK_LINE(959)
				Dynamic();
			}
		}
		;break;
		default: {
			HX_STACK_LINE(962)
			::String _g12 = ::Std_obj::string(t);		HX_STACK_VAR(_g12,"_g12");
			HX_STACK_LINE(962)
			::String _g13 = (HX_CSTRING("can t subtype ") + _g12);		HX_STACK_VAR(_g13,"_g13");
			HX_STACK_LINE(962)
			::String _g14 = (_g13 + HX_CSTRING(" "));		HX_STACK_VAR(_g14,"_g14");
			HX_STACK_LINE(962)
			::String _ = (_g14 + inf->type);		HX_STACK_VAR(_,"_");
			HX_STACK_LINE(962)
			Dynamic();
		}
	}
	HX_STACK_LINE(967)
	::String name = inf->name;		HX_STACK_VAR(name,"name");
	HX_STACK_LINE(968)
	while((true)){
		HX_STACK_LINE(968)
		if ((!(scanSubscript))){
			HX_STACK_LINE(968)
			break;
		}
		HX_STACK_LINE(969)
		if ((r_array->match(name))){
			HX_STACK_LINE(971)
			::String _g15 = r_array->matchedLeft();		HX_STACK_VAR(_g15,"_g15");
			HX_STACK_LINE(971)
			name = _g15;
			HX_STACK_LINE(972)
			::String _g16 = r_array->matched((int)1);		HX_STACK_VAR(_g16,"_g16");
			HX_STACK_LINE(972)
			Dynamic _g17 = ::Std_obj::parseInt(_g16);		HX_STACK_VAR(_g17,"_g17");
			HX_STACK_LINE(972)
			::h3d::impl::ShaderType _g18 = ::h3d::impl::ShaderType_obj::Index(_g17,t);		HX_STACK_VAR(_g18,"_g18");
			HX_STACK_LINE(972)
			t = _g18;
			HX_STACK_LINE(973)
			{
				HX_STACK_LINE(973)
				::String _g19 = ::Std_obj::string(t);		HX_STACK_VAR(_g19,"_g19");
				HX_STACK_LINE(973)
				::String _ = (((HX_CSTRING("0_ sub ") + name) + HX_CSTRING(" -> ")) + _g19);		HX_STACK_VAR(_,"_");
				HX_STACK_LINE(973)
				Dynamic();
			}
			HX_STACK_LINE(974)
			continue;
		}
		HX_STACK_LINE(977)
		int c = name.lastIndexOf(HX_CSTRING("."),null());		HX_STACK_VAR(c,"c");
		HX_STACK_LINE(978)
		if (((c < (int)0))){
			HX_STACK_LINE(979)
			int _g20 = name.lastIndexOf(HX_CSTRING("["),null());		HX_STACK_VAR(_g20,"_g20");
			HX_STACK_LINE(979)
			c = _g20;
		}
		HX_STACK_LINE(982)
		if (((c > (int)0))){
			HX_STACK_LINE(983)
			{
				HX_STACK_LINE(983)
				::String _g21 = ::Std_obj::string(t);		HX_STACK_VAR(_g21,"_g21");
				HX_STACK_LINE(983)
				::String _ = (((HX_CSTRING("1_ ") + name) + HX_CSTRING(" -> ")) + _g21);		HX_STACK_VAR(_,"_");
				HX_STACK_LINE(983)
				Dynamic();
			}
			HX_STACK_LINE(984)
			::String field = name.substr((c + (int)1),null());		HX_STACK_VAR(field,"field");
			HX_STACK_LINE(985)
			::String _g22 = name.substr((int)0,c);		HX_STACK_VAR(_g22,"_g22");
			HX_STACK_LINE(985)
			name = _g22;
			HX_STACK_LINE(986)
			{
				HX_STACK_LINE(986)
				::String _g23 = ::Std_obj::string(t);		HX_STACK_VAR(_g23,"_g23");
				HX_STACK_LINE(986)
				::String _ = (((((HX_CSTRING("1_ ") + name) + HX_CSTRING(" -> field ")) + field) + HX_CSTRING(" ")) + _g23);		HX_STACK_VAR(_,"_");
				HX_STACK_LINE(986)
				Dynamic();
			}
			HX_STACK_LINE(987)
			if ((!(isSubscriptArray))){
				HX_STACK_LINE(988)
				::h3d::impl::ShaderType _g24 = ::h3d::impl::ShaderType_obj::Struct(field,t);		HX_STACK_VAR(_g24,"_g24");
				HX_STACK_LINE(988)
				t = _g24;
			}
			else{
				HX_STACK_LINE(991)
				::h3d::impl::ShaderType _g25 = ::h3d::impl::ShaderType_obj::Elements(field,inf->size,t);		HX_STACK_VAR(_g25,"_g25");
				HX_STACK_LINE(991)
				t = _g25;
			}
		}
		HX_STACK_LINE(993)
		break;
	}
	HX_STACK_LINE(999)
	Dynamic _g26 = ::openfl::gl::GL_obj::lime_gl_get_uniform_location(p->id,inf->name);		HX_STACK_VAR(_g26,"_g26");
	HX_STACK_LINE(997)
	return ::h3d::impl::Uniform_obj::__new(name,_g26,t,this->parseUniInfo->texIndex);
}


HX_DEFINE_DYNAMIC_FUNC2(GlDriver_obj,parseUniform,return )

Void GlDriver_obj::deleteShader( ::h3d::impl::Shader shader){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","deleteShader",0xae9a8778,"h3d.impl.GlDriver.deleteShader","h3d/impl/GlDriver.hx",1005,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_ARG(shader,"shader")
		HX_STACK_LINE(1006)
		if (((shader == null()))){
			HX_STACK_LINE(1008)
			HX_STACK_DO_THROW(HX_CSTRING("Shader not set ?"));
			HX_STACK_LINE(1010)
			return null();
		}
		HX_STACK_LINE(1013)
		{
			HX_STACK_LINE(1013)
			::openfl::gl::GLProgram program = shader->instance->program;		HX_STACK_VAR(program,"program");
			HX_STACK_LINE(1013)
			::openfl::gl::GL_obj::lime_gl_delete_program(program->id);
			HX_STACK_LINE(1013)
			program->invalidate();
		}
	}
return null();
}


bool GlDriver_obj::selectShader( ::h3d::impl::Shader shader){
	HX_STACK_FRAME("h3d.impl.GlDriver","selectShader",0x2c3a5509,"h3d.impl.GlDriver.selectShader","h3d/impl/GlDriver.hx",1016,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_ARG(shader,"shader")
	HX_STACK_LINE(1017)
	if (((shader == null()))){
		HX_STACK_LINE(1019)
		HX_STACK_DO_THROW(HX_CSTRING("Shader not set ?"));
		HX_STACK_LINE(1021)
		return false;
	}
	HX_STACK_LINE(1024)
	bool change = false;		HX_STACK_VAR(change,"change");
	HX_STACK_LINE(1025)
	if (((shader->instance == null()))){
		HX_STACK_LINE(1026)
		{
			HX_STACK_LINE(1026)
			::ValueType _g = ::Type_obj::_typeof(shader);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(1026)
			::String _g1 = ::Std_obj::string(_g);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(1026)
			::String _ = (HX_CSTRING("building shader") + _g1);		HX_STACK_VAR(_,"_");
			HX_STACK_LINE(1026)
			Dynamic();
		}
		HX_STACK_LINE(1027)
		::h3d::impl::ShaderInstance _g2 = this->buildShaderInstance(shader);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(1027)
		shader->instance = _g2;
	}
	HX_STACK_LINE(1029)
	if (((shader->instance != this->curShader))){
		HX_STACK_LINE(1030)
		::h3d::impl::ShaderInstance old = this->curShader;		HX_STACK_VAR(old,"old");
		HX_STACK_LINE(1031)
		{
			HX_STACK_LINE(1031)
			::Class _g3 = ::Type_obj::getClass(shader);		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(1031)
			::String _g4 = ::Std_obj::string(_g3);		HX_STACK_VAR(_g4,"_g4");
			HX_STACK_LINE(1031)
			::String _g5 = (HX_CSTRING("binding shader ") + _g4);		HX_STACK_VAR(_g5,"_g5");
			HX_STACK_LINE(1031)
			::String _g6 = (_g5 + HX_CSTRING(" nbAttribs:"));		HX_STACK_VAR(_g6,"_g6");
			HX_STACK_LINE(1031)
			::String _ = (_g6 + shader->instance->attribs->length);		HX_STACK_VAR(_,"_");
			HX_STACK_LINE(1031)
			Dynamic();
		}
		HX_STACK_LINE(1032)
		this->curShader = shader->instance;
		HX_STACK_LINE(1034)
		if (((this->curShader->program == null()))){
			HX_STACK_LINE(1034)
			HX_STACK_DO_THROW(HX_CSTRING("invalid shader"));
		}
		HX_STACK_LINE(1036)
		{
			HX_STACK_LINE(1036)
			::openfl::gl::GLProgram program = this->curShader->program;		HX_STACK_VAR(program,"program");
			HX_STACK_LINE(1036)
			::openfl::gl::GL_obj::lime_gl_use_program((  (((program == null()))) ? Dynamic(null()) : Dynamic(program->id) ));
		}
		HX_STACK_LINE(1038)
		int oa = (int)0;		HX_STACK_VAR(oa,"oa");
		HX_STACK_LINE(1039)
		if (((old != null()))){
			HX_STACK_LINE(1040)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(1040)
			Array< ::Dynamic > _g1 = old->attribs;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(1040)
			while((true)){
				HX_STACK_LINE(1040)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(1040)
					break;
				}
				HX_STACK_LINE(1040)
				::h3d::impl::Attribute a = _g1->__get(_g).StaticCast< ::h3d::impl::Attribute >();		HX_STACK_VAR(a,"a");
				HX_STACK_LINE(1040)
				++(_g);
				HX_STACK_LINE(1041)
				hx::OrEq(oa,(int((int)1) << int(a->index)));
			}
		}
		HX_STACK_LINE(1043)
		int na = (int)0;		HX_STACK_VAR(na,"na");
		HX_STACK_LINE(1044)
		{
			HX_STACK_LINE(1044)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(1044)
			Array< ::Dynamic > _g1 = this->curShader->attribs;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(1044)
			while((true)){
				HX_STACK_LINE(1044)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(1044)
					break;
				}
				HX_STACK_LINE(1044)
				::h3d::impl::Attribute a = _g1->__get(_g).StaticCast< ::h3d::impl::Attribute >();		HX_STACK_VAR(a,"a");
				HX_STACK_LINE(1044)
				++(_g);
				HX_STACK_LINE(1045)
				hx::OrEq(na,(int((int)1) << int(a->index)));
			}
		}
		HX_STACK_LINE(1047)
		if (((old != null()))){
			HX_STACK_LINE(1048)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(1048)
			Array< ::Dynamic > _g1 = old->attribs;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(1048)
			while((true)){
				HX_STACK_LINE(1048)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(1048)
					break;
				}
				HX_STACK_LINE(1048)
				::h3d::impl::Attribute a = _g1->__get(_g).StaticCast< ::h3d::impl::Attribute >();		HX_STACK_VAR(a,"a");
				HX_STACK_LINE(1048)
				++(_g);
				HX_STACK_LINE(1049)
				if (((((int(na) & int((int((int)1) << int(a->index))))) == (int)0))){
					HX_STACK_LINE(1050)
					::openfl::gl::GL_obj::lime_gl_disable_vertex_attrib_array(a->index);
				}
			}
		}
		HX_STACK_LINE(1052)
		{
			HX_STACK_LINE(1052)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(1052)
			Array< ::Dynamic > _g1 = this->curShader->attribs;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(1052)
			while((true)){
				HX_STACK_LINE(1052)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(1052)
					break;
				}
				HX_STACK_LINE(1052)
				::h3d::impl::Attribute a = _g1->__get(_g).StaticCast< ::h3d::impl::Attribute >();		HX_STACK_VAR(a,"a");
				HX_STACK_LINE(1052)
				++(_g);
				HX_STACK_LINE(1053)
				if (((((int(oa) & int((int((int)1) << int(a->index))))) == (int)0))){
					HX_STACK_LINE(1054)
					::openfl::gl::GL_obj::lime_gl_enable_vertex_attrib_array(a->index);
				}
			}
		}
		HX_STACK_LINE(1057)
		change = true;
		HX_STACK_LINE(1058)
		(this->shaderSwitch)++;
	}
	HX_STACK_LINE(1064)
	{
		HX_STACK_LINE(1064)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(1064)
		Array< ::Dynamic > _g1 = this->curShader->uniforms;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(1064)
		while((true)){
			HX_STACK_LINE(1064)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(1064)
				break;
			}
			HX_STACK_LINE(1064)
			::h3d::impl::Uniform u = _g1->__get(_g).StaticCast< ::h3d::impl::Uniform >();		HX_STACK_VAR(u,"u");
			HX_STACK_LINE(1064)
			++(_g);
			HX_STACK_LINE(1065)
			if (((u == null()))){
				HX_STACK_LINE(1065)
				HX_STACK_DO_THROW(HX_CSTRING("Missing uniform pointer"));
			}
			HX_STACK_LINE(1066)
			if (((u->loc == null()))){
				HX_STACK_LINE(1066)
				HX_STACK_DO_THROW(HX_CSTRING("Missing uniform location"));
			}
			HX_STACK_LINE(1068)
			Dynamic val;		HX_STACK_VAR(val,"val");
			HX_STACK_LINE(1068)
			val = (  (((shader == null()))) ? Dynamic(null()) : Dynamic(shader->__Field(u->name,true)) );
			HX_STACK_LINE(1069)
			if (((val == null()))){
				HX_STACK_LINE(1070)
				if ((::Reflect_obj::hasField(shader,u->name))){
					HX_STACK_LINE(1071)
					HX_STACK_DO_THROW(((HX_CSTRING("Shader param ") + u->name) + HX_CSTRING(" is null")));
				}
				else{
					HX_STACK_LINE(1073)
					Array< ::String > _g7 = ::Reflect_obj::fields(shader);		HX_STACK_VAR(_g7,"_g7");
					HX_STACK_LINE(1073)
					::String _g8 = ::Std_obj::string(_g7);		HX_STACK_VAR(_g8,"_g8");
					HX_STACK_LINE(1073)
					HX_STACK_DO_THROW((((HX_CSTRING("Missing shader value ") + u->name) + HX_CSTRING(" among ")) + _g8));
				}
			}
			HX_STACK_LINE(1077)
			this->setUniform(val,u,u->type,change);
		}
	}
	HX_STACK_LINE(1081)
	shader->customSetup(hx::ObjectPtr<OBJ_>(this));
	HX_STACK_LINE(1082)
	{
		HX_STACK_LINE(1082)
		int _g9 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g9,"_g9");
		HX_STACK_LINE(1082)
		if (((_g9 != (int)0))){
			HX_STACK_LINE(1082)
			::String s;		HX_STACK_VAR(s,"s");
			HX_STACK_LINE(1082)
			{
				HX_STACK_LINE(1082)
				int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(1082)
				switch( (int)(_g)){
					case (int)0: {
						HX_STACK_LINE(1082)
						s = null();
					}
					;break;
					case (int)1280: {
						HX_STACK_LINE(1082)
						s = HX_CSTRING("INVALID_ENUM");
					}
					;break;
					case (int)1281: {
						HX_STACK_LINE(1082)
						s = HX_CSTRING("INVALID_VALUE");
					}
					;break;
					case (int)1282: {
						HX_STACK_LINE(1082)
						s = HX_CSTRING("INVALID_OPERATION");
					}
					;break;
					case (int)1285: {
						HX_STACK_LINE(1082)
						s = HX_CSTRING("OUT_OF_MEMORY");
					}
					;break;
					default: {
						HX_STACK_LINE(1082)
						s = null();
					}
				}
			}
			HX_STACK_LINE(1082)
			if (((s != null()))){
				HX_STACK_LINE(1082)
				::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
				HX_STACK_LINE(1082)
				::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
				HX_STACK_LINE(1082)
				HX_STACK_DO_THROW(s);
			}
		}
	}
	HX_STACK_LINE(1085)
	return change;
}


bool GlDriver_obj::setupTexture( ::h3d::mat::Texture t,int stage,::h3d::mat::MipMap mipMap,::h3d::mat::Filter filter,::h3d::mat::Wrap wrap){
	HX_STACK_FRAME("h3d.impl.GlDriver","setupTexture",0x87f75da6,"h3d.impl.GlDriver.setupTexture","h3d/impl/GlDriver.hx",1097,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_ARG(t,"t")
	HX_STACK_ARG(stage,"stage")
	HX_STACK_ARG(mipMap,"mipMap")
	HX_STACK_ARG(filter,"filter")
	HX_STACK_ARG(wrap,"wrap")
	HX_STACK_LINE(1098)
	if (((this->curTex->__get(stage).StaticCast< ::h3d::mat::Texture >() != t))){
		HX_STACK_LINE(1099)
		{
			HX_STACK_LINE(1099)
			::openfl::gl::GLTexture texture = t->t;		HX_STACK_VAR(texture,"texture");
			HX_STACK_LINE(1099)
			::openfl::gl::GL_obj::lime_gl_bind_texture((int)3553,(  (((texture == null()))) ? Dynamic(null()) : Dynamic(texture->id) ));
		}
		HX_STACK_LINE(1100)
		int _g = mipMap->__Index();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(1100)
		Array< ::Dynamic > _g1 = ::h3d::impl::GlDriver_obj::TFILTERS->__get(_g).StaticCast< Array< ::Dynamic > >();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(1100)
		int _g2 = filter->__Index();		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(1100)
		Array< int > flags = _g1->__get(_g2).StaticCast< Array< int > >();		HX_STACK_VAR(flags,"flags");
		HX_STACK_LINE(1101)
		::openfl::gl::GL_obj::lime_gl_tex_parameteri((int)3553,(int)10240,flags->__get((int)0));
		HX_STACK_LINE(1102)
		::openfl::gl::GL_obj::lime_gl_tex_parameteri((int)3553,(int)10241,flags->__get((int)1));
		HX_STACK_LINE(1103)
		int _g3 = wrap->__Index();		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(1103)
		int w = ::h3d::impl::GlDriver_obj::TWRAP->__get(_g3);		HX_STACK_VAR(w,"w");
		HX_STACK_LINE(1104)
		::openfl::gl::GL_obj::lime_gl_tex_parameteri((int)3553,(int)10242,w);
		HX_STACK_LINE(1105)
		::openfl::gl::GL_obj::lime_gl_tex_parameteri((int)3553,(int)10243,w);
		HX_STACK_LINE(1106)
		{
			HX_STACK_LINE(1106)
			int _g4 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g4,"_g4");
			HX_STACK_LINE(1106)
			if (((_g4 != (int)0))){
				HX_STACK_LINE(1106)
				::String s;		HX_STACK_VAR(s,"s");
				HX_STACK_LINE(1106)
				{
					HX_STACK_LINE(1106)
					int _g5 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g5,"_g5");
					HX_STACK_LINE(1106)
					switch( (int)(_g5)){
						case (int)0: {
							HX_STACK_LINE(1106)
							s = null();
						}
						;break;
						case (int)1280: {
							HX_STACK_LINE(1106)
							s = HX_CSTRING("INVALID_ENUM");
						}
						;break;
						case (int)1281: {
							HX_STACK_LINE(1106)
							s = HX_CSTRING("INVALID_VALUE");
						}
						;break;
						case (int)1282: {
							HX_STACK_LINE(1106)
							s = HX_CSTRING("INVALID_OPERATION");
						}
						;break;
						case (int)1285: {
							HX_STACK_LINE(1106)
							s = HX_CSTRING("OUT_OF_MEMORY");
						}
						;break;
						default: {
							HX_STACK_LINE(1106)
							s = null();
						}
					}
				}
				HX_STACK_LINE(1106)
				if (((s != null()))){
					HX_STACK_LINE(1106)
					::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
					HX_STACK_LINE(1106)
					::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
					HX_STACK_LINE(1106)
					HX_STACK_DO_THROW(s);
				}
			}
		}
		HX_STACK_LINE(1107)
		this->curTex[stage] = t;
		HX_STACK_LINE(1108)
		(this->textureSwitch)++;
		HX_STACK_LINE(1109)
		return true;
	}
	HX_STACK_LINE(1111)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC5(GlDriver_obj,setupTexture,return )

::openfl::utils::Float32Array GlDriver_obj::blitMatrices( Array< ::Dynamic > a,bool transpose){
	HX_STACK_FRAME("h3d.impl.GlDriver","blitMatrices",0x6882c4b7,"h3d.impl.GlDriver.blitMatrices","h3d/impl/GlDriver.hx",1114,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(transpose,"transpose")
	HX_STACK_LINE(1115)
	::openfl::utils::Float32Array t = this->createF32((a->length * (int)16));		HX_STACK_VAR(t,"t");
	HX_STACK_LINE(1116)
	int p = (int)0;		HX_STACK_VAR(p,"p");
	HX_STACK_LINE(1117)
	{
		HX_STACK_LINE(1117)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(1117)
		while((true)){
			HX_STACK_LINE(1117)
			if ((!(((_g < a->length))))){
				HX_STACK_LINE(1117)
				break;
			}
			HX_STACK_LINE(1117)
			::h3d::Matrix m = a->__get(_g).StaticCast< ::h3d::Matrix >();		HX_STACK_VAR(m,"m");
			HX_STACK_LINE(1117)
			++(_g);
			HX_STACK_LINE(1118)
			{
				HX_STACK_LINE(1118)
				::openfl::utils::Float32Array t1 = t;		HX_STACK_VAR(t1,"t1");
				HX_STACK_LINE(1118)
				if (((t1 == null()))){
					HX_STACK_LINE(1118)
					::openfl::utils::Float32Array _g1 = this->createF32((int)16);		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(1118)
					t1 = _g1;
				}
				HX_STACK_LINE(1118)
				if ((!(transpose))){
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,p) = m->_11;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)1)) = m->_12;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)2)) = m->_13;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)3)) = m->_14;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)4)) = m->_21;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)5)) = m->_22;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)6)) = m->_23;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)7)) = m->_24;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)8)) = m->_31;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)9)) = m->_32;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)10)) = m->_33;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)11)) = m->_34;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)12)) = m->_41;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)13)) = m->_42;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)14)) = m->_43;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)15)) = m->_44;
				}
				else{
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,p) = m->_11;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)1)) = m->_21;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)2)) = m->_31;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)3)) = m->_41;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)4)) = m->_12;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)5)) = m->_22;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)6)) = m->_32;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)7)) = m->_42;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)8)) = m->_13;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)9)) = m->_23;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)10)) = m->_33;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)11)) = m->_43;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)12)) = m->_14;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)13)) = m->_24;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)14)) = m->_34;
					HX_STACK_LINE(1118)
					hx::__ArrayImplRef(t1,(p + (int)15)) = m->_44;
				}
				HX_STACK_LINE(1118)
				t1;
			}
			HX_STACK_LINE(1119)
			hx::AddEq(p,(int)16);
		}
	}
	HX_STACK_LINE(1121)
	return t;
}


HX_DEFINE_DYNAMIC_FUNC2(GlDriver_obj,blitMatrices,return )

::openfl::utils::Float32Array GlDriver_obj::blitMatrix( ::h3d::Matrix a,bool transpose,hx::Null< int >  __o_ofs,::openfl::utils::Float32Array t){
int ofs = __o_ofs.Default(0);
	HX_STACK_FRAME("h3d.impl.GlDriver","blitMatrix",0xf1e5981e,"h3d.impl.GlDriver.blitMatrix","h3d/impl/GlDriver.hx",1124,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(transpose,"transpose")
	HX_STACK_ARG(ofs,"ofs")
	HX_STACK_ARG(t,"t")
{
		HX_STACK_LINE(1125)
		if (((t == null()))){
			HX_STACK_LINE(1125)
			::openfl::utils::Float32Array _g = this->createF32((int)16);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(1125)
			t = _g;
		}
		HX_STACK_LINE(1127)
		if ((!(transpose))){
			HX_STACK_LINE(1128)
			hx::__ArrayImplRef(t,ofs) = a->_11;
			HX_STACK_LINE(1129)
			hx::__ArrayImplRef(t,(ofs + (int)1)) = a->_12;
			HX_STACK_LINE(1130)
			hx::__ArrayImplRef(t,(ofs + (int)2)) = a->_13;
			HX_STACK_LINE(1131)
			hx::__ArrayImplRef(t,(ofs + (int)3)) = a->_14;
			HX_STACK_LINE(1133)
			hx::__ArrayImplRef(t,(ofs + (int)4)) = a->_21;
			HX_STACK_LINE(1134)
			hx::__ArrayImplRef(t,(ofs + (int)5)) = a->_22;
			HX_STACK_LINE(1135)
			hx::__ArrayImplRef(t,(ofs + (int)6)) = a->_23;
			HX_STACK_LINE(1136)
			hx::__ArrayImplRef(t,(ofs + (int)7)) = a->_24;
			HX_STACK_LINE(1138)
			hx::__ArrayImplRef(t,(ofs + (int)8)) = a->_31;
			HX_STACK_LINE(1139)
			hx::__ArrayImplRef(t,(ofs + (int)9)) = a->_32;
			HX_STACK_LINE(1140)
			hx::__ArrayImplRef(t,(ofs + (int)10)) = a->_33;
			HX_STACK_LINE(1141)
			hx::__ArrayImplRef(t,(ofs + (int)11)) = a->_34;
			HX_STACK_LINE(1143)
			hx::__ArrayImplRef(t,(ofs + (int)12)) = a->_41;
			HX_STACK_LINE(1144)
			hx::__ArrayImplRef(t,(ofs + (int)13)) = a->_42;
			HX_STACK_LINE(1145)
			hx::__ArrayImplRef(t,(ofs + (int)14)) = a->_43;
			HX_STACK_LINE(1146)
			hx::__ArrayImplRef(t,(ofs + (int)15)) = a->_44;
		}
		else{
			HX_STACK_LINE(1149)
			hx::__ArrayImplRef(t,ofs) = a->_11;
			HX_STACK_LINE(1150)
			hx::__ArrayImplRef(t,(ofs + (int)1)) = a->_21;
			HX_STACK_LINE(1151)
			hx::__ArrayImplRef(t,(ofs + (int)2)) = a->_31;
			HX_STACK_LINE(1152)
			hx::__ArrayImplRef(t,(ofs + (int)3)) = a->_41;
			HX_STACK_LINE(1154)
			hx::__ArrayImplRef(t,(ofs + (int)4)) = a->_12;
			HX_STACK_LINE(1155)
			hx::__ArrayImplRef(t,(ofs + (int)5)) = a->_22;
			HX_STACK_LINE(1156)
			hx::__ArrayImplRef(t,(ofs + (int)6)) = a->_32;
			HX_STACK_LINE(1157)
			hx::__ArrayImplRef(t,(ofs + (int)7)) = a->_42;
			HX_STACK_LINE(1159)
			hx::__ArrayImplRef(t,(ofs + (int)8)) = a->_13;
			HX_STACK_LINE(1160)
			hx::__ArrayImplRef(t,(ofs + (int)9)) = a->_23;
			HX_STACK_LINE(1161)
			hx::__ArrayImplRef(t,(ofs + (int)10)) = a->_33;
			HX_STACK_LINE(1162)
			hx::__ArrayImplRef(t,(ofs + (int)11)) = a->_43;
			HX_STACK_LINE(1164)
			hx::__ArrayImplRef(t,(ofs + (int)12)) = a->_14;
			HX_STACK_LINE(1165)
			hx::__ArrayImplRef(t,(ofs + (int)13)) = a->_24;
			HX_STACK_LINE(1166)
			hx::__ArrayImplRef(t,(ofs + (int)14)) = a->_34;
			HX_STACK_LINE(1167)
			hx::__ArrayImplRef(t,(ofs + (int)15)) = a->_44;
		}
		HX_STACK_LINE(1169)
		return t;
	}
}


HX_DEFINE_DYNAMIC_FUNC4(GlDriver_obj,blitMatrix,return )

::openfl::utils::Float32Array GlDriver_obj::createF32( int sz){
	HX_STACK_FRAME("h3d.impl.GlDriver","createF32",0x152a5a21,"h3d.impl.GlDriver.createF32","h3d/impl/GlDriver.hx",1174,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_ARG(sz,"sz")
	HX_STACK_LINE(1175)
	if ((!(::h3d::impl::GlDriver_obj::f32Pool->exists(sz)))){
		HX_STACK_LINE(1176)
		Dynamic _g;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(1176)
		{
			HX_STACK_LINE(1176)
			Dynamic _g1 = Dynamic( Array_obj<Dynamic>::__new());		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(1176)
			{
				HX_STACK_LINE(1176)
				int _g11 = (int)0;		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(1176)
				while((true)){
					HX_STACK_LINE(1176)
					if ((!(((_g11 < sz))))){
						HX_STACK_LINE(1176)
						break;
					}
					HX_STACK_LINE(1176)
					int i = (_g11)++;		HX_STACK_VAR(i,"i");
					HX_STACK_LINE(1176)
					_g1->__Field(HX_CSTRING("push"),true)(0.0);
				}
			}
			HX_STACK_LINE(1176)
			_g = _g1;
		}
		HX_STACK_LINE(1176)
		::openfl::utils::Float32Array _g1 = ::openfl::utils::Float32Array_obj::__new(_g,null(),null());		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(1176)
		::h3d::impl::GlDriver_obj::f32Pool->set(sz,_g1);
	}
	HX_STACK_LINE(1179)
	::openfl::utils::Float32Array p = ::h3d::impl::GlDriver_obj::f32Pool->get(sz);		HX_STACK_VAR(p,"p");
	HX_STACK_LINE(1181)
	{
		HX_STACK_LINE(1181)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(1181)
		int _g = p->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(1181)
		while((true)){
			HX_STACK_LINE(1181)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(1181)
				break;
			}
			HX_STACK_LINE(1181)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(1181)
			hx::__ArrayImplRef(p,i) = 0.0;
		}
	}
	HX_STACK_LINE(1183)
	::h3d::impl::GlDriver_obj::f32Pool->set(sz,null());
	HX_STACK_LINE(1184)
	return p;
}


HX_DEFINE_DYNAMIC_FUNC1(GlDriver_obj,createF32,return )

Void GlDriver_obj::deleteF32( ::openfl::utils::Float32Array a){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","deleteF32",0xbd0fa852,"h3d.impl.GlDriver.deleteF32","h3d/impl/GlDriver.hx",1188,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_ARG(a,"a")
		HX_STACK_LINE(1188)
		::h3d::impl::GlDriver_obj::f32Pool->set(a->length,a);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(GlDriver_obj,deleteF32,(void))

Void GlDriver_obj::setUniform( Dynamic val,::h3d::impl::Uniform u,::h3d::impl::ShaderType t,bool shaderChange){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","setUniform",0x2207857a,"h3d.impl.GlDriver.setUniform","h3d/impl/GlDriver.hx",1193,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_ARG(val,"val")
		HX_STACK_ARG(u,"u")
		HX_STACK_ARG(t,"t")
		HX_STACK_ARG(shaderChange,"shaderChange")
		HX_STACK_LINE(1195)
		::openfl::utils::Float32Array buff = null();		HX_STACK_VAR(buff,"buff");
		HX_STACK_LINE(1196)
		if (((u == null()))){
			HX_STACK_LINE(1196)
			HX_STACK_DO_THROW(HX_CSTRING("no uniform set, check your shader"));
		}
		HX_STACK_LINE(1197)
		if (((u->loc == null()))){
			HX_STACK_LINE(1197)
			HX_STACK_DO_THROW(HX_CSTRING("no uniform loc set, check your shader"));
		}
		HX_STACK_LINE(1198)
		if (((val == null()))){
			HX_STACK_LINE(1198)
			HX_STACK_DO_THROW(HX_CSTRING("no val set, check your shader"));
		}
		HX_STACK_LINE(1199)
		if (((::h3d::impl::GlDriver_obj::gl == null()))){
			HX_STACK_LINE(1199)
			HX_STACK_DO_THROW(HX_CSTRING("no gl set, Arrrghh"));
		}
		HX_STACK_LINE(1201)
		{
			HX_STACK_LINE(1201)
			int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(1201)
			if (((_g != (int)0))){
				HX_STACK_LINE(1201)
				::String s;		HX_STACK_VAR(s,"s");
				HX_STACK_LINE(1201)
				{
					HX_STACK_LINE(1201)
					int _g1 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(1201)
					switch( (int)(_g1)){
						case (int)0: {
							HX_STACK_LINE(1201)
							s = null();
						}
						;break;
						case (int)1280: {
							HX_STACK_LINE(1201)
							s = HX_CSTRING("INVALID_ENUM");
						}
						;break;
						case (int)1281: {
							HX_STACK_LINE(1201)
							s = HX_CSTRING("INVALID_VALUE");
						}
						;break;
						case (int)1282: {
							HX_STACK_LINE(1201)
							s = HX_CSTRING("INVALID_OPERATION");
						}
						;break;
						case (int)1285: {
							HX_STACK_LINE(1201)
							s = HX_CSTRING("OUT_OF_MEMORY");
						}
						;break;
						default: {
							HX_STACK_LINE(1201)
							s = null();
						}
					}
				}
				HX_STACK_LINE(1201)
				if (((s != null()))){
					HX_STACK_LINE(1201)
					::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
					HX_STACK_LINE(1201)
					::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
					HX_STACK_LINE(1201)
					HX_STACK_DO_THROW(s);
				}
			}
		}
		HX_STACK_LINE(1206)
		switch( (int)(t->__Index())){
			case (int)6: {
				HX_STACK_LINE(1210)
				if ((::Std_obj::is(val,hx::ClassOf< Array<int> >()))){
					HX_STACK_LINE(1210)
					HX_STACK_DO_THROW(HX_CSTRING("error"));
				}
				HX_STACK_LINE(1215)
				::h3d::Matrix m = val;		HX_STACK_VAR(m,"m");
				HX_STACK_LINE(1216)
				{
					HX_STACK_LINE(1216)
					Dynamic location = u->loc;		HX_STACK_VAR(location,"location");
					HX_STACK_LINE(1216)
					Dynamic v;		HX_STACK_VAR(v,"v");
					HX_STACK_LINE(1216)
					{
						HX_STACK_LINE(1216)
						::openfl::utils::Float32Array _g2;		HX_STACK_VAR(_g2,"_g2");
						HX_STACK_LINE(1216)
						{
							HX_STACK_LINE(1216)
							int ofs = (int)0;		HX_STACK_VAR(ofs,"ofs");
							HX_STACK_LINE(1216)
							::openfl::utils::Float32Array t1 = null();		HX_STACK_VAR(t1,"t1");
							HX_STACK_LINE(1216)
							if (((t1 == null()))){
								HX_STACK_LINE(1216)
								::openfl::utils::Float32Array _g1 = this->createF32((int)16);		HX_STACK_VAR(_g1,"_g1");
								HX_STACK_LINE(1216)
								t1 = _g1;
							}
							HX_STACK_LINE(1216)
							{
								HX_STACK_LINE(1216)
								hx::__ArrayImplRef(t1,ofs) = m->_11;
								HX_STACK_LINE(1216)
								hx::__ArrayImplRef(t1,(ofs + (int)1)) = m->_21;
								HX_STACK_LINE(1216)
								hx::__ArrayImplRef(t1,(ofs + (int)2)) = m->_31;
								HX_STACK_LINE(1216)
								hx::__ArrayImplRef(t1,(ofs + (int)3)) = m->_41;
								HX_STACK_LINE(1216)
								hx::__ArrayImplRef(t1,(ofs + (int)4)) = m->_12;
								HX_STACK_LINE(1216)
								hx::__ArrayImplRef(t1,(ofs + (int)5)) = m->_22;
								HX_STACK_LINE(1216)
								hx::__ArrayImplRef(t1,(ofs + (int)6)) = m->_32;
								HX_STACK_LINE(1216)
								hx::__ArrayImplRef(t1,(ofs + (int)7)) = m->_42;
								HX_STACK_LINE(1216)
								hx::__ArrayImplRef(t1,(ofs + (int)8)) = m->_13;
								HX_STACK_LINE(1216)
								hx::__ArrayImplRef(t1,(ofs + (int)9)) = m->_23;
								HX_STACK_LINE(1216)
								hx::__ArrayImplRef(t1,(ofs + (int)10)) = m->_33;
								HX_STACK_LINE(1216)
								hx::__ArrayImplRef(t1,(ofs + (int)11)) = m->_43;
								HX_STACK_LINE(1216)
								hx::__ArrayImplRef(t1,(ofs + (int)12)) = m->_14;
								HX_STACK_LINE(1216)
								hx::__ArrayImplRef(t1,(ofs + (int)13)) = m->_24;
								HX_STACK_LINE(1216)
								hx::__ArrayImplRef(t1,(ofs + (int)14)) = m->_34;
								HX_STACK_LINE(1216)
								hx::__ArrayImplRef(t1,(ofs + (int)15)) = m->_44;
							}
							HX_STACK_LINE(1216)
							_g2 = t1;
						}
						HX_STACK_LINE(1216)
						::openfl::utils::Float32Array f = buff = _g2;		HX_STACK_VAR(f,"f");
						HX_STACK_LINE(1216)
						Dynamic data = f->getByteBuffer();		HX_STACK_VAR(data,"data");
						HX_STACK_LINE(1216)
						v = data;
					}
					HX_STACK_LINE(1216)
					::openfl::gl::GL_obj::lime_gl_uniform_matrix(location,false,v,(int)4);
				}
				HX_STACK_LINE(1217)
				this->deleteF32(buff);
			}
			;break;
			case (int)7: {
				HX_STACK_LINE(1222)
				::h3d::mat::Texture t1 = val;		HX_STACK_VAR(t1,"t1");
				HX_STACK_LINE(1223)
				bool reuse = this->setupTexture(t1,u->index,t1->mipMap,t1->filter,t1->wrap);		HX_STACK_VAR(reuse,"reuse");
				HX_STACK_LINE(1224)
				if (((bool(!(reuse)) || bool(shaderChange)))){
					HX_STACK_LINE(1226)
					::openfl::gl::GL_obj::lime_gl_active_texture(((int)33984 + u->index));
					HX_STACK_LINE(1227)
					{
						HX_STACK_LINE(1227)
						Dynamic location = u->loc;		HX_STACK_VAR(location,"location");
						HX_STACK_LINE(1227)
						::openfl::gl::GL_obj::lime_gl_uniform1i(location,u->index);
					}
				}
			}
			;break;
			case (int)0: {
				HX_STACK_LINE(1231)
				Float f = val;		HX_STACK_VAR(f,"f");
				HX_STACK_LINE(1231)
				{
					HX_STACK_LINE(1231)
					Dynamic location = u->loc;		HX_STACK_VAR(location,"location");
					HX_STACK_LINE(1231)
					::openfl::gl::GL_obj::lime_gl_uniform1f(location,f);
				}
			}
			;break;
			case (int)1: {
				HX_STACK_LINE(1232)
				::h3d::Vector v = val;		HX_STACK_VAR(v,"v");
				HX_STACK_LINE(1232)
				{
					HX_STACK_LINE(1232)
					Dynamic location = u->loc;		HX_STACK_VAR(location,"location");
					HX_STACK_LINE(1232)
					::openfl::gl::GL_obj::lime_gl_uniform2f(location,v->x,v->y);
				}
			}
			;break;
			case (int)2: {
				HX_STACK_LINE(1233)
				::h3d::Vector v = val;		HX_STACK_VAR(v,"v");
				HX_STACK_LINE(1233)
				{
					HX_STACK_LINE(1233)
					Dynamic location = u->loc;		HX_STACK_VAR(location,"location");
					HX_STACK_LINE(1233)
					::openfl::gl::GL_obj::lime_gl_uniform3f(location,v->x,v->y,v->z);
				}
			}
			;break;
			case (int)3: {
				HX_STACK_LINE(1234)
				::h3d::Vector v = val;		HX_STACK_VAR(v,"v");
				HX_STACK_LINE(1234)
				{
					HX_STACK_LINE(1234)
					Dynamic location = u->loc;		HX_STACK_VAR(location,"location");
					HX_STACK_LINE(1234)
					::openfl::gl::GL_obj::lime_gl_uniform4f(location,v->x,v->y,v->z,v->w);
				}
			}
			;break;
			case (int)11: {
				HX_STACK_LINE(1206)
				::h3d::impl::ShaderType t1 = (::h3d::impl::ShaderType(t))->__Param(1);		HX_STACK_VAR(t1,"t1");
				HX_STACK_LINE(1206)
				::String field = (::h3d::impl::ShaderType(t))->__Param(0);		HX_STACK_VAR(field,"field");
				HX_STACK_LINE(1236)
				{
					HX_STACK_LINE(1237)
					Dynamic vs = ::Reflect_obj::field(val,field);		HX_STACK_VAR(vs,"vs");
					HX_STACK_LINE(1239)
					if (((t1 == null()))){
						HX_STACK_LINE(1239)
						::String _g3 = ::Std_obj::string(t1);		HX_STACK_VAR(_g3,"_g3");
						HX_STACK_LINE(1239)
						HX_STACK_DO_THROW((HX_CSTRING("Missing shader type ") + _g3));
					}
					HX_STACK_LINE(1240)
					if (((u == null()))){
						HX_STACK_LINE(1240)
						::String _g4 = ::Std_obj::string(u);		HX_STACK_VAR(_g4,"_g4");
						HX_STACK_LINE(1240)
						HX_STACK_DO_THROW((HX_CSTRING("Missing shader loc ") + _g4));
					}
					HX_STACK_LINE(1241)
					if (((vs == null()))){
						HX_STACK_LINE(1241)
						::String _g5 = ::Std_obj::string(val);		HX_STACK_VAR(_g5,"_g5");
						HX_STACK_LINE(1241)
						HX_STACK_DO_THROW((((HX_CSTRING("Missing shader field ") + field) + HX_CSTRING(" in ")) + _g5));
					}
					HX_STACK_LINE(1243)
					this->setUniform(vs,u,t1,shaderChange);
				}
			}
			;break;
			case (int)13: {
				HX_STACK_LINE(1206)
				::h3d::impl::ShaderType t1 = (::h3d::impl::ShaderType(t))->__Param(2);		HX_STACK_VAR(t1,"t1");
				HX_STACK_LINE(1206)
				Dynamic nb = (::h3d::impl::ShaderType(t))->__Param(1);		HX_STACK_VAR(nb,"nb");
				HX_STACK_LINE(1206)
				::String field = (::h3d::impl::ShaderType(t))->__Param(0);		HX_STACK_VAR(field,"field");
				HX_STACK_LINE(1245)
				{
					HX_STACK_LINE(1247)
					switch( (int)(t1->__Index())){
						case (int)2: {
							HX_STACK_LINE(1249)
							Array< ::Dynamic > arr = ::Reflect_obj::field(val,field);		HX_STACK_VAR(arr,"arr");
							HX_STACK_LINE(1250)
							if (((arr->length > nb))){
								HX_STACK_LINE(1250)
								Array< ::Dynamic > _g6 = arr->slice((int)0,nb);		HX_STACK_VAR(_g6,"_g6");
								HX_STACK_LINE(1250)
								arr = _g6;
							}
							HX_STACK_LINE(1251)
							{
								HX_STACK_LINE(1251)
								Dynamic location = u->loc;		HX_STACK_VAR(location,"location");
								HX_STACK_LINE(1251)
								Dynamic v;		HX_STACK_VAR(v,"v");
								HX_STACK_LINE(1251)
								{
									HX_STACK_LINE(1251)
									::openfl::utils::Float32Array _g7 = this->packArray3(arr);		HX_STACK_VAR(_g7,"_g7");
									HX_STACK_LINE(1251)
									::openfl::utils::Float32Array f = buff = _g7;		HX_STACK_VAR(f,"f");
									HX_STACK_LINE(1251)
									Dynamic data = f->getByteBuffer();		HX_STACK_VAR(data,"data");
									HX_STACK_LINE(1251)
									v = data;
								}
								HX_STACK_LINE(1251)
								::openfl::gl::GL_obj::lime_gl_uniform3fv(location,v);
							}
						}
						;break;
						case (int)3: {
							HX_STACK_LINE(1254)
							Array< ::Dynamic > arr = ::Reflect_obj::field(val,field);		HX_STACK_VAR(arr,"arr");
							HX_STACK_LINE(1255)
							if (((arr->length > nb))){
								HX_STACK_LINE(1255)
								Array< ::Dynamic > _g8 = arr->slice((int)0,nb);		HX_STACK_VAR(_g8,"_g8");
								HX_STACK_LINE(1255)
								arr = _g8;
							}
							HX_STACK_LINE(1256)
							{
								HX_STACK_LINE(1256)
								Dynamic location = u->loc;		HX_STACK_VAR(location,"location");
								HX_STACK_LINE(1256)
								Dynamic v;		HX_STACK_VAR(v,"v");
								HX_STACK_LINE(1256)
								{
									HX_STACK_LINE(1256)
									::openfl::utils::Float32Array _g9 = this->packArray4(arr);		HX_STACK_VAR(_g9,"_g9");
									HX_STACK_LINE(1256)
									::openfl::utils::Float32Array f = buff = _g9;		HX_STACK_VAR(f,"f");
									HX_STACK_LINE(1256)
									Dynamic data = f->getByteBuffer();		HX_STACK_VAR(data,"data");
									HX_STACK_LINE(1256)
									v = data;
								}
								HX_STACK_LINE(1256)
								::openfl::gl::GL_obj::lime_gl_uniform4fv(location,v);
							}
						}
						;break;
						case (int)6: {
							HX_STACK_LINE(1259)
							Array< ::Dynamic > ms = val;		HX_STACK_VAR(ms,"ms");
							HX_STACK_LINE(1260)
							if (((bool((nb != null())) && bool((ms->length != nb))))){
								HX_STACK_LINE(1260)
								Dynamic msg = ((((HX_CSTRING("Array uniform type mismatch ") + nb) + HX_CSTRING(" requested, ")) + ms->length) + HX_CSTRING(" found"));		HX_STACK_VAR(msg,"msg");
								HX_STACK_LINE(1260)
								::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
								HX_STACK_LINE(1260)
								int pos_lineNumber = (int)1260;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
								HX_STACK_LINE(1260)
								::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
								HX_STACK_LINE(1260)
								::String pos_methodName = HX_CSTRING("setUniform");		HX_STACK_VAR(pos_methodName,"pos_methodName");
								HX_STACK_LINE(1260)
								if (((::hxd::System_obj::debugLevel >= (int)3))){
									HX_STACK_LINE(1260)
									::String _g10 = ::Std_obj::string(msg);		HX_STACK_VAR(_g10,"_g10");
									HX_STACK_LINE(1260)
									::String _g11 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g10);		HX_STACK_VAR(_g11,"_g11");
									HX_STACK_LINE(1260)
									::haxe::Log_obj::trace(_g11,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
								}
								HX_STACK_LINE(1260)
								msg;
							}
							HX_STACK_LINE(1262)
							{
								HX_STACK_LINE(1262)
								Dynamic location = u->loc;		HX_STACK_VAR(location,"location");
								HX_STACK_LINE(1262)
								Dynamic v;		HX_STACK_VAR(v,"v");
								HX_STACK_LINE(1262)
								{
									HX_STACK_LINE(1262)
									::openfl::utils::Float32Array _g13;		HX_STACK_VAR(_g13,"_g13");
									HX_STACK_LINE(1262)
									{
										HX_STACK_LINE(1262)
										::openfl::utils::Float32Array t2 = this->createF32((ms->length * (int)16));		HX_STACK_VAR(t2,"t2");
										HX_STACK_LINE(1262)
										int p = (int)0;		HX_STACK_VAR(p,"p");
										HX_STACK_LINE(1262)
										{
											HX_STACK_LINE(1262)
											int _g = (int)0;		HX_STACK_VAR(_g,"_g");
											HX_STACK_LINE(1262)
											while((true)){
												HX_STACK_LINE(1262)
												if ((!(((_g < ms->length))))){
													HX_STACK_LINE(1262)
													break;
												}
												HX_STACK_LINE(1262)
												::h3d::Matrix m = ms->__get(_g).StaticCast< ::h3d::Matrix >();		HX_STACK_VAR(m,"m");
												HX_STACK_LINE(1262)
												++(_g);
												HX_STACK_LINE(1262)
												{
													HX_STACK_LINE(1262)
													::openfl::utils::Float32Array t3 = t2;		HX_STACK_VAR(t3,"t3");
													HX_STACK_LINE(1262)
													if (((t3 == null()))){
														HX_STACK_LINE(1262)
														::openfl::utils::Float32Array _g12 = this->createF32((int)16);		HX_STACK_VAR(_g12,"_g12");
														HX_STACK_LINE(1262)
														t3 = _g12;
													}
													HX_STACK_LINE(1262)
													{
														HX_STACK_LINE(1262)
														hx::__ArrayImplRef(t3,p) = m->_11;
														HX_STACK_LINE(1262)
														hx::__ArrayImplRef(t3,(p + (int)1)) = m->_21;
														HX_STACK_LINE(1262)
														hx::__ArrayImplRef(t3,(p + (int)2)) = m->_31;
														HX_STACK_LINE(1262)
														hx::__ArrayImplRef(t3,(p + (int)3)) = m->_41;
														HX_STACK_LINE(1262)
														hx::__ArrayImplRef(t3,(p + (int)4)) = m->_12;
														HX_STACK_LINE(1262)
														hx::__ArrayImplRef(t3,(p + (int)5)) = m->_22;
														HX_STACK_LINE(1262)
														hx::__ArrayImplRef(t3,(p + (int)6)) = m->_32;
														HX_STACK_LINE(1262)
														hx::__ArrayImplRef(t3,(p + (int)7)) = m->_42;
														HX_STACK_LINE(1262)
														hx::__ArrayImplRef(t3,(p + (int)8)) = m->_13;
														HX_STACK_LINE(1262)
														hx::__ArrayImplRef(t3,(p + (int)9)) = m->_23;
														HX_STACK_LINE(1262)
														hx::__ArrayImplRef(t3,(p + (int)10)) = m->_33;
														HX_STACK_LINE(1262)
														hx::__ArrayImplRef(t3,(p + (int)11)) = m->_43;
														HX_STACK_LINE(1262)
														hx::__ArrayImplRef(t3,(p + (int)12)) = m->_14;
														HX_STACK_LINE(1262)
														hx::__ArrayImplRef(t3,(p + (int)13)) = m->_24;
														HX_STACK_LINE(1262)
														hx::__ArrayImplRef(t3,(p + (int)14)) = m->_34;
														HX_STACK_LINE(1262)
														hx::__ArrayImplRef(t3,(p + (int)15)) = m->_44;
													}
													HX_STACK_LINE(1262)
													t3;
												}
												HX_STACK_LINE(1262)
												hx::AddEq(p,(int)16);
											}
										}
										HX_STACK_LINE(1262)
										_g13 = t2;
									}
									HX_STACK_LINE(1262)
									::openfl::utils::Float32Array f = buff = _g13;		HX_STACK_VAR(f,"f");
									HX_STACK_LINE(1262)
									Dynamic data = f->getByteBuffer();		HX_STACK_VAR(data,"data");
									HX_STACK_LINE(1262)
									v = data;
								}
								HX_STACK_LINE(1262)
								::openfl::gl::GL_obj::lime_gl_uniform_matrix(location,false,v,(int)4);
							}
						}
						;break;
						default: {
							HX_STACK_LINE(1265)
							HX_STACK_DO_THROW(HX_CSTRING("not supported"));
						}
					}
					HX_STACK_LINE(1267)
					this->deleteF32(buff);
				}
			}
			;break;
			case (int)12: {
				HX_STACK_LINE(1206)
				::h3d::impl::ShaderType t1 = (::h3d::impl::ShaderType(t))->__Param(1);		HX_STACK_VAR(t1,"t1");
				HX_STACK_LINE(1206)
				int index = (::h3d::impl::ShaderType(t))->__Param(0);		HX_STACK_VAR(index,"index");
				HX_STACK_LINE(1270)
				{
					HX_STACK_LINE(1271)
					Dynamic v = val->__GetItem(index);		HX_STACK_VAR(v,"v");
					HX_STACK_LINE(1272)
					if (((v == null()))){
						HX_STACK_LINE(1272)
						HX_STACK_DO_THROW((HX_CSTRING("Missing shader index ") + index));
					}
					HX_STACK_LINE(1273)
					this->setUniform(v,u,t1,shaderChange);
				}
			}
			;break;
			case (int)10: {
				HX_STACK_LINE(1275)
				int v = val;		HX_STACK_VAR(v,"v");
				HX_STACK_LINE(1276)
				{
					HX_STACK_LINE(1276)
					Dynamic location = u->loc;		HX_STACK_VAR(location,"location");
					HX_STACK_LINE(1276)
					::openfl::gl::GL_obj::lime_gl_uniform4f(location,(Float(((int((int(v) >> int((int)16))) & int((int)255)))) / Float((int)255)),(Float(((int((int(v) >> int((int)8))) & int((int)255)))) / Float((int)255)),(Float(((int(v) & int((int)255)))) / Float((int)255)),(Float((hx::UShr(v,(int)24))) / Float((int)255)));
				}
			}
			;break;
			case (int)9: {
				HX_STACK_LINE(1278)
				int v = val;		HX_STACK_VAR(v,"v");
				HX_STACK_LINE(1279)
				{
					HX_STACK_LINE(1279)
					Dynamic location = u->loc;		HX_STACK_VAR(location,"location");
					HX_STACK_LINE(1279)
					::openfl::gl::GL_obj::lime_gl_uniform3f(location,(Float(((int((int(v) >> int((int)16))) & int((int)255)))) / Float((int)255)),(Float(((int((int(v) >> int((int)8))) & int((int)255)))) / Float((int)255)),(Float(((int(v) & int((int)255)))) / Float((int)255)));
				}
			}
			;break;
			default: {
				HX_STACK_LINE(1281)
				::String _g14 = ::Std_obj::string(u->type);		HX_STACK_VAR(_g14,"_g14");
				HX_STACK_LINE(1281)
				HX_STACK_DO_THROW((HX_CSTRING("Unsupported uniform ") + _g14));
			}
		}
		HX_STACK_LINE(1285)
		{
			HX_STACK_LINE(1285)
			int _g15 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g15,"_g15");
			HX_STACK_LINE(1285)
			if (((_g15 != (int)0))){
				HX_STACK_LINE(1285)
				::String s;		HX_STACK_VAR(s,"s");
				HX_STACK_LINE(1285)
				{
					HX_STACK_LINE(1285)
					int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(1285)
					switch( (int)(_g)){
						case (int)0: {
							HX_STACK_LINE(1285)
							s = null();
						}
						;break;
						case (int)1280: {
							HX_STACK_LINE(1285)
							s = HX_CSTRING("INVALID_ENUM");
						}
						;break;
						case (int)1281: {
							HX_STACK_LINE(1285)
							s = HX_CSTRING("INVALID_VALUE");
						}
						;break;
						case (int)1282: {
							HX_STACK_LINE(1285)
							s = HX_CSTRING("INVALID_OPERATION");
						}
						;break;
						case (int)1285: {
							HX_STACK_LINE(1285)
							s = HX_CSTRING("OUT_OF_MEMORY");
						}
						;break;
						default: {
							HX_STACK_LINE(1285)
							s = null();
						}
					}
				}
				HX_STACK_LINE(1285)
				if (((s != null()))){
					HX_STACK_LINE(1285)
					::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
					HX_STACK_LINE(1285)
					::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
					HX_STACK_LINE(1285)
					HX_STACK_DO_THROW(s);
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(GlDriver_obj,setUniform,(void))

::openfl::utils::Float32Array GlDriver_obj::packArray4( Array< ::Dynamic > vecs){
	HX_STACK_FRAME("h3d.impl.GlDriver","packArray4",0x94510bfc,"h3d.impl.GlDriver.packArray4","h3d/impl/GlDriver.hx",1289,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_ARG(vecs,"vecs")
	HX_STACK_LINE(1290)
	::openfl::utils::Float32Array a = this->createF32((vecs->length * (int)4));		HX_STACK_VAR(a,"a");
	HX_STACK_LINE(1291)
	{
		HX_STACK_LINE(1291)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(1291)
		int _g = vecs->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(1291)
		while((true)){
			HX_STACK_LINE(1291)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(1291)
				break;
			}
			HX_STACK_LINE(1291)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(1292)
			::h3d::Vector vec = vecs->__get(i).StaticCast< ::h3d::Vector >();		HX_STACK_VAR(vec,"vec");
			HX_STACK_LINE(1293)
			hx::__ArrayImplRef(a,(i * (int)4)) = vec->x;
			HX_STACK_LINE(1294)
			hx::__ArrayImplRef(a,((i * (int)4) + (int)1)) = vec->y;
			HX_STACK_LINE(1295)
			hx::__ArrayImplRef(a,((i * (int)4) + (int)2)) = vec->z;
			HX_STACK_LINE(1296)
			hx::__ArrayImplRef(a,((i * (int)4) + (int)3)) = vec->w;
		}
	}
	HX_STACK_LINE(1298)
	return a;
}


HX_DEFINE_DYNAMIC_FUNC1(GlDriver_obj,packArray4,return )

::openfl::utils::Float32Array GlDriver_obj::packArray3( Array< ::Dynamic > vecs){
	HX_STACK_FRAME("h3d.impl.GlDriver","packArray3",0x94510bfb,"h3d.impl.GlDriver.packArray3","h3d/impl/GlDriver.hx",1302,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_ARG(vecs,"vecs")
	HX_STACK_LINE(1303)
	::openfl::utils::Float32Array a = this->createF32((vecs->length * (int)4));		HX_STACK_VAR(a,"a");
	HX_STACK_LINE(1304)
	{
		HX_STACK_LINE(1304)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(1304)
		int _g = vecs->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(1304)
		while((true)){
			HX_STACK_LINE(1304)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(1304)
				break;
			}
			HX_STACK_LINE(1304)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(1305)
			::h3d::Vector vec = vecs->__get(i).StaticCast< ::h3d::Vector >();		HX_STACK_VAR(vec,"vec");
			HX_STACK_LINE(1306)
			hx::__ArrayImplRef(a,(i * (int)3)) = vec->x;
			HX_STACK_LINE(1307)
			hx::__ArrayImplRef(a,((i * (int)3) + (int)1)) = vec->y;
			HX_STACK_LINE(1308)
			hx::__ArrayImplRef(a,((i * (int)3) + (int)2)) = vec->z;
		}
	}
	HX_STACK_LINE(1310)
	return a;
}


HX_DEFINE_DYNAMIC_FUNC1(GlDriver_obj,packArray3,return )

Void GlDriver_obj::selectBuffer( ::h3d::impl::GLVB v){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","selectBuffer",0xdfae52e4,"h3d.impl.GlDriver.selectBuffer","h3d/impl/GlDriver.hx",1316,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(1318)
		::h3d::impl::GLVB ob = this->curBuffer;		HX_STACK_VAR(ob,"ob");
		HX_STACK_LINE(1320)
		this->curBuffer = v;
		HX_STACK_LINE(1321)
		this->curMultiBuffer = null();
		HX_STACK_LINE(1323)
		int stride = v->stride;		HX_STACK_VAR(stride,"stride");
		HX_STACK_LINE(1324)
		if (((ob != v))){
			HX_STACK_LINE(1325)
			{
				HX_STACK_LINE(1325)
				::openfl::gl::GLBuffer buffer = v->b;		HX_STACK_VAR(buffer,"buffer");
				HX_STACK_LINE(1325)
				::openfl::gl::GL_obj::lime_gl_bind_buffer((int)34962,(  (((buffer == null()))) ? Dynamic(null()) : Dynamic(buffer->id) ));
			}
			HX_STACK_LINE(1326)
			Dynamic();
		}
		else{
			HX_STACK_LINE(1329)
			Dynamic();
		}
		HX_STACK_LINE(1331)
		{
			HX_STACK_LINE(1331)
			int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(1331)
			if (((_g != (int)0))){
				HX_STACK_LINE(1331)
				::String s;		HX_STACK_VAR(s,"s");
				HX_STACK_LINE(1331)
				{
					HX_STACK_LINE(1331)
					int _g1 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(1331)
					switch( (int)(_g1)){
						case (int)0: {
							HX_STACK_LINE(1331)
							s = null();
						}
						;break;
						case (int)1280: {
							HX_STACK_LINE(1331)
							s = HX_CSTRING("INVALID_ENUM");
						}
						;break;
						case (int)1281: {
							HX_STACK_LINE(1331)
							s = HX_CSTRING("INVALID_VALUE");
						}
						;break;
						case (int)1282: {
							HX_STACK_LINE(1331)
							s = HX_CSTRING("INVALID_OPERATION");
						}
						;break;
						case (int)1285: {
							HX_STACK_LINE(1331)
							s = HX_CSTRING("OUT_OF_MEMORY");
						}
						;break;
						default: {
							HX_STACK_LINE(1331)
							s = null();
						}
					}
				}
				HX_STACK_LINE(1331)
				if (((s != null()))){
					HX_STACK_LINE(1331)
					::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
					HX_STACK_LINE(1331)
					::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
					HX_STACK_LINE(1331)
					HX_STACK_DO_THROW(s);
				}
			}
		}
		HX_STACK_LINE(1337)
		{
			HX_STACK_LINE(1337)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(1337)
			Array< ::Dynamic > _g1 = this->curShader->attribs;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(1337)
			while((true)){
				HX_STACK_LINE(1337)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(1337)
					break;
				}
				HX_STACK_LINE(1337)
				::h3d::impl::Attribute a = _g1->__get(_g).StaticCast< ::h3d::impl::Attribute >();		HX_STACK_VAR(a,"a");
				HX_STACK_LINE(1337)
				++(_g);
				HX_STACK_LINE(1338)
				int ofs = (a->offset * (int)4);		HX_STACK_VAR(ofs,"ofs");
				HX_STACK_LINE(1339)
				::openfl::gl::GL_obj::lime_gl_vertex_attrib_pointer(a->index,a->size,a->etype,false,(stride * (int)4),ofs);
				HX_STACK_LINE(1340)
				{
					HX_STACK_LINE(1340)
					::String _g11 = ::Std_obj::string(a);		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(1340)
					::String _g2 = (HX_CSTRING("selectBuffer: set vertex attrib: ") + _g11);		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(1340)
					::String _g3 = (_g2 + HX_CSTRING(" stride:"));		HX_STACK_VAR(_g3,"_g3");
					HX_STACK_LINE(1340)
					::String _g4 = (_g3 + (stride * (int)4));		HX_STACK_VAR(_g4,"_g4");
					HX_STACK_LINE(1340)
					::String _g5 = (_g4 + HX_CSTRING(" ofs:"));		HX_STACK_VAR(_g5,"_g5");
					HX_STACK_LINE(1340)
					::String _ = (_g5 + ofs);		HX_STACK_VAR(_,"_");
					HX_STACK_LINE(1340)
					Dynamic();
				}
			}
		}
		HX_STACK_LINE(1344)
		{
			HX_STACK_LINE(1344)
			int _g6 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g6,"_g6");
			HX_STACK_LINE(1344)
			if (((_g6 != (int)0))){
				HX_STACK_LINE(1344)
				::String s;		HX_STACK_VAR(s,"s");
				HX_STACK_LINE(1344)
				{
					HX_STACK_LINE(1344)
					int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(1344)
					switch( (int)(_g)){
						case (int)0: {
							HX_STACK_LINE(1344)
							s = null();
						}
						;break;
						case (int)1280: {
							HX_STACK_LINE(1344)
							s = HX_CSTRING("INVALID_ENUM");
						}
						;break;
						case (int)1281: {
							HX_STACK_LINE(1344)
							s = HX_CSTRING("INVALID_VALUE");
						}
						;break;
						case (int)1282: {
							HX_STACK_LINE(1344)
							s = HX_CSTRING("INVALID_OPERATION");
						}
						;break;
						case (int)1285: {
							HX_STACK_LINE(1344)
							s = HX_CSTRING("OUT_OF_MEMORY");
						}
						;break;
						default: {
							HX_STACK_LINE(1344)
							s = null();
						}
					}
				}
				HX_STACK_LINE(1344)
				if (((s != null()))){
					HX_STACK_LINE(1344)
					::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
					HX_STACK_LINE(1344)
					::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
					HX_STACK_LINE(1344)
					HX_STACK_DO_THROW(s);
				}
			}
		}
	}
return null();
}


Void GlDriver_obj::selectMultiBuffers( Array< ::Dynamic > buffers){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","selectMultiBuffers",0x7c9e8ade,"h3d.impl.GlDriver.selectMultiBuffers","h3d/impl/GlDriver.hx",1347,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_ARG(buffers,"buffers")
		HX_STACK_LINE(1348)
		bool changed = (bool((this->curMultiBuffer == null())) || bool((this->curMultiBuffer->length != buffers->length)));		HX_STACK_VAR(changed,"changed");
		HX_STACK_LINE(1352)
		if ((!(changed))){
			HX_STACK_LINE(1353)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(1353)
			int _g = this->curMultiBuffer->length;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(1353)
			while((true)){
				HX_STACK_LINE(1353)
				if ((!(((_g1 < _g))))){
					HX_STACK_LINE(1353)
					break;
				}
				HX_STACK_LINE(1353)
				int i = (_g1)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(1354)
				if (((buffers->__get(i).StaticCast< ::h3d::impl::BufferOffset >() != this->curMultiBuffer->__get(i).StaticCast< ::h3d::impl::BufferOffset >()))){
					HX_STACK_LINE(1355)
					changed = true;
					HX_STACK_LINE(1356)
					break;
				}
			}
		}
		HX_STACK_LINE(1359)
		if ((changed)){
			HX_STACK_LINE(1360)
			{
				HX_STACK_LINE(1360)
				int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(1360)
				int _g = buffers->length;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(1360)
				while((true)){
					HX_STACK_LINE(1360)
					if ((!(((_g1 < _g))))){
						HX_STACK_LINE(1360)
						break;
					}
					HX_STACK_LINE(1360)
					int i = (_g1)++;		HX_STACK_VAR(i,"i");
					HX_STACK_LINE(1361)
					::h3d::impl::BufferOffset b = buffers->__get(i).StaticCast< ::h3d::impl::BufferOffset >();		HX_STACK_VAR(b,"b");
					HX_STACK_LINE(1362)
					::h3d::impl::Attribute a = this->curShader->attribs->__get(i).StaticCast< ::h3d::impl::Attribute >();		HX_STACK_VAR(a,"a");
					HX_STACK_LINE(1363)
					{
						HX_STACK_LINE(1363)
						::openfl::gl::GLBuffer buffer = b->b->b->vbuf->b;		HX_STACK_VAR(buffer,"buffer");
						HX_STACK_LINE(1363)
						::openfl::gl::GL_obj::lime_gl_bind_buffer((int)34962,(  (((buffer == null()))) ? Dynamic(null()) : Dynamic(buffer->id) ));
					}
					HX_STACK_LINE(1366)
					if ((!(b->shared))){
						HX_STACK_LINE(1367)
						::openfl::gl::GL_obj::lime_gl_vertex_attrib_pointer(a->index,a->size,a->etype,false,(int)0,(int)0);
						HX_STACK_LINE(1369)
						{
							HX_STACK_LINE(1369)
							::String _g2 = ::Std_obj::string(a);		HX_STACK_VAR(_g2,"_g2");
							HX_STACK_LINE(1369)
							::String _ = (HX_CSTRING("selectMultiBuffer: set vertex attrib not shared: ") + _g2);		HX_STACK_VAR(_,"_");
							HX_STACK_LINE(1369)
							Dynamic();
						}
					}
					else{
						HX_STACK_LINE(1372)
						{
							HX_STACK_LINE(1372)
							int stride = b->stride;		HX_STACK_VAR(stride,"stride");
							HX_STACK_LINE(1372)
							::openfl::gl::GL_obj::lime_gl_vertex_attrib_pointer(a->index,a->size,a->etype,false,stride,(b->offset * (int)4));
						}
						HX_STACK_LINE(1373)
						{
							HX_STACK_LINE(1373)
							::String _g11 = ::Std_obj::string(a);		HX_STACK_VAR(_g11,"_g11");
							HX_STACK_LINE(1373)
							::String _ = (HX_CSTRING("selectMultiBuffer: set vertex attrib shared: ") + _g11);		HX_STACK_VAR(_,"_");
							HX_STACK_LINE(1373)
							Dynamic();
						}
					}
					HX_STACK_LINE(1376)
					{
						HX_STACK_LINE(1376)
						int _g2 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g2,"_g2");
						HX_STACK_LINE(1376)
						if (((_g2 != (int)0))){
							HX_STACK_LINE(1376)
							::String s;		HX_STACK_VAR(s,"s");
							HX_STACK_LINE(1376)
							{
								HX_STACK_LINE(1376)
								int _g3 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g3,"_g3");
								HX_STACK_LINE(1376)
								switch( (int)(_g3)){
									case (int)0: {
										HX_STACK_LINE(1376)
										s = null();
									}
									;break;
									case (int)1280: {
										HX_STACK_LINE(1376)
										s = HX_CSTRING("INVALID_ENUM");
									}
									;break;
									case (int)1281: {
										HX_STACK_LINE(1376)
										s = HX_CSTRING("INVALID_VALUE");
									}
									;break;
									case (int)1282: {
										HX_STACK_LINE(1376)
										s = HX_CSTRING("INVALID_OPERATION");
									}
									;break;
									case (int)1285: {
										HX_STACK_LINE(1376)
										s = HX_CSTRING("OUT_OF_MEMORY");
									}
									;break;
									default: {
										HX_STACK_LINE(1376)
										s = null();
									}
								}
							}
							HX_STACK_LINE(1376)
							if (((s != null()))){
								HX_STACK_LINE(1376)
								::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
								HX_STACK_LINE(1376)
								::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
								HX_STACK_LINE(1376)
								HX_STACK_DO_THROW(s);
							}
						}
					}
				}
			}
			HX_STACK_LINE(1379)
			this->curBuffer = null();
			HX_STACK_LINE(1380)
			this->curMultiBuffer = buffers;
		}
	}
return null();
}


Void GlDriver_obj::checkObject( ::openfl::gl::GLObject o){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","checkObject",0x692900df,"h3d.impl.GlDriver.checkObject","h3d/impl/GlDriver.hx",1384,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_ARG(o,"o")
		HX_STACK_LINE(1386)
		{
			HX_STACK_LINE(1386)
			::String _g = o->toString();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(1386)
			::String _g1 = (_g + HX_CSTRING(" "));		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(1386)
			::String _g2 = o->getType();		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(1386)
			::String _g3 = (_g1 + _g2);		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(1386)
			::String _g4 = (_g3 + HX_CSTRING(" "));		HX_STACK_VAR(_g4,"_g4");
			HX_STACK_LINE(1386)
			bool _g5 = o->isValid();		HX_STACK_VAR(_g5,"_g5");
			HX_STACK_LINE(1386)
			::String _g6 = ::Std_obj::string(_g5);		HX_STACK_VAR(_g6,"_g6");
			HX_STACK_LINE(1386)
			Dynamic msg = (_g4 + _g6);		HX_STACK_VAR(msg,"msg");
			HX_STACK_LINE(1386)
			::String pos_fileName = HX_CSTRING("GlDriver.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
			HX_STACK_LINE(1386)
			int pos_lineNumber = (int)1386;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
			HX_STACK_LINE(1386)
			::String pos_className = HX_CSTRING("h3d.impl.GlDriver");		HX_STACK_VAR(pos_className,"pos_className");
			HX_STACK_LINE(1386)
			::String pos_methodName = HX_CSTRING("checkObject");		HX_STACK_VAR(pos_methodName,"pos_methodName");
			HX_STACK_LINE(1386)
			if (((::hxd::System_obj::debugLevel >= (int)2))){
				HX_STACK_LINE(1386)
				::String _g7 = ::Std_obj::string(msg);		HX_STACK_VAR(_g7,"_g7");
				HX_STACK_LINE(1386)
				::String _g8 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g7);		HX_STACK_VAR(_g8,"_g8");
				HX_STACK_LINE(1386)
				::haxe::Log_obj::trace(_g8,hx::SourceInfo(HX_CSTRING("System.hx"),315,HX_CSTRING("hxd.System"),HX_CSTRING("trace2")));
			}
			HX_STACK_LINE(1386)
			msg;
		}
		HX_STACK_LINE(1387)
		{
			HX_STACK_LINE(1387)
			bool o1 = o->isValid();		HX_STACK_VAR(o1,"o1");
			HX_STACK_LINE(1387)
			if (((false == o1))){
				HX_STACK_LINE(1387)
				::String _g9 = ::haxe::CallStack_obj::callStack()->join(HX_CSTRING(",\n"));		HX_STACK_VAR(_g9,"_g9");
				HX_STACK_LINE(1387)
				::String msg = ((((::hxd::Assert_obj::ASSERT_HEADER + HX_CSTRING("\n msg: ")) + (HX_CSTRING("value should be true\n"))) + HX_CSTRING("\nstatck:\n")) + _g9);		HX_STACK_VAR(msg,"msg");
				HX_STACK_LINE(1387)
				HX_STACK_DO_THROW(msg);
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(GlDriver_obj,checkObject,(void))

Void GlDriver_obj::draw( ::openfl::gl::GLBuffer ibuf,int startIndex,int ntriangles){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","draw",0x62f6c5cc,"h3d.impl.GlDriver.draw","h3d/impl/GlDriver.hx",1391,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ibuf,"ibuf")
		HX_STACK_ARG(startIndex,"startIndex")
		HX_STACK_ARG(ntriangles,"ntriangles")
		HX_STACK_LINE(1393)
		::openfl::gl::GL_obj::lime_gl_bind_buffer((int)34963,(  (((ibuf == null()))) ? Dynamic(null()) : Dynamic(ibuf->id) ));
		HX_STACK_LINE(1394)
		{
			HX_STACK_LINE(1394)
			int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(1394)
			if (((_g != (int)0))){
				HX_STACK_LINE(1394)
				::String s;		HX_STACK_VAR(s,"s");
				HX_STACK_LINE(1394)
				{
					HX_STACK_LINE(1394)
					int _g1 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(1394)
					switch( (int)(_g1)){
						case (int)0: {
							HX_STACK_LINE(1394)
							s = null();
						}
						;break;
						case (int)1280: {
							HX_STACK_LINE(1394)
							s = HX_CSTRING("INVALID_ENUM");
						}
						;break;
						case (int)1281: {
							HX_STACK_LINE(1394)
							s = HX_CSTRING("INVALID_VALUE");
						}
						;break;
						case (int)1282: {
							HX_STACK_LINE(1394)
							s = HX_CSTRING("INVALID_OPERATION");
						}
						;break;
						case (int)1285: {
							HX_STACK_LINE(1394)
							s = HX_CSTRING("OUT_OF_MEMORY");
						}
						;break;
						default: {
							HX_STACK_LINE(1394)
							s = null();
						}
					}
				}
				HX_STACK_LINE(1394)
				if (((s != null()))){
					HX_STACK_LINE(1394)
					::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
					HX_STACK_LINE(1394)
					::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
					HX_STACK_LINE(1394)
					HX_STACK_DO_THROW(s);
				}
			}
		}
		HX_STACK_LINE(1400)
		::openfl::gl::GL_obj::lime_gl_draw_elements((int)4,(ntriangles * (int)3),(int)5123,(startIndex * (int)2));
		HX_STACK_LINE(1401)
		{
			HX_STACK_LINE(1401)
			int _g1 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(1401)
			if (((_g1 != (int)0))){
				HX_STACK_LINE(1401)
				::String s;		HX_STACK_VAR(s,"s");
				HX_STACK_LINE(1401)
				{
					HX_STACK_LINE(1401)
					int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(1401)
					switch( (int)(_g)){
						case (int)0: {
							HX_STACK_LINE(1401)
							s = null();
						}
						;break;
						case (int)1280: {
							HX_STACK_LINE(1401)
							s = HX_CSTRING("INVALID_ENUM");
						}
						;break;
						case (int)1281: {
							HX_STACK_LINE(1401)
							s = HX_CSTRING("INVALID_VALUE");
						}
						;break;
						case (int)1282: {
							HX_STACK_LINE(1401)
							s = HX_CSTRING("INVALID_OPERATION");
						}
						;break;
						case (int)1285: {
							HX_STACK_LINE(1401)
							s = HX_CSTRING("OUT_OF_MEMORY");
						}
						;break;
						default: {
							HX_STACK_LINE(1401)
							s = null();
						}
					}
				}
				HX_STACK_LINE(1401)
				if (((s != null()))){
					HX_STACK_LINE(1401)
					::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
					HX_STACK_LINE(1401)
					::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
					HX_STACK_LINE(1401)
					HX_STACK_DO_THROW(s);
				}
			}
		}
		HX_STACK_LINE(1405)
		::openfl::gl::GL_obj::lime_gl_bind_buffer((int)34963,null());
		HX_STACK_LINE(1406)
		{
			HX_STACK_LINE(1406)
			int _g2 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(1406)
			if (((_g2 != (int)0))){
				HX_STACK_LINE(1406)
				::String s;		HX_STACK_VAR(s,"s");
				HX_STACK_LINE(1406)
				{
					HX_STACK_LINE(1406)
					int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(1406)
					switch( (int)(_g)){
						case (int)0: {
							HX_STACK_LINE(1406)
							s = null();
						}
						;break;
						case (int)1280: {
							HX_STACK_LINE(1406)
							s = HX_CSTRING("INVALID_ENUM");
						}
						;break;
						case (int)1281: {
							HX_STACK_LINE(1406)
							s = HX_CSTRING("INVALID_VALUE");
						}
						;break;
						case (int)1282: {
							HX_STACK_LINE(1406)
							s = HX_CSTRING("INVALID_OPERATION");
						}
						;break;
						case (int)1285: {
							HX_STACK_LINE(1406)
							s = HX_CSTRING("OUT_OF_MEMORY");
						}
						;break;
						default: {
							HX_STACK_LINE(1406)
							s = null();
						}
					}
				}
				HX_STACK_LINE(1406)
				if (((s != null()))){
					HX_STACK_LINE(1406)
					::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
					HX_STACK_LINE(1406)
					::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
					HX_STACK_LINE(1406)
					HX_STACK_DO_THROW(s);
				}
			}
		}
		HX_STACK_LINE(1407)
		Dynamic();
	}
return null();
}


Void GlDriver_obj::present( ){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","present",0x56edee33,"h3d.impl.GlDriver.present","h3d/impl/GlDriver.hx",1410,0xae6eb278)
		HX_STACK_THIS(this)
	}
return null();
}


bool GlDriver_obj::isDisposed( ){
	HX_STACK_FRAME("h3d.impl.GlDriver","isDisposed",0xbc173cb7,"h3d.impl.GlDriver.isDisposed","h3d/impl/GlDriver.hx",1418,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_LINE(1418)
	return false;
}


Void GlDriver_obj::init( Dynamic onCreate,hx::Null< bool >  __o_forceSoftware){
bool forceSoftware = __o_forceSoftware.Default(false);
	HX_STACK_FRAME("h3d.impl.GlDriver","init",0x6641d4d8,"h3d.impl.GlDriver.init","h3d/impl/GlDriver.hx",1421,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_ARG(onCreate,"onCreate")
	HX_STACK_ARG(forceSoftware,"forceSoftware")
{
		HX_STACK_LINE(1422)
		Dynamic _g;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(1422)
		{
			HX_STACK_LINE(1422)
			Dynamic f = Dynamic( Array_obj<Dynamic>::__new().Add(onCreate));		HX_STACK_VAR(f,"f");

			HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_2_1,Dynamic,f)
			Void run(){
				HX_STACK_FRAME("*","_Function_2_1",0x5201af78,"*._Function_2_1","h3d/impl/GlDriver.hx",1422,0xae6eb278)
				{
					HX_STACK_LINE(1422)
					return null(f->__GetItem((int)0)(false).Cast< Void >());
				}
				return null();
			}
			HX_END_LOCAL_FUNC0((void))

			HX_STACK_LINE(1422)
			_g =  Dynamic(new _Function_2_1(f));
		}
		HX_STACK_LINE(1422)
		::haxe::Timer_obj::delay(_g,(int)1);
	}
return null();
}


::String GlDriver_obj::glCompareToString( int c){
	HX_STACK_FRAME("h3d.impl.GlDriver","glCompareToString",0x88e81b04,"h3d.impl.GlDriver.glCompareToString","h3d/impl/GlDriver.hx",1473,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_ARG(c,"c")
	HX_STACK_LINE(1473)
	switch( (int)(c)){
		case (int)519: {
			HX_STACK_LINE(1474)
			return HX_CSTRING("ALWAYS");
		}
		;break;
		case (int)512: {
			HX_STACK_LINE(1475)
			return HX_CSTRING("NEVER");
		}
		;break;
		case (int)514: {
			HX_STACK_LINE(1476)
			return HX_CSTRING("EQUAL");
		}
		;break;
		case (int)517: {
			HX_STACK_LINE(1477)
			return HX_CSTRING("NOTEQUAL");
		}
		;break;
		case (int)516: {
			HX_STACK_LINE(1478)
			return HX_CSTRING("GREATER");
		}
		;break;
		case (int)518: {
			HX_STACK_LINE(1479)
			return HX_CSTRING("GEQUAL");
		}
		;break;
		case (int)513: {
			HX_STACK_LINE(1480)
			return HX_CSTRING("LESS");
		}
		;break;
		case (int)515: {
			HX_STACK_LINE(1481)
			return HX_CSTRING("LEQUAL");
		}
		;break;
		default: {
			HX_STACK_LINE(1482)
			return HX_CSTRING("Unknown");
		}
	}
	HX_STACK_LINE(1473)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(GlDriver_obj,glCompareToString,return )

Void GlDriver_obj::checkError( ){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","checkError",0x9cddeda8,"h3d.impl.GlDriver.checkError","h3d/impl/GlDriver.hx",1487,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_LINE(1489)
		int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(1489)
		if (((_g != (int)0))){
			HX_STACK_LINE(1491)
			::String s;		HX_STACK_VAR(s,"s");
			HX_STACK_LINE(1491)
			{
				HX_STACK_LINE(1491)
				int _g1 = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(1491)
				switch( (int)(_g1)){
					case (int)0: {
						HX_STACK_LINE(1491)
						s = null();
					}
					;break;
					case (int)1280: {
						HX_STACK_LINE(1491)
						s = HX_CSTRING("INVALID_ENUM");
					}
					;break;
					case (int)1281: {
						HX_STACK_LINE(1491)
						s = HX_CSTRING("INVALID_VALUE");
					}
					;break;
					case (int)1282: {
						HX_STACK_LINE(1491)
						s = HX_CSTRING("INVALID_OPERATION");
					}
					;break;
					case (int)1285: {
						HX_STACK_LINE(1491)
						s = HX_CSTRING("OUT_OF_MEMORY");
					}
					;break;
					default: {
						HX_STACK_LINE(1491)
						s = null();
					}
				}
			}
			HX_STACK_LINE(1492)
			if (((s != null()))){
				HX_STACK_LINE(1493)
				::String str = (HX_CSTRING("GL_ERROR:") + s);		HX_STACK_VAR(str,"str");
				HX_STACK_LINE(1494)
				::haxe::Log_obj::trace(str,hx::SourceInfo(HX_CSTRING("GlDriver.hx"),1494,HX_CSTRING("h3d.impl.GlDriver"),HX_CSTRING("checkError")));
				HX_STACK_LINE(1495)
				HX_STACK_DO_THROW(s);
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(GlDriver_obj,checkError,(void))

::String GlDriver_obj::getError( ){
	HX_STACK_FRAME("h3d.impl.GlDriver","getError",0x256bf91a,"h3d.impl.GlDriver.getError","h3d/impl/GlDriver.hx",1502,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_LINE(1503)
	int _g = ::openfl::gl::GL_obj::lime_gl_get_error();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(1503)
	switch( (int)(_g)){
		case (int)0: {
			HX_STACK_LINE(1504)
			return null();
		}
		;break;
		case (int)1280: {
			HX_STACK_LINE(1505)
			return HX_CSTRING("INVALID_ENUM");
		}
		;break;
		case (int)1281: {
			HX_STACK_LINE(1506)
			return HX_CSTRING("INVALID_VALUE");
		}
		;break;
		case (int)1282: {
			HX_STACK_LINE(1507)
			return HX_CSTRING("INVALID_OPERATION");
		}
		;break;
		case (int)1285: {
			HX_STACK_LINE(1508)
			return HX_CSTRING("OUT_OF_MEMORY");
		}
		;break;
		default: {
			HX_STACK_LINE(1509)
			return null();
		}
	}
	HX_STACK_LINE(1503)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(GlDriver_obj,getError,return )

::String GlDriver_obj::getShaderInfoLog( ::openfl::gl::GLShader s,Dynamic code){
	HX_STACK_FRAME("h3d.impl.GlDriver","getShaderInfoLog",0x4eb2e363,"h3d.impl.GlDriver.getShaderInfoLog","h3d/impl/GlDriver.hx",1513,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_ARG(s,"s")
	HX_STACK_ARG(code,"code")
	HX_STACK_LINE(1514)
	::String log = ::openfl::gl::GL_obj::lime_gl_get_shader_info_log(s->id);		HX_STACK_VAR(log,"log");
	HX_STACK_LINE(1515)
	if (((log == null()))){
		HX_STACK_LINE(1515)
		return HX_CSTRING("");
	}
	HX_STACK_LINE(1516)
	Array< ::String > lines = code->__Field(HX_CSTRING("split"),true)(HX_CSTRING("\n"));		HX_STACK_VAR(lines,"lines");
	HX_STACK_LINE(1517)
	::String _g = log.substr((int)9,null());		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(1517)
	Dynamic index = ::Std_obj::parseInt(_g);		HX_STACK_VAR(index,"index");
	HX_STACK_LINE(1518)
	if (((index == null()))){
		HX_STACK_LINE(1518)
		return HX_CSTRING("");
	}
	HX_STACK_LINE(1519)
	(index)--;
	HX_STACK_LINE(1520)
	if (((lines->__get(index) == null()))){
		HX_STACK_LINE(1520)
		return HX_CSTRING("");
	}
	HX_STACK_LINE(1521)
	::String line = lines->__get(index);		HX_STACK_VAR(line,"line");
	HX_STACK_LINE(1522)
	if (((line == null()))){
		HX_STACK_LINE(1523)
		line = HX_CSTRING("-");
	}
	else{
		HX_STACK_LINE(1525)
		::String _g1 = ::StringTools_obj::trim(line);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(1525)
		::String _g2 = (HX_CSTRING("(") + _g1);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(1525)
		::String _g3 = (_g2 + HX_CSTRING(")."));		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(1525)
		line = _g3;
	}
	HX_STACK_LINE(1526)
	return (log + line);
}


HX_DEFINE_DYNAMIC_FUNC2(GlDriver_obj,getShaderInfoLog,return )

::String GlDriver_obj::getProgramInfoLog( ::openfl::gl::GLProgram p,Dynamic code){
	HX_STACK_FRAME("h3d.impl.GlDriver","getProgramInfoLog",0xffe9db00,"h3d.impl.GlDriver.getProgramInfoLog","h3d/impl/GlDriver.hx",1529,0xae6eb278)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_ARG(code,"code")
	HX_STACK_LINE(1530)
	::String log = ::openfl::gl::GL_obj::lime_gl_get_program_info_log(p->id);		HX_STACK_VAR(log,"log");
	HX_STACK_LINE(1531)
	::String hnt = log.substr((int)26,null());		HX_STACK_VAR(hnt,"hnt");
	HX_STACK_LINE(1532)
	Array< ::String > _g = code->__Field(HX_CSTRING("split"),true)(HX_CSTRING("\n"));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(1532)
	Dynamic _g1 = ::Std_obj::parseInt(hnt);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(1532)
	::String line = _g->__get(_g1);		HX_STACK_VAR(line,"line");
	HX_STACK_LINE(1533)
	if (((line == null()))){
		HX_STACK_LINE(1534)
		line = HX_CSTRING("-");
	}
	else{
		HX_STACK_LINE(1536)
		::String _g2 = ::StringTools_obj::trim(line);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(1536)
		::String _g3 = (HX_CSTRING("(") + _g2);		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(1536)
		::String _g4 = (_g3 + HX_CSTRING(")."));		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(1536)
		line = _g4;
	}
	HX_STACK_LINE(1537)
	return (log + line);
}


HX_DEFINE_DYNAMIC_FUNC2(GlDriver_obj,getProgramInfoLog,return )

Void GlDriver_obj::restoreOpenfl( ){
{
		HX_STACK_FRAME("h3d.impl.GlDriver","restoreOpenfl",0x0db69ab6,"h3d.impl.GlDriver.restoreOpenfl","h3d/impl/GlDriver.hx",1540,0xae6eb278)
		HX_STACK_THIS(this)
		HX_STACK_LINE(1541)
		::openfl::gl::GL_obj::lime_gl_depth_range((int)0,(int)1);
		HX_STACK_LINE(1542)
		::openfl::gl::GL_obj::lime_gl_clear_depth((int)-1);
		HX_STACK_LINE(1543)
		::openfl::gl::GL_obj::lime_gl_depth_mask(true);
		HX_STACK_LINE(1544)
		::openfl::gl::GL_obj::lime_gl_color_mask(true,true,true,true);
		HX_STACK_LINE(1545)
		::openfl::gl::GL_obj::lime_gl_disable((int)2929);
		HX_STACK_LINE(1546)
		::openfl::gl::GL_obj::lime_gl_front_face((int)2305);
		HX_STACK_LINE(1547)
		::openfl::gl::GL_obj::lime_gl_enable((int)3042);
		HX_STACK_LINE(1548)
		::openfl::gl::GL_obj::lime_gl_blend_func((int)770,(int)771);
		HX_STACK_LINE(1549)
		::openfl::gl::GL_obj::lime_gl_disable((int)2884);
		HX_STACK_LINE(1550)
		::openfl::gl::GL_obj::lime_gl_bind_texture((int)3553,null());
		HX_STACK_LINE(1551)
		::openfl::gl::GL_obj::lime_gl_bind_buffer((int)34962,null());
		HX_STACK_LINE(1552)
		::openfl::gl::GL_obj::lime_gl_bind_buffer((int)34963,null());
		HX_STACK_LINE(1554)
		this->curShader = null();
		HX_STACK_LINE(1555)
		this->curMatBits = (int)0;
		HX_STACK_LINE(1556)
		this->depthMask = false;
		HX_STACK_LINE(1557)
		this->depthTest = false;
		HX_STACK_LINE(1558)
		this->depthFunc = (int)-1;
		HX_STACK_LINE(1559)
		this->curTex = null();
		HX_STACK_LINE(1560)
		this->curBuffer = null();
		HX_STACK_LINE(1561)
		this->curMultiBuffer = null();
	}
return null();
}


Dynamic GlDriver_obj::gl;

::haxe::ds::IntMap GlDriver_obj::f32Pool;

Array< ::Dynamic > GlDriver_obj::TFILTERS;

Array< int > GlDriver_obj::TWRAP;

Array< int > GlDriver_obj::FACES;

Array< int > GlDriver_obj::BLEND;

Array< int > GlDriver_obj::COMPARE;


GlDriver_obj::GlDriver_obj()
{
}

void GlDriver_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(GlDriver);
	HX_MARK_MEMBER_NAME(fixMult,"fixMult");
	HX_MARK_MEMBER_NAME(curShader,"curShader");
	HX_MARK_MEMBER_NAME(curMatBits,"curMatBits");
	HX_MARK_MEMBER_NAME(depthMask,"depthMask");
	HX_MARK_MEMBER_NAME(depthTest,"depthTest");
	HX_MARK_MEMBER_NAME(depthFunc,"depthFunc");
	HX_MARK_MEMBER_NAME(curTex,"curTex");
	HX_MARK_MEMBER_NAME(shaderSwitch,"shaderSwitch");
	HX_MARK_MEMBER_NAME(textureSwitch,"textureSwitch");
	HX_MARK_MEMBER_NAME(resetSwitch,"resetSwitch");
	HX_MARK_MEMBER_NAME(vpWidth,"vpWidth");
	HX_MARK_MEMBER_NAME(vpHeight,"vpHeight");
	HX_MARK_MEMBER_NAME(fboList,"fboList");
	HX_MARK_MEMBER_NAME(fboStack,"fboStack");
	HX_MARK_MEMBER_NAME(parseUniInfo,"parseUniInfo");
	HX_MARK_MEMBER_NAME(curBuffer,"curBuffer");
	HX_MARK_MEMBER_NAME(curMultiBuffer,"curMultiBuffer");
	HX_MARK_END_CLASS();
}

void GlDriver_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(fixMult,"fixMult");
	HX_VISIT_MEMBER_NAME(curShader,"curShader");
	HX_VISIT_MEMBER_NAME(curMatBits,"curMatBits");
	HX_VISIT_MEMBER_NAME(depthMask,"depthMask");
	HX_VISIT_MEMBER_NAME(depthTest,"depthTest");
	HX_VISIT_MEMBER_NAME(depthFunc,"depthFunc");
	HX_VISIT_MEMBER_NAME(curTex,"curTex");
	HX_VISIT_MEMBER_NAME(shaderSwitch,"shaderSwitch");
	HX_VISIT_MEMBER_NAME(textureSwitch,"textureSwitch");
	HX_VISIT_MEMBER_NAME(resetSwitch,"resetSwitch");
	HX_VISIT_MEMBER_NAME(vpWidth,"vpWidth");
	HX_VISIT_MEMBER_NAME(vpHeight,"vpHeight");
	HX_VISIT_MEMBER_NAME(fboList,"fboList");
	HX_VISIT_MEMBER_NAME(fboStack,"fboStack");
	HX_VISIT_MEMBER_NAME(parseUniInfo,"parseUniInfo");
	HX_VISIT_MEMBER_NAME(curBuffer,"curBuffer");
	HX_VISIT_MEMBER_NAME(curMultiBuffer,"curMultiBuffer");
}

Dynamic GlDriver_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"gl") ) { return gl; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"draw") ) { return draw_dyn(); }
		if (HX_FIELD_EQ(inName,"init") ) { return init_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"TWRAP") ) { return TWRAP; }
		if (HX_FIELD_EQ(inName,"FACES") ) { return FACES; }
		if (HX_FIELD_EQ(inName,"BLEND") ) { return BLEND; }
		if (HX_FIELD_EQ(inName,"reset") ) { return reset_dyn(); }
		if (HX_FIELD_EQ(inName,"clear") ) { return clear_dyn(); }
		if (HX_FIELD_EQ(inName,"begin") ) { return begin_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"curTex") ) { return curTex; }
		if (HX_FIELD_EQ(inName,"resize") ) { return resize_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"f32Pool") ) { return f32Pool; }
		if (HX_FIELD_EQ(inName,"COMPARE") ) { return COMPARE; }
		if (HX_FIELD_EQ(inName,"fixMult") ) { return fixMult; }
		if (HX_FIELD_EQ(inName,"vpWidth") ) { return vpWidth; }
		if (HX_FIELD_EQ(inName,"fboList") ) { return fboList; }
		if (HX_FIELD_EQ(inName,"present") ) { return present_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"TFILTERS") ) { return TFILTERS; }
		if (HX_FIELD_EQ(inName,"getUints") ) { return getUints_dyn(); }
		if (HX_FIELD_EQ(inName,"vpHeight") ) { return vpHeight; }
		if (HX_FIELD_EQ(inName,"fboStack") ) { return fboStack; }
		if (HX_FIELD_EQ(inName,"checkFBO") ) { return checkFBO_dyn(); }
		if (HX_FIELD_EQ(inName,"makeMips") ) { return makeMips_dyn(); }
		if (HX_FIELD_EQ(inName,"typeSize") ) { return typeSize_dyn(); }
		if (HX_FIELD_EQ(inName,"getError") ) { return getError_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"curShader") ) { return curShader; }
		if (HX_FIELD_EQ(inName,"depthMask") ) { return depthMask; }
		if (HX_FIELD_EQ(inName,"depthTest") ) { return depthTest; }
		if (HX_FIELD_EQ(inName,"depthFunc") ) { return depthFunc; }
		if (HX_FIELD_EQ(inName,"createF32") ) { return createF32_dyn(); }
		if (HX_FIELD_EQ(inName,"deleteF32") ) { return deleteF32_dyn(); }
		if (HX_FIELD_EQ(inName,"curBuffer") ) { return curBuffer; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"curMatBits") ) { return curMatBits; }
		if (HX_FIELD_EQ(inName,"getUints16") ) { return getUints16_dyn(); }
		if (HX_FIELD_EQ(inName,"decodeType") ) { return decodeType_dyn(); }
		if (HX_FIELD_EQ(inName,"blitMatrix") ) { return blitMatrix_dyn(); }
		if (HX_FIELD_EQ(inName,"setUniform") ) { return setUniform_dyn(); }
		if (HX_FIELD_EQ(inName,"packArray4") ) { return packArray4_dyn(); }
		if (HX_FIELD_EQ(inName,"packArray3") ) { return packArray3_dyn(); }
		if (HX_FIELD_EQ(inName,"isDisposed") ) { return isDisposed_dyn(); }
		if (HX_FIELD_EQ(inName,"checkError") ) { return checkError_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"resetSwitch") ) { return resetSwitch; }
		if (HX_FIELD_EQ(inName,"allocVertex") ) { return allocVertex_dyn(); }
		if (HX_FIELD_EQ(inName,"checkObject") ) { return checkObject_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"shaderSwitch") ) { return shaderSwitch; }
		if (HX_FIELD_EQ(inName,"allocTexture") ) { return allocTexture_dyn(); }
		if (HX_FIELD_EQ(inName,"allocIndexes") ) { return allocIndexes_dyn(); }
		if (HX_FIELD_EQ(inName,"parseUniInfo") ) { return parseUniInfo; }
		if (HX_FIELD_EQ(inName,"parseUniform") ) { return parseUniform_dyn(); }
		if (HX_FIELD_EQ(inName,"deleteShader") ) { return deleteShader_dyn(); }
		if (HX_FIELD_EQ(inName,"selectShader") ) { return selectShader_dyn(); }
		if (HX_FIELD_EQ(inName,"setupTexture") ) { return setupTexture_dyn(); }
		if (HX_FIELD_EQ(inName,"blitMatrices") ) { return blitMatrices_dyn(); }
		if (HX_FIELD_EQ(inName,"selectBuffer") ) { return selectBuffer_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"textureSwitch") ) { return textureSwitch; }
		if (HX_FIELD_EQ(inName,"setRenderZone") ) { return setRenderZone_dyn(); }
		if (HX_FIELD_EQ(inName,"disposeVertex") ) { return disposeVertex_dyn(); }
		if (HX_FIELD_EQ(inName,"decodeTypeInt") ) { return decodeTypeInt_dyn(); }
		if (HX_FIELD_EQ(inName,"restoreOpenfl") ) { return restoreOpenfl_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"selectMaterial") ) { return selectMaterial_dyn(); }
		if (HX_FIELD_EQ(inName,"disposeTexture") ) { return disposeTexture_dyn(); }
		if (HX_FIELD_EQ(inName,"disposeIndexes") ) { return disposeIndexes_dyn(); }
		if (HX_FIELD_EQ(inName,"findVarComment") ) { return findVarComment_dyn(); }
		if (HX_FIELD_EQ(inName,"hasArrayAccess") ) { return hasArrayAccess_dyn(); }
		if (HX_FIELD_EQ(inName,"curMultiBuffer") ) { return curMultiBuffer; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"setRenderTarget") ) { return setRenderTarget_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"getShaderInfoLog") ) { return getShaderInfoLog_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"uploadVertexBytes") ) { return uploadVertexBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"glCompareToString") ) { return glCompareToString_dyn(); }
		if (HX_FIELD_EQ(inName,"getProgramInfoLog") ) { return getProgramInfoLog_dyn(); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"uploadVertexBuffer") ) { return uploadVertexBuffer_dyn(); }
		if (HX_FIELD_EQ(inName,"uploadIndexesBytes") ) { return uploadIndexesBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"selectMultiBuffers") ) { return selectMultiBuffers_dyn(); }
		break;
	case 19:
		if (HX_FIELD_EQ(inName,"getShaderInputNames") ) { return getShaderInputNames_dyn(); }
		if (HX_FIELD_EQ(inName,"uploadTextureBitmap") ) { return uploadTextureBitmap_dyn(); }
		if (HX_FIELD_EQ(inName,"uploadTexturePixels") ) { return uploadTexturePixels_dyn(); }
		if (HX_FIELD_EQ(inName,"uploadIndexesBuffer") ) { return uploadIndexesBuffer_dyn(); }
		if (HX_FIELD_EQ(inName,"buildShaderInstance") ) { return buildShaderInstance_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic GlDriver_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"gl") ) { gl=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"TWRAP") ) { TWRAP=inValue.Cast< Array< int > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"FACES") ) { FACES=inValue.Cast< Array< int > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"BLEND") ) { BLEND=inValue.Cast< Array< int > >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"curTex") ) { curTex=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"f32Pool") ) { f32Pool=inValue.Cast< ::haxe::ds::IntMap >(); return inValue; }
		if (HX_FIELD_EQ(inName,"COMPARE") ) { COMPARE=inValue.Cast< Array< int > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"fixMult") ) { fixMult=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"vpWidth") ) { vpWidth=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"fboList") ) { fboList=inValue.Cast< ::List >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"TFILTERS") ) { TFILTERS=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"vpHeight") ) { vpHeight=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"fboStack") ) { fboStack=inValue.Cast< ::List >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"curShader") ) { curShader=inValue.Cast< ::h3d::impl::ShaderInstance >(); return inValue; }
		if (HX_FIELD_EQ(inName,"depthMask") ) { depthMask=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"depthTest") ) { depthTest=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"depthFunc") ) { depthFunc=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"curBuffer") ) { curBuffer=inValue.Cast< ::h3d::impl::GLVB >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"curMatBits") ) { curMatBits=inValue.Cast< int >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"resetSwitch") ) { resetSwitch=inValue.Cast< int >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"shaderSwitch") ) { shaderSwitch=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"parseUniInfo") ) { parseUniInfo=inValue.Cast< ::h3d::impl::UniformContext >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"textureSwitch") ) { textureSwitch=inValue.Cast< int >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"curMultiBuffer") ) { curMultiBuffer=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void GlDriver_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("fixMult"));
	outFields->push(HX_CSTRING("curShader"));
	outFields->push(HX_CSTRING("curMatBits"));
	outFields->push(HX_CSTRING("depthMask"));
	outFields->push(HX_CSTRING("depthTest"));
	outFields->push(HX_CSTRING("depthFunc"));
	outFields->push(HX_CSTRING("curTex"));
	outFields->push(HX_CSTRING("shaderSwitch"));
	outFields->push(HX_CSTRING("textureSwitch"));
	outFields->push(HX_CSTRING("resetSwitch"));
	outFields->push(HX_CSTRING("vpWidth"));
	outFields->push(HX_CSTRING("vpHeight"));
	outFields->push(HX_CSTRING("fboList"));
	outFields->push(HX_CSTRING("fboStack"));
	outFields->push(HX_CSTRING("parseUniInfo"));
	outFields->push(HX_CSTRING("curBuffer"));
	outFields->push(HX_CSTRING("curMultiBuffer"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("gl"),
	HX_CSTRING("f32Pool"),
	HX_CSTRING("TFILTERS"),
	HX_CSTRING("TWRAP"),
	HX_CSTRING("FACES"),
	HX_CSTRING("BLEND"),
	HX_CSTRING("COMPARE"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsBool,(int)offsetof(GlDriver_obj,fixMult),HX_CSTRING("fixMult")},
	{hx::fsObject /*::h3d::impl::ShaderInstance*/ ,(int)offsetof(GlDriver_obj,curShader),HX_CSTRING("curShader")},
	{hx::fsInt,(int)offsetof(GlDriver_obj,curMatBits),HX_CSTRING("curMatBits")},
	{hx::fsBool,(int)offsetof(GlDriver_obj,depthMask),HX_CSTRING("depthMask")},
	{hx::fsBool,(int)offsetof(GlDriver_obj,depthTest),HX_CSTRING("depthTest")},
	{hx::fsInt,(int)offsetof(GlDriver_obj,depthFunc),HX_CSTRING("depthFunc")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(GlDriver_obj,curTex),HX_CSTRING("curTex")},
	{hx::fsInt,(int)offsetof(GlDriver_obj,shaderSwitch),HX_CSTRING("shaderSwitch")},
	{hx::fsInt,(int)offsetof(GlDriver_obj,textureSwitch),HX_CSTRING("textureSwitch")},
	{hx::fsInt,(int)offsetof(GlDriver_obj,resetSwitch),HX_CSTRING("resetSwitch")},
	{hx::fsInt,(int)offsetof(GlDriver_obj,vpWidth),HX_CSTRING("vpWidth")},
	{hx::fsInt,(int)offsetof(GlDriver_obj,vpHeight),HX_CSTRING("vpHeight")},
	{hx::fsObject /*::List*/ ,(int)offsetof(GlDriver_obj,fboList),HX_CSTRING("fboList")},
	{hx::fsObject /*::List*/ ,(int)offsetof(GlDriver_obj,fboStack),HX_CSTRING("fboStack")},
	{hx::fsObject /*::h3d::impl::UniformContext*/ ,(int)offsetof(GlDriver_obj,parseUniInfo),HX_CSTRING("parseUniInfo")},
	{hx::fsObject /*::h3d::impl::GLVB*/ ,(int)offsetof(GlDriver_obj,curBuffer),HX_CSTRING("curBuffer")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(GlDriver_obj,curMultiBuffer),HX_CSTRING("curMultiBuffer")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("fixMult"),
	HX_CSTRING("curShader"),
	HX_CSTRING("curMatBits"),
	HX_CSTRING("depthMask"),
	HX_CSTRING("depthTest"),
	HX_CSTRING("depthFunc"),
	HX_CSTRING("curTex"),
	HX_CSTRING("shaderSwitch"),
	HX_CSTRING("textureSwitch"),
	HX_CSTRING("resetSwitch"),
	HX_CSTRING("getUints"),
	HX_CSTRING("getUints16"),
	HX_CSTRING("reset"),
	HX_CSTRING("selectMaterial"),
	HX_CSTRING("clear"),
	HX_CSTRING("begin"),
	HX_CSTRING("getShaderInputNames"),
	HX_CSTRING("vpWidth"),
	HX_CSTRING("vpHeight"),
	HX_CSTRING("resize"),
	HX_CSTRING("allocTexture"),
	HX_CSTRING("allocVertex"),
	HX_CSTRING("allocIndexes"),
	HX_CSTRING("setRenderZone"),
	HX_CSTRING("fboList"),
	HX_CSTRING("fboStack"),
	HX_CSTRING("checkFBO"),
	HX_CSTRING("setRenderTarget"),
	HX_CSTRING("disposeTexture"),
	HX_CSTRING("disposeIndexes"),
	HX_CSTRING("disposeVertex"),
	HX_CSTRING("makeMips"),
	HX_CSTRING("uploadTextureBitmap"),
	HX_CSTRING("uploadTexturePixels"),
	HX_CSTRING("uploadVertexBuffer"),
	HX_CSTRING("uploadVertexBytes"),
	HX_CSTRING("uploadIndexesBuffer"),
	HX_CSTRING("uploadIndexesBytes"),
	HX_CSTRING("decodeType"),
	HX_CSTRING("decodeTypeInt"),
	HX_CSTRING("typeSize"),
	HX_CSTRING("buildShaderInstance"),
	HX_CSTRING("parseUniInfo"),
	HX_CSTRING("findVarComment"),
	HX_CSTRING("hasArrayAccess"),
	HX_CSTRING("parseUniform"),
	HX_CSTRING("deleteShader"),
	HX_CSTRING("selectShader"),
	HX_CSTRING("setupTexture"),
	HX_CSTRING("blitMatrices"),
	HX_CSTRING("blitMatrix"),
	HX_CSTRING("createF32"),
	HX_CSTRING("deleteF32"),
	HX_CSTRING("setUniform"),
	HX_CSTRING("packArray4"),
	HX_CSTRING("packArray3"),
	HX_CSTRING("curBuffer"),
	HX_CSTRING("curMultiBuffer"),
	HX_CSTRING("selectBuffer"),
	HX_CSTRING("selectMultiBuffers"),
	HX_CSTRING("checkObject"),
	HX_CSTRING("draw"),
	HX_CSTRING("present"),
	HX_CSTRING("isDisposed"),
	HX_CSTRING("init"),
	HX_CSTRING("glCompareToString"),
	HX_CSTRING("checkError"),
	HX_CSTRING("getError"),
	HX_CSTRING("getShaderInfoLog"),
	HX_CSTRING("getProgramInfoLog"),
	HX_CSTRING("restoreOpenfl"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(GlDriver_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(GlDriver_obj::gl,"gl");
	HX_MARK_MEMBER_NAME(GlDriver_obj::f32Pool,"f32Pool");
	HX_MARK_MEMBER_NAME(GlDriver_obj::TFILTERS,"TFILTERS");
	HX_MARK_MEMBER_NAME(GlDriver_obj::TWRAP,"TWRAP");
	HX_MARK_MEMBER_NAME(GlDriver_obj::FACES,"FACES");
	HX_MARK_MEMBER_NAME(GlDriver_obj::BLEND,"BLEND");
	HX_MARK_MEMBER_NAME(GlDriver_obj::COMPARE,"COMPARE");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(GlDriver_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(GlDriver_obj::gl,"gl");
	HX_VISIT_MEMBER_NAME(GlDriver_obj::f32Pool,"f32Pool");
	HX_VISIT_MEMBER_NAME(GlDriver_obj::TFILTERS,"TFILTERS");
	HX_VISIT_MEMBER_NAME(GlDriver_obj::TWRAP,"TWRAP");
	HX_VISIT_MEMBER_NAME(GlDriver_obj::FACES,"FACES");
	HX_VISIT_MEMBER_NAME(GlDriver_obj::BLEND,"BLEND");
	HX_VISIT_MEMBER_NAME(GlDriver_obj::COMPARE,"COMPARE");
};

#endif

Class GlDriver_obj::__mClass;

void GlDriver_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.impl.GlDriver"), hx::TCanCast< GlDriver_obj> ,sStaticFields,sMemberFields,
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

void GlDriver_obj::__boot()
{
	gl= hx::ClassOf< ::openfl::gl::GL >();
	f32Pool= ::haxe::ds::IntMap_obj::__new();
	TFILTERS= Array_obj< ::Dynamic >::__new().Add(Array_obj< ::Dynamic >::__new().Add(Array_obj< int >::__new().Add((int)9728).Add((int)9728)).Add(Array_obj< int >::__new().Add((int)9729).Add((int)9729))).Add(Array_obj< ::Dynamic >::__new().Add(Array_obj< int >::__new().Add((int)9728).Add((int)9984)).Add(Array_obj< int >::__new().Add((int)9729).Add((int)9985))).Add(Array_obj< ::Dynamic >::__new().Add(Array_obj< int >::__new().Add((int)9728).Add((int)9986)).Add(Array_obj< int >::__new().Add((int)9729).Add((int)9987)));
	TWRAP= Array_obj< int >::__new().Add((int)33071).Add((int)10497);
	FACES= Array_obj< int >::__new().Add((int)0).Add((int)1029).Add((int)1028).Add((int)1032);
	BLEND= Array_obj< int >::__new().Add((int)1).Add((int)0).Add((int)770).Add((int)768).Add((int)772).Add((int)774).Add((int)771).Add((int)769).Add((int)773).Add((int)775).Add((int)32769).Add((int)32771).Add((int)32770).Add((int)32772).Add((int)776);
	COMPARE= Array_obj< int >::__new().Add((int)519).Add((int)512).Add((int)514).Add((int)517).Add((int)516).Add((int)518).Add((int)513).Add((int)515);
}

} // end namespace h3d
} // end namespace impl
