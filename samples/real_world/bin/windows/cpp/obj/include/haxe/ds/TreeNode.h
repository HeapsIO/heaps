#ifndef INCLUDED_haxe_ds_TreeNode
#define INCLUDED_haxe_ds_TreeNode

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(haxe,ds,TreeNode)
namespace haxe{
namespace ds{


class HXCPP_CLASS_ATTRIBUTES  TreeNode_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef TreeNode_obj OBJ_;
		TreeNode_obj();
		Void __construct(::haxe::ds::TreeNode l,Dynamic k,Dynamic v,::haxe::ds::TreeNode r,hx::Null< int >  __o_h);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< TreeNode_obj > __new(::haxe::ds::TreeNode l,Dynamic k,Dynamic v,::haxe::ds::TreeNode r,hx::Null< int >  __o_h);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~TreeNode_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("TreeNode"); }

		::haxe::ds::TreeNode left;
		::haxe::ds::TreeNode right;
		Dynamic key;
		Dynamic value;
		int _height;
		virtual ::String toString( );
		Dynamic toString_dyn();

};

} // end namespace haxe
} // end namespace ds

#endif /* INCLUDED_haxe_ds_TreeNode */ 
