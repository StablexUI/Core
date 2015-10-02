package sx.properties.metric;

import sx.exceptions.LockedPropertyException;
import sx.properties.Orientation;
import sx.properties.metric.Units;
import sx.signals.Signal;

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

    /** Orientation. E.g. for `left`,`right` and `width` it's horizontal. */
    public var orientation (default,null) : Orientation;

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
     * @param   Size    Changed instance
     * @param   Units   Units used before this change
     * @param   Float   Value before this change
     */
    public var onChange (default,null) : Signal<Size->Units->Float->Void>;

    /** Indicates if this is a 'weak' instance which should be disposed immediately after usage */
    public var weak (default,null) : Bool = false;

    /** Current value */
    private var __value : Float = 0;


    /**
     * Constructor
     *
     */
    public function new (orientation:Orientation = Horizontal) : Void
    {
        this.orientation = orientation;
        onChange = new Signal();
    }


    /**
     * Check if this size defines vertical dimension
     */
    public inline function isVertical () : Bool
    {
        return orientation == Vertical;
    }


    /**
     * Check if this size defines horizontal dimension
     */
    public inline function isHorizontal () : Bool
    {
        return orientation == Horizontal;
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
     * Copy value and units from another `size` instance
     */
    public function copyValueFrom (size:Size) : Void
    {
        var previousUnits = units;
        var previousValue = __value;

        units   = size.units;
        __value = size.__value;

        if (size.weak) size.dispose();

        __invokeOnChange(previousUnits, previousValue);
    }


    /**
     * For overriding by disposable descendants
     */
    public function dispose () : Void
    {

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
        onChange.dispatch(this, previousUnits, previousValue);
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