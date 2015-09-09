package sx.geom;

import sx.exceptions.InvalidArgumentException;


/**
 * Points with x and y cooridnates
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
    public function new () : Void
    {

    }


    /**
     * Set coordinates for this point
     */
    public inline function set (x:Float, y:Float) : Void
    {
        this.x = x;
        this.y = y;
    }


    /**
     * Copy current point
     */
    public inline function clone () : Point
    {
        var copy = new Point();
        copy.x = x;
        copy.y = y;

        return copy;
    }

}//class Point