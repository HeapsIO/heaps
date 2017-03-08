package hxd.snd.efx;

import hxd.snd.Driver;

private typedef AL           = openal.AL;
private typedef ALC          = openal.ALC;
private typedef EFX          = openal.EFX;
private typedef ALEffect     = openal.EFX.Effect;
private typedef ALEffectSlot = openal.EFX.EffectSlot;

@:allow(hxd.snd.efx.Manager)
private class EffectSlot {
	public var instance (default, null) : ALEffectSlot;
	public var changed  (default, null) : Bool;

	var effect     : Effect;
	var used       : Bool;
	var retainTime : Float;
	var lastStamp  : Float;

	function new(instance : ALEffectSlot) {
		this.instance   = instance;
		this.used       = false;
		this.effect     = null;
		this.changed    = true;
		this.retainTime = 0.0;
		this.lastStamp  = 0.0;
	}
}

@:allow(hxd.snd.efx.Manager)
private class AuxiliarySend {
	public var instance (default, null) : Int;
	public var changed  (default, null) : Bool;

	public function new(instance : Int) {
		this.instance = instance;
		this.changed  = true;
	}
}

private class SourceSends {
	public var used  : Map<Effect, AuxiliarySend>;
	public var free  : Array<AuxiliarySend>;
	public var count : Int;

	public function new() {
		used  = new Map();
		free  = [];
		count = 0;
	}
}

private class Manager {
	static inline var AL_NUM_EFFECT_SLOTS = 4;
	static var instance : Manager;

	public var maxAuxiliarySends(default, null) : Int;
	var effectSlots : Array<EffectSlot>;
	var sourceSends : Map<Driver.Source, SourceSends>;

	private function new() {
		var bytes = haxe.io.Bytes.alloc(4);

		// query maximum number of auxiliary sends
		var device = @:privateAccess hxd.snd.Driver.get().alDevice;
		ALC.getIntegerv(device, EFX.MAX_AUXILIARY_SENDS, 1, bytes);
		maxAuxiliarySends = bytes.getInt32(0);
		
		// alloc effect slots
		effectSlots = [];
		for (i in 0...AL_NUM_EFFECT_SLOTS) {
			EFX.genAuxiliaryEffectSlots(1, bytes);
			if (AL.getError() != AL.NO_ERROR) break;
			effectSlots.push(new EffectSlot(ALEffectSlot.ofInt(bytes.getInt32(0))));
		}

		sourceSends = new Map();

		/* dispose
		EFX.deleteAuxiliaryEffectSlots(effectSlots.length, arrayBytes([for( es in effectSlots ) es.instance.toInt()]));
		effectSlots = [];
		*/
	}

	public static function get() : Manager {
		if (instance == null) {
			instance = new Manager();
			var driver = hxd.snd.Driver.get();
			driver.addPreUpdateCallback(instance.preUpdate);
			driver.addPostUpdateCallback(instance.postUpdate);
		}
		return instance;
	}

	function preUpdate() {
		for (e in effectSlots) e.used = false;
	}

	function postUpdate() {
		var now = haxe.Timer.stamp();
		for (e in effectSlots) {
			if (e.used || e.effect == null) continue;
			if (now - e.lastStamp > e.retainTime) releaseEffectSlot(e);
		}
	}

	public function getEffectSlot(effect : Effect, retainTime : Float = 0.0) : EffectSlot { 
		var slot : EffectSlot = null;
		for (e in effectSlots) {
			if (e.effect == effect) {
				slot = e;
				break;
			} else if (e.effect == null) 
				slot = e;
		}

		if (slot == null) throw "too many request slot requests";
		if (slot.effect == effect) {
			slot.changed = false;
		} else {
			slot.changed  = true;
			slot.effect = effect;
		}
		
		slot.used       = true;
		slot.retainTime = retainTime;
		slot.lastStamp  = haxe.Timer.stamp();
		return slot;
	}

	function releaseEffectSlot(slot : EffectSlot) {
		EFX.auxiliaryEffectSloti(slot.instance, EFX.EFFECTSLOT_EFFECT, EFX.EFFECTSLOT_NULL);
		slot.effect = null;
	}

	public function getAuxiliarySend(effect : Effect, source : Driver.Source) : AuxiliarySend {
		var sends = sourceSends.get(source);
		if (sends == null) {
			sends = new SourceSends();
			sourceSends.set(source, sends);
		}

		var as = sends.used.get(effect);
		if (as != null) {
			as.changed = false;
			return as;
		}

		if (sends.free.length > 0) {
			as = sends.free.pop();
		} else {
			if (sends.count >= maxAuxiliarySends) throw "too many auxilary send requests (max = " + maxAuxiliarySends + " )";
			as = new AuxiliarySend(sends.count++);
		}

		as.changed = true;
		sends.used.set(effect, as);
		return as;
	}

	public function releaseAuxiliarySend(effect : Effect, source : Driver.Source) {
		var sends = sourceSends.get(source);
		if (sends == null) return;

		var as = sends.used.get(effect);
		if (as == null) return;

		sends.free.push(as);
		sends.used.remove(effect);
	}
}

class Effect extends hxd.snd.Effect {
	public var filter (default, set) : Filter;

	var manager        : Manager;
	var changed        : Bool;
	var filterChanged  : Bool;
	var slotRetainTime : Float;
	var instance       : ALEffect;
	var alBytes        : haxe.io.Bytes;

	public function new(?filter : Filter) {
		super();
		this.manager        = Manager.get();
		this.changed        = true;
		this.filter         = filter;
		this.slotRetainTime = 0.0;
		this.alBytes        = haxe.io.Bytes.alloc(4);
	}

	inline function set_filter(v : Filter) { 
		if (v == filter) return filter;
		if (allocated) {
			if (filter != null) filter.decRefs();
			if (v != null) v.incRefs();
		}
		filterChanged = true; 
		return filter = v; 
	}

	override function onAlloc() {
		EFX.genEffects(1, alBytes);
		instance = ALEffect.ofInt(alBytes.getInt32(0));
		changed  = true;
		if (filter != null) filter.incRefs();
	}

	override function onDelete() {
		EFX.deleteEffects(1, alBytes);
		if (filter != null) filter.decRefs();
	}

	override function apply(source : Driver.Source) {
		var slot = manager.getEffectSlot(this, slotRetainTime);
		if (changed || slot.changed) {
			EFX.auxiliaryEffectSloti(slot.instance, EFX.EFFECTSLOT_EFFECT, instance.toInt());
			changed = false;
		}

		var filterInst = EFX.FILTER_NULL;
		if (filter != null) {
			filter.effect = this;
			filter.apply(source);
			filter.effect = null;
			filterInst = filter.instance.toInt();
		}

		var send = manager.getAuxiliarySend(this, source);
		if (filterChanged || send.changed || slot.changed) {
			AL.source3i(source.inst, EFX.AUXILIARY_SEND_FILTER, slot.instance.toInt(), send.instance, filterInst);
			filterChanged = false;
		}	
	}

	override function unapply(source : Driver.Source) {
		var send = manager.getAuxiliarySend(this, source);
		AL.source3i(source.inst, EFX.AUXILIARY_SEND_FILTER, EFX.EFFECTSLOT_NULL, send.instance, EFX.FILTER_NULL);
		manager.releaseAuxiliarySend(this, source);
	}
}