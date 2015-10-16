package sx.widgets;

import sx.input.Pointer;
import sx.properties.abstracts.APadding;
import sx.properties.metric.Padding;
import sx.properties.metric.Size;
import sx.properties.metric.Units;
import sx.properties.Orientation;
import sx.signals.Signal;
import sx.tween.Actuator;
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

    /** Indicates if `value` can be changed by clicking on progress bar */
    public var interactive (default,set) : Bool = false;

    /** Dispatched when `value` is changed */
    public var onChange (get,never) : Signal<Progress->Void>;
    private var __onChange : Signal<Progress->Void>;

    /**
     * If `easing` is specified, then any change of `value` will be animated using `easing` function.
     * Otherwise `bar` width will be simply changed according to new `value`
     *
     * You can use functions from `sx.tween.easing` package.
     * Example: `progress.easing = sx.tween.Cubic.easeIn`
     */
    public var easing : Null<Float->Float>;
    /** Duration of an animation if `easing` is set (seconds). */
    private var easingDuration : Float = 0.3;

    /** handler of last started animation for `value` change */
    private var __barActuator : Actuator;
    /** Flag used to avoid recursive `__updateBar()` calls */
    private var __updatingBar : Bool = false;

    /** If `value` is automatically adjusted to pointer position on each pointer move signal */
    private var __isChangingValueAfterPointer : Bool = false;
    /** If progress bar is currently pressed and we are changing `value` according to pointer position */
    private var __currentTouchId : Int = 0;


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

            if (__barActuator != null) __barActuator.stop();
            if (easing == null || __isChangingValueAfterPointer) {
                barSize.dip  = spaceDip * part;
            } else {
                __barActuator = tween.tween(easingDuration, barSize.dip = spaceDip * part);
                __barActuator.ease(easing);
            }

            //set size in orientation opposite to bar growth orientation
            var oppositeOrientation = orientation.opposite();
            var barSize = bar.size(oppositeOrientation);
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
     * Add pointer signals listeners to be able to change `value` by clicking on progress bar
     */
    private inline function __setupInteractivity () : Void
    {
        onPointerPress.unique(__startChangingValueAfterPointer);
    }


    /**
     * User pressed this progress bar, and we are starting to change `value` according to pointer position.
     */
    private function __startChangingValueAfterPointer (me:Widget, dispatcher:Widget, touchId:Int) : Void
    {
        //already following pointer
        if (__isChangingValueAfterPointer) return;
        __currentTouchId = touchId;

        __changeValueToPointerPosition(this, touchId);
        __isChangingValueAfterPointer = true;

        Pointer.onMove.add(__changeValueToPointerPosition);
        Pointer.onNextRelease.add(__stopChangingValueAfterPointer);
    }


    /**
     * Change `value` according to current pointer position
     */
    private function __changeValueToPointerPosition (dispatcher:Widget, touchId:Int) : Void
    {
        if (__currentTouchId != touchId) return;

        var pos = globalToLocal(Pointer.getPosition());
        switch (orientation) {
            case Horizontal :
                var minPx = padding.left.px;
                var maxPx = width.px - padding.right.px;
                var part  = (
                    bar.left.selected
                        ? (pos.x - minPx) / (maxPx - minPx)
                        : (maxPx - pos.x) / (maxPx - minPx)
                );
                value = (max - min) * part;
            case Vertical   :
                var minPx = padding.top.px;
                var maxPx = height.px - padding.bottom.px;
                var part  = (
                    bar.top.selected
                        ? (pos.y - minPx) / (maxPx - minPx)
                        : (maxPx - pos.y) / (maxPx - minPx)
                );
                value = (max - min) * part;
        }
    }


    /**
     * Stop changing `value` after pointer position.
     */
    private function __stopChangingValueAfterPointer (dispatcher:Widget, touchId:Int) : Void
    {
        Pointer.onMove.remove(__changeValueToPointerPosition);
        __currentTouchId = 0;
        __isChangingValueAfterPointer = false;
    }


    /**
     * Remove pointer signals listeners
     */
    private inline function __disableInteractivity () : Void
    {
        onPointerPress.remove(__startChangingValueAfterPointer);
        if (__isChangingValueAfterPointer) {
            __stopChangingValueAfterPointer(this, __currentTouchId);
        }
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


    /**
     * Setter `interactive`
     */
    private function set_interactive (value:Bool) : Bool
    {
        if (interactive != value) {
            interactive = value;
            if (interactive) {
                __setupInteractivity();
            } else {
                __disableInteractivity();
            }
        }

        return value;
    }


    /** Getters */
    private function get_padding ()     return __padding;

    /** Setters */
    private function set_padding (v)    return {__padding.copyValueFrom(v); return __padding;}

    /** Typical signal getters */
    private function get_onChange ()    return (__onChange == null ? __onChange = new Signal() : __onChange);



}//class Progress