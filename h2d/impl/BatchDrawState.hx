package h2d.impl;

import h3d.Indexes;
import h3d.Buffer;

class BatchDrawState {

	/**
		Whether BatchDrawState used to render quads or triangles.
	**/
	public var isQuads(default, null) : Bool;
	/**
		Current active texture of BatchDrawState.
	**/
	public var currentTexture(get, never) : h3d.mat.Texture;

	var head : StateEntry;
	var tail : StateEntry;
	var dirty : Bool;

	public function new( quads : Bool, tex : h3d.mat.Texture = null ) {
		this.isQuads = quads;
		this.head = this.tail = new StateEntry(tex, 0);
	}

	/**
		Adds the `count` amount of vertexes to the state, separating it if `tile` texture was changed.
	**/
	public inline function nextTile( tile : h2d.Tile, count : Int ) {
		if ( tile == null ) add(count);
		else next(tile.getTexture(), count);
	}

	/**
		Adds the `count` amount of vertexes to the state, separating it if `texture` was changed.
	**/
	public function next( texture : h3d.mat.Texture, count : Int ) {
		if ( texture != null ) {
			if ( tail.texture == null ) tail.texture = texture;
			else if ( tail.texture != texture ) {
				var cur = tail;
				if ( isQuads ) cur.calcOffsetQuads();
				else cur.calcOffsetTris();
				if ( cur.next == null ) cur.next = tail = new StateEntry(texture, cur.offset + cur.count);
				else tail = cur.next.set(texture, cur.offset + cur.count);
			}
		}
		tail.count += count;
		dirty = true;
	}

	public inline function add( count : Int ) {
		tail.count += count;
		dirty = true;
	}

	/**
		Resets the BatchDrawState.
		@param clearTextures Will clear the texture references in all state entries when enabled.
	**/
	public function clear( clearTextures : Bool = false ) {
		if ( clearTextures ) {
			var state = head;
			do {
				state.texture = null;
				state = state.next;
			} while ( state != null );
		} else {
			head.texture = null;
		}
		tail = head;
		tail.count = 0;
		tail.offset = 0;
		dirty = true;
	}

	/**
		Ensures that current tail state has element offsets calculated.
	**/
	public function calcElements() {
		if ( dirty ) {
			if ( isQuads ) tail.calcOffsetQuads();
			else tail.calcOffsetTris();
			dirty = false;
		}
	}

	public function drawQuads( ctx : RenderContext, buffer : Buffer, offset = 0, length = -1 ) {
		if ( dirty ) {
			tail.calcOffsetQuads();
			dirty = false;
		}
		var state = head;
		var last = tail.next;
		var engine = ctx.engine;

		if ( offset == 0 && length == -1 ) {
			// Skip extra logic when not restraining rendering
			do {
				ctx.swapTexture(state.texture);
				engine.renderQuadBuffer(buffer, state.elOffset, state.elCount);
				state = state.next;
			} while ( state != last );
		} else {
			if ( length == -1 ) length = tail.elOffset + tail.elCount - offset;
			do {
				if ( state.elOffsetEnd >= offset ) {
					var stateMin = offset >= state.elOffset ? offset : state.elOffset;
					var stateLen = length > state.elCount ? state.elCount : length;
					ctx.swapTexture(state.texture);
					engine.renderQuadBuffer(buffer, stateMin, stateLen);
					length -= stateLen;
					if ( length == 0 ) break;
				}
				state = state.next;
			} while ( state != last );
		}
	}

	public function drawIndexed( ctx : RenderContext, buffer : Buffer, indices : Indexes, offset : Int = 0, length : Int = -1 ) {
		if ( dirty ) {
			tail.calcOffsetTris();
			dirty = false;
		}
		var state = head;
		var last = tail.next;
		var engine = ctx.engine;
		if ( offset == 0 && length == -1 ) {
			// Skip extra logic when not restraining rendering
			do {
				ctx.swapTexture(state.texture);
				engine.renderIndexed(buffer, indices, state.elOffset, state.elCount);
				state = state.next;
			} while ( state != last );
		} else {
			if ( length == -1 ) length = tail.elOffset + tail.elCount - offset;
			do {
				if ( state.elOffsetEnd >= offset ) {
					var stateMin = offset >= state.elOffset ? offset : state.elOffset;
					var stateLen = length > state.elCount ? state.elCount : length;
					ctx.swapTexture(state.texture);
					engine.renderIndexed(buffer, indices, stateMin, stateLen);
					length -= stateLen;
					if ( length == 0 ) break;
				}
				state = state.next;
			} while ( state != last );
		}
	}

	inline function get_currentTexture() return tail.texture;

}

private class StateEntry {

	/**
		Texture associated with draw state instance.
	**/
	public var texture : h3d.mat.Texture;
	/**
		An offset from the beginning of the render buffer representing batch range start.
		Not always represents vertex or element offset.
	**/
	public var offset : Int;
	/**
		A size of batch state.
		Not always represents vertices or elements.
	**/
	public var count : Int;
	
	/**
		Managed buffer offset in rendering elements.
		See `calcOffsetTris` and `calcOffsetQuads`.
	**/
	public var elOffset : Int;
	/**
		Managed state size in rendering elements.
		See `calcOffsetTris` and `calcOffsetQuads`.
	**/
	public var elCount : Int;
	/**
		Manage state offset end in rendering elements. Precalculated `elOffset + elCount`.
		See `calcOffsetTris` and `calcOffsetQuads`.
	**/
	public var elOffsetEnd : Int;

	public var next:StateEntry;

	public function new( texture : h3d.mat.Texture, offset : Int ) {
		this.texture = texture;
		this.offset = offset;
		this.count = 0;
		this.elOffset = 0;
		this.elCount = 0;
		this.elOffsetEnd = 0;
	}

	public function set( texture : h3d.mat.Texture, offset : Int ) : StateEntry {
		this.texture = texture;
		this.offset = offset;
		this.count = 0;
		return this;
	}

	/**
		Fills `elOffset` and `elCount` with amount of triangles batch state contains.
		Expects `offset` and `count` being a vertex offset/count in multiple of 3 per triangle.
	**/
	public inline function calcOffsetTris() {
		this.elOffset = Std.int(this.offset / 3);
		this.elCount = Std.int(this.count / 3);
		this.elOffsetEnd = elOffset + elCount;
	}

	/**
		Fills `elOffset` and `elCount` with amount of quads batch state contains.
		Expects `offset` and `count` being a vertex offset/count in multiple of 4 per quad.
	**/
	public inline function calcOffsetQuads() {
		this.elOffset = this.offset >> 1;
		this.elCount = this.count >> 1;
		this.elOffsetEnd = elOffset + elCount;
	}


}