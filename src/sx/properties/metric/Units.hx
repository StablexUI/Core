package sx.properties.metric;



/**
 * Possible metrical measurements units.
 *
 */
@:enum abstract Units (String) to String
{

    var Pixel   = 'px';
    var Percent = 'pct';
    var Dip     = 'dip';

}//abstract Units