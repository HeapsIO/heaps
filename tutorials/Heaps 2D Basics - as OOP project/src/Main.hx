
import levels.*;

import hxd.Res;

class Main extends hxd.App {
    static function main() {
        new Main();
        Res.initLocal();
    }

    var mylevel : Grasslands_01;

    override function init() {

        mylevel = new Grasslands_01( this );

        setScene( mylevel );

    }

    override function update(dt:Float) {

        mylevel.update();

    }

}