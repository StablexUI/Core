package sx.properties.metric;

import sx.exceptions.LockedPropertyException;
import sx.properties.abstracts.ASize;
import sx.properties.Orientation;
import sx.properties.metric.Units;
import sx.signals.Signal;

using sx.tools.PropertiesTools;
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

    /**
     * Minimal possible value for this size.
     * If you previously set this constraint, but now want to remove it, then you need
     * to assign `null` or `Math.NEGATIVE_INFINITY` to this property.
     */
    public var min (get,set) : ASize;
    private var __min : Size;
    /**
     * Maximal possible value for this size.
     * If you previously set this constraint, but now want to remove it, then you need
     * to assign `null` or `Math.POSITIVE_INFINITY` to this property.
     */
    public var max (get,set) : ASize;
    private var __max : Size;

    /** Currently selected units. */
    public var units (default,null) : Units = Dip;

    /** Orientation. E.g. for `left`,`right` and `width` it's horizontal. */
    public var orientation (default,null) : Orientation;

    /**
     * Method which should return `Size` instance which will be used as a source for percentage calculations.
     * E.g. if `pctSource()` returns instance of `10px` and `this` is `5px` then `this.pct` will be equal to `50`.
     * If this method returns `null` then zero-sized dummy Size instance is used.
     */
    public var pctSource : Null<Void->Size>;
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
     *
     * Returns current instance.
     */
    public function copyValueFrom (size:Size) : Size
    {
        var previousUnits = units;
        var previousValue = __value;

        units   = size.units;
        __value = size.__value;

        if (size.weak) size.dispose();

        __invokeOnChange(previousUnits, previousValue);

        return this;
    }


    /**
     * Indicates if minimal allowed value is set
     */
    public function hasMin () : Bool
    {
        return __min != null;
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
     * Make sure current value does not violate `min` and `max` constraints
     */
    private function __constraintChanged (constraint:Size, previousUnits:Units, previousValue:Float) : Void
    {
        if (constraint == __min) {
            var minValue = __min.get(units);
            if (__value < minValue) {
                var previous = __value;
                __value = minValue;
                __invokeOnChange(units, previous);
            }

            return;
        }

        if (constraint == __max) {
            var maxValue = __max.get(units);
            if (__value > maxValue) {
                var previous = __value;
                __value = maxValue;
                __invokeOnChange(units, previous);
            }

            return;
        }
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
        if (__min != null && __min.dip > value) {
            __value = __min.dip;
        } else if (__max != null && __max.dip < value) {
            __value = __max.dip;
        } else {
            __value = value;
        }

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
        if (__min != null && __min.px > value) {
            __value = __min.px;
        } else if (__max != null && __max.px < value) {
            __value = __max.px;
        } else {
            __value = value;
        }

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
        if (__min != null && __min.pct > value) {
            __value = __min.pct;
        } else if (__max != null && __max.pct < value) {
            __value = __max.pct;
        } else {
            __value = value;
        }

        __invokeOnChange(previousUnits, previousValue);

        return value;
    }


    /**
     * Getter `min`
     */
    private function get_min () : ASize
    {
        if (__min == null) {
            __min = new Size(orientation);
            __min.pctSource = __pctSource;
            __min.__value = Math.NEGATIVE_INFINITY;
            __min.onChange.add(__constraintChanged);
        }

        return __min;
    }


    /**
     * Setter `min`
     */
    private function set_min (value:Size) : ASize
    {
        if (value == null) {
            if (__min != null) {
                switch (__min.units) {
                    case Dip     : __min.dip = Math.NEGATIVE_INFINITY;
                    case Pixel   : __min.px = Math.NEGATIVE_INFINITY;
                    case Percent : __min.pct = Math.NEGATIVE_INFINITY;
                }
            }
        } else {
            (min:Size).copyValueFrom(value);
        }

        return value;
    }


    /**
     * Getter `max`
     */
    private function get_max () : ASize
    {
        if (__max == null) {
            __max = new Size(orientation);
            __max.pctSource = __pctSource;
            __max.__value = Math.POSITIVE_INFINITY;
            __max.onChange.add(__constraintChanged);
        }

        return __max;
    }


    /**
     * Setter `max`
     */
    private function set_max (value:Size) : ASize
    {
        if (value == null) {
            if (__max != null) {
                switch (__max.units) {
                    case Dip     : __max.dip = Math.NEGATIVE_INFINITY;
                    case Pixel   : __max.px = Math.NEGATIVE_INFINITY;
                    case Percent : __max.pct = Math.NEGATIVE_INFINITY;
                }
            }
        } else {
            (max:Size).copyValueFrom(value);
        }

        return value;
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