#include <hxcpp.h>

#ifndef INCLUDED_Demo
#include <Demo.h>
#endif
#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_List
#include <List.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_flash_Lib
#include <flash/Lib.h>
#endif
#ifndef INCLUDED_flash_display_DisplayObject
#include <flash/display/DisplayObject.h>
#endif
#ifndef INCLUDED_flash_display_DisplayObjectContainer
#include <flash/display/DisplayObjectContainer.h>
#endif
#ifndef INCLUDED_flash_display_Graphics
#include <flash/display/Graphics.h>
#endif
#ifndef INCLUDED_flash_display_IBitmapDrawable
#include <flash/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_flash_display_InteractiveObject
#include <flash/display/InteractiveObject.h>
#endif
#ifndef INCLUDED_flash_display_MovieClip
#include <flash/display/MovieClip.h>
#endif
#ifndef INCLUDED_flash_display_Shape
#include <flash/display/Shape.h>
#endif
#ifndef INCLUDED_flash_display_Sprite
#include <flash/display/Sprite.h>
#endif
#ifndef INCLUDED_flash_display_Stage
#include <flash/display/Stage.h>
#endif
#ifndef INCLUDED_flash_events_EventDispatcher
#include <flash/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_flash_events_IEventDispatcher
#include <flash/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_h2d_Anim
#include <h2d/Anim.h>
#endif
#ifndef INCLUDED_h2d_BatchElement
#include <h2d/BatchElement.h>
#endif
#ifndef INCLUDED_h2d_Bitmap
#include <h2d/Bitmap.h>
#endif
#ifndef INCLUDED_h2d_Drawable
#include <h2d/Drawable.h>
#endif
#ifndef INCLUDED_h2d_DrawableShader
#include <h2d/DrawableShader.h>
#endif
#ifndef INCLUDED_h2d_Font
#include <h2d/Font.h>
#endif
#ifndef INCLUDED_h2d_Graphics
#include <h2d/Graphics.h>
#endif
#ifndef INCLUDED_h2d_Layers
#include <h2d/Layers.h>
#endif
#ifndef INCLUDED_h2d_Scene
#include <h2d/Scene.h>
#endif
#ifndef INCLUDED_h2d_Sprite
#include <h2d/Sprite.h>
#endif
#ifndef INCLUDED_h2d_SpriteBatch
#include <h2d/SpriteBatch.h>
#endif
#ifndef INCLUDED_h2d_Text
#include <h2d/Text.h>
#endif
#ifndef INCLUDED_h2d_Tile
#include <h2d/Tile.h>
#endif
#ifndef INCLUDED_h2d_col_Bounds
#include <h2d/col/Bounds.h>
#endif
#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
#endif
#ifndef INCLUDED_h3d_IDrawable
#include <h3d/IDrawable.h>
#endif
#ifndef INCLUDED_h3d_Vector
#include <h3d/Vector.h>
#endif
#ifndef INCLUDED_h3d_impl_Driver
#include <h3d/impl/Driver.h>
#endif
#ifndef INCLUDED_h3d_impl_GlDriver
#include <h3d/impl/GlDriver.h>
#endif
#ifndef INCLUDED_h3d_impl_Shader
#include <h3d/impl/Shader.h>
#endif
#ifndef INCLUDED_haxe_Log
#include <haxe/Log.h>
#endif
#ifndef INCLUDED_haxe_Timer
#include <haxe/Timer.h>
#endif
#ifndef INCLUDED_haxe_Unserializer
#include <haxe/Unserializer.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_hxd_Charset
#include <hxd/Charset.h>
#endif
#ifndef INCLUDED_hxd_Profiler
#include <hxd/Profiler.h>
#endif
#ifndef INCLUDED_hxd_Res
#include <hxd/Res.h>
#endif
#ifndef INCLUDED_hxd_System
#include <hxd/System.h>
#endif
#ifndef INCLUDED_hxd_res_EmbedFileSystem
#include <hxd/res/EmbedFileSystem.h>
#endif
#ifndef INCLUDED_hxd_res_FileSystem
#include <hxd/res/FileSystem.h>
#endif
#ifndef INCLUDED_hxd_res_FontBuilder
#include <hxd/res/FontBuilder.h>
#endif
#ifndef INCLUDED_hxd_res_Loader
#include <hxd/res/Loader.h>
#endif
#ifndef INCLUDED_hxd_res_Resource
#include <hxd/res/Resource.h>
#endif
#ifndef INCLUDED_hxd_res_Texture
#include <hxd/res/Texture.h>
#endif

Void Demo_obj::__construct()
{
HX_STACK_FRAME("Demo","new",0x367a83b5,"Demo.new","Demo.hx",14,0x79ee295b)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(209)
	this->count = (int)0;
	HX_STACK_LINE(208)
	this->spin = (int)0;
	HX_STACK_LINE(22)
	::h3d::Engine _g = ::h3d::Engine_obj::__new(null(),null());		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(22)
	this->engine = _g;
	HX_STACK_LINE(23)
	this->engine->onReady = this->init_dyn();
	HX_STACK_LINE(24)
	this->engine->backgroundColor = (int)-3355444;
	HX_STACK_LINE(26)
	{
		HX_STACK_LINE(26)
		::h3d::Engine _this = this->engine;		HX_STACK_VAR(_this,"_this");
		HX_STACK_LINE(26)
		_this->driver->init(_this->onCreate_dyn(),!(_this->hardware));
	}
}
;
	return null();
}

//Demo_obj::~Demo_obj() { }

Dynamic Demo_obj::__CreateEmpty() { return  new Demo_obj; }
hx::ObjectPtr< Demo_obj > Demo_obj::__new()
{  hx::ObjectPtr< Demo_obj > result = new Demo_obj();
	result->__construct();
	return result;}

Dynamic Demo_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Demo_obj > result = new Demo_obj();
	result->__construct();
	return result;}

Void Demo_obj::onResize( Dynamic _){
{
		HX_STACK_FRAME("Demo","onResize",0x862e68fe,"Demo.onResize","Demo.hx",35,0x79ee295b)
		HX_STACK_THIS(this)
		HX_STACK_ARG(_,"_")
		HX_STACK_LINE(36)
		::haxe::Log_obj::trace(HX_CSTRING("resize"),hx::SourceInfo(HX_CSTRING("Demo.hx"),36,HX_CSTRING("Demo"),HX_CSTRING("onResize")));
		HX_STACK_LINE(37)
		int _g = ::flash::Lib_obj::get_current()->get_stage()->get_stageWidth();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(37)
		::String _g1 = (_g + HX_CSTRING(" "));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(37)
		int _g2 = ::flash::Lib_obj::get_current()->get_stage()->get_stageHeight();		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(37)
		::String _g3 = (_g1 + _g2);		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(37)
		::haxe::Log_obj::trace(_g3,hx::SourceInfo(HX_CSTRING("Demo.hx"),37,HX_CSTRING("Demo"),HX_CSTRING("onResize")));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Demo_obj,onResize,(void))

Void Demo_obj::init( ){
{
		HX_STACK_FRAME("Demo","init",0x7171721b,"Demo.init","Demo.hx",41,0x79ee295b)
		HX_STACK_THIS(this)
		HX_STACK_LINE(43)
		::h2d::Scene _g = ::h2d::Scene_obj::__new();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(43)
		this->scene = _g;
		HX_STACK_LINE(44)
		::h2d::Sprite root = ::h2d::Sprite_obj::__new(this->scene);		HX_STACK_VAR(root,"root");
		struct _Function_1_1{
			inline static Dynamic Block( ){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","Demo.hx",46,0x79ee295b)
				{
					hx::Anon __result = hx::Anon_obj::Create();
					__result->Add(HX_CSTRING("antiAliasing") , false,false);
					__result->Add(HX_CSTRING("chars") , ::hxd::Charset_obj::DEFAULT_CHARS,false);
					return __result;
				}
				return null();
			}
		};
		HX_STACK_LINE(46)
		::h2d::Font font = ::hxd::res::FontBuilder_obj::getFont(HX_CSTRING("arial"),(int)32,_Function_1_1::Block());		HX_STACK_VAR(font,"font");
		struct _Function_1_2{
			inline static Dynamic Block( ){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","Demo.hx",47,0x79ee295b)
				{
					hx::Anon __result = hx::Anon_obj::Create();
					__result->Add(HX_CSTRING("antiAliasing") , false,false);
					__result->Add(HX_CSTRING("chars") , ::hxd::Charset_obj::DEFAULT_CHARS,false);
					return __result;
				}
				return null();
			}
		};
		HX_STACK_LINE(47)
		::h2d::Font fontRoboto = ::hxd::res::FontBuilder_obj::getFont(HX_CSTRING("Roboto-Black"),(int)32,_Function_1_2::Block());		HX_STACK_VAR(fontRoboto,"fontRoboto");
		HX_STACK_LINE(49)
		::h2d::Tile tileHaxe = ::hxd::Res_obj::loader->loadTexture(HX_CSTRING("haxe.png"))->toTile();		HX_STACK_VAR(tileHaxe,"tileHaxe");
		HX_STACK_LINE(50)
		::h2d::Tile tileNME = ::hxd::Res_obj::loader->loadTexture(HX_CSTRING("nme.png"))->toTile();		HX_STACK_VAR(tileNME,"tileNME");
		HX_STACK_LINE(51)
		::h2d::Tile tileOFL = ::hxd::Res_obj::loader->loadTexture(HX_CSTRING("openfl.png"))->toTile();		HX_STACK_VAR(tileOFL,"tileOFL");
		HX_STACK_LINE(53)
		::h2d::Tile oTileHaxe = tileHaxe;		HX_STACK_VAR(oTileHaxe,"oTileHaxe");
		HX_STACK_LINE(55)
		::h2d::Tile _g1;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(55)
		{
			HX_STACK_LINE(55)
			Dynamic dx = ::Std_obj::_int((Float(tileHaxe->width) / Float((int)2)));		HX_STACK_VAR(dx,"dx");
			HX_STACK_LINE(55)
			Dynamic dy = ::Std_obj::_int((Float(tileHaxe->height) / Float((int)2)));		HX_STACK_VAR(dy,"dy");
			HX_STACK_LINE(55)
			if (((dx == null()))){
				HX_STACK_LINE(55)
				dx = (int(tileHaxe->width) >> int((int)1));
			}
			HX_STACK_LINE(55)
			if (((dy == null()))){
				HX_STACK_LINE(55)
				dy = (int(tileHaxe->height) >> int((int)1));
			}
			HX_STACK_LINE(55)
			_g1 = tileHaxe->sub((int)0,(int)0,tileHaxe->width,tileHaxe->height,-(dx),-(dy));
		}
		HX_STACK_LINE(55)
		tileHaxe = _g1;
		HX_STACK_LINE(56)
		::h2d::Tile _g2;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(56)
		{
			HX_STACK_LINE(56)
			Dynamic dx = ::Std_obj::_int((Float(tileNME->width) / Float((int)2)));		HX_STACK_VAR(dx,"dx");
			HX_STACK_LINE(56)
			Dynamic dy = ::Std_obj::_int((Float(tileNME->height) / Float((int)2)));		HX_STACK_VAR(dy,"dy");
			HX_STACK_LINE(56)
			if (((dx == null()))){
				HX_STACK_LINE(56)
				dx = (int(tileNME->width) >> int((int)1));
			}
			HX_STACK_LINE(56)
			if (((dy == null()))){
				HX_STACK_LINE(56)
				dy = (int(tileNME->height) >> int((int)1));
			}
			HX_STACK_LINE(56)
			_g2 = tileNME->sub((int)0,(int)0,tileNME->width,tileNME->height,-(dx),-(dy));
		}
		HX_STACK_LINE(56)
		tileNME = _g2;
		HX_STACK_LINE(57)
		::h2d::Tile _g3;		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(57)
		{
			HX_STACK_LINE(57)
			Dynamic dx = ::Std_obj::_int((Float(tileOFL->width) / Float((int)2)));		HX_STACK_VAR(dx,"dx");
			HX_STACK_LINE(57)
			Dynamic dy = ::Std_obj::_int((Float(tileOFL->height) / Float((int)2)));		HX_STACK_VAR(dy,"dy");
			HX_STACK_LINE(57)
			if (((dx == null()))){
				HX_STACK_LINE(57)
				dx = (int(tileOFL->width) >> int((int)1));
			}
			HX_STACK_LINE(57)
			if (((dy == null()))){
				HX_STACK_LINE(57)
				dy = (int(tileOFL->height) >> int((int)1));
			}
			HX_STACK_LINE(57)
			_g3 = tileOFL->sub((int)0,(int)0,tileOFL->width,tileOFL->height,-(dx),-(dy));
		}
		HX_STACK_LINE(57)
		tileOFL = _g3;
		HX_STACK_LINE(59)
		int stw = ::flash::Lib_obj::get_current()->get_stage()->get_stageWidth();		HX_STACK_VAR(stw,"stw");
		HX_STACK_LINE(60)
		int sth = ::flash::Lib_obj::get_current()->get_stage()->get_stageHeight();		HX_STACK_VAR(sth,"sth");
		HX_STACK_LINE(62)
		::h2d::Tile _g4;		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(62)
		{
			HX_STACK_LINE(62)
			Dynamic dx = (int)0;		HX_STACK_VAR(dx,"dx");
			HX_STACK_LINE(62)
			Dynamic dy = (int)0;		HX_STACK_VAR(dy,"dy");
			HX_STACK_LINE(62)
			if (((dx == null()))){
				HX_STACK_LINE(62)
				dx = (int(tileHaxe->width) >> int((int)1));
			}
			HX_STACK_LINE(62)
			if (((dy == null()))){
				HX_STACK_LINE(62)
				dy = (int(tileHaxe->height) >> int((int)1));
			}
			HX_STACK_LINE(62)
			_g4 = tileHaxe->sub((int)0,(int)0,tileHaxe->width,tileHaxe->height,-(dx),-(dy));
		}
		HX_STACK_LINE(62)
		::h2d::Bitmap fill = ::h2d::Bitmap_obj::__new(_g4,this->scene,null());		HX_STACK_VAR(fill,"fill");
		HX_STACK_LINE(63)
		{
			HX_STACK_LINE(63)
			Float v = (Float(stw) / Float(tileHaxe->width));		HX_STACK_VAR(v,"v");
			HX_STACK_LINE(63)
			fill->scaleX = v;
			HX_STACK_LINE(63)
			{
				HX_STACK_LINE(63)
				fill->posChanged = true;
				HX_STACK_LINE(63)
				if (((fill->childs != null()))){
					HX_STACK_LINE(63)
					int _g5 = (int)0;		HX_STACK_VAR(_g5,"_g5");
					HX_STACK_LINE(63)
					Array< ::Dynamic > _g11 = fill->childs;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(63)
					while((true)){
						HX_STACK_LINE(63)
						if ((!(((_g5 < _g11->length))))){
							HX_STACK_LINE(63)
							break;
						}
						HX_STACK_LINE(63)
						::h2d::Sprite c = _g11->__get(_g5).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(63)
						++(_g5);
						HX_STACK_LINE(63)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(63)
				fill->posChanged;
			}
			HX_STACK_LINE(63)
			v;
		}
		HX_STACK_LINE(64)
		{
			HX_STACK_LINE(64)
			Float v = ((Float(sth) / Float(tileHaxe->height)) * 0.7);		HX_STACK_VAR(v,"v");
			HX_STACK_LINE(64)
			fill->scaleY = v;
			HX_STACK_LINE(64)
			{
				HX_STACK_LINE(64)
				fill->posChanged = true;
				HX_STACK_LINE(64)
				if (((fill->childs != null()))){
					HX_STACK_LINE(64)
					int _g5 = (int)0;		HX_STACK_VAR(_g5,"_g5");
					HX_STACK_LINE(64)
					Array< ::Dynamic > _g11 = fill->childs;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(64)
					while((true)){
						HX_STACK_LINE(64)
						if ((!(((_g5 < _g11->length))))){
							HX_STACK_LINE(64)
							break;
						}
						HX_STACK_LINE(64)
						::h2d::Sprite c = _g11->__get(_g5).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(64)
						++(_g5);
						HX_STACK_LINE(64)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(64)
				fill->posChanged;
			}
			HX_STACK_LINE(64)
			v;
		}
		HX_STACK_LINE(65)
		if (((fill->parent != null()))){
			HX_STACK_LINE(65)
			fill->parent->setChildIndex(fill,(int)0);
		}
		HX_STACK_LINE(66)
		fill->name = HX_CSTRING("fill");
		HX_STACK_LINE(68)
		::h2d::Tile subHaxe;		HX_STACK_VAR(subHaxe,"subHaxe");
		HX_STACK_LINE(68)
		{
			HX_STACK_LINE(68)
			::h2d::Tile _this = oTileHaxe->sub((int)0,(int)0,(int)16,(int)16,null(),null());		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(68)
			Dynamic dx = (int)8;		HX_STACK_VAR(dx,"dx");
			HX_STACK_LINE(68)
			Dynamic dy = (int)8;		HX_STACK_VAR(dy,"dy");
			HX_STACK_LINE(68)
			if (((dx == null()))){
				HX_STACK_LINE(68)
				dx = (int(_this->width) >> int((int)1));
			}
			HX_STACK_LINE(68)
			if (((dy == null()))){
				HX_STACK_LINE(68)
				dy = (int(_this->height) >> int((int)1));
			}
			HX_STACK_LINE(68)
			subHaxe = _this->sub((int)0,(int)0,_this->width,_this->height,-(dx),-(dy));
		}
		HX_STACK_LINE(69)
		::h2d::SpriteBatch _g5 = ::h2d::SpriteBatch_obj::__new(tileHaxe,this->scene);		HX_STACK_VAR(_g5,"_g5");
		HX_STACK_LINE(69)
		::Demo_obj::batch = _g5;
		HX_STACK_LINE(70)
		{
			HX_STACK_LINE(70)
			::h2d::SpriteBatch _this = ::Demo_obj::batch;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(70)
			bool _g6 = _this->shader->hasVertexColor = true;		HX_STACK_VAR(_g6,"_g6");
			HX_STACK_LINE(70)
			_this->hasVertexColor = _g6;
			HX_STACK_LINE(70)
			true;
		}
		HX_STACK_LINE(71)
		{
			HX_STACK_LINE(71)
			::h2d::SpriteBatch _this = ::Demo_obj::batch;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(71)
			bool _g7 = _this->shader->hasVertexAlpha = true;		HX_STACK_VAR(_g7,"_g7");
			HX_STACK_LINE(71)
			_this->hasVertexAlpha = _g7;
			HX_STACK_LINE(71)
			true;
		}
		HX_STACK_LINE(72)
		::Demo_obj::batch->hasRotationScale = true;
		HX_STACK_LINE(74)
		{
			HX_STACK_LINE(74)
			int _g11 = (int)0;		HX_STACK_VAR(_g11,"_g11");
			HX_STACK_LINE(74)
			int _g6 = (int)256;		HX_STACK_VAR(_g6,"_g6");
			HX_STACK_LINE(74)
			while((true)){
				HX_STACK_LINE(74)
				if ((!(((_g11 < _g6))))){
					HX_STACK_LINE(74)
					break;
				}
				HX_STACK_LINE(74)
				int i = (_g11)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(75)
				::h2d::BatchElement _g8 = ::h2d::BatchElement_obj::__new(tileHaxe);		HX_STACK_VAR(_g8,"_g8");
				HX_STACK_LINE(75)
				::h2d::BatchElement e = ::Demo_obj::batch->add(_g8,null());		HX_STACK_VAR(e,"e");
				HX_STACK_LINE(76)
				e->x = (hx::Mod(i,(int)16) * (int)16);
				HX_STACK_LINE(77)
				int _g9 = ::Std_obj::_int((Float(i) / Float((int)16)));		HX_STACK_VAR(_g9,"_g9");
				HX_STACK_LINE(77)
				int _g10 = (_g9 * (int)16);		HX_STACK_VAR(_g10,"_g10");
				HX_STACK_LINE(77)
				e->y = _g10;
				HX_STACK_LINE(78)
				e->t = subHaxe;
				HX_STACK_LINE(79)
				Float _g111 = ::Math_obj::random();		HX_STACK_VAR(_g111,"_g111");
				HX_STACK_LINE(79)
				e->color->x = _g111;
				HX_STACK_LINE(80)
				Float _g12 = ::Math_obj::random();		HX_STACK_VAR(_g12,"_g12");
				HX_STACK_LINE(80)
				e->color->y = _g12;
				HX_STACK_LINE(81)
				Float _g13 = ::Math_obj::random();		HX_STACK_VAR(_g13,"_g13");
				HX_STACK_LINE(81)
				e->color->z = _g13;
				HX_STACK_LINE(82)
				{
					HX_STACK_LINE(82)
					e->scaleX = (Float((int)16) / Float(e->t->width));
					HX_STACK_LINE(82)
					(int)16;
				}
				HX_STACK_LINE(83)
				{
					HX_STACK_LINE(83)
					e->scaleY = (Float((int)16) / Float(e->t->height));
					HX_STACK_LINE(83)
					(int)16;
				}
				HX_STACK_LINE(84)
				e->skewY = (Float(::Math_obj::PI) / Float((int)4));
				HX_STACK_LINE(85)
				int _g14 = ::Std_obj::random((int)10);		HX_STACK_VAR(_g14,"_g14");
				HX_STACK_LINE(85)
				int p = ((int)-5 + _g14);		HX_STACK_VAR(p,"p");
				HX_STACK_LINE(86)
				{
					HX_STACK_LINE(86)
					e->priority = p;
					HX_STACK_LINE(86)
					if (((e->batch != null()))){
						HX_STACK_LINE(86)
						e->batch->_delete(e);
						HX_STACK_LINE(86)
						e->batch->add(e,p);
					}
					HX_STACK_LINE(86)
					p;
				}
			}
		}
		HX_STACK_LINE(88)
		::Demo_obj::batch->name = HX_CSTRING("batch");
		HX_STACK_LINE(90)
		::h2d::Text _g15 = ::h2d::Text_obj::__new(font,root);		HX_STACK_VAR(_g15,"_g15");
		HX_STACK_LINE(90)
		::Demo_obj::fps = _g15;
		HX_STACK_LINE(91)
		::Demo_obj::fps->set_textColor((int)16777215);
		struct _Function_1_3{
			inline static Dynamic Block( ){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","Demo.hx",92,0x79ee295b)
				{
					hx::Anon __result = hx::Anon_obj::Create();
					__result->Add(HX_CSTRING("dx") , 0.5,false);
					__result->Add(HX_CSTRING("dy") , 0.5,false);
					__result->Add(HX_CSTRING("color") , (int)16711680,false);
					__result->Add(HX_CSTRING("alpha") , 0.8,false);
					return __result;
				}
				return null();
			}
		};
		HX_STACK_LINE(92)
		::Demo_obj::fps->dropShadow = _Function_1_3::Block();
		HX_STACK_LINE(93)
		::Demo_obj::fps->set_text(HX_CSTRING(""));
		HX_STACK_LINE(94)
		{
			HX_STACK_LINE(94)
			::h2d::Text _this = ::Demo_obj::fps;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(94)
			_this->x = (int)0;
			HX_STACK_LINE(94)
			{
				HX_STACK_LINE(94)
				_this->posChanged = true;
				HX_STACK_LINE(94)
				if (((_this->childs != null()))){
					HX_STACK_LINE(94)
					int _g6 = (int)0;		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(94)
					Array< ::Dynamic > _g11 = _this->childs;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(94)
					while((true)){
						HX_STACK_LINE(94)
						if ((!(((_g6 < _g11->length))))){
							HX_STACK_LINE(94)
							break;
						}
						HX_STACK_LINE(94)
						::h2d::Sprite c = _g11->__get(_g6).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(94)
						++(_g6);
						HX_STACK_LINE(94)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(94)
				_this->posChanged;
			}
			HX_STACK_LINE(94)
			(int)0;
		}
		HX_STACK_LINE(95)
		{
			HX_STACK_LINE(95)
			::h2d::Text _this = ::Demo_obj::fps;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(95)
			_this->y = (int)450;
			HX_STACK_LINE(95)
			{
				HX_STACK_LINE(95)
				_this->posChanged = true;
				HX_STACK_LINE(95)
				if (((_this->childs != null()))){
					HX_STACK_LINE(95)
					int _g6 = (int)0;		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(95)
					Array< ::Dynamic > _g11 = _this->childs;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(95)
					while((true)){
						HX_STACK_LINE(95)
						if ((!(((_g6 < _g11->length))))){
							HX_STACK_LINE(95)
							break;
						}
						HX_STACK_LINE(95)
						::h2d::Sprite c = _g11->__get(_g6).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(95)
						++(_g6);
						HX_STACK_LINE(95)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(95)
				_this->posChanged;
			}
			HX_STACK_LINE(95)
			(int)450;
		}
		HX_STACK_LINE(96)
		::Demo_obj::fps->name = HX_CSTRING("tf");
		HX_STACK_LINE(98)
		::h2d::Text _g16 = ::h2d::Text_obj::__new(font,root);		HX_STACK_VAR(_g16,"_g16");
		HX_STACK_LINE(98)
		::Demo_obj::tf = _g16;
		HX_STACK_LINE(99)
		::Demo_obj::tf->set_textColor((int)16777215);
		struct _Function_1_4{
			inline static Dynamic Block( ){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","Demo.hx",100,0x79ee295b)
				{
					hx::Anon __result = hx::Anon_obj::Create();
					__result->Add(HX_CSTRING("dx") , 0.5,false);
					__result->Add(HX_CSTRING("dy") , 0.5,false);
					__result->Add(HX_CSTRING("color") , (int)16711680,false);
					__result->Add(HX_CSTRING("alpha") , 0.8,false);
					return __result;
				}
				return null();
			}
		};
		HX_STACK_LINE(100)
		::Demo_obj::tf->dropShadow = _Function_1_4::Block();
		HX_STACK_LINE(101)
		::Demo_obj::tf->set_text(HX_CSTRING("This is a large batch of text\n that is representative about\n real world pav\xc3""\xa9""."));
		HX_STACK_LINE(102)
		{
			HX_STACK_LINE(102)
			::h2d::Text _this = ::Demo_obj::tf;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(102)
			_this->y = (int)300;
			HX_STACK_LINE(102)
			{
				HX_STACK_LINE(102)
				_this->posChanged = true;
				HX_STACK_LINE(102)
				if (((_this->childs != null()))){
					HX_STACK_LINE(102)
					int _g6 = (int)0;		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(102)
					Array< ::Dynamic > _g11 = _this->childs;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(102)
					while((true)){
						HX_STACK_LINE(102)
						if ((!(((_g6 < _g11->length))))){
							HX_STACK_LINE(102)
							break;
						}
						HX_STACK_LINE(102)
						::h2d::Sprite c = _g11->__get(_g6).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(102)
						++(_g6);
						HX_STACK_LINE(102)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(102)
				_this->posChanged;
			}
			HX_STACK_LINE(102)
			(int)300;
		}
		HX_STACK_LINE(103)
		{
			HX_STACK_LINE(103)
			::h2d::Text _this = ::Demo_obj::tf;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(103)
			int _g17 = ::hxd::System_obj::get_height();		HX_STACK_VAR(_g17,"_g17");
			HX_STACK_LINE(103)
			Float v = (_g17 * 0.5);		HX_STACK_VAR(v,"v");
			HX_STACK_LINE(103)
			_this->x = v;
			HX_STACK_LINE(103)
			{
				HX_STACK_LINE(103)
				_this->posChanged = true;
				HX_STACK_LINE(103)
				if (((_this->childs != null()))){
					HX_STACK_LINE(103)
					int _g6 = (int)0;		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(103)
					Array< ::Dynamic > _g11 = _this->childs;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(103)
					while((true)){
						HX_STACK_LINE(103)
						if ((!(((_g6 < _g11->length))))){
							HX_STACK_LINE(103)
							break;
						}
						HX_STACK_LINE(103)
						::h2d::Sprite c = _g11->__get(_g6).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(103)
						++(_g6);
						HX_STACK_LINE(103)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(103)
				_this->posChanged;
			}
			HX_STACK_LINE(103)
			v;
		}
		HX_STACK_LINE(104)
		::Demo_obj::tf->name = HX_CSTRING("tf");
		HX_STACK_LINE(106)
		::h2d::Tile _char = ::hxd::Res_obj::loader->loadTexture(HX_CSTRING("char.png"))->toTile();		HX_STACK_VAR(_char,"char");
		HX_STACK_LINE(108)
		Array< ::Dynamic > idle_anim = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(idle_anim,"idle_anim");
		HX_STACK_LINE(110)
		int x = (int)0;		HX_STACK_VAR(x,"x");
		HX_STACK_LINE(111)
		int y = (int)0;		HX_STACK_VAR(y,"y");
		HX_STACK_LINE(112)
		int w = (int)48;		HX_STACK_VAR(w,"w");
		HX_STACK_LINE(112)
		int h = (int)32;		HX_STACK_VAR(h,"h");
		HX_STACK_LINE(113)
		Array< ::Dynamic > idle_anim1 = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(idle_anim1,"idle_anim1");
		HX_STACK_LINE(114)
		{
			HX_STACK_LINE(114)
			int _g6 = (int)0;		HX_STACK_VAR(_g6,"_g6");
			HX_STACK_LINE(114)
			while((true)){
				HX_STACK_LINE(114)
				if ((!(((_g6 < (int)6))))){
					HX_STACK_LINE(114)
					break;
				}
				HX_STACK_LINE(114)
				int i = (_g6)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(115)
				::h2d::Tile _g18;		HX_STACK_VAR(_g18,"_g18");
				HX_STACK_LINE(115)
				{
					HX_STACK_LINE(115)
					::h2d::Tile _this = _char->sub(x,y,w,h,null(),null());		HX_STACK_VAR(_this,"_this");
					HX_STACK_LINE(115)
					Dynamic dx = (int(w) >> int((int)1));		HX_STACK_VAR(dx,"dx");
					HX_STACK_LINE(115)
					Dynamic dy = h;		HX_STACK_VAR(dy,"dy");
					HX_STACK_LINE(115)
					if (((dx == null()))){
						HX_STACK_LINE(115)
						dx = (int(_this->width) >> int((int)1));
					}
					HX_STACK_LINE(115)
					if (((dy == null()))){
						HX_STACK_LINE(115)
						dy = (int(_this->height) >> int((int)1));
					}
					HX_STACK_LINE(115)
					_g18 = _this->sub((int)0,(int)0,_this->width,_this->height,-(dx),-(dy));
				}
				HX_STACK_LINE(115)
				idle_anim1->push(_g18);
				HX_STACK_LINE(116)
				hx::AddEq(x,(int)48);
			}
		}
		HX_STACK_LINE(119)
		::h2d::Anim _g19 = ::h2d::Anim_obj::__new(idle_anim1,null(),null(),this->scene);		HX_STACK_VAR(_g19,"_g19");
		HX_STACK_LINE(119)
		::Demo_obj::anim = _g19;
		HX_STACK_LINE(120)
		{
			HX_STACK_LINE(120)
			::h2d::Anim _this = ::Demo_obj::anim;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(120)
			_this->x = (int)16;
			HX_STACK_LINE(120)
			{
				HX_STACK_LINE(120)
				_this->posChanged = true;
				HX_STACK_LINE(120)
				if (((_this->childs != null()))){
					HX_STACK_LINE(120)
					int _g6 = (int)0;		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(120)
					Array< ::Dynamic > _g11 = _this->childs;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(120)
					while((true)){
						HX_STACK_LINE(120)
						if ((!(((_g6 < _g11->length))))){
							HX_STACK_LINE(120)
							break;
						}
						HX_STACK_LINE(120)
						::h2d::Sprite c = _g11->__get(_g6).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(120)
						++(_g6);
						HX_STACK_LINE(120)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(120)
				_this->posChanged;
			}
			HX_STACK_LINE(120)
			(int)16;
		}
		HX_STACK_LINE(121)
		{
			HX_STACK_LINE(121)
			::h2d::Anim _this = ::Demo_obj::anim;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(121)
			_this->y = (int)200;
			HX_STACK_LINE(121)
			{
				HX_STACK_LINE(121)
				_this->posChanged = true;
				HX_STACK_LINE(121)
				if (((_this->childs != null()))){
					HX_STACK_LINE(121)
					int _g6 = (int)0;		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(121)
					Array< ::Dynamic > _g11 = _this->childs;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(121)
					while((true)){
						HX_STACK_LINE(121)
						if ((!(((_g6 < _g11->length))))){
							HX_STACK_LINE(121)
							break;
						}
						HX_STACK_LINE(121)
						::h2d::Sprite c = _g11->__get(_g6).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(121)
						++(_g6);
						HX_STACK_LINE(121)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(121)
				_this->posChanged;
			}
			HX_STACK_LINE(121)
			(int)200;
		}
		HX_STACK_LINE(122)
		::Demo_obj::anim->name = HX_CSTRING("anim");
		HX_STACK_LINE(125)
		::h2d::Bitmap _g20 = ::h2d::Bitmap_obj::__new(idle_anim1->__get((int)1).StaticCast< ::h2d::Tile >(),this->scene,null());		HX_STACK_VAR(_g20,"_g20");
		HX_STACK_LINE(125)
		::Demo_obj::bmp = _g20;
		HX_STACK_LINE(126)
		::Demo_obj::bmp->name = HX_CSTRING("bitmap");
		HX_STACK_LINE(127)
		{
			HX_STACK_LINE(127)
			::h2d::Bitmap _this = ::Demo_obj::bmp;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(127)
			_this->x = (int)16;
			HX_STACK_LINE(127)
			{
				HX_STACK_LINE(127)
				_this->posChanged = true;
				HX_STACK_LINE(127)
				if (((_this->childs != null()))){
					HX_STACK_LINE(127)
					int _g6 = (int)0;		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(127)
					Array< ::Dynamic > _g11 = _this->childs;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(127)
					while((true)){
						HX_STACK_LINE(127)
						if ((!(((_g6 < _g11->length))))){
							HX_STACK_LINE(127)
							break;
						}
						HX_STACK_LINE(127)
						::h2d::Sprite c = _g11->__get(_g6).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(127)
						++(_g6);
						HX_STACK_LINE(127)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(127)
				_this->posChanged;
			}
			HX_STACK_LINE(127)
			(int)16;
		}
		HX_STACK_LINE(128)
		{
			HX_STACK_LINE(128)
			::h2d::Bitmap _this = ::Demo_obj::bmp;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(128)
			_this->y = (int)250;
			HX_STACK_LINE(128)
			{
				HX_STACK_LINE(128)
				_this->posChanged = true;
				HX_STACK_LINE(128)
				if (((_this->childs != null()))){
					HX_STACK_LINE(128)
					int _g6 = (int)0;		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(128)
					Array< ::Dynamic > _g11 = _this->childs;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(128)
					while((true)){
						HX_STACK_LINE(128)
						if ((!(((_g6 < _g11->length))))){
							HX_STACK_LINE(128)
							break;
						}
						HX_STACK_LINE(128)
						::h2d::Sprite c = _g11->__get(_g6).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(128)
						++(_g6);
						HX_STACK_LINE(128)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(128)
				_this->posChanged;
			}
			HX_STACK_LINE(128)
			(int)250;
		}
		HX_STACK_LINE(129)
		::Demo_obj::anims = Array_obj< ::Dynamic >::__new();
		HX_STACK_LINE(131)
		::h2d::Bitmap _g21 = ::h2d::Bitmap_obj::__new(idle_anim1->__get((int)1).StaticCast< ::h2d::Tile >(),this->scene,null());		HX_STACK_VAR(_g21,"_g21");
		HX_STACK_LINE(131)
		::Demo_obj::bmp = _g21;
		HX_STACK_LINE(132)
		::Demo_obj::bmp->name = HX_CSTRING("bitmap");
		HX_STACK_LINE(133)
		{
			HX_STACK_LINE(133)
			::h2d::Bitmap _this = ::Demo_obj::bmp;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(133)
			_this->x = (int)100;
			HX_STACK_LINE(133)
			{
				HX_STACK_LINE(133)
				_this->posChanged = true;
				HX_STACK_LINE(133)
				if (((_this->childs != null()))){
					HX_STACK_LINE(133)
					int _g6 = (int)0;		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(133)
					Array< ::Dynamic > _g11 = _this->childs;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(133)
					while((true)){
						HX_STACK_LINE(133)
						if ((!(((_g6 < _g11->length))))){
							HX_STACK_LINE(133)
							break;
						}
						HX_STACK_LINE(133)
						::h2d::Sprite c = _g11->__get(_g6).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(133)
						++(_g6);
						HX_STACK_LINE(133)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(133)
				_this->posChanged;
			}
			HX_STACK_LINE(133)
			(int)100;
		}
		HX_STACK_LINE(134)
		{
			HX_STACK_LINE(134)
			::h2d::Bitmap _this = ::Demo_obj::bmp;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(134)
			_this->y = (int)250;
			HX_STACK_LINE(134)
			{
				HX_STACK_LINE(134)
				_this->posChanged = true;
				HX_STACK_LINE(134)
				if (((_this->childs != null()))){
					HX_STACK_LINE(134)
					int _g6 = (int)0;		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(134)
					Array< ::Dynamic > _g11 = _this->childs;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(134)
					while((true)){
						HX_STACK_LINE(134)
						if ((!(((_g6 < _g11->length))))){
							HX_STACK_LINE(134)
							break;
						}
						HX_STACK_LINE(134)
						::h2d::Sprite c = _g11->__get(_g6).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(134)
						++(_g6);
						HX_STACK_LINE(134)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(134)
				_this->posChanged;
			}
			HX_STACK_LINE(134)
			(int)250;
		}
		HX_STACK_LINE(138)
		::flash::display::Shape shCircle = ::flash::display::Shape_obj::__new();		HX_STACK_VAR(shCircle,"shCircle");
		HX_STACK_LINE(139)
		shCircle->get_graphics()->beginFill((int)16711680,null());
		HX_STACK_LINE(140)
		shCircle->get_graphics()->drawCircle((int)60,(int)400,(int)50);
		HX_STACK_LINE(141)
		shCircle->get_graphics()->endFill();
		HX_STACK_LINE(143)
		::flash::display::Shape shSquare = ::flash::display::Shape_obj::__new();		HX_STACK_VAR(shSquare,"shSquare");
		HX_STACK_LINE(144)
		shSquare->get_graphics()->beginFill((int)16512,null());
		HX_STACK_LINE(145)
		shSquare->get_graphics()->drawRect((int)100,(int)400,(int)50,(int)50);
		HX_STACK_LINE(146)
		shSquare->get_graphics()->endFill();
		HX_STACK_LINE(148)
		::h2d::Sprite_obj::fromSprite(shCircle,this->scene);
		HX_STACK_LINE(149)
		::h2d::Sprite_obj::fromSprite(shSquare,this->scene);
		HX_STACK_LINE(151)
		::h2d::Sprite local = ::h2d::Sprite_obj::__new(this->scene);		HX_STACK_VAR(local,"local");
		HX_STACK_LINE(152)
		local->name = HX_CSTRING("local");
		HX_STACK_LINE(153)
		::h2d::Anim a = null();		HX_STACK_VAR(a,"a");
		HX_STACK_LINE(154)
		{
			HX_STACK_LINE(154)
			int _g11 = (int)0;		HX_STACK_VAR(_g11,"_g11");
			HX_STACK_LINE(154)
			int _g6 = (int)256;		HX_STACK_VAR(_g6,"_g6");
			HX_STACK_LINE(154)
			while((true)){
				HX_STACK_LINE(154)
				if ((!(((_g11 < _g6))))){
					HX_STACK_LINE(154)
					break;
				}
				HX_STACK_LINE(154)
				int i = (_g11)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(156)
				::h2d::Anim _g22 = ::h2d::Anim_obj::__new(idle_anim1,null(),::Demo_obj::anim->shader,local);		HX_STACK_VAR(_g22,"_g22");
				HX_STACK_LINE(156)
				::h2d::Anim _g23 = a = _g22;		HX_STACK_VAR(_g23,"_g23");
				HX_STACK_LINE(156)
				::Demo_obj::anims->push(_g23);
				HX_STACK_LINE(157)
				a->name = (HX_CSTRING("anim") + i);
				HX_STACK_LINE(158)
				{
					HX_STACK_LINE(158)
					Float v = ((int)300 + (hx::Mod(i,(int)16) * (int)16));		HX_STACK_VAR(v,"v");
					HX_STACK_LINE(158)
					a->x = v;
					HX_STACK_LINE(158)
					{
						HX_STACK_LINE(158)
						a->posChanged = true;
						HX_STACK_LINE(158)
						if (((a->childs != null()))){
							HX_STACK_LINE(158)
							int _g7 = (int)0;		HX_STACK_VAR(_g7,"_g7");
							HX_STACK_LINE(158)
							Array< ::Dynamic > _g12 = a->childs;		HX_STACK_VAR(_g12,"_g12");
							HX_STACK_LINE(158)
							while((true)){
								HX_STACK_LINE(158)
								if ((!(((_g7 < _g12->length))))){
									HX_STACK_LINE(158)
									break;
								}
								HX_STACK_LINE(158)
								::h2d::Sprite c = _g12->__get(_g7).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
								HX_STACK_LINE(158)
								++(_g7);
								HX_STACK_LINE(158)
								c->set_posChanged(true);
							}
						}
						HX_STACK_LINE(158)
						a->posChanged;
					}
					HX_STACK_LINE(158)
					v;
				}
				HX_STACK_LINE(159)
				{
					HX_STACK_LINE(159)
					int _g24 = ::Std_obj::_int((Float(i) / Float((int)16)));		HX_STACK_VAR(_g24,"_g24");
					HX_STACK_LINE(159)
					int _g25 = (_g24 * (int)16);		HX_STACK_VAR(_g25,"_g25");
					HX_STACK_LINE(159)
					Float v = ((int)16 + _g25);		HX_STACK_VAR(v,"v");
					HX_STACK_LINE(159)
					a->y = v;
					HX_STACK_LINE(159)
					{
						HX_STACK_LINE(159)
						a->posChanged = true;
						HX_STACK_LINE(159)
						if (((a->childs != null()))){
							HX_STACK_LINE(159)
							int _g7 = (int)0;		HX_STACK_VAR(_g7,"_g7");
							HX_STACK_LINE(159)
							Array< ::Dynamic > _g12 = a->childs;		HX_STACK_VAR(_g12,"_g12");
							HX_STACK_LINE(159)
							while((true)){
								HX_STACK_LINE(159)
								if ((!(((_g7 < _g12->length))))){
									HX_STACK_LINE(159)
									break;
								}
								HX_STACK_LINE(159)
								::h2d::Sprite c = _g12->__get(_g7).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
								HX_STACK_LINE(159)
								++(_g7);
								HX_STACK_LINE(159)
								c->set_posChanged(true);
							}
						}
						HX_STACK_LINE(159)
						a->posChanged;
					}
					HX_STACK_LINE(159)
					v;
				}
			}
		}
		HX_STACK_LINE(162)
		::h2d::Graphics s = ::h2d::Graphics_obj::__new(this->scene);		HX_STACK_VAR(s,"s");
		HX_STACK_LINE(163)
		s->beginFill((int)16711935,null());
		HX_STACK_LINE(164)
		s->drawRect((int)0,(int)0,(int)50,(int)50);
		HX_STACK_LINE(165)
		s->endFill();
		HX_STACK_LINE(167)
		{
			HX_STACK_LINE(167)
			s->x = (int)300;
			HX_STACK_LINE(167)
			{
				HX_STACK_LINE(167)
				s->posChanged = true;
				HX_STACK_LINE(167)
				if (((s->childs != null()))){
					HX_STACK_LINE(167)
					int _g6 = (int)0;		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(167)
					Array< ::Dynamic > _g11 = s->childs;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(167)
					while((true)){
						HX_STACK_LINE(167)
						if ((!(((_g6 < _g11->length))))){
							HX_STACK_LINE(167)
							break;
						}
						HX_STACK_LINE(167)
						::h2d::Sprite c = _g11->__get(_g6).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(167)
						++(_g6);
						HX_STACK_LINE(167)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(167)
				s->posChanged;
			}
			HX_STACK_LINE(167)
			(int)300;
		}
		HX_STACK_LINE(168)
		{
			HX_STACK_LINE(168)
			s->y = (int)300;
			HX_STACK_LINE(168)
			{
				HX_STACK_LINE(168)
				s->posChanged = true;
				HX_STACK_LINE(168)
				if (((s->childs != null()))){
					HX_STACK_LINE(168)
					int _g6 = (int)0;		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(168)
					Array< ::Dynamic > _g11 = s->childs;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(168)
					while((true)){
						HX_STACK_LINE(168)
						if ((!(((_g6 < _g11->length))))){
							HX_STACK_LINE(168)
							break;
						}
						HX_STACK_LINE(168)
						::h2d::Sprite c = _g11->__get(_g6).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(168)
						++(_g6);
						HX_STACK_LINE(168)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(168)
				s->posChanged;
			}
			HX_STACK_LINE(168)
			(int)300;
		}
		HX_STACK_LINE(169)
		::Demo_obj::square = s;
		HX_STACK_LINE(171)
		::h2d::Graphics s1 = ::h2d::Graphics_obj::__new(s);		HX_STACK_VAR(s1,"s1");
		HX_STACK_LINE(172)
		s1->beginFill((int)16711935,null());
		HX_STACK_LINE(173)
		s1->drawCircle((int)0,(int)0,(int)30,(int)30);
		HX_STACK_LINE(174)
		s1->endFill();
		HX_STACK_LINE(176)
		{
			HX_STACK_LINE(176)
			s1->x = (int)50;
			HX_STACK_LINE(176)
			{
				HX_STACK_LINE(176)
				s1->posChanged = true;
				HX_STACK_LINE(176)
				if (((s1->childs != null()))){
					HX_STACK_LINE(176)
					int _g6 = (int)0;		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(176)
					Array< ::Dynamic > _g11 = s1->childs;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(176)
					while((true)){
						HX_STACK_LINE(176)
						if ((!(((_g6 < _g11->length))))){
							HX_STACK_LINE(176)
							break;
						}
						HX_STACK_LINE(176)
						::h2d::Sprite c = _g11->__get(_g6).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(176)
						++(_g6);
						HX_STACK_LINE(176)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(176)
				s1->posChanged;
			}
			HX_STACK_LINE(176)
			(int)50;
		}
		HX_STACK_LINE(177)
		{
			HX_STACK_LINE(177)
			s1->y = (int)50;
			HX_STACK_LINE(177)
			{
				HX_STACK_LINE(177)
				s1->posChanged = true;
				HX_STACK_LINE(177)
				if (((s1->childs != null()))){
					HX_STACK_LINE(177)
					int _g6 = (int)0;		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(177)
					Array< ::Dynamic > _g11 = s1->childs;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(177)
					while((true)){
						HX_STACK_LINE(177)
						if ((!(((_g6 < _g11->length))))){
							HX_STACK_LINE(177)
							break;
						}
						HX_STACK_LINE(177)
						::h2d::Sprite c = _g11->__get(_g6).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(177)
						++(_g6);
						HX_STACK_LINE(177)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(177)
				s1->posChanged;
			}
			HX_STACK_LINE(177)
			(int)50;
		}
		HX_STACK_LINE(178)
		::Demo_obj::sphere = s1;
		HX_STACK_LINE(180)
		::hxd::System_obj::setLoop(this->update_dyn());
		HX_STACK_LINE(182)
		::h2d::Graphics _g26 = ::h2d::Graphics_obj::__new(this->scene);		HX_STACK_VAR(_g26,"_g26");
		HX_STACK_LINE(182)
		::Demo_obj::bds = _g26;
		HX_STACK_LINE(184)
		::h2d::Bitmap _g27 = ::h2d::Bitmap_obj::__new(idle_anim1->__get((int)1).StaticCast< ::h2d::Tile >(),this->scene,null());		HX_STACK_VAR(_g27,"_g27");
		HX_STACK_LINE(184)
		::Demo_obj::square = _g27;
		HX_STACK_LINE(185)
		::Demo_obj::square->name = HX_CSTRING("bitmap");
		HX_STACK_LINE(186)
		{
			HX_STACK_LINE(186)
			::h2d::Sprite _this = ::Demo_obj::square;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(186)
			_this->x = (int)200;
			HX_STACK_LINE(186)
			{
				HX_STACK_LINE(186)
				_this->posChanged = true;
				HX_STACK_LINE(186)
				if (((_this->childs != null()))){
					HX_STACK_LINE(186)
					int _g6 = (int)0;		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(186)
					Array< ::Dynamic > _g11 = _this->childs;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(186)
					while((true)){
						HX_STACK_LINE(186)
						if ((!(((_g6 < _g11->length))))){
							HX_STACK_LINE(186)
							break;
						}
						HX_STACK_LINE(186)
						::h2d::Sprite c = _g11->__get(_g6).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(186)
						++(_g6);
						HX_STACK_LINE(186)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(186)
				_this->posChanged;
			}
			HX_STACK_LINE(186)
			(int)200;
		}
		HX_STACK_LINE(187)
		{
			HX_STACK_LINE(187)
			::h2d::Sprite _this = ::Demo_obj::square;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(187)
			_this->y = (int)250;
			HX_STACK_LINE(187)
			{
				HX_STACK_LINE(187)
				_this->posChanged = true;
				HX_STACK_LINE(187)
				if (((_this->childs != null()))){
					HX_STACK_LINE(187)
					int _g6 = (int)0;		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(187)
					Array< ::Dynamic > _g11 = _this->childs;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(187)
					while((true)){
						HX_STACK_LINE(187)
						if ((!(((_g6 < _g11->length))))){
							HX_STACK_LINE(187)
							break;
						}
						HX_STACK_LINE(187)
						::h2d::Sprite c = _g11->__get(_g6).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(187)
						++(_g6);
						HX_STACK_LINE(187)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(187)
				_this->posChanged;
			}
			HX_STACK_LINE(187)
			(int)250;
		}
		HX_STACK_LINE(189)
		::h2d::Bitmap _g28 = ::h2d::Bitmap_obj::__new(idle_anim1->__get((int)1).StaticCast< ::h2d::Tile >(),::Demo_obj::square,null());		HX_STACK_VAR(_g28,"_g28");
		HX_STACK_LINE(189)
		::Demo_obj::sphere = _g28;
		HX_STACK_LINE(190)
		::Demo_obj::sphere->name = HX_CSTRING("bitmap");
		HX_STACK_LINE(191)
		{
			HX_STACK_LINE(191)
			::h2d::Sprite _this = ::Demo_obj::sphere;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(191)
			_this->x = (int)50;
			HX_STACK_LINE(191)
			{
				HX_STACK_LINE(191)
				_this->posChanged = true;
				HX_STACK_LINE(191)
				if (((_this->childs != null()))){
					HX_STACK_LINE(191)
					int _g6 = (int)0;		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(191)
					Array< ::Dynamic > _g11 = _this->childs;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(191)
					while((true)){
						HX_STACK_LINE(191)
						if ((!(((_g6 < _g11->length))))){
							HX_STACK_LINE(191)
							break;
						}
						HX_STACK_LINE(191)
						::h2d::Sprite c = _g11->__get(_g6).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(191)
						++(_g6);
						HX_STACK_LINE(191)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(191)
				_this->posChanged;
			}
			HX_STACK_LINE(191)
			(int)50;
		}
		HX_STACK_LINE(192)
		{
			HX_STACK_LINE(192)
			::h2d::Sprite _this = ::Demo_obj::sphere;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(192)
			_this->y = (int)50;
			HX_STACK_LINE(192)
			{
				HX_STACK_LINE(192)
				_this->posChanged = true;
				HX_STACK_LINE(192)
				if (((_this->childs != null()))){
					HX_STACK_LINE(192)
					int _g6 = (int)0;		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(192)
					Array< ::Dynamic > _g11 = _this->childs;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(192)
					while((true)){
						HX_STACK_LINE(192)
						if ((!(((_g6 < _g11->length))))){
							HX_STACK_LINE(192)
							break;
						}
						HX_STACK_LINE(192)
						::h2d::Sprite c = _g11->__get(_g6).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(192)
						++(_g6);
						HX_STACK_LINE(192)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(192)
				_this->posChanged;
			}
			HX_STACK_LINE(192)
			(int)50;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Demo_obj,init,(void))

Void Demo_obj::update( ){
{
		HX_STACK_FRAME("Demo","update",0xb5ffd5d4,"Demo.update","Demo.hx",211,0x79ee295b)
		HX_STACK_THIS(this)
		HX_STACK_LINE(212)
		{
			HX_STACK_LINE(212)
			::h2d::Sprite _g = ::Demo_obj::sphere;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(212)
			{
				HX_STACK_LINE(212)
				Float v = (_g->rotation + 0.02);		HX_STACK_VAR(v,"v");
				HX_STACK_LINE(212)
				_g->rotation = v;
				HX_STACK_LINE(212)
				{
					HX_STACK_LINE(212)
					_g->posChanged = true;
					HX_STACK_LINE(212)
					if (((_g->childs != null()))){
						HX_STACK_LINE(212)
						int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
						HX_STACK_LINE(212)
						Array< ::Dynamic > _g11 = _g->childs;		HX_STACK_VAR(_g11,"_g11");
						HX_STACK_LINE(212)
						while((true)){
							HX_STACK_LINE(212)
							if ((!(((_g1 < _g11->length))))){
								HX_STACK_LINE(212)
								break;
							}
							HX_STACK_LINE(212)
							::h2d::Sprite c = _g11->__get(_g1).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
							HX_STACK_LINE(212)
							++(_g1);
							HX_STACK_LINE(212)
							c->set_posChanged(true);
						}
					}
					HX_STACK_LINE(212)
					_g->posChanged;
				}
				HX_STACK_LINE(212)
				v;
			}
		}
		HX_STACK_LINE(213)
		{
			HX_STACK_LINE(213)
			::h2d::Sprite _g = ::Demo_obj::square;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(213)
			{
				HX_STACK_LINE(213)
				Float v = (_g->rotation + 0.001);		HX_STACK_VAR(v,"v");
				HX_STACK_LINE(213)
				_g->rotation = v;
				HX_STACK_LINE(213)
				{
					HX_STACK_LINE(213)
					_g->posChanged = true;
					HX_STACK_LINE(213)
					if (((_g->childs != null()))){
						HX_STACK_LINE(213)
						int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
						HX_STACK_LINE(213)
						Array< ::Dynamic > _g11 = _g->childs;		HX_STACK_VAR(_g11,"_g11");
						HX_STACK_LINE(213)
						while((true)){
							HX_STACK_LINE(213)
							if ((!(((_g1 < _g11->length))))){
								HX_STACK_LINE(213)
								break;
							}
							HX_STACK_LINE(213)
							::h2d::Sprite c = _g11->__get(_g1).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
							HX_STACK_LINE(213)
							++(_g1);
							HX_STACK_LINE(213)
							c->set_posChanged(true);
						}
					}
					HX_STACK_LINE(213)
					_g->posChanged;
				}
				HX_STACK_LINE(213)
				v;
			}
		}
		HX_STACK_LINE(214)
		{
			HX_STACK_LINE(214)
			::h2d::Sprite _this = ::Demo_obj::square;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(214)
			Float v;		HX_STACK_VAR(v,"v");
			HX_STACK_LINE(214)
			{
				HX_STACK_LINE(214)
				::h2d::Sprite _this1 = ::Demo_obj::square;		HX_STACK_VAR(_this1,"_this1");
				HX_STACK_LINE(214)
				Float _g = ::Math_obj::sin((this->count * 0.01));		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(214)
				Float _g1 = ::Math_obj::abs(_g);		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(214)
				Float _g2 = (0.5 * _g1);		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(214)
				Float v1 = (0.5 + _g2);		HX_STACK_VAR(v1,"v1");
				HX_STACK_LINE(214)
				_this1->scaleY = v1;
				HX_STACK_LINE(214)
				{
					HX_STACK_LINE(214)
					_this1->posChanged = true;
					HX_STACK_LINE(214)
					if (((_this1->childs != null()))){
						HX_STACK_LINE(214)
						int _g3 = (int)0;		HX_STACK_VAR(_g3,"_g3");
						HX_STACK_LINE(214)
						Array< ::Dynamic > _g11 = _this1->childs;		HX_STACK_VAR(_g11,"_g11");
						HX_STACK_LINE(214)
						while((true)){
							HX_STACK_LINE(214)
							if ((!(((_g3 < _g11->length))))){
								HX_STACK_LINE(214)
								break;
							}
							HX_STACK_LINE(214)
							::h2d::Sprite c = _g11->__get(_g3).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
							HX_STACK_LINE(214)
							++(_g3);
							HX_STACK_LINE(214)
							c->set_posChanged(true);
						}
					}
					HX_STACK_LINE(214)
					_this1->posChanged;
				}
				HX_STACK_LINE(214)
				v = v1;
			}
			HX_STACK_LINE(214)
			_this->scaleX = v;
			HX_STACK_LINE(214)
			{
				HX_STACK_LINE(214)
				_this->posChanged = true;
				HX_STACK_LINE(214)
				if (((_this->childs != null()))){
					HX_STACK_LINE(214)
					int _g = (int)0;		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(214)
					Array< ::Dynamic > _g1 = _this->childs;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(214)
					while((true)){
						HX_STACK_LINE(214)
						if ((!(((_g < _g1->length))))){
							HX_STACK_LINE(214)
							break;
						}
						HX_STACK_LINE(214)
						::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(214)
						++(_g);
						HX_STACK_LINE(214)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(214)
				_this->posChanged;
			}
			HX_STACK_LINE(214)
			v;
		}
		HX_STACK_LINE(215)
		{
			HX_STACK_LINE(215)
			::h2d::Sprite _this = ::Demo_obj::sphere;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(215)
			Float v;		HX_STACK_VAR(v,"v");
			HX_STACK_LINE(215)
			{
				HX_STACK_LINE(215)
				::h2d::Sprite _this1 = ::Demo_obj::sphere;		HX_STACK_VAR(_this1,"_this1");
				HX_STACK_LINE(215)
				Float _g3 = ::Math_obj::sin((this->count * 0.1));		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(215)
				Float _g4 = ::Math_obj::abs(_g3);		HX_STACK_VAR(_g4,"_g4");
				HX_STACK_LINE(215)
				Float _g5 = (0.5 * _g4);		HX_STACK_VAR(_g5,"_g5");
				HX_STACK_LINE(215)
				Float v1 = (0.5 + _g5);		HX_STACK_VAR(v1,"v1");
				HX_STACK_LINE(215)
				_this1->scaleY = v1;
				HX_STACK_LINE(215)
				{
					HX_STACK_LINE(215)
					_this1->posChanged = true;
					HX_STACK_LINE(215)
					if (((_this1->childs != null()))){
						HX_STACK_LINE(215)
						int _g = (int)0;		HX_STACK_VAR(_g,"_g");
						HX_STACK_LINE(215)
						Array< ::Dynamic > _g1 = _this1->childs;		HX_STACK_VAR(_g1,"_g1");
						HX_STACK_LINE(215)
						while((true)){
							HX_STACK_LINE(215)
							if ((!(((_g < _g1->length))))){
								HX_STACK_LINE(215)
								break;
							}
							HX_STACK_LINE(215)
							::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
							HX_STACK_LINE(215)
							++(_g);
							HX_STACK_LINE(215)
							c->set_posChanged(true);
						}
					}
					HX_STACK_LINE(215)
					_this1->posChanged;
				}
				HX_STACK_LINE(215)
				v = v1;
			}
			HX_STACK_LINE(215)
			_this->scaleX = v;
			HX_STACK_LINE(215)
			{
				HX_STACK_LINE(215)
				_this->posChanged = true;
				HX_STACK_LINE(215)
				if (((_this->childs != null()))){
					HX_STACK_LINE(215)
					int _g = (int)0;		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(215)
					Array< ::Dynamic > _g1 = _this->childs;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(215)
					while((true)){
						HX_STACK_LINE(215)
						if ((!(((_g < _g1->length))))){
							HX_STACK_LINE(215)
							break;
						}
						HX_STACK_LINE(215)
						::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(215)
						++(_g);
						HX_STACK_LINE(215)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(215)
				_this->posChanged;
			}
			HX_STACK_LINE(215)
			v;
		}
		HX_STACK_LINE(218)
		{
			HX_STACK_LINE(218)
			::h2d::Bitmap _this = ::Demo_obj::bmp;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(218)
			Float v = (Float(::Math_obj::PI) / Float((int)8));		HX_STACK_VAR(v,"v");
			HX_STACK_LINE(218)
			_this->skewX = v;
			HX_STACK_LINE(218)
			{
				HX_STACK_LINE(218)
				_this->posChanged = true;
				HX_STACK_LINE(218)
				if (((_this->childs != null()))){
					HX_STACK_LINE(218)
					int _g = (int)0;		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(218)
					Array< ::Dynamic > _g1 = _this->childs;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(218)
					while((true)){
						HX_STACK_LINE(218)
						if ((!(((_g < _g1->length))))){
							HX_STACK_LINE(218)
							break;
						}
						HX_STACK_LINE(218)
						::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(218)
						++(_g);
						HX_STACK_LINE(218)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(218)
				_this->posChanged;
			}
			HX_STACK_LINE(218)
			v;
		}
		HX_STACK_LINE(219)
		{
			HX_STACK_LINE(219)
			::h2d::Bitmap _this = ::Demo_obj::bmp;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(219)
			Float v = (Float(::Math_obj::PI) / Float((int)8));		HX_STACK_VAR(v,"v");
			HX_STACK_LINE(219)
			_this->skewY = v;
			HX_STACK_LINE(219)
			{
				HX_STACK_LINE(219)
				_this->posChanged = true;
				HX_STACK_LINE(219)
				if (((_this->childs != null()))){
					HX_STACK_LINE(219)
					int _g = (int)0;		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(219)
					Array< ::Dynamic > _g1 = _this->childs;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(219)
					while((true)){
						HX_STACK_LINE(219)
						if ((!(((_g < _g1->length))))){
							HX_STACK_LINE(219)
							break;
						}
						HX_STACK_LINE(219)
						::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(219)
						++(_g);
						HX_STACK_LINE(219)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(219)
				_this->posChanged;
			}
			HX_STACK_LINE(219)
			v;
		}
		HX_STACK_LINE(220)
		{
			HX_STACK_LINE(220)
			::h2d::Bitmap _this = ::Demo_obj::bmp;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(220)
			Float _g6 = ::Math_obj::sin((this->count * 0.1));		HX_STACK_VAR(_g6,"_g6");
			HX_STACK_LINE(220)
			Float _g7 = ::Math_obj::abs(_g6);		HX_STACK_VAR(_g7,"_g7");
			HX_STACK_LINE(220)
			Float _g8 = (0.1 * _g7);		HX_STACK_VAR(_g8,"_g8");
			HX_STACK_LINE(220)
			Float v = (1.0 + _g8);		HX_STACK_VAR(v,"v");
			HX_STACK_LINE(220)
			_this->scaleX = v;
			HX_STACK_LINE(220)
			{
				HX_STACK_LINE(220)
				_this->posChanged = true;
				HX_STACK_LINE(220)
				if (((_this->childs != null()))){
					HX_STACK_LINE(220)
					int _g = (int)0;		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(220)
					Array< ::Dynamic > _g1 = _this->childs;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(220)
					while((true)){
						HX_STACK_LINE(220)
						if ((!(((_g < _g1->length))))){
							HX_STACK_LINE(220)
							break;
						}
						HX_STACK_LINE(220)
						::h2d::Sprite c = _g1->__get(_g).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(220)
						++(_g);
						HX_STACK_LINE(220)
						c->set_posChanged(true);
					}
				}
				HX_STACK_LINE(220)
				_this->posChanged;
			}
			HX_STACK_LINE(220)
			v;
		}
		HX_STACK_LINE(222)
		::Demo_obj::bds->clear();
		HX_STACK_LINE(223)
		::Demo_obj::bds->beginFill((int)16711935,0.2);
		HX_STACK_LINE(224)
		::h2d::col::Bounds b = ::Demo_obj::bmp->getBounds();		HX_STACK_VAR(b,"b");
		HX_STACK_LINE(225)
		::Demo_obj::bds->drawRect(b->xMin,b->yMin,(b->xMax - b->xMin),(b->yMax - b->yMin));
		HX_STACK_LINE(226)
		::Demo_obj::bds->endFill();
		struct _Function_1_1{
			inline static Dynamic Block( ){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","Demo.hx",228,0x79ee295b)
				{
					HX_STACK_LINE(228)
					Array< ::Dynamic > e = Array_obj< ::Dynamic >::__new().Add(::Demo_obj::batch->first);		HX_STACK_VAR(e,"e");
					struct _Function_2_1{
						inline static Dynamic Block( Array< ::Dynamic > &e){
							HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","Demo.hx",228,0x79ee295b)
							{
								hx::Anon __result = hx::Anon_obj::Create();

								HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_3_1,Array< ::Dynamic >,e)
								Dynamic run(){
									HX_STACK_FRAME("*","_Function_3_1",0x520271b9,"*._Function_3_1","Demo.hx",228,0x79ee295b)
									{
										struct _Function_4_1{
											inline static Dynamic Block( Array< ::Dynamic > &e){
												HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","Demo.hx",228,0x79ee295b)
												{
													hx::Anon __result = hx::Anon_obj::Create();

													HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_5_1,Array< ::Dynamic >,e)
													::h2d::BatchElement run(){
														HX_STACK_FRAME("*","_Function_5_1",0x5203f63b,"*._Function_5_1","Demo.hx",228,0x79ee295b)
														{
															HX_STACK_LINE(228)
															::h2d::BatchElement cur = e->__get((int)0).StaticCast< ::h2d::BatchElement >();		HX_STACK_VAR(cur,"cur");
															HX_STACK_LINE(228)
															e[(int)0] = e->__get((int)0).StaticCast< ::h2d::BatchElement >()->next;
															HX_STACK_LINE(228)
															return cur;
														}
														return null();
													}
													HX_END_LOCAL_FUNC0(return)

													__result->Add(HX_CSTRING("next") ,  Dynamic(new _Function_5_1(e)),true);

													HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_5_2,Array< ::Dynamic >,e)
													bool run(){
														HX_STACK_FRAME("*","_Function_5_2",0x5203f63c,"*._Function_5_2","Demo.hx",228,0x79ee295b)
														{
															HX_STACK_LINE(228)
															return (e->__get((int)0).StaticCast< ::h2d::BatchElement >() != null());
														}
														return null();
													}
													HX_END_LOCAL_FUNC0(return)

													__result->Add(HX_CSTRING("hasNext") ,  Dynamic(new _Function_5_2(e)),true);
													return __result;
												}
												return null();
											}
										};
										HX_STACK_LINE(228)
										return _Function_4_1::Block(e);
									}
									return null();
								}
								HX_END_LOCAL_FUNC0(return)

								__result->Add(HX_CSTRING("iterator") ,  Dynamic(new _Function_3_1(e)),true);
								return __result;
							}
							return null();
						}
					};
					HX_STACK_LINE(228)
					return _Function_2_1::Block(e);
				}
				return null();
			}
		};
		HX_STACK_LINE(228)
		for(::cpp::FastIterator_obj< ::h2d::BatchElement > *__it = ::cpp::CreateFastIterator< ::h2d::BatchElement >((_Function_1_1::Block())->__Field(HX_CSTRING("iterator"),true)());  __it->hasNext(); ){
			::h2d::BatchElement e = __it->next();
			hx::AddEq(e->rotation,0.1);
		}
		HX_STACK_LINE(231)
		if ((::hxd::Profiler_obj::enable)){
			HX_STACK_LINE(231)
			Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
			HX_STACK_LINE(231)
			Dynamic ent = ::hxd::Profiler_obj::h->get(HX_CSTRING("myUpdate"));		HX_STACK_VAR(ent,"ent");
			HX_STACK_LINE(231)
			if (((null() != ent))){
				HX_STACK_LINE(231)
				if (((ent->__Field(HX_CSTRING("start"),true) != null()))){
					HX_STACK_LINE(231)
					hx::AddEq(ent->__FieldRef(HX_CSTRING("total")),(t - ent->__Field(HX_CSTRING("start"),true)));
				}
			}
		}
		HX_STACK_LINE(232)
		if ((::hxd::Profiler_obj::enable)){
			HX_STACK_LINE(232)
			Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
			HX_STACK_LINE(232)
			Dynamic ent = ::hxd::Profiler_obj::h->get(HX_CSTRING("engine.render"));		HX_STACK_VAR(ent,"ent");
			HX_STACK_LINE(232)
			if (((null() == ent))){
				struct _Function_3_1{
					inline static Dynamic Block( ){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","Demo.hx",232,0x79ee295b)
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
				HX_STACK_LINE(232)
				ent = _Function_3_1::Block();
				HX_STACK_LINE(232)
				::hxd::Profiler_obj::h->set(HX_CSTRING("engine.render"),ent);
			}
			HX_STACK_LINE(232)
			ent->__FieldRef(HX_CSTRING("start")) = t;
			HX_STACK_LINE(232)
			(ent->__FieldRef(HX_CSTRING("hit")))++;
		}
		HX_STACK_LINE(233)
		this->engine->render(this->scene);
		HX_STACK_LINE(234)
		if ((::hxd::Profiler_obj::enable)){
			HX_STACK_LINE(234)
			Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
			HX_STACK_LINE(234)
			Dynamic ent = ::hxd::Profiler_obj::h->get(HX_CSTRING("engine.render"));		HX_STACK_VAR(ent,"ent");
			HX_STACK_LINE(234)
			if (((null() != ent))){
				HX_STACK_LINE(234)
				if (((ent->__Field(HX_CSTRING("start"),true) != null()))){
					HX_STACK_LINE(234)
					hx::AddEq(ent->__FieldRef(HX_CSTRING("total")),(t - ent->__Field(HX_CSTRING("start"),true)));
				}
			}
		}
		HX_STACK_LINE(235)
		if ((::hxd::Profiler_obj::enable)){
			HX_STACK_LINE(235)
			Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
			HX_STACK_LINE(235)
			Dynamic ent = ::hxd::Profiler_obj::h->get(HX_CSTRING("engine.vbl"));		HX_STACK_VAR(ent,"ent");
			HX_STACK_LINE(235)
			if (((null() == ent))){
				struct _Function_3_1{
					inline static Dynamic Block( ){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","Demo.hx",235,0x79ee295b)
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
				HX_STACK_LINE(235)
				ent = _Function_3_1::Block();
				HX_STACK_LINE(235)
				::hxd::Profiler_obj::h->set(HX_CSTRING("engine.vbl"),ent);
			}
			HX_STACK_LINE(235)
			ent->__FieldRef(HX_CSTRING("start")) = t;
			HX_STACK_LINE(235)
			(ent->__FieldRef(HX_CSTRING("hit")))++;
		}
		HX_STACK_LINE(236)
		if (((this->count > (int)100))){
			HX_STACK_LINE(237)
			::String _g18;		HX_STACK_VAR(_g18,"_g18");
			HX_STACK_LINE(237)
			{
				HX_STACK_LINE(237)
				::String s = HX_CSTRING("");		HX_STACK_VAR(s,"s");
				HX_STACK_LINE(237)
				Array< Float > k = Array_obj< Float >::__new().Add(10000.0);		HX_STACK_VAR(k,"k");
				HX_STACK_LINE(237)
				hx::MultEq(k[(int)0],10.0);

				HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_3_1,Array< Float >,k)
				Float run(Float v){
					HX_STACK_FRAME("*","_Function_3_1",0x520271b9,"*._Function_3_1","Demo.hx",237,0x79ee295b)
					HX_STACK_ARG(v,"v")
					{
						HX_STACK_LINE(237)
						int _g9 = ::Std_obj::_int((v * k->__get((int)0)));		HX_STACK_VAR(_g9,"_g9");
						HX_STACK_LINE(237)
						return (Float(_g9) / Float(k->__get((int)0)));
					}
					return null();
				}
				HX_END_LOCAL_FUNC1(return)

				HX_STACK_LINE(237)
				Dynamic trunk =  Dynamic(new _Function_3_1(k));		HX_STACK_VAR(trunk,"trunk");
				HX_STACK_LINE(237)
				for(::cpp::FastIterator_obj< ::String > *__it = ::cpp::CreateFastIterator< ::String >(::hxd::Profiler_obj::h->keys());  __it->hasNext(); ){
					::String k1 = __it->next();
					{
						HX_STACK_LINE(237)
						Float sp;		HX_STACK_VAR(sp,"sp");
						HX_STACK_LINE(237)
						if ((!(::hxd::Profiler_obj::enable))){
							HX_STACK_LINE(237)
							sp = 0.0;
						}
						else{
							HX_STACK_LINE(237)
							sp = ::hxd::Profiler_obj::h->get(k1)->__Field(HX_CSTRING("total"),true);
						}
						HX_STACK_LINE(237)
						Float ht;		HX_STACK_VAR(ht,"ht");
						HX_STACK_LINE(237)
						if ((!(::hxd::Profiler_obj::enable))){
							HX_STACK_LINE(237)
							ht = 0.0;
						}
						else{
							HX_STACK_LINE(237)
							ht = ::hxd::Profiler_obj::h->get(k1)->__Field(HX_CSTRING("hit"),true);
						}
						HX_STACK_LINE(237)
						if (((sp <= ::hxd::Profiler_obj::minLimit))){
							HX_STACK_LINE(237)
							continue;
						}
						HX_STACK_LINE(237)
						Float _g10 = trunk(sp).Cast< Float >();		HX_STACK_VAR(_g10,"_g10");
						HX_STACK_LINE(237)
						::String _g11 = (((HX_CSTRING("tag: ") + k1) + HX_CSTRING(" spent: ")) + _g10);		HX_STACK_VAR(_g11,"_g11");
						HX_STACK_LINE(237)
						::String _g12 = (_g11 + HX_CSTRING(" hit:"));		HX_STACK_VAR(_g12,"_g12");
						HX_STACK_LINE(237)
						::String _g13 = (_g12 + ht);		HX_STACK_VAR(_g13,"_g13");
						HX_STACK_LINE(237)
						::String _g14 = (_g13 + HX_CSTRING(" avg time: "));		HX_STACK_VAR(_g14,"_g14");
						HX_STACK_LINE(237)
						Float _g15 = trunk((Float(sp) / Float(ht))).Cast< Float >();		HX_STACK_VAR(_g15,"_g15");
						HX_STACK_LINE(237)
						::String _g16 = (_g14 + _g15);		HX_STACK_VAR(_g16,"_g16");
						HX_STACK_LINE(237)
						::String _g17 = (_g16 + HX_CSTRING("<br/>\n"));		HX_STACK_VAR(_g17,"_g17");
						HX_STACK_LINE(237)
						hx::AddEq(s,_g17);
					}
;
				}
				HX_STACK_LINE(237)
				_g18 = s;
			}
			HX_STACK_LINE(237)
			::haxe::Log_obj::trace(_g18,hx::SourceInfo(HX_CSTRING("Demo.hx"),237,HX_CSTRING("Demo"),HX_CSTRING("update")));
			HX_STACK_LINE(238)
			if ((::hxd::Profiler_obj::enable)){
				HX_STACK_LINE(238)
				::haxe::ds::StringMap _g19 = ::haxe::ds::StringMap_obj::__new();		HX_STACK_VAR(_g19,"_g19");
				HX_STACK_LINE(238)
				::hxd::Profiler_obj::h = _g19;
			}
			HX_STACK_LINE(239)
			this->count = (int)0;
		}
		HX_STACK_LINE(242)
		(this->count)++;
		HX_STACK_LINE(245)
		::h3d::impl::GlDriver driver;		HX_STACK_VAR(driver,"driver");
		struct _Function_1_2{
			inline static ::h3d::impl::Driver Block( ){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","Demo.hx",245,0x79ee295b)
				{
					HX_STACK_LINE(245)
					::h3d::Engine _this;		HX_STACK_VAR(_this,"_this");
					HX_STACK_LINE(245)
					{
						HX_STACK_LINE(245)
						if (((::hxd::System_obj::debugLevel >= (int)1))){
							HX_STACK_LINE(245)
							if (((::h3d::Engine_obj::CURRENT == null()))){
								HX_STACK_LINE(245)
								HX_STACK_DO_THROW(HX_CSTRING("no current context, please do this operation after engine init/creation"));
							}
						}
						HX_STACK_LINE(245)
						_this = ::h3d::Engine_obj::CURRENT;
					}
					HX_STACK_LINE(245)
					return _this->driver;
				}
				return null();
			}
		};
		HX_STACK_LINE(245)
		driver = _Function_1_2::Block();
		HX_STACK_LINE(247)
		if ((::hxd::Profiler_obj::enable)){
			HX_STACK_LINE(247)
			Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
			HX_STACK_LINE(247)
			Dynamic ent = ::hxd::Profiler_obj::h->get(HX_CSTRING("engine.vbl"));		HX_STACK_VAR(ent,"ent");
			HX_STACK_LINE(247)
			if (((null() != ent))){
				HX_STACK_LINE(247)
				if (((ent->__Field(HX_CSTRING("start"),true) != null()))){
					HX_STACK_LINE(247)
					hx::AddEq(ent->__FieldRef(HX_CSTRING("total")),(t - ent->__Field(HX_CSTRING("start"),true)));
				}
			}
		}
		HX_STACK_LINE(248)
		if ((::hxd::Profiler_obj::enable)){
			HX_STACK_LINE(248)
			Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
			HX_STACK_LINE(248)
			Dynamic ent = ::hxd::Profiler_obj::h->get(HX_CSTRING("myUpdate"));		HX_STACK_VAR(ent,"ent");
			HX_STACK_LINE(248)
			if (((null() == ent))){
				struct _Function_3_1{
					inline static Dynamic Block( ){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","Demo.hx",248,0x79ee295b)
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
				HX_STACK_LINE(248)
				ent = _Function_3_1::Block();
				HX_STACK_LINE(248)
				::hxd::Profiler_obj::h->set(HX_CSTRING("myUpdate"),ent);
			}
			HX_STACK_LINE(248)
			ent->__FieldRef(HX_CSTRING("start")) = t;
			HX_STACK_LINE(248)
			(ent->__FieldRef(HX_CSTRING("hit")))++;
		}
		HX_STACK_LINE(249)
		int _g20 = (this->spin)++;		HX_STACK_VAR(_g20,"_g20");
		HX_STACK_LINE(249)
		if (((_g20 >= (int)10))){
			struct _Function_2_1{
				inline static ::h3d::Engine Block( ){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","Demo.hx",250,0x79ee295b)
					{
						HX_STACK_LINE(250)
						if (((::hxd::System_obj::debugLevel >= (int)1))){
							HX_STACK_LINE(250)
							if (((::h3d::Engine_obj::CURRENT == null()))){
								HX_STACK_LINE(250)
								HX_STACK_DO_THROW(HX_CSTRING("no current context, please do this operation after engine init/creation"));
							}
						}
						HX_STACK_LINE(250)
						return ::h3d::Engine_obj::CURRENT;
					}
					return null();
				}
			};
			HX_STACK_LINE(250)
			Float _g21 = (_Function_2_1::Block())->get_fps();		HX_STACK_VAR(_g21,"_g21");
			HX_STACK_LINE(250)
			::String _g22 = ::Std_obj::string(_g21);		HX_STACK_VAR(_g22,"_g22");
			HX_STACK_LINE(250)
			::String _g23 = (_g22 + HX_CSTRING(" ssw:"));		HX_STACK_VAR(_g23,"_g23");
			HX_STACK_LINE(250)
			::String _g24 = (_g23 + driver->shaderSwitch);		HX_STACK_VAR(_g24,"_g24");
			HX_STACK_LINE(250)
			::String _g25 = (_g24 + HX_CSTRING(" tsw:"));		HX_STACK_VAR(_g25,"_g25");
			HX_STACK_LINE(250)
			::String _g26 = (_g25 + driver->textureSwitch);		HX_STACK_VAR(_g26,"_g26");
			HX_STACK_LINE(250)
			::String _g27 = (_g26 + HX_CSTRING(" rsw"));		HX_STACK_VAR(_g27,"_g27");
			HX_STACK_LINE(250)
			::String _g28 = (_g27 + driver->resetSwitch);		HX_STACK_VAR(_g28,"_g28");
			HX_STACK_LINE(250)
			::Demo_obj::fps->set_text(_g28);
			HX_STACK_LINE(251)
			this->spin = (int)0;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Demo_obj,update,(void))

::h2d::Sprite Demo_obj::square;

::h2d::Sprite Demo_obj::sphere;

::h2d::Graphics Demo_obj::bds;

::h2d::Text Demo_obj::fps;

::h2d::Text Demo_obj::tf;

::h2d::SpriteBatch Demo_obj::batch;

::h2d::Bitmap Demo_obj::bmp;

::h2d::Anim Demo_obj::anim;

Array< ::Dynamic > Demo_obj::anims;

Void Demo_obj::main( ){
{
		HX_STACK_FRAME("Demo","main",0x740c6f44,"Demo.main","Demo.hx",259,0x79ee295b)
		HX_STACK_LINE(255)
		::hxd::res::EmbedFileSystem _g1;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(255)
		{
			HX_STACK_LINE(255)
			Dynamic _g = ::haxe::Unserializer_obj::run(HX_CSTRING("oy10:Roboto.ttfty10:haxe2k.pngty8:char.pngty10:openfl.pngty10:openfl.svgty7:nme.pngty8:haxe.pngty8:haxe.tgatg"));		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(255)
			_g1 = ::hxd::res::EmbedFileSystem_obj::__new(_g);
		}
		HX_STACK_LINE(260)
		::hxd::res::Loader _g2 = ::hxd::res::Loader_obj::__new(_g1);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(260)
		::hxd::Res_obj::loader = _g2;
		HX_STACK_LINE(261)
		::Demo_obj::__new();
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Demo_obj,main,(void))


Demo_obj::Demo_obj()
{
}

void Demo_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Demo);
	HX_MARK_MEMBER_NAME(engine,"engine");
	HX_MARK_MEMBER_NAME(scene,"scene");
	HX_MARK_MEMBER_NAME(actions,"actions");
	HX_MARK_MEMBER_NAME(spin,"spin");
	HX_MARK_MEMBER_NAME(count,"count");
	HX_MARK_END_CLASS();
}

void Demo_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(engine,"engine");
	HX_VISIT_MEMBER_NAME(scene,"scene");
	HX_VISIT_MEMBER_NAME(actions,"actions");
	HX_VISIT_MEMBER_NAME(spin,"spin");
	HX_VISIT_MEMBER_NAME(count,"count");
}

Dynamic Demo_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"tf") ) { return tf; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"bds") ) { return bds; }
		if (HX_FIELD_EQ(inName,"fps") ) { return fps; }
		if (HX_FIELD_EQ(inName,"bmp") ) { return bmp; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"anim") ) { return anim; }
		if (HX_FIELD_EQ(inName,"main") ) { return main_dyn(); }
		if (HX_FIELD_EQ(inName,"init") ) { return init_dyn(); }
		if (HX_FIELD_EQ(inName,"spin") ) { return spin; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"batch") ) { return batch; }
		if (HX_FIELD_EQ(inName,"anims") ) { return anims; }
		if (HX_FIELD_EQ(inName,"scene") ) { return scene; }
		if (HX_FIELD_EQ(inName,"count") ) { return count; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"square") ) { return square; }
		if (HX_FIELD_EQ(inName,"sphere") ) { return sphere; }
		if (HX_FIELD_EQ(inName,"engine") ) { return engine; }
		if (HX_FIELD_EQ(inName,"update") ) { return update_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"actions") ) { return actions; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"onResize") ) { return onResize_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Demo_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"tf") ) { tf=inValue.Cast< ::h2d::Text >(); return inValue; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"bds") ) { bds=inValue.Cast< ::h2d::Graphics >(); return inValue; }
		if (HX_FIELD_EQ(inName,"fps") ) { fps=inValue.Cast< ::h2d::Text >(); return inValue; }
		if (HX_FIELD_EQ(inName,"bmp") ) { bmp=inValue.Cast< ::h2d::Bitmap >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"anim") ) { anim=inValue.Cast< ::h2d::Anim >(); return inValue; }
		if (HX_FIELD_EQ(inName,"spin") ) { spin=inValue.Cast< int >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"batch") ) { batch=inValue.Cast< ::h2d::SpriteBatch >(); return inValue; }
		if (HX_FIELD_EQ(inName,"anims") ) { anims=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"scene") ) { scene=inValue.Cast< ::h2d::Scene >(); return inValue; }
		if (HX_FIELD_EQ(inName,"count") ) { count=inValue.Cast< int >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"square") ) { square=inValue.Cast< ::h2d::Sprite >(); return inValue; }
		if (HX_FIELD_EQ(inName,"sphere") ) { sphere=inValue.Cast< ::h2d::Sprite >(); return inValue; }
		if (HX_FIELD_EQ(inName,"engine") ) { engine=inValue.Cast< ::h3d::Engine >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"actions") ) { actions=inValue.Cast< ::List >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Demo_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("engine"));
	outFields->push(HX_CSTRING("scene"));
	outFields->push(HX_CSTRING("actions"));
	outFields->push(HX_CSTRING("spin"));
	outFields->push(HX_CSTRING("count"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("square"),
	HX_CSTRING("sphere"),
	HX_CSTRING("bds"),
	HX_CSTRING("fps"),
	HX_CSTRING("tf"),
	HX_CSTRING("batch"),
	HX_CSTRING("bmp"),
	HX_CSTRING("anim"),
	HX_CSTRING("anims"),
	HX_CSTRING("main"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h3d::Engine*/ ,(int)offsetof(Demo_obj,engine),HX_CSTRING("engine")},
	{hx::fsObject /*::h2d::Scene*/ ,(int)offsetof(Demo_obj,scene),HX_CSTRING("scene")},
	{hx::fsObject /*::List*/ ,(int)offsetof(Demo_obj,actions),HX_CSTRING("actions")},
	{hx::fsInt,(int)offsetof(Demo_obj,spin),HX_CSTRING("spin")},
	{hx::fsInt,(int)offsetof(Demo_obj,count),HX_CSTRING("count")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("engine"),
	HX_CSTRING("scene"),
	HX_CSTRING("actions"),
	HX_CSTRING("onResize"),
	HX_CSTRING("init"),
	HX_CSTRING("spin"),
	HX_CSTRING("count"),
	HX_CSTRING("update"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Demo_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Demo_obj::square,"square");
	HX_MARK_MEMBER_NAME(Demo_obj::sphere,"sphere");
	HX_MARK_MEMBER_NAME(Demo_obj::bds,"bds");
	HX_MARK_MEMBER_NAME(Demo_obj::fps,"fps");
	HX_MARK_MEMBER_NAME(Demo_obj::tf,"tf");
	HX_MARK_MEMBER_NAME(Demo_obj::batch,"batch");
	HX_MARK_MEMBER_NAME(Demo_obj::bmp,"bmp");
	HX_MARK_MEMBER_NAME(Demo_obj::anim,"anim");
	HX_MARK_MEMBER_NAME(Demo_obj::anims,"anims");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Demo_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Demo_obj::square,"square");
	HX_VISIT_MEMBER_NAME(Demo_obj::sphere,"sphere");
	HX_VISIT_MEMBER_NAME(Demo_obj::bds,"bds");
	HX_VISIT_MEMBER_NAME(Demo_obj::fps,"fps");
	HX_VISIT_MEMBER_NAME(Demo_obj::tf,"tf");
	HX_VISIT_MEMBER_NAME(Demo_obj::batch,"batch");
	HX_VISIT_MEMBER_NAME(Demo_obj::bmp,"bmp");
	HX_VISIT_MEMBER_NAME(Demo_obj::anim,"anim");
	HX_VISIT_MEMBER_NAME(Demo_obj::anims,"anims");
};

#endif

Class Demo_obj::__mClass;

void Demo_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("Demo"), hx::TCanCast< Demo_obj> ,sStaticFields,sMemberFields,
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

void Demo_obj::__boot()
{
}

