package org.haxe.nme;

import java.util.Date;

import android.app.Activity;
import android.content.Context;
import android.graphics.PixelFormat;
import android.opengl.GLSurfaceView;
import android.os.Build;
import android.util.AttributeSet;
import android.util.Log;
::if (ANDROID_TARGET_SDK_VERSION > 11)::import android.view.InputDevice;::end::
import android.view.KeyCharacterMap;
import android.view.KeyEvent;
import android.view.MotionEvent;
import javax.microedition.khronos.egl.EGL10;
import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.egl.EGLContext;
import javax.microedition.khronos.egl.EGLDisplay;
import javax.microedition.khronos.opengles.GL10;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;


class MainView extends GLSurfaceView {
	
	
	static final int etTouchBegin = 15;
	static final int etTouchMove = 16;
	static final int etTouchEnd = 17;
	static final int etTouchTap = 18;
	static final int resTerminate = -1;
	
	Activity mActivity;
	static MainView mRefreshView;
	Timer mTimer = new Timer ();
	int mTimerID = 0;
	
	private static final String TAG = "MTNATIVE.MainView";
	
	
	public MainView (Context context, Activity inActivity) {
		
		super (context);
		
		int eglVersion = 1;
		
		if (::WIN_ALLOW_SHADERS:: || ::WIN_REQUIRE_SHADERS::) {
			
			EGL10 egl = (EGL10)EGLContext.getEGL ();
			EGLDisplay display = egl.eglGetDisplay (EGL10.EGL_DEFAULT_DISPLAY);
			int[] version = new int[2];
			
			egl.eglInitialize (display, version);
			
			EGLConfig[] v2_configs = new EGLConfig[1];
			int[] num_config = new int[1];
			int[] attrs = { EGL10.EGL_RENDERABLE_TYPE, 4 /*EGL_OPENGL_ES2_BIT*/, EGL10.EGL_NONE };
			egl.eglChooseConfig (display, attrs, v2_configs, 1, num_config);
			
			::if debug::
			setDebugFlags(DEBUG_CHECK_GL_ERROR);
			::end::
			
			if (num_config[0]==1) {
				
				eglVersion = 2;
				setEGLContextClientVersion (2);
				
			}
			
		}
		
		final int renderType = (eglVersion == 1 ? 0x01 : 0x04);
		
		setEGLConfigChooser (new EGLConfigChooser () {
			
			public EGLConfig chooseConfig (EGL10 egl, EGLDisplay display) {
				
				int depth = ::if WIN_DEPTH_BUFFER::16::else::0::end::;
				int stencil = ::if WIN_STENCIL_BUFFER::8::else::0::end::;
				EGLConfig[] configs = new EGLConfig[1];
				int[] num_config = new int[1];
				
				if (::WIN_ANTIALIASING:: > 1) {
					
					int[] attrs = {
						
						EGL10.EGL_DEPTH_SIZE, depth,
						EGL10.EGL_STENCIL_SIZE, stencil,
						EGL10.EGL_SAMPLE_BUFFERS, 1 /* true */,
						EGL10.EGL_SAMPLES, ::WIN_ANTIALIASING::,
						EGL10.EGL_RENDERABLE_TYPE, renderType,
						EGL10.EGL_NONE
						
					};
					
					egl.eglChooseConfig (display, attrs, configs, 1, num_config);
					
					if (num_config[0] == 1) {
						
						return configs[0];
						
					}
					
					if (::WIN_ANTIALIASING:: > 2) {
						
						int[] attrs_aa2 = {
							
							EGL10.EGL_DEPTH_SIZE, depth,
							EGL10.EGL_STENCIL_SIZE, stencil,
							EGL10.EGL_SAMPLE_BUFFERS, 1 /* true */,
							EGL10.EGL_SAMPLES, 2,
							EGL10.EGL_RENDERABLE_TYPE, renderType,
							EGL10.EGL_NONE
							
						};
						
						egl.eglChooseConfig (display, attrs_aa2, configs, 1, num_config);
						
						if (num_config[0] == 1) {
							
							return configs[0];
							
						}
						
					}
					
					final int EGL_COVERAGE_BUFFERS_NV = 0x30E0;
					final int EGL_COVERAGE_SAMPLES_NV = 0x30E1;
					
					int[] attrs_aanv = {
						
						EGL10.EGL_DEPTH_SIZE, depth,
						EGL10.EGL_STENCIL_SIZE, stencil,
						EGL_COVERAGE_BUFFERS_NV, 1 /* true */,
						EGL_COVERAGE_SAMPLES_NV, 2,  // always 5 in practice on tegra 2
						EGL10.EGL_RENDERABLE_TYPE, renderType,
						EGL10.EGL_NONE
						
					};
					
					egl.eglChooseConfig (display, attrs_aanv, configs, 1, num_config);
					
					if (num_config[0] == 1) {
						
						return configs[0];
						
					}
					
				}
				
				int[] attrs1 = {
					
					EGL10.EGL_DEPTH_SIZE, depth,
					EGL10.EGL_STENCIL_SIZE, stencil,
					EGL10.EGL_RENDERABLE_TYPE, renderType,
					EGL10.EGL_NONE
					
				};
				
				egl.eglChooseConfig (display, attrs1, configs, 1, num_config);
				
				if (num_config[0] == 1) {
					
					return configs[0];
					
				}
				
				int[] attrs2 = {
					
					EGL10.EGL_NONE
					
				};
				
				egl.eglChooseConfig (display, attrs2, configs, 1, num_config);
				
				if (num_config[0] == 1) {
					
					return configs[0];
					
				}
				
				return null;
				
			}
			
		});
		
		mActivity = inActivity;
		mRefreshView = this;
		setFocusable (true);
		setFocusableInTouchMode (true);
		setRenderer (new Renderer (this));
		setRenderMode (GLSurfaceView.RENDERMODE_WHEN_DIRTY);
		
	}
	
	
	public void HandleResult (int inCode) {
		
		if (inCode == resTerminate) {
			
			mActivity.finish ();
			return;
			
		}
		
		double wake = NME.getNextWake ();
		final MainView me = this;
		
		if (wake <= 0) {
			
			queueEvent (new Runnable () {
				
				public void run () {
					
					me.onPoll ();
					
				}
				
			});
			
		} else {
			
			final int tid = ++mTimerID;
			Date end = new Date ();
			end.setTime (end.getTime () + (int)(wake * 1000));
			
			mTimer.schedule (new TimerTask () {
				
				public void run () {
					
					if (tid == me.mTimerID) {
						
						me.queuePoll ();
						
					}
					
				}
				
			}, end);
			
		}
		
	}
	
	
	::if (ANDROID_TARGET_SDK_VERSION > 11)::@Override public boolean onGenericMotionEvent (MotionEvent event) {
		
		if ((event.getSource () & InputDevice.SOURCE_CLASS_JOYSTICK) != 0 && event.getAction () == MotionEvent.ACTION_MOVE) {
			
			final MainView me = this;
			final InputDevice device = event.getDevice ();
			final int deviceId = event.getDeviceId ();
			
			int[] axisList = {
				
				android.view.MotionEvent.AXIS_X, android.view.MotionEvent.AXIS_Y, android.view.MotionEvent.AXIS_Z,
				android.view.MotionEvent.AXIS_RX, android.view.MotionEvent.AXIS_RY, android.view.MotionEvent.AXIS_RZ,
				android.view.MotionEvent.AXIS_HAT_X, android.view.MotionEvent.AXIS_HAT_Y,
				android.view.MotionEvent.AXIS_LTRIGGER, android.view.MotionEvent.AXIS_RTRIGGER
				
			};
			
			for (int i = 0; i < axisList.length; i++) {
				
				final int axis = axisList[i];
				final InputDevice.MotionRange range = device.getMotionRange (axis, event.getSource ());
				
				if (range != null) {
					
					final float flat = range.getFlat ();
					final float value = event.getAxisValue (axis);
					
					if (Math.abs (value) > flat) {
						
						queueEvent (new Runnable () {
							
							public void run () {
								
								me.HandleResult (NME.onJoyMotion (deviceId, axis, ((value - range.getMin ()) / (range.getRange ())) * 65535 - 32768));
								
							}
							
						});
						
					} else {
						
						queueEvent (new Runnable () {
							
							public void run () {
								
								me.HandleResult (NME.onJoyMotion (deviceId, axis, 0));
								
							}
							
						});
						
					}
				}
				
			}
			
			return true;
			
		}
		
		return super.onGenericMotionEvent (event);
		
	}::end::
	
	
	@Override public boolean onKeyDown (final int inKeyCode, KeyEvent event) {
		
		final MainView me = this;
		
		::if (ANDROID_TARGET_SDK_VERSION > 11)::if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB_MR1 && (event.isGamepadButton (inKeyCode) || (inKeyCode >= 19 && inKeyCode <= 22))) {
			
			if (event.getRepeatCount () == 0) {
				
				final int deviceId = event.getDeviceId ();
				
				queueEvent (new Runnable () {
					
					public void run () {
						
						me.HandleResult (NME.onJoyChange (deviceId, inKeyCode, true));
						
					}
					
				});
				
			}
			
			return true;
			
		}::end::
		
		final int keyCode = translateKey (inKeyCode, event);
		
		if (keyCode != 0) {
			
			queueEvent (new Runnable () {
				
				public void run () {
					
					me.HandleResult (NME.onKeyChange (keyCode, true));
					
				}
				
			});
			
			return true;
			
		}
		
		return super.onKeyDown(inKeyCode, event);
		
	}
	
	
	@Override public boolean onKeyUp (final int inKeyCode, KeyEvent event) {
		
		final MainView me = this;
		
		::if (ANDROID_TARGET_SDK_VERSION > 11)::if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB_MR1 && (event.isGamepadButton (inKeyCode) || (inKeyCode >= 19 && inKeyCode <= 22))) {
			
			if (event.getRepeatCount () == 0) {
				
				final int deviceId = event.getDeviceId ();
				
				queueEvent (new Runnable () {
					
					public void run () {
						
						me.HandleResult (NME.onJoyChange (deviceId, inKeyCode, false));
						
					}
					
				});
				
			}
			
			return true;
			
		}::end::
		
		final int keyCode = translateKey (inKeyCode, event);
		
		if (keyCode != 0) {
			
			queueEvent (new Runnable () {
				
				public void run () {
					
					me.HandleResult (NME.onKeyChange (keyCode, false));
					
				}
				
			});
			
			return true;
			
		}
		
		return super.onKeyDown(inKeyCode, event);
		
	}
	
	
	void onPoll () {
		
		HandleResult (NME.onPoll ());
		
	}
	
	
	@Override public boolean onTouchEvent (final MotionEvent ev) {
		
		final MainView me = this;
		final int action = ev.getAction ();
		int type = -1;
		
		switch (action & MotionEvent.ACTION_MASK) {
			
			case MotionEvent.ACTION_DOWN: type = etTouchBegin; break;
			case MotionEvent.ACTION_POINTER_DOWN: type = etTouchBegin; break;
			case MotionEvent.ACTION_MOVE: type = etTouchMove; break;
			case MotionEvent.ACTION_UP: type = etTouchEnd; break;
			case MotionEvent.ACTION_POINTER_UP: type = etTouchEnd; break;
			case MotionEvent.ACTION_CANCEL: type = etTouchEnd; break;
			
		}
		
		int idx = (action & MotionEvent.ACTION_POINTER_ID_MASK) >> (MotionEvent.ACTION_POINTER_ID_SHIFT);
		final int t = type;
		
		for (int i = 0; i < ev.getPointerCount (); i++) {
			
			final int id = ev.getPointerId (i);
			final float x = ev.getX (i);
			final float y = ev.getY (i);
			final float sizeX = ev.getSize (i);
			final float sizeY = ev.getSize (i);
			
			if (type == etTouchMove || i == idx) {
				
				queueEvent (new Runnable () {
					
					public void run () {
						
						me.HandleResult (NME.onTouch (t, x, y, id, sizeX, sizeY));
						
					}
					
				});
				
			}
			
		}
		
		return true;
		
	}
	
	
	@Override public boolean onTrackballEvent (final MotionEvent ev) {
		
		final MainView me = this;
		
		queueEvent (new Runnable () {
			
			public void run() {
				
				float x = ev.getX ();
				float y = ev.getY ();
				
				me.HandleResult (NME.onTrackball (x, y));
				
			}
			
		});
		
		return false;
		
	}
	
	
	void queuePoll () {
		
		final MainView me = this;
		
		queueEvent (new Runnable () {
			
			public void run () {
				
				me.onPoll ();
				
			}
			
		});
		
	}
	
	
	
	static public void renderNow () { //Called directly from C++
		
		mRefreshView.requestRender ();
		
	}
	
	
	void sendActivity (final int inActivity) {
		
		queueEvent (new Runnable () {
			
			public void run () {
				
				NME.onActivity (inActivity);
				
			}
			
		});
		
	}
	
	
	public int translateKey(int inCode, KeyEvent event) {
		
		switch (inCode) {
			
			case KeyEvent.KEYCODE_BACK: return 27; /* Fake Escape */
			case KeyEvent.KEYCODE_MENU: return 0x01000012; /* Fake MENU */
			case KeyEvent.KEYCODE_DEL: return 8;
			
		}
		
		int result = event.getUnicodeChar (event.getMetaState ());
		
		if (result == KeyCharacterMap.COMBINING_ACCENT) {
			
			//TODO
			return 0;
			
		}
		
		return result;
		
	}
	
	
	
	
	private static class Renderer implements GLSurfaceView.Renderer {
		//mine
		
		MainView mMainView;
		
		public Renderer (MainView inView) {
			
			mMainView = inView;
			
		}
		
		
		public void onDrawFrame (GL10 gl) {
			
			mMainView.HandleResult (NME.onRender ());
			Sound.checkSoundCompletion ();
			
			
		}
		
		
		public void onSurfaceChanged (GL10 gl, int width, int height) {
			
			mMainView.HandleResult (NME.onResize (width, height));
			
			
		}
		
		
			
		public void onSurfaceCreated (GL10 gl, EGLConfig config) {
			GameActivity.getInstance().surfaceCreationTime = new Date();
			Log.d(TAG,"surfaceCreationTime:"+GameActivity.getInstance().surfaceCreationTime);
			
			org.json.JSONObject gpu = new org.json.JSONObject();
			
			int [] results = {0,0,0,0};
			int i = 0;
			
			gl.glGetIntegerv(GL10.GL_MAX_TEXTURE_SIZE,results,i++);
			gl.glGetIntegerv(GL10.GL_MAX_ELEMENTS_VERTICES,results,i++);
			gl.glGetIntegerv(GL10.GL_MAX_ELEMENTS_INDICES,results,i++);
			gl.glGetIntegerv(GL10.GL_MAX_TEXTURE_UNITS,results,i++);
			
			gpu.put("max_texture_width",results[0]);
			gpu.put("max_elements_vertices",results[1]);
			gpu.put("max_elements_indices",results[2]);
			gpu.put("max_texture_units",results[3]);
			
			String extensions = gl.glGetString(GL10.GL_EXTENSIONS);
			gpu.put("extensions", extensions);
		}
		
	}
	
	
}