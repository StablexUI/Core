package sx.geom;



/**
 * Possible metrical measurements units.
 *
 */
@:enum abstract Unit (String) to String {

    var Pixel   = 'px';
    var Percent = 'pct';
    var Dip     = 'dip';

}//abstract Unit