package hxd.snd.efx;

import openal.AL;
import openal.EFX;

class Reverb extends hxd.snd.efx.Effect {
	public var density             (default, set) : Float;
    public var diffusion           (default, set) : Float;
	public var gain                (default, set) : Float;
    public var gainHF              (default, set) : Float;
    public var gainLF              (default, set) : Float;
    public var decayTime           (default, set) : Float;
    public var decayHFRatio        (default, set) : Float;
    public var decayLFRatio        (default, set) : Float;
    public var reflectionsGain     (default, set) : Float;
    public var reflectionsDelay    (default, set) : Float;
    public var reflectionsPan      (default, set) : h3d.Vector;
    public var lateReverbGain      (default, set) : Float;
    public var lateReverbDelay     (default, set) : Float;
    public var lateReverbPan       (default, set) : h3d.Vector;
    public var echoTime            (default, set) : Float;
    public var echoDepth           (default, set) : Float;
    public var modulationTime      (default, set) : Float;
    public var modulationDepth     (default, set) : Float;
    public var airAbsorptionGainHF (default, set) : Float;
    public var hfReference         (default, set) : Float;
    public var lfReference         (default, set) : Float;
    public var roomRolloffFactor   (default, set) : Float;
    public var decayHFLimit        (default, set) : Int;

	inline function set_density(v)             { changed = true; return density = v; }            
	inline function set_diffusion(v)           { changed = true; return diffusion = v; }  
	inline function set_gain(v)                { changed = true; return gain = v; }          
	inline function set_gainHF(v)              { changed = true; return gainHF = v; }             
	inline function set_gainLF(v)              { changed = true; return gainLF = v; }             
	inline function set_decayTime(v)           { changed = true; return decayTime = v; }          
	inline function set_decayHFRatio(v)        { changed = true; return decayHFRatio = v; }       
	inline function set_decayLFRatio(v)        { changed = true; return decayLFRatio = v; }       
	inline function set_reflectionsGain(v)     { changed = true; return reflectionsGain = v; }    
	inline function set_reflectionsDelay(v)    { changed = true; return reflectionsDelay = v; }   
	inline function set_reflectionsPan(v)      { changed = true; return reflectionsPan = v; }     
	inline function set_lateReverbGain(v)      { changed = true; return lateReverbGain = v; }     
	inline function set_lateReverbDelay(v)     { changed = true; return lateReverbDelay = v; }    
	inline function set_lateReverbPan(v)       { changed = true; return lateReverbPan = v; }      
	inline function set_echoTime(v)            { changed = true; return echoTime = v; }           
	inline function set_echoDepth(v)           { changed = true; return echoDepth = v; }          
	inline function set_modulationTime(v)      { changed = true; return modulationTime = v; }     
	inline function set_modulationDepth(v)     { changed = true; return modulationDepth = v; }    
	inline function set_airAbsorptionGainHF(v) { changed = true; return airAbsorptionGainHF = v; }
	inline function set_hfReference(v)         { changed = true; return hfReference = v; }        
	inline function set_lfReference(v)         { changed = true; return lfReference = v; }        
	inline function set_roomRolloffFactor(v)   { changed = true; return roomRolloffFactor = v; }  
	inline function set_decayHFLimit(v)        { changed = true; return decayHFLimit = v; }       

	public function new(?preset : ReverbPreset) {
		super();
		loadPreset(preset != null ? preset : ReverbPreset.GENERIC);
	}

	public function loadPreset(preset : ReverbPreset) {
		density             = preset.density;
		diffusion           = preset.diffusion;
		gain                = preset.gain;
		gainHF              = preset.gainHF;
		gainLF              = preset.gainLF;
		decayTime           = preset.decayTime;
		decayHFRatio        = preset.decayHFRatio;
		decayLFRatio        = preset.decayLFRatio;
		reflectionsGain     = preset.reflectionsGain;
		reflectionsDelay    = preset.reflectionsDelay;
		reflectionsPan      = preset.reflectionsPan;
		lateReverbGain      = preset.lateReverbGain;
		lateReverbDelay     = preset.lateReverbDelay;
		lateReverbPan       = preset.lateReverbPan;
		echoTime            = preset.echoTime;
		echoDepth           = preset.echoDepth;
		modulationTime      = preset.modulationTime;
		modulationDepth     = preset.modulationDepth;
		airAbsorptionGainHF = preset.airAbsorptionGainHF;
		hfReference         = preset.hfReference;
		lfReference         = preset.lfReference;
		roomRolloffFactor   = preset.roomRolloffFactor;
		decayHFLimit        = preset.decayHFLimit;
	}

	override function onAlloc() {
		super.onAlloc();
		EFX.effecti(instance, EFX.EFFECT_TYPE, EFX.EFFECT_REVERB);
	}

	override function apply(source : Driver.Source) {
		if (changed) {
			EFX.effectf(instance, EFX.REVERB_DENSITY,               density);
			EFX.effectf(instance, EFX.REVERB_DIFFUSION,             diffusion);
			EFX.effectf(instance, EFX.REVERB_GAIN,                  gain);
			EFX.effectf(instance, EFX.REVERB_GAINHF,                gainHF);
			EFX.effectf(instance, EFX.REVERB_DECAY_TIME,            decayTime);
			EFX.effectf(instance, EFX.REVERB_DECAY_HFRATIO,         decayHFRatio);
			EFX.effectf(instance, EFX.REVERB_REFLECTIONS_GAIN,      reflectionsGain);
			EFX.effectf(instance, EFX.REVERB_REFLECTIONS_DELAY,     reflectionsDelay);
			EFX.effectf(instance, EFX.REVERB_LATE_REVERB_GAIN,      lateReverbGain);
			EFX.effectf(instance, EFX.REVERB_LATE_REVERB_DELAY,     lateReverbDelay);
			EFX.effectf(instance, EFX.REVERB_AIR_ABSORPTION_GAINHF, airAbsorptionGainHF);
			EFX.effectf(instance, EFX.REVERB_ROOM_ROLLOFF_FACTOR,   roomRolloffFactor);
			EFX.effecti(instance, EFX.REVERB_DECAY_HFLIMIT,         decayHFLimit);

			slotRetainTime = decayTime + reflectionsDelay + lateReverbDelay;
		}
		super.apply(source);
	}

	override function applyAudibleGainModifier(v : Float) {
		return v + gain * Math.max(reflectionsGain, lateReverbGain);
	}
}