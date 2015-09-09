package sx.geom;

import sx.exceptions.InvalidArgumentException;
import sx.geom.Matrix;
import sx.geom.Point;


/**
 * Minimal matrix implementation.
 */
class Matrix
{
    /** a */
    public var a : Float = 1;
    /** b */
    public var b : Float = 0;
    /** c */
    public var c : Float = 0;
    /** d */
    public var d : Float = 1;
    /** tx */
    public var tx : Float = 0;
    /** ty */
    public var ty : Float = 0;


    /**
     * Constructor
     */
    public function new () : Void
    {

    }


    /**
     * Reset matrix
     */
    public inline function identity () : Void
    {
        a  = 1;
        b  = 0;
        c  = 0;
        d  = 1;
        tx = 0;
        ty = 0;
    }


    /**
     * Concatenate with `matrix`
     */
    public function concat (matrix:Matrix) : Void
    {
        var a1 = a * matrix.a + b * matrix.c;
        b = a * matrix.b + b * matrix.d;

        a = a1;

        var c1 = c * matrix.a + d * matrix.c;
        d = c * matrix.b + d * matrix.d;

        c = c1;

        var tx1 = tx * matrix.a + ty * matrix.c + matrix.tx;
        ty = tx * matrix.b + ty * matrix.d + matrix.ty;

        tx = tx1;
    }


    /**
     * Translate matrix
     */
    public inline function translate (x:Float, y:Float) : Void
    {
        tx += x;
        ty += y;
    }


    /**
     * Apply scale transformation
     */
    public inline function scale (scaleX:Float, scaleY:Float) : Void
    {
        a  *= scaleX;
        b  *= scaleY;
        c  *= scaleX;
        d  *= scaleY;
        tx *= scaleX;
        ty *= scaleY;
    }


    /**
     * Apply rotation (radians clockwise)
     */
    public function rotate (angle:Float) : Void
    {
        var cos : Float = Math.cos(angle);
        var sin : Float = Math.sin(angle);

        var a1 : Float = a * cos - b * sin;
        b = a * sin + b * cos;
        a = a1;

        var c1 : Float = c * cos - d * sin;
        d = c * sin + d * cos;
        c = c1;

        var tx1 : Float = tx * cos - ty * sin;
        ty = tx * sin + ty * cos;
        tx = tx1;
    }


    /**
     * Apply matrix transformations to `point`
     * Modifies `point` in place.
     */
    public inline function transformPoint (point:Point) : Void
    {
        point.x = point.x * a + point.y * c + tx;
        point.y = point.x * b + point.y * d + ty;
    }


    /**
     * Invert this matrix
     */
    public function invert () : Void
    {
        var norm = a * d - b * c;

        if (norm == 0) {
            a  = b = c = d = 0;
            tx = -tx;
            ty = -ty;

        } else {
            norm    = 1.0 / norm;
            var a1  = d * norm;
            d = a * norm;
            a = a1;
            b *= -norm;
            c *= -norm;

            var tx1  = - a * tx - c * ty;
            ty = - b * tx - d * ty;
            tx = tx1;
        }
    }


    /**
     * Copy current matrix
     */
    public inline function clone () : Matrix
    {
        var copy = new Matrix();
        copy.a = a;
        copy.b = b;
        copy.c = c;
        copy.d = d;
        copy.tx = tx;
        copy.ty = ty;

        return copy;
    }

}//class Matrix