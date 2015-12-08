package sx.widgtes;

import sx.properties.abstracts.ASize;
import sx.properties.metric.Size;
import sx.properties.metric.Units;
import sx.properties.Side;
import sx.signals.Signal;
import sx.signals.CalloutSignal;
import sx.widgets.base.Floating;
import sx.tween.Actuator;
import sx.widgets.Widget;


/**
 * Callout is a tooltip-like widget and usually appears somewhere near a widget, which user is currently interacting with.
 *
 */
class Callout extends Floating
{
    /**
     * List of sides where to show callout relative to target widget. Ordered by priority from the highest to the lowest.
     * By default: `[Top, Left, Right, Bottom]`.
     *
     * This means that by default callout will be shown on top of target widget. But if there is not enough space between
     * target widget and top stage border, then callout will be placed to the left of the target. And so on for `Right`
     * and `Bottom` sides. If there is no side where callout can fit between target widget and stage border, then callout
     * be shown on the side with highest priority, which is `Top` in this case.
     */
    public var sidePriority : Array<Side>;
    /**
     * Function which is called by callout to obtain an arrow widget which will be used to point at the target when
     * callout is shown at specified `Side` relative to target.
     */
    public var arrowFactory : Null<Callout->Side->Null<Widget>>;
    /** Widget which triggered this callout */
    public var currentTarget (default,null) : Null<Widget>;
    /**
     * Distance between callout and target widget.
     * Please note, that arrow size is not taken into account and `targetGap` describes distance between own
     * callout border and a border of target widget.
     */
    public var targetGap (get,set) : ASize;
    private var __targetGap : Size;
    /**
     * Callback which implements callout reveal animation when callout is shown.
     * If this property is set, then `onShow` signal will be dispatched after appearance animation is finished.
     * E.g. fade in effect may look like this:
     * ```
     * callout.showEffect = function (c) {
     *      c.alpha = 0;
     *      var actuator = p.tween.linear(1, c.alpha = 1);
     *      return actuator;
     * }
     * ```
     */
    public var showEffect : Null<Callout->Actuator>;
    /**
     * Callback which implements callout dissapeearance animation when callout is closed.
     * If this property is set, then `onClose` signal will be dispatched after disappearance animation is finished.
     */
    public var closeEffect : Null<Callout->Actuator>;
    /** Dispatched when callout is shown */
    public var onShow (get,never) : CalloutSignal;
    private var __onShow : CalloutSignal = null;
    /** Dispatched when callout is closed */
    public var onClose (get,never) : CalloutSignal;
    private var __onClose : CalloutSignal = null;

    /** If we need to update callout position */
    private var __positionUpdateRequired : Bool = false;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();
        sidePriority = [Top, Left, Right, Bottom];
        __targetGap = new Size();
        __targetGap.onChange.add(__targetGapChanged);
    }


    /**
     * Show callout near specified `target`.
     *
     * If callout does not have a parent, then `visible` will be set to `true` and callout will be added to `Sx.root` display list.
     * If callout has a parent, then this method just switches `visible` to `true` and moves callout to the top of parents display list.
     */
    public function show (target:Widget) : Void
    {
        currentTarget = target;
        // if (shown) {
        //     close();
        // }

        __show();
    }


    /**
     * Close callout.
     *
     * If callout is attached to `Sx.root` then callout is `Sx.root.removeChild(callout)` is called and `visible` changed to `false`.
     * If callout is attached to another widget (except `Sx.root`) then this method just switches `visible` to `false`.
     */
    public function close () : Void
    {
        __close();
    }


    /**
     * Calls `show()` if callout is hidden or `close()` if callout is shown.
     */
    public function toggle () : Void
    {
        if (shown) {
            close();
        } else {
            show();
        }
    }


    /**
     * Override in descendants to animate widget appearance
     */
    override private function __showEffect () : Null<Actuator>
    {
        return (showEffect == null ? null : showEffect(this));
    }


    /**
     * Override in descendants to animate widget disappearance
     */
    override private function __closeEffect () : Null<Actuator>
    {
        return (closeEffect == null ? null : closeEffect(this));
    }


    /**
     * Override in descendants to dispatch `onShow` signals
     */
    override private function __shown () : Void
    {
        if (__positionUpdateRequired) {
            __updatePosition();
        }

        __onShow.dispatch(this);
    }


    /**
     * Override in descendants to dispatch `onClose` signals
     */
    override private function __closed () : Void
    {
        currentTarget = null;
        __positionUpdateRequired = false;
        __onClose.dispatch(this);
    }


    /**
     * Update callout position if callout is currently shown
     */
    private function __updatePosition () : Void
    {
        if (!shown) {
            return;
        }

        if (__appearanceActuator != null) {
            __positionUpdateRequired = true;
            return;
        }
        __positionUpdateRequired = false;

        //TODO: perform some actions
    }


    /**
     * Update position if `targetGap` changed
     */
    private function __targetGapChanged (gap:Size, previousUnits:Units, previousValue:Float) : Void
    {
        __updatePosition();
    }


    /** Getters */
    private function get_targetGap ()       return __targetGap;

    /** Setters */
    private function set_targetGap (v)       return __targetGap.copyValueFrom(v);

    /** Typical signal getters */
    private function get_onShow ()        return (__onShow == null ? __onShow = new Signal() : __onShow);
    private function get_onClose ()       return (__onClose == null ? __onClose = new Signal() : __onClose);

}//class Callout