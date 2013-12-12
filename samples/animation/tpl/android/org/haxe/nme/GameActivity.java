package org.haxe.nme;

//MINE

import java.util.Date;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Constructor;
import java.lang.Math;
import java.util.HashMap;
import java.util.Locale;
import java.lang.Thread.UncaughtExceptionHandler;
import java.util.ArrayList;

import android.app.Activity;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.content.res.Configuration;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Vibrator;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.inputmethod.InputMethodManager;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.ViewGroup;
import android.webkit.WebView;

import dalvik.system.DexClassLoader;

//import com.google.android.gms.gcm.GoogleCloudMessaging;
import mtnative.webview.NMEWebView;

//mainView.queueEvent == HXCPP THREAD
//act().runOnUiThread == ANDROID UI THREAD 
public class GameActivity extends Activity implements SensorEventListener
{
	private static final String GLOBAL_PREF_FILE = "nmeAppPrefs";
	private static final int DEVICE_ORIENTATION_UNKNOWN = 0;
	private static final int DEVICE_ORIENTATION_PORTRAIT = 1;
	private static final int DEVICE_ORIENTATION_PORTRAIT_UPSIDE_DOWN = 2;
	private static final int DEVICE_ORIENTATION_LANDSCAPE_RIGHT = 3;
	private static final int DEVICE_ORIENTATION_LANDSCAPE_LEFT = 4;
	private static final int DEVICE_ORIENTATION_FACE_UP = 5;
	private static final int DEVICE_ORIENTATION_FACE_DOWN = 6;
	private static final int DEVICE_ROTATION_0 = 0;
	private static final int DEVICE_ROTATION_90 = 1;
	private static final int DEVICE_ROTATION_180 = 2;
	private static final int DEVICE_ROTATION_270 = 3;
	
	static GameActivity activity;
	static AssetManager mAssets;
	static Context mContext;
	static DisplayMetrics metrics;
	static HashMap<String, Class> mLoadedClasses = new HashMap<String, Class>();
	static SensorManager sensorManager;
	
	public Handler mHandler;
	public MainView mView;
	
	private static float[] accelData = new float[3];
	private static int bufferedDisplayOrientation = -1;
	private static int bufferedNormalOrientation = -1;
	private static float[] inclinationMatrix = new float[16];
	private static float[] magnetData = new float[3];
	private static float[] orientData = new float[3];
	private static float[] rotationMatrix = new float[16];
	private static int id = 0;
	
	public int uid;
	
	private Sound _sound;
	public boolean paused;
	public ArrayList<View> views = new ArrayList();
	
	private static final String TAG = "MTNATIVE.GameActivity";
	public static final boolean DEBUG = true;
	public static mtnative.device.TypedHaxeHandler haxeHandler = null;
	
	public Date activityCreationTime;
	public Date viewCreationTime;
	public Date viewCreatedTime;
	public Date surfaceCreationTime;
	
	//MINE ::BILLING:: ::debug:: ::mobileApp:: ::NMMLParser:: ::TERM::
	protected void onCreate(Bundle state)
	{
		activityCreationTime = new Date();
		Log.d(TAG,"activityCreationTime:"+activityCreationTime);
		
		uid=id++;
		super.onCreate(state);
		
		activity = this;
		mContext = this;
		mHandler = new Handler();
		mAssets = getAssets();
				
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		
		_sound = new Sound(getApplication());
		
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
		
		metrics = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(metrics);
		
		Thread.currentThread().setUncaughtExceptionHandler(new UncaughtExceptionHandler() {
            @Override
            public void uncaughtException(Thread thread, Throwable ex) {
                if(DEBUG) Log.e(TAG,"[GA] Uncaught exception",ex);
            }
        });
		
		// Pre-load these, so the C++ knows where to find them
		
		::foreach ndlls::
		System.loadLibrary("::name::");::end::
		
		org.haxe.HXCPP.run("ApplicationMain");
		
		viewCreationTime = new Date();
		Log.d(TAG,"viewCreationTime:"+viewCreationTime);
		mView = new MainView(getApplication(), this);
		setContentView(mView);
		viewCreatedTime = new Date();
		Log.d(TAG,"viewCreatedTime:"+viewCreatedTime);
		
		sensorManager = (SensorManager)activity.getSystemService(Context.SENSOR_SERVICE);
		
		if (sensorManager != null)
		{
			sensorManager.registerListener(this, sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER), SensorManager.SENSOR_DELAY_GAME);
			sensorManager.registerListener(this, sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD), SensorManager.SENSOR_DELAY_GAME);
		}
		paused=false;
		
		act().getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
	}
	
	public GameActivity act(){
		return GameActivity.activity;
	}
	
	public void runInHaxeThread( Runnable r )
	{
		mView.queueEvent(r);
	}
	
	@Override
    protected void onNewIntent(final Intent intent) {
		Bundle b = intent.getExtras();
		if(b!=null)
			haxeHandler.onIntent( b.getString("data") );
		else 
			haxeHandler.onIntent( null );
		super.onNewIntent(intent);
    }
	
	@Override public void onBackPressed(){
		WebView wv = NMEWebView.mWebView;
		if( wv != null ) {
			if( wv.canGoBack())
				wv.goBack();
			else {
				haxeHandler.onBackPressed();
			}
		}
		else{
			//TODO DE handler by game !
			haxeHandler.onBackPressed();
		}
	}
	
	public static double CapabilitiesGetPixelAspectRatio()
	{
		return metrics.xdpi / metrics.ydpi;
	}
	
	
	public static double CapabilitiesGetScreenDPI()
	{
		return metrics.xdpi;	
	}
	
	
	public static double CapabilitiesGetScreenResolutionX()
	{
		return metrics.widthPixels;
	}
	
	
	public static double CapabilitiesGetScreenResolutionY()
	{
		return metrics.heightPixels;
	}
	
	public static String CapabilitiesGetLanguage()
	{
		return Locale.getDefault().getLanguage();
	}
	
	
	public static void clearUserPreference(String inId)
	{
		SharedPreferences prefs = activity.getSharedPreferences(GLOBAL_PREF_FILE, MODE_PRIVATE);
		SharedPreferences.Editor prefEditor = prefs.edit();
		prefEditor.putString(inId, "");
		prefEditor.commit();
	}
	
	
	public void doPause(){
		paused = true;
		try{
			if (sensorManager != null) sensorManager.unregisterListener(this);
			_sound.doPause();
			mView.sendActivity(NME.DEACTIVATE);
			Log.d(TAG,"nme deactivated"+ Thread.currentThread().getStackTrace());
			mView.onPause();
			Log.d(TAG,"onPaused");
		}
		catch( Throwable t ){
			if(DEBUG) Log.e(TAG,"GameActivity:doPause:"+t);
		}
	}
	
	public void doResume(){	
		SensorManager sm = sensorManager;
		Log.d(TAG,"doResume begin "+id);
		//dont check pause because onResume can be called by sleep process as well
		paused = false;
		
		mView.onResume();
		
		_sound.doResume();
		
		if (sm != null)
		{
			sm.registerListener(this, sm.getDefaultSensor(Sensor.TYPE_ACCELEROMETER), SensorManager.SENSOR_DELAY_GAME);
			sm.registerListener(this, sm.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD), SensorManager.SENSOR_DELAY_GAME);
		}
		
		mView.sendActivity(NME.ACTIVATE);
		
		if( NMEWebView.mWebView != null ){
			Log.w(TAG, "resuming web view");
			NMEWebView.show();
		}
		else{
			if(DEBUG) Log.w(TAG, "no webview to resume" );
		}
		
		if(DEBUG) Log.d(TAG,"doResume end");
	}
	
	
	public static Context getContext(){
		return mContext;
	}
	
	public static GameActivity getInstance(){
		return activity;
	}
	
	public static MainView getMainView(){
		return activity.mView;
	}

	public void queueRunnable(java.lang.Runnable runnable){
		Log.e("GameActivity", "queueing...");
	}
	
	
	public static byte[] getResource(String inResource){
		try
		{
			InputStream inputStream = mAssets.open(inResource, AssetManager.ACCESS_BUFFER);
			long length = inputStream.available();
			byte[] result = new byte[(int) length];
			inputStream.read(result);
			inputStream.close();
			return result;
		}
		catch (java.io.IOException e)
		{
			if(DEBUG) Log.e("GameActivity",  "getResource" + ":" + e.toString());
		}
		
		return null;
	}
	
	
	public static int getResourceID(String inFilename)
	{
		::foreach assets::::if (type == "music")::if (inFilename.equals("::id::")) return ::APP_PACKAGE::.R.raw.::flatName::;
		::end::::end::
		::foreach assets::::if (type == "sound")::if (inFilename.equals("::id::")) return ::APP_PACKAGE::.R.raw.::flatName::;
		::end::::end::
		return -1;
	}
	
	
	static public String getSpecialDir(int inWhich)
    {
		if(DEBUG) Log.d(TAG,"Get special Dir " + inWhich);
		File path = null;
		
		switch (inWhich)
		{
			case 0: // App
				return mContext.getPackageCodePath();
			
			case 1: // Storage
				path = mContext.getFilesDir();
				break;
			
			case 2: // Desktop
				path = Environment.getDataDirectory();
				break;
			
			case 3: // Docs
				path = Environment.getExternalStorageDirectory();
				break;
			
			case 4: // User
				path = mContext.getExternalFilesDir(Environment.DIRECTORY_DOWNLOADS);
				break;
		}
		
		return path == null ? "" : path.getAbsolutePath();
	}
	
	
	public static String getUserPreference(String inId)
	{
		SharedPreferences prefs = activity.getSharedPreferences(GLOBAL_PREF_FILE, MODE_PRIVATE);
		return prefs.getString(inId, "");
	}
	
	
	public static void launchBrowser(String inURL)
	{
		Intent browserIntent = new Intent(Intent.ACTION_VIEW).setData(Uri.parse(inURL));
		
		try
		{
			activity.startActivity(browserIntent);
		}
		catch (Exception e)
		{
			if(DEBUG) Log.e("GameActivity", e.toString());
			return;
		}
	}
	
	
	private void loadNewSensorData(SensorEvent event)
	{
		final int type = event.sensor.getType();
		
		if (type == Sensor.TYPE_ACCELEROMETER)
		{
			accelData = event.values.clone();
			
			if( accelData != null && accelData.length > 3 )
				NME.onAccelerate(-accelData[0], -accelData[1], accelData[2]);
		}
		
		if (type == Sensor.TYPE_MAGNETIC_FIELD)
		{
			magnetData = event.values.clone();
			//Log.d("GameActivity","new mag: " + magnetData[0] + ", " + magnetData[1] + ", " + magnetData[2]);
		}
	}
	
	
	@Override public void onAccuracyChanged(Sensor sensor, int accuracy)
	{
		
	}
	
	
	@Override protected void onDestroy()
	{
		if(DEBUG) Log.d(TAG,"onDestroy");
		
		mView.sendActivity(NME.DESTROY);
		activity = null;
		super.onDestroy();
	}
	
	
	@Override protected void onPause()
	{
		if(DEBUG) Log.d(TAG,"onPause "+id);
		super.onPause();
		doPause();
	}
	
	@Override protected void onStart()
	{
		if(DEBUG) Log.d(TAG,"onStart "+id);
		super.onStart();
	}
	
	@Override protected void onRestart()
	{
		if(DEBUG) Log.d(TAG,"onRestart "+id);
		super.onStart();
	}
	
	@Override protected void onStop()
	{
		if(DEBUG) Log.d(TAG,"onStop "+id);
		super.onStop();
	}
	
	
	@Override protected void onResume()
	{
		if(DEBUG) Log.d(TAG,"onResume "+id);
		doResume();
		super.onResume();
	}
	
	@Override public void onSensorChanged(SensorEvent event)
	{
		loadNewSensorData(event);
		
		if (accelData != null && magnetData != null)
		{
			boolean foundRotationMatrix = SensorManager.getRotationMatrix(rotationMatrix, inclinationMatrix, accelData, magnetData);
			if (foundRotationMatrix)
			{
				SensorManager.getOrientation(rotationMatrix, orientData);
				NME.onOrientationUpdate(orientData[0], orientData[1], orientData[2]);
			}
		}
		
		NME.onDeviceOrientationUpdate(prepareDeviceOrientation());
		NME.onNormalOrientationFound(bufferedNormalOrientation);
	}

	////////////////////////////////////////////////////////////////////////
	////////////VIEW Handling										////////
	////////////////////////////////////////////////////////////////////////
	public static void popView()
	{
		if(DEBUG) 
			if( activity.mView==null) 	Log.e("com.mt.NME","no view to restore...");
			else						Log.w("com.mt.NME","popView");
		
		activity.setContentView(activity.mView);
		activity.doResume();
	}
	
	/**
	Replaces current view tree by view
	*/
	public static void pushView(View inView, boolean pause)
	{
		activity.setContentView(inView);
		if( pause ){
			if(DEBUG) Log.w("MT.NME.WEBVIEW", "pausing");
			activity.doPause();
			if(DEBUG) Log.w("MT.NME.WEBVIEW", "paused");
		};
	}
	
	/**
	*/
	public static void removeContentView(View inView){
		ViewGroup vg = (ViewGroup)(inView.getParent());
		vg.removeView(inView);
		activity.doResume();
	}
	
	/**
	Adds the view to current view tree
	internally uses addContentView
	it you dont enable pausing, you might want to do it manually
	pausing can cause the requesting view not to show, beware !
	if you really wanna pause you must have a mecanism  that ensure isssued view will take control.
	*/
	public static void addView(View inView, android.view.ViewGroup.LayoutParams  params, boolean pause){
		
		if(DEBUG) Log.w("MT.NME.WEBVIEW", "adding content view pause:"+pause);
		activity.addContentView(inView,params);
		if(DEBUG) Log.w("MT.NME.WEBVIEW", "added");
		
		if( pause ){
			if(DEBUG) Log.w("MT.NME.WEBVIEW", "pausing");
			activity.doPause();
			if(DEBUG) Log.w("MT.NME.WEBVIEW", "paused");
		}
	}
	
	////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////
	
	
	public static void postUICallback(final long inHandle)
	{
		activity.mHandler.post(new Runnable()
		{
			@Override public void run()
			{
				NME.onCallback(inHandle);
			}
		});
	}
	
	
	private int prepareDeviceOrientation()
	{
		int rawOrientation = getWindow().getWindowManager().getDefaultDisplay().getOrientation();
		
		if (rawOrientation != bufferedDisplayOrientation)
		{
			bufferedDisplayOrientation = rawOrientation;
		}
		
		int screenOrientation = getResources().getConfiguration().orientation;
		int deviceOrientation = DEVICE_ORIENTATION_UNKNOWN;
		
		if (bufferedNormalOrientation < 0)
		{
			switch (screenOrientation)
			{
				case Configuration.ORIENTATION_LANDSCAPE:
					switch (bufferedDisplayOrientation)
					{
						case DEVICE_ROTATION_0:
						case DEVICE_ROTATION_180:
							bufferedNormalOrientation = DEVICE_ORIENTATION_LANDSCAPE_LEFT;
							break;
						
						case DEVICE_ROTATION_90:
						case DEVICE_ROTATION_270:
							bufferedNormalOrientation = DEVICE_ORIENTATION_PORTRAIT;
							break;
						
						default:
							bufferedNormalOrientation = DEVICE_ORIENTATION_UNKNOWN;
					}
					break;
				
				case Configuration.ORIENTATION_PORTRAIT:
					switch (bufferedDisplayOrientation)
					{
						case DEVICE_ROTATION_0:
						case DEVICE_ROTATION_180:
							bufferedNormalOrientation = DEVICE_ORIENTATION_PORTRAIT;
							break;
						
						case DEVICE_ROTATION_90:
						case DEVICE_ROTATION_270:
							bufferedNormalOrientation = DEVICE_ORIENTATION_LANDSCAPE_LEFT;
							break;
						
						default:
							bufferedNormalOrientation = DEVICE_ORIENTATION_UNKNOWN;
					}
					break;
				
				default: // ORIENTATION_SQUARE OR ORIENTATION_UNDEFINED
					bufferedNormalOrientation = DEVICE_ORIENTATION_UNKNOWN;
			}
		}
		
		switch (screenOrientation)
		{
			case Configuration.ORIENTATION_LANDSCAPE:
				switch (bufferedDisplayOrientation)
				{
					case DEVICE_ROTATION_0:
					case DEVICE_ROTATION_270:
						deviceOrientation = DEVICE_ORIENTATION_LANDSCAPE_LEFT;
						break;
					
					case DEVICE_ROTATION_90:
					case DEVICE_ROTATION_180:
						deviceOrientation = DEVICE_ORIENTATION_LANDSCAPE_RIGHT;
						break;
					
					default: // impossible!
						deviceOrientation = DEVICE_ORIENTATION_UNKNOWN;
				}
				break;
			
			case Configuration.ORIENTATION_PORTRAIT:
				switch (bufferedDisplayOrientation)
				{
					case DEVICE_ROTATION_0:
					case DEVICE_ROTATION_90:
						deviceOrientation = DEVICE_ORIENTATION_PORTRAIT;
						break;
					
					case DEVICE_ROTATION_180:
					case DEVICE_ROTATION_270:
						deviceOrientation = DEVICE_ORIENTATION_PORTRAIT_UPSIDE_DOWN;
						break;
					
					default: // impossible!
						deviceOrientation = DEVICE_ORIENTATION_UNKNOWN;
				}
				break;
			
			default: // ORIENTATION_SQUARE OR ORIENTATION_UNDEFINED
				deviceOrientation = DEVICE_ORIENTATION_UNKNOWN;
		}
		
		return deviceOrientation;
	}
	
	
	
	
	public static void setUserPreference(String inId, String inPreference)
	{
		SharedPreferences prefs = activity.getSharedPreferences(GLOBAL_PREF_FILE, MODE_PRIVATE);
		SharedPreferences.Editor prefEditor = prefs.edit();
		prefEditor.putString(inId, inPreference);
		prefEditor.commit();
	}
	
	
	public static void showKeyboard(boolean show)
	{
		InputMethodManager mgr = (InputMethodManager)activity.getSystemService(Context.INPUT_METHOD_SERVICE);
		mgr.hideSoftInputFromWindow(activity.mView.getWindowToken(), 0);
		
		if (show)
		{
			mgr.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);
			// On the Nexus One, SHOW_FORCED makes it impossible
			// to manually dismiss the keyboard.
			// On the Droid SHOW_IMPLICIT doesn't bring up the keyboard.
		}
	}
	
	
	public static void vibrate(int period, int duration)
	{
		Vibrator v = (Vibrator)activity.getSystemService(Context.VIBRATOR_SERVICE);
		
		if (period == 0)
		{
			v.vibrate(duration);
		}
		else
		{	
			int periodMS = (int)Math.ceil(period / 2);
			int count = (int)Math.ceil((duration / period) * 2);
			long[] pattern = new long[count];
			
			for (int i = 0; i < count; i++)
			{
				pattern[i] = periodMS;
			}
			
			v.vibrate(pattern, -1);
		}
	}
}
