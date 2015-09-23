package sx.properties.metric;

import sx.exceptions.LockedPropertyException;
import sx.properties.Orientation;
import sx.properties.metric.Coordinate;
import sx.properties.metric.Size;
import sx.properties.metric.Units;


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

    /**
     * Callback to invoke when origin point is changed
     *
     * This property can be set one time only. Trying to change it will throw `sx.exceptions.LockedPropertyException`
     */
    @:noCompletion
    public var onChange (default,set) : Null<Void->Void>;

    /** Do not invoke `onChange` */
    private var __silentChanges : Bool = false;


    /**
     * Constructor
     */
    public function new (widthProvider:Void->Size, heightProvider:Void->Size) : Void
    {
        left = new Coordinate(Horizontal);
        left.pctSource = widthProvider;
        left.onChange  = __changed;

        right = new Coordinate(Horizontal);
        right.pctSource = widthProvider;
        right.onChange  = __changed;

        top = new Coordinate(Vertical);
        top.pctSource = heightProvider;
        top.onChange  = __changed;

        bottom = new Coordinate(Vertical);
        bottom.pctSource = heightProvider;
        bottom.onChange  = __changed;

        left.pair      = get_right;
        right.pair     = get_left;
        top.pair       = get_bottom;
        bottom.pair    = get_top;

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
    private function __changed (property:Size, previousUnits:Units, previousValue:Float) : Void
    {
        if (!__silentChanges && onChange != null) onChange();
    }


    /**
     * Setter `onChange`
     */
    private function set_onChange (value:Void->Void) : Void->Void
    {
        if (onChange != null) {
            throw new LockedPropertyException();
        }

        return onChange = value;
    }


    /** Getters */
    private function get_left ()            return left;
    private function get_right ()           return right;
    private function get_top ()             return top;
    private function get_bottom ()          return bottom;

}//class Origin