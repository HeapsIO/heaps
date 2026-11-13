import hxd.impl.ImeText;

class ImeTextTest {
	static var fails = 0;

	static function eq<T>( name : String, got : T, exp : T ) {
		if( got != exp ) {
			fails++;
			Sys.println("FAIL " + name + ": got " + got + ", expected " + exp);
		}
	}

	static function main() {
		var cps = ImeText.codePoints("a你😀");
		eq("cp.len", cps.length, 3);
		eq("cp0", cps[0], 0x61);
		eq("cp1", cps[1], 0x4F60);
		eq("cp2", cps[2], 0x1F600);

		eq("idx utf8 astral", ImeText.toUtf16Index("a😀b", 2, false), 3);
		eq("idx utf16 astral", ImeText.toUtf16Index("a😀b", 3, true), 3);
		eq("idx utf16 mid-pair snaps", ImeText.toUtf16Index("a😀b", 2, true), 3);
		eq("idx negative", ImeText.toUtf16Index("a😀b", -1, true), 4);
		eq("idx mid-pair", ImeText.toUtf16Index("😀", 1, true), 2);
		eq("idx clamp", ImeText.toUtf16Index("ab", 9, false), 2);

		eq("len astral", ImeText.toUtf16Length("a😀b", 1, 1, false), 2);
		eq("len negative", ImeText.toUtf16Length("ab", 0, -1, true), 0);

		eq("event toString", new hxd.Event(ETextComposition).toString().indexOf("composition=") >= 0, true);

		if( fails > 0 ) {
			Sys.println("ImeTextTest: " + fails + " failure(s)");
			Sys.exit(1);
		}
		Sys.println("ImeTextTest: all passed");
	}
}
