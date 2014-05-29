#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_h3d_Drawable
#include <h3d/Drawable.h>
#endif
#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
#endif
#ifndef INCLUDED_h3d_IDrawable
#include <h3d/IDrawable.h>
#endif
#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
#endif
#ifndef INCLUDED_h3d_Vector
#include <h3d/Vector.h>
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
#ifndef INCLUDED_h3d_impl_GLVB
#include <h3d/impl/GLVB.h>
#endif
#ifndef INCLUDED_h3d_impl_GlDriver
#include <h3d/impl/GlDriver.h>
#endif
#ifndef INCLUDED_h3d_impl_Indexes
#include <h3d/impl/Indexes.h>
#endif
#ifndef INCLUDED_h3d_impl_LineShader
#include <h3d/impl/LineShader.h>
#endif
#ifndef INCLUDED_h3d_impl_MemoryManager
#include <h3d/impl/MemoryManager.h>
#endif
#ifndef INCLUDED_h3d_impl_PointShader
#include <h3d/impl/PointShader.h>
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
#ifndef INCLUDED_h3d_mat_Texture
#include <h3d/mat/Texture.h>
#endif
#ifndef INCLUDED_h3d_prim_Plan2D
#include <h3d/prim/Plan2D.h>
#endif
#ifndef INCLUDED_h3d_prim_Primitive
#include <h3d/prim/Primitive.h>
#endif
#ifndef INCLUDED_haxe_Log
#include <haxe/Log.h>
#endif
#ifndef INCLUDED_haxe_Timer
#include <haxe/Timer.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_hxd_Profiler
#include <hxd/Profiler.h>
#endif
#ifndef INCLUDED_hxd_Stage
#include <hxd/Stage.h>
#endif
#ifndef INCLUDED_hxd_System
#include <hxd/System.h>
#endif
#ifndef INCLUDED_openfl_gl_GLBuffer
#include <openfl/gl/GLBuffer.h>
#endif
#ifndef INCLUDED_openfl_gl_GLObject
#include <openfl/gl/GLObject.h>
#endif
namespace h3d{

Void Engine_obj::__construct(hx::Null< bool >  __o_hardware,hx::Null< int >  __o_aa)
{
HX_STACK_FRAME("h3d.Engine","new",0x9d5dece9,"h3d.Engine.new","h3d/Engine.hx",6,0xd2375a86)
HX_STACK_THIS(this)
HX_STACK_ARG(__o_hardware,"hardware")
HX_STACK_ARG(__o_aa,"aa")
bool hardware = __o_hardware.Default(true);
int aa = __o_aa.Default(0);
{
	HX_STACK_LINE(30)
	this->forcedMatMask = (int)16777215;
	HX_STACK_LINE(29)
	this->forcedMatBits = (int)0;
	HX_STACK_LINE(27)
	this->frameCount = (int)0;
	HX_STACK_LINE(24)
	this->triggerClear = true;
	HX_STACK_LINE(44)
	this->hardware = hardware;
	HX_STACK_LINE(45)
	this->antiAlias = aa;
	HX_STACK_LINE(46)
	this->autoResize = true;
	HX_STACK_LINE(48)
	if (((::hxd::System_obj::debugLevel >= (int)2))){
		HX_STACK_LINE(48)
		::haxe::Log_obj::trace(HX_CSTRING("booting"),hx::SourceInfo(HX_CSTRING("Engine.hx"),48,HX_CSTRING("h3d.Engine"),HX_CSTRING("new")));
	}
	HX_STACK_LINE(51)
	if (((::hxd::System_obj::debugLevel >= (int)2))){
		HX_STACK_LINE(51)
		::haxe::Log_obj::trace(HX_CSTRING("ofl boot"),hx::SourceInfo(HX_CSTRING("Engine.hx"),51,HX_CSTRING("h3d.Engine"),HX_CSTRING("new")));
	}
	HX_STACK_LINE(52)
	::hxd::Stage_obj::openFLBoot(this->start_dyn());
}
;
	return null();
}

//Engine_obj::~Engine_obj() { }

Dynamic Engine_obj::__CreateEmpty() { return  new Engine_obj; }
hx::ObjectPtr< Engine_obj > Engine_obj::__new(hx::Null< bool >  __o_hardware,hx::Null< int >  __o_aa)
{  hx::ObjectPtr< Engine_obj > result = new Engine_obj();
	result->__construct(__o_hardware,__o_aa);
	return result;}

Dynamic Engine_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Engine_obj > result = new Engine_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

::h3d::impl::Driver Engine_obj::get_driver( ){
	HX_STACK_FRAME("h3d.Engine","get_driver",0x6e576688,"h3d.Engine.get_driver","h3d/Engine.hx",61,0xd2375a86)
	HX_STACK_THIS(this)
	HX_STACK_LINE(61)
	return this->driver;
}


HX_DEFINE_DYNAMIC_FUNC0(Engine_obj,get_driver,return )

Void Engine_obj::start( ){
{
		HX_STACK_FRAME("h3d.Engine","start",0x0d3c852b,"h3d.Engine.start","h3d/Engine.hx",63,0xd2375a86)
		HX_STACK_THIS(this)
		HX_STACK_LINE(64)
		bool _g = !(::hxd::System_obj::get_isWindowed());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(64)
		this->set_fullScreen(_g);
		HX_STACK_LINE(65)
		::hxd::Stage stage = ::hxd::Stage_obj::getInstance();		HX_STACK_VAR(stage,"stage");
		HX_STACK_LINE(66)
		Float _g1 = stage->getFrameRate();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(66)
		this->realFps = _g1;
		HX_STACK_LINE(67)
		Float _g2 = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(67)
		this->lastTime = _g2;
		HX_STACK_LINE(68)
		stage->addResizeEvent(this->onStageResize_dyn());
		HX_STACK_LINE(72)
		{
			HX_STACK_LINE(72)
			::String pos_fileName = HX_CSTRING("Engine.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
			HX_STACK_LINE(72)
			int pos_lineNumber = (int)72;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
			HX_STACK_LINE(72)
			::String pos_className = HX_CSTRING("h3d.Engine");		HX_STACK_VAR(pos_className,"pos_className");
			HX_STACK_LINE(72)
			::String pos_methodName = HX_CSTRING("start");		HX_STACK_VAR(pos_methodName,"pos_methodName");
			HX_STACK_LINE(72)
			if (((::hxd::System_obj::debugLevel >= (int)1))){
				HX_STACK_LINE(72)
				::String _g3 = HX_CSTRING("creating gl driver !");		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(72)
				::String _g4 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g3);		HX_STACK_VAR(_g4,"_g4");
				HX_STACK_LINE(72)
				::haxe::Log_obj::trace(_g4,hx::SourceInfo(HX_CSTRING("System.hx"),305,HX_CSTRING("hxd.System"),HX_CSTRING("trace1")));
			}
			HX_STACK_LINE(72)
			HX_CSTRING("creating gl driver !");
		}
		HX_STACK_LINE(73)
		::h3d::impl::GlDriver _g5 = ::h3d::impl::GlDriver_obj::__new();		HX_STACK_VAR(_g5,"_g5");
		HX_STACK_LINE(73)
		this->driver = _g5;
		HX_STACK_LINE(74)
		{
			HX_STACK_LINE(74)
			::String pos_fileName = HX_CSTRING("Engine.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
			HX_STACK_LINE(74)
			int pos_lineNumber = (int)74;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
			HX_STACK_LINE(74)
			::String pos_className = HX_CSTRING("h3d.Engine");		HX_STACK_VAR(pos_className,"pos_className");
			HX_STACK_LINE(74)
			::String pos_methodName = HX_CSTRING("start");		HX_STACK_VAR(pos_methodName,"pos_methodName");
			HX_STACK_LINE(74)
			if (((::hxd::System_obj::debugLevel >= (int)1))){
				HX_STACK_LINE(74)
				::String _g6 = HX_CSTRING("created gl driver !");		HX_STACK_VAR(_g6,"_g6");
				HX_STACK_LINE(74)
				::String _g7 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g6);		HX_STACK_VAR(_g7,"_g7");
				HX_STACK_LINE(74)
				::haxe::Log_obj::trace(_g7,hx::SourceInfo(HX_CSTRING("System.hx"),305,HX_CSTRING("hxd.System"),HX_CSTRING("trace1")));
			}
			HX_STACK_LINE(74)
			HX_CSTRING("created gl driver !");
		}
		HX_STACK_LINE(78)
		if (((::h3d::Engine_obj::CURRENT == null()))){
			HX_STACK_LINE(79)
			::h3d::Engine_obj::CURRENT = hx::ObjectPtr<OBJ_>(this);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Engine_obj,start,(void))

Void Engine_obj::setCurrent( ){
{
		HX_STACK_FRAME("h3d.Engine","setCurrent",0xb773374e,"h3d.Engine.setCurrent","h3d/Engine.hx",99,0xd2375a86)
		HX_STACK_THIS(this)
		HX_STACK_LINE(99)
		::h3d::Engine_obj::CURRENT = hx::ObjectPtr<OBJ_>(this);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Engine_obj,setCurrent,(void))

Void Engine_obj::init( ){
{
		HX_STACK_FRAME("h3d.Engine","init",0x118a1667,"h3d.Engine.init","h3d/Engine.hx",103,0xd2375a86)
		HX_STACK_THIS(this)
		HX_STACK_LINE(103)
		this->driver->init(this->onCreate_dyn(),!(this->hardware));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Engine_obj,init,(void))

::String Engine_obj::driverName( hx::Null< bool >  __o_details){
bool details = __o_details.Default(false);
	HX_STACK_FRAME("h3d.Engine","driverName",0x7f6fc92a,"h3d.Engine.driverName","h3d/Engine.hx",107,0xd2375a86)
	HX_STACK_THIS(this)
	HX_STACK_ARG(details,"details")
{
		HX_STACK_LINE(107)
		return this->driver->getDriverName(details);
	}
}


HX_DEFINE_DYNAMIC_FUNC1(Engine_obj,driverName,return )

Void Engine_obj::selectShader( ::h3d::impl::Shader shader){
{
		HX_STACK_FRAME("h3d.Engine","selectShader",0x80053d98,"h3d.Engine.selectShader","h3d/Engine.hx",111,0xd2375a86)
		HX_STACK_THIS(this)
		HX_STACK_ARG(shader,"shader")
		HX_STACK_LINE(111)
		if ((this->driver->selectShader(shader))){
			HX_STACK_LINE(112)
			(this->shaderSwitches)++;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Engine_obj,selectShader,(void))

Void Engine_obj::selectMaterial( ::h3d::mat::Material m){
{
		HX_STACK_FRAME("h3d.Engine","selectMaterial",0x347c9dda,"h3d.Engine.selectMaterial","h3d/Engine.hx",116,0xd2375a86)
		HX_STACK_THIS(this)
		HX_STACK_ARG(m,"m")
		HX_STACK_LINE(117)
		int mbits = (int((int(m->bits) & int(this->forcedMatMask))) | int(this->forcedMatBits));		HX_STACK_VAR(mbits,"mbits");
		HX_STACK_LINE(118)
		this->driver->selectMaterial(mbits);
		HX_STACK_LINE(119)
		this->selectShader(m->shader);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Engine_obj,selectMaterial,(void))

bool Engine_obj::selectBuffer( ::h3d::impl::BigBuffer buf){
	HX_STACK_FRAME("h3d.Engine","selectBuffer",0x33793b73,"h3d.Engine.selectBuffer","h3d/Engine.hx",122,0xd2375a86)
	HX_STACK_THIS(this)
	HX_STACK_ARG(buf,"buf")
	HX_STACK_LINE(123)
	if ((buf->isDisposed())){
		HX_STACK_LINE(123)
		return false;
	}
	HX_STACK_LINE(124)
	this->driver->selectBuffer(buf->vbuf);
	HX_STACK_LINE(125)
	return true;
}


HX_DEFINE_DYNAMIC_FUNC1(Engine_obj,selectBuffer,return )

bool Engine_obj::renderTriBuffer( ::h3d::impl::Buffer b,hx::Null< int >  __o_start,hx::Null< int >  __o_max){
int start = __o_start.Default(0);
int max = __o_max.Default(-1);
	HX_STACK_FRAME("h3d.Engine","renderTriBuffer",0x6fc0ec5e,"h3d.Engine.renderTriBuffer","h3d/Engine.hx",128,0xd2375a86)
	HX_STACK_THIS(this)
	HX_STACK_ARG(b,"b")
	HX_STACK_ARG(start,"start")
	HX_STACK_ARG(max,"max")
{
		HX_STACK_LINE(129)
		bool v = this->renderBuffer(b,this->mem->indexes,(int)3,start,max);		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(130)
		return v;
	}
}


HX_DEFINE_DYNAMIC_FUNC3(Engine_obj,renderTriBuffer,return )

bool Engine_obj::renderQuadBuffer( ::h3d::impl::Buffer b,hx::Null< int >  __o_start,hx::Null< int >  __o_max){
int start = __o_start.Default(0);
int max = __o_max.Default(-1);
	HX_STACK_FRAME("h3d.Engine","renderQuadBuffer",0x8c18f1f4,"h3d.Engine.renderQuadBuffer","h3d/Engine.hx",133,0xd2375a86)
	HX_STACK_THIS(this)
	HX_STACK_ARG(b,"b")
	HX_STACK_ARG(start,"start")
	HX_STACK_ARG(max,"max")
{
		HX_STACK_LINE(134)
		bool v = this->renderBuffer(b,this->mem->quadIndexes,(int)2,start,max);		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(135)
		return v;
	}
}


HX_DEFINE_DYNAMIC_FUNC3(Engine_obj,renderQuadBuffer,return )

bool Engine_obj::renderBuffer( ::h3d::impl::Buffer b,::h3d::impl::Indexes indexes,int vertPerTri,hx::Null< int >  __o_startTri,hx::Null< int >  __o_drawTri){
int startTri = __o_startTri.Default(0);
int drawTri = __o_drawTri.Default(-1);
	HX_STACK_FRAME("h3d.Engine","renderBuffer",0xbe974b4d,"h3d.Engine.renderBuffer","h3d/Engine.hx",141,0xd2375a86)
	HX_STACK_THIS(this)
	HX_STACK_ARG(b,"b")
	HX_STACK_ARG(indexes,"indexes")
	HX_STACK_ARG(vertPerTri,"vertPerTri")
	HX_STACK_ARG(startTri,"startTri")
	HX_STACK_ARG(drawTri,"drawTri")
{
		HX_STACK_LINE(142)
		if ((indexes->isDisposed())){
			HX_STACK_LINE(143)
			return false;
		}
		HX_STACK_LINE(145)
		while((true)){
			HX_STACK_LINE(147)
			int ntri = ::Std_obj::_int((Float(b->nvert) / Float(vertPerTri)));		HX_STACK_VAR(ntri,"ntri");
			HX_STACK_LINE(148)
			int pos = ::Std_obj::_int((Float(b->pos) / Float(vertPerTri)));		HX_STACK_VAR(pos,"pos");
			HX_STACK_LINE(149)
			if (((startTri > (int)0))){
				HX_STACK_LINE(150)
				if (((startTri >= ntri))){
					HX_STACK_LINE(151)
					hx::SubEq(startTri,ntri);
					HX_STACK_LINE(152)
					b = b->next;
					HX_STACK_LINE(153)
					continue;
				}
				HX_STACK_LINE(155)
				hx::AddEq(pos,startTri);
				HX_STACK_LINE(156)
				hx::SubEq(ntri,startTri);
				HX_STACK_LINE(157)
				startTri = (int)0;
			}
			HX_STACK_LINE(159)
			if (((drawTri >= (int)0))){
				HX_STACK_LINE(160)
				if (((drawTri == (int)0))){
					HX_STACK_LINE(160)
					return false;
				}
				HX_STACK_LINE(161)
				hx::SubEq(drawTri,ntri);
				HX_STACK_LINE(162)
				if (((drawTri < (int)0))){
					HX_STACK_LINE(163)
					hx::AddEq(ntri,drawTri);
					HX_STACK_LINE(164)
					drawTri = (int)0;
				}
			}
			HX_STACK_LINE(168)
			if (((  (((ntri > (int)0))) ? bool(this->selectBuffer(b->b)) : bool(false) ))){
				HX_STACK_LINE(170)
				this->driver->draw(indexes->ibuf,(pos * (int)3),ntri);
				HX_STACK_LINE(171)
				hx::AddEq(this->drawTriangles,ntri);
				HX_STACK_LINE(172)
				(this->drawCalls)++;
			}
			HX_STACK_LINE(175)
			b = b->next;
			HX_STACK_LINE(145)
			if ((!(((b != null()))))){
				HX_STACK_LINE(145)
				break;
			}
		}
		HX_STACK_LINE(177)
		return true;
	}
}


HX_DEFINE_DYNAMIC_FUNC5(Engine_obj,renderBuffer,return )

Void Engine_obj::renderIndexed( ::h3d::impl::Buffer b,::h3d::impl::Indexes indexes,hx::Null< int >  __o_startTri,hx::Null< int >  __o_drawTri){
int startTri = __o_startTri.Default(0);
int drawTri = __o_drawTri.Default(-1);
	HX_STACK_FRAME("h3d.Engine","renderIndexed",0x34f95104,"h3d.Engine.renderIndexed","h3d/Engine.hx",181,0xd2375a86)
	HX_STACK_THIS(this)
	HX_STACK_ARG(b,"b")
	HX_STACK_ARG(indexes,"indexes")
	HX_STACK_ARG(startTri,"startTri")
	HX_STACK_ARG(drawTri,"drawTri")
{
		HX_STACK_LINE(182)
		if (((b->next != null()))){
			HX_STACK_LINE(183)
			HX_STACK_DO_THROW(HX_CSTRING("Buffer is split"));
		}
		HX_STACK_LINE(184)
		if ((indexes->isDisposed())){
			HX_STACK_LINE(185)
			return null();
		}
		HX_STACK_LINE(186)
		int maxTri = ::Std_obj::_int((Float(indexes->count) / Float((int)3)));		HX_STACK_VAR(maxTri,"maxTri");
		HX_STACK_LINE(187)
		if (((drawTri < (int)0))){
			HX_STACK_LINE(187)
			drawTri = (maxTri - startTri);
		}
		HX_STACK_LINE(188)
		if (((  (((drawTri > (int)0))) ? bool(this->selectBuffer(b->b)) : bool(false) ))){
			HX_STACK_LINE(190)
			this->driver->draw(indexes->ibuf,(startTri * (int)3),drawTri);
			HX_STACK_LINE(191)
			hx::AddEq(this->drawTriangles,drawTri);
			HX_STACK_LINE(192)
			(this->drawCalls)++;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Engine_obj,renderIndexed,(void))

Void Engine_obj::renderMultiBuffers( Array< ::Dynamic > buffers,::h3d::impl::Indexes indexes,hx::Null< int >  __o_startTri,hx::Null< int >  __o_drawTri){
int startTri = __o_startTri.Default(0);
int drawTri = __o_drawTri.Default(-1);
	HX_STACK_FRAME("h3d.Engine","renderMultiBuffers",0x52df3807,"h3d.Engine.renderMultiBuffers","h3d/Engine.hx",196,0xd2375a86)
	HX_STACK_THIS(this)
	HX_STACK_ARG(buffers,"buffers")
	HX_STACK_ARG(indexes,"indexes")
	HX_STACK_ARG(startTri,"startTri")
	HX_STACK_ARG(drawTri,"drawTri")
{
		HX_STACK_LINE(199)
		int maxTri = ::Std_obj::_int((Float(indexes->count) / Float((int)3)));		HX_STACK_VAR(maxTri,"maxTri");
		HX_STACK_LINE(200)
		if (((maxTri <= (int)0))){
			HX_STACK_LINE(200)
			return null();
		}
		HX_STACK_LINE(202)
		this->driver->selectMultiBuffers(buffers);
		HX_STACK_LINE(203)
		if ((indexes->isDisposed())){
			HX_STACK_LINE(204)
			return null();
		}
		HX_STACK_LINE(205)
		if (((drawTri < (int)0))){
			HX_STACK_LINE(205)
			drawTri = (maxTri - startTri);
		}
		HX_STACK_LINE(206)
		if (((drawTri > (int)0))){
			HX_STACK_LINE(208)
			this->driver->draw(indexes->ibuf,(startTri * (int)3),drawTri);
			HX_STACK_LINE(209)
			hx::AddEq(this->drawTriangles,drawTri);
			HX_STACK_LINE(210)
			(this->drawCalls)++;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Engine_obj,renderMultiBuffers,(void))

bool Engine_obj::set_debug( bool d){
	HX_STACK_FRAME("h3d.Engine","set_debug",0x989d43ff,"h3d.Engine.set_debug","h3d/Engine.hx",214,0xd2375a86)
	HX_STACK_THIS(this)
	HX_STACK_ARG(d,"d")
	HX_STACK_LINE(215)
	this->debug = d;
	HX_STACK_LINE(216)
	this->driver->setDebug(this->debug);
	HX_STACK_LINE(217)
	return d;
}


HX_DEFINE_DYNAMIC_FUNC1(Engine_obj,set_debug,return )

Void Engine_obj::onCreate( bool disposed){
{
		HX_STACK_FRAME("h3d.Engine","onCreate",0xff713052,"h3d.Engine.onCreate","h3d/Engine.hx",220,0xd2375a86)
		HX_STACK_THIS(this)
		HX_STACK_ARG(disposed,"disposed")
		HX_STACK_LINE(221)
		if (((::hxd::System_obj::debugLevel >= (int)1))){
			HX_STACK_LINE(221)
			::haxe::Log_obj::trace(HX_CSTRING("onCreate"),hx::SourceInfo(HX_CSTRING("Engine.hx"),221,HX_CSTRING("h3d.Engine"),HX_CSTRING("onCreate")));
		}
		HX_STACK_LINE(222)
		if ((this->autoResize)){
			HX_STACK_LINE(223)
			int _g = ::hxd::System_obj::get_width();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(223)
			this->width = _g;
			HX_STACK_LINE(224)
			int _g1 = ::hxd::System_obj::get_height();		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(224)
			this->height = _g1;
		}
		HX_STACK_LINE(226)
		if ((disposed)){
			HX_STACK_LINE(227)
			this->mem->onContextLost();
		}
		else{
			HX_STACK_LINE(229)
			::h3d::impl::MemoryManager _g2 = ::h3d::impl::MemoryManager_obj::__new(this->driver,(int)65400);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(229)
			this->mem = _g2;
		}
		HX_STACK_LINE(231)
		bool _g3 = this->driver->isHardware();		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(231)
		this->hardware = _g3;
		HX_STACK_LINE(232)
		this->set_debug(this->debug);
		HX_STACK_LINE(233)
		this->set_fullScreen(this->fullScreen);
		HX_STACK_LINE(234)
		this->resize(this->width,this->height);
		HX_STACK_LINE(236)
		if ((disposed)){
			HX_STACK_LINE(237)
			this->onContextLost();
		}
		else{
			HX_STACK_LINE(239)
			this->onReady();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Engine_obj,onCreate,(void))

HX_BEGIN_DEFAULT_FUNC(__default_onContextLost,Engine_obj)
Void run(){
{
		HX_STACK_FRAME("h3d.Engine","onContextLost",0xdff22e5d,"h3d.Engine.onContextLost","h3d/Engine.hx",244,0xd2375a86)
		HX_STACK_THIS(this)
		HX_STACK_LINE(244)
		if (((::hxd::System_obj::debugLevel >= (int)1))){
			HX_STACK_LINE(244)
			::haxe::Log_obj::trace(HX_CSTRING("onContextLost"),hx::SourceInfo(HX_CSTRING("Engine.hx"),244,HX_CSTRING("h3d.Engine"),HX_CSTRING("onContextLost")));
		}
	}
return null();
}
HX_END_LOCAL_FUNC0((void))
HX_END_DEFAULT_FUNC

HX_BEGIN_DEFAULT_FUNC(__default_onReady,Engine_obj)
Void run(){
{
		HX_STACK_FRAME("h3d.Engine","onReady",0x8125d3cd,"h3d.Engine.onReady","h3d/Engine.hx",248,0xd2375a86)
		HX_STACK_THIS(this)
		HX_STACK_LINE(248)
		if (((::hxd::System_obj::debugLevel >= (int)1))){
			HX_STACK_LINE(248)
			::haxe::Log_obj::trace(HX_CSTRING("onReady"),hx::SourceInfo(HX_CSTRING("Engine.hx"),248,HX_CSTRING("h3d.Engine"),HX_CSTRING("onReady")));
		}
	}
return null();
}
HX_END_LOCAL_FUNC0((void))
HX_END_DEFAULT_FUNC

Void Engine_obj::onStageResize( ){
{
		HX_STACK_FRAME("h3d.Engine","onStageResize",0x56ab7a3c,"h3d.Engine.onStageResize","h3d/Engine.hx",252,0xd2375a86)
		HX_STACK_THIS(this)
		HX_STACK_LINE(252)
		if (((  ((this->autoResize)) ? bool(!(this->driver->isDisposed())) : bool(false) ))){
			HX_STACK_LINE(253)
			int w = ::hxd::System_obj::get_width();		HX_STACK_VAR(w,"w");
			HX_STACK_LINE(253)
			int h = ::hxd::System_obj::get_height();		HX_STACK_VAR(h,"h");
			HX_STACK_LINE(254)
			if (((bool((w != this->width)) || bool((h != this->height))))){
				HX_STACK_LINE(255)
				this->resize(w,h);
			}
			HX_STACK_LINE(256)
			this->onResized();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Engine_obj,onStageResize,(void))

bool Engine_obj::set_fullScreen( bool v){
	HX_STACK_FRAME("h3d.Engine","set_fullScreen",0xaf032d2f,"h3d.Engine.set_fullScreen","h3d/Engine.hx",260,0xd2375a86)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(261)
	this->fullScreen = v;
	HX_STACK_LINE(262)
	if (((  (((this->mem != null()))) ? bool(::hxd::System_obj::get_isWindowed()) : bool(false) ))){
		HX_STACK_LINE(263)
		::hxd::Stage_obj::getInstance()->setFullScreen(v);
	}
	HX_STACK_LINE(264)
	return v;
}


HX_DEFINE_DYNAMIC_FUNC1(Engine_obj,set_fullScreen,return )

HX_BEGIN_DEFAULT_FUNC(__default_onResized,Engine_obj)
Void run(){
{
		HX_STACK_FRAME("h3d.Engine","onResized",0xd5a1bdda,"h3d.Engine.onResized","h3d/Engine.hx",268,0xd2375a86)
		HX_STACK_THIS(this)
		HX_STACK_LINE(268)
		if (((::hxd::System_obj::debugLevel >= (int)1))){
			HX_STACK_LINE(268)
			::haxe::Log_obj::trace(HX_CSTRING("onResized"),hx::SourceInfo(HX_CSTRING("Engine.hx"),268,HX_CSTRING("h3d.Engine"),HX_CSTRING("onResized")));
		}
	}
return null();
}
HX_END_LOCAL_FUNC0((void))
HX_END_DEFAULT_FUNC

Void Engine_obj::resize( int width,int height){
{
		HX_STACK_FRAME("h3d.Engine","resize",0x8a38f90b,"h3d.Engine.resize","h3d/Engine.hx",271,0xd2375a86)
		HX_STACK_THIS(this)
		HX_STACK_ARG(width,"width")
		HX_STACK_ARG(height,"height")
		HX_STACK_LINE(272)
		{
			HX_STACK_LINE(272)
			Dynamic msg = (((HX_CSTRING("engine resize ") + width) + HX_CSTRING(",")) + height);		HX_STACK_VAR(msg,"msg");
			HX_STACK_LINE(272)
			::String pos_fileName = HX_CSTRING("Engine.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
			HX_STACK_LINE(272)
			int pos_lineNumber = (int)272;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
			HX_STACK_LINE(272)
			::String pos_className = HX_CSTRING("h3d.Engine");		HX_STACK_VAR(pos_className,"pos_className");
			HX_STACK_LINE(272)
			::String pos_methodName = HX_CSTRING("resize");		HX_STACK_VAR(pos_methodName,"pos_methodName");
			HX_STACK_LINE(272)
			if (((::hxd::System_obj::debugLevel >= (int)1))){
				HX_STACK_LINE(272)
				::String _g = ::Std_obj::string(msg);		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(272)
				::String _g1 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g);		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(272)
				::haxe::Log_obj::trace(_g1,hx::SourceInfo(HX_CSTRING("System.hx"),305,HX_CSTRING("hxd.System"),HX_CSTRING("trace1")));
			}
			HX_STACK_LINE(272)
			msg;
		}
		HX_STACK_LINE(274)
		if (((width < (int)32))){
			HX_STACK_LINE(274)
			width = (int)32;
		}
		HX_STACK_LINE(275)
		if (((height < (int)32))){
			HX_STACK_LINE(275)
			height = (int)32;
		}
		HX_STACK_LINE(276)
		this->width = width;
		HX_STACK_LINE(277)
		this->height = height;
		HX_STACK_LINE(278)
		if ((!(this->driver->isDisposed()))){
			HX_STACK_LINE(278)
			this->driver->resize(width,height);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Engine_obj,resize,(void))

bool Engine_obj::begin( ){
	HX_STACK_FRAME("h3d.Engine","begin",0x3986faf2,"h3d.Engine.begin","h3d/Engine.hx",282,0xd2375a86)
	HX_STACK_THIS(this)
	HX_STACK_LINE(283)
	if ((this->driver->isDisposed())){
		HX_STACK_LINE(284)
		return false;
	}
	HX_STACK_LINE(286)
	if ((::hxd::Profiler_obj::enable)){
		HX_STACK_LINE(286)
		Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
		HX_STACK_LINE(286)
		Dynamic ent = ::hxd::Profiler_obj::h->get(HX_CSTRING("Engine:begin"));		HX_STACK_VAR(ent,"ent");
		HX_STACK_LINE(286)
		if (((null() == ent))){
			struct _Function_3_1{
				inline static Dynamic Block( ){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/Engine.hx",286,0xd2375a86)
					{
						hx::Anon __result = hx::Anon_obj::Create();
						__result->Add(HX_CSTRING("start") , null(),false);
						__result->Add(HX_CSTRING("total") , 0.0,false);
						__result->Add(HX_CSTRING("hit") , (int)0,false);
						return __result;
					}
					return null();
				}
			};
			HX_STACK_LINE(286)
			ent = _Function_3_1::Block();
			HX_STACK_LINE(286)
			::hxd::Profiler_obj::h->set(HX_CSTRING("Engine:begin"),ent);
		}
		HX_STACK_LINE(286)
		ent->__FieldRef(HX_CSTRING("start")) = t;
		HX_STACK_LINE(286)
		(ent->__FieldRef(HX_CSTRING("hit")))++;
	}
	HX_STACK_LINE(287)
	if ((this->triggerClear)){
		HX_STACK_LINE(288)
		this->driver->clear((Float(((int((int(this->backgroundColor) >> int((int)16))) & int((int)255)))) / Float((int)255)),(Float(((int((int(this->backgroundColor) >> int((int)8))) & int((int)255)))) / Float((int)255)),(Float(((int(this->backgroundColor) & int((int)255)))) / Float((int)255)),(Float(((int(hx::UShr(this->backgroundColor,(int)24)) & int((int)255)))) / Float((int)255)));
	}
	HX_STACK_LINE(293)
	this->driver->begin();
	HX_STACK_LINE(296)
	(this->frameCount)++;
	HX_STACK_LINE(297)
	this->drawTriangles = (int)0;
	HX_STACK_LINE(298)
	this->shaderSwitches = (int)0;
	HX_STACK_LINE(299)
	this->drawCalls = (int)0;
	HX_STACK_LINE(300)
	this->curProjMatrix = null();
	HX_STACK_LINE(301)
	this->driver->reset();
	HX_STACK_LINE(302)
	if ((::hxd::Profiler_obj::enable)){
		HX_STACK_LINE(302)
		Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
		HX_STACK_LINE(302)
		Dynamic ent = ::hxd::Profiler_obj::h->get(HX_CSTRING("Engine:begin"));		HX_STACK_VAR(ent,"ent");
		HX_STACK_LINE(302)
		if (((null() != ent))){
			HX_STACK_LINE(302)
			if (((ent->__Field(HX_CSTRING("start"),true) != null()))){
				HX_STACK_LINE(302)
				hx::AddEq(ent->__FieldRef(HX_CSTRING("total")),(t - ent->__Field(HX_CSTRING("start"),true)));
			}
		}
	}
	HX_STACK_LINE(303)
	return true;
}


HX_DEFINE_DYNAMIC_FUNC0(Engine_obj,begin,return )

Void Engine_obj::reset( ){
{
		HX_STACK_FRAME("h3d.Engine","reset",0x6ff95a98,"h3d.Engine.reset","h3d/Engine.hx",307,0xd2375a86)
		HX_STACK_THIS(this)
		HX_STACK_LINE(307)
		this->driver->reset();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Engine_obj,reset,(void))

Void Engine_obj::end( ){
{
		HX_STACK_FRAME("h3d.Engine","end",0x9d572064,"h3d.Engine.end","h3d/Engine.hx",310,0xd2375a86)
		HX_STACK_THIS(this)
		HX_STACK_LINE(311)
		if ((::hxd::Profiler_obj::enable)){
			HX_STACK_LINE(311)
			Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
			HX_STACK_LINE(311)
			Dynamic ent = ::hxd::Profiler_obj::h->get(HX_CSTRING("Engine:end"));		HX_STACK_VAR(ent,"ent");
			HX_STACK_LINE(311)
			if (((null() == ent))){
				struct _Function_3_1{
					inline static Dynamic Block( ){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/Engine.hx",311,0xd2375a86)
						{
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("start") , null(),false);
							__result->Add(HX_CSTRING("total") , 0.0,false);
							__result->Add(HX_CSTRING("hit") , (int)0,false);
							return __result;
						}
						return null();
					}
				};
				HX_STACK_LINE(311)
				ent = _Function_3_1::Block();
				HX_STACK_LINE(311)
				::hxd::Profiler_obj::h->set(HX_CSTRING("Engine:end"),ent);
			}
			HX_STACK_LINE(311)
			ent->__FieldRef(HX_CSTRING("start")) = t;
			HX_STACK_LINE(311)
			(ent->__FieldRef(HX_CSTRING("hit")))++;
		}
		HX_STACK_LINE(312)
		this->driver->present();
		HX_STACK_LINE(313)
		this->reset();
		HX_STACK_LINE(314)
		this->curProjMatrix = null();
		HX_STACK_LINE(315)
		if ((::hxd::Profiler_obj::enable)){
			HX_STACK_LINE(315)
			Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
			HX_STACK_LINE(315)
			Dynamic ent = ::hxd::Profiler_obj::h->get(HX_CSTRING("Engine:end"));		HX_STACK_VAR(ent,"ent");
			HX_STACK_LINE(315)
			if (((null() != ent))){
				HX_STACK_LINE(315)
				if (((ent->__Field(HX_CSTRING("start"),true) != null()))){
					HX_STACK_LINE(315)
					hx::AddEq(ent->__FieldRef(HX_CSTRING("total")),(t - ent->__Field(HX_CSTRING("start"),true)));
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Engine_obj,end,(void))

Void Engine_obj::setTarget( ::h3d::mat::Texture tex,Dynamic __o_bindDepth,Dynamic __o_clearColor){
Dynamic bindDepth = __o_bindDepth.Default(false);
Dynamic clearColor = __o_clearColor.Default(0);
	HX_STACK_FRAME("h3d.Engine","setTarget",0x811811dc,"h3d.Engine.setTarget","h3d/Engine.hx",327,0xd2375a86)
	HX_STACK_THIS(this)
	HX_STACK_ARG(tex,"tex")
	HX_STACK_ARG(bindDepth,"bindDepth")
	HX_STACK_ARG(clearColor,"clearColor")
{
		HX_STACK_LINE(327)
		this->driver->setRenderTarget((  (((tex == null()))) ? ::h3d::mat::Texture(null()) : ::h3d::mat::Texture(tex) ),bindDepth,clearColor);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Engine_obj,setTarget,(void))

Void Engine_obj::setRenderZone( hx::Null< int >  __o_x,hx::Null< int >  __o_y,Dynamic __o_width,Dynamic __o_height){
int x = __o_x.Default(0);
int y = __o_y.Default(0);
Dynamic width = __o_width.Default(-1);
Dynamic height = __o_height.Default(-1);
	HX_STACK_FRAME("h3d.Engine","setRenderZone",0xe7c75cad,"h3d.Engine.setRenderZone","h3d/Engine.hx",334,0xd2375a86)
	HX_STACK_THIS(this)
	HX_STACK_ARG(x,"x")
	HX_STACK_ARG(y,"y")
	HX_STACK_ARG(width,"width")
	HX_STACK_ARG(height,"height")
{
		HX_STACK_LINE(334)
		this->driver->setRenderZone(x,y,width,height);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Engine_obj,setRenderZone,(void))

bool Engine_obj::render( Dynamic obj){
	HX_STACK_FRAME("h3d.Engine","render",0x86e70a6d,"h3d.Engine.render","h3d/Engine.hx",337,0xd2375a86)
	HX_STACK_THIS(this)
	HX_STACK_ARG(obj,"obj")
	HX_STACK_LINE(338)
	if ((!(this->begin()))){
		HX_STACK_LINE(338)
		return false;
	}
	HX_STACK_LINE(339)
	obj->__Field(HX_CSTRING("render"),true)(hx::ObjectPtr<OBJ_>(this));
	HX_STACK_LINE(340)
	this->end();
	HX_STACK_LINE(342)
	Float _g = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(342)
	Float delta = (_g - this->lastTime);		HX_STACK_VAR(delta,"delta");
	HX_STACK_LINE(343)
	hx::AddEq(this->lastTime,delta);
	HX_STACK_LINE(344)
	if (((delta > (int)0))){
		HX_STACK_LINE(345)
		Float curFps = (Float(1.) / Float(delta));		HX_STACK_VAR(curFps,"curFps");
		HX_STACK_LINE(346)
		if (((curFps > (this->realFps * (int)2)))){
			HX_STACK_LINE(346)
			curFps = (this->realFps * (int)2);
		}
		else{
			HX_STACK_LINE(346)
			if (((curFps < (this->realFps * 0.5)))){
				HX_STACK_LINE(346)
				curFps = (this->realFps * 0.5);
			}
		}
		HX_STACK_LINE(347)
		Float f = (Float(delta) / Float(.5));		HX_STACK_VAR(f,"f");
		HX_STACK_LINE(348)
		if (((f > 0.3))){
			HX_STACK_LINE(348)
			f = 0.3;
		}
		HX_STACK_LINE(349)
		this->realFps = ((this->realFps * (((int)1 - f))) + (curFps * f));
	}
	HX_STACK_LINE(351)
	return true;
}


HX_DEFINE_DYNAMIC_FUNC1(Engine_obj,render,return )

Void Engine_obj::point( Float x,Float y,Float z,hx::Null< int >  __o_color,hx::Null< Float >  __o_size,hx::Null< bool >  __o_depth){
int color = __o_color.Default(-2130771968);
Float size = __o_size.Default(1.0);
bool depth = __o_depth.Default(false);
	HX_STACK_FRAME("h3d.Engine","point",0x4fc0c519,"h3d.Engine.point","h3d/Engine.hx",361,0xd2375a86)
	HX_STACK_THIS(this)
	HX_STACK_ARG(x,"x")
	HX_STACK_ARG(y,"y")
	HX_STACK_ARG(z,"z")
	HX_STACK_ARG(color,"color")
	HX_STACK_ARG(size,"size")
	HX_STACK_ARG(depth,"depth")
{
		HX_STACK_LINE(362)
		if (((this->curProjMatrix == null()))){
			HX_STACK_LINE(363)
			return null();
		}
		HX_STACK_LINE(364)
		if (((this->debugPoint == null()))){
			HX_STACK_LINE(365)
			::h3d::prim::Plan2D _g = ::h3d::prim::Plan2D_obj::__new();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(365)
			::h3d::impl::PointShader _g1 = ::h3d::impl::PointShader_obj::__new();		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(365)
			::h3d::Drawable _g2 = ::h3d::Drawable_obj::__new(_g,_g1);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(365)
			this->debugPoint = _g2;
			HX_STACK_LINE(366)
			this->debugPoint->material->blend(::h3d::mat::Blend_obj::SrcAlpha,::h3d::mat::Blend_obj::OneMinusSrcAlpha);
		}
		HX_STACK_LINE(369)
		this->debugPoint->material->set_depthWrite(false);
		HX_STACK_LINE(370)
		this->debugLine->material->set_culling(::h3d::mat::Face_obj::None);
		HX_STACK_LINE(371)
		this->debugPoint->material->set_depthTest((  ((depth)) ? ::h3d::mat::Compare(::h3d::mat::Compare_obj::LessEqual) : ::h3d::mat::Compare(::h3d::mat::Compare_obj::Always) ));
		HX_STACK_LINE(372)
		this->debugPoint->shader->__FieldRef(HX_CSTRING("mproj")) = this->curProjMatrix;
		HX_STACK_LINE(373)
		::h3d::Vector _g3 = ::h3d::Vector_obj::__new(x,y,z,(int)1);		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(373)
		this->debugPoint->shader->__FieldRef(HX_CSTRING("delta")) = _g3;
		HX_STACK_LINE(374)
		Float gscale = 0.005;		HX_STACK_VAR(gscale,"gscale");
		HX_STACK_LINE(375)
		::h3d::Vector _g4 = ::h3d::Vector_obj::__new((size * gscale),(Float(((size * gscale) * this->width)) / Float(this->height)),null(),null());		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(375)
		this->debugPoint->shader->__FieldRef(HX_CSTRING("size")) = _g4;
		HX_STACK_LINE(376)
		this->debugPoint->shader->__FieldRef(HX_CSTRING("color")) = color;
		HX_STACK_LINE(377)
		::h3d::Engine _g5;		HX_STACK_VAR(_g5,"_g5");
		HX_STACK_LINE(377)
		{
			HX_STACK_LINE(377)
			if (((::hxd::System_obj::debugLevel >= (int)1))){
				HX_STACK_LINE(377)
				if (((::h3d::Engine_obj::CURRENT == null()))){
					HX_STACK_LINE(377)
					HX_STACK_DO_THROW(HX_CSTRING("no current context, please do this operation after engine init/creation"));
				}
			}
			HX_STACK_LINE(377)
			_g5 = ::h3d::Engine_obj::CURRENT;
		}
		HX_STACK_LINE(377)
		this->debugPoint->render(_g5);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC6(Engine_obj,point,(void))

Void Engine_obj::line( Float x1,Float y1,Float z1,Float x2,Float y2,Float z2,hx::Null< int >  __o_color,hx::Null< bool >  __o_depth){
int color = __o_color.Default(-2130771968);
bool depth = __o_depth.Default(false);
	HX_STACK_FRAME("h3d.Engine","line",0x1381f34b,"h3d.Engine.line","h3d/Engine.hx",380,0xd2375a86)
	HX_STACK_THIS(this)
	HX_STACK_ARG(x1,"x1")
	HX_STACK_ARG(y1,"y1")
	HX_STACK_ARG(z1,"z1")
	HX_STACK_ARG(x2,"x2")
	HX_STACK_ARG(y2,"y2")
	HX_STACK_ARG(z2,"z2")
	HX_STACK_ARG(color,"color")
	HX_STACK_ARG(depth,"depth")
{
		HX_STACK_LINE(381)
		if (((this->curProjMatrix == null()))){
			HX_STACK_LINE(382)
			if (((::hxd::System_obj::debugLevel == (int)2))){
				HX_STACK_LINE(382)
				::haxe::Log_obj::trace(HX_CSTRING("line render failed, no proj mat"),hx::SourceInfo(HX_CSTRING("Engine.hx"),382,HX_CSTRING("h3d.Engine"),HX_CSTRING("line")));
			}
			HX_STACK_LINE(383)
			HX_STACK_DO_THROW(HX_CSTRING("FATAL ERROR"));
		}
		HX_STACK_LINE(385)
		if (((this->debugLine == null()))){
			HX_STACK_LINE(386)
			::h3d::prim::Plan2D _g = ::h3d::prim::Plan2D_obj::__new();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(386)
			::h3d::impl::LineShader _g1 = ::h3d::impl::LineShader_obj::__new();		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(386)
			::h3d::Drawable _g2 = ::h3d::Drawable_obj::__new(_g,_g1);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(386)
			this->debugLine = _g2;
			HX_STACK_LINE(387)
			this->debugLine->material->blend(::h3d::mat::Blend_obj::SrcAlpha,::h3d::mat::Blend_obj::OneMinusSrcAlpha);
		}
		HX_STACK_LINE(390)
		this->debugLine->material->set_depthTest((  ((depth)) ? ::h3d::mat::Compare(::h3d::mat::Compare_obj::LessEqual) : ::h3d::mat::Compare(::h3d::mat::Compare_obj::Always) ));
		HX_STACK_LINE(391)
		this->debugLine->material->set_culling(::h3d::mat::Face_obj::None);
		HX_STACK_LINE(392)
		this->debugLine->material->set_depthWrite(false);
		HX_STACK_LINE(393)
		this->debugLine->shader->__FieldRef(HX_CSTRING("mproj")) = this->curProjMatrix;
		HX_STACK_LINE(394)
		::h3d::Vector _g3 = ::h3d::Vector_obj::__new(x1,y1,z1,null());		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(394)
		this->debugLine->shader->__FieldRef(HX_CSTRING("start")) = _g3;
		HX_STACK_LINE(395)
		::h3d::Vector _g4 = ::h3d::Vector_obj::__new(x2,y2,z2,null());		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(395)
		this->debugLine->shader->__FieldRef(HX_CSTRING("end")) = _g4;
		HX_STACK_LINE(396)
		this->debugLine->shader->__FieldRef(HX_CSTRING("color")) = color;
		HX_STACK_LINE(398)
		::h3d::Engine _g5;		HX_STACK_VAR(_g5,"_g5");
		HX_STACK_LINE(398)
		{
			HX_STACK_LINE(398)
			if (((::hxd::System_obj::debugLevel >= (int)1))){
				HX_STACK_LINE(398)
				if (((::h3d::Engine_obj::CURRENT == null()))){
					HX_STACK_LINE(398)
					HX_STACK_DO_THROW(HX_CSTRING("no current context, please do this operation after engine init/creation"));
				}
			}
			HX_STACK_LINE(398)
			_g5 = ::h3d::Engine_obj::CURRENT;
		}
		HX_STACK_LINE(398)
		this->debugLine->render(_g5);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC8(Engine_obj,line,(void))

Void Engine_obj::lineP( Dynamic a,Dynamic b,hx::Null< int >  __o_color,hx::Null< bool >  __o_depth){
int color = __o_color.Default(-2130771968);
bool depth = __o_depth.Default(false);
	HX_STACK_FRAME("h3d.Engine","lineP",0xfe32eea5,"h3d.Engine.lineP","h3d/Engine.hx",402,0xd2375a86)
	HX_STACK_THIS(this)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_ARG(color,"color")
	HX_STACK_ARG(depth,"depth")
{
		HX_STACK_LINE(402)
		this->line(a->__Field(HX_CSTRING("x"),true),a->__Field(HX_CSTRING("y"),true),a->__Field(HX_CSTRING("z"),true),b->__Field(HX_CSTRING("x"),true),b->__Field(HX_CSTRING("y"),true),b->__Field(HX_CSTRING("z"),true),color,depth);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Engine_obj,lineP,(void))

Void Engine_obj::dispose( ){
{
		HX_STACK_FRAME("h3d.Engine","dispose",0xbf7a15a8,"h3d.Engine.dispose","h3d/Engine.hx",405,0xd2375a86)
		HX_STACK_THIS(this)
		HX_STACK_LINE(406)
		this->driver->dispose();
		HX_STACK_LINE(407)
		::hxd::Stage_obj::getInstance()->removeResizeEvent(this->onStageResize_dyn());
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Engine_obj,dispose,(void))

Float Engine_obj::get_fps( ){
	HX_STACK_FRAME("h3d.Engine","get_fps",0x2af02589,"h3d.Engine.get_fps","h3d/Engine.hx",410,0xd2375a86)
	HX_STACK_THIS(this)
	HX_STACK_LINE(411)
	int _g = ::Math_obj::ceil((this->realFps * (int)100));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(411)
	return (Float(_g) / Float((int)100));
}


HX_DEFINE_DYNAMIC_FUNC0(Engine_obj,get_fps,return )

Void Engine_obj::restoreOpenfl( ){
{
		HX_STACK_FRAME("h3d.Engine","restoreOpenfl",0x0b772f47,"h3d.Engine.restoreOpenfl","h3d/Engine.hx",415,0xd2375a86)
		HX_STACK_THIS(this)
		HX_STACK_LINE(417)
		this->triggerClear = false;
		HX_STACK_LINE(419)
		this->driver->restoreOpenfl();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Engine_obj,restoreOpenfl,(void))

::h3d::Engine Engine_obj::CURRENT;

Void Engine_obj::check( ){
{
		HX_STACK_FRAME("h3d.Engine","check",0xcee7a991,"h3d.Engine.check","h3d/Engine.hx",87,0xd2375a86)
		HX_STACK_LINE(87)
		if (((::hxd::System_obj::debugLevel >= (int)1))){
			HX_STACK_LINE(88)
			if (((::h3d::Engine_obj::CURRENT == null()))){
				HX_STACK_LINE(88)
				HX_STACK_DO_THROW(HX_CSTRING("no current context, please do this operation after engine init/creation"));
			}
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Engine_obj,check,(void))

::h3d::Engine Engine_obj::getCurrent( ){
	HX_STACK_FRAME("h3d.Engine","getCurrent",0xb3f598da,"h3d.Engine.getCurrent","h3d/Engine.hx",93,0xd2375a86)
	HX_STACK_LINE(94)
	if (((::hxd::System_obj::debugLevel >= (int)1))){
		HX_STACK_LINE(94)
		if (((::h3d::Engine_obj::CURRENT == null()))){
			HX_STACK_LINE(94)
			HX_STACK_DO_THROW(HX_CSTRING("no current context, please do this operation after engine init/creation"));
		}
	}
	HX_STACK_LINE(95)
	return ::h3d::Engine_obj::CURRENT;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Engine_obj,getCurrent,return )


Engine_obj::Engine_obj()
{
	onContextLost = new __default_onContextLost(this);
	onReady = new __default_onReady(this);
	onResized = new __default_onResized(this);
}

void Engine_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Engine);
	HX_MARK_MEMBER_NAME(driver,"driver");
	HX_MARK_MEMBER_NAME(mem,"mem");
	HX_MARK_MEMBER_NAME(hardware,"hardware");
	HX_MARK_MEMBER_NAME(width,"width");
	HX_MARK_MEMBER_NAME(height,"height");
	HX_MARK_MEMBER_NAME(debug,"debug");
	HX_MARK_MEMBER_NAME(drawTriangles,"drawTriangles");
	HX_MARK_MEMBER_NAME(drawCalls,"drawCalls");
	HX_MARK_MEMBER_NAME(shaderSwitches,"shaderSwitches");
	HX_MARK_MEMBER_NAME(backgroundColor,"backgroundColor");
	HX_MARK_MEMBER_NAME(autoResize,"autoResize");
	HX_MARK_MEMBER_NAME(fullScreen,"fullScreen");
	HX_MARK_MEMBER_NAME(triggerClear,"triggerClear");
	HX_MARK_MEMBER_NAME(frameCount,"frameCount");
	HX_MARK_MEMBER_NAME(forcedMatBits,"forcedMatBits");
	HX_MARK_MEMBER_NAME(forcedMatMask,"forcedMatMask");
	HX_MARK_MEMBER_NAME(realFps,"realFps");
	HX_MARK_MEMBER_NAME(lastTime,"lastTime");
	HX_MARK_MEMBER_NAME(antiAlias,"antiAlias");
	HX_MARK_MEMBER_NAME(debugPoint,"debugPoint");
	HX_MARK_MEMBER_NAME(debugLine,"debugLine");
	HX_MARK_MEMBER_NAME(curProjMatrix,"curProjMatrix");
	HX_MARK_MEMBER_NAME(onContextLost,"onContextLost");
	HX_MARK_MEMBER_NAME(onReady,"onReady");
	HX_MARK_MEMBER_NAME(onResized,"onResized");
	HX_MARK_END_CLASS();
}

void Engine_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(driver,"driver");
	HX_VISIT_MEMBER_NAME(mem,"mem");
	HX_VISIT_MEMBER_NAME(hardware,"hardware");
	HX_VISIT_MEMBER_NAME(width,"width");
	HX_VISIT_MEMBER_NAME(height,"height");
	HX_VISIT_MEMBER_NAME(debug,"debug");
	HX_VISIT_MEMBER_NAME(drawTriangles,"drawTriangles");
	HX_VISIT_MEMBER_NAME(drawCalls,"drawCalls");
	HX_VISIT_MEMBER_NAME(shaderSwitches,"shaderSwitches");
	HX_VISIT_MEMBER_NAME(backgroundColor,"backgroundColor");
	HX_VISIT_MEMBER_NAME(autoResize,"autoResize");
	HX_VISIT_MEMBER_NAME(fullScreen,"fullScreen");
	HX_VISIT_MEMBER_NAME(triggerClear,"triggerClear");
	HX_VISIT_MEMBER_NAME(frameCount,"frameCount");
	HX_VISIT_MEMBER_NAME(forcedMatBits,"forcedMatBits");
	HX_VISIT_MEMBER_NAME(forcedMatMask,"forcedMatMask");
	HX_VISIT_MEMBER_NAME(realFps,"realFps");
	HX_VISIT_MEMBER_NAME(lastTime,"lastTime");
	HX_VISIT_MEMBER_NAME(antiAlias,"antiAlias");
	HX_VISIT_MEMBER_NAME(debugPoint,"debugPoint");
	HX_VISIT_MEMBER_NAME(debugLine,"debugLine");
	HX_VISIT_MEMBER_NAME(curProjMatrix,"curProjMatrix");
	HX_VISIT_MEMBER_NAME(onContextLost,"onContextLost");
	HX_VISIT_MEMBER_NAME(onReady,"onReady");
	HX_VISIT_MEMBER_NAME(onResized,"onResized");
}

Dynamic Engine_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"mem") ) { return mem; }
		if (HX_FIELD_EQ(inName,"fps") ) { return get_fps(); }
		if (HX_FIELD_EQ(inName,"end") ) { return end_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"init") ) { return init_dyn(); }
		if (HX_FIELD_EQ(inName,"line") ) { return line_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"check") ) { return check_dyn(); }
		if (HX_FIELD_EQ(inName,"width") ) { return width; }
		if (HX_FIELD_EQ(inName,"debug") ) { return debug; }
		if (HX_FIELD_EQ(inName,"start") ) { return start_dyn(); }
		if (HX_FIELD_EQ(inName,"begin") ) { return begin_dyn(); }
		if (HX_FIELD_EQ(inName,"reset") ) { return reset_dyn(); }
		if (HX_FIELD_EQ(inName,"point") ) { return point_dyn(); }
		if (HX_FIELD_EQ(inName,"lineP") ) { return lineP_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"driver") ) { return inCallProp ? get_driver() : driver; }
		if (HX_FIELD_EQ(inName,"height") ) { return height; }
		if (HX_FIELD_EQ(inName,"resize") ) { return resize_dyn(); }
		if (HX_FIELD_EQ(inName,"render") ) { return render_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"CURRENT") ) { return CURRENT; }
		if (HX_FIELD_EQ(inName,"realFps") ) { return realFps; }
		if (HX_FIELD_EQ(inName,"onReady") ) { return onReady; }
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		if (HX_FIELD_EQ(inName,"get_fps") ) { return get_fps_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"hardware") ) { return hardware; }
		if (HX_FIELD_EQ(inName,"lastTime") ) { return lastTime; }
		if (HX_FIELD_EQ(inName,"onCreate") ) { return onCreate_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"drawCalls") ) { return drawCalls; }
		if (HX_FIELD_EQ(inName,"antiAlias") ) { return antiAlias; }
		if (HX_FIELD_EQ(inName,"debugLine") ) { return debugLine; }
		if (HX_FIELD_EQ(inName,"set_debug") ) { return set_debug_dyn(); }
		if (HX_FIELD_EQ(inName,"onResized") ) { return onResized; }
		if (HX_FIELD_EQ(inName,"setTarget") ) { return setTarget_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"getCurrent") ) { return getCurrent_dyn(); }
		if (HX_FIELD_EQ(inName,"autoResize") ) { return autoResize; }
		if (HX_FIELD_EQ(inName,"fullScreen") ) { return fullScreen; }
		if (HX_FIELD_EQ(inName,"frameCount") ) { return frameCount; }
		if (HX_FIELD_EQ(inName,"debugPoint") ) { return debugPoint; }
		if (HX_FIELD_EQ(inName,"get_driver") ) { return get_driver_dyn(); }
		if (HX_FIELD_EQ(inName,"setCurrent") ) { return setCurrent_dyn(); }
		if (HX_FIELD_EQ(inName,"driverName") ) { return driverName_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"triggerClear") ) { return triggerClear; }
		if (HX_FIELD_EQ(inName,"selectShader") ) { return selectShader_dyn(); }
		if (HX_FIELD_EQ(inName,"selectBuffer") ) { return selectBuffer_dyn(); }
		if (HX_FIELD_EQ(inName,"renderBuffer") ) { return renderBuffer_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"drawTriangles") ) { return drawTriangles; }
		if (HX_FIELD_EQ(inName,"forcedMatBits") ) { return forcedMatBits; }
		if (HX_FIELD_EQ(inName,"forcedMatMask") ) { return forcedMatMask; }
		if (HX_FIELD_EQ(inName,"curProjMatrix") ) { return curProjMatrix; }
		if (HX_FIELD_EQ(inName,"renderIndexed") ) { return renderIndexed_dyn(); }
		if (HX_FIELD_EQ(inName,"onContextLost") ) { return onContextLost; }
		if (HX_FIELD_EQ(inName,"onStageResize") ) { return onStageResize_dyn(); }
		if (HX_FIELD_EQ(inName,"setRenderZone") ) { return setRenderZone_dyn(); }
		if (HX_FIELD_EQ(inName,"restoreOpenfl") ) { return restoreOpenfl_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"shaderSwitches") ) { return shaderSwitches; }
		if (HX_FIELD_EQ(inName,"selectMaterial") ) { return selectMaterial_dyn(); }
		if (HX_FIELD_EQ(inName,"set_fullScreen") ) { return set_fullScreen_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"backgroundColor") ) { return backgroundColor; }
		if (HX_FIELD_EQ(inName,"renderTriBuffer") ) { return renderTriBuffer_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"renderQuadBuffer") ) { return renderQuadBuffer_dyn(); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"renderMultiBuffers") ) { return renderMultiBuffers_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Engine_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"mem") ) { mem=inValue.Cast< ::h3d::impl::MemoryManager >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"width") ) { width=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"debug") ) { if (inCallProp) return set_debug(inValue);debug=inValue.Cast< bool >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"driver") ) { driver=inValue.Cast< ::h3d::impl::Driver >(); return inValue; }
		if (HX_FIELD_EQ(inName,"height") ) { height=inValue.Cast< int >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"CURRENT") ) { CURRENT=inValue.Cast< ::h3d::Engine >(); return inValue; }
		if (HX_FIELD_EQ(inName,"realFps") ) { realFps=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"onReady") ) { onReady=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"hardware") ) { hardware=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lastTime") ) { lastTime=inValue.Cast< Float >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"drawCalls") ) { drawCalls=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"antiAlias") ) { antiAlias=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"debugLine") ) { debugLine=inValue.Cast< ::h3d::Drawable >(); return inValue; }
		if (HX_FIELD_EQ(inName,"onResized") ) { onResized=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"autoResize") ) { autoResize=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"fullScreen") ) { if (inCallProp) return set_fullScreen(inValue);fullScreen=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"frameCount") ) { frameCount=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"debugPoint") ) { debugPoint=inValue.Cast< ::h3d::Drawable >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"triggerClear") ) { triggerClear=inValue.Cast< bool >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"drawTriangles") ) { drawTriangles=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"forcedMatBits") ) { forcedMatBits=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"forcedMatMask") ) { forcedMatMask=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"curProjMatrix") ) { curProjMatrix=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		if (HX_FIELD_EQ(inName,"onContextLost") ) { onContextLost=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"shaderSwitches") ) { shaderSwitches=inValue.Cast< int >(); return inValue; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"backgroundColor") ) { backgroundColor=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Engine_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("driver"));
	outFields->push(HX_CSTRING("mem"));
	outFields->push(HX_CSTRING("hardware"));
	outFields->push(HX_CSTRING("width"));
	outFields->push(HX_CSTRING("height"));
	outFields->push(HX_CSTRING("debug"));
	outFields->push(HX_CSTRING("drawTriangles"));
	outFields->push(HX_CSTRING("drawCalls"));
	outFields->push(HX_CSTRING("shaderSwitches"));
	outFields->push(HX_CSTRING("backgroundColor"));
	outFields->push(HX_CSTRING("autoResize"));
	outFields->push(HX_CSTRING("fullScreen"));
	outFields->push(HX_CSTRING("triggerClear"));
	outFields->push(HX_CSTRING("fps"));
	outFields->push(HX_CSTRING("frameCount"));
	outFields->push(HX_CSTRING("forcedMatBits"));
	outFields->push(HX_CSTRING("forcedMatMask"));
	outFields->push(HX_CSTRING("realFps"));
	outFields->push(HX_CSTRING("lastTime"));
	outFields->push(HX_CSTRING("antiAlias"));
	outFields->push(HX_CSTRING("debugPoint"));
	outFields->push(HX_CSTRING("debugLine"));
	outFields->push(HX_CSTRING("curProjMatrix"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("CURRENT"),
	HX_CSTRING("check"),
	HX_CSTRING("getCurrent"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h3d::impl::Driver*/ ,(int)offsetof(Engine_obj,driver),HX_CSTRING("driver")},
	{hx::fsObject /*::h3d::impl::MemoryManager*/ ,(int)offsetof(Engine_obj,mem),HX_CSTRING("mem")},
	{hx::fsBool,(int)offsetof(Engine_obj,hardware),HX_CSTRING("hardware")},
	{hx::fsInt,(int)offsetof(Engine_obj,width),HX_CSTRING("width")},
	{hx::fsInt,(int)offsetof(Engine_obj,height),HX_CSTRING("height")},
	{hx::fsBool,(int)offsetof(Engine_obj,debug),HX_CSTRING("debug")},
	{hx::fsInt,(int)offsetof(Engine_obj,drawTriangles),HX_CSTRING("drawTriangles")},
	{hx::fsInt,(int)offsetof(Engine_obj,drawCalls),HX_CSTRING("drawCalls")},
	{hx::fsInt,(int)offsetof(Engine_obj,shaderSwitches),HX_CSTRING("shaderSwitches")},
	{hx::fsInt,(int)offsetof(Engine_obj,backgroundColor),HX_CSTRING("backgroundColor")},
	{hx::fsBool,(int)offsetof(Engine_obj,autoResize),HX_CSTRING("autoResize")},
	{hx::fsBool,(int)offsetof(Engine_obj,fullScreen),HX_CSTRING("fullScreen")},
	{hx::fsBool,(int)offsetof(Engine_obj,triggerClear),HX_CSTRING("triggerClear")},
	{hx::fsInt,(int)offsetof(Engine_obj,frameCount),HX_CSTRING("frameCount")},
	{hx::fsInt,(int)offsetof(Engine_obj,forcedMatBits),HX_CSTRING("forcedMatBits")},
	{hx::fsInt,(int)offsetof(Engine_obj,forcedMatMask),HX_CSTRING("forcedMatMask")},
	{hx::fsFloat,(int)offsetof(Engine_obj,realFps),HX_CSTRING("realFps")},
	{hx::fsFloat,(int)offsetof(Engine_obj,lastTime),HX_CSTRING("lastTime")},
	{hx::fsInt,(int)offsetof(Engine_obj,antiAlias),HX_CSTRING("antiAlias")},
	{hx::fsObject /*::h3d::Drawable*/ ,(int)offsetof(Engine_obj,debugPoint),HX_CSTRING("debugPoint")},
	{hx::fsObject /*::h3d::Drawable*/ ,(int)offsetof(Engine_obj,debugLine),HX_CSTRING("debugLine")},
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(Engine_obj,curProjMatrix),HX_CSTRING("curProjMatrix")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Engine_obj,onContextLost),HX_CSTRING("onContextLost")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Engine_obj,onReady),HX_CSTRING("onReady")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Engine_obj,onResized),HX_CSTRING("onResized")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("driver"),
	HX_CSTRING("mem"),
	HX_CSTRING("hardware"),
	HX_CSTRING("width"),
	HX_CSTRING("height"),
	HX_CSTRING("debug"),
	HX_CSTRING("drawTriangles"),
	HX_CSTRING("drawCalls"),
	HX_CSTRING("shaderSwitches"),
	HX_CSTRING("backgroundColor"),
	HX_CSTRING("autoResize"),
	HX_CSTRING("fullScreen"),
	HX_CSTRING("triggerClear"),
	HX_CSTRING("frameCount"),
	HX_CSTRING("forcedMatBits"),
	HX_CSTRING("forcedMatMask"),
	HX_CSTRING("realFps"),
	HX_CSTRING("lastTime"),
	HX_CSTRING("antiAlias"),
	HX_CSTRING("debugPoint"),
	HX_CSTRING("debugLine"),
	HX_CSTRING("curProjMatrix"),
	HX_CSTRING("get_driver"),
	HX_CSTRING("start"),
	HX_CSTRING("setCurrent"),
	HX_CSTRING("init"),
	HX_CSTRING("driverName"),
	HX_CSTRING("selectShader"),
	HX_CSTRING("selectMaterial"),
	HX_CSTRING("selectBuffer"),
	HX_CSTRING("renderTriBuffer"),
	HX_CSTRING("renderQuadBuffer"),
	HX_CSTRING("renderBuffer"),
	HX_CSTRING("renderIndexed"),
	HX_CSTRING("renderMultiBuffers"),
	HX_CSTRING("set_debug"),
	HX_CSTRING("onCreate"),
	HX_CSTRING("onContextLost"),
	HX_CSTRING("onReady"),
	HX_CSTRING("onStageResize"),
	HX_CSTRING("set_fullScreen"),
	HX_CSTRING("onResized"),
	HX_CSTRING("resize"),
	HX_CSTRING("begin"),
	HX_CSTRING("reset"),
	HX_CSTRING("end"),
	HX_CSTRING("setTarget"),
	HX_CSTRING("setRenderZone"),
	HX_CSTRING("render"),
	HX_CSTRING("point"),
	HX_CSTRING("line"),
	HX_CSTRING("lineP"),
	HX_CSTRING("dispose"),
	HX_CSTRING("get_fps"),
	HX_CSTRING("restoreOpenfl"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Engine_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Engine_obj::CURRENT,"CURRENT");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Engine_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Engine_obj::CURRENT,"CURRENT");
};

#endif

Class Engine_obj::__mClass;

void Engine_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.Engine"), hx::TCanCast< Engine_obj> ,sStaticFields,sMemberFields,
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

void Engine_obj::__boot()
{
	CURRENT= null();
}

} // end namespace h3d
