package h3d.impl;

#if macro
private typedef PassObject = Dynamic;
#else
private typedef PassObject = h3d.pass.PassObject;
#end

enum RenderErrorKind {
	Compile( pass : PassObject );
	Shader( shader : hxsl.RuntimeShader );
	Params( shader : hxsl.RuntimeShader );
	Draw( pass : PassObject );
}

class RenderError {

	/**
		When set, render errors are reported here instead of throwing, and what failed is skipped.
		A failed `Shader` stays skipped. The failing pass, if any, is `RenderContext.drawPass`.
	**/
	public static var onRenderError : (error : RenderErrorKind, message : String) -> Void;

	public static macro function guard( e : haxe.macro.Expr, kind : haxe.macro.Expr ) : haxe.macro.Expr {
		return macro if( h3d.impl.RenderError.onRenderError == null ) { $e; true; } else try { $e; true; } catch( exc : haxe.Exception ) {
			h3d.impl.RenderError.onRenderError($kind, exc.message);
			false;
		};
	}

}
