package sx.properties;


/**
 * Possible sides of some entity (e.g. widget)
 *
 */
@:enum abstract Side (String) to String
{

    var Left   = 'left';
    var Right  = 'right';
    var Top    = 'top';
    var Bottom = 'bottom';

}//abstract Side