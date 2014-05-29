#include <hxcpp.h>

#ifndef INCLUDED_h2d__Graphics_GraphicsContent
#include <h2d/_Graphics/GraphicsContent.h>
#endif
#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
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
#ifndef INCLUDED_h3d_prim_Primitive
#include <h3d/prim/Primitive.h>
#endif
namespace h2d{
namespace _Graphics{

Void GraphicsContent_obj::__construct()
{
HX_STACK_FRAME("h2d._Graphics.GraphicsContent","new",0x10c8f848,"h2d._Graphics.GraphicsContent.new","h2d/Graphics.hx",32,0x5cd0883e)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(32)
	this->buffers = Dynamic( Array_obj<Dynamic>::__new());
}
;
	return null();
}

//GraphicsContent_obj::~GraphicsContent_obj() { }

Dynamic GraphicsContent_obj::__CreateEmpty() { return  new GraphicsContent_obj; }
hx::ObjectPtr< GraphicsContent_obj > GraphicsContent_obj::__new()
{  hx::ObjectPtr< GraphicsContent_obj > result = new GraphicsContent_obj();
	result->__construct();
	return result;}

Dynamic GraphicsContent_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< GraphicsContent_obj > result = new GraphicsContent_obj();
	result->__construct();
	return result;}

Void GraphicsContent_obj::addIndex( int i){
{
		HX_STACK_FRAME("h2d._Graphics.GraphicsContent","addIndex",0x0cbaf049,"h2d._Graphics.GraphicsContent.addIndex","h2d/Graphics.hx",36,0x5cd0883e)
		HX_STACK_THIS(this)
		HX_STACK_ARG(i,"i")
		HX_STACK_LINE(36)
		this->index->push(i);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(GraphicsContent_obj,addIndex,(void))

Void GraphicsContent_obj::add( Float x,Float y,Float u,Float v,Float r,Float g,Float b,Float a){
{
		HX_STACK_FRAME("h2d._Graphics.GraphicsContent","add",0x10bf1a09,"h2d._Graphics.GraphicsContent.add","h2d/Graphics.hx",39,0x5cd0883e)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(u,"u")
		HX_STACK_ARG(v,"v")
		HX_STACK_ARG(r,"r")
		HX_STACK_ARG(g,"g")
		HX_STACK_ARG(b,"b")
		HX_STACK_ARG(a,"a")
		HX_STACK_LINE(40)
		this->tmp->push(x);
		HX_STACK_LINE(41)
		this->tmp->push(y);
		HX_STACK_LINE(42)
		this->tmp->push(u);
		HX_STACK_LINE(43)
		this->tmp->push(v);
		HX_STACK_LINE(44)
		this->tmp->push(r);
		HX_STACK_LINE(45)
		this->tmp->push(g);
		HX_STACK_LINE(46)
		this->tmp->push(b);
		HX_STACK_LINE(47)
		this->tmp->push(a);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC8(GraphicsContent_obj,add,(void))

bool GraphicsContent_obj::next( ){
	HX_STACK_FRAME("h2d._Graphics.GraphicsContent","next",0x9f10480b,"h2d._Graphics.GraphicsContent.next","h2d/Graphics.hx",50,0x5cd0883e)
	HX_STACK_THIS(this)
	HX_STACK_LINE(51)
	int nvect = (int(this->tmp->length) >> int((int)3));		HX_STACK_VAR(nvect,"nvect");
	HX_STACK_LINE(52)
	if (((nvect < (int)32768))){
		HX_STACK_LINE(53)
		return false;
	}
	struct _Function_1_1{
		inline static Dynamic Block( hx::ObjectPtr< ::h2d::_Graphics::GraphicsContent_obj > __this){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h2d/Graphics.hx",54,0x5cd0883e)
			{
				hx::Anon __result = hx::Anon_obj::Create();
				__result->Add(HX_CSTRING("buf") , __this->tmp,false);
				__result->Add(HX_CSTRING("idx") , __this->index,false);
				__result->Add(HX_CSTRING("vbuf") , null(),false);
				__result->Add(HX_CSTRING("ibuf") , null(),false);
				return __result;
			}
			return null();
		}
	};
	HX_STACK_LINE(54)
	this->buffers->__Field(HX_CSTRING("push"),true)(_Function_1_1::Block(this));
	HX_STACK_LINE(55)
	Array< Float > _g;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(55)
	{
		HX_STACK_LINE(55)
		int length = (int)0;		HX_STACK_VAR(length,"length");
		HX_STACK_LINE(55)
		_g = Array_obj< Float >::__new();
	}
	HX_STACK_LINE(55)
	this->tmp = _g;
	HX_STACK_LINE(56)
	Array< int > _g1;		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(56)
	{
		HX_STACK_LINE(56)
		int length = (int)0;		HX_STACK_VAR(length,"length");
		HX_STACK_LINE(56)
		_g1 = Array_obj< int >::__new();
	}
	HX_STACK_LINE(56)
	this->index = _g1;
	HX_STACK_LINE(57)
	this->super::dispose();
	HX_STACK_LINE(58)
	return true;
}


HX_DEFINE_DYNAMIC_FUNC0(GraphicsContent_obj,next,return )

Void GraphicsContent_obj::alloc( ::h3d::Engine engine){
{
		HX_STACK_FRAME("h2d._Graphics.GraphicsContent","alloc",0x1790965d,"h2d._Graphics.GraphicsContent.alloc","h2d/Graphics.hx",61,0x5cd0883e)
		HX_STACK_THIS(this)
		HX_STACK_ARG(engine,"engine")
		HX_STACK_LINE(62)
		if (((this->index->length <= (int)0))){
			HX_STACK_LINE(62)
			return null();
		}
		HX_STACK_LINE(63)
		::h3d::impl::Buffer _g = engine->mem->allocVector(this->tmp,(int)8,(int)0,null(),hx::SourceInfo(HX_CSTRING("Graphics.hx"),63,HX_CSTRING("h2d._Graphics.GraphicsContent"),HX_CSTRING("alloc")));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(63)
		this->buffer = _g;
		HX_STACK_LINE(64)
		::h3d::impl::Indexes _g1 = engine->mem->allocIndex(this->index,null(),null());		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(64)
		this->indexes = _g1;
		HX_STACK_LINE(65)
		{
			HX_STACK_LINE(65)
			int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(65)
			Dynamic _g11 = this->buffers;		HX_STACK_VAR(_g11,"_g11");
			HX_STACK_LINE(65)
			while((true)){
				HX_STACK_LINE(65)
				if ((!(((_g2 < _g11->__Field(HX_CSTRING("length"),true)))))){
					HX_STACK_LINE(65)
					break;
				}
				HX_STACK_LINE(65)
				Dynamic b = _g11->__GetItem(_g2);		HX_STACK_VAR(b,"b");
				HX_STACK_LINE(65)
				++(_g2);
				HX_STACK_LINE(66)
				if (((  ((!(((b->__Field(HX_CSTRING("vbuf"),true) == null()))))) ? bool(b->__Field(HX_CSTRING("vbuf"),true)->__Field(HX_CSTRING("isDisposed"),true)()) : bool(true) ))){
					HX_STACK_LINE(66)
					::h3d::impl::Buffer _g21 = engine->mem->allocVector(b->__Field(HX_CSTRING("buf"),true),(int)8,(int)0,null(),hx::SourceInfo(HX_CSTRING("Graphics.hx"),66,HX_CSTRING("h2d._Graphics.GraphicsContent"),HX_CSTRING("alloc")));		HX_STACK_VAR(_g21,"_g21");
					HX_STACK_LINE(66)
					b->__FieldRef(HX_CSTRING("vbuf")) = _g21;
				}
				HX_STACK_LINE(67)
				if (((  ((!(((b->__Field(HX_CSTRING("ibuf"),true) == null()))))) ? bool(b->__Field(HX_CSTRING("ibuf"),true)->__Field(HX_CSTRING("isDisposed"),true)()) : bool(true) ))){
					HX_STACK_LINE(67)
					::h3d::impl::Indexes _g3 = engine->mem->allocIndex(b->__Field(HX_CSTRING("idx"),true),null(),null());		HX_STACK_VAR(_g3,"_g3");
					HX_STACK_LINE(67)
					b->__FieldRef(HX_CSTRING("ibuf")) = _g3;
				}
			}
		}
	}
return null();
}


Void GraphicsContent_obj::render( ::h3d::Engine engine){
{
		HX_STACK_FRAME("h2d._Graphics.GraphicsContent","render",0x4c80246e,"h2d._Graphics.GraphicsContent.render","h2d/Graphics.hx",71,0x5cd0883e)
		HX_STACK_THIS(this)
		HX_STACK_ARG(engine,"engine")
		HX_STACK_LINE(72)
		if (((this->index->length <= (int)0))){
			HX_STACK_LINE(72)
			return null();
		}
		HX_STACK_LINE(73)
		if (((  ((!(((this->buffer == null()))))) ? bool(this->buffer->isDisposed()) : bool(true) ))){
			HX_STACK_LINE(73)
			this->alloc(engine);
		}
		HX_STACK_LINE(74)
		{
			HX_STACK_LINE(74)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(74)
			Dynamic _g1 = this->buffers;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(74)
			while((true)){
				HX_STACK_LINE(74)
				if ((!(((_g < _g1->__Field(HX_CSTRING("length"),true)))))){
					HX_STACK_LINE(74)
					break;
				}
				HX_STACK_LINE(74)
				Dynamic b = _g1->__GetItem(_g);		HX_STACK_VAR(b,"b");
				HX_STACK_LINE(74)
				++(_g);
				HX_STACK_LINE(75)
				engine->renderIndexed(b->__Field(HX_CSTRING("vbuf"),true),b->__Field(HX_CSTRING("ibuf"),true),null(),null());
			}
		}
		HX_STACK_LINE(76)
		this->super::render(engine);
	}
return null();
}


Void GraphicsContent_obj::dispose( ){
{
		HX_STACK_FRAME("h2d._Graphics.GraphicsContent","dispose",0xdfd7bc87,"h2d._Graphics.GraphicsContent.dispose","h2d/Graphics.hx",79,0x5cd0883e)
		HX_STACK_THIS(this)
		HX_STACK_LINE(80)
		{
			HX_STACK_LINE(80)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(80)
			Dynamic _g1 = this->buffers;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(80)
			while((true)){
				HX_STACK_LINE(80)
				if ((!(((_g < _g1->__Field(HX_CSTRING("length"),true)))))){
					HX_STACK_LINE(80)
					break;
				}
				HX_STACK_LINE(80)
				Dynamic b = _g1->__GetItem(_g);		HX_STACK_VAR(b,"b");
				HX_STACK_LINE(80)
				++(_g);
				HX_STACK_LINE(81)
				if (((b->__Field(HX_CSTRING("vbuf"),true) != null()))){
					HX_STACK_LINE(81)
					b->__Field(HX_CSTRING("vbuf"),true)->__Field(HX_CSTRING("dispose"),true)();
				}
				HX_STACK_LINE(82)
				if (((b->__Field(HX_CSTRING("ibuf"),true) != null()))){
					HX_STACK_LINE(82)
					b->__Field(HX_CSTRING("ibuf"),true)->__Field(HX_CSTRING("dispose"),true)();
				}
				HX_STACK_LINE(83)
				b->__FieldRef(HX_CSTRING("vbuf")) = null();
				HX_STACK_LINE(84)
				b->__FieldRef(HX_CSTRING("ibuf")) = null();
			}
		}
		HX_STACK_LINE(86)
		this->super::dispose();
	}
return null();
}


Void GraphicsContent_obj::reset( ){
{
		HX_STACK_FRAME("h2d._Graphics.GraphicsContent","reset",0xdcc53bb7,"h2d._Graphics.GraphicsContent.reset","h2d/Graphics.hx",90,0x5cd0883e)
		HX_STACK_THIS(this)
		HX_STACK_LINE(91)
		this->dispose();
		HX_STACK_LINE(92)
		Array< Float > _g;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(92)
		{
			HX_STACK_LINE(92)
			int length = (int)0;		HX_STACK_VAR(length,"length");
			HX_STACK_LINE(92)
			_g = Array_obj< Float >::__new();
		}
		HX_STACK_LINE(92)
		this->tmp = _g;
		HX_STACK_LINE(93)
		Array< int > _g1;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(93)
		{
			HX_STACK_LINE(93)
			int length = (int)0;		HX_STACK_VAR(length,"length");
			HX_STACK_LINE(93)
			_g1 = Array_obj< int >::__new();
		}
		HX_STACK_LINE(93)
		this->index = _g1;
		HX_STACK_LINE(94)
		this->buffers = Dynamic( Array_obj<Dynamic>::__new());
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(GraphicsContent_obj,reset,(void))


GraphicsContent_obj::GraphicsContent_obj()
{
}

void GraphicsContent_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(GraphicsContent);
	HX_MARK_MEMBER_NAME(tmp,"tmp");
	HX_MARK_MEMBER_NAME(index,"index");
	HX_MARK_MEMBER_NAME(buffers,"buffers");
	::h3d::prim::Primitive_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void GraphicsContent_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(tmp,"tmp");
	HX_VISIT_MEMBER_NAME(index,"index");
	HX_VISIT_MEMBER_NAME(buffers,"buffers");
	::h3d::prim::Primitive_obj::__Visit(HX_VISIT_ARG);
}

Dynamic GraphicsContent_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"tmp") ) { return tmp; }
		if (HX_FIELD_EQ(inName,"add") ) { return add_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"next") ) { return next_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"index") ) { return index; }
		if (HX_FIELD_EQ(inName,"alloc") ) { return alloc_dyn(); }
		if (HX_FIELD_EQ(inName,"reset") ) { return reset_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"render") ) { return render_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"buffers") ) { return buffers; }
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"addIndex") ) { return addIndex_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic GraphicsContent_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"tmp") ) { tmp=inValue.Cast< Array< Float > >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"index") ) { index=inValue.Cast< Array< int > >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"buffers") ) { buffers=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void GraphicsContent_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("tmp"));
	outFields->push(HX_CSTRING("index"));
	outFields->push(HX_CSTRING("buffers"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Array< Float >*/ ,(int)offsetof(GraphicsContent_obj,tmp),HX_CSTRING("tmp")},
	{hx::fsObject /*Array< int >*/ ,(int)offsetof(GraphicsContent_obj,index),HX_CSTRING("index")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(GraphicsContent_obj,buffers),HX_CSTRING("buffers")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("tmp"),
	HX_CSTRING("index"),
	HX_CSTRING("buffers"),
	HX_CSTRING("addIndex"),
	HX_CSTRING("add"),
	HX_CSTRING("next"),
	HX_CSTRING("alloc"),
	HX_CSTRING("render"),
	HX_CSTRING("dispose"),
	HX_CSTRING("reset"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(GraphicsContent_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(GraphicsContent_obj::__mClass,"__mClass");
};

#endif

Class GraphicsContent_obj::__mClass;

void GraphicsContent_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d._Graphics.GraphicsContent"), hx::TCanCast< GraphicsContent_obj> ,sStaticFields,sMemberFields,
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

void GraphicsContent_obj::__boot()
{
}

} // end namespace h2d
} // end namespace _Graphics
