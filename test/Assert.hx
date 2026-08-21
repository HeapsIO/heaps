package test;

class Assert {
    public static var failures:Int = 0;
    public static var successes:Int = 0;

    public static function isTrue(value:Bool, ?pos:haxe.PosInfos) {
        if (!value) {
            failures++;
            trace("FAIL: Expected true, got false at " + pos.fileName + ":" + pos.lineNumber);
        } else {
            successes++;
        }
    }

    public static function isFalse(value:Bool, ?pos:haxe.PosInfos) {
        if (value) {
            failures++;
            trace("FAIL: Expected false, got true at " + pos.fileName + ":" + pos.lineNumber);
        } else {
            successes++;
        }
    }

    public static function equals<T>(expected:T, actual:T, ?pos:haxe.PosInfos) {
        if (expected != actual) {
            failures++;
            trace("FAIL: Expected " + expected + ", got " + actual + " at " + pos.fileName + ":" + pos.lineNumber);
        } else {
            successes++;
        }
    }

    public static function floatEquals(expected:Float, actual:Float, epsilon:Float = 1e-6, ?pos:haxe.PosInfos) {
        var diff = expected - actual;
        if (diff < 0) diff = -diff;
        if (diff > epsilon) {
            failures++;
            trace("FAIL: Expected " + expected + ", got " + actual + " (diff " + diff + " > epsilon " + epsilon + ") at " + pos.fileName + ":" + pos.lineNumber);
        } else {
            successes++;
        }
    }
}
