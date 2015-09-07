package sx;



/**
 * Core class of StablexUI
 *
 */
class Sx
{
    /** Device independent pixels to physical pixels factor */
    static public var dipFactor : Float = 1;


    /**
    * Convert pixels to dips
    *
    */
    static public inline function toDip (px:Float) : Float {
        return px / dipFactor;
    }//function toDip()


    /**
    * Convert dips to pixels
    *
    */
    static public inline function toPx (dip:Float) : Float {
        return dip * dipFactor;
    }//function toPx()


    /**
     * Cosntructor
     *
     */
    private function new () : Void
    {

    }

}//class Sx