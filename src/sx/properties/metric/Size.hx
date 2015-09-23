package sx.properties.metric;

import sx.exceptions.LockedPropertyException;
import sx.properties.Orientation;
import sx.properties.metric.Units;

using sx.Sx;


/**
 * Represents metrical size of something
 *
 */
class Size
{
    /** Use this when it's required to provide some size instance, but you don't have one. */
    static public var zeroProperty (get,never) : Size;

    /** Device independent pixels */
    public var dip (get,set) : Float;
    /** Physical pixels */
    public var px (get,set) : Float;
    /** Percentage. Used if this size is calculated as a proportional part of some other value. */
    public var pct (get,set) : Float;

    /** Currently selected units. */
    public var units (default,null) : Units = Dip;

    /**
     * Method which should return `Size` instance which will be used as a source for percentage calculations.
     * E.g. if `pctSource()` returns instance of `10px` and `this` is `5px` then `this.pct` will be equal to `50`.
     * If this method returns `null` then zero-sized dummy Size instance is used.
     *
     * This property can be set one time only. Trying to change it will throw `sx.exceptions.LockedPropertyException`
     */
    @:noCompletion
    public var pctSource (default,set) : Null<Void->Size>;
    /**
     * This handler is invoked every time size value is changed.
     * Accepts Size instance which is reporting changes now as an argument.
     *
     * This property can be set one time only. Trying to change it will throw `sx.exceptions.LockedPropertyException`
     *
     * @param   Size    Changed instance
     * @param   Units   Units used before this change
     * @param   Float   Value before this change
     */
    @:noCompletion
    public var onChange (default,set) : Null<Size->Units->Float->Void>;

    /** Current value */
    private var __value : Float = 0;
    /** Orientation. E.g. for `left`,`right` and `width` it's horizontal. */
    private var __orientation : Orientation;


    /**
     * Constructor
     *
     */
    public function new (orientation:Orientation = Vertical) : Void
    {
        __orientation = orientation;
    }


    /**
     * Check if this size defines vertical dimension
     */
    public inline function isVertical () : Bool
    {
        return __orientation == Vertical;
    }


    /**
     * Check if this size defines horizontal dimension
     */
    public inline function isHorizontal () : Bool
    {
        return __orientation == Horizontal;
    }


    /**
     * Get string representation
     *
     */
    public function toString () : String
    {
        return __value + '' + units;
    }


    /**
     * Returns result of `pctSource()` or zero-sized stub if `pctSource` is not set.
     */
    private function __pctSource () : Size
    {
        return (pctSource == null ? zeroProperty : pctSource());
    }


    /**
     * Invokes `onChange()` if `onChange` is not null
     */
    private function __invokeOnChange (previousUnits:Units, previousValue:Float) : Void
    {
        if (onChange != null) onChange(this, previousUnits, previousValue);
    }


    /**
     * Getter `dip`
     *
     */
    private function get_dip () : Float
    {
        return switch (units) {
            case Dip     : __value;
            case Pixel   : __value.toDip();
            case Percent : __pctSource().dip * __value * 0.01;
        }
    }


    /**
     * Getter `px`
     *
     */
    private function get_px () : Float
    {
        return switch (units) {
            case Dip     : __value.toPx();
            case Pixel   : __value;
            case Percent : __pctSource().px * __value * 0.01;
        }
    }


    /**
     * Getter `pct`
     *
     */
    private function get_pct () : Float
    {
        return switch (units) {
            case Dip :
                var dip = __pctSource().dip;
                (dip == 0 ? 100 : __value / dip * 100);
            case Pixel   :
                var px = __pctSource().px;
                (px == 0 ? 100 : __value / px * 100);
            case Percent :
                __value;
        }
    }


    /**
     * Setter `dip`
     *
     */
    private function set_dip (value:Float) : Float
    {
        var previousUnits = units;
        var previousValue = __value;

        units = Dip;
        __value = value;

        __invokeOnChange(previousUnits, previousValue);

        return value;
    }


    /**
     * Setter `px`
     *
     */
    private function set_px (value:Float) : Float
    {
        var previousUnits = units;
        var previousValue = __value;

        units = Pixel;
        __value = value;

        __invokeOnChange(previousUnits, previousValue);

        return value;
    }


    /**
     * Setter `pct`
     *
     */
    private function set_pct (value:Float) : Float
    {
        var previousUnits = units;
        var previousValue = __value;

        units = Percent;
        __value = value;

        __invokeOnChange(previousUnits, previousValue);

        return value;
    }


    /**
     * Setter `onChange`
     */
    private function set_onChange (value:Size->Units->Float->Void) : Size->Units->Float->Void
    {
        if (onChange != null) {
            throw new LockedPropertyException();
        }

        return onChange = value;
    }


    /**
     * Setter `pctSource`
     */
    private function set_pctSource (value:Void->Size) : Void->Size
    {
        if (pctSource != null) {
            throw new LockedPropertyException();
        }

        return pctSource = value;
    }


    /** Getters */
    static private inline function get_zeroProperty () return Size_Internal_ZeroSize.instance;

}//class Size



/**
 * For internal usage in case `pctSource` of Size is `null`
 *
 */
private class Size_Internal_ZeroSize extends Size
{
    static public var instance : Size = new Size_Internal_ZeroSize();

    /**
     * Getters & setters
     *
     */
    override private function get_px () return 0;
    override private function get_pct () return 0;
    override private function get_dip () return 0;
    override private function set_px (v) return v;
    override private function set_pct (v) return v;
    override private function set_dip (v) return v;

}//class Size_Internal_ZeroSize