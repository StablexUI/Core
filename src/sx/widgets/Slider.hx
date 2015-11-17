package sx.widgets;

import sx.input.Pointer;
import sx.properties.Orientation;
import sx.signals.Signal;
import sx.tween.Actuator;
import sx.widgets.Widget;

using sx.tools.WidgetTools;
using sx.tools.SliderTools;
using sx.Sx;


/**
 * Slider widget
 *
 */
class Slider extends Widget
{

    /** Minimum value */
    public var min (default,set) : Float = 0;
    /** Maximum value */
    public var max (default,set) : Float = 100;
    /** Current value */
    public var value (default,set) : Float = 0;

    /**
     * Whether this is horizontal (default) or vertical slider.
     *
     * By default minimum value of horizontal slider is on the left end of a slider, and maximum - on the right end.
     * Use `slider.thumb.right.select()` or set right coordinate of a thumb to swap sides.
     *
     * By default minimum value of vertical slider is on the top end of a slider, and maximum - on the bottom end.
     * Use `slider.thumb.bottom.select()` or set bottom coordinate of a thumb to swap sides.
     */
    public var orientation (default,set) : Orientation = Horizontal;

    /** Widget used as slider's thumb */
    public var thumb (get,set) : Widget;
    private var __thumb : Widget;

    /**
     * If `easing` is specified, then any change of `value` will be animated using `easing` function.
     * Otherwise `thumb` position will be simply set according to new `value`
     *
     * You can use functions from `sx.tween.easing` package.
     * Example: `slider.easing = sx.tween.Cubic.easeIn`
     */
    public var easing : Null<Float->Float>;
    /** Duration of an animation if `easing` is set (seconds). */
    public var easingDuration : Float = 0.2;

    /** handler of last started animation for `value` change */
    private var __thumbActuator : Actuator;

    /** Dispatched when `value` is changed */
    public var onChange (get,never) : Signal<Slider->Void>;
    private var __onChange : Signal<Slider->Void>;

    /** If `value` is automatically adjusted to pointer position on each pointer move signal */
    private var __isChangingValueAfterPointer : Bool = false;
    /** If thumb is currently pressed and we are changing `value` according to pointer position */
    private var __currentTouchId : Int = 0;
    /** Distance between thumb position and pointer position, when user pressed thumb */
    private var __thumbPointerDx : Float = 0;
    /** Distance between thumb position and pointer position, when user pressed thumb */
    private var __thumbPointerDy : Float = 0;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();

        onPointerPress.unique(__sliderPressed);
    }


    /**
     * User pressed slider. Change `value` or start moving thumb after pointer.
     */
    private function __sliderPressed (me:Widget, dispatcher:Widget, touchId:Int) : Void
    {
        if (__isChangingValueAfterPointer) return;

        //need thumb to follow pointer
        if (thumb.contains(dispatcher)) {
            Pointer.stopCurrentSignal();
            __startChangingValueAfterPointer(touchId);
        } else {
            var shift = thumb.size(orientation).dip * 0.5;
            value = this.pointerPosToValue(-shift, -shift);
        }
    }


    /**
     * Change `thumb` widget
     */
    private inline function __setThumb (newThumb:Widget) : Void
    {
        if (__thumb != null) {
            removeChild(__thumb);
        }

        __thumb = newThumb;
        addChild(newThumb);

        __updateThumb();
    }


    /**
     * Update `thumb` according to current `value`
     */
    private function __updateThumb () : Void
    {
        if (initialized /* && !__isChangingValueAfterPointer */) {
            var thumbPos = thumb.selectedCoordinate(orientation);
            var pos = this.getValueCoordinateDip();

            if (__thumbActuator != null) __thumbActuator.stop();
            if (easing == null || __isChangingValueAfterPointer) {
                thumbPos.dip  = pos;
            } else {
                __thumbActuator = tween.tween(easingDuration, thumbPos.dip = pos);
                __thumbActuator.ease(easing);
            }
        }
    }


    /**
     * When user whant thumb to follow pointer position
     */
    private inline function __startChangingValueAfterPointer (touchId:Int) : Void
    {
        __isChangingValueAfterPointer = true;
        __currentTouchId = touchId;

        var pos = globalToLocal(Pointer.getPosition(touchId));
        __thumbPointerDx = thumb.left.dip - pos.x.toDip();
        __thumbPointerDy = thumb.top.dip - pos.y.toDip();

        Pointer.onMove.add(__changeValueToPointerPosition);
        Pointer.onNextRelease.add(__stopChangingValueAfterPointer);
    }


    /**
     * Change slider.value according to current pointer position
     */
    private function __changeValueToPointerPosition (dispatcher:Null<Widget>, touchId:Int) : Void
    {
        if (__currentTouchId != touchId) return;

        value = this.pointerPosToValue(__thumbPointerDx, __thumbPointerDy);
    }


    /**
     * Stop changing `value` after pointer position.
     */
    private function __stopChangingValueAfterPointer (dispatcher:Widget, touchId:Int) : Void
    {
        //wait till correct interaction finish.
        if (touchId != __currentTouchId) {
            Pointer.onNextRelease.add(__stopChangingValueAfterPointer);
            return;
        }

        Pointer.onMove.remove(__changeValueToPointerPosition);
        __currentTouchId = 0;
        __isChangingValueAfterPointer = false;
    }


    /**
     * Update `thumb` on initialization
     */
    override private function __initializeSelf () : Void
    {
        super.__initializeSelf();

        //don't animate on creation
        if (easing != null) {
            var fn = easing;
            easing = null;
            __updateThumb();
            easing = fn;
        } else {
            __updateThumb();
        }
    }


    /**
     * Getter `thumb`
     */
    private function get_thumb () : Widget
    {
        if (__thumb == null) {
            var widget = new Widget();
            widget.style = null;

            __setThumb(widget);
        }

        return __thumb;
    }


    /**
     * Setter `thumb`
     */
    private function set_thumb (thumb:Widget) : Widget
    {
        __setThumb(thumb);

        return thumb;
    }


    /**
     * Setter `max`
     */
    private function set_max (val:Float) : Float
    {
        if (max != val) {
            max = val;
            if (max < min) max = min;
            if (value > max) {
                value = max;
            } else {
                __updateThumb();
            }
        }

        return val;
    }


    /**
     * Setter `max`
     */
    private function set_min (val:Float) : Float
    {
        if (min != val) {
            min = val;
            if (min > max) min = max;
            if (value < min) {
                value = min;
            } else {
                __updateThumb();
            }
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
            __updateThumb();
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
            __updateThumb();
        }

        return orientation = val;
    }


    /** Typical signal getters */
    private function get_onChange ()    return (__onChange == null ? __onChange = new Signal() : __onChange);

}//class Slider