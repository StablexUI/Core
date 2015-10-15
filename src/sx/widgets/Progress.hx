package sx.widgets;

import sx.properties.abstracts.APadding;
import sx.properties.metric.Padding;
import sx.properties.metric.Size;
import sx.properties.metric.Units;
import sx.properties.Orientation;
import sx.signals.Signal;
import sx.widgets.Widget;

using sx.tools.PropertiesTools;
using sx.tools.WidgetTools;


/**
 * Progress bar
 *
 */
class Progress extends Widget
{

    /** Minimum value */
    public var min (default,set) : Float = 0;
    /** Maximum value */
    public var max (default,set) : Float = 100;
    /** Current value */
    public var value (default,set) : Float = 0;
    /**
     * Whether this progress bar should grow horizontally or vertically.
     * Horizontal bar grows from left to right by default.
     * Vertical bar grows from top to bottom by default.
     * If you want horizontally oriented bar to grow from right to left, call `progress.bar.right.select()`.
     * If you want vertically oriented bar to grow from bottom to top, call `progress.bar.bottom.select()`.
     * The same appliable to `left` and `top`.
     */
    public var orientation (default,set) : Orientation = Horizontal;

    /** Padding between edges of this widget and `bar` widget */
    public var padding (get,set) : APadding;
    private var __padding : Padding;

    /** Widget for a bar */
    public var bar (get,set) : Widget;
    private var __bar : Widget;

    /** Dispatched when `value` is changed */
    public var onChange (get,never) : Signal<Progress->Void>;
    private var __onChange : Signal<Progress->Void>;

    /** Flag used to avoid recursive `__updateBar()` calls */
    private var __updatingBar : Bool = false;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();

        __padding = new Padding();
        __padding.ownerWidth  = get_width;
        __padding.ownerHeight = get_height;
        __padding.onComponentsChange.add(__paddingChanged);

        onResize.add(__sizeChanged);
    }


    /**
     * Change `bar` widget
     */
    private inline function __setBar (newBar:Widget) : Void
    {
        if (__bar != null) {
            removeChild(__bar);
        }

        __bar = newBar;
        addChildAt(newBar, 0);

        __updateBar();
    }


    /**
     * Update `bar` size and position according to current value and padding
     */
    private function __updateBar () : Void
    {
        if (__updatingBar) return;
        __updatingBar = true;

        __updateBarSize();
        __updateBarPosition();

        __updatingBar = false;
    }


    /**
     * Update `bar` size according to current `value`
     */
    private inline function __updateBarSize () : Void
    {
        if (initialized) {
            //set size along bar growth direction
            var barSize  = bar.size(orientation);
            var ownSize  = this.size(orientation);
            var spaceDip = ownSize.dip - padding.sum(orientation);
            var part     = (max > min ? value / (max - min) : 1);
            barSize.dip  = spaceDip * part;

            //set size in orientation opposite to bar growth orientation
            var oppositeOrientation = orientation.opposite();
            barSize = bar.size(oppositeOrientation);
            ownSize = this.size(oppositeOrientation);
            barSize.dip = ownSize.dip - padding.sum(oppositeOrientation);
        }
    }


    /**
     * Update `bar` position according to `padding` settings
     */
    private inline function __updateBarPosition () : Void
    {
        if (initialized) {
            var side = bar.selectedSide(Horizontal);
            bar.coordinate(side).dip = padding.side(side).dip;

            side = bar.selectedSide(Vertical);
            bar.coordinate(side).dip = padding.side(side).dip;
        }
    }


    /**
     * Called when `padding` settings changed
     */
    private function __paddingChanged (horizontalChanged:Bool, verticalChanged:Bool) : Void
    {
        __updateBar();
    }


    /**
     * Update `bar` on initialization
     */
    override private function __initializeSelf () : Void
    {
        super.__initializeSelf();
        __updateBar();
    }


    /**
     * Widget resized
     */
    private inline function __sizeChanged (me:Widget, changed:Size, previousUnits:Units, previousValue:Float) : Void
    {
        __updateBar();
    }


    /**
     * Getter `bar`
     */
    private function get_bar () : Widget
    {
        if (__bar == null) {
            var widget = new Widget();
            widget.style = null;

            __setBar(widget);
        }

        return __bar;
    }


    /**
     * Setter `bar`
     */
    private function set_bar (bar:Widget) : Widget
    {
        __setBar(bar);

        return bar;
    }


    /**
     * Setter `max`
     */
    private function set_max (val:Float) : Float
    {
        max = val;
        if (max < min) max = min;
        if (value > max) {
            value = max;
        } else {
            __updateBar();
        }

        return val;
    }


    /**
     * Setter `max`
     */
    private function set_min (val:Float) : Float
    {
        min = val;
        if (min > max) min = max;
        if (value < min) {
            value = min;
        } else {
            __updateBar();
        }

        return val;
    }


    /**
     * Setter `value`
     */
    private function set_value (val:Float) : Float
    {
        var constrained = (val < min ? min : (val > max ? max : val));

        if (value != constrained) {
            value = constrained;
            __updateBar();
            __onChange.dispatch(this);
        }

        return val;
    }


    /**
     * Setter `orientation`
     */
    private function set_orientation (val:Orientation) : Orientation
    {
        if (orientation != val) {
            orientation = val;
            __updateBar();
        }

        return orientation = val;
    }


    /** Getters */
    private function get_padding ()     return __padding;

    /** Setters */
    private function set_padding (v)    return {__padding.copyValueFrom(v); return __padding;}

    /** Typical signal getters */
    private function get_onChange ()    return (__onChange == null ? __onChange = new Signal() : __onChange);



}//class Progress