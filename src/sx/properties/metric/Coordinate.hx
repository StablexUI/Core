package sx.properties.metric;

import sx.exceptions.LockedPropertyException;
import sx.properties.metric.Units;




/**
 * Used for `left`, `right`, `top`, `bottom` and other such properties.
 *
 */
class Coordinate extends Size
{
    /**
     * Owner's width or height
     *
     * This property can be set one time only. Trying to change it will throw `sx.exceptions.LockedPropertyException`
     */
    public var ownerSize (default,set) : Null<Void->Size>;
    /**
     * Paired property.
     * E.g. if this is `left` then `pair` should contain `right` instance.
     *
     * This property can be set one time only. Trying to change it will throw `sx.exceptions.LockedPropertyException`
     */
    public var pair (default,set) : Void->Coordinate;
    /** If owner's position is determined by this coordinate */
    public var selected (default,null) : Bool = false;


    /**
     * Mark this coordinate as determining owner's position.
     */
    public inline function select () : Void
    {
        if (!selected) {
            selected = true;
            pair().selected = false;
        }
    }


    /**
     * Returns `ownerSize()` result or zero-sized property if `ownerSize` is not set
     */
    private function __ownerSize () : Size
    {
        return (ownerSize == null ? Size.zeroProperty : ownerSize());
    }


    /**
     * Getter `px`.
     */
    override private function get_px () : Float {
        if (selected) return super.get_px();
        return __pctSource().px - pair().px - __ownerSize().px;
    }


    /**
     * Getter `pct`.
     */
    override private function get_pct () : Float {
        if (selected) return super.get_pct();
        return __pctSource().pct - pair().pct - __ownerSize().pct;
    }


    /**
     * Getter `dip`.
     */
    override private function get_dip () : Float {
        if (selected) return super.get_dip();
        return __pctSource().dip - pair().dip - __ownerSize().dip;
    }


    /**
     * If this property is changed, select it.
     */
    override private function __invokeOnChange (previousUnits:Units, previousValue:Float) : Void
    {
        select();
        super.__invokeOnChange(previousUnits, previousValue);
    }


    /**
     * Setter `ownerSize`
     */
    private function set_ownerSize (value:Void->Size) : Void->Size
    {
        if (ownerSize != null) {
            throw new LockedPropertyException();
        }

        return ownerSize = value;
    }


    /**
     * Setter `pair`
     */
    private function set_pair (value:Void->Coordinate) : Void->Coordinate
    {
        if (pair != null) {
            throw new LockedPropertyException();
        }

        return pair = value;
    }

}//class Coordinate