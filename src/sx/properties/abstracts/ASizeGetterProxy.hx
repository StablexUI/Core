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
    @:op(A + B) static private inline function AplusBf (a:ASizeGetterProxy, b:Float) return a.dip + b;
    @:op(A - B) static private inline function AminusBf (a:ASizeGetterProxy, b:Float) return a.dip - b;
    @:op(A * B) static private inline function AmulBf (a:ASizeGetterProxy, b:Float) return a.dip * b;
    @:op(A / B) static private inline function AdivBf (a:ASizeGetterProxy, b:Float) return a.dip / b;
    @:op(A < B) static private inline function AltBf (a:ASizeGetterProxy, b:Float) return a.dip < b;
    @:op(A <= B) static private inline function AlteBf (a:ASizeGetterProxy, b:Float) return a.dip <= b;
    @:op(A != B) static private inline function AneBf (a:ASizeGetterProxy, b:Float) return a.dip != b;
    @:op(A >= B) static private inline function AgteBf (a:ASizeGetterProxy, b:Float) return a.dip >= b;
    @:op(A > B) static private inline function AgtBf (a:ASizeGetterProxy, b:Float) return a.dip > b;
    @:op(A == B) static private inline function AeqBf (a:ASizeGetterProxy, b:Float) return a.dip == b;

}//abstract ASizeGetterProxy
