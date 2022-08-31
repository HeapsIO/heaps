package hxd.impl;

enum MouseMode {
	/**
		Default mouse movement mode. Causes `EMove` events in window coordinates.
	**/
	Absolute;
	/**
		Relative mouse movement mode. In this mode the mouse cursor is hidden and instead of `EMove` event the `callback` is invoked with relative mouse movement.

		During Relative mouse mode the window mouse position is not updated.
		If event is not cancelled and `propagate` set to true, the `EMove` event will be sent with last mouse position.
		Use `Window.setMousePos` to modify the sent mouse position.
	**/
	Relative(callback: hxd.Event->Void);
	/**
		Alternate relative mouse movement mode. In this mode the mouse cursor is hidden, and `EMove` can report mouse positions outside of window boundaries.
	**/
	AbsoluteUnbound;
	/**
		Alternate relative mouse movement mode. In this mode, the mouse cursor is hidden, and `EMove` event mouse position can wrap around the window boundaries.
	**/
	AbsoluteWrap;
}
