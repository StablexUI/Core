package sx.properties;

import sx.geom.Unit;




/**
 * Used for `left`, `right`, `top`, `bottom` and other such properties.
 *
 */
class Coordinate extends Size
{
    /** Owner's width or height */
    public var ownerSize : Void->Size;
    /**
     * Paired property.
     * E.g. if this is `left` then `pair` should contain `right` instance.
     */
    public var pair : Void->Coordinate;
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
     * Getter `px`.
     */
    override private function get_px () : Float {
        if (selected) return super.get_px();
        return __getPctSource().px - pair().px - ownerSize().px;
    }


    /**
     * Getter `pct`.
     */
    override private function get_pct () : Float {
        if (selected) return super.get_pct();
        return __getPctSource().pct - pair().pct - ownerSize().pct;
    }


    /**
     * Getter `dip`.
     */
    override private function get_dip () : Float {
        if (selected) return super.get_dip();
        return __getPctSource().dip - pair().dip - ownerSize().dip;
    }


    /**
     * If this property is changed, select it.
     */
    override private function __invokeOnChange (previousUnits:Unit, previousValue:Float) : Void
    {
        select();
        super.__invokeOnChange(previousUnits, previousValue);
    }

}//class Coordinate