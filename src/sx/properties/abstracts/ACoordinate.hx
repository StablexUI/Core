package sx.properties.abstracts;


import sx.ds.ObjectPool;
import sx.properties.metric.Coordinate;
import sx.properties.metric.Size;
import sx.properties.metric.Units;


/**
 * Abstract to be able to write numbers directly to `Coordinate` instances.
 *
 */
@:forward(dip,pct,px,units,orientation,min,max,onChange,isVertical,isHorizontal,toString,selected,select)
abstract ACoordinate (Coordinate) from Coordinate to Coordinate
{
    /** Object pool */
    static private var __pool : ObjectPool<WeakCoordinate> = new ObjectPool();


    /**
     * Create from numbers
     */
    @:access(sx.properties.metric.Coordinate.weak)
    @:from static private function __fromFloat (v:Float) : ACoordinate
    {
        var weakCoordinate = __pool.pop();
        if (weakCoordinate == null) weakCoordinate = new WeakCoordinate();
        weakCoordinate.weak = true;
        weakCoordinate.dip = v;

        return new ACoordinate(weakCoordinate);
    }


    /**
     * Create from `Size` instance
     */
    @:from static private function __fromSize (size:Size) : ACoordinate
    {
        return __fromFloat(size.dip);
    }


    /** Convert to */
    @:to private inline function __toFloat () : Float return this.dip;


    private inline function new (coordinate:Coordinate)
    {
        this = coordinate;
    }


    /**
     * ACoordinate
     */
    @:op(A += B) static private inline function __aIncB (a:ACoordinate, b:ACoordinate) return a.dip += b.dip;
    @:op(A -= B) static private inline function __aDecB (a:ACoordinate, b:ACoordinate) return a.dip -= b.dip;
    @:op(A *= B) static private inline function __aMulIncB (a:ACoordinate, b:ACoordinate) return a.dip *= b.dip;
    @:op(A /= B) static private inline function __aDevDecB (a:ACoordinate, b:ACoordinate) return a.dip /= b.dip;
    @:op(A + B) static private inline function __aPlusB (a:ACoordinate, b:ACoordinate) return a.dip + b.dip;
    @:op(A - B) static private inline function __aMinusB (a:ACoordinate, b:ACoordinate) return a.dip - b.dip;
    @:op(A * B) static private inline function __aMulB (a:ACoordinate, b:ACoordinate) return a.dip * b.dip;
    @:op(A / B) static private inline function __aDivB (a:ACoordinate, b:ACoordinate) return a.dip / b.dip;
    @:op(A < B) static private inline function __aLtB (a:ACoordinate, b:ACoordinate) return a.dip < b.dip;
    @:op(A <= B) static private inline function __aLteB (a:ACoordinate, b:ACoordinate) return a.dip <= b.dip;
    @:op(A != B) static private inline function __aNeB (a:ACoordinate, b:ACoordinate) return a.dip != b.dip;
    @:op(A >= B) static private inline function __aGteB (a:ACoordinate, b:ACoordinate) return a.dip >= b.dip;
    @:op(A > B) static private inline function __aGtB (a:ACoordinate, b:ACoordinate) return a.dip > b.dip;
    @:op(A == B) static private inline function __aEqB (a:ACoordinate, b:ACoordinate) return a.dip == b.dip;
    @:op(-A) static private inline function __minusA (a:ACoordinate) return -a.dip;

    @:op(A++) static private inline function __aInc (a:ACoordinate) return a.dip++;
    @:op(A--) static private inline function __aDec (a:ACoordinate) return a.dip--;


    /**
     * Float
     */
    @:op(A += B) static private inline function __aIncBf (a:ACoordinate, b:Float) return a.dip += b;
    @:op(A -= B) static private inline function __aDecBf (a:ACoordinate, b:Float) return a.dip -= b;
    @:op(A *= B) static private inline function __aMulIncBf (a:ACoordinate, b:Float) return a.dip *= b;
    @:op(A /= B) static private inline function __aDevDecBf (a:ACoordinate, b:Float) return a.dip /= b;
    @:op(A + B) static private inline function __aPlusBf (a:ACoordinate, b:Float) return a.dip + b;
    @:op(A - B) static private inline function __aMinusBf (a:ACoordinate, b:Float) return a.dip - b;
    @:op(A * B) static private inline function __aMulBf (a:ACoordinate, b:Float) return a.dip * b;
    @:op(A / B) static private inline function __aDivBf (a:ACoordinate, b:Float) return a.dip / b;
    @:op(A < B) static private inline function __aLtBf (a:ACoordinate, b:Float) return a.dip < b;
    @:op(A <= B) static private inline function __aLteBf (a:ACoordinate, b:Float) return a.dip <= b;
    @:op(A != B) static private inline function __aNeBf (a:ACoordinate, b:Float) return a.dip != b;
    @:op(A >= B) static private inline function __aGteBf (a:ACoordinate, b:Float) return a.dip >= b;
    @:op(A > B) static private inline function __aGtBf (a:ACoordinate, b:Float) return a.dip > b;
    @:op(A == B) static private inline function __aEqBf (a:ACoordinate, b:Float) return a.dip == b;

}//abstract ACoordinate


/**
 * For temporary instances used just to pass values to other instances
 *
 */
@:access(sx.properties.abstracts.ACoordinate.__pool)
private class WeakCoordinate extends Coordinate
{

    /**
     * Constructor
     */
    public function new () : Void
    {
        super();
        selected = true;
        onChange = null;
    }


    /**
     * Return to object pool
     */
    override public function dispose () : Void
    {
        ACoordinate.__pool.push(this);
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