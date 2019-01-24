package h2d.uikit;

class Error {
	public var message : String;
	public var pmin : Int;
	public var pmax : Int;

	public function new( messsage, pmin = -1, pmax = -1 ) {
		this.message = messsage;
		this.pmin = pmin;
		this.pmax = pmax < 0 ? pmin + 1 : pmax;
	}

	public function toString() {
		var msg = "UIKitError("+message+")";
		if( pmin < 0 )
			return msg;
		msg += " "+pmin;
		if( pmax == pmin )
			return msg;
		msg += ":"+(pmax - pmin);
		return msg;
	}

}