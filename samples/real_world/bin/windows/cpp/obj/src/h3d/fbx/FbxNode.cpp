#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_Type
#include <Type.h>
#endif
#ifndef INCLUDED_h3d_fbx_FbxNode
#include <h3d/fbx/FbxNode.h>
#endif
#ifndef INCLUDED_h3d_fbx_FbxProp
#include <h3d/fbx/FbxProp.h>
#endif
namespace h3d{
namespace fbx{

Void FbxNode_obj::__construct(::String n,Array< ::Dynamic > p,Array< ::Dynamic > c)
{
HX_STACK_FRAME("h3d.fbx.FbxNode","new",0x7fe854c9,"h3d.fbx.FbxNode.new","h3d/fbx/Data.hx",24,0xd5b13f0b)
HX_STACK_THIS(this)
HX_STACK_ARG(n,"n")
HX_STACK_ARG(p,"p")
HX_STACK_ARG(c,"c")
{
	HX_STACK_LINE(25)
	this->name = n;
	HX_STACK_LINE(26)
	this->props = p;
	HX_STACK_LINE(27)
	this->childs = c;
}
;
	return null();
}

//FbxNode_obj::~FbxNode_obj() { }

Dynamic FbxNode_obj::__CreateEmpty() { return  new FbxNode_obj; }
hx::ObjectPtr< FbxNode_obj > FbxNode_obj::__new(::String n,Array< ::Dynamic > p,Array< ::Dynamic > c)
{  hx::ObjectPtr< FbxNode_obj > result = new FbxNode_obj();
	result->__construct(n,p,c);
	return result;}

Dynamic FbxNode_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< FbxNode_obj > result = new FbxNode_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

::String FbxNode_obj::toString( ){
	HX_STACK_FRAME("h3d.fbx.FbxNode","toString",0xd774afa3,"h3d.fbx.FbxNode.toString","h3d/fbx/Data.hx",30,0xd5b13f0b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(31)
	::String _g = ::Std_obj::string(this->props);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(31)
	::String _g1 = (((HX_CSTRING("name:") + this->name) + HX_CSTRING(" \n props:")) + _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(31)
	::String _g2 = (_g1 + HX_CSTRING(" \n childs:"));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(31)
	::String _g3 = ::Std_obj::string(this->childs);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(31)
	return (_g2 + _g3);
}


HX_DEFINE_DYNAMIC_FUNC0(FbxNode_obj,toString,return )

::h3d::fbx::FbxNode FbxNode_obj::get( ::String path,hx::Null< bool >  __o_opt){
bool opt = __o_opt.Default(false);
	HX_STACK_FRAME("h3d.fbx.FbxNode","get",0x7fe304ff,"h3d.fbx.FbxNode.get","h3d/fbx/Data.hx",34,0xd5b13f0b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(path,"path")
	HX_STACK_ARG(opt,"opt")
{
		HX_STACK_LINE(35)
		Array< ::String > parts = path.split(HX_CSTRING("."));		HX_STACK_VAR(parts,"parts");
		HX_STACK_LINE(36)
		::h3d::fbx::FbxNode cur = hx::ObjectPtr<OBJ_>(this);		HX_STACK_VAR(cur,"cur");
		HX_STACK_LINE(37)
		{
			HX_STACK_LINE(37)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(37)
			while((true)){
				HX_STACK_LINE(37)
				if ((!(((_g < parts->length))))){
					HX_STACK_LINE(37)
					break;
				}
				HX_STACK_LINE(37)
				::String p = parts->__get(_g);		HX_STACK_VAR(p,"p");
				HX_STACK_LINE(37)
				++(_g);
				HX_STACK_LINE(38)
				bool found = false;		HX_STACK_VAR(found,"found");
				HX_STACK_LINE(39)
				{
					HX_STACK_LINE(39)
					int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(39)
					Array< ::Dynamic > _g2 = cur->childs;		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(39)
					while((true)){
						HX_STACK_LINE(39)
						if ((!(((_g1 < _g2->length))))){
							HX_STACK_LINE(39)
							break;
						}
						HX_STACK_LINE(39)
						::h3d::fbx::FbxNode c = _g2->__get(_g1).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(39)
						++(_g1);
						HX_STACK_LINE(40)
						if (((c->name == p))){
							HX_STACK_LINE(41)
							cur = c;
							HX_STACK_LINE(42)
							found = true;
							HX_STACK_LINE(43)
							break;
						}
					}
				}
				HX_STACK_LINE(45)
				if ((!(found))){
					HX_STACK_LINE(46)
					if ((opt)){
						HX_STACK_LINE(47)
						return null();
					}
					HX_STACK_LINE(48)
					HX_STACK_DO_THROW((((((this->name + HX_CSTRING(" does not have ")) + path) + HX_CSTRING(" (")) + p) + HX_CSTRING(" not found)")));
				}
			}
		}
		HX_STACK_LINE(51)
		return cur;
	}
}


HX_DEFINE_DYNAMIC_FUNC2(FbxNode_obj,get,return )

Array< ::Dynamic > FbxNode_obj::getAll( ::String path){
	HX_STACK_FRAME("h3d.fbx.FbxNode","getAll",0x9d969562,"h3d.fbx.FbxNode.getAll","h3d/fbx/Data.hx",54,0xd5b13f0b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(55)
	Array< ::String > parts = path.split(HX_CSTRING("."));		HX_STACK_VAR(parts,"parts");
	HX_STACK_LINE(56)
	Array< ::Dynamic > cur = Array_obj< ::Dynamic >::__new().Add(hx::ObjectPtr<OBJ_>(this));		HX_STACK_VAR(cur,"cur");
	HX_STACK_LINE(57)
	{
		HX_STACK_LINE(57)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(57)
		while((true)){
			HX_STACK_LINE(57)
			if ((!(((_g < parts->length))))){
				HX_STACK_LINE(57)
				break;
			}
			HX_STACK_LINE(57)
			::String p = parts->__get(_g);		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(57)
			++(_g);
			HX_STACK_LINE(58)
			Array< ::Dynamic > out = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(out,"out");
			HX_STACK_LINE(59)
			{
				HX_STACK_LINE(59)
				int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(59)
				while((true)){
					HX_STACK_LINE(59)
					if ((!(((_g1 < cur->length))))){
						HX_STACK_LINE(59)
						break;
					}
					HX_STACK_LINE(59)
					::h3d::fbx::FbxNode n = cur->__get(_g1).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(n,"n");
					HX_STACK_LINE(59)
					++(_g1);
					HX_STACK_LINE(60)
					int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(60)
					Array< ::Dynamic > _g3 = n->childs;		HX_STACK_VAR(_g3,"_g3");
					HX_STACK_LINE(60)
					while((true)){
						HX_STACK_LINE(60)
						if ((!(((_g2 < _g3->length))))){
							HX_STACK_LINE(60)
							break;
						}
						HX_STACK_LINE(60)
						::h3d::fbx::FbxNode c = _g3->__get(_g2).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(c,"c");
						HX_STACK_LINE(60)
						++(_g2);
						HX_STACK_LINE(61)
						if (((c->name == p))){
							HX_STACK_LINE(62)
							out->push(c);
						}
					}
				}
			}
			HX_STACK_LINE(63)
			cur = out;
			HX_STACK_LINE(64)
			if (((cur->length == (int)0))){
				HX_STACK_LINE(65)
				return cur;
			}
		}
	}
	HX_STACK_LINE(67)
	return cur;
}


HX_DEFINE_DYNAMIC_FUNC1(FbxNode_obj,getAll,return )

Array< int > FbxNode_obj::getInts( ){
	HX_STACK_FRAME("h3d.fbx.FbxNode","getInts",0x4b776143,"h3d.fbx.FbxNode.getInts","h3d/fbx/Data.hx",70,0xd5b13f0b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(71)
	if (((this->props->length != (int)1))){
		HX_STACK_LINE(72)
		::String _g = ::Std_obj::string(this->props);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(72)
		::String _g1 = ((this->name + HX_CSTRING(" has ")) + _g);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(72)
		HX_STACK_DO_THROW((_g1 + HX_CSTRING(" props")));
	}
	HX_STACK_LINE(73)
	{
		HX_STACK_LINE(73)
		::h3d::fbx::FbxProp _g = this->props->__get((int)0).StaticCast< ::h3d::fbx::FbxProp >();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(73)
		switch( (int)(_g->__Index())){
			case (int)4: {
				HX_STACK_LINE(73)
				Array< int > v = (::h3d::fbx::FbxProp(_g))->__Param(0);		HX_STACK_VAR(v,"v");
				HX_STACK_LINE(75)
				return v;
			}
			;break;
			default: {
				HX_STACK_LINE(77)
				::String _g2 = ::Std_obj::string(this->props);		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(77)
				::String _g3 = ((this->name + HX_CSTRING(" has ")) + _g2);		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(77)
				HX_STACK_DO_THROW((_g3 + HX_CSTRING(" props")));
			}
		}
	}
	HX_STACK_LINE(73)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(FbxNode_obj,getInts,return )

Array< Float > FbxNode_obj::getFloats( ){
	HX_STACK_FRAME("h3d.fbx.FbxNode","getFloats",0x43c9e5b6,"h3d.fbx.FbxNode.getFloats","h3d/fbx/Data.hx",81,0xd5b13f0b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(82)
	if (((this->props->length != (int)1))){
		HX_STACK_LINE(83)
		::String _g = ::Std_obj::string(this->props);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(83)
		::String _g1 = ((this->name + HX_CSTRING(" has ")) + _g);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(83)
		HX_STACK_DO_THROW((_g1 + HX_CSTRING(" props")));
	}
	HX_STACK_LINE(84)
	{
		HX_STACK_LINE(84)
		::h3d::fbx::FbxProp _g = this->props->__get((int)0).StaticCast< ::h3d::fbx::FbxProp >();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(84)
		switch( (int)(_g->__Index())){
			case (int)5: {
				HX_STACK_LINE(84)
				Array< Float > v = (::h3d::fbx::FbxProp(_g))->__Param(0);		HX_STACK_VAR(v,"v");
				HX_STACK_LINE(86)
				return v;
			}
			;break;
			case (int)4: {
				HX_STACK_LINE(84)
				Array< int > i = (::h3d::fbx::FbxProp(_g))->__Param(0);		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(87)
				{
					HX_STACK_LINE(88)
					Array< Float > fl = Array_obj< Float >::__new();		HX_STACK_VAR(fl,"fl");
					HX_STACK_LINE(89)
					{
						HX_STACK_LINE(89)
						int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
						HX_STACK_LINE(89)
						while((true)){
							HX_STACK_LINE(89)
							if ((!(((_g1 < i->length))))){
								HX_STACK_LINE(89)
								break;
							}
							HX_STACK_LINE(89)
							int x = i->__get(_g1);		HX_STACK_VAR(x,"x");
							HX_STACK_LINE(89)
							++(_g1);
							HX_STACK_LINE(90)
							fl->push(x);
						}
					}
					HX_STACK_LINE(91)
					return fl;
				}
			}
			;break;
			default: {
				HX_STACK_LINE(93)
				::String _g2 = ::Std_obj::string(this->props);		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(93)
				::String _g3 = ((this->name + HX_CSTRING(" has ")) + _g2);		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(93)
				HX_STACK_DO_THROW((_g3 + HX_CSTRING(" props")));
			}
		}
	}
	HX_STACK_LINE(84)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(FbxNode_obj,getFloats,return )

bool FbxNode_obj::hasProp( ::h3d::fbx::FbxProp p){
	HX_STACK_FRAME("h3d.fbx.FbxNode","hasProp",0x4cdc5506,"h3d.fbx.FbxNode.hasProp","h3d/fbx/Data.hx",97,0xd5b13f0b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(98)
	{
		HX_STACK_LINE(98)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(98)
		Array< ::Dynamic > _g1 = this->props;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(98)
		while((true)){
			HX_STACK_LINE(98)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(98)
				break;
			}
			HX_STACK_LINE(98)
			::h3d::fbx::FbxProp p2 = _g1->__get(_g).StaticCast< ::h3d::fbx::FbxProp >();		HX_STACK_VAR(p2,"p2");
			HX_STACK_LINE(98)
			++(_g);
			HX_STACK_LINE(99)
			if ((::Type_obj::enumEq(p,p2))){
				HX_STACK_LINE(100)
				return true;
			}
		}
	}
	HX_STACK_LINE(101)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC1(FbxNode_obj,hasProp,return )

int FbxNode_obj::getId( ){
	HX_STACK_FRAME("h3d.fbx.FbxNode","getId",0x826dc2ba,"h3d.fbx.FbxNode.getId","h3d/fbx/Data.hx",104,0xd5b13f0b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(105)
	if (((this->props->length != (int)3))){
		HX_STACK_LINE(106)
		HX_STACK_DO_THROW((this->name + HX_CSTRING(" is not an object")));
	}
	HX_STACK_LINE(107)
	{
		HX_STACK_LINE(107)
		::h3d::fbx::FbxProp _g = this->props->__get((int)0).StaticCast< ::h3d::fbx::FbxProp >();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(107)
		switch( (int)(_g->__Index())){
			case (int)0: {
				HX_STACK_LINE(107)
				int id = (::h3d::fbx::FbxProp(_g))->__Param(0);		HX_STACK_VAR(id,"id");
				HX_STACK_LINE(108)
				return id;
			}
			;break;
			case (int)1: {
				HX_STACK_LINE(107)
				Float id = (::h3d::fbx::FbxProp(_g))->__Param(0);		HX_STACK_VAR(id,"id");
				HX_STACK_LINE(109)
				return ::Std_obj::_int(id);
			}
			;break;
			default: {
				HX_STACK_LINE(110)
				::String _g1 = ::Std_obj::string(this->props);		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(110)
				HX_STACK_DO_THROW(((this->name + HX_CSTRING(" is not an object ")) + _g1));
			}
		}
	}
	HX_STACK_LINE(107)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC0(FbxNode_obj,getId,return )

::String FbxNode_obj::getName( ){
	HX_STACK_FRAME("h3d.fbx.FbxNode","getName",0x4ebb8eea,"h3d.fbx.FbxNode.getName","h3d/fbx/Data.hx",114,0xd5b13f0b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(115)
	if (((this->props->length != (int)3))){
		HX_STACK_LINE(116)
		HX_STACK_DO_THROW((this->name + HX_CSTRING(" is not an object")));
	}
	HX_STACK_LINE(117)
	{
		HX_STACK_LINE(117)
		::h3d::fbx::FbxProp _g = this->props->__get((int)1).StaticCast< ::h3d::fbx::FbxProp >();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(117)
		switch( (int)(_g->__Index())){
			case (int)2: {
				HX_STACK_LINE(117)
				::String n = (::h3d::fbx::FbxProp(_g))->__Param(0);		HX_STACK_VAR(n,"n");
				HX_STACK_LINE(118)
				return n.split(HX_CSTRING("::"))->pop();
			}
			;break;
			default: {
				HX_STACK_LINE(119)
				HX_STACK_DO_THROW((this->name + HX_CSTRING(" is not an object")));
			}
		}
	}
	HX_STACK_LINE(117)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(FbxNode_obj,getName,return )

::String FbxNode_obj::getType( ){
	HX_STACK_FRAME("h3d.fbx.FbxNode","getType",0x52c50f59,"h3d.fbx.FbxNode.getType","h3d/fbx/Data.hx",123,0xd5b13f0b)
	HX_STACK_THIS(this)
	HX_STACK_LINE(124)
	if (((this->props->length != (int)3))){
		HX_STACK_LINE(125)
		HX_STACK_DO_THROW((this->name + HX_CSTRING(" is not an object")));
	}
	HX_STACK_LINE(126)
	{
		HX_STACK_LINE(126)
		::h3d::fbx::FbxProp _g = this->props->__get((int)2).StaticCast< ::h3d::fbx::FbxProp >();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(126)
		switch( (int)(_g->__Index())){
			case (int)2: {
				HX_STACK_LINE(126)
				::String n = (::h3d::fbx::FbxProp(_g))->__Param(0);		HX_STACK_VAR(n,"n");
				HX_STACK_LINE(127)
				return n;
			}
			;break;
			default: {
				HX_STACK_LINE(128)
				HX_STACK_DO_THROW((this->name + HX_CSTRING(" is not an object")));
			}
		}
	}
	HX_STACK_LINE(126)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(FbxNode_obj,getType,return )

::String FbxNode_obj::getStringProp( int idx){
	HX_STACK_FRAME("h3d.fbx.FbxNode","getStringProp",0x23e936f3,"h3d.fbx.FbxNode.getStringProp","h3d/fbx/Data.hx",133,0xd5b13f0b)
	HX_STACK_THIS(this)
	HX_STACK_ARG(idx,"idx")
	HX_STACK_LINE(133)
	{
		HX_STACK_LINE(133)
		::h3d::fbx::FbxProp _g = this->props->__get(idx).StaticCast< ::h3d::fbx::FbxProp >();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(133)
		switch( (int)(_g->__Index())){
			case (int)2: {
				HX_STACK_LINE(133)
				::String n = (::h3d::fbx::FbxProp(_g))->__Param(0);		HX_STACK_VAR(n,"n");
				HX_STACK_LINE(134)
				return n;
			}
			;break;
			default: {
				HX_STACK_LINE(135)
				HX_STACK_DO_THROW((this->name + HX_CSTRING(" is not an object")));
			}
		}
	}
	HX_STACK_LINE(133)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(FbxNode_obj,getStringProp,return )


FbxNode_obj::FbxNode_obj()
{
}

void FbxNode_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(FbxNode);
	HX_MARK_MEMBER_NAME(name,"name");
	HX_MARK_MEMBER_NAME(props,"props");
	HX_MARK_MEMBER_NAME(childs,"childs");
	HX_MARK_END_CLASS();
}

void FbxNode_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(name,"name");
	HX_VISIT_MEMBER_NAME(props,"props");
	HX_VISIT_MEMBER_NAME(childs,"childs");
}

Dynamic FbxNode_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"get") ) { return get_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { return name; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"props") ) { return props; }
		if (HX_FIELD_EQ(inName,"getId") ) { return getId_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"childs") ) { return childs; }
		if (HX_FIELD_EQ(inName,"getAll") ) { return getAll_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"getInts") ) { return getInts_dyn(); }
		if (HX_FIELD_EQ(inName,"hasProp") ) { return hasProp_dyn(); }
		if (HX_FIELD_EQ(inName,"getName") ) { return getName_dyn(); }
		if (HX_FIELD_EQ(inName,"getType") ) { return getType_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"getFloats") ) { return getFloats_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"getStringProp") ) { return getStringProp_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic FbxNode_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { name=inValue.Cast< ::String >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"props") ) { props=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"childs") ) { childs=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void FbxNode_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("name"));
	outFields->push(HX_CSTRING("props"));
	outFields->push(HX_CSTRING("childs"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsString,(int)offsetof(FbxNode_obj,name),HX_CSTRING("name")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(FbxNode_obj,props),HX_CSTRING("props")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(FbxNode_obj,childs),HX_CSTRING("childs")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("name"),
	HX_CSTRING("props"),
	HX_CSTRING("childs"),
	HX_CSTRING("toString"),
	HX_CSTRING("get"),
	HX_CSTRING("getAll"),
	HX_CSTRING("getInts"),
	HX_CSTRING("getFloats"),
	HX_CSTRING("hasProp"),
	HX_CSTRING("getId"),
	HX_CSTRING("getName"),
	HX_CSTRING("getType"),
	HX_CSTRING("getStringProp"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FbxNode_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FbxNode_obj::__mClass,"__mClass");
};

#endif

Class FbxNode_obj::__mClass;

void FbxNode_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.fbx.FbxNode"), hx::TCanCast< FbxNode_obj> ,sStaticFields,sMemberFields,
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

void FbxNode_obj::__boot()
{
}

} // end namespace h3d
} // end namespace fbx
