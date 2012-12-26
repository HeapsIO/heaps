package h3d.prim;

class Joint {

	public var index : Int;
	public var name : String;
	public var bindIndex : Int;
	public var transPos : h3d.Matrix; // inverse pose matrix
	public var parent : Joint;
	public var subs : Array<Joint>;
	
	public function new() {
		bindIndex = -1;
		subs = [];
	}
	
}

private class Influence {
	public var j : Joint;
	public var w : Float;
	public function new(j, w) {
		this.j = j;
		this.w = w;
	}
}

private typedef Table<T> = #if flash flash.Vector<T> #else Array<T> #end

class Skin {
	
	public var vertexCount(default, null) : Int;
	public var bonesPerVertex(default,null) : Int;
	public var vertexJoints : Table<Int>;
	public var vertexWeights : Table<Float>;
	public var rootJoints(default,null) : Array<Joint>;
	public var namedJoints(default,null) : Hash<Joint>;
	public var allJoints(default,null) : Array<Joint>;
	public var boundJoints(default,null) : Array<Joint>;
	public var primitive : Primitive;
	
	var envelop : Array<Array<Influence>>;
	
	public function new( vertexCount, bonesPerVertex ) {
		this.vertexCount = vertexCount;
		this.bonesPerVertex = bonesPerVertex;
		vertexJoints = new Table(#if flash vertexCount * bonesPerVertex #end);
		vertexWeights = new Table(#if flash vertexCount * bonesPerVertex #end);
		envelop = [];
	}
	
	public function setJoints( joints : Array<Joint>, roots : Array<Joint> ) {
		rootJoints = roots;
		allJoints = joints;
		namedJoints = new Hash();
		for( j in joints )
			if( j.name != null )
				namedJoints.set(j.name, j);
	}
	
	public inline function addInfluence( vid : Int, j : Joint, w : Float ) {
		var il = envelop[vid];
		if( il == null )
			il = envelop[vid] = [];
		il.push(new Influence(j,w));
	}

	function sortInfluences( i1 : Influence, i2 : Influence ) {
		return i2.w > i1.w ? 1 : -1;
	}
	
	public function initWeights() {
		boundJoints = [];
		var pos = 0;
		for( i in 0...vertexCount ) {
			var il = envelop[i];
			if( il == null ) il = [];
			il.sort(sortInfluences);
			if( il.length > 4 )
				il = il.slice(0, 4);
			var tw = 0.;
			for( i in il )
				tw += i.w;
			tw = 1 / tw;
			for( i in 0...bonesPerVertex ) {
				var i = il[i];
				if( i == null ) {
					vertexJoints[pos] = 0;
					vertexWeights[pos] = 0;
				} else {
					if( i.j.bindIndex == -1 ) {
						i.j.bindIndex = boundJoints.length;
						boundJoints.push(i.j);
					}
					vertexJoints[pos] = i.j.bindIndex;
					vertexWeights[pos] = i.w;
				}
				pos++;
			}
		}
	}
	
}