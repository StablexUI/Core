package sx.backend.dummy;


/**
 * Dummy points with x and y cooridnates
 *
 */
class Point
{
    /** x */
    public var x : Float;
    /** y */
    public var y : Float;


    /**
     * Constructor
     */
    public function new (x:Float = 0, y:Float = 0) : Void
    {
        this.x = x;
        this.y = y;
    }


}//class Point