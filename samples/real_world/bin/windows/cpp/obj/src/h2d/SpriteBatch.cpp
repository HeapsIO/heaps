#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_h2d_BatchElement
#include <h2d/BatchElement.h>
#endif
#ifndef INCLUDED_h2d_Drawable
#include <h2d/Drawable.h>
#endif
#ifndef INCLUDED_h2d_DrawableShader
#include <h2d/DrawableShader.h>
#endif
#ifndef INCLUDED_h2d_Matrix
#include <h2d/Matrix.h>
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
#ifndef INCLUDED_h2d_col_Bounds
#include <h2d/col/Bounds.h>
#endif
#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
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
#ifndef INCLUDED_h3d_scene_RenderContext
#include <h3d/scene/RenderContext.h>
#endif
#ifndef INCLUDED_haxe_Log
#include <haxe/Log.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_hxd_Assert
#include <hxd/Assert.h>
#endif
namespace h2d{

Void SpriteBatch_obj::__construct(::h2d::Tile masterTile,::h2d::Sprite parent)
{
HX_STACK_FRAME("h2d.SpriteBatch","new",0xd55a1eb3,"h2d.SpriteBatch.new","h2d/SpriteBatch.hx",106,0x7caf17de)
HX_STACK_THIS(this)
HX_STACK_ARG(masterTile,"masterTile")
HX_STACK_ARG(parent,"parent")
{
	HX_STACK_LINE(107)
	super::__construct(parent,null());
	HX_STACK_LINE(108)
	this->tile = masterTile;
	HX_STACK_LINE(110)
	{
		HX_STACK_LINE(110)
		bool _g = this->shader->hasVertexColor = true;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(110)
		this->hasVertexColor = _g;
		HX_STACK_LINE(110)
		true;
	}
	HX_STACK_LINE(111)
	this->hasRotationScale = true;
	HX_STACK_LINE(112)
	{
		HX_STACK_LINE(112)
		bool _g1 = this->shader->hasVertexAlpha = true;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(112)
		this->hasVertexAlpha = _g1;
		HX_STACK_LINE(112)
		true;
	}
	HX_STACK_LINE(114)
	::h2d::Matrix _g2 = ::h2d::Matrix_obj::__new(null(),null(),null(),null(),null(),null());		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(114)
	this->tmpMatrix = _g2;
}
;
	return null();
}

//SpriteBatch_obj::~SpriteBatch_obj() { }

Dynamic SpriteBatch_obj::__CreateEmpty() { return  new SpriteBatch_obj; }
hx::ObjectPtr< SpriteBatch_obj > SpriteBatch_obj::__new(::h2d::Tile masterTile,::h2d::Sprite parent)
{  hx::ObjectPtr< SpriteBatch_obj > result = new SpriteBatch_obj();
	result->__construct(masterTile,parent);
	return result;}

Dynamic SpriteBatch_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< SpriteBatch_obj > result = new SpriteBatch_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

Void SpriteBatch_obj::dispose( ){
{
		HX_STACK_FRAME("h2d.SpriteBatch","dispose",0x96d3f472,"h2d.SpriteBatch.dispose","h2d/SpriteBatch.hx",117,0x7caf17de)
		HX_STACK_THIS(this)
		HX_STACK_LINE(118)
		this->super::dispose();
		struct _Function_1_1{
			inline static Dynamic Block( hx::ObjectPtr< ::h2d::SpriteBatch_obj > __this){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h2d/SpriteBatch.hx",120,0x7caf17de)
				{
					HX_STACK_LINE(120)
					Array< ::Dynamic > e = Array_obj< ::Dynamic >::__new().Add(__this->first);		HX_STACK_VAR(e,"e");
					struct _Function_2_1{
						inline static Dynamic Block( Array< ::Dynamic > &e){
							HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h2d/SpriteBatch.hx",120,0x7caf17de)
							{
								hx::Anon __result = hx::Anon_obj::Create();

								HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_3_1,Array< ::Dynamic >,e)
								Dynamic run(){
									HX_STACK_FRAME("*","_Function_3_1",0x520271b9,"*._Function_3_1","h2d/SpriteBatch.hx",120,0x7caf17de)
									{
										struct _Function_4_1{
											inline static Dynamic Block( Array< ::Dynamic > &e){
												HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h2d/SpriteBatch.hx",120,0x7caf17de)
												{
													hx::Anon __result = hx::Anon_obj::Create();

													HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_5_1,Array< ::Dynamic >,e)
													::h2d::BatchElement run(){
														HX_STACK_FRAME("*","_Function_5_1",0x5203f63b,"*._Function_5_1","h2d/SpriteBatch.hx",120,0x7caf17de)
														{
															HX_STACK_LINE(120)
															::h2d::BatchElement cur = e->__get((int)0).StaticCast< ::h2d::BatchElement >();		HX_STACK_VAR(cur,"cur");
															HX_STACK_LINE(120)
															e[(int)0] = e->__get((int)0).StaticCast< ::h2d::BatchElement >()->next;
															HX_STACK_LINE(120)
															return cur;
														}
														return null();
													}
													HX_END_LOCAL_FUNC0(return)

													__result->Add(HX_CSTRING("next") ,  Dynamic(new _Function_5_1(e)),true);

													HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_5_2,Array< ::Dynamic >,e)
													bool run(){
														HX_STACK_FRAME("*","_Function_5_2",0x5203f63c,"*._Function_5_2","h2d/SpriteBatch.hx",120,0x7caf17de)
														{
															HX_STACK_LINE(120)
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
										HX_STACK_LINE(120)
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
					HX_STACK_LINE(120)
					return _Function_2_1::Block(e);
				}
				return null();
			}
		};
		HX_STACK_LINE(120)
		for(::cpp::FastIterator_obj< ::h2d::BatchElement > *__it = ::cpp::CreateFastIterator< ::h2d::BatchElement >((_Function_1_1::Block(this))->__Field(HX_CSTRING("iterator"),true)());  __it->hasNext(); ){
			::h2d::BatchElement e = __it->next();
			{
				HX_STACK_LINE(121)
				if (((e->batch != null()))){
					HX_STACK_LINE(121)
					e->batch->_delete(e);
				}
				HX_STACK_LINE(121)
				e->t = null();
				HX_STACK_LINE(121)
				e->color = null();
				HX_STACK_LINE(121)
				e->batch = null();
			}
;
		}
		HX_STACK_LINE(122)
		this->tmpBuf = null();
		HX_STACK_LINE(123)
		this->tile = null();
		HX_STACK_LINE(124)
		this->first = null();
		HX_STACK_LINE(125)
		this->last = null();
	}
return null();
}


bool SpriteBatch_obj::set_hasVertexColor( bool b){
	HX_STACK_FRAME("h2d.SpriteBatch","set_hasVertexColor",0xcb4a586f,"h2d.SpriteBatch.set_hasVertexColor","h2d/SpriteBatch.hx",129,0x7caf17de)
	HX_STACK_THIS(this)
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(130)
	bool _g = this->shader->hasVertexColor = b;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(130)
	this->hasVertexColor = _g;
	HX_STACK_LINE(131)
	return b;
}


HX_DEFINE_DYNAMIC_FUNC1(SpriteBatch_obj,set_hasVertexColor,return )

bool SpriteBatch_obj::set_hasVertexAlpha( bool b){
	HX_STACK_FRAME("h2d.SpriteBatch","set_hasVertexAlpha",0xa2848e6a,"h2d.SpriteBatch.set_hasVertexAlpha","h2d/SpriteBatch.hx",134,0x7caf17de)
	HX_STACK_THIS(this)
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(135)
	bool _g = this->shader->hasVertexAlpha = b;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(135)
	this->hasVertexAlpha = _g;
	HX_STACK_LINE(136)
	return b;
}


HX_DEFINE_DYNAMIC_FUNC1(SpriteBatch_obj,set_hasVertexAlpha,return )

::h2d::BatchElement SpriteBatch_obj::add( ::h2d::BatchElement e,Dynamic prio){
	e->batch = hx::ObjectPtr<OBJ_>(this);
	e->priority = prio;
	if (((prio == null()))){
		if (((this->first == null()))){
			::h2d::BatchElement _g = this->last = e;
			this->first = _g;
		}
		else{
			this->last->next = e;
			e->prev = this->last;
			this->last = e;
		}
	}
	else{
		if (((this->first == null()))){
			::h2d::BatchElement _g1 = this->last = e;
			this->first = _g1;
		}
		else{
			::h2d::BatchElement cur = this->first;
			while((true)){
				if ((!(((bool((e->priority < cur->priority)) && bool((cur->next != null()))))))){
					break;
				}
				cur = cur->next;
			}
			if (((cur->next == null()))){
				if (((cur->priority >= e->priority))){
					cur->next = e;
					e->prev = cur;
					if (((this->last == cur))){
						this->last = e;
					}
					if (((this->first == cur))){
						this->first = cur;
					}
				}
				else{
					e->next = cur;
					e->prev = cur->prev;
					if (((cur->prev != null()))){
						cur->prev->next = e;
					}
					cur->prev = e;
					if (((this->first == cur))){
						this->first = e;
					}
					if (((this->last == cur))){
						this->last = cur;
					}
				}
			}
			else{
				::h2d::BatchElement p = cur->prev;
				::h2d::BatchElement n = cur;
				e->next = cur;
				cur->prev = e;
				e->prev = p;
				if (((p != null()))){
					p->next = e;
				}
				if (((p == null()))){
					this->first = e;
				}
			}
		}
	}
	(this->length)++;
	return e;
}


HX_DEFINE_DYNAMIC_FUNC2(SpriteBatch_obj,add,return )

::h2d::BatchElement SpriteBatch_obj::alloc( ::h2d::Tile t,Dynamic prio){
	::h2d::BatchElement _g = ::h2d::BatchElement_obj::__new(t);
	return this->add(_g,prio);
}


HX_DEFINE_DYNAMIC_FUNC2(SpriteBatch_obj,alloc,return )

Void SpriteBatch_obj::_delete( ::h2d::BatchElement e){
{
		if (((e->prev == null()))){
			if (((this->first == e))){
				this->first = e->next;
			}
		}
		else{
			e->prev->next = e->next;
		}
		if (((e->next == null()))){
			if (((this->last == e))){
				this->last = e->prev;
			}
		}
		else{
			e->next->prev = e->prev;
		}
		e->prev = null();
		e->next = null();
		(this->length)--;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(SpriteBatch_obj,_delete,(void))

::h2d::col::Bounds SpriteBatch_obj::getMyBounds( ){
	HX_STACK_FRAME("h2d.SpriteBatch","getMyBounds",0x000ecf0a,"h2d.SpriteBatch.getMyBounds","h2d/SpriteBatch.hx",236,0x7caf17de)
	HX_STACK_THIS(this)
	HX_STACK_LINE(236)
	return ::h2d::col::Bounds_obj::__new();
}


int SpriteBatch_obj::pushElemSRT( Array< Float > tmp,::h2d::BatchElement e,int pos){
	::h2d::Tile t = e->t;
	::hxd::Assert_obj::notNull(t,HX_CSTRING("all elem must have tiles"));
	if (((t == null()))){
		return (int)0;
	}
	int px = t->dx;
	int py = t->dy;
	int hx = e->t->width;
	int hy = e->t->height;
	{
		::h2d::Matrix _this = this->tmpMatrix;
		_this->a = 1.;
		_this->b = 0.;
		_this->c = 0.;
		_this->d = 1.;
		_this->tx = 0.;
		_this->ty = 0.;
	}
	this->tmpMatrix->skew(e->skewX,e->skewY);
	{
		::h2d::Matrix _this = this->tmpMatrix;
		Float x = e->scaleX;
		Float y = e->scaleY;
		hx::MultEq(_this->a,x);
		hx::MultEq(_this->b,y);
		hx::MultEq(_this->c,x);
		hx::MultEq(_this->d,y);
		hx::MultEq(_this->tx,x);
		hx::MultEq(_this->ty,y);
	}
	{
		Float angle = e->rotation;
		Float c = ::Math_obj::cos(angle);
		Float s = ::Math_obj::sin(angle);
		this->tmpMatrix->concat32(c,-(s),s,c,0.0,0.0);
	}
	{
		::h2d::Matrix _this = this->tmpMatrix;
		hx::AddEq(_this->tx,e->x);
		hx::AddEq(_this->ty,e->y);
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		{
			::h2d::Matrix _this = this->tmpMatrix;
			tmp[key] = (((px * _this->a) + (py * _this->c)) + _this->tx);
		}
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		{
			::h2d::Matrix _this = this->tmpMatrix;
			tmp[key] = (((px * _this->b) + (py * _this->d)) + _this->ty);
		}
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = t->u;
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = t->v;
	}
	if ((this->hasVertexAlpha)){
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = e->alpha;
	}
	if ((this->hasVertexColor)){
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->x;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->y;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->z;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->w;
		}
	}
	int px1 = (t->dx + hx);
	int py1 = t->dy;
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		{
			::h2d::Matrix _this = this->tmpMatrix;
			tmp[key] = (((px1 * _this->a) + (py1 * _this->c)) + _this->tx);
		}
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		{
			::h2d::Matrix _this = this->tmpMatrix;
			tmp[key] = (((px1 * _this->b) + (py1 * _this->d)) + _this->ty);
		}
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = t->u2;
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = t->v;
	}
	if ((this->hasVertexAlpha)){
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = e->alpha;
	}
	if ((this->hasVertexColor)){
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->x;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->y;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->z;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->w;
		}
	}
	int px2 = t->dx;
	int py2 = (t->dy + hy);
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		{
			::h2d::Matrix _this = this->tmpMatrix;
			tmp[key] = (((px2 * _this->a) + (py2 * _this->c)) + _this->tx);
		}
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		{
			::h2d::Matrix _this = this->tmpMatrix;
			tmp[key] = (((px2 * _this->b) + (py2 * _this->d)) + _this->ty);
		}
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = t->u;
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = t->v2;
	}
	if ((this->hasVertexAlpha)){
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = e->alpha;
	}
	if ((this->hasVertexColor)){
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->x;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->y;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->z;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->w;
		}
	}
	int px3 = (t->dx + hx);
	int py3 = (t->dy + hy);
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		{
			::h2d::Matrix _this = this->tmpMatrix;
			tmp[key] = (((px3 * _this->a) + (py3 * _this->c)) + _this->tx);
		}
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		{
			::h2d::Matrix _this = this->tmpMatrix;
			tmp[key] = (((px3 * _this->b) + (py3 * _this->d)) + _this->ty);
		}
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = t->u2;
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = t->v2;
	}
	if ((this->hasVertexAlpha)){
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = e->alpha;
	}
	if ((this->hasVertexColor)){
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->x;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->y;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->z;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->w;
		}
	}
	return pos;
}


HX_DEFINE_DYNAMIC_FUNC3(SpriteBatch_obj,pushElemSRT,return )

int SpriteBatch_obj::pushElem( Array< Float > tmp,::h2d::BatchElement e,int pos){
	::h2d::Tile t = e->t;
	::hxd::Assert_obj::notNull(t,HX_CSTRING("all elem must have tiles"));
	if (((t == null()))){
		return (int)0;
	}
	Float sx = (e->x + t->dx);
	Float sy = (e->y + t->dy);
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = sx;
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = sy;
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = t->u;
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = t->v;
	}
	if ((this->hasVertexAlpha)){
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = e->alpha;
	}
	if ((this->hasVertexColor)){
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->x;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->y;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->z;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->w;
		}
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = ((sx + t->width) + 0.1);
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = sy;
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = t->u2;
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = t->v;
	}
	if ((this->hasVertexAlpha)){
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = e->alpha;
	}
	if ((this->hasVertexColor)){
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->x;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->y;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->z;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->w;
		}
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = sx;
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = ((sy + t->height) + 0.1);
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = t->u;
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = t->v2;
	}
	if ((this->hasVertexAlpha)){
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = e->alpha;
	}
	if ((this->hasVertexColor)){
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->x;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->y;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->z;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->w;
		}
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = ((sx + t->width) + 0.1);
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = ((sy + t->height) + 0.1);
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = t->u2;
	}
	{
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = t->v2;
	}
	if ((this->hasVertexAlpha)){
		int key = (pos)++;
		if (((tmp->length <= key))){
			HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
		}
		tmp[key] = e->alpha;
	}
	if ((this->hasVertexColor)){
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->x;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->y;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->z;
		}
		{
			int key = (pos)++;
			if (((tmp->length <= key))){
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
			}
			tmp[key] = e->color->w;
		}
	}
	return pos;
}


HX_DEFINE_DYNAMIC_FUNC3(SpriteBatch_obj,pushElem,return )

Void SpriteBatch_obj::draw( ::h3d::scene::RenderContext ctx){
{
		if (((this->first == null()))){
			return null();
		}
		if (((this->tmpBuf == null()))){
			Array< Float > _g;
			{
				int length = (int)0;
				_g = Array_obj< Float >::__new();
			}
			this->tmpBuf = _g;
		}
		int stride = (int)4;
		int vertPerQuad = (int)4;
		if ((this->hasVertexColor)){
			hx::AddEq(stride,(int)4);
		}
		if ((this->hasVertexAlpha)){
			hx::AddEq(stride,(int)1);
		}
		int len = ((((this->length + (int)1)) * stride) * vertPerQuad);
		if (((this->tmpBuf->length < len))){
			Array< Float > this1 = this->tmpBuf;
			if (((this1->length < len))){
				::haxe::Log_obj::trace((HX_CSTRING("regrowing to ") + len),hx::SourceInfo(HX_CSTRING("FloatBuffer.hx"),79,HX_CSTRING("hxd._FloatBuffer.FloatBuffer_Impl_"),HX_CSTRING("resize")));
				this1[len] = 0.0;
			}
		}
		int pos = (int)0;
		::h2d::BatchElement e = this->first;
		Array< Float > tmp = this->tmpBuf;
		Dynamic a;
		Dynamic b;
		Dynamic c;
		int d = (int)0;
		if ((this->hasRotationScale)){
			while((true)){
				if ((!(((e != null()))))){
					break;
				}
				if ((e->visible)){
					int _g1 = this->pushElemSRT(tmp,e,pos);
					pos = _g1;
				}
				e = e->next;
			}
		}
		else{
			while((true)){
				if ((!(((e != null()))))){
					break;
				}
				if ((e->visible)){
					int _g2 = this->pushElem(tmp,e,pos);
					pos = _g2;
				}
				e = e->next;
			}
		}
		int nverts = ::Std_obj::_int((Float(pos) / Float(stride)));
		::h3d::impl::Buffer buffer = ctx->engine->mem->alloc(nverts,stride,(int)4,true,hx::SourceInfo(HX_CSTRING("SpriteBatch.hx"),418,HX_CSTRING("h2d.SpriteBatch"),HX_CSTRING("draw")));
		buffer->uploadVector(this->tmpBuf,(int)0,nverts);
		this->setupShader(ctx->engine,this->tile,(int)8);
		{
			::h3d::Engine _this = ctx->engine;
			int start = (int)0;
			int max = (int)-1;
			bool v = _this->renderBuffer(buffer,_this->mem->quadIndexes,(int)2,start,max);
			v;
		}
		buffer->dispose();
	}
return null();
}


Dynamic SpriteBatch_obj::getElements( ){
	Array< ::Dynamic > e = Array_obj< ::Dynamic >::__new().Add(this->first);
	struct _Function_1_1{
		inline static Dynamic Block( Array< ::Dynamic > &e){
			{
				hx::Anon __result = hx::Anon_obj::Create();

				HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_2_1,Array< ::Dynamic >,e)
				Dynamic run(){
					{
						struct _Function_3_1{
							inline static Dynamic Block( Array< ::Dynamic > &e){
								{
									hx::Anon __result = hx::Anon_obj::Create();

									HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_4_1,Array< ::Dynamic >,e)
									::h2d::BatchElement run(){
										{
											::h2d::BatchElement cur = e->__get((int)0).StaticCast< ::h2d::BatchElement >();
											e[(int)0] = e->__get((int)0).StaticCast< ::h2d::BatchElement >()->next;
											return cur;
										}
										return null();
									}
									HX_END_LOCAL_FUNC0(return)

									__result->Add(HX_CSTRING("next") ,  Dynamic(new _Function_4_1(e)),true);

									HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_4_2,Array< ::Dynamic >,e)
									bool run(){
										{
											return (e->__get((int)0).StaticCast< ::h2d::BatchElement >() != null());
										}
										return null();
									}
									HX_END_LOCAL_FUNC0(return)

									__result->Add(HX_CSTRING("hasNext") ,  Dynamic(new _Function_4_2(e)),true);
									return __result;
								}
								return null();
							}
						};
						return _Function_3_1::Block(e);
					}
					return null();
				}
				HX_END_LOCAL_FUNC0(return)

				__result->Add(HX_CSTRING("iterator") ,  Dynamic(new _Function_2_1(e)),true);
				return __result;
			}
			return null();
		}
	};
	return _Function_1_1::Block(e);
}


HX_DEFINE_DYNAMIC_FUNC0(SpriteBatch_obj,getElements,return )

bool SpriteBatch_obj::isEmpty( ){
	HX_STACK_FRAME("h2d.SpriteBatch","isEmpty",0xe7e75216,"h2d.SpriteBatch.isEmpty","h2d/SpriteBatch.hx",442,0x7caf17de)
	HX_STACK_THIS(this)
	HX_STACK_LINE(442)
	return (this->first == null());
}


HX_DEFINE_DYNAMIC_FUNC0(SpriteBatch_obj,isEmpty,return )


SpriteBatch_obj::SpriteBatch_obj()
{
}

void SpriteBatch_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(SpriteBatch);
	HX_MARK_MEMBER_NAME(tile,"tile");
	HX_MARK_MEMBER_NAME(hasRotationScale,"hasRotationScale");
	HX_MARK_MEMBER_NAME(hasVertexColor,"hasVertexColor");
	HX_MARK_MEMBER_NAME(hasVertexAlpha,"hasVertexAlpha");
	HX_MARK_MEMBER_NAME(first,"first");
	HX_MARK_MEMBER_NAME(last,"last");
	HX_MARK_MEMBER_NAME(length,"length");
	HX_MARK_MEMBER_NAME(tmpBuf,"tmpBuf");
	HX_MARK_MEMBER_NAME(tmpMatrix,"tmpMatrix");
	::h2d::Drawable_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void SpriteBatch_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(tile,"tile");
	HX_VISIT_MEMBER_NAME(hasRotationScale,"hasRotationScale");
	HX_VISIT_MEMBER_NAME(hasVertexColor,"hasVertexColor");
	HX_VISIT_MEMBER_NAME(hasVertexAlpha,"hasVertexAlpha");
	HX_VISIT_MEMBER_NAME(first,"first");
	HX_VISIT_MEMBER_NAME(last,"last");
	HX_VISIT_MEMBER_NAME(length,"length");
	HX_VISIT_MEMBER_NAME(tmpBuf,"tmpBuf");
	HX_VISIT_MEMBER_NAME(tmpMatrix,"tmpMatrix");
	::h2d::Drawable_obj::__Visit(HX_VISIT_ARG);
}

Dynamic SpriteBatch_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"add") ) { return add_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"tile") ) { return tile; }
		if (HX_FIELD_EQ(inName,"last") ) { return last; }
		if (HX_FIELD_EQ(inName,"draw") ) { return draw_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"first") ) { return first; }
		if (HX_FIELD_EQ(inName,"alloc") ) { return alloc_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"length") ) { return length; }
		if (HX_FIELD_EQ(inName,"tmpBuf") ) { return tmpBuf; }
		if (HX_FIELD_EQ(inName,"delete") ) { return _delete_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		if (HX_FIELD_EQ(inName,"isEmpty") ) { return isEmpty_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"pushElem") ) { return pushElem_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"tmpMatrix") ) { return tmpMatrix; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"getMyBounds") ) { return getMyBounds_dyn(); }
		if (HX_FIELD_EQ(inName,"pushElemSRT") ) { return pushElemSRT_dyn(); }
		if (HX_FIELD_EQ(inName,"getElements") ) { return getElements_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"hasVertexColor") ) { return hasVertexColor; }
		if (HX_FIELD_EQ(inName,"hasVertexAlpha") ) { return hasVertexAlpha; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"hasRotationScale") ) { return hasRotationScale; }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"set_hasVertexColor") ) { return set_hasVertexColor_dyn(); }
		if (HX_FIELD_EQ(inName,"set_hasVertexAlpha") ) { return set_hasVertexAlpha_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic SpriteBatch_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"tile") ) { tile=inValue.Cast< ::h2d::Tile >(); return inValue; }
		if (HX_FIELD_EQ(inName,"last") ) { last=inValue.Cast< ::h2d::BatchElement >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"first") ) { first=inValue.Cast< ::h2d::BatchElement >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"length") ) { length=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"tmpBuf") ) { tmpBuf=inValue.Cast< Array< Float > >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"tmpMatrix") ) { tmpMatrix=inValue.Cast< ::h2d::Matrix >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"hasVertexColor") ) { if (inCallProp) return set_hasVertexColor(inValue);hasVertexColor=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"hasVertexAlpha") ) { if (inCallProp) return set_hasVertexAlpha(inValue);hasVertexAlpha=inValue.Cast< bool >(); return inValue; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"hasRotationScale") ) { hasRotationScale=inValue.Cast< bool >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void SpriteBatch_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("tile"));
	outFields->push(HX_CSTRING("hasRotationScale"));
	outFields->push(HX_CSTRING("hasVertexColor"));
	outFields->push(HX_CSTRING("hasVertexAlpha"));
	outFields->push(HX_CSTRING("first"));
	outFields->push(HX_CSTRING("last"));
	outFields->push(HX_CSTRING("length"));
	outFields->push(HX_CSTRING("tmpBuf"));
	outFields->push(HX_CSTRING("tmpMatrix"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h2d::Tile*/ ,(int)offsetof(SpriteBatch_obj,tile),HX_CSTRING("tile")},
	{hx::fsBool,(int)offsetof(SpriteBatch_obj,hasRotationScale),HX_CSTRING("hasRotationScale")},
	{hx::fsBool,(int)offsetof(SpriteBatch_obj,hasVertexColor),HX_CSTRING("hasVertexColor")},
	{hx::fsBool,(int)offsetof(SpriteBatch_obj,hasVertexAlpha),HX_CSTRING("hasVertexAlpha")},
	{hx::fsObject /*::h2d::BatchElement*/ ,(int)offsetof(SpriteBatch_obj,first),HX_CSTRING("first")},
	{hx::fsObject /*::h2d::BatchElement*/ ,(int)offsetof(SpriteBatch_obj,last),HX_CSTRING("last")},
	{hx::fsInt,(int)offsetof(SpriteBatch_obj,length),HX_CSTRING("length")},
	{hx::fsObject /*Array< Float >*/ ,(int)offsetof(SpriteBatch_obj,tmpBuf),HX_CSTRING("tmpBuf")},
	{hx::fsObject /*::h2d::Matrix*/ ,(int)offsetof(SpriteBatch_obj,tmpMatrix),HX_CSTRING("tmpMatrix")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("tile"),
	HX_CSTRING("hasRotationScale"),
	HX_CSTRING("hasVertexColor"),
	HX_CSTRING("hasVertexAlpha"),
	HX_CSTRING("first"),
	HX_CSTRING("last"),
	HX_CSTRING("length"),
	HX_CSTRING("tmpBuf"),
	HX_CSTRING("dispose"),
	HX_CSTRING("set_hasVertexColor"),
	HX_CSTRING("set_hasVertexAlpha"),
	HX_CSTRING("add"),
	HX_CSTRING("alloc"),
	HX_CSTRING("delete"),
	HX_CSTRING("getMyBounds"),
	HX_CSTRING("pushElemSRT"),
	HX_CSTRING("pushElem"),
	HX_CSTRING("tmpMatrix"),
	HX_CSTRING("draw"),
	HX_CSTRING("getElements"),
	HX_CSTRING("isEmpty"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(SpriteBatch_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(SpriteBatch_obj::__mClass,"__mClass");
};

#endif

Class SpriteBatch_obj::__mClass;

void SpriteBatch_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.SpriteBatch"), hx::TCanCast< SpriteBatch_obj> ,sStaticFields,sMemberFields,
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

void SpriteBatch_obj::__boot()
{
}

} // end namespace h2d
