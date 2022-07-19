
import gameobjects.*;

class LevelLoader {

    public static function loadLevel( level_string:String, startX:Float=0, startY:Float=0, level : Level ) {
        var fieldSize = 32;
        var x = 0;
        var y = 0;
        // local function (to calculate the real position in the scene)
        var positionInScene = ( x:Int, y:Int ) -> {
            var sx = (x *fieldSize) + startX;
            var sy = (y *fieldSize) + startY;
            return {
                x: sx,
                y: sy
            };
        };
        for( i in 0...level_string.length ){
            var char = level_string.charAt( i );
            switch( char ){
                case "\n":
                    y++;
                    x=0;
                case "o":
                    // coin
                    var coin = new Coin( level );
                    var posInSc = positionInScene( x, y );
                    coin.setPosition( posInSc.x +16, posInSc.y +16 ); // +16 because coin sprite is centered
                case "#":
                    // wall
                    var posInSc = positionInScene( x, y );
                    level.create_wall( posInSc.x, posInSc.y );
                case ".":
                    // dirt
                    var posInSc = positionInScene( x, y );
                    var tilegroup = level.background_tilegroup;
                    var tile = tilegroup.tile.grid(16)[0][1]; tile.scaleToSize(32,32);
                    tilegroup.add( posInSc.x, posInSc.y, tile );
                case "~":
                    // water
                    var posInSc = positionInScene( x, y );
                    var tilegroup = level.background_tilegroup;
                    var tile = tilegroup.tile.grid(16)[1][1]; tile.scaleToSize(32,32);
                    tilegroup.add( posInSc.x, posInSc.y, tile );
                default:
            }
            x++;
        }
    }
}