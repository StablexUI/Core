package sx.properties.abstracts;


import sx.properties.metric.Size;
import sx.properties.metric.Units;


/**
 * Abstract to be able to write numbers directly to `Size` instances.
 *
 */
@:forward(dip,pct,px,units,orientation,onChange,isVertical,isHorizontal,toString)
abstract AbstractSize (Size) from Size to Size
{
    /** Object pool */
    static private var __pool : Array<WeakSize> = [];


    /**
     * Create from numbers
     */
    @:access(sx.properties.metric.Size.weak)
    @:from static private function fromFloat (v:Float) : AbstractSize
    {
        var weakSize = __pool.pop();
        if (weakSize == null) weakSize = new WeakSize();
        weakSize.weak = true;
        weakSize.dip = v;

        return weakSize;
    }


    /** Convert to */
    @:to private inline function toFloat () : Float return this.dip;


    /**
    * Float
    */
    @:op(A += B) static private inline function AincBf (a:AbstractSize, b:Float) : AbstractSize {
        a.dip += b;
        return a;
    }
    @:op(A -= B) static private inline function AdecBf (a:AbstractSize, b:Float) : AbstractSize {
        a.dip -= b;
        return a;
    }
    @:op(A *= B) static private inline function AmulIncBf (a:AbstractSize, b:Float) : AbstractSize {
        a.dip *= b;
        return a;
    }
    @:op(A /= B) static private inline function AdevDecBf (a:AbstractSize, b:Float)  : AbstractSize {
        a.dip /= b;
        return a;
    }
    @:op(A + B) static private inline function AplusBf (a:AbstractSize, b:Float) return a.dip + b;
    @:op(A - B) static private inline function AminusBf (a:AbstractSize, b:Float) return a.dip - b;
    @:op(A * B) static private inline function AmulBf (a:AbstractSize, b:Float) return a.dip * b;
    @:op(A / B) static private inline function AdivBf (a:AbstractSize, b:Float) return a.dip / b;
    @:op(A < B) static private inline function AltBf (a:AbstractSize, b:Float) return a.dip < b;
    @:op(A <= B) static private inline function AlteBf (a:AbstractSize, b:Float) return a.dip <= b;
    @:op(A != B) static private inline function AneBf (a:AbstractSize, b:Float) return a.dip != b;
    @:op(A >= B) static private inline function AgteBf (a:AbstractSize, b:Float) return a.dip >= b;
    @:op(A > B) static private inline function AgtBf (a:AbstractSize, b:Float) return a.dip > b;
    @:op(A == B) static private inline function AeqBf (a:AbstractSize, b:Float) return a.dip == b;


    /**
    * AbstractSize
    */
    @:op(A + B) static private inline function AplusB (a:AbstractSize, b:AbstractSize) return a.dip + b.dip;
    @:op(A - B) static private inline function AminusB (a:AbstractSize, b:AbstractSize) return a.dip - b.dip;
    @:op(A * B) static private inline function AmulB (a:AbstractSize, b:AbstractSize) return a.dip * b.dip;
    @:op(A / B) static private inline function AdivB (a:AbstractSize, b:AbstractSize) return a.dip / b.dip;
    @:op(A < B) static private inline function AltB (a:AbstractSize, b:AbstractSize) return a.dip < b.dip;
    @:op(A <= B) static private inline function AlteB (a:AbstractSize, b:AbstractSize) return a.dip <= b.dip;
    @:op(A != B) static private inline function AneB (a:AbstractSize, b:AbstractSize) return a.dip != b.dip;
    @:op(A >= B) static private inline function AgteB (a:AbstractSize, b:AbstractSize) return a.dip >= b.dip;
    @:op(A > B) static private inline function AgtB (a:AbstractSize, b:AbstractSize) return a.dip > b.dip;
    @:op(A == B) static private inline function AeqB (a:AbstractSize, b:AbstractSize) return a.dip == b.dip;

    @:op(A ++) static private inline function Ainc (a:AbstractSize) return a.dip ++;
    @:op(A --) static private inline function Bdec (a:AbstractSize) return a.dip --;

}//abstract AbstractSize



/**
 * For temporary instances used just to pass values to other instances
 *
 */
@:access(sx.properties.abstracts.AbstractSize.__pool)
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
        AbstractSize.__pool.push(this);
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