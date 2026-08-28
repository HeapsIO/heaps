package test;

class TestRunner {
    public static function main() {
        Sys.println("Starting test execution...");
        
        var mathTests = new TestMath();
        mathTests.run();

        var segmentsTests = new TestSegments();
        segmentsTests.run();

        var shaderCacheTests = new TestShaderCache();
        shaderCacheTests.run();
        
        Sys.println("Successes: " + Assert.successes);
        if (Assert.failures > 0) {
            Sys.println("Failures: " + Assert.failures);
            Sys.exit(1);
        } else {
            Sys.println("All tests passed!");
            Sys.exit(0);
        }
    }
}
