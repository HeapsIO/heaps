package h3d.pass;

import h3d.mat.Texture;

private class GenerateMipMapsShader extends h3d.shader.ScreenShader {
    static var SRC = {
        @param var src : Sampler2D;

        final offsets : Array<Vec2, 4> = [
            vec2(0, 0),
            vec2(1, 0),
            vec2(0, 1),
            vec2(1, 1)
        ];

		function fragment() {
            var destPos = floor(fragCoord.xy);
            var srcPos = destPos * 2.0;
            var sum = vec4(0.0);
            for ( i in 0...4 ) {
                var pos = srcPos + offsets[i];
                sum += src.fetch(ivec2(pos));
            }
            var outColor = sum / 4.0;
            output.color = outColor;
		}
	}
}

class MipMaps extends ScreenFx<GenerateMipMapsShader> {
    public function new() {
		super(new GenerateMipMapsShader());
	}

    public function apply( from : h3d.mat.Texture ) {
        var texCopy = new Texture(from.width, from.height, [Target, Writable, MipMapped, ManualMipMapGen], from.format);
        texCopy.filter = Nearest;
        texCopy.mipMap = Nearest;

        for ( lvl in 1...from.mipLevels ) {
            var src = lvl & 1 == 0 ? texCopy : from;
            var target = lvl & 1 == 0 ? from : texCopy;
            src.startingMip = lvl - 1;
            shader.src = src;
            engine.pushTarget(target, 0, lvl);
            render();
            engine.popTarget();

            if ( target == texCopy ) {
                texCopy.startingMip = lvl;
                h3d.pass.Copy.run(texCopy, from, None, null, 0, lvl);
            }
        }

        from.startingMip = 0;
    }

    public static function generate( from : h3d.mat.Texture ) {
        if ( from == null )
            return;

        var engine = h3d.Engine.getCurrent();

        var inst : MipMaps = @:privateAccess engine.resCache.get(MipMaps);
		if( inst == null ) {
			inst = new MipMaps();
			@:privateAccess engine.resCache.set(MipMaps, inst);
		}

		return inst.apply(from);
    }
}