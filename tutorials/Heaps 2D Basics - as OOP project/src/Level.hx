
import gameobjects.*;

import hxd.Res;

class Level extends h2d.Scene {

    public var walls   : Array< { bounds:h2d.col.Bounds, type:Int } > = [];
    public var background_tilegroup : h2d.TileGroup;

    // contained GameObjects
    public var player  : Player;
    public var coins   : Array< Coin > = [];
    public var enemies : Array< Enemy > = [];

    public function new() {
        super();
        background_tilegroup = new h2d.TileGroup( Res.tilegroup.toTile(), this );
    }

    // returns wether obj may/will move
    public function moveObjectWhenWallFree( obj:h2d.Object, x:Float, y:Float ) {
        if( checkForWalls( x, y ) == false ){ // meaning: walls found = false
            obj.setPosition( x, y );
            return true;
        }
        return false;
    }

    public function checkForWalls( x:Float, y:Float ){
        var point = new h2d.col.Point( x, y );
        for( w in walls ){
            if( w.bounds.contains( point ) && w.type==1 )
                return true;
        }
        return false;
    }

    public function create_wall( x:Float, y:Float ) {
        var tile = Res.tilegroup.toTile().grid( 16 );
        var chosenTile = tile[1][0];
        chosenTile.scaleToSize( 32, 32 ); // making tile bigger on screen
        background_tilegroup.add( x, y, chosenTile );

        var bounds = new h2d.col.Bounds();
        bounds.set( x, y, 32, 32 );

        walls.push( // adds our wall object: an anonymous structure/object
            {
                bounds: bounds,
                type:   1
            } );
    }

    //
    //              other stuff
    //
    public function wrapInsideScene( obj:h2d.Object ){
        if( obj.x < 0 )
            obj.x = this.width;
        if( obj.y < 0 )
            obj.y = this.height;
        if( obj.x > this.width )
            obj.x = 0;
        if( obj.y > this.height )
            obj.y = 0;
    }

    public function assignRandomPositionInScene( obj : h2d.Object ) {
        obj.setPosition( hxd.Math.random(this.width), hxd.Math.random(this.height) );
    }
}