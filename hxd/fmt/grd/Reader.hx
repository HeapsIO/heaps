package hxd.fmt.grd;
import hxd.fmt.grd.Data;

// http://www.tonton-pixel.com/Photoshop%20Additional%20File%20Formats/gradients-file-format.html

class Reader {
	var i : haxe.io.Input;
	var version : Int;

	public function new(i) {
		this.i = i;
		i.bigEndian = true;
	}

	function readUnicode(input : haxe.io.Input, len : Int) : String {
		var res = "";
		for (i in 0...len - 1) res += String.fromCharCode(input.readInt16());
		input.readInt16();
		return res;
	}

	function parseValue(i : haxe.io.Input) : Dynamic {
		var type = i.readString(4);
		var value : Dynamic;
		switch (type) {
			case "Objc" : value = parseObj (i);
            case "VlLs" : value = parseList(i);
            case "doub" : value = i.readDouble();
            case "UntF" : i.readString(4); value = i.readDouble();
            case "TEXT" : value = readUnicode(i, i.readInt32());
            case "enum" : value = parseEnum(i);
            case "long" : value = i.readInt32();
            case "bool" : value = i.readByte();
            case "tdtd" : var len = i.readInt32(); value = { length : len, value : i.read(len) };
			default     : throw "Unhandled type \"" + type + "\"";
		}
		return value;
	}

	function parseObj(i : haxe.io.Input) : Dynamic {
		var len  = i.readInt32(); if (len == 0) len = 4;
		var name = readUnicode(i, len);

		len = i.readInt32(); if (len == 0) len = 4;
		var type = i.readString(len);

		var obj = { name : name, type : type }

		var numProperties = i.readInt32();
		for (pi in 0...numProperties) {
			len = i.readInt32(); if (len == 0) len = 4;
			var key = i.readString(len);
			var si = key.indexOf(" ");
			if (si > 0) key = key.substring(0, si);
			Reflect.setField(obj, key, parseValue(i));
		}

		return obj;
	}

	function parseList(i : haxe.io.Input) {
		var res = new Array<Dynamic>();
		var len = i.readInt32();
		for (li in 0...len)
			res.push(parseValue(i));
		return res;
	}

	function parseEnum(i : haxe.io.Input) {
		var len  = i.readInt32(); if (len == 0) len = 4;
		var type = i.readString(len);
		len = i.readInt32(); if (len == 0) len = 4;
		var value = i.readString(len);
		return { type : type, value : value };
	}

	public function read() : Data {
		var d = new Data();
		i.read(32);      // skip header
		i.readString(4); // main object

		var list = cast(parseValue(i), Array<Dynamic>);
		for (obj in list) {
			var obj = obj.Grad;
			var grd = new Gradient();

			var nm : String = obj.Nm;
			grd.name = nm.substring(nm.indexOf("=") + 1);
			grd.interpolation = obj.Intr;

			createColorStops        (obj.Clrs, grd.colorStops);
			createTransparencyStops (obj.Trns, grd.transparencyStops);
			createGradientStops     (grd.colorStops, grd.transparencyStops, grd.gradientStops);

			d.set(grd.name, grd);
		}
		return d;
	}

	function createColorStops(list : Array<Dynamic>, out : Array<ColorStop>) {
		for (e in list) {
			var color = Color.RGB(0, 0, 0);
			var type  : ColorStopType;
			switch(e.Type.value) {
				case "UsrS" : type = User;
				case "BckC" : type = Background;
				case "FrgC" : type = Foreground;
				default : throw "unhalndled color stop type : " + e.Type.value;
			}

			if (type == User) {
				switch(e.Clr.type) {
					case "RGBC" : color = Color.RGB(e.Clr.Rd, e.Clr.Grn,  e.Clr.Bl);
					case "HSBC" : color = Color.HSB(e.Clr.H,  e.Clr.Strt, e.Clr.Brgh);
					default : //throw "unhandled color type : " + e.Clr.type;
				}
			}

			var stop = new ColorStop();
			stop.color = color;
			stop.location = e.Lctn;
			stop.midpoint = e.Mdpn;
			stop.type = type;
			out.push(stop);
		}
	}

	function createTransparencyStops(list : Array<Dynamic>, out : Array<TransparencyStop>) {
		for (e in list) {
			var stop = new TransparencyStop();
			stop.opacity = e.Opct;
			stop.location = e.Lctn;
			stop.midpoint = e.Mdpn;
			out.push(stop);
		}
	}

	function createGradientStops(
		clrs : Array<ColorStop>,
		trns : Array<TransparencyStop>,
		out : Array<GradientStop>) {

		for (clr in clrs) {
			var stop = new GradientStop();
			stop.opacity = getOpacity(clr, trns);
			stop.colorStop = clr;
			out.push(stop);
		}
	}

	function getOpacity(clr : ColorStop, trns : Array<TransparencyStop>) {
		var index = -1;
		for (i in 0...trns.length) {
			var t = trns[i];
			if (t.location >= clr.location) {
				index = i;
				break;
			}
		}

		if (index == 0) return trns[0].opacity;
		if (index <  0) return trns[trns.length - 1].opacity;

		var prev = trns[index - 1];
		var next = trns[index];
		var w = next.location - prev.location;
		var h = next.opacity - prev.opacity;

		if (w == 0) return prev.opacity;
		var m = h / w;
		var b = prev.opacity - (m * prev.location);
		return m * clr.location + b;
	}
}
