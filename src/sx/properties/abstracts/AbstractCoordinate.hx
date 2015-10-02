package sx.properties.abstracts;


import sx.properties.metric.Coordinate;
import sx.properties.metric.Units;


/**
 * Abstract to be able to write numbers directly to `Coordinate` instances.
 *
 */
@:forward(dip,pct,px,units,orientation,onChange,isVertical,isHorizontal,toString,selected)
abstract AbstractCoordinate (Coordinate) from Coordinate to Coordinate
{
    /** Object pool */
    static private var __pool : Array<WeakCoordinate> = [];


    /**
     * Create from numbers
     */
    @:access(sx.properties.metric.Coordinate.weak)
    @:from static private function fromFloat (v:Float) : AbstractCoordinate
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
    * Float
    */
    @:op(A += B) static private inline function AincBf (a:AbstractCoordinate, b:Float) return a.dip += b;
    @:op(A -= B) static private inline function AdecBf (a:AbstractCoordinate, b:Float) return a.dip -= b;
    @:op(A *= B) static private inline function AmulIncBf (a:AbstractCoordinate, b:Float) return a.dip *= b;
    @:op(A /= B) static private inline function AdevDecBf (a:AbstractCoordinate, b:Float) return a.dip /= b;
    @:op(A + B) static private inline function AplusBf (a:AbstractCoordinate, b:Float) return a.dip + b;
    @:op(A - B) static private inline function AminusBf (a:AbstractCoordinate, b:Float) return a.dip - b;
    @:op(A * B) static private inline function AmulBf (a:AbstractCoordinate, b:Float) return a.dip * b;
    @:op(A / B) static private inline function AdivBf (a:AbstractCoordinate, b:Float) return a.dip / b;
    @:op(A < B) static private inline function AltBf (a:AbstractCoordinate, b:Float) return a.dip < b;
    @:op(A <= B) static private inline function AlteBf (a:AbstractCoordinate, b:Float) return a.dip <= b;
    @:op(A != B) static private inline function AneBf (a:AbstractCoordinate, b:Float) return a.dip != b;
    @:op(A >= B) static private inline function AgteBf (a:AbstractCoordinate, b:Float) return a.dip >= b;
    @:op(A > B) static private inline function AgtBf (a:AbstractCoordinate, b:Float) return a.dip > b;
    @:op(A == B) static private inline function AeqBf (a:AbstractCoordinate, b:Float) return a.dip == b;


    /**
    * AbstractCoordinate
    */
    @:op(A + B) static private inline function AplusB (a:AbstractCoordinate, b:AbstractCoordinate) return a.dip + b.dip;
    @:op(A - B) static private inline function AminusB (a:AbstractCoordinate, b:AbstractCoordinate) return a.dip - b.dip;
    @:op(A * B) static private inline function AmulB (a:AbstractCoordinate, b:AbstractCoordinate) return a.dip * b.dip;
    @:op(A / B) static private inline function AdivB (a:AbstractCoordinate, b:AbstractCoordinate) return a.dip / b.dip;
    @:op(A < B) static private inline function AltB (a:AbstractCoordinate, b:AbstractCoordinate) return a.dip < b.dip;
    @:op(A <= B) static private inline function AlteB (a:AbstractCoordinate, b:AbstractCoordinate) return a.dip <= b.dip;
    @:op(A != B) static private inline function AneB (a:AbstractCoordinate, b:AbstractCoordinate) return a.dip != b.dip;
    @:op(A >= B) static private inline function AgteB (a:AbstractCoordinate, b:AbstractCoordinate) return a.dip >= b.dip;
    @:op(A > B) static private inline function AgtB (a:AbstractCoordinate, b:AbstractCoordinate) return a.dip > b.dip;
    @:op(A == B) static private inline function AeqB (a:AbstractCoordinate, b:AbstractCoordinate) return a.dip == b.dip;

    @:op(A ++) static private inline function Ainc (a:AbstractCoordinate) return a.dip ++;
    @:op(A --) static private inline function Bdec (a:AbstractCoordinate) return a.dip --;

}//abstract AbstractCoordinate



/**
 * For temporary instances used just to pass values to other instances
 *
 */
@:access(sx.properties.abstracts.AbstractCoordinate.__pool)
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
        AbstractCoordinate.__pool.push(this);
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