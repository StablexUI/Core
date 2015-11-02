package sx.properties.abstracts;


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
    static private var __pool : Array<WeakSize> = [];


    /**
     * Create from numbers
     */
    @:access(sx.properties.metric.Size.weak)
    @:from static private function fromFloat (v:Float) : ASize
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
    @:from static private function fromSize (coordinate:Coordinate) : ASize
    {
        return fromFloat(coordinate.dip);
    }


    /** Convert to */
    @:to private inline function toFloat () : Float return this.dip;


    private inline function new (size:Size)
    {
        this = size;
    }


    /**
     * ASize
     */
    @:op(A += B) static private inline function AincB (a:ASize, b:ASize) return a.dip += b.dip;
    @:op(A -= B) static private inline function AdecB (a:ASize, b:ASize) return a.dip -= b.dip;
    @:op(A *= B) static private inline function AmulIncB (a:ASize, b:ASize) return a.dip *= b.dip;
    @:op(A /= B) static private inline function AdevDecB (a:ASize, b:ASize) return a.dip /= b.dip;
    @:op(A + B) static private inline function AplusB (a:ASize, b:ASize) return a.dip + b.dip;
    @:op(A - B) static private inline function AminusB (a:ASize, b:ASize) return a.dip - b.dip;
    @:op(A * B) static private inline function AmulB (a:ASize, b:ASize) return a.dip * b.dip;
    @:op(A / B) static private inline function AdivB (a:ASize, b:ASize) return a.dip / b.dip;
    @:op(A < B) static private inline function AltB (a:ASize, b:ASize) return a.dip < b.dip;
    @:op(A <= B) static private inline function AlteB (a:ASize, b:ASize) return a.dip <= b.dip;
    @:op(A != B) static private inline function AneB (a:ASize, b:ASize) return a.dip != b.dip;
    @:op(A >= B) static private inline function AgteB (a:ASize, b:ASize) return a.dip >= b.dip;
    @:op(A > B) static private inline function AgtB (a:ASize, b:ASize) return a.dip > b.dip;
    @:op(A == B) static private inline function AeqB (a:ASize, b:ASize) return a.dip == b.dip;

    @:op(A ++) static private inline function Ainc (a:ASize) return a.dip ++;
    @:op(A --) static private inline function Bdec (a:ASize) return a.dip --;


    /**
     * Float
     */
    @:op(A += B) static private inline function AincBf (a:ASize, b:Float) return a.dip += b;
    @:op(A -= B) static private inline function AdecBf (a:ASize, b:Float) return a.dip -= b;
    @:op(A *= B) static private inline function AmulIncBf (a:ASize, b:Float) return a.dip *= b;
    @:op(A /= B) static private inline function AdevDecBf (a:ASize, b:Float) return a.dip /= b;
    @:op(A + B) static private inline function AplusBf (a:ASize, b:Float) return a.dip + b;
    @:op(A - B) static private inline function AminusBf (a:ASize, b:Float) return a.dip - b;
    @:op(A * B) static private inline function AmulBf (a:ASize, b:Float) return a.dip * b;
    @:op(A / B) static private inline function AdivBf (a:ASize, b:Float) return a.dip / b;
    @:op(A < B) static private inline function AltBf (a:ASize, b:Float) return a.dip < b;
    @:op(A <= B) static private inline function AlteBf (a:ASize, b:Float) return a.dip <= b;
    @:op(A != B) static private inline function AneBf (a:ASize, b:Float) return a.dip != b;
    @:op(A >= B) static private inline function AgteBf (a:ASize, b:Float) return a.dip >= b;
    @:op(A > B) static private inline function AgtBf (a:ASize, b:Float) return a.dip > b;
    @:op(A == B) static private inline function AeqBf (a:ASize, b:Float) return a.dip == b;

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