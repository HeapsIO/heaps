package h2d;

/**
	Basic multi-camera container.
	This is very early version of multiple cameras support and does not work with h2d.Interactive.
**/
class MultiCamera extends Object {

	var cameras : Array<Camera>;
	var cameraLayer : Int;

	public function new( ?scene : h2d.Scene ) {
		super(scene);
		cameras = new Array();
	}

	public inline function addCamera( camera : Camera ) {
		if ( camera.parent == null ) {
			cameras.push(camera);
			camera.parent = this;
			camera.posChanged = true;
			if ( allocated ) {
				camera.onAdd();
			}
		}
		
	}

	public inline function removeCamera( camera : Camera ) {
		if ( cameras.remove(camera) ) {
			if ( camera.allocated ) camera.onRemove();
			camera.parent = null;
			camera.posChanged = true;
		}
	}

	override public function addChild(s:Object)
	{
		var cam : Camera = Std.instance(s, Camera);
		if (cam != null)
			addCamera(cam);
		else
			super.addChild(s);
	}

	override public function removeChild(s:Object)
	{
		var cam : Camera = Std.instance(s, Camera);
		if ( cam != null )
			removeCamera(cam);
		else
			super.removeChild(s);
	}

	override private function drawRec(ctx:RenderContext)
	{
		if ( !visible ) return;
		
		if( filter != null ) {
			throw "MultiCamera does not support filters!";
		} else {
			var old = ctx.globalAlpha;
			ctx.globalAlpha *= alpha;
			if( ctx.front2back ) {
				var nchilds = children.length;
				for ( cam in cameras ) {
					cam.drawRec(ctx);
					ctx.setCamera(cam);
					for (i in 0...nchilds) children[nchilds - 1 - i].drawRec(ctx);
				}
				ctx.clearCamera();
				draw(ctx);
			} else {
				draw(ctx);
				for ( cam in cameras ) {
					ctx.setCamera(cam);
					for( c in children ) c.drawRec(ctx);
					cam.drawRec(ctx);
				}
			}
			ctx.globalAlpha = old;
		}
	}

}