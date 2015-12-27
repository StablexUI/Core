package sx.properties.abstracts;


import sx.ds.ObjectPool;
import sx.properties.metric.Coordinate;
import sx.properties.metric.Size;
import sx.properties.metric.Units;


/**
 * Abstract to be able to write numbers directly to `Size` instances.
 *
 */
@:forward(dip,pct,px,units,orientation,min,max,onChange,isVertical,isHorizontal,toString)
abstract ASize (Size) from Size to Size
{
    /** Object pool */
    static private var __pool : ObjectPool<WeakSize> = new ObjectPool();


    /**
     * Create from numbers
     */
    @:access(sx.properties.metric.Size.weak)
    @:from static private function __fromFloat (v:Float) : ASize
    {
        var weakSize = __pool.pop();
        if (weakSize == null) weakSize = new WeakSize();
        weakSize.weak = true;
        weakSize.dip = v;

        return new ASize(weakSize);
    }


    /**
     * Create from `Coordinate` instance
     */
    @:from static private function __fromSize (coordinate:Coordinate) : ASize
    {
        return __fromFloat(coordinate.dip);
    }


    /** Convert to */
    @:to private inline function __toFloat () : Float return this.dip;


    private inline function new (size:Size)
    {
        this = size;
    }


    /**
     * ASize
     */
    @:op(A += B) static private inline function __aIncB (a:ASize, b:ASize) return a.dip += b.dip;
    @:op(A -= B) static private inline function __aDecB (a:ASize, b:ASize) return a.dip -= b.dip;
    @:op(A *= B) static private inline function __aMulIncB (a:ASize, b:ASize) return a.dip *= b.dip;
    @:op(A /= B) static private inline function __aDevDecB (a:ASize, b:ASize) return a.dip /= b.dip;
    @:op(A + B) static private inline function __aPlusB (a:ASize, b:ASize) return a.dip + b.dip;
    @:op(A - B) static private inline function __aMinusB (a:ASize, b:ASize) return a.dip - b.dip;
    @:op(A * B) static private inline function __aMulB (a:ASize, b:ASize) return a.dip * b.dip;
    @:op(A / B) static private inline function __aDivB (a:ASize, b:ASize) return a.dip / b.dip;
    @:op(A < B) static private inline function __aLtB (a:ASize, b:ASize) return a.dip < b.dip;
    @:op(A <= B) static private inline function __aLteB (a:ASize, b:ASize) return a.dip <= b.dip;
    @:op(A != B) static private inline function __aNeB (a:ASize, b:ASize) return a.dip != b.dip;
    @:op(A >= B) static private inline function __aGteB (a:ASize, b:ASize) return a.dip >= b.dip;
    @:op(A > B) static private inline function __aGtB (a:ASize, b:ASize) return a.dip > b.dip;
    @:op(A == B) static private inline function __aEqB (a:ASize, b:ASize) return a.dip == b.dip;
    @:op(-A) static private inline function __minusA (a:ASize) return -a.dip;

    @:op(A++) static private inline function __aInc (a:ASize) return a.dip++;
    @:op(A--) static private inline function __bDec (a:ASize) return a.dip--;


    /**
     * Float
     */
    @:op(A += B) static private inline function __aIncBf (a:ASize, b:Float) return a.dip += b;
    @:op(A -= B) static private inline function __aDecBf (a:ASize, b:Float) return a.dip -= b;
    @:op(A *= B) static private inline function __aMulIncBf (a:ASize, b:Float) return a.dip *= b;
    @:op(A /= B) static private inline function __aDevDecBf (a:ASize, b:Float) return a.dip /= b;
    @:op(A + B) static private inline function __aPlusBf (a:ASize, b:Float) return a.dip + b;
    @:op(A - B) static private inline function __aMinusBf (a:ASize, b:Float) return a.dip - b;
    @:op(A * B) static private inline function __aMulBf (a:ASize, b:Float) return a.dip * b;
    @:op(A / B) static private inline function __aDivBf (a:ASize, b:Float) return a.dip / b;
    @:op(A < B) static private inline function __aLtBf (a:ASize, b:Float) return a.dip < b;
    @:op(A <= B) static private inline function __aLteBf (a:ASize, b:Float) return a.dip <= b;
    @:op(A != B) static private inline function __aNeBf (a:ASize, b:Float) return a.dip != b;
    @:op(A >= B) static private inline function __aGteBf (a:ASize, b:Float) return a.dip >= b;
    @:op(A > B) static private inline function __aGtBf (a:ASize, b:Float) return a.dip > b;
    @:op(A == B) static private inline function __aEqBf (a:ASize, b:Float) return a.dip == b;

}//abstract ASize


/**
 * For temporary instances used just to pass values to other instances
 *
 */
@:access(sx.properties.abstracts.ASize.__pool)
private class WeakSize extends Size
{

    /**
     * Constructor
     */
    public function new () : Void
    {
        super();
        onChange = null;
    }


    /**
     * Return to object pool
     */
    override public function dispose () : Void
    {
        ASize.__pool.push(this);
        //to prevent adding to pool multiple times
        weak = false;
    }


    /**
     * Do not dispatch any signals.
     */
    override private function __invokeOnChange (previousUnits:Units, previousValue:Float) : Void
    {

    }

}//class WeakSize