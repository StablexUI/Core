package sx.geom;

import sx.exceptions.InvalidArgumentException;


/**
 * Points with x and y cooridnates
 *
 */
abstract Point(Array<Float>) to Array<Float>
{
    /** index of X coordinate */
    static private inline var X = 0;
    /** index of Y coordinate */
    static private inline var Y = 1;

    /** x */
    public var x (get,set) : Float;
    /** y */
    public var y (get,set) : Float;


    /**
     * Constructor
     */
    public function new (data:Array<Float> = null) : Void
    {
        if (data != null) {
            if (data.length != 2) throw new InvalidArgumentException('Wrong length of point data. Should be 2 elements.');
        } else {
            data = [0, 0];
        }

        this = data;
    }


    /**
     * Set coordinates for this point
     */
    public inline function set (x:Float, y:Float) : Void
    {
        this[X] = x;
        this[Y] = y;
    }


    /**
     * Copy current point
     */
    public inline function clone () : Point
    {
        return new Point(this.copy());
    }


    /** Getters */
    private inline function get_x () return this[X];
    private inline function get_y () return this[Y];

    /** Setters */
    private inline function set_x (v) return this[X] = v;
    private inline function set_y (v) return this[Y] = v;

}//abstract Point