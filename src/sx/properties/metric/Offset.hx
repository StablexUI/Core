package sx.properties.metric;

import sx.exceptions.LockedPropertyException;
import sx.properties.abstracts.ACoordinate;
import sx.properties.Orientation;
import sx.properties.metric.Coordinate;
import sx.properties.metric.Size;
import sx.properties.metric.Units;
import sx.signals.Signal;


/**
 * Offset
 *
 */
class Offset
{

    /** Define offset by distance from the left border */
    public var left (get,set) : ACoordinate;
    private var __left : Coordinate;
    /** Define offset by distance from the right border */
    public var right (get,set) : ACoordinate;
    private var __right : Coordinate;
    /** Define offset by distance from the top border */
    public var top (get,set) : ACoordinate;
    private var __top : Coordinate;
    /** Define offset by distance from the bottom border */
    public var bottom (get,set) : ACoordinate;
    private var __bottom : Coordinate;

    /** Callback to invoke when offset is changed */
    public var onChange (default,null) : Signal<Void->Void>;

    /** Do not invoke `onChange` */
    private var __silentChanges : Bool = false;


    /**
     * Constructor
     */
    public function new (widthProvider:Void->Size, heightProvider:Void->Size) : Void
    {
        __left = new Coordinate(Horizontal);
        __left.pctSource = widthProvider;
        __left.onChange.add(__changed);

        __right = new Coordinate(Horizontal);
        __right.pctSource = widthProvider;
        __right.onChange.add(__changed);

        __top = new Coordinate(Vertical);
        __top.pctSource = heightProvider;
        __top.onChange.add(__changed);

        __bottom = new Coordinate(Vertical);
        __bottom.pctSource = heightProvider;
        __bottom.onChange.add(__changed);

        __left.pair      = get_right;
        __right.pair     = get_left;
        __top.pair       = get_bottom;
        __bottom.pair    = get_top;

        __left.select();
        __top.select();

        onChange = new Signal();
    }


    /**
     * Set Offset by the `x` and `y`.
     *
     * If value is greater or equal 0 and less or equal 1, it is treated as proportional of subject size.
     * E.g. `Offset.set(0.5, 0.5)` will set offset to the middle of subject object.
     *
     * In all other cases units are DIPs.
     *
     * Use this method only for hardcoded values.
     * If you need to calculate offset position, use `left`, `right`, `top` and `bottom` to avoid confusions when your
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
        onChange.dispatch();
    }


    /**
     * Called when Offset is changed.
     */
    private function __changed (property:Size, previousUnits:Units, previousValue:Float) : Void
    {
        if (!__silentChanges) onChange.dispatch();
    }


    /** Getters */
    private function get_left ()            return __left;
    private function get_right ()           return __right;
    private function get_top ()             return __top;
    private function get_bottom ()          return __bottom;

    /** Setters */
    private function set_left (v)       {__left.copyValueFrom(v); return __left;}
    private function set_right (v)      {__right.copyValueFrom(v); return __right;}
    private function set_top (v)        {__top.copyValueFrom(v); return __top;}
    private function set_bottom (v)     {__bottom.copyValueFrom(v); return __bottom;}


}//class Offset