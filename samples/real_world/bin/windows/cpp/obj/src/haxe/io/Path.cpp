#include <hxcpp.h>

#ifndef INCLUDED_EReg
#include <EReg.h>
#endif
#ifndef INCLUDED_haxe_io_Path
#include <haxe/io/Path.h>
#endif
namespace haxe{
namespace io{

Void Path_obj::__construct(::String path)
{
HX_STACK_FRAME("haxe.io.Path","new",0x1b96d677,"haxe.io.Path.new","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Path.hx",76,0xf5d3569a)
HX_STACK_THIS(this)
HX_STACK_ARG(path,"path")
{
	HX_STACK_LINE(77)
	int c1 = path.lastIndexOf(HX_CSTRING("/"),null());		HX_STACK_VAR(c1,"c1");
	HX_STACK_LINE(78)
	int c2 = path.lastIndexOf(HX_CSTRING("\\"),null());		HX_STACK_VAR(c2,"c2");
	HX_STACK_LINE(79)
	if (((c1 < c2))){
		HX_STACK_LINE(80)
		::String _g = path.substr((int)0,c2);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(80)
		this->dir = _g;
		HX_STACK_LINE(81)
		::String _g1 = path.substr((c2 + (int)1),null());		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(81)
		path = _g1;
		HX_STACK_LINE(82)
		this->backslash = true;
	}
	else{
		HX_STACK_LINE(83)
		if (((c2 < c1))){
			HX_STACK_LINE(84)
			::String _g2 = path.substr((int)0,c1);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(84)
			this->dir = _g2;
			HX_STACK_LINE(85)
			::String _g3 = path.substr((c1 + (int)1),null());		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(85)
			path = _g3;
		}
		else{
			HX_STACK_LINE(87)
			this->dir = null();
		}
	}
	HX_STACK_LINE(88)
	int cp = path.lastIndexOf(HX_CSTRING("."),null());		HX_STACK_VAR(cp,"cp");
	HX_STACK_LINE(89)
	if (((cp != (int)-1))){
		HX_STACK_LINE(90)
		::String _g4 = path.substr((cp + (int)1),null());		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(90)
		this->ext = _g4;
		HX_STACK_LINE(91)
		::String _g5 = path.substr((int)0,cp);		HX_STACK_VAR(_g5,"_g5");
		HX_STACK_LINE(91)
		this->file = _g5;
	}
	else{
		HX_STACK_LINE(93)
		this->ext = null();
		HX_STACK_LINE(94)
		this->file = path;
	}
}
;
	return null();
}

//Path_obj::~Path_obj() { }

Dynamic Path_obj::__CreateEmpty() { return  new Path_obj; }
hx::ObjectPtr< Path_obj > Path_obj::__new(::String path)
{  hx::ObjectPtr< Path_obj > result = new Path_obj();
	result->__construct(path);
	return result;}

Dynamic Path_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Path_obj > result = new Path_obj();
	result->__construct(inArgs[0]);
	return result;}

::String Path_obj::toString( ){
	HX_STACK_FRAME("haxe.io.Path","toString",0xc0ab5735,"haxe.io.Path.toString","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Path.hx",109,0xf5d3569a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(109)
	return ((((  (((this->dir == null()))) ? ::String(HX_CSTRING("")) : ::String((this->dir + ((  ((this->backslash)) ? ::String(HX_CSTRING("\\")) : ::String(HX_CSTRING("/")) )))) )) + this->file) + ((  (((this->ext == null()))) ? ::String(HX_CSTRING("")) : ::String((HX_CSTRING(".") + this->ext)) )));
}


HX_DEFINE_DYNAMIC_FUNC0(Path_obj,toString,return )

::String Path_obj::withoutExtension( ::String path){
	HX_STACK_FRAME("haxe.io.Path","withoutExtension",0xb4016fa0,"haxe.io.Path.withoutExtension","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Path.hx",117,0xf5d3569a)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(118)
	::haxe::io::Path s = ::haxe::io::Path_obj::__new(path);		HX_STACK_VAR(s,"s");
	HX_STACK_LINE(119)
	s->ext = null();
	HX_STACK_LINE(120)
	return s->toString();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Path_obj,withoutExtension,return )

::String Path_obj::withoutDirectory( ::String path){
	HX_STACK_FRAME("haxe.io.Path","withoutDirectory",0xdf35ce8e,"haxe.io.Path.withoutDirectory","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Path.hx",128,0xf5d3569a)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(129)
	::haxe::io::Path s = ::haxe::io::Path_obj::__new(path);		HX_STACK_VAR(s,"s");
	HX_STACK_LINE(130)
	s->dir = null();
	HX_STACK_LINE(131)
	return s->toString();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Path_obj,withoutDirectory,return )

::String Path_obj::directory( ::String path){
	HX_STACK_FRAME("haxe.io.Path","directory",0xbcfe23c4,"haxe.io.Path.directory","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Path.hx",141,0xf5d3569a)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(142)
	::haxe::io::Path s = ::haxe::io::Path_obj::__new(path);		HX_STACK_VAR(s,"s");
	HX_STACK_LINE(143)
	if (((s->dir == null()))){
		HX_STACK_LINE(144)
		return HX_CSTRING("");
	}
	HX_STACK_LINE(145)
	return s->dir;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Path_obj,directory,return )

::String Path_obj::extension( ::String path){
	HX_STACK_FRAME("haxe.io.Path","extension",0x91c9c4d6,"haxe.io.Path.extension","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Path.hx",155,0xf5d3569a)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(156)
	::haxe::io::Path s = ::haxe::io::Path_obj::__new(path);		HX_STACK_VAR(s,"s");
	HX_STACK_LINE(157)
	if (((s->ext == null()))){
		HX_STACK_LINE(158)
		return HX_CSTRING("");
	}
	HX_STACK_LINE(159)
	return s->ext;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Path_obj,extension,return )

::String Path_obj::withExtension( ::String path,::String ext){
	HX_STACK_FRAME("haxe.io.Path","withExtension",0x256d3570,"haxe.io.Path.withExtension","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Path.hx",169,0xf5d3569a)
	HX_STACK_ARG(path,"path")
	HX_STACK_ARG(ext,"ext")
	HX_STACK_LINE(170)
	::haxe::io::Path s = ::haxe::io::Path_obj::__new(path);		HX_STACK_VAR(s,"s");
	HX_STACK_LINE(171)
	s->ext = ext;
	HX_STACK_LINE(172)
	return s->toString();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Path_obj,withExtension,return )

::String Path_obj::join( Array< ::String > paths){
	HX_STACK_FRAME("haxe.io.Path","join",0x05c781f3,"haxe.io.Path.join","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Path.hx",183,0xf5d3569a)
	HX_STACK_ARG(paths,"paths")

	HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_1_1)
	bool run(::String s){
		HX_STACK_FRAME("*","_Function_1_1",0x5200ed37,"*._Function_1_1","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Path.hx",184,0xf5d3569a)
		HX_STACK_ARG(s,"s")
		{
			HX_STACK_LINE(184)
			return (bool((s != null())) && bool((s != HX_CSTRING(""))));
		}
		return null();
	}
	HX_END_LOCAL_FUNC1(return)

	HX_STACK_LINE(184)
	Array< ::String > paths1 = paths->filter( Dynamic(new _Function_1_1()));		HX_STACK_VAR(paths1,"paths1");
	HX_STACK_LINE(185)
	if (((paths1->length == (int)0))){
		HX_STACK_LINE(186)
		return HX_CSTRING("");
	}
	HX_STACK_LINE(188)
	::String path = paths1->__get((int)0);		HX_STACK_VAR(path,"path");
	HX_STACK_LINE(189)
	{
		HX_STACK_LINE(189)
		int _g1 = (int)1;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(189)
		int _g = paths1->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(189)
		while((true)){
			HX_STACK_LINE(189)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(189)
				break;
			}
			HX_STACK_LINE(189)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(190)
			::String _g2 = ::haxe::io::Path_obj::addTrailingSlash(path);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(190)
			path = _g2;
			HX_STACK_LINE(191)
			hx::AddEq(path,paths1->__get(i));
		}
	}
	HX_STACK_LINE(193)
	return ::haxe::io::Path_obj::normalize(path);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Path_obj,join,return )

::String Path_obj::normalize( ::String path){
	HX_STACK_FRAME("haxe.io.Path","normalize",0x585a68e4,"haxe.io.Path.normalize","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Path.hx",204,0xf5d3569a)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(205)
	::String slash = HX_CSTRING("/");		HX_STACK_VAR(slash,"slash");
	HX_STACK_LINE(206)
	::String _g = path.split(HX_CSTRING("\\"))->join(HX_CSTRING("/"));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(206)
	path = _g;
	HX_STACK_LINE(207)
	if (((bool((path == null())) || bool((path == slash))))){
		HX_STACK_LINE(208)
		return slash;
	}
	HX_STACK_LINE(211)
	Array< ::String > target = Array_obj< ::String >::__new();		HX_STACK_VAR(target,"target");
	HX_STACK_LINE(212)
	Array< ::String > src;		HX_STACK_VAR(src,"src");
	HX_STACK_LINE(213)
	Dynamic parts;		HX_STACK_VAR(parts,"parts");
	HX_STACK_LINE(214)
	::String token;		HX_STACK_VAR(token,"token");
	HX_STACK_LINE(216)
	Array< ::String > _g1 = path.split(slash);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(216)
	src = _g1;
	HX_STACK_LINE(217)
	{
		HX_STACK_LINE(217)
		int _g11 = (int)0;		HX_STACK_VAR(_g11,"_g11");
		HX_STACK_LINE(217)
		int _g2 = src->length;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(217)
		while((true)){
			HX_STACK_LINE(217)
			if ((!(((_g11 < _g2))))){
				HX_STACK_LINE(217)
				break;
			}
			HX_STACK_LINE(217)
			int i = (_g11)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(218)
			token = src->__get(i);
			HX_STACK_LINE(220)
			if (((token == HX_CSTRING("..")))){
				HX_STACK_LINE(221)
				target->pop();
			}
			else{
				HX_STACK_LINE(222)
				if (((token != HX_CSTRING(".")))){
					HX_STACK_LINE(223)
					target->push(token);
				}
			}
		}
	}
	HX_STACK_LINE(227)
	::String tmp = target->join(slash);		HX_STACK_VAR(tmp,"tmp");
	HX_STACK_LINE(229)
	::EReg regex = ::EReg_obj::__new(HX_CSTRING("([^:])/+"),HX_CSTRING("g"));		HX_STACK_VAR(regex,"regex");
	HX_STACK_LINE(230)
	::String result = regex->replace(tmp,(HX_CSTRING("$1") + slash));		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(253)
	return result;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Path_obj,normalize,return )

::String Path_obj::addTrailingSlash( ::String path){
	HX_STACK_FRAME("haxe.io.Path","addTrailingSlash",0x8b4f8e69,"haxe.io.Path.addTrailingSlash","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Path.hx",268,0xf5d3569a)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(269)
	if (((path.length == (int)0))){
		HX_STACK_LINE(270)
		return HX_CSTRING("/");
	}
	HX_STACK_LINE(271)
	int c1 = path.lastIndexOf(HX_CSTRING("/"),null());		HX_STACK_VAR(c1,"c1");
	HX_STACK_LINE(272)
	int c2 = path.lastIndexOf(HX_CSTRING("\\"),null());		HX_STACK_VAR(c2,"c2");
	HX_STACK_LINE(273)
	if (((c1 < c2))){
		HX_STACK_LINE(274)
		if (((c2 != (path.length - (int)1)))){
			HX_STACK_LINE(274)
			return (path + HX_CSTRING("\\"));
		}
		else{
			HX_STACK_LINE(275)
			return path;
		}
	}
	else{
		HX_STACK_LINE(277)
		if (((c1 != (path.length - (int)1)))){
			HX_STACK_LINE(277)
			return (path + HX_CSTRING("/"));
		}
		else{
			HX_STACK_LINE(278)
			return path;
		}
	}
	HX_STACK_LINE(273)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Path_obj,addTrailingSlash,return )

::String Path_obj::removeTrailingSlashes( ::String path){
	HX_STACK_FRAME("haxe.io.Path","removeTrailingSlashes",0x2dc73462,"haxe.io.Path.removeTrailingSlashes","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Path.hx",293,0xf5d3569a)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(294)
	while((true)){
		HX_STACK_LINE(295)
		Dynamic _g = path.charCodeAt((path.length - (int)1));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(295)
		Dynamic _switch_1 = (_g);
		if (  ( _switch_1==(int)47) ||  ( _switch_1==(int)92)){
			HX_STACK_LINE(296)
			::String _g1 = path.substr((int)0,(int)-1);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(296)
			path = _g1;
		}
		else  {
			HX_STACK_LINE(297)
			break;
		}
;
;
	}
	HX_STACK_LINE(300)
	return path;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Path_obj,removeTrailingSlashes,return )


Path_obj::Path_obj()
{
}

void Path_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Path);
	HX_MARK_MEMBER_NAME(dir,"dir");
	HX_MARK_MEMBER_NAME(file,"file");
	HX_MARK_MEMBER_NAME(ext,"ext");
	HX_MARK_MEMBER_NAME(backslash,"backslash");
	HX_MARK_END_CLASS();
}

void Path_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(dir,"dir");
	HX_VISIT_MEMBER_NAME(file,"file");
	HX_VISIT_MEMBER_NAME(ext,"ext");
	HX_VISIT_MEMBER_NAME(backslash,"backslash");
}

Dynamic Path_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"dir") ) { return dir; }
		if (HX_FIELD_EQ(inName,"ext") ) { return ext; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"join") ) { return join_dyn(); }
		if (HX_FIELD_EQ(inName,"file") ) { return file; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"directory") ) { return directory_dyn(); }
		if (HX_FIELD_EQ(inName,"extension") ) { return extension_dyn(); }
		if (HX_FIELD_EQ(inName,"normalize") ) { return normalize_dyn(); }
		if (HX_FIELD_EQ(inName,"backslash") ) { return backslash; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"withExtension") ) { return withExtension_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"withoutExtension") ) { return withoutExtension_dyn(); }
		if (HX_FIELD_EQ(inName,"withoutDirectory") ) { return withoutDirectory_dyn(); }
		if (HX_FIELD_EQ(inName,"addTrailingSlash") ) { return addTrailingSlash_dyn(); }
		break;
	case 21:
		if (HX_FIELD_EQ(inName,"removeTrailingSlashes") ) { return removeTrailingSlashes_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Path_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"dir") ) { dir=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"ext") ) { ext=inValue.Cast< ::String >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"file") ) { file=inValue.Cast< ::String >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"backslash") ) { backslash=inValue.Cast< bool >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Path_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("dir"));
	outFields->push(HX_CSTRING("file"));
	outFields->push(HX_CSTRING("ext"));
	outFields->push(HX_CSTRING("backslash"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("withoutExtension"),
	HX_CSTRING("withoutDirectory"),
	HX_CSTRING("directory"),
	HX_CSTRING("extension"),
	HX_CSTRING("withExtension"),
	HX_CSTRING("join"),
	HX_CSTRING("normalize"),
	HX_CSTRING("addTrailingSlash"),
	HX_CSTRING("removeTrailingSlashes"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsString,(int)offsetof(Path_obj,dir),HX_CSTRING("dir")},
	{hx::fsString,(int)offsetof(Path_obj,file),HX_CSTRING("file")},
	{hx::fsString,(int)offsetof(Path_obj,ext),HX_CSTRING("ext")},
	{hx::fsBool,(int)offsetof(Path_obj,backslash),HX_CSTRING("backslash")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("dir"),
	HX_CSTRING("file"),
	HX_CSTRING("ext"),
	HX_CSTRING("backslash"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Path_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Path_obj::__mClass,"__mClass");
};

#endif

Class Path_obj::__mClass;

void Path_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.io.Path"), hx::TCanCast< Path_obj> ,sStaticFields,sMemberFields,
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

void Path_obj::__boot()
{
}

} // end namespace haxe
} // end namespace io
