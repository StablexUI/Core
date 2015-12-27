package sx.properties.abstracts;

import sx.properties.metric.Size;


/**
 * Abstract which allows to get values of `Size` instances, but disables assigning values to `Size` instances.
 *
 */
@:forward(orientation)
abstract ASizeGetterProxy (Size) from Size from ASize
{

    /** DIPs */
    public var dip (get, never) : Float;
    /** Pixels */
    public var px (get, never) : Float;
    /** Percent */
    public var pct (get, never) : Float;


    /** Getters */
    private inline function get_dip ()  return this.dip;
    private inline function get_px ()   return this.px;
    private inline function get_pct ()  return this.pct;


    /**
     * Float
     */
    @:op(A + B) static private inline function __aPlusBf (a:ASizeGetterProxy, b:Float) return a.dip + b;
    @:op(A - B) static private inline function __aMinusBf (a:ASizeGetterProxy, b:Float) return a.dip - b;
    @:op(A * B) static private inline function __aMulBf (a:ASizeGetterProxy, b:Float) return a.dip * b;
    @:op(A / B) static private inline function __aDivBf (a:ASizeGetterProxy, b:Float) return a.dip / b;
    @:op(A < B) static private inline function __aLtBf (a:ASizeGetterProxy, b:Float) return a.dip < b;
    @:op(A <= B) static private inline function __aLteBf (a:ASizeGetterProxy, b:Float) return a.dip <= b;
    @:op(A != B) static private inline function __aNeBf (a:ASizeGetterProxy, b:Float) return a.dip != b;
    @:op(A >= B) static private inline function __aGteBf (a:ASizeGetterProxy, b:Float) return a.dip >= b;
    @:op(A > B) static private inline function __aGtBf (a:ASizeGetterProxy, b:Float) return a.dip > b;
    @:op(A == B) static private inline function __aEqBf (a:ASizeGetterProxy, b:Float) return a.dip == b;

}//abstract ASizeGetterProxy
