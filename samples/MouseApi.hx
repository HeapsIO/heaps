import hxd.impl.MouseMode;
import h2d.Graphics;
import h2d.Text;
import hxd.Key;

using hxd.Math;

class MouseApi extends SampleApp {
	
	var state: Text;
	var restore: Bool;
	var propagate: Bool;
	var virtualCursor: Graphics;
	var relativePath: Graphics;
	var relX: Float;
	var relY: Float;
	var expectedMode: MouseMode;

	override function init() {
		super.init();

		var window = hxd.Window.getInstance();

		addText("Press Escape or right click to restore to Absolute mouse mode");
		state = addText("\n");

		#if !js // Not supported on JS
		// Lock the mouse within the window boundaries.
		addCheck("MouseClip", () -> window.mouseClip, (v) -> window.mouseClip = v);
		#end
		
		// Use setCursorPos in order to warp the mouse
		// JS: Due to browser limitations only useful in relative modes to move the virtual cursor.
		addButton("Set position to center", () -> window.setCursorPos(s2d.width>>1, s2d.height>>1));

		addText("MouseMode:");
		// The default mouse mode behaves like a regular mouse.
		addButton("Absolute", () -> window.mouseMode = expectedMode = Absolute);
		// Callback will get relative mouse movement.
		addButton("Relative", () -> {
			window.mouseMode = expectedMode = Relative(onRelativeMove, restore);
			relX = 0;
			relY = 0;
			relativePath.clear();
			relativePath.setPosition(s2d.width>>1, s2d.height>>1);
		});
		// Mouse position would be able to leave the window boundaries, but clipped on exit.
		addButton("AbsoluteUnbound", () -> window.mouseMode = expectedMode = AbsoluteUnbound(restore));
		// When restoring to Absolute: Either clip mouse position or restore to where it entered relative mode.
		addCheck("RestorePos", () -> restore, (v) -> restore = v);
		// Would set propagate flag in Relative mode, allowing mouse movement events to pass trough.
		addCheck("Propagate", () -> propagate, (v) -> propagate = v);

		relativePath = new Graphics();
		s2d.addChildAt(relativePath, 0);

		virtualCursor = new Graphics(s2d);
		virtualCursor.lineStyle(1);
		virtualCursor.beginFill(0xffffff);
		virtualCursor.moveTo(0, 0);
		virtualCursor.lineTo(10, 10);
		virtualCursor.lineTo(0, 16);
		virtualCursor.endFill();

		#if js
		// On JS, browser can force-exit the relative mode. In which case switch back to one we want.
		window.onMouseModeChange = (from, to) -> to != expectedMode ? from : to;
		#end
	}

	override function update(dt:Float) {

		var window = hxd.Window.getInstance();

		if (Key.isReleased(Key.ESCAPE) || Key.isReleased(Key.MOUSE_RIGHT)) window.mouseMode = expectedMode = Absolute;
		state.text = "Current mode: " + window.mouseMode.getName() + "\nMouse position: " + window.mouseX + ", " + window.mouseY;
		virtualCursor.visible = window.mouseMode != Absolute;
		virtualCursor.setPosition(window.mouseX, window.mouseY);

	}

	function onRelativeMove(e: hxd.Event) {
		// Draw the movement segment and keep Graphics centered.
		relativePath.x -= e.relX;
		relativePath.y -= e.relY;
		relativePath.lineStyle(1, Std.int(((Math.cos(relX * .05) + 1)) / 2 * 0xff) << 16 | Std.int(((Math.sin(relY * .05) + 1)) / 2 * 0xff) << 8 | 0xff, 1);
		relativePath.moveTo(relX, relY);
		relX += e.relX;
		relY += e.relY;
		relativePath.lineTo(relX, relY);
		relativePath.lineStyle();

		// Since in relative mode mouse position is not updated - update it manually.
		var window = hxd.Window.getInstance();
		if (propagate) {
			window.setCursorPos((window.mouseX + Std.int(e.relX)).iclamp(0, window.width), (window.mouseY + Std.int(e.relY)).iclamp(0, window.height));
			e.propagate = true;
		}
	}

	static function main() {
		new MouseApi();
	}

}