package sx.properties;

import sx.properties.Coordinate;
import sx.properties.Size;
import sx.geom.Unit;


/**
 * Origin point
 *
 */
class Origin
{

    /** Define origin point by distance from the left border */
    public var left (default,null) : Coordinate;
    /** Define origin point by distance from the right border */
    public var right (default,null) : Coordinate;
    /** Define origin point by distance from the top border */
    public var top (default,null) : Coordinate;
    /** Define origin point by distance from the bottom border */
    public var bottom (default,null) : Coordinate;

    /** Callback to invoke when origin point is changed */
    public var onChange : Void->Void;

    /** Do not invoke `onChange` */
    private var __silentChanges : Bool = false;


    /**
     * Constructor
     */
    public function new (widthProvider:Void->Null<Size>, heightProvider:Void->Null<Size>) : Void
    {
        left = new Coordinate();
        left.pctSource = widthProvider;
        left.onChange  = __changed;

        right = new Coordinate();
        right.pctSource = widthProvider;
        right.onChange  = __changed;

        top = new Coordinate();
        top.pctSource = heightProvider;
        top.onChange  = __changed;

        bottom = new Coordinate();
        bottom.pctSource = heightProvider;
        bottom.onChange  = __changed;

        left.pair      = get_right;
        right.pair     = get_left;
        top.pair       = get_bottom;
        bottom.pair    = get_top;
        left.ownerSize = right.ownerSize = Size.zeroProperty;
        top.ownerSize  = bottom.ownerSize = Size.zeroProperty;

        left.select();
        top.select();
    }


    /**
     * Set origin by the `x` and `y`.
     *
     * If value is greater or equal 0 and less or equal 1, it is treated as proportional of subject size.
     * E.g. `origin.set(0.5, 0.5)` will set origin point to the middle of subject object.
     *
     * In all other cases units are DIPs.
     *
     * Use this method only for hardcoded values.
     * If you need to calculate origin position, use `left`, `right`, `top` and `bottom` to avoid confusions when your
     * calculated values unexpectedly hit or do not hit [0...1] interval.
     */
    public function set (x:Float, y:Float) : Void
    {
        __silentChanges = true;

        if (0 <= x && x <= 1) {
            left.pct = x * 100;
        } else {
            left.dip = x;
        }
        if (0 <= y && y <= 1) {
            top.pct = y * 100;
        } else {
            top.dip = y;
        }

        __silentChanges = false;
        if (onChange != null) onChange();
    }


    /**
     * Called when origin is changed.
     */
    private function __changed (changed:Size, previousUnits:Unit, previousValue:Float) : Void
    {
        if (!__silentChanges && onChange != null) onChange();
    }


    /** Getters */
    private function get_left ()            return left;
    private function get_right ()           return right;
    private function get_top ()             return top;
    private function get_bottom ()          return bottom;

}//class Origin