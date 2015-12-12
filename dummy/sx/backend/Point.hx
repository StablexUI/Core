package sx.backend;


/**
 * Should be replaced with native backend Point class.
 * Point is expected to have decimal `x` and `y` properties measured in pixels and a constructor accepting `x` and `y`.
 */
typedef Point = sx.backend.dummy.Point;


/**
This is minimal required Point implementation:

class Point
{
    public var x : Float = 0;
    public var y : Float = 0;

    public function new (x:Float = 0, y:Float = 0) : Void
    {
        this.x = x;
        this.y = y;
    }
}
*/