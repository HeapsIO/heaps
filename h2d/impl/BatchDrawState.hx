package h2d.impl;

import h3d.Indexes;
import h3d.Buffer;

/**
	Automates buffer segmentation when rendering 2D geometry with multiple unique textures.

	Primary use-case is to allow usage of multiple textures without the need to manually manage them.
	Causes extra draw call each time a texture is swapped.
	Due to that, for production it is recommended to combine assets in atlases for optimal performance.

	Depending on geometry type, vertex count should be in groups of 4 vertices per quad or 3 indices per triangle.
**/
class BatchDrawState {

	/**
		Current active texture of the BatchDrawState.
		Represents the most recent texture that was set with `setTile` or `setTexture`.
		Always null after state initialization or after `clear` call.
	**/
	public var currentTexture(get, never) : h3d.mat.Texture;
	/**
		A total amount of vertices added to the BatchDrawState.
	**/
	public var totalCount(default, null) : Int;

	var head : StateEntry;
	var tail : StateEntry;

	/**
		Create a new BatchDrawState instance.
	**/
	public function new() {
		this.head = this.tail = new StateEntry(null);
		this.totalCount = 0;
	}

	/**
		Switches currently active texture to one in the given `tile` if it differs and splits the render state.
		@param tile A Tile containing a texture that should be used for the next set of vertices. Does nothing if `null`.
	**/
	public inline function setTile( tile : h2d.Tile ) {
		if ( tile != null ) setTexture(tile.getTexture());
	}

	/**
		Switches currently active texture to the given `texture` if it differs and splits the render state.
		@param texture The texture that should be used for the next set of vertices. Does nothing if `null`.
	**/
	public function setTexture( texture : h3d.mat.Texture ) {
		if ( texture != null ) {
			if ( tail.texture == null ) tail.texture = texture;
			else if ( tail.texture != texture ) {
				var cur = tail;
				if ( cur.count == 0 ) cur.set(texture);
				else if ( cur.next == null ) cur.next = tail = new StateEntry(texture);
				else tail = cur.next.set(texture);
			}
		}
	}

	/**
		Add vertices to the state using currently active texture.
		Should be called when rendering buffers add more data in order to properly render the geometry.
		@param count The amount of vertices to add.
	**/
	public inline function add( count : Int ) {
		tail.count += count;
		totalCount += count;
	}

	/**
		Resets the BatchDrawState by removing all texture references and zeroing vertex counter.
	**/
	public function clear() {
		var state = head;
		do {
			state.texture = null;
			state = state.next;
		} while ( state != null );
		tail = head;
		tail.count = 0;
		totalCount = 0;
	}

	/**
		Renders given buffer as a set of quads. Buffer data should be in groups of 4 vertices per quad.
		@param ctx The render context which performs the rendering. Rendering object should call `h2d.RenderContext.beginDrawBatchState` before calling `drawQuads`.
		@param buffer The quad buffer used to render the state.
		@param offset An optional starting offset of the buffer to render in triangles (2 per quad).
		@param length An optional maximum limit of triangles to render.

		When `offset` and `length` are not provided or are default values, slightly faster rendering routine is used.
	**/
	public function drawQuads( ctx : RenderContext, buffer : Buffer, offset = 0, length = -1 ) {
		var state = head;
		var last = tail.next;
		var engine = ctx.engine;
		var stateLen : Int;
		inline function toQuads( count : Int ) return count >> 1;

		if ( offset == 0 && length == -1 ) {
			// Skip extra logic when not restraining rendering
			do {
				ctx.swapTexture(state.texture);
				stateLen = toQuads(state.count);
				engine.renderQuadBuffer(buffer, offset, stateLen);
				offset += stateLen;
				state = state.next;
			} while ( state != last );
		} else {
			if ( length == -1 ) length = toQuads(totalCount) - offset;
			var caret = 0;
			do {
				stateLen = toQuads(state.count);
				if ( caret + stateLen >= offset ) {
					var stateMin = offset >= caret ? offset : caret;
					var stateLen = length > stateLen ? stateLen : length;
					ctx.swapTexture(state.texture);
					engine.renderQuadBuffer(buffer, stateMin, stateLen);
					length -= stateLen;
					if ( length == 0 ) break;
				}
				caret += stateLen;
				state = state.next;
			} while ( state != last );
		}
	}

	/**
		Renders given indices as a set of triangles. Index data should be in groups of 3 vertices per quad.
		@param ctx The render context which performs the rendering. Rendering object should call `h2d.RenderContext.beginDrawBatchState` before calling `drawQuads`.
		@param buffer The vertex buffer used to render the state.
		@param indices Vertex indices used to render the state.
		@param offset An optional starting offset of the buffer to render in triangles.
		@param length An optional maximum limit of triangles to render.

		When `offset` and `length` are not provided or are default values, slightly faster rendering routine is used.
	**/
	public function drawIndexed( ctx : RenderContext, buffer : Buffer, indices : Indexes, offset : Int = 0, length : Int = -1 ) {
		var state = head;
		var last = tail.next;
		var engine = ctx.engine;
		var stateLen : Int;
		inline function toTris( count : Int ) return Std.int(count / 3);

		if ( offset == 0 && length == -1 ) {
			// Skip extra logic when not restraining rendering
			do {
				ctx.swapTexture(state.texture);
				stateLen = toTris(state.count);
				engine.renderIndexed(buffer, indices, offset, stateLen);
				offset += stateLen;
				state = state.next;
			} while ( state != last );
		} else {
			if ( length == -1 ) length = toTris(totalCount);
			var caret = 0;
			do {
				stateLen = toTris(state.count);
				if ( caret + stateLen >= offset ) {
					var stateMin = offset >= caret ? offset : caret;
					var stateLen = length > stateLen ? stateLen : length;
					ctx.swapTexture(state.texture);
					engine.renderIndexed(buffer, indices, stateMin, stateLen);
					length -= stateLen;
					if ( length == 0 ) break;
				}
				caret += stateLen;
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
		A size of batch state.
	**/
	public var count : Int;


	public var next:StateEntry;

	public function new( texture : h3d.mat.Texture ) {
		this.texture = texture;
		this.count = 0;
	}

	public function set( texture : h3d.mat.Texture ) : StateEntry {
		this.texture = texture;
		this.count = 0;
		return this;
	}

}