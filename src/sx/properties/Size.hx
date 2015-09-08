package sx.properties;

import sx.geom.Unit;

using sx.Sx;


/**
 * Represents metrical size of something
 *
 */
class Size
{
    /** Device independent pixels */
    public var dip (get,set) : Float;
    /** Physical pixels */
    public var px (get,set) : Float;
    /** Percentage. Used if this size is calculated as a proportional part of some other value. */
    public var pct (get,set) : Float;

    /** Currently selected units. */
    public var units (default,null) : Unit = Dip;

    /**
     * Method which should return `Size` instance which will be used as a source for percentage calculations.
     * E.g. if `this.pctSource(this)` returns instance of `10px` and `this` is `5px` then `this.pct` will be equal to `50`.
     * If this method returns `null` then zero-sized dummy Size instance is used.
     */
    public var pctSource : Size->Null<Size>;
    /**
     * This handler is invoked every time size value is changed.
     * Accepts Size instance which is reporting changes now as an argument.
     */
    public var onChange : Size->Void;

    /** Current value */
    private var zz_value : Float = 0;



    /**
     * Constructor
     *
     */
    public function new () : Void
    {

    }


    /**
     * Get string representation
     *
     */
    public function toString () : String
    {
        return zz_value + '' + units;
    }


    /**
     * Returns result of `pctSource(this)` or zero-sized stub if `pctSource` returned null.
     */
    private function getPctSource () : Size
    {
        var source = (pctSource == null ? null : pctSource(this));

        return (source == null ? Size_Internal_ZeroSize.instance : source);
    }


    /**
     * Invokes `onChange(this)` if `onChange` is not null
     */
    private function invokeOnChange () : Void
    {
        if (onChange != null) onChange(this);
    }


    /**
     * Getter `dip`
     *
     */
    private function get_dip () : Float
    {
        return switch (units) {
            case Dip     : zz_value;
            case Pixel   : zz_value.toDip();
            case Percent : getPctSource().dip * zz_value * 0.01;
        }
    }


    /**
     * Getter `px`
     *
     */
    private function get_px () : Float
    {
        return switch (units) {
            case Dip     : zz_value.toPx();
            case Pixel   : zz_value;
            case Percent : getPctSource().px * zz_value * 0.01;
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
                var dip = getPctSource().dip;
                (dip == 0 ? 100 : zz_value / dip * 100);
            case Pixel   :
                var px = getPctSource().px;
                (px == 0 ? 100 : zz_value / px * 100);
            case Percent :
                zz_value;
        }
    }


    /**
     * Setter `dip`
     *
     */
    private function set_dip (value:Float) : Float
    {
        units = Dip;
        zz_value = value;

        invokeOnChange();

        return value;
    }


    /**
     * Setter `px`
     *
     */
    private function set_px (value:Float) : Float
    {
        units = Pixel;
        zz_value = value;

        invokeOnChange();

        return value;
    }


    /**
     * Setter `pct`
     *
     */
    private function set_pct (value:Float) : Float
    {
        units = Percent;
        zz_value = value;

        invokeOnChange();

        return value;
    }


}//class Size



/**
 * For internal usage in case `pctSource` of Size is `null`
 *
 */
private class Size_Internal_ZeroSize extends Size
{
    /** for internal usage */
    static public var instance : Size_Internal_ZeroSize = new Size_Internal_ZeroSize();


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