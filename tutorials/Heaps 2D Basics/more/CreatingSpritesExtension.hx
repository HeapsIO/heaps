package more;

//
//
//          O T H E R   S T U F F 
//
//          (might/will help beginners later when advancing after tutorial)
//
//

class CreatingSpritesExtension {

    public static function createSprite_animated_extended( image_resource:hxd.res.Image, speed, chosenFrames:Array<Int>, parent, forAllFrames:(frame:h2d.Tile)->h2d.Tile ) : h2d.Anim {
        var height = image_resource.getSize().height;
        var autoCount = Math.floor( image_resource.getSize().width / height );
        var allFrames  = image_resource.toTile().split( autoCount );
        for( f in allFrames ){
            f = forAllFrames( f );
        }
        var frames = [ for( i in chosenFrames ) allFrames[i] ];
        return new h2d.Anim( frames, speed, parent );
    }
}

//
//      test class
//

class Sample {

    var player : h2d.Object; // dummy reference
    var parent : h2d.Object; // dummy reference (might/should be s2d)

    function changePlayerAnimation_byExtended( chosenFrames:Array<Int>, looksLeft:Bool=false ) {
        var old_x = player.x;
        var old_y = player.y;
        var old_sprite = player;

        player = CreatingSpritesExtension.createSprite_animated_extended( hxd.Res.blue_strip, 5, chosenFrames, parent,
            (frame)->{
                frame.setCenterRatio();
                if( looksLeft )
                    frame.flipX();
                return frame;
            }
            ); 

        player.setPosition( old_x, old_y );
        old_sprite.remove();
    }
}