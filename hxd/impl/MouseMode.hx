package hxd.impl;

/**
	The mouse movement input handling mode.
**/
enum MouseMode {
	/**
		Default mouse movement mode. Causes `EMove` events in window coordinates.
	**/
	Absolute;
	/**
		Relative mouse movement mode. In this mode the mouse cursor is hidden and instead of `EMove` event the `callback` is invoked with relative mouse movement.

		During Relative mouse mode the window mouse position is not updated.

		JS/HTML: Due to browser limitations, `restorePos` is always forced to `true`.
		Mouse mode is force-changed to `Absolute` when user presses `Escape` or somehow else exits mouse capture mode.
		Override `Window.onMouseModeChange` event in order to catch such cases.
		
		@param callback The callback to which the relative mouse movements are reported.
		Unless event is cancelled, set `propagate` flag in order to emit an `EMove` event with current window cursor position.
		Use `Window.setMousePos` to manually update the window cursor position.

		@param restorePos If set, when changing mouse mode to `Absolute`, cursor position would be restores to the position it was on when this mode was enabled.
		Otherwise mouse position is clipped to window boundaries.
	**/
	Relative(callback : hxd.Event -> Void, restorePos : Bool);
	/**
		Alternate relative mouse movement mode. In this mode the mouse cursor is hidden, and `EMove` can report mouse positions outside of window boundaries.
		
		JS/HTML: Due to browser limitations, `restorePos` is always forced to `true`.
		Mouse mode is force-changed to `Absolute` when user presses `Escape` or somehow else exits mouse capture mode.
		Override `Window.onMouseModeChange` event in order to catch such cases.
		
		@param restorePos If set, when changing mouse mode to `Absolute`, cursor position would be restored to the position it was on when this mode was enabled.
		Otherwise mouse position is clipped to window boundaries.
	**/
	AbsoluteUnbound(restorePos : Bool);
}
