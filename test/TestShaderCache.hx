package test;

import h3d.impl.ShaderCache;
import haxe.io.Bytes;

class TestShaderCache {
    public function new() {}

    public function run() {
        testShaderCacheInMemoryWithAllowSaveFalse();
    }

    function testShaderCacheInMemoryWithAllowSaveFalse() {
        // Create a mock/temporary cache file path.
        var cacheFile = "temp_shader_cache.data";
        var cache = new ShaderCache(cacheFile);
        
        // Turn off disk persistence.
        cache.allowSave = false;
        cache.keepSource = true;

        var shaderSource = "
            @input float4 position;
            void main() {
                output.position = position;
            }
        ";
        var compiledBinary = Bytes.ofString("MOCK_COMPILED_SHADER_BINARY");

        // Save the compiled shader. It should cache in-memory.
        cache.saveCompiledShader(shaderSource, compiledBinary);

        // Try to resolve the shader binary from the cache.
        var resolved = cache.resolveShaderBinary(shaderSource);

        Assert.isTrue(resolved != null);
        if (resolved != null) {
            Assert.equals(compiledBinary.toString(), resolved.toString());
        }
    }
}
