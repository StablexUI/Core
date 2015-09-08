package sx.geom;

import sx.exceptions.InvalidArgumentException;
import sx.geom.Matrix;
import sx.geom.Point;


/**
 * Minimal required matrix implementation.
 */
abstract Matrix (Array<Float>) to Array<Float>
{
    static private inline var A = 0;
    static private inline var B = 1;
    static private inline var C = 2;
    static private inline var D = 3;
    static private inline var TX = 4;
    static private inline var TY = 5;

    /** a */
    public var a (get,set) : Float;
    /** b */
    public var b (get,set) : Float;
    /** c */
    public var c (get,set) : Float;
    /** d */
    public var d (get,set) : Float;
    /** tx */
    public var tx (get,set) : Float;
    /** ty */
    public var ty (get,set) : Float;


    /**
     * Constructor
     */
    public function new (data:Array<Float> = null) : Void
    {
        if (data != null) {
            if (data.length != 6) throw new InvalidArgumentException('Wrong length of matrix data. Should be 6 elements.');
        } else {
            data = [1.0, 0, 0, 1, 0, 0];
        }

        this = data;
    }


    /**
     * Reset matrix
     */
    public inline function identity () : Void
    {
        this[A]  = 1;
        this[B]  = 0;
        this[C]  = 0;
        this[D]  = 1;
        this[TX] = 0;
        this[TY] = 0;
    }


    /**
     * Concatenate with `matrix`
     */
    public function concat (matrix:Matrix) : Void
    {
        var a : Float = this[A] * matrix.a + this[B] * matrix.c;
        this[B] = this[A] * matrix.b + this[B] * matrix.d;
        this[A] = a;

        var c : Float = this[C] * matrix.a + this[D] * matrix.c;
        this[D] = this[C] * matrix.b + this[D] * matrix.d;

        this[C] = c;

        var tx   = this[TX] * matrix.a + this[TY] * matrix.c + matrix.tx;
        this[TY] = this[TX] * matrix.b + this[TY] * matrix.d + matrix.ty;
        this[TX] = tx;
    }


    /**
     * Translate matrix
     */
    public inline function translate (x:Float, y:Float) : Void
    {
        this[TX] += x;
        this[TY] += y;
    }


    /**
     * Apply scale transformation
     */
    public inline function scale (scaleX:Float, scaleY:Float) : Void
    {
        this[A]  *= scaleX;
        this[B]  *= scaleY;
        this[C]  *= scaleX;
        this[D]  *= scaleY;
        this[TX] *= scaleX;
        this[TY] *= scaleY;
    }


    /**
     * Apply rotation (radians)
     */
    public function rotate (angle:Float) : Void
    {
        var cos : Float = Math.cos(angle);
        var sin : Float = Math.sin(angle);

        var a1 : Float = this[A] * cos - this[B] * sin;
        this[B] = this[A] * sin + this[B] * cos;
        this[A] = a1;

        var c1 : Float = this[C] * cos - this[D] * sin;
        this[D] = this[C] * sin + this[D] * cos;
        this[C] = c1;

        var tx1 : Float = this[TX] * cos - this[TY] * sin;
        this[TY] = this[TX] * sin + this[TY] * cos;
        this[TX] = tx1;
    }


    /**
     * Apply matrix transformations to `point`
     * Modifies `point` in place.
     */
    public inline function transformPoint (point:Point) : Void
    {
        point.x = point.x * this[A] + point.y * this[C] + this[TX];
        point.y = point.x * this[B] + point.y * this[D] + this[TY];
    }


    /**
     * Invert this matrix
     */
    public function invert () : Void
    {
        var norm = this[A] * this[D] - this[B] * this[C];

        if (norm == 0) {
            this[A]  = this[B] = this[C] = this[D] = 0;
            this[TX] = -this[TX];
            this[TY] = -this[TY];

        } else {
            norm    = 1.0 / norm;
            var a1  = this[D] * norm;
            this[D] = this[A] * norm;
            this[A] = a1;
            this[B] *= -norm;
            this[C] *= -norm;

            var tx1  = - this[A] * this[TX] - this[C] * this[TY];
            this[TY] = - this[B] * this[TX] - this[D] * this[TY];
            this[TX] = tx1;
        }
    }


    /**
     * Copy current matrix
     */
    public inline function clone () : Matrix
    {
        return new Matrix(this.copy());
    }


    /** Getters */
    private inline function get_tx () return this[TX];
    private inline function get_ty () return this[TY];
    private inline function get_a () return this[A];
    private inline function get_b () return this[B];
    private inline function get_c () return this[C];
    private inline function get_d () return this[D];

    /** Setters */
    private inline function set_a (v) return this[A] = v;
    private inline function set_b (v) return this[B] = v;
    private inline function set_c (v) return this[C] = v;
    private inline function set_d (v) return this[D] = v;
    private inline function set_tx (v) return this[TX] = v;
    private inline function set_ty (v) return this[TY] = v;

}//abstract Matrix