package test;

class TestMath {
    public function new() {}

    public function run() {
        testClamp();
        testIsPOT();
        testNextPOT();
        testLerp();
        testInverseLerp();
        testFmt();
    }

    function testClamp() {
        Assert.equals(5.0, hxd.Math.clamp(5.0, 0.0, 10.0));
        Assert.equals(0.0, hxd.Math.clamp(-1.0, 0.0, 10.0));
        Assert.equals(10.0, hxd.Math.clamp(15.0, 0.0, 10.0));
        Assert.equals(0.5, hxd.Math.clamp(0.5)); // Default range: 0 to 1
        Assert.equals(0.0, hxd.Math.clamp(-0.2));
        Assert.equals(1.0, hxd.Math.clamp(1.5));
    }

    function testIsPOT() {
        Assert.isTrue(hxd.Math.isPOT(1));
        Assert.isTrue(hxd.Math.isPOT(2));
        Assert.isTrue(hxd.Math.isPOT(4));
        Assert.isTrue(hxd.Math.isPOT(1024));
        Assert.isFalse(hxd.Math.isPOT(3));
        Assert.isFalse(hxd.Math.isPOT(5));
        Assert.isFalse(hxd.Math.isPOT(1000));
    }

    function testNextPOT() {
        Assert.equals(0, hxd.Math.nextPOT(0));
        Assert.equals(1, hxd.Math.nextPOT(1));
        Assert.equals(2, hxd.Math.nextPOT(2));
        Assert.equals(4, hxd.Math.nextPOT(3));
        Assert.equals(4, hxd.Math.nextPOT(4));
        Assert.equals(8, hxd.Math.nextPOT(5));
        Assert.equals(1024, hxd.Math.nextPOT(1000));
    }

    function testLerp() {
        Assert.floatEquals(5.0, hxd.Math.lerp(0.0, 10.0, 0.5));
        Assert.floatEquals(0.0, hxd.Math.lerp(0.0, 10.0, 0.0));
        Assert.floatEquals(10.0, hxd.Math.lerp(0.0, 10.0, 1.0));
        Assert.floatEquals(2.5, hxd.Math.lerp(0.0, 10.0, 0.25));
    }

    function testInverseLerp() {
        Assert.floatEquals(0.5, hxd.Math.inverseLerp(0.0, 10.0, 5.0));
        Assert.floatEquals(0.0, hxd.Math.inverseLerp(0.0, 10.0, 0.0));
        Assert.floatEquals(1.0, hxd.Math.inverseLerp(0.0, 10.0, 10.0));
        Assert.floatEquals(0.25, hxd.Math.inverseLerp(0.0, 10.0, 2.5));
    }

    function testFmt() {
        // fmt rounds to 4 significant digits (or standard forms)
        Assert.floatEquals(1.234, hxd.Math.fmt(1.234));
        Assert.floatEquals(1.234, hxd.Math.fmt(1.2343));
        Assert.floatEquals(0.0, hxd.Math.fmt(1e-12));
    }
}
