package sx.properties.abstracts;


import sx.properties.metric.Coordinate;
import sx.properties.metric.Units;


/**
 * Abstract to be able to write numbers directly to `Coordinate` instances.
 *
 */
@:forward(dip,pct,px,units,orientation,onChange,isVertical,isHorizontal,toString,selected)
abstract ACoordinate (Coordinate) from Coordinate to Coordinate
{
    /** Object pool */
    static private var __pool : Array<WeakCoordinate> = [];


    /**
     * Create from numbers
     */
    @:access(sx.properties.metric.Coordinate.weak)
    @:from static private function fromFloat (v:Float) : ACoordinate
    {
        var weakCoordinate = __pool.pop();
        if (weakCoordinate == null) weakCoordinate = new WeakCoordinate();
        weakCoordinate.weak = true;
        weakCoordinate.dip = v;

        return weakCoordinate;
    }


    /** Convert to */
    @:to private inline function toFloat () : Float return this.dip;


    /**
     * ACoordinate
     */
    @:op(A += B) static private inline function AincB (a:ACoordinate, b:ACoordinate) return a.dip += b.dip;
    @:op(A -= B) static private inline function AdecB (a:ACoordinate, b:ACoordinate) return a.dip -= b.dip;
    @:op(A *= B) static private inline function AmulIncB (a:ACoordinate, b:ACoordinate) return a.dip *= b.dip;
    @:op(A /= B) static private inline function AdevDecB (a:ACoordinate, b:ACoordinate) return a.dip /= b.dip;
    @:op(A + B) static private inline function AplusB (a:ACoordinate, b:ACoordinate) return a.dip + b.dip;
    @:op(A - B) static private inline function AminusB (a:ACoordinate, b:ACoordinate) return a.dip - b.dip;
    @:op(A * B) static private inline function AmulB (a:ACoordinate, b:ACoordinate) return a.dip * b.dip;
    @:op(A / B) static private inline function AdivB (a:ACoordinate, b:ACoordinate) return a.dip / b.dip;
    @:op(A < B) static private inline function AltB (a:ACoordinate, b:ACoordinate) return a.dip < b.dip;
    @:op(A <= B) static private inline function AlteB (a:ACoordinate, b:ACoordinate) return a.dip <= b.dip;
    @:op(A != B) static private inline function AneB (a:ACoordinate, b:ACoordinate) return a.dip != b.dip;
    @:op(A >= B) static private inline function AgteB (a:ACoordinate, b:ACoordinate) return a.dip >= b.dip;
    @:op(A > B) static private inline function AgtB (a:ACoordinate, b:ACoordinate) return a.dip > b.dip;
    @:op(A == B) static private inline function AeqB (a:ACoordinate, b:ACoordinate) return a.dip == b.dip;

    @:op(A ++) static private inline function Ainc (a:ACoordinate) return a.dip ++;
    @:op(A --) static private inline function Bdec (a:ACoordinate) return a.dip --;


    /**
     * Float
     */
    @:op(A += B) static private inline function AincBf (a:ACoordinate, b:Float) return a.dip += b;
    @:op(A -= B) static private inline function AdecBf (a:ACoordinate, b:Float) return a.dip -= b;
    @:op(A *= B) static private inline function AmulIncBf (a:ACoordinate, b:Float) return a.dip *= b;
    @:op(A /= B) static private inline function AdevDecBf (a:ACoordinate, b:Float) return a.dip /= b;
    @:op(A + B) static private inline function AplusBf (a:ACoordinate, b:Float) return a.dip + b;
    @:op(A - B) static private inline function AminusBf (a:ACoordinate, b:Float) return a.dip - b;
    @:op(A * B) static private inline function AmulBf (a:ACoordinate, b:Float) return a.dip * b;
    @:op(A / B) static private inline function AdivBf (a:ACoordinate, b:Float) return a.dip / b;
    @:op(A < B) static private inline function AltBf (a:ACoordinate, b:Float) return a.dip < b;
    @:op(A <= B) static private inline function AlteBf (a:ACoordinate, b:Float) return a.dip <= b;
    @:op(A != B) static private inline function AneBf (a:ACoordinate, b:Float) return a.dip != b;
    @:op(A >= B) static private inline function AgteBf (a:ACoordinate, b:Float) return a.dip >= b;
    @:op(A > B) static private inline function AgtBf (a:ACoordinate, b:Float) return a.dip > b;
    @:op(A == B) static private inline function AeqBf (a:ACoordinate, b:Float) return a.dip == b;

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